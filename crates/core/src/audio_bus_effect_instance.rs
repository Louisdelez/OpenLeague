//! Native B270B0 replacement, B268E0 teardown and Bus E0 resource acquisition.
//! Plugin DSP and resource lifetime methods are mandatory caller implementations.
use crate::{audio_bus_bank::Error,audio_bus_control_application::Voice,audio_bus_effects_changed::Graph,audio_bus_source_mask::Store as Sources};
use std::collections::BTreeMap;
#[derive(Debug,Clone)]pub struct Resource{pub reference:u32,pub id:u32,pub references:u32,pub plugin_id:u32,pub parameter:u32,pub bindings:Vec<[u32;6]>}
#[derive(Debug,Default)]pub struct Store{pub resources:BTreeMap<u32,Resource>,pub buckets:BTreeMap<(bool,u32),Vec<u32>>}
pub struct Factory{pub status:u32,pub plugin:u32}
pub struct Info{pub status:u32,pub raw:[u8;8]}
pub struct Allocation{pub reference:u32,pub raw:[u8;28]}
pub trait Backend{
 fn lock(&mut self,category:bool)->Result<(),Error>;fn unlock(&mut self,category:bool)->Result<(),Error>;
 fn rtpc_nonzero(&mut self,node:u32,parameter:u32,owner:u32)->Result<bool,Error>;
 fn factory(&mut self,id:u32)->Result<Factory,Error>;fn info(&mut self,plugin:u32)->Result<Info,Error>;
 fn plugin_destroy(&mut self,plugin:u32)->Result<(),Error>;
 fn clone_parameter(&mut self,parameter:u32)->Result<u32,Error>;
 fn bind(&mut self,parameter:u32,fields:[u32;6],owner:u32)->Result<(),Error>;
 fn allocate(&mut self,size:u32)->Result<Option<Allocation>,Error>;
 fn write_context(&mut self,reference:u32,raw:[u8;28])->Result<(),Error>;
 fn context_destroy(&mut self,reference:u32)->Result<(),Error>;fn free(&mut self,reference:u32)->Result<(),Error>;
 fn unsubscribe(&mut self,parameter:u32)->Result<(),Error>;fn parameter_destroy(&mut self,parameter:u32)->Result<(),Error>;
 fn init(&mut self,plugin:u32,context:u32,parameter:u32,format:[u8;8])->Result<u32,Error>;
 fn reset(&mut self,plugin:u32)->Result<u32,Error>;
 /// Publish a retained reference while its category lock is still held.
 fn retained(&mut self,resource:&Resource)->Result<(),Error>;
 fn release(&mut self,resource:&mut Resource)->Result<(),Error>;
}
fn word(v:&Voice,o:usize)->u32{u32::from_le_bytes(v.raw[o..o+4].try_into().unwrap())}
fn set(v:&mut Voice,o:usize,value:u32){v.raw[o..o+4].copy_from_slice(&value.to_le_bytes());}
fn offset(index:u32)->Result<usize,Error>{if index>=4{Err(Error::Backend("unqualified effect instance slot"))}else{Ok(0x470+index as usize*20)}}
/// B27020 packs raw six fields with wrapping shifts and the original masks.
pub fn format(fields:[u32;6])->[u8;8]{let[rate,channels,bits,stride,kind,interleaved]=fields;let mut packed=kind&3;packed|=interleaved.wrapping_shl(2);packed=packed.wrapping_shl(5)|(stride&31);packed=packed.wrapping_shl(6)|(bits&63);packed=packed.wrapping_shl(18)|(channels&0x3ffff);let mut raw=[0;8];raw[..4].copy_from_slice(&rate.to_le_bytes());raw[4..].copy_from_slice(&packed.to_le_bytes());raw}
pub fn teardown(voice:&mut Voice,index:u32,backend:&mut impl Backend)->Result<(),Error>{
 let o=offset(index)?;let plugin=word(voice,o+8);if plugin!=0{backend.plugin_destroy(plugin)?;set(voice,o+8,0);}
 let context=word(voice,o+12);if context!=0{backend.context_destroy(context)?;backend.free(context)?;set(voice,o+12,0);}
 let parameter=word(voice,o+4);set(voice,o,u32::MAX);if parameter!=0{backend.unsubscribe(parameter)?;backend.parameter_destroy(parameter)?;set(voice,o+4,0);}Ok(())
}
impl Store{
 fn acquire(&mut self,category:bool,id:u32,backend:&mut impl Backend)->Result<Option<u32>,Error>{
  backend.lock(category)?;let result=(||{for r in self.buckets.get(&(category,id%193)).into_iter().flatten(){let resource=self.resources.get_mut(r).ok_or(Error::UnresolvedReference)?;if resource.reference!=*r || *r==0{return Err(Error::UnresolvedReference);}if resource.id==id{resource.references=resource.references.wrapping_add(1);backend.retained(resource)?;return Ok(Some(*r));}}Ok(None)})();let unlocked=backend.unlock(category);unlocked?;result
 }
 fn descriptor(&mut self,g:&Graph,sources:&Sources,bound:u32,index:u32,backend:&mut impl Backend)->Result<(Option<u32>,bool),Error>{
  if bound==0{return Ok((None,false));}let b=g.buses.get(&bound).ok_or(Error::UnresolvedReference)?;if b.reference!=bound || b.word(0)!=0xff1380{return Err(Error::WrongClass);}let pointer=b.word(0x18);if pointer==0{return Ok((None,false));}let cache=g.caches.get(&pointer).ok_or(Error::MissingEffectsCache(pointer))?;let at=index as usize*8;let id=u32::from_le_bytes(cache.raw[at+4..at+8].try_into().unwrap());let resource=if id==0{None}else{self.acquire(cache.raw[at+1]!=0,id,backend)?};
  let bypass=(||{let parameter=24+index;let mask=u64::from(b.word(0x30))|(u64::from(b.word(0x34))<<32);if id!=0 && mask&(1u64<<parameter)!=0{return backend.rtpc_nonzero(bound,parameter,0);}let flags=if b.word(0x14)==0{cache.raw[32]}else{sources.sources.get(&b.word(0x14)).ok_or(Error::MissingAudioSource(b.word(0x14)))?[16]};Ok(flags&(1<<index)!=0)})();
  match bypass{Ok(value)=>Ok((resource,value)),Err(error)=>{if let Some(r)=resource{backend.release(self.resources.get_mut(&r).unwrap())?;}Err(error)}}
 }
 fn create(&mut self,reference:u32,voice_reference:u32,voice:&mut Voice,bound:u32,index:u32,bypass:bool,rate:u32,backend:&mut impl Backend)->Result<u32,Error>{
  let o=offset(index)?;let resource=self.resources.get(&reference).ok_or(Error::UnresolvedReference)?.clone();set(voice,o,resource.plugin_id);let factory=backend.factory(resource.plugin_id)?;set(voice,o+8,factory.plugin);if factory.status!=1{return Ok(factory.status);}if factory.plugin==0{return Err(Error::UnresolvedReference);}let first=backend.info(factory.plugin)?;
  if first.raw[4]==0{backend.plugin_destroy(factory.plugin)?;set(voice,o+8,0);let context=word(voice,o+12);if context!=0{backend.context_destroy(context)?;backend.free(context)?;set(voice,o+12,0);}return Ok(2);}
  let parameter=backend.clone_parameter(resource.parameter)?;set(voice,o+4,parameter);if parameter==0{teardown(voice,index,backend)?;return Ok(2);}for fields in resource.bindings{backend.bind(parameter,fields,0)?;}
  let allocation=backend.allocate(28)?;let context=match allocation{None=>0,Some(mut a)=>{if a.reference==0{return Err(Error::InvalidAllocation);}for(i,value)in [0xff273c,index,0,0,0,voice_reference,bound].into_iter().enumerate(){a.raw[i*4..i*4+4].copy_from_slice(&value.to_le_bytes());}backend.write_context(a.reference,a.raw)?;a.reference}};set(voice,o+12,context);if context==0{teardown(voice,index,backend)?;return Ok(2);}
  voice.raw[o+16]=(voice.raw[o+16]&!1)|u8::from(bypass);let info=backend.info(factory.plugin)?;let mut result=if info.raw[5]!=0{2}else{info.status};if result==1{let channels=word(voice,0x41c);result=backend.init(factory.plugin,context,parameter,format([rate,channels,32,channels.count_ones().wrapping_mul(4),1,1]))?;if result==1{result=backend.reset(factory.plugin)?;}}
  if result!=1{teardown(voice,index,backend)?;}Ok(result)
 }
 pub fn replace(&mut self,g:&Graph,sources:&Sources,voice_reference:u32,voice:&mut Voice,bound:u32,index:u32,rate:u32,backend:&mut impl Backend)->Result<u32,Error>{
  offset(index)?;if voice_reference==0{return Err(Error::UnresolvedReference);}teardown(voice,index,backend)?;let(resource,bypass)=self.descriptor(g,sources,bound,index,backend)?;let Some(reference)=resource else{return Ok(1);};let result=self.create(reference,voice_reference,voice,bound,index,bypass,rate,backend);let released=backend.release(self.resources.get_mut(&reference).ok_or(Error::UnresolvedReference)?);released?;result
 }
}
/// Resolve each binding from the live graph at the slot callback. Native slot
/// dispatch ignores B270B0's status; preserve it separately without failing the bank.
pub struct Refresh<'a,B>{pub store:&'a mut Store,pub backend:&'a mut B,pub primary:u32,pub sample_rate:u32,pub results:Vec<(u32,u32,u32)>}
impl<B:Backend>crate::audio_bus_effect_consumers::Refresh for Refresh<'_,B>{
 fn dispatch(&mut self,b:&crate::audio_bus_registry::Bus,g:&Graph,inputs:&crate::audio_bus_gain_aggregation::Inputs,targets:&mut crate::audio_bus_control_application::Store,index:u32)->Result<Vec<crate::audio_bus_effect_slot_dispatch::Call>,Error>{
  struct Bound<'a,B>{g:&'a Graph,sources:&'a Sources,store:&'a mut Store,backend:&'a mut B,primary:u32,rate:u32,results:&'a mut Vec<(u32,u32,u32)>}
  impl<B:Backend>crate::audio_bus_effect_slot_dispatch::Refresh for Bound<'_,B>{fn refresh(&mut self,r:u32,v:&mut Voice,binding:crate::audio_bus_effect_slot_dispatch::Binding,index:u32)->Result<(),Error>{let bound=match binding{crate::audio_bus_effect_slot_dispatch::Binding::Primary=>self.primary,crate::audio_bus_effect_slot_dispatch::Binding::VoiceBus(_)=>word(v,0x4d0)};let result=self.store.replace(self.g,self.sources,r,v,bound,index,self.rate,self.backend)?;self.results.push((r,index,result));Ok(())}}
  let mut bound=Bound{g,sources:&inputs.sources,store:self.store,backend:self.backend,primary:self.primary,rate:self.sample_rate,results:&mut self.results};crate::audio_bus_effect_slot_dispatch::dispatch(b,targets,index,&mut bound)
 }
}
#[cfg(test)]pub(crate) mod tests{
 use super::*;use crate::{audio_bus_registry::Bus,audio_bus_effects_bank::Cache};
 pub(crate) struct Trace{pub profile:String,pub query:u32,pub calls:Vec<serde_json::Value>,pub context:[u8;28],pub locks:u32,pub unlocks:u32}
 impl Trace{pub(crate) fn new(profile:&str)->Self{Self{profile:profile.into(),query:0,calls:vec![],context:[0xa5;28],locks:0,unlocks:0}}fn event(&mut self,kind:&str,reference:u32){self.calls.push(serde_json::json!({"kind":kind,"reference":reference}));}}
 impl Backend for Trace{
  fn retained(&mut self,_:&Resource)->Result<(),Error>{Ok(())}
  fn lock(&mut self,_:bool)->Result<(),Error>{self.locks+=1;Ok(())}fn unlock(&mut self,_:bool)->Result<(),Error>{self.unlocks+=1;Ok(())}
  fn rtpc_nonzero(&mut self,_:u32,_:u32,_:u32)->Result<bool,Error>{Err(Error::Backend("RTPC not supplied in static instance reference"))}
  fn factory(&mut self,id:u32)->Result<Factory,Error>{let status=if self.profile=="factory_fail"{7}else{1};self.calls.push(serde_json::json!({"kind":"factory","id":id,"status":status}));Ok(Factory{status,plugin:if status==1{0x30005300}else{0}})}
  fn info(&mut self,_:u32)->Result<Info,Error>{self.query+=1;let mut raw=[0;8];raw[4]=u8::from(self.profile!="not_inplace");raw[5]=u8::from(self.profile=="info_flag" && self.query==2);let status=if self.profile=="info_fail" && self.query==2{7}else{1};self.calls.push(serde_json::json!({"kind":"plugin_info","query":self.query,"status":status,"raw":raw.iter().map(|b|format!("{b:02x}")).collect::<String>()}));Ok(Info{status,raw})}
  fn plugin_destroy(&mut self,p:u32)->Result<(),Error>{self.event("plugin_destroy",p);Ok(())}
  fn clone_parameter(&mut self,p:u32)->Result<u32,Error>{self.event("clone",p);Ok(if self.profile=="clone_fail"{0}else{0x30005100})}
  fn bind(&mut self,_:u32,_:[u32;6],_:u32)->Result<(),Error>{Err(Error::Backend("nonempty parameter bindings not supplied in reference"))}
  fn allocate(&mut self,size:u32)->Result<Option<Allocation>,Error>{self.calls.push(serde_json::json!({"kind":"allocate","size":size}));Ok(if self.profile=="allocation_fail"{None}else{Some(Allocation{reference:0x30005200,raw:[0xa5;28]})})}
  fn write_context(&mut self,_:u32,raw:[u8;28])->Result<(),Error>{self.context=raw;Ok(())}
  fn context_destroy(&mut self,r:u32)->Result<(),Error>{self.event("context_destroy",r);Ok(())}fn free(&mut self,r:u32)->Result<(),Error>{self.event("free",r);Ok(())}
  fn unsubscribe(&mut self,p:u32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"unsubscribe","parameter":p}));Ok(())}
  fn parameter_destroy(&mut self,p:u32)->Result<(),Error>{self.event("parameter_destroy",p);Ok(())}
  fn init(&mut self,_:u32,context:u32,parameter:u32,format:[u8;8])->Result<u32,Error>{let status=if self.profile=="init_fail"{7}else{1};self.calls.push(serde_json::json!({"kind":"plugin_init","context":context,"parameter":parameter,"format":format.iter().map(|b|format!("{b:02x}")).collect::<String>(),"status":status}));Ok(status)}
  fn reset(&mut self,_:u32)->Result<u32,Error>{let status=if self.profile=="reset_fail"{7}else{1};self.calls.push(serde_json::json!({"kind":"plugin_reset","status":status}));Ok(status)}
  fn release(&mut self,r:&mut Resource)->Result<(),Error>{r.references=r.references.wrapping_sub(1);self.event("resource_release",r.reference);Ok(())}
 }
 #[test]fn audio_effect_instance_replacement_matches1280_native_status_cleanup_and_memory_cases(){
  let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_effect_instance_contract.json")).unwrap();assert_eq!(p["case_count"],1280);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut g=Graph::default();let mut b=Bus{reference:0x30002000,raw:[0;200]};b.set_word(0,0xff1380);b.set_word(0x18,0x30003000);g.buses.insert(b.reference,b);let mut cache=Cache{raw:[0;36]};let index=row["index"].as_u64().unwrap()as u32;cache.raw[index as usize*8+1]=row["category"].as_u64().unwrap()as u8;cache.raw[index as usize*8+4..index as usize*8+8].copy_from_slice(&100u32.to_le_bytes());cache.raw[32]=row["bypass"].as_u64().unwrap()as u8;g.caches.insert(0x30003000,cache);let profile=row["profile"].as_str().unwrap();let mut store=Store::default();store.resources.insert(0x30006000,Resource{reference:0x30006000,id:100,references:7,plugin_id:0x00810003,parameter:0x30005000,bindings:vec![]});if profile!="none"{store.buckets.insert((row["category"]!=0,100%193),vec![0x30006000]);}let mut trace=Trace::new(profile);let mut voice=Voice{raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let result=store.replace(&g,&Sources::default(),0x30001000,&mut voice,0x30002000,index,48000,&mut trace).unwrap();assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(voice.raw,crate::audio_spatial_controls::tests::hex::<0x500>(row["after"].as_str().unwrap()),"voice {case}");assert_eq!(trace.context,crate::audio_spatial_controls::tests::hex::<28>(row["context"].as_str().unwrap()),"context {case}");assert_eq!(serde_json::json!(trace.calls),row["calls"],"complete lifecycle order {case}");assert_eq!(u64::from(store.resources[&0x30006000].references),row["resource_refcount"].as_u64().unwrap(),"references {case}");assert_eq!((trace.locks,trace.unlocks),(1,1));}
 }
 #[test]fn audio_effect_instance_invalid_slot_has_no_teardown(){let mut v=Voice{raw:[0xa5;0x500]};let mut b=Trace::new("success");let mut store=Store::default();assert!(store.replace(&Graph::default(),&Sources::default(),1,&mut v,0,4,48000,&mut b).is_err());assert_eq!(v.raw,[0xa5;0x500]);assert!(b.calls.is_empty());}
}
