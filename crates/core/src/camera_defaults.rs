//! Native7D2960 focus defaults and7CFB03 map adjustments. Runtime saved globals supplied.
#[derive(Debug,Clone,Copy)]
pub struct Defaults {
    pub current:[f32;3],pub saved:[f32;3],pub auxiliary_before_angles:u32,
    pub pitch_degrees:f32,pub yaw_degrees:f32,pub previous_yaw_degrees:f32,
    pub extra_angle_degrees:f32,pub fov_degrees:f32,pub auxiliary_after_fov:u32,
    pub zoom_scale:f32,
}
impl Defaults {
    pub fn original_initial(saved_global_words:[u32;3],map_id_raw:u32)->Self {
        let adjusted=map_id_raw==11||map_id_raw==90;
        Self {current:[-1000.;3],saved:saved_global_words.map(f32::from_bits),auxiliary_before_angles:0,
            pitch_degrees:56.,yaw_degrees:180.,previous_yaw_degrees:180.,extra_angle_degrees:56.,
            fov_degrees:if adjusted {40.} else {50.},auxiliary_after_fov:0,
            zoom_scale:if adjusted {map_override_scale()} else {1.}}
    }
}
// Only the two fixed constructor angles use this polynomial; not a general tangent API.
fn constructor_tangent(angle:f32)->f32 {
    let x2=angle*angle;
    let mut p=x2*f32::from_bits(1008462948)+f32::from_bits(993924796);
    for c in [1019821242,1029349058,1040750596,1051372138,1065353216] {p=p*x2+f32::from_bits(c);}
    p*angle
}
fn map_override_scale()->f32 {
    let numerator=constructor_tangent(f32::from_bits(1054828275));
    let denominator=constructor_tangent(f32::from_bits(1051900099));
    // Both native tangent returns were stored to f32; x87 divides then rounds to f32.
    (f64::from(numerator)/f64::from(denominator)) as f32
}
#[cfg(test)]
mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_defaults_contract.json")).unwrap()}
 #[test]
 fn matches_original_focus_initializer_including_raw_saved_globals() {
  let p=proof();let cases=p["initializers"].as_array().unwrap();assert_eq!(cases.len(),4);
  for c in cases {
   let seed=std::array::from_fn(|i|c["saved_seed_bits"][i].as_u64().unwrap() as u32);
   let d=Defaults::original_initial(seed,10);
   let words=[d.current[0].to_bits(),d.current[1].to_bits(),d.current[2].to_bits(),d.saved[0].to_bits(),d.saved[1].to_bits(),d.saved[2].to_bits(),d.auxiliary_before_angles,d.pitch_degrees.to_bits(),d.yaw_degrees.to_bits(),d.previous_yaw_degrees.to_bits(),d.extra_angle_degrees.to_bits(),d.fov_degrees.to_bits(),d.auxiliary_after_fov];
   for i in 0..13 {assert_eq!(words[i],c["state_bits"][i].as_u64().unwrap() as u32,"{i}/{c}");}
  }
 }
 #[test]
 fn matches_130_native_map_adjustments_without_substituting_standard_tangent() {
  let p=proof();let cases=p["map_overrides"].as_array().unwrap();assert_eq!(cases.len(),130);
  for c in cases {
   let map=c["map_id_raw"].as_u64().unwrap() as u32;let d=Defaults::original_initial([0;3],map);
   assert_eq!(d.fov_degrees.to_bits(),c["fov_bits"].as_u64().unwrap() as u32,"map{map}");
   assert_eq!(d.zoom_scale.to_bits(),c["zoom_scale_bits"].as_u64().unwrap() as u32,"map{map}");
   assert_eq!(c["tangent_input_bits"].as_array().unwrap().len(),if map==11||map==90 {2} else {0});
  }
  assert_eq!(Defaults::original_initial([0;3],10).fov_degrees,50.);
 }
}
