//! Native B260B0/B26140/B260C0 owned device factory and raw constructors.
//! Hardware/fallback configuration and device Term bodies are mandatory services.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use std::collections::BTreeMap;
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services{
 fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>;
 fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
 fn configure_modern(&mut self,memory:&mut Memory,configuration:u32,mask:u32,kind:u32)->Result<u32,Error>;
 fn configure_legacy(&mut self,memory:&mut Memory,configuration:u32,mask:u32)->Result<u32,Error>;
 fn configure_fallback(&mut self,memory:&mut Memory,mask:u32)->Result<u32,Error>;
 fn term(&mut self,memory:&mut Memory)->Result<(),Error>;
}
#[derive(Debug)]pub struct Outputs{pub memory:Memory,pub count:u32}
#[derive(Debug,Default)]pub struct Runtime{pub objects:BTreeMap<u32,Memory>,pub legacy_handle:u32}
impl Runtime{
 fn allocate(&mut self,kind:u32,pool:u32,services:&mut impl Services)->Result<Option<u32>,Error>{
  let size=match kind{1=>108,2=>68,3=>44,_=>return Err(Error::Backend("unqualified device constructor"))};let Some(mut memory)=services.allocate_pool(pool,size)?else{return Ok(None);};if memory.reference==0||memory.raw.len()!=size as usize||self.objects.contains_key(&memory.reference){return Err(Error::InvalidAllocation);}
  for offset in [4,8,12]{set(&mut memory.raw,offset,0);}set(&mut memory.raw,0x1c,kind);
  match kind{
   1=>{set(&mut memory.raw,0,0xff2de0);set(&mut memory.raw,0x20,0xff2e14);set(&mut memory.raw,0x24,0xff2e20);for o in (0x28..=0x68).step_by(4){set(&mut memory.raw,o,0);}},
   2=>{set(&mut memory.raw,0,0xff2d78);self.legacy_handle=0;for o in (0x24..=0x3c).step_by(4){set(&mut memory.raw,o,0);}memory.raw[0x42]=0;},
   3=>set(&mut memory.raw,0,0xff25b0),_=>unreachable!()
  }
  let reference=memory.reference;self.objects.insert(reference,memory);Ok(Some(reference))
 }
 fn cleanup(&mut self,reference:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  let memory=self.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?;services.term(memory)?;
  self.destroy_zero(reference)?;let memory=self.objects.get(&reference).unwrap();services.free_pool(pool,memory)?;self.objects.remove(&reference);Ok(())
 }
 fn destroy_zero(&mut self,reference:u32)->Result<(),Error>{
  let memory=self.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if memory.raw.len()<4{return Err(Error::Truncated);}
  // Native scalar deleting destructors with flags0 do not deallocate themselves.
  match word(&memory.raw,0){0xff2de0=>{if memory.raw.len()<40{return Err(Error::Truncated);}set(&mut memory.raw,0x20,0xff2e14);set(&mut memory.raw,0x24,0xff2e20);},0xff2d78|0xff25b0=>{},_=>return Err(Error::Backend("unqualified device destructor"))}
  set(&mut memory.raw,0,0xff2584);Ok(())
 }
 /// B0FB40 now creates devices through this same owned factory/runtime. Device
 /// virtual bodies and switching remain mandatory explicit implementations.
 pub fn quota(&mut self,scheduler:&mut crate::audio_frame_quota::Scheduler,backend:&mut impl Control)->Result<u32,Error>{
  let mut devices=QuotaDevices{runtime:self,pool:scheduler.pool,current:scheduler.device,backend};scheduler.quota(&mut devices)
 }
 /// B0C270 selects the first matching pair in the56-byte output table.
 /// Term/destructor/free precede publication. Null old devices fault in the
 /// native Term call; owned unresolved/null references produce explicit errors.
 pub fn switch(&mut self,outputs:&mut Outputs,first:u32,second:u32,reference:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
  let size=(outputs.count as usize).checked_mul(56).ok_or(Error::InvalidAllocation)?;if outputs.memory.raw.len()<size||(outputs.count!=0&&outputs.memory.reference==0){return Err(Error::InvalidAllocation);}
  for index in 0..outputs.count as usize{let offset=index*56;if word(&outputs.memory.raw,offset+16)==first&&word(&outputs.memory.raw,offset+20)==second{let old=word(&outputs.memory.raw,offset+4);if old==0{return Err(Error::UnresolvedReference);}self.cleanup(old,pool,services)?;set(&mut outputs.memory.raw,offset+4,reference);return Ok(1);}}
  Ok(2)
 }
 pub fn quota_with_outputs(&mut self,scheduler:&mut crate::audio_frame_quota::Scheduler,outputs:&mut Outputs,backend:&mut impl Virtual)->Result<u32,Error>{
  let mut switching=Switching{outputs,pool:scheduler.pool,backend};self.quota(scheduler,&mut switching)
 }
 /// Kind0 tries modern then legacy only after configuration failure. An
 /// allocation failure returns null immediately. Kind3 updates settings+4
 /// from the prior device mask (or3) before attempting its own allocation.
 pub fn create(&mut self,settings:&mut Memory,kind:u32,_flags:u32,current:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
  if settings.reference==0||settings.raw.len()<8{return Err(Error::Truncated);}
  if kind==0||kind==1{
   let Some(reference)=self.allocate(1,pool,services)?else{return Ok(0);};let status=services.configure_modern(self.objects.get_mut(&reference).unwrap(),0x14a7d10,word(&settings.raw,4),kind)?;if status==1{return Ok(reference);}self.cleanup(reference,pool,services)?;
  }
  if kind==0||kind==2{
   let Some(reference)=self.allocate(2,pool,services)?else{return Ok(0);};let status=services.configure_legacy(self.objects.get_mut(&reference).unwrap(),0x14a7d10,word(&settings.raw,4))?;if status==1{return Ok(reference);}self.cleanup(reference,pool,services)?;
  }
  if kind==3{
   if word(&settings.raw,4)==0{let mask=if current==0{3}else{let old=self.objects.get(&current).ok_or(Error::UnresolvedReference)?;if old.raw.len()<12{return Err(Error::Truncated);}word(&old.raw,8)};set(&mut settings.raw,4,mask);}
   let Some(reference)=self.allocate(3,pool,services)?else{return Ok(0);};let status=services.configure_fallback(self.objects.get_mut(&reference).unwrap(),word(&settings.raw,4))?;if status==1{return Ok(reference);}self.cleanup(reference,pool,services)?;
  }
  Ok(0)
 }
}
/// Shared-object device operations required by the factory/quota producer.
/// Switching receives the graph/current device so a real implementation can
/// perform its native ownership changes rather than discard old objects silently.
pub trait Virtual:Services{
 fn init_device(&mut self,memory:&mut Memory)->Result<u32,Error>;
 fn device_quota(&mut self,memory:&mut Memory,output:&mut u32)->Result<u32,Error>;
}
pub trait Control:Virtual{
 fn switch_device(&mut self,runtime:&mut Runtime,current:u32,first:u32,second:u32,reference:u32)->Result<(),Error>;
}
struct Switching<'a,S>{outputs:&'a mut Outputs,pool:u32,backend:&'a mut S}
impl<S:Virtual> Services for Switching<'_,S>{
 fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.backend.allocate_pool(pool,size)}
 fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.backend.free_pool(pool,m)}
 fn configure_modern(&mut self,m:&mut Memory,c:u32,mask:u32,kind:u32)->Result<u32,Error>{self.backend.configure_modern(m,c,mask,kind)}
 fn configure_legacy(&mut self,m:&mut Memory,c:u32,mask:u32)->Result<u32,Error>{self.backend.configure_legacy(m,c,mask)}
 fn configure_fallback(&mut self,m:&mut Memory,mask:u32)->Result<u32,Error>{self.backend.configure_fallback(m,mask)}
 fn term(&mut self,m:&mut Memory)->Result<(),Error>{self.backend.term(m)}
}
impl<S:Virtual> Virtual for Switching<'_,S>{
 fn init_device(&mut self,m:&mut Memory)->Result<u32,Error>{self.backend.init_device(m)}
 fn device_quota(&mut self,m:&mut Memory,out:&mut u32)->Result<u32,Error>{self.backend.device_quota(m,out)}
}
impl<S:Virtual> Control for Switching<'_,S>{
 fn switch_device(&mut self,runtime:&mut Runtime,_current:u32,first:u32,second:u32,reference:u32)->Result<(),Error>{runtime.switch(self.outputs,first,second,reference,self.pool,self.backend)?;Ok(())}
}
struct QuotaDevices<'a,S>{runtime:&'a mut Runtime,pool:u32,current:u32,backend:&'a mut S}
impl<S:Control> crate::audio_frame_quota::Devices for QuotaDevices<'_,S>{
 fn create(&mut self,settings:&mut Memory,kind:u32,flags:u32,current:u32)->Result<u32,Error>{self.current=current;self.runtime.create(settings,kind,flags,current,self.pool,self.backend)}
 fn init(&mut self,reference:u32)->Result<u32,Error>{self.backend.init_device(self.runtime.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?)}
 fn switch(&mut self,first:u32,second:u32,reference:u32)->Result<(),Error>{self.backend.switch_device(self.runtime,self.current,first,second,reference)?;self.current=reference;Ok(())}
 fn term(&mut self,reference:u32)->Result<(),Error>{self.backend.term(self.runtime.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?)}
 fn destroy(&mut self,reference:u32,flags:u32)->Result<(),Error>{if flags!=0{return Err(Error::Backend("device deleting-destructor allocator required"));}self.runtime.destroy_zero(reference)}
 fn free_pool(&mut self,pool:u32,reference:u32)->Result<(),Error>{let memory=self.runtime.objects.get(&reference).ok_or(Error::UnresolvedReference)?;self.backend.free_pool(pool,memory)?;self.runtime.objects.remove(&reference);Ok(())}
 fn quota(&mut self,reference:u32,output:&mut u32)->Result<u32,Error>{self.backend.device_quota(self.runtime.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?,output)}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{profile:String,pattern:u8,failure:u32,nth:u32,next:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,allocated:Vec<u32>}
 impl Backend{fn configure(&mut self,memory:&mut Memory,entry:&str,args:Vec<u32>,mask:u32)->Result<u32,Error>{let failure=match entry{"modern"=>self.profile=="modern_fail"||self.profile=="both_fail","legacy"=>self.profile=="legacy_fail"||self.profile=="both_fail","fallback"=>self.profile=="fallback_fail",_=>unreachable!()};let status=if failure{52}else{1};set(&mut memory.raw,8,mask);self.calls.push(json!({"kind":"configure_device","entry":entry,"reference":memory.reference,"args":args,"status":status}));Ok(status)}}
 impl Services for Backend{
  fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let reference=if self.nth==self.failure{0}else{self.next};self.calls.push(json!({"kind":"allocate","method":"pool","allocator":pool,"size":size,"reference":reference}));if reference==0{return Ok(None);}self.next+=512;self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
  fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":memory.reference}));assert!(self.freed.insert(memory.reference,memory.clone()).is_none());Ok(())}
  fn configure_modern(&mut self,m:&mut Memory,c:u32,mask:u32,kind:u32)->Result<u32,Error>{self.configure(m,"modern",vec![c,mask,kind],mask)}
  fn configure_legacy(&mut self,m:&mut Memory,c:u32,mask:u32)->Result<u32,Error>{self.configure(m,"legacy",vec![c,mask],mask)}
  fn configure_fallback(&mut self,m:&mut Memory,mask:u32)->Result<u32,Error>{self.configure(m,"fallback",vec![mask],mask)}
  fn term(&mut self,m:&mut Memory)->Result<(),Error>{self.calls.push(json!({"kind":"term_device","reference":m.reference}));Ok(())}
 }
 struct Composition{factory:Backend,status:u32,written:Option<u32>}
 impl Services for Composition{
  fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.factory.allocate_pool(pool,size)}
  fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.factory.free_pool(pool,m)}
  fn configure_modern(&mut self,m:&mut Memory,c:u32,mask:u32,kind:u32)->Result<u32,Error>{self.factory.configure_modern(m,c,mask,kind)}
  fn configure_legacy(&mut self,m:&mut Memory,c:u32,mask:u32)->Result<u32,Error>{self.factory.configure_legacy(m,c,mask)}
  fn configure_fallback(&mut self,m:&mut Memory,mask:u32)->Result<u32,Error>{self.factory.configure_fallback(m,mask)}
  fn term(&mut self,m:&mut Memory)->Result<(),Error>{self.factory.term(m)}
 }
 impl Virtual for Composition{
  fn init_device(&mut self,m:&mut Memory)->Result<u32,Error>{self.factory.calls.push(json!({"kind":"init_device","reference":m.reference,"status":1}));Ok(1)}
  fn device_quota(&mut self,m:&mut Memory,output:&mut u32)->Result<u32,Error>{if let Some(value)=self.written{*output=value;}self.factory.calls.push(json!({"kind":"device_quota","reference":m.reference,"status":self.status,"quota_written":self.written}));Ok(self.status)}
 }
 impl Control for Composition{
  fn switch_device(&mut self,runtime:&mut Runtime,current:u32,first:u32,second:u32,reference:u32)->Result<(),Error>{assert!(runtime.objects.contains_key(&current));assert!(runtime.objects.contains_key(&reference));self.factory.calls.push(json!({"kind":"switch_device","first":first,"second":second,"reference":reference}));Ok(())}
 }
 #[test]fn audio_device_factory_quota_matches1536_native_shared_ownership_and_mutable_settings_sequences(){replay_quota(include_str!("../../../data/4.20/audio_device_factory_quota_preparation.json"));}
 #[test]fn audio_device_factory_quota_switch_matches1536_native_output_table_retirement_compositions(){replay_quota(include_str!("../../../data/4.20/audio_device_factory_quota_switch_preparation.json"));}
 fn replay_quota(source:&str){
  let proof:Value=serde_json::from_str(source).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1536);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let initial=b["allocations"].as_array().unwrap();let mut runtime=Runtime{legacy_handle:b["legacy_handle"].as_u64().unwrap()as u32,objects:initial.iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect()};let mut scheduler=crate::audio_frame_quota::Scheduler{retry:b["retry"].as_u64().unwrap()as u32,device:b["device"].as_u64().unwrap()as u32,changed:b["changed"].as_u64().unwrap()as u8,device_kind:row["kind"].as_u64().unwrap()as u32,settings:Memory{reference:0x14a79f8,raw:bytes(b["settings"].as_str().unwrap())},pool:row["pool"].as_u64().unwrap()as u32};let mut backend=Composition{factory:Backend{profile:row["profile"].as_str().unwrap().into(),pattern:row["pattern"].as_u64().unwrap()as u8,failure:0,nth:0,next:row["next_allocation"].as_u64().unwrap_or(0x3000d000)as u32,calls:vec![],freed:BTreeMap::new(),allocated:vec![]},status:row["quota_status"].as_u64().unwrap()as u32,written:row["quota_written"].as_u64().map(|v|v as u32)};let mut outputs=if row["native_output_switch"]==true{Some(Outputs{memory:Memory{reference:b["table_reference"].as_u64().unwrap()as u32,raw:bytes(b["table"].as_str().unwrap())},count:b["table_count"].as_u64().unwrap()as u32})}else{None};let quota=if let Some(outputs)=outputs.as_mut(){runtime.quota_with_outputs(&mut scheduler,outputs,&mut backend)}else{runtime.quota(&mut scheduler,&mut backend)};assert_eq!(quota.unwrap()as u64,row["result"].as_u64().unwrap(),"quota {i}");assert_eq!(json!(backend.factory.calls),row["calls"],"complete producer call order {i}");let refs:Vec<u32>=initial.iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(backend.factory.allocated.iter().copied()).collect();let allocations:Vec<Value>=refs.iter().map(|reference|{let m=backend.factory.freed.get(reference).or_else(||runtime.objects.get(reference)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":backend.factory.freed.contains_key(reference),"raw":hex(&m.raw)})}).collect();let mut actual=json!({"retry":scheduler.retry,"device":scheduler.device,"changed":scheduler.changed,"settings":hex(&scheduler.settings.raw),"legacy_handle":runtime.legacy_handle,"allocations":allocations});if let Some(outputs)=outputs{actual["table"]=json!(hex(&outputs.memory.raw));actual["table_reference"]=json!(outputs.memory.reference);actual["table_count"]=json!(outputs.count);}assert_eq!(actual,row["after"],"shared device graph and all owned bytes {i}");
  }
 }
 #[test]fn audio_device_switch_matches384_native_output_table_first_match_and_retirement_cases(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_device_switch_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],384);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let initial=b["allocations"].as_array().unwrap();let mut runtime=Runtime{legacy_handle:0,objects:initial.iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect()};let mut outputs=Outputs{memory:Memory{reference:b["table_reference"].as_u64().unwrap()as u32,raw:bytes(b["table"].as_str().unwrap())},count:b["count"].as_u64().unwrap()as u32};let mut backend=Backend{profile:"ready".into(),pattern:row["pattern"].as_u64().unwrap()as u8,failure:0,nth:0,next:0x3000f000,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};assert_eq!(runtime.switch(&mut outputs,row["key"].as_u64().unwrap()as u32,row["second"].as_u64().unwrap()as u32,row["new_reference"].as_u64().unwrap()as u32,row["pool"].as_u64().unwrap()as u32,&mut backend).unwrap()as u64,row["result"].as_u64().unwrap(),"switch result {i}");assert_eq!(json!(backend.calls),row["calls"],"switch retirement order {i}");assert!(backend.allocated.is_empty());let allocations:Vec<Value>=initial.iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=backend.freed.get(&reference).or_else(||runtime.objects.get(&reference)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":backend.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!({"table":hex(&outputs.memory.raw),"table_reference":outputs.memory.reference,"count":outputs.count,"allocations":allocations}),row["after"],"full table and owned device bytes {i}");
  }
 }
 #[test]fn audio_device_factory_matches1200_native_constructor_settings_and_cleanup_sequences(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_device_factory_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1200);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let initial=b["allocations"].as_array().unwrap();let mut runtime=Runtime{legacy_handle:b["legacy_handle"].as_u64().unwrap()as u32,objects:initial.iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect()};let mut settings=Memory{reference:0x14a79f8,raw:bytes(b["settings"].as_str().unwrap())};let mut backend=Backend{profile:row["profile"].as_str().unwrap().into(),pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure_nth"].as_u64().unwrap()as u32,nth:0,next:0x3000d000,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};assert_eq!(runtime.create(&mut settings,row["kind"].as_u64().unwrap()as u32,0,row["current_device"].as_u64().unwrap()as u32,row["pool"].as_u64().unwrap()as u32,&mut backend).unwrap()as u64,row["result"].as_u64().unwrap(),"result {i}");assert_eq!(json!(backend.calls),row["calls"],"call order {i}");let refs:Vec<u32>=initial.iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(backend.allocated.iter().copied()).collect();let allocations:Vec<Value>=refs.iter().map(|reference|{let m=backend.freed.get(reference).or_else(||runtime.objects.get(reference)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":backend.freed.contains_key(reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!({"settings":hex(&settings.raw),"legacy_handle":runtime.legacy_handle,"allocations":allocations}),row["after"],"all owned settings/device bytes {i}");
  }
 }
}
