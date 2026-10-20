//! Bounded local R impact facts, produced only after accepted common damage.
//! This is a presentation delivery policy, not native VFX/audio chronology.
//! Private team rings/orders never count or evict the other view's hidden hits.
//! Conservative LOCAL audience: caster, target and both points visible before
//! damage; current caster and frozen points visible at projection. No hidden
//! caster audio policy, launch/release signal or native callback timing claim.
use crate::{Point, Simulation};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};
use std::io::{self, Write};

pub const POLICY: &str = "local_r_accepted_hit_conservative_v1";
pub const MAX_EVENTS: usize = 32;
pub const MAX_OWNERS: usize = 6;
// Local authorization retention: the authored Magicdust life can reach4s.
//150ticks allow that life plus bounded receipt freshness. This is NOT a
//birth/replay window: consumers still admit only events at most3ticks old.
pub const HORIZON: u64 = 150;
pub const MAX_BYTES: usize = 8192;

/// Target ID and both contact points are historical facts, not live attachments.
/// Never resolve a new target position or a recycled entity from this ID.
/// The authenticated snapshot session and accepted client epoch scope `order`.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct Event {
    pub owner: u32,
    pub target: u32,
    pub order: u64,
    pub tick: u64,
    pub projectile_center: Point,
    pub target_center: Point,
}

#[derive(Debug, Clone, Copy)]
pub(crate) struct Prepared {
    session: u64,
    owner: u32,
    source_team: u8,
    target: u32,
    tick: u64,
    projectile_center: Point,
    target_center: Point,
    audience: [bool; 2],
}
#[derive(Debug, Clone, Copy, PartialEq)]
struct Stored { event: Event, source_team: u8 }
#[derive(Debug, Default, PartialEq)]
struct Slot { orders: [u64; 2], disabled: [bool; 2] }
#[derive(Debug, Default)]
pub(crate) struct State {
    session: Option<u64>,
    owners: BTreeMap<u32, Slot>,
    highest_admitted_owner: u32,
    rings: [VecDeque<Stored>; 2],
    last_tick: Option<u64>,
}
impl State {
    fn register_owner(&mut self, session: u64, owner: u32) {
        if self.session != Some(session) { return; }
        let stale=owner==0 || owner<=self.highest_admitted_owner;
        self.highest_admitted_owner=self.highest_admitted_owner.max(owner);
        if stale || self.owners.len()>=MAX_OWNERS {
            if self.owners.contains_key(&owner) { self.remove_owner(owner); }
            return;
        }
        self.owners.insert(owner,Slot::default());
    }
    fn remove_owner(&mut self, owner: u32) {
        self.owners.remove(&owner);
        for ring in &mut self.rings { ring.retain(|s|s.event.owner!=owner && s.event.target!=owner); }
        // Admission watermark and other producers' private orders do not reset.
    }
    pub(crate) fn prune(&mut self, session: u64, tick: u64) {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old) { return; }
        self.last_tick=Some(tick);
        for ring in &mut self.rings { ring.retain(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON); }
    }
    /// No Result and no gameplay mutation. The caller has already committed
    /// attenuation/passive after apply_damage Ok, including a fully shielded hit.
    fn record(&mut self, fact: Prepared) {
        if self.session!=Some(fact.session) || self.last_tick.is_some_and(|old|fact.tick<old)
            || fact.owner==0 || fact.target==0 || fact.owner==fact.target || fact.source_team>1
            || !fact.projectile_center.finite() || !fact.target_center.finite() { return; }
        self.prune(fact.session,fact.tick);
        let Some(slot)=self.owners.get_mut(&fact.owner) else {return;};
        for team in 0..2 {
            if !fact.audience[team] || slot.disabled[team] {continue;}
            let Some(order)=slot.orders[team].checked_add(1) else {slot.disabled[team]=true;continue;};
            slot.orders[team]=order;
            self.rings[team].push_back(Stored {source_team:fact.source_team,event:Event {
                owner:fact.owner,target:fact.target,order,tick:fact.tick,
                projectile_center:fact.projectile_center,target_center:fact.target_center,
            }});
            if self.rings[team].len()>MAX_EVENTS {self.rings[team].pop_front();}
        }
    }
    fn project(&self, session:u64, team:u8, tick:u64,
        mut visible:impl FnMut(u32,u8,Point,Point)->bool) -> Value {
        if self.session!=Some(session) || self.last_tick.is_some_and(|old|tick<old) {return envelope(&[]);}
        let Some(ring)=self.rings.get(usize::from(team))else{return envelope(&[]);};
        let mut events:Vec<_>=ring.iter().filter(|s|s.event.tick<=tick && tick-s.event.tick<HORIZON
            && self.owners.contains_key(&s.event.owner)
            && visible(s.event.owner,s.source_team,s.event.projectile_center,s.event.target_center))
            .map(|s|s.event).collect();
        loop {
            let value=envelope(&events);
            if fits_budget(&value) {return value;}
            if events.is_empty() {return envelope(&[]);}
            events.remove(0); // only this view's whole projected facts; no shared eviction
        }
    }
}
fn envelope(events:&[Event])->Value {json!({"version":1,"events":events})}
struct Budget(usize);
impl Write for Budget {
    fn write(&mut self, bytes:&[u8])->io::Result<usize> {
        if bytes.len()>MAX_BYTES.saturating_sub(self.0) {return Err(io::Error::new(io::ErrorKind::InvalidData,"R impact byte budget"));}
        self.0+=bytes.len();Ok(bytes.len())
    }
    fn flush(&mut self)->io::Result<()> {Ok(())}
}
fn fits_budget(value:&Value)->bool {serde_json::to_writer(Budget(0),value).is_ok()}

impl Simulation {
    fn synchronize_ezreal_r_impact_session(&mut self) {
        if self.ezreal_r.impacts.session==Some(self.session) {return;}
        self.ezreal_r.impacts=State {session:Some(self.session),..State::default()};
        // A new explicit session admits its existing roster in stable ID order;
        // admission is never inferred from first visible/hidden hit ordering.
        for owner in self.players.keys().copied() {self.ezreal_r.impacts.register_owner(self.session,owner);}
    }
    pub(crate) fn register_ezreal_r_impact_owner(&mut self, owner:u32) {
        if self.ezreal_r.impacts.session!=Some(self.session) {
            self.synchronize_ezreal_r_impact_session();
        } else {self.ezreal_r.impacts.register_owner(self.session,owner);}
    }
    pub(crate) fn clear_ezreal_r_impact_context(&mut self) {
        self.synchronize_ezreal_r_impact_session();
        for ring in &mut self.ezreal_r.impacts.rings {ring.clear();}
        // Same-session clear does not recycle per-view order identities.
    }
    pub(crate) fn remove_ezreal_r_impact_owner(&mut self, owner:u32) {self.ezreal_r.impacts.remove_owner(owner);}
    /// Capture geometry and each independent view BEFORE common damage can kill
    /// or remove the target. Failure suppresses presentation only, never damage.
    pub(crate) fn prepare_ezreal_r_accepted_impact(&self, owner:u32, source_team:u8, target:u32,
        projectile_center:Point, target_center:Point)->Option<Prepared> {
        if self.winner.is_some() || source_team>1 || owner==0 || target==0 || owner==target
            || !projectile_center.finite() || !target_center.finite()
            || !self.players.get(&owner).is_some_and(|p|p.champion=="ezreal" && p.team==source_team)
            || self.target_info(target).is_none() {return None;}
        let audience:[bool;2]=std::array::from_fn(|team|self.visible_to(team as u8,owner)
            && self.visible_to(team as u8,target)
            && self.visible_point_to(team as u8,projectile_center)
            && self.visible_point_to(team as u8,target_center));
        if !audience.into_iter().any(|allowed|allowed) {return None;}
        Some(Prepared {session:self.session,owner,source_team,target,tick:self.tick,
            projectile_center,target_center,audience})
    }
    pub(crate) fn record_ezreal_r_accepted_impact(&mut self, prepared:Option<Prepared>) {
        let Some(fact)=prepared else{return;};
        if self.winner.is_some() || fact.session!=self.session || fact.tick!=self.tick
            || !self.players.get(&fact.owner).is_some_and(|p|p.champion=="ezreal" && p.team==fact.source_team) {return;}
        self.ezreal_r.impacts.record(fact);
    }
    pub(crate) fn ezreal_r_accepted_impact_projection(&self, team:u8)->Value {
        if self.winner.is_some() {return envelope(&[]);}
        self.ezreal_r.impacts.project(self.session,team,self.tick,|owner,source_team,projectile,target|
            self.players.get(&owner).is_some_and(|p|p.champion=="ezreal" && p.team==source_team)
            && self.visible_to(team,owner) && self.visible_point_to(team,projectile)
            && self.visible_point_to(team,target))
        // No current target lookup: lethal/removal facts keep only frozen points.
    }
}

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum DecodeError {Budget,Envelope,Version,Event,Time,Owners,Order}
/// Call after shared authentication/context/epoch/clock validation. A local
/// error disables only this optional consumer. Consumer identity is
/// (snapshot.session, accepted epoch, owner, order); first baseline consumes
/// history without replay. Validate the received canonical Ezreal roster too.
pub fn decode_view(value:Option<&Value>,snapshot_tick:u64)->Result<Option<Vec<Event>>,DecodeError> {
    let Some(value)=value else{return Ok(None);};
    if !fits_budget(value) {return Err(DecodeError::Budget);}
    let map=value.as_object().ok_or(DecodeError::Envelope)?;
    if map.len()!=2 || !map.contains_key("version") || !map.contains_key("events") {return Err(DecodeError::Envelope);}
    if map["version"].as_u64()!=Some(1) {return Err(DecodeError::Version);}
    let rows=map["events"].as_array().ok_or(DecodeError::Envelope)?;
    if rows.len()>MAX_EVENTS {return Err(DecodeError::Budget);}
    let mut owners=BTreeMap::<u32,(u64,u64)>::new();let mut events=Vec::with_capacity(rows.len());
    for row in rows {
        let row=row.as_object().ok_or(DecodeError::Event)?;
        if row.len()!=6 || !["owner","target","order","tick","projectile_center","target_center"].iter().all(|key|row.contains_key(*key)) {return Err(DecodeError::Event);}
        let id=|key:&str|row[key].as_u64().and_then(|v|u32::try_from(v).ok()).filter(|v|*v!=0).ok_or(DecodeError::Event);
        let owner=id("owner")?;let target=id("target")?;
        if owner==target {return Err(DecodeError::Event);}
        let order=row["order"].as_u64().filter(|v|*v!=0).ok_or(DecodeError::Event)?;
        let tick=row["tick"].as_u64().ok_or(DecodeError::Event)?;
        if tick>snapshot_tick || snapshot_tick-tick>=HORIZON {return Err(DecodeError::Time);}
        let point=|key:&str|->Result<Point,DecodeError> {
            let p=row[key].as_object().ok_or(DecodeError::Event)?;
            if p.len()!=2 || !p.contains_key("x") || !p.contains_key("z") {return Err(DecodeError::Event);}
            let coordinate=|key:&str|p[key].as_f64().map(|v|v as f32).filter(|v|v.is_finite()).ok_or(DecodeError::Event);
            Ok(Point {x:coordinate("x")?,z:coordinate("z")?})
        };
        if owners.get(&owner).is_some_and(|(old_order,old_tick)|order<=*old_order || tick<*old_tick) {return Err(DecodeError::Order);}
        owners.insert(owner,(order,tick));if owners.len()>MAX_OWNERS {return Err(DecodeError::Owners);}
        events.push(Event {owner,target,order,tick,projectile_center:point("projectile_center")?,target_center:point("target_center")?});
    }
    Ok(Some(events))
}

#[cfg(test)]
#[path="ezreal_r_accepted_impacts_tests.rs"]
mod tests;
