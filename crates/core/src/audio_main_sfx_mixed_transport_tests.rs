//! True owned queue traversal to native21 reference buffers, no PCM/device.
use super::*;
use crate::{audio_common_queue as queue,audio_plugin_factory::Allocator};
use crate::audio_main_sfx_mixed_transport::test_request::RtpcRequest;
use serde_json::Value;
#[path="audio_main_sfx_receiver_fixture.rs"]mod owned;
struct Services{depth:u32,events:Vec<u32>}
impl Allocator for Services{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("composition does not create a missing audio allocation"))}}
impl queue::Services for Services{
 fn free_pool(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no queue retirement in bounded fixture"))}
 fn lock_queue(&mut self)->Result<(),Error>{assert_eq!(self.depth,0);self.depth=1;Ok(())}
 fn unlock_queue(&mut self)->Result<(),Error>{assert_eq!(self.depth,1);self.depth=0;Ok(())}
}
impl queue::RetryServices for Services{
 fn reset_event(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("fixture has no backpressure"))}
 fn set_event(&mut self,event:u32)->Result<(),Error>{self.events.push(event);Ok(())}
 fn wait_event(&mut self,_:u32,_:u32,_:&mut queue::Context,_:&mut u32)->Result<(),Error>{Err(Error::Backend("real wait worker required for backpressure"))}
 fn dispatch_command(&mut self,_:&[u8])->Result<(),Error>{Err(Error::Backend("explicit owned mixed receiver closure required"))}
}
fn common()->queue::Context{
 let table_ref=0x30008000u32;let pages=[0x30009000u32,0x3000a000];let mut raw=[0u8;0x98];
 for(o,v)in [(0x18,table_ref),(0x1c,2),(0x20,2),(0x24,2),(0x88,0x3000b088),(0x90,0x3000b090)]{raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
 let mut table=Memory{reference:table_ref,raw:vec![0;16]};for(i,page)in pages.iter().enumerate(){table.raw[i*8..i*8+4].copy_from_slice(&page.to_le_bytes());}
 queue::Context{raw,table,pages:pages.into_iter().map(|p|(p,Memory{reference:p,raw:vec![0xa5;2048]})).collect(),page_size:2048}
}
fn bytes(text:&str)->Vec<u8>{(0..text.len()).step_by(2).map(|i|u8::from_str_radix(&text[i..i+2],16).unwrap()).collect()}
fn native()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_main_sfx_mixed_receivers_contract.json")).unwrap()}
fn qproof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_main_sfx_queue_route_contract.json")).unwrap()}
fn request(row:&Value)->RtpcRequest{let r=&row["queue_input"]["request"];let get=|k:&str|r[k].as_u64().unwrap()as u32;RtpcRequest{id:get("key"),value_bits:get("value_bits"),owner:get("owner"),duration:get("duration"),curve:get("curve")}}
fn context()->bus::Context{bus::Context{manager_reference:0x30100000,conversion_cache:0}}

#[test]fn original21_queued_main_sfx_packets_reach_mixed_owned_receiver_and_match_native_full_buffers_and_old_manager(){
 let p=native();let queue=qproof();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],21);assert_eq!(p["logical_result_adapters"].as_array().unwrap().len(),0);assert_eq!(queue["case_count"],21);
 for(index,row)in p["cases"].as_array().unwrap().iter().enumerate(){
  let(mut manager,mut values,mut meters,mut graph,mut targets)=owned::state(row);let mut ring=common();let mut services=Services{depth:0,events:vec![]};let mut processed=0;
  let pad=row["queue_input"]["padding_pattern"].as_u64().unwrap()as u8;assert_eq!(enqueue(request(row),[pad;4],&mut ring,&mut processed,&mut services).unwrap(),1);
  let expected=bytes(row["queue_packet_hex"].as_str().unwrap());assert_eq!(&ring.pages[&0x30009000].raw[..20],expected.as_slice(),"native packet {index}");assert_eq!(row["queue_packet_hex"],queue["cases"][index]["queue_published_hex"]);
  assert_eq!(ring.publish_frame(&mut [0xa5;8],&mut processed,&mut services).unwrap(),1);
  let mut packets=vec![];let mut results=vec![];assert_eq!(ring.consume_with_dispatch(&mut processed,&mut services,|packet,_|{packets.push(packet.to_vec());results.push(dispatch_global(packet,&mut manager,&mut values,&mut meters,&mut graph,&mut targets,context())?);Ok(())}).unwrap(),1);
  assert_eq!(packets,vec![expected]);assert_eq!(results.len(),1);assert_eq!(processed,2);assert_eq!(services.depth,0);assert_eq!(services.events,vec![0x3000b088,0x3000b090]);
  assert_eq!(word(&ring.raw,0x2c),28);assert_eq!(word(&ring.raw,0x80),1);assert_eq!(word(&ring.raw,0x84),1);
  owned::assert_buffers(row,&manager,&values,&meters,&graph,&targets,index);
  let actual=&results[0];assert_eq!(actual.status,1);let notifications=row["notifications"].as_array().unwrap();assert_eq!(actual.notifications.len(),notifications.len());
  for(event,expected)in actual.notifications.iter().zip(notifications){assert_eq!(event.manager_old_value_bits as u64,expected["manager_old_value_bits"].as_u64().unwrap(),"OLD through actual queue {index}");match &event.callback{
   mixed::Callback::Meter{receiver,parameter,..}=>{assert_eq!(expected["entry"],"0xb3e100");assert_eq!(*receiver as u64,expected["receiver"].as_u64().unwrap());assert_eq!(*parameter,4);},
   mixed::Callback::Bus(delivery)=>{assert_eq!(expected["entry"],"0xb00c90");assert_eq!(delivery.new_curve_bits as u64,expected["stack_words"][3].as_u64().unwrap());},
  }}
  if let Some(store)=actual.final_store{assert_eq!(row["manager_stores"].as_array().unwrap().len(),1);let expected=&row["manager_stores"][0];assert_eq!(store.address as u64,expected["address"].as_u64().unwrap());assert_eq!(store.value as u64,expected["value"].as_u64().unwrap());assert_eq!(store.notifications_already_observed as u64,expected["notifications_already_observed"].as_u64().unwrap());}else{assert!(row["manager_stores"].as_array().unwrap().is_empty());assert!(actual.notifications.is_empty());}
  assert_eq!(row["selected_native_consumer"]["owner"],0);assert_eq!(word(&values.values().next().unwrap().raw,0),0);
 }
}

#[test]fn late_queued_owner_failure_retains_all_audio_state_and_command_for_explicit_retry_without_reallocation(){
 let p=native();let row=&p["cases"][0];let(mut manager,mut values,mut meters,mut graph,mut targets)=owned::state(row);
 let missing=0x30109100;let native_meter=meters.objects.remove(&missing).unwrap();let before=owned::snapshot(&manager,&values,&meters,&graph,&targets);
 let mut ring=common();let mut services=Services{depth:0,events:vec![]};let mut processed=0;enqueue(request(row),[0;4],&mut ring,&mut processed,&mut services).unwrap();ring.publish_frame(&mut [0;8],&mut processed,&mut services).unwrap();
 let ring_raw=ring.raw;let ring_table=ring.table.raw.clone();let ring_pages=ring.pages.iter().map(|(k,v)|(*k,v.raw.clone())).collect::<Vec<_>>();
 assert!(ring.consume_with_dispatch(&mut processed,&mut services,|packet,_|{dispatch_global(packet,&mut manager,&mut values,&mut meters,&mut graph,&mut targets,context())?;Ok(())}).is_err());
 assert_eq!(owned::snapshot(&manager,&values,&meters,&graph,&targets),before);assert_eq!(processed,0);assert_eq!(services.depth,0);assert_eq!(ring.raw,ring_raw);assert_eq!(ring.table.raw,ring_table);assert_eq!(ring.pages.iter().map(|(k,v)|(*k,v.raw.clone())).collect::<Vec<_>>(),ring_pages);
 // Caller restores the exact original owned object; no constructor/allocator
 // fallback is used. The existing queued command is then consumed once.
 meters.objects.insert(missing,native_meter);let mut calls=0;assert_eq!(ring.consume_with_dispatch(&mut processed,&mut services,|packet,_|{dispatch_global(packet,&mut manager,&mut values,&mut meters,&mut graph,&mut targets,context())?;calls+=1;Ok(())}).unwrap(),1);assert_eq!(calls,1);assert_eq!(processed,2);owned::assert_buffers(row,&manager,&values,&meters,&graph,&targets,0);
 let(mut manager,mut values,mut meters,mut graph,mut targets)=owned::state(row);let before=owned::snapshot(&manager,&values,&meters,&graph,&targets);let mut packet=bytes(row["queue_packet_hex"].as_str().unwrap());packet[16..20].copy_from_slice(&77u32.to_le_bytes());assert!(dispatch_global(&packet,&mut manager,&mut values,&mut meters,&mut graph,&mut targets,context()).is_err());assert_eq!(owned::snapshot(&manager,&values,&meters,&graph,&targets),before);
}
