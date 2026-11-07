//! Readonly render-world readiness and phase observations; no draw redirection.
use bevy::{prelude::*,asset::AssetId,core_pipeline::{core_3d::Transparent3d,schedule::camera_driver},render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,erased_render_asset::ErasedRenderAssets,mesh::RenderMesh,texture::GpuImage,sync_world::MainEntity,render_resource::PipelineCache,renderer::RenderGraph,render_phase::ViewSortedRenderPhases},pbr::{PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,RenderMeshInstances,SpecializedMaterialPipelineCache}};
use crate::native_minion_fade_material::Material;
#[derive(Clone)]pub(crate)struct Ticket{pub network:u32,pub root:Entity,pub model:String,pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:AssetId<Material>,pub images:Vec<AssetId<Image>>,pub visibility:AssetId<Image>}
#[derive(Resource,Clone,Default,ExtractResource)]pub(crate)struct Frame{pub directory:Option<std::path::PathBuf>,pub key:Option<(u64,u64,u32)>,pub probe_frame:u64,pub age:f64,pub tickets:Vec<Ticket>}
#[derive(Resource,Default)]struct Last{probe_frame:u64}
pub(crate)fn install(app:&mut App){app.init_resource::<Frame>().add_plugins(ExtractResourcePlugin::<Frame>::default());app.sub_app_mut(RenderApp).init_resource::<Last>().add_systems(RenderGraph,observe.after(camera_driver));}
fn readiness(world:&World,ticket:&Ticket,key:(u64,u64,u32))->Vec<String>{
 let mut missing=Vec::new();let entity=MainEntity::from(ticket.draw);
 if world.get_resource::<RenderAssets<RenderMesh>>().and_then(|m|m.get(ticket.mesh)).is_none(){missing.push("GPU mesh pending".into());}
 if world.get_resource::<RenderMeshInstances>().and_then(|m|m.mesh_asset_id(entity))!=Some(ticket.mesh){missing.push("extracted mesh differs".into());}
 if world.get_resource::<RenderMaterialInstances>().and_then(|m|m.instances.get(&entity)).map(|v|v.asset_id)!=Some(ticket.material.untyped()){missing.push("extracted material differs".into());}
 let material=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>().and_then(|m|m.get(ticket.material));if material.is_none(){missing.push("prepared GPU material pending".into());}
 let bind=material.and_then(|m|world.get_resource::<MaterialBindGroupAllocators>()?.get(&std::any::TypeId::of::<Material>())?.get(m.binding.group)?.bind_group());if bind.is_none(){missing.push("actual bind group pending".into());}
 let images=world.get_resource::<RenderAssets<GpuImage>>();if ticket.images.iter().any(|id|images.and_then(|m|m.get(*id)).is_none()){missing.push("actual GPU material image pending".into());}
 if !crate::fow_gpu::ready_for(world,key.0,ticket.visibility){missing.push("current session FoW not encoded".into());}
 let pipelines=world.get_resource::<SpecializedMaterialPipelineCache>();let cache=world.get_resource::<PipelineCache>();if !pipelines.is_some_and(|p|p.values().filter_map(|v|v.get(&entity)).any(|id|cache.is_some_and(|c|c.get_render_pipeline(*id).is_some()))){missing.push("actual specialized pipeline pending".into());}
 missing
}
fn observe(world:&mut World){
 let Some(frame)=world.get_resource::<Frame>().cloned()else{return;};let(Some(key),Some(directory))=(frame.key,frame.directory)else{return;};if frame.probe_frame==0||world.resource::<Last>().probe_frame==frame.probe_frame{return;}world.resource_mut::<Last>().probe_frame=frame.probe_frame;
 let mut rows=Vec::new();for ticket in &frame.tickets{let missing=readiness(world,ticket,key);let mut phases=Vec::new();if let Some(render_phases)=world.get_resource::<ViewSortedRenderPhases<Transparent3d>>(){for(view,phase)in &render_phases.0{for item in phase.items.values(){if item.entity.1.id()==ticket.draw{phases.push(serde_json::json!({"view":format!("{view:?}"),"batch_start":item.batch_range.start,"batch_end":item.batch_range.end,"pipeline_ready":world.get_resource::<PipelineCache>().is_some_and(|p|p.get_render_pipeline(item.pipeline).is_some())}));}}}}
  rows.push(serde_json::json!({"id":ticket.network,"root":format!("{:?}",ticket.root),"model":ticket.model,"draw":format!("{:?}",ticket.draw),"mesh":format!("{:?}",ticket.mesh),"material":format!("{:?}",ticket.material),"ready":missing.is_empty(),"missing":missing,"phase_members":phases,"material_command_success":null}));
 }
 let row=serde_json::json!({"stage":"render_readiness","schema":1,"key":key,"source_probe_frame":frame.probe_frame,"source_age":frame.age,"rows":rows,"draw_submission_qualified":false,"visible_pixels_qualified":false,"primary_window_view_qualified":false,"limits":["Real GPU resources and current transparent phase only; no DrawMaterial redirection or success observation.","Pipeline available in at least one actual view; phase membership includes all views and does not identify primary-window minion pixels.","CPU publication frame/age identifies extracted request; no exact GPU exposure timestamp or original framebuffer parity."]});use std::io::Write;let result=(||->std::io::Result<()>{let mut file=std::fs::OpenOptions::new().create(true).append(true).open(directory.join("gpu.jsonl"))?;writeln!(file,"{row}")})();if let Err(e)=result{warn!("Fade GPU observation: {e}");}
}
