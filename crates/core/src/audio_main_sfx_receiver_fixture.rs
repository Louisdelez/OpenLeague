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
fn context()->bus::Context{bus::Context{manager_reference:DATA,conversion_cache:0}}
fn request(row:&Value)->port::Request{port::Request{key:KEY,new_bits:row["input"]["new_bits"].as_u64().unwrap()as u32,owner:0,transition:[0,4],mode:1}}
pub(crate) fn state(row:&Value)->(Manager,BTreeMap<u32,Memory>,Meters,Graph,Store){
 let (mut manager,values,graph,targets)=crate::audio_main_sfx_mixed_transport::test_bus_owner::state(row);let before=&row["before"];
 manager.records.get_mut(&(DATA+0x1000)).unwrap().subscribers.raw=bytes(&before["subscribers"]);
 let mut meters=Meters{objects:BTreeMap::new(),manager:0x10203040,manager_allocator:0x50607080};
 for (i,(object,binding))in [(M0,BM0),(M1,BM1)].into_iter().enumerate(){
  let raw=bytes(&before["meter_bindings"][i]);let curves=bytes(&before["meter_curves"][i]);let points=word(&curves,8);
  manager.bindings.insert(binding,Binding{memory:Memory{reference:binding,raw:raw.clone()},curves:Memory{reference:word(&raw,20),raw:curves},points:BTreeMap::from([(points,Memory{reference:points,raw:bytes(&before["points"])})])});
  meters.objects.insert(object,Memory{reference:object,raw:bytes(&before["meters"][i])});
 }
 (manager,values,meters,graph,targets)
}
pub(crate) fn snapshot(m:&Manager,v:&BTreeMap<u32,Memory>,meters:&Meters,g:&Graph,t:&Store)->Value{
 json!({"native_manager_graph_voices":crate::audio_main_sfx_mixed_transport::test_bus_owner::snapshot(m,v,g,t),"meters":{"manager":meters.manager,"allocator":meters.manager_allocator,"objects":meters.objects.iter().map(|(k,v)|(*k,v.reference,v.raw.clone())).collect::<Vec<_>>()},
 "groups":g.groups.iter().map(|(k,v)|(*k,v.children.clone(),v.active)).collect::<Vec<_>>(),"cache":format!("{:?}",g.caches),"registered":t.registered,"roots":format!("{:?}",t.roots),"bus_ids":t.bus_ids,
 "physical_references":m.records.iter().map(|(k,r)|(*k,r.memory.reference,r.subscribers.reference)).collect::<Vec<_>>(),"binding_references":m.bindings.iter().map(|(k,b)|(*k,b.memory.reference,b.curves.reference,b.points.iter().map(|(p,m)|(*p,m.reference)).collect::<Vec<_>>())).collect::<Vec<_>>()})
}
pub(crate) fn assert_buffers(row:&Value,m:&Manager,v:&BTreeMap<u32,Memory>,meters:&Meters,g:&Graph,t:&Store,index:usize){
 let a=&row["after"];assert_eq!(m.raw.as_slice(),bytes(&a["manager"]),"manager {index}");let record=&m.records[&(DATA+0x1000)];assert_eq!(record.memory.raw,bytes(&a["record"]),"record {index}");assert_eq!(record.subscribers.raw,bytes(&a["subscribers"]));
 assert_eq!(v.values().next().unwrap().raw,bytes(&a["overrides"]));assert_eq!(meters.manager,0x10203040);assert_eq!(meters.manager_allocator,0x50607080);
 for (i,(object,binding))in [(M0,BM0),(M1,BM1)].into_iter().enumerate(){let b=&m.bindings[&binding];assert_eq!(meters.objects[&object].raw,bytes(&a["meters"][i]),"whole Meter {index}/{i}");assert_eq!(b.memory.raw,bytes(&a["meter_bindings"][i]));assert_eq!(b.curves.raw,bytes(&a["meter_curves"][i]));assert_eq!(b.points.values().next().unwrap().raw,bytes(&a["points"]));}
 let b=&m.bindings[&BIND];assert_eq!(b.memory.raw,bytes(&a["binding"]));assert_eq!(b.curves.raw,bytes(&a["curve"]));assert_eq!(b.points.values().next().unwrap().raw,bytes(&a["points"]));
 for (key,reference)in [("bus",DATA+0x2000),("master",DATA+0x2100),("child1",DATA+0x2400),("child2",DATA+0x2500)]{if let Some(b)=g.buses.get(&reference){assert_eq!(b.raw.as_slice(),bytes(&a[key]),"whole Bus {index}/{key}");}else{assert_eq!(a[key],row["before"][key]);}}
 for (i,reference)in t.registered.iter().enumerate(){assert_eq!(t.voices[reference].raw.as_slice(),bytes(&a["voices"][i]),"whole voice {index}/{i}");}
 for key in ["groups","children","registered","roots"]{assert_eq!(a[key],row["before"][key],"preserved native buffer {index}/{key}");}
}
