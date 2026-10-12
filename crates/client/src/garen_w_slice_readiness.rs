//! Observe the actual extracted material, skin, images and compiled pipeline.
//! Acknowledgements identify exact draw/asset instances, never merely a W token.
use bevy::{prelude::*,
    mesh::skinning::SkinnedMesh,
    pbr::{PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,RenderMeshInstances,SkinUniforms,SpecializedMaterialPipelineCache},
    render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},renderer::RenderGraph,
        render_asset::RenderAssets,erased_render_asset::ErasedRenderAssets,mesh::RenderMesh,
        render_resource::{PipelineCache,TextureFormat},texture::GpuImage,sync_world::MainEntity},
    core_pipeline::schedule::camera_driver};
use crate::{garen_w_slice_host as host,garen_w_slice_material::SliceMaterial};

#[derive(Resource,Clone,Default,ExtractResource)]
struct Frame {serial:u64,tickets:Vec<host::Ticket>}
#[derive(Resource,Default)]
struct Measurements {last:Vec<serde_json::Value>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        let gate=host::Readiness::default();
        app.insert_resource(gate.clone()).init_resource::<Frame>()
            .add_plugins(ExtractResourcePlugin::<Frame>::default())
            .add_systems(PostUpdate,extract_frame.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));
        app.sub_app_mut(RenderApp).insert_resource(gate).init_resource::<Measurements>()
            .add_systems(RenderGraph,measure.after(crate::fow_gpu::Encoded).before(camera_driver));
    }
}
fn extract_frame(query:Query<(Entity,&host::Ticket,&ViewVisibility,&Mesh3d,&SkinnedMesh,&MeshMaterial3d<SliceMaterial>),With<host::Draw>>,
    mut frame:ResMut<Frame>) {
    frame.serial=frame.serial.saturating_add(1);
    frame.tickets=query.iter().filter(|(entity,ticket,visible,mesh,skin,material)|
        *entity==ticket.draw && visible.get() && mesh.id()==ticket.mesh && material.id()==ticket.material
            && skin.inverse_bindposes.id()==ticket.inverse_bind && skin.joints.len()==68)
        .map(|(_,ticket,_,_,_,_)|ticket.clone()).collect();
}
fn ready(world:&World,ticket:&host::Ticket)->Result<(),String> {
    if !crate::fow_gpu::ready_for(world,ticket.key.session,ticket.images[2]) {return Err("FoW frame/session not encoded".into())}
    let images=world.get_resource::<RenderAssets<GpuImage>>().ok_or("GPU image registry missing")?;
    for (i,id) in ticket.images.iter().enumerate() {
        let image=images.get(*id).ok_or("GPU image pending")?;
        if i<2 {
            let (width,mips)=if i==0 {(512,1)}else{(128,8)};
            let d=&image.texture_descriptor;
            if d.format!=TextureFormat::Bc3RgbaUnorm || d.size.width!=width || d.size.height!=width
                || d.size.depth_or_array_layers!=1 || d.mip_level_count!=mips {
                return Err("GPU Slice raw DDS layout mismatch".into())
            }
        }
    }
    let entity=MainEntity::from(ticket.draw);
    let meshes=world.get_resource::<RenderAssets<RenderMesh>>().ok_or("GPU meshes missing")?;
    if meshes.get(ticket.mesh).is_none() {return Err("GPU mesh pending".into())}
    let instances=world.get_resource::<RenderMeshInstances>().ok_or("mesh instances missing")?;
    if instances.mesh_asset_id(entity)!=Some(ticket.mesh) {return Err("render mesh identity mismatch".into())}
    let skins=world.get_resource::<SkinUniforms>().ok_or("GPU skin buffer pending")?;
    let offset=skins.skin_index(entity).ok_or("skin extraction pending")? as usize;
    let matrices=skins.current_staging_buffer.get(offset..offset+68).ok_or("skin palette incomplete")?;
    if matrices.iter().any(|m|!m.is_finite()) || skins.current_buffer.size()<((offset+68)*64) as u64 {
        return Err("skin palette invalid or buffer too small".into())
    }
    let instances=world.get_resource::<RenderMaterialInstances>().ok_or("material instances missing")?;
    let actual=instances.instances.get(&entity).ok_or("material extraction pending")?;
    if actual.asset_id!=ticket.material.untyped() {return Err("render material identity mismatch".into())}
    let materials=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>().ok_or("prepared materials missing")?;
    let material=materials.get(ticket.material).ok_or("material bind preparation pending")?;
    let allocators=world.get_resource::<MaterialBindGroupAllocators>().ok_or("material allocators missing")?;
    let allocator=allocators.get(&std::any::TypeId::of::<SliceMaterial>()).ok_or("Slice allocator pending")?;
    let group=allocator.get(material.binding.group).ok_or("Slice binding pending")?;
    if group.bind_group().is_none() {return Err("Slice GPU bind group pending".into())}
    let pipelines=world.get_resource::<SpecializedMaterialPipelineCache>().ok_or("specialized pipelines missing")?;
    let cache=world.get_resource::<PipelineCache>().ok_or("pipeline cache missing")?;
    if !pipelines.values().filter_map(|view|view.get(&entity)).any(|id|cache.get_render_pipeline(*id).is_some()) {
        return Err("Slice render pipeline pending".into())
    }
    Ok(())
}
fn measure(world:&mut World) {
    let Some(frame)=world.get_resource::<Frame>().cloned() else{return};
    let Some(gate)=world.get_resource::<host::Readiness>().cloned() else{return};
    let mut accepted=Vec::new();let mut records=Vec::new();
    for ticket in &frame.tickets {
        let result=ready(world,ticket);
        if result.is_ok(){accepted.push(ticket.clone())}
        records.push(serde_json::json!({"session":ticket.key.session,"effect":ticket.key.effect,
            "source":ticket.key.source,"draw":format!("{:?}",ticket.draw),"generation":ticket.generation,
            "ready":result.is_ok(),"reason":result.err()}));
    }
    if let Err(error)=gate.publish_ready(accepted) {warn!("Courage shimmer readiness: {error}")}
    let measurement=serde_json::json!({"frame":frame.serial,"draws":records});
    let mut measurements=world.resource_mut::<Measurements>();
    if measurements.last.len()==512 {measurements.last.remove(0);}
    measurements.last.push(measurement);
    if let Ok(path)=std::env::var("OPENLEAGUE_GAREN_SLICE_RENDER_PROBE") {
        let report=serde_json::json!({"render_assets_observed":true,"native_pixel_parity":false,"frames":measurements.last});
        if let Err(error)=std::fs::write(path,serde_json::to_vec(&report).unwrap()) {warn!("Courage shimmer render probe: {error}")}
    }
}
