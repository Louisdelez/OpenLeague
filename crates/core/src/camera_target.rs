//! Native5AEB40 selection gate,5A54E0 target ID selection and7CFB70 initialization prelude.
use std::collections::BTreeMap;
#[derive(Debug,Clone,Copy)]
/// Flags: provider1A1, provider334, UI1B0, cameraDC; time fields338/340.
pub struct Gate {pub flags:[u8;4],pub first_time:f32,pub second_time:f32,pub now:f32,pub input_option_raw:u8,pub mode_raw:u32,pub ui_present:bool}
impl Gate {
 pub fn enabled(&self)->bool {
  if self.flags[0]==0||self.flags[1]==0||self.first_time>self.now {return false;}
  if self.input_option_raw!=0&&self.second_time>self.now {return false;}
  self.ui_present&&self.flags[2]!=0&&self.flags[3]!=0&&self.mode_raw==2
 }
}
/// Refresh is external: cached index must be the result of the original selection updater.
pub fn selected_id(ids:&[u32],gate:bool,cached_index_after_update:i32)->u32 {
 let index=if gate {cached_index_after_update} else {0};
 if index<0 {0} else {ids.get(index as usize).copied().unwrap_or(0)}
}
/// Unique unsigned network IDs resolve to entity positions; native hash-container mechanics external.
pub fn resolve_position(registry:&BTreeMap<u32,[f32;3]>,id:u32)->Option<[f32;3]> {registry.get(&id).copied()}
#[derive(Debug,Clone,Copy)]
pub struct Context {pub follow_block_raw:u32,pub service_active_raw:u8,pub ui_present:bool,pub target_provider_present:bool}
#[derive(Debug,Clone,Copy)]
pub struct Initialization {pub focus:[f32;3],pub service_queried:bool,pub getter_called:bool,pub selection_update_requested:bool,pub lookup_id:Option<u32>}
/// Native target prelude before the Y reset/restriction/geometry phase. Missing entities preserve focus.
pub fn initialize_missing_focus(focus:[f32;3],context:&Context,ids:&[u32],selection_gate:bool,cached_index_after_update:i32,registry:&BTreeMap<u32,[f32;3]>)->Initialization {
 let mut out=Initialization{focus,service_queried:false,getter_called:false,selection_update_requested:false,lookup_id:None};
 if !(focus[1]< -999.)||context.follow_block_raw!=0 {return out;}
 out.service_queried=true;
 if context.service_active_raw==0||!context.ui_present||!context.target_provider_present {return out;}
 out.getter_called=true;out.selection_update_requested=selection_gate;
 let id=selected_id(ids,selection_gate,cached_index_after_update);
 if id==0 {return out;}
 out.lookup_id=Some(id);
 if let Some(position)=resolve_position(registry,id) {out.focus=position;}
 out
}
#[cfg(test)]
mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_target_contract.json")).unwrap()}
 #[test]
 fn matches_512_native_selection_gates_including_unordered_timing_comparisons() {
  let p=proof();let cases=p["gates"].as_array().unwrap();assert_eq!(cases.len(),512);
  for c in cases {
   let gate=Gate{flags:std::array::from_fn(|i|c["flags"][i].as_u64().unwrap() as u8),first_time:f32::from_bits(c["times_bits"][0].as_u64().unwrap() as u32),second_time:f32::from_bits(c["times_bits"][1].as_u64().unwrap() as u32),now:0.,input_option_raw:c["input_option_raw"].as_u64().unwrap() as u8,mode_raw:c["mode_raw"].as_u64().unwrap() as u32,ui_present:c["ui_present"].as_bool().unwrap()};
   assert_eq!(gate.enabled(),c["result_raw"].as_u64().unwrap()!=0,"{c}");
  }
 }
 #[test]
 fn matches_48_native_target_id_getters_with_explicit_index_refresh() {
  let p=proof();let cases=p["getters"].as_array().unwrap();assert_eq!(cases.len(),48);
  for c in cases {
   let ids=c["ids"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();let gate=c["gate"].as_bool().unwrap();assert_eq!(selected_id(&ids,gate,c["cached_index_after_update"].as_i64().unwrap() as i32),c["target_id"].as_u64().unwrap() as u32);assert_eq!(c["index_update_calls"].as_u64().unwrap(),u64::from(gate));
  }
 }
 #[test]
 fn matches_54_native_unsigned_registry_lookups_in_three_hash_layouts() {
  let p=proof();let cases=p["resolvers"].as_array().unwrap();assert_eq!(cases.len(),54);
  for c in cases {let registry=c["registered_ids"].as_array().unwrap().iter().map(|v|(v.as_u64().unwrap() as u32,[1.,2.,3.])).collect();assert_eq!(resolve_position(&registry,c["query"].as_u64().unwrap() as u32).is_some(),c["resolved"].as_bool().unwrap());}
 }
 #[test]
 fn matches_576_full_native_target_preludes_and_their_dispatch_branches() {
  let p=proof();let cases=p["preludes"].as_array().unwrap();assert_eq!(cases.len(),576);
  for (n,c) in cases.iter().enumerate() {
   let context=Context{follow_block_raw:c["follow_block_raw"].as_u64().unwrap() as u32,service_active_raw:c["service_active_raw"].as_u64().unwrap() as u8,ui_present:c["ui_present"].as_bool().unwrap(),target_provider_present:c["provider_present"].as_bool().unwrap()};
   let vector=|v:&serde_json::Value|std::array::from_fn(|i|v[i].as_f64().unwrap() as f32);let registry=c["registry"].as_object().unwrap().iter().map(|(id,v)|(id.parse::<u32>().unwrap(),vector(v))).collect();let ids=c["target_ids"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
   let out=initialize_missing_focus(vector(&c["focus"]),&context,&ids,c["gate"].as_bool().unwrap(),c["cached_index_after_update"].as_i64().unwrap() as i32,&registry);
   for i in 0..3 {assert_eq!(out.focus[i].to_bits(),c["output_focus_bits"][i].as_u64().unwrap() as u32,"case{n}/axis{i}");}
   assert_eq!(u64::from(out.service_queried),c["service_queries"].as_u64().unwrap());assert_eq!(u64::from(out.getter_called),c["getter_calls"].as_u64().unwrap());assert_eq!(u64::from(out.selection_update_requested),c["index_update_calls"].as_u64().unwrap());let ids=c["lookup_ids"].as_array().unwrap();assert_eq!(ids.len(),usize::from(out.lookup_id.is_some()));if let Some(id)=out.lookup_id {assert_eq!(id,ids[0].as_u64().unwrap() as u32);}
  }
 }
}
