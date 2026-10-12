//! Original pitch cents to playback ratio, x87 path B27F56..B27F6C.
/// Source f32 cents and multiplier are multiplied without a premature f32
/// rounding step, then the power result is rounded to an f32 control.
pub fn ratio(cents:f32)->Result<f32,&'static str> {
 if !cents.is_finite() || cents.abs()>2400. {return Err("unqualified native pitch");}
 let factor=f32::from_bits(0x3a5a740e) as f64;
 Ok(2.0f64.powf(cents as f64*factor) as f32)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn pitch_matches_original_x87_execution() {
  #[derive(serde::Deserialize)]struct Sample {cents:f32,native_ratio:f32}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Sample>,cents_multiplier:f32}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_pitch_contract.json")).unwrap();
  assert_eq!(c.cases.len(),206);
  assert_eq!(c.cents_multiplier.to_bits(),0x3a5a740e);
  for s in c.cases {
   let actual=ratio(s.cents).unwrap();
   assert!(actual.to_bits().abs_diff(s.native_ratio.to_bits())<=1,"cents {}: {} != {}",s.cents,actual,s.native_ratio);
  }
 }
 #[test] fn octave_controls_and_unsupported_pitch_are_explicit() {
  assert_eq!(ratio(0.).unwrap(),1.);
  assert_eq!(ratio(1200.).unwrap(),2.);
  assert_eq!(ratio(-1200.).unwrap(),0.5);
  for v in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY,-2400.01,2400.01] {assert!(ratio(v).is_err());}
 }
}
