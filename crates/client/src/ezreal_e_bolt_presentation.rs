//! Current E samples from complete accepted OLSR frames. This is not an emitter,
//! renderer or native trajectory clock. No actor/target lookup or extrapolation.
use openleague_core::{ezreal_e_projectile_view::{self as wire,Row},session_transport::Context,Point,Snapshot};
use std::collections::{BTreeMap,BTreeSet};

/// Local presentation timeout, unrelated to native particle life or cadence.
pub const FRESH_SECONDS:f64=0.2;
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)]
pub struct Key {pub session:u64,pub owner:u32,pub team:u8,pub ordinal:u64}
#[derive(Clone,Copy,Debug,PartialEq)]
pub struct CurrentE {
    pub key:Key,pub epoch:u64,pub incarnation:u64,pub position:Point,
    pub y_native:f32,pub direction:Point,pub sample_tick:u64,pub sample_frame:u64,
    /// Current permission may be renewed while the simulation tick is unchanged.
    /// It never changes the provenance of the XYZ/direction sample above.
    pub authorization_frame:u64,
}
#[derive(Debug)]
pub struct State {
    session:Option<u64>,viewer:Option<u32>,epoch:Option<u64>,team:Option<u8>,
    last_tick:Option<u64>,last_frame:Option<u64>,last_now:Option<f64>,at:Option<f64>,
    baseline:bool,ended:bool,next:u64,facts:BTreeMap<Key,Row>,rows:BTreeMap<Key,CurrentE>,
}
impl Default for State {
    fn default()->Self {Self{session:None,viewer:None,epoch:None,team:None,last_tick:None,
        last_frame:None,last_now:None,at:None,baseline:true,ended:false,next:0,
        facts:BTreeMap::new(),rows:BTreeMap::new()}}
}
impl State {
    pub fn suspend(&mut self) {
        self.rows.clear();self.facts.clear();self.at=None;self.baseline=true;
        // Keep frame/tick watermarks and the episode counter: a malformed replay
        // or a connection gap must not reset the accepted transport sequence.
    }
    pub fn reset_session(&mut self,session:u64,viewer:u32) {
        let next=self.next;*self=Self{session:Some(session),viewer:Some(viewer),next,..Self::default()};
    }
    pub fn begin_epoch(&mut self,epoch:Option<u64>) {
        self.suspend();self.epoch=epoch;self.team=None;self.last_tick=None;
        self.last_frame=None;self.last_now=None;self.ended=false;
    }
    fn fresh(&self,now:f64)->bool {self.at.is_some_and(|at|now>=at&&now-at<=FRESH_SECONDS)}
    /// Called from the normal receive system even when no datagram arrives.
    pub fn maintain(&mut self,now:f64,paused:bool,healthy:bool) {
        if !healthy||paused||!now.is_finite()||now<0.
            ||self.last_now.is_some_and(|old|now<old)||self.at.is_some()&&!self.fresh(now) {
            self.suspend();
        }
    }
    fn audience(snapshot:&Snapshot,viewer:u32)->Result<u8,&'static str> {
        if snapshot.roster.len()>64{return Err("E current roster budget");}
        let mut seen=BTreeSet::new();
        for p in &snapshot.roster {if p.id==0||p.team>1||!seen.insert(p.id){return Err("E current roster invalid");}}
        snapshot.roster.iter().find(|p|p.id==viewer).map(|p|p.team).ok_or("E current viewer absent")
    }
    pub fn observe_accepted_frame(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,
        paused:bool,healthy:bool,delivery:Option<(Context,u64)>)->Result<(),&'static str> {
        let result=self.observe(snapshot,viewer,now,paused,healthy,delivery);
        if result.is_err(){self.suspend();}result
    }
    fn observe(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,paused:bool,
        healthy:bool,delivery:Option<(Context,u64)>)->Result<(),&'static str> {
        if !healthy||!now.is_finite()||now<0.||self.last_now.is_some_and(|old|now<old)
            ||self.session!=Some(snapshot.session)||self.viewer!=Some(viewer)
            ||self.last_tick.is_some_and(|old|snapshot.tick<old) {
            return Err("E current boundary unavailable");
        }
        let Some((context,frame))=delivery else {self.suspend();return Ok(());};
        if !context.valid()||context.session!=snapshot.session||context.player!=viewer
            ||self.epoch!=Some(context.epoch)||frame==0
            ||self.last_frame.is_some_and(|old|frame<=old) {return Err("E requires fresh atomic frame");}
        self.last_frame=Some(frame); // malformed optional data still consumes its frame
        crate::ezreal_e_bolt_profile::inventory()?; // inert DATA only; no renderer
        let team=Self::audience(snapshot,viewer)?;
        if self.team!=Some(team){self.suspend();self.team=Some(team);}
        if snapshot.winner.is_some()||self.ended {self.suspend();self.ended=true;return Ok(());}
        let advancing=self.last_tick.is_some_and(|old|snapshot.tick>old);
        let incoming=match &snapshot.ezreal_e_current_bolts {Some(value)=>wire::decode(value)?,None=>vec![]};
        let mut facts=BTreeMap::new();
        for row in incoming {
            if !snapshot.roster.iter().any(|p|p.id==row.owner&&p.team==row.team&&p.champion=="ezreal") {
                return Err("E current owner roster mismatch");
            }
            let key=Key{session:snapshot.session,owner:row.owner,team:row.team,ordinal:row.ordinal};
            if self.facts.keys().any(|old|old.ordinal==key.ordinal&&*old!=key) {
                return Err("E current identity changed within an episode");
            }
            // E is homing: direction may change on an actual new simulation tick.
            // A same-tick permission frame cannot rewrite the sampled pose.
            if !advancing&&self.facts.get(&key).is_some_and(|old|*old!=row) {
                return Err("E same-tick current sample changed");
            }
            facts.insert(key,row);
        }
        if self.at.is_some()&&!self.fresh(now){self.suspend();}
        self.last_tick=Some(snapshot.tick);self.last_now=Some(now);
        if paused {self.suspend();self.facts=facts;return Ok(());}
        if self.baseline {
            // First frame after start/epoch/gap/pause is a baseline, not a birth
            // history. A later advancing sample can start a new local episode.
            self.rows.clear();self.facts=facts;self.baseline=false;self.at=Some(now);return Ok(());
        }
        if !advancing {
            self.rows.retain(|key,_|facts.contains_key(key));
            for row in self.rows.values_mut(){row.authorization_frame=frame;}
            self.facts=facts;return Ok(()); // never refresh the age of a same-tick sample
        }
        let mut rows=BTreeMap::new();let mut next=self.next;
        for (key,row) in &facts {
            let incarnation=if let Some(old)=self.rows.get(key){old.incarnation}
                else {next=next.checked_add(1).ok_or("E current episode exhausted")?;next};
            rows.insert(*key,CurrentE{key:*key,epoch:context.epoch,incarnation,
                position:row.position,y_native:row.y_native,direction:row.direction,
                sample_tick:snapshot.tick,sample_frame:frame,authorization_frame:frame});
        }
        // Commit the entire bounded frame only after all rows/counters pass.
        self.rows=rows;self.facts=facts;self.next=next;self.at=Some(now);Ok(())
    }
    pub fn samples(&self,snapshot:&Snapshot,viewer:u32,session:u64,epoch:Option<u64>,
        now:f64,paused:bool,healthy:bool)->Vec<CurrentE> {
        if !healthy||paused||!now.is_finite()||!self.fresh(now)||self.baseline||self.ended
            ||snapshot.winner.is_some()||self.session!=Some(session)||snapshot.session!=session
            ||self.viewer!=Some(viewer)||epoch.is_none()||self.epoch!=epoch
            ||self.last_tick!=Some(snapshot.tick)||self.last_now.is_none_or(|old|now<old)
            ||Self::audience(snapshot,viewer).ok()!=self.team {return vec![];}
        self.rows.values().copied().collect()
    }
}

#[cfg(test)]
#[path="ezreal_e_bolt_presentation_tests.rs"]
mod tests;
