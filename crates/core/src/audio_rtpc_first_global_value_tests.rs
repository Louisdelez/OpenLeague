use super::*;
use crate::{audio_rtpc_subscriber_release::{Manager,Record,Binding},audio_bus_registry::Bus};
use serde_json::Value;
use std::collections::VecDeque;
fn bytes(s:&str)->Vec<u8>{s.as_bytes().chunks_exact(2).map(|b|u8::from_str_radix(std::str::from_utf8(b).unwrap(),16).unwrap()).collect()}
fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
fn u(v:&Value)->u32{v.as_u64().unwrap()as u32}
fn contract()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_first_global_value_contract.json")).unwrap()}
fn source()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_init_rtpc_owner_source.json")).unwrap()}
fn memory(p:u32,map:&mut BTreeMap<u32,Memory>)->Memory{if p==0{Memory{reference:0,raw:vec![]}}else{map.remove(&p).unwrap()}}
fn from_snapshot(row:&Value,name:&str)->(FreshInitializationOwner,Values,Graph,Store){
 let s=&row[name];let mut map:BTreeMap<u32,Memory>=s["blocks"].as_array().unwrap().iter().filter(|b|b["freed"]==false).map(|b|{let p=u(&b["reference"]);(p,Memory{reference:p,raw:bytes(b["raw"].as_str().unwrap())})}).collect();
 let p=u(&s["manager"]);let full=memory(p,&mut map).raw;assert_eq!(full.len(),0x954);
 let node_p=*map.iter().find(|(_,m)|m.raw.len()==0x2260).unwrap().0;let node=memory(node_p,&mut map);let pool_nodes=memory(word(&full,0x934),&mut map);
 let mut manager=Manager{raw:full[..0x920].try_into().unwrap(),records:BTreeMap::new(),bindings:BTreeMap::new()};
 let defaults=source();let mut values=Values::default();
 for d in defaults["STMG"]["defaults"].as_array().unwrap(){
  let key=u(&d["id"]);let p=*map.iter().find(|(_,m)|m.raw.len()==40&&word(&m.raw,0)==key).unwrap().0;let m=memory(p,&mut map);
  let table=word(&m.raw,12);if table!=0{values.blocks.insert(table,memory(table,&mut map));}
  let subscribers=memory(word(&m.raw,28),&mut map);manager.records.insert(p,Record{memory:m,subscribers});
 }
 for i in 0..193{let mut p=word(&manager.raw,0x614+i*4);while p!=0{
  let m=memory(p,&mut map);let next=word(&m.raw,8);let c=memory(word(&m.raw,20),&mut map);let mut points=BTreeMap::new();
  for entry in c.raw.chunks_exact(20){let p=word(entry,8);if p!=0{points.insert(p,memory(p,&mut map));}}
  manager.bindings.insert(p,Binding{memory:m,curves:c,points});p=next;
 }}
 let b=memory(u(&row["Bus_ref"]),&mut map);let graph=Graph{buses:BTreeMap::from([(b.reference,Bus{reference:b.reference,raw:b.raw.try_into().unwrap()})]),caches:BTreeMap::new(),groups:BTreeMap::new()};assert!(map.is_empty());
 let initialized=(0..11).map(|i|node.reference+i*0x320).collect();
 (FreshInitializationOwner{reference:p,pool_id:u32::MAX,manager,opaque_tail:full[0x920..].try_into().unwrap(),node_registry:node,pool_nodes,initialized_critical_sections:initialized},values,graph,Store::default())
}
fn snapshot(o:&FreshInitializationOwner,v:&Values,g:&Graph)->BTreeMap<u32,String>{
 let mut out=BTreeMap::new();let mut add=|p:u32,b:&[u8]|{if p!=0{assert!(out.insert(p,hex(b)).is_none());}};
 add(o.reference,&o.full_raw());add(o.node_registry.reference,&o.node_registry.raw);add(o.pool_nodes.reference,&o.pool_nodes.raw);
 for r in o.manager.records.values(){add(r.memory.reference,&r.memory.raw);add(r.subscribers.reference,&r.subscribers.raw);}
 for b in o.manager.bindings.values(){add(b.memory.reference,&b.memory.raw);add(b.curves.reference,&b.curves.raw);for p in b.points.values(){add(p.reference,&p.raw);}}
 for m in v.blocks.values(){add(m.reference,&m.raw);}for b in g.buses.values(){add(b.reference,&b.raw);}out
}
fn expected(s:&Value)->BTreeMap<u32,String>{s["blocks"].as_array().unwrap().iter().filter(|b|b["freed"]==false).map(|b|(u(&b["reference"]),b["raw"].as_str().unwrap().to_owned())).collect()}
struct Backend{grants:VecDeque<Option<Memory>>,events:Vec<String>,observations:Vec<(u32,bool,BTreeMap<u32,String>)>,freed:Vec<u32>}
impl Backend{fn new(grants:Vec<Option<Memory>>)->Self{Self{grants:grants.into(),events:vec![],observations:vec![],freed:vec![]}}}
impl Services for Backend{
 fn allocate_values(&mut self,pool:u32,n:u32)->Result<Option<Memory>,Error>{assert_eq!(pool,u32::MAX);assert_eq!(n,64);self.events.push("allocate64".into());Ok(self.grants.pop_front().expect("explicit native allocator input missing"))}
 fn free_values(&mut self,pool:u32,m:&Memory)->Result<(),Error>{assert_eq!(pool,u32::MAX);self.events.push("free".into());self.freed.push(m.reference);Ok(())}
 fn observe_notification(&mut self,o:&FreshInitializationOwner,v:&Values,n:&Notification){self.events.push("callback".into());self.observations.push((n.manager_old_bits,!v.blocks.is_empty(),snapshot(o,v,&Graph{buses:BTreeMap::new(),caches:BTreeMap::new(),groups:BTreeMap::new()})));}
}
fn grant(row:&Value,name:&str)->Memory{
 let before=expected(&row["before"]);let after=expected(&row[name]);let p=*after.keys().find(|p|!before.contains_key(p)).unwrap();Memory{reference:p,raw:vec![u(&row["pattern"])as u8;64]}
}
fn request(row:&Value)->Request{let i=&row["input"];Request{key:u(&i["key"]),new_bits:u(&i["new_bits"]),owner:u(&i["owner"]),transition:[u(&i["transition"][0]),u(&i["transition"][1])],mode:u(&i["mode"])}}
fn context(o:&FreshInitializationOwner)->bus::Context{bus::Context{manager_reference:o.reference,conversion_cache:0x14a7970}}
fn receiver_fields(events:&Value)->Vec<(u32,u32)>{
 let mut new=None;let mut out=vec![];
 for e in events.as_array().unwrap(){
  if e["entry"]=="0xb00c90"{assert!(new.is_none());new=Some(u(&e["args"][3]));}
  if e["entry"]=="0xaffc60"{out.push((new.take().expect("native NEW callback must precede its receiver delta"),u(&e["args"][1])));}
 }assert!(new.is_none());out
}
fn match_callbacks(out:&Outcome,events:&Value,old_bits:u32,existed:bool){
 let expected=receiver_fields(events);assert_eq!(out.notifications.len(),expected.len());for(n,(new,delta))in out.notifications.iter().zip(expected){assert_eq!(n.manager_old_bits,old_bits);assert_eq!(n.owner_value_existed_before,existed);assert_eq!(n.delivery.new_curve_bits,new);assert_eq!(n.delivery.delta_bits,delta);assert!(n.delivery.voices.is_empty());}
}
#[test]fn original_fourteen_fresh_init_first_global_contexts_match_full_buffers_default_reads_callback_order_real_failure_and_created_followups(){
 let d=contract();let success=&d["native_success"];let failure=&d["native_failure"];let reads=&d["native_reads"];
 assert_eq!(success["passed"],true);assert_eq!(failure["passed"],true);assert_eq!(reads["passed"],true);
 assert_eq!(success["rows"].as_array().unwrap().len(),10);assert_eq!(failure["rows"].as_array().unwrap().len(),2);assert_eq!(reads["rows"].as_array().unwrap().len(),2);
 for row in success["rows"].as_array().unwrap(){
  let(mut o,mut v,mut g,mut t)=from_snapshot(row,"before");let c=context(&o);let mut backend=Backend::new(vec![Some(grant(row,"after"))]);let req=request(row);
  let out=set_global(&mut o,&mut v,&mut g,&mut t,req,c,&mut backend).unwrap();assert_eq!(out.status,u(&row["result"]));assert_eq!(snapshot(&o,&v,&g),expected(&row["after"]));
  match_callbacks(&out,&row["first_events"],100f32.to_bits(),false);assert_eq!(backend.events,["callback","allocate64"]);assert_eq!(backend.observations[0].0,100f32.to_bits());assert!(!backend.observations[0].1);
  let mut old=expected(&row["before"]);old.remove(&u(&row["Bus_ref"]));assert_eq!(backend.observations[0].2,old,"actual OLD full owner before allocation");
  let out=set_global(&mut o,&mut v,&mut g,&mut t,req,c,&mut backend).unwrap();assert_eq!(out.status,u(&row["equal_result"]));assert!(out.notifications.is_empty()&&out.final_store.is_none());assert_eq!(snapshot(&o,&v,&g),expected(&row["after_equal"]));
  let changed=row["changed_events"].as_array().unwrap().iter().find(|e|e["entry"]=="0xb12320").unwrap();let mut req=req;req.new_bits=u(&changed["args"][1]);
  let out=set_global(&mut o,&mut v,&mut g,&mut t,req,c,&mut backend).unwrap();assert_eq!(out.status,u(&row["changed_result"]));assert_eq!(snapshot(&o,&v,&g),expected(&row["after_changed"]));match_callbacks(&out,&row["changed_events"],u(&row["input"]["new_bits"]),true);
  assert!(backend.grants.is_empty()&&backend.freed.is_empty());assert_eq!(backend.events,["callback","allocate64"]);
 }
 for row in failure["rows"].as_array().unwrap(){
  let(mut o,mut v,mut g,mut t)=from_snapshot(row,"before");let c=context(&o);let mut backend=Backend::new(vec![None,Some(grant(row,"after_retry"))]);let req=request(row);
  let out=set_global(&mut o,&mut v,&mut g,&mut t,req,c,&mut backend).unwrap();assert_eq!(out.status,u(&row["result"]));match_callbacks(&out,&row["failure_events"],100f32.to_bits(),false);
  assert!(out.final_store.is_none()&&out.created_values.is_none()&&v.blocks.is_empty());assert_eq!(snapshot(&o,&v,&g),expected(&row["after_failure"]));assert_eq!(backend.events,["callback","allocate64"]);
  let out=set_global(&mut o,&mut v,&mut g,&mut t,req,c,&mut backend).unwrap();assert_eq!(out.status,u(&row["retry_result"]));match_callbacks(&out,&row["retry_events"],100f32.to_bits(),false);assert_eq!(snapshot(&o,&v,&g),expected(&row["after_retry"]));assert_eq!(backend.events,["callback","allocate64","callback","allocate64"]);
 }
 for row in reads["rows"].as_array().unwrap(){
  let(mut o,mut v,mut g,mut t)=from_snapshot(row,"before");let c=context(&o);let mut backend=Backend::new(vec![Some(grant(row,"after"))]);let out=set_global(&mut o,&mut v,&mut g,&mut t,request(row),c,&mut backend).unwrap();
  assert_eq!(snapshot(&o,&v,&g),expected(&row["after"]));assert_eq!(out.notifications[0].manager_old_bits,u(&row["default_reads"][0]["default_word"]));assert!(!backend.observations[0].1);match_callbacks(&out,&row["events"],100f32.to_bits(),false);
 }
}
#[test]fn first_global_allocator_custody_rejects_foreign_ranges_and_reclaims_only_fresh_unpublished_storage_after_callback(){
 let d=contract();let row=&d["native_success"]["rows"][2];
 for alias in [true,false]{
  let(mut o,mut v,mut g,mut t)=from_snapshot(row,"before");let c=context(&o);let old=snapshot(&o,&v,&g);let p=if alias{o.reference}else{grant(row,"after").reference};let mut backend=Backend::new(vec![Some(Memory{reference:p,raw:vec![0x51;63]})]);
  let mut failure=set_global(&mut o,&mut v,&mut g,&mut t,request(row),c,&mut backend).unwrap_err();assert!(matches!(failure.error,Error::InvalidAllocation));assert_eq!(failure.notifications.len(),1);assert_eq!(snapshot(&o,&v,&g),old);assert_eq!(backend.events,["callback","allocate64"]);
  assert_eq!(failure.unpublished_values.len(),usize::from(!alias));failure.reclaim(o.pool_id,&mut backend).unwrap();assert_eq!(backend.freed,if alias{vec![]}else{vec![p]});assert!(failure.unpublished_values.is_empty());
 }
 let(mut o,mut v,mut g,mut t)=from_snapshot(row,"before");let c=context(&o);let old=snapshot(&o,&v,&g);let bus=u(&row["Bus_ref"]);let mut backend=Backend::new(vec![Some(Memory{reference:bus,raw:vec![0;64]})]);
 let mut failure=set_global(&mut o,&mut v,&mut g,&mut t,request(row),c,&mut backend).unwrap_err();assert_eq!(failure.notifications.len(),1);assert!(failure.unpublished_values.is_empty());failure.reclaim(o.pool_id,&mut backend).unwrap();assert!(backend.freed.is_empty());assert_eq!(snapshot(&o,&v,&g),old);
 // Foreign map-key/Bus ownership is rejected before a receiver/allocation.
 g.buses.get_mut(&bus).unwrap().reference=0x77700000;let mut backend=Backend::new(vec![]);assert!(matches!(set_global(&mut o,&mut v,&mut g,&mut t,request(row),c,&mut backend),Err(Failure{error:Error::InvalidAllocation,..})));assert!(backend.events.is_empty());g.buses.get_mut(&bus).unwrap().reference=bus;assert_eq!(snapshot(&o,&v,&g),old);
 // Unknown parent/voice ownership is rejected before a receiver/allocation.
 g.buses.get_mut(&bus).unwrap().set_word(0x24,0x77700000);let mut backend=Backend::new(vec![]);assert!(set_global(&mut o,&mut v,&mut g,&mut t,request(row),c,&mut backend).is_err());assert!(backend.events.is_empty());
}
