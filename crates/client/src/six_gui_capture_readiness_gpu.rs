//! Actual render-world resource barrier for ordinary six-GUI captures.
//! Readonly: no drawer redirection, batching, camera, simulation or asset edits.
//! Resources/cache/phase observations do not qualify DrawMaterial success/pixels.
use bevy::{prelude::*,asset::AssetId,
    core_pipeline::{core_3d::{Opaque3d,AlphaMask3d,Transparent3d},schedule::camera_driver},
    pbr::{Material,PreparedMaterial,RenderMaterialInstances,MaterialBindGroupAllocators,
        RenderMeshInstances,SkinUniforms,SpecializedMaterialPipelineCache},
    render::{RenderApp,render_asset::RenderAssets,erased_render_asset::ErasedRenderAssets,
        mesh::{RenderMesh,RenderMeshBufferInfo,allocator::MeshAllocator},texture::GpuImage,sync_world::MainEntity,renderer::RenderGraph,
        render_resource::{PipelineCache,CachedRenderPipelineId},
        view::{ExtractedView,RetainedViewEntity,visibility::RenderVisibleEntities},camera::ExtractedCamera,
        render_phase::{ViewBinnedRenderPhases,ViewSortedRenderPhases}},
    ui_render::{UiCameraView,UiViewTarget,ui_material::UiMaterial}};
use super::types::{Frame,Shared,GpuReport,Scope,MeshTicket,MeshMaterial,MeshRole,UiTicket,UiMaterial as UiKind};

#[path="six_gui_capture_readiness_ui.rs"]
mod ui;
pub(crate) fn install(app:&mut App,shared:Shared) {
    ui::install(app);
    app.sub_app_mut(RenderApp).insert_resource(shared)
        .add_systems(RenderGraph,observe.after(camera_driver).after(crate::fow_gpu::Encoded));
}
fn images(world:&World,ids:&[AssetId<Image>])->Result<(),String> {
    let assets=world.get_resource::<RenderAssets<GpuImage>>().ok_or("GPU image registry unavailable")?;
    if ids.iter().any(|id|assets.get(*id).is_none()){return Err("actual required GPU image pending".into());}
    Ok(())
}
fn prepared_mesh_material<M:Material>(world:&World,id:AssetId<M>)->Result<(),String> {
    let prepared=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>()
        .and_then(|a|a.get(id)).ok_or("actual GPU material preparation pending")?;
    let allocator=world.get_resource::<MaterialBindGroupAllocators>()
        .and_then(|a|a.get(&std::any::TypeId::of::<M>())).ok_or("actual material allocator pending")?;
    if allocator.get(prepared.binding.group).and_then(|g|g.bind_group()).is_none() {
        return Err("actual required material bind group pending".into());
    }Ok(())
}
fn mesh_material_id(ticket:&MeshTicket)->bevy::asset::UntypedAssetId {
    match ticket.material {MeshMaterial::Fog(id)=>id.untyped(),MeshMaterial::Terrain(id)=>id.untyped(),MeshMaterial::Standard(id)=>id.untyped()}
}
fn material_binding_contract(ticket:&MeshTicket,output:AssetId<Image>)->Result<(),String> {
    match ticket.material {
        MeshMaterial::Standard(id)=>{
            if ticket.role!=MeshRole::Terrain||ticket.native_visibility.is_some()
                ||!ticket.standard_source.as_ref().is_some_and(|source|source.material==id&&source.source_mesh==ticket.mesh) {
                return Err("Standard ticket requires exact MapRoot GLTF provenance and no Native FoW binding".into());
            }
        },
        MeshMaterial::Fog(_)|MeshMaterial::Terrain(_)=>{
            if ticket.native_visibility!=Some(output)||ticket.standard_source.is_some() {
                return Err("native Fog/Terrain ticket is not bound to exact scene FoW output".into());
            }
        },
    }Ok(())
}
fn primary(world:&mut World,scope:&Scope)->Result<(Entity,RetainedViewEntity),String> {
    let expected=RetainedViewEntity::new(MainEntity::from(scope.camera),None,0);
    let candidates={let mut q=world.query::<(Entity,&ExtractedView,&ExtractedCamera)>();
        q.iter(world).filter(|(_,v,c)|v.retained_view_entity==expected
            &&c.target.as_ref()==Some(&scope.target)
            &&c.physical_target_size==Some(UVec2::new(1280,800))
            &&c.physical_viewport_size==Some(UVec2::new(1280,800))
            &&v.viewport==UVec4::new(0,0,1280,800))
            .map(|(e,v,_)|(e,v.retained_view_entity)).collect::<Vec<_>>()};
    if candidates.len()!=1{return Err("unique exact primary-window extracted camera/view pending".into());}
    Ok(candidates[0])
}
fn current_pipeline(world:&World,ticket:&MeshTicket,view:RetainedViewEntity)->Result<CachedRenderPipelineId,String> {
    let entity=MainEntity::from(ticket.draw);
    let id=world.get_resource::<SpecializedMaterialPipelineCache>()
        .and_then(|p|p.get(&view)).and_then(|p|p.get(&entity)).copied()
        .ok_or("current primary-view own mesh specialization pending")?;
    if !world.get_resource::<PipelineCache>().is_some_and(|p|p.get_render_pipeline(id).is_some()) {
        return Err("current primary-view own mesh compiled pipeline pending".into());
    }Ok(id)
}
fn mesh_ready(world:&World,ticket:&MeshTicket,scope:&Scope,view_entity:Entity,
    view:RetainedViewEntity)->Result<CachedRenderPipelineId,String> {
    let entity=MainEntity::from(ticket.draw);
    material_binding_contract(ticket,scope.visibility_output)?;
    let actual_visible=world.get::<RenderVisibleEntities>(view_entity)
        .and_then(|v|v.get::<Mesh3d>()).is_some_and(|v|v.iter_visible().any(|(_,main)|*main==entity));
    if !actual_visible{return Err("own mesh not in actual primary-view extracted visibility".into());}
    let mesh=world.get_resource::<RenderAssets<RenderMesh>>().and_then(|m|m.get(ticket.mesh)).ok_or("actual render mesh preparation pending")?;
    if mesh.vertex_count==0||world.get_resource::<RenderMeshInstances>().and_then(|m|m.mesh_asset_id(entity))!=Some(ticket.mesh){
        return Err("actual extracted own mesh pending, empty or changed".into());
    }
    // RenderMesh preparation alone contains layout/counts, not the resident
    // allocator buffers. Observe the real own allocations without altering them.
    let allocator=world.get_resource::<MeshAllocator>().ok_or("actual mesh allocator unavailable")?;
    let vertices=allocator.mesh_vertex_slice(&ticket.mesh).ok_or("actual own vertex allocation/upload pending")?;
    if vertices.range.end<vertices.range.start||vertices.range.end-vertices.range.start<mesh.vertex_count||vertices.buffer.size()==0 {
        return Err("actual own vertex allocation incomplete".into());
    }
    if let RenderMeshBufferInfo::Indexed{count,..}=&mesh.buffer_info {
        let indices=allocator.mesh_index_slice(&ticket.mesh).ok_or("actual own index allocation/upload pending")?;
        if *count==0||indices.range.end<indices.range.start||indices.range.end-indices.range.start<*count||indices.buffer.size()==0 {
            return Err("actual own index allocation incomplete".into());
        }
    }
    if world.get_resource::<RenderMaterialInstances>().and_then(|m|m.instances.get(&entity))
        .map(|m|m.asset_id)!=Some(mesh_material_id(ticket)) {
        return Err("actual extracted own material identity pending or changed".into());
    }
    match ticket.material {
        MeshMaterial::Fog(id)=>prepared_mesh_material(world,id)?,
        MeshMaterial::Terrain(id)=>prepared_mesh_material(world,id)?,
        MeshMaterial::Standard(id)=>prepared_mesh_material(world,id)?,
    }
    images(world,&ticket.images)?;
    // This is a global scene obligation even for Standard. It is deliberately
    // separate from ticket.native_visibility: the existing Standard shader has
    // no Native FoW binding, and resource readiness does not repair that shader.
    if !crate::fow_gpu::ready_for_team(world,scope.owner.session,scope.team,scope.visibility_output) {
        return Err("actual FoW passes not encoded for this exact session/team/output".into());
    }
    if let Some(skin)=&ticket.skin {
        if skin.joints.is_empty(){return Err("source skin contains no joints".into());}
        let uniforms=world.get_resource::<SkinUniforms>().ok_or("actual skin GPU buffer pending")?;
        let start=uniforms.skin_index(entity).ok_or("actual own skin extraction pending")? as usize;
        let end=start.checked_add(skin.joints.len()).ok_or("actual skin range overflow")?;
        let matrices=uniforms.current_staging_buffer.get(start..end).ok_or("actual variable-count skin palette incomplete")?;
        if matrices.iter().any(|m|!m.is_finite())||uniforms.current_buffer.size()<(end as u64).checked_mul(64).ok_or("actual skin byte range overflow")? {
            return Err("actual own skin palette nonfinite or GPU buffer incomplete".into());
        }
    }
    current_pipeline(world,ticket,view)
}
fn phase_membership(world:&World,ticket:&MeshTicket,view:RetainedViewEntity,
    pipeline:CachedRenderPipelineId)->serde_json::Value {
    let entity=MainEntity::from(ticket.draw);let mut exact=Vec::new();let mut multidraw_unknown=false;
    if let Some(phase)=world.get_resource::<ViewSortedRenderPhases<Transparent3d>>().and_then(|p|p.get(&view)) {
        for item in phase.items.values().filter(|v|v.entity.1==entity&&v.pipeline==pipeline) {
            exact.push(serde_json::json!({"phase":"transparent","nonempty_batch":item.batch_range.end>item.batch_range.start}));
        }
    }
    if let Some(phase)=world.get_resource::<ViewBinnedRenderPhases<Opaque3d>>().and_then(|p|p.get(&view)) {
        for ((key,bin),members) in &phase.batchable_meshes {
            if key.pipeline==pipeline&&bin.asset_id==ticket.mesh.untyped()&&members.entities().contains_key(&entity) {
                exact.push(serde_json::json!({"phase":"opaque_batchable","current_owned_entity_member":true}));
            }
        }
        for ((key,bin),members) in &phase.unbatchable_meshes {
            if key.pipeline==pipeline&&bin.asset_id==ticket.mesh.untyped()&&members.entities.contains_key(&entity) {
                exact.push(serde_json::json!({"phase":"opaque_unbatchable","current_owned_entity_member":true}));
            }
        }
        multidraw_unknown|=phase.multidrawable_meshes.keys().any(|key|key.pipeline==pipeline);
    }
    if let Some(phase)=world.get_resource::<ViewBinnedRenderPhases<AlphaMask3d>>().and_then(|p|p.get(&view)) {
        for ((key,bin),members) in &phase.batchable_meshes {
            if key.pipeline==pipeline&&bin.asset_id==ticket.mesh.untyped()&&members.entities().contains_key(&entity) {
                exact.push(serde_json::json!({"phase":"alpha_mask_batchable","current_owned_entity_member":true}));
            }
        }
        for ((key,bin),members) in &phase.unbatchable_meshes {
            if key.pipeline==pipeline&&bin.asset_id==ticket.mesh.untyped()&&members.entities.contains_key(&entity) {
                exact.push(serde_json::json!({"phase":"alpha_mask_unbatchable","current_owned_entity_member":true}));
            }
        }
        multidraw_unknown|=phase.multidrawable_meshes.keys().any(|key|key.pipeline==pipeline);
    }
    serde_json::json!({"exact_owned_phase_members":exact,"multidraw_owned_entity_membership_unknown":multidraw_unknown,
        "DrawMaterial_success_observed":false,"GPU_execution_or_visible_pixels_qualified":false})
}
fn ui_view(world:&World,view:Entity)->Result<RetainedViewEntity,String> {
    let ui=world.get::<UiCameraView>(view).ok_or("actual primary UI camera view pending")?.0;
    if world.get::<UiViewTarget>(ui).map(|t|t.0)!=Some(view){return Err("UI view targets another camera".into());}
    Ok(world.get::<ExtractedView>(ui).ok_or("actual extracted primary UI view pending")?.retained_view_entity)
}
fn ui_ready<M:UiMaterial>(world:&World,ticket:&UiTicket,id:AssetId<M>,view:RetainedViewEntity)->Result<serde_json::Value,String> {
    ui::ready(world,ticket,id,view)
}
fn observe(world:&mut World) {
    let Some(frame)=world.get_resource::<Frame>().cloned()else{return;};
    let Some(shared)=world.get_resource::<Shared>().cloned()else{return;};
    let Some(scope)=frame.scope.clone()else{if let Ok(mut value)=shared.0.lock(){*value=None;}return;};
    let mut missing=frame.missing.clone();let mut meshes=Vec::new();let mut ui=Vec::new();
    match primary(world,&scope) {
        Err(error)=>missing.push(error),
        Ok((view_entity,view))=>{
            for ticket in &frame.meshes {
                match mesh_ready(world,ticket,&scope,view_entity,view) {
                    Ok(pipeline)=>meshes.push(serde_json::json!({"draw":format!("{:?}",ticket.draw),"role":format!("{:?}",ticket.role),
                        "resources_and_primary_pipeline_ready":true,"pipeline":format!("{pipeline:?}"),"phase":phase_membership(world,ticket,view,pipeline),
                        "native_FoW_binding_output":ticket.native_visibility.map(|id|format!("{id:?}")),
                        "Standard_shader_native_FoW_binding_present":false,
                        "native_texture_shadow_pass_or_pixel_parity_qualified":false})),
                    Err(error)=>{missing.push(format!("{:?} mesh {:?}: {error}",ticket.role,ticket.draw));}
                }
            }
            match ui_view(world,view_entity) {
                Err(error)=>missing.push(error),
                Ok(view)=>for ticket in &frame.ui {
                    let result=match ticket.material {UiKind::Icon(id)=>ui_ready(world,ticket,id,view),UiKind::Font(id)=>ui_ready(world,ticket,id,view)};
                    match result {Ok(observed)=>ui.push(serde_json::json!({"role":format!("{:?}",ticket.role),"draw":format!("{:?}",ticket.draw),"resource_and_phase":observed})),
                        Err(error)=>missing.push(format!("{:?} HUD {:?}: {error}",ticket.role,ticket.draw))}
                }
            }
        }
    }
    if frame.meshes.is_empty()||frame.ui.is_empty(){missing.push("actual scene/HUD tickets are empty".into());}
    let scene_fow_output=scope.visibility_output;
    let report=GpuReport {serial:frame.serial,scope,meshes:frame.meshes,ui:frame.ui,missing,
        observations:serde_json::json!({"mesh_rows":meshes,"UI_rows":ui,"readonly_render_graph_after_camera_and_FoW":true,
            "scene_FoW_output":format!("{scene_fow_output:?}"),"Standard_native_FoW_masking_qualified":false,
            "scope":"actual GPU resources, primary-view specialization and observable queued items","DrawMaterial_success_observed":false,
            "opaque_multidraw_entity_membership_may_be_unknown":true,"visible_pixels_qualified":false}),
        draw_material_success_observed:false,visible_pixels_qualified:false};
    crate::six_client_match_observation::copy_join::observe_gpu(world,&report);
    if let Ok(mut value)=shared.0.lock(){*value=Some(report);};
}

#[cfg(test)]mod tests {
    use super::*;
    fn standard_ticket()->MeshTicket {
        // Contract fixture only. These default identities are not CPU/GPU
        // loaded assets, accepted GLTF provenance or a resource-ready scene.
        let id=Handle::<StandardMaterial>::default().id();let mesh=Handle::<Mesh>::default().id();
        MeshTicket {role:MeshRole::Terrain,draw:Entity::PLACEHOLDER,mesh,material:MeshMaterial::Standard(id),
            images:vec![],native_visibility:None,skin:None,standard_source:Some(super::super::materials::StandardSource {
                material:id,source_gltf_material:Handle::<bevy::gltf::GltfMaterial>::default().id(),
                source_gltf_mesh:Handle::<bevy::gltf::GltfMesh>::default().id(),source_mesh:mesh,
                material_name:"source-fixture-only".into(),mesh_name:"source-fixture-only".into(),standard_path:"fixture#Material0/std".into()})}
    }
    #[test]fn six_gui_capture_Standard_resources_do_not_claim_native_FoW_or_fabricate_GPU_preparation() {
        let output=Handle::<Image>::default().id();let mut ticket=standard_ticket();
        assert!(material_binding_contract(&ticket,output).is_ok());
        assert!(ticket.native_visibility.is_none());
        let world=World::new();assert!(prepared_mesh_material(&world,Handle::<StandardMaterial>::default().id()).is_err());
        assert!(!crate::fow_gpu::ready_for_team(&world,11,0,output));
        ticket.native_visibility=Some(output);assert!(material_binding_contract(&ticket,output).is_err());
        ticket.native_visibility=None;ticket.standard_source=None;assert!(material_binding_contract(&ticket,output).is_err());
    }
    #[test]fn six_gui_capture_material_contract_rejects_local_Standard_and_foreign_native_output() {
        let output=Handle::<Image>::default().id();let mut ticket=standard_ticket();
        ticket.role=MeshRole::LocalModel;assert!(material_binding_contract(&ticket,output).is_err());
        ticket.role=MeshRole::Terrain;
        let mut standards=Assets::<StandardMaterial>::default();let other=standards.add(StandardMaterial::default());
        ticket.standard_source.as_mut().unwrap().material=other.id();assert!(material_binding_contract(&ticket,output).is_err());
        ticket.material=MeshMaterial::Fog(Handle::<crate::map_fog::FogMaterial>::default().id());
        ticket.standard_source=None;ticket.native_visibility=Some(output);
        assert!(material_binding_contract(&ticket,output).is_ok());
        let mut images=Assets::<Image>::default();let foreign=images.add(Image::default());
        ticket.native_visibility=Some(foreign.id());assert!(material_binding_contract(&ticket,output).is_err());
        ticket.native_visibility=None;assert!(material_binding_contract(&ticket,output).is_err());
    }
}
