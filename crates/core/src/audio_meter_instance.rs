//! Actual Meter implementation behind native instance replacement callbacks.
//! OS/resource/context/subscription/scheduler boundaries remain mandatory services.
use crate::{audio_bus_bank::Error,audio_bus_effect_instance as instance,audio_plugin_factory::{self as factory,Memory,Registry,Kind,MeterCreators},audio_meter_lifecycle::{Runtime,Update},audio_meter_dsp::{Buffer,Clear}};
pub trait Services:Update{
 fn lock(&mut self,category:bool)->Result<(),Error>;
 fn unlock(&mut self,category:bool)->Result<(),Error>;
 fn rtpc_nonzero(&mut self,node:u32,parameter:u32,owner:u32)->Result<bool,Error>;
 /// Bind against the actual owned parameter, so qualified subscription producers
 /// can apply initial values without a second copied parameter store.
 fn bind(&mut self,parameter:&mut Memory,fields:[u32;6],owner:u32)->Result<(),Error>;
 fn context_allocate(&mut self,size:u32)->Result<Option<instance::Allocation>,Error>;
 fn context_write(&mut self,reference:u32,raw:[u8;28])->Result<(),Error>;
 fn context_destroy(&mut self,reference:u32)->Result<(),Error>;
 fn context_free(&mut self,reference:u32)->Result<(),Error>;
 fn unsubscribe(&mut self,parameter:u32)->Result<(),Error>;
 fn resource_release(&mut self,resource:&mut instance::Resource)->Result<(),Error>;
}
pub struct Backend<'a,S>{pub registry:&'a Registry,pub runtime:&'a mut Runtime,pub services:&'a mut S,pub allocator:u32}
impl<S:Services>Backend<'_,S>{
 pub fn process(&mut self,plugin:u32,buffer:&mut Buffer)->Result<Vec<Clear>,Error>{self.runtime.process_meter(plugin,buffer)}
 pub fn update(&mut self,rtpc_manager:u32)->Result<(),Error>{self.runtime.update(rtpc_manager,self.services)}
 fn retain(&mut self,object:Memory)->Result<u32,Error>{
  if object.reference==0||self.runtime.objects.contains_key(&object.reference){return Err(Error::InvalidAllocation);}
  let reference=object.reference;self.runtime.objects.insert(reference,object);Ok(reference)
 }
}
impl<S:Services>instance::Backend for Backend<'_,S>{
 fn lock(&mut self,category:bool)->Result<(),Error>{self.services.lock(category)}
 fn unlock(&mut self,category:bool)->Result<(),Error>{self.services.unlock(category)}
 fn rtpc_nonzero(&mut self,node:u32,parameter:u32,owner:u32)->Result<bool,Error>{self.services.rtpc_nonzero(node,parameter,owner)}
 fn factory(&mut self,id:u32)->Result<instance::Factory,Error>{
  let result=self.registry.create(Kind::Effect,id,self.allocator,&mut MeterCreators{allocator:self.services,objects:&mut self.runtime.objects})?;
  Ok(instance::Factory{status:result.status,plugin:result.reference})
 }
 fn info(&mut self,plugin:u32)->Result<instance::Info,Error>{
  let object=self.runtime.objects.get(&plugin).ok_or(Error::UnresolvedReference)?;
  if object.reference!=plugin||object.raw.len()!=84{return Err(Error::InvalidAllocation);}
  if object.raw[..4]!=0xff36d4u32.to_le_bytes(){return Err(Error::WrongClass);}
  let mut raw=[0;8];let status=factory::meter_info(&mut raw);Ok(instance::Info{status,raw})
 }
 fn plugin_destroy(&mut self,plugin:u32)->Result<(),Error>{self.runtime.terminate_effect(plugin,self.allocator,self.services)?;Ok(())}
 fn clone_parameter(&mut self,parameter:u32)->Result<u32,Error>{
  let source=self.runtime.objects.get(&parameter).ok_or(Error::UnresolvedReference)?;
  if source.reference!=parameter{return Err(Error::UnresolvedReference);}
  let object=factory::meter_clone_parameter(source,self.allocator,self.services)?;
  match object{None=>Ok(0),Some(object)=>self.retain(object)}
 }
 fn bind(&mut self,parameter:u32,fields:[u32;6],owner:u32)->Result<(),Error>{
  let object=self.runtime.objects.get_mut(&parameter).ok_or(Error::UnresolvedReference)?;
  if object.reference!=parameter{return Err(Error::UnresolvedReference);}
  self.services.bind(object,fields,owner)
 }
 fn allocate(&mut self,size:u32)->Result<Option<instance::Allocation>,Error>{self.services.context_allocate(size)}
 fn write_context(&mut self,reference:u32,raw:[u8;28])->Result<(),Error>{self.services.context_write(reference,raw)}
 fn context_destroy(&mut self,reference:u32)->Result<(),Error>{self.services.context_destroy(reference)}
 fn free(&mut self,reference:u32)->Result<(),Error>{self.services.context_free(reference)}
 fn unsubscribe(&mut self,parameter:u32)->Result<(),Error>{self.services.unsubscribe(parameter)}
 fn parameter_destroy(&mut self,parameter:u32)->Result<(),Error>{self.runtime.terminate_parameter(parameter,self.allocator,self.services)?;Ok(())}
 fn init(&mut self,plugin:u32,context:u32,parameter:u32,format:[u8;8])->Result<u32,Error>{self.runtime.init(plugin,self.allocator,context,parameter,format,self.services)}
 fn reset(&mut self,plugin:u32)->Result<u32,Error>{self.runtime.reset(plugin)}
 fn retained(&mut self,resource:&instance::Resource)->Result<(),Error>{
  // Concrete bank resources share this runtime with the cloned plugin parameters.
  // Opaque resources retain their caller-owned lifetime interface.
  let Some(object)=self.runtime.objects.get_mut(&resource.reference)else{return Ok(());};
  if object.reference!=resource.reference||object.raw.len()!=48{return Err(Error::InvalidAllocation);}
  let class=u32::from_le_bytes(object.raw[..4].try_into().unwrap());
  if ![0xff2380,0xff2394].contains(&class){return Err(Error::WrongClass);}
  object.raw[12..16].copy_from_slice(&resource.references.to_le_bytes());Ok(())
 }
 fn release(&mut self,resource:&mut instance::Resource)->Result<(),Error>{
  let Some(object)=self.runtime.objects.get(&resource.reference)else{return self.services.resource_release(resource);};
  if object.reference!=resource.reference||object.raw.len()!=48{return Err(Error::InvalidAllocation);}
  let category=match u32::from_le_bytes(object.raw[..4].try_into().unwrap()){0xff2380=>true,0xff2394=>false,_=>return Err(Error::WrongClass)};
  if resource.references<=1{return Err(Error::Backend("zero-release requires the owning effect registry"));}
  self.services.lock(category)?;
  resource.references=resource.references.wrapping_sub(1);
  self.runtime.objects.get_mut(&resource.reference).unwrap().raw[12..16].copy_from_slice(&resource.references.to_le_bytes());
  self.services.unlock(category)?;Ok(())
 }
}
#[cfg(test)]pub(crate)mod tests{
 use super::*;use serde_json::{Value,json};
 use crate::{audio_bus_effects_changed::Graph,audio_bus_registry::Bus,audio_bus_effects_bank::Cache,audio_bus_source_mask::Store as Sources,audio_bus_control_application::Voice,audio_plugin_factory::Allocator,audio_meter_lifecycle::Lifetime};
 pub(crate)fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 pub(crate)fn hex(raw:&[u8])->String{raw.iter().map(|b|format!("{b:02x}")).collect()}
 fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
 pub(crate)struct Allocation{pub memory:Memory,pub freed:bool}
 pub(crate)struct Heap{pub profile:String,pub pattern:u8,pub next:u32,pub stride:u32,pub allocations:Vec<Allocation>,pub calls:Vec<Value>}
 impl Heap{
  pub(crate)fn new(profile:&str,pattern:u8)->Self{Self{profile:profile.into(),pattern,next:0x30030000,stride:0x100,allocations:vec![],calls:vec![]}}
  fn allocation(&mut self,owner:u32,size:u32)->Result<Option<Memory>,Error>{
   let fail=match self.profile.as_str(){"factory_fail"=>84,"clone_fail"=>32,"context_fail"=>28,"manager_fail"=>16,_=>0}==size;
   let reference=if fail{0}else{self.next};self.calls.push(json!({"kind":"allocate","method":if owner==0x121023c{"virtual"}else{"pool"},"allocator":owner,"size":size,"reference":reference}));
   if fail{return Ok(None);}self.next+=self.stride;let memory=Memory{reference,raw:vec![self.pattern;size as usize]};self.allocations.push(Allocation{memory:memory.clone(),freed:false});Ok(Some(memory))
  }
  fn release(&mut self,kind:&str,owner:u32,object:&Memory)->Result<(),Error>{
   let record=self.allocations.iter_mut().find(|a|a.memory.reference==object.reference).ok_or(Error::UnresolvedReference)?;assert!(!record.freed);record.freed=true;record.memory=object.clone();self.calls.push(json!({"kind":kind,"allocator":owner,"reference":object.reference}));Ok(())
  }
  pub(crate)fn snapshot(&self,runtime:&Runtime)->Value{json!(self.allocations.iter().map(|a|{let object=runtime.objects.get(&a.memory.reference).unwrap_or(&a.memory);json!({"reference":object.reference,"size":object.raw.len(),"freed":a.freed,"raw":hex(&object.raw)})}).collect::<Vec<_>>())}
 }
 impl Allocator for Heap{fn allocate(&mut self,owner:u32,size:u32)->Result<Option<Memory>,Error>{self.allocation(owner,size)}}
 impl Lifetime for Heap{
  fn free(&mut self,owner:u32,object:&Memory)->Result<(),Error>{self.release("free_virtual",owner,object)}
  fn register_callback(&mut self,callback:u32)->Result<(),Error>{self.calls.push(json!({"kind":"register_callback","callback":callback}));Ok(())}
 }
 impl Update for Heap{
  fn set_rtpc(&mut self,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_rtpc","manager":manager,"id":id,"bits":bits,"owner":owner,"transition":transition,"mode":mode}));Ok(())}
  fn unregister_callback(&mut self,callback:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unregister_callback","callback":callback}));Ok(())}
  fn free_manager(&mut self,owner:u32,object:&Memory)->Result<(),Error>{self.release("free_pool",owner,object)}
 }
 impl Services for Heap{
  fn lock(&mut self,category:bool)->Result<(),Error>{self.calls.push(json!({"kind":"lock","category":category}));Ok(())}
  fn unlock(&mut self,category:bool)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","category":category}));Ok(())}
  fn rtpc_nonzero(&mut self,_:u32,_:u32,_:u32)->Result<bool,Error>{Err(Error::Backend("static bypass only in reference"))}
  fn bind(&mut self,_:&mut Memory,_:[u32;6],_:u32)->Result<(),Error>{Err(Error::Backend("empty resource bindings only in reference"))}
  fn context_allocate(&mut self,size:u32)->Result<Option<instance::Allocation>,Error>{
   self.allocation(u32::MAX,size)?.map(|o|Ok(instance::Allocation{reference:o.reference,raw:o.raw.try_into().map_err(|_|Error::InvalidAllocation)?})).transpose()
  }
  fn context_write(&mut self,reference:u32,raw:[u8;28])->Result<(),Error>{let a=self.allocations.iter_mut().find(|a|a.memory.reference==reference).ok_or(Error::UnresolvedReference)?;a.memory.raw=raw.to_vec();Ok(())}
  fn context_destroy(&mut self,reference:u32)->Result<(),Error>{self.calls.push(json!({"kind":"context_destroy","reference":reference}));Ok(())}
  fn context_free(&mut self,reference:u32)->Result<(),Error>{let object=self.allocations.iter().find(|a|a.memory.reference==reference).ok_or(Error::UnresolvedReference)?.memory.clone();self.release("free_pool",u32::MAX,&object)}
  fn unsubscribe(&mut self,parameter:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unsubscribe","parameter":parameter}));Ok(())}
  fn resource_release(&mut self,resource:&mut instance::Resource)->Result<(),Error>{resource.references=resource.references.wrapping_sub(1);self.calls.push(json!({"kind":"resource_release","reference":resource.reference}));Ok(())}
 }
 #[test]fn audio_meter_instance_matches336_native_factory_clone_dsp_replacement_failure_and_update_cases(){
  let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_meter_instance_contract.json")).unwrap();assert_eq!(p["case_count"],336);
  for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
   let profile=row["profile"].as_str().unwrap();let index=row["index"].as_u64().unwrap()as u32;let mut graph=Graph::default();let mut bus=Bus{reference:0x30002000,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(24,0x30003000);graph.buses.insert(bus.reference,bus);
   let mut cache=Cache{raw:[0;36]};cache.raw[index as usize*8+1]=row["category"].as_u64().unwrap()as u8;cache.raw[index as usize*8+4..index as usize*8+8].copy_from_slice(&100u32.to_le_bytes());cache.raw[32]=row["bypass"].as_u64().unwrap()as u8;graph.caches.insert(0x30003000,cache);
   let mut store=instance::Store::default();store.resources.insert(0x30006000,instance::Resource{reference:0x30006000,id:100,references:7,plugin_id:if profile=="unregistered"{0xdeadbeef}else{factory::METER_ID},parameter:0x30005000,bindings:vec![]});if profile!="missing"{store.buckets.insert((row["category"]!=0,100%193),vec![0x30006000]);}
   let mut runtime=Runtime{manager_allocator:u32::MAX,..Runtime::default()};runtime.objects.insert(0x30005000,Memory{reference:0x30005000,raw:bytes(row["source_parameter"].as_str().unwrap())});let registry=Registry{entries:vec![factory::Registration{id:factory::METER_ID,effect:factory::METER_EFFECT_CREATOR,parameter:factory::METER_PARAMETER_CREATOR}]};let mut heap=Heap::new(profile,row["pattern"].as_u64().unwrap()as u8);let mut voice=Voice{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap()};let mut backend=Backend{registry:&registry,runtime:&mut runtime,services:&mut heap,allocator:0x121023c};
   for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
    backend.services.calls.clear();let mut processed=None;
    let result=if j<2{let result=store.replace(&graph,&Sources::default(),0x30001000,&mut voice,0x30002000,index,48000,&mut backend).unwrap();let plugin=word(&voice.raw,0x470+index as usize*20+8);if result==1&&plugin!=0{
     let mut raw=[0;16];for(o,v)in [(0,0x30009000u32),(4,3),(8,17)]{raw[o..o+4].copy_from_slice(&v.to_le_bytes());}raw[12..14].copy_from_slice(&8u16.to_le_bytes());raw[14..16].copy_from_slice(&4u16.to_le_bytes());let samples=[-0.25f32,0.5,-1.,0.125,0.,-0.75,0.25,1.].into_iter().cycle().take(16).map(f32::to_bits).collect();let mut buffer=Buffer{raw,samples};let clears=backend.process(plugin,&mut buffer).unwrap();backend.services.calls.extend(clears.into_iter().map(|c|json!({"kind":"clear","offset":c.offset,"size":c.size})));processed=Some(buffer);
    }result}else if j==2{instance::teardown(&mut voice,index,&mut backend).unwrap();1}else{if backend.runtime.manager!=0{backend.update(0x3000a000).unwrap();}1};
    assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(hex(&voice.raw),stage["voice"].as_str().unwrap(),"voice {i}/{j}");assert_eq!(hex(&backend.runtime.objects[&0x30005000].raw),stage["source_parameter"].as_str().unwrap(),"source {i}/{j}");assert_eq!(u64::from(store.resources[&0x30006000].references),stage["resource_refcount"].as_u64().unwrap(),"leases {i}/{j}");assert_eq!(u64::from(backend.runtime.manager),stage["global_manager"].as_u64().unwrap(),"manager {i}/{j}");assert_eq!(backend.services.snapshot(backend.runtime),stage["allocations"],"all allocations {i}/{j}");assert_eq!(json!(backend.services.calls),stage["calls"],"all boundary calls {i}/{j}");assert_eq!(processed.is_some(),stage["processed"].as_bool().unwrap());if let Some(buffer)=processed{assert_eq!(hex(&buffer.raw),stage["buffer"].as_str().unwrap(),"buffer {i}/{j}");let raw:Vec<u8>=buffer.samples.iter().flat_map(|b|b.to_le_bytes()).collect();assert_eq!(hex(&raw),stage["samples"].as_str().unwrap(),"samples {i}/{j}");}
   }
  }
 }
}
