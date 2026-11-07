//! Ordinary pickup draw publication. Original trigger parity remains unqualified.
use bevy::{prelude::*,asset::AssetId,image::{CompressedImageFormats,ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode},camera::primitives::MeshAabb};
use crate::{relic_pickup_events as events,relic_pickup_live as live,relic_pickup_simple_draw as draw,
 relic_rune_image_bindings::Bindings,relic_image_reference_store::Store,nexus_glow_material::{GlowMaterial,Inputs}};
#[derive(Component,Clone,Debug,PartialEq,Eq)]pub struct Ticket{pub key:events::Key,pub owner:events::Binding,pub group:usize,pub slot:usize,pub birth:u32,pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:AssetId<GlowMaterial>,pub images:[AssetId<Image>;4]}
struct Owned{ticket:Ticket,mesh:Handle<Mesh>,material:Handle<GlowMaterial>}
struct Prepared{key:events::Key,owner:events::Binding,group:usize,slot:usize,birth:u32,mesh:Mesh,bounds:bevy::camera::primitives::Aabb,material:GlowMaterial,images:[AssetId<Image>;4]}
#[derive(Resource,Default)]pub struct Backend{draws:Vec<Owned>,store:Store,bindings:Vec<Bindings>,overlay:Handle<Image>,session:Option<u64>,pub error:Option<String>,pub published_frames:u64}
impl Backend{
 pub fn tickets(&self)->Vec<Ticket>{self.draws.iter().map(|d|d.ticket.clone()).collect()}
 fn remove(world:&mut World,d:Owned){if world.get::<Ticket>(d.ticket.draw)==Some(&d.ticket){world.despawn(d.ticket.draw);}world.resource_mut::<Assets<Mesh>>().remove(d.mesh.id());world.resource_mut::<Assets<GlowMaterial>>().remove(d.material.id());}
 fn hide(&self,world:&mut World){for d in &self.draws{if let Some(mut v)=world.get_mut::<Visibility>(d.ticket.draw){*v=Visibility::Hidden;}if let Some(mut m)=world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material){m.set_admitted(false);}}}
 fn publish(&mut self,world:&mut World,packets:Vec<Prepared>)->Result<(),String>{
  let mut identities=std::collections::HashSet::new();
  for p in &packets{let playback=world.get::<crate::animation::Playback>(p.owner.root).ok_or("pickup draw owner missing")?;
   if playback.network_id()!=p.key.picker||playback.model_asset_id()!=p.owner.model||world.get::<crate::actor_fow::Root>(p.owner.root).is_none()
    ||!identities.insert((p.key,p.group,p.slot,p.birth)){return Err("pickup draw owner or particle identity changed".into());}}
  for d in &self.draws{if world.get::<Ticket>(d.ticket.draw)!=Some(&d.ticket)||world.get::<Mesh3d>(d.ticket.draw).map(|m|m.id())!=Some(d.ticket.mesh)
   ||world.get::<MeshMaterial3d<GlowMaterial>>(d.ticket.draw).map(|m|m.id())!=Some(d.ticket.material)||world.get::<ChildOf>(d.ticket.draw).is_some()
   ||world.get::<Transform>(d.ticket.draw)!=Some(&Transform::IDENTITY)||world.get::<GlobalTransform>(d.ticket.draw)!=Some(&GlobalTransform::IDENTITY)
   ||!world.resource::<Assets<Mesh>>().contains(d.ticket.mesh)||!world.resource::<Assets<GlowMaterial>>().contains(d.ticket.material){return Err("pickup retained draw ownership changed".into());}}
  let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"pickup draw allocation failed")?;
  self.hide(world);
  for p in packets{
   let old=self.draws.iter().position(|d|d.ticket.key==p.key&&d.ticket.owner==p.owner&&d.ticket.group==p.group&&d.ticket.slot==p.slot&&d.ticket.birth==p.birth);
   let d=if let Some(i)=old{let mut d=self.draws.swap_remove(i);*world.resource_mut::<Assets<Mesh>>().get_mut(&d.mesh).unwrap()=p.mesh;
    *world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material).unwrap()=p.material;d.ticket.images=p.images;world.entity_mut(d.ticket.draw).insert((p.bounds,d.ticket.clone()));d
   }else{let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);let material=world.resource_mut::<Assets<GlowMaterial>>().add(p.material);
    let entity=world.spawn((Name::new("Relic original Simple particle"),Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
    let ticket=Ticket{key:p.key,owner:p.owner,group:p.group,slot:p.slot,birth:p.birth,draw:entity,mesh:mesh.id(),material:material.id(),images:p.images};world.entity_mut(entity).insert(ticket.clone());Owned{ticket,mesh,material}
   };output.push(d);
  }
  for d in self.draws.drain(..){Self::remove(world,d);}self.draws=output;
  for d in &self.draws{world.resource_mut::<Assets<GlowMaterial>>().get_mut(&d.material).unwrap().set_admitted(true);*world.get_mut::<Visibility>(d.ticket.draw).unwrap()=Visibility::Visible;}
  self.published_frames=self.published_frames.saturating_add(1);Ok(())
 }
 fn load(&mut self,world:&mut World)->Result<(),String>{
  if self.bindings.len()==4{return Ok(());}if !self.bindings.is_empty(){return Err("pickup partial texture acquisition requires cleanup".into());}
  let catalog=crate::relic_recovered_catalog::Catalog::recovered_with_pickup()?;
  let repeat=ImageSamplerDescriptor{address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()};
  let clamp=ImageSamplerDescriptor{address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,..repeat.clone()};
  let names=[("Purify01.tga","Wish_tar__starTrailSPI3__p-rgba.tga"),("Purify01.tga","wish_tar__mesh__p-rgba.tga"),("Wish_tar.tga","Wish_tar__starswirl__p-rgba.tga"),("Wish_tar.tga","Wish_tar__shafts__p-rgba.tga")];
  let compressed=CompressedImageFormats::from_features(world.get_resource::<bevy::render::renderer::RenderDevice>().ok_or("pickup GPU device absent")?.features());
  for (diffuse,color) in names{let d=std::ffi::CString::new(diffuse).unwrap();let c=std::ffi::CString::new(color).unwrap();
   match Bindings::acquire(&mut self.store,&mut world.resource_mut::<Assets<Image>>(),compressed,catalog.source(&d,ImageSampler::Descriptor(repeat.clone()),false)?,catalog.source(&c,ImageSampler::Descriptor(clamp.clone()),false)?){
    Ok(bindings)=>self.bindings.push(bindings),Err(failure)=>{let message=failure.message;let mut images=world.resource_mut::<Assets<Image>>();
     for lease in failure.leases{let _=self.store.release(lease,&mut images);}for bindings in self.bindings.drain(..){let _=bindings.retire(&mut self.store,&mut images);}return Err(message);}
   }
  }
  self.overlay=world.resource::<AssetServer>().load("maps/terrain_native/DefaultFogOfWarOverlay.png");Ok(())
 }
 fn retire_images(&mut self,world:&mut World)->Result<(),String>{
  if !self.draws.is_empty(){return Err("pickup image retirement precedes draw retirement".into());}
  let mut images=world.resource_mut::<Assets<Image>>();let mut errors=vec![];
  for bindings in self.bindings.drain(..){if let Err(failure)=bindings.retire(&mut self.store,&mut images){errors.push(failure.message);}}
  self.overlay=Handle::default();if errors.is_empty(){Ok(())}else{Err(errors.join("; "))}
 }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Backend>().add_systems(Startup,warmup).add_systems(PostUpdate,synchronize.after(events::Published)
 .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds).before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}}
fn warmup(world:&mut World){let mut backend=world.remove_resource::<Backend>().unwrap_or_default();backend.error=backend.load(world).err();world.insert_resource(backend);}
pub fn synchronize(world:&mut World){
 let Some(mut backend)=world.remove_resource::<Backend>()else{return};let Some(mut state)=world.remove_resource::<live::Live>()else{world.insert_resource(backend);return};
 let mut requests=world.remove_resource::<events::Host>().unwrap_or_default();
 let result=(||->Result<(),String>{
  let session=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity).map(|(session,_,_)|session);
  if backend.session.is_some()&&backend.session!=session{backend.publish(world,vec![])?;backend.retire_images(world)?;}backend.session=session;
  let now=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("pickup game clock absent")?.now;
  let plan=state.planned(&requests,now)?;
  if plan.groups().next().is_none(){plan.validate(&state,&requests)?;backend.publish(world,vec![])?;state.commit(plan,&mut requests)?;return Ok(());}
  backend.load(world)?;
  let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("pickup current FoW absent")?.output.clone();
  let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("pickup native map extent absent")?.geometry.extent;
  let view=world.get_resource::<crate::camera_native::NativeCamera>().and_then(|c|c.native_parameters()).map(openleague_core::camera_view::from_parameters).transpose().map_err(str::to_owned)?;
  let mut packets=Vec::new();
  for group in plan.groups(){let profile=match group.profile.index{0=>draw::Profile::HealStarTrail,1=>draw::Profile::HealMesh,2=>draw::Profile::ManaStarSwirl,3=>draw::Profile::ManaShafts,_=>return Err("pickup draw profile escaped".into())};
   let storage=group.host.state.particles.as_ref().ok_or("pickup actual particle storage absent")?;
   for i in 0..storage.ages.len(){let Some(packet)=draw::packet(draw::Config::for_profile(profile),draw::particle(storage,i).map_err(str::to_owned)?,draw::Frame{instance_e0:1.,system_bc:1.,system_c0:1.,rgba:[1.;4],scroll:[0.;2]},view).map_err(str::to_owned)?else{continue};
    let geometry=crate::nexus_glow_quad::from_packet(openleague_core::native_complex_type0_quad::Quad{words:packet.native.words},packet.atlas).map_err(str::to_owned)?;let bounds=geometry.mesh.compute_aabb().ok_or("pickup mesh bounds absent")?;
    let images=backend.bindings[group.profile.index].images_render_fog(&backend.store,world.resource::<Assets<Image>>(),[fog.clone(),backend.overlay.clone()])?.map(|h|h.id());
    // Original backface=false selects D3DCULL_CCW. Actual D3D9 HAL and
    // Vulkan/DX12 readbacks retain this native negative-NDC quad with GPU
    // FaceFront. In the reflected camera, view_cull maps Back to FaceFront.
    // Qualification: pickup_cull_gpu_probe/qualification.json, SHA256
    // adca235c341a67912b3368de25ae9487ad7670c89c2344ea3939a0dfa357452a.
    let material=GlowMaterial::new_owned_render_fog(&backend.bindings[group.profile.index],&backend.store,world.resource::<Assets<Image>>(),[fog.clone(),backend.overlay.clone()],Inputs{native_fog_extent:extent,encoding:crate::nexus_complex_material::OutputEncoding::DisplayToLinear,cull:crate::nexus_complex_material::Cull::Back,render_mode:0,render_flags:0,shader_features:0})?;
    packets.push(Prepared{key:group.key,owner:group.owner.binding,group:group.profile.index,slot:i,birth:group.host.state.birth[i],mesh:geometry.mesh,bounds,material,images});
   }
  }
  plan.validate(&state,&requests)?;backend.publish(world,packets)?;state.commit(plan,&mut requests)?;Ok(())
 })();if result.is_err(){backend.hide(world);}backend.error=result.err();state.error=backend.error.clone();
 if let Ok(path)=std::env::var("OPENLEAGUE_RELIC_PICKUP_CPU_PROBE"){
  let tickets=backend.draws.iter().map(|d|serde_json::json!({"session":d.ticket.key.session,"pickup_tick":d.ticket.key.pickup_tick,"picker":d.ticket.key.picker,"group":d.ticket.group,"slot":d.ticket.slot,"birth_word":d.ticket.birth,"draw":format!("{:?}",d.ticket.draw)})).collect::<Vec<_>>();
  let doc=serde_json::json!({"ordinary_pickup_host":true,"original_trigger_parity":false,"ordinal":state.ordinal,"requests":requests.requests.len(),"published_frames":backend.published_frames,"error":backend.error,"draws":tickets});
  if let Err(e)=std::fs::write(path,serde_json::to_vec(&doc).unwrap()){warn!("pickup CPU report: {e}");}
 }
 world.insert_resource(backend);world.insert_resource(state);world.insert_resource(requests);
}

#[cfg(test)]
#[path="relic_pickup_render_tests.rs"]mod tests;
