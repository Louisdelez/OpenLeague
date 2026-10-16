use bevy::{
    gltf::GltfMaterialName,
    image::{
        ImageAddressMode, ImageFilterMode, ImageLoaderSettings, ImageSampler,
        ImageSamplerDescriptor,
    },
    mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline, MaterialPipelineKey},
    prelude::*,
    reflect::TypePath,
    render::render_resource::{
        AsBindGroup, RenderPipelineDescriptor, SpecializedMeshPipelineError,
    },
    shader::ShaderRef,
};
use std::collections::HashMap;

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct TerrainMaterial {
    #[uniform(30)] pub high_fog0:Vec4,
    #[uniform(31)] pub high_fog1:Vec4,
    #[uniform(32)] pub cloud_phase:Vec4,
    #[texture(33)] #[sampler(34)] pub cloud_opacity:Handle<Image>,
    #[uniform(35)] pub fog_mod2x:u32,
    #[uniform(36)] pub fog_profile:UVec4,
    #[uniform(37)] pub fog_constant:Vec4,

    #[uniform(0)]
    scales: Vec4,
    #[uniform(1)]
    half_blend: f32,
    #[texture(2)]
    #[sampler(3)]
    layer0: Handle<Image>,
    #[texture(4)]
    #[sampler(5)]
    layer1: Handle<Image>,
    #[texture(6)]
    #[sampler(7)]
    layer2: Handle<Image>,
    #[texture(8)]
    #[sampler(9)]
    layer3: Handle<Image>,
    #[texture(10)]
    #[sampler(11)]
    height_map: Handle<Image>,
    #[texture(12)]
    #[sampler(13)]
    colormap: Handle<Image>,
    #[uniform(14)]
    fog_opaque: Vec4,
    #[texture(15)]
    #[sampler(16)]
    fog_lighting: Handle<Image>,
    #[texture(17)] #[sampler(18)] pub visibility_map:Handle<Image>,
    #[uniform(19)] pub visibility_params:Vec4,
    #[uniform(20)] pub visibility_diagnostic:u32,
    #[uniform(21)] pub visibility_height:Vec4,
    #[uniform(22)] pub visibility_edge:Vec4,
    #[texture(23)] #[sampler(24)] pub visibility_overlay:Handle<Image>,
    #[uniform(25)] pub visibility_below:Vec4,
    #[uniform(26)] pub visibility_ready:u32,
    #[uniform(27)] terrain_transform: Vec4,
    #[uniform(28)] fog_coordinates: Vec4,
    #[uniform(29)] alpha_reference:f32,
}
pub(crate) struct FogProbeInputs<'a> {
    pub coordinates:Vec4,pub lighting:&'a Handle<Image>,pub alpha_reference:f32,pub colormap:&'a Handle<Image>,
}
impl TerrainMaterial {
    /// Borrowed exact CPU texture identities for the opt-in capture barrier.
    /// This does not establish GPU allocation, encoded FoW, drawing or pixels.
    pub(crate) fn capture_images(&self)->[&Handle<Image>;10] {
        [&self.layer0,&self.layer1,&self.layer2,&self.layer3,&self.height_map,
            &self.colormap,&self.fog_lighting,&self.cloud_opacity,
            &self.visibility_map,&self.visibility_overlay]
    }
    pub(crate) fn coordinate_uniform(&self)->Vec4 {self.fog_opaque}
    /// Borrowed CPU observations only; never alters material values or ownership.
    pub(crate) fn fog_probe_inputs(&self)->FogProbeInputs<'_> {
        FogProbeInputs {coordinates:self.fog_coordinates,lighting:&self.fog_lighting,alpha_reference:self.alpha_reference,colormap:&self.colormap}
    }
}
impl Material for TerrainMaterial {
    fn vertex_shader()->ShaderRef { "shaders/terrain_fow_vertex.wgsl".into() }
    fn fragment_shader() -> ShaderRef {
        "shaders/terrain_height_blend.wgsl".into()
    }
    fn specialize(
        _pipeline: &MaterialPipeline,
        descriptor: &mut RenderPipelineDescriptor,
        _layout: &MeshVertexBufferLayoutRef,
        _key: MaterialPipelineKey<Self>,
    ) -> Result<(), SpecializedMeshPipelineError> {
        descriptor.primitive.cull_mode = None;
        Ok(())
    }
}
#[derive(Resource, Default)]
pub struct TerrainMaterials(HashMap<String, Handle<TerrainMaterial>>);
impl TerrainMaterials {
    /// Readonly current native Terrain conversion expectation; no Standard fallback.
    pub(crate) fn expects(&self,name:&str)->bool {self.0.contains_key(name)}
}
#[derive(Component)]
pub struct NativeTerrainBound;
fn configure_image(s: &mut ImageLoaderSettings, tiled: bool) {
            // Legacy HLSL performs its blending on raw texture channels. Convert the
            // final display RGB to linear in WGSL, rather than linearizing masks/alpha.
            s.is_srgb = false;
            s.sampler = ImageSampler::Descriptor(ImageSamplerDescriptor {
                address_mode_u: if tiled {
                    ImageAddressMode::Repeat
                } else {
                    ImageAddressMode::ClampToEdge
                },
                address_mode_v: if tiled {
                    ImageAddressMode::Repeat
                } else {
                    ImageAddressMode::ClampToEdge
                },
                mag_filter: ImageFilterMode::Linear,
                min_filter: ImageFilterMode::Linear,
                ..default()
            });
}
pub(crate) fn image(assets: &AssetServer, path: String, tiled: bool) -> Handle<Image> {
    assets
        .load_builder()
        .with_settings(move |s: &mut ImageLoaderSettings| {
            configure_image(s, tiled);
        })
        .load(path)
}
// Original particle manager sets stage0 MIPFILTER NONE; WGPU uses an explicit LOD clamp.
fn configure_projected_image(settings:&mut ImageLoaderSettings) {
    configure_image(settings,false);
    if let ImageSampler::Descriptor(sampler)=&mut settings.sampler {
        sampler.lod_min_clamp=0.;
        sampler.lod_max_clamp=0.;
    }
}
pub(crate) fn projected_image(assets:&AssetServer,path:String)->Handle<Image> {
    assets.load_builder().with_settings(configure_projected_image).load(path)
}
pub fn setup(
    mut commands: Commands,
    assets: Res<AssetServer>,
    mut materials: ResMut<Assets<TerrainMaterial>>,
    native_settings:Res<crate::environment_render_config::State>,
) {
    let data: serde_json::Value =
        serde_json::from_str(include_str!("../../../data/4.20/terrain_materials.json"))
            .expect("native terrain configuration");
    native_settings.require_current_material_profile().expect("native terrain profile");
    let scales=Vec4::from_array(native_settings.scales);
    let height_map = image(&assets, data["height_map"].as_str().unwrap().into(), false);
    let colormap = image(&assets, data["colormap"].as_str().unwrap().into(), false);
    let fog: serde_json::Value =
        serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json"))
            .expect("native fog settings");
    let fp = fog["fog_data1"].as_array().unwrap();
    let fog_opaque = Vec4::new(
        fp[1].as_f64().unwrap() as f32,
        fp[2].as_f64().unwrap() as f32,
        crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT,
        0., // Reserved, matching FogExtension: no world mirror origin.
    );
    let fog_lighting = image(&assets, fog["fog_lighting"].as_str().unwrap().into(), false);
    let mut catalog = TerrainMaterials::default();
    for entry in data["terrain_materials"].as_array().unwrap() {
        let layers = entry["layers"].as_array().unwrap();
        let handle = materials.add(TerrainMaterial {
            high_fog0:crate::native_high_fog::fog_vectors().0,
        high_fog1:crate::native_high_fog::fog_vectors().1,
        cloud_phase:Vec4::from_array(crate::native_cloud_phase::Phase::default().constants(2000.)),
        cloud_opacity:crate::native_high_fog::cloud_image(&assets),
        fog_mod2x:u32::from(native_settings.colormap),
        fog_profile:crate::native_high_fog::profile_uniform(3),
        fog_constant:crate::native_high_fog::fog_constant(),
        scales,
            terrain_transform: map10_terrain_transform(),
            fog_coordinates: native_map_fog_coordinates(),
            alpha_reference:crate::native_alpha::shader_reference(native_settings.alpha_reference).expect("native terrain alpha reference"),
            half_blend: data["half_blend_area"].as_f64().unwrap() as f32,
            layer0: image(&assets, layers[0].as_str().unwrap().into(), true),
            layer1: image(&assets, layers[1].as_str().unwrap().into(), true),
            layer2: image(&assets, layers[2].as_str().unwrap().into(), true),
            layer3: image(&assets, layers[3].as_str().unwrap().into(), true),
            height_map: height_map.clone(),
            colormap: colormap.clone(),
            fog_opaque,
            fog_lighting: fog_lighting.clone(),
            visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_diagnostic:0,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,
        });
        catalog
            .0
            .insert(entry["name"].as_str().unwrap().into(), handle);
    }
    commands.insert_resource(catalog);
}
pub fn bind(
    mut commands: Commands,
    catalog: Res<TerrainMaterials>,
    query: Query<
        (Entity, &GltfMaterialName),
        (
            With<MeshMaterial3d<StandardMaterial>>,
            Without<NativeTerrainBound>,
        ),
    >,
    mut count: Local<usize>,
) {
    for (entity, name) in &query {
        if let Some(handle) = catalog.0.get(&name.0) {
            commands
                .entity(entity)
                .remove::<MeshMaterial3d<StandardMaterial>>()
                .insert((MeshMaterial3d(handle.clone()), NativeTerrainBound));
            *count += 1;
            println!(
                "Native height-blend terrain bound: {} (total {})",
                name.0, *count
            );
        }
    }
}

#[cfg(test)]
mod projected_sampler_tests {
    use super::*;
    #[test]
    fn production_projected_image_addressing_matches_original_dispatch_and_cache_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_sampler_contract.json")).unwrap();
        let mut settings=ImageLoaderSettings::default();
        configure_image(&mut settings,false);
        let ImageSampler::Descriptor(sampler)=settings.sampler else {panic!("explicit projected sampler required")};
        assert_eq!(sampler.address_mode_u,ImageAddressMode::ClampToEdge);
        assert_eq!(sampler.address_mode_v,ImageAddressMode::ClampToEdge);
        for case in proof["cases"].as_array().unwrap() {
            let calls=case["calls"].as_array().unwrap();
            if case["initial_cached"]==2 {assert!(calls.is_empty());}
            else {
                assert_eq!(calls.len(),6);
                for stage in 0..3 {
                    // Native D3D address U/V states1/2 both receive CLAMP3.
                    assert!(calls.contains(&serde_json::json!([stage,1,3])));
                    assert!(calls.contains(&serde_json::json!([stage,2,3])));
                }
            }
            assert_eq!(case["final_cached"],serde_json::json!([[2,2],[2,2],[2,2]]));
        }
    }
}

#[cfg(test)]
mod projected_filter_tests {
    use super::*;
    #[test]
    fn projected_loader_matches_original_linear_filters_and_disables_mip_selection() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particle_filter_contract.json")).unwrap();
        let cold=&p["cases"][0]["calls"].as_array().unwrap();
        for pair in [[0,5,2],[0,6,2],[0,7,0]] {assert!(cold.contains(&serde_json::json!(pair)));}
        let mut settings=ImageLoaderSettings::default();configure_projected_image(&mut settings);
        let ImageSampler::Descriptor(s)=settings.sampler else {panic!("explicit projected sampler required")};
        assert_eq!(s.mag_filter,ImageFilterMode::Linear);assert_eq!(s.min_filter,ImageFilterMode::Linear);
        assert_eq!(s.lod_min_clamp,0.);assert_eq!(s.lod_max_clamp,0.);
        assert_eq!(s.address_mode_u,ImageAddressMode::ClampToEdge);assert_eq!(s.address_mode_v,ImageAddressMode::ClampToEdge);
    }
}

// Original 86FB74 SSE c233 producer; preserve reciprocal/multiply order.
fn terrain_transform_from_bounds(span: [f32; 3], center: [f32; 3]) -> Option<Vec4> {
    if !span[0].is_finite() || !span[2].is_finite() || span[0] <= 0. || span[2] <= 0.
        || !center[0].is_finite() || !center[2].is_finite() { return None; }
    let x = 1. / span[0]; let z = 1. / span[2];
    let value = Vec4::new(x, z, -((center[0] - span[0] * 0.5) * x), -((center[2] - span[2] * 0.5) * z));
    value.is_finite().then_some(value)
}
pub(crate) fn map10_terrain_transform() -> Vec4 {
    let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/terrain_transform_contract.json")).expect("qualified native terrain transform");
    let first = &proof["cases"][0];
    let read = |name: &str| std::array::from_fn(|i| f32::from_bits(first[name][i].as_u64().expect("native f32 bits") as u32));
    terrain_transform_from_bounds(read("span_bits"), read("center_bits")).expect("valid Map10 native bounds")
}
#[cfg(test)]
mod native_terrain_transform_tests {
    use super::*;
    #[test]
    fn production_c233_matches_native_upload_bits_and_rejects_degenerate_bounds() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/terrain_transform_contract.json")).unwrap();
        assert!(proof["passed"].as_bool().unwrap());
        for case in proof["cases"].as_array().unwrap() {
            let read = |name: &str| std::array::from_fn(|i| f32::from_bits(case[name][i].as_u64().unwrap() as u32));
            let span: [f32;3] = read("span_bits");
            if span[0] <= 0. || span[2] <= 0. {
                assert!(terrain_transform_from_bounds(span,read("center_bits")).is_none());
            } else {
                let got = terrain_transform_from_bounds(span,read("center_bits")).unwrap().to_array().map(f32::to_bits);
                for i in 0..4 { assert_eq!(got[i],case["uploaded_bits"][i].as_u64().unwrap() as u32); }
            }
        }
        let map = map10_terrain_transform();
        assert_ne!(map.x.to_bits(),(1f32/15360.).to_bits());
        // Native c233 bounds remain unchanged by the client rendering basis.
        let extent = 15398.671875f32;
        assert_eq!(extent * map.x + map.z,1.);
        let world_z = extent / crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT;
        assert_eq!(world_z * 20. * map.y + map.w,1.);
    }
}

pub(crate) fn native_map_extent() -> f32 {
 crate::map10_vision_view::Map10VisionView::native_map10().expect("native Map10 geometry").geometry.extent
}
pub(crate) fn native_map_fog_coordinates() -> Vec4 {
 crate::native_fow::FogParams::from_native_extent(native_map_extent()).expect("qualified c230 Map10 bounds").params()
}
#[cfg(test)] mod native_world_texture_coordinates_tests {
 use super::*;
 #[test] fn map_root_inverse_and_fog_lighting_coordinates_follow_actual_startup_and_native_shader() {
  let extent=native_map_extent();let c230=native_map_fog_coordinates();let c233=map10_terrain_transform();
  let root=crate::map_coordinates::map_root_transform();
  for x in [0.,1.,4009.24,7699.3359375,15360.,extent] {
   for z in [0.,1.,4009.24,7699.3359375,15360.,extent] {
    let position=root.transform_point(Vec3::new(x,0.,z));
    let recovered=crate::map_coordinates::native_from_world(position).xz();
    let actual_fog=recovered*c230.xy()+c230.zw();let expected_fog=Vec2::new(x,z)*c230.xy()+c230.zw();
    assert!((actual_fog-expected_fog).abs().max_element()<0.000001);
    let actual_terrain=recovered*c233.xy()+c233.zw();let expected_terrain=Vec2::new(x,z)*c233.xy()+c233.zw();
    assert!((actual_terrain-expected_terrain).abs().max_element()<0.000001);
   }
  }
  // Native fog texture flips Z; colormap does not. They must use separate UVs.
  assert_eq!(Vec2::ZERO*c230.xy()+c230.zw(),Vec2::new(0.,1.));
  assert_eq!(Vec2::ZERO*c233.xy()+c233.zw(),Vec2::ZERO);
  assert_eq!(root.translation,Vec3::ZERO);
  assert_eq!(root.scale,Vec3::splat(0.05));
 }
}
