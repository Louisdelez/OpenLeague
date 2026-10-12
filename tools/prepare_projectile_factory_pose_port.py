from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
code='''//! Pose fields from original projectile7172B0 /6C8E30 /6C97B0.
//! Allocation, collision bookkeeping, providers and resource parser remain separate.
#[derive(Debug,Clone)]
pub struct Setup {
 pub wrapper_position:[u32;3],pub wrapper_type:u32,pub ended:u32,
 pub troy_flags:u32,pub troy_requests:u32,pub troy_position:[u32;3],pub troy_matrix:[u32;16],
}
impl Setup {
 pub fn load(factory_flags:u32,pending_flags:u32,position:[f32;3],live:bool)->Result<Self,&'static str>{
  if !position.iter().all(|v|v.is_finite()) {return Err("nonfinite projectile factory position unqualified");}
  let constructor=crate::native_effect_live_creation::Troy::default();
  let mut s=Self{wrapper_position:if factory_flags&0x40==0 {position.map(f32::to_bits)}else{[0;3]},wrapper_type:0x212|(factory_flags&1),ended:0,troy_flags:constructor.flags24,troy_requests:constructor.dirty144,troy_position:[0;3],troy_matrix:constructor.matrix_words};
  if live {
   //6C96F0 calls flag getter/setter even when pending flags are zero.
   s.troy_flags|=if pending_flags&1!=0{0x10}else{0};
   s.troy_flags|=if pending_flags&2!=0{2}else{0};
   s.troy_flags|=if pending_flags&4!=0{0x20}else{0};
   s.troy_requests|=0x800|0x1000;
   s.troy_requests&=!0x2000;
   s.troy_position=[f32::MAX.to_bits();3];
   s.wrapper_type|=0x100000;
  }
  Ok(s)
 }
 /// Qualified empty-provider prefix and setters. Other wrapper fields omitted.
 pub fn first_update(&mut self,live:bool)->bool {
  if !live || self.ended!=0{return false;}
  self.troy_position=self.wrapper_position;
  self.troy_requests|=0x90|0x1000;
  true
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn check(s:&Setup,r:&serde_json::Value){
  for (k,a) in [("wrapper_type",s.wrapper_type),("ended",s.ended),("troy_flags",s.troy_flags),("troy_requests",s.troy_requests)]{assert_eq!(a,r[k].as_u64().unwrap() as u32,"{k} {r}");}
  for (k,a) in [("wrapper_position",s.wrapper_position.to_vec()),("troy_position",s.troy_position.to_vec()),("troy_matrix",s.troy_matrix.to_vec())]{let e:Vec<u32>=r[k].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();assert_eq!(a,e,"{k} {r}");}
 }
 #[test]
 fn matches120_native_projectile_factory_load_and_first_update_profiles(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_factory_pose_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),120);
  for c in cases {
   let live=c["live"].as_bool().unwrap();let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);
   let mut s=Setup::load(c["factory_flags"].as_u64().unwrap() as u32,c["pending_flags"].as_u64().unwrap() as u32,position,live).unwrap();check(&s,&c["after_load"]);
   assert_eq!(u32::from(s.first_update(live)),c["update_return"].as_u64().unwrap() as u32);check(&s,&c["after_update"]);
  }
 }
}
'''
(r/'crates/core/src/native_projectile_factory_pose.rs').write_text(code,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8')
if 'pub mod native_projectile_factory_pose;' not in s:p.write_text(s+'\npub mod native_projectile_factory_pose;\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
