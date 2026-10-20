use crate::{audio_plugin_factory::Memory,audio_rtpc_subscriber_release::{Manager,Record,Binding},audio_bus_effects_changed::{Graph,Group},audio_bus_control_application::{Store,Voice,Root},audio_bus_registry::Bus};
use serde_json::Value;
use std::collections::BTreeMap;
use super as port;
const DATA:u32=0x30100000;const BUS:u32=DATA+0x2000;const MASTER:u32=DATA+0x2100;const CHILD1:u32=DATA+0x2400;const CHILD2:u32=DATA+0x2500;const BIND:u32=DATA+0x1300;
const KEY:u32=3273357900;
fn bytes(v:&Value)->Vec<u8>{let s=v.as_str().unwrap();(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
pub(crate) fn state(row:&Value)->(Manager,BTreeMap<u32,Memory>,Graph,Store){
 let before=&row["before"];let record=bytes(&before["record"]);let vp=word(&record,12);let subs=Memory{reference:word(&record,28),raw:BIND.to_le_bytes().to_vec()};
 let curve=bytes(&before["curve"]);let cp=word(&curve,8);let binding=bytes(&before["binding"]);
 let manager=Manager{raw:bytes(&before["manager"]).try_into().unwrap(),records:BTreeMap::from([(DATA+0x1000,Record{memory:Memory{reference:DATA+0x1000,raw:record},subscribers:subs})]),bindings:BTreeMap::from([(BIND,Binding{memory:Memory{reference:BIND,raw:binding.clone()},curves:Memory{reference:word(&binding,20),raw:curve},points:BTreeMap::from([(cp,Memory{reference:cp,raw:bytes(&before["points"])})])})])};
 let values=BTreeMap::from([(vp,Memory{reference:vp,raw:bytes(&before["overrides"])})]);let mut graph=Graph::default();
 for (key,reference) in [("bus",BUS),("master",MASTER),("child1",CHILD1),("child2",CHILD2)]{let raw:[u8;200]=bytes(&before[key]).try_into().unwrap();if word(&raw,0)==0xff1380{graph.buses.insert(reference,Bus{reference,raw});}}
 let children=bytes(&before["children"]);
 for (i,(node,next)) in [(BUS,Some(word(&children,0))),(CHILD1,Some(word(&children,4))),(CHILD2,None)].into_iter().enumerate(){if let Some(bus)=graph.buses.get(&node){let pointer=bus.word(0x1c);if pointer!=0{let raw=bytes(&before["groups"][i]);graph.groups.insert(pointer,Group{children:next.into_iter().collect(),active:[u16::from_le_bytes(raw[0x30..0x32].try_into().unwrap()),u16::from_le_bytes(raw[0x32..0x34].try_into().unwrap())]});}}}
 let registered=bytes(&before["registered"]);let roots=bytes(&before["roots"]);let mut targets=Store::default();
 for i in 0..3{let reference=word(&registered,i*4);let raw:[u8;0x500]=bytes(&before["voices"][i]).try_into().unwrap();let pointer=word(&raw,0x4d0);targets.bus_ids.insert(pointer,graph.buses[&pointer].word(8));targets.voices.insert(reference,Voice{raw});targets.registered.push(reference);targets.roots.push(Root{voice:word(&roots,i*0x38),key:[word(&roots,i*0x38+0x10),word(&roots,i*0x38+0x14)]});}
 (manager,values,graph,targets)
}
pub(crate) fn snapshot(m:&Manager,v:&BTreeMap<u32,Memory>,g:&Graph,t:&Store)->Value{serde_json::json!({"manager":m.raw.as_slice(),"records":m.records.iter().map(|(k,r)|(*k,r.memory.raw.clone(),r.subscribers.raw.clone())).collect::<Vec<_>>(),"binding":m.bindings.iter().map(|(k,b)|(*k,b.memory.raw.clone(),b.curves.raw.clone(),b.points.iter().map(|(k,p)|(*k,p.raw.clone())).collect::<Vec<_>>())).collect::<Vec<_>>(),"values":v.iter().map(|(k,v)|(*k,v.raw.clone())).collect::<Vec<_>>(),"buses":g.buses.iter().map(|(k,b)|(*k,b.raw.as_slice().to_vec())).collect::<Vec<_>>(),"voices":t.voices.iter().map(|(k,v)|(*k,v.raw.as_slice().to_vec())).collect::<Vec<_>>()})}
fn proof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_bus_rtpc_delta_contract.json")).unwrap()}
#[test]fn original112_global_rtpc_bus_delta_frames_match_whole_owned_manager_graph_voice_and_retained_subtraction(){
 let proof=proof();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],112);assert_eq!(proof["logical_result_adapters"].as_array().unwrap().len(),0);
 for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (mut manager,mut values,mut graph,mut targets)=state(row);let old_manager=manager.raw;let old_binding=manager.bindings[&BIND].memory.raw.clone();
  let result=port::set_global(&mut manager,&mut values,&mut graph,&mut targets,KEY,row["input"]["new_bits"].as_u64().unwrap()as u32,0,port::Context{manager_reference:DATA,conversion_cache:0}).unwrap();
  let after=&row["after"];assert_eq!(manager.raw.as_slice(),bytes(&after["manager"]),"whole manager {index}");assert_eq!(manager.raw,old_manager);assert_eq!(manager.records[&(DATA+0x1000)].memory.raw,bytes(&after["record"]));assert_eq!(manager.bindings[&BIND].memory.raw,old_binding);assert_eq!(manager.bindings[&BIND].curves.raw,bytes(&after["curve"]));assert_eq!(manager.bindings[&BIND].points.values().next().unwrap().raw,bytes(&after["points"]));assert_eq!(values.values().next().unwrap().raw,bytes(&after["overrides"]));
  for (key,node) in [("bus",BUS),("master",MASTER),("child1",CHILD1),("child2",CHILD2)]{if let Some(b)=graph.buses.get(&node){assert_eq!(b.raw.as_slice(),bytes(&after[key]),"whole bus {index}/{key}");}}
  for (i,voice) in targets.registered.iter().enumerate(){assert_eq!(targets.voices[voice].raw.as_slice(),bytes(&after["voices"][i]),"whole voice {index}/{i}");}
  let calls=row["calls"].as_array().unwrap();if let Some(call)=calls.iter().find(|r|r["entry"]=="0xb00c90"){assert_eq!(result.len(),1);assert_eq!(result[0].binding,BIND);assert_eq!(result[0].bus,BUS);assert_eq!(u64::from(result[0].new_curve_bits),call["args"][3].as_u64().unwrap());let delta=calls.iter().find(|r|r["entry"]=="0xaffc60").unwrap();assert_eq!(u64::from(result[0].delta_bits),delta["args"][1].as_u64().unwrap(),"retained old manager subtraction {index}");}else{assert!(result.is_empty());}
 }
}
#[test]fn unsupported_owner_and_late_bus_target_failure_publish_no_manager_or_voice_changes(){
 let p=proof();let row=p["cases"].as_array().unwrap().iter().find(|r|r["input"]["processing_input"]==true&&r["input"]["path"]=="bus"&&r["input"]["new_bits"]==0).unwrap();
 let (mut m,mut v,mut g,mut t)=state(row);let before=snapshot(&m,&v,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut g,&mut t,KEY,0,77,port::Context{manager_reference:DATA,conversion_cache:0}).is_err());assert_eq!(snapshot(&m,&v,&g,&t),before);
 // The first real target would be changed before the missing later target;
 // cloned native plans must isolate that partial calculation from publication.
 t.registered.push(0xdead0000);let before=snapshot(&m,&v,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut g,&mut t,KEY,0,0,port::Context{manager_reference:DATA,conversion_cache:0}).is_err());assert_eq!(snapshot(&m,&v,&g,&t),before);
}
