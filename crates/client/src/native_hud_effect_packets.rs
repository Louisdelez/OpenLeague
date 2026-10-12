//! Original Effect packet fields and alpha request; allocation/GPU bridge pending.
#[derive(Debug,Clone,Copy,PartialEq)] pub struct Packet {
 pub kind:u32,pub flags:u32,pub index:u32,pub element_index:u32,pub layer:u32,pub owner:u32,pub mode:u32,pub instance:u32,pub textures:[u32;2],pub buffers:[u32;2],
}
pub fn create(source_flags:u32,element_index:u32,packet_index:u32,layer:u32,owner:u32,instance:u32,textures:[u32;2])->Packet {
 Packet {kind:2,flags:2*(source_flags&1),index:packet_index,element_index,layer,owner,mode:1,instance,textures,buffers:[0;2]}
}
pub fn visibility(flags:u32,enabled:bool)->u32 {if enabled {flags|2}else {flags&!2}}
pub fn alpha_enabled(mode:u32)->bool {mode&1!=0}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn original32_packet_creations_and10_visibility_updates_preserve_fields() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_effect_packets_contract.json")).unwrap();assert_eq!(c["packet_cases"],32);assert_eq!(c["visibility_cases"],10);
  for a in c["cases"].as_array().unwrap() {let f=&a["fields"];let textures=if a["textures"].as_bool().unwrap() {[5678,9012]}else {[0;2]};let p=create(a["flags"].as_u64().unwrap() as u32,a["element_index"].as_u64().unwrap() as u32,a["existing_packets"].as_u64().unwrap() as u32,77,f["0x14"].as_u64().unwrap() as u32,1234,textures);
   for (key,value) in [("0x0",p.kind),("0x4",p.flags),("0x8",p.index),("0xc",p.element_index),("0x10",p.layer),("0x14",p.owner),("0x18",p.mode),("0x1c",p.instance),("0x20",p.textures[0]),("0x24",p.textures[1]),("0x38",p.buffers[0]),("0x3c",p.buffers[1])] {assert_eq!(value,f[key].as_u64().unwrap() as u32);}
  }
  for a in c["visibility_updates"].as_array().unwrap() {assert_eq!(visibility(a["old_flags"].as_u64().unwrap() as u32,a["enabled"].as_bool().unwrap()),a["new_flags"].as_u64().unwrap() as u32);}
 }
 #[test] fn original20_alpha_cache_transitions_request_native_blend_factors() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_effect_state_contract.json")).unwrap();assert_eq!(c["case_count"],20);
  for a in c["cases"].as_array().unwrap() {let old=alpha_enabled(a["old_mode"].as_u64().unwrap() as u32);let new=alpha_enabled(a["mode"].as_u64().unwrap() as u32);let events=a["events"].as_array().unwrap();assert_eq!(events.len(),usize::from(old!=new));if old!=new {assert_eq!(events[0]["state"],27);assert_eq!(events[0]["value"],u32::from(new));}}
  let b=crate::native_hud_icon_material::blend();use bevy::render::render_resource::{BlendFactor,BlendOperation};assert_eq!(b.color.src_factor,BlendFactor::One);assert_eq!(b.color.dst_factor,BlendFactor::OneMinusSrcAlpha);assert_eq!(b.color.operation,BlendOperation::Add);assert_eq!(b.alpha,b.color);assert!(alpha_enabled(create(1,0,0,3,0,0,[0;2]).mode));
 }
}
