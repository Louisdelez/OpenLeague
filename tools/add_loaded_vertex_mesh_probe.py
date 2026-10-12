from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/map_fog.rs';s=p.read_text();s+='''
/// Dump loaded geometry and bindings only for an explicitly enabled diagnostic.
pub fn dump_probe(
    time: Res<Time>,
    mut written: Local<bool>,
    meshes: Res<Assets<Mesh>>,
    materials: Res<Assets<FogMaterial>>,
    query: Query<(&bevy::gltf::GltfMeshName, &Mesh3d, &GlobalTransform, Option<&MeshMaterial3d<FogMaterial>>)>,
) {
    if *written || time.elapsed_secs() < 50. || std::env::var_os("OPENLEAGUE_SCREENSHOT").is_none()
        || std::env::var("OPENLEAGUE_PROBE_LOADED_MESHES").as_deref() != Ok("1") { return; }
    fn attribute(mesh: &Mesh, key: bevy::mesh::MeshVertexAttribute) -> serde_json::Value {
        use bevy::mesh::VertexAttributeValues;
        match mesh.attribute(key) {
            Some(VertexAttributeValues::Float32x2(v)) => serde_json::json!(v),
            Some(VertexAttributeValues::Float32x3(v)) => serde_json::json!(v),
            Some(VertexAttributeValues::Float32x4(v)) => serde_json::json!(v),
            _ => serde_json::Value::Null,
        }
    }
    let mut rows=Vec::new();
    for (name,handle,transform,material) in &query {
        if !["MapGeo_Instance_365","MapGeo_Instance_534"].contains(&name.0.as_str()) { continue; }
        let Some(mesh)=meshes.get(&handle.0) else { continue; };
        let bound=material.and_then(|m|materials.get(&m.0));
        rows.push(serde_json::json!({"mesh":name.0,"world_matrix":transform.to_matrix().to_cols_array(),
            "native_factor":bound.map(|m|m.extension.vertex_lighting_factor),"diagnostic_channel":bound.map(|m|m.extension.diagnostic_channel),
            "positions":attribute(mesh,Mesh::ATTRIBUTE_POSITION),"uv":attribute(mesh,Mesh::ATTRIBUTE_UV_0),"colors":attribute(mesh,Mesh::ATTRIBUTE_COLOR),
            "indices":mesh.indices().map(|v|v.iter().collect::<Vec<_>>())}));
    }
    if rows.len()<2 { return; }
    let path=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../logs/native_vertex_loaded_meshes.json");
    std::fs::write(path,serde_json::to_vec_pretty(&rows).unwrap()).expect("write native mesh diagnostic");
    println!("Native loaded mesh diagnostic: {} instances",rows.len());
    *written=true;
}
''';p.write_text(s)
p=r/'crates/client/src/main.rs';s=p.read_text().replace('map_fog::bind,','map_fog::bind,\n                map_fog::dump_probe,');p.write_text(s)
