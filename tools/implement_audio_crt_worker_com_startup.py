from pathlib import Path
r=Path('E:/OpenLeague')
s='''//! Original CABDA8 package cache, C9C384 COM initializer and C9C439 worker stage.
use std::collections::{BTreeMap,BTreeSet};use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use crate::audio_path_source_virtual_cleanup::{get,put,live};
#[derive(Debug,Clone,Copy)]pub struct PackageQuery{pub result:u32,pub length:u32}
pub trait Services:crate::audio_crt_worker_exit::ComServices{
 fn current_package_id(&mut self,function:u32,initial_length:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<PackageQuery,Error>;
 fn invoke_ro_initialize(&mut self,function:u32,kind:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
}
pub fn package_state(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<u32,Error>{
 let mut cached=get(m,d,0x122343c,4)?;if(cached as i32)<0{let function=get(m,d,0x2da5374,4)?^get(m,d,0x1222ed0,4)?;cached=if function!=0{u32::from(s.current_package_id(function,0,m,d)?.result==122)}else{0};put(m,d,0x122343c,4,cached)?;}Ok(u32::from((cached as i32)>0))
}
pub fn initialize_com(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<u32,Error>{
 if get(m,d,0x14ae5fc,4)?==0{let module=s.load_library("combase.dll",0x800,m,d)?;let procedure=s.procedure(module,"RoInitialize",m,d)?;if procedure==0{return Ok(0);}let encoded=s.encode(procedure,m,d)?;put(m,d,0x14ae5f8,4,encoded)?;put(m,d,0x14ae5fc,4,1)?;}
 let function=s.decode(get(m,d,0x14ae5f8,4)?,m,d)?;Ok(u32::from(s.invoke_ro_initialize(function,1,m,d)?==0))
}
/// The source flag uses exact zero HRESULT, independently of runtime ownership
/// tracking for all nonnegative HRESULT values (including S_FALSE).
pub fn prepare_worker(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,record:u32,s:&mut impl Services)->Result<u32,Error>{
 live(m,d,record,956)?;let package=package_state(m,d,s)?;put(m,d,record+0x3b4,4,package)?;let flag=if package!=0{let flag=initialize_com(m,d,s)?;put(m,d,record+0x3b4,4,flag)?;flag}else{0};Ok(flag)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{cfg:Value,regions:Vec<(String,u32,usize)>,calls:Vec<Value>}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,a,z)in &self.regions{out[n]=json!(crate::audio_path_memory::read(m,*a,*z).unwrap().iter().map(|v|format!("{v:02x}")).collect::<String>());}out}fn emit(&mut self,n:&str,args:Value,result:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":n,"arguments":args,"result":result,"at_call":self.snapshot(m)}));}}
 impl crate::audio_crt_worker_exit::ComServices for Api{
  fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.cfg["module"].as_u64().unwrap()as u32;self.emit("LoadLibraryExW",json!([n,0,f]),result,m);Ok(result)}
  fn procedure(&mut self,r:u32,n:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=if r!=0&&self.cfg["available"]==true{0x40029100}else{0};self.emit("GetProcAddress",json!([r,n]),result,m);Ok(result)}
  fn encode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=r^0x13572468;self.emit("EncodePointer",json!([r]),result,m);Ok(result)}
  fn decode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=r^0x13572468;self.emit("DecodePointer",json!([r]),result,m);Ok(result)}
  fn invoke_ro_uninitialize(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{panic!("initializer never invokes release")}
 }
 impl Services for Api{
  fn current_package_id(&mut self,f:u32,length:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<PackageQuery,Error>{assert_eq!((f,length),(0x40029000,0));let result=self.cfg["package_result"].as_u64().unwrap()as u32;let length=self.cfg["length"].as_u64().unwrap()as u32;self.emit("GetCurrentPackageId",json!([0,0]),result,m);self.calls.last_mut().unwrap()["supplied_length"]=json!(length);Ok(PackageQuery{result,length})}
  fn invoke_ro_initialize(&mut self,f:u32,kind:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!((f,kind),(0x40029100,1));let result=self.cfg["hresult"].as_u64().unwrap()as u32;self.emit("RoInitialize",json!([kind]),result,m);Ok(result)}
 }
 #[test]fn audio_crt_worker_com_startup_matches566_original_signed_package_cache_exact122_detection_ro_initialize_cache_strict_zero_hresult_and_worker_flag_entry_banks(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_com_startup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],566);
  for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{cfg:row["config"].clone(),regions,calls:vec![]};let result=match api.cfg["kind"].as_str().unwrap(){"package"=>package_state(&mut m,&mut d,&mut api),"com"=>initialize_com(&mut m,&mut d,&mut api),"stage"=>prepare_worker(&mut m,&mut d,0x40012000,&mut api),_=>panic!("invalid kind")}.unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native flag {i}");assert_eq!(json!(api.calls),row["calls"],"all native entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all native final banks {i}");assert!(d.is_empty());}
 }
}
'''
(r/'crates/core/src/audio_crt_worker_com_startup.rs').write_text(s,encoding='utf-8');p=r/'crates/core/src/lib.rs';s=p.read_text();assert 'pub mod audio_crt_worker_com_startup;'not in s;p.write_text(s+'\npub mod audio_crt_worker_com_startup;\n',encoding='utf-8');(r/'tools/implement_audio_crt_worker_com_startup.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Original package/COM/worker flag producers ported;566-case native full-bank test added')
