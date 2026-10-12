from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''//! Registered original CA9026 FLS callback dispatch to the actual Rust destructor.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
pub const THREAD_DESTRUCTOR:u32=0xca9026;
/// Windows skips NULL data/callback. The provider must clear slot data before dispatch.
/// This dispatch is logical; a native OS ABI shim remains a separate provider obligation.
pub fn dispatch(callback:Option<u32>,value:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,s:&mut impl crate::audio_crt_thread_destructor::Services)->Result<(),Error>{
 if value==0||callback.is_none()||callback==Some(0){return Ok(());}
 if callback!=Some(THREAD_DESTRUCTOR){return Err(Error::Backend("unresolved FLS callback"));}
 crate::audio_crt_thread_destructor::destroy(m,dead,value,s)
}
''';(r/'crates/core/src/audio_crt_fls_callback.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_fls_callback;'not in s;p.write_text(s+'\npub mod audio_crt_fls_callback;\n',encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text(encoding='utf-8');old='freed:Vec<u32>}';assert old in s;s=s.replace(old,'freed:Vec<u32>,slot_callback:Option<u32>,callbacks:Vec<Value>}')
s=s.replace('freed:vec![]}','freed:vec![],slot_callback:None,callbacks:vec![]}')
needle='let result=if self.failure=="slot"{u32::MAX}else{5};';assert needle in s;s=s.replace(needle,'self.slot_callback=callback;'+needle,1)
old='assert_eq!(self.tls,0,"live FLS callback requires actual destructor execution");self.emit(if function==0{"TlsFree"}else{"FlsFree"},json!([index]),1,m,None);Ok(1)'
new='self.emit(if function==0{"TlsFree"}else{"FlsFree"},json!([index]),1,m,None);let value=self.tls;self.tls=0;if function!=0&&value!=0&&self.slot_callback.is_some(){let before=self.snapshot(m);crate::audio_crt_fls_callback::dispatch(self.slot_callback,value,m,_)?;let after=self.snapshot(m);self.callbacks.push(json!({"callback":self.slot_callback.unwrap(),"slot":index,"value":value,"slot_value_at_entry":0,"before":before,"after":after}));}Ok(1)'
# Name this method's dead-set parameter so it can be passed into the callback.
start=s.index('fn free_slot(');end=s.index('\n',start);part=s[start:end];assert old in part;part=part.replace('_:&mut BTreeSet<u32>','d:&mut BTreeSet<u32>').replace(old,new.replace('value,m,_','value,m,d'));s=s[:start]+part+s[end:]
s=s.rstrip();assert s.endswith('}');s=s[:-1]+r'''
 #[test]fn audio_crt_fls_slot_lifetime_matches36_original_full_tls_fls_live_cleared_detached_slot_cleanup_actual_destructor_callbacks_banks_and_allocation_lifetimes(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_fls_slot_lifetime_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],36);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:row["layout"].as_str().unwrap().into(),failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![],slot_callback:None,callbacks:vec![]};assert_eq!(initialize(&mut m,&mut d,&mut api).unwrap(),1);assert_eq!(api.snapshot(&m),row["after_startup"],"complete original startup before slot teardown {i}");assert_eq!(api.calls.len()as u64,row["startup_call_count"].as_u64().unwrap());
 match row["state"].as_str().unwrap(){"live"=>{},"cleared"=>{assert_eq!(crate::audio_crt_tls_value_wrappers::set_value(&mut m,&mut d,5,0,&mut api).unwrap(),1);},"detached"=>crate::audio_crt_thread_destructor::detach(&mut m,&mut d,0,&mut api).unwrap(),_=>panic!("unknown native state")}
 assert_eq!(api.snapshot(&m),row["before_cleanup"],"all canonical pre-cleanup regions {i}");assert_eq!(api.tls as u64,row["tls_value_before_cleanup"].as_u64().unwrap());cleanup(&mut m,&mut d,&mut api).unwrap();assert_eq!(json!(api.calls),row["calls"],"every original import/free entry including real Rust destructor called from slot-free {i}");let mut expected=row["callbacks"].clone();for v in expected.as_array_mut().unwrap(){assert_eq!(v["callback_stack_delta"],8,"native originalstdcall frame proof only; not a Rust ABI assertion");v.as_object_mut().unwrap().remove("callback_stack_delta");}assert_eq!(json!(api.callbacks),expected,"registered callback identity and all original entry/exit banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all33 final canonical regions {i}");assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(json!(api.freed),row["freed"],"original live FLS frees context; live TLS/cleared slot retain it {i}");assert_eq!(d,api.freed.iter().copied().filter(|r|*r!=0).collect());assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());}}
}
''';p.write_text(s,encoding='utf-8')
(r/'tools/integrate_audio_crt_fls_callback.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Integrated registered FLS destructor dispatch and36 original full slot lifetime comparisons')
