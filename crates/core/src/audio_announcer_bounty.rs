//! Native bounty callback6D44B0/6D4500 and its historical %.0f rendering.
//! Float32 actor input is promoted to double before CRT conversion.
pub fn format_bounty_bits(bits:u32)->Vec<u8> {
 let value=f32::from_bits(bits);let negative=value.is_sign_negative();let magnitude=(value as f64).abs();
 let mut text=if !value.is_finite() {"1".to_string()} else if magnitude>=1e16 {
  // The old CRT generates 17 significant decimal digits and appends zeros
  // for integer places beyond that precision, rather than printing every
  // exact binary-integer digit. Float32 cannot hit a half tie at digit17.
  let scientific=format!("{magnitude:.16e}");let (mantissa,exponent)=scientific.split_once('e').unwrap();let mut digits=mantissa.replace('.',"");let places=exponent.parse::<i32>().unwrap()+1;digits.extend(std::iter::repeat_n('0',places as usize-digits.len()));digits
 } else {format!("{:.0}",magnitude.round())};
 if negative {text.insert(0,'-');}text.into_bytes()
}
pub fn bounty_bytes<A:Copy>(actor:Option<A>,mut flags:impl FnMut(A)->u32,mut float_bits:impl FnMut(A)->Result<u32,&'static str>)->Result<Vec<u8>,&'static str> {
 let Some(actor)=actor else {return Ok(b"0".to_vec());};
 if flags(actor)&0x400==0 {return Ok(b"0".to_vec());}
 Ok(format_bounty_bits(float_bits(actor)?))
}
#[cfg(test)] mod tests {
 use super::*;
 fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test] fn audio_bounty_gate_and_historical_float_output_match288_actual_native_crt_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_bounty_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),288);
  for c in cases {let bits=u32::from_le_bytes(decode(c["float_bits_hex"].as_str().unwrap()).try_into().unwrap());let mut ops=Vec::new();let bytes=bounty_bytes(c["actor_present"].as_bool().unwrap().then_some(1u32),|_|c["flags"].as_u64().unwrap() as u32,|_|{ops.push(serde_json::json!({"op":"bounty_getter"}));Ok(bits)}).unwrap();assert_eq!(bytes,decode(c["output_hex"].as_str().unwrap()));let expected:Vec<_>=c["ops"].as_array().unwrap().iter().filter(|o|o["op"]=="bounty_getter").cloned().collect();assert_eq!(ops,expected);}
 }
 #[test] fn audio_bounty_float_conversion_matches2080_original_random_full_range_and_nonfinite_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_bounty_extended_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2080);
  for c in cases {let bits=u32::from_le_bytes(decode(c["float_bits_hex"].as_str().unwrap()).try_into().unwrap());assert_eq!(format_bounty_bits(bits),decode(c["output_hex"].as_str().unwrap()),"{c}");}
 }
}
