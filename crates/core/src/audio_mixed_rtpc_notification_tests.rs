//! Native golden replay and owned late-failure fixtures. No PCM/runtime claim.
use crate::{audio_plugin_factory::Memory,audio_rtpc_subscriber_release::{Manager,Binding},audio_meter_lifecycle::Runtime as Meters,audio_bus_effects_changed::Graph,audio_bus_control_application::Store};
use serde_json::{Value,json};use std::collections::BTreeMap;
use crate::{audio_bus_rtpc_delta as bus,audio_mixed_rtpc_notification as port};
const DATA:u32=0x30100000;const BIND:u32=DATA+0x1300;
const M0:u32=DATA+0x9000;const M1:u32=DATA+0x9100;const BM0:u32=DATA+0x9200;const BM1:u32=DATA+0x9240;
const KEY:u32=3273357900;
fn bytes(v:&Value)->Vec<u8>{let s=v.as_str().unwrap();(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn put(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn proof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_mixed_rtpc_notification_contract.json")).unwrap()}
fn context()->bus::Context{bus::Context{manager_reference:DATA,conversion_cache:0}}
fn request(row:&Value)->port::Request{port::Request{key:KEY,new_bits:row["input"]["new_bits"].as_u64().unwrap()as u32,owner:0,transition:[0,4],mode:1}}
fn state(row:&Value)->(Manager,BTreeMap<u32,Memory>,Meters,Graph,Store){
 let (mut manager,values,graph,targets)=crate::audio_bus_rtpc_delta::tests::state(row);let before=&row["before"];
 manager.records.get_mut(&(DATA+0x1000)).unwrap().subscribers.raw=bytes(&before["subscribers"]);
 let mut meters=Meters{objects:BTreeMap::new(),manager:0x10203040,manager_allocator:0x50607080};
 for (i,(object,binding))in [(M0,BM0),(M1,BM1)].into_iter().enumerate(){
  let raw=bytes(&before["meter_bindings"][i]);let curves=bytes(&before["meter_curves"][i]);let points=word(&curves,8);
  manager.bindings.insert(binding,Binding{memory:Memory{reference:binding,raw:raw.clone()},curves:Memory{reference:word(&raw,20),raw:curves},points:BTreeMap::from([(points,Memory{reference:points,raw:bytes(&before["points"])})])});
  meters.objects.insert(object,Memory{reference:object,raw:bytes(&before["meters"][i])});
 }
 (manager,values,meters,graph,targets)
}
fn snapshot(m:&Manager,v:&BTreeMap<u32,Memory>,meters:&Meters,g:&Graph,t:&Store)->Value{
 json!({"native_manager_graph_voices":crate::audio_bus_rtpc_delta::tests::snapshot(m,v,g,t),"meters":{"manager":meters.manager,"allocator":meters.manager_allocator,"objects":meters.objects.iter().map(|(k,v)|(*k,v.reference,v.raw.clone())).collect::<Vec<_>>()},
 "groups":g.groups.iter().map(|(k,v)|(*k,v.children.clone(),v.active)).collect::<Vec<_>>(),"cache":format!("{:?}",g.caches),"registered":t.registered,"roots":format!("{:?}",t.roots),"bus_ids":t.bus_ids,
 "physical_references":m.records.iter().map(|(k,r)|(*k,r.memory.reference,r.subscribers.reference)).collect::<Vec<_>>(),"binding_references":m.bindings.iter().map(|(k,b)|(*k,b.memory.reference,b.curves.reference,b.points.iter().map(|(p,m)|(*p,m.reference)).collect::<Vec<_>>())).collect::<Vec<_>>()})
}
fn assert_buffers(row:&Value,m:&Manager,v:&BTreeMap<u32,Memory>,meters:&Meters,g:&Graph,t:&Store,index:usize){
 let a=&row["after"];assert_eq!(m.raw.as_slice(),bytes(&a["manager"]),"manager {index}");let record=&m.records[&(DATA+0x1000)];assert_eq!(record.memory.raw,bytes(&a["record"]),"record {index}");assert_eq!(record.subscribers.raw,bytes(&a["subscribers"]));
 assert_eq!(v.values().next().unwrap().raw,bytes(&a["overrides"]));assert_eq!(meters.manager,0x10203040);assert_eq!(meters.manager_allocator,0x50607080);
 for (i,(object,binding))in [(M0,BM0),(M1,BM1)].into_iter().enumerate(){let b=&m.bindings[&binding];assert_eq!(meters.objects[&object].raw,bytes(&a["meters"][i]),"whole Meter {index}/{i}");assert_eq!(b.memory.raw,bytes(&a["meter_bindings"][i]));assert_eq!(b.curves.raw,bytes(&a["meter_curves"][i]));assert_eq!(b.points.values().next().unwrap().raw,bytes(&a["points"]));}
 let b=&m.bindings[&BIND];assert_eq!(b.memory.raw,bytes(&a["binding"]));assert_eq!(b.curves.raw,bytes(&a["curve"]));assert_eq!(b.points.values().next().unwrap().raw,bytes(&a["points"]));
 for (key,reference)in [("bus",DATA+0x2000),("master",DATA+0x2100),("child1",DATA+0x2400),("child2",DATA+0x2500)]{if let Some(b)=g.buses.get(&reference){assert_eq!(b.raw.as_slice(),bytes(&a[key]),"whole Bus {index}/{key}");}else{assert_eq!(a[key],row["before"][key]);}}
 for (i,reference)in t.registered.iter().enumerate(){assert_eq!(t.voices[reference].raw.as_slice(),bytes(&a["voices"][i]),"whole voice {index}/{i}");}
 for key in ["groups","children","registered","roots"]{assert_eq!(a[key],row["before"][key],"preserved native buffer {index}/{key}");}
}

#[test]fn original256_mixed_notifications_match_forward_adjacent_dedup_old_manager_one_store_and_all_owned_buffers(){
 let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],256);assert_eq!(p["cases"].as_array().unwrap().len(),256);assert_eq!(p["logical_result_adapters"].as_array().unwrap().len(),0);
 for(index,row)in p["cases"].as_array().unwrap().iter().enumerate(){
  assert_eq!(row["notification_order_matches_forward_adjacent_dedup"],true);assert_eq!(row["all_notifications_read_old_manager"],true);assert_eq!(row["global_store_occurs_once_after_notifications"],true);
  let(mut m,mut v,mut meters,mut g,mut t)=state(row);let manager_before=m.raw;let actual=port::set_global(&mut m,&mut v,&mut meters,&mut g,&mut t,request(row),context()).unwrap();assert_eq!(actual.status as u64,row["result"].as_u64().unwrap());assert_eq!(m.raw,manager_before);
  assert_buffers(row,&m,&v,&meters,&g,&t,index);
  let native=row["notifications"].as_array().unwrap();assert_eq!(actual.notifications.len(),native.len(),"callback count {index}");
  let deltas=row["calls"].as_array().unwrap().iter().filter(|r|r["entry"]=="0xaffc60").collect::<Vec<_>>();let mut bus_index=0;
  let mut previous=0;let expected_bindings=if actual.final_store.is_none(){vec![]}else{row["input"]["subscriber_order"].as_array().unwrap().iter().map(|r|r.as_u64().unwrap()as u32).filter(|r|{let different=*r!=previous;previous=*r;different}).collect::<Vec<_>>()};
  assert_eq!(actual.notifications.iter().map(|r|r.binding).collect::<Vec<_>>(),expected_bindings,"forward/adjacent-only order {index}");
  for(event,expected)in actual.notifications.iter().zip(native){assert_eq!(event.manager_old_value_bits as u64,expected["manager_old_value_bits"].as_u64().unwrap(),"OLD global {index}");
   match &event.callback{
    port::Callback::Meter{receiver,parameter,new_curve_bits,status}=>{assert_eq!(expected["entry"],"0xb3e100");assert_eq!(*receiver as u64,expected["receiver"].as_u64().unwrap());assert_eq!(*parameter as u64,expected["stack_words"][0].as_u64().unwrap());assert_eq!(*status,1);let mi=if *receiver==M0{0}else{assert_eq!(*receiver,M1);1};assert_eq!(*new_curve_bits,word(&bytes(&row["after"]["meters"][mi]),12));},
    port::Callback::Bus(delivery)=>{assert_eq!(expected["entry"],"0xb00c90");assert_eq!(delivery.bus as u64,expected["receiver"].as_u64().unwrap());assert_eq!(delivery.binding as u64,expected["stack_words"][0].as_u64().unwrap());assert_eq!(delivery.new_curve_bits as u64,expected["stack_words"][3].as_u64().unwrap());assert_eq!(delivery.delta_bits as u64,deltas[bus_index]["args"][1].as_u64().unwrap(),"retained OLD delta {index}/{bus_index}");bus_index+=1;},
   }
  }
  assert_eq!(bus_index,deltas.len());let stores=row["manager_stores"].as_array().unwrap();
  if let Some(store)=actual.final_store{assert_eq!(stores.len(),1);let expected=&stores[0];assert_eq!(store.address as u64,expected["address"].as_u64().unwrap());assert_eq!(store.size as u64,expected["size"].as_u64().unwrap());assert_eq!(store.value as u64,expected["value"].as_u64().unwrap());assert_eq!(store.notifications_already_observed as u64,expected["notifications_already_observed"].as_u64().unwrap());}else{assert!(stores.is_empty());}
 }
}

#[test]fn mixed_late_meter_bus_failure_and_conflicting_shared_points_publish_no_owned_or_global_changes(){
 let p=proof();let row=p["cases"].as_array().unwrap().iter().find(|r|r["input"]["processing_input"]==true&&r["input"]["path"]=="bus"&&r["input"]["new_bits"]==0&&r["input"]["subscriber_order"].as_array().unwrap().len()==3).unwrap();
 // The valid prefix really changes the first Meter and native voice bytes.
 // Missing last Meter then tests a failure after that same proposed prefix.
 let(mut pm,mut pv,mut pmeters,mut pg,mut pt)=state(row);put(&mut pm.records.get_mut(&(DATA+0x1000)).unwrap().memory.raw,32,2);let prefix=snapshot(&pm,&pv,&pmeters,&pg,&pt);
 let proposal=port::set_global(&mut pm,&mut pv,&mut pmeters,&mut pg,&mut pt,request(row),context()).unwrap();assert_eq!(proposal.notifications.len(),2);assert_ne!(snapshot(&pm,&pv,&pmeters,&pg,&pt),prefix);assert_ne!(pmeters.objects[&M0].raw,bytes(&row["before"]["meters"][0]));assert_ne!(pt.voices[&pt.registered[0]].raw.as_slice(),bytes(&row["before"]["voices"][0]));
 let(mut m,mut v,mut meters,mut g,mut t)=state(row);meters.objects.remove(&M1);let before=snapshot(&m,&v,&meters,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut meters,&mut g,&mut t,request(row),context()).is_err());assert_eq!(snapshot(&m,&v,&meters,&g,&t),before);
 let(mut m,mut v,mut meters,mut g,mut t)=state(row);t.registered.push(0xdead0000);let before=snapshot(&m,&v,&meters,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut meters,&mut g,&mut t,request(row),context()).is_err());assert_eq!(snapshot(&m,&v,&meters,&g,&t),before);
 let(mut m,mut v,mut meters,mut g,mut t)=state(row);m.bindings.get_mut(&BM1).unwrap().points.values_mut().next().unwrap().raw[4]^=1;let before=snapshot(&m,&v,&meters,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut meters,&mut g,&mut t,request(row),context()).is_err());assert_eq!(snapshot(&m,&v,&meters,&g,&t),before);
 for request in [port::Request{owner:77,..request(row)},port::Request{transition:[1,4],..request(row)},port::Request{mode:0,..request(row)}]{let(mut m,mut v,mut meters,mut g,mut t)=state(row);let before=snapshot(&m,&v,&meters,&g,&t);assert!(port::set_global(&mut m,&mut v,&mut meters,&mut g,&mut t,request,context()).is_err());assert_eq!(snapshot(&m,&v,&meters,&g,&t),before);}
}
