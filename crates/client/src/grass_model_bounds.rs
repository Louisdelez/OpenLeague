//! Native static model box from9640CF/9641B8, consumed through66C0B0.
use std::{collections::BTreeMap,sync::OnceLock};
#[derive(Clone,Copy)] pub struct Model {pub local:[f32;6],pub skin_scale:f32}
pub fn from_mesh(mesh:[f32;6],override_size:Option<[f32;3]>)->Result<[f32;6],&'static str> {
    if mesh.iter().any(|v|!v.is_finite())||override_size.is_some_and(|s|s.iter().any(|v|!v.is_finite())){return Err("nonfinite static model bounds");}
    let size=override_size.unwrap_or([(mesh[3]-mesh[0]).abs(),mesh[4]-mesh[1],(mesh[5]-mesh[2]).abs()]);
    let out=[0.,mesh[1],0.,size[0],size[1]+mesh[1],size[2]];
    if out.iter().any(|v|!v.is_finite()){return Err("static model bounds overflow");}Ok(out)
}
#[derive(serde::Deserialize)] struct Profile {provider_bounds_bits:[u32;6],skin_scale:serde_json::Value}
pub fn base_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_model_bounds.json")).expect("native model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified base model bounds")?;
    let scale=profile.skin_scale.as_f64().map(|v|v as f32).or_else(||profile.skin_scale.as_str()?.parse::<f32>().ok()).ok_or("invalid native model skin scale")?;
    let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native model profile");}
    Ok(Model{local,skin_scale:scale})
}
pub fn world_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_world_model_bounds.json")).expect("native world model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified world model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native world model scale")? as f32;
    let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native world model profile");}
    Ok(Model{local,skin_scale:scale})
}
pub fn structure_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_structure_model_bounds.json")).expect("native structure model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified structure model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native structure model scale")? as f32;
    let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native structure model profile");}
    Ok(Model{local,skin_scale:scale})
}
pub fn altar_model(name:&str)->Result<Model,&'static str> {
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_altar_model_bounds.json")).expect("native altar model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified altar model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native altar model scale")? as f32;let local=profile.provider_bounds_bits.map(f32::from_bits);
    if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native altar model profile");}Ok(Model{local,skin_scale:scale})
}
pub fn destroyed_model(name:&str)->Result<Model,&'static str>{
    static C:OnceLock<BTreeMap<String,Profile>>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_grass_destroyed_model_bounds.json")).expect("native destroyed model bounds catalog"));
    let profile=catalog.get(&name.to_ascii_lowercase()).ok_or("missing qualified destroyed model bounds")?;
    let scale=profile.skin_scale.as_f64().ok_or("invalid native destroyed model scale")? as f32;let local=profile.provider_bounds_bits.map(f32::from_bits);if !scale.is_finite()||local.iter().any(|v|!v.is_finite()){return Err("nonfinite native destroyed model profile");}Ok(Model{local,skin_scale:scale})
}
pub fn model(name:&str)->Result<Model,&'static str>{base_model(name).or_else(|_|world_model(name)).or_else(|_|structure_model(name)).or_else(|_|altar_model(name)).or_else(|_|destroyed_model(name))}
#[cfg(test)] mod tests {
 use super::*;
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

 #[test] fn authored_structure_meshes_produce_native_boxes_and_render_scales(){
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_intact_animation_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),17);
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

 #[test] fn all_native_base_model_boxes_and_overrides_match_original_loader_and_getter() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),127);
    for c in proof["cases"].as_array().unwrap() {
        let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
        let local=from_mesh(mesh,size).unwrap();assert_eq!(serde_json::json!(local.map(f32::to_bits)),c["provider_bounds_bits"],"native model {}",c["name"]);
        if !c["name"].as_str().unwrap().starts_with("fixture-"){let model=base_model(c["name"].as_str().unwrap()).unwrap();assert_eq!(model.local.map(f32::to_bits),local.map(f32::to_bits));assert_eq!(model.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);}
    }
    assert!(base_model("missing-model").is_err());
 }
}
