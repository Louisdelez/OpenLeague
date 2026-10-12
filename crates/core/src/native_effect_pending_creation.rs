//!751BE0 pending-wrapper profile: flags8, zero direction and no linked Troy.
//!Resource resolution/allocation and live effects are separate backend obligations.
#[derive(Debug)]
pub struct Pending {pub flags144:u32,pub scalar180:u32,pub scalar140:u32,pub secondary_words:[u32;3],pub secondary_active:bool,pub flag130:bool}
pub fn configure(flags:u32,scalar180:f32,scalar140:f32,secondary:[f32;3])->Result<Pending,&'static str>{
 if flags&8==0 || flags&!0xb9!=0 {return Err("unqualified effect creation flags");}
 if !secondary.into_iter().chain([scalar180,scalar140]).all(f32::is_finite){return Err("unqualified pending effect fields");}
 let flags144=u32::from(flags&0x10==0)|(u32::from(flags&0x20!=0)<<1)|(u32::from(flags&0x80!=0)<<2);
 Ok(Pending{flags144,scalar180:scalar180.to_bits(),scalar140:scalar140.to_bits(),secondary_words:secondary.map(f32::to_bits),secondary_active:true,flag130:flags&1!=0})
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches192_original_pending_factory_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/impact_effect_factory_pending_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),192);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){
 let v=std::array::from_fn(|i|c["secondary_position"][i].as_f64().unwrap() as f32);
 let a=configure(c["flags"].as_u64().unwrap() as u32,c["scalar180"].as_f64().unwrap() as f32,c["scalar140"].as_f64().unwrap() as f32,v).unwrap();let e=&c["state"];
 assert_eq!(a.flags144,e["flags144"].as_u64().unwrap() as u32,"case{n}");assert_eq!(a.scalar180,e["scalar180"].as_u64().unwrap() as u32,"case{n}");assert_eq!(a.scalar140,e["scalar140"].as_u64().unwrap() as u32,"case{n}");assert_eq!(a.secondary_active,e["secondary_active"].as_bool().unwrap());assert_eq!(a.flag130,e["flag130"].as_bool().unwrap());
 for i in 0..3{assert_eq!(a.secondary_words[i],e["secondary_words"][i].as_u64().unwrap() as u32,"case{n} axis{i}");}
 }
 }
}
