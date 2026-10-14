//! Ordinary pickup draw publication. Original trigger parity remains unqualified.
use bevy::{prelude::*,asset::AssetId,image::{CompressedImageFormats,ImageSampler},camera::primitives::MeshAabb};
use crate::{relic_pickup_events as events,relic_pickup_seven_live as live,relic_pickup_simple_draw as draw,
 relic_rune_image_bindings::Bindings,relic_image_reference_store::Store,nexus_glow_material::{GlowMaterial,Inputs}};
#[derive(Clone,Copy,Debug,PartialEq,Eq)]pub struct ExpectedImage {pub source:[u32;3],pub storage:[u32;3],pub mips:u32,pub format:bevy::render::render_resource::TextureFormat}
pub struct Texture {pub requested:std::ffi::CString,pub canonical:std::ffi::CString,pub bytes:std::sync::Arc<[u8]>,pub sampler:ImageSampler,pub is_srgb:bool}
pub struct ComplexFrame {pub native_modulation:[f32;4],pub system_bc:f32,pub system_c0:f32,pub primary_mult_texture_pointer:u32}
/// Real resource/material producers are mandatory. In particular no default
/// palette, unit scale or white modulation is selected by this renderer.
pub trait RenderSources<C:Clone>:Send+Sync+'static {
 fn textures(&self,group:crate::relic_pickup_seven_identity::Group)->Result<[Texture;2],String>;
 fn material(&self,group:crate::relic_pickup_seven_identity::Group,native_extent:f32)->Result<Inputs,String>;
 fn simple_frame(&self,key:events::Key,owner:events::OwnerFrame,group:crate::relic_pickup_seven_identity::Group,
     host:&crate::relic_pickup_simulation::Host,time:f32)->Result<draw::Frame,String>;
 fn complex_frame(&self,key:events::Key,owner:events::OwnerFrame,group:crate::relic_pickup_seven_identity::Group,
     context:&C,record:&openleague_core::native_complex_particle_storage::Record,time:f32)->Result<ComplexFrame,String>;
}
#[derive(Resource)]pub struct Source<R:Send+Sync+'static> {pub value:R,pub admission:live::Admission}
fn expected_images(binding:&Bindings,store:&Store,assets:&Assets<Image>,ids:[AssetId<Image>;2])->Result<[ExpectedImage;2],String>{
 let layouts=binding.layouts(store)?;let mut output=Vec::new();
 for i in 0..2 {let image=assets.get(ids[i]).ok_or("seven-group owned DDS disappeared")?;let d=&image.texture_descriptor;
  if layouts[i].source_has_block_padding()||d.dimension!=bevy::render::render_resource::TextureDimension::D2||d.sample_count!=1
   ||[d.size.width,d.size.height,d.size.depth_or_array_layers]!=layouts[i].storage_extent||d.mip_level_count!=layouts[i].mip_levels{return Err("seven-group DDS descriptor differs from native source layout".into());}
  output.push(ExpectedImage {source:layouts[i].source_extent,storage:layouts[i].storage_extent,mips:layouts[i].mip_levels,format:d.format});
 }Ok(output.try_into().unwrap())
}
#[derive(Component,Clone,Debug,PartialEq,Eq)]pub struct Ticket{pub key:events::Key,pub owner:events::Binding,pub group:crate::relic_pickup_seven_identity::Group,pub slot:usize,pub birth:u32,pub counter:Option<u32>,pub layouts:[ExpectedImage;2],pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:AssetId<GlowMaterial>,pub images:[AssetId<Image>;4]}
struct Owned{ticket:Ticket,mesh:Handle<Mesh>,material:Handle<GlowMaterial>}
struct Prepared{key:events::Key,owner:events::Binding,group:crate::relic_pickup_seven_identity::Group,slot:usize,birth:u32,counter:Option<u32>,layouts:[ExpectedImage;2],mesh:Mesh,bounds:bevy::camera::primitives::Aabb,material:GlowMaterial,images:[AssetId<Image>;4]}
#[derive(Resource,Default)]pub struct Backend{draws:Vec<Owned>,store:Store,bindings:Vec<Bindings>,overlay:Handle<Image>,session:Option<u64>,pub error:Option<String>,pub published_frames:u64,expected:Vec<[ExpectedImage;2]>,samplers:Vec<[ImageSampler;2]>,failed_leases:Vec<crate::relic_image_reference_store::Lease>}
impl Backend{
 pub fn tickets(&self)->Vec<Ticket>{self.draws.iter().map(|d|d.ticket.clone()).collect()}
 fn remove(world:&mut World,d:Owned){if world.get::<Ticket>(d.ticket.draw)==Some(&d.ticket){world.despawn(d.ticket.draw);}world.resource_mut::<Assets<Mesh>>().remove(d.mesh.id());world.resource_mut::<Assets<GlowMaterial>>().remove(d.material.id());}
 fn hide(&self,world:&mut World){for d in &self.draws{if let Some(mut v)=world.get_mut::<Visibility>(d.ticket.draw){*v=Visibility::Hidden;}if let Some(mut m)=world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material){m.set_admitted(false);}}}
 fn publish(&mut self,world:&mut World,packets:Vec<Prepared>)->Result<(),String>{
  let mut identities=std::collections::HashSet::new();
  for p in &packets{let playback=world.get::<crate::animation::Playback>(p.owner.root).ok_or("pickup draw owner missing")?;
   if (p.group.class()==crate::relic_pickup_seven_identity::Class::Complex)!=p.counter.is_some(){return Err("seven-group particle class/counter identity differs".into());}
   if playback.network_id()!=p.key.picker||playback.model_asset_id()!=p.owner.model||world.get::<crate::actor_fow::Root>(p.owner.root).is_none()
    ||!identities.insert((p.key,p.group,p.slot,p.birth,p.counter)){return Err("pickup draw owner or particle identity changed".into());}}
  for d in &self.draws{if world.get::<Ticket>(d.ticket.draw)!=Some(&d.ticket)||world.get::<Mesh3d>(d.ticket.draw).map(|m|m.id())!=Some(d.ticket.mesh)
   ||world.get::<MeshMaterial3d<GlowMaterial>>(d.ticket.draw).map(|m|m.id())!=Some(d.ticket.material)||world.get::<ChildOf>(d.ticket.draw).is_some()
   ||world.get::<Transform>(d.ticket.draw)!=Some(&Transform::IDENTITY)||world.get::<GlobalTransform>(d.ticket.draw)!=Some(&GlobalTransform::IDENTITY)
   ||!world.resource::<Assets<Mesh>>().contains(d.ticket.mesh)||!world.resource::<Assets<GlowMaterial>>().contains(d.ticket.material){return Err("pickup retained draw ownership changed".into());}}
  let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"pickup draw allocation failed")?;
  self.hide(world);
  for p in packets{
   let old=self.draws.iter().position(|d|d.ticket.key==p.key&&d.ticket.owner==p.owner&&d.ticket.group==p.group&&d.ticket.slot==p.slot&&d.ticket.birth==p.birth&&d.ticket.counter==p.counter);
   let d=if let Some(i)=old{let mut d=self.draws.swap_remove(i);*world.resource_mut::<Assets<Mesh>>().get_mut(&d.mesh).unwrap()=p.mesh;
    *world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material).unwrap()=p.material;d.ticket.images=p.images;d.ticket.layouts=p.layouts;world.entity_mut(d.ticket.draw).insert((p.bounds,d.ticket.clone()));d
   }else{let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);let material=world.resource_mut::<Assets<GlowMaterial>>().add(p.material);
    let entity=world.spawn((Name::new(format!("Relic {:?} {} particle",p.group.class(),p.group.name())),Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
    let ticket=Ticket{key:p.key,owner:p.owner,group:p.group,slot:p.slot,birth:p.birth,counter:p.counter,layouts:p.layouts,draw:entity,mesh:mesh.id(),material:material.id(),images:p.images};world.entity_mut(entity).insert(ticket.clone());Owned{ticket,mesh,material}
   };output.push(d);
  }
  for d in self.draws.drain(..){Self::remove(world,d);}self.draws=output;
  for d in &self.draws{world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material).unwrap().set_admitted(true);*world.get_mut::<Visibility>(d.ticket.draw).unwrap()=Visibility::Visible;}
  self.published_frames=self.published_frames.saturating_add(1);Ok(())
 }
 fn load<C:Clone>(&mut self,world:&mut World,source:&impl RenderSources<C>)->Result<(),String>{
  if self.bindings.len()==7{return Ok(());}if !self.bindings.is_empty(){return Err("pickup partial texture acquisition requires cleanup".into());}
  let compressed=CompressedImageFormats::from_features(world.get_resource::<bevy::render::renderer::RenderDevice>().ok_or("pickup GPU device absent")?.features());
  let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("seven-group real FoW source absent")?.output.clone();
  let overlay=world.resource::<AssetServer>().load("maps/terrain_native/DefaultFogOfWarOverlay.png");
  let textures=crate::relic_pickup_seven_identity::GROUPS.into_iter().map(|g|source.textures(g)).collect::<Result<Vec<_>,_>>()?;
  for [diffuse,color] in textures {
   let d=crate::relic_rune_image_bindings::Source::request(&diffuse.requested,&diffuse.canonical,&diffuse.bytes,diffuse.sampler.clone(),diffuse.is_srgb)?;
   let c=crate::relic_rune_image_bindings::Source::request(&color.requested,&color.canonical,&color.bytes,color.sampler.clone(),color.is_srgb)?;
   match Bindings::acquire(&mut self.store,&mut world.resource_mut::<Assets<Image>>(),compressed,d,c){
    Ok(bindings)=>{
     self.bindings.push(bindings);let binding=self.bindings.last().unwrap();
     let result=binding.images_render_fog(&self.store,world.resource::<Assets<Image>>(),[fog.clone(),overlay.clone()])
       .and_then(|handles|expected_images(binding,&self.store,world.resource::<Assets<Image>>(),[handles[0].id(),handles[1].id()]));
     let expected=match result {Ok(expected)=>expected,Err(error)=>{self.cleanup_images(world);return Err(error);}};
     self.expected.push(expected);self.samplers.push([diffuse.sampler,color.sampler]);
    },Err(failure)=>{let message=failure.message;self.failed_leases.extend(failure.leases);self.cleanup_images(world);return Err(message);}
   }
  }
  self.overlay=overlay;Ok(())
 }
 fn retire_images(&mut self,world:&mut World)->Result<(),String>{
  if !self.draws.is_empty(){return Err("pickup image retirement precedes draw retirement".into());}
  let mut images=world.resource_mut::<Assets<Image>>();let mut errors=vec![];
  for bindings in self.bindings.drain(..){if let Err(failure)=bindings.retire(&mut self.store,&mut images){self.failed_leases.extend(failure.leases);errors.push(failure.message);}}
  self.expected.clear();self.samplers.clear();
  self.overlay=Handle::default();if errors.is_empty(){Ok(())}else{Err(errors.join("; "))}
 }
 fn cleanup_images(&mut self,world:&mut World){let mut images=world.resource_mut::<Assets<Image>>();
  for bindings in self.bindings.drain(..){if let Err(failure)=bindings.retire(&mut self.store,&mut images){self.failed_leases.extend(failure.leases);}}
  let leases=std::mem::take(&mut self.failed_leases);for lease in leases {if let Err(error)=self.store.release(lease,&mut images){self.failed_leases.push(error.lease);}}
  self.expected.clear();self.samplers.clear();
 }
}
/// Root registers only after providing both qualified mandatory source resources.
pub struct Plugin<S,R>(std::marker::PhantomData<(S,R)>);
impl<S,R> Default for Plugin<S,R>{fn default()->Self{Self(std::marker::PhantomData)}}
impl<S,R> bevy::app::Plugin for Plugin<S,R>
where S:crate::relic_pickup_seven_host::Sources+Send+Sync+'static,S::Context:Send+Sync+'static,R:RenderSources<S::Context> {
 fn build(&self,app:&mut App){app.init_resource::<Backend>().add_systems(PostUpdate,synchronize::<S,R>.after(events::Published)
 .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds).before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}
}
pub fn synchronize<S,R>(world:&mut World)
where S:crate::relic_pickup_seven_host::Sources+Send+Sync+'static,S::Context:Send+Sync+'static,R:RenderSources<S::Context> {
 let Some(mut backend)=world.remove_resource::<Backend>()else{return};let Some(mut state)=world.remove_resource::<live::Live<S>>()else{
 write_cpu_report(world,&backend,None,world.get_resource::<events::Host>(),false);world.insert_resource(backend);return};
 let mut requests=world.remove_resource::<events::Host>().unwrap_or_default();
 let result=(||->Result<(),String>{
  let session=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity).map(|(session,_,_)|session);
  if backend.session.is_some()&&backend.session!=session{backend.publish(world,vec![])?;backend.retire_images(world)?;}backend.session=session;
  let now=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("pickup game clock absent")?.now;
  let plan=state.planned(&requests,now)?;
  if plan.groups().next().is_none(){state.validate(&plan,&requests)?;backend.publish(world,vec![])?;state.commit(plan,&mut requests)?;return Ok(());}
  let source=world.remove_resource::<Source<R>>().ok_or("seven-group render sources absent")?;
  let result=match &source.admission {live::Admission::Pending(reason)=>Err(format!("seven-group render source not admitted: {reason}")),
   live::Admission::Qualified {source_evidence} if source_evidence.is_empty()=>Err("seven-group render evidence absent".into()),
   _=>prepare::<S,R>(world,&mut backend,&state,&requests,plan,&source.value)};
  world.insert_resource(source);let plan=result?;state.commit(plan,&mut requests)?;return Ok(());
 })();if result.is_err(){backend.hide(world);}backend.error=result.err();state.error=backend.error.clone();
 write_cpu_report(world,&backend,Some(state.host.ordinal),Some(&requests),backend.error.is_none());
 world.insert_resource(backend);world.insert_resource(state);world.insert_resource(requests);
}
fn prepare<S,R>(world:&mut World,backend:&mut Backend,state:&live::Live<S>,requests:&events::Host,plan:live::Planned<S::Context>,source:&R)->Result<live::Planned<S::Context>,String>
where S:crate::relic_pickup_seven_host::Sources+Send+Sync+'static,S::Context:Send+Sync+'static,R:RenderSources<S::Context> {
  backend.load(world,source)?;
  let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("pickup current FoW absent")?.output.clone();
  let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("pickup native map extent absent")?.geometry.extent;
  let view=world.get_resource::<crate::camera_native::NativeCamera>().and_then(|c|c.native_parameters()).map(openleague_core::camera_view::from_parameters).transpose().map_err(str::to_owned)?;
  let camera=world.get_resource::<crate::camera_native::NativeCamera>().and_then(|c|c.native_parameters())
   .ok_or("seven-group native camera absent")?;
  let mut packets=Vec::new();
  for group in plan.groups() {
   let binding=&backend.bindings[group.group.index()];
   let handles=binding.images_render_fog(&backend.store,world.resource::<Assets<Image>>(),[fog.clone(),backend.overlay.clone()])?;
   let layouts=expected_images(binding,&backend.store,world.resource::<Assets<Image>>(),[handles[0].id(),handles[1].id()])?;
   if layouts!=backend.expected[group.group.index()]{return Err("seven-group DDS layout mutated outside owner".into());}
   for i in 0..2 {if world.resource::<Assets<Image>>().get(handles[i].id()).ok_or("seven-group DDS sampler absent")?.sampler!=backend.samplers[group.group.index()][i]{return Err("seven-group native sampler changed".into());}}
   let images=handles.map(|h|h.id());
   let input=source.material(group.group,extent)?;
   let material=GlowMaterial::new_owned_render_fog(binding,&backend.store,world.resource::<Assets<Image>>(),[fog.clone(),backend.overlay.clone()],input)?;
   match group.state {
    live::GroupState::Simple {profile,host}=>{
     let profile=match profile.index {0=>draw::Profile::HealStarTrail,1=>draw::Profile::HealMesh,2=>draw::Profile::ManaStarSwirl,3=>draw::Profile::ManaShafts,_=>return Err("seven-group Simple identity escaped".into())};
     let storage=host.state.particles.as_ref().ok_or("seven-group Simple storage absent")?;
     let frame=source.simple_frame(group.key,group.owner,group.group,host,plan.time)?;
     for i in 0..storage.ages.len(){let Some(packet)=draw::packet(draw::Config::for_profile(profile),draw::particle(storage,i).map_err(str::to_owned)?,frame,view).map_err(str::to_owned)?else{continue};
      let geometry=crate::nexus_glow_quad::from_packet(openleague_core::native_complex_type0_quad::Quad {words:packet.native.words},packet.atlas).map_err(str::to_owned)?;
      let bounds=geometry.mesh.compute_aabb().ok_or("seven-group mesh bounds absent")?;
      packets.push(Prepared {key:group.key,owner:group.owner.binding,group:group.group,slot:i,birth:host.state.birth[i],counter:None,layouts,mesh:geometry.mesh,bounds,material:material.clone(),images});
     }
    },
    live::GroupState::Complex {profile,host,context}=>{
     for (i,record) in host.storage.particles.iter().enumerate(){
      let frame=source.complex_frame(group.key,group.owner,group.group,context,record,plan.time)?;
      let prepared=crate::relic_pickup_complex_rgba::mode0(std::array::from_fn(|a|f32::from_bits(record.color[4+a])),frame.native_modulation).map_err(str::to_owned)?;
      let scaled=crate::relic_pickup_complex_draw_inputs::scales(std::array::from_fn(|a|f32::from_bits(record.scale[3+a])),frame.system_bc,frame.system_c0).map_err(str::to_owned)?;
      let corners=crate::relic_pickup_complex_draw_inputs::channel_corners(frame.primary_mult_texture_pointer);
      let packet=crate::relic_pickup_seven_draw::packet(record,camera.position,scaled,prepared,corners).map_err(str::to_owned)?;
      let divisions=crate::relic_pickup_complex_profiles::numeric(&profile.fields,"p-texdiv").ok_or("Complex atlas source absent")?;
      let geometry=crate::nexus_glow_quad::from_packet(openleague_core::native_complex_type0_quad::Quad {words:packet.words},[divisions[0] as u16,divisions[1] as u16]).map_err(str::to_owned)?;
      let bounds=geometry.mesh.compute_aabb().ok_or("Complex mesh bounds absent")?;
      packets.push(Prepared {key:group.key,owner:group.owner.binding,group:group.group,slot:i,birth:record.life[0],counter:Some(record.field_88[0]),layouts,mesh:geometry.mesh,bounds,material:material.clone(),images});
     }
    },
   }
  }
  state.validate(&plan,requests)?;backend.publish(world,packets)?;Ok(plan)
}

/// Actual publication/commit diagnostics, not a simulation or GPU-ready fixture.
/// Hidden retained tickets remain identifiable after failure; committed=false
/// and error prevent them from being reported as a successful new frame.
fn write_cpu_report(world:&World,backend:&Backend,ordinal:Option<u64>,requests:Option<&events::Host>,committed:bool){
 let Ok(path)=std::env::var("OPENLEAGUE_RELIC_PICKUP_CPU_PROBE")else{return};
 let draws=backend.draws.iter().map(|d|serde_json::json!({"session":d.ticket.key.session,"pickup_tick":d.ticket.key.pickup_tick,
  "picker":d.ticket.key.picker,"group":d.ticket.group.index(),"source_class":format!("{:?}",d.ticket.group.class()),"source_group":d.ticket.group.name(),
  "slot":d.ticket.slot,"counter":d.ticket.counter,"birth_word":d.ticket.birth,"draw":d.ticket.draw.to_bits(),
  "visible":world.get::<Visibility>(d.ticket.draw).is_some_and(|v|*v==Visibility::Visible),
  "material_admitted":world.get_resource::<Assets<GlowMaterial>>().and_then(|a|a.get(d.material.id())).is_some_and(GlowMaterial::is_admitted)})).collect::<Vec<_>>();
 let doc=serde_json::json!({"schema":"map10_pickup_seven_cpu_v1","ordinary_pickup_host":true,"original_trigger_parity":false,
  "group_count":7,"ordinal":ordinal,"requests":requests.map(|r|r.requests.len()),"committed":committed,"published_frames":backend.published_frames,
  "error":backend.error,"draws":draws});
 if let Ok(bytes)=serde_json::to_vec_pretty(&doc){
  let path=std::path::Path::new(&path);let pending=path.with_extension("json.pending");
  let _=std::fs::write(&pending,bytes).and_then(|_|std::fs::rename(pending,path));
 }
}
