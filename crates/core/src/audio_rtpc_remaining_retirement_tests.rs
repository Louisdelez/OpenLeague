use super::*;
use crate::{audio_init_rtpc_owner::FreshInitializationOwner,audio_rtpc_first_global_value::Values,audio_bus_registry::Bus,
 audio_rtpc_subscriber_release::{Manager,Record,Binding},audio_rtpc_values_retirement as body};
use serde_json::{Value,json};
fn bytes(s:&str)->Vec<u8>{s.as_bytes().chunks_exact(2).map(|p|u8::from_str_radix(std::str::from_utf8(p).unwrap(),16).unwrap()).collect()}
fn hx(b:&[u8])->String{b.iter().map(|b|format!("{b:02x}")).collect()}
fn u(v:&Value)->u32{v.as_u64().unwrap()as u32}
fn proof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_remaining_retirement_contract.json")).unwrap()}
fn take(m:&mut BTreeMap<u32,Memory>,p:u32)->Memory{if p==0{Memory{reference:0,raw:vec![]}}else{m.remove(&p).unwrap()}}
/// Explicit original before-body inputs. The opaque RemainingOwners is produced
/// through the unchanged old body API; no operational wrapper is fabricated.
fn remaining(row:&Value)->RemainingOwners{
 let s=&row["before"];let mut map:BTreeMap<u32,Memory>=s["blocks"].as_array().unwrap().iter().map(|b|{assert_eq!(b["freed"],false);let p=u(&b["reference"]);(p,Memory{reference:p,raw:bytes(b["raw"].as_str().unwrap())})}).collect();
 let reference=u(&s["manager"]);let full=take(&mut map,reference).raw;let registry=take(&mut map,u(&s["node_registry"]));let pool_nodes=take(&mut map,word(&full,0x934));
 let mut manager=Manager{raw:full[..0x920].try_into().unwrap(),records:BTreeMap::new(),bindings:BTreeMap::new()};let mut values=Values::default();
 for bucket in 0..193{let mut p=word(&manager.raw,bucket*4);while p!=0{let memory=take(&mut map,p);let next=word(&memory.raw,4);let table=word(&memory.raw,12);if table!=0{values.blocks.insert(table,take(&mut map,table));}let subscribers=take(&mut map,word(&memory.raw,28));manager.records.insert(p,Record{memory,subscribers});p=next;}}
 for bucket in 0..193{let mut p=word(&manager.raw,0x614+bucket*4);while p!=0{let memory=take(&mut map,p);let next=word(&memory.raw,8);let curves=take(&mut map,word(&memory.raw,20));let point_ref=word(&curves.raw,8);let point=take(&mut map,point_ref);manager.bindings.insert(p,Binding{memory,curves,points:BTreeMap::from([(point_ref,point)])});p=next;}}
 let bus=take(&mut map,u(&row["remaining_inputs"]["Bus200"]));assert!(map.is_empty());
 let sections=s["locks"].as_array().unwrap().iter().map(|s|{assert_eq!(s["held"],0);assert_eq!(s["deleted"],false);u(&s["reference"])}).collect();
 let owner=FreshInitializationOwner{reference,pool_id:u32::MAX,manager,opaque_tail:full[0x920..].try_into().unwrap(),node_registry:registry,pool_nodes,initialized_critical_sections:sections};
 let mut r=match body::begin(owner,values,Bus{reference:bus.reference,raw:bus.raw.try_into().unwrap()}){Ok(r)=>r,Err(e)=>panic!("old body input rejected:{:?}",e.error)};
 struct BodyProvider;impl body::Services for BodyProvider{fn free_owned(&mut self,_pool:u32,_role:Role,_memory:&Memory)->FreeResult{FreeResult::Freed}}
 assert!(r.advance(&mut BodyProvider).unwrap());let retired=match r.finish(){Ok(r)=>r,Err(_)=>panic!("old body did not finish")};
 // Compare EVERY input→old-body buffer, not just the remaining three, against
 // actual native after_body. These service responses are numeric fixture
 // custody, not new real Windows HeapFree qualification.
 let native=&row["after_body"];for b in native["blocks"].as_array().unwrap(){let p=u(&b["reference"]);let actual=&retired.history().blocks[&p];let dead=b["freed"].as_bool().unwrap();assert_eq!(actual.custody,if dead{Custody::Freed}else{Custody::Live});assert_eq!(actual.memory.raw,bytes(b[if dead{"last_physical_bytes_before_free"}else{"raw"}].as_str().unwrap()));}
 retired.into_remaining()
}
fn context(row:&Value)->Context{
 let s=&row["after_body"];let g=&s["globals"];let sections=s["locks"].as_array().unwrap().iter().map(|s|{assert_eq!(s["held"],0);assert_eq!(s["deleted"],false);CriticalState{reference:u(&s["reference"]),recursion:0,custody:Custody::Live}}).collect();
 // Mandatory source ABI fixture stack, derived from the actual AF6650 trace:
 // key address=[native stack top-12], not a logical global-source default.
 let key=row["remaining_events"].as_array().unwrap().iter().find(|e|e["kind"]=="native_entry"&&e["entry"]=="0xaf6650").unwrap();let native_stack_top=u(&key["args"][0]).checked_add(12).unwrap();
 Context::supplied(GlobalWords{manager:u(&g["0x14a7a3c"]),registry:u(&g["0x14a7a08"]),pool:u(&g["0x12100dc"]),master_bus:u(&g["0x14a7aac"]),alternate_bus:u(&g["0x14a7ab0"])},sections,native_stack_top)
}
fn start(row:&Value)->Retiring{match begin(remaining(row),context(row)){Ok(r)=>r,Err(e)=>panic!("remaining inputs rejected:{:?}",e.error)}}
fn compare(s:&Snapshot,native:&Value){
 let refs=s.blocks.keys().copied().collect::<BTreeSet<_>>();let blocks=native["blocks"].as_array().unwrap().iter().filter(|b|refs.contains(&u(&b["reference"]))).collect::<Vec<_>>();assert_eq!(blocks.len(),3);
 for b in blocks{let p=u(&b["reference"]);let actual=&s.blocks[&p];let dead=b["freed"].as_bool().unwrap();assert_eq!(actual.custody,if dead{Custody::Freed}else{Custody::Live});assert_eq!(actual.memory.raw,bytes(b[if dead{"last_physical_bytes_before_free"}else{"raw"}].as_str().unwrap()),"entire remaining buffer{p:x}");}
 let g=&native["globals"];assert_eq!(s.globals,GlobalWords{manager:u(&g["0x14a7a3c"]),registry:u(&g["0x14a7a08"]),pool:u(&g["0x12100dc"]),master_bus:u(&g["0x14a7aac"]),alternate_bus:u(&g["0x14a7ab0"])});
 let locks=native["locks"].as_array().unwrap();assert_eq!(s.sections.len(),locks.len());for(a,b)in s.sections.iter().zip(locks){assert_eq!(a.reference,u(&b["reference"]));assert_eq!(a.recursion,u(&b["held"]));assert_eq!(a.custody,if b["deleted"]==true{Custody::Freed}else{Custody::Live});}
}
fn project(e:&Value)->Value{match e["kind"].as_str().unwrap(){
 "native_entry"=>json!({"kind":"entry","va":e["entry"],"receiver":e["receiver"],"args":e["args"]}),
 "owned_write"=>json!({"kind":"write","pc":e["pc"],"reference":e["reference"],"offset":e["offset"],"bytes":e["bytes"],"value":e["value"],"old_raw":e["old_raw"]}),
 "global_write"=>json!({"kind":"global","pc":e["pc"],"address":e["address"],"value":e["value"],"old_raw":e["old_raw"]}),
 "physical_CS_service"=>{let c=&e["physical_call"];json!({"kind":"critical","operation":c["kind"],"reference":c["reference"],"recursion_after":c["host_recursion"]})},
 "native_physical_free_entry"=>json!({"kind":"free_entry","pool":e["pool"],"reference":e["reference"],"size":e["size"],"raw":e["native_before"]}),
 "physical_free_completed"=>json!({"kind":"free_completed","reference":e["physical_call"]["reference"]}),
 "native_fragment_stop"=>json!({"kind":"boundary","address":e["address"]}),
 k=>panic!("unexpected event{k}")}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]enum Attempt{Store(u32,usize),Critical(CriticalOperation,u32),Free(Role),Global(u32)}
struct Provider{last:Snapshot,live:BTreeMap<u32,Vec<u8>>,dead:BTreeMap<u32,Vec<u8>>,globals:GlobalWords,sections:Vec<CriticalState>,events:Vec<Value>,attempts:Vec<Attempt>,pre_frees:Vec<Snapshot>,checkpoints:Vec<Snapshot>,fail:Option<Attempt>,uncertain:bool}
impl Provider{
 fn new(s:Snapshot)->Self{Self{live:s.blocks.iter().map(|(&p,b)|(p,b.memory.raw.clone())).collect(),globals:s.globals,sections:s.sections.clone(),last:s,dead:BTreeMap::new(),events:vec![],attempts:vec![],pre_frees:vec![],checkpoints:vec![],fail:None,uncertain:false}}
 fn retained(&mut self,a:Attempt)->Option<bool>{self.attempts.push(a);if self.fail==Some(a){self.fail=None;Some(self.uncertain)}else{None}}
 fn effect_failure(uncertain:bool)->EffectResult{if uncertain{EffectResult::Indeterminate(Error::Backend("explicit uncertain effect fixture"))}else{EffectResult::Retained(Error::Backend("explicit retained effect fixture"))}}
}
impl Services for Provider{
 fn store_owned(&mut self,_role:Role,m:&Memory,o:usize,b:&[u8])->EffectResult{assert_eq!(self.live.get(&m.reference),Some(&m.raw));if let Some(v)=self.retained(Attempt::Store(m.reference,o)){return Self::effect_failure(v);}self.live.get_mut(&m.reference).unwrap()[o..o+b.len()].copy_from_slice(b);EffectResult::Applied}
 fn critical(&mut self,k:CriticalOperation,s:CriticalState)->EffectResult{let i=self.sections.iter().position(|a|a.reference==s.reference).unwrap();assert_eq!(self.sections[i],s);if let Some(v)=self.retained(Attempt::Critical(k,s.reference)){return Self::effect_failure(v);}match k{CriticalOperation::Enter=>self.sections[i].recursion+=1,CriticalOperation::Leave=>self.sections[i].recursion-=1,CriticalOperation::Delete=>{assert_eq!(s.recursion,0);self.sections[i].custody=Custody::Freed;}}EffectResult::Applied}
 fn free_owned(&mut self,pool:u32,role:Role,m:&Memory)->FreeResult{assert_eq!(pool,u32::MAX);assert_eq!(self.live.get(&m.reference),Some(&m.raw));if let Some(v)=self.retained(Attempt::Free(role)){return if v{FreeResult::Indeterminate(Error::Backend("explicit uncertain free fixture"))}else{FreeResult::Retained(Error::Backend("explicit retained free fixture"))};}
  self.pre_frees.push(self.last.clone());self.events.push(json!({"kind":"free_entry","pool":pool,"reference":m.reference,"size":m.raw.len(),"raw":hx(&m.raw)}));assert!(self.dead.insert(m.reference,self.live.remove(&m.reference).unwrap()).is_none());self.events.push(json!({"kind":"free_completed","reference":m.reference}));FreeResult::Freed}
 fn store_global(&mut self,a:u32,old:u32,v:u32)->EffectResult{let actual=if a==0x14a7a3c{self.globals.manager}else{assert_eq!(a,0x14a7a08);self.globals.registry};assert_eq!(actual,old);if let Some(v)=self.retained(Attempt::Global(a)){return Self::effect_failure(v);}if a==0x14a7a3c{self.globals.manager=v}else{self.globals.registry=v}EffectResult::Applied}
 fn observe(&mut self,op:&Operation,s:&Snapshot){match op{
  Operation::Entry{va,receiver,args,..}=>self.events.push(json!({"kind":"entry","va":format!("{va:#x}"),"receiver":receiver,"args":args})),
  Operation::Write{pc,reference,offset,bytes,..}=>{let mut b=[0u8;4];b[..bytes.len()].copy_from_slice(bytes);self.events.push(json!({"kind":"write","pc":format!("{pc:#x}"),"reference":reference,"offset":offset,"bytes":bytes.len(),"value":u32::from_le_bytes(b),"old_raw":hx(&self.last.blocks[reference].memory.raw[*offset..*offset+bytes.len()])}));},
  Operation::Critical{operation,reference,..}=>{let n=s.sections.iter().find(|a|a.reference==*reference).unwrap();let label=match operation{CriticalOperation::Enter=>"physical_EnterCriticalSection",CriticalOperation::Leave=>"physical_LeaveCriticalSection",CriticalOperation::Delete=>"physical_DeleteCriticalSection"};self.events.push(json!({"kind":"critical","operation":label,"reference":reference,"recursion_after":n.recursion}));},
  Operation::GlobalWrite{pc,address,value,..}=>{let old=if *address==0x14a7a3c{self.last.globals.manager}else{self.last.globals.registry};self.events.push(json!({"kind":"global","pc":format!("{pc:#x}"),"address":address,"value":value,"old_raw":hx(&old.to_le_bytes())}));},
  Operation::Boundary{address,..}=>self.events.push(json!({"kind":"boundary","address":format!("{address:#x}")})),Operation::Free{..}=>{},
 }
  assert_eq!(self.globals,s.globals);assert_eq!(self.sections,s.sections);for(&p,b)in &s.blocks{if b.custody==Custody::Live{assert_eq!(self.live.get(&p),Some(&b.memory.raw));}else{assert_eq!(self.dead.get(&p),Some(&b.memory.raw));}}
  if matches!(op,Operation::Critical{pc:0xb00234,..}|Operation::Boundary{..}){self.checkpoints.push(s.clone());}self.last=s.clone();
 }
}
#[test]
fn original_fourteen_local_remaining_retirements_match_all_buffers_350_stores_42_frees_recursive_locks_154_deletes_and_global_order(){
 let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],14);let mut stores=0;let mut frees=0;let mut deletes=0;let mut globals=0;
 for row in p["rows"].as_array().unwrap(){let mut r=start(row);compare(&r.snapshot(),&row["after_body"]);let mut provider=Provider::new(r.snapshot());assert!(r.advance(&mut provider).unwrap());
  let expected=row["remaining_events"].as_array().unwrap().iter().map(project).collect::<Vec<_>>();assert_eq!(provider.events,expected,"complete native event order case{}",row["index"]);
  compare(&r.snapshot(),&row["after_registry_tail"]);assert_eq!(provider.live.len(),0);assert_eq!(provider.dead.len(),3);
  // Full raw snapshots at EACH native pre-free and end-of-stage, keeping dead
  // raw diagnostic words and globals0 distinct from live physical buffers.
  let native_frees=row["remaining_events"].as_array().unwrap().iter().filter(|e|e["kind"]=="native_physical_free_entry").collect::<Vec<_>>();assert_eq!(provider.pre_frees.len(),3);
  for(before,event)in provider.pre_frees.iter().zip(native_frees){
   compare(before,&event["full_owned_state"]);
   let at=u(&event["reference"]);assert_eq!(provider.dead[&at],bytes(event["native_before"].as_str().unwrap()));
  }
  assert_eq!(provider.checkpoints.len(),3);for(s,key)in provider.checkpoints.iter().zip(["after_Bus_release","after_Manager_tail","after_registry_tail"]){compare(s,&row[key]);}
  let done=match r.finish(){Ok(r)=>r,Err(_)=>panic!("selected complete remaining retirement rejected")};compare(done.history(),&row["after_registry_tail"]);
  stores+=provider.events.iter().filter(|e|e["kind"]=="write").count();frees+=provider.dead.len();deletes+=provider.events.iter().filter(|e|e["kind"]=="critical"&&e["operation"]=="physical_DeleteCriticalSection").count();globals+=provider.events.iter().filter(|e|e["kind"]=="global").count();
 }
 assert_eq!((stores,frees,deletes,globals),(350,42,154,28));
}
#[test]
fn retained_cs_free_and_global_failures_resume_only_exact_suffix_and_indeterminate_custody_forbids_reuse(){
 let p=proof();let row=&p["rows"][0];let registry=u(&row["remaining_inputs"]["registry2260"]);let cs=registry+0x960;
 let expected=row["remaining_events"].as_array().unwrap().iter().map(project).collect::<Vec<_>>();
 for target in [Attempt::Critical(CriticalOperation::Delete,cs),Attempt::Free(Role::Registry2260),Attempt::Global(0x14a7a3c)]{
  let mut r=start(row);let mut provider=Provider::new(r.snapshot());provider.fail=Some(target);assert!(r.advance(&mut provider).is_err());let paused=r.snapshot();assert!(!paused.poisoned);assert_eq!(provider.dead.len(),2);assert_eq!(provider.live.len(),1);assert_ne!(paused.globals.registry,0);
  let mut r=match r.finish(){Err(r)=>r,Ok(_)=>panic!("partial remaining state cannot finish")};assert!(r.advance(&mut provider).unwrap());assert_eq!(provider.events,expected);compare(&r.snapshot(),&row["after_registry_tail"]);assert_eq!(provider.attempts.iter().filter(|&&a|a==target).count(),2);
  let mut successful=provider.attempts.clone();let first=successful.iter().position(|a|a==&target).unwrap();successful.remove(first);let mut unique=BTreeSet::new();for a in successful{if let Attempt::Free(role)=a{assert!(unique.insert(format!("{role:?}")));}}assert_eq!(unique.len(),3);
  assert!(r.finish().is_ok());
 }
 for target in [Attempt::Critical(CriticalOperation::Delete,cs),Attempt::Free(Role::Registry2260),Attempt::Global(0x14a7a3c)]{
  let mut r=start(row);let mut provider=Provider::new(r.snapshot());provider.fail=Some(target);provider.uncertain=true;assert!(r.advance(&mut provider).is_err());let paused=r.snapshot();assert!(paused.poisoned);
  let attempts=provider.attempts.clone();let events=provider.events.clone();assert!(r.advance(&mut provider).is_err());assert_eq!(provider.attempts,attempts);assert_eq!(provider.events,events);assert!(r.finish().is_err());
 }
 let remain=remaining(row);let original=remain.manager().raw.clone();let mut ctx=context(row);ctx.globals.manager=0;let saved=ctx.globals;
 let e=match begin(remain,ctx){Err(e)=>e,Ok(_)=>panic!("absent actual Manager global admitted")};assert_eq!(e.remaining.manager().raw,original);assert_eq!(e.context.globals,saved);
 let remain=remaining(row);let mut ctx=context(row);ctx.sections[1].recursion=1;let e=match begin(remain,ctx){Err(e)=>e,Ok(_)=>panic!("held initialCS admitted")};assert_eq!(e.context.sections[1].recursion,1);assert_eq!(e.remaining.critical_sections().len(),11);
}
