from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''//! Original CA9026 destructor, CA8B6F locale release and CA915B detach caller.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
use crate::audio_path_source_virtual_cleanup::{get,put};
pub trait Services:Windows{
 fn destroy_locale(&mut self,_reference:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("original custom locale destructor required"))}
}
fn decrement(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,a:u32)->Result<u32,Error>{let v=get(m,d,a,4)?.wrapping_sub(1);put(m,d,a,4,v)?;Ok(v)}
/// Native reference operations preserve unsigned wrap and pointer aliases.
pub fn release_locale(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,locale:u32)->Result<(),Error>{if locale==0{return Ok(());}decrement(m,d,locale)?;for offset in[0x78,0x80,0x7c,0x88]{let r=get(m,d,locale+offset,4)?;if r!=0{decrement(m,d,r)?;}}for j in 0..6{let a=locale+0x1c+j*16;if get(m,d,a-8,4)?!=0x12230d4{let r=get(m,d,a,4)?;if r!=0{decrement(m,d,r)?;}}if get(m,d,a-12,4)?!=0{let r=get(m,d,a-4,4)?;if r!=0{decrement(m,d,r)?;}}}let r=get(m,d,locale+0x9c,4)?.wrapping_add(0xb0);decrement(m,d,r)?;Ok(())}
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,reference:u32,s:&mut impl Services)->Result<(),Error>{s.free_thread(reference,m,d)?;if reference!=0{d.insert(reference);}Ok(())}
pub fn destroy(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,record:u32,s:&mut impl Services)->Result<(),Error>{
 if record==0{return Ok(());}
 for off in[0x24,0x2c,0x34,0x3c,0x40,0x44,0x48]{let reference=get(m,d,record+off,4)?;if reference!=0{free(m,d,reference,s)?;}}
 let exception=get(m,d,record+0x5c,4)?;if exception!=0x106b708{free(m,d,exception,s)?;}
 crate::audio_crt_thread_context::lock(m,d,13,true,s)?;
 let mb=get(m,d,record+0x68,4)?;if mb!=0&&decrement(m,d,mb)?==0&&mb!=0x1222bb0{free(m,d,mb,s)?;}
 crate::audio_crt_thread_context::lock(m,d,13,false,s)?;
 crate::audio_crt_thread_context::lock(m,d,12,true,s)?;
 let locale=get(m,d,record+0x6c,4)?;if locale!=0{release_locale(m,d,locale)?;if locale!=get(m,d,0x122323c,4)?&&locale!=0x1223240&&get(m,d,locale,4)?==0{s.destroy_locale(locale,m,d)?;}}
 crate::audio_crt_thread_context::lock(m,d,12,false,s)?;free(m,d,record,s)
}
pub fn detach(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,record:u32,s:&mut(impl Services+crate::audio_crt_tls_value_wrappers::Services))->Result<(),Error>{
 let mut index=get(m,d,0x12230cc,4)?;if index==u32::MAX{return Ok(());}let mut r=record;
 if r==0{r=crate::audio_crt_tls_value_wrappers::get_value(m,d,index,s)?;index=get(m,d,0x12230cc,4)?;}
 let _=crate::audio_crt_tls_value_wrappers::set_value(m,d,index,0,s)?;destroy(m,d,r,s)
}
'''
(r/'crates/core/src/audio_crt_thread_destructor.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_context.rs';s=p.read_text(encoding='utf-8');assert 'fn lock(m:'in s;p.write_text(s.replace('fn lock(m:','pub(crate) fn lock(m:',1),encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_thread_destructor;'not in s;p.write_text(s+'\npub mod audio_crt_thread_destructor;\n',encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text(encoding='utf-8');s=s.rstrip();assert s.endswith('}');s=s[:-1]+r'''
 impl crate::audio_crt_thread_destructor::Services for Api{}
 #[test]fn audio_crt_thread_lifecycle_matches72_original_startup_detach_actual_destructor_locale_release_system_cleanup_all_intermediate_banks_and_physical_lifetimes(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_thread_lifecycle_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:row["layout"].as_str().unwrap().into(),failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![]};let result=initialize(&mut m,&mut d,&mut api).unwrap();assert_eq!(result as u64,row["startup_result"].as_u64().unwrap());assert_eq!(api.snapshot(&m),row["after_startup"],"complete startup bank {i}");assert_eq!(api.calls.len()as u64,row["startup_call_count"].as_u64().unwrap());api.last=row["saved_error"].as_u64().unwrap()as u32;
 let record=if row["explicit_record"].as_bool().unwrap(){0x40012000}else{0};crate::audio_crt_thread_destructor::detach(&mut m,&mut d,record,&mut api).unwrap();assert_eq!(api.snapshot(&m),row["after_detach"],"all33 canonical regions after actual reference release/destruction {i}");assert_eq!(api.calls.len()as u64,row["detach_call_count"].as_u64().unwrap());assert_eq!(api.tls as u64,row["detach_tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["detach_last_error"].as_u64().unwrap());cleanup(&mut m,&mut d,&mut api).unwrap();assert_eq!(json!(api.calls),row["calls"],"every original allocator/Windows entry and full bank in entire lifetime {i}");assert_eq!(api.snapshot(&m),row["after"],"complete final canonical bank {i}");assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(json!(api.freed),row["freed"]);assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,BTreeSet::from([0x40012000]),"exactly the allocated context is retired {i}");}}
 #[test]fn audio_crt_optional_thread_buffers_matches126_original_ordered_strings_null_exception_wrapped_multibyte_reference_static_retention_and_all_native_ownership_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_optional_thread_buffers_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],126);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let storage=m.remove(&0x40007000).unwrap();assert_eq!(storage.raw.len(),8*32);for j in 0..8{let reference=storage.reference+j as u32*32;m.insert(reference,Memory{reference,raw:storage.raw[j*32..j*32+32].to_vec()});}
 let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:row["layout"].as_str().unwrap().into(),failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![]};assert_eq!(initialize(&mut m,&mut d,&mut api).unwrap(),1);assert_eq!(api.snapshot(&m),row["after_startup"],"native startup and optional storage initial bank {i}");assert_eq!(api.calls.len()as u64,row["startup_call_count"].as_u64().unwrap());
 // Explicit controlled state changes are captured between startup/destruction.
 Api::fill(&mut m,&d,0x40007000,32,0xa5).unwrap();for j in 1..8{Api::fill(&mut m,&d,0x40007000+j*32,32,0xa5).unwrap();}let mode=row["multibyte"].as_str().unwrap();let count=match mode{"custom1"=>1,"custom2"=>2,"customMAX"=>u32::MAX,_=>0};put(&mut m,&d,0x40010000,4,count).unwrap();
 for(j,off)in[0x24,0x2c,0x34,0x3c,0x40,0x44,0x48].into_iter().enumerate(){let reference=if row["strings"]=="all"||(row["strings"]=="alternating"&&j%2==0){0x40007000+j as u32*32}else{0};put(&mut m,&d,0x40012000+off,4,reference).unwrap();}
 let exception=if row["exception"]=="static"{0x106b708}else if row["exception"]=="null"{0}else{0x40007000+7*32};put(&mut m,&d,0x40012000+0x5c,4,exception).unwrap();if mode=="null"{put(&mut m,&d,0x40012000+0x68,4,0).unwrap();}else if mode=="static1"{put(&mut m,&d,0x1222bb0,4,1).unwrap();}else if mode.starts_with("custom"){put(&mut m,&d,0x40012000+0x68,4,0x40010000).unwrap();}
 assert_eq!(api.snapshot(&m),row["before_detach"],"every supplied optional pointer/refcount and complete pre-destruction bank {i}");crate::audio_crt_thread_destructor::detach(&mut m,&mut d,0x40012000,&mut api).unwrap();assert_eq!(json!(api.calls),row["calls"],"exact original free(NULL)/string/critical section/refcount order and full entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all52 canonical regions including retained static MB buffer {i}");assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(json!(api.freed),row["freed"]);assert_eq!(d,api.freed.iter().copied().filter(|r|*r!=0).collect(),"only actual nonNULL freed allocation identities {i}");assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());}}
}
'''
p.write_text(s,encoding='utf-8')
(r/'tools/implement_audio_crt_thread_destruction.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Implemented actual thread detach/destructor and locale release;72 full lifetime+126 optional ownership comparisons')
