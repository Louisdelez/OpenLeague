//! Selected mist sampler/instance adapter. Every owner and local policy is explicit.
//! Generic Complex buffers are reused; no heal profile loader is called.
use crate::{spawn_mist_sources as mist,relic_pickup_complex_profiles as profiles,
 relic_pickup_complex_simulation as simulation,relic_pickup_complex_sources as source,
 relic_pickup_seven_host::{self as seven,Sources as _},relic_pickup_complex_source_matrix as matrix};
use openleague_core::native_random::Rng55;
use serde_json::Value;
use crate::spawn_mist_surface;

#[derive(Clone)]pub struct HostSource{pub native:mist::Profile,pub profile:profiles::Profile,pub sources:source::Sources,pub getter_source:GetterSource}
fn word(v:&Value)->Result<u32,String>{v.as_u64().and_then(|n|u32::try_from(n).ok()).ok_or("native mist word absent".into())}
impl HostSource{
 pub fn new(native:mist::Profile,factory:&Value,policy:source::LocalPolicy)->Result<Self,String>{
  let row=factory["cases"].as_array().ok_or("mist factory cases absent")?.iter().find(|r|r["effect"]==native.effect.name()&&r["group"]=="mist"&&r["provider_capability"]==native.factory.provider_capability).ok_or("mist source context absent")?;
  let scalar=|key:&str|word(&row["primary_scalars"][key]);
  let definition=source::Definition{index:0,primary:matrix::PrimaryFields{position:native.factory.primary_position,rotation_degrees:native.factory.primary_rotation_degrees,scale:native.factory.primary_scale},modulation:native.factory.source_modulation,provider_capability:native.factory.provider_capability,primary_mult_texture_pointer:native.factory.mult_texture_pointer,
   life:f32::from_bits(scalar("0x2f0")?),life_scaled:scalar("0x2f4")?&255!=0,local_emitter:native.factory.local_emitter,
   limit:scalar("0x314")?as i32,single:scalar("0x334")?,end_override:f32::from_bits(scalar("0x33c")?),rotations:vec![],native_instance_channels:native.factory.native_instance_c0};
  if !row["rotation_list"].as_array().ok_or("mist rotation list absent")?.is_empty(){return Err("mist rotation source outside selected scope".into());}
  let profile=profiles::Profile{index:0,group:"mist",fields:native.fields.clone(),vectors:native.vectors.clone(),birth_color:native.birth_color.clone(),lifetime_color:native.lifetime_color.clone(),lifetime_scale:native.lifetime_scale.clone(),timing:native.timing.clone(),linger:native.linger.clone(),life:native.life.clone(),rate:native.rate.clone(),bind:native.bind.clone(),uv:native.uv.clone(),start_frame:native.factory.native_start_frame,num_frames:native.factory.native_num_frames,frame_rate:native.factory.native_frame_rate,local_emitter_orientation:native.factory.local_emitter,lookup:profiles::Lookup{modes:native.lookup.modes,scale:native.lookup.scale,offset:native.lookup.offset}};
  let getter_source=GetterSource{attribute_enabled:word(&row["primary_raw_words"][0x478/4])?&255!=0,attribute_key:word(&row["primary_raw_words"][0x45c/4])?};
  Ok(Self{native,profile,sources:source::Sources{definitions:[definition.clone(),definition.clone(),definition],policy},getter_source})
 }
 pub fn create(&self,owner:seven::Owner,start:f32,rng:&mut Rng55)->Result<seven::Created<source::Context>,String>{self.sources.create(0,owner,start,rng)}
 pub fn birth(&self,context:&mut source::Context,instance:simulation::Instance,owner:seven::Owner,birth:&simulation::SampledBirth,ordinal:u32,rng:&mut Rng55)->Result<simulation::PreparedBirth,&'static str>{
  self.sources.prepare_birth(0,context,instance,owner,birth,ordinal,rng)
 }
 pub fn frame(&self,context:&mut source::Context,mut instance:simulation::Instance,previous:seven::Owner,current:seven::Owner,time:f32)->Result<seven::FrameSource,String>{
  if context.binding!=[current.root_token,current.model_token]||context.binding!=[previous.root_token,previous.model_token]{return Err("mist owner binding changed".into());}
  if current.matrix.iter().chain(&current.position).chain(&previous.matrix).chain(&previous.position).any(|b|!f32::from_bits(*b).is_finite()){return Err("mist owner pose nonfinite".into());}
  context.instance_matrix=matrix::compose(context.definition.primary).map_err(str::to_owned)?.words();
  instance.past_end=openleague_core::native_complex_instance_life::evaluate_end_flag(time,context.start,instance.duration,self.sources.policy.owner_flags,context.definition.end_override).past_end;
  Ok(seven::FrameSource{instance,particles:simulation::FrameInputs{owner_delta:std::array::from_fn(|a|f32::from_bits(current.position[a])-f32::from_bits(previous.position[a])),owner_extra:self.sources.policy.owner_extra,default_vector:std::array::from_fn(|i|f32::from_bits(context.definition.native_instance_channels[i])),scale_owner:self.sources.policy.scale_owner,lookup_modes:self.native.lookup.modes,lookup_scale:self.native.lookup.scale,lookup_offset:self.native.lookup.offset,surface_direct:false,local_matrix:None,attach_matrix:None}})
 }
}

/// Owned state for one real effect/owner binding. The caller publishes every
/// effect plan and the shared RNG together after renderer preparation succeeds.
pub struct EffectState{pub host:simulation::Host,pub created:seven::Created<source::Context>,pub owner:seven::Owner}
impl Clone for EffectState{fn clone(&self)->Self{Self{host:self.host.clone(),created:seven::Created{instance:self.created.instance,context:self.created.context.clone()},owner:self.owner}}}
#[derive(Clone)]pub struct PlannedFrame{pub state:EffectState,pub rng:Rng55}
impl EffectState{
 pub fn new(source:&HostSource,owner:seven::Owner,start:f32,rng:&mut Rng55)->Result<Self,String>{
  let mut next_rng=rng.clone();let created=source.create(owner,start,&mut next_rng)?;
  let state=Self{host:simulation::Host::new(start,owner.position.map(f32::from_bits)),created,owner};
  *rng=next_rng;Ok(state)
 }
 pub fn planned_frame(&self,source:&HostSource,ordinal:u64,time:f32,owner:seven::Owner,rng:&Rng55)->Result<Option<PlannedFrame>,String>{
  let mut state=self.clone();
  let frame=source.frame(&mut state.created.context,state.created.instance,self.owner,owner,time)?;
  state.created.instance=frame.instance;
  let plan=state.host.planned_frame(ordinal,&source.profile,time,owner.position.map(f32::from_bits),frame.instance,frame.particles,rng,
   |birth,id,random|source.birth(&mut state.created.context,state.created.instance,owner,birth,id,random)).map_err(str::to_owned)?;
  let Some((host,rng))=plan else{return Ok(None);};state.host=host;state.owner=owner;
  Ok(Some(PlannedFrame{state,rng}))
 }
 pub fn surfaces(&self,source:GetterSource,mut lookup:impl FnMut(seven::Owner,u32)->Result<Option<f32>,String>)->Result<Vec<[u32;56]>,String>{
  self.host.storage.particles.iter().map(|record|{
   let attribute=if source.attribute_enabled{Some(spawn_mist_surface::AttributeLookup{key:source.attribute_key,value:lookup(self.owner,source.attribute_key)?})}else{None};
   spawn_mist_surface::prepare(record,spawn_mist_surface::Inputs{attribute_enabled:source.attribute_enabled,attribute_key:source.attribute_key,lookup:attribute}).map_err(str::to_owned)
  }).collect()
 }
}
/// Mandatory getter context; PRIMARY and NESTED are distinct native objects.
/// Original primary+478/key45C production is not inferred from nested flags.
#[derive(Clone,Copy)]pub struct GetterSource{pub attribute_enabled:bool,pub attribute_key:u32}

#[cfg(test)]
#[path="spawn_mist_host_tests.rs"]mod tests;
