//! Real restored map geometry for projected particles; no synthetic navigation plane.
use crate::{projected_surface::{SurfaceVertex, TerrainProjection}, native_environment_draw::Quality};
use bevy::{prelude::*, mesh::{PrimitiveTopology, VertexAttributeValues}, asset::RenderAssetUsages};
use std::collections::HashMap;

pub fn triangles(mesh: &Mesh, transform: &GlobalTransform) -> Result<Vec<[Vec3;3]>, String> {
    if mesh.primitive_topology()!=PrimitiveTopology::TriangleList {
        return Err("projected terrain requires triangle-list geometry".into());
    }
    let Some(VertexAttributeValues::Float32x3(positions))=mesh.attribute(Mesh::ATTRIBUTE_POSITION) else {
        return Err("projected terrain positions unavailable in CPU asset".into());
    };
    let matrix=transform.to_matrix();
    if !matrix.is_finite() { return Err("nonfinite map transform".into()); }
    let indices:Vec<usize>=mesh.indices().map(|i|i.iter().collect()).unwrap_or_else(||(0..positions.len()).collect());
    if indices.len()%3!=0 { return Err("incomplete terrain triangle indices".into()); }
    let mut result=Vec::with_capacity(indices.len()/3);
    for index in indices.chunks_exact(3) {
        let mut triangle=[Vec3::ZERO;3];
        for (i,&v) in index.iter().enumerate() {
            let local=positions.get(v).ok_or("terrain index outside vertex buffer")?;
            let world=matrix.transform_point3(Vec3::from_array(*local));
            if !world.is_finite() { return Err("nonfinite terrain position".into()); }
            triangle[i]=world;
        }
        // Preserve the indexed winding under the actual world transform; no implicit reflection.
        if (triangle[1]-triangle[0]).cross(triangle[2]-triangle[0]).length_squared()>1e-12 {
            result.push(triangle);
        }
    }
    Ok(result)
}
struct Surface {
    mesh: AssetId<Mesh>,
    transform: Mat4,
    triangles: Vec<[Vec3;3]>,
    native_index:usize,
}
#[derive(Resource)]
pub struct TerrainSurfaces {
    sources:HashMap<Entity,Surface>,
    by_native:HashMap<usize,Vec<Entity>>,
    reported:bool,
    revision:u64,
    receivers:openleague_core::native_projected_receivers::Receivers,
    quality:i32,
}
impl Default for TerrainSurfaces {
    fn default()->Self { Self { sources:HashMap::new(),by_native:HashMap::new(),reported:false,revision:0,
        receivers:serde_json::from_str(include_str!("../../../data/4.20/map10_receiver_tree.json")).expect("verified Map10 receiver tree"),quality:Quality::default().value } }
}
fn native_index(name:&str)->Option<usize> {
    name.strip_prefix("MapGeo_Instance_")?.split('.').next()?.parse().ok()
}
impl TerrainSurfaces {
    pub fn triangle_count(&self)->usize { self.sources.values().map(|s|s.triangles.len()).sum() }
    pub fn geometry_key(&self,projection:TerrainProjection)->(u64,Vec<Entity>) {
        let b=projection.native_bounds_xz;
        let selected=self.receivers.select(b.to_array(),self.quality)
            .expect("valid projection and verified receiver tree");
        (self.revision,selected.into_iter().flat_map(|index|self.by_native.get(&index).into_iter().flatten().copied()).collect())
    }
    pub fn projected_triangles(&self, projection:TerrainProjection)->Vec<[SurfaceVertex;3]> {
        self.geometry_key(projection).1.into_iter().filter_map(|entity|self.sources.get(&entity))
            // Native95B670 selects whole objects;95AFC0 submits their full
            // geometry ranges. UVs outside0..1 reach the clamped sampler.
            .flat_map(|s|s.triangles.iter())
            .map(|triangle|triangle.map(|world|SurfaceVertex {world,uv:projection.uv(world),height_factor:projection.height_factor(world)})).collect()
    }
    pub fn projected_mesh(&self,projection:TerrainProjection)->Option<Mesh> {
        let triangles=self.projected_triangles(projection);
        if triangles.is_empty() { return None; }
        let mut positions=Vec::new();let mut normals=Vec::new();let mut uvs=Vec::new();let mut colors=Vec::new();
        for triangle in triangles {
            let normal=(triangle[1].world-triangle[0].world).cross(triangle[2].world-triangle[0].world).normalize();
            for v in triangle { positions.push(v.world.to_array());normals.push(normal.to_array());uvs.push(v.uv.to_array());colors.push([1.,1.,1.,v.height_factor]); }
        }
        let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
        mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,positions);
        mesh.insert_attribute(Mesh::ATTRIBUTE_NORMAL,normals);
        mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,uvs);
        mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,colors);
        Some(mesh)
    }
}
pub fn collect(
    mut surfaces:ResMut<TerrainSurfaces>,
    meshes:Res<Assets<Mesh>>,
    query:Query<(Entity,&Mesh3d,&GlobalTransform,&bevy::gltf::GltfMeshName)>,
    quality:Res<Quality>,
    mut events:MessageReader<AssetEvent<Mesh>>,
) {
    let changed:Vec<_>=events.read().filter_map(|event| match event {
        AssetEvent::Modified {id}|AssetEvent::Removed {id}=>Some(*id),_=>None
    }).collect();
    surfaces.quality=quality.value;
    let previous_count=surfaces.sources.len();
    surfaces.sources.retain(|entity,_|query.get(*entity).is_ok());
    if previous_count!=surfaces.sources.len(){surfaces.revision=surfaces.revision.wrapping_add(1);}
    for (entity,handle,transform,name) in &query {
        let Some(native_index)=native_index(&name.0).filter(|&i|i<surfaces.receivers.objects.len()) else {continue;};
        let current=transform.to_matrix();
        if surfaces.sources.get(&entity).is_some_and(|s|s.mesh==handle.id() && s.transform==current && !changed.contains(&s.mesh)) { continue; }
        surfaces.revision=surfaces.revision.wrapping_add(1);
        // Never retain stale positions after a mesh or transform changes.
        surfaces.sources.remove(&entity);
        let Some(mesh)=meshes.get(&handle.0) else {continue;};
        match triangles(mesh,transform) {
            Ok(triangles)=>{surfaces.sources.insert(entity,Surface {mesh:handle.id(),transform:current,triangles,native_index});}
            Err(error)=>warn!("Projected terrain unavailable for {entity:?}: {error}"),
        }
    }
    // Build once per collection, rather than scan all map objects for every selected object.
    let mut by_native:HashMap<usize,Vec<Entity>>=HashMap::new();
    for (&entity,surface) in &surfaces.sources {by_native.entry(surface.native_index).or_default().push(entity);}
    for entities in by_native.values_mut(){entities.sort_by_key(|e|e.to_bits());}
    surfaces.by_native=by_native;
    if !surfaces.sources.is_empty() && !surfaces.reported {
        info!("Projected terrain geometry ready: {} restored meshes, {} triangles; native receiver selection active; clipping fidelity pending",surfaces.sources.len(),surfaces.triangle_count());
        surfaces.reported=true;
    }
}
pub fn probe(surfaces:Res<TerrainSurfaces>,state:Res<crate::Match>,mut frames:Local<u32>) {
    let Some(path)=std::env::var_os("OPENLEAGUE_PROJECTED_TERRAIN_PROBE").map(std::path::PathBuf::from) else {return;};
    if path.parent()!=Some(std::path::Path::new("E:/OpenLeague/logs")) || *frames>=60 || surfaces.sources.is_empty() {return;}
    let Some(snapshot)=state.snapshot.as_ref() else {return;};
    let Some(actor)=snapshot.players.iter().find(|p|p.champion.eq_ignore_ascii_case("annie")) else {return;};
    *frames+=1;
    if *frames<60 {return;}
    // Explicit diagnostic dimensions; native emitter scale/orientation binding is still pending.
    let center=Vec2::new(actor.position.x,actor.position.z);
    let projection=TerrainProjection::new(center,Vec2::splat(500.),0.).unwrap();
    let patch=surfaces.projected_triangles(projection);
    let ys:Vec<_>=patch.iter().flatten().map(|v|v.world.y).collect();
    let record=serde_json::json!({"complete":false,"diagnostic_only":true,"runtime_particle_rendered":false,"frames_after_geometry_available":*frames,"restored_terrain_meshes":surfaces.sources.len(),"source_triangles":surfaces.triangle_count(),"native_center_xz":[center.x,center.y],"diagnostic_half_size":500,"diagnostic_angle_degrees":0,"clipped_triangles":patch.len(),"world_y_min":ys.iter().copied().reduce(f32::min),"world_y_max":ys.iter().copied().reduce(f32::max),"limits":["Actual restored GLB mesh positions and GlobalTransforms measured in live client, not a synthetic flat surface.","Patch size/orientation supplied explicitly for diagnostic only; native emitter binding/FOW/depth/sampler/lifetime and actual GPU projected consumer still incomplete."]});
    if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&record).unwrap()) {warn!("Projected terrain probe: {error}");}
}

#[cfg(test)]
mod tests {
    use super::*;
    use bevy::mesh::Indices;
    #[test]
    fn direct_projection_selects_original_receiver_ids_for_all_195_native_rectangles() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_receiver_tree_contract.json")).unwrap();
        let mut surfaces=TerrainSurfaces::default();let mut world=World::new();
        let entities:Vec<Entity>=(0..surfaces.receivers.objects.len()).map(|_|world.spawn_empty().id()).collect();
        surfaces.by_native=entities.iter().enumerate().map(|(i,&e)|(i,vec![e])).collect();
        assert_eq!(proof["cases"].as_array().unwrap().len(),195);
        for case in proof["cases"].as_array().unwrap() {
            surfaces.quality=case["threshold"].as_i64().unwrap() as i32;
            let p=TerrainProjection {world_to_uv:Mat4::IDENTITY,native_bounds_xz:Vec4::from_array(std::array::from_fn(|i|case["rectangle"][i].as_f64().unwrap() as f32)),native_height:None};
            let expected:Vec<Entity>=case["queued_meshes"].as_array().unwrap().iter().map(|i|entities[i.as_u64().unwrap() as usize]).collect();
            assert_eq!(surfaces.geometry_key(p).1,expected,"native receiver case {case}");
        }
    }
    fn mesh()->Mesh {
        let mut m=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
        m.insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,0.,0.],[100.,30.,0.],[0.,50.,100.]]);
        m.insert_indices(Indices::U16(vec![0,1,2]));m
    }
    #[test]
    fn indexed_restored_geometry_uses_direct_map_root_and_preserves_indexed_winding() {
        let transform=GlobalTransform::from(crate::map_coordinates::map_root_transform());
        let t=triangles(&mesh(),&transform).unwrap()[0];
        assert_eq!(t[1]-t[0],Vec3::new(5.,1.5,0.));
        assert_eq!(t[2]-t[0],Vec3::new(0.,2.5,5.));
        assert!((t[1]-t[0]).cross(t[2]-t[0]).y<0.);
    }
    #[test]
    fn invalid_and_cpu_unavailable_geometry_return_explicit_errors() {
        let mut m=mesh();m.insert_indices(Indices::U32(vec![0,1,99]));
        assert!(triangles(&m,&GlobalTransform::IDENTITY).is_err());
        m.insert_indices(Indices::U32(vec![0,1]));
        assert!(triangles(&m,&GlobalTransform::IDENTITY).is_err());
        m.remove_attribute(Mesh::ATTRIBUTE_POSITION);
        assert!(triangles(&m,&GlobalTransform::IDENTITY).is_err());
    }
    #[test]
    fn actual_surface_patch_preserves_sloped_vertices_and_has_no_origin_fallback() {
        let mut cache=TerrainSurfaces::default();
        cache.receivers=serde_json::from_value(serde_json::json!({"nodes":[{"bounds":[-100000.,-100000.,-100000.,100000.,100000.,100000.],"first_object":0,"object_count":1,"first_child":0,"child_count":0}],"objects":[{"material_kind":0,"quality":-100}]})).unwrap();
        let triangles=triangles(&mesh(),&GlobalTransform::IDENTITY).unwrap();
        cache.sources.insert(Entity::PLACEHOLDER,Surface {mesh:Handle::<Mesh>::default().id(),transform:Mat4::IDENTITY,triangles,native_index:0});
        cache.by_native.insert(0,vec![Entity::PLACEHOLDER]);
        let p=TerrainProjection::new(Vec2::new(500.,500.),Vec2::splat(100.),45.).unwrap();
        let moved=TerrainProjection::new(Vec2::new(510.,505.),Vec2::splat(100.),20.).unwrap().with_native_height(20.,5.,200.).unwrap();
        assert_eq!(cache.geometry_key(p),cache.geometry_key(moved),"uniform-only changes reuse identical selected geometry");
        let patch=cache.projected_mesh(p).unwrap();
        let Some(VertexAttributeValues::Float32x3(positions))=patch.attribute(Mesh::ATTRIBUTE_POSITION) else {panic!("missing positions")};
        for v in positions { assert!((v[1]-(0.3*v[0]+0.5*v[2])).abs()<0.0001); }
        assert_eq!(positions.len(),3,"native selected object retains its whole triangle");
        let Some(VertexAttributeValues::Float32x2(uvs))=patch.attribute(Mesh::ATTRIBUTE_UV_0) else {panic!("missing UVs")};
        assert!(uvs.iter().any(|uv|uv.iter().any(|v|*v<0. || *v>1.)),"out-of-footprint UVs must reach sampler");
        let outside=TerrainProjection::new(Vec2::splat(200000.),Vec2::splat(100.),0.).unwrap();
        assert!(cache.projected_mesh(outside).is_none());
    }
    #[test]
    fn active_quality_changes_projection_without_reloading_meshes() {
        let mut app=App::new();
        app.init_resource::<Assets<Mesh>>().init_resource::<TerrainSurfaces>().init_resource::<Quality>()
            .add_message::<AssetEvent<Mesh>>().add_systems(Update,collect);
        app.world_mut().resource_mut::<TerrainSurfaces>().receivers=serde_json::from_value(serde_json::json!({
            "nodes":[{"bounds":[0.,-10.,0.,2000.,10.,2000.],"first_object":0,"object_count":1,"first_child":0,"child_count":0}],
            "objects":[{"material_kind":0,"quality":1}]})).unwrap();
        let handle=app.world_mut().resource_mut::<Assets<Mesh>>().add(mesh());
        app.world_mut().spawn((Mesh3d(handle),GlobalTransform::IDENTITY,bevy::gltf::GltfMeshName("MapGeo_Instance_0".into())));
        let projection=TerrainProjection::new(Vec2::new(500.,500.),Vec2::splat(600.),0.).unwrap();
        app.world_mut().resource_mut::<Quality>().apply(1);app.update();
        assert!(app.world().resource::<TerrainSurfaces>().projected_mesh(projection).is_none());
        app.world_mut().resource_mut::<Quality>().apply(2);app.update();
        assert!(app.world().resource::<TerrainSurfaces>().projected_mesh(projection).is_some());
        assert_eq!(app.world().resource::<TerrainSurfaces>().sources.len(),1);
        app.world_mut().resource_mut::<Quality>().apply(0);app.update();
        assert!(app.world().resource::<TerrainSurfaces>().projected_mesh(projection).is_none());
    }
    #[test]
    fn live_cache_refreshes_transforms_and_asset_replacements_then_removes_despawned_surfaces() {
        let mut app=App::new();
        app.init_resource::<Assets<Mesh>>().init_resource::<TerrainSurfaces>().init_resource::<Quality>()
            .add_message::<AssetEvent<Mesh>>().add_systems(Update,collect);
        let handle=app.world_mut().resource_mut::<Assets<Mesh>>().add(mesh());
        let entity=app.world_mut().spawn((Mesh3d(handle.clone()),GlobalTransform::IDENTITY,bevy::gltf::GltfMeshName("MapGeo_Instance_0".into()))).id();
        app.update();
        assert_eq!(app.world().resource::<TerrainSurfaces>().triangle_count(),1);
        let revision=app.world().resource::<TerrainSurfaces>().revision;
        app.update();assert_eq!(revision,app.world().resource::<TerrainSurfaces>().revision,"unchanged geometry must keep cache valid");
        app.world_mut().entity_mut(entity).insert(GlobalTransform::from(Transform::from_translation(Vec3::Y*10.)));
        app.update();
        assert_eq!(app.world().resource::<TerrainSurfaces>().sources[&entity].triangles[0][0].y,10.);
        assert_ne!(revision,app.world().resource::<TerrainSurfaces>().revision,"transform changes must invalidate cached projection mesh");
        app.world_mut().resource_mut::<Assets<Mesh>>().get_mut(&handle).unwrap().insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,5.,0.],[100.,35.,0.],[0.,55.,100.]]);
        app.world_mut().write_message(AssetEvent::Modified {id:handle.id()});
        app.update();
        assert_eq!(app.world().resource::<TerrainSurfaces>().sources[&entity].triangles[0][0].y,15.);
        app.world_mut().despawn(entity);app.update();
        assert_eq!(app.world().resource::<TerrainSurfaces>().triangle_count(),0);
    }
}
