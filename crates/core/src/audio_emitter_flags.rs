//! Native6C96F0 and Troy928440/928460 accessors, with weak lifetime explicit.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Transfer {pub flags:u32,pub requests:u32}
/// The wrapper maps bits1/2/4 to target10/2/20 and preserves all target bits.
/// An alive target setter marks request800 even when flags do not change.
pub fn transfer(alive:bool,wrapper:u32,flags:u32,requests:u32)->Transfer {
 if !alive{return Transfer{flags,requests};}
 Transfer{flags:flags | (wrapper&2) | ((wrapper&1)<<4) | ((wrapper&4)<<3),requests:requests|0x800}
}
#[cfg(test)]mod tests{
 use super::*;
 #[test]fn matches_native_wrapper_and_real_target_accessors(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_flags_contract.json")).unwrap();
  let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),360);
  for c in cases{
   let n=|k:&str|c[k].as_u64().unwrap() as u32;
   assert_eq!(transfer(c["weak_alive"].as_bool().unwrap(),n("wrapper_flags"),n("existing"),n("dirty")),Transfer{flags:n("final_flags"),requests:n("final_dirty")},"{c}");
  }
 }
}

/// Original animation start5B56B4..5B56C6, after its factory returned a wrapper.
/// Wrapper is valid here; `alive` refers only to its weak effect target.
pub fn animation_start(alive:bool,wrapper:&mut u32,flags:u32,requests:u32)->Transfer {
 *wrapper|=1;
 transfer(alive,*wrapper,flags,requests)
}
#[cfg(test)]mod start_tests{
 use super::*;
 #[test]fn animation_start_matches_native_caller_and_accessors(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_start_flags_contract.json")).unwrap();
  let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),360);
  for c in cases{
   let n=|k:&str|c[k].as_u64().unwrap() as u32;let mut wrapper=n("wrapper_flags");
   assert_eq!(animation_start(c["weak_alive"].as_bool().unwrap(),&mut wrapper,n("existing"),n("dirty")),Transfer{flags:n("final_flags"),requests:n("final_dirty")},"{c}");
   assert_eq!(wrapper,n("started_wrapper"));
  }
 }
}
