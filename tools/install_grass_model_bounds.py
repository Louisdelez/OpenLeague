from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_model_bounds.rs';assert not p.exists()
code='''//! Native static model box from9640CF/9641B8, consumed through66C0B0.
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
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn all_native_base_model_boxes_and_overrides_match_original_loader_and_getter() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_model_bounds_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),127);
    for c in proof["cases"].as_array().unwrap() {
        let mesh=std::array::from_fn(|i|c["mesh_bounds"][i].as_f64().unwrap() as f32);let size=c["override"].as_array().map(|a|std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
        let local=from_mesh(mesh,size).unwrap();assert_eq!(serde_json::json!(local.map(f32::to_bits)),c["provider_bounds_bits"],"native model {}",c["name"]);
        if !c["name"].as_str().unwrap().starts_with("fixture-"){let model=base_model(c["name"].as_str().unwrap()).unwrap();assert_eq!(model.local.map(f32::to_bits),local.map(f32::to_bits));}
    }
    assert!(base_model("missing-model").is_err());
 }
}
'''
p.write_text(code,encoding='utf-8');main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');s='mod grass_model_bounds;\n'+s;main.write_text(s,encoding='utf-8')
for name in ['install_grass_model_bounds.py','probe_native_grass_model_bounds.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
