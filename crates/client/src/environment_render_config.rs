//! Original958E90 configuration consumer, after explicit typed getter adaptation.
//! Full getter/override, renderer initialization and alpha draw-state remain separate.
use bevy::prelude::Resource;
use crate::map10_native_config::{Config,Value,key};
#[derive(Clone,Debug,Resource)]
pub struct State {
 pub renderer:u32,pub height_blend:bool,pub scales:[f32;4],pub colormap:bool,
 pub colormap_revision:u32,pub shadow_dynamic_only:bool,pub shadow_revision:u32,pub alpha_reference:f32,
}
#[derive(Default,Debug)]
pub struct Input {pub renderer:Option<String>,pub height_blend:Option<i32>,pub scales:[Option<f32>;4],pub colormap:Option<i32>,pub shadow_dynamic_only:Option<i32>,pub alpha_cutoff:Option<i32>}
fn integer(config:&Config,section:&str,name:&str)->Result<Option<i32>,&'static str> {
 match config.entries.get(&key(section,name)) {None=>Ok(None),Some(Value::Boolean(v))=>Ok(Some(i32::from(*v))),Some(Value::Byte(v))=>Ok(Some(*v as i32)),_=>Err("native integer getter conversion unqualified")}
}
impl Input {
 pub fn map10()->Result<Self,&'static str> {
  let config=Config::map10()?;
  let renderer=match config.entries.get(&key("Environment","Renderer")) {None=>None,Some(Value::Text(v))=>Some(v.clone()),_=>return Err("native renderer text conversion unqualified")};
  let mut scales=[None;4];
  for (i,slot) in scales.iter_mut().enumerate() {
   *slot=match config.entries.get(&key("HeightBlending",&format!("layer{i}_scale"))) {
    None=>None,Some(Value::Float(v))=>Some(*v),
    // The recovered native file contains literal1.0000 for layer1. General text parsing is not qualified.
    Some(Value::Text(v)) if v=="1.0000"=>Some(1.),_=>return Err("native layer scale conversion unqualified")
   };
  }
  Ok(Self {renderer,height_blend:integer(&config,"HeightBlending","enable")?,scales,colormap:integer(&config,"ColorMap","enable")?,shadow_dynamic_only:integer(&config,"Environment","ShadowDynamicOnly")?,alpha_cutoff:integer(&config,"AlphaTest","cut_off")?})
 }
}
impl State {
 pub fn native_static_initial()->Self {
  let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/environment_render_defaults.json")).expect("native render defaults");
  let d=&d["state"];
  Self {renderer:d["renderer"].as_u64().unwrap() as u32,height_blend:d["height_blend"].as_bool().unwrap(),scales:std::array::from_fn(|i|f32::from_bits(d["scale_bits"][i].as_u64().unwrap() as u32)),colormap:d["colormap"].as_bool().unwrap(),colormap_revision:d["colormap_revision"].as_u64().unwrap() as u32,shadow_dynamic_only:d["shadow_dynamic_only"].as_bool().unwrap(),shadow_revision:d["shadow_revision"].as_u64().unwrap() as u32,alpha_reference:f32::from_bits(d["alpha_bits"].as_u64().unwrap() as u32)}
 }
 pub fn apply(&mut self,input:&Input) {
  match input.renderer.as_deref().unwrap_or("legacy") {
   "baked"=>self.renderer=2,
   "legacy"=>{
    self.renderer=1;self.height_blend=input.height_blend.unwrap_or(0)!=0;
    self.scales=input.scales.map(|v|v.unwrap_or(1.));
    let color=input.colormap.unwrap_or(0)!=0;
    if color!=self.colormap {self.colormap_revision=self.colormap_revision.wrapping_add(1);self.colormap=color;}
    let shadow=input.shadow_dynamic_only.unwrap_or(0)==1;
    if shadow!=self.shadow_dynamic_only {self.shadow_revision=self.shadow_revision.wrapping_add(1);self.shadow_dynamic_only=shadow;}
   },_=>{}
  }
  // Exact original1138A30 f32 reciprocal255, not a rounded decimal approximation.
  let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/environment_render_defaults.json")).unwrap();
  self.alpha_reference=input.alpha_cutoff.unwrap_or(1).clamp(0,255) as f32*f32::from_bits(d["alpha_unit_bits"].as_u64().unwrap() as u32);
 }
 pub fn native_map10()->Result<Self,&'static str> {let mut state=Self::native_static_initial();state.apply(&Input::map10()?);Ok(state)}
 pub fn require_current_material_profile(&self)->Result<(),&'static str> {
  if self.renderer!=1 {return Err("native alternate renderer integration unfinished");}
  if !self.height_blend || !self.colormap {return Err("native non-height/non-colormap material variants unfinished");}
  Ok(())
 }
}
impl Default for State {fn default()->Self {let state=Self::native_map10().expect("native Map10 render configuration");state.require_current_material_profile().expect("supported native Map10 render profile");state}}
#[cfg(test)] mod tests {
 use super::*;
 fn from_json(d:&serde_json::Value)->State {
  State {renderer:d["renderer"].as_u64().unwrap() as u32,height_blend:d["height_blend"].as_bool().unwrap(),scales:std::array::from_fn(|i|f32::from_bits(d["scale_bits"][i].as_u64().unwrap() as u32)),colormap:d["colormap"].as_bool().unwrap(),colormap_revision:d["colormap_revision"].as_u64().unwrap() as u32,shadow_dynamic_only:d["shadow_dynamic_only"].as_bool().unwrap(),shadow_revision:d["shadow_revision"].as_u64().unwrap() as u32,alpha_reference:f32::from_bits(d["alpha_bits"].as_u64().unwrap() as u32)}
 }
 fn compare(s:&State,d:&serde_json::Value) {let e=from_json(d);assert_eq!(s.renderer,e.renderer);assert_eq!(s.height_blend,e.height_blend);assert_eq!(s.scales.map(f32::to_bits),e.scales.map(f32::to_bits));assert_eq!(s.colormap,e.colormap);assert_eq!(s.colormap_revision,e.colormap_revision);assert_eq!(s.shadow_dynamic_only,e.shadow_dynamic_only);assert_eq!(s.shadow_revision,e.shadow_revision);assert_eq!(s.alpha_reference.to_bits(),e.alpha_reference.to_bits());}
 #[test] fn original_consumer_branches_defaults_revisions_and_alpha_bits_match_every_recorded_case() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/environment_render_config_contract.json")).unwrap();assert_eq!(proof["passed"],true);
  for case in proof["cases"].as_array().unwrap() {
   let p=&case["properties"];let number=|key:&str|p[key].as_i64().map(|v|v as i32).or_else(||p[key].as_bool().map(i32::from));
   let input=Input {renderer:p["Environment/Renderer"].as_str().map(str::to_owned),height_blend:number("HeightBlending/enable"),scales:std::array::from_fn(|i|{let value=&p[format!("HeightBlending/layer{i}_scale")];value.as_f64().map(|v|v as f32).or_else(||value.as_str().map(|v|v.parse::<f32>().unwrap()))}),colormap:number("ColorMap/enable"),shadow_dynamic_only:number("Environment/ShadowDynamicOnly"),alpha_cutoff:number("AlphaTest/cut_off")};
   let mut state=from_json(&case["initial"]);state.apply(&input);compare(&state,&case["result"]);
  }
 }
 #[test] fn real_binary_configuration_drives_current_material_profile_and_rejects_unimplemented_variants() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/environment_render_config_contract.json")).unwrap();let state=State::native_map10().unwrap();compare(&state,&proof["cases"][0]["result"]);assert!(state.require_current_material_profile().is_ok());assert_eq!(state.renderer,1);assert!(state.height_blend && state.colormap && state.shadow_dynamic_only);
  let restoration:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/terrain_materials.json")).unwrap();for i in 0..4 {assert_eq!(state.scales[i].to_bits(),(restoration["layer_scales"][i].as_f64().unwrap() as f32).to_bits());}
  let mut alternate=state.clone();alternate.renderer=2;assert!(alternate.require_current_material_profile().is_err());alternate.renderer=1;alternate.height_blend=false;assert!(alternate.require_current_material_profile().is_err());alternate.height_blend=true;alternate.colormap=false;assert!(alternate.require_current_material_profile().is_err());
 }
}
