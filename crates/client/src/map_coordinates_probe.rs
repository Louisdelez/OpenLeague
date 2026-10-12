//! Opt-in read-only ECS observations. No transforms, visibility, camera or gameplay writes.
use bevy::{prelude::*,gltf::GltfMeshName,mesh::VertexAttributeValues};
use serde_json::{json,Value};
use std::{collections::{HashSet,VecDeque},path::{Path,PathBuf}};
use bevy::world_serialization::WorldAssetRoot;
#[path="map_deep_fog_probe.rs"] mod deep_fog;
const FLOOR_IDS:[usize;8]=[534,555,567,582,938,973,989,1028];
const CAPACITY:usize=64;
#[derive(Default)]
pub struct State {previous:Option<f64>,serial:u64,frames:VecDeque<Value>,failed:bool}
fn path(value:&std::ffi::OsStr)->Option<PathBuf> {
    let p=PathBuf::from(value);
    (p.is_absolute() && p.parent()==Some(Path::new("E:/OpenLeague/logs")) && p.extension().is_some_and(|x|x=="json")).then_some(p)
}
fn floor_id(name:&str)->Option<usize> {
    name.strip_prefix("MapGeo_Instance_")?.split('.').next()?.parse::<usize>().ok().filter(|id|FLOOR_IDS.contains(id))
}
fn local_bounds(mesh:&Mesh)->Option<(Vec3,Vec3)> {
    let VertexAttributeValues::Float32x3(points)=mesh.attribute(Mesh::ATTRIBUTE_POSITION)? else {return None;};
    if points.is_empty() {return None;}
    let(mut lo,mut hi)=(Vec3::splat(f32::INFINITY),Vec3::splat(f32::NEG_INFINITY));
    for p in points {let p=Vec3::from_array(*p);if !p.is_finite(){return None;}lo=lo.min(p);hi=hi.max(p);}
    Some((lo,hi))
}
fn ancestry(start:Entity,parents:&Query<&ChildOf>,roots:&HashSet<Entity>)->Value {
    let mut current=start;let mut seen=HashSet::new();let mut chain=Vec::new();
    for _ in 0..64 {
        if !seen.insert(current) {return json!({"entities":chain,"map_root":null,"error":"cycle"});}
        chain.push(format!("{current:?}"));
        if roots.contains(&current) {return json!({"entities":chain,"map_root":format!("{current:?}"),"error":null});}
        let Ok(parent)=parents.get(current) else {return json!({"entities":chain,"map_root":null,"error":"no MapRoot ancestor"});};
        current=parent.parent();
    }
    json!({"entities":chain,"map_root":null,"error":"ancestor depth limit"})
}
impl State {
    fn push(&mut self,frame:Value) {
        if self.frames.len()==CAPACITY {self.frames.pop_front();}
        self.frames.push_back(frame);
    }
}
pub fn observe(
    time:Res<Time>,state:Res<crate::Match>,clock:Option<Res<crate::native_effect_clock::EffectClock>>,
    roots:Query<(Entity,&GlobalTransform,Option<&WorldAssetRoot>),With<crate::map_coordinates::MapRoot>>,
    names:Query<(Entity,&Name,&GlobalTransform,Option<&InheritedVisibility>,Option<&WorldAssetRoot>)>,
    globals:Query<&GlobalTransform>,
    floors:Query<(Entity,&Mesh3d,&GltfMeshName,&GlobalTransform,Option<&InheritedVisibility>,Option<&MeshMaterial3d<crate::map_fog::FogMaterial>>,Option<&MeshMaterial3d<crate::terrain_material::TerrainMaterial>>,Option<&ViewVisibility>,Option<&MeshMaterial3d<StandardMaterial>>,Option<&crate::map_fog::NativeFogBound>)>,
    cameras:Query<(Entity,&Camera,&GlobalTransform),With<Camera3d>>,
    material_assets:(Res<Assets<Mesh>>,Res<Assets<crate::map_fog::FogMaterial>>,Res<Assets<crate::terrain_material::TerrainMaterial>>,Res<Assets<Image>>,Res<Assets<StandardMaterial>>),
    depths:Query<(Entity,&crate::selector7_depth::DepthPhase,&ChildOf,&Mesh3d,&MeshMaterial3d<crate::map_fog::FogMaterial>,Option<&GlobalTransform>,Option<&InheritedVisibility>,Option<&ViewVisibility>)>,
    assets:Res<AssetServer>,parents:Query<&ChildOf>,native_camera:Option<Res<crate::camera_native::NativeCamera>>,
    mut probe:Local<State>,
    nexus:(Option<Res<crate::nexus_idle_particles::Host>>,Option<Res<crate::nexus_complex_live::Diagnostics>>,Res<Assets<crate::nexus_complex_material::NexusMaterial>>,Option<Res<crate::nexus_crown_live::Diagnostics>>,Option<Res<crate::nexus_crown_state::State>>,Option<Res<crate::nexus_glow_live::Diagnostics>>,Option<Res<crate::nexus_glow_state::State>>,Res<Assets<crate::nexus_glow_material::GlowMaterial>>,Option<Res<crate::nexus_glow_simple::State>>),
    nexus_draws:(Query<(Entity,&crate::nexus_complex_host::OwnedDraw,&Mesh3d,&MeshMaterial3d<crate::nexus_complex_material::NexusMaterial>,&GlobalTransform,Option<&InheritedVisibility>,Option<&ViewVisibility>)>,
        Query<(Entity,&crate::nexus_crown_live::OwnedDraw,&Mesh3d,&MeshMaterial3d<crate::nexus_complex_material::NexusMaterial>,Option<&InheritedVisibility>,Option<&ViewVisibility>)>,
        Query<(Entity,&crate::nexus_glow_live::OwnedDraw,&Mesh3d,&MeshMaterial3d<crate::nexus_glow_material::GlowMaterial>,Option<&InheritedVisibility>,Option<&ViewVisibility>)>),
) {
    let Some(value)=std::env::var_os("OPENLEAGUE_MAP_COORDINATES_PROBE") else {return;};
    if probe.failed{return;}
    let Some(path)=path(&value) else {warn!("Map coordinates probe requires an absolute JSON path directly in project logs");probe.failed=true;return;};
    let now=time.elapsed_secs_f64();
    if probe.previous.is_some_and(|old|now-old<0.5){return;}
    let Some(snapshot)=state.snapshot.as_ref() else {return;};
    probe.previous=Some(now);probe.serial=probe.serial.saturating_add(1);
    let (meshes,fog,terrain,images,standard)=material_assets;
    let root_ids:HashSet<_>=roots.iter().take(4).map(|(e,_,_)|e).collect();
    let root_count=roots.iter().count();
    let root_rows:Vec<_>=roots.iter().take(4).map(|(e,t,scene)|json!({"entity":format!("{e:?}"),"world_matrix":t.to_matrix().to_cols_array(),"scene_handle":scene.map(|s|format!("{:?}",s.0.id())),"scene_asset":scene.and_then(|s|assets.get_path(s.0.id()).map(|p|p.to_string()))})).collect();
    let mut floor_rows=Vec::new();
    for(e,h,name,t,visible,environment,ground,_,_,_) in &floors {
        let Some(id)=floor_id(&name.0) else {continue;};
        if floor_rows.len()>=32 {break;}
        let bounds=meshes.get(&h.0).and_then(local_bounds).map(|(lo,hi)|json!({"min":lo.to_array(),"max":hi.to_array(),"world_center":t.transform_point((lo+hi)*0.5).to_array()}));
        let uniform=environment.and_then(|h|fog.get(&h.0)).map(|m|m.extension.opaque)
            .or_else(||ground.and_then(|h|terrain.get(&h.0)).map(|m|m.coordinate_uniform()));
        floor_rows.push(json!({"id":id,"entity":format!("{e:?}"),"mesh":format!("{:?}",h.id()),"mesh_asset":assets.get_path(h.id()).map(|p|p.to_string()),"ancestry":ancestry(e,&parents,&root_ids),"world_matrix":t.to_matrix().to_cols_array(),"bounds":bounds,"inherited_visible":visible.map(|v|v.get()),"coordinate_uniform":uniform.map(|v|v.to_array())}));
    }
    let mut deep_rows=Vec::new();
    let mut deep_counts=std::collections::BTreeMap::<usize,usize>::new();
    for(e,h,name,t,visible,environment,ground,view,base,bound) in &floors {
        let Some(id)=deep_fog::target(&name.0) else {continue;};
        *deep_counts.entry(id).or_default()+=1;
        if deep_rows.len()>=32 {continue;}
        let mut materials=Vec::new();
        if let Some(handle)=environment {
            let material=fog.get(&handle.0);
            materials.push(json!({"kind":"FogMaterial","binding":deep_fog::binding(&handle.0,&assets,material.is_some()),"values":material.map(|m|deep_fog::fog(m,&assets,&images))}));
        }
        if let Some(handle)=ground {
            let material=terrain.get(&handle.0);
            materials.push(json!({"kind":"TerrainMaterial","binding":deep_fog::binding(&handle.0,&assets,material.is_some()),"values":material.map(|m|deep_fog::terrain(m,&assets,&images))}));
        }
        if let Some(handle)=base {
            let material=standard.get(&handle.0);
            materials.push(json!({"kind":"StandardMaterial","binding":deep_fog::binding(&handle.0,&assets,material.is_some()),"values":material.map(|m|deep_fog::standard(m,&assets,&images))}));
        }
        let depth_count=depths.iter().filter(|(_,_,parent,_,_,_,_,_)|parent.parent()==e).count();
        let depth_rows:Vec<_>=depths.iter().filter(|(_,_,parent,_,_,_,_,_)|parent.parent()==e).take(8)
            .map(|(entity,phase,parent,mesh,handle,global,inherited,view)|{
                let material=fog.get(&handle.0);
                json!({"entity":format!("{entity:?}"),"parent":format!("{:?}",parent.parent()),
                    "source":deep_fog::binding(&phase.source,&assets,fog.get(&phase.source).is_some()),
                    "binding":deep_fog::binding(&handle.0,&assets,material.is_some()),
                    "values":material.map(|m|deep_fog::fog(m,&assets,&images)),
                    "mesh":format!("{:?}",mesh.id()),"mesh_asset":assets.get_path(mesh.id()).map(|p|p.to_string()),
                    "world_matrix":global.map(|t|t.to_matrix().to_cols_array()),"inherited_visible":inherited.map(|v|v.get()),"view_visible_any_camera":view.map(|v|v.get())})
            }).collect();
        deep_rows.push(json!({"id":id,"role":deep_fog::role(id),"entity":format!("{e:?}"),"name":name.0,
            "mesh":format!("{:?}",h.id()),"mesh_asset":assets.get_path(h.id()).map(|p|p.to_string()),
            "mesh_cpu_asset_present":meshes.get(&h.0).is_some(),"ancestry":ancestry(e,&parents,&root_ids),
            "world_matrix":t.to_matrix().to_cols_array(),"inherited_visible":visible.map(|v|v.get()),
            "view_visible_any_camera":view.map(|v|v.get()),"materials":materials,
            "native_fog_source":bound.map(|b|deep_fog::binding(&b.source,&assets,standard.get(&b.source).is_some())),
            "selector7_depth_count":depth_count,"selector7_depth_rows":depth_rows,"selector7_rows_truncated":depth_count>8}));
    }
    let deep_counts:Vec<_>=deep_fog::TARGETS.iter().map(|id|json!({"id":id,"count":deep_counts.get(id).copied().unwrap_or(0)})).collect();
    let deep_fog=json!({"scope":"CPU bindings only","gpu_readiness":null,"pixels_qualified":false,
        "target_counts":deep_counts,"rows":deep_rows,"rows_truncated":deep_counts.iter().filter_map(|x|x["count"].as_u64()).sum::<u64>()>32});
    let ambient:Vec<_>=names.iter().filter(|(_,n,_,_,_)|n.as_str().starts_with("OpenLeagueAmbient::")).take(32)
        .map(|(e,n,t,v,scene)|json!({"entity":format!("{e:?}"),"name":n.as_str(),"world_matrix":t.to_matrix().to_cols_array(),"inherited_visible":v.map(|v|v.get()),"scene_asset":scene.and_then(|s|assets.get_path(s.0.id()).map(|p|p.to_string()))})).collect();
    let mut actors=Vec::new();
    let mut record=|id:u32,label:&str,native:[f32;3]| {
        if actors.len()>=32 {return;}
        let entity=state.visuals.get(&id).copied();
        let transform=entity.and_then(|e|globals.get(e).ok());
        actors.push(json!({"id":id,"label":label,"native_position":native,"entity":entity.map(|e|format!("{e:?}")),"world_matrix":transform.map(|t|t.to_matrix().to_cols_array())}));
    };
    for p in &snapshot.players {record(p.id,&p.champion,[p.position.x,p.height,p.position.z]);}
    for u in &snapshot.units {
        if u.definition=="TT_Spiderboss" || u.definition.to_ascii_lowercase().contains("nexus") || u.definition.starts_with("HQ_") {
            record(u.id,&u.definition,[u.position.x,u.height,u.position.z]);
        }
    }
    if let Some(map)=&snapshot.map10 {for a in &map.altars {record(a.id,&a.name,[a.position.x,a.height,a.position.z]);}}
    let cameras:Vec<_>=cameras.iter().take(4).map(|(e,c,t)|json!({"entity":format!("{e:?}"),"world_matrix":t.to_matrix().to_cols_array(),"clip_from_view":c.clip_from_view().to_cols_array(),"viewport":c.physical_viewport_rect().map(|r|[r.min.x,r.min.y,r.max.x,r.max.y]),"active":c.is_active,"invert_culling":c.invert_culling})).collect();
    let native_camera=native_camera.as_ref().map(|c|json!({"focus":c.native_focus(),"parameters":c.native_parameters().map(|p|json!({"position":p.position,"direction":p.direction,"up":p.up,"fov_degrees":p.fov_degrees,"near":p.near,"far":p.far,"projection_raw":p.projection_raw}))}));
    let floor_counts:Vec<_>=FLOOR_IDS.iter().map(|id|json!({"id":id,"count":floor_rows.iter().filter(|r|r["id"].as_u64()==Some(*id as u64)).count()})).collect();
    let unix_ms=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).ok().and_then(|d|u64::try_from(d.as_millis()).ok());
    let (idle,diagnostics,nexus_materials,crown_diagnostics,crown_state,glow_diagnostics,glow_state,glow_materials,simple_glow)=nexus;
    let (nexus_draws,crown_draws,glow_draws)=nexus_draws;
    let crown_count=crown_draws.iter().count();
    let crown_rows=crown_draws.iter().take(crate::nexus_crown_state::DRAW_CAPACITY).map(|(entity,owned,mesh,material,inherited,view)| {
        let t=&owned.0;
        json!({"entity":format!("{entity:?}"),"session":t.particle.session,"source":t.particle.source,
            "cycle":t.particle.cycle,"slot":t.particle.slot,"birth":t.particle.birth,"ordinal":t.ordinal,
            "attachment_generation":t.owner.attachment_generation,"effect_id":t.owner.effect_id,
            "mesh":format!("{:?}",mesh.id()),"material":format!("{:?}",material.id()),
            "cpu_mesh_present":meshes.get(&mesh.0).is_some(),"cpu_admitted":nexus_materials.get(&material.0).map(|m|m.is_ready()),
            "images":t.images.map(|i|format!("{i:?}")),"inherited_visible":inherited.map(|v|v.get()),
            "view_visible_any_camera":view.map(|v|v.get())})
    }).collect::<Vec<_>>();
    let crown=json!({"scope":"CPU particle identity and draw ownership only","gpu_readiness":null,"pixels_qualified":false,
        "diagnostics":crown_diagnostics.as_ref().map(|d|json!({"error":d.error,"ordinal":d.ordinal,"emitters":d.emitters,
            "particles":d.particles,"draws":d.draws,"missing_pose_frames":d.missing_pose_frames,
            "local_reconstruction":d.local_reconstruction,"native_complete":d.native_complete,"gpu_draw_qualified":d.gpu_draw_qualified})),
        "emitters":crown_state.as_ref().map(|s|s.slots.iter().take(8).map(|slot|json!({"source":slot.key.source,"slot":slot.key.slot,
            "cycle":slot.cycle.serial,"phase":format!("{:?}",slot.phase),"age":slot.age,"seen":slot.seen,"emitted":slot.emitter.emitted,
            "particles":slot.particles.iter().take(crate::nexus_crown_state::PARTICLE_CAPACITY).map(|p|json!({"birth":p.id.birth,"birth_time":p.birth.schedule.time,
                "age":slot.age-p.birth.schedule.time,"life":p.birth.life})).collect::<Vec<_>>()})).collect::<Vec<_>>()),
        "draw_count":crown_count,"draws":crown_rows,"draws_truncated":crown_count>crate::nexus_crown_state::DRAW_CAPACITY});
    let glow_count=glow_draws.iter().count();
    let glow_rows=glow_draws.iter().take(crate::nexus_glow_simple::DRAW_CAPACITY).map(|(entity,owned,mesh,material,inherited,view)| {
        let t=&owned.0;
        json!({"entity":format!("{entity:?}"),"session":t.particle.session,"source":t.particle.source,
            "cycle":t.particle.cycle,"slot":t.particle.slot,"birth":t.particle.birth,"ordinal":t.ordinal,
            "attachment_generation":t.owner.attachment_generation,"effect_id":t.owner.effect_id,
            "mesh":format!("{:?}",mesh.id()),"material":format!("{:?}",material.id()),
            "cpu_mesh_present":meshes.get(&mesh.0).is_some(),"cpu_admitted":glow_materials.get(&material.0).map(|m|m.is_admitted()),
            "images":t.images.map(|i|format!("{i:?}")),"inherited_visible":inherited.map(|v|v.get()),
            "view_visible_any_camera":view.map(|v|v.get())})
    }).collect::<Vec<_>>();
    let glow=json!({"scope":"Startup Complex and On Simple glow CPU identity/draw ownership only","on_simple_supported":true,
        "gpu_readiness":null,"pixels_qualified":false,
        "diagnostics":glow_diagnostics.as_ref().map(|d|json!({"error":d.error,"ordinal":d.ordinal,"emitters":d.emitters,
            "particles":d.particles,"draws":d.draws,"missing_pose_frames":d.missing_pose_frames,
            "local_reconstruction":d.local_reconstruction,"native_complete":d.native_complete,"gpu_draw_qualified":d.gpu_draw_qualified})),
        "emitters":glow_state.as_ref().map(|s|s.slots.iter().take(12).map(|slot|json!({"source":slot.key.source,"slot":slot.key.slot,
            "cycle":slot.cycle.serial,"age":slot.age,"seen":slot.seen,"emitted":slot.emitted,
            "particles":slot.particles.iter().take(4).map(|p|json!({"birth":p.id.birth,"birth_time":p.birth.time,
                "age":slot.age-p.birth.time,"life":p.birth.life})).collect::<Vec<_>>()})).collect::<Vec<_>>()),
        "simple_emitters":simple_glow.as_ref().map(|s|s.slots.iter().take(12).map(|slot|json!({"source":slot.key.source,"slot":slot.key.slot,
            "cycle":slot.cycle.serial,"age":slot.age,"seen":slot.seen,"emitted":slot.emitted,"allocated_slots":slot.birth.len(),
            "particles":slot.live_indices().take(crate::nexus_glow_simple::SLOT_CAPACITY).map(|i|json!({"birth":slot.identities[i],
                "birth_time":f32::from_bits(slot.birth[i]),"normalized_age":f32::from_bits(slot.storage.ages[i]),
                "position":slot.storage.positions[i].map(f32::from_bits),"lookup":([slot.storage.attribute_a[i],slot.storage.attribute_b[i]].map(f32::from_bits))})).collect::<Vec<_>>()})).collect::<Vec<_>>()),
        "draw_count":glow_count,"draws":glow_rows,"draws_truncated":glow_count>crate::nexus_glow_simple::DRAW_CAPACITY});
    let idle=idle.as_ref().map(|host|json!({"ordinal":host.frame.ordinal,"session":host.frame.session,"error":host.frame.error,
        "issues":host.issues,"request_count":host.frame.requests.len(),"requests_truncated":host.frame.requests.len()>22,"requests":host.frame.requests.iter().take(22).map(|r|json!({
            "source":r.cycle.source,"cycle":r.cycle.serial,"slot":r.descriptor.slot,"resource":r.descriptor.resource,"bone":r.descriptor.bone,"bone_entity":format!("{:?}",r.bone),
            "actor":format!("{:?}",r.owner.actor),"session":r.owner.session,"attachment_generation":r.owner.attachment_generation,
            "effect_id":r.owner.effect_id,"started_at":r.started_at,"age_seconds":r.age_seconds,
            "attachment_world":r.attachment_world.to_cols_array()})).collect::<Vec<_>>()}));
    let diagnostics=diagnostics.as_ref().map(|d|json!({"error":d.error,"issues":d.issues,"draws":d.draws,"ages":d.ages,
        "local_reconstruction":d.local_reconstruction,"gpu_draw_qualified":d.gpu_draw_qualified}));
    let draw_count=nexus_draws.iter().count();
    let draws=nexus_draws.iter().take(8).map(|(e,owned,mesh,material,t,inherited,view)|{
        let cpu_mesh=meshes.get(&mesh.0);let cpu_material=nexus_materials.get(&material.0);
        json!({"entity":format!("{e:?}"),"group":owned.0.group.authored_name(),"ordinal":owned.0.ordinal,
            "effect_id":owned.0.owner.effect_id,"mesh":format!("{:?}",mesh.id()),"material":format!("{:?}",material.id()),
            "cpu_mesh_present":cpu_mesh.is_some(),"cpu_material_present":cpu_material.is_some(),
            "cpu_admitted":cpu_material.map(|m|m.is_ready()),"world_matrix":t.to_matrix().to_cols_array(),
            "bounds":cpu_mesh.and_then(local_bounds).map(|(lo,hi)|json!({"min":lo.to_array(),"max":hi.to_array()})),
            "inherited_visible":inherited.map(|v|v.get()),"view_visible_any_camera":view.map(|v|v.get())})
    }).collect::<Vec<_>>();
    let nexus=json!({"scope":"CPU ownership and bindings only","gpu_readiness":null,"pixels_qualified":false,
        "idle":idle,"diagnostics":diagnostics,"draw_count":draw_count,"draws":draws,"draws_truncated":draw_count>8});
    let serial=probe.serial;
    probe.push(json!({"pid":std::process::id(),"serial":serial,"unix_ms":unix_ms,"time":now,"effect_time":clock.as_ref().map(|c|c.now),"session":snapshot.session,"tick":snapshot.tick,"map_root_count":root_count,"map_roots":root_rows,"floor_counts":floor_counts,"floors":floor_rows,"ambient":ambient,"actors":actors,"cameras":cameras,"native_camera":native_camera,"deep_fog":deep_fog,"nexus":nexus,"crown":crown,"crystal_glow":glow}));
    let report=json!({"schema":"map_coordinates_v1","capacity":CAPACITY,"read_only":true,"complete":false,"pixels_qualified":false,"frames":probe.frames});
    if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&report).expect("finite map diagnostic values")) {
        warn!("Map coordinates probe write failed: {error}");probe.failed=true;
    }
}
#[cfg(test)]mod tests {
    use super::*;
    #[test]fn diagnostic_ring_is_bounded_and_never_promotes_a_missing_mesh() {
        let mut state=State::default();for i in 0..70 {state.push(json!({"serial":i}));}
        assert_eq!(state.frames.len(),64);assert_eq!(state.frames.front().unwrap()["serial"],6);
        let mesh=Mesh::new(bevy::mesh::PrimitiveTopology::TriangleList,bevy::asset::RenderAssetUsages::default());
        assert!(local_bounds(&mesh).is_none());assert_eq!(floor_id("MapGeo_Instance_534.0"),Some(534));assert_eq!(floor_id("MapGeo_Instance_1"),None);
        let mut world=World::new();let root=world.spawn_empty().id();let child=world.spawn(ChildOf(root)).id();let outside=world.spawn_empty().id();
        let mut state=bevy::ecs::system::SystemState::<Query<&ChildOf>>::new(&mut world);let parents=state.get(&world).expect("read-only parent query");
        let roots=HashSet::from([root]);
        assert_eq!(ancestry(child,&parents,&roots)["map_root"],format!("{root:?}"));
        assert!(ancestry(outside,&parents,&roots)["map_root"].is_null());
        assert_eq!(ancestry(outside,&parents,&roots)["error"],"no MapRoot ancestor");
    }
    #[test]fn diagnostic_path_is_opt_in_and_confined_to_direct_logs_child() {
        assert!(path(std::ffi::OsStr::new("E:/OpenLeague/logs/map-coordinates.json")).is_some());
        for p in ["map.json","E:/OpenLeague/map.json","E:/OpenLeague/logs/sub/map.json","E:/OpenLeague/logs/../map.json"] {assert!(path(std::ffi::OsStr::new(p)).is_none());}
    }
}
