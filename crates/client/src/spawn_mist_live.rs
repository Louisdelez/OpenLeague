//! Ordinary Map10 static mist under an explicit reconstructed local policy.
//! Original missing fogcircle/texture bytes, all-FX order and trigger are unknown.
use bevy::{asset::{AssetId,RenderAssetUsages},camera::primitives::MeshAabb,
 image::{CompressedImageFormats,ImageAddressMode,ImageFilterMode,ImageSampler,ImageSamplerDescriptor,ImageType},
 mesh::PrimitiveTopology,prelude::*};
use crate::{spawn_mist_state::{State,Binding,Plan},spawn_mist_sources::{Effect,Profile},spawn_mist_host::HostSource,
 spawn_mist_world::{self,ReconstructedGeometry},spawn_mist_material::{MistMaterial,Inputs,Cull,OutputEncoding}};
use openleague_core::{native_random::Rng55,native_complex_particle_storage::GlobalVectors};
use std::sync::{Arc,Mutex};

pub const DIFFUSE:&str="particles/spawn_mist_reconstructed/TT_Mist_circle-fixedalpha-v2.png";
pub const GEOMETRY:&str="../../../data/4.20/spawn_mist/fogcircle-reconstructed-native-v3.json";
#[derive(Component,Clone,Copy,Debug,PartialEq,Eq)]pub struct SourceRoot{pub session:u64,pub slot:usize,pub map_root:Entity,pub model:AssetId<Gltf>,pub position:[u32;3]}
#[derive(Component,Clone,Debug,PartialEq,Eq,Hash)]pub struct Ticket{
 pub binding:Binding,pub source:usize,pub slot:usize,pub birth:u32,pub counter:u32,
 pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:AssetId<MistMaterial>,pub images:[AssetId<Image>;4],
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]pub struct ImageLayout{pub extent:[u32;3],pub mips:u32,pub format:bevy::render::render_resource::TextureFormat}
#[derive(Resource,Clone,Default)]pub struct ReadyAnswers(pub Arc<Mutex<Vec<Ticket>>>);
impl ReadyAnswers{fn ready(&self,ticket:&Ticket)->bool{self.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner).contains(ticket)}pub fn clear(&self){self.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner).clear();}}
#[derive(Resource)]pub struct Configuration{pub sources:[HostSource;2],pub positions:[[u32;3];2],pub geometry:ReconstructedGeometry}
#[derive(Resource)]struct Resources{images:[Handle<Image>;3],layouts:[ImageLayout;2],samplers:[ImageSampler;2]}
// Read-only copy of exact prepared getter output. No field is required
// by Prepared or publish callers, and missing observations stay unavailable.
#[derive(Clone,Copy)]struct SurfaceObservation{binding:Binding,source:usize,slot:usize,birth:u32,counter:u32,clock:Option<f64>,scroll_words:[u32;2],atlas_frame_word:u32}
struct Owned{ticket:Ticket,mesh:Handle<Mesh>,material:Handle<MistMaterial>}
struct Prepared{source:usize,slot:usize,birth:u32,counter:u32,mesh:Mesh,bounds:bevy::camera::primitives::Aabb,material:MistMaterial,images:[AssetId<Image>;4]}
#[derive(Resource,Default)]pub struct Backend{draws:Vec<Owned>,pub binding:Option<Binding>,pub error:Option<String>,pub published_frames:u64,pub layouts:Option<[ImageLayout;2]>,surface_observations:Vec<SurfaceObservation>}
impl Backend{
 pub fn tickets(&self)->Vec<Ticket>{self.draws.iter().map(|d|d.ticket.clone()).collect()}
 fn remove(world:&mut World,owned:Owned){
  // A foreign entity is never deleted merely because it reuses our Entity index.
  if world.get::<Ticket>(owned.ticket.draw)==Some(&owned.ticket){world.despawn(owned.ticket.draw);}
  world.resource_mut::<Assets<Mesh>>().remove(owned.mesh.id());world.resource_mut::<Assets<MistMaterial>>().remove(owned.material.id());
 }
 fn clear(&mut self,world:&mut World){self.surface_observations.clear();for owned in self.draws.drain(..){Self::remove(world,owned);}world.resource::<ReadyAnswers>().clear();}
 fn hide(&self,world:&mut World){for owned in &self.draws{
  if world.get::<Ticket>(owned.ticket.draw)!=Some(&owned.ticket){continue;}
  if let Some(mut visibility)=world.get_mut::<Visibility>(owned.ticket.draw){*visibility=Visibility::Hidden;}
  if let Some(mut material)=world.resource_mut::<Assets<MistMaterial>>().get_mut(owned.material.id()){material.set_ready(false);}
 }world.resource::<ReadyAnswers>().clear();}
 fn validate_retained(&self,world:&World)->Result<(),String>{
  for owned in &self.draws{let t=&owned.ticket;
   if world.get::<Ticket>(t.draw)!=Some(t)||world.get::<Mesh3d>(t.draw).map(|m|m.0.id())!=Some(t.mesh)
    ||world.get::<MeshMaterial3d<MistMaterial>>(t.draw).map(|m|m.0.id())!=Some(t.material)
    ||world.get::<ChildOf>(t.draw).is_some()||world.get::<Transform>(t.draw)!=Some(&Transform::IDENTITY)
    ||world.get::<GlobalTransform>(t.draw)!=Some(&GlobalTransform::IDENTITY)
    ||world.get::<Visibility>(t.draw).is_none()||world.resource::<Assets<Mesh>>().get(t.mesh).is_none()
    ||world.resource::<Assets<MistMaterial>>().get(t.material).is_none(){return Err("mist retained private draw ownership changed".into());}
  }Ok(())
 }
 fn publish(&mut self,world:&mut World,binding:Option<Binding>,packets:Vec<Prepared>)->Result<(),String>{
  if binding.is_none()&&packets.is_empty(){self.clear(world);self.binding=None;self.published_frames=self.published_frames.saturating_add(1);return Ok(());}
  self.validate_retained(world)?;let mut identities=std::collections::HashSet::new();
  if packets.len()>128{return Err("mist selected local draw capacity exceeded".into());}
  for p in &packets{if p.source>=2||!identities.insert((p.source,p.slot,p.birth,p.counter)){return Err("mist duplicate/private particle identity".into());}}
  if !packets.is_empty()&&binding.is_none(){return Err("mist packets without current source binding".into());}
  let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"mist draw reservation failed")?;
  // There are no fallible allocations/owner checks after this point. Stable
  // birth+counter leases retain actual entity, mesh and material IDs while cold.
  let answers=world.resource::<ReadyAnswers>().clone();
  for p in packets{let binding=binding.unwrap();let old=self.draws.iter().position(|d|d.ticket.binding==binding&&d.ticket.source==p.source&&d.ticket.slot==p.slot&&d.ticket.birth==p.birth&&d.ticket.counter==p.counter);
   let owned=if let Some(i)=old{let mut owned=self.draws.swap_remove(i);let mut material=p.material;
    let candidate=Ticket{images:p.images,..owned.ticket.clone()};material.set_ready(answers.ready(&candidate));
    *world.resource_mut::<Assets<Mesh>>().get_mut(&owned.mesh).unwrap()=p.mesh;
    *world.resource_mut::<Assets<MistMaterial>>().get_mut(&owned.material).unwrap()=material;
    owned.ticket=candidate;world.entity_mut(owned.ticket.draw).insert((p.bounds,owned.ticket.clone(),Visibility::Visible));owned
   }else{let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);let material=world.resource_mut::<Assets<MistMaterial>>().add(p.material);
    let draw=world.spawn((Name::new(format!("Map10 reconstructed {} mist",if p.source==0{"Chaos"}else{"Order"})),Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),
     Transform::IDENTITY,GlobalTransform::IDENTITY,p.bounds,Visibility::Visible)).id();
    let ticket=Ticket{binding,source:p.source,slot:p.slot,birth:p.birth,counter:p.counter,draw,mesh:mesh.id(),material:material.id(),images:p.images};world.entity_mut(draw).insert(ticket.clone());Owned{ticket,mesh,material}
   };output.push(owned);
  }
  for owned in self.draws.drain(..){Self::remove(world,owned);}self.draws=output;
  self.binding=binding;self.published_frames=self.published_frames.saturating_add(1);Ok(())
 }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Backend>().init_resource::<ReadyAnswers>()
 .add_plugins((crate::spawn_mist_material::Plugin,crate::spawn_mist_readiness::Plugin))
 .add_systems(Startup,initialize).add_systems(PostUpdate,synchronize
  .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
  .after(bevy::transform::TransformSystems::Propagate)
  .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}}

fn json(text:&str)->Result<serde_json::Value,String>{serde_json::from_str(text).map_err(|e|e.to_string())}
pub fn local_configuration()->Result<Configuration,String>{
 let catalog=json(include_str!("../../../data/4.20/map10_particle_catalog.json"))?;
 let placements=catalog["placements"].as_array().ok_or("mist native placement catalog absent")?;
 let definitions=[include_str!("../../../data/4.20/map10_particles/definitions/Chaos_Spawn.json"),include_str!("../../../data/4.20/map10_particles/definitions/Order_Spawn.json")];
 let factories=[include_str!("../../../data/4.20/spawn_mist/Chaos_Spawn_numeric_factory_v5.json"),include_str!("../../../data/4.20/spawn_mist/Order_Spawn_numeric_factory_v5.json")];
 let mut sources=Vec::new();let mut positions=Vec::new();let mut last_line=0;
 for(i,effect)in [Effect::Chaos,Effect::Order].into_iter().enumerate(){
  let rows=placements.iter().filter(|p|p["reference"]==format!("{}.troy",effect.name())).collect::<Vec<_>>();
  if rows.len()!=1{return Err("mist native placement not unique".into());}let row=rows[0];let line=row["line"].as_u64().ok_or("mist placement line")?;
  if line<=last_line{return Err("mist native catalog source order changed".into());}last_line=line;
  let values=row["position"].as_array().filter(|a|a.len()==3).ok_or("mist placement position absent")?;
  let mut p=[0;3];for(axis,value)in values.iter().enumerate(){let v=value.as_f64().ok_or("mist placement numeric")? as f32;if !v.is_finite(){return Err("mist placement nonfinite".into());}p[axis]=v.to_bits();}positions.push(p);
  let factory=json(factories[i])?;let native=Profile::from_documents(effect,&json(definitions[i])?,&factory,false)?;
  // Reconstructed static local actor: no attributes/trails/shapes. This is not
  // recovered original global actor/provider state. Capability false is selected.
  let policy=crate::relic_pickup_complex_sources::LocalPolicy{life_owner_scale:1.,actor_rate_scale:1.,scale_owner:1.,owner_flags:0,owner_extra:[0.;3],motion_scratch:[0;3],
    globals:GlobalVectors{unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]}};
  let source=HostSource::new(native,&factory,policy)?;
  if source.getter_source.attribute_enabled{return Err("mist selected static policy requires the actual disabled PRIMARY owner-attribute branch".into());}
  sources.push(source);
 }
 let geometry=json(include_str!("../../../data/4.20/spawn_mist/fogcircle-reconstructed-native-v3.json"))?;
 let vec3=|key:&str|->Result<Vec<[f32;3]>,String>{geometry[key].as_array().ok_or("mist reconstructed geometry channel absent")?.iter().map(|row|{let a=row.as_array().filter(|a|a.len()==3).ok_or("mist geometry triple")?;let mut out=[0.;3];for i in 0..3{out[i]=a[i].as_f64().ok_or("mist geometry numeric")? as f32;}Ok(out)}).collect()};
 let native_positions=vec3("vertices_native_xyz")?;
 let uv=geometry["uv"].as_array().ok_or("mist geometry UV absent")?.iter().map(|row|{let a=row.as_array().filter(|a|a.len()==2).ok_or("mist UV pair")?;Ok([a[0].as_f64().ok_or("mist U numeric")? as f32,a[1].as_f64().ok_or("mist V numeric")? as f32])}).collect::<Result<Vec<_>,String>>()?;
 let triangles=geometry["triangles"].as_array().ok_or("mist topology absent")?.iter().map(|row|{let a=row.as_array().filter(|a|a.len()==3).ok_or("mist triangle")?;let mut out=[0;3];for i in 0..3{out[i]=a[i].as_u64().and_then(|v|u32::try_from(v).ok()).ok_or("mist triangle index")?;}Ok(out)}).collect::<Result<Vec<_>,String>>()?;
 let geometry=ReconstructedGeometry{native_positions,uv,triangles};geometry.bake(Mat4::IDENTITY.to_cols_array()).map_err(str::to_owned)?;
 Ok(Configuration{sources:sources.try_into().ok().unwrap(),positions:positions.try_into().unwrap(),geometry})
}
#[cfg(windows)]fn filetime()->u64{#[repr(C)]struct FileTime{low:u32,high:u32}#[link(name="kernel32")]unsafe extern "system"{fn GetSystemTimeAsFileTime(value:*mut FileTime);}let mut value=FileTime{low:0,high:0};unsafe{GetSystemTimeAsFileTime(&mut value)};(u64::from(value.high)<<32)|u64::from(value.low)}
#[cfg(not(windows))]fn filetime()->u64{116444736000000000+u64::try_from(std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).expect("UTC epoch").as_nanos()/100).expect("FILETIME")}
fn layout(image:&Image)->ImageLayout{let d=&image.texture_descriptor;ImageLayout{extent:[d.size.width,d.size.height,d.size.depth_or_array_layers],mips:d.mip_level_count,format:d.format}}
fn initialize(world:&mut World){
 let result=(||->Result<(Configuration,Resources,State),String>{
  if world.contains_resource::<State>()||world.contains_resource::<Configuration>()||world.contains_resource::<Resources>(){return Err("mist startup already initialized; no reseed".into());}
  let config=local_configuration()?;
  let compressed=CompressedImageFormats::from_features(world.get_resource::<bevy::render::renderer::RenderDevice>().ok_or("mist GPU device absent")?.features());
  let linear=ImageSamplerDescriptor{address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()};
  let samplers=[ImageSampler::Descriptor(linear.clone()),ImageSampler::Descriptor(ImageSamplerDescriptor{address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,..linear})];
  let diffuse=Image::from_buffer(include_bytes!("../../../assets/particles/spawn_mist_reconstructed/TT_Mist_circle-fixedalpha-v2.png"),ImageType::Extension("png"),compressed,false,samplers[0].clone(),RenderAssetUsages::default()).map_err(|e|e.to_string())?;
  let palette=Image::from_buffer(include_bytes!("../../../assets/particles/map10_native/color-bellramp.dds"),ImageType::Extension("dds"),compressed,false,samplers[1].clone(),RenderAssetUsages::default()).map_err(|e|e.to_string())?;
  let layouts=[layout(&diffuse),layout(&palette)];
  if layouts[0].extent!=[1254,1254,1]||layouts[0].mips!=1||layouts[1].extent!=[64,64,1]{return Err("mist source image extent changed".into());}
  let overlay=world.resource::<AssetServer>().load("maps/terrain_native/DefaultFogOfWarOverlay.png");
  let handles={let mut images=world.resource_mut::<Assets<Image>>();[images.add(diffuse),images.add(palette),overlay]};
  Ok((config,Resources{images:handles,layouts,samplers},State::new(Rng55::from_filetime(filetime()))))
 })();match result{Ok((config,images,state))=>{world.resource_mut::<Backend>().layouts=Some(images.layouts);world.insert_resource(config);world.insert_resource(images);world.insert_resource(state);},Err(error)=>{world.resource_mut::<Backend>().error=Some(error.clone());error!("Reconstructed Map10 mist startup rejected: {error}");}}
}

fn current_binding(world:&mut World,backend:&mut Backend,config:&Configuration)->Result<Option<Binding>,String>{
 let identity=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity);
 let session=identity.and_then(|(session,_,_)|world.get_resource::<crate::Match>().and_then(|s|s.snapshot.as_ref()).filter(|s|s.session==session).map(|_|session));
 let mut query=world.query_filtered::<Entity,With<crate::map_coordinates::MapRoot>>();let maps=query.iter(world).collect::<Vec<_>>();
 let model=world.get_resource::<crate::MapHandle>().map(|m|m.0.id());
 let Some((session,map_root,model))=session.zip(maps.first().copied()).zip(model).map(|((a,b),c)|(a,b,c))else{return Ok(None)};
 if maps.len()!=1{return Err("mist current native map root not unique".into());}
 if world.get_resource::<Assets<Gltf>>().and_then(|a|a.get(model)).is_none(){return Err("mist actual map model pending".into());}
 if let Some(binding)=backend.binding{
  if binding.session==session&&binding.map_root==map_root&&binding.model==model&&binding.positions==config.positions{
   if let Err(error)=validate_binding(world,binding){backend.clear(world);retire_roots(world,backend.binding.take());return Err(error);}
   return Ok(Some(binding));
  }
 }
 retire_roots(world,backend.binding.take());backend.clear(world);
 let roots=std::array::from_fn(|slot|world.spawn((Name::new(if slot==0{"Chaos_Spawn local mist owner"}else{"Order_Spawn local mist owner"}),
  SourceRoot{session,slot,map_root,model,position:config.positions[slot]},ChildOf(map_root),Transform::from_translation(Vec3::from_array(config.positions[slot].map(f32::from_bits))),Visibility::Inherited)).id());
 let binding=Binding{session,map_root,model,roots,positions:config.positions};backend.binding=Some(binding);Ok(Some(binding))
}
fn validate_binding(world:&World,binding:Binding)->Result<(),String>{
 if world.get_entity(binding.map_root).is_err()||world.get::<crate::map_coordinates::MapRoot>(binding.map_root).is_none()
  ||world.get::<Transform>(binding.map_root)!=Some(&crate::map_coordinates::map_root_transform())
  ||world.get::<ChildOf>(binding.map_root).is_some()
  ||world.get::<GlobalTransform>(binding.map_root)!=Some(&GlobalTransform::from(crate::map_coordinates::map_root_transform()))
  ||world.get_resource::<crate::MapHandle>().map(|m|m.0.id())!=Some(binding.model){return Err("mist map owner lost".into());}
 let model=world.get_resource::<Assets<Gltf>>().and_then(|a|a.get(binding.model)).ok_or("mist current map model unavailable")?;
 if world.get::<bevy::world_serialization::WorldAssetRoot>(binding.map_root).map(|r|r.0.id())!=model.scenes.first().map(|s|s.id()){return Err("mist map root no longer owns its actual model scene".into());}
 for slot in 0..2{let marker=SourceRoot{session:binding.session,slot,map_root:binding.map_root,model:binding.model,position:binding.positions[slot]};
  if world.get::<SourceRoot>(binding.roots[slot])!=Some(&marker)||world.get::<ChildOf>(binding.roots[slot]).map(ChildOf::parent)!=Some(binding.map_root)
   ||world.get::<Transform>(binding.roots[slot])!=Some(&Transform::from_translation(Vec3::from_array(binding.positions[slot].map(f32::from_bits)))){return Err("mist static source owner changed".into());}
 }Ok(())
}
fn retire_roots(world:&mut World,binding:Option<Binding>){if let Some(binding)=binding{for(slot,entity)in binding.roots.into_iter().enumerate(){let expected=SourceRoot{session:binding.session,slot,map_root:binding.map_root,model:binding.model,position:binding.positions[slot]};if world.get::<SourceRoot>(entity)==Some(&expected){world.despawn(entity);}}}}
fn prepare(world:&World,plan:&mut Plan,config:&Configuration,resources:&Resources)->Result<(Vec<Prepared>,Vec<SurfaceObservation>),String>{
 let prepared_clock=plan.next.last_clock;
 let observing=std::env::var_os("OPENLEAGUE_SPAWN_MIST_CPU_PROBE").is_some();
 let Some(active)=plan.next.active.as_mut()else{return Ok((vec![],vec![]))};validate_binding(world,active.binding)?;
 let assets=world.resource::<Assets<Image>>();for i in 0..2{let image=assets.get(resources.images[i].id()).ok_or("mist owned image absent")?;if layout(image)!=resources.layouts[i]||image.sampler!=resources.samplers[i]{return Err("mist owned image layout/sampler changed".into());}}
 if assets.get(resources.images[2].id()).is_none(){return Err("mist actual overlay pending".into());}
 let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("mist current real FoW absent")?.output.clone();
 // FoW output is RenderAssetUsages::RENDER_WORLD and legitimately leaves CPU
 // Assets<Image>. Its current GPU object/session is checked at actual dispatch.
 let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("mist actual native map extent absent")?.geometry.extent;
 let native_fog=crate::native_fow::FogParams::from_native_extent(extent).map_err(str::to_owned)?.params();
 let handles=[resources.images[0].clone(),resources.images[1].clone(),fog,resources.images[2].clone()];let ids=handles.each_ref().map(|h|h.id());
 let mut packets=Vec::new();let mut surface_observations=Vec::new();
 for source in 0..2{let effect=&active.effects[source];let cfg=&config.sources[source];
  let surfaces=effect.surfaces(cfg.getter_source,|_,_|Err("mist owner attribute lookup outside selected disabled PRIMARY branch".into()))?;
  if surfaces.len()!=effect.host.storage.particles.len(){return Err("mist surface/storage enumeration differs".into());}
  for(slot,(surface,record))in surfaces.into_iter().zip(&effect.host.storage.particles).enumerate(){
   let placement=spawn_mist_world::prepare(surface,&mut active.headers[source],f32::from_bits(effect.created.context.system_scales[0]),f32::from_bits(effect.created.context.system_scales[1])).map_err(str::to_owned)?;
   let baked=config.geometry.bake(placement.world).map_err(str::to_owned)?;
   let colors=baked.positions.iter().map(|p|[0.,0.,0.,crate::native_fow::fade_toward_fogged(p[1]*20.)]).collect::<Vec<_>>();
   let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
   mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,baked.positions);mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,baked.uv);mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,colors);
   mesh.insert_indices(bevy::mesh::Indices::U32(baked.triangles.into_iter().flatten().collect()));let bounds=mesh.compute_aabb().ok_or("mist mesh finite bounds absent")?;
   let rgba=cfg.native.prepare_rgba(std::array::from_fn(|i|f32::from_bits(surface[32+i])))?;
   let uv=cfg.native.mesh_uv_transform(f32::from_bits(surface[53]),[f32::from_bits(surface[45]),f32::from_bits(surface[46])])?;
   let input=Inputs{uv_scale_offset:Vec4::from_array(uv),lookup_uv:Vec2::new(f32::from_bits(surface[49]),f32::from_bits(surface[50])),color_factor:Vec4::from_array(rgba),
    fog_uv_scale_offset:Vec4::new(native_fog.x*20.,native_fog.y*20.,native_fog.z,native_fog.w),output_encoding:OutputEncoding::DisplayToLinear,cull:Cull::Back,
    shader_class:1,uv_mode:cfg.native.factory.uv_mode,render_mode:cfg.native.factory.render_mode,vertex_colors:false,reflected:false,soft:cfg.native.factory.soft_enabled,mult_pass:false,screen_uv:false,alpha_slice:cfg.native.factory.alpha_slice,fresnel_rgb:Vec3::ZERO};
   let material=MistMaterial::from_images(handles.clone(),input).map_err(str::to_owned)?;
   packets.push(Prepared{source,slot,birth:record.life[0],counter:record.field_88[0],mesh,bounds,material,images:ids});
   if observing{surface_observations.push(SurfaceObservation{binding:active.binding,source,slot,birth:record.life[0],counter:record.field_88[0],clock:prepared_clock,scroll_words:[surface[45],surface[46]],atlas_frame_word:surface[53]});}
  }
 }Ok((packets,surface_observations))
}
fn synchronize(world:&mut World){
 let Some(mut backend)=world.remove_resource::<Backend>()else{return};let Some(mut state)=world.remove_resource::<State>()else{backend.hide(world);if backend.error.is_none(){backend.error=Some("mist owned state unavailable".into());}world.insert_resource(backend);return};
 let Some(config)=world.remove_resource::<Configuration>()else{backend.hide(world);backend.error=Some("mist owned source configuration unavailable".into());world.insert_resource(state);world.insert_resource(backend);return};
 let result=(||->Result<(),String>{
  let binding=current_binding(world,&mut backend,&config)?;
  let mut plan=planned_with_clock(&state,binding,&config,world.get_resource::<crate::native_effect_clock::EffectClock>())?;
  let(packets,surface_observations)=if binding.is_none(){(vec![],vec![])}else{prepare(world,&mut plan,&config,world.get_resource::<Resources>().ok_or("mist owned resources absent")?)?};
  state.validate(&plan,binding)?;if let Some(binding)=binding{validate_binding(world,binding)?;}
  let old_binding=backend.binding;
  backend.publish(world,binding,packets)?;state.commit(plan,binding)?;backend.surface_observations=surface_observations;
  if binding.is_none(){retire_roots(world,old_binding);}Ok(())
 })();
 if let Err(error)=result{backend.hide(world);if backend.binding.is_none(){state.active=None;}backend.error=Some(error);}else{backend.error=None;}
 report(world,&backend,&state);
 world.insert_resource(config);world.insert_resource(state);world.insert_resource(backend);
}
fn planned_with_clock(state:&State,binding:Option<Binding>,config:&Configuration,clock:Option<&crate::native_effect_clock::EffectClock>)->Result<Plan,String>{
 if binding.is_none(){return state.retired();}
 let clock=clock.ok_or("mist canonical effect clock absent")?;
 if clock.diagnostic()["failed"]==true{return Err("mist canonical effect clock stopped".into());}
 state.planned(binding,clock.now,&config.sources)
}
#[cfg(test)]
#[path="spawn_mist_live_tests.rs"]mod tests;
fn report(world:&World,backend:&Backend,state:&State){
 let Ok(path)=std::env::var("OPENLEAGUE_SPAWN_MIST_CPU_PROBE")else{return};
 let rows=backend.draws.iter().map(|d|{let surface=backend.surface_observations.iter().find(|s|s.binding==d.ticket.binding&&s.source==d.ticket.source&&s.slot==d.ticket.slot&&s.birth==d.ticket.birth&&s.counter==d.ticket.counter);serde_json::json!({"session":d.ticket.binding.session,"source":d.ticket.source,"effect":if d.ticket.source==0{"Chaos_Spawn"}else{"Order_Spawn"},"slot":d.ticket.slot,"birth":d.ticket.birth,"counter":d.ticket.counter,"draw":d.ticket.draw.to_bits(),"map_root":d.ticket.binding.map_root.to_bits(),"source_root":d.ticket.binding.roots[d.ticket.source].to_bits(),"visible":world.get::<Visibility>(d.ticket.draw)==Some(&Visibility::Visible),"material_ready":world.resource::<Assets<MistMaterial>>().get(d.material.id()).is_some_and(MistMaterial::is_ready),
  "surface56_prepared_clock":surface.and_then(|s|s.clock),"surface56_scroll_words":surface.map(|s|s.scroll_words),"surface56_atlas_frame_word":surface.map(|s|s.atlas_frame_word),
  "mesh_asset_id":format!("{:?}",d.mesh.id()),"material_asset_id":format!("{:?}",d.material.id()),"image_asset_ids":d.ticket.images.map(|id|format!("{id:?}")),
  "CPU_material_uniform_words":world.resource::<Assets<MistMaterial>>().get(d.material.id()).map(MistMaterial::uniform_words)})}).collect::<Vec<_>>();
 let doc=serde_json::json!({"schema":"map10_spawn_mist_cpu_v1","telemetry_schema":"map10_spawn_mist_surface_telemetry_v1","surface_words_are_prepared_native_getter_output":true,"GPU_buffer_readback":false,"ordinary_static_reconstructed_policy":true,"original_trigger_parity":false,"original_missing_asset_parity":false,"all_fx_global_rng_parity":false,"source_order":["Chaos_Spawn:88","Order_Spawn:89"],"ordinal":state.ordinal,"clock":state.last_clock,"published_frames":backend.published_frames,"error":backend.error,"draws":rows});
 if let Ok(bytes)=serde_json::to_vec(&doc){let _=std::fs::write(path,bytes);}
}
