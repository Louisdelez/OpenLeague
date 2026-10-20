//! Optional animation of received, body-visible Ezreal W Pending casts.
//! releases-8 is the existing LOCAL simulation policy, not a native clip clock.
//! Existing W is committed under later CC; this controller preserves that policy.
//! EffectClock supplies 1x age only; no native playback rate or gameplay change.
use openleague_core::{Snapshot, TICK_RATE, ezreal_w::{VisibleCast, WINDUP_TICKS}};
use std::collections::{BTreeMap, BTreeSet};

const MAX_OWNERS: usize = 64;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity {
    pub session: u64, pub epoch: u64, pub owner: u32, pub team: u8,
    pub ordinal: u64, pub releases: u64,
}
#[derive(Debug, Clone, Copy, PartialEq)]
struct Record {
    ordinal: u64, releases: u64, team: u8, direction: [u32; 2],
    age: f64, received_at: f64, claimed_by: Option<u64>, retired: bool,
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection { pub identity: Identity, pub age_seconds: f32, pub first: bool }

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    session: Option<u64>, epoch: u64, tick: Option<u64>, clock: Option<f64>,
    visible: BTreeSet<u32>, records: BTreeMap<u32, Record>,
    conflicts: BTreeSet<u32>, ready: bool, finished: bool,
}
impl State {
    pub fn reset(&mut self, session: u64) {
        if self.session != Some(session) { *self = Self { session: Some(session), ..Self::default() }; }
        else { self.suspend(); self.epoch = 0; self.tick = None; self.clock = None; self.visible.clear(); }
    }
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) {
        if epoch == 0 || (self.session == Some(session) && epoch <= self.epoch) { return; }
        if self.session != Some(session) { self.reset(session); }
        self.suspend(); self.epoch = epoch; self.tick = None; self.clock = None; self.visible.clear();
    }
    pub fn retire(&mut self, owner: u32) {
        if let Some(record) = self.records.get_mut(&owner) { record.retired = true; }
    }
    pub fn suspend(&mut self) {
        for record in self.records.values_mut() { record.retired = true; }
        self.ready = false; self.conflicts.clear();
    }
    /// Called after Q observation for EVERY accepted packet, before coalescing.
    /// A contradictory Q/W/R body consumes all affected cast channels before coalescing.
    pub fn observe_with_other_casts(&mut self, snapshot: &Snapshot, now: f64, ready: bool,
        paused: bool, q: &mut crate::ezreal_q_cast_animation::State,
        r: &mut crate::ezreal_r_cast_animation::State,
    ) -> Result<bool, String> {
        let accepted = self.observe_accepted(snapshot, now, ready, paused)?;
        if accepted { for owner in &self.conflicts { q.retire(*owner); r.retire(*owner); } }
        Ok(accepted)
    }
    /// Malformed optional rows cannot change gameplay. Retire this channel on
    /// rejection so invalidity followed by recovery in one batch never replays it.
    pub fn observe_accepted(&mut self, snapshot: &Snapshot, now: f64,
        clock_ready: bool, clock_paused: bool,
    ) -> Result<bool, String> {
        if self.session != Some(snapshot.session) || self.tick.is_some_and(|tick| snapshot.tick < tick) {
            return Ok(false);
        }
        if !now.is_finite() || self.clock.is_some_and(|old| now < old) {
            self.suspend(); return Err("Ezreal W presentation clock invalid".into());
        }
        let mut next = self.clone();
        match next.observe_inner(snapshot, now, clock_ready, clock_paused) {
            Ok(()) => { *self = next; Ok(true) }
            Err(error) => { self.suspend(); Err(error) }
        }
    }
    fn observe_inner(&mut self, snapshot: &Snapshot, now: f64,
        clock_ready: bool, clock_paused: bool,
    ) -> Result<(), String> {
        if snapshot.roster.len() > MAX_OWNERS || snapshot.players.len() > MAX_OWNERS
            || snapshot.ezreal_w_casts.len() > MAX_OWNERS || snapshot.ezreal_r_casts.len() > MAX_OWNERS {
            return Err("Ezreal W presentation owner budget exceeded".into());
        }
        let mut roster = BTreeMap::new();
        for entry in &snapshot.roster {
            if entry.id == 0 || entry.team > 1 || roster.insert(entry.id, (entry.team, entry.champion.as_str())).is_some() {
                return Err("Ezreal W presentation roster invalid".into());
            }
        }
        let mut visible = BTreeMap::new();
        let mut player_ids = BTreeSet::new();
        for actor in &snapshot.players {
            if !player_ids.insert(actor.id) { return Err("Ezreal W duplicate visible body".into()); }
            if actor.champion != "ezreal" { continue; }
            if !roster.get(&actor.id).is_some_and(|(team, name)| *name == "ezreal" && *team == actor.team) {
                return Err("Ezreal W visible owner invalid".into());
            }
            visible.insert(actor.id, actor);
        }
        let mut casts = BTreeMap::new();
        for cast in &snapshot.ezreal_w_casts {
            let starts = cast.releases.checked_sub(WINDUP_TICKS).ok_or("Ezreal W release precedes local windup")?;
            let length = f64::from(cast.direction.x).hypot(f64::from(cast.direction.z));
            if cast.session != snapshot.session || cast.owner == 0 || cast.team > 1 || cast.ordinal == 0
                || starts > snapshot.tick || !cast.direction.finite() || !(0.999..=1.001).contains(&length)
                || !visible.get(&cast.owner).is_some_and(|actor| actor.team == cast.team)
                || casts.insert(cast.owner, cast).is_some() {
                return Err("Ezreal W cast identity, body, geometry or time invalid".into());
            }
            if let Some(old) = self.records.get(&cast.owner) {
                if cast.ordinal < old.ordinal || cast.team != old.team
                    || (cast.ordinal == old.ordinal && (cast.releases != old.releases || bits(cast) != old.direction))
                    || (cast.ordinal > old.ordinal && cast.releases <= old.releases) {
                    return Err("Ezreal W cast identity changed or regressed".into());
                }
            }
        }
        let baseline = self.tick.is_none() || !self.ready;
        let previous_tick = self.tick;
        let previous_visible = self.visible.clone();
        self.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        self.conflicts.clear();
        // Only roster departure frees a consumed ordinal. FoW loss never does.
        self.records.retain(|owner, _| roster.get(owner).is_some_and(|(_, name)| *name == "ezreal"));
        for (&owner, cast) in &casts {
            let starts = cast.releases - WINDUP_TICKS;
            if self.records.get(&owner).is_none_or(|old| cast.ordinal > old.ordinal) {
                self.records.insert(owner, Record {
                    ordinal: cast.ordinal, releases: cast.releases, team: cast.team, direction: bits(cast),
                    age: snapshot.tick.saturating_sub(starts) as f64 / TICK_RATE as f64,
                    received_at: now, claimed_by: None,
                    retired: baseline || !previous_visible.contains(&owner) || !clock_ready || clock_paused
                        || self.finished || previous_tick.is_some_and(|tick| starts < tick),
                });
            }
        }
        for (&owner, record) in &mut self.records {
            let Some(actor) = visible.get(&owner) else { record.retired = true; continue; };
            let Some(cast) = casts.get(&owner).filter(|cast| cast.ordinal == record.ordinal) else {
                record.retired = true; continue;
            };
            let starts = record.releases - WINDUP_TICKS;
            let elapsed = record.age + (now - record.received_at);
            let age = if clock_paused { record.age } else {
                elapsed.max(snapshot.tick.saturating_sub(starts) as f64 / TICK_RATE as f64)
            };
            if !age.is_finite() || age < 0. { return Err("Ezreal W presentation age invalid".into()); }
            record.age = age; record.received_at = now;
            let conflict = actor.effects.ezreal_q.is_some()
                || snapshot.ezreal_r_casts.iter().any(|row| row.owner == owner);
            if conflict { self.conflicts.insert(owner); }
            if self.finished || !clock_ready || snapshot.tick >= cast.releases || age >= window()
                || !actor.health.is_finite() || actor.health <= 0. || !actor.position.finite()
                || actor.windup.is_some() || conflict
                || !actor.effects.ezreal_w.as_ref().is_some_and(|lock|
                    lock.releases == cast.releases && lock.direction == cast.direction) {
                record.retired = true;
            }
        }
        self.visible = visible.keys().copied().collect();
        self.tick = Some(snapshot.tick); self.clock = Some(now); self.ready = clock_ready;
        Ok(())
    }
    /// A replaced player or unavailable clip consumes this launch permanently.
    /// Duration is a bound, never a scale factor for the authored animation.
    pub fn select(&mut self, owner: u32, entity: u64, now: f64, duration: Option<f32>,
        eligible: bool, clock_ready: bool,
    ) -> Option<Selection> {
        if !clock_ready || !self.ready || !now.is_finite() || self.clock.is_some_and(|old| now < old) {
            self.suspend(); return None;
        }
        self.clock = Some(now);
        let record = self.records.get_mut(&owner)?;
        if record.retired { return None; }
        let age = record.age + (now - record.received_at);
        let duration = duration.filter(|value| value.is_finite() && *value > 0.);
        if !eligible || duration.is_none() || !age.is_finite() || age < 0. || age >= window()
            || duration.is_some_and(|duration| age >= f64::from(duration))
            || record.claimed_by.is_some_and(|old| old != entity) {
            record.retired = true; return None;
        }
        let first = record.claimed_by.is_none(); record.claimed_by = Some(entity);
        record.age = age; record.received_at = now;
        Some(Selection { identity: Identity { session: self.session?, epoch: self.epoch, owner,
            team: record.team, ordinal: record.ordinal, releases: record.releases }, age_seconds: age as f32, first })
    }
}
fn bits(cast: &VisibleCast) -> [u32; 2] { [cast.direction.x.to_bits(), cast.direction.z.to_bits()] }
fn window() -> f64 { WINDUP_TICKS as f64 / TICK_RATE as f64 }

#[cfg(test)]
pub(crate) mod test_support {
    use openleague_core::{Action, Navigation, Point, Simulation, Snapshot};
    pub(crate) fn game() -> (Simulation,u32) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=99;let owner=game.join("ezreal").unwrap();
        let p=game.players.get_mut(&owner).unwrap();p.position=Point{x:100.,z:100.};p.level=6;p.ranks=[1,1,0,1];p.mana=2000.;
        (game,owner)
    }
    pub(crate) fn cast(game:&mut Simulation,owner:u32)->Snapshot {
        game.tick=100;game.command(owner,Action::CastAt{slot:1,point:Point{x:700.,z:100.}}).unwrap();
        let snapshot=game.snapshot_for(owner).unwrap();assert_eq!(snapshot.ezreal_w_casts.len(),1);snapshot
    }
}
#[cfg(test)]
mod tests {
    use super::*;use test_support::{game,cast};
    fn fixture()->(openleague_core::Simulation,u32,State) {
        let(game,owner)=game();let mut state=State::default();state.reset(game.session);
        state.observe_accepted(&game.snapshot_for(owner).unwrap(),0.,true,false).unwrap();(game,owner,state)
    }
    fn select(state:&mut State,owner:u32,now:f64)->Option<Selection>{state.select(owner,10,now,Some(1.0666667),true,true)}
    #[test]
    fn w_real_pending_uses_unscaled_age_freezes_on_pause_and_ends_at_release() {
        let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);let before=serde_json::to_value(&snapshot).unwrap();
        state.observe_accepted(&snapshot,0.1,true,false).unwrap();assert_eq!(select(&mut state,owner,0.1).unwrap().age_seconds,0.);
        state.observe_accepted(&snapshot,0.2,true,false).unwrap();let age=select(&mut state,owner,0.2).unwrap().age_seconds;assert!((age-0.1).abs()<0.000001);
        let mut paused=snapshot.clone();paused.tick=106;state.observe_accepted(&paused,0.2,true,true).unwrap();
        assert_eq!(select(&mut state,owner,0.2).unwrap().age_seconds,age);
        state.observe_accepted(&paused,0.2,true,false).unwrap();assert!((select(&mut state,owner,0.2).unwrap().age_seconds-0.2).abs()<0.000001);
        while game.tick<108 {game.advance();}let release=game.snapshot_for(owner).unwrap();assert!(release.ezreal_w_casts.is_empty());
        state.observe_accepted(&release,0.3,true,false).unwrap();assert!(select(&mut state,owner,0.3).is_none());
        assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
    }
    #[test]
    fn w_committed_stun_silence_and_forced_motion_do_not_rewrite_gameplay_or_clip_time() {
        for mode in 0..3 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,0.1,true,false).unwrap();
            game.tick=101;let p=game.players.get_mut(&owner).unwrap();match mode {
                0=>p.stuns.push(openleague_core::stuns::Stun{tag:"W".into(),source:None,expires_at:120}),
                1=>p.effects.silence_until=120,
                _=>{p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:101,until:112});p.position.z+=20.;}
            }
            let controlled=game.snapshot_for(owner).unwrap();assert_eq!(controlled.ezreal_w_casts.len(),1);
            state.observe_accepted(&controlled,0.12,true,false).unwrap();assert!(select(&mut state,owner,0.12).is_some(),"mode{mode}");
        }
    }
    #[test]
    fn w_absence_death_fog_end_and_connection_gap_consume_same_ordinal_in_one_batch() {
        for mode in 0..6 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,0.1,true,false).unwrap();
            let mut gap=snapshot.clone();gap.tick=101;match mode {
                0=>gap.ezreal_w_casts.clear(),
                1=>{gap.ezreal_w_casts.clear();gap.players.clear();},
                2=>gap.players[0].health=0.,3=>gap.winner=Some(0),
                4=>gap.players[0].effects.ezreal_w=None,_=>{}
            }
            state.observe_accepted(&gap,0.11,mode!=5,false).unwrap();
            let mut restore=snapshot.clone();restore.tick=102;state.observe_accepted(&restore,0.12,true,false).unwrap();
            assert!(select(&mut state,owner,0.12).is_none(),"mode{mode}");
        }
    }
    #[test]
    fn w_baseline_epoch_late_discovery_stale_packets_and_new_cast_have_distinct_lifetimes() {
        let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);
        let mut delayed=snapshot.clone();delayed.tick=103;state.observe_accepted(&delayed,0.1,true,false).unwrap();
        assert!((select(&mut state,owner,0.1).unwrap().age_seconds-0.1).abs()<0.000001);
        let saved=state.clone();assert_eq!(state.observe_accepted(&snapshot,0.2,true,false),Ok(false));assert_eq!(state,saved);
        state.begin_epoch(7,u64::MAX-1);state.observe_accepted(&delayed,0.2,true,false).unwrap();assert!(select(&mut state,owner,0.2).is_none());
        while game.tick<108 {game.advance();}state.observe_accepted(&game.snapshot_for(owner).unwrap(),0.3,true,false).unwrap();
        game.tick=109;game.players.get_mut(&owner).unwrap().cooldowns[1]=0;
        game.command(owner,openleague_core::Action::CastAt{slot:1,point:openleague_core::Point{x:700.,z:100.}}).unwrap();
        let fresh=game.snapshot_for(owner).unwrap();state.observe_accepted(&fresh,0.4,true,false).unwrap();
        let selected=select(&mut state,owner,0.4).unwrap();assert_eq!(selected.identity.epoch,u64::MAX-1);assert!(selected.identity.ordinal>snapshot.ezreal_w_casts[0].ordinal);
        let mut departed=fresh.clone();departed.players.clear();departed.roster.clear();departed.ezreal_w_casts.clear();
        state.observe_accepted(&departed,0.5,true,false).unwrap();assert!(state.records.is_empty());
    }
    #[test]
    fn w_invalid_row_clock_missing_clip_or_replaced_player_never_rearms() {
        for mode in 0..10 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,0.1,true,false).unwrap();
            assert!(select(&mut state,owner,0.1).is_some());
            if mode<6 {
                let mut bad=snapshot.clone();bad.tick=101;match mode {
                    0=>bad.ezreal_w_casts[0].ordinal=0,1=>bad.ezreal_w_casts[0].session+=1,
                    2=>bad.ezreal_w_casts[0].direction.x=f32::NAN,3=>bad.ezreal_w_casts[0].releases+=1,
                    4=>bad.ezreal_w_casts.push(bad.ezreal_w_casts[0]),
                    _=>{bad.ezreal_w_casts=vec![bad.ezreal_w_casts[0];MAX_OWNERS+1];}
                }
                assert!(state.observe_accepted(&bad,0.11,true,false).is_err());
            } else {match mode {
                6=>assert!(state.select(owner,10,0.11,None,true,true).is_none()),
                7=>assert!(state.select(owner,11,0.11,Some(2.),true,true).is_none()),
                8=>assert!(state.observe_accepted(&snapshot,f64::NAN,true,false).is_err()),
                _=>assert!(select(&mut state,owner,0.09).is_none())
            }}
            let mut restore=snapshot.clone();restore.tick=102;state.observe_accepted(&restore,0.12,true,false).unwrap();assert!(select(&mut state,owner,0.12).is_none());
        }
    }
    #[test]
    fn w_contradictory_real_q_or_r_cast_retires_all_channels_before_coalescing() {
        for slot in [0,3] {
            let(mut game,owner,mut state)=fixture();let baseline=game.snapshot_for(owner).unwrap();
            let mut q=crate::ezreal_q_cast_animation::State::default();q.reset(7);q.observe_accepted(&baseline,0.,true,false).unwrap();
            let mut r=crate::ezreal_r_cast_animation::State::default();r.reset(7);r.observe_accepted(&baseline,0.,true,false).unwrap();
            let mut other=test_support::game().0;other.tick=100;
            other.command(owner,openleague_core::Action::CastAt{slot,point:openleague_core::Point{x:700.,z:100.}}).unwrap();
            let real=other.snapshot_for(owner).unwrap();let mut conflict=cast(&mut game,owner);
            if slot==0 {conflict.players[0].effects.ezreal_q=real.players[0].effects.ezreal_q.clone();}else{conflict.ezreal_r_casts=real.ezreal_r_casts;}
            q.observe_accepted(&conflict,0.1,true,false).unwrap();r.observe_with_q(&conflict,0.1,true,false,&mut q).unwrap();
            state.observe_with_other_casts(&conflict,0.1,true,false,&mut q,&mut r).unwrap();
            let mut restore=conflict.clone();restore.tick=101;restore.ezreal_w_casts.clear();restore.players[0].effects.ezreal_w=None;
            q.observe_accepted(&restore,0.12,true,false).unwrap();r.observe_with_q(&restore,0.12,true,false,&mut q).unwrap();
            state.observe_with_other_casts(&restore,0.12,true,false,&mut q,&mut r).unwrap();
            assert!(select(&mut state,owner,0.12).is_none());assert!(q.select(owner,10,0.12,Some(2.),true,true).is_none());
            assert!(r.select(owner,10,0.12,Some(4.),true,true).is_none());
        }
    }
}

