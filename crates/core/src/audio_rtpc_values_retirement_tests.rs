use super::*;
use crate::audio_rtpc_subscriber_release::{Manager,Record,Binding};
use serde_json::{Value,json};
fn bytes(s:&str)->Vec<u8>{s.as_bytes().chunks_exact(2).map(|p|u8::from_str_radix(std::str::from_utf8(p).unwrap(),16).unwrap()).collect()}
fn hx(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
fn u(v:&Value)->u32{v.as_u64().unwrap()as u32}
fn contract()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_values_retirement_contract.json")).unwrap()}
fn take(map:&mut BTreeMap<u32,Memory>,p:u32)->Memory{if p==0{Memory{reference:0,raw:vec![]}}else{map.remove(&p).unwrap()}}
fn prepared(row:&Value)->(FreshInitializationOwner,Values,Bus){
 let b=&row["before"];let mut map:BTreeMap<u32,Memory>=b["blocks"].as_array().unwrap().iter().map(|v|{assert_eq!(v["freed"],false);let p=u(&v["reference"]);(p,Memory{reference:p,raw:bytes(v["raw"].as_str().unwrap())})}).collect();
 let reference=u(&b["manager"]);let full=take(&mut map,reference).raw;let registry=take(&mut map,u(&b["node_registry"]));let pool_nodes=take(&mut map,word(&full,0x934));
 let mut manager=Manager{raw:full[..0x920].try_into().unwrap(),records:BTreeMap::new(),bindings:BTreeMap::new()};let mut values=Values::default();
 for bucket in 0..193{let mut p=word(&manager.raw,bucket*4);while p!=0{let memory=take(&mut map,p);let next=word(&memory.raw,4);let table=word(&memory.raw,12);if table!=0{values.blocks.insert(table,take(&mut map,table));}let subscribers=take(&mut map,word(&memory.raw,28));manager.records.insert(p,Record{memory,subscribers});p=next;}}
 for bucket in 0..193{let mut p=word(&manager.raw,0x614+bucket*4);while p!=0{let memory=take(&mut map,p);let next=word(&memory.raw,8);let curves=take(&mut map,word(&memory.raw,20));let points=word(&curves.raw,8);let point=take(&mut map,points);manager.bindings.insert(p,Binding{memory,curves,points:BTreeMap::from([(points,point)])});p=next;}}
 let bus_memory=take(&mut map,u(&row["remaining_owned_refs"]["Bus200"]));assert!(map.is_empty());
 let sections=b["locks"].as_array().unwrap().iter().map(|s|{assert_eq!(s["held"],0);assert_eq!(s["deleted"],false);u(&s["reference"])}).collect();
 (FreshInitializationOwner{reference,pool_id:u32::MAX,manager,opaque_tail:full[0x920..].try_into().unwrap(),node_registry:registry,pool_nodes,initialized_critical_sections:sections},values,Bus{reference:bus_memory.reference,raw:bus_memory.raw.try_into().unwrap()})
}
fn start(row:&Value)->Retiring{let(o,v,b)=prepared(row);match begin(o,v,b){Ok(r)=>r,Err(e)=>panic!("source begin rejected: {:?}",e.error)}}
fn project(e:&Value)->Value{match e["kind"].as_str().unwrap(){
 "native_entry"=>json!({"kind":"native_entry","entry":e["entry"],"receiver":e["receiver"],"args":e["args"]}),
 "owned_write"=>json!({"kind":"owned_write","pc":e["pc"],"reference":e["reference"],"offset":e["offset"],"bytes":e["bytes"],"value":e["value"],"old_raw":e["old_raw"]}),
 "native_physical_free_entry"=>json!({"kind":"native_physical_free_entry","entry":e["entry"],"reference":e["reference"],"pool":e["pool"],"size":e["size"],"native_before":e["native_before"],"manager_raw":e["manager_raw"]}),
 other=>panic!("unexpected native event {other}")}}
struct Provider{last:Snapshot,live:BTreeMap<u32,Vec<u8>>,freed:BTreeMap<u32,Vec<u8>>,events:Vec<Value>,attempts:Vec<u32>,fail:Option<Role>,uncertain:bool}
impl Provider{fn new(s:Snapshot)->Self{Self{live:s.blocks.iter().map(|(&p,b)|(p,b.memory.raw.clone())).collect(),last:s,freed:BTreeMap::new(),events:vec![],attempts:vec![],fail:None,uncertain:false}}}
impl Services for Provider{
 fn free_owned(&mut self,pool:u32,role:Role,m:&Memory)->FreeResult{
  assert_eq!(pool,u32::MAX);assert_eq!(self.live.get(&m.reference),Some(&m.raw));self.attempts.push(m.reference);
  if self.fail==Some(role){self.fail=None;return if self.uncertain{FreeResult::Indeterminate(Error::Backend("explicit uncertain physical provider fixture"))}else{FreeResult::Retained(Error::Backend("explicit retained physical provider fixture"))};}
  self.events.push(json!({"kind":"native_physical_free_entry","entry":"0xada3e0","reference":m.reference,"pool":pool,"size":m.raw.len(),"native_before":hx(&m.raw),"manager_raw":hx(&self.last.blocks[&self.last.manager].memory.raw)}));
  assert!(self.freed.insert(m.reference,self.live.remove(&m.reference).unwrap()).is_none());FreeResult::Freed
 }
 fn observe(&mut self,operation:Operation,s:&Snapshot){
  match operation{
   Operation::Entry{va,receiver,argument}=>self.events.push(json!({"kind":"native_entry","entry":format!("{va:#x}"),"receiver":receiver,"args":argument.into_iter().collect::<Vec<_>>()})),
   Operation::Write{pc,reference,offset,value}=>self.events.push(json!({"kind":"owned_write","pc":format!("{pc:#x}"),"reference":reference,"offset":offset,"bytes":4,"value":value,"old_raw":hx(&self.last.blocks[&reference].memory.raw[offset..offset+4])})),
   Operation::Free{..}=>{},
  }
  for(&p,b)in &s.blocks{if b.custody==Custody::Live{assert!(self.live.contains_key(&p));self.live.insert(p,b.memory.raw.clone());}else{assert!(!self.live.contains_key(&p));}}
  self.last=s.clone();
 }
}
fn compare_history(s:&Snapshot,row:&Value){
 let blocks=row["after"]["blocks"].as_array().unwrap();assert_eq!(s.blocks.len(),blocks.len());assert!(!s.poisoned);assert_eq!(s.cursor,s.actions);
 for b in blocks{let p=u(&b["reference"]);let actual=&s.blocks[&p];let freed=b["freed"].as_bool().unwrap();assert_eq!(actual.custody,if freed{Custody::Freed}else{Custody::Live},"custody {p:x}");
  let raw=b[if freed{"last_physical_bytes_before_free"}else{"raw"}].as_str().unwrap();assert_eq!(actual.memory.raw,bytes(raw),"entire body buffer {p:x}");assert_eq!(actual.memory.raw.len(),u(&b["size"])as usize);
  if freed{assert_eq!(raw,b["retained_guest_bytes_after_free"].as_str().unwrap());}
 }
 assert_eq!(s.blocks[&s.manager].memory.raw,bytes(row["after"]["manager_raw"].as_str().unwrap()));
}
#[test]
fn original_fourteen_values_retirements_match_all_owned_buffers_native_stores_free_order_and_separate_live_owners(){
 let proof=contract();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],14);
 let mut free_total=0;let mut stores=0;
 for row in proof["rows"].as_array().unwrap(){let mut r=start(row);let mut provider=Provider::new(r.snapshot());assert!(r.advance(&mut provider).unwrap());compare_history(&r.snapshot(),row);
  let expected=row["release_events"].as_array().unwrap().iter().map(project).collect::<Vec<_>>();assert_eq!(provider.events,expected,"native chronology case{}",row["index"]);
  free_total+=provider.freed.len();stores+=provider.events.iter().filter(|e|e["kind"]=="owned_write").count();let retired=match r.finish(){Ok(r)=>r,Err(_)=>panic!("finished ledger rejected")};compare_history(retired.history(),row);
  let remain=retired.remaining();assert_eq!(provider.live.len(),3);assert_eq!(remain.manager().raw.len(),0x954);assert_eq!(remain.registry().raw.len(),0x2260);assert_eq!(remain.bus().raw.len(),200);assert_eq!(remain.critical_sections().len(),11);
  for m in [remain.manager(),remain.registry(),remain.bus()]{assert_eq!(provider.live[&m.reference],m.raw);}let backing=word(&remain.manager().raw,0x934);assert_eq!(word(&remain.manager().raw,0x924),backing);assert_eq!(retired.history().blocks[&backing].custody,Custody::Freed);
 }
 assert_eq!(free_total,376);assert_eq!(stores,1198);
}
#[test]
fn late_retained_provider_failure_resumes_exact_suffix_and_uncertain_custody_forbids_double_free_and_fresh_owner_reuse(){
 let proof=contract();let row=&proof["rows"][0];let mut r=start(row);let mut provider=Provider::new(r.snapshot());provider.fail=Some(Role::PoolC0);
 assert!(r.advance(&mut provider).is_err());let paused=r.snapshot();assert!(!paused.poisoned);assert_eq!(provider.live.len(),4);assert_eq!(provider.freed.len(),26);let backing=word(&paused.blocks[&paused.manager].memory.raw,0x934);
 assert_eq!(paused.blocks[&backing].custody,Custody::Live);assert_eq!(word(&paused.blocks[&paused.manager].memory.raw,0x928),16);assert_eq!(word(&paused.blocks[&paused.manager].memory.raw,0x92c),u32::MAX);
 let mut r=match r.finish(){Err(r)=>r,Ok(_)=>panic!("partial ledger cannot be retired")};assert!(r.advance(&mut provider).unwrap());compare_history(&r.snapshot(),row);
 assert_eq!(provider.events,row["release_events"].as_array().unwrap().iter().map(project).collect::<Vec<_>>());assert_eq!(provider.attempts.iter().filter(|&&p|p==backing).count(),2);assert_eq!(provider.freed.len(),27);
 let retired=match r.finish(){Ok(r)=>r,Err(_)=>panic!("resume did not finish")};assert_eq!(retired.into_remaining().critical_sections().len(),11);
 let mut r=start(row);let mut provider=Provider::new(r.snapshot());provider.fail=Some(Role::PoolC0);provider.uncertain=true;assert!(r.advance(&mut provider).is_err());assert!(r.snapshot().poisoned);assert_eq!(r.snapshot().blocks[&backing].custody,Custody::Indeterminate);
 let attempts=provider.attempts.clone();let events=provider.events.clone();assert!(r.advance(&mut provider).is_err());assert_eq!(provider.attempts,attempts);assert_eq!(provider.events,events);assert!(r.finish().is_err());
 // Validation returns every original input before taking custody or mutating
 // bytes, even when public legacy metadata tries to alias the pool backing.
 let(mut owner,mut values,bus)=prepared(row);let original=owner.full_raw();let original_values=values.blocks.iter().map(|(&p,m)|(p,m.raw.clone())).collect::<BTreeMap<_,_>>();let pool=owner.pool_nodes.reference;values.blocks.insert(pool,owner.pool_nodes.clone());
 let error=match begin(owner,values,bus){Err(e)=>e,Ok(_)=>panic!("foreign/unconnected Values alias admitted")};assert!(matches!(error.error,Error::InvalidAllocation));assert_eq!(error.owner.full_raw(),original);assert_eq!(error.values.blocks.len(),original_values.len()+1);assert_eq!(error.bus.raw.len(),200);
 let(mut owner,values,bus)=prepared(row);owner.node_registry.reference=u32::MAX-10;let error=match begin(owner,values,bus){Err(e)=>e,Ok(_)=>panic!("overflowing registry references admitted")};assert!(matches!(error.error,Error::InvalidAllocation));
}
