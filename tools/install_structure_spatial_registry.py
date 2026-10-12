from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_model_bounds.rs';s=p.read_text(encoding='utf-8');assert 'pub fn structure_model' not in s
old='pub fn model(name:&str)->Result<Model,&\'static str>{base_model(name).or_else(|_|world_model(name))}'
new='''pub fn structure_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_structure_model_bounds.json")).expect("native structure model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified structure model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native structure model scale")? as f32;
    let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native structure model profile");}
    Ok(Model{local,skin_scale:scale})
}
pub fn model(name:&str)->Result<Model,&'static str>{base_model(name).or_else(|_|world_model(name)).or_else(|_|structure_model(name))}'''
assert old in s;s=s.replace(old,new)
s=s.replace(' use super::*;',''' use super::*;
 #[test] fn all_intact_structure_candidates_produce_equal_native_boxes_and_render_scales(){
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_structure_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),45);
    let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_grass_structure_model_bounds.json")).unwrap();assert_eq!(catalog.as_object().unwrap().len(),12);
    let scales:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_structure_model_scale_contract.json")).unwrap();assert_eq!(scales["passed"],true);assert_eq!(scales["cases"].as_array().unwrap().len(),15);
    let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/world_animation_manifest.json")).unwrap();
    for c in proof["cases"].as_array().unwrap(){
        let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
        assert_eq!(serde_json::json!(from_mesh(mesh,size).unwrap().map(f32::to_bits)),c["provider_bounds_bits"]);
        let name=c["name"].as_str().unwrap();if name.starts_with("fixture-"){continue;}let base=name.split("__candidate_").next().unwrap();
        let loaded=structure_model(base).unwrap();assert_eq!(serde_json::json!(loaded.local.map(f32::to_bits)),c["provider_bounds_bits"]);assert_eq!(loaded.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);
        let entry=manifest.as_object().unwrap().iter().find(|(n,_)|n.eq_ignore_ascii_case(base)).unwrap().1;assert_eq!((entry["scale"].as_f64().unwrap() as f32).to_bits(),loaded.skin_scale.to_bits());
        let native_scale=scales["cases"].as_array().unwrap().iter().find(|v|v["name"]==base).unwrap();assert_eq!(native_scale["result_bits"],c["skin_scale_bits"]);
    }
    assert!(structure_model("TT_OrderTurret1_destroyed").is_err());assert!(structure_model("altar_l").is_err());
 }
''',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_live_registry.rs';s=p.read_text(encoding='utf-8')
# Keep explicit unavailable-resource coverage while adding real structure coverage.
start=s.index(' #[test] fn loaded_world_models_follow_snapshot');prefix=s[:start];tail=s[start:]
tail=tail.replace('TT_OrderTurret1','missing-structure');s=prefix+tail
test='''
 #[test] fn loaded_intact_structures_register_and_retire_when_destroyed_variant_changes(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let mut snapshot=simulation.snapshot();snapshot.session=701;
    let template=snapshot.units[0].clone();snapshot.units.clear();
    let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_grass_structure_model_bounds.json")).unwrap();let mut names=BTreeMap::new();
    for (i,name) in catalog.as_object().unwrap().keys().enumerate(){let mut unit=template.clone();unit.id=70000+i as u32;unit.definition=name.clone();unit.kind=openleague_core::world::Kind::Turret;unit.health=100.;unit.position=openleague_core::Point{x:6000.+i as f32*600.,z:7000.};names.insert(unit.id,name.clone());snapshot.units.push(unit);}
    let mut live=Live::default();let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(observations.len(),12);assert!(unqualified.is_empty());live.synchronize(701,&observations).unwrap();
    for tracked in live.active.values(){let object=&live.registry.objects[tracked.index];assert!(object.indexed.node.parent_present);assert_eq!(live.tree.nodes[object.parent.unwrap()].members.iter().filter(|m|m.id==tracked.index as u64).count(),1);}
    let id=snapshot.units[0].id;let slot=live.active[&id].index;let original=names[&id].clone();snapshot.units[0].health=0.;let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(observations.len(),11);assert!(unqualified.is_empty());live.synchronize(701,&observations).unwrap();assert!(live.registry.recycled.contains(&slot));assert!(live.registry.objects[slot].parent.is_none());
    names.insert(id,format!("{original}_destroyed"));let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (_,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(unqualified[&id],format!("{original}_destroyed"));
    snapshot.units[0].health=100.;names.insert(id,original);let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(701,&observations).unwrap();assert_eq!(live.active.len(),12);assert_eq!(live.active[&id].index,slot);
 }
'''
assert s.endswith('}\n');s=s[:-2]+test+'}\n';p.write_text(s,encoding='utf-8');print('Intact structure models integrated; destroyed variants remain explicit unqualified resources')
