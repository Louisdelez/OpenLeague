//! Native7631D0/7647B0 impact callback and763740 no-bone target selection.
use crate::native_particle_force_body::inverse_estimate;
#[derive(Clone,Copy,Debug)]
pub struct State {pub position:[f32;3],pub direction:[f32;3]}
pub trait Backend {
 /// Dispatch corresponding to76F0D0; the state still has its original direction.
 fn impact_request(&mut self,state:&State,normalized:[f32;3]);
}
/// Target span empty uses stored fallback; a present target adds its native height.
/// Bone attachment resolution, effect consumer and object deletion are separate.
pub fn finish(state:&mut State,fallback:[f32;3],target:Option<[f32;3]>,height:f32,backend:&mut impl Backend)->Result<bool,&'static str>{
 let selected=target.map(|v|[v[0],v[1]+height,v[2]]).unwrap_or(fallback);
 if !state.direction.into_iter().chain(selected).chain([height]).all(f32::is_finite){return Err("unqualified impact input");}
 let d=state.direction;let squared=(d[1]*d[1]+d[0]*d[0])+d[2]*d[2];
 if !squared.is_finite(){return Err("impact direction overflow");}
 let normalized=if squared>1e-9 {let e=inverse_estimate(squared)?;let factor=(3.-((e*squared)*e))*(e*0.5);d.map(|v|v*factor)}else{d};
 state.position=selected;
 backend.impact_request(state,normalized);
 state.direction=[0.;3];
 Ok(false)
}
/// Selection section76F323..76F5F9; HitBranch requires its own consumer.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum EffectRoute {None,HitBranch,AfterRequest}
pub fn effect_route(cast_3b9:u8,spell_37d:u8,spell_37f:u8,spell_380:u8,after_pointer_nonnull:bool)->EffectRoute{
 if cast_3b9==0 && spell_37d&2==0 {EffectRoute::None}
 else if spell_37f&0x40!=0 {EffectRoute::HitBranch}
 else if spell_380&1!=0 && after_pointer_nonnull {EffectRoute::AfterRequest}
 else{EffectRoute::None}
}
#[cfg(test)]
mod tests {
 use super::*;
 struct Capture {requests:Vec<(State,[f32;3])>}
 impl Backend for Capture {fn impact_request(&mut self,state:&State,normalized:[f32;3]){self.requests.push((*state,normalized));}}
 #[test]
 fn matches192_original_impact_callbacks(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_impact_callback_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),192);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){
 let v=|k:&str|std::array::from_fn(|i|c[k][i].as_f64().unwrap() as f32);
 let mut state=State{position:[0.;3],direction:v("direction")};let mut backend=Capture{requests:vec![]};
 let result=finish(&mut state,v("fallback"),c["target_present"].as_bool().unwrap().then(||v("position")),c["height"].as_f64().unwrap() as f32,&mut backend).unwrap();assert!(!result);assert_eq!(backend.requests.len(),1);
 let(before,normalized)=backend.requests[0];
 for(values,expected) in [(before.position,&c["request"]["position_words"]),(before.direction,&c["request"]["direction_before_words"]),(normalized,&c["request"]["normalized_words"]),(state.position,&c["final_position_words"]),(state.direction,&c["final_direction_words"]) ]{for i in 0..3{assert_eq!(values[i].to_bits(),expected[i].as_u64().unwrap() as u32,"case{n} axis{i}");}}
 }
 }
 #[test]
 fn matches48_original_effect_gate_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_impact_effect_gate_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),48);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){
 let b=|k:&str|c[k].as_bool().unwrap();let a=effect_route(c["forced"].as_u64().unwrap() as u8,if b("point_flag"){2}else{0},if b("hit_flag"){0x40}else{0},u8::from(b("after_flag")),b("name_pointer"));
 let expected=match c["route"].as_str().unwrap(){"none"=>EffectRoute::None,"hit_branch"=>EffectRoute::HitBranch,"after_request"=>EffectRoute::AfterRequest,_=>panic!("unknown native route")};assert_eq!(a,expected,"case{n}");
 }
 }

}
