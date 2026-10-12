//! Original filter-control frequency mapping B35530..B35680.
//! Raw mode selection, bypass, coefficients and PCM execution are separate.
pub fn cutoff(control:f32,mode_raw:u8,sample_rate:u32)->Result<f32,&'static str> {
 if !control.is_finite() || !(0.0..=100.0).contains(&control)
  || !matches!(sample_rate,44100|48000|96000) {return Err("unqualified filter control or sample rate");}
 if mode_raw!=0 {
  let integer=((sample_rate as f64/1024.0)*8.0).trunc() as u32;
  let half=(integer as u16 as f32)*0.5;
  return Ok(half-(((half-1.0)*0.01)*control));
 }
 if control<30.0 {
  return Ok((30.0-control)*f32::from_bits(0x43d8aaab)+7000.0);
 }
 let multiplier=f32::from_bits(0x497e9fbf) as f64;
 let bits=(((100.0-control as f64)*multiplier+1065353216.0) as i64) as u32;
 let mantissa=f32::from_bits((bits&0x7fffff)+0x3f800000);
 let exponent=f32::from_bits(bits&0xff800000);
 let value=(((mantissa*f32::from_bits(0x3ea67f46))+f32::from_bits(0x3caa70de))*mantissa+f32::from_bits(0x3f272ddb))*exponent;
 Ok(value*f32::from_bits(0x4186612a))
}
/// Normalized low-pass coefficient arguments passed to the original setter.
/// This does not expand its SIMD layout or run a PCM/channel-history filter.
pub fn coefficients(frequency:f32,sample_rate:u32)->Result<[f32;5],&'static str> {
 if !frequency.is_finite() || frequency<=0. || !matches!(sample_rate,44100|48000|96000) {
  return Err("unqualified filter frequency or sample rate");
 }
 let normalized=((frequency as f64/sample_rate as f64) as f32).min(0.45);
 let angle=normalized as f64*f32::from_bits(0x40490fdb) as f64;
 let k=(1.0/angle.tan()) as f32;
 let squared=k*k;
 let damping=k*f32::from_bits(0x3fb504f3);
 let gain=1.0/((damping+1.0)+squared);
 let a1=((1.0-squared)*2.0)*gain;
 let a2=((1.0-damping)+squared)*gain;
 let result=[gain,gain*2.0,gain,a1,a2];
 if result.iter().any(|v|!v.is_finite()) {return Err("filter coefficient overflow");}
 Ok(result)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn coefficient_arguments_match_original_calculation() {
  #[derive(serde::Deserialize)]struct Sample {frequency:f32,sample_rate:u32,native_coefficients:[f32;5]}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Sample>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_coefficients_contract.json")).unwrap();
  assert_eq!(c.cases.len(),30);
  for s in c.cases {
   let actual=coefficients(s.frequency,s.sample_rate).unwrap();
   for i in 0..5 {assert!((actual[i]-s.native_coefficients[i]).abs()<=1e-6,"freq{} rate{}: {:?} != {:?}",s.frequency,s.sample_rate,actual,s.native_coefficients);}
  }
 }
 #[test] fn frequency_clamps_to_native_point_four_five_and_invalid_inputs_fail() {
  assert_eq!(coefficients(48000.,48000),coefficients(24000.,48000));
  for f in [0.,-1.,f32::NAN,f32::INFINITY] {assert!(coefficients(f,48000).is_err());}
  assert!(coefficients(1000.,0).is_err());
 }
 #[test] fn cutoff_matches_all_original_mapping_branches() {
  #[derive(serde::Deserialize)]struct Sample {control:f32,mode_raw:u8,sample_rate:u32,native_cutoff:f32}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Sample>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_contract.json")).unwrap();
  assert_eq!(c.cases.len(),936);
  for s in c.cases {
   let actual=cutoff(s.control,s.mode_raw,s.sample_rate).unwrap();
   assert_eq!(actual.to_bits(),s.native_cutoff.to_bits(),"control{} mode{} rate{}",s.control,s.mode_raw,s.sample_rate);
  }
 }
 #[test] fn mode_zero_is_independent_of_rate_and_any_nonzero_mode_uses_alternate_path() {
  for control in [0.,29.99,30.,40.,100.] {
   assert_eq!(cutoff(control,0,44100),cutoff(control,0,96000));
   assert_eq!(cutoff(control,1,48000),cutoff(control,255,48000));
  }
  assert_eq!(cutoff(0.,0,48000).unwrap(),20000.);
  assert_eq!(cutoff(0.,1,48000).unwrap(),187.5);
 }
 #[test] fn unsupported_controls_and_sample_rates_are_explicit() {
  for control in [f32::NAN,f32::INFINITY,-0.01,100.01] {assert!(cutoff(control,0,48000).is_err());}
  for rate in [0,8000,192000] {assert!(cutoff(40.,0,rate).is_err());}
 }
}
