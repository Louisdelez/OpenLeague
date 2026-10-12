//! Native B0F7A0/B29910/B26970 owned voice effect slots.
//! Meter refuses relocation; other plugin classes require their native bodies.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_plugin_context::{Context,Kind,Services},audio_bank_memory_reader::Manager,audio_bank_media_lookup::MediaRegistry,audio_meter_lifecycle::Runtime};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Default)]pub struct Owners{pub primary:Vec<u32>,pub secondary:Vec<u32>,pub voices:BTreeMap<u32,Memory>,pub contexts:BTreeMap<u32,Context>,pub rtpc:Option<crate::audio_rtpc_subscriber_release::Manager>}
impl Owners{
 fn kind(context:&Context)->Result<Kind,Error>{if context.memory.raw.len()<20{return Err(Error::InvalidAllocation);}match word(&context.memory.raw,0){0xff273c=>Ok(Kind::Extended),0xff26f0=>Ok(Kind::Standard),0xff2788=>Ok(Kind::Base),_=>Err(Error::Backend("unqualified plugin context class"))}}
 fn needs_stop(&self,voice:u32,bank:u32,plugins:&Runtime)->Result<bool,Error>{
  let voice=self.voices.get(&voice).ok_or(Error::UnresolvedReference)?;if voice.raw.len()<0x4d4{return Err(Error::InvalidAllocation);}
  for i in 0..4{
   let base=0x470+i*20;let reference=word(&voice.raw,base+12);if reference==0{continue;}
   let context=self.contexts.get(&reference).ok_or(Error::UnresolvedReference)?;if context.memory.raw.len()<20{return Err(Error::InvalidAllocation);}
   let count=word(&context.memory.raw,12)as usize;if count>word(&context.memory.raw,16)as usize||count.checked_mul(20).filter(|n|*n<=context.records.raw.len()).is_none()||word(&context.memory.raw,8)!=context.records.reference{return Err(Error::InvalidAllocation);}
   for record in context.records.raw[..count*20].chunks_exact(20){
    if word(record,16)==bank{
     let plugin=plugins.objects.get(&word(&voice.raw,base+8)).ok_or(Error::UnresolvedReference)?;
     if plugin.raw.len()!=84||word(&plugin.raw,0)!=0xff36d4{return Err(Error::Backend("plugin relocation implementation not qualified"));}
     // Actual Meter virtual10=586230 returns AL=false. B29910 consequently requires stop.
     return Ok(true);
    }
   }
  }Ok(false)
 }
 fn stop(&mut self,reference:u32,manager:&mut Manager,media:&mut MediaRegistry,plugins:&mut Runtime,plugin_allocator:u32,context_pool:u32,buffer_pool:u32,owner_pool:u32,services:&mut impl Services)->Result<(),Error>{
  let voice=self.voices.get(&reference).ok_or(Error::UnresolvedReference)?;
  if self.rtpc.is_none()&&(0..4).any(|i|word(&voice.raw,0x474+i*20)!=0){return Err(Error::Backend("voice parameter requires owned RTPC manager"));}
  for i in 0..4{
   let base=0x470+i*20;let plugin=word(&self.voices[&reference].raw,base+8);
   if plugin!=0{plugins.terminate_effect(plugin,plugin_allocator,services)?;set(&mut self.voices.get_mut(&reference).unwrap().raw,base+8,0);}
   let context=word(&self.voices[&reference].raw,base+12);
   if context!=0{
    let c=self.contexts.get_mut(&context).ok_or(Error::UnresolvedReference)?;let kind=Self::kind(c)?;c.destroy(kind,0,manager,media,buffer_pool,owner_pool,services)?;services.free_pool(context_pool,&c.memory)?;self.contexts.remove(&context);set(&mut self.voices.get_mut(&reference).unwrap().raw,base+12,0);
   }
   set(&mut self.voices.get_mut(&reference).unwrap().raw,base,u32::MAX);
   let parameter=word(&self.voices[&reference].raw,base+4);if parameter!=0{self.rtpc.as_mut().ok_or(Error::UnresolvedReference)?.unsubscribe(parameter,owner_pool,services)?;plugins.terminate_parameter(parameter,plugin_allocator,services)?;set(&mut self.voices.get_mut(&reference).unwrap().raw,base+4,0);}
  }Ok(())
 }
 pub fn release_bank(&mut self,bank:u32,manager:&mut Manager,media:&mut MediaRegistry,plugins:&mut Runtime,plugin_allocator:u32,context_pool:u32,buffer_pool:u32,owner_pool:u32,services:&mut impl Services)->Result<(),Error>{
  for (secondary,references)in [(false,self.primary.clone()),(true,self.secondary.clone())]{
   for reference in references{
    if self.needs_stop(reference,bank,plugins)?{self.stop(reference,manager,media,plugins,plugin_allocator,context_pool,buffer_pool,owner_pool,services)?;if secondary{set(&mut self.voices.get_mut(&reference).unwrap().raw,0x4d0,2);}}
   }
  }Ok(())
 }
}

#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::{audio_bank_memory_reader::{Bank,Services as BankServices},audio_bank_media_lookup::{Node,Services as MediaServices},audio_effect_bank_loader::{Holder,Services as EffectServices},audio_effect_resource_registry::Services as ResourceServices,audio_effect_resource_bank::Services as PoolServices,audio_plugin_factory::Allocator,audio_meter_lifecycle::Lifetime};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
    struct Physical{trace:bool,pattern:u8,next:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>}
    impl Allocator for Physical{fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{if size!=16{return Err(Error::Backend("unqualified voice allocation"));}crate::audio_rtpc_output_setter::Services::allocate_pool(self,pool,size)}}
    impl Lifetime for Physical{fn free(&mut self,allocator:u32,m:&Memory)->Result<(),Error>{if self.freed.insert(m.reference,m.clone()).is_some(){return Err(Error::Backend("double virtual free"));}self.calls.push(json!({"kind":"free","method":"virtual","allocator":allocator,"reference":m.reference}));Ok(())}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("no effect registration during media lookup"))}}
    impl PoolServices for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{if self.freed.insert(m.reference,m.clone()).is_some(){return Err(Error::Backend("double media free"));}self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}}
    impl ResourceServices for Physical{fn lock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect lock during media lookup"))}fn unlock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect unlock during media lookup"))}}
    impl EffectServices for Physical{fn lock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager lock during media lookup"))}fn unlock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager unlock during media lookup"))}}
    impl BankServices for Physical{
        fn atomic_decrement(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&holder.raw,offset);let after=before.wrapping_sub(1);set(&mut holder.raw,offset,after);self.calls.push(json!({"kind":"atomic_decrement","reference":holder.reference+offset as u32,"before":before,"after":after}));Ok(after)}
        fn notify_bank(&mut self,_:&mut[u8;40],_:[u32;6])->Result<(),Error>{Err(Error::Backend("no bank callback during media lookup"))}
        fn lock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_registry","category":null}));Ok(())}
        fn unlock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_registry","category":null}));Ok(())}
    }
    impl MediaServices for Physical{
        fn lock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_media"}));Ok(())}
        fn unlock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_media"}));Ok(())}
        fn atomic_increment(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&holder.raw,offset);let after=before.wrapping_add(1);set(&mut holder.raw,offset,after);self.calls.push(json!({"kind":"atomic_increment","reference":holder.reference+offset as u32,"before":before,"after":after}));Ok(after)}
    }

 impl Services for Physical{fn free_game_heap(&mut self,_:&Memory)->Result<(),Error>{Err(Error::Backend("deleting context destructor not qualified"))}}

 #[test]fn audio_bank_voice_effects_match16_native_meter_owner_scan_and_slot_destruction_sequences(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_meter_owner_scan_preparation.json")).unwrap();assert_eq!(p["case_count"],16);assert_eq!(p["passed"],true);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
  let b=&row["before"];let mut manager=Manager{raw:bytes(b["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let raw=bytes(b["holder"].as_str().unwrap());manager.banks.insert(0x30006000,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference:0x30006000,raw}});
  let mut allocations:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut media=MediaRegistry::default();media.nodes.insert(0x30006800,Node{memory:allocations.remove(&0x30006800).unwrap(),owners:allocations.remove(&0x30007000).unwrap()});
  let mut plugins=Runtime::default();plugins.objects.insert(0x3000c000,allocations.remove(&0x3000c000).unwrap());let mut owners=Owners::default();owners.contexts.insert(0x30007400,Context{memory:allocations.remove(&0x30007400).unwrap(),records:allocations.remove(&0x30007600).unwrap()});owners.voices.insert(0x30008000,Memory{reference:0x30008000,raw:bytes(b["voice"].as_str().unwrap())});if row["collection"]=="primary"{owners.primary.push(0x30008000)}else{owners.secondary.push(0x30008000)}
  let mut physical=Physical{trace:false,pattern:0,next:0x3000da00,calls:vec![],freed:BTreeMap::new()};let bank=if row["matching"]==true{0x30006000}else{0x30006200};owners.release_bank(bank,&mut manager,&mut media,&mut plugins,0x121023c,u32::MAX,u32::MAX,u32::MAX,&mut physical).unwrap();let after=&row["after"];
  assert_eq!(hex(&manager.raw),after["manager"].as_str().unwrap(),"manager {i}");assert_eq!(hex(&manager.banks[&0x30006000].memory.raw),after["holder"].as_str().unwrap(),"retained owner {i}");assert_eq!(hex(&owners.voices[&0x30008000].raw),after["voice"].as_str().unwrap(),"whole voice {i}");assert_eq!(b["table"],after["table"]);assert_eq!(json!(physical.calls),row["calls"],"physical order {i}");
  let allocations:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).or_else(||plugins.objects.get(&reference)).or_else(||media.nodes.get(&reference).map(|n|&n.memory)).or_else(||media.nodes.values().find(|n|n.owners.reference==reference).map(|n|&n.owners)).or_else(||owners.contexts.get(&reference).map(|c|&c.memory)).or_else(||owners.contexts.values().find(|c|c.records.reference==reference).map(|c|&c.records)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":physical.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),after["allocations"],"all owned storage {i}");
 }
 }

 impl crate::audio_common_queue::Services for Physical{
  fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{PoolServices::free_pool(self,pool,memory)}
  fn lock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"audio_common_queue"}));Ok(())}
  fn unlock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"audio_common_queue"}));Ok(())}
 }
 impl crate::audio_common_queue::RetryServices for Physical{
  fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
  fn set_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
  fn wait_event(&mut self,_:u32,_:u32,_:&mut crate::audio_common_queue::Context,_:&mut u32)->Result<(),Error>{Err(Error::Backend("unexpected wait in native empty common fixture"))}
  fn dispatch_command(&mut self,_:&[u8])->Result<(),Error>{Err(Error::Backend("command must use concrete bank consumer"))}
 }
 #[test]fn audio_bank_meter_deferred_unload_matches8_native_request_common_queue_voice_frame_and_final_owner_sequences(){
 let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_meter_deferred_unload_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],8);
 for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
  let b=&row["before"];let mut manager=Manager{raw:bytes(b["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let raw=bytes(b["holder"].as_str().unwrap());manager.banks.insert(0x30006000,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference:0x30006000,raw}});
  let mut allocations:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut media=MediaRegistry::default();media.nodes.insert(0x30006800,Node{memory:allocations.remove(&0x30006800).unwrap(),owners:allocations.remove(&0x30007000).unwrap()});
  let mut plugins=Runtime::default();plugins.objects.insert(0x3000c000,allocations.remove(&0x3000c000).unwrap());let mut owners=Owners::default();owners.contexts.insert(0x30007400,Context{memory:allocations.remove(&0x30007400).unwrap(),records:allocations.remove(&0x30007600).unwrap()});owners.voices.insert(0x30008000,Memory{reference:0x30008000,raw:bytes(b["voice"].as_str().unwrap())});if row["collection"]=="primary"{owners.primary.push(0x30008000)}else{owners.secondary.push(0x30008000)}

  let mut common=crate::audio_common_queue::Context{raw:bytes(b["common"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30005800,raw:bytes(b["common_table"].as_str().unwrap())},pages:BTreeMap::new(),page_size:64};for (j,page)in b["pages"].as_array().unwrap().iter().enumerate(){let reference=0x3000a000+j as u32*4096;common.pages.insert(reference,Memory{reference,raw:bytes(page.as_str().unwrap())});}
  let mut processed=b["processed"].as_u64().unwrap()as u32;let mut physical=Physical{trace:false,pattern:0,next:0x3000da00,calls:vec![],freed:BTreeMap::new()};let mut resources=crate::audio_effect_resource_registry::Registry::default();
  assert_eq!(manager.unload_request([1,0,0,1,0,u32::MAX,0,0,0],&mut common,&mut processed,&mut resources,&mut plugins,&mut physical).unwrap(),1);
  fn queue_snapshot(common:&crate::audio_common_queue::Context,processed:u32,expected:&Value){
   assert_eq!(hex(&common.raw),expected["common"].as_str().unwrap());assert_eq!(hex(&common.table.raw),expected["common_table"].as_str().unwrap());assert_eq!(processed as u64,expected["processed"].as_u64().unwrap());
   for(j,page)in common.pages.values().enumerate(){let mut actual=page.raw.clone();let mut reference=bytes(expected["pages"][j].as_str().unwrap());if j==0{for range in [4..8,16..20]{actual[range.clone()].fill(0);reference[range].fill(0);}}assert_eq!(actual,reference,"only undefined native type24/frame padding excluded");}
  }
  let queued=&row["queued"];assert_eq!(hex(&manager.raw),queued["manager"].as_str().unwrap());assert_eq!(hex(&manager.banks[&0x30006000].memory.raw),queued["holder"].as_str().unwrap());queue_snapshot(&common,processed,queued);assert_eq!(json!(physical.calls),row["queue_calls"],"request order {i}");physical.calls.clear();
  let pools:[u32;3]=row["allocator_pools"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();assert_eq!(crate::audio_bank_deferred_consumer::consume_with_voice_effects(&mut common,&mut manager,&[],&mut owners,&mut media,&mut plugins,pools,&mut processed,&mut physical).unwrap(),1);
  let after=&row["after"];assert_eq!(hex(&manager.raw),after["manager"].as_str().unwrap(),"whole manager {i}");queue_snapshot(&common,processed,after);assert!(manager.banks.is_empty());assert!(media.nodes.is_empty());assert!(plugins.objects.is_empty());assert!(owners.contexts.is_empty());assert_eq!(hex(&owners.voices[&0x30008000].raw),after["voice"].as_str().unwrap());assert_eq!(b["table"],after["table"]);
  let owned:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":true,"raw":hex(&m.raw)})}).collect();assert_eq!(json!(owned),after["allocations"],"all final owned bytes {i}");assert_eq!(json!(physical.calls),row["calls"],"full bank/voice/frame physical order {i}");
 }
 }
 #[test]fn audio_bank_voice_parameters_match16_native_meter_rtpc_and_parameter_termination_sequences(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_meter_parameter_owner_scan_preparation.json")).unwrap();assert_eq!(p["case_count"],16);assert_eq!(p["passed"],true);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
  let b=&row["before"];let mut manager=Manager{raw:bytes(b["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let raw=bytes(b["holder"].as_str().unwrap());manager.banks.insert(0x30006000,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference:0x30006000,raw}});
  let mut allocations:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut media=MediaRegistry::default();media.nodes.insert(0x30006800,Node{memory:allocations.remove(&0x30006800).unwrap(),owners:allocations.remove(&0x30007000).unwrap()});
  let mut plugins=Runtime::default();plugins.objects.insert(0x3000c000,allocations.remove(&0x3000c000).unwrap());plugins.objects.insert(0x3000c200,allocations.remove(&0x3000c200).unwrap());let mut owners=Owners::default();owners.rtpc=Some(crate::audio_rtpc_subscriber_release::Manager{raw:bytes(b["rtpc"].as_str().unwrap()).try_into().unwrap(),bindings:BTreeMap::new(),records:BTreeMap::new()});owners.contexts.insert(0x30007400,Context{memory:allocations.remove(&0x30007400).unwrap(),records:allocations.remove(&0x30007600).unwrap()});owners.voices.insert(0x30008000,Memory{reference:0x30008000,raw:bytes(b["voice"].as_str().unwrap())});if row["collection"]=="primary"{owners.primary.push(0x30008000)}else{owners.secondary.push(0x30008000)}
  let mut physical=Physical{trace:false,pattern:0,next:0x3000da00,calls:vec![],freed:BTreeMap::new()};let bank=if row["matching"]==true{0x30006000}else{0x30006200};owners.release_bank(bank,&mut manager,&mut media,&mut plugins,0x121023c,u32::MAX,u32::MAX,u32::MAX,&mut physical).unwrap();let after=&row["after"];assert_eq!(hex(&owners.rtpc.as_ref().unwrap().raw),after["rtpc"].as_str().unwrap());
  assert_eq!(hex(&manager.raw),after["manager"].as_str().unwrap(),"manager {i}");assert_eq!(hex(&manager.banks[&0x30006000].memory.raw),after["holder"].as_str().unwrap(),"retained owner {i}");assert_eq!(hex(&owners.voices[&0x30008000].raw),after["voice"].as_str().unwrap(),"whole voice {i}");assert_eq!(b["table"],after["table"]);assert_eq!(json!(physical.calls),row["calls"],"physical order {i}");
  let allocations:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).or_else(||plugins.objects.get(&reference)).or_else(||media.nodes.get(&reference).map(|n|&n.memory)).or_else(||media.nodes.values().find(|n|n.owners.reference==reference).map(|n|&n.owners)).or_else(||owners.contexts.get(&reference).map(|c|&c.memory)).or_else(||owners.contexts.values().find(|c|c.records.reference==reference).map(|c|&c.records)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":physical.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),after["allocations"],"all owned storage {i}");
 }
 }


 impl crate::audio_rtpc_output_setter::Services for Physical{
 fn observe_meter_parameter(&mut self,reference:u32,id:u32,bits:u32){if self.trace{self.calls.push(json!({"kind":"meter_set_parameter","reference":reference,"id":id,"bits":bits,"length":4}));}}

 fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{let reference=self.next;self.next+=512;self.calls.push(json!({"kind":"allocate","method":"pool","allocator":pool,"size":size,"reference":reference}));Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
 }
 impl crate::audio_meter_lifecycle::Update for Physical{
  fn set_rtpc(&mut self,_:u32,_:u32,_:u32,_:u32,_:[u32;2],_:u32)->Result<(),Error>{Err(Error::Backend("nonzero Meter delivery requires concrete RTPC setter"))}
  fn unregister_callback(&mut self,callback:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unregister_callback","callback":callback}));Ok(())}
  fn free_manager(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{PoolServices::free_pool(self,pool,memory)}
 }
 #[test]fn audio_bank_registered_initialized_meter_unload_matches16_native_parameter_subscription_and_deferred_callback_sequences(){
 for(text,initialized)in [(include_str!("../../../data/4.20/audio_bank_meter_registered_parameter_unload_preparation.json"),false),(include_str!("../../../data/4.20/audio_bank_meter_initialized_unload_preparation.json"),true)]{replay_meter_unload(text,initialized);}
 }
 #[test]fn audio_bank_meter_output_unload_matches8_native_complete_rtpc_delivery_sequences(){replay_meter_unload(include_str!("../../../data/4.20/audio_bank_meter_output_unload_preparation.json"),true);}
 #[test]fn audio_bank_meter_output_unload_matches8_native_live_subscription_callback_delivery_sequences(){replay_meter_unload(include_str!("../../../data/4.20/audio_bank_meter_subscriber_output_unload_preparation.json"),true);}
 #[test]fn audio_bank_meter_frame_dispatch_matches8_native_live_subscription_unload_sequences(){replay_meter_unload(include_str!("../../../data/4.20/audio_bank_meter_frame_callback_unload_preparation.json"),true);}
 #[test]fn audio_bank_meter_owned_registry_matches8_native_initialization_and_unload_sequences(){
 let text=include_str!("../../../data/4.20/audio_bank_meter_registered_callback_unload_preparation.json");
 let proof:Value=serde_json::from_str(text).unwrap();
 for row in proof["cases"].as_array().unwrap(){
  let before=&row["init_before"];let after=&row["init_after"];let pools:Vec<u32>=row["allocator_pools"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();
  let mut runtime=Runtime{manager_allocator:pools[0],..Runtime::default()};runtime.objects.insert(0x3000c000,Memory{reference:0x3000c000,raw:bytes(before["effect"].as_str().unwrap())});runtime.objects.insert(0x3000c200,Memory{reference:0x3000c200,raw:bytes(before["parameter"].as_str().unwrap())});
  let mut registry=crate::audio_callback_registry::Registry::default();let mut physical=Physical{trace:false,pattern:row["pattern"].as_u64().unwrap()as u8,next:before["next_allocation"].as_u64().unwrap()as u32,calls:vec![],freed:BTreeMap::new()};
  let mut format=[0;8];format[..4].copy_from_slice(&48000u32.to_le_bytes());let mut backend=crate::audio_callback_registry::MeterBackend{registry:&mut registry,pool:pools[2],backend:&mut physical};assert_eq!(runtime.init(0x3000c000,0x121023c,0x30007400,0x3000c200,format,&mut backend).unwrap(),1);
  assert_eq!(runtime.manager as u64,after["manager_reference"].as_u64().unwrap());assert_eq!(hex(&runtime.objects[&0x3000c000].raw),after["effect"].as_str().unwrap());assert_eq!(hex(&runtime.objects[&runtime.manager].raw),after["manager"].as_str().unwrap());assert_eq!(hex(&registry.raw),after["registry_header"].as_str().unwrap());assert_eq!(hex(&registry.callbacks.raw),after["registry_storage"].as_str().unwrap());assert_eq!(json!(physical.calls),after["calls"]);
 }
 replay_meter_unload(text,true);
 }
 fn replay_meter_unload(text:&str,initialized:bool){
 let proof:Value=serde_json::from_str(text).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],8);
 for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
  let active=row["active_subscriber"]==true;let b=&row["before"];let mut manager=Manager{raw:bytes(b["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let raw=bytes(b["holder"].as_str().unwrap());manager.banks.insert(0x30006000,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference:0x30006000,raw}});
  let mut allocations:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut media=MediaRegistry::default();media.nodes.insert(0x30006800,Node{memory:allocations.remove(&0x30006800).unwrap(),owners:allocations.remove(&0x30007000).unwrap()});
  let mut plugins=Runtime::default();plugins.objects.insert(0x3000c000,allocations.remove(&0x3000c000).unwrap());plugins.objects.insert(0x3000c200,allocations.remove(&0x3000c200).unwrap());let mut owners=Owners::default();owners.contexts.insert(0x30007400,Context{memory:allocations.remove(&0x30007400).unwrap(),records:allocations.remove(&0x30007600).unwrap()});owners.voices.insert(0x30008000,Memory{reference:0x30008000,raw:bytes(b["voice"].as_str().unwrap())});if row["collection"]=="primary"{owners.primary.push(0x30008000)}else{owners.secondary.push(0x30008000)}

  let mut common=crate::audio_common_queue::Context{raw:bytes(b["common"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30005800,raw:bytes(b["common_table"].as_str().unwrap())},pages:BTreeMap::new(),page_size:64};for (j,page)in b["pages"].as_array().unwrap().iter().enumerate(){let reference=0x3000a000+j as u32*4096;common.pages.insert(reference,Memory{reference,raw:bytes(page.as_str().unwrap())});}

  allocations.remove(&0x30006000).unwrap();
  let mut rtpc=crate::audio_rtpc_subscriber_release::Manager{raw:bytes(b["rtpc"].as_str().unwrap()).try_into().unwrap(),bindings:BTreeMap::new(),records:BTreeMap::new()};
  for bucket in 0..193{let mut reference=word(&rtpc.raw,0x614+bucket*4);while reference!=0{let memory=allocations.remove(&reference).unwrap();let next=word(&memory.raw,8);let curves=allocations.remove(&word(&memory.raw,20)).unwrap();let mut points=BTreeMap::new();for entry in curves.raw[..word(&memory.raw,24)as usize*20].chunks_exact(20){let pointer=word(entry,8);if pointer!=0{points.insert(pointer,allocations.remove(&pointer).unwrap());}}rtpc.bindings.insert(reference,crate::audio_rtpc_subscriber_release::Binding{memory,curves,points});reference=next;}}
  let memory=Memory{reference:0x30009c00,raw:bytes(b["rtpc_record"].as_str().unwrap())};let subscribers=allocations.remove(&word(&memory.raw,28)).unwrap();rtpc.records.insert(memory.reference,crate::audio_rtpc_subscriber_release::Record{memory,subscribers});owners.rtpc=Some(rtpc);
  let pools:[u32;3]=row["allocator_pools"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
  if initialized{plugins.manager=b["meter_manager"].as_u64().unwrap()as u32;plugins.manager_allocator=pools[0];plugins.objects.insert(plugins.manager,allocations.remove(&plugins.manager).unwrap());}if active{plugins.objects.insert(0x30009000,allocations.remove(&0x30009000).unwrap());}let registered=row["native_callback_registry"]==true;let mut callback_registry=if registered{let raw:[u8;12]=bytes(b["callback_registry_header"].as_str().unwrap()).try_into().unwrap();let callbacks=allocations.remove(&word(&raw,0)).unwrap();crate::audio_callback_registry::Registry{raw,callbacks}}else{crate::audio_callback_registry::Registry::default()};assert!(allocations.is_empty());
  let mut values=BTreeMap::new();let mut processed=b["processed"].as_u64().unwrap()as u32;let mut physical=Physical{trace:active,pattern:0,next:row["next_allocation"].as_u64().unwrap_or(0x3000da00)as u32,calls:vec![],freed:BTreeMap::new()};let mut resources=crate::audio_effect_resource_registry::Registry::default();
  fn snapshot(manager:&Manager,media:&MediaRegistry,plugins:&Runtime,owners:&Owners,common:&crate::audio_common_queue::Context,processed:u32,physical:&Physical,values:&BTreeMap<u32,Memory>,registry:&crate::audio_callback_registry::Registry,expected:&Value){
   assert_eq!(hex(&manager.raw),expected["manager"].as_str().unwrap());assert_eq!(hex(&common.raw),expected["common"].as_str().unwrap());assert_eq!(hex(&common.table.raw),expected["common_table"].as_str().unwrap());assert_eq!(processed as u64,expected["processed"].as_u64().unwrap());
   for(j,page)in common.pages.values().enumerate(){let mut actual=page.raw.clone();let mut reference=bytes(expected["pages"][j].as_str().unwrap());if j==0{for range in [4..8,16..20]{actual[range.clone()].fill(0);reference[range].fill(0);}}assert_eq!(actual,reference,"undefined type24/frame words excluded only");}
   assert_eq!(hex(&owners.voices[&0x30008000].raw),expected["voice"].as_str().unwrap());let rtpc=owners.rtpc.as_ref().unwrap();assert_eq!(hex(&rtpc.raw),expected["rtpc"].as_str().unwrap());assert_eq!(hex(&rtpc.records[&0x30009c00].memory.raw),expected["rtpc_record"].as_str().unwrap());if let Some(v)=expected.get("meter_manager"){assert_eq!(plugins.manager as u64,v.as_u64().unwrap());}
   if let Some(header)=expected.get("callback_registry_header"){assert_eq!(hex(&registry.raw),header.as_str().unwrap());assert_eq!(hex(&registry.callbacks.raw),expected["callback_registry_storage"].as_str().unwrap());}
   let owned:Vec<Value>=expected["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).or_else(||plugins.objects.get(&reference)).or_else(||manager.banks.get(&reference).map(|n|&n.memory)).or_else(||media.nodes.get(&reference).map(|n|&n.memory)).or_else(||media.nodes.values().find(|n|n.owners.reference==reference).map(|n|&n.owners)).or_else(||owners.contexts.get(&reference).map(|n|&n.memory)).or_else(||owners.contexts.values().find(|n|n.records.reference==reference).map(|n|&n.records)).or_else(||values.get(&reference)).or_else(||(registry.callbacks.reference==reference).then_some(&registry.callbacks)).or_else(||rtpc.bindings.get(&reference).map(|n|&n.memory)).or_else(||rtpc.bindings.values().find(|n|n.curves.reference==reference).map(|n|&n.curves)).or_else(||rtpc.bindings.values().find_map(|n|n.points.get(&reference))).or_else(||rtpc.records.values().find(|n|n.subscribers.reference==reference).map(|n|&n.subscribers)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":physical.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(owned),expected["allocations"],"every owned allocation raw byte/free state");
  }
  assert_eq!(manager.unload_request([1,0,0,1,0,u32::MAX,0,0,0],&mut common,&mut processed,&mut resources,&mut plugins,&mut physical).unwrap(),1);snapshot(&manager,&media,&plugins,&owners,&common,processed,&physical,&values,&callback_registry,&row["queued"]);assert_eq!(json!(physical.calls),row["queue_calls"],"queue {i}/{initialized}");physical.calls.clear();
  assert_eq!(crate::audio_bank_deferred_consumer::consume_with_voice_effects(&mut common,&mut manager,&[],&mut owners,&mut media,&mut plugins,pools,&mut processed,&mut physical).unwrap(),1);snapshot(&manager,&media,&plugins,&owners,&common,processed,&physical,&values,&callback_registry,&row["after"]);assert_eq!(json!(physical.calls),row["calls"],"consumer {i}/{initialized}");assert!(manager.banks.is_empty());assert!(owners.contexts.is_empty());assert_eq!(owners.rtpc.as_ref().unwrap().bindings.len(),if active{1}else{0});assert!(media.nodes.is_empty());
  if initialized{assert!(plugins.objects.contains_key(&0x3000c000));physical.calls.clear();physical.pattern=row["pattern"].as_u64().unwrap()as u8;if row["native_frame_callback_slice"]==true{crate::audio_rtpc_output_setter::dispatch_meter(&mut callback_registry,crate::audio_callback_registry::Reason::Frame,&mut plugins,0x3000e000,owners.rtpc.as_mut().unwrap(),&mut values,pools[2],&mut physical).unwrap();}else if registered{let mut backend=crate::audio_callback_registry::MeterBackend{registry:&mut callback_registry,pool:pools[2],backend:&mut physical};crate::audio_rtpc_output_setter::update_meter(&mut plugins,0x3000e000,owners.rtpc.as_mut().unwrap(),&mut values,pools[2],&mut backend).unwrap();}else{crate::audio_rtpc_output_setter::update_meter(&mut plugins,0x3000e000,owners.rtpc.as_mut().unwrap(),&mut values,pools[2],&mut physical).unwrap();}snapshot(&manager,&media,&plugins,&owners,&common,processed,&physical,&values,&callback_registry,&row["final"]);assert_eq!(json!(physical.calls),row["callback_calls"],"deferred callback {i}");}
  if active{assert_eq!(plugins.objects.len(),1);assert!(plugins.objects.contains_key(&0x30009000));}else{assert!(plugins.objects.is_empty());}
 }
 }
 }
