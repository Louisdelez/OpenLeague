//! Current render-world ownership checks for the separate active TT Well Ring path.
//! Actual command results can be observed; readiness/Success do not prove pixels.
use bevy::{prelude::*,asset::AssetId,core_pipeline::{core_3d::Transparent3d,schedule::camera_driver},
    render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,
        erased_render_asset::ErasedRenderAssets,mesh::RenderMesh,texture::GpuImage,sync_world::MainEntity,
        renderer::RenderGraph,render_resource::{PipelineCache,CachedRenderPipelineId,TextureDimension},
        render_phase::{ViewSortedRenderPhases,Draw,DrawError,DrawFunctions,RenderCommand,RenderCommandResult,
            RenderCommandState,TrackedRenderPass}},
    pbr::{PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,RenderMeshInstances,
        SpecializedMaterialPipelineCache,DrawMaterial}};
use bevy::ecs::{query::ROQueryItem,system::{lifetimeless::SRes,SystemParamItem}};
use crate::{tt_well_ring_live::{Backend,Ticket,ImageLayout},nexus_glow_material::GlowMaterial};
#[derive(Resource,Clone,Default,ExtractResource)]
struct Frame {admitted:bool,tickets:Vec<Ticket>,published_frames:u64}
#[derive(Default)]
struct Counters {attempt:u64,rejected:u64,success:u64,skip:u64,failure:u64,
    nonempty_success:std::collections::BTreeMap<crate::tt_well_ring_live::Key,[u64;1]>}
#[derive(Resource,Default)]
struct Dispatch(std::sync::Mutex<Counters>);
fn image(world:&World,id:AssetId<Image>,expected:ImageLayout)->Result<(),String> {
    let image=world.get_resource::<RenderAssets<GpuImage>>().and_then(|a|a.get(id)).ok_or("TT Well Ring GPU image pending")?;
    let d=&image.texture_descriptor;
    if d.dimension!=TextureDimension::D2 || d.format!=expected.format || d.sample_count!=1
        ||[d.size.width,d.size.height,d.size.depth_or_array_layers]!=expected.extent || d.mip_level_count!=expected.mips {
        return Err("TT Well Ring owned GPU image descriptor changed".into());
    }Ok(())
}
fn ready(world:&World,ticket:&Ticket,view:Entity,expected:CachedRenderPipelineId)->Result<(),String> {
    let current=world.get::<bevy::render::view::ExtractedView>(view).ok_or("TT Well Ring current extracted view missing")?;
    if !current.invert_culling {return Err("TT Well Ring current view is outside reflected native camera scope".into());}
    if !world.get_resource::<Frame>().is_some_and(|f|f.admitted){return Err("TT Well Ring CPU publication rejected".into());}
    if !crate::fow_gpu::ready_for(world,ticket.key.session,ticket.images[2]){return Err("TT Well Ring current-session FoW not encoded".into());}
    image(world,ticket.images[0],ticket.layouts[0])?;image(world,ticket.images[1],ticket.layouts[1])?;
    image(world,ticket.images[2],ImageLayout {extent:[512,512,1],mips:1,
        format:bevy::render::render_resource::TextureFormat::Rgba8Unorm})?;
    let gpu=world.get_resource::<RenderAssets<GpuImage>>().ok_or("TT Well Ring GPU image assets absent")?;
    for id in &ticket.images[2..] {if gpu.get(*id).is_none(){return Err("TT Well Ring FoW/overlay GPU pending".into());}}
    let entity=MainEntity::from(ticket.draw);
    if world.get_resource::<RenderAssets<RenderMesh>>().and_then(|a|a.get(ticket.mesh)).is_none()
        ||world.get_resource::<RenderMeshInstances>().and_then(|a|a.mesh_asset_id(entity))!=Some(ticket.mesh) {
        return Err("TT Well Ring GPU/extracted mesh pending or differs".into());
    }
    if world.get_resource::<RenderMaterialInstances>().and_then(|a|a.instances.get(&entity))
        .map(|v|v.asset_id)!=Some(ticket.material.untyped()){return Err("TT Well Ring extracted material differs".into());}
    let material=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>().and_then(|a|a.get(ticket.material))
        .ok_or("TT Well Ring GPU material pending")?;
    let allocator=world.get_resource::<MaterialBindGroupAllocators>().and_then(|a|a.get(&std::any::TypeId::of::<GlowMaterial>()))
        .ok_or("TT Well Ring material allocator pending")?;
    if allocator.get(material.binding.group).and_then(|g|g.bind_group()).is_none(){return Err("TT Well Ring bind group pending".into());}
    let pipelines=world.get_resource::<SpecializedMaterialPipelineCache>().ok_or("TT Well Ring pipeline specialization pending")?;
    let cache=world.get_resource::<PipelineCache>().ok_or("TT Well Ring pipeline cache absent")?;
    let pipeline=pipelines.get(&current.retained_view_entity).and_then(|per_view|per_view.get(&entity));
    if pipeline!=Some(&expected){return Err("TT Well Ring actual item pipeline differs from current view/entity specialization".into());}
    if cache.get_render_pipeline(expected).is_none(){
        return Err("TT Well Ring GPU pipeline for current view pending".into());
    }Ok(())
}
fn extract(backend:Res<Backend>,mut frame:ResMut<Frame>){
    frame.tickets=backend.tickets();frame.published_frames=backend.published_frames;
    frame.admitted=backend.error.is_none()&&backend.published_frames>0;
}
// Additive private GuardedDraw TypeId. Untagged shared Glow/Nexus/Rune phase
// items keep their exact previous draw_function; no global DrawMaterial is added,
// replaced or wrapped. Ring delegation is allowed only after exact ticket/view,
// pipeline and session-FoW checks below, never by CPU permission alone.
fn gate(world:&mut World) {
    let Some(frame)=world.get_resource::<Frame>().cloned() else{return};
    let ids:std::collections::HashSet<_>=frame.tickets.iter().map(|t|t.draw).collect();
    let guard=world.resource::<DrawFunctions<Transparent3d>>().read().id::<GuardedDraw>();
    if let Some(mut phases)=world.get_resource_mut::<ViewSortedRenderPhases<Transparent3d>>(){
        for (_,phase) in phases.0.iter_mut(){for (_,item) in phase.items.iter_mut(){
            if ids.contains(&item.entity.1.id()){item.draw_function=guard;}
        }}
    }
}
fn flush(world:&World) {
    let Ok(path)=std::env::var("OPENLEAGUE_TT_WELL_RING_RENDER_PROBE") else{return};
    let Some(frame)=world.get_resource::<Frame>() else{return};
    let Some(dispatch)=world.get_resource::<Dispatch>() else{return};
    let counts=dispatch.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner);
    let tickets:Vec<_>=frame.tickets.iter().map(|t|serde_json::json!({"session":t.key.session,
        "ready_tick":t.key.ready_tick,"generation":t.key.generation,"group":t.group,"birth":t.birth,
        "draw":t.draw.to_bits(),"readiness_scope":"checked against actual view only at guarded draw"})).collect();
    let census:Vec<_>=counts.nonempty_success.iter().map(|(key,groups)|serde_json::json!({
        "session":key.session,"ready_tick":key.ready_tick,"generation":key.generation,
        "group_nonempty_success":groups,"nonempty_success":groups[0],
        "group_mask":u8::from(groups[0]>0)})).collect();
    let report=serde_json::json!({"schema":1,"pid":std::process::id(),"ordinary_TT_well_ring_owned_path":true,
        "published_frames":frame.published_frames,"tickets":tickets,
        "guard_attempt":counts.attempt,"guard_rejected":counts.rejected,"material_success":counts.success,
        "material_skip":counts.skip,"material_failure":counts.failure,
        "nonempty_success_by_key":census,
        "aggregate_success_is_not_Ring_key_qualification":true,
        "source_based_composition":true,"original_native_whole_frame_qualified":false,
        "original_global_RNG_qualified":false,"visible_pixels_qualified":false,"complete":false});
    if let Err(error)=std::fs::write(path,serde_json::to_vec(&report).unwrap()){warn!("TT Well Ring render report: {error}");}
}
struct ObservedMaterial;
impl RenderCommand<Transparent3d> for ObservedMaterial {
    type Param=(<DrawMaterial as RenderCommand<Transparent3d>>::Param,SRes<Dispatch>,SRes<Frame>);
    type ViewQuery=<DrawMaterial as RenderCommand<Transparent3d>>::ViewQuery;
    type ItemQuery=<DrawMaterial as RenderCommand<Transparent3d>>::ItemQuery;
    fn render<'w>(item:&Transparent3d,view:ROQueryItem<'w,'_,Self::ViewQuery>,entity:Option<ROQueryItem<'w,'_,Self::ItemQuery>>,
        (param,dispatch,frame):SystemParamItem<'w,'_,Self::Param>,pass:&mut TrackedRenderPass<'w>)->RenderCommandResult {
        let result=<DrawMaterial as RenderCommand<Transparent3d>>::render(item,view,entity,param,pass);
        let mut c=dispatch.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner);
        match &result {RenderCommandResult::Success=>{
            c.success+=1;
            // Batched items can report Success with an empty range. Count only
            // this exact admitted draw, with an actual nonempty batch range.
            if frame.admitted && item.batch_range.end>item.batch_range.start {
                if let Some(ticket)=frame.tickets.iter().find(|t|t.draw==item.entity.1.id()&&t.group==0) {
                    c.nonempty_success.entry(ticket.key).or_default()[ticket.group]+=1;
                }
            }
        },RenderCommandResult::Skip=>c.skip+=1,
            RenderCommandResult::Failure(_)=>c.failure+=1}result
    }
}
struct GuardedDraw(RenderCommandState<Transparent3d,ObservedMaterial>);
impl Draw<Transparent3d> for GuardedDraw {
    fn prepare(&mut self,world:&World){self.0.prepare(world);}
    fn draw<'w>(&mut self,world:&'w World,pass:&mut TrackedRenderPass<'w>,view:Entity,item:&Transparent3d)->Result<(),DrawError> {
        let Some(dispatch)=world.get_resource::<Dispatch>() else{return Ok(())};
        dispatch.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner).attempt+=1;
        let ticket=world.get_resource::<Frame>().and_then(|f|f.tickets.iter().find(|t|t.draw==item.entity.1.id()));
        if ticket.is_none_or(|t|ready(world,t,view,item.pipeline).is_err()) {
            dispatch.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner).rejected+=1;return Ok(());
        }
        self.0.draw(world,pass,view,item)
    }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Frame>().add_plugins(ExtractResourcePlugin::<Frame>::default())
            .add_systems(PostUpdate,extract.after(crate::tt_well_ring_live::synchronize)
                .after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));
        let Some(render)=app.get_sub_app_mut(RenderApp) else{return};
        render.init_resource::<Dispatch>().add_systems(RenderGraph,(gate.after(crate::fow_gpu::Encoded).before(camera_driver),flush.after(camera_driver)));
        // Registers only this module's private guard type. Existing DrawMaterial
        // and all other modules' guards retain their registration and IDs.
        let draw=GuardedDraw(RenderCommandState::new(render.world_mut()));
        render.world().resource::<DrawFunctions<Transparent3d>>().write().add(draw);
    }
}
