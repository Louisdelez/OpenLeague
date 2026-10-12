from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_model_bounds.rs';s=p.read_text();assert 'pub fn altar_model' not in s
marker='pub fn model(name:&str)'
idx=s.index(marker)
s=s[:idx]+'''pub fn altar_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_altar_model_bounds.json")).expect("native altar model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified altar model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native altar model scale")? as f32;let local=profile.provider_bounds_bits.map(f32::from_bits);
    if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native altar model profile");}Ok(Model{local,skin_scale:scale})
}
'''+s[idx:]
s=s.replace('.or_else(|_|structure_model(name))}', '.or_else(|_|structure_model(name)).or_else(|_|altar_model(name))}')
s=s.replace(' use super::*;',''' use super::*;
 #[test] fn separate_native_altar_resources_preserve_shared_box_and_scale(){
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_altar_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),7);
    let scales:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_altar_model_scale_contract.json")).unwrap();assert_eq!(scales["passed"],true);assert_eq!(scales["cases"].as_array().unwrap().len(),5);
    let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/world_animation_manifest.json")).unwrap();
    for c in proof["cases"].as_array().unwrap(){
        let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));assert_eq!(serde_json::json!(from_mesh(mesh,size).unwrap().map(f32::to_bits)),c["provider_bounds_bits"]);
        let name=c["name"].as_str().unwrap();if name.starts_with("fixture-"){continue;}let loaded=altar_model(name).unwrap();assert_eq!(serde_json::json!(loaded.local.map(f32::to_bits)),c["provider_bounds_bits"]);assert_eq!(loaded.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);assert_eq!((manifest[name]["scale"].as_f64().unwrap() as f32).to_bits(),loaded.skin_scale.to_bits());
        assert!(c["config"].as_str().unwrap().contains(if name=="altar_l"{"TT_Buffplat_L"}else{"TT_Buffplat_R"}));let native=scales["cases"].as_array().unwrap().iter().find(|v|v["name"]==name).unwrap();assert_eq!(native["result_bits"],c["skin_scale_bits"]);
    }
 }
''',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_live_registry.rs';s=p.read_text();needle='    (observations,unqualified)\n}'
new='''    if let Some(map)=&snapshot.map10 {
        for altar in &map.altars {
            // Same identity and model choice as receive's actual visual producer.
            let name=if altar.name=="altar_west"{"altar_l"}else{"altar_r"};
            observe(altar.id,name,[altar.position.x,altar.height,altar.position.z]);
        }
    }
    (observations,unqualified)
}''';assert needle in s;s=s.replace(needle,new)
test='''
 #[test] fn actual_map10_altars_follow_loaded_network_identity_movement_and_removal(){
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let mut snapshot=simulation.snapshot();snapshot.session=702;
    let map=snapshot.map10.as_mut().unwrap();assert_eq!(map.altars.len(),2);let west=map.altars.iter().find(|altar|altar.name=="altar_west").unwrap().id;let east=map.altars.iter().find(|altar|altar.name!="altar_west").unwrap().id;
    let models=BTreeMap::from([(west,"altar_l"),(east,"altar_r")]);let (observations,unqualified)=loaded_observations(&snapshot,&models);assert_eq!(observations.len(),2);assert!(unqualified.is_empty());let mut live=Live::default();live.synchronize(702,&observations).unwrap();assert_eq!(live.active[&west].model,"altar_l");assert_eq!(live.active[&east].model,"altar_r");
    let slot=live.active[&west].index;let before=live.registry.objects[slot].indexed.node.center;snapshot.map10.as_mut().unwrap().altars.iter_mut().find(|altar|altar.id==west).unwrap().position.x+=120.;let (observations,_)=loaded_observations(&snapshot,&models);live.synchronize(702,&observations).unwrap();assert_ne!(live.registry.objects[slot].indexed.node.center,before);
    let wrong=BTreeMap::from([(west,"altar_r"),(east,"altar_r")]);let (observations,_)=loaded_observations(&snapshot,&wrong);assert_eq!(observations.len(),1);live.synchronize(702,&observations).unwrap();assert!(!live.active.contains_key(&west));assert!(live.registry.recycled.contains(&slot));
    snapshot.map10=None;let (observations,_)=loaded_observations(&snapshot,&models);assert!(observations.is_empty());live.synchronize(702,&observations).unwrap();assert!(live.active.is_empty());
 }
''';assert s.endswith('}\n');s=s[:-2]+test+'}\n';p.write_text(s,encoding='utf-8');print('Loaded altar identities integrated with spatial lifecycle')
