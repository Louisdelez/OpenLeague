//! Optional LOCAL current R samples and owner-only passive HUD values.
//! OLSR current XYZ is a separate bounded presentation, never launch/history reconstruction.
use std::collections::{BTreeMap, BTreeSet};
use openleague_core::{Point, Snapshot};

const MAX_R: usize = 64;
const MAX_ROSTER: usize = 64;
const FRESH_SECONDS: f64 = 0.2; // Explicit local freshness, not native spell TTL.

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) struct Key { pub session: u64, pub owner: u32, pub team: u8, pub ordinal: u64 }
#[derive(Debug, Clone, Copy, PartialEq)]
pub(crate) struct CurrentR {
    pub key: Key, pub incarnation: u64, pub position: Point, pub direction: Point,
}
/// Complete position from one accepted OLSR frame. Its stamp is retained with
/// XYZ during pause; it is not a cast/release tick or a reconstructed history.
#[derive(Debug, Clone, Copy, PartialEq)]
pub(crate) struct CurrentR3d {
    pub key: Key, pub incarnation: u64, pub position: Point, pub y_native: f32,
    pub direction: Point, pub sample_tick: u64, pub frame_ordinal: u64,
}
#[derive(Debug, Clone, Copy, PartialEq)]
struct HeightFact { position: Point, direction: Point, y_native: f32 }
#[derive(Debug, Clone, Copy)]
struct Record { current: CurrentR }
#[derive(Debug, Default)]
pub(crate) struct State {
    session: Option<u64>, viewer: Option<u32>, epoch: Option<u64>, viewer_team: Option<u8>,
    last_tick: Option<u64>, last_now: Option<f64>, ended: bool,
    next_incarnation: u64, records: BTreeMap<Key, Record>, r_at: Option<f64>,
    last_r_rows: Option<BTreeMap<Key, openleague_core::ezreal_r::VisibleMissile>>,
    next_3d_incarnation: u64, records_3d: BTreeMap<Key, CurrentR3d>, r_3d_at: Option<f64>,
    last_3d_rows: Option<BTreeMap<Key, HeightFact>>, last_3d_frame: Option<u64>,
    passive_count: Option<u8>, passive_at: Option<f64>,
}
impl State {
    fn clear(&mut self) {
        self.records.clear(); self.r_at = None;
        self.clear_3d();
        self.passive_count = None; self.passive_at = None;
    }
    fn clear_3d(&mut self) { self.records_3d.clear(); self.r_3d_at = None; }
    pub(crate) fn reset_session(&mut self, session: u64, viewer: u32) {
        let next_incarnation = self.next_incarnation;
        let next_3d_incarnation = self.next_3d_incarnation;
        *self = Self { session: Some(session), viewer: Some(viewer), next_incarnation, next_3d_incarnation, ..Self::default() };
    }
    pub(crate) fn begin_epoch(&mut self, epoch: Option<u64>) {
        self.clear(); self.last_r_rows = None; self.epoch = epoch; self.last_tick = None; self.last_now = None; self.ended = false;
        self.last_3d_rows = None; self.last_3d_frame = None;
    }
    fn audience(snapshot: &Snapshot, viewer: u32) -> Result<u8, &'static str> {
        if snapshot.roster.len() > MAX_ROSTER { return Err("presentation roster exceeds bound"); }
        let mut ids = BTreeSet::new();
        for p in &snapshot.roster {
            if p.team > 1 || !ids.insert(p.id) { return Err("presentation roster identity invalid"); }
        }
        snapshot.roster.iter().find(|p| p.id == viewer).map(|p| p.team).ok_or("presentation viewer absent")
    }
    fn passive_value(snapshot: &Snapshot, viewer: u32) -> Result<Option<u8>, &'static str> {
        let Some(value) = snapshot.ezreal_passive_self else { return Ok(None); };
        if value.session != snapshot.session || value.owner != viewer || value.stacks > 5 {
            return Err("owner passive DTO identity/count invalid");
        }
        let mut players = snapshot.players.iter().filter(|p| p.id == viewer);
        let p = players.next().ok_or("owner passive player absent")?;
        if players.next().is_some() || p.champion != "ezreal" || p.team > 1
            || !p.health.is_finite() || p.health <= 0.
            || !snapshot.roster.iter().any(|r| r.id == viewer && r.champion == p.champion && r.team == p.team) {
            return Err("owner passive current player invalid");
        }
        Ok(Some(value.stacks))
    }
    fn observe_r(&mut self, snapshot: &Snapshot, now: f64, paused: bool, new_tick: bool) -> Result<(), &'static str> {
        if snapshot.ezreal_r_projectiles.len() > MAX_R { return Err("R projection exceeds bound"); }
        let mut incoming = BTreeMap::new();
        for row in &snapshot.ezreal_r_projectiles {
            if row.session != snapshot.session || row.team > 1 || row.ordinal == 0
                || !row.position.finite() || !row.direction.finite()
                || (row.direction.x.hypot(row.direction.z) - 1.).abs() > 0.0001
                || !snapshot.roster.iter().any(|p| p.id == row.owner && p.champion == "ezreal" && p.team == row.team) {
                return Err("R projection current sample invalid");
            }
            let key = Key { session: row.session, owner: row.owner, team: row.team, ordinal: row.ordinal };
            if incoming.insert(key, *row).is_some() { return Err("R projection duplicate identity"); }
        }
        // Retain last accepted facts independently from visual retirement, so
        // an unchanged same-tick duplicate cannot revive an expired pool.
        let changed = self.last_r_rows.as_ref() != Some(&incoming);
        for (key,row) in &incoming {
            if self.last_r_rows.as_ref().and_then(|rows| rows.get(key))
                .is_some_and(|old| old.direction != row.direction) { return Err("R immutable direction changed"); }
        }
        if !new_tick && !changed && self.records.is_empty() { return Ok(()); }
        self.last_r_rows = Some(incoming.clone());
        // No actor Entity/health/height lookup. Current point was authorized by
        // the server; hidden caster is deliberately valid for this R channel.
        self.records.retain(|key,_| incoming.contains_key(key));
        for (key,row) in incoming {
            if let Some(record) = self.records.get_mut(&key) {
                if !paused { record.current.position = row.position; }
            } else {
                self.next_incarnation = self.next_incarnation.checked_add(1).ok_or("R incarnation exhausted")?;
                self.records.insert(key,Record { current: CurrentR { key, incarnation: self.next_incarnation,
                    position: row.position, direction: row.direction } });
            }
        }
        if new_tick || changed { self.r_at = Some(now); }
        Ok(())
    }
    fn height_facts(snapshot: &Snapshot) -> Result<BTreeMap<Key, HeightFact>, &'static str> {
        let mut facts = BTreeMap::new();
        let Some(raw) = &snapshot.ezreal_r_current_heights else { return Ok(facts); };
        let object = raw.as_object().ok_or("R height object invalid")?;
        if object.len() != 2 || object.get("policy").and_then(|v| v.as_str())
            != Some(openleague_core::ezreal_r::CURRENT_HEIGHT_POLICY) { return Err("R height policy invalid"); }
        let rows = object.get("rows").and_then(|v| v.as_array()).ok_or("R height rows invalid")?;
        if rows.len() > MAX_R { return Err("R height rows exceed bound"); }
        for raw in rows {
            let row = raw.as_object().ok_or("R height row invalid")?;
            if row.len() != 4 { return Err("R height row schema invalid"); }
            let owner = row.get("owner").and_then(|v| v.as_u64()).and_then(|v| u32::try_from(v).ok())
                .ok_or("R height owner invalid")?;
            let team = row.get("team").and_then(|v| v.as_u64()).and_then(|v| u8::try_from(v).ok())
                .filter(|v| *v <= 1).ok_or("R height team invalid")?;
            let ordinal = row.get("ordinal").and_then(|v| v.as_u64()).filter(|v| *v != 0)
                .ok_or("R height ordinal invalid")?;
            let y = row.get("y_native").and_then(|v| v.as_f64()).ok_or("R current height is not a number")?;
            let y_native = y as f32;
            if !y.is_finite() || !y_native.is_finite() { return Err("R current height nonfinite"); }
            let key = Key { session: snapshot.session, owner, team, ordinal };
            let mut matching = snapshot.ezreal_r_projectiles.iter().filter(|r| r.session == key.session
                && r.owner == owner && r.team == team && r.ordinal == ordinal);
            let current = matching.next().ok_or("R height has no authorized current XZ")?;
            if matching.next().is_some() || facts.insert(key, HeightFact {
                position: current.position, direction: current.direction, y_native,
            }).is_some() { return Err("R height duplicate identity"); }
        }
        Ok(facts)
    }
    fn observe_3d(&mut self, snapshot: &Snapshot, viewer: u32, now: f64, paused: bool, new_tick: bool,
        delivery: Option<(openleague_core::session_transport::Context, u64)>, base_r_valid: bool) -> Result<(), &'static str> {
        let Some((context, frame)) = delivery else {
            self.clear_3d(); self.last_3d_rows = None; return Ok(());
        };
        if !context.valid() || context.session != snapshot.session || context.player != viewer
            || self.epoch != Some(context.epoch) || frame == 0
            || self.last_3d_frame.is_some_and(|old| frame <= old) {
            return Err("R height needs a fresh matching OLSR frame");
        }
        // Consume the frame before optional parsing: a malformed same-frame
        // replacement cannot revive a discarded height channel.
        self.last_3d_frame = Some(frame);
        if !base_r_valid { return Err("R height requires valid authorized XZ facts"); }
        let incoming = Self::height_facts(snapshot)?;
        let changed = self.last_3d_rows.as_ref() != Some(&incoming);
        if self.r_3d_at.is_some() && !Self::fresh(self.r_3d_at, now) { self.clear_3d(); }
        if !new_tick && !changed && self.records_3d.is_empty() { return Ok(()); }
        self.last_3d_rows = Some(incoming.clone());
        self.records_3d.retain(|key, _| incoming.contains_key(key));
        for (key, fact) in incoming {
            if let Some(record) = self.records_3d.get_mut(&key) {
                if !paused {
                    // Update every coordinate and the originating frame together.
                    record.position = fact.position; record.y_native = fact.y_native;
                    record.direction = fact.direction; record.sample_tick = snapshot.tick;
                    record.frame_ordinal = frame;
                }
            } else {
                self.next_3d_incarnation = self.next_3d_incarnation.checked_add(1).ok_or("R 3D incarnation exhausted")?;
                self.records_3d.insert(key, CurrentR3d { key, incarnation: self.next_3d_incarnation,
                    position: fact.position, y_native: fact.y_native, direction: fact.direction,
                    sample_tick: snapshot.tick, frame_ordinal: frame });
            }
        }
        if new_tick || changed { self.r_3d_at = Some(now); }
        Ok(())
    }
    /// Called only after the existing network/session/bootstrap/clock gates.
    /// Optional failures retire their own channel and never reject a Snapshot.
    pub(crate) fn observe_accepted(&mut self, snapshot: &Snapshot, viewer: u32,
        now: f64, paused: bool, healthy: bool) -> Result<(), &'static str> {
        self.observe_accepted_frame(snapshot, viewer, now, paused, healthy, None)
    }
    pub(crate) fn observe_accepted_frame(&mut self, snapshot: &Snapshot, viewer: u32,
        now: f64, paused: bool, healthy: bool,
        delivery: Option<(openleague_core::session_transport::Context, u64)>) -> Result<(), &'static str> {
        if self.session != Some(snapshot.session) || self.viewer != Some(viewer)
            || self.last_tick.is_some_and(|tick| snapshot.tick < tick)
            || !healthy || !now.is_finite() || now < 0. || self.last_now.is_some_and(|old| now < old) {
            self.clear(); return Err("R/passive presentation boundary unavailable");
        }
        let team = match Self::audience(snapshot,viewer) {
            Ok(team) => team, Err(e) => { self.clear(); return Err(e); },
        };
        if self.viewer_team != Some(team) {
            self.clear(); self.last_r_rows = None; self.last_3d_rows = None; self.viewer_team = Some(team);
        }
        if snapshot.winner.is_some() || self.ended {
            self.clear(); self.ended = true; self.last_tick = Some(snapshot.tick); self.last_now = Some(now); return Ok(());
        }
        let new_tick = self.last_tick != Some(snapshot.tick);
        // A locally expired presentation is retired, not merely hidden. A
        // later current sample must never revive the previous pool incarnation.
        if self.r_at.is_some() && !Self::fresh(self.r_at,now) { self.records.clear(); self.r_at = None; }
        let r_error = self.observe_r(snapshot,now,paused,new_tick).err();
        let height_error = self.observe_3d(snapshot, viewer, now, paused, new_tick, delivery, r_error.is_none()).err();
        if r_error.is_some() { self.records.clear(); self.r_at = None; self.last_r_rows = None; }
        if r_error.is_some() || height_error.is_some() {
            self.clear_3d(); self.last_3d_rows = None;
        }
        let passive_error = match Self::passive_value(snapshot,viewer) {
            Ok(count) => {
                if new_tick || count != self.passive_count { self.passive_at = Some(now); }
                self.passive_count = count; None
            },
            Err(e) => { self.passive_count = None; self.passive_at = None; Some(e) },
        };
        self.last_tick = Some(snapshot.tick); self.last_now = Some(now);
        if let Some(e) = r_error.or(height_error).or(passive_error) { Err(e) } else { Ok(()) }
    }
    fn boundary(&self, snapshot: &Snapshot, viewer: u32, session: u64, epoch: Option<u64>, now: f64, healthy: bool) -> bool {
        healthy && now.is_finite() && now >= 0. && !self.ended && snapshot.winner.is_none()
            && self.session == Some(session) && snapshot.session == session && self.viewer == Some(viewer)
            && self.epoch == epoch && self.last_tick == Some(snapshot.tick)
            && Self::audience(snapshot,viewer).ok() == self.viewer_team
            && self.last_now.is_some_and(|old| now >= old)
    }
    fn fresh(at: Option<f64>, now: f64) -> bool {
        at.is_some_and(|at| now >= at && now - at <= FRESH_SECONDS)
    }
    pub(crate) fn passive(&self, snapshot: &Snapshot, viewer: u32, session: u64, epoch: Option<u64>, now: f64, healthy: bool) -> Option<u8> {
        if !self.boundary(snapshot,viewer,session,epoch,now,healthy) || !Self::fresh(self.passive_at,now) { return None; }
        let current = Self::passive_value(snapshot,viewer).ok().flatten();
        if current == self.passive_count { current } else { None }
    }
    /// Read-only preparation for a later separately reviewed renderer. This
    /// group does not draw a quad or fabricate a launch/impact event.
    pub(crate) fn r_samples(&self, snapshot: &Snapshot, viewer: u32, session: u64, epoch: Option<u64>, now: f64, healthy: bool) -> Vec<CurrentR> {
        if !self.boundary(snapshot,viewer,session,epoch,now,healthy) || !Self::fresh(self.r_at,now) { return Vec::new(); }
        self.records.values().map(|r| r.current).collect()
    }
    pub(crate) fn r_samples_3d(&self, snapshot: &Snapshot, viewer: u32, session: u64, epoch: Option<u64>, now: f64, healthy: bool) -> Vec<CurrentR3d> {
        if epoch.is_none() || !self.boundary(snapshot, viewer, session, epoch, now, healthy)
            || !Self::fresh(self.r_3d_at, now) { return Vec::new(); }
        self.records_3d.values().copied().collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn snapshot() -> (Snapshot,u32,u32) {
        let mut bytes = Vec::new();for _ in 0..6400 { bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1); }
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
        let mut sim=openleague_core::Simulation::new(nav).unwrap();let owner=sim.join("ezreal").unwrap();let viewer=sim.join("garen").unwrap();
        sim.players.get_mut(&owner).unwrap().team=0;sim.players.get_mut(&viewer).unwrap().team=1;
        let mut snapshot=sim.snapshot();snapshot.ezreal_r_projectiles.push(openleague_core::ezreal_r::VisibleMissile {
            session:snapshot.session,owner,team:0,ordinal:u32::MAX as u64+9,
            position:Point{x:1000.,z:500.},direction:Point{x:1.,z:0.},
        });(snapshot,owner,viewer)
    }
    fn state(snapshot:&Snapshot,viewer:u32)->State {let mut s=State::default();s.reset_session(snapshot.session,viewer);s.begin_epoch(Some(7));s}
    fn samples(s:&State,snapshot:&Snapshot,viewer:u32,now:f64)->Vec<CurrentR> {s.r_samples(snapshot,viewer,snapshot.session,Some(7),now,true)}

    #[test]
    fn accepted_current_r_works_with_hidden_caster_without_extrapolation_or_launch_history() {
        let(mut snapshot,owner,viewer)=snapshot();snapshot.players.retain(|p|p.id!=owner);
        let mut s=state(&snapshot,viewer);let before=serde_json::to_value(&snapshot).unwrap();
        s.observe_accepted(&snapshot,viewer,5.,false,true).unwrap();
        let first=samples(&s,&snapshot,viewer,5.1);assert_eq!(first.len(),1);
        assert_eq!(first[0].position,snapshot.ezreal_r_projectiles[0].position);
        assert_eq!(samples(&s,&snapshot,viewer,5.15)[0].position,first[0].position);
        snapshot.tick+=1;snapshot.ezreal_r_projectiles[0].position.x+=400.;
        s.observe_accepted(&snapshot,viewer,5.16,false,true).unwrap();
        assert_eq!(samples(&s,&snapshot,viewer,5.16)[0].position,snapshot.ezreal_r_projectiles[0].position);
        assert_eq!(samples(&s,&snapshot,viewer,5.16)[0].incarnation,first[0].incarnation);
        assert_ne!(serde_json::to_value(&snapshot).unwrap(),before);
        assert!(samples(&s,&snapshot,viewer,5.37).is_empty());
    }

    #[test]
    fn same_batch_absence_reveal_retires_incarnation_and_duplicates_do_not_refresh_stale_state() {
        let(mut snapshot,_,viewer)=snapshot();let mut s=state(&snapshot,viewer);
        s.observe_accepted(&snapshot,viewer,1.,false,true).unwrap();let first=samples(&s,&snapshot,viewer,1.)[0];
        s.observe_accepted(&snapshot,viewer,1.15,false,true).unwrap();
        assert_eq!(samples(&s,&snapshot,viewer,1.16)[0].incarnation,first.incarnation);
        assert!(samples(&s,&snapshot,viewer,1.21).is_empty());
        s.observe_accepted(&snapshot,viewer,1.22,false,true).unwrap();
        assert!(samples(&s,&snapshot,viewer,1.22).is_empty());assert!(s.records.is_empty());
        snapshot.tick+=1;s.observe_accepted(&snapshot,viewer,1.22,false,true).unwrap();
        let recovered=samples(&s,&snapshot,viewer,1.22)[0];assert!(recovered.incarnation>first.incarnation);
        let row=snapshot.ezreal_r_projectiles[0];snapshot.tick+=1;snapshot.ezreal_r_projectiles.clear();
        s.observe_accepted(&snapshot,viewer,1.22,false,true).unwrap();assert!(s.records.is_empty());
        snapshot.tick+=1;snapshot.ezreal_r_projectiles.push(row);
        s.observe_accepted(&snapshot,viewer,1.22,false,true).unwrap();
        assert!(samples(&s,&snapshot,viewer,1.22)[0].incarnation>recovered.incarnation);
    }

    #[test]
    fn pause_freezes_pose_while_authoritative_absence_epoch_clock_and_departure_still_retire() {
        let(mut snapshot,owner,viewer)=snapshot();let mut s=state(&snapshot,viewer);
        s.observe_accepted(&snapshot,viewer,2.,false,true).unwrap();let first=samples(&s,&snapshot,viewer,2.)[0];
        snapshot.tick+=1;snapshot.ezreal_r_projectiles[0].position.x+=900.;
        s.observe_accepted(&snapshot,viewer,2.,true,true).unwrap();assert_eq!(samples(&s,&snapshot,viewer,2.)[0].position,first.position);
        snapshot.tick+=1;snapshot.ezreal_r_projectiles.clear();s.observe_accepted(&snapshot,viewer,2.,true,true).unwrap();assert!(s.records.is_empty());
        let(mut snapshot,_,viewer)=self::snapshot();s.reset_session(snapshot.session,viewer);s.begin_epoch(Some(7));
        s.observe_accepted(&snapshot,viewer,2.,true,true).unwrap();assert_eq!(samples(&s,&snapshot,viewer,2.).len(),1);
        assert!(s.observe_accepted(&snapshot,viewer,2.,true,false).is_err());assert!(s.records.is_empty());
        s.observe_accepted(&snapshot,viewer,2.,false,true).unwrap();s.begin_epoch(Some(8));assert!(samples(&s,&snapshot,viewer,2.).is_empty());
        s.begin_epoch(Some(7));s.observe_accepted(&snapshot,viewer,2.,false,true).unwrap();
        let previous=samples(&s,&snapshot,viewer,2.)[0].incarnation;
        snapshot.tick+=1;snapshot.roster.iter_mut().find(|p|p.id==viewer).unwrap().team=0;
        snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().team=0;
        s.observe_accepted(&snapshot,viewer,2.,false,true).unwrap();
        assert!(samples(&s,&snapshot,viewer,2.)[0].incarnation>previous);
        snapshot.tick+=1;snapshot.roster.retain(|p|p.id!=owner);assert!(s.observe_accepted(&snapshot,viewer,2.01,false,true).is_err());assert!(s.records.is_empty());
    }

    #[test]
    fn owner_count_hides_on_zero_missing_death_identity_end_and_never_predicts_expiry() {
        let(mut snapshot,owner,_)=snapshot();let mut s=state(&snapshot,owner);
        snapshot.ezreal_passive_self=Some(openleague_core::ezreal_passive::OwnerPassive{session:snapshot.session,owner,stacks:5});
        s.observe_accepted(&snapshot,owner,0.,false,true).unwrap();assert_eq!(s.passive(&snapshot,owner,snapshot.session,Some(7),0.1,true),Some(5));
        snapshot.tick+=1;snapshot.ezreal_passive_self.as_mut().unwrap().stacks=0;
        s.observe_accepted(&snapshot,owner,0.11,true,true).unwrap();assert_eq!(s.passive(&snapshot,owner,snapshot.session,Some(7),0.11,true),Some(0));
        snapshot.tick+=1;snapshot.ezreal_passive_self=None;s.observe_accepted(&snapshot,owner,0.12,false,true).unwrap();assert!(s.passive_count.is_none());
        snapshot.ezreal_passive_self=Some(openleague_core::ezreal_passive::OwnerPassive{session:snapshot.session,owner,stacks:5});
        snapshot.players.iter_mut().find(|p|p.id==owner).unwrap().health=0.;
        assert!(s.observe_accepted(&snapshot,owner,0.13,false,true).is_err());assert!(s.passive_count.is_none());
        snapshot.winner=Some(0);s.observe_accepted(&snapshot,owner,0.14,false,true).unwrap();assert!(s.ended);
        snapshot.winner=None;s.observe_accepted(&snapshot,owner,0.15,false,true).unwrap();assert!(s.records.is_empty()&&s.passive_count.is_none());
    }

    #[test]
    fn malformed_optional_channel_does_not_mutate_snapshot_or_disable_the_other_channel() {
        let(mut snapshot,owner,_)=snapshot();let mut s=state(&snapshot,owner);
        snapshot.ezreal_passive_self=Some(openleague_core::ezreal_passive::OwnerPassive{session:snapshot.session,owner,stacks:3});
        snapshot.ezreal_r_projectiles[0].direction=Point{x:0.,z:0.};let before=serde_json::to_value(&snapshot).unwrap();
        assert!(s.observe_accepted(&snapshot,owner,0.,false,true).is_err());assert!(s.records.is_empty());
        assert_eq!(s.passive(&snapshot,owner,snapshot.session,Some(7),0.,true),Some(3));assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        snapshot.tick+=1;snapshot.ezreal_r_projectiles[0].direction=Point{x:1.,z:0.};snapshot.ezreal_passive_self.as_mut().unwrap().stacks=6;
        assert!(s.observe_accepted(&snapshot,owner,0.01,false,true).is_err());assert_eq!(samples(&s,&snapshot,owner,0.01).len(),1);assert!(s.passive_count.is_none());
        assert!(s.observe_accepted(&snapshot,owner,0.009,false,true).is_err());assert!(s.records.is_empty()&&s.passive_count.is_none());
    }
}

#[cfg(test)]
mod height_tests {
    use super::*;
    use openleague_core::session_transport::Context;
    fn fixture() -> (Snapshot, u32, u32) {
        let mut bytes = Vec::new();
        for _ in 0..6400 { bytes.extend(0f32.to_le_bytes()); bytes.extend([0u8;6]); bytes.push(1); }
        let nav = openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#, &bytes).unwrap();
        let mut sim = openleague_core::Simulation::new(nav).unwrap();
        sim.session = u64::MAX - 7;
        let owner = sim.join("ezreal").unwrap(); let viewer = sim.join("garen").unwrap();
        sim.players.get_mut(&owner).unwrap().team = 0; sim.players.get_mut(&viewer).unwrap().team = 1;
        let mut snapshot = sim.snapshot(); snapshot.tick = 10;
        snapshot.ezreal_r_projectiles.push(openleague_core::ezreal_r::VisibleMissile {
            session: snapshot.session, owner, team: 0, ordinal: u64::MAX - 3,
            position: Point { x:1000., z:500. }, direction: Point { x:1., z:0. },
        });
        height(&mut snapshot, 120.); (snapshot, owner, viewer)
    }
    fn height(snapshot: &mut Snapshot, y: f32) {
        snapshot.ezreal_r_current_heights = Some(serde_json::json!({
            "policy":openleague_core::ezreal_r::CURRENT_HEIGHT_POLICY,
            "rows":snapshot.ezreal_r_projectiles.iter().map(|r| serde_json::json!({
                "owner":r.owner,"team":r.team,"ordinal":r.ordinal,"y_native":y,
            })).collect::<Vec<_>>(),
        }));
    }
    fn context(snapshot: &Snapshot, viewer: u32) -> Context { Context { session:snapshot.session, player:viewer, epoch:7 } }
    fn state(snapshot: &Snapshot, viewer: u32) -> State {
        let mut s = State::default(); s.reset_session(snapshot.session,viewer); s.begin_epoch(Some(7)); s
    }
    fn observe(s:&mut State,snapshot:&Snapshot,viewer:u32,frame:u64,now:f64,paused:bool)->Result<(),&'static str> {
        s.observe_accepted_frame(snapshot,viewer,now,paused,true,Some((context(snapshot,viewer),frame)))
    }
    fn samples(s:&State,snapshot:&Snapshot,viewer:u32,now:f64)->Vec<CurrentR3d> {
        s.r_samples_3d(snapshot,viewer,snapshot.session,Some(7),now,true)
    }
    #[test]
    fn hidden_caster_xyz_is_one_current_frame_without_extrapolation_or_snapshot_mutation() {
        let (mut snapshot,owner,viewer)=fixture();snapshot.players.retain(|p|p.id!=owner);
        let mut s=state(&snapshot,viewer);let before=serde_json::to_value(&snapshot).unwrap();
        observe(&mut s,&snapshot,viewer,1,5.,false).unwrap();
        assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        let first=samples(&s,&snapshot,viewer,5.1)[0];
        assert_eq!((first.position,first.y_native,first.sample_tick,first.frame_ordinal),
            (snapshot.ezreal_r_projectiles[0].position,120.,10,1));
        assert_eq!(first.key.ordinal,u64::MAX-3);assert_eq!(first.key.session,u64::MAX-7);
        snapshot.tick=11;snapshot.ezreal_r_projectiles[0].position=Point{x:1300.,z:700.};height(&mut snapshot,88.);
        observe(&mut s,&snapshot,viewer,2,5.05,false).unwrap();let next=samples(&s,&snapshot,viewer,5.15)[0];
        assert_eq!((next.position,next.y_native,next.sample_tick,next.frame_ordinal),(Point{x:1300.,z:700.},88.,11,2));
        assert_eq!(next.incarnation,first.incarnation);assert!(samples(&s,&snapshot,viewer,5.26).is_empty());
    }
    #[test]
    fn missing_and_invalid_height_retire_then_reveal_with_new_three_d_incarnation() {
        let(mut snapshot,_,viewer)=fixture();let mut s=state(&snapshot,viewer);
        observe(&mut s,&snapshot,viewer,1,1.,false).unwrap();let first=samples(&s,&snapshot,viewer,1.)[0];
        snapshot.ezreal_r_current_heights=None;observe(&mut s,&snapshot,viewer,2,1.,false).unwrap();
        assert!(samples(&s,&snapshot,viewer,1.).is_empty());assert_eq!(s.records.len(),1);
        height(&mut snapshot,150.);observe(&mut s,&snapshot,viewer,3,1.,false).unwrap();
        let revealed=samples(&s,&snapshot,viewer,1.)[0];assert!(revealed.incarnation>first.incarnation);
        snapshot.ezreal_r_current_heights=Some(serde_json::json!("bad"));
        assert!(observe(&mut s,&snapshot,viewer,4,1.,false).is_err());assert!(s.records_3d.is_empty());assert_eq!(s.records.len(),1);
        height(&mut snapshot,160.);observe(&mut s,&snapshot,viewer,5,1.,false).unwrap();
        assert!(samples(&s,&snapshot,viewer,1.)[0].incarnation>revealed.incarnation);
    }
    #[test]
    fn pause_freezes_xyz_and_original_stamp_but_absence_still_retires_immediately() {
        let(mut snapshot,_,viewer)=fixture();let mut s=state(&snapshot,viewer);
        observe(&mut s,&snapshot,viewer,1,2.,false).unwrap();let first=samples(&s,&snapshot,viewer,2.)[0];
        snapshot.tick+=1;snapshot.ezreal_r_projectiles[0].position.x+=900.;height(&mut snapshot,-45.);
        observe(&mut s,&snapshot,viewer,2,2.,true).unwrap();assert_eq!(samples(&s,&snapshot,viewer,2.)[0],first);
        // Higher current authorization frame does not relabel provenance of the frozen position.
        observe(&mut s,&snapshot,viewer,3,2.,true).unwrap();assert_eq!(samples(&s,&snapshot,viewer,2.)[0],first);
        snapshot.ezreal_r_current_heights=None;observe(&mut s,&snapshot,viewer,4,2.,true).unwrap();assert!(s.records_3d.is_empty());
        height(&mut snapshot,-45.);observe(&mut s,&snapshot,viewer,5,2.,true).unwrap();let revealed=samples(&s,&snapshot,viewer,2.)[0];
        assert_eq!((revealed.position,revealed.y_native,revealed.sample_tick,revealed.frame_ordinal),
            (snapshot.ezreal_r_projectiles[0].position,-45.,snapshot.tick,5));assert!(revealed.incarnation>first.incarnation);
    }
    #[test]
    fn height_needs_olsr_context_and_frame_and_does_not_rearm_after_reset_or_end() {
        let(mut snapshot,_,viewer)=fixture();let mut s=state(&snapshot,viewer);
        s.observe_accepted(&snapshot,viewer,1.,false,true).unwrap();assert!(s.records_3d.is_empty());
        observe(&mut s,&snapshot,viewer,1,1.,false).unwrap();assert_eq!(s.records_3d.len(),1);
        for context in [Context{epoch:8,..context(&snapshot,viewer)},Context{player:viewer+1,..context(&snapshot,viewer)},
            Context{session:snapshot.session-1,..context(&snapshot,viewer)}] {
            assert!(s.observe_accepted_frame(&snapshot,viewer,1.,false,true,Some((context,2))).is_err());assert!(s.records_3d.is_empty());
        }
        observe(&mut s,&snapshot,viewer,2,1.,false).unwrap();
        assert!(observe(&mut s,&snapshot,viewer,2,1.,false).is_err());assert!(s.records_3d.is_empty());
        assert!(observe(&mut s,&snapshot,viewer,0,1.,false).is_err());
        observe(&mut s,&snapshot,viewer,3,1.,false).unwrap();let old=samples(&s,&snapshot,viewer,1.)[0].incarnation;
        s.begin_epoch(Some(8));assert!(s.r_samples_3d(&snapshot,viewer,snapshot.session,Some(8),1.,true).is_empty());
        s.reset_session(snapshot.session,viewer);s.begin_epoch(Some(7));observe(&mut s,&snapshot,viewer,1,1.,false).unwrap();
        assert!(samples(&s,&snapshot,viewer,1.)[0].incarnation>old);
        snapshot.winner=Some(0);observe(&mut s,&snapshot,viewer,2,1.,false).unwrap();snapshot.winner=None;
        observe(&mut s,&snapshot,viewer,3,1.,false).unwrap();assert!(s.records_3d.is_empty());
    }
    #[test]
    fn malformed_optional_height_leaves_ordinary_snapshot_and_owner_passive_available() {
        for case in 0..11 {
            let(mut snapshot,owner,_)=fixture();let viewer=owner;let mut s=state(&snapshot,viewer);
            snapshot.ezreal_passive_self=Some(openleague_core::ezreal_passive::OwnerPassive{session:snapshot.session,owner,stacks:3});
            observe(&mut s,&snapshot,viewer,1,0.,false).unwrap();
            let raw=snapshot.ezreal_r_current_heights.as_mut().unwrap();
            match case {
                0=>raw["policy"]=serde_json::json!("unknown"),
                1=>{let row=raw["rows"][0].clone();raw["rows"]=serde_json::json!(vec![row;65]);},
                2=>{let row=raw["rows"][0].clone();raw["rows"].as_array_mut().unwrap().push(row);},
                3=>raw["rows"][0]["owner"]=serde_json::json!(999999),
                4=>raw["rows"][0]["team"]=serde_json::json!(2),
                5=>raw["rows"][0]["ordinal"]=serde_json::json!(1.5),
                6=>raw["rows"][0]["owner"]=serde_json::json!(u64::MAX),
                7=>raw["rows"][0]["y_native"]=serde_json::json!(1e40),
                8=>raw["rows"][0]["y_native"]=serde_json::Value::Null,
                9=>raw["rows"][0]["y_native"]=serde_json::json!("12"),
                _=>raw["rows"][0]["origin"]=serde_json::json!([1,2,3]),
            }
            let before=serde_json::to_value(&snapshot).unwrap();
            assert!(observe(&mut s,&snapshot,viewer,2,0.01,false).is_err(),"case {case}");assert!(s.records_3d.is_empty());
            assert_eq!(s.records.len(),1);assert_eq!(s.passive(&snapshot,viewer,snapshot.session,Some(7),0.01,true),Some(3));
            assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        }
    }
    #[test]
    fn sixty_four_current_rows_keep_u64_keys_and_legitimate_zero_negative_y() {
        let(mut snapshot,_,viewer)=fixture();let original=snapshot.ezreal_r_projectiles[0];
        snapshot.ezreal_r_projectiles=(0..MAX_R).map(|i|openleague_core::ezreal_r::VisibleMissile {
            ordinal:(1u64<<53)+1+i as u64,..original }).collect();height(&mut snapshot,0.);
        for (i,row) in snapshot.ezreal_r_current_heights.as_mut().unwrap()["rows"].as_array_mut().unwrap().iter_mut().enumerate() {
            if i%2==1 {row["y_native"]=serde_json::json!(-5.5);}
        }
        let snapshot:Snapshot=serde_json::from_slice(&serde_json::to_vec(&snapshot).unwrap()).unwrap();
        let mut s=state(&snapshot,viewer);observe(&mut s,&snapshot,viewer,1,0.,false).unwrap();let rows=samples(&s,&snapshot,viewer,0.);
        assert_eq!(rows.len(),64);assert_eq!(rows[0].key.ordinal,(1u64<<53)+1);assert_eq!(rows[63].key.ordinal,(1u64<<53)+64);
        assert_eq!((rows[0].y_native,rows[1].y_native),(0.,-5.5));
    }
    #[test]
    fn height_only_change_refreshes_same_tick_but_unchanged_frames_cannot_revive_expiry() {
        let(mut snapshot,_,viewer)=fixture();let mut s=state(&snapshot,viewer);
        observe(&mut s,&snapshot,viewer,1,5.,false).unwrap();let first=samples(&s,&snapshot,viewer,5.)[0];
        height(&mut snapshot,125.);observe(&mut s,&snapshot,viewer,2,5.1,false).unwrap();
        let changed=samples(&s,&snapshot,viewer,5.25)[0];assert_eq!(changed.y_native,125.);assert_eq!(changed.incarnation,first.incarnation);
        observe(&mut s,&snapshot,viewer,3,5.29,false).unwrap();assert!(!samples(&s,&snapshot,viewer,5.29).is_empty());
        assert!(samples(&s,&snapshot,viewer,5.31).is_empty());observe(&mut s,&snapshot,viewer,4,5.32,false).unwrap();assert!(s.records_3d.is_empty());
        snapshot.tick+=1;observe(&mut s,&snapshot,viewer,5,5.33,false).unwrap();assert!(samples(&s,&snapshot,viewer,5.33)[0].incarnation>first.incarnation);
    }
    #[test]
    fn invalid_xz_consumes_its_frame_and_cannot_be_repaired_by_a_same_frame_replay() {
        let(mut snapshot,_,viewer)=fixture();let mut s=state(&snapshot,viewer);
        observe(&mut s,&snapshot,viewer,1,0.,false).unwrap();snapshot.ezreal_r_projectiles[0].direction=Point{x:0.,z:0.};
        assert!(observe(&mut s,&snapshot,viewer,2,0.01,false).is_err());assert!(s.records_3d.is_empty());
        snapshot.ezreal_r_projectiles[0].direction=Point{x:1.,z:0.};
        assert!(observe(&mut s,&snapshot,viewer,2,0.02,false).is_err());assert!(s.records_3d.is_empty());
        observe(&mut s,&snapshot,viewer,3,0.03,false).unwrap();assert_eq!(s.records_3d.len(),1);
    }
}
