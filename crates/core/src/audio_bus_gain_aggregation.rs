//! Native B02CE0/B03610 Bus gain, including x87 parent precision.
//! State and RTPC providers and gain application are mandatory dependencies.
use crate::{audio_bus_bank::Error,audio_bus_effects_changed::{self as changed,Graph}};
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone)]pub struct Entry{pub next:u32,pub value:f32}
#[derive(Debug,Default)]pub struct Inputs{
 pub tables:crate::audio_bus_properties_bank::Tables,
 pub sources:crate::audio_bus_source_mask::Store,
 pub ranges:BTreeMap<u32,Vec<u8>>,
 pub lists:BTreeMap<u32,Entry>,
}
pub trait Contribution{
 fn state(&mut self,node:u32,mask:u32,graph:&Graph)->Result<f32,Error>;
 fn rtpc(&mut self,node:u32,parameter:u32,owner:u32)->Result<Vec<f32>,Error>;
}
pub trait State{fn contribution(&mut self,node:u32,mask:u32,graph:&Graph)->Result<f32,Error>;}
/// Uses the qualified actual RTPC manager; state lifetime and loading remain explicit.
pub struct Managed<'a,S>{pub state:&'a mut S,pub manager:&'a crate::audio_rtpc_manager::Manager}
impl<S:State>Contribution for Managed<'_,S>{
 fn state(&mut self,n:u32,m:u32,g:&Graph)->Result<f32,Error>{self.state.contribution(n,m,g)}
 fn rtpc(&mut self,n:u32,p:u32,o:u32)->Result<Vec<f32>,Error>{
  let Some(routes)=self.manager.bindings.get(&(n,p))else{return Ok(vec![0.]);};
  let mut previous=0f32;let mut last=vec![0.];
  for route in routes{
   // Scaling2 returns a retained x87 logarithm, not an f32 curve result.
   // Its extended consumer must be qualified before use in this path.
   if route.curve.scaling!=0{return Err(Error::Backend("unqualified extended Bus RTPC curve scaling"));}
   let input=self.manager.value(route.rtpc,o).map_err(|_|Error::Backend("Bus gain RTPC value failed"))?;
   let value=finite(route.curve.evaluate(input).map_err(|_|Error::Backend("Bus gain RTPC curve failed"))?)?;
   last=vec![value,previous];previous=extended_sum(&last)?;
  }
  Ok(last)
 }
}
fn finite(v:f32)->Result<f32,Error>{if v.is_finite(){Ok(v)}else{Err(Error::Backend("nonfinite Bus gain outside qualified range"))}}
pub(crate) fn lookup(raw:&[u8],key:u8,stride:usize)->Result<Option<f32>,Error>{
 let count=usize::from(*raw.first().ok_or(Error::Truncated)?);let start=(count+4)&!3;
 if raw.len()<start+count*stride{return Err(Error::Truncated);}
 for i in 0..count{if raw[i+1]==key{let at=start+i*stride;return finite(f32::from_le_bytes(raw[at..at+4].try_into().unwrap())).map(Some);}}
 Ok(None)
}
/// Native FINIT reference uses 64-bit significand and nearest-even rounding.
/// Keep the entire parent addition chain in x87; f64 loses cancellation terms.
fn extended_sum(values:&[f32])->Result<f32,Error>{
 if values.is_empty(){return Err(Error::Backend("empty Bus gain sum"));}
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]{
  let mut output=0f32;let mut saved=0u16;let native=0x037fu16;
  // All input storage stays alive throughout assembly. One stack entry is
  // pushed and popped, and the caller's control word is restored.
  unsafe{std::arch::asm!(
   "fnstcw word ptr [{saved}]","fldcw word ptr [{native}]",
   "fld dword ptr [{ptr}]","add {ptr}, 4","dec {count}","jz 3f",
   "2:","fadd dword ptr [{ptr}]","add {ptr}, 4","dec {count}","jnz 2b",
   "3:","fstp dword ptr [{output}]","fldcw word ptr [{saved}]",
   ptr=inout(reg)values.as_ptr()=>_,count=inout(reg)values.len()=>_,
   saved=in(reg)&mut saved,native=in(reg)&native,output=in(reg)&mut output,
   out("st(0)")_,options(nostack),
  );}
  finite(output)
 }
 #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]{let _=values;Err(Error::Backend("native x87 Bus gain unavailable"))}
}
/// AFEF40 cached-state chain: gated by Bus2Ebit7, entry+8 next,
/// entry+10 range-table pointer; use the first value, never the range maximum.
#[derive(Debug,Clone)]pub struct StateEntry{pub next:u32,pub table:u32}
#[derive(Debug,Default)]pub struct CachedStates{pub entries:BTreeMap<u32,StateEntry>,pub tables:BTreeMap<u32,Vec<u8>>}
impl State for CachedStates{
 fn contribution(&mut self,n:u32,m:u32,g:&Graph)->Result<f32,Error>{
  let key=match m{1=>0,8=>4,_=>return Err(Error::Backend("unqualified Bus cached state mask"))};
  let b=g.buses.get(&n).ok_or(Error::UnresolvedReference)?;if b.raw[0x2e]&0x80==0{return Ok(0.);}
  let mut at=b.word(0x10);let mut sum=0f32;let mut seen=BTreeSet::new();
  while at!=0{
   if !seen.insert(at){return Err(Error::CyclicList);}let e=self.entries.get(&at).ok_or(Error::MissingControl(at))?;
   if e.table!=0{let raw=self.tables.get(&e.table).ok_or(Error::Backend("missing Bus cached state table"))?;if let Some(v)=lookup(raw,key,8)?{sum=finite(v+sum)?;}}
   at=e.next;
  }
  Ok(sum)
 }
}
impl Inputs{
 fn local(&self,graph:&Graph,node:u32,key:u8)->Result<(f32,Option<f32>,f32),Error>{
  let b=graph.buses.get(&node).ok_or(Error::UnresolvedReference)?;
  if node==0 || b.reference!=node{return Err(Error::UnresolvedReference);}if b.word(0)!=0xff1380{return Err(Error::WrongClass);}
  if b.word(0x18)!=0 && !graph.caches.contains_key(&b.word(0x18)){return Err(Error::MissingEffectsCache(b.word(0x18)));}
  let static_value=if b.word(0x28)==0{0.}else{lookup(self.tables.values.get(&b.word(0x28)).ok_or(Error::Backend("missing Bus gain property table"))?,key,4)?.unwrap_or(0.)};
  let minimum=if b.word(0x14)==0{None}else{
   let source=self.sources.sources.get(&b.word(0x14)).ok_or(Error::MissingAudioSource(b.word(0x14)))?;
   let pointer=u32::from_le_bytes(source[12..16].try_into().unwrap());
   if pointer==0{None}else{lookup(self.ranges.get(&pointer).ok_or(Error::Backend("missing Bus gain range table"))?,key,8)?}
  };
  let mut at=b.word(if key==0{0x84}else{0xa0});let mut seen=BTreeSet::new();let mut sum=0f32;
  while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}let e=self.lists.get(&at).ok_or(Error::MissingControl(at))?;sum=finite(finite(e.value)?+sum)?;at=e.next;}
  let baseline=finite(f32::from_bits(b.word(0x64)))?;
  Ok((static_value,minimum,if baseline>sum{baseline}else{sum}))
 }
 pub fn evaluate(&self,graph:&Graph,node:u32,args:[u32;2],backend:&mut impl Contribution)->Result<f32,Error>{
  if args[0]>1 || ![0,4].contains(&args[1]){return Err(Error::Backend("unqualified Bus gain arguments"));}
  let key=args[1]as u8;let mut seen=BTreeSet::new();let mut chain=Vec::new();let mut at=node;
  // Validate the selected chain before calling external state or RTPC code.
  loop{
   if !seen.insert(at){return Err(Error::Backend("cyclic Bus gain parent hierarchy"));}
   let local=self.local(graph,at,key)?;chain.push((at,local));let parent=graph.buses[&at].word(0x24);
   if parent==0{break;}
   // The parent predicate reads its cache even when that parent is not added.
   let b=graph.buses.get(&parent).ok_or(Error::UnresolvedReference)?;
   if b.reference!=parent || b.word(0)!=0xff1380{return Err(Error::WrongClass);}
   if b.word(0x18)!=0 && !graph.caches.contains_key(&b.word(0x18)){return Err(Error::MissingEffectsCache(b.word(0x18)));}
   if args[0]==0 && graph.processing(parent){break;}at=parent;
  }
  let mut locals=Vec::with_capacity(chain.len());
  for(n,(static_value,minimum,list))in chain{
   let state=finite(backend.state(n,if key==0{1}else{8},graph)?)?;
   let mut value=finite(static_value+state)?;
   let b=&graph.buses[&n];let mask=u64::from(b.word(0x30))|(u64::from(b.word(0x34))<<32);
   if mask&(1u64<<key)!=0{let mut rtpc=backend.rtpc(n,u32::from(key),0)?;if rtpc.is_empty(){return Err(Error::Backend("missing extended RTPC value"));}for v in &rtpc{finite(*v)?;}rtpc.push(value);value=extended_sum(&rtpc)?;}
   if let Some(min)=minimum{value=finite(min+value)?;}
   locals.push(finite(list+value)?);
  }
  locals.reverse();extended_sum(&locals)
 }
}
pub trait Application{fn root(&mut self,kind:u32,bits:u32,graph:&Graph)->Result<(),Error>;fn bus(&mut self,id:u32,bits:u32,graph:&Graph)->Result<(),Error>;}
/// Refresh passes its live graph, including the just-updated effect IDs.
pub struct Backend<'a,C,A>{pub inputs:&'a Inputs,pub contribution:&'a mut C,pub application:&'a mut A}
impl<C:Contribution,A:Application>changed::Gain for Backend<'_,C,A>{
 fn gain(&mut self,n:u32,args:[u32;2],graph:&Graph)->Result<f32,Error>{self.inputs.evaluate(graph,n,args,self.contribution)}
 fn root(&mut self,k:u32,b:u32,g:&Graph)->Result<(),Error>{self.application.root(k,b,g)}
 fn bus(&mut self,id:u32,b:u32,g:&Graph)->Result<(),Error>{self.application.bus(id,b,g)}
}
#[cfg(test)]mod tests{
 use super::*;use crate::audio_bus_registry::Bus;
 struct Trace{states:BTreeMap<u32,f32>,rtpc:Option<f32>,calls:Vec<serde_json::Value>}
 impl Contribution for Trace{
  fn state(&mut self,n:u32,m:u32,_:&Graph)->Result<f32,Error>{let v=self.states[&n];self.calls.push(serde_json::json!({"kind":"state","node":n,"mask":m,"bits":v.to_bits()}));Ok(v)}
  fn rtpc(&mut self,n:u32,p:u32,o:u32)->Result<Vec<f32>,Error>{self.calls.push(serde_json::json!({"kind":"rtpc","node":n,"parameter":p,"owner":o}));Ok(vec![self.rtpc.unwrap()])}
 }
 fn table(key:u8,values:&[f32])->Vec<u8>{let mut raw=vec![1,key,0,0];for v in values{raw.extend_from_slice(&v.to_le_bytes());}raw}
 #[test]fn audio_bus_gain_matches3456_native_aggregation_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_gain_aggregation_contract.json")).unwrap();assert_eq!(proof["case_count"],3456);
  for(case,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
   let key=row["property"].as_u64().unwrap()as u8;let mut graph=Graph::default();let mut inputs=Inputs::default();let mut trace=Trace{states:BTreeMap::new(),rtpc:row["rtpc"].as_f64().map(|v|v as f32),calls:vec![]};
   for(i,n)in row["nodes"].as_array().unwrap().iter().enumerate(){
    let reference=n["reference"].as_u64().unwrap()as u32;let mut b=Bus{reference,raw:[0;200]};b.set_word(0,0xff1380);b.set_word(0x24,n["parent"].as_u64().unwrap()as u32);b.set_word(0x64,(n["baseline"].as_f64().unwrap()as f32).to_bits());
    let cache=0x30004000+i as u32*0x100;b.set_word(0x18,cache);let mut effects=crate::audio_bus_effects_bank::Cache{raw:[0;36]};if row["parent_stage"]==true && i==1{effects.raw[4..8].copy_from_slice(&777u32.to_le_bytes());}graph.caches.insert(cache,effects);
    if let Some(v)=n["static"].as_f64(){let ptr=0x30005000+i as u32*0x100;b.set_word(0x28,ptr);inputs.tables.values.insert(ptr,table(key,&[v as f32]));}
    let source=0x30006000+i as u32*0x100;b.set_word(0x14,source);let mut raw=[0;20];if let Some(v)=n["minimum"].as_f64(){let ptr=0x30007000+i as u32*0x100;raw[12..16].copy_from_slice(&ptr.to_le_bytes());inputs.ranges.insert(ptr,table(key,&[v as f32,777.]));}inputs.sources.sources.insert(source,raw);
    let values=n["list_values"].as_array().unwrap();for(j,v)in values.iter().enumerate(){let ptr=0x30008000+i as u32*0x200+j as u32*0x40;inputs.lists.insert(ptr,Entry{next:if j+1<values.len(){ptr+0x40}else{0},value:v.as_f64().unwrap()as f32});if j==0{b.set_word(if key==0{0x84}else{0xa0},ptr);}}
    if trace.rtpc.is_some(){b.set_word(0x30,1<<key);}trace.states.insert(reference,n["state"].as_f64().unwrap()as f32);graph.buses.insert(reference,b);
   }
   let result=inputs.evaluate(&graph,0x30001000,[row["traverse"].as_u64().unwrap()as u32,u32::from(key)],&mut trace).unwrap();assert_eq!(u64::from(result.to_bits()),row["result_bits"].as_u64().unwrap(),"gain {case}");assert_eq!(serde_json::json!(trace.calls),row["calls"],"calls {case}");
  }
 }
 #[test]fn audio_bus_gain_parent_precision_matches84_native_cancellation_cases(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_gain_precision_contract.json")).unwrap();assert_eq!(p["case_count"],84);assert_eq!(p["f64_mismatches"],26);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut graph=Graph::default();let mut inputs=Inputs::default();let mut trace=Trace{states:BTreeMap::new(),rtpc:None,calls:vec![]};let key=row["property"].as_u64().unwrap()as u8;
   for i in 0..3{let reference=100+i;let mut bus=Bus{reference,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(0x24,if i<2{reference+1}else{0});bus.set_word(0x28,reference+100);inputs.tables.values.insert(reference+100,table(key,&[f32::from_bits(row["local_bits"][i as usize].as_u64().unwrap()as u32)]));graph.buses.insert(reference,bus);trace.states.insert(reference,0.);}
   assert_eq!(u64::from(inputs.evaluate(&graph,100,[1,u32::from(key)],&mut trace).unwrap().to_bits()),row["result_bits"].as_u64().unwrap(),"precision {case}");
  }
 }
 #[test]fn audio_bus_gain_rejects_invalid_graph_before_external_calls(){let mut g=Graph::default();let mut bus=Bus{reference:1,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(0x24,1);g.buses.insert(1,bus);let mut t=Trace{states:BTreeMap::from([(1,0.)]),rtpc:None,calls:vec![]};let i=Inputs::default();assert!(i.evaluate(&g,1,[1,0],&mut t).is_err());assert!(t.calls.is_empty());assert!(i.evaluate(&g,1,[0,7],&mut t).is_err());assert!(t.calls.is_empty());}
}
#[cfg(test)]mod consumer_tests{
 use super::*;use crate::{audio_bus_registry::Bus,audio_curves::{Curve,Point},audio_rtpc_manager::{Manager,RouteCurve,Record}};
 use std::{rc::Rc,cell::RefCell};type Calls=Rc<RefCell<Vec<serde_json::Value>>>;
 struct TracedState{store:CachedStates,calls:Calls}
 impl State for TracedState{fn contribution(&mut self,n:u32,m:u32,g:&Graph)->Result<f32,Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"state","node":n,"mask":m}));self.store.contribution(n,m,g)}}
 struct Traced<'a>{inner:Managed<'a,TracedState>,calls:Calls}
 impl Contribution for Traced<'_>{
  fn state(&mut self,n:u32,m:u32,g:&Graph)->Result<f32,Error>{self.inner.state(n,m,g)}
  fn rtpc(&mut self,n:u32,p:u32,o:u32)->Result<Vec<f32>,Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"rtpc","node":n,"parameter":p,"owner":o}));self.inner.rtpc(n,p,o)}
 }
 struct Sink{calls:Calls}
 impl Application for Sink{fn root(&mut self,k:u32,b:u32,_:&Graph)->Result<(),Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"root_gain","args":[k,b]}));Ok(())}fn bus(&mut self,id:u32,b:u32,_:&Graph)->Result<(),Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"bus_gain","args":[id,b]}));Ok(())}}
 fn bytes(v:&serde_json::Value)->Vec<u8>{crate::audio_bus_properties_bank::tests::bytes(v.as_str().unwrap())}
 #[test]fn audio_bus_actual_gain_state_manager_and_refresh_match864_native_cases(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_gain_consumers_contract.json")).unwrap();assert_eq!(p["case_count"],864);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){
   let mut graph=Graph::default();let mut inputs=Inputs::default();let mut states=CachedStates::default();let mut manager=Manager::default();let profile=row["rtpc_profile"].as_u64().unwrap();manager.records.insert(100,Record{default:20.,overrides:if profile==2{BTreeMap::from([(0,25.),(77,75.)])}else{BTreeMap::new()}});
   for(i,node)in row["nodes"].as_array().unwrap().iter().enumerate(){
    let reference=node["reference"].as_u64().unwrap()as u32;graph.buses.insert(reference,Bus{reference,raw:crate::audio_spatial_controls::tests::hex(row["before"][i].as_str().unwrap())});
    graph.caches.insert(node["cache"].as_u64().unwrap()as u32,crate::audio_bus_effects_bank::Cache{raw:crate::audio_spatial_controls::tests::hex(node["cache_raw"].as_str().unwrap())});
    if node["table"]!=0{inputs.tables.values.insert(node["table"].as_u64().unwrap()as u32,bytes(&node["table_raw"]));}
    inputs.sources.sources.insert(node["source"].as_u64().unwrap()as u32,crate::audio_spatial_controls::tests::hex(node["source_raw"].as_str().unwrap()));
    if node["range"]!=0{inputs.ranges.insert(node["range"].as_u64().unwrap()as u32,bytes(&node["range_raw"]));}
    for e in node["lists"].as_array().unwrap(){inputs.lists.insert(e["reference"].as_u64().unwrap()as u32,Entry{next:e["next"].as_u64().unwrap()as u32,value:e["value"].as_f64().unwrap()as f32});}
    for e in node["states"].as_array().unwrap(){let ptr=e["table"].as_u64().unwrap()as u32;states.entries.insert(e["reference"].as_u64().unwrap()as u32,StateEntry{next:e["next"].as_u64().unwrap()as u32,table:ptr});states.tables.insert(ptr,bytes(&e["raw"]));}
    for route in node["routes"].as_array().unwrap(){let parameter=route["parameter"].as_u64().unwrap()as u32;let begin=route["begin"].as_f64().unwrap()as f32;manager.bindings.insert((reference,parameter),vec![RouteCurve{rtpc:100,curve:Curve{scaling:0,points:vec![Point{from:0.,to:begin,interp:4},Point{from:100.,to:begin+10.,interp:4}]}}]);}
   }
   let calls:Calls=Rc::default();let mut state=TracedState{store:states,calls:calls.clone()};let mut contribution=Traced{inner:Managed{state:&mut state,manager:&manager},calls:calls.clone()};let reference=0x30001000;
   let value=inputs.evaluate(&graph,reference,[row["traverse"].as_u64().unwrap()as u32,row["property"].as_u64().unwrap()as u32],&mut contribution).unwrap();assert_eq!(u64::from(value.to_bits()),row["result_bits"].as_u64().unwrap(),"gain {case}");assert_eq!(serde_json::json!(*calls.borrow()),row["aggregate_calls"],"aggregate order {case}");calls.borrow_mut().clear();
   let mut sink=Sink{calls:calls.clone()};let mut gain=Backend{inputs:&inputs,contribution:&mut contribution,application:&mut sink};graph.changed(reference,&mut gain).unwrap();assert_eq!(serde_json::json!(*calls.borrow()),row["changed_calls"],"refresh order {case}");
   for(i,node)in row["nodes"].as_array().unwrap().iter().enumerate(){assert_eq!(graph.buses[&(node["reference"].as_u64().unwrap()as u32)].raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"][i].as_str().unwrap()),"bus {case}/{i}");}
  }
 }
 #[test]fn audio_bus_cached_state_flag_and_invalid_links_are_explicit(){let mut graph=Graph::default();let mut bus=Bus{reference:1,raw:[0;200]};bus.set_word(0x10,2);graph.buses.insert(1,bus);let mut state=CachedStates::default();assert_eq!(state.contribution(1,1,&graph).unwrap().to_bits(),0);graph.buses.get_mut(&1).unwrap().raw[0x2e]=0x80;assert_eq!(state.contribution(1,1,&graph),Err(Error::MissingControl(2)));state.entries.insert(2,StateEntry{next:2,table:0});assert_eq!(state.contribution(1,8,&graph),Err(Error::CyclicList));assert!(state.contribution(1,2,&graph).is_err());}
}
#[cfg(test)]mod rtpc_precision_tests{
 use super::*;use crate::{audio_bus_registry::Bus,audio_curves::{Curve,Point},audio_rtpc_manager::{Manager,Record,RouteCurve}};
 #[test]fn audio_bus_rtpc_precision_matches84_actual_manager_cancellation_cases(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_gain_rtpc_precision_contract.json")).unwrap();assert_eq!(p["case_count"],84);assert_eq!(p["premature_f32_mismatches"],46);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut graph=Graph::default();let mut inputs=Inputs::default();let mut manager=Manager::default();let mut states=CachedStates::default();let reference=0x30001000;let key=row["property"].as_u64().unwrap()as u8;let big=f32::from_bits(row["big_bits"].as_u64().unwrap()as u32);let small=f32::from_bits(row["small_bits"].as_u64().unwrap()as u32);let mut bus=Bus{reference,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(0x30,1<<key);bus.set_word(0x28,100);graph.buses.insert(reference,bus);let mut raw=vec![1,key,0,0];raw.extend_from_slice(&(-big).to_le_bytes());inputs.tables.values.insert(100,raw);manager.records.insert(100,Record::default());manager.bindings.insert((reference,u32::from(key)),[big,small].into_iter().map(|v|RouteCurve{rtpc:100,curve:Curve{scaling:0,points:vec![Point{from:0.,to:v,interp:4}]}}).collect());let mut managed=Managed{state:&mut states,manager:&manager};let actual=inputs.evaluate(&graph,reference,[0,u32::from(key)],&mut managed).unwrap();assert_eq!(u64::from(actual.to_bits()),row["result_bits"].as_u64().unwrap(),"RTPC precision {case}");}
 }
 #[test]fn audio_bus_extended_rtpc_scaling_is_not_silently_narrowed(){let mut states=CachedStates::default();let mut manager=Manager::default();manager.bindings.insert((1,0),vec![RouteCurve{rtpc:100,curve:Curve{scaling:2,points:vec![Point{from:0.,to:0.5,interp:4}]}}]);let mut managed=Managed{state:&mut states,manager:&manager};assert!(managed.rtpc(1,0,0).is_err());}
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]
 #[test]fn audio_bus_parent_sum_restores_callers_x87_control_word(){
  let mut original=0u16;let requested=0x027fu16;let mut observed=0u16;
  unsafe{std::arch::asm!("fnstcw word ptr [{out}]",out=in(reg)&mut original,options(nostack));std::arch::asm!("fldcw word ptr [{value}]",value=in(reg)&requested,options(nostack));}
  let value=extended_sum(&[2f32.powi(60),1.,-2f32.powi(60)]);
  unsafe{std::arch::asm!("fnstcw word ptr [{out}]",out=in(reg)&mut observed,options(nostack));std::arch::asm!("fldcw word ptr [{value}]",value=in(reg)&original,options(nostack));}
  assert_eq!(value.unwrap().to_bits(),1f32.to_bits());assert_eq!(observed,requested);
 }
}
