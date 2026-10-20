//! Optional LOCAL accepted-R-cast facts, independent of impacts and missile release.
//! Frozen pre-commit body/position audience; current living body and frozen point
//! must remain visible. No native callback schedule, skin override or audio mix claim.
use crate::{Point, Simulation};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::{collections::{BTreeMap,VecDeque},io::{self,Write}};

pub const POLICY:&str="local_r_accepted_OnCast_conservative_v1";
pub const MAX_EVENTS:usize=16;
pub const MAX_OWNERS:usize=6;
// Five seconds authorizes the longest 3.75s media plus bounded delivery/watchdog.
// It is local journal retention, not native sound duration or cast-time scaling.
pub const HORIZON:u64=150;
pub const MAX_BYTES:usize=4096;
#[derive(Debug,Clone,Copy,Serialize,Deserialize,PartialEq)]
pub struct Event { pub owner:u32,pub ordinal:u64,pub order:u64,pub tick:u64,pub position:Point }
#[derive(Debug,Clone,Copy)]
pub(crate) struct Prepared {
    session:u64,owner:u32,source_team:u8,ordinal:u64,tick:u64,position:Point,audience:[bool;2],
}
#[derive(Debug,Clone,Copy,PartialEq)]
struct Stored {event:Event,source_team:u8}
#[derive(Debug,Default)]
struct Slot {orders:[u64;2],disabled:[bool;2],last_ordinal:u64}
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
    fn remove(&mut self,owner:u32){self.owners.remove(&owner);for ring in &mut self.rings{ring.retain(|s|s.event.owner!=owner);}}
    pub(crate) fn prune(&mut self,session:u64,tick:u64) {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old){return;}
        self.last_tick=Some(tick);for ring in &mut self.rings{ring.retain(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON);}
    }
    /// Sole production caller: immediately after cast_ezreal_r_at commits Pending.
    /// This optional journal has no Result and can never reject accepted gameplay.
    pub(crate) fn record(&mut self,fact:Option<Prepared>) {
        let Some(f)=fact else{return;};
        if self.session!=Some(f.session) || self.last_tick.is_some_and(|old|f.tick<old)
            || f.owner==0 || f.source_team>1 || f.ordinal==0 || !f.position.finite(){return;}
        self.prune(f.session,f.tick);
        let Some(slot)=self.owners.get_mut(&f.owner) else{return;};
        if f.ordinal<=slot.last_ordinal{return;}slot.last_ordinal=f.ordinal;
        for team in 0..2 {
            if !f.audience[team] || slot.disabled[team]{continue;}
            let Some(order)=slot.orders[team].checked_add(1) else{slot.disabled[team]=true;continue;};
            slot.orders[team]=order;
            self.rings[team].push_back(Stored{source_team:f.source_team,event:Event{owner:f.owner,ordinal:f.ordinal,order,tick:f.tick,position:f.position}});
            if self.rings[team].len()>MAX_EVENTS{self.rings[team].pop_front();}
        }
    }
    fn project(&self,session:u64,team:u8,tick:u64,mut visible:impl FnMut(u32,u8,Point)->bool)->Value {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old){return envelope(&[]);}
        let Some(ring)=self.rings.get(usize::from(team))else{return envelope(&[]);};
        let mut rows:Vec<_>=ring.iter().filter(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON
            && self.owners.contains_key(&s.event.owner) && visible(s.event.owner,s.source_team,s.event.position)).map(|s|s.event).collect();
        loop {let value=envelope(&rows);if fits(&value){return value;}if rows.is_empty(){return envelope(&[]);}rows.remove(0);}
    }
}
fn envelope(events:&[Event])->Value{json!({"version":1,"events":events})}
struct Budget(usize);
impl Write for Budget {
    fn write(&mut self,b:&[u8])->io::Result<usize>{if b.len()>MAX_BYTES.saturating_sub(self.0){return Err(io::Error::new(io::ErrorKind::InvalidData,"R OnCast byte budget"));}self.0+=b.len();Ok(b.len())}
    fn flush(&mut self)->io::Result<()>{Ok(())}
}
fn fits(value:&Value)->bool{serde_json::to_writer(Budget(0),value).is_ok()}
impl Simulation {
    fn synchronize_ezreal_r_cast_audio_session(&mut self){
        if self.ezreal_r.cast_audio.session==Some(self.session){return;}
        self.ezreal_r.cast_audio=State{session:Some(self.session),..State::default()};
        for owner in self.players.keys().copied(){self.ezreal_r.cast_audio.register(self.session,owner);}
    }
    pub(crate) fn register_ezreal_r_cast_audio_owner(&mut self,owner:u32){
        if self.ezreal_r.cast_audio.session!=Some(self.session){self.synchronize_ezreal_r_cast_audio_session();}
        else{self.ezreal_r.cast_audio.register(self.session,owner);}
    }
    pub(crate) fn clear_ezreal_r_cast_audio_context(&mut self){
        self.synchronize_ezreal_r_cast_audio_session();for ring in &mut self.ezreal_r.cast_audio.rings{ring.clear();}
        // Same-session clear preserves both accepted ordinal and private view orders.
    }
    pub(crate) fn remove_ezreal_r_cast_audio_owner(&mut self,owner:u32){self.ezreal_r.cast_audio.remove(owner);}
    pub(crate) fn prepare_ezreal_r_accepted_cast(&self,owner:u32,team:u8,ordinal:u64,position:Point)->Option<Prepared>{
        if self.winner.is_some() || owner==0 || team>1 || ordinal==0 || !position.finite()
            || !self.players.get(&owner).is_some_and(|p|p.id==owner && p.champion=="ezreal" && p.team==team
                && p.health.is_finite() && p.health>0. && p.position==position){return None;}
        let audience=std::array::from_fn(|view|self.visible_to(view as u8,owner) && self.visible_point_to(view as u8,position));
        if !audience.into_iter().any(|allowed|allowed){return None;}
        Some(Prepared{session:self.session,owner,source_team:team,ordinal,tick:self.tick,position,audience})
    }
    pub(crate) fn ezreal_r_accepted_cast_projection(&self,team:u8)->Value{
        if self.winner.is_some(){return envelope(&[]);}
        self.ezreal_r.cast_audio.project(self.session,team,self.tick,|owner,source_team,position|
            self.players.get(&owner).is_some_and(|p|p.id==owner && p.champion=="ezreal" && p.team==source_team
                && p.health.is_finite() && p.health>0. && p.position.finite())
            && self.visible_to(team,owner) && self.visible_point_to(team,position))
    }
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum DecodeError{Budget,Envelope,Version,Event,Time,Owners,Order}
/// Only an admitted atomic OLSR frame may authorize this optional channel.
/// u64 ordinal/order are parsed as integers, never through floating-point IDs.
pub fn decode_view(value:Option<&Value>,tick:u64)->Result<Option<Vec<Event>>,DecodeError>{
    let Some(v)=value else{return Ok(None);};if !fits(v){return Err(DecodeError::Budget);}
    let map=v.as_object().ok_or(DecodeError::Envelope)?;
    if map.len()!=2 || !map.contains_key("version") || !map.contains_key("events"){return Err(DecodeError::Envelope);}
    if map["version"].as_u64()!=Some(1){return Err(DecodeError::Version);}
    let rows=map["events"].as_array().ok_or(DecodeError::Envelope)?;if rows.len()>MAX_EVENTS{return Err(DecodeError::Budget);}
    let mut owners=BTreeMap::<u32,(u64,u64,u64)>::new();let mut events=Vec::with_capacity(rows.len());
    for row in rows{
        let row=row.as_object().ok_or(DecodeError::Event)?;
        if row.len()!=5 || !["owner","ordinal","order","tick","position"].iter().all(|k|row.contains_key(*k)){return Err(DecodeError::Event);}
        let integer=|k:&str|row[k].as_u64().filter(|v|*v!=0).ok_or(DecodeError::Event);
        let owner=u32::try_from(integer("owner")?).map_err(|_|DecodeError::Event)?;
        let ordinal=integer("ordinal")?;let order=integer("order")?;let at=row["tick"].as_u64().ok_or(DecodeError::Event)?;
        if at>tick || tick-at>=HORIZON{return Err(DecodeError::Time);}
        let pos=row["position"].as_object().ok_or(DecodeError::Event)?;
        if pos.len()!=2 || !pos.contains_key("x") || !pos.contains_key("z"){return Err(DecodeError::Event);}
        let coordinate=|k:&str|pos[k].as_f64().map(|v|v as f32).filter(|v|v.is_finite()).ok_or(DecodeError::Event);
        let position=Point{x:coordinate("x")?,z:coordinate("z")?};
        if owners.get(&owner).is_some_and(|(old_order,old_ordinal,old_tick)|order<=*old_order || ordinal<=*old_ordinal || at<*old_tick){return Err(DecodeError::Order);}
        owners.insert(owner,(order,ordinal,at));if owners.len()>MAX_OWNERS{return Err(DecodeError::Owners);}
        events.push(Event{owner,ordinal,order,tick:at,position});
    }
    Ok(Some(events))
}
#[cfg(test)]
#[path="ezreal_r_accepted_casts_tests.rs"]
mod tests;
