//! B12320 immediate finite RTPC values and class0 Meter notifications. Other classes/transitions remain required.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_rtpc_subscriber_release::{Manager,Record}};
use std::collections::{BTreeMap,BTreeSet};
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:crate::audio_effect_resource_bank::Services{fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>;
 /// Passive audit hook after concrete Meter SetParam execution; never substitutes its body.
 fn observe_meter_parameter(&mut self,_reference:u32,_id:u32,_bits:u32){}
}
pub fn set_value(manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,key:u32,bits:u32,owner:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{set_value_inner(manager,values,key,bits,owner,pool,services,false)}
fn set_value_inner(manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,key:u32,bits:u32,owner:u32,pool:u32,services:&mut impl Services,allow_subscribers:bool)->Result<u32,Error>{
 if !f32::from_bits(bits).is_finite(){return Err(Error::Backend("nonfinite RTPC output not qualified"));}
 let bucket=(key%193)as usize*4;let mut reference=word(&manager.raw,bucket);let mut seen=BTreeSet::new();
 while reference!=0{if !seen.insert(reference){return Err(Error::Backend("cyclic RTPC output hash"));}let r=manager.records.get(&reference).ok_or(Error::UnresolvedReference)?;if r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}if word(&r.memory.raw,0)==key{break;}reference=word(&r.memory.raw,4);}
 if reference==0{
  let Some(mut memory)=services.allocate_pool(pool,40)? else{return Ok(2);};if memory.reference==0||memory.raw.len()!=40{return Err(Error::InvalidAllocation);}memory.raw.fill(0);set(&mut memory.raw,0,key);set(&mut memory.raw,4,word(&manager.raw,bucket));reference=memory.reference;manager.records.insert(reference,Record{memory,subscribers:Memory{reference:0,raw:vec![]}});set(&mut manager.raw,bucket,reference);let count=word(&manager.raw,0x304).wrapping_add(1);set(&mut manager.raw,0x304,count);
 }
 let record=manager.records.get_mut(&reference).unwrap();if !allow_subscribers&&word(&record.memory.raw,32)!=0{return Err(Error::Backend("RTPC subscriber notification body required"));}
 let pointer=word(&record.memory.raw,12);let count=word(&record.memory.raw,16)as usize;let capacity=word(&record.memory.raw,20)as usize;
 if count>capacity{return Err(Error::InvalidAllocation);}let mut index=0;
 if pointer!=0{let v=values.get(&pointer).ok_or(Error::UnresolvedReference)?;if v.raw.len()<capacity*8{return Err(Error::InvalidAllocation);}while index<count&&word(&v.raw,index*8)<owner{index+=1;}if index<count&&word(&v.raw,index*8)==owner{if f32::from_bits(word(&v.raw,index*8+4))!=f32::from_bits(bits){set(&mut values.get_mut(&pointer).unwrap().raw,index*8+4,bits);}return Ok(1);}}
 let pointer=if count==capacity{
  let new_capacity=capacity.checked_add(8).ok_or(Error::InvalidAllocation)?;let Some(mut next)=services.allocate_pool(pool,(new_capacity*8)as u32)? else{return Ok(2);};if next.reference==0||next.raw.len()!=new_capacity*8{return Err(Error::InvalidAllocation);}
  if pointer!=0{let old=values.get(&pointer).ok_or(Error::UnresolvedReference)?;next.raw[..count*8].copy_from_slice(&old.raw[..count*8]);services.free_pool(pool,old)?;values.remove(&pointer);}
  let p=next.reference;values.insert(p,next);set(&mut record.memory.raw,12,p);set(&mut record.memory.raw,20,new_capacity as u32);p
 }else{pointer};
 let v=values.get_mut(&pointer).ok_or(Error::UnresolvedReference)?;v.raw.copy_within(index*8..count*8,(index+1)*8);set(&mut v.raw,index*8,owner);set(&mut v.raw,index*8+4,bits);set(&mut record.memory.raw,16,(count+1)as u32);Ok(1)
}
fn owner_value(record:&Record,values:&BTreeMap<u32,Memory>,owner:u32)->Result<Option<u32>,Error>{
 let count=word(&record.memory.raw,16)as usize;let capacity=word(&record.memory.raw,20)as usize;let pointer=word(&record.memory.raw,12);if count>capacity{return Err(Error::InvalidAllocation);}if pointer==0{return if count==0{Ok(None)}else{Err(Error::InvalidAllocation)};}let memory=values.get(&pointer).ok_or(Error::UnresolvedReference)?;if memory.raw.len()<capacity*8{return Err(Error::InvalidAllocation);}let mut low=0i64;let mut high=count as i64-1;while low<=high{let mid=low+(high-low)/2;let key=word(&memory.raw,mid as usize*8);if owner<key{high=mid-1;}else if owner>key{low=mid+1;}else{return Ok(Some(word(&memory.raw,mid as usize*8+4)));}}Ok(None)
}
/// Native B12200/B10780/B11850: notify before value storage. Class0 uses its
/// first curve, preserves adjacent duplicate suppression and owner fallback rules.
pub fn set_value_meter(manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,runtime:&mut crate::audio_meter_lifecycle::Runtime,key:u32,bits:u32,owner:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
 if !f32::from_bits(bits).is_finite(){return Err(Error::Backend("nonfinite RTPC output not qualified"));}
 if let Some(reference)=manager.find_record(key)?{let record=&manager.records[&reference];if word(&record.memory.raw,24)!=0{return Err(Error::Backend("RTPC transition removal body required"));}if owner_value(record,values,owner)?.is_some_and(|old|f32::from_bits(old)==f32::from_bits(bits)){return Ok(1);}let count=word(&record.memory.raw,32)as usize;let capacity=word(&record.memory.raw,36)as usize;if count>capacity||record.subscribers.raw.len()<capacity*4||word(&record.memory.raw,28)!=record.subscribers.reference{return Err(Error::InvalidAllocation);}let mut previous=0;
  for entry in record.subscribers.raw[..count*4].chunks_exact(4){let target=word(entry,0);if target==previous{continue;}previous=target;let binding=manager.bindings.get(&target).ok_or(Error::UnresolvedReference)?;if binding.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}let bound_owner=word(&binding.memory.raw,12);if owner!=bound_owner&&owner!=0&&bound_owner!=0{continue;}if word(&binding.memory.raw,16)!=0{return Err(Error::Backend("other RTPC setter subscriber classes require their native bodies"));}if owner!=bound_owner{if owner!=0{continue;}if owner_value(record,values,bound_owner)?.is_some(){continue;}}
   let n=word(&binding.memory.raw,24)as usize;if n==0||binding.curves.raw.len()<n*20||word(&binding.memory.raw,20)!=binding.curves.reference{return Err(Error::InvalidAllocation);}let first=&binding.curves.raw[..20];let n=word(first,12)as usize;let memory=binding.points.get(&word(first,8)).ok_or(Error::UnresolvedReference)?;if memory.raw.len()<n*12{return Err(Error::InvalidAllocation);}let points=memory.raw[..n*12].chunks_exact(12).map(|p|crate::audio_curves::Point{from:f32::from_bits(word(p,0)),to:f32::from_bits(word(p,4)),interp:word(p,8)}).collect();let curve=crate::audio_curves::Curve{scaling:word(first,16),points};let value=curve.evaluate(f32::from_bits(bits)).map_err(|_|Error::Backend("unqualified Meter setter curve evaluation"))?;
   let subscriber=word(&binding.memory.raw,0);let id=word(&binding.memory.raw,4)&0xffff;let object=runtime.objects.get_mut(&subscriber).ok_or(Error::UnresolvedReference)?;crate::audio_meter_lifecycle::set_parameter(object,id,&value.to_bits().to_le_bytes(),4)?;services.observe_meter_parameter(subscriber,id,value.to_bits());
  }
 }set_value_inner(manager,values,key,bits,owner,pool,services,true)
}
/// Deliver Meter measurements into owned RTPC storage. Callback registration and
/// physical lifetime operations remain the caller's services; no logical setter shim.
pub fn update_meter(runtime:&mut crate::audio_meter_lifecycle::Runtime,reference:u32,manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,pool:u32,backend:&mut (impl Services+crate::audio_meter_lifecycle::Update))->Result<(),Error>{
 let mut delivery=MeterDelivery{reference,manager,values,pool,backend};runtime.update(reference,&mut delivery)
}
/// Dispatch the qualified native callback loop against the shared Meter graph.
/// B3EBC0 does not consume its reason argument; other callback bodies stay explicit.
/// Whole audio-frame producers and device scheduling are separate from this loop.
pub fn dispatch_meter(registry:&mut crate::audio_callback_registry::Registry,reason:crate::audio_callback_registry::Reason,runtime:&mut crate::audio_meter_lifecycle::Runtime,reference:u32,manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,pool:u32,backend:&mut(impl Services+crate::audio_meter_lifecycle::Update))->Result<(),Error>{
 registry.dispatch(reason,|registry,key,_reason|{if key!=0xb3ed30{return Err(Error::Backend("unqualified audio callback body"));}let mut registered=crate::audio_callback_registry::MeterBackend{registry,pool,backend};update_meter(runtime,reference,manager,values,pool,&mut registered)})
}
struct MeterDelivery<'a,S>{reference:u32,manager:&'a mut Manager,values:&'a mut BTreeMap<u32,Memory>,pool:u32,backend:&'a mut S}
impl<S:Services+crate::audio_meter_lifecycle::Update> crate::audio_plugin_factory::Allocator for MeterDelivery<'_,S>{
 fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{self.backend.allocate(allocator,size)}
}
impl<S:Services+crate::audio_meter_lifecycle::Update> crate::audio_meter_lifecycle::Lifetime for MeterDelivery<'_,S>{
 fn free(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{self.backend.free(allocator,memory)}
 fn register_callback(&mut self,callback:u32)->Result<(),Error>{self.backend.register_callback(callback)}
}
impl<S:Services+crate::audio_meter_lifecycle::Update> crate::audio_meter_lifecycle::Update for MeterDelivery<'_,S>{
 fn set_rtpc(&mut self,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{
  if manager!=self.reference{return Err(Error::UnresolvedReference);}
  if transition!=[0,4]||mode!=1{return Err(Error::Backend("RTPC transitions require their native bodies"));}
  // B3EBC0 ignores the B12320 status; retain native partial writes on allocation failure.
  set_value(self.manager,self.values,id,bits,owner,self.pool,self.backend)?;Ok(())
 }
 fn set_rtpc_owned(&mut self,runtime:&mut crate::audio_meter_lifecycle::Runtime,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{
  if manager!=self.reference{return Err(Error::UnresolvedReference);}if transition!=[0,4]||mode!=1{return Err(Error::Backend("RTPC transitions require their native bodies"));}
  set_value_meter(self.manager,self.values,runtime,id,bits,owner,self.pool,self.backend)?;Ok(())
 }
 fn unregister_callback(&mut self,callback:u32)->Result<(),Error>{self.backend.unregister_callback(callback)}
 fn free_manager(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.backend.free_pool(pool,memory)}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_plugin_factory::Allocator;use crate::audio_meter_lifecycle::Lifetime;use crate::audio_effect_resource_bank::Services as PoolServices;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Physical{pattern:u8,failure:u32,nth:u32,next:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,allocated:Vec<u32>}
 impl Allocator for Physical{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("explicit pool allocator required"))}}
 impl Lifetime for Physical{fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no virtual output free"))}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("no output callback"))}}
 impl PoolServices for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));assert!(self.freed.insert(m.reference,m.clone()).is_none());Ok(())}}
 impl Services for Physical{fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let reference=if self.nth==self.failure{0}else{self.next};self.calls.push(json!({"kind":"allocate","method":"pool","allocator":pool,"size":size,"reference":reference}));if reference==0{return Ok(None);}self.next+=512;self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}}
 #[test]fn audio_rtpc_output_setter_matches648_native_record_owner_override_hash_and_storage_cases(){replay(include_str!("../../../data/4.20/audio_rtpc_output_setter_preparation.json"),648);}
 #[test]fn audio_rtpc_output_setter_matches2232_native_growth_allocation_pattern_and_failure_cases(){
 replay(include_str!("../../../data/4.20/audio_rtpc_output_setter_growth_preparation.json"),864);
 replay({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/audio_rtpc_output_setter_allocation_pattern_preparation.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 14615888, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        },1296);
 replay(include_str!("../../../data/4.20/audio_rtpc_output_setter_failure_preparation.json"),72);
 }
 fn replay(source:&str,count:u32){let proof:Value=serde_json::from_str(source).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],count);
 for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
  let b=&row["before"];let mut storage:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut manager=Manager{raw:bytes(b["rtpc"].as_str().unwrap()).try_into().unwrap(),bindings:BTreeMap::new(),records:BTreeMap::new()};let mut values=BTreeMap::new();for reference in [0x30009400,0x30009600]{let memory=storage.remove(&reference).unwrap();let v=word(&memory.raw,12);if v!=0{values.insert(v,storage.remove(&v).unwrap());}manager.records.insert(reference,Record{memory,subscribers:Memory{reference:0,raw:vec![]}});}assert!(storage.is_empty());
  let mut physical=Physical{pattern:row.get("allocation_pattern").unwrap_or(&row["pattern"]).as_u64().unwrap()as u8,failure:row["failure_nth"].as_u64().unwrap_or(0)as u32,nth:0,next:0x3000a000,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};assert_eq!(set_value(&mut manager,&mut values,row["key"].as_u64().unwrap()as u32,row["bits"].as_u64().unwrap()as u32,row["owner"].as_u64().unwrap()as u32,u32::MAX,&mut physical).unwrap(),row["result"].as_u64().unwrap_or(1)as u32,"status {i}");assert_eq!(hex(&manager.raw),row["after"]["rtpc"].as_str().unwrap(),"whole manager {i}");assert_eq!(json!(physical.calls),row["calls"],"allocation order {i}");
  let references:Vec<u32>=b["allocations"].as_array().unwrap().iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(physical.allocated.iter().copied()).collect();let owned:Vec<Value>=references.iter().map(|r|{let m=physical.freed.get(r).or_else(||manager.records.get(r).map(|n|&n.memory)).or_else(||values.get(r)).unwrap();json!({"reference":r,"size":m.raw.len(),"freed":physical.freed.contains_key(r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(owned),row["after"]["allocations"],"whole records and vector bytes {i}");
 }
 }
}
