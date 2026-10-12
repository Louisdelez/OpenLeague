//! Actual Bus virtual144 B044E0 bank orchestration and B02430 control-list order.
//! All parent/loader/allocator dependencies are mandatory; none returns success by default.
use crate::audio_bus_registry::Bus;
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone,Copy,PartialEq,Eq)] pub enum Stage {Properties,Effects,Rtpc,States,Position}
impl Stage {pub fn name(self)->&'static str{match self{Self::Properties=>"properties",Self::Effects=>"effects",Self::Rtpc=>"rtpc",Self::States=>"states",Self::Position=>"position"}}}
#[derive(Debug,PartialEq,Eq)] pub enum Error {WrongClass,UnresolvedReference,Truncated,MissingControl(u32),CyclicList,InvalidAllocation,MissingEffectsCache(u32),MissingAudioSource(u32),Application(crate::audio_bus_control_application::Error),Parent(crate::audio_bus_parent::Error),Groups(crate::audio_bus_active_groups::Error),Backend(&'static str)}
pub struct Cursor<'a>{pub bytes:&'a[u8],pub offset:usize,pub remaining:u32}
impl Cursor<'_>{
 pub fn read<const N:usize>(&mut self)->Result<[u8;N],Error>{let end=self.offset.checked_add(N).ok_or(Error::Truncated)?;let out=self.bytes.get(self.offset..end).ok_or(Error::Truncated)?.try_into().unwrap();self.offset=end;Ok(out)}
 pub fn u32(&mut self)->Result<u32,Error>{Ok(u32::from_le_bytes(self.read()?))}
 pub fn u8(&mut self)->Result<u8,Error>{Ok(self.read::<1>()?[0])}
}
#[derive(Debug,Clone)] pub struct Control{pub words:[u32;7]}
#[derive(Debug)] pub struct State{pub primary:u32,pub secondary:u32,pub sample_rate:u32,pub controls:BTreeMap<u32,Control>}
pub trait Backend{
 fn lookup(&mut self,id:u32,selector:u32)->Result<Option<u32>,Error>;
 fn retain(&mut self,node:u32)->Result<(),Error>;
 fn attach(&mut self,parent:u32,child:&mut Bus)->Result<u32,Error>;
 fn release(&mut self,node:u32)->Result<(),Error>;
 fn stage(&mut self,stage:Stage,bus:&mut Bus,cursor:&mut Cursor<'_>)->Result<u32,Error>;
 fn allocate_control(&mut self,size:u32)->Result<Option<u32>,Error>;
}
fn find(bus:&Bus,state:&State,id:u32)->Result<Option<u32>,Error>{let mut at=bus.word(0x68);let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}let e=state.controls.get(&at).ok_or(Error::MissingControl(at))?;if e.words[1]==id{return Ok(Some(at));}at=e.words[0];}Ok(None)}
fn append(bus:&mut Bus,state:&mut State,backend:&mut impl Backend)->Result<Option<u32>,Error>{
 let mut reference=bus.word(0x70);
 if reference==0{if bus.word(0x7c)>=bus.word(0x78){return Ok(None);}let Some(new)=backend.allocate_control(28)? else{return Ok(None);};if new==0 || state.controls.contains_key(&new){return Err(Error::InvalidAllocation);}state.controls.insert(new,Control{words:[0;7]});reference=new;}
 let next=state.controls.get(&reference).ok_or(Error::MissingControl(reference))?.words[0];let tail=bus.word(0x6c);
 if tail!=0{state.controls.get_mut(&tail).ok_or(Error::MissingControl(tail))?.words[0]=reference;}else{bus.set_word(0x68,reference);}
 bus.set_word(0x6c,reference);bus.set_word(0x70,next);state.controls.get_mut(&reference).ok_or(Error::MissingControl(reference))?.words[0]=0;bus.set_word(0x7c,bus.word(0x7c).wrapping_add(1));Ok(Some(reference))
}
fn validate_pool(bus:&Bus,state:&State)->Result<(),Error>{let mut at=bus.word(0x70);let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}at=state.controls.get(&at).ok_or(Error::MissingControl(at))?.words[0];}Ok(())}
/// Native result1 success / other statuses propagated. Pointer/remaining counters
/// belong to dependency readers; direct B044E0 reads advance only the pointer.
pub fn load(bus:&mut Bus,state:&mut State,cursor:&mut Cursor<'_>,backend:&mut impl Backend)->Result<u32,Error>{
 if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}validate_pool(bus,state)?;if cursor.bytes.get(cursor.offset..).is_none_or(|b|b.len()<8){return Err(Error::Truncated);}
 cursor.read::<4>()?;let parent_id=cursor.u32()?;
 if parent_id!=0{let Some(parent)=backend.lookup(parent_id,1)? else{return Ok(2);};backend.retain(bus.reference)?;let result=backend.attach(parent,bus);backend.release(parent)?;let result=result?;if result!=1{return Ok(result);}}
 else if state.primary==0{state.primary=bus.reference;bus.raw[0xc4]|=0x80;}
 else if state.secondary==0 && state.primary!=bus.reference{state.secondary=bus.reference;bus.raw[0xc4]&=0x7f;}
 let result=backend.stage(Stage::Properties,bus,cursor)?;if result!=1{return Ok(result);}
 let duration=cursor.u32()?;let factor=((u64::from(state.sample_rate)*0x10624dd3)>>38) as u32;bus.set_word(0x5c,factor.wrapping_mul(duration));bus.set_word(0x64,cursor.u32()?);let count=cursor.u32()?;
 for _ in 0..count{let id=cursor.u32()?;let gain_bits=cursor.u32()?;let first=cursor.u32()?;let second=cursor.u32()?;let a=cursor.u8()?;let b=cursor.u8()?;
  let reference=match find(bus,state,id)?{Some(r)=>r,None=>{let Some(r)=append(bus,state,backend)? else{return Ok(2);};r}};
  state.controls.get_mut(&reference).ok_or(Error::MissingControl(reference))?.words[1..].copy_from_slice(&[id,gain_bits,first,second,u32::from(a),u32::from(b)]);
 }
 for stage in [Stage::Effects,Stage::Rtpc,Stage::States,Stage::Position]{let result=backend.stage(stage,bus,cursor)?;if result!=1{return Ok(result);}}
 Ok(1)
}
#[cfg(test)] mod tests{
 use super::*;
 struct Trace{row:serde_json::Value,calls:Vec<serde_json::Value>,allocated:u32}
 impl Backend for Trace{
  fn lookup(&mut self,id:u32,selector:u32)->Result<Option<u32>,Error>{self.calls.push(serde_json::json!({"kind":"lookup","id":id,"selector":selector}));Ok(if self.row["found"]==true{Some(0x30002000)}else{None})}
  fn retain(&mut self,node:u32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"retain","node":node}));Ok(())}
  fn attach(&mut self,parent:u32,child:&mut Bus)->Result<u32,Error>{self.calls.push(serde_json::json!({"kind":"attach","parent":parent,"child":child.reference}));Ok(self.row["attach_result"].as_u64().unwrap() as u32)}
  fn release(&mut self,node:u32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"release","node":node}));Ok(())}
  fn stage(&mut self,stage:Stage,_:&mut Bus,c:&mut Cursor<'_>)->Result<u32,Error>{self.calls.push(serde_json::json!({"kind":stage.name(),"offset":c.offset,"remaining":c.remaining}));Ok(if self.row["failure_stage"]==stage.name(){2}else{1})}
  fn allocate_control(&mut self,size:u32)->Result<Option<u32>,Error>{self.calls.push(serde_json::json!({"kind":"allocate","size":size}));let pool=self.row["pool_count"].as_u64().unwrap_or(0) as u32;let reference=0x30005000+(pool+self.allocated)*0x100;self.allocated+=1;Ok(if self.row["allocation_failure"]==true{None}else{Some(reference)})}
 }
 fn bytes(hex:&str)->Vec<u8>{hex.as_bytes().chunks_exact(2).map(|v|u8::from_str_radix(std::str::from_utf8(v).unwrap(),16).unwrap()).collect()}
 fn compare_native_bank(proof:&str,count:usize){let proof:serde_json::Value=serde_json::from_str(proof).unwrap();assert_eq!(proof["case_count"],count);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let mut state=State{primary:row["primary"].as_u64().unwrap() as u32,secondary:row["secondary"].as_u64().unwrap() as u32,sample_rate:48000,controls:BTreeMap::new()};let pool=row["pool_count"].as_u64().unwrap_or(0) as u32;for i in 0..pool{let mut words=[0;7];words[0]=if i+1<pool{0x30005000+(i+1)*0x100}else{0};state.controls.insert(0x30005000+i*0x100,Control{words});}let raw=bytes(row["payload"].as_str().unwrap());let mut cursor=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut backend=Trace{row:row.clone(),calls:vec![],allocated:0};let status=load(&mut bus,&mut state,&mut cursor,&mut backend).unwrap();assert_eq!(u64::from(status),row["result"].as_u64().unwrap(),"result {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"node {case}");assert_eq!(u64::from(state.primary),row["primary_after"].as_u64().unwrap(),"primary {case}");assert_eq!(u64::from(state.secondary),row["secondary_after"].as_u64().unwrap(),"secondary {case}");assert_eq!(serde_json::json!(backend.calls),row["calls"],"trace {case}");let mut at=bus.word(0x68);let mut items=Vec::new();while at!=0{let e=&state.controls[&at];items.push(serde_json::json!({"reference":at,"words":e.words}));at=e.words[0];}assert_eq!(serde_json::json!(items),row["items"],"controls {case}");}}
 #[test] fn audio_actual_bus_bank_orchestration_and_controls_match2304_native_cases(){compare_native_bank(include_str!("../../../data/4.20/audio_bus_bank_orchestration_contract.json"),2304);}
 #[test] fn audio_bus_bank_free_pool_and_capacity_match72_native_cases(){compare_native_bank(include_str!("../../../data/4.20/audio_bus_bank_pool_contract.json"),72);}
 #[test] fn audio_bus_bank_truncated_prefix_has_no_external_or_root_effects(){let mut bus=Bus{reference:1,raw:[0;200]};bus.set_word(0,0xff1380);let before=bus.raw;let mut s=State{primary:0,secondary:0,sample_rate:48000,controls:BTreeMap::new()};let mut c=Cursor{bytes:&[0;7],offset:0,remaining:7};let mut b=Trace{row:serde_json::json!({}),calls:vec![],allocated:0};assert_eq!(load(&mut bus,&mut s,&mut c,&mut b),Err(Error::Truncated));assert!(b.calls.is_empty());assert_eq!(bus.raw,before);assert_eq!(s.primary,0);assert_eq!(c.offset,0);}
 #[test] fn audio_whole_bus_bank_with_actual_properties_matches480_native_cases(){
  use crate::audio_bus_properties_bank::{PropertiesBackend,Tables,Call,tests::SnapshotAllocator};let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_bank_properties_composition_contract.json")).unwrap();assert_eq!(p["case_count"],480);
  for (case,row) in p["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let mut state=State{primary:row["primary"].as_u64().unwrap() as u32,secondary:row["secondary"].as_u64().unwrap() as u32,sample_rate:48000,controls:BTreeMap::new()};let raw=bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut dependencies=Trace{row:row.clone(),calls:vec![],allocated:0};let mut properties=SnapshotAllocator{reference:0x30008000,failure:row["property_failure"].as_bool().unwrap()};let mut tables=Tables::default();let mut backend=PropertiesBackend{dependencies:&mut dependencies,properties:&mut properties,tables:&mut tables,traces:vec![]};let result=load(&mut bus,&mut state,&mut c,&mut backend).unwrap();assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {case}");let traces=std::mem::take(&mut backend.traces);drop(backend);assert_eq!(traces.len(),1);let parent_calls=if row["parent_id"]==0{0}else{4};let mut calls=dependencies.calls[..parent_calls].to_vec();let t=&traces[0];calls.push(serde_json::json!({"kind":"properties","offset":t.offset,"remaining":t.remaining}));for call in &t.calls{if let Call::Allocate{size}=call{calls.push(serde_json::json!({"kind":"allocate_properties","size":size}));}}calls.extend_from_slice(&dependencies.calls[parent_calls..]);assert_eq!(serde_json::json!(calls),row["calls"],"trace {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"node {case}");assert_eq!(u64::from(state.primary),row["primary_after"].as_u64().unwrap(),"primary {case}");assert_eq!(u64::from(state.secondary),row["secondary_after"].as_u64().unwrap(),"secondary {case}");assert_eq!(tables.values.get(&0x30008000).map(|v|v.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["property_table"].as_str().map(str::to_owned),"property table {case}");let mut at=bus.word(0x68);let mut items=Vec::new();while at!=0{let e=&state.controls[&at];items.push(serde_json::json!({"reference":at,"words":e.words}));at=e.words[0];}assert_eq!(serde_json::json!(items),row["items"],"controls {case}");}
 }

 #[test] fn audio_whole_bus_bank_parent_and_properties_match2048_native_cases(){
  use crate::audio_bus_parent::{self as parent,Graph,Node,Reservation,BankBackend};
  use crate::audio_bus_properties_bank::{PropertiesBackend,Tables,Call,tests::SnapshotAllocator};
  struct Operations{failure:bool,refs:Vec<(bool,u32)>}
  impl parent::Backend for Operations{
   fn reserve(&mut self,_:u32,s:u8,_:u32)->Result<Option<Reservation>,parent::Error>{Ok(if self.failure{None}else{Some(Reservation{reference:0x3000a000+u32::from(s)*0x100,capacity:4})})}
   fn retain(&mut self,n:u32)->Result<(),parent::Error>{self.refs.push((true,n));Ok(())}
   fn release(&mut self,n:u32)->Result<(),parent::Error>{self.refs.push((false,n));Ok(())}
  }
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_bank_parent_properties_contract.json")).unwrap();assert_eq!(p["case_count"],2048);
  for (case,row) in p["cases"].as_array().unwrap().iter().enumerate(){
   let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};
   let mut graph=Graph::default();
   for (reference,id) in [(bus.reference,55),(0x30002000,row["parent_id"].as_u64().unwrap() as u32),(0x3000c000,55),(0x3000c100,200),(0x3000e000,0),(0x3000e100,0)]{let mut b=Bus{reference,raw:[0;200]};b.set_word(0,0xff1380);b.set_word(8,id);graph.nodes.insert(reference,Node{bus:b,children:[vec![],vec![]]});}
   let n=graph.nodes.get_mut(&0x30002000).unwrap();n.bus.raw=crate::audio_spatial_controls::tests::hex(row["before_parent"].as_str().unwrap());if row["populated"]==true{n.children=[vec![0x3000c000,0x3000c100],vec![0x3000c000,0x3000c100]];}
   let depth=row["depth"].as_u64().unwrap() as usize;graph.nodes.get_mut(&bus.reference).unwrap().children[1]=[0x3000e000,0x3000e100][..depth].to_vec();for id in [0x3000e000,0x3000e100]{graph.nodes.get_mut(&id).unwrap().bus.raw[0xc4]=0xa5;}
   let raw=bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};
   let mut state=State{primary:0,secondary:0,sample_rate:48000,controls:BTreeMap::new()};let mut dependencies=Trace{row:row.clone(),calls:vec![],allocated:0};let mut operations=Operations{failure:row["reserve_failure"].as_bool().unwrap(),refs:vec![]};
   let mut parent_backend=BankBackend{dependencies:&mut dependencies,graph:&mut graph,operations:&mut operations,attachments:vec![]};
   let mut properties=SnapshotAllocator{reference:0x30008000,failure:row["property_failure"].as_bool().unwrap()};let mut tables=Tables::default();
   let mut backend=PropertiesBackend{dependencies:&mut parent_backend,properties:&mut properties,tables:&mut tables,traces:vec![]};
   let status=load(&mut bus,&mut state,&mut c,&mut backend).unwrap();let traces=std::mem::take(&mut backend.traces);drop(backend);let attachments=std::mem::take(&mut parent_backend.attachments);drop(parent_backend);
   assert_eq!(u64::from(status),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(attachments.len(),1);
   let mut calls=dependencies.calls[..2].to_vec();calls.push(serde_json::json!({"kind":"attach","parent":0x30002000u32,"child":bus.reference}));for call in &attachments[0].calls{calls.push(serde_json::json!(call));}calls.push(dependencies.calls[2].clone());
   for t in &traces{calls.push(serde_json::json!({"kind":"properties","offset":t.offset,"remaining":t.remaining}));for call in &t.calls{if let Call::Allocate{size}=call{calls.push(serde_json::json!({"kind":"allocate_properties","size":size}));}}}calls.extend_from_slice(&dependencies.calls[3..]);
   assert_eq!(serde_json::json!(calls),row["calls"],"full call order {case}");
   let ref_calls:Vec<_>=attachments[0].calls.iter().filter_map(|v|match v{parent::Call::Retain{node}=>Some((true,*node)),parent::Call::Release{node}=>Some((false,*node)),_=>None}).collect();assert_eq!(operations.refs,ref_calls,"lifetime interface dispatch {case}");
   assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"live child {case}");assert_eq!(graph.nodes[&0x30002000].bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after_parent"].as_str().unwrap()),"parent {case}");assert_eq!(serde_json::json!(graph.nodes[&0x30002000].children),row["parent_lists"],"lists {case}");
   let flags:Vec<_>=[0x3000e000,0x3000e100][..depth].iter().map(|r|graph.nodes[r].bus.raw[0xc4]).collect();assert_eq!(serde_json::json!(flags),row["desc_flags"],"descendants {case}");
   assert_eq!(u64::from(state.primary),row["primary_after"].as_u64().unwrap());assert_eq!(u64::from(state.secondary),row["secondary_after"].as_u64().unwrap());
   assert_eq!(tables.values.get(&0x30008000).map(|v|v.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["property_table"].as_str().map(str::to_owned),"table {case}");
   let mut at=bus.word(0x68);let mut items=Vec::new();while at!=0{let e=&state.controls[&at];items.push(serde_json::json!({"reference":at,"words":e.words}));at=e.words[0];}assert_eq!(serde_json::json!(items),row["items"],"controls {case}");
  }
 }

 #[test] fn audio_whole_bus_bank_and_actual_effects_match1536_native_cases(){use crate::audio_bus_effects_bank::{BankBackend,TargetBackend,Store,Call,tests::Snapshot};let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_bank_effects_composition_contract.json")).unwrap();assert_eq!(p["case_count"],1536);for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let mut state=State{primary:0,secondary:0,sample_rate:48000,controls:BTreeMap::new()};let raw=bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut dependencies=Trace{row:row.clone(),calls:vec![],allocated:0};let mut allocation=Snapshot{reference:0x30008000,failure:row["effect_failure"].as_bool().unwrap()};let mut targets=crate::audio_bus_control_application::Store::default();let mut effects=TargetBackend{dependencies:&mut allocation,targets:&mut targets,applied:vec![]};let mut store=Store::default();let mut backend=BankBackend{dependencies:&mut dependencies,effects:&mut effects,store:&mut store,traces:vec![]};let result=load(&mut bus,&mut state,&mut c,&mut backend).unwrap();let traces=std::mem::take(&mut backend.traces);drop(backend);assert!(effects.applied.is_empty());drop(effects);let mut calls=dependencies.calls;for t in traces{let at=calls.iter().position(|v|v["kind"]=="rtpc" || v["kind"]=="states" || v["kind"]=="position").unwrap_or(calls.len());let mut fx=vec![serde_json::json!({"kind":"effects","offset":t.offset,"remaining":t.remaining})];for call in &t.calls{fx.push(match call{Call::Allocate{size}=>serde_json::json!({"kind":"allocate_effects","size":size}),_=>serde_json::json!(call)});}calls.splice(at..at,fx);}assert_eq!(serde_json::json!(calls),row["calls"],"whole order {case}");assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");assert_eq!(u64::from(state.primary),row["primary_after"].as_u64().unwrap());assert_eq!(u64::from(state.secondary),row["secondary_after"].as_u64().unwrap());assert_eq!(store.caches.get(&bus.word(0x18)).map(|v|v.raw.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["after_cache"].as_str().map(str::to_owned),"cache {case}");let mut at=bus.word(0x68);let mut items=Vec::new();while at!=0{let e=&state.controls[&at];items.push(serde_json::json!({"reference":at,"words":e.words}));at=e.words[0];}assert_eq!(serde_json::json!(items),row["items"],"controls {case}");}}

}
