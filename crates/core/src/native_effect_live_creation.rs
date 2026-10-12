//!751BE0 profile with concrete10D6DB4 callbacks and6AB520 direction matrix.
use crate::native_particle_force_body::inverse_estimate;
#[derive(Debug,Clone)]
pub struct Troy {pub flags24:u32,pub dirty144:u32,pub scalar148:u32,pub scalar5c:u32,pub scalar3c:u32,pub matrix_words:[u32;16]}
/// Verified93FD60 constructor fields before resource loading.
impl Default for Troy {fn default()->Self{Self{flags24:0,dirty144:0x2000,scalar148:0,scalar5c:1f32.to_bits(),scalar3c:1f32.to_bits(),matrix_words:[1f32.to_bits(),0,0,0,0,1f32.to_bits(),0,0,0,0,1f32.to_bits(),0,0,0,0,1f32.to_bits()]}}}
fn normalize(v:[f32;3])->Result<[f32;3],&'static str>{
 let squared=(v[1]*v[1]+v[0]*v[0])+v[2]*v[2];if !squared.is_finite(){return Err("effect matrix overflow");}
 if squared>1e-9 {let e=inverse_estimate(squared)?;let factor=(3.-((e*squared)*e))*(e*0.5);Ok(v.map(|x|x*factor))}else{Ok(v)}
}
/// Native6AB520 keeps up=[0,1,0], normalizes forward and right independently.
pub fn direction_matrix(direction:[f32;3])->Result<[u32;16],&'static str>{
 if !direction.into_iter().all(f32::is_finite){return Err("unqualified effect direction");}
 let f=normalize(direction)?;
 let r=normalize([direction[2]-direction[1]*0.,direction[0]*0.-direction[2]*0.,direction[1]*0.-direction[0]])?;
 Ok([r[0],r[1],r[2],0.,0.,1.,0.,0.,f[0],f[1],f[2],0.,0.,0.,0.,1.].map(f32::to_bits))
}
/// Qualified pending wrapper has zero accumulated scalar180 and no attached owner.
/// Resource construction, weak lifetime and caller binding are separate requirements.
pub fn configure(flags:u32,direction:[f32;3],scalar180:f32,scalar140:f32,live:bool,troy:&mut Troy)->Result<(),&'static str>{
 let pending=crate::native_effect_pending_creation::configure(flags,scalar180,scalar140,[0.;3])?;
 if !direction.into_iter().all(f32::is_finite){return Err("unqualified effect direction");}
 let matrix=if direction!=[0.;3]{Some(direction_matrix(direction)?)}else{None};
 if !live{return Ok(());}
 troy.scalar148=pending.scalar180;
 if pending.flags144!=0 {
  troy.flags24|=(u32::from(pending.flags144&1!=0)<<4)|(u32::from(pending.flags144&2!=0)<<1)|(u32::from(pending.flags144&4!=0)<<5);
  troy.dirty144|=0x800;
 }
 troy.scalar5c=pending.scalar140;troy.dirty144|=4;
 if let Some(m)=matrix{troy.matrix_words=m;troy.dirty144|=0x20;}
 troy.scalar3c=0;troy.dirty144|=0x100;
 Ok(())
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches36_original_troy_constructor_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_constructor_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
 for (n,c) in cases.iter().enumerate(){let a=Troy::default();let e=&c["troy"];
 for(k,v) in [("flags24",a.flags24),("dirty144",a.dirty144),("scalar148",a.scalar148),("scalar5c",a.scalar5c),("scalar3c",a.scalar3c)]{assert_eq!(v,e[k].as_u64().unwrap() as u32,"case{n} {k}");}
 for i in 0..16{assert_eq!(a.matrix_words[i],e["matrix_words"][i].as_u64().unwrap() as u32,"case{n} matrix{i}");}
 }
 }
 #[test]
 fn matches192_original_live_factory_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/impact_effect_factory_live_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),192);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){
 let d=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);let mut a=Troy{flags24:0x80,dirty144:0,scalar148:0,scalar5c:0,scalar3c:0,..Troy::default()};configure(c["flags"].as_u64().unwrap() as u32,d,c["scalar180"].as_f64().unwrap() as f32,c["scalar140"].as_f64().unwrap() as f32,c["live"].as_bool().unwrap(),&mut a).unwrap();let e=&c["troy"];
 for(k,v) in [("flags24",a.flags24),("dirty144",a.dirty144),("scalar148",a.scalar148),("scalar5c",a.scalar5c),("scalar3c",a.scalar3c)]{assert_eq!(v,e[k].as_u64().unwrap() as u32,"case{n} {k}");}
 for i in 0..16{assert_eq!(a.matrix_words[i],e["matrix_words"][i].as_u64().unwrap() as u32,"case{n} matrix{i}");}
 }
 }
}
