//! Scratch seven-group composition. Uses current concrete Simple host directly.
//! Complex native source creation is a mandatory provider, never a fallback.
use openleague_core::native_random::Rng55;
use crate::{relic_pickup_complex_profiles as complex_profiles,relic_pickup_complex_simulation as complex,
    relic_pickup_simulation as simple,relic_pickup_profiles as simple_profiles,relic_pickup_forces as forces};
#[derive(Debug,Clone,Copy,PartialEq,Eq,PartialOrd,Ord)]
pub struct Key {pub session:u64,pub tick:u64,pub actor:u32}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Owner {pub root_token:u64,pub model_token:u64,pub matrix:[u32;16],pub position:[u32;3]}
pub type Requests=std::collections::BTreeMap<Key,Option<Owner>>;
#[derive(Clone,Copy)]
pub struct FrameSource {pub instance:complex::Instance,pub particles:complex::FrameInputs}
/// Implementations must be pure apart from the supplied private RNG. Their
/// return values are owned by the plan; no external draw mutation is permitted.
pub struct Created<C> {pub instance:complex::Instance,pub context:C}
pub trait Sources {
    type Context:Clone;
    fn create(&self,group:usize,owner:Owner,time:f32,rng:&mut Rng55)->Result<Created<Self::Context>,String>;
    fn prepare_birth(&self,group:usize,context:&mut Self::Context,instance:complex::Instance,owner:Owner,birth:&complex::SampledBirth,
        emitter_ordinal:u32,rng:&mut Rng55)->Result<complex::PreparedBirth,&'static str>;
    fn frame(&self,group:usize,context:&mut Self::Context,instance:complex::Instance,previous:Owner,current:Owner,time:f32,rng:&mut Rng55)
        ->Result<FrameSource,String>;
}
#[derive(Clone)]
pub struct Effect<C:Clone> {pub owner:Owner,pub start:f32,pub simple_profiles:[simple_profiles::Profile;4],
    pub simple_forces:[forces::Population;4],pub simple_hosts:[simple::Host;4],
    pub complex_contexts:[C;3],pub complex_profiles:[complex_profiles::Profile;3],pub complex_instances:[complex::Instance;3],pub complex_hosts:[complex::Host;3]}
#[derive(Clone)]
pub struct Host<C:Clone> {effects:std::collections::BTreeMap<Key,Effect<C>>,pub rng:Rng55,pub ordinal:u64,pub time:Option<f32>}
pub struct Planned<C:Clone> {pub next:Host<C>,pub completed:Vec<Key>,pub retired:Vec<Key>,pub order:Vec<(Key,usize)>,
    base_ordinal:u64,base_rng:(u32,u32,[u32;55]),requests:Requests}
fn simple_owner(owner:Owner)->simple::Owner {
    let identity=std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0});
    simple::Owner {system_matrix:owner.matrix,position:owner.position,inverse_fallback:identity}
}
impl<C:Clone> Planned<C> {
    pub fn validate(&self,host:&Host<C>,requests:&Requests)->Result<(),String> {
        if host.ordinal!=self.base_ordinal || (host.rng.first,host.rng.second,host.rng.words)!=self.base_rng
            || requests!=&self.requests {return Err("stale seven-group pickup plan/owner/RNG".into());}
        Ok(())
    }
}
impl<C:Clone> Host<C> {
    pub fn effects(&self)->&std::collections::BTreeMap<Key,Effect<C>> {&self.effects}
    pub fn new(rng:Rng55)->Self {Self {effects:std::collections::BTreeMap::new(),rng,ordinal:0,time:None}}
    pub fn planned(&self,time:f32,requests:&Requests,source:&impl Sources<Context=C>)->Result<Planned<C>,String> {
        if !time.is_finite() || self.time.is_some_and(|last|time<last) {return Err("invalid seven-group time".into());}
        let mut next=self.clone();next.ordinal=next.ordinal.checked_add(1).ok_or("seven-group ordinal overflow")?;
        next.time=Some(time);next.effects.retain(|key,_|requests.get(key).is_some_and(Option::is_some));let mut order=Vec::new();
        for (&key,&owner) in requests {
            let Some(owner)=owner else{continue;};
            if owner.position.iter().chain(&owner.matrix).any(|v|!f32::from_bits(*v).is_finite()) {return Err("nonfinite seven-group owner".into());}
            if next.effects.get(&key).is_some_and(|effect|effect.owner.root_token!=owner.root_token || effect.owner.model_token!=owner.model_token) {
                return Err("seven-group owner binding changed".into());
            }
            if !next.effects.contains_key(&key) {
                let simple_profiles=(0..4).map(simple_profiles::Profile::load).collect::<Result<Vec<_>,_>>()?.try_into().map_err(|_|"simple profile count")?;
                let complex_profiles=(0..3).map(|i|complex_profiles::Profile::load(i).map_err(str::to_owned)).collect::<Result<Vec<_>,_>>()?.try_into().map_err(|_|"Complex profile count")?;
                let mut simple_force=Vec::new();let mut complex_instance=Vec::new();
                // Native source order: both heal Simple, all three heal Complex,
                // then both mana Simple. Creation draws stay in this order.
                for index in 0..7 {match index {
                    0|1=>simple_force.push(crate::relic_pickup_force_sources::population(index,&mut next.rng)?),
                    2..=4=>complex_instance.push(source.create(index-2,owner,time,&mut next.rng)?),
                    5|6=>simple_force.push(crate::relic_pickup_force_sources::population(index-3,&mut next.rng)?),
                    _=>unreachable!(),
                }}
                let simple_hosts=(0..4).map(|_|simple::Host::new(&simple_owner(owner),time).map_err(str::to_owned)).collect::<Result<Vec<_>,_>>()?.try_into().map_err(|_|"simple host count")?;
                let complex_hosts=(0..3).map(|_|complex::Host::new(time,owner.position.map(f32::from_bits))).collect::<Vec<_>>().try_into().map_err(|_|"Complex host count")?;
                next.effects.insert(key,Effect {owner,start:time,simple_profiles,simple_forces:simple_force.try_into().map_err(|_|"simple force count")?,simple_hosts,
                    complex_profiles,complex_contexts:complex_instance.iter().map(|c|c.context.clone()).collect::<Vec<_>>().try_into().map_err(|_|"Complex context count")?,
                    complex_instances:complex_instance.into_iter().map(|c|c.instance).collect::<Vec<_>>().try_into().map_err(|_|"Complex instance count")?,complex_hosts});
            }
            let effect=next.effects.get_mut(&key).unwrap();
            for index in 0..7 {
                order.push((key,index));
                match index {
                    2..=4=>{let c=index-2;let instance=effect.complex_instances[c];
                        let frame=source.frame(c,&mut effect.complex_contexts[c],instance,effect.owner,owner,time,&mut next.rng)?;
                        let instance=frame.instance;effect.complex_instances[c]=instance;
                        let (host,rng)=effect.complex_hosts[c].planned_frame(next.ordinal,&effect.complex_profiles[c],time,
                            owner.position.map(f32::from_bits),instance,frame.particles,&next.rng,
                            |birth,ordinal,rng|source.prepare_birth(c,&mut effect.complex_contexts[c],instance,owner,birth,ordinal,rng))
                            .map_err(str::to_owned)?.ok_or("Complex seven-group ordinal disagreement")?;
                        effect.complex_hosts[c]=host;next.rng=rng;
                    },
                    _=>{let s=if index<2 {index}else{index-3};let profile=&effect.simple_profiles[s];let life=profile.authored_life()?;
                        let rotation=profile.rotation_sources();let force=effect.simple_forces[s].frame(((time-effect.start)/life).clamp(0.,1.)).map_err(str::to_owned)?;
                        let graph=force.graph();let definition=profile.definition(simple_profiles::Instance {life,resource_flags:0,
                            factors:openleague_core::native_simple_birth_factors::Sources {context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},
                            force_resource:u32::from(!effect.simple_forces[s].is_empty()),forces:(!effect.simple_forces[s].is_empty()).then_some(&graph),reset_value:0,
                            manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]},&rotation)?;
                        let (host,rng)=effect.simple_hosts[s].planned(next.ordinal,time,effect.start,&profile.parameters,&definition,&simple_owner(owner),&next.rng,
                            &mut |_|Err("selected native pickup terrain false")).map_err(str::to_owned)?.ok_or("Simple seven-group ordinal disagreement")?;
                        effect.simple_hosts[s]=host;next.rng=rng;
                    },
                }
            }
            effect.owner=owner;
        }
        let completed=next.effects.iter().filter(|(_,effect)|effect.simple_hosts.iter().all(simple::Host::finished)
            && effect.complex_hosts.iter().zip(&effect.complex_profiles).all(|(host,profile)|host.finished(profile,time)))
            .map(|(&key,_)|key).collect::<Vec<_>>();
        for key in &completed {next.effects.remove(key);}
        let retired=self.effects.keys().filter(|key|!next.effects.contains_key(*key)).copied().collect();
        Ok(Planned {next,completed,retired,order,base_ordinal:self.ordinal,base_rng:(self.rng.first,self.rng.second,self.rng.words),requests:requests.clone()})
    }
    pub fn commit(&mut self,plan:Planned<C>,requests:&Requests)->Result<(),String> {plan.validate(self,requests)?;*self=plan.next;Ok(())}
}
