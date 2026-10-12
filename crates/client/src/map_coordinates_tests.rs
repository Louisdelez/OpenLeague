use super::*;
use serde_json::Value;
fn proof() -> Value {
    serde_json::from_str(include_str!("../../../data/4.20/map_coordinates_contract.json")).unwrap()
}
fn ambient() -> Value {
    serde_json::from_str(include_str!("../../../data/4.20/map_ambient_manifest.json")).unwrap()
}
fn point(v: &Value) -> Vec3 {
    Vec3::new(v[0].as_f64().unwrap() as f32,v[1].as_f64().unwrap() as f32,v[2].as_f64().unwrap() as f32)
}
fn matrix(v: &Value) -> Mat4 {
    Mat4::from_cols_array(&std::array::from_fn(|i|v[i].as_f64().unwrap() as f32))
}
fn close(a: Vec3, b: Vec3, tolerance: f32) {
    assert!((a-b).abs().max_element() <= tolerance, "{a:?} != {b:?}");
}
fn glb() -> (Value,Vec<u8>) {
    let raw=std::fs::read(std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets/maps/twisted_treeline.glb")).unwrap();
    assert_eq!(&raw[..4],b"glTF");
    let n=u32::from_le_bytes(raw[12..16].try_into().unwrap()) as usize;
    (serde_json::from_slice(&raw[20..20+n]).unwrap(),raw[28+n..].to_vec())
}
fn positions(doc: &Value,blob: &[u8],index: usize) -> Vec<Vec3> {
    let a=&doc["accessors"][index];let v=&doc["bufferViews"][a["bufferView"].as_u64().unwrap() as usize];
    assert_eq!(a["componentType"],5126);assert_eq!(a["type"],"VEC3");
    let offset=(v["byteOffset"].as_u64().unwrap_or(0)+a["byteOffset"].as_u64().unwrap_or(0)) as usize;
    let stride=v["byteStride"].as_u64().unwrap_or(12) as usize;
    (0..a["count"].as_u64().unwrap() as usize).map(|i|Vec3::from_array(std::array::from_fn(|j| {
        let at=offset+i*stride+j*4;f32::from_le_bytes(blob[at..at+4].try_into().unwrap())
    }))).collect()
}

#[test]
fn two_native_altar_floors_bind_to_actual_dynamic_catalogue_in_d() {
    let proof=proof();let (doc,blob)=glb();
    let altars:Value=serde_json::from_str(include_str!("../../../data/4.20/altars_map10.json")).unwrap();
    for row in proof["altar_bindings"].as_array().unwrap() {
        let mut lo=Vec3::splat(f32::INFINITY);let mut hi=Vec3::splat(f32::NEG_INFINITY);
        for id in row["native_mesh_ids"].as_array().unwrap() {
            let name=format!("MapGeo_Instance_{}",id.as_u64().unwrap());
            let node=doc["nodes"].as_array().unwrap().iter().find(|n|n["name"]==name).unwrap();
            for k in ["matrix","translation","scale","rotation"] {assert!(node[k].is_null());}
            let primitive=&doc["meshes"][node["mesh"].as_u64().unwrap() as usize]["primitives"][0];
            for p in positions(&doc,&blob,primitive["attributes"]["POSITION"].as_u64().unwrap() as usize) {lo=lo.min(p);hi=hi.max(p);}
        }
        close(lo,point(&row["bounds_min"]),0.00001);close(hi,point(&row["bounds_max"]),0.00001);
        let actual=altars["altars"].as_array().unwrap().iter().find(|a|a["name"]==row["name"]).unwrap();
        let p=Vec3::new(actual["position"]["x"].as_f64().unwrap() as f32,actual["height"].as_f64().unwrap() as f32,actual["position"]["z"].as_f64().unwrap() as f32);
        // Real source vertices versus independently used runtime actor catalogue.
        close(map_root_transform().transform_point((lo+hi)*0.5),p/20.,0.0001);
        assert!(row["horizontal_separation_current_native_units"].as_f64().unwrap()>1800.);
    }
}

#[test]
fn both_nexus_and_relic_gears_preserve_three_authored_offsets() {
    let proof=proof();let ambient=ambient();
    let world:Value=serde_json::from_str(include_str!("../../../data/4.20/map10_world.json")).unwrap();
    let interactions:Value=serde_json::from_str(include_str!("../../../data/4.20/map10_interactions.json")).unwrap();
    assert_eq!(proof["authored_pairs"].as_array().unwrap().len(),3);
    for row in proof["authored_pairs"].as_array().unwrap() {
        let native_actor=point(&row["actor"]["point"]);let native_decor=point(&row["decor"]["point"]);
        let actual_actor=if row["actor"]["name"].as_str().unwrap().starts_with("HQ_") {
            let a=world["structures"].as_array().unwrap().iter().find(|a|a["name"]==row["actor"]["name"]).unwrap();
            Vec3::new(a["position"]["x"].as_f64().unwrap() as f32,a["height"].as_f64().unwrap() as f32,a["position"]["z"].as_f64().unwrap() as f32)
        } else {Vec3::new(interactions["relic_position"]["x"].as_f64().unwrap() as f32,interactions["relic_height"].as_f64().unwrap() as f32,interactions["relic_position"]["z"].as_f64().unwrap() as f32)};
        close(actual_actor,native_actor,0.001);
        let placement=ambient["placements"].as_array().unwrap().iter().find(|p|p["id"]==row["embedded_root"]).unwrap();
        let rendered=ambient_transform(matrix(&placement["matrix"]),crate::terrain_material::native_map_extent()).unwrap().translation;
        close(rendered-actual_actor/20.,(native_decor-native_actor)/20.,0.0001);
    }
}

#[test]
fn all_seventeen_ambient_linear_bases_and_child_poses_match_source_placements() {
    let proof=proof();let manifest=ambient();
    assert_eq!(manifest["placements"].as_array().unwrap().len(),17);
    for placement in manifest["placements"].as_array().unwrap() {
        let row=proof["ambient_placements"].as_array().unwrap().iter().find(|r|r["id"]==placement["id"]).unwrap();
        let expected=matrix(&row["source_direct_matrix"]);
        let actual=ambient_transform(matrix(&placement["matrix"]),crate::terrain_material::native_map_extent()).unwrap();
        assert!(actual.to_matrix().determinant()>0.);
        // Off-origin child points exercise rotation and scale, not just root position.
        for child in [Vec3::ZERO,Vec3::X*100.,Vec3::Y*75.,Vec3::Z*200.,Vec3::new(37.,19.,-42.)] {
            close(actual.transform_point(child),expected.transform_point3(child),0.0001);
        }
    }
    assert!(ambient_transform(Mat4::IDENTITY,0.).is_err());
    assert!(ambient_transform(Mat4::IDENTITY,f32::NAN).is_err());
    assert!(ambient_transform(Mat4::ZERO,15398.671875).is_err());
}

#[test]
fn named_points_keep_native_fog_flip_colormap_and_cloud_coordinates_distinct() {
    let proof=proof();let extent=crate::terrain_material::native_map_extent();
    let c230=crate::native_fow::FogParams::from_native_extent(extent).unwrap();
    let c233=crate::terrain_material::map10_terrain_transform();
    let settings=crate::fow_settings::Settings::map10().shader_parameters(extent).unwrap();
    let visibility=Vec4::from_array(settings.coordinates);let world_visibility=Vec4::new(visibility.x*20.,visibility.y*20.,visibility.z,visibility.w);
    let cloud=Vec4::from_array(crate::native_cloud_phase::Phase::default().constants(2000.));
    for row in proof["landmarks"].as_array().unwrap() {
        let native=point(&row["point"]);let world=map_root_transform().transform_point(native);let recovered=native_from_world(world);
        close(recovered,native,0.002);
        let lighting=recovered.xz()*c230.params().xy()+c230.params().zw();
        let visible=world.xz()*world_visibility.xy()+world_visibility.zw();
        assert!((lighting-visible).abs().max_element()<0.000001);
        assert!((lighting-c230.texture_coordinates(native.xz())).abs().max_element()<0.000001);
        let colormap=recovered.xz()*c233.xy()+c233.zw();
        assert!((colormap-(native.xz()*c233.xy()+c233.zw())).abs().max_element()<0.000001);
        assert!(((recovered.xz()*cloud.x+cloud.yz())-(native.xz()*cloud.x+cloud.yz())).abs().max_element()<0.00001);
    }
    assert_eq!(c230.texture_coordinates(Vec2::ZERO),Vec2::new(0.,1.));
    assert_eq!(Vec2::ZERO*c233.xy()+c233.zw(),Vec2::ZERO);
    for shader in [include_str!("../../../assets/shaders/environment_fow_vertex.wgsl"),include_str!("../../../assets/shaders/terrain_fow_vertex.wgsl")] {
        assert!(shader.contains("let native_xz=out.world_position.xz*terrain_coordinates.z;"));
        assert!(!shader.contains("terrain_coordinates.w-"));
    }
}

#[test]
fn native_camera_and_real_grid_picker_keep_the_direct_landmark_coordinates() {
    let proof=proof();let terrain=crate::picking::Terrain::default();
    let mut camera=crate::camera_native::NativeCamera::default();
    for row in proof["landmarks"].as_array().unwrap() {
        let native=point(&row["point"]);
        let hit=terrain.0.raycast_floor((native+Vec3::Y*1000.).to_array(),[0.,-1.,0.]).unwrap();
        assert!((hit.x-native.x).abs()<0.001 && (hit.z-native.z).abs()<0.001);
        let (_,_,focus)=camera.pose(native/20.,0.,0.).unwrap();
        close(Vec3::from_array(camera.native_focus()),focus*20.,0.001);
        // Native camera limits may clamp its focus; those policies are not changed.
        let params=camera.native_parameters().unwrap();assert!(params.position.iter().all(|v|v.is_finite()));
    }
}

#[test]
fn ecs_propagates_real_floor_child_vertices_and_ambient_placement_in_d() {
    let proof=proof();let mut app=App::new();app.add_plugins(bevy::transform::TransformPlugin);
    let map=app.world_mut().spawn((MapRoot,map_root_transform())).id();
    let mut expected=Vec::new();
    for row in proof["altar_bindings"].as_array().unwrap() {
        let native=point(&row["native_geometry_center"]);
        expected.push((app.world_mut().spawn((Transform::from_translation(native),ChildOf(map))).id(),point(&row["current_dynamic_position"])/20.));
    }
    for row in proof["ambient_placements"].as_array().unwrap() {
        let transform=ambient_transform(matrix(&row["legacy_matrix"]),crate::terrain_material::native_map_extent()).unwrap();
        let root=app.world_mut().spawn(transform).id();let child=Vec3::new(5.,17.,29.);
        expected.push((app.world_mut().spawn((Transform::from_translation(child),ChildOf(root))).id(),matrix(&row["source_direct_matrix"]).transform_point3(child)));
    }
    app.update();
    for (entity,position) in expected {close(app.world().get::<GlobalTransform>(entity).unwrap().translation(),position,0.0001);}
}
