from pathlib import Path
r=Path('E:/OpenLeague')
s='''//! Qualified93DB40 / empty93DF20 initialization fields only.
//! Strings, containers, direction matrix, children and age producers remain separate.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Initial {
 pub source_flags:u32,pub scales:[u32;3],pub flags_1dc:u8,pub flags_1dd:u8,
 pub maximum_child_time:u32,pub aggregated_child_flags:u32,
 pub direction_words:[u32;3],pub minimum_words:[u32;3],pub maximum_words:[u32;3],
}
/// The original clears only secondary bit0; caller must supply the existing byte.
pub fn empty_instance(previous_secondary:u8,global_direction:[u32;3],radius:f32)->Result<Initial,&'static str>{
 if !radius.is_finite(){return Err("nonfinite resource radius is unqualified");}
 let extent=radius*f32::from_bits(0x3f3504f3);let lower=0.-extent;let upper=lower+extent*2.;
 Ok(Initial {source_flags:0,scales:[1f32.to_bits(),1f32.to_bits(),0],flags_1dc:0,flags_1dd:previous_secondary&0xfe,maximum_child_time:0,aggregated_child_flags:0,direction_words:global_direction,minimum_words:[lower.to_bits();3],maximum_words:[upper.to_bits();3]})
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches36_original_resource_instance_constructor_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_resource_instance_constructor_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
 for (n,c) in cases.iter().enumerate(){let a=empty_instance(c["memory_fill"].as_u64().unwrap() as u8,[1f32.to_bits(),0,0],c["radius"].as_f64().unwrap() as f32).unwrap();let e=&c["instance"];
 for(k,v) in [("source_flags",a.source_flags),("scale_bc",a.scales[0]),("scale_c0",a.scales[1]),("scale_c4",a.scales[2]),("flags_1dc",u32::from(a.flags_1dc)),("flags_1dd",u32::from(a.flags_1dd)),("maximum_child_time",a.maximum_child_time),("aggregated_child_flags",a.aggregated_child_flags)]{assert_eq!(v,e[k].as_u64().unwrap() as u32,"case{n} {k}");}
 for(k,v) in [("direction_words",a.direction_words),("minimum_words",a.minimum_words),("maximum_words",a.maximum_words)]{for i in 0..3{assert_eq!(v[i],e[k][i].as_u64().unwrap() as u32,"case{n} {k}{i}");}}
 }
 }
}
'''
(r/'crates/core/src/native_troy_resource_initial.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod native_troy_resource_initial;' not in s;p.write_text(s+'\npub mod native_troy_resource_initial;\n',encoding='utf-8')

