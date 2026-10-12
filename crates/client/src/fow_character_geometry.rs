//! Original56BD88 CharacterData field reads and nested global default.
//! Native lookup/cache implementation and configuration hierarchy remain open.
use std::sync::OnceLock;
use serde::Deserialize;
use std::collections::BTreeMap;
use crate::fow_actor_metrics::CharacterGeometry;
#[derive(Deserialize)] pub struct AuthoredGeometry {
    #[serde(rename="SelectionHeight")]pub selection_height:Option<f32>,
    #[serde(rename="SelectionRadius")]pub selection_radius:Option<f32>,
    #[serde(rename="PathfindingCollisionRadius")]pub pathfinding_radius:Option<f32>,
    #[serde(rename="GameplayCollisionRadius")]pub gameplay_radius:Option<f32>,
}
impl AuthoredGeometry {
    pub fn resolve(&self,global_collision_radius:f32)->CharacterGeometry {
        CharacterGeometry {shape:self.selection_height.unwrap_or(-1.),radius:self.selection_radius.unwrap_or(-1.),secondary:self.pathfinding_radius.unwrap_or(-1.),geometry_factor:self.gameplay_radius.unwrap_or(global_collision_radius)}
    }
}
#[derive(Deserialize)] struct Profile {authored:AuthoredGeometry}
#[derive(Deserialize)] struct Catalog {global_collision_default:f32,profiles:BTreeMap<String,Profile>}
pub fn native_character(definition:&str,global_collision_override:Option<f32>)->Result<CharacterGeometry,&'static str> {
    static C:OnceLock<Catalog>=OnceLock::new();let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_character_geometry.json")).expect("native character geometry catalog"));
    static N:OnceLock<Catalog>=OnceLock::new();let npc=N.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_npc_geometry.json")).expect("native NPC geometry catalog"));
    let name=definition.to_ascii_lowercase();
    let (profile,default)=if let Some(profile)=catalog.profiles.get(&name) {(profile,catalog.global_collision_default)}else if let Some(profile)=npc.profiles.get(&name) {(profile,npc.global_collision_default)}else{return Err("missing native character geometry");};
    Ok(profile.authored.resolve(global_collision_override.unwrap_or(default)))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn authored_122_characters_and_nested_global_defaults_match_original_field_writes() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_character_geometry_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),125);
        for c in proof["cases"].as_array().unwrap() {
            let authored:AuthoredGeometry=serde_json::from_value(c["authored"].clone()).unwrap();
            let global=c["global_override"].as_f64().map(|v|v as f32).unwrap_or(65.);let resolved=authored.resolve(global);
            for (i,v) in [resolved.shape,resolved.radius,resolved.secondary,resolved.geometry_factor].iter().enumerate() {assert_eq!(v.to_bits(),c["result_bits"][i].as_u64().unwrap() as u32,"{c}");}
            if let Ok(loaded)=native_character(c["name"].as_str().unwrap(),None) {for (a,b) in [loaded.shape,loaded.radius,loaded.secondary,loaded.geometry_factor].iter().zip([resolved.shape,resolved.radius,resolved.secondary,resolved.geometry_factor]) {assert_eq!(a.to_bits(),b.to_bits());}}
        }
        assert!(native_character("missing-unit",None).is_err());let garen=native_character("Garen",None).unwrap();assert!(garen.radius>0. && garen.secondary>0.);
    }
}

#[cfg(test)] mod npc_tests {
    use super::*;
    #[test] fn original_28_npc_geometry_resources_match_native_field_reads() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_npc_geometry_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),31);
        for c in proof["cases"].as_array().unwrap().iter().take(28) {
            let loaded=native_character(c["name"].as_str().unwrap(),None).unwrap();
            for (i,v) in [loaded.shape,loaded.radius,loaded.secondary,loaded.geometry_factor].iter().enumerate() {assert_eq!(v.to_bits(),c["result_bits"][i].as_u64().unwrap() as u32,"NPC {c}");}
        }
    }
}
