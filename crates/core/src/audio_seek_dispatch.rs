//! Numeric AEB010 seek packet and native type23 event-worker routing.
//! Node/sample seek execution belongs to the device backend, not event selection.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Packet {pub object_id:u32,pub milliseconds:i32,pub marker_raw:u8}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Action {pub kind:u16,pub target:u32}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct NodeSeek {pub milliseconds:i32,pub nearest_marker:bool}
/// Event lookup must retain the actual event before queue submission. Failure
/// returns native2 and does not queue. The queue's status is passed through.
pub fn enqueue(event_found:bool,packet:Packet,submit:impl FnOnce(Packet)->u32)->u32 {
    if event_found{submit(packet)}else{2}
}
pub trait Backend {
    type Object;
    type Node;
    fn acquire_object(&mut self,id:u32)->Option<Self::Object>;
    fn acquire_node(&mut self,target:u32)->Option<Self::Node>;
    fn seek_node(&mut self,node:&Self::Node,object:Option<&Self::Object>,request:NodeSeek);
    fn release_node(&mut self,node:Self::Node);
    fn release_object(&mut self,object:Self::Object);
    fn release_event(&mut self);
}
/// Preserves action order and duplicates, skips non-Play0403 and absent nodes.
/// An absent object accepts only the native FFFFFFFF global request. Object and
/// event references are released after node calls, including no-op branches.
pub fn dispatch(packet:Packet,actions:impl IntoIterator<Item=Action>,backend:&mut impl Backend){
    let object=backend.acquire_object(packet.object_id);
    if object.is_some() || packet.object_id==u32::MAX {
        for action in actions {
            if action.kind!=0x403{continue;}
            if let Some(node)=backend.acquire_node(action.target){
                backend.seek_node(&node,object.as_ref(),NodeSeek{milliseconds:packet.milliseconds,nearest_marker:packet.marker_raw&1!=0});
                backend.release_node(node);
            }
        }
    }
    if let Some(object)=object{backend.release_object(object);}
    backend.release_event();
}
#[cfg(test)] mod tests {
 use super::*;
 fn contract()->serde_json::Value{serde_json::from_str(include_str!("../../../data/4.20/audio_seek_dispatch_contract.json")).unwrap()}
 #[test] fn numeric_api_preserves_raw_time_marker_and_queue_status_in240_native_cases(){
  let proof=contract();let cases=proof["api_cases"].as_array().unwrap();assert_eq!(cases.len(),240);
  for row in cases{
   let p=Packet{object_id:row["object_id"].as_u64().unwrap() as u32,milliseconds:row["milliseconds"].as_i64().unwrap() as i32,marker_raw:row["marker_raw"].as_u64().unwrap() as u8};let mut calls=Vec::new();
   let result=enqueue(row["event_found"].as_bool().unwrap(),p,|p|{calls.push(serde_json::json!({"kind":"packet","object_id":p.object_id,"offset_raw":p.milliseconds as u32,"relative_raw":0,"marker_raw":p.marker_raw}));row["queue_result"].as_u64().unwrap() as u32});
   assert_eq!(u64::from(result),row["result"].as_u64().unwrap());assert_eq!(serde_json::json!(calls),row["calls"]);
  }
 }
 struct Probe{object_found:bool,node_found:bool,calls:Vec<serde_json::Value>,released_objects:usize}
 impl Backend for Probe{
  type Object=();type Node=u32;
  fn acquire_object(&mut self,_:u32)->Option<()>{self.object_found.then_some(())}
  fn acquire_node(&mut self,id:u32)->Option<u32>{self.calls.push(serde_json::json!({"kind":"lookup","target":id}));self.node_found.then_some(id)}
  fn seek_node(&mut self,_:&u32,object:Option<&()>,s:NodeSeek){self.calls.push(serde_json::json!({"kind":"seek","object_present":object.is_some(),"offset_raw":s.milliseconds as u32,"flags":u8::from(s.nearest_marker)<<1,"action_kind":4,"zero_words":[0,0]}));}
  fn release_node(&mut self,_:u32){self.calls.push(serde_json::json!({"kind":"node_release"}));}
  fn release_object(&mut self,_:()){self.released_objects+=1;}
  fn release_event(&mut self){self.calls.push(serde_json::json!({"kind":"event_release"}));}
 }
 #[test] fn action_filter_global_route_and_release_order_match288_native_cases(){
  let proof=contract();let cases=proof["worker_cases"].as_array().unwrap();assert_eq!(cases.len(),288);
  for row in cases{
   let mut b=Probe{object_found:row["object_found"].as_bool().unwrap(),node_found:row["node_found"].as_bool().unwrap(),calls:Vec::new(),released_objects:0};
   dispatch(Packet{object_id:row["object_id"].as_u64().unwrap() as u32,milliseconds:row["milliseconds"].as_i64().unwrap() as i32,marker_raw:row["marker_raw"].as_u64().unwrap() as u8},[Action{kind:0x403,target:11},Action{kind:0x503,target:22},Action{kind:0x403,target:33}],&mut b);
   let mut expected=row["calls"].clone();for call in expected.as_array_mut().unwrap(){if call["kind"]=="seek"{call["flags"]=serde_json::json!(call["flags"].as_u64().unwrap()&3);}}
   assert_eq!(serde_json::json!(b.calls),expected);assert_eq!(b.released_objects,usize::from(b.object_found));
  }
 }
}
