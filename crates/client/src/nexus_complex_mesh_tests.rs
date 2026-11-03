use super::*;
use bevy::mesh::VertexAttributeValues;
use crate::nexus_complex_material::{self as material, Inputs, OutputEncoding, Cull};

#[test]
fn original_scb_retains_every_corner_uv_and_black_rgb_without_guessing_normals() {
    let g=Geometry::original();assert_eq!(g.corners.len(),108);
    assert!(g.corners.iter().all(|c|c.rgb==[0;3]));
    for (i,c) in g.corners.iter().enumerate() {
        let at=428+(i/3)*100;let corner=i%3;let v=u32_at(SOURCE,at+corner*4) as usize;
        assert_eq!(c.position.map(f32::to_bits),std::array::from_fn(|a|f32_at(SOURCE,176+v*12+a*4).to_bits()));
        assert_eq!(c.uv.map(f32::to_bits),[f32_at(SOURCE,at+76+corner*4).to_bits(),f32_at(SOURCE,at+88+corner*4).to_bits()]);
    }
    let mesh=g.bake(NativeWorld(Mat4::IDENTITY.to_cols_array())).unwrap();
    assert!(mesh.attribute(Mesh::ATTRIBUTE_NORMAL).is_none());
    assert!(mesh.indices().is_none());assert_eq!(mesh.count_vertices(),108);
    let mut changed=SOURCE.to_vec();let last=changed.len()-1;changed[last]=1;assert!(Geometry::decode(&changed).is_err());
    assert!(Geometry::decode(&SOURCE[..SOURCE.len()-1]).is_err());
}
#[test]
fn affine_native_vertices_become_direct_d_and_height_is_baked_before_interpolation() {
    let g=Geometry {corners:vec![Corner {position:[0.,-1100.,0.],uv:[0.,0.],rgb:[0;3]},
        Corner {position:[20.,-950.,40.],uv:[1.,0.],rgb:[0;3]},
        Corner {position:[0.,-800.,0.],uv:[0.,1.],rgb:[0;3]}],centre:[7.,8.,9.]};
    let mesh=g.bake(NativeWorld(Mat4::from_translation(Vec3::new(100.,0.,200.)).to_cols_array())).unwrap();
    let VertexAttributeValues::Float32x3(p)=mesh.attribute(Mesh::ATTRIBUTE_POSITION).unwrap() else{panic!()};
    assert_eq!(p,&vec![[5.,-55.,10.],[6.,-47.5,12.],[5.,-40.,10.]]);
    let VertexAttributeValues::Float32x4(c)=mesh.attribute(Mesh::ATTRIBUTE_COLOR).unwrap() else{panic!()};
    assert_eq!(c.iter().map(|v|v[3]).collect::<Vec<_>>(),vec![0.,0.5,1.]);
    let mut invalid=Mat4::IDENTITY.to_cols_array();invalid[4]=f32::NAN;
    assert!(g.bake(NativeWorld(invalid)).is_err());
    invalid=Mat4::IDENTITY.to_cols_array();invalid[3]=1.;assert!(g.bake(NativeWorld(invalid)).is_err());
}
#[test]
fn real_dds_decode_raw_bc3_and_mode1_preserves_separate_alpha_blend() {
    let mut images=Assets::<Image>::default();let t=material::Textures::fixture(&mut images);
    t.validate(&images).unwrap();
    for group in [Group::GemInside,Group::Gem] {
        let i=images.get(t.handle(group).unwrap()).unwrap();assert!(!i.texture_descriptor.format.is_srgb());
        assert!(!i.data.as_ref().unwrap().is_empty());
    }
    let blend=material::mode1_blend();
    use bevy::render::render_resource::{BlendFactor,BlendOperation};
    for c in [blend.color,blend.alpha] {assert_eq!(c.src_factor,BlendFactor::SrcAlpha);
        assert_eq!(c.dst_factor,BlendFactor::OneMinusSrcAlpha);assert_eq!(c.operation,BlendOperation::Add);}
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_render_state_contract.json")).unwrap();
    let row=proof["cases"].as_array().unwrap().iter().find(|r|r["mode"]==1&&r["flags"]==0&&r["initial"]==0).unwrap();
    for pair in [[19,5],[20,6],[207,5],[208,6]] {assert!(row["calls"].as_array().unwrap().contains(&serde_json::json!(pair)));}
}
#[test]
fn unsupported_shader_and_state_variants_fail_without_white_or_color_fallback() {
    let input=Inputs {uv_scale_offset:Vec4::new(1.,1.,0.,0.),lookup_uv:Vec2::splat(0.5),color_factor:Vec4::ONE,
        native_fog_extent:15360.,output_encoding:OutputEncoding::RawNumeric,cull:Cull::Back,shader_features:0,
        fresnel:Vec4::ZERO,render_mode:1,render_flags:0};
    input.validate().unwrap();
    for bad in [Inputs {shader_features:1,..input},Inputs {fresnel:Vec4::X,..input},
        Inputs {render_flags:2,..input},Inputs {render_mode:4,..input},Inputs {native_fog_extent:0.,..input},
        Inputs {lookup_uv:Vec2::splat(f32::NAN),..input}] {assert!(bad.validate().is_err());}
}

#[test]
fn sparkle_uses_its_own_504_source_corners_and_original_uvs() {
    assert_ne!(SPARKLE_SOURCE,SOURCE);
    let g=Geometry::sparkle();assert_eq!(g.corners.len(),504);
    assert!(g.corners.iter().all(|c|c.rgb==[0;3]));
    for (i,c) in g.corners.iter().enumerate() {
        let at=1220+(i/3)*100;let corner=i%3;let v=u32_at(SPARKLE_SOURCE,at+corner*4) as usize;
        assert!(v<86);
        assert_eq!(c.position.map(f32::to_bits),std::array::from_fn(|a|f32_at(SPARKLE_SOURCE,176+v*12+a*4).to_bits()));
        assert_eq!(c.uv.map(f32::to_bits),[f32_at(SPARKLE_SOURCE,at+76+corner*4).to_bits(),f32_at(SPARKLE_SOURCE,at+88+corner*4).to_bits()]);
    }
    let mesh=g.bake(NativeWorld(Mat4::IDENTITY.to_cols_array())).unwrap();
    assert_eq!(mesh.count_vertices(),504);assert!(mesh.attribute(Mesh::ATTRIBUTE_NORMAL).is_none());
    let mut changed=SPARKLE_SOURCE.to_vec();changed[200]^=1;assert!(Geometry::decode(&changed).is_err());
    assert!(Geometry::decode(&SPARKLE_SOURCE[..SPARKLE_SOURCE.len()-1]).is_err());
}

#[test]
fn sparkle_raw_dds_is_optional_only_for_startup_and_never_aliases_gem() {
    let mut images=Assets::<Image>::default();let startup=material::Textures::fixture(&mut images);
    assert!(startup.handle(Group::GemSparkle).is_err());startup.validate(&images).unwrap();
    let on=material::Textures::fixture_set(&mut images,material::TextureSet::On);on.validate(&images).unwrap();
    let sparkle=on.handle(Group::GemSparkle).unwrap();let gem=on.handle(Group::Gem).unwrap();
    assert_ne!(sparkle.id(),gem.id());
    let s=images.get(sparkle).unwrap();let g=images.get(gem).unwrap();
    assert_ne!(s.data,g.data);assert_eq!(s.texture_descriptor.size.width,256);assert_eq!(s.texture_descriptor.mip_level_count,9);
    assert_eq!(s.texture_descriptor.format,bevy::render::render_resource::TextureFormat::Bc3RgbaUnorm);
    images.remove(sparkle.id());assert!(on.validate(&images).is_err());startup.validate(&images).unwrap();
}

#[test]
fn custom_nexus_culling_obeys_the_actual_reflected_camera_pipeline_key() {
    use bevy::{pbr::MeshPipelineKey,render::render_resource::Face};
    for (invert,back,front) in [(false,Face::Back,Face::Front),(true,Face::Front,Face::Back)] {
        let key=if invert {MeshPipelineKey::INVERT_CULLING} else {MeshPipelineKey::empty()};
        assert_eq!(material::view_cull(Cull::Back,key),Some(back));
        assert_eq!(material::view_cull(Cull::Front,key),Some(front));
        assert_eq!(material::view_cull(Cull::None,key),None);
    }
}

#[test] fn pickup_geometry_matches_every_word_from_original_scb_reader() {
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/scb_reader_contract.json")).unwrap();assert_eq!(proof["passed"],true);
 let capture=&proof["geometry_capture"];let g=Geometry::decode(PICKUP_SOURCE).unwrap();assert_eq!(g.corners.len(),240);
 assert_eq!(g.centre.map(f32::to_bits),std::array::from_fn(|i|capture["center_words"][i].as_u64().unwrap() as u32));
 for (index,c) in g.corners.iter().enumerate() {
  let face=&capture["faces"][index/3];let corner=index%3;let vertex=face["indices"][corner].as_u64().unwrap() as usize;
  assert_eq!(c.position.map(f32::to_bits),std::array::from_fn(|i|capture["vertex_words"][vertex*3+i].as_u64().unwrap() as u32));
  assert_eq!(c.uv.map(f32::to_bits),[face["uv_words"][corner].as_u64().unwrap() as u32,face["uv_words"][3+corner].as_u64().unwrap() as u32]);
  let bgra=(face["corner_BGRA"][corner].as_u64().unwrap() as u32).to_le_bytes();assert_eq!(c.rgb,[bgra[2],bgra[1],bgra[0]]);
 }
 let mut changed=PICKUP_SOURCE.to_vec();changed[200]^=1;assert!(Geometry::decode(&changed).is_err());
}
