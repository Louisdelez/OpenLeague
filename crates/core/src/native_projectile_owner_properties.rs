//! Concrete projectile-owner property callbacks and Troy setters from6C97B0.
//! Qualified only with no optional body component, default wrapper visibility and empty lists.
use crate::native_projectile_stop_dispatch::Wrapper;
#[derive(Clone,Debug)]
pub struct Properties {
 pub requests:u32,pub radius:u32,pub color:[u32;8],pub visibility:u8,
 pub position:[u32;3],pub channels:[u32;3],
}
impl Properties {
 /// Copies the source fields written by the qualified wrapper callbacks/setters.
 /// Other constructor and externally supplied source fields remain unchanged.
 pub fn apply_to_source(&self,source:&mut crate::native_troy_properties::Source) {
  source.requests=self.requests;source.params[2]=self.radius;source.color=self.color;
  source.visibility=self.visibility;source.position=self.position;source.channels=self.channels;
 }
}
/// Source84 is a suppression byte: downstream Troy maps it to instance1DC bit8.
/// Inputs correspond to wrapper158, wrapper12C and the qualified virtual90/20 results.
/// None means no acquired primary provider; native construction and team visibility remain open.
pub fn source_suppression(enabled_158:bool,mode_12c:u32,wrapper_visible:bool,provider_visible:Option<bool>)->u8 {
 u8::from(!enabled_158 || !wrapper_visible || mode_12c==0 || provider_visible==Some(false))
}
/// Original6CA0A0 with no secondary provider and concrete projectile provider90=true.
/// Root filter, team id and mask are caller inputs; their native producers remain separate.
pub fn projectile_team_visible(type_flags:u32,root_filter_enabled:bool,team_id:Option<u32>,team_mask:u32)->bool {
 if type_flags&0x20!=0 {return false;}
 if !root_filter_enabled {return true;}
 match team_id {
  None=>true,
  Some(team)=>team_mask&(if team==100 {1} else {2})!=0,
 }
}
/// Caller supplies native weak acquisition and actor flags; their producers remain separate.
/// Optional body shapes, visibility overrides and populated property providers are unsupported here.
pub fn update(wrapper:&mut Wrapper,wrapper_position:&mut [u32;3],properties:&mut Properties,
              resource_live:bool,provider_present:bool,owner:Option<([f32;3],u32)>)->bool {
 if !wrapper.update_owner_gate(resource_live,false,provider_present,owner.is_some()) {return false;}
 if provider_present {
  if let Some((position,flags))=owner {
   *wrapper_position=position.map(f32::to_bits);
   // Original concrete callback has zero radius when optional component is absent.
   properties.radius=0;properties.requests|=8;
   if flags&0x400!=0 {
    properties.color=[position[0],position[1],position[2],0.,1.,0.,0.,0.].map(f32::to_bits);
    properties.requests|=0x4000;
   }
  }
 }
 // Zero-initialized wrapper fixtures suppress the source; these are not native constructor defaults.
 properties.visibility=source_suppression(false,0,false,None);properties.requests|=0x10;
 properties.position=*wrapper_position;properties.requests|=0x1000;
 properties.channels=*wrapper_position;properties.requests|=0x80;
 true
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn projectile_team_visibility_matches192_original_callbacks() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_team_visibility_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),192);
  for c in cases {
   let actual=projectile_team_visible(0x212|if c["excluded_type_20"].as_bool().unwrap(){0x20}else{0},c["root_filter_enabled"].as_bool().unwrap(),c["team_id"].as_u64().map(|x|x as u32),c["team_mask"].as_u64().unwrap() as u32);
   assert_eq!(actual,c["visible"].as_bool().unwrap(),"{c}");
  }
 }
 #[test]
 fn wrapper_visibility_matches32_original_updates() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_wrapper_visibility_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),32);
  for c in cases {
   let provider=(c["provider_present"].as_bool().unwrap() && c["owner_live"].as_bool().unwrap()).then_some(true);
   let actual=source_suppression(c["enabled_158"].as_bool().unwrap(),c["mode_12c"].as_u64().unwrap() as u32,c["wrapper_callback"].as_bool().unwrap(),provider);
   assert_eq!(actual,c["after"]["visibility"].as_u64().unwrap() as u8,"{c}");
  }
 }
 #[test]
 fn concrete_owner_property_callbacks_match24_original_updates() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_owner_properties_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),24);
  for c in cases {
   let b=&c["before"];let a=&c["after"];
   let words=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect::<Vec<_>>();
   let mut wrapper=Wrapper{ended:b["ended"].as_u64().unwrap() as u32,linked:true};
   let mut position=[500f32,600.,700.].map(f32::to_bits);
   let mut properties=Properties{requests:b["requests"].as_u64().unwrap() as u32,radius:b["radius"].as_u64().unwrap() as u32,color:words(&b["color"]).try_into().unwrap(),visibility:b["visibility"].as_u64().unwrap() as u8,position:words(&b["position"]).try_into().unwrap(),channels:words(&b["channels"]).try_into().unwrap()};
   let owner=c["owner_live"].as_bool().unwrap().then(||(std::array::from_fn(|i|c["owner_position"][i].as_f64().unwrap() as f32),c["flags"].as_u64().unwrap() as u32));
   let value=update(&mut wrapper,&mut position,&mut properties,true,c["provider_present"].as_bool().unwrap(),owner);
   assert_eq!(value,c["continues"].as_bool().unwrap(),"{c}");assert_eq!(wrapper.ended,a["ended"].as_u64().unwrap() as u32,"{c}");
   assert_eq!(properties.requests,a["requests"].as_u64().unwrap() as u32,"{c}");assert_eq!(properties.radius,a["radius"].as_u64().unwrap() as u32,"{c}");assert_eq!(properties.visibility,a["visibility"].as_u64().unwrap() as u8,"{c}");
   for (key,actual) in [("color",properties.color.to_vec()),("position",properties.position.to_vec()),("channels",properties.channels.to_vec())]{assert_eq!(actual,words(&a[key]),"{key} {c}");}
  }
 }

 #[test]
 fn callback_setters_and_troy_transfer_match48_original_compositions() {
  use crate::{native_troy_properties::{Source,Emitter,Config},native_troy_scalar::Child,native_troy_position_bounds::Bounds};
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_owner_property_transfer_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
  let words=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect::<Vec<_>>();
  for c in cases {
   let b=&c["before"];let eb=&c["emitter_before"];let expected=&c["emitter_after"];
   let mut wrapper=Wrapper{ended:0,linked:true};let mut position=[500f32,600.,700.].map(f32::to_bits);
   let mut properties=Properties{requests:b["requests"].as_u64().unwrap() as u32,radius:b["radius"].as_u64().unwrap() as u32,color:words(&b["color"]).try_into().unwrap(),visibility:b["visibility"].as_u64().unwrap() as u8,position:words(&b["position"]).try_into().unwrap(),channels:words(&b["channels"]).try_into().unwrap()};
   let owner=c["owner_live"].as_bool().unwrap().then(||(std::array::from_fn(|i|c["owner_position"][i].as_f64().unwrap() as f32),c["flags"].as_u64().unwrap() as u32));
   update(&mut wrapper,&mut position,&mut properties,true,c["provider_present"].as_bool().unwrap(),owner);
   let mut source=Source{requests:0,flags:0,visibility:0,params:[1f32.to_bits(),1f32.to_bits(),0],color:[0;8],matrix:[0;16],channels:[0;3],field_80:0,position:[0;3],direction:[0;3]};
   properties.apply_to_source(&mut source);
   let mut emitter=Emitter{flags:eb["flags"].as_u64().unwrap() as u8,source_flags:0,channels:words(&eb["channels"]).try_into().unwrap(),field_80:0,params:words(&eb["params"]).try_into().unwrap(),color:words(&eb["color"]).try_into().unwrap(),matrix:[0;16],bounds:Bounds{position:words(&eb["position"]).try_into().unwrap(),minimum:words(&eb["minimum"]).try_into().unwrap(),maximum:words(&eb["maximum"]).try_into().unwrap()},direction:[0;3]};
   let mut child=[Child{coefficients:[1f32.to_bits(),(c["owner_weight"].as_f64().unwrap() as f32).to_bits(),0],owner:[2f32.to_bits(),0],value:eb["child_factor"].as_u64().unwrap() as u32}];
   crate::native_troy_properties::transfer(&source,&mut emitter,Config{lower:0,upper:1f32.to_bits(),scale_cap:1f32.to_bits(),group_vis:500f32.to_bits()},&mut child,&mut [],None);
   assert_eq!(emitter.flags,expected["flags"].as_u64().unwrap() as u8,"{c}");assert_eq!(child[0].value,expected["child_factor"].as_u64().unwrap() as u32,"{c}");
   for (key,actual) in [("params",emitter.params.to_vec()),("color",emitter.color.to_vec()),("channels",emitter.channels.to_vec()),("position",emitter.bounds.position.to_vec()),("minimum",emitter.bounds.minimum.to_vec()),("maximum",emitter.bounds.maximum.to_vec())]{assert_eq!(actual,words(&expected[key]),"{key} {c}");}
  }
 }
}
