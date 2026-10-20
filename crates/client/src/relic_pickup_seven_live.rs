//! Accepted Bevy owner/request adapter for the owned seven-group host.
//! Installing this module requires a real Sources implementation and its evidence.
use bevy::{prelude::*,asset::AssetId};
use crate::{relic_pickup_events as events,relic_pickup_seven_host as seven,relic_pickup_seven_identity::{Group,GROUPS},
    relic_pickup_profiles as simple_profiles,relic_pickup_simulation as simple,
    relic_pickup_complex_profiles as complex_profiles,relic_pickup_complex_simulation as complex};
use openleague_core::native_random::Rng55;
#[derive(Clone,Default)]struct Models {entries:Vec<AssetId<Gltf>>}
impl Models {fn token(&mut self,model:AssetId<Gltf>)->Result<u64,String>{
    if let Some(index)=self.entries.iter().position(|id|*id==model){return Ok(index as u64+1);}
    self.entries.try_reserve(1).map_err(|_|"pickup model identity allocation")?;self.entries.push(model);
    u64::try_from(self.entries.len()).map_err(|_|"pickup model identity overflow".into())
}}
type Token=(events::Key,events::Key,u64,Option<(events::Binding,[u32;16],[u32;3])>);
fn tokens(host:&events::Host)->Vec<Token>{host.requests.iter().map(|(key,r)|(*key,r.key,r.observed_snapshot_tick,
    r.owner.map(|o|(o.binding,o.native_matrix,o.native_position)))).collect()}
fn key(key:events::Key)->seven::Key {seven::Key {session:key.session,tick:key.pickup_tick,actor:key.picker}}
fn event_key(key:seven::Key)->events::Key {events::Key {session:key.session,pickup_tick:key.tick,picker:key.actor}}
fn requests(host:&events::Host,models:&mut Models)->Result<seven::Requests,String>{host.requests.iter().map(|(k,r)| {
    if *k!=r.key {return Err("pickup request key changed".into());}
    let owner=r.owner.map(|o|Ok::<seven::Owner,String>(seven::Owner {root_token:o.binding.root.to_bits(),model_token:models.token(o.binding.model)?,
        matrix:o.native_matrix,position:o.native_position})).transpose()?;
    Ok((key(*k),owner))
}).collect()}
/// Evidence ID supplied by the qualified native source adapter. Pending status
/// cannot seed, advance simulations, acquire Complex textures or publish draws.
#[derive(Clone,Debug)]pub enum Admission {Pending(String),Qualified {source_evidence:String}}
#[derive(Resource)]
pub struct Live<S> where S:seven::Sources+Send+Sync+'static,S::Context:Send+Sync+'static {
    pub host:seven::Host<S::Context>,source:S,models:Models,last_clock:Option<f64>,pub admission:Admission,pub error:Option<String>,
}
pub struct Planned<C:Clone> {pub next:seven::Planned<C>,models:Models,requests:Vec<Token>,owners:std::collections::BTreeMap<events::Key,events::OwnerFrame>,pub time:f32,now:f64}
pub enum GroupState<'a,C:Clone> {
    Simple {profile:&'a simple_profiles::Profile,host:&'a simple::Host},
    Complex {profile:&'a complex_profiles::Profile,host:&'a complex::Host,context:&'a C},
}
pub struct DrawGroup<'a,C:Clone>{pub key:events::Key,pub owner:events::OwnerFrame,pub group:Group,pub state:GroupState<'a,C>}
impl<C:Clone> Planned<C> {
    pub fn groups(&self)->impl Iterator<Item=DrawGroup<'_,C>> {
        self.next.next.effects().iter().flat_map(|(key,effect)|{
            let key=event_key(*key);let owner=self.owners[&key];
            GROUPS.into_iter().map(move |group|DrawGroup {key,owner,group,state:if let Some(i)=group.simple_index() {
                GroupState::Simple {profile:&effect.simple_profiles[i],host:&effect.simple_hosts[i]}
            }else {let i=group.complex_index().unwrap();GroupState::Complex {profile:&effect.complex_profiles[i],host:&effect.complex_hosts[i],context:&effect.complex_contexts[i]}}})
        })
    }
}
impl<S> Live<S> where S:seven::Sources+Send+Sync+'static,S::Context:Send+Sync+'static {
    pub fn new(source:S,rng:Rng55,admission:Admission)->Self {Self {host:seven::Host::new(rng),source,models:Models::default(),last_clock:None,admission,error:None}}
    pub fn planned(&self,host:&events::Host,now:f64)->Result<Planned<S::Context>,String>{
        match &self.admission {Admission::Pending(reason)=>return Err(format!("seven-group source not admitted: {reason}")),
            Admission::Qualified {source_evidence} if source_evidence.is_empty()=>return Err("seven-group source evidence absent".into()),_=>{}}
        if !now.is_finite()||now<0.||now>f32::MAX as f64||self.last_clock.is_some_and(|v|now<v){return Err("seven-group native clock invalid".into());}
        let mut models=self.models.clone();let request=requests(host,&mut models)?;
        let next=self.host.planned(now as f32,&request,&self.source)?;
        let owners=host.requests.iter().filter_map(|(key,r)|r.owner.map(|owner|(*key,owner))).collect();
        Ok(Planned {next,models,requests:tokens(host),owners,time:now as f32,now})
    }
    pub fn validate(&self,plan:&Planned<S::Context>,host:&events::Host)->Result<(),String>{
        if plan.requests!=tokens(host){return Err("seven-group accepted owner/snapshot changed".into());}
        let mut models=self.models.clone();let request=requests(host,&mut models)?;plan.next.validate(&self.host,&request)?;
        if plan.next.completed.iter().any(|key|!host.requests.contains_key(&event_key(*key))){return Err("seven-group completion became stale".into());}Ok(())
    }
    /// Exclusive-world caller validates immediately before draw publication and
    /// commits without intervening request/source mutation. No reseeding occurs.
    pub fn commit(&mut self,plan:Planned<S::Context>,host:&mut events::Host)->Result<(),String>{
        self.validate(&plan,host)?;let mut models=self.models.clone();let request=requests(host,&mut models)?;
        for key in &plan.next.completed {host.complete(event_key(*key)).expect("validated unique completion");}
        self.host.commit(plan.next,&request)?;self.models=plan.models;self.last_clock=Some(plan.now);Ok(())
    }
}
