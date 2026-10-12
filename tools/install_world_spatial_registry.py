from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/grass_model_bounds.rs';s=p.read_text(encoding='utf-8');assert 'pub fn world_model' not in s
marker='#[cfg(test)] mod tests {'
add='''pub fn world_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_world_model_bounds.json")).expect("native world model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified world model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native world model scale")? as f32;
    let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native world model profile");}
    Ok(Model{local,skin_scale:scale})
}
pub fn model(name:&str)->Result<Model,&'static str>{base_model(name).or_else(|_|world_model(name))}
'''
assert marker in s;s=s.replace(marker,add+marker)
s=s.replace(' use super::*;',''' use super::*;
 #[test] fn original_world_boxes_scales_and_manifest_associations_match_native_consumers(){
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_world_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),21);
    let scales:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_world_model_scale_contract.json")).unwrap();assert_eq!(scales["passed"],true);assert_eq!(scales["cases"].as_array().unwrap().len(),19);
    let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/world_animation_manifest.json")).unwrap();
    for c in proof["cases"].as_array().unwrap(){
        let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
        let box_value=from_mesh(mesh,size).unwrap();assert_eq!(serde_json::json!(box_value.map(f32::to_bits)),c["provider_bounds_bits"]);
        let name=c["name"].as_str().unwrap();if name.starts_with("fixture-"){continue;}
        let loaded=world_model(name).unwrap();assert_eq!(loaded.local.map(f32::to_bits),box_value.map(f32::to_bits));assert_eq!(loaded.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);
        let entry=manifest.as_object().unwrap().iter().find(|(n,_)|n.eq_ignore_ascii_case(name)).unwrap().1;
        assert_eq!((entry["scale"].as_f64().unwrap() as f32).to_bits(),loaded.skin_scale.to_bits(),"render/spatial scale mismatch {name}");
        let scale=scales["cases"].as_array().unwrap().iter().find(|case|case["name"]==name).unwrap();assert_eq!(scale["result_bits"],c["skin_scale_bits"]);
    }
    assert!(world_model("TT_OrderTurret1").is_err());
 }
''',1)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_live_registry.rs';s=p.read_text(encoding='utf-8');assert 'fn loaded_observations' not in s
s=s.replace('last_error:Option<String>','last_error:Option<String>,unqualified_models:BTreeMap<u32,String>')
s=s.replace('last_error:None}','last_error:None,unqualified_models:BTreeMap::new()}')
s=s.replace('crate::grass_model_bounds::base_model(&actor.model)?','crate::grass_model_bounds::model(&actor.model)?')
s=s.replace('"error":self.last_error,','"error":self.last_error,"unqualified_loaded_models":self.unqualified_models,')
start=s.index('    let mut observations=Vec::new();\n    if let Some(snapshot)=&state.snapshot {')
end=s.index('        let error=live.synchronize',start)
s=s[:start]+'''    if let Some(snapshot)=&state.snapshot {
        let models:BTreeMap<_,_>=loaded.iter().map(|model|(model.network_id(),model.model_name())).collect();
        let (observations,unqualified)=loaded_observations(snapshot,&models);live.unqualified_models=unqualified;
'''+s[end:]
s=s.replace('}else if live.session.is_some(){let error=', '}else if live.session.is_some(){live.unqualified_models.clear();let error=')
marker='#[cfg(test)] mod tests {'
helper='''fn loaded_observations(snapshot:&openleague_core::Snapshot,models:&BTreeMap<u32,&str>)->(Vec<Observation>,BTreeMap<u32,String>) {
    let mut observations=Vec::new();let mut unqualified=BTreeMap::new();
    let mut observe=|id:u32,expected:&str,position:[f32;3]|{
        let Some(name)=models.get(&id) else{return;};
        if !name.eq_ignore_ascii_case(expected){return;}
        if crate::grass_model_bounds::model(name).is_err(){unqualified.insert(id,(*name).to_owned());return;}
        observations.push(Observation{id,model:(*name).to_owned(),position,actor_scale:1.});
    };
    for actor in &snapshot.players{observe(actor.id,&actor.champion,[actor.position.x,actor.height,actor.position.z]);}
    for unit in &snapshot.units{
        let name=if unit.kind.structure()&&unit.health<=0.{format!("{}_destroyed",unit.definition)}else{unit.definition.clone()};
        observe(unit.id,&name,[unit.position.x,unit.height,unit.position.z]);
    }
    (observations,unqualified)
}
'''
assert marker in s;s=s.replace(marker,helper+marker)
test='''
 #[test] fn loaded_world_models_follow_snapshot_identity_position_removal_and_unqualified_variants(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let player=simulation.join("garen").unwrap();let mut snapshot=simulation.snapshot();snapshot.session=700;
    let template=snapshot.units[0].clone();snapshot.units.clear();
    let world:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_grass_world_model_bounds.json")).unwrap();
    let mut names=BTreeMap::new();names.insert(player,"garen".to_owned());
    for (i,name) in world.as_object().unwrap().keys().enumerate(){let mut unit=template.clone();unit.id=50000+i as u32;unit.definition=name.clone();unit.kind=openleague_core::world::Kind::Monster;unit.health=100.;unit.position=openleague_core::Point{x:7000.+i as f32*80.,z:8100.};unit.height=45.;names.insert(unit.id,name.clone());snapshot.units.push(unit);}
    let mut unresolved=template.clone();unresolved.id=60000;unresolved.definition="TT_OrderTurret1".into();unresolved.kind=openleague_core::world::Kind::Turret;unresolved.health=100.;snapshot.units.push(unresolved);names.insert(60000,"TT_OrderTurret1".into());
    let mut live=Live::default();let loaded=names.iter().map(|(id,n)|(*id,n.as_str())).collect();let (observations,unqualified)=loaded_observations(&snapshot,&loaded);
    assert_eq!(observations.len(),17);assert_eq!(unqualified.len(),1);assert_eq!(unqualified[&60000],"TT_OrderTurret1");live.synchronize(700,&observations).unwrap();assert!(live.tree.queue.is_empty());
    let id=snapshot.units[0].id;let slot=live.active[&id].index;let before=live.registry.objects[slot].indexed.integer_bounds;snapshot.units[0].position.x+=500.;
    let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(700,&observations).unwrap();assert_ne!(live.registry.objects[slot].indexed.integer_bounds,before);
    snapshot.units.remove(0);let (observations,_)=loaded_observations(&snapshot,&loaded);live.synchronize(700,&observations).unwrap();assert!(!live.active.contains_key(&id));assert!(live.registry.recycled.contains(&slot));
    snapshot.units.last_mut().unwrap().health=0.;let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert!(unqualified.is_empty(),"previous live model must not stand in for destroyed model");assert_eq!(observations.len(),16);
    let mut destroyed=names.clone();destroyed.insert(60000,"TT_OrderTurret1_destroyed".into());let destroyed=destroyed.iter().map(|(id,n)|(*id,n.as_str())).collect();let (_,unqualified)=loaded_observations(&snapshot,&destroyed);assert_eq!(unqualified[&60000],"TT_OrderTurret1_destroyed");
 }
'''
assert s.endswith('}\n');s=s[:-2]+test+'}\n';p.write_text(s,encoding='utf-8')
print('World bounds consumer and actual loaded NPC bridge installed')
