from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/native_troy_resource_initial.rs';s=p.read_text(encoding='utf-8')
new='''
/// Qualified93E5D0 fields; matrix reset and runtime clock producer are separate.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Started {
 pub clock_words:[u32;3],pub offset_words:u32,pub previous_words:[u32;3],pub position_words:[u32;3],
 pub minimum_words:[u32;3],pub maximum_words:[u32;3],
}
pub fn start(clock:f32,offset:f32,radius:f32)->Result<Started,&'static str>{
 if !clock.is_finite() || !offset.is_finite(){return Err("nonfinite effect clock is unqualified");}
 let age_origin=clock-offset;if !age_origin.is_finite(){return Err("effect clock overflow");}
 let initial=empty_instance(0,[0;3],radius)?;
 Ok(Started {clock_words:[age_origin.to_bits();3],offset_words:0,previous_words:[0;3],position_words:[0;3],minimum_words:initial.minimum_words,maximum_words:initial.maximum_words})
}
'''
assert 'pub struct Started' not in s;s=s.replace('#[cfg(test)]',new+'\n#[cfg(test)]',1)
marker=' #[test]\n fn matches36_original_resource_instance_constructor_executions()'
test=''' #[test]
 fn matches288_original_start_time_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_start_time_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),288);
 for (n,c) in cases.iter().enumerate(){let f=|k:&str|f32::from_bits(c[k].as_u64().unwrap() as u32);let a=start(f("clock_words"),f("offset_words"),f("radius_words")).unwrap();let e=&c["result"];
 assert_eq!(a.offset_words,e["offset_words"].as_u64().unwrap() as u32,"case{n} offset");
 for(k,v) in [("clock_words",a.clock_words),("previous_words",a.previous_words),("position_words",a.position_words),("minimum_words",a.minimum_words),("maximum_words",a.maximum_words)]{for i in 0..3{assert_eq!(v[i],e[k][i].as_u64().unwrap() as u32,"case{n} {k}{i}");}}
 }
 }
'''
assert marker in s;s=s.replace(marker,test+marker);p.write_text(s,encoding='utf-8')
