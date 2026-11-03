//! Bounded local accepted-cast facts. No native callback, cast lock or playback.
//! Private team counters/rings cannot count or evict the other view's hidden casts.
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};
use std::io::{self, Write};

pub const MAX_EVENTS: usize = 32;
pub const MAX_OWNERS: usize = 6;
pub const HORIZON: u64 = 60;
pub const MAX_BYTES: usize = 8192;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Kind {
    #[serde(rename = "trundle_w")]
    W,
    #[serde(rename = "trundle_r")]
    R,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub struct Event {
    pub owner: u32,
    pub order: u64,
    pub tick: u64,
    pub kind: Kind,
}

/// Local diagnostics only: deliberately no Serialize implementation.
#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub(crate) struct Diagnostics {
    admission_rejected: u64,
    unregistered_source: u64,
    time_rejected: u64,
    exhausted: [u64; 2],
    evicted: [u64; 2],
}
#[derive(Debug, Default, Clone, PartialEq, Eq)]
struct Slot { orders: [u64; 2], disabled: [bool; 2] }
#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub(crate) struct State {
    session: Option<u64>,
    owners: BTreeMap<u32, Slot>,
    highest_admitted_owner: u32,
    rings: [VecDeque<Event>; 2],
    last_tick: Option<u64>,
    diagnostics: Diagnostics,
}
impl State {
    /// Admission provenance comes from successful join, never first-cast order.
    /// Any failure affects optional presentation only, not the joined player.
    pub(crate) fn register_owner(&mut self, session: u64, owner: u32) {
        if self.session != Some(session) { *self = Self { session: Some(session), ..Self::default() }; }
        let stale = owner == 0 || owner <= self.highest_admitted_owner;
        self.highest_admitted_owner = self.highest_admitted_owner.max(owner);
        if stale || self.owners.len() >= MAX_OWNERS {
            // A duplicate/reused active identity cannot inherit its old slot.
            if self.owners.contains_key(&owner) { self.remove_owner(owner); }
            self.diagnostics.admission_rejected = self.diagnostics.admission_rejected.saturating_add(1);
            return;
        }
        self.owners.insert(owner, Slot::default());
    }
    pub(crate) fn remove_owner(&mut self, owner: u32) {
        self.owners.remove(&owner);
        for ring in &mut self.rings { ring.retain(|event| event.owner != owner); }
        // Never reset the bounded anti-reuse admission watermark on departure.
    }
    pub(crate) fn prune(&mut self, tick: u64) {
        if self.last_tick.is_some_and(|old| tick < old) { return; }
        self.last_tick = Some(tick);
        for ring in &mut self.rings {
            ring.retain(|event| event.tick <= tick && tick - event.tick < HORIZON);
        }
    }
    /// Non-failing append AFTER successful actual Core cast commit. Audience was
    /// captured before mutation. There is no gameplay Result or rollback here.
    pub(crate) fn record(&mut self, session: u64, owner: u32, tick: u64, kind: Kind, audience: [bool; 2]) {
        if self.session != Some(session) {
            self.diagnostics.unregistered_source = self.diagnostics.unregistered_source.saturating_add(1);
            return;
        }
        if self.last_tick.is_some_and(|old| tick < old) {
            self.diagnostics.time_rejected = self.diagnostics.time_rejected.saturating_add(1);
            return;
        }
        self.prune(tick);
        let Some(slot) = self.owners.get_mut(&owner) else {
            self.diagnostics.unregistered_source = self.diagnostics.unregistered_source.saturating_add(1);
            return;
        };
        for team in 0..2 {
            if !audience[team] || slot.disabled[team] { continue; }
            let Some(order) = slot.orders[team].checked_add(1) else {
                slot.disabled[team] = true;
                self.diagnostics.exhausted[team] = self.diagnostics.exhausted[team].saturating_add(1);
                continue;
            };
            slot.orders[team] = order;
            self.rings[team].push_back(Event { owner, order, tick, kind });
            if self.rings[team].len() > MAX_EVENTS {
                self.rings[team].pop_front();
                self.diagnostics.evicted[team] = self.diagnostics.evicted[team].saturating_add(1);
            }
        }
    }
    /// Fixed supported envelope, even after private producer errors. No health,
    /// error, audience, global order or hidden cast count is serialized.
    pub(crate) fn project(&self, session: u64, team: u8, tick: u64, mut visible: impl FnMut(u32) -> bool) -> Value {
        if self.session != Some(session) { return envelope(&[]); }
        let Some(ring) = self.rings.get(usize::from(team)) else { return envelope(&[]); };
        let mut events: Vec<_> = ring.iter().copied().filter(|event|
            event.tick <= tick && tick - event.tick < HORIZON
            && self.owners.contains_key(&event.owner) && visible(event.owner)).collect();
        loop {
            let value = envelope(&events);
            if fits_budget(&value) { return value; }
            if events.is_empty() { return envelope(&[]); }
            events.remove(0); // whole oldest event, never truncated JSON
        }
    }
    pub(crate) fn local_diagnostic(&self) -> &Diagnostics { &self.diagnostics }
}
fn envelope(events: &[Event]) -> Value { json!({"version":1,"events":events}) }

struct Budget(usize);
impl Write for Budget {
    fn write(&mut self, bytes: &[u8]) -> io::Result<usize> {
        if bytes.len() > MAX_BYTES.saturating_sub(self.0) {
            return Err(io::Error::new(io::ErrorKind::InvalidData, "cast field byte budget"));
        }
        self.0 += bytes.len();
        Ok(bytes.len())
    }
    fn flush(&mut self) -> io::Result<()> { Ok(()) }
}
fn fits_budget(value: &Value) -> bool { serde_json::to_writer(Budget(0), value).is_ok() }

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DecodeError { Budget, Envelope, Version, Event, Owners, Order }
/// Call only AFTER shared authentication/context/epoch/clock/state validation.
/// A local error disables this optional presentation; it is not a shared-state
/// verdict. None is unsupported; Some(empty) contains no projected facts only.
pub fn decode_view(value: Option<&Value>) -> Result<Option<Vec<Event>>, DecodeError> {
    let Some(value) = value else { return Ok(None); };
    if !fits_budget(value) { return Err(DecodeError::Budget); }
    let map = value.as_object().ok_or(DecodeError::Envelope)?;
    if map.len() != 2 || !map.contains_key("version") || !map.contains_key("events") {
        return Err(DecodeError::Envelope);
    }
    if map["version"].as_u64() != Some(1) { return Err(DecodeError::Version); }
    let rows = map["events"].as_array().ok_or(DecodeError::Envelope)?;
    if rows.len() > MAX_EVENTS { return Err(DecodeError::Budget); }
    let mut owners = BTreeMap::<u32, (u64, u64)>::new();
    let mut events = Vec::with_capacity(rows.len());
    for row in rows {
        let row = row.as_object().ok_or(DecodeError::Event)?;
        if row.len() != 4 || !["owner", "order", "tick", "kind"].iter().all(|key| row.contains_key(*key)) {
            return Err(DecodeError::Event);
        }
        let owner = row["owner"].as_u64().and_then(|n| u32::try_from(n).ok())
            .filter(|n| *n != 0).ok_or(DecodeError::Event)?;
        let order = row["order"].as_u64().filter(|n| *n != 0).ok_or(DecodeError::Event)?;
        let tick = row["tick"].as_u64().ok_or(DecodeError::Event)?;
        let kind = match row["kind"].as_str() {
            Some("trundle_w") => Kind::W, Some("trundle_r") => Kind::R,
            _ => return Err(DecodeError::Event),
        };
        if owners.get(&owner).is_some_and(|(old_order, old_tick)| order <= *old_order || tick < *old_tick) {
            return Err(DecodeError::Order);
        }
        owners.insert(owner, (order, tick));
        if owners.len() > MAX_OWNERS { return Err(DecodeError::Owners); }
        events.push(Event { owner, order, tick, kind });
    }
    Ok(Some(events))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Action, Navigation, Point, Simulation};
    fn events(state: &State, team: u8, tick: u64) -> Vec<Event> {
        decode_view(Some(&state.project(7, team, tick, |_| true))).unwrap().unwrap()
    }
    fn game() -> (Simulation, u32, u32) {
        let mut cells=Vec::new();
        for _ in 0..6400 { cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1); }
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
        let mut s=Simulation::new(nav).unwrap();s.session=7;s.tick=10;
        let a=s.join("trundle").unwrap();let b=s.join("garen").unwrap();
        let p=s.players.get_mut(&a).unwrap();p.position=Point{x:1000.,z:1000.};p.level=18;p.ranks=[1,1,0,1];p.mana=1000.;
        let p=s.players.get_mut(&b).unwrap();p.position=Point{x:1100.,z:1000.};
        (s,a,b)
    }
    #[test]
    fn independent_audience_rings_never_count_or_evict_hidden_casts_for_other_view() {
        let mut s=State::default();s.register_owner(7,1);
        s.record(7,1,10,Kind::W,[true,false]);let original=s.project(7,0,10,|_|true);
        for _ in 0..64 { s.record(7,1,10,Kind::R,[false,true]); }
        assert_eq!(s.project(7,0,10,|_|true),original);
        assert_eq!(events(&s,0,10)[0].order,1);assert_eq!(events(&s,1,10).len(),32);
        assert_eq!(events(&s,1,10).first().unwrap().order,33);
        s.record(7,1,10,Kind::R,[true,true]);
        assert_eq!(events(&s,0,10).last().unwrap().order,2);
        assert_eq!(events(&s,1,10).last().unwrap().order,65);
        assert_eq!(s.local_diagnostic().evicted,[0,33]);
    }
    #[test]
    fn admission_not_first_cast_controls_owner_order_and_departure_reuse_is_suppressed() {
        let mut s=State::default();s.register_owner(7,2);s.register_owner(7,5);
        s.record(7,5,1,Kind::W,[true,true]);s.record(7,2,1,Kind::R,[true,true]);
        assert_eq!(events(&s,0,1).iter().map(|e|(e.owner,e.order)).collect::<Vec<_>>(),[(5,1),(2,1)]);
        s.remove_owner(2);assert!(events(&s,0,1).iter().all(|e|e.owner!=2));
        s.register_owner(7,2);s.record(7,2,2,Kind::R,[true,true]);
        assert!(events(&s,0,2).iter().all(|e|e.owner!=2));
        s.register_owner(7,6);s.record(7,6,2,Kind::W,[true,true]);
        assert_eq!(events(&s,0,2).last().unwrap().owner,6);
        for id in 7..=12 {s.register_owner(7,id);}
        assert_eq!(s.owners.len(),MAX_OWNERS);
        assert!(s.local_diagnostic().admission_rejected>0);
        assert_eq!(s.project(8,0,2,|_|true),envelope(&[]));
        s.record(8,5,2,Kind::R,[true,true]);assert_eq!(s.project(8,0,2,|_|true),envelope(&[]));
        s.register_owner(8,2);s.record(8,2,2,Kind::R,[true,true]);
        assert_eq!(decode_view(Some(&s.project(8,0,2,|_|true))).unwrap().unwrap()[0].order,1);
    }
    #[test]
    fn lifetime_current_visibility_and_actual_encoding_are_bounded_without_wire_diagnostics() {
        let mut s=State::default();s.register_owner(7,1);
        for _ in 0..MAX_EVENTS {s.record(7,1,10,Kind::R,[true,false]);}
        let full=s.project(7,0,69,|_|true);assert_eq!(decode_view(Some(&full)).unwrap().unwrap().len(),32);
        assert!(serde_json::to_vec(&full).unwrap().len()<=MAX_BYTES);
        assert_eq!(s.project(7,0,69,|_|false),envelope(&[]));
        assert_eq!(s.project(7,0,70,|_|true),envelope(&[]));
        s.prune(70);assert!(s.rings[0].is_empty());
        s.record(7,1,69,Kind::W,[true,true]);assert_eq!(s.local_diagnostic().time_rejected,1);
        assert_eq!(s.project(7,0,70,|_|true),envelope(&[]));
        assert_eq!(s.project(7,2,70,|_|true),envelope(&[]));
        assert_eq!(full.as_object().unwrap().keys().cloned().collect::<Vec<_>>(),["events","version"]);
        for e in full["events"].as_array().unwrap() {assert_eq!(e.as_object().unwrap().len(),4);}
    }
    #[test]
    fn exhausted_view_counter_disables_only_its_producer_without_gameplay_error_or_public_flag() {
        let mut s=State::default();s.register_owner(7,1);s.owners.get_mut(&1).unwrap().orders[0]=u64::MAX;
        s.record(7,1,10,Kind::R,[true,true]);
        assert!(events(&s,0,10).is_empty());assert_eq!(events(&s,1,10)[0].order,1);
        assert_eq!(s.project(7,0,10,|_|true),envelope(&[]));assert_eq!(s.local_diagnostic().exhausted,[1,0]);
        s.record(7,1,11,Kind::W,[false,true]);assert_eq!(events(&s,1,11).last().unwrap().order,2);
        assert_eq!(s.local_diagnostic().exhausted,[1,0]);
    }
    #[test]
    fn successful_w_and_lethal_r_emit_in_real_same_tick_order_without_requiring_drain() {
        for reverse in [false,true] {
            let (mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;let point=s.players[&a].position;
            if reverse {s.command(a,Action::Cast{slot:3,target:Some(b)}).unwrap();}
            s.command(a,Action::CastAt{slot:1,point}).unwrap();
            if !reverse {s.command(a,Action::Cast{slot:3,target:Some(b)}).unwrap();}
            assert_eq!(s.players[&b].health,0.);assert!(s.players[&a].effects.trundle_r.is_none());
            let expected=if reverse {[Kind::R,Kind::W]}else{[Kind::W,Kind::R]};
            let snapshot=s.snapshot_for(a).unwrap();let facts=decode_view(snapshot.accepted_casts.as_ref()).unwrap().unwrap();
            assert_eq!(facts.iter().map(|e|e.kind).collect::<Vec<_>>(),expected);
            assert_eq!(facts.iter().map(|e|(e.owner,e.order,e.tick)).collect::<Vec<_>>(),[(a,1,10),(a,2,10)]);
            assert!(serde_json::to_vec(snapshot.accepted_casts.as_ref().unwrap()).unwrap().len()<=MAX_BYTES);
            let legacy=crate::wire::state_datagrams(&snapshot).unwrap();
            let mut sender=crate::session_wire::Sender::new(crate::session_transport::Context{session:7,player:a,epoch:1}).unwrap();
            let resumed=sender.encode(&snapshot,0).unwrap();
            assert!(legacy.iter().chain(&resumed).all(|packet|packet.len()<=1200));
            assert!(s.snapshot().accepted_casts.is_none());
        }
    }
    #[test]
    fn rejected_w_r_commands_do_not_emit_increment_or_change_existing_combat_decisions() {
        let (mut s,a,b)=game();let point=s.players[&a].position;
        s.players.get_mut(&a).unwrap().mana=0.;
        let before=serde_json::to_value(&s.players).unwrap();
        assert!(s.command(a,Action::CastAt{slot:1,point}).is_err());
        assert!(s.command(a,Action::Cast{slot:3,target:Some(b)}).is_err());
        assert_eq!(serde_json::to_value(&s.players).unwrap(),before);assert!(events(&s.accepted_casts,0,10).is_empty());
        assert_eq!(s.accepted_casts.owners[&a].orders,[0,0]);
        s.players.get_mut(&a).unwrap().mana=1000.;s.players.get_mut(&a).unwrap().attack_roll=Some(true);
        let before=s.players[&a].clone();s.command(a,Action::CastAt{slot:1,point}).unwrap();
        let after=&s.players[&a];assert_eq!(after.attack_roll,before.attack_roll);
        assert_eq!(after.next_attack,before.next_attack);assert_eq!(after.target,before.target);
        assert_eq!(after.destination,before.destination);assert_eq!(after.path,before.path);
    }
    #[test]
    fn death_respawn_and_actual_departure_keep_or_retire_the_correct_private_identity() {
        let (mut s,a,_)=game();let point=s.players[&a].position;
        s.command(a,Action::CastAt{slot:1,point}).unwrap();
        s.apply_damage(None,a,100000.,crate::damage::DamageKind::True).unwrap();
        assert!(s.players[&a].effects.trundle_w.is_none());
        assert_eq!(s.accepted_casts.owners[&a].orders,[1,1]);
        s.tick=s.players[&a].respawn_at.unwrap();s.advance_respawns();assert!(s.players[&a].health>0.);
        assert_eq!(s.accepted_casts.owners[&a].orders,[1,1]);
        let point=s.players[&a].position;s.command(a,Action::CastAt{slot:1,point}).unwrap();
        assert_eq!(events(&s.accepted_casts,0,s.tick).last().unwrap().order,2);
        s.remove_player(a).unwrap();assert!(!s.accepted_casts.owners.contains_key(&a));
        assert!(events(&s.accepted_casts,0,s.tick).is_empty());
        let new=s.join("trundle").unwrap();assert!(new>a);
        assert_eq!(s.accepted_casts.owners[&new].orders,[0,0]);
    }
    #[test]
    fn optional_value_decode_rejects_bad_journal_without_accepting_invalid_shared_state() {
        let (s,_,_)=game();let mut wire=serde_json::to_value(s.snapshot()).unwrap();
        let valid=json!({"version":1,"events":[{"owner":1,"order":1,"tick":10,"kind":"trundle_r"}]});
        assert_eq!(decode_view(Some(&valid)).unwrap().unwrap().len(),1);
        assert!(decode_view(None).unwrap().is_none());assert_eq!(decode_view(Some(&envelope(&[]))).unwrap(),Some(vec![]));
        for bad in [json!(7),json!({"version":2,"events":[]}),
            json!({"version":1,"events":[{"owner":true,"order":1,"tick":10,"kind":"trundle_r"}]}),
            json!({"version":1,"events":[{"owner":1,"order":1,"tick":10,"kind":"trundle_r","target":2}]}),
            json!({"version":1,"events":[{"owner":1,"order":1,"tick":10,"kind":"unknown"}]}),
            json!({"version":1,"events":[],"error":"hidden"}),json!("x".repeat(MAX_BYTES))] {
            wire["accepted_casts"]=bad;
            let snapshot:crate::Snapshot=serde_json::from_value(wire.clone()).unwrap();
            assert!(decode_view(snapshot.accepted_casts.as_ref()).is_err());assert_eq!(snapshot.tick,s.tick);
        }
        let mut duplicate=valid.clone();duplicate["events"].as_array_mut().unwrap().push(valid["events"][0].clone());
        assert_eq!(decode_view(Some(&duplicate)),Err(DecodeError::Order));
        let over=json!({"version":1,"events":vec![valid["events"][0].clone();MAX_EVENTS+1]});
        assert_eq!(decode_view(Some(&over)),Err(DecodeError::Budget));
        wire.as_object_mut().unwrap().remove("session");assert!(serde_json::from_value::<crate::Snapshot>(wire).is_err());
    }
}
