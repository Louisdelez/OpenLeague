//! Native617F10 target validity callback. Raw flags retain their native meaning.
pub fn valid(override_enabled:bool,mode:bool,field24:u8,field2c:u8,blocked5ea:u8,mut helper:impl FnMut()->bool)->bool {
 if override_enabled{return true;}
 let enabled=if mode {field24!=0 && helper()}else{field2c!=0 || field24!=0};
 enabled && blocked5ea&1==0
}
/// Native6B2C30: disabled mode and selector-1 bypass mask lookup;
/// selector-2 checks bits0/1, other selectors use x86 shift-count wrapping.
pub fn mask_valid(mode:bool,selector:i32,mask:u32)->bool {
 if !mode || selector == -1 {return true;}
 if selector == -2 {mask & 3 != 0} else {mask & 1u32.wrapping_shl(selector as u32) != 0}
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches3584_original_mask_and_validity_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/actor_target_mask_contract.json")).unwrap();
 let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),3584);
 for(n,c) in cases.iter().enumerate(){let b=|k:&str|c[k].as_bool().unwrap();let mut calls=Vec::new();
 if !b("override"){calls.push(b("mode"));}
 let a=valid(b("override"),b("mode"),u8::from(b("field24")),u8::from(b("field2c")),u8::from(b("blocked")),||{
  calls.push(b("helper_mode"));mask_valid(b("helper_mode"),c["selector"].as_i64().unwrap() as i32,c["mask"].as_u64().unwrap() as u32)
 });
 assert_eq!(a,b("valid"),"case{n}");assert_eq!(serde_json::json!(calls),c["mode_calls"],"case{n} mode call order");
 }
 }

 #[test]
 fn matches64_original_validity_callbacks(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/actor_target_validity_contract.json")).unwrap();
 let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),64);
 for(n,c) in cases.iter().enumerate(){let b=|k:&str|c[k].as_bool().unwrap();let mut calls=0;
 let a=valid(b("override"),b("mode"),u8::from(b("field24")),u8::from(b("field2c")),u8::from(b("blocked")),||{calls+=1;b("helper")});
 assert_eq!(a,b("valid"),"case{n}");assert_eq!(calls,c["calls"].as_array().unwrap().iter().filter(|x|x.as_str()==Some("helper")).count(),"case{n} helper calls");
 }
 }
}
