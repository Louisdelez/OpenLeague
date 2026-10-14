//! Actual render-world admission and opt-in command dispatch evidence.
use bevy::{prelude::*,asset::AssetId,core_pipeline::{core_3d::Transparent3d,schedule::camera_driver},
 render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,erased_render_asset::ErasedRenderAssets,
 mesh::RenderMesh,render_resource::{PipelineCache,TextureFormat,TextureDimension},texture::GpuImage,sync_world::MainEntity,renderer::RenderGraph,
 render_phase::{ViewSortedRenderPhases,Draw,DrawError,DrawFunctions,RenderCommand,RenderCommandResult,RenderCommandState,TrackedRenderPass}},
 pbr::{PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,RenderMeshInstances,SpecializedMaterialPipelineCache,DrawMaterial}};
use crate::{relic_pickup_seven_render::{Backend,Ticket,ExpectedImage},nexus_glow_material::GlowMaterial};
use bevy::ecs::{query::ROQueryItem,system::{lifetimeless::SRes,SystemParamItem}};
#[derive(Resource,Clone,Default,ExtractResource)]struct Frame{admitted:bool,tickets:Vec<Ticket>,published_frames:u64}
#[derive(Default)]struct DispatchState{frame:u64,published_frames:u64,readiness:Vec<serde_json::Value>,phase_members:Vec<serde_json::Value>,commands:Vec<serde_json::Value>,dropped:u64}
impl DispatchState{
 fn begin(&mut self,published_frames:u64,readiness:Vec<serde_json::Value>){let frame=self.frame.saturating_add(1);*self=Self{frame,published_frames,readiness,..default()};}
 fn push(&mut self,row:serde_json::Value){if self.commands.len()<16384{self.commands.push(row);}else{self.dropped+=1;}}
 fn counts(&self)->serde_json::Value{let mut counts=serde_json::Map::new();for stage in ["guard_attempt","guard_rejected","delegated","material_success","material_skip","material_failure","returned_ok","returned_error"]{counts.insert(stage.into(),serde_json::json!(self.commands.iter().filter(|v|v["stage"]==stage).count()));}serde_json::Value::Object(counts)}
}
#[derive(Resource)]struct Dispatch{enabled:bool,state:std::sync::Mutex<DispatchState>}
impl Default for Dispatch{fn default()->Self{Self{enabled:std::env::var_os("OPENLEAGUE_RELIC_PICKUP_DISPATCH_PROBE").is_some(),state:default()}}}
fn command_row(ticket:Option<&Ticket>,view:Entity,item:&Transparent3d,stage:&str,reason:Option<&str>)->serde_json::Value{
 serde_json::json!({"stage":stage,"reason":reason,"view":view.to_bits(),"draw":item.entity.1.id().to_bits(),
 "session":ticket.map(|t|t.key.session),"pickup_tick":ticket.map(|t|t.key.pickup_tick),"picker":ticket.map(|t|t.key.picker),
 "group":ticket.map(|t|t.group.index()),"source_class":ticket.map(|t|format!("{:?}",t.group.class())),"source_group":ticket.map(|t|t.group.name()),"counter":ticket.and_then(|t|t.counter),"slot":ticket.map(|t|t.slot),"birth":ticket.map(|t|t.birth),
 "batch_start":item.batch_range.start,"batch_end":item.batch_range.end,"extra_index":format!("{:?}",item.extra_index)})
}
fn record(world:&World,ticket:Option<&Ticket>,view:Entity,item:&Transparent3d,stage:&str,reason:Option<&str>){let Some(dispatch)=world.get_resource::<Dispatch>().filter(|d|d.enabled)else{return};dispatch.state.lock().unwrap_or_else(std::sync::PoisonError::into_inner).push(command_row(ticket,view,item,stage,reason));}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Frame>().add_plugins(ExtractResourcePlugin::<Frame>::default())
 .add_systems(PostUpdate,extract.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));
 let render_app=app.sub_app_mut(RenderApp);render_app.init_resource::<Dispatch>().add_systems(RenderGraph,(gate.after(crate::fow_gpu::Encoded).before(camera_driver),flush.after(camera_driver)));
 let draw=GuardedDraw(RenderCommandState::new(render_app.world_mut()));render_app.world().resource::<DrawFunctions<Transparent3d>>().write().add(draw);}}
fn extract(backend:Res<Backend>,mut frame:ResMut<Frame>){frame.tickets=backend.tickets();frame.published_frames=backend.published_frames;frame.admitted=backend.error.is_none()&&backend.published_frames>0;}
pub(crate) fn image(world:&World,id:AssetId<Image>,expected:ExpectedImage)->Result<(),String>{
 let images=world.get_resource::<RenderAssets<GpuImage>>().ok_or("seven-group GPU images absent")?;
 let image=images.get(id).ok_or("seven-group GPU image pending")?;let d=&image.texture_descriptor;
 if expected.source!=expected.storage||d.dimension!=TextureDimension::D2||d.format!=expected.format
  ||[d.size.width,d.size.height,d.size.depth_or_array_layers]!=expected.storage||d.mip_level_count!=expected.mips||d.sample_count!=1{
  return Err("seven-group exact DDS GPU layout mismatch".into());
 }Ok(())
}
fn ready(world:&World,ticket:&Ticket)->Result<(),String>{
 if !world.get_resource::<Frame>().is_some_and(|frame|frame.admitted){return Err("seven-group CPU publication rejected".into());}
 if (ticket.group.class()==crate::relic_pickup_seven_identity::Class::Complex)!=ticket.counter.is_some(){return Err("seven-group particle source class differs".into());}
 if !crate::fow_gpu::ready_for(world,ticket.key.session,ticket.images[2]){return Err("pickup current FoW not encoded".into());}
 image(world,ticket.images[0],ticket.layouts[0])?;image(world,ticket.images[1],ticket.layouts[1])?;
 image(world,ticket.images[2],ExpectedImage {source:[512,512,1],storage:[512,512,1],mips:1,format:TextureFormat::Rgba8Unorm})?;
 if world.get_resource::<RenderAssets<GpuImage>>().and_then(|images|images.get(ticket.images[3])).is_none(){return Err("pickup overlay GPU image pending".into());}
 let entity=MainEntity::from(ticket.draw);
 if world.get_resource::<RenderAssets<RenderMesh>>().and_then(|m|m.get(ticket.mesh)).is_none(){return Err("pickup GPU mesh pending".into());}
 if world.get_resource::<RenderMeshInstances>().and_then(|m|m.mesh_asset_id(entity))!=Some(ticket.mesh){return Err("pickup extracted mesh differs".into());}
 let instances=world.get_resource::<RenderMaterialInstances>().ok_or("pickup material extraction missing")?;
 if instances.instances.get(&entity).map(|v|v.asset_id)!=Some(ticket.material.untyped()){return Err("pickup extracted material differs".into());}
 let material=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>().and_then(|m|m.get(ticket.material)).ok_or("pickup GPU material pending")?;
 let allocator=world.get_resource::<MaterialBindGroupAllocators>().and_then(|a|a.get(&std::any::TypeId::of::<GlowMaterial>())).ok_or("pickup material allocator pending")?;
 if allocator.get(material.binding.group).and_then(|g|g.bind_group()).is_none(){return Err("pickup bind group pending".into());}
 let pipelines=world.get_resource::<SpecializedMaterialPipelineCache>().ok_or("pickup specialized pipelines missing")?;let cache=world.get_resource::<PipelineCache>().ok_or("pickup pipeline cache missing")?;
 if !pipelines.values().filter_map(|view|view.get(&entity)).any(|id|cache.get_render_pipeline(*id).is_some()){return Err("pickup pipeline pending".into());}Ok(())
}
fn gate(world:&mut World){
 let Some(frame)=world.get_resource::<Frame>().cloned()else{return};let mut records=vec![];
 for ticket in &frame.tickets{let result=ready(world,ticket);records.push(serde_json::json!({"session":ticket.key.session,"pickup_tick":ticket.key.pickup_tick,"picker":ticket.key.picker,"group":ticket.group.index(),"source_class":format!("{:?}",ticket.group.class()),"source_group":ticket.group.name(),"counter":ticket.counter,"slot":ticket.slot,"draw":format!("{:?}",ticket.draw),"ready":result.is_ok(),"reason":result.err()}));}
 if let Some(dispatch)=world.get_resource::<Dispatch>().filter(|d|d.enabled){dispatch.state.lock().unwrap_or_else(std::sync::PoisonError::into_inner).begin(frame.published_frames,records.clone());}
 let ids:std::collections::HashSet<_>=frame.tickets.iter().map(|t|t.draw).collect();
 let guard=world.resource::<DrawFunctions<Transparent3d>>().read().id::<GuardedDraw>();
 let tracing=world.get_resource::<Dispatch>().is_some_and(|d|d.enabled);let mut members=Vec::new();
 if let Some(mut phases)=world.get_resource_mut::<ViewSortedRenderPhases<Transparent3d>>(){for (view,phase) in phases.0.iter_mut(){
  for (_,item) in phase.items.iter_mut(){if ids.contains(&item.entity.1.id()){item.draw_function=guard;}}
  if !tracing{continue;}let items:Vec<_>=phase.items.values().collect();
  for (position,item) in items.iter().enumerate(){if let Some(ticket)=frame.tickets.iter().find(|t|t.draw==item.entity.1.id()){
   let length=item.batch_range.len();let batch_members=items.iter().skip(position).take(length).map(|member|member.entity.1.id().to_bits()).collect::<Vec<_>>();
   members.push(serde_json::json!({"view":format!("{view:?}"),"phase_position":position,"session":ticket.key.session,"pickup_tick":ticket.key.pickup_tick,"picker":ticket.key.picker,"group":ticket.group.index(),"source_class":format!("{:?}",ticket.group.class()),"source_group":ticket.group.name(),"counter":ticket.counter,"slot":ticket.slot,"birth":ticket.birth,"draw":ticket.draw.to_bits(),"batch_start":item.batch_range.start,"batch_end":item.batch_range.end,"extra_index":format!("{:?}",item.extra_index),"batch_members":batch_members,"batch_members_source":"contiguous phase traversal span; GPU instance ownership not independently resolved"}));
  }}
 }}
 if let Some(dispatch)=world.get_resource::<Dispatch>().filter(|d|d.enabled){dispatch.state.lock().unwrap_or_else(std::sync::PoisonError::into_inner).phase_members=members;}
 if let Ok(path)=std::env::var("OPENLEAGUE_RELIC_PICKUP_RENDER_PROBE"){let doc=serde_json::json!({"ordinary_pickup_host":true,"native_trigger_parity":false,"native_pixel_parity":false,"draws":records});if let Err(e)=std::fs::write(path,serde_json::to_vec(&doc).unwrap()){warn!("pickup render report: {e}");}}
}
fn flush(world:&World){let Some(dispatch)=world.get_resource::<Dispatch>().filter(|d|d.enabled)else{return};let Ok(path)=std::env::var("OPENLEAGUE_RELIC_PICKUP_DISPATCH_PROBE")else{return};let state=dispatch.state.lock().unwrap_or_else(std::sync::PoisonError::into_inner);
 let doc=serde_json::json!({"schema":1,"frame":state.frame,"published_frames":state.published_frames,"readiness":state.readiness,"phase_members":state.phase_members,"commands":state.commands,"counts":state.counts(),"dropped":state.dropped,
 "ordinary_pickup_host":true,"native_trigger_parity":false,"visible_pixels_proven":false,"limits":["Readiness alone is not dispatch.","material_success is the actual DrawMaterial tuple result including DrawMesh; returned_ok also includes Skip.","Successful command encoding does not prove a nonzero GPU instance count or visible pixels."]});
 if let Err(e)=std::fs::write(path,serde_json::to_vec(&doc).unwrap()){warn!("pickup dispatch report: {e}");}
}
// RenderCommandState collapses both Success and Skip into Draw::draw Ok.
// Capture the actual tuple result before that collapse, without altering it.
struct ObservedMaterial;
impl RenderCommand<Transparent3d> for ObservedMaterial{
 type Param=(<DrawMaterial as RenderCommand<Transparent3d>>::Param,SRes<Dispatch>,SRes<Frame>);
 type ViewQuery=(Entity,<DrawMaterial as RenderCommand<Transparent3d>>::ViewQuery);
 type ItemQuery=<DrawMaterial as RenderCommand<Transparent3d>>::ItemQuery;
 fn render<'w>(item:&Transparent3d,(view,query):ROQueryItem<'w,'_,Self::ViewQuery>,entity:Option<ROQueryItem<'w,'_,Self::ItemQuery>>,(param,dispatch,frame):SystemParamItem<'w,'_,Self::Param>,pass:&mut TrackedRenderPass<'w>)->RenderCommandResult{
  let result=<DrawMaterial as RenderCommand<Transparent3d>>::render(item,query,entity,param,pass);
  if dispatch.enabled{let ticket=frame.tickets.iter().find(|t|t.draw==item.entity.1.id());let (stage,reason)=match &result{RenderCommandResult::Success=>("material_success",None),RenderCommandResult::Skip=>("material_skip",None),RenderCommandResult::Failure(reason)=>("material_failure",Some(*reason))};dispatch.state.lock().unwrap_or_else(std::sync::PoisonError::into_inner).push(command_row(ticket,view,item,stage,reason));}result
 }
}
struct GuardedDraw(RenderCommandState<Transparent3d,ObservedMaterial>);
impl Draw<Transparent3d> for GuardedDraw{
 fn prepare(&mut self,world:&World){self.0.prepare(world);}
 fn draw<'w>(&mut self,world:&'w World,pass:&mut TrackedRenderPass<'w>,view:Entity,item:&Transparent3d)->Result<(),DrawError>{
  let ticket=world.get_resource::<Frame>().and_then(|frame|frame.tickets.iter().find(|t|t.draw==item.entity.1.id()));record(world,ticket,view,item,"guard_attempt",None);
  if !world.get::<bevy::render::view::ExtractedView>(view).is_some_and(|v|v.invert_culling){record(world,ticket,view,item,"guard_rejected",Some("view absent or not reflected"));return Ok(());}
  let Some(ticket)=ticket else{record(world,None,view,item,"guard_rejected",Some("current ticket absent"));return Ok(());};
  if let Err(reason)=ready(world,ticket){record(world,Some(ticket),view,item,"guard_rejected",Some(&reason));return Ok(());}
  record(world,Some(ticket),view,item,"delegated",None);let result=self.0.draw(world,pass,view,item);
  match &result{Ok(())=>record(world,Some(ticket),view,item,"returned_ok",None),Err(error)=>record(world,Some(ticket),view,item,"returned_error",Some(&error.to_string()))}result
 }
}
