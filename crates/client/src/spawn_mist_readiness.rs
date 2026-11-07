//! Actual render-world mist admission. No fabricated GPU-ready producer.
//! Cold private materials are specialized in the normal transparent phase;
//! responses feed their CPU control on the next frame, while this draw guard
//! still rechecks current assets, bind groups, FoW and the exact item pipeline.
use bevy::{prelude::*,asset::AssetId,core_pipeline::{core_3d::Transparent3d,schedule::camera_driver},
 render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,
 erased_render_asset::ErasedRenderAssets,mesh::RenderMesh,render_resource::{PipelineCache,TextureDimension},
 texture::GpuImage,sync_world::MainEntity,renderer::RenderGraph,
 render_phase::{ViewSortedRenderPhases,Draw,DrawError,DrawFunctions,RenderCommand,RenderCommandResult,RenderCommandState,TrackedRenderPass}},
 pbr::{PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,RenderMeshInstances,SpecializedMaterialPipelineCache,DrawMaterial}};
use crate::{spawn_mist_live::{Backend,Ticket,ReadyAnswers,ImageLayout},spawn_mist_material::{MistMaterial,BindingEvidenceHandle}};
use bevy::ecs::{query::ROQueryItem,system::{lifetimeless::SRes,SystemParamItem}};
#[derive(Clone)]struct MaterialEvidence{material:AssetId<MistMaterial>,images:[AssetId<Image>;4],words:[u32;20],evidence:BindingEvidenceHandle}
#[derive(Resource,Clone,Default,ExtractResource)]struct Frame{admitted:bool,tickets:Vec<Ticket>,layouts:Option<[ImageLayout;2]>,published_frames:u64,answers:ReadyAnswers,evidence:Vec<MaterialEvidence>}
#[derive(Resource,Default)]struct Observation{frame:u64,ready:Vec<serde_json::Value>,commands:std::sync::Mutex<Vec<serde_json::Value>>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Frame>().add_plugins(ExtractResourcePlugin::<Frame>::default())
 .add_systems(PostUpdate,extract.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));
 let render=app.sub_app_mut(RenderApp);render.init_resource::<Observation>().add_systems(RenderGraph,(gate.after(crate::fow_gpu::Encoded).before(camera_driver),flush.after(camera_driver)));
 let draw=GuardedDraw(RenderCommandState::new(render.world_mut()));render.world().resource::<DrawFunctions<Transparent3d>>().write().add(draw);}}
fn extract(backend:Res<Backend>,answers:Res<ReadyAnswers>,materials:Res<Assets<MistMaterial>>,mut frame:ResMut<Frame>){frame.tickets=backend.tickets();frame.layouts=backend.layouts;frame.published_frames=backend.published_frames;frame.answers=answers.clone();
 frame.evidence=frame.tickets.iter().filter_map(|t|materials.get(t.material).map(|m|MaterialEvidence{material:t.material,images:m.images().map(|i|i.id()),words:m.uniform_words(),evidence:m.binding_evidence.clone()})).collect();
 frame.admitted=backend.error.is_none()&&backend.published_frames>0&&backend.binding.is_some();}
fn image(world:&World,id:AssetId<Image>,expected:ImageLayout)->Result<(),String>{
 let gpu=world.get_resource::<RenderAssets<GpuImage>>().and_then(|a|a.get(id)).ok_or("mist GPU image pending")?;let d=&gpu.texture_descriptor;
 if d.dimension!=TextureDimension::D2||[d.size.width,d.size.height,d.size.depth_or_array_layers]!=expected.extent||d.mip_level_count!=expected.mips||d.format!=expected.format||d.sample_count!=1{return Err("mist exact GPU image layout changed".into());}Ok(())
}
fn ready(world:&World,ticket:&Ticket)->Result<(),String>{
 let frame=world.get_resource::<Frame>().filter(|f|f.admitted).ok_or("mist current CPU publication rejected")?;
 if !frame.tickets.contains(ticket)||ticket.source>=2{return Err("mist exact current ticket absent".into());}
 if !crate::fow_gpu::ready_for(world,ticket.binding.session,ticket.images[2]){return Err("mist current FoW not encoded".into());}
 let layouts=frame.layouts.ok_or("mist source image layouts absent")?;image(world,ticket.images[0],layouts[0])?;image(world,ticket.images[1],layouts[1])?;
 image(world,ticket.images[2],ImageLayout{extent:[512,512,1],mips:1,format:bevy::render::render_resource::TextureFormat::Rgba8Unorm})?;
 if world.get_resource::<RenderAssets<GpuImage>>().and_then(|a|a.get(ticket.images[3])).is_none(){return Err("mist overlay GPU image pending".into());}
 let entity=MainEntity::from(ticket.draw);
 if world.get_resource::<RenderAssets<RenderMesh>>().and_then(|a|a.get(ticket.mesh)).is_none(){return Err("mist actual GPU mesh pending".into());}
 if world.get_resource::<RenderMeshInstances>().and_then(|a|a.mesh_asset_id(entity))!=Some(ticket.mesh){return Err("mist extracted mesh identity changed".into());}
 if world.get_resource::<RenderMaterialInstances>().and_then(|a|a.instances.get(&entity)).map(|a|a.asset_id)!=Some(ticket.material.untyped()){return Err("mist extracted material identity changed".into());}
 let material=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>().and_then(|a|a.get(ticket.material)).ok_or("mist prepared material pending")?;
 let evidence=frame.evidence.iter().find(|e|e.material==ticket.material&&e.images==ticket.images).ok_or("mist exact extracted material binding evidence absent")?;
 let binding=evidence.evidence.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner).ok_or("mist real AsBindGroup producer pending")?;
 if binding.uniform_words!=evidence.words{return Err("mist GPU uniform generation differs from extracted material".into());}
 let gpu=world.get_resource::<RenderAssets<GpuImage>>().ok_or("mist GPU images absent")?;
 for i in 0..4{let image=gpu.get(ticket.images[i]).ok_or("mist bound GPU image missing")?;
  if binding.views[i]!=image.texture_view.id()||binding.samplers[i]!=image.sampler.id(){return Err("mist material still binds an older GPU image/sampler generation".into());}
 }
 let allocator=world.get_resource::<MaterialBindGroupAllocators>().and_then(|a|a.get(&std::any::TypeId::of::<MistMaterial>())).ok_or("mist actual material allocator pending")?;
 if allocator.get(material.binding.group).and_then(|group|group.bind_group()).is_none(){return Err("mist actual bind group pending".into());}
 let pipelines=world.get_resource::<SpecializedMaterialPipelineCache>().ok_or("mist specialized pipeline cache absent")?;
 let cache=world.get_resource::<PipelineCache>().ok_or("mist pipeline cache absent")?;
 if !pipelines.values().filter_map(|view|view.get(&entity)).any(|pipeline|cache.get_render_pipeline(*pipeline).is_some()){return Err("mist actual specialized pipeline pending".into());}Ok(())
}

// Read-only witness of the actual extracted CPU material and AsBindGroup
// resource producer. These words are not a GPU-buffer readback.
fn binding_words(frame:&Frame,ticket:&Ticket)->serde_json::Value{
 let source=frame.evidence.iter().find(|e|e.material==ticket.material&&e.images==ticket.images);
 let (binding,status)=match source{
  Some(source)=>match source.evidence.0.lock(){
   Ok(value)=>(*value,Some("read")),
   Err(poisoned)=>(*poisoned.into_inner(),Some("poison_recovered_read")),
  },None=>(None,None),
 };
 serde_json::json!({"mesh_asset_id":format!("{:?}",ticket.mesh),"material_asset_id":format!("{:?}",ticket.material),
  "image_asset_ids":ticket.images.map(|id|format!("{id:?}")),
  "extracted_uniform_words":source.map(|e|e.words),"actual_AsBindGroup_uniform_words":binding.map(|b|b.uniform_words),
  "uniform_words_match":source.and_then(|e|binding.map(|b|b.uniform_words==e.words)),
  "actual_AsBindGroup_texture_view_ids":binding.map(|b|b.views.map(|id|format!("{id:?}"))),
  "actual_AsBindGroup_sampler_ids":binding.map(|b|b.samplers.map(|id|format!("{id:?}"))),
  "binding_evidence_read_status":status,"GPU_buffer_readback":false})
}
fn current_gpu_images(world:&World,ticket:&Ticket)->serde_json::Value{
 let gpu=world.get_resource::<RenderAssets<GpuImage>>();
 let source=world.get_resource::<Frame>().and_then(|f|f.evidence.iter().find(|e|e.material==ticket.material&&e.images==ticket.images));
 let binding=source.and_then(|e|*e.evidence.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner));
 let rows=ticket.images.iter().copied().enumerate().map(|(slot,id)|{
  let image=gpu.and_then(|a|a.get(id));
  serde_json::json!({"slot":slot,"image_asset_id":format!("{id:?}"),
   "current_GPU_texture_view_id":image.map(|i|format!("{:?}",i.texture_view.id())),
   "current_GPU_sampler_id":image.map(|i|format!("{:?}",i.sampler.id())),
   "matches_actual_AsBindGroup_view":image.and_then(|i|binding.map(|b|b.views[slot]==i.texture_view.id())),
   "matches_actual_AsBindGroup_sampler":image.and_then(|i|binding.map(|b|b.samplers[slot]==i.sampler.id()))})
 }).collect::<Vec<_>>();serde_json::json!(rows)
}

fn row(ticket:&Ticket)->serde_json::Value{serde_json::json!({"session":ticket.binding.session,"source":ticket.source,"effect":if ticket.source==0{"Chaos_Spawn"}else{"Order_Spawn"},"slot":ticket.slot,"birth":ticket.birth,"counter":ticket.counter,"draw":ticket.draw.to_bits(),"map_root":ticket.binding.map_root.to_bits(),"source_root":ticket.binding.roots[ticket.source].to_bits()})}
fn gate(world:&mut World){
 let Some(frame)=world.get_resource::<Frame>().cloned()else{return};let mut answers=Vec::new();let mut records=Vec::new();
 for ticket in &frame.tickets{let result=ready(world,ticket);if result.is_ok(){answers.push(ticket.clone());}let mut record=row(ticket);record["ready"]=result.is_ok().into();record["reason"]=result.err().into();if std::env::var_os("OPENLEAGUE_SPAWN_MIST_RENDER_PROBE").is_some(){record["binding_observation"]=binding_words(&frame,ticket);record["current_GPU_images"]=current_gpu_images(world,ticket);}records.push(record);}
 *frame.answers.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner)=answers;
 let ids:std::collections::HashSet<_>=frame.tickets.iter().map(|t|t.draw).collect();let guard=world.resource::<DrawFunctions<Transparent3d>>().read().id::<GuardedDraw>();
 if let Some(mut phases)=world.get_resource_mut::<ViewSortedRenderPhases<Transparent3d>>(){for(_,phase)in phases.0.iter_mut(){for(_,item)in phase.items.iter_mut(){if ids.contains(&item.entity.1.id()){item.draw_function=guard;}}}}
 let mut observation=world.resource_mut::<Observation>();observation.frame=observation.frame.saturating_add(1);observation.ready=records;observation.commands.lock().unwrap_or_else(std::sync::PoisonError::into_inner).clear();
}
fn record(world:&World,ticket:Option<&Ticket>,view:Entity,item:&Transparent3d,stage:&str,reason:Option<&str>){
 if std::env::var_os("OPENLEAGUE_SPAWN_MIST_RENDER_PROBE").is_none(){return;}
 if let Some(observation)=world.get_resource::<Observation>(){let mut record=ticket.map(row).unwrap_or_else(||serde_json::json!({}));record["stage"]=stage.into();record["reason"]=reason.into();record["view"]=view.to_bits().into();record["batch_start"]=item.batch_range.start.into();record["batch_end"]=item.batch_range.end.into();
 record["actual_pipeline_id"]=format!("{:?}",item.pipeline).into();
 record["actual_pipeline_cached"]=world.get_resource::<PipelineCache>().map(|cache|cache.get_render_pipeline(item.pipeline).is_some()).into();
 record["actual_view_invert_culling"]=world.get::<bevy::render::view::ExtractedView>(view).map(|v|v.invert_culling).into();
 record["actual_retained_main_view_entity"]=world.get::<bevy::render::view::ExtractedView>(view).map(|v|format!("{:?}",v.retained_view_entity.main_entity)).into();
 let mut commands=observation.commands.lock().unwrap_or_else(std::sync::PoisonError::into_inner);if commands.len()<4096{commands.push(record);}}
}
fn flush(world:&World){let Ok(path)=std::env::var("OPENLEAGUE_SPAWN_MIST_RENDER_PROBE")else{return};let Some(frame)=world.get_resource::<Frame>()else{return};let observation=world.resource::<Observation>();
 let doc=serde_json::json!({"schema":"map10_spawn_mist_render_v1","telemetry_schema":"map10_spawn_mist_binding_telemetry_v1","GPU_buffer_readback":false,"frame":observation.frame,"published_frames":frame.published_frames,"ready":observation.ready,"commands":*observation.commands.lock().unwrap_or_else(std::sync::PoisonError::into_inner),"ordinary_reconstructed_static_policy":true,"original_missing_asset_parity":false,"native_trigger_parity":false,"native_pixel_parity":false,"visible_pixels_proven":false});
 if let Ok(bytes)=serde_json::to_vec(&doc){let _=std::fs::write(path,bytes);}}
struct ObservedMaterial;
impl RenderCommand<Transparent3d> for ObservedMaterial{
 type Param=(<DrawMaterial as RenderCommand<Transparent3d>>::Param,SRes<Observation>,SRes<Frame>);
 type ViewQuery=(Entity,<DrawMaterial as RenderCommand<Transparent3d>>::ViewQuery);
 type ItemQuery=<DrawMaterial as RenderCommand<Transparent3d>>::ItemQuery;
 fn render<'w>(item:&Transparent3d,(view,query):ROQueryItem<'w,'_,Self::ViewQuery>,entity:Option<ROQueryItem<'w,'_,Self::ItemQuery>>,(param,observation,frame):SystemParamItem<'w,'_,Self::Param>,pass:&mut TrackedRenderPass<'w>)->RenderCommandResult{
  let result=<DrawMaterial as RenderCommand<Transparent3d>>::render(item,query,entity,param,pass);
  if std::env::var_os("OPENLEAGUE_SPAWN_MIST_RENDER_PROBE").is_some(){let ticket=frame.tickets.iter().find(|t|t.draw==item.entity.1.id());let mut value=ticket.map(row).unwrap_or_else(||serde_json::json!({}));
   let(stage,reason)=match &result{RenderCommandResult::Success=>("material_success",None),RenderCommandResult::Skip=>("material_skip",None),RenderCommandResult::Failure(reason)=>("material_failure",Some(*reason))};value["stage"]=stage.into();value["reason"]=reason.into();value["view"]=view.to_bits().into();value["batch_start"]=item.batch_range.start.into();value["batch_end"]=item.batch_range.end.into();value["actual_pipeline_id"]=format!("{:?}",item.pipeline).into();
   value["binding_observation"]=ticket.map(|t|binding_words(&frame,t)).unwrap_or(serde_json::Value::Null);
   // Guard metadata was read from the real World immediately before this exact
   // delegate, in the same cleared per-frame command journal. Missing context
   // remains null; no culling/pipeline value is synthesized from success.
   let mut commands=observation.commands.lock().unwrap_or_else(std::sync::PoisonError::into_inner);
   value["actual_guard_dispatch_context"]=commands.iter().rev().find(|r|r["stage"]=="delegated"&&r["view"]==value["view"]&&r["draw"]==value["draw"]&&r["batch_start"]==value["batch_start"]&&r["batch_end"]==value["batch_end"]&&r["actual_pipeline_id"]==value["actual_pipeline_id"]).map(|r|serde_json::json!({
    "origin":"same_frame_exact_guard_delegated","actual_pipeline_id":r["actual_pipeline_id"],"actual_pipeline_cached":r["actual_pipeline_cached"],
    "actual_view_invert_culling":r["actual_view_invert_culling"],"actual_retained_main_view_entity":r["actual_retained_main_view_entity"]})).unwrap_or(serde_json::Value::Null);
   commands.push(value);
  }result
 }
}
struct GuardedDraw(RenderCommandState<Transparent3d,ObservedMaterial>);
impl Draw<Transparent3d> for GuardedDraw{
 fn prepare(&mut self,world:&World){self.0.prepare(world);}
 fn draw<'w>(&mut self,world:&'w World,pass:&mut TrackedRenderPass<'w>,view:Entity,item:&Transparent3d)->Result<(),DrawError>{
  let ticket=world.get_resource::<Frame>().and_then(|frame|frame.tickets.iter().find(|t|t.draw==item.entity.1.id()));record(world,ticket,view,item,"guard_attempt",None);
  let Some(ticket)=ticket else{record(world,None,view,item,"guard_rejected",Some("exact current mist ticket absent"));return Ok(())};
  if item.batch_range.end<=item.batch_range.start{record(world,Some(ticket),view,item,"guard_rejected",Some("mist draw instance range is empty"));return Ok(())}
  if !world.get_resource::<Frame>().and_then(|f|f.evidence.iter().find(|e|e.material==ticket.material)).is_some_and(|e|e.words[16]==1){record(world,Some(ticket),view,item,"guard_rejected",Some("mist cold material specialized; awaiting next CPU readiness response"));return Ok(())}
  if !world.get::<bevy::render::view::ExtractedView>(view).is_some_and(|v|v.invert_culling){record(world,Some(ticket),view,item,"guard_rejected",Some("mist actual view not reflected"));return Ok(())}
  if world.get_resource::<PipelineCache>().and_then(|cache|cache.get_render_pipeline(item.pipeline)).is_none(){record(world,Some(ticket),view,item,"guard_rejected",Some("exact current mist item pipeline pending"));return Ok(())}
  let extracted=world.get::<bevy::render::view::ExtractedView>(view).unwrap();
  if world.get_resource::<SpecializedMaterialPipelineCache>().and_then(|cache|cache.get(&extracted.retained_view_entity)).and_then(|cache|cache.get(&MainEntity::from(ticket.draw)))!=Some(&item.pipeline){record(world,Some(ticket),view,item,"guard_rejected",Some("mist pipeline is not associated with this exact current view/entity"));return Ok(())}
  if let Err(reason)=ready(world,ticket){record(world,Some(ticket),view,item,"guard_rejected",Some(&reason));return Ok(())}
  record(world,Some(ticket),view,item,"delegated",None);let result=self.0.draw(world,pass,view,item);
  match &result{Ok(())=>record(world,Some(ticket),view,item,"returned_ok",None),Err(error)=>record(world,Some(ticket),view,item,"returned_error",Some(&error.to_string()))}result
 }
}
