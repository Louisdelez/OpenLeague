//! Optional LOCAL facts of a committed blink, not native E callbacks.
//! Departure/arrival have separate frozen audiences and only one public point.
//! Current body plus frozen point visibility is deliberately conservative.
use crate::{Point,Simulation};
use serde::{Deserialize,Serialize};
use serde_json::{json,Value};
use std::{collections::{BTreeMap,VecDeque},io::{self,Write}};

pub const POLICY:&str="local_e_committed_blink_points_v1";
pub const MAX_EVENTS:usize=32;
pub const MAX_OWNERS:usize=6;
pub const MAX_BYTES:usize=8192;
/// Local authorization retention, never permission to create late particles.
pub const HORIZON:u64=180;
pub const FRESH_TICKS:u64=3;
#[derive(Debug,Clone,Copy,Serialize,Deserialize,PartialEq,Eq)]
#[serde(rename_all="snake_case")]
pub enum Phase {Departure,Arrival}
impl Phase {fn bit(self)->u8 {match self {Self::Departure=>1,Self::Arrival=>2}}}
#[derive(Debug,Clone,Copy,Serialize,Deserialize,PartialEq)]
pub struct Event {pub owner:u32,pub order:u64,pub tick:u64,pub phase:Phase,pub position:Point}
impl Event {
    /// Consumers also need a fresh accepted context/epoch and current authority.
    pub fn fresh_at(self,tick:u64)->bool {self.tick<=tick && tick-self.tick<=FRESH_TICKS}
}
#[derive(Debug,Clone,Copy)]
pub(crate) struct Prepared {
    session:u64,owner:u32,source_team:u8,ordinal:u64,tick:u64,
    phase:Phase,position:Point,audience:[bool;2],
}
#[derive(Debug,Clone,Copy,PartialEq)]
struct Stored {event:Event,source_team:u8}
#[derive(Debug,Default)]
struct Slot {orders:[u64;2],disabled:[bool;2],last_ordinal:u64,phases:u8}
#[derive(Debug,Default)]
pub(crate) struct State {
    session:Option<u64>,owners:BTreeMap<u32,Slot>,highest_admitted_owner:u32,
    rings:[VecDeque<Stored>;2],last_tick:Option<u64>,
}
impl State {
    fn register(&mut self,session:u64,owner:u32) {
        if self.session!=Some(session){return;}
        let stale=owner==0 || owner<=self.highest_admitted_owner;
        self.highest_admitted_owner=self.highest_admitted_owner.max(owner);
        if stale || self.owners.len()>=MAX_OWNERS {if self.owners.contains_key(&owner){self.remove(owner);}return;}
        self.owners.insert(owner,Slot::default());
    }
    fn remove(&mut self,owner:u32) {self.owners.remove(&owner);for ring in &mut self.rings {ring.retain(|s|s.event.owner!=owner);}}
    pub(crate) fn prune(&mut self,session:u64,tick:u64) {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old){return;}
        self.last_tick=Some(tick);
        for ring in &mut self.rings {ring.retain(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON);}
    }
    /// Called only after the existing position/facing commit. No Result and no
    /// gameplay mutation; failure drops presentation. Invisible phases do not
    /// increment another view's order or consume its ring capacity.
    pub(crate) fn record(&mut self,fact:Option<Prepared>) {
        let Some(f)=fact else{return;};
        if self.session!=Some(f.session) || self.last_tick.is_some_and(|old|f.tick<old)
            || f.owner==0 || f.source_team>1 || f.ordinal==0 || !f.position.finite(){return;}
        self.prune(f.session,f.tick);
        let Some(slot)=self.owners.get_mut(&f.owner) else{return;};
        if f.ordinal<slot.last_ordinal{return;}
        if f.ordinal>slot.last_ordinal {slot.last_ordinal=f.ordinal;slot.phases=0;}
        if slot.phases&f.phase.bit()!=0{return;}
        slot.phases|=f.phase.bit();
        for team in 0..2 {
            if !f.audience[team] || slot.disabled[team]{continue;}
            let Some(order)=slot.orders[team].checked_add(1) else {slot.disabled[team]=true;continue;};
            slot.orders[team]=order;
            self.rings[team].push_back(Stored {source_team:f.source_team,event:Event {
                owner:f.owner,order,tick:f.tick,phase:f.phase,position:f.position,
            }});
            if self.rings[team].len()>MAX_EVENTS {self.rings[team].pop_front();}
        }
    }
    fn project(&self,session:u64,team:u8,tick:u64,mut visible:impl FnMut(u32,u8,Point)->bool)->Value {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old){return envelope(&[]);}
        let Some(ring)=self.rings.get(usize::from(team)) else{return envelope(&[]);};
        let mut rows:Vec<_>=ring.iter().filter(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON
            && self.owners.contains_key(&s.event.owner) && visible(s.event.owner,s.source_team,s.event.position))
            .map(|s|s.event).collect();
        loop {let value=envelope(&rows);if fits(&value){return value;}if rows.is_empty(){return envelope(&[]);}rows.remove(0);}
    }
}
fn envelope(events:&[Event])->Value {json!({"policy":POLICY,"events":events})}
struct Budget(usize);
impl Write for Budget {
    fn write(&mut self,b:&[u8])->io::Result<usize> {
        if b.len()>MAX_BYTES.saturating_sub(self.0){return Err(io::Error::new(io::ErrorKind::InvalidData,"E release byte budget"));}
        self.0+=b.len();Ok(b.len())
    }
    fn flush(&mut self)->io::Result<()> {Ok(())}
}
fn fits(value:&Value)->bool {serde_json::to_writer(Budget(0),value).is_ok()}
impl Simulation {
    fn synchronize_ezreal_e_release_session(&mut self) {
        if self.ezreal_e.releases.session==Some(self.session){return;}
        self.ezreal_e.releases=State {session:Some(self.session),..State::default()};
        for owner in self.players.keys().copied(){self.ezreal_e.releases.register(self.session,owner);}
    }
    pub(crate) fn register_ezreal_e_release_owner(&mut self,owner:u32) {
        if self.ezreal_e.releases.session!=Some(self.session){self.synchronize_ezreal_e_release_session();}
        else {self.ezreal_e.releases.register(self.session,owner);}
    }
    pub(crate) fn clear_ezreal_e_release_context(&mut self) {
        self.synchronize_ezreal_e_release_session();for ring in &mut self.ezreal_e.releases.rings {ring.clear();}
        // Preserve same-session watermarks, accepted ordinal and per-phase mask.
    }
    pub(crate) fn remove_ezreal_e_release_owner(&mut self,owner:u32){self.ezreal_e.releases.remove(owner);}
    pub(crate) fn prepare_ezreal_e_release(&self,owner:u32,team:u8,ordinal:u64,phase:Phase,position:Point)->Option<Prepared> {
        if self.winner.is_some() || owner==0 || team>1 || ordinal==0 || !position.finite()
            || !self.players.get(&owner).is_some_and(|p|p.id==owner && p.champion=="ezreal" && p.team==team
                && p.health.is_finite() && p.health>0. && p.position==position){return None;}
        let audience=std::array::from_fn(|view|self.visible_to(view as u8,owner) && self.visible_point_to(view as u8,position));
        // Keep a private prepared record even when both views are hidden, so
        // duplicate phase admission cannot later reveal a historical point.
        Some(Prepared {session:self.session,owner,source_team:team,ordinal,tick:self.tick,phase,position,audience})
    }
    pub(crate) fn ezreal_e_accepted_release_projection(&self,team:u8)->Value {
        if self.winner.is_some(){return envelope(&[]);}
        self.ezreal_e.releases.project(self.session,team,self.tick,|owner,source_team,point|
            self.players.get(&owner).is_some_and(|p|p.id==owner && p.champion=="ezreal" && p.team==source_team
                && p.health.is_finite() && p.position.finite())
            && self.visible_to(team,owner) && self.visible_point_to(team,point))
    }
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum DecodeError {Budget,Envelope,Policy,Event,Time,Owners,Order}
/// Only an accepted atomic OLSR frame can authorize this optional history.
/// No source cast ordinal or other phase point is part of the public event.
pub fn decode_view(value:Option<&Value>,tick:u64)->Result<Option<Vec<Event>>,DecodeError> {
    let Some(v)=value else{return Ok(None);};if !fits(v){return Err(DecodeError::Budget);}
    let map=v.as_object().ok_or(DecodeError::Envelope)?;
    if map.len()!=2 || !map.contains_key("policy") || !map.contains_key("events"){return Err(DecodeError::Envelope);}
    if map["policy"].as_str()!=Some(POLICY){return Err(DecodeError::Policy);}
    let rows=map["events"].as_array().ok_or(DecodeError::Envelope)?;
    if rows.len()>MAX_EVENTS{return Err(DecodeError::Budget);}
    let mut owners=BTreeMap::<u32,(u64,u64)>::new();let mut events=Vec::with_capacity(rows.len());
    for row in rows {
        let row=row.as_object().ok_or(DecodeError::Event)?;
        if row.len()!=5 || !["owner","order","tick","phase","position"].iter().all(|k|row.contains_key(*k)){return Err(DecodeError::Event);}
        let owner=row["owner"].as_u64().and_then(|v|u32::try_from(v).ok()).filter(|v|*v!=0).ok_or(DecodeError::Event)?;
        let order=row["order"].as_u64().filter(|v|*v!=0).ok_or(DecodeError::Event)?;
        let at=row["tick"].as_u64().ok_or(DecodeError::Event)?;
        if at>tick || tick-at>=HORIZON{return Err(DecodeError::Time);}
        let phase=match row["phase"].as_str() {Some("departure")=>Phase::Departure,Some("arrival")=>Phase::Arrival,_=>return Err(DecodeError::Event)};
        let point=row["position"].as_object().ok_or(DecodeError::Event)?;
        if point.len()!=2 || !point.contains_key("x") || !point.contains_key("z"){return Err(DecodeError::Event);}
        let number=|k:&str|point[k].as_f64().map(|v|v as f32).filter(|v|v.is_finite()).ok_or(DecodeError::Event);
        let position=Point{x:number("x")?,z:number("z")?};
        if owners.get(&owner).is_some_and(|(old_order,old_tick)|order<=*old_order || at<*old_tick){return Err(DecodeError::Order);}
        owners.insert(owner,(order,at));if owners.len()>MAX_OWNERS{return Err(DecodeError::Owners);}
        events.push(Event {owner,order,tick:at,phase,position});
    }
    Ok(Some(events))
}
#[cfg(test)]
#[path="ezreal_e_accepted_releases_tests.rs"]
mod tests;
