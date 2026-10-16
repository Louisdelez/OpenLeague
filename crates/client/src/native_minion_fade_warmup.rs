//! Precompile the private fade route for actual loaded lane primitives.
//! No entity is spawned, rebound, queued or made visible by this preparation.
use bevy::{prelude::*, asset::AssetId,
 material::key::{ErasedMaterialPipelineKey,ErasedMeshPipelineKey},
 pbr::{PreparedMaterial,ViewKeyCache,MeshPipelineKey,StandardMaterialKey,
      alpha_mode_pipeline_key,RenderMeshInstances,RenderMeshInstanceFlags,
      Lightmap,MaterialBindGroupAllocators},
 render::{Render,RenderApp,RenderSystems,mesh::RenderMesh,render_asset::RenderAssets,
          erased_render_asset::ErasedRenderAssets,sync_world::MainEntity,
          extract_resource::{ExtractResource,ExtractResourcePlugin},
          render_resource::PipelineCache,view::{RenderVisibilityRanges,ExtractedView,RenderVisibleEntities}}};
use std::{collections::HashMap,sync::{Arc,Mutex},hash::{Hash,Hasher}};
use crate::{map_fog::FogMaterial,native_minion_fade_material::{Material,Extension,Owner}};

#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
struct Stamp {session:u64,network:u32,root:Entity,model:AssetId<Gltf>,draw:Entity,
 mesh:AssetId<Mesh>,source:AssetId<StandardMaterial>,previous:AssetId<FogMaterial>,
 standard_key:u64,fog_key:u32,mesh_shape:u64}
#[derive(Clone)]struct Candidate {stamp:Stamp,mesh:Handle<Mesh>,material:Handle<Material>,lightmap:Option<bool>}
#[derive(Clone,Default)]struct Answer {ready:bool,pipelines:usize,error:Option<String>}
#[derive(Resource,Default)]struct Candidates {entries:HashMap<Entity,Candidate>}
#[derive(Resource,Clone,Default,ExtractResource)]struct Requests {
 entries:Vec<Candidate>,answers:Arc<Mutex<HashMap<Stamp,Answer>>>,
}

fn descendant(world:&World,entity:Entity,root:Entity)->bool {
 let mut e=entity;for _ in 0..128{if e==root{return true;}let Some(p)=world.get::<ChildOf>(e)else{return false;};e=p.parent();}false
}
fn mesh_shape(mesh:&Mesh)->Option<u64>{let mut h=std::collections::hash_map::DefaultHasher::new();mesh.primitive_topology().hash(&mut h);for(attribute,values)in mesh.try_attributes().ok()?{attribute.id.hash(&mut h);bevy::render::render_resource::VertexFormat::from(values).hash(&mut h);}mesh.try_has_morph_targets().ok()?.hash(&mut h);Some(h.finish())}
/// Preparation identity uses the current ordinary actor, without an invented
/// endgame result/event. The eventual binding rechecks its actual result Owner.
pub(crate)fn collect(world:&mut World){
 let mut cache=world.remove_resource::<Candidates>().unwrap_or_default();
 let identity=world.get_resource::<crate::Connection>().and_then(|c|c.inventory_input_identity());
 let actors:Vec<_>=identity.and_then(|id|world.get_resource::<crate::Match>().and_then(|state|{
  let snapshot=state.snapshot.as_ref().filter(|s|s.session==id.0)?;
  Some(snapshot.units.iter().filter(|u|u.kind.lane()).filter_map(|u|{
   let root=*state.visuals.get(&u.id)?;let playback=world.get::<crate::animation::Playback>(root)?;
   if world.get::<crate::actor_fow::Root>(root).is_none()||playback.network_id()!=u.id||playback.model_name()!=u.definition{return None;}
   Some((id.0,u.id,root,playback.model_asset_id()))
  }).collect())
 })).unwrap_or_default();
 let primitives:Vec<_>={let mut q=world.query::<(Entity,&Mesh3d,&crate::actor_fow::Bound,&MeshMaterial3d<FogMaterial>)>();
  q.iter(world).map(|(e,m,b,f)|(e,m.0.clone(),b.source.clone(),f.0.clone())).collect()};
 let mut next=HashMap::new();
 for(draw,mesh,source,previous)in primitives{
  let Some(&(session,network,root,model))=actors.iter().find(|(_,_,root,_)|descendant(world,draw,*root))else{continue;};
  if world.get::<crate::native_minion_fade_material::Guard>(draw).is_some(){continue;}
  let Some(shape)=world.get_resource::<Assets<Mesh>>().and_then(|m|m.get(&mesh)).and_then(mesh_shape)else{continue;};
  // RenderLightmaps' live map is private in Bevy0.19. Admit only actual
  // unlightmapped lane primitives, rather than invent its GPU-ready presence.
  if world.get::<Lightmap>(draw).is_some(){continue;}
  if !world.get_resource::<crate::actor_fow::Cache>().is_some_and(|c|c.bindings.get(&source.id())==Some(&previous)){continue;}
  let Some(base)=world.get_resource::<Assets<FogMaterial>>().and_then(|m|m.get(&previous)).filter(|m|crate::native_minion_fade_material::admitted(m)).cloned()else{continue;};
  let stamp=Stamp{session,network,root,model,draw,mesh:mesh.id(),source:source.id(),previous:previous.id(),standard_key:StandardMaterialKey::from(&base.base).bits(),fog_key:base.extension.native_draw_mode,mesh_shape:shape};
  let candidate=if let Some(old)=cache.entries.remove(&draw).filter(|c|c.stamp==stamp){
   if let Some(mut material)=world.resource_mut::<Assets<Material>>().get_mut(&old.material){material.base=base;}
   old
  }else{let material=world.resource_mut::<Assets<Material>>().add(Material{base,extension:Extension{opacity:1.}});Candidate{stamp,mesh,material,lightmap:world.get::<Lightmap>(draw).map(|l|l.bicubic_sampling)}};
  next.insert(draw,candidate);
 }
 cache.entries=next;
 let requests:Vec<_>=cache.entries.values().cloned().collect();
 let mut frame=world.get_resource_mut::<Requests>().expect("fade warmup requests installed");
 frame.entries=requests;
 if let Ok(mut answers)=frame.answers.lock(){answers.retain(|stamp,_|frame.entries.iter().any(|c|c.stamp==*stamp));}
 drop(frame);world.insert_resource(cache);
}
/// Return only a retained, unbound candidate whose actual GPU route compiled.
/// Pending preparation preserves the exact FogMaterial binding and event clock.
pub(crate)fn take_ready(world:&mut World,owner:Owner,draw:Entity,source:&Handle<StandardMaterial>,previous:&Handle<FogMaterial>)->Result<Option<Handle<Material>>,String>{
 let Some(cache)=world.get_resource::<Candidates>()else{return Err("fade warmup not installed; baseline retained".into());};
 let Some(candidate)=cache.entries.get(&draw).cloned()else{return Ok(None);};
 let s=candidate.stamp;
 let current_mesh=world.get::<Mesh3d>(draw).map(|m|m.0.id());
 let current_base=world.resource::<Assets<FogMaterial>>().get(previous);
 if (s.session,s.network,s.root,s.model,s.source,s.previous)!=(owner.session,owner.network,owner.root,owner.model,source.id(),previous.id())
  ||current_mesh!=Some(s.mesh)||world.get::<Lightmap>(draw).is_some()
  ||world.get_resource::<Assets<Mesh>>().and_then(|m|m.get(s.mesh)).and_then(mesh_shape)!=Some(s.mesh_shape)
  ||!current_base.is_some_and(|b|crate::native_minion_fade_material::admitted(b)&&StandardMaterialKey::from(&b.base).bits()==s.standard_key&&b.extension.native_draw_mode==s.fog_key){return Ok(None);}
 let Some(frame)=world.get_resource::<Requests>()else{return Err("fade warmup feedback unavailable; baseline retained".into());};
 let ready=frame.answers.lock().map_err(|_|"fade warmup feedback poisoned")?.get(&s).is_some_and(|a|a.ready&&a.pipelines>0&&a.error.is_none());
 if !ready{return Ok(None);}
 if world.resource::<Assets<Material>>().get(&candidate.material).is_none(){return Ok(None);}
 world.resource_mut::<Candidates>().entries.remove(&draw);
 Ok(Some(candidate.material))
}

/// This is the same key composition used by Bevy0.19 specialize_material_meshes.
fn mesh_key(view:MeshPipelineKey,mesh:MeshPipelineKey,material:MeshPipelineKey,alpha:AlphaMode,
 lightmap:Option<bool>,range:bool,flags:RenderMeshInstanceFlags)->MeshPipelineKey{
 let mut material=material;material.insert(alpha_mode_pipeline_key(alpha,&Msaa::from_samples(view.msaa_samples())));
 let mut key=view|mesh|material;
 if let Some(bicubic)=lightmap{key|=MeshPipelineKey::LIGHTMAPPED;if bicubic{key|=MeshPipelineKey::LIGHTMAP_BICUBIC_SAMPLING;}}
 if range{key|=MeshPipelineKey::VISIBILITY_RANGE_DITHER;}
 if view.contains(MeshPipelineKey::MOTION_VECTOR_PREPASS){
  if flags.contains(RenderMeshInstanceFlags::HAS_PREVIOUS_SKIN){key|=MeshPipelineKey::HAS_PREVIOUS_SKIN;}
  if flags.contains(RenderMeshInstanceFlags::HAS_PREVIOUS_MORPH){key|=MeshPipelineKey::HAS_PREVIOUS_MORPH;}
 }key
}
fn prepare(world:&mut World){
 let Some(frame)=world.get_resource::<Requests>().cloned()else{return;};let mut answers=HashMap::new();
 let observed_views:Vec<_>={let mut q=world.query::<(&ExtractedView,&RenderVisibleEntities)>();q.iter(world).map(|(v,e)|(v.retained_view_entity,e.get::<Mesh3d>().map(|class|class.iter_visible().map(|(_,main)|*main).collect::<Vec<_>>()).unwrap_or_default())).collect()};
 for candidate in &frame.entries{
  let mut answer=Answer::default();let main=MainEntity::from(candidate.stamp.draw);
  let prepared=(||{
   let mesh=world.get_resource::<RenderAssets<RenderMesh>>()?.get(candidate.mesh.id())?;
   let material=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>()?.get(candidate.material.id())?;
   let allocator=world.get_resource::<MaterialBindGroupAllocators>()?.get(&std::any::TypeId::of::<Material>())?;
   allocator.get(material.binding.group)?.bind_group()?;
   let instance=world.get_resource::<RenderMeshInstances>()?.render_mesh_queue_data(main)?;
   if instance.mesh_asset_id()!=candidate.mesh.id(){return None;}
   let lightmap=candidate.lightmap;
   let range=world.get_resource::<RenderVisibilityRanges>()?.entity_has_crossfading_visibility_ranges(main);
   let views=world.get_resource::<ViewKeyCache>()?;
   let keys:Vec<_>=observed_views.iter().filter(|(_,visible)|visible.contains(&main)).filter_map(|(id,_)|views.get(id)).map(|view|ErasedMaterialPipelineKey{
    type_id:std::any::TypeId::of::<Material>(),
    mesh_key:ErasedMeshPipelineKey::new(mesh_key(*view,MeshPipelineKey::from_bits_retain(mesh.key_bits.bits()),material.properties.mesh_pipeline_key_bits.downcast(),material.properties.alpha_mode,lightmap,range,instance.flags())),
    material_key:material.properties.material_key.clone(),
   }).collect();Some((mesh.layout.clone(),material.properties.clone(),keys))
  })();
  if let Some((layout,properties,keys))=prepared{
   if let Some(specialize)=properties.base_specialize{
    let mut ready=!keys.is_empty();
    for key in keys{match specialize(world,key,&layout,&properties){
     Ok(id)=>{answer.pipelines+=1;ready&=world.resource::<PipelineCache>().get_render_pipeline(id).is_some();},
     Err(error)=>{ready=false;answer.error=Some(error.to_string());},
    }}answer.ready=ready;
   }
  }answers.insert(candidate.stamp,answer);
 }
 if let Ok(mut destination)=frame.answers.lock(){*destination=answers;};
}
pub(crate)fn install(app:&mut App){
 app.init_resource::<Candidates>().init_resource::<Requests>().add_plugins(ExtractResourcePlugin::<Requests>::default())
  .add_systems(PostUpdate,collect.after(bevy::transform::TransformSystems::Propagate).before(crate::native_minion_fade_producer::synchronize));
 app.sub_app_mut(RenderApp).add_systems(Render,prepare.in_set(RenderSystems::PrepareBindGroups).after(bevy::pbr::prepare_material_bind_groups));
}
#[cfg(test)]pub(crate)fn ready_fixture(world:&mut World,draw:Entity){
 // Controlled CPU ownership test only: no GPU readiness or pixels are claimed.
 world.init_resource::<Candidates>();world.init_resource::<Requests>();
 if world.get_resource::<Assets<Mesh>>().is_none(){world.insert_resource(Assets::<Mesh>::default());}
 let handle=world.resource_mut::<Assets<Mesh>>().add(Mesh::from(Cuboid::new(1.,1.,1.)));
 world.entity_mut(draw).insert(Mesh3d(handle));collect(world);
 let stamp=world.resource::<Candidates>().entries.get(&draw).unwrap().stamp;
 world.resource::<Requests>().answers.lock().unwrap().insert(stamp,Answer{ready:true,pipelines:1,error:None});
}
#[cfg(test)]#[path="native_minion_fade_test_fixture.rs"]mod test_helper;
#[cfg(test)]mod tests{
 use super::*;
 use super::test_helper as helper;
 #[test]fn private_preparation_pending_preserves_baseline_then_ready_and_stale_reload_are_distinct(){
  let(mut app,owner,draw,sibling,previous)=helper::fixture();
  ready_fixture(app.world_mut(),draw);let stamp=app.world().resource::<Candidates>().entries[&draw].stamp;
  app.world().resource::<Requests>().answers.lock().unwrap().insert(stamp,Answer::default());
  assert!(!crate::native_minion_fade_material::publish(app.world_mut(),owner,draw,0.5).unwrap());
  assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(draw).unwrap().0,previous);
  assert!(app.world().get::<crate::native_minion_fade_material::Guard>(draw).is_none());
  app.world().resource::<Requests>().answers.lock().unwrap().insert(stamp,Answer{ready:true,pipelines:1,error:None});
  // A shader-key reload rejects the old ready response before any replacement.
  let original_cull=app.world().resource::<Assets<FogMaterial>>().get(&previous).unwrap().base.cull_mode;
  app.world_mut().resource_mut::<Assets<FogMaterial>>().get_mut(&previous).unwrap().base.cull_mode=Some(bevy::render::render_resource::Face::Front);
  assert!(!crate::native_minion_fade_material::publish(app.world_mut(),owner,draw,0.5).unwrap());
  app.world_mut().resource_mut::<Assets<FogMaterial>>().get_mut(&previous).unwrap().base.cull_mode=original_cull;
  assert!(crate::native_minion_fade_material::publish(app.world_mut(),owner,draw,0.5).unwrap());
  assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(sibling).unwrap().0,previous);
  assert!(crate::native_minion_fade_material::release(app.world_mut(),draw).unwrap());
  assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(draw).unwrap().0,previous);
 }
 #[test]fn dynamic_skin_morph_lightmap_and_view_bits_are_retained_in_private_variant(){
  let view=MeshPipelineKey::from_target_format(bevy::render::render_resource::TextureFormat::Rgba16Float)|MeshPipelineKey::TONEMAP_IN_SHADER|MeshPipelineKey::MOTION_VECTOR_PREPASS|MeshPipelineKey::from_msaa_samples(4);
  let flags=RenderMeshInstanceFlags::HAS_PREVIOUS_SKIN|RenderMeshInstanceFlags::HAS_PREVIOUS_MORPH;
  let key=mesh_key(view,MeshPipelineKey::MORPH_TARGETS,MeshPipelineKey::empty(),AlphaMode::Blend,Some(true),true,flags);
  assert!(key.contains(view|MeshPipelineKey::MORPH_TARGETS|MeshPipelineKey::HAS_PREVIOUS_SKIN|MeshPipelineKey::HAS_PREVIOUS_MORPH|MeshPipelineKey::LIGHTMAPPED|MeshPipelineKey::LIGHTMAP_BICUBIC_SAMPLING|MeshPipelineKey::VISIBILITY_RANGE_DITHER|MeshPipelineKey::BLEND_ALPHA));
  let ordinary=mesh_key(MeshPipelineKey::empty(),MeshPipelineKey::MORPH_TARGETS,MeshPipelineKey::empty(),AlphaMode::Blend,None,false,flags);
  assert!(!ordinary.intersects(MeshPipelineKey::HAS_PREVIOUS_SKIN|MeshPipelineKey::HAS_PREVIOUS_MORPH|MeshPipelineKey::LIGHTMAPPED|MeshPipelineKey::VISIBILITY_RANGE_DITHER));
 }
}
