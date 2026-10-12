//! Projected terrain material and an explicitly requested diagnostic consumer.
//! Native emitter binding, FOW/DeathScreen and rendering state remain unqualified.
use crate::{Match, projected_surface::TerrainProjection, projected_terrain::TerrainSurfaces, terrain_material};
use bevy::{prelude::*, reflect::TypePath, shader::ShaderRef, mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline,MaterialPipelineKey}, render::render_resource::{AsBindGroup,RenderPipelineDescriptor,SpecializedMeshPipelineError}};

#[derive(Asset,TypePath,AsBindGroup,Debug,Clone,Default)]
pub struct ProjectedMaterial {
    #[texture(0)] #[sampler(1)] pub texture:Handle<Image>,
    #[uniform(2)] pub visibility_params:Vec4,
    #[texture(3)] #[sampler(4)] pub visibility_map:Handle<Image>,
    #[texture(5)] #[sampler(6)] pub visibility_overlay:Handle<Image>,
    #[uniform(7)] pub visibility_edge:Vec4,
    #[uniform(8)] pub visibility_ready:u32,
    #[texture(9)] #[sampler(10)] pub color_texture:Handle<Image>,
    #[uniform(11)] pub color_lookup:Vec4,
    #[uniform(12)] pub world_to_projection:Mat4,
    #[uniform(13)] pub projection_height:Vec4,
}
impl Material for ProjectedMaterial {
    fn vertex_shader()->ShaderRef { "shaders/projected_vertex.wgsl".into() }
    fn fragment_shader()->ShaderRef { "shaders/projected_terrain.wgsl".into() }
    fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
    fn specialize(_: &MaterialPipeline,d:&mut RenderPipelineDescriptor,_:&MeshVertexBufferLayoutRef,_:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError> {
        d.primitive.cull_mode=crate::particle_render_state::ParticleState::base_projected_cull();
        if let Some(fragment)=d.fragment.as_mut() {
            for target in fragment.targets.iter_mut().flatten() {
                target.blend=Some(crate::particle_render_state::ParticleState::base_projected_blend());
            }
        }
        if let Some(depth)=d.depth_stencil.as_mut() {
            depth.depth_write_enabled=Some(crate::particle_render_state::ParticleState::base_projected_depth_write());
            depth.depth_compare=Some(crate::particle_render_state::ParticleState::base_projected_depth_compare());
        }
        Ok(())
    }
}
#[derive(Resource,Default)]
pub struct Probe {
    frames:u32,
    entity:Option<Entity>,
    mesh:Option<Handle<Mesh>>,
    material:Option<Handle<ProjectedMaterial>>,
    capture_started:bool,
    finished:bool,
    patch_vertices:usize,
}
fn path()->Option<std::path::PathBuf> {
    let p=std::path::PathBuf::from(std::env::var_os("OPENLEAGUE_PROJECTED_RENDER_PROBE")?);
    (p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs"))).then_some(p)
}
pub fn probe(
    mut commands:Commands,state:Res<Match>,surfaces:Res<TerrainSurfaces>,assets:Res<AssetServer>,
    mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<ProjectedMaterial>>,mut probe:ResMut<Probe>,
) {
    let Some(path)=path() else {return;};
    if probe.finished || surfaces.triangle_count()==0 {return;}
    let Some(snapshot)=state.snapshot.as_ref() else {return;};
    let Some(actor)=snapshot.players.iter().find(|p|p.champion.eq_ignore_ascii_case("annie")) else {return;};
    probe.frames+=1;
    if probe.frames==60 {
        let projection=TerrainProjection::new(Vec2::new(actor.position.x,actor.position.z),Vec2::splat(500.),0.).unwrap();
        let Some(mesh)=surfaces.projected_mesh(projection) else {warn!("Projected diagnostic has no receiving geometry");probe.finished=true;return;};
        probe.patch_vertices=mesh.count_vertices();
        let mesh=meshes.add(mesh);
        let material=materials.add(ProjectedMaterial {texture:terrain_material::projected_image(&assets,"particles/annie/disintegrate-light.png".into()),..default()});
        let entity=commands.spawn((Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,Visibility::Inherited,bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();
        probe.entity=Some(entity);probe.mesh=Some(mesh);probe.material=Some(material);
        warn!("Projected diagnostic only: real restored terrain, native texture; explicit half-size500/angle0/FOW1, ADD/depth state unqualified. Native emitter not bound.");
    }
    if probe.frames==180 && probe.entity.is_some() {
        commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(path.with_extension("png")));
        probe.capture_started=true;
    }
    if probe.frames==240 && probe.capture_started {
        if let Some(entity)=probe.entity.take() {commands.entity(entity).despawn();}
        if let Some(mesh)=probe.mesh.take() {meshes.remove(mesh.id());}
        if let Some(material)=probe.material.take() {materials.remove(material.id());}
    }
    if probe.frames==270 && probe.capture_started {
        commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(path.with_file_name("projected-render-off.png")));
        let diagnostic=serde_json::json!({"complete":false,"diagnostic_only":true,"native_emitter_bound":false,"patch_vertices":probe.patch_vertices,"capture_started":true,"remaining_materials":materials.len(),"remaining_probe_entity":probe.entity.is_some(),"limits":["Native texture sampled on actual restored terrain clipped with verified native world-to-UV math.","Explicit diagnostic half-size500/angle0/FOW1; ADD and depth states reconstructed, original emitter placement and lifecycle not connected.","Pixel shader fog/death/color-palette/mip variants, other receiving surfaces and original depth/sampler policy remain unqualified."]});
        if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&diagnostic).unwrap()) {warn!("Projected render diagnostic: {error}");}
        probe.finished=true;
    }
}

/// Hold the authored texture and shader from startup, before a short-lived cast.
/// This prepares assets only; specialized GPU pipeline readiness is separate.
#[derive(Resource)]
struct PreparedAssets {
    _shader:Handle<bevy::shader::Shader>,
    _vertex_shader:Handle<bevy::shader::Shader>,
    _texture:Handle<Image>,
    _color_texture:Handle<Image>,
}
pub fn preload(mut commands:Commands, assets:Res<AssetServer>) {
    commands.insert_resource(PreparedAssets {
        _shader:assets.load("shaders/projected_terrain.wgsl"),
        _vertex_shader:assets.load("shaders/projected_vertex.wgsl"),
        _texture:terrain_material::projected_image(&assets,"particles/annie/disintegrate-light.png".into()),
        _color_texture:terrain_material::projected_image(&assets,"particles/annie/color-hold.png".into()),
    });
}
