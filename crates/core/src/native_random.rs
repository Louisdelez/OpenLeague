//! Original8E2630/8E25C0/8E26A0 shared55word RNG. Explicit seeds/state, no invented initialization clock.
#[derive(Debug,Clone)]
pub struct Rng55 {pub words:[u32;55],pub first:u32,pub second:u32}
impl Rng55 {
 /// Original993DA0: unsigned wrapping FILETIME epoch subtraction, 100ns to milliseconds.
 pub fn seed_from_filetime(filetime:u64)->u32 { (filetime.wrapping_sub(116444736000000000)/10000) as u32 }
 pub fn from_filetime(filetime:u64)->Self {Self::seeded(Self::seed_from_filetime(filetime))}
 pub fn seeded(seed:u32)->Self {
  static TABLE:std::sync::OnceLock<[u32;55]>=std::sync::OnceLock::new();
  let table=TABLE.get_or_init(||{let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_random_shake_contract.json")).expect("native RNG proof");std::array::from_fn(|i|p["seed_table_words"][i].as_u64().expect("native seed word") as u32)});
  Self{words:std::array::from_fn(|i|table[(i+seed as usize%55)%55]^seed),first:0,second:31}
 }
 fn advance(&mut self)->u32 {
  self.first=self.first.wrapping_add(1)%55;self.second=self.second.wrapping_add(3)%55;
  let value=self.words[self.second as usize];let mix=value.wrapping_add(0xaa).wrapping_shl(5).wrapping_add(value>>2);
  self.words[self.first as usize]^=mix;self.words[self.first as usize]
 }
 pub fn bounded(&mut self,maximum:u32)->u32 {if maximum==0 {0} else {self.advance()%maximum}}
 /// Native x87 value is exactly representable in f64; do not round before shake interpolation.
 pub fn fraction_extended(&mut self)->f64 {f64::from(self.advance()%u32::MAX)*f64::from(f32::from_bits(796917760))}
 pub fn fraction(&mut self)->f32 {self.fraction_extended() as f32}
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches_nine_seed_initializers_and_864_native_state_transitions() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_random_shake_contract.json")).unwrap();let cases=p["rng_sequences"].as_array().unwrap();assert_eq!(cases.len(),9);let mut count=0;
  for c in cases {
   let mut rng=Rng55::seeded(c["seed"].as_u64().unwrap() as u32);
   let check=|r:&Rng55,s:&serde_json::Value| {assert_eq!(r.first,s["first"].as_u64().unwrap() as u32);assert_eq!(r.second,s["second"].as_u64().unwrap() as u32);for i in 0..55 {assert_eq!(r.words[i],s["words"][i].as_u64().unwrap() as u32);}};
   check(&rng,&c["initial"]);
   for step in c["steps"].as_array().unwrap() {count+=1;if let Some(maximum)=step["maximum"].as_u64() {assert_eq!(rng.bounded(maximum as u32),step["bounded"].as_u64().unwrap() as u32);} else {let value=rng.fraction_extended();assert_eq!(value.to_bits(),step["extended_bits"].as_u64().unwrap());assert_eq!((value as f32).to_bits(),step["fraction_bits"].as_u64().unwrap() as u32);}check(&rng,&step["state"]);}
  }
  assert_eq!(count,864);
 }
 #[test]
 fn matches_native_utc_conversion_and_six_startup_seed_fragments() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/random_seed_clock_contract.json")).unwrap();
  let rows=p["conversion_cases"].as_array().unwrap();assert_eq!(rows.len(),114);
  for c in rows {assert_eq!(Rng55::seed_from_filetime(c["filetime"].as_u64().unwrap()),c["seed_u32"].as_u64().unwrap() as u32);}
  let rows=p["startup_cases"].as_array().unwrap();assert_eq!(rows.len(),6);
  for c in rows {let rng=Rng55::from_filetime(c["filetime"].as_u64().unwrap());assert_eq!(rng.first,0);assert_eq!(rng.second,31);for i in 0..55 {assert_eq!(rng.words[i],c["rng"]["words"][i].as_u64().unwrap() as u32);}}
 }

}
