//! Native scaling4 dB-to-amplitude approximation (ADEE1C..ADEED6).
/// Verified bounded positive domain; finite-input guards are defensive.
pub fn amplitude(db:f32)->Result<f32,&'static str> {
 if !db.is_finite() || db>48. {return Err("unqualified dB gain");}
 let scaled=db*0.05;
 if scaled < -37. {return Ok(0.);}
 // x87 multiplication/addition then truncation to i64. All constants and
 // inputs are f32; f64 retains these bounded intermediate integer bits.
 let multiplier=f32::from_bits(0x4bd49a78) as f64;
 let bits=((scaled as f64*multiplier+1065353216.) as i64) as u32;
 let mantissa=f32::from_bits((bits&0x7fffff)+0x3f800000);
 let exponent=f32::from_bits(bits&0xff800000);
 let a=f32::from_bits(0x3ea67f46);
 let b=f32::from_bits(0x3caa70de);
 let c=f32::from_bits(0x3f272ddb);
 Ok((((mantissa*a)+b)*mantissa+c)*exponent)
}

/// AF5670 conversion with x87 PC64 and nearest-even addition, followed by
/// toward-zero signed64 conversion. Preserve native invalid conversion bits.
/// The separate guarded amplitude API retains its original qualified contract.
pub fn native_extended_bits(db_bits:u32)->u32{
 let scaled=f32::from_bits(db_bits)*f32::from_bits(0x3d4ccccd);if scaled < -37.0{return 0;}
 let integer=x87_sum_to_integer(scaled);let bits=integer as u32;let mantissa=f32::from_bits((bits&0x7fffff)+0x3f800000);let exponent=f32::from_bits(bits&0xff800000);
 ((((mantissa*f32::from_bits(0x3ea67f46))+f32::from_bits(0x3caa70de))*mantissa+f32::from_bits(0x3f272ddb))*exponent).to_bits()
}
fn x87_sum_to_integer(scaled:f32)->i64{
 let product=scaled as f64*f32::from_bits(0x4bd49a78)as f64;let bias=1065353216u128;
 if !product.is_finite()||product>=9223372036854775808.0{return i64::MIN;}
 // Half one PC64 ulp at the positive integer bias. Below this the extended
 // sum rounds to the bias even for a negative, nonzero input.
 if product.abs()<=f64::from_bits(0x3dc0000000000000){return bias as i64;}
 let bits=scaled.to_bits();let field=(bits>>23)&255;let mantissa=(bits&0x7fffff)|if field==0{0}else{0x800000};let exponent=if field==0{-149}else{field as i32-150};let multiplier=0x4bd49a78u32;let m=(multiplier&0x7fffff)|0x800000;let e=((multiplier>>23)&255)as i32-150;let numerator=mantissa as u128*m as u128;let exponent=exponent+e;
 let(positive,denominator)=if exponent>=0{let p=numerator<<exponent as u32;(if bits&0x80000000!=0{bias-p}else{bias+p},0)}else{let d=(-exponent)as u32;let base=bias<<d;(if bits&0x80000000!=0{base-numerator}else{base+numerator},d)};
 let bit_length=128-positive.leading_zeros();let shift=bit_length.saturating_sub(64);let rounded=if shift==0{positive}else{let mut high=positive>>shift;let rest=positive&((1u128<<shift)-1);let half=1u128<<(shift-1);if rest>half||(rest==half&&high&1!=0){high+=1;}high<<shift};
 let integer=rounded>>denominator;if integer>=1u128<<63{i64::MIN}else{integer as i64}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn gains_match_original_scaling4_execution() {
  #[derive(serde::Deserialize)]struct Sample {db:f32,native_gain:f32}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Sample>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_gain_contract.json")).unwrap();
  assert_eq!(c.cases.len(),173);
  for s in c.cases {
   let actual=amplitude(s.db).unwrap();
   assert_eq!(actual.to_bits(),s.native_gain.to_bits(),"dB {}",s.db);
  }
 }
 #[test] fn native_silence_threshold_and_unqualified_inputs_are_explicit() {
  assert_eq!(amplitude(-740.01).unwrap(),0.);
  assert!(amplitude(-740.).unwrap()>0.);
  for db in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY,48.01] {assert!(amplitude(db).is_err());}
 }
}
