//! Whole native bank -> actual voice clone -> unload -> surviving DSP ownership.
use crate::{audio_bus_bank::Error,audio_effect_bank_loader::{self as bank,Stream,Holder},audio_effect_resource_registry::{Registry,Services as ResourceServices},audio_effect_resource_bank::{Services as BankServices,tests::Heap},audio_meter_instance::{Backend,Services},audio_meter_lifecycle::{Runtime,Lifetime,Update},audio_plugin_factory::{Allocator,Memory,Registry as Plugins,Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR},audio_bus_effect_instance as instance,audio_bus_control_application::Voice,audio_bus_effects_changed::Graph,audio_bus_registry::Bus,audio_bus_effects_bank::Cache,audio_bus_source_mask::Store as Sources,audio_meter_dsp::Buffer};
use std::collections::BTreeMap;
use serde_json::{Value,json};
struct Native{heap:Heap,contexts:BTreeMap<u32,Memory>}
impl Allocator for Native{fn allocate(&mut self,a:u32,s:u32)->Result<Option<Memory>,Error>{self.heap.allocate(a,s)}}
impl Lifetime for Native{
 fn free(&mut self,a:u32,m:&Memory)->Result<(),Error>{Lifetime::free(&mut self.heap,a,m)}
 fn register_callback(&mut self,c:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"register_callback","callback":c}));Ok(())}
}
impl BankServices for Native{fn free_pool(&mut self,a:u32,m:&Memory)->Result<(),Error>{self.heap.free_pool(a,m)}}
impl ResourceServices for Native{
 fn lock(&mut self,c:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"registry","category":c}));Ok(())}
 fn unlock(&mut self,c:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"registry","category":c}));Ok(())}
}
impl bank::Services for Native{
 fn lock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_manager","category":null}));Ok(())}
 fn unlock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_manager","category":null}));Ok(())}
}
impl Update for Native{
 fn set_rtpc(&mut self,m:u32,id:u32,b:u32,o:u32,t:[u32;2],mode:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"set_rtpc","manager":m,"id":id,"bits":b,"owner":o,"transition":t,"mode":mode}));Ok(())}
 fn unregister_callback(&mut self,c:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unregister_callback","callback":c}));Ok(())}
 fn free_manager(&mut self,a:u32,m:&Memory)->Result<(),Error>{self.heap.free_pool(a,m)}
}
impl Services for Native{
 fn lock(&mut self,c:bool)->Result<(),Error>{ResourceServices::lock(self,c)}
 fn unlock(&mut self,c:bool)->Result<(),Error>{ResourceServices::unlock(self,c)}
 fn rtpc_nonzero(&mut self,_:u32,_:u32,_:u32)->Result<bool,Error>{Err(Error::Backend("static bypass only in bank voice proof"))}
 fn bind(&mut self,_:&mut Memory,_:[u32;6],_:u32)->Result<(),Error>{Err(Error::Backend("empty subscriptions only in bank voice proof"))}
 fn context_allocate(&mut self,s:u32)->Result<Option<instance::Allocation>,Error>{self.allocate(u32::MAX,s)?.map(|m|Ok(instance::Allocation{reference:m.reference,raw:m.raw.try_into().map_err(|_|Error::InvalidAllocation)?})).transpose()}
 fn context_write(&mut self,r:u32,raw:[u8;28])->Result<(),Error>{self.contexts.insert(r,Memory{reference:r,raw:raw.to_vec()});Ok(())}
 fn context_destroy(&mut self,r:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"context_destroy","reference":r}));Ok(())}
 fn context_free(&mut self,r:u32)->Result<(),Error>{let m=self.contexts.remove(&r).ok_or(Error::UnresolvedReference)?;self.heap.free_pool(u32::MAX,&m)}
 fn unsubscribe(&mut self,p:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unsubscribe","parameter":p}));Ok(())}
 fn resource_release(&mut self,_:&mut instance::Resource)->Result<(),Error>{Err(Error::Backend("native owned resource required"))}
}
fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn hex(raw:&[u8])->String{raw.iter().map(|b|format!("{b:02x}")).collect()}
#[test]fn audio_bank_voice_clone_survives_unload_matches224_native_lifetime_dsp_and_failure_cases(){
 let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_bank_voice_contract.json")).unwrap();assert_eq!(proof["case_count"],224);
 for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
  let data=bytes(row["bank_payload"].as_str().unwrap());let id=word(&data,0);let category=row["category"].as_bool().unwrap();let index=row["index"].as_u64().unwrap()as u32;
  let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![(0x30005400,8)],freed:BTreeMap::new(),methods:true},contexts:BTreeMap::new()};
  let mut resources=Registry::default();let mut runtime=Runtime{manager_allocator:u32::MAX,..Runtime::default()};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
  let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);
  let mut holder=Holder{raw:[0xa5;64],slots:Memory{reference:0x30005400,raw:vec![0xa5;8]}};set(&mut holder.raw,52,holder.slots.reference);set(&mut holder.raw,56,0);set(&mut holder.raw,60,2);
  let mut voice=Voice{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap()};let mut graph=Graph::default();let mut bus=Bus{reference:0x30031000,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(24,0x30032000);graph.buses.insert(bus.reference,bus);
  let mut cache=Cache{raw:[0;36]};cache.raw[index as usize*8+1]=u8::from(category);set(&mut cache.raw,index as usize*8+4,id);graph.caches.insert(0x30032000,cache);
  for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
   native.heap.calls.clear();let mut processed=None;
   let result=match stage["stage"].as_str().unwrap(){
    "load"=>{let mut descriptor=[0;5];descriptor[0]=if category{18}else{19};descriptor[1..].copy_from_slice(&(data.len()as u32).to_le_bytes());bank::load_effect(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,descriptor,&mut native).unwrap()},
    "unload"=>{holder.unload_effects(&mut resources,&mut runtime,&mut native).unwrap();0},
    action=>{
     let mut backend=Backend{registry:&plugins,runtime:&mut runtime,services:&mut native,allocator:0x121023c};
     let status=match action{"replace"=>resources.instances.replace(&graph,&Sources::default(),0x30030000,&mut voice,0x30031000,index,48000,&mut backend).unwrap(),"teardown"=>{instance::teardown(&mut voice,index,&mut backend).unwrap();1},"update"=>{if backend.runtime.manager!=0{backend.update(0x30035000).unwrap();}1},"process_after_unload"=>1,_=>panic!("unknown stage")};
     if ["replace","process_after_unload"].contains(&action)&&status==1{
      let plugin=word(&voice.raw,0x470+index as usize*20+8);
      if plugin!=0{let mut raw=[0;16];for(o,v)in [(0,0x30034000u32),(4,3),(8,17)]{set(&mut raw,o,v);}raw[12..14].copy_from_slice(&8u16.to_le_bytes());raw[14..16].copy_from_slice(&4u16.to_le_bytes());let samples=[-0.25f32,0.5,-1.,0.125,0.,-0.75,0.25,1.].into_iter().cycle().take(16).map(f32::to_bits).collect();let mut buffer=Buffer{raw,samples};let clears=backend.process(plugin,&mut buffer).unwrap();backend.services.heap.calls.extend(clears.into_iter().map(|c|json!({"kind":"clear","offset":c.offset,"size":c.size})));processed=Some(buffer);}
     }status
    }
   };
   assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(hex(&voice.raw),stage["voice"].as_str().unwrap(),"voice {i}/{j}");assert_eq!(hex(&stream.raw),stage["stream"].as_str().unwrap(),"stream {i}/{j}");assert_eq!(hex(&holder.raw),stage["holder"].as_str().unwrap(),"holder {i}/{j}");assert_eq!(u64::from(runtime.manager),stage["global_manager"].as_u64().unwrap(),"manager {i}/{j}");
   let head=resources.instances.buckets.get(&(category,id%193)).and_then(|v|v.first()).copied().unwrap_or(0);assert_eq!(u64::from(head),stage["head"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[usize::from(category)]),stage["count"].as_u64().unwrap());
   let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||native.contexts.get(&r)).or_else(||(r==holder.slots.reference).then_some(&holder.slots)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();
   assert_eq!(json!(allocations),stage["allocations"],"owned bytes/frees {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"native lock/lifetime order {i}/{j}");assert_eq!(processed.is_some(),stage["processed"].as_bool().unwrap());
   if let Some(buffer)=processed{assert_eq!(hex(&buffer.raw),stage["buffer"].as_str().unwrap());let raw:Vec<u8>=buffer.samples.iter().flat_map(|s|s.to_le_bytes()).collect();assert_eq!(hex(&raw),stage["samples"].as_str().unwrap(),"DSP {i}/{j}");}
  }
  assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());assert!(native.contexts.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
 }
}
