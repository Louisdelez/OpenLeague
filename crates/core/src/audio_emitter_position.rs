//! Native ambient position route lookup, point-only producer and queue13 fields.
use crate::audio_routing::VoiceRoute;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum OrientationState {
 /// 706DF0 initializes XYZ only; the API then copies three local stack words.
 /// These bytes are not an authored source direction and have no inferred default.
 NotInitializedByNativeProducer,
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct PositionUpdate {pub object_id:u32,pub position:[f32;3],pub orientation:OrientationState}
impl PositionUpdate {
 /// Original six-word packet layout for verification or raw native forwarding.
 /// Caller supplies opaque tail explicitly; this never invents an orientation.
 pub fn native_words(self,opaque_tail:[u32;3])->[u32;6] {
  [self.position[0].to_bits(),self.position[1].to_bits(),self.position[2].to_bits(),opaque_tail[0],opaque_tail[1],opaque_tail[2]]
 }
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Dispatch {pub position_update:Option<PositionUpdate>,pub refresh_voice:bool}
#[derive(Debug,Clone,Copy,PartialEq)]
pub enum Error {InvalidPosition}
/// 6CE200 updates only a found, actor-unbound voice. Its refresh call occurs even
/// when the position setter skips an unavailable engine or invalid object ID.
/// Actual refresh/RTPC effects and audio-object registration are separate.
pub fn dispatch(route:Option<VoiceRoute>,engine_available:bool,position:[f32;3])->Result<Dispatch,Error> {
 let Some(route)=route else {return Ok(Dispatch {position_update:None,refresh_voice:false});};
 if route.actor_id!=0 {return Ok(Dispatch {position_update:None,refresh_voice:false});}
 let position_update=if !engine_available || route.object_id==-1 || route.object_id==0 {None} else {
  if position.iter().any(|v|!v.is_finite()) {return Err(Error::InvalidPosition);}
  Some(PositionUpdate {object_id:route.object_id as u32,position,orientation:OrientationState::NotInitializedByNativeProducer})
 };
 Ok(Dispatch {position_update,refresh_voice:true})
}
#[cfg(test)]mod tests {
 use super::*;
 #[test]fn native_route_gates_point_bits_and_explicit_stack_tail_match() {
  #[derive(serde::Deserialize)]struct Message {object_id:u32,position_bits:[u32;3],opaque_orientation_words:[u32;3]}
  #[derive(serde::Deserialize)]struct Case {stack_seed_word:u32,found:bool,actor_id:u32,object_id:i32,engine_available:bool,position:[f32;3],messages:Vec<Message>,refresh_calls:usize}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_position_contract.json")).unwrap();assert_eq!(c.cases.len(),72);let mut messages=0;
  for c in c.cases {
   let route=c.found.then_some(VoiceRoute {object_id:c.object_id,actor_id:c.actor_id});let result=dispatch(route,c.engine_available,c.position).unwrap();
   assert_eq!(usize::from(result.refresh_voice),c.refresh_calls);assert_eq!(usize::from(result.position_update.is_some()),c.messages.len());
   if let Some(update)=result.position_update {
    messages+=1;let expected=&c.messages[0];assert_eq!(update.object_id,expected.object_id);assert_eq!(update.orientation,OrientationState::NotInitializedByNativeProducer);
    let words=update.native_words([c.stack_seed_word;3]);assert_eq!(&words[..3],&expected.position_bits);assert_eq!(&words[3..],&expected.opaque_orientation_words);
   }
  }
  assert_eq!(messages,3);
 }
 #[test]fn unavailable_and_unbound_routes_do_not_inspect_unused_position_data() {
  let route=VoiceRoute {object_id:123,actor_id:0};let bad=[f32::NAN;3];assert_eq!(dispatch(Some(route),true,bad),Err(Error::InvalidPosition));
  assert_eq!(dispatch(Some(route),false,bad).unwrap(),Dispatch {position_update:None,refresh_voice:true});assert_eq!(dispatch(None,true,bad).unwrap(),Dispatch {position_update:None,refresh_voice:false});
  assert_eq!(dispatch(Some(VoiceRoute {object_id:123,actor_id:9}),true,bad).unwrap().refresh_voice,false);
  assert!(dispatch(Some(VoiceRoute {object_id:0,actor_id:0}),true,bad).unwrap().position_update.is_none());
 }
}
