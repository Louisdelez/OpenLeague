from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_model_bounds.rs';s=p.read_text();assert 'pub fn destroyed_model' not in s
idx=s.index('pub fn model(name:&str)');s=s[:idx]+'''pub fn destroyed_model(name:&str)->Result<Model,&'static str>{
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_destroyed_model_bounds.json")).expect("native destroyed model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified destroyed model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native destroyed model scale")? as f32;let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native destroyed model profile");}Ok(Model{local,skin_scale:scale})
}
'''+s[idx:];s=s.replace('.or_else(|_|altar_model(name))}', '.or_else(|_|altar_model(name)).or_else(|_|destroyed_model(name))}')
s=s.replace(' use super::*;',''' use super::*;
 #[test] fn recovered_destroyed_aliases_match_native_model_boxes_scales_and_scene_selection(){
    let boxes:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_destroyed_model_bounds_contract.json")).unwrap();assert_eq!(boxes["passed"],true);assert_eq!(boxes["cases"].as_array().unwrap().len(),17);
    let scales:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_destroyed_model_scale_contract.json")).unwrap();assert_eq!(scales["passed"],true);assert_eq!(scales["cases"].as_array().unwrap().len(),15);
    let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/world_animation_manifest.json")).unwrap();let selection:serde_json::Value=serde_json::from_str(include_str!("../../../docs/map10_destroyed_model_selection.json")).unwrap();let recovery:serde_json::Value=serde_json::from_str(include_str!("../../../docs/map10_destroyed_asset_recovery.json")).unwrap();assert_eq!(recovery["aliases"].as_array().unwrap().len(),12);
    for c in boxes["cases"].as_array().unwrap(){let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));assert_eq!(serde_json::json!(from_mesh(mesh,size).unwrap().map(f32::to_bits)),c["provider_bounds_bits"]);let name=c["name"].as_str().unwrap();if name.starts_with("fixture-"){continue;}
        let loaded=destroyed_model(name).unwrap();assert_eq!(serde_json::json!(loaded.local.map(f32::to_bits)),c["provider_bounds_bits"]);assert_eq!(loaded.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);
        let alias=recovery["aliases"].as_array().unwrap().iter().find(|a|a["alias"].as_str().unwrap().eq_ignore_ascii_case(name)).unwrap();let identity=alias["alias"].as_str().unwrap();assert_eq!(manifest[identity]["asset"],alias["asset"]);assert_eq!((manifest[identity]["scale"].as_f64().unwrap() as f32).to_bits(),loaded.skin_scale.to_bits());let definition=identity.strip_suffix("_destroyed").unwrap();assert_eq!(selection["profiles"][definition]["model"],alias["selected_model"]);let native=scales["cases"].as_array().unwrap().iter().find(|v|v["name"]==name).unwrap();assert_eq!(native["result_bits"],c["skin_scale_bits"]);
    }
    assert_eq!(destroyed_model("OrderNexus_destroyed").unwrap().skin_scale.to_bits(),0.8f32.to_bits());
 }
''',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_live_registry.rs';s=p.read_text();old='let (_,unqualified)=loaded_observations(&snapshot,&loaded);assert_eq!(unqualified[&id],format!("{original}_destroyed"));'
new='''let (observations,unqualified)=loaded_observations(&snapshot,&loaded);assert!(unqualified.is_empty());assert_eq!(observations.len(),12);live.synchronize(701,&observations).unwrap();assert_eq!(live.active[&id].model,format!("{original}_destroyed"));assert_eq!(live.active[&id].index,slot);assert!(live.registry.objects[slot].parent.is_some());'''
assert old in s;s=s.replace(old,new);p.write_text(s,encoding='utf-8');print('Recovered native destroyed models integrated with owned spatial lifecycle')
