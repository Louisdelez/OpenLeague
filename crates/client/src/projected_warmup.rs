//! Prepare the production material pipeline with the production vertex layout.
//! The layout asset is never spawned or drawn; live terrain remains authoritative.
use bevy::{prelude::*, asset::RenderAssetUsages,
    mesh::PrimitiveTopology, material::key::{ErasedMaterialPipelineKey,ErasedMeshPipelineKey},
    pbr::{PreparedMaterial,MeshPipelineKey,ViewKeyCache,alpha_mode_pipeline_key},
    render::{Render,RenderApp,RenderSystems,mesh::RenderMesh,
        render_asset::RenderAssets,erased_render_asset::ErasedRenderAssets,
        extract_resource::{ExtractResource,ExtractResourcePlugin},render_resource::CachedRenderPipelineId}};
use crate::projected_render::ProjectedMaterial;
#[derive(Resource,Clone,ExtractResource)]
struct LayoutAssets {mesh:Handle<Mesh>,material:Handle<ProjectedMaterial>}
#[derive(Resource,Default)]
struct Prepared {keys:Vec<(ErasedMaterialPipelineKey,CachedRenderPipelineId)>}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.add_plugins(ExtractResourcePlugin::<LayoutAssets>::default()).add_systems(Startup,setup);
        app.sub_app_mut(RenderApp).init_resource::<Prepared>()
            .add_systems(Render,prepare.in_set(RenderSystems::Queue).before(RenderSystems::QueueMeshes));
    }
}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<ProjectedMaterial>>) {
    // Only format/layout/topology matter for specialization; no world geometry is created.
    let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::RENDER_WORLD);
    mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,0.,0.];3]);
    mesh.insert_attribute(Mesh::ATTRIBUTE_NORMAL,vec![[0.,1.,0.];3]);
    mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,vec![[0.,0.];3]);
    mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,vec![[1.,1.,1.,1.];3]);
    let material=materials.add(ProjectedMaterial{texture:crate::terrain_material::projected_image(&assets,"particles/annie/disintegrate-light.png".into()),color_texture:crate::terrain_material::projected_image(&assets,"particles/annie/color-hold.png".into()),color_lookup:Vec4::new(0.,1.,1.,0.),..default()});
    commands.insert_resource(LayoutAssets{mesh:meshes.add(mesh),material});
}
fn prepare(world:&mut World) {
    let Some(assets)=world.get_resource::<LayoutAssets>().cloned() else{return;};
    let Some(meshes)=world.get_resource::<RenderAssets<RenderMesh>>() else{return;};
    let Some(mesh)=meshes.get(assets.mesh.id()) else{return;};
    let layout=mesh.layout.clone();let bits=MeshPipelineKey::from_bits_retain(mesh.key_bits.bits());
    let Some(materials)=world.get_resource::<ErasedRenderAssets<PreparedMaterial>>() else{return;};
    let Some(material)=materials.get(assets.material.id()) else{return;};
    let properties=material.properties.clone();
    let Some(views)=world.get_resource::<ViewKeyCache>() else{return;};
    let keys:Vec<_>=views.values().map(|view| {
        let mut material_bits:MeshPipelineKey=properties.mesh_pipeline_key_bits.downcast();
        material_bits.insert(alpha_mode_pipeline_key(properties.alpha_mode,&Msaa::from_samples(view.msaa_samples())));
        ErasedMaterialPipelineKey {type_id:std::any::TypeId::of::<ProjectedMaterial>(),
            mesh_key:ErasedMeshPipelineKey::new(*view|bits|material_bits),material_key:properties.material_key.clone()}
    }).collect();
    for key in keys {
        if world.resource::<Prepared>().keys.iter().any(|(existing,_)|existing==&key){continue;}
        let Some(specialize)=properties.base_specialize else{return;};
        match specialize(world,key.clone(),&layout,&properties) {
            Ok(id)=>world.resource_mut::<Prepared>().keys.push((key,id)),
            Err(error)=>warn!("Projected pipeline preparation: {error}"),
        }
    }
}
