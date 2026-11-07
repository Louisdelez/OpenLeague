//! Real callback consumers compared with V792 native marker-enabled/disabled traces.
//! Notification types, storage identities and interface leaves are test inputs.
//! No native marker producer, decoder or physical playback backend is implemented here.
use openleague_core::{audio_deferred_pool::{Allocation,Cleanup,Pool,ScratchSubsystem},audio_object_callbacks::{self,Kind}};
use serde_json::{json,Value};
fn num(v:&Value)->u32{v.as_u64().unwrap().try_into().unwrap()}
#[test]
fn consumers_match_three_native_marker_profiles(){
 let cases:Value=serde_json::from_str(r#"[{"route":"unbound","object_id":3,"object_token":1612868880,"scratch":1612868960,"callback_cookie":856507392,"callback_flags":5,"native_types":[4,4,4,4,1],"native_markers":[{"id":1,"position":0,"label":"Tempo: 120.0"},{"id":2,"position":0,"label":"Timestamp: 159906600"},{"id":1,"position":0,"label":"Tempo: 120.0"},{"id":2,"position":0,"label":"Timestamp: 158870250"}],"callback_methods":[{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":4,"argument":null},{"slot":0,"argument":1}],"cleanup":["dispose","destroy_linked","remove"]},{"route":"bound","object_id":2000001,"object_token":856506880,"scratch":0,"callback_cookie":856507392,"callback_flags":5,"native_types":[4,4,4,4,1],"native_markers":[{"id":1,"position":0,"label":"Tempo: 120.0"},{"id":2,"position":0,"label":"Timestamp: 159906600"},{"id":1,"position":0,"label":"Tempo: 120.0"},{"id":2,"position":0,"label":"Timestamp: 158870250"}],"callback_methods":[{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":8,"argument":null},{"slot":4,"argument":null},{"slot":0,"argument":1}],"cleanup":[]},{"route":"unbound","object_id":3,"object_token":1612868880,"scratch":1612868960,"callback_cookie":856507392,"callback_flags":1,"native_types":[1],"native_markers":[],"callback_methods":[{"slot":4,"argument":null},{"slot":0,"argument":1}],"cleanup":["dispose","destroy_linked","remove"]}]"#).unwrap();
 for c in cases.as_array().unwrap(){
  let bound=c["route"]=="bound";let object=num(&c["object_id"]);let cookie=num(&c["callback_cookie"]);let token=u64::from(num(&c["scratch"]));
  let mut methods=vec![];let mut cleanup=vec![];let mut pool=Pool::default();let mut subsystem=ScratchSubsystem{initialized:true};
  if !bound{assert!(matches!(pool.allocate(&mut subsystem,Some(cookie),||Some(object),||panic!("already initialized"),||Some(token)),Allocation::Registered{token:t}if t==token));}
  let mut retired=0;
  for typ in c["native_types"].as_array().unwrap(){
   let typ=num(typ);
   if bound{methods.extend(audio_object_callbacks::deliver(Kind::Bound,typ,true,false,&mut retired).into_iter().map(|q|json!({"slot":q.slot,"argument":q.argument})));assert_eq!(retired,0);}
   else{
    assert!(pool.deliver_callback(token,typ,|linked,q|{assert_eq!(*linked,cookie);methods.push(json!({"slot":q.slot,"argument":q.argument}));}));
    assert_eq!(pool.entries().len(),1);assert_eq!(pool.entries()[0].retired,u8::from(typ==1));
    if typ==4{pool.cleanup(|_|panic!("marker must not retire the object"));assert_eq!(pool.entries().len(),1);}
   }
  }
  if !bound{pool.clear(|command|match command{
   Cleanup::DisposeObject(o)=>{assert_eq!(*o,object);cleanup.push("dispose");},
   Cleanup::DestroyLinked(linked)=>{assert_eq!(*linked,cookie);methods.push(json!({"slot":0,"argument":1}));cleanup.push("destroy_linked");},
   Cleanup::RemoveScratch(t)=>{assert_eq!(t,token);cleanup.push("remove");},
  });assert!(pool.entries().is_empty());}
  assert_eq!(json!(methods),c["callback_methods"]);assert_eq!(json!(cleanup),c["cleanup"]);
  println!("OBSERVATION {}",json!({"route":c["route"],"object_id":object,"flags":c["callback_flags"],"native_types":c["native_types"],"methods":methods,"cleanup":cleanup}));
 }
}
#[test]
fn absent_cookie_link_and_unsupported_exact_type_are_explicit(){
 let mut retired=0;
 assert!(audio_object_callbacks::deliver(Kind::Bound,4,false,false,&mut retired).is_empty());
 assert!(audio_object_callbacks::deliver(Kind::Unbound,4,true,false,&mut retired).is_empty());
 assert!(audio_object_callbacks::deliver(Kind::Unbound,5,true,true,&mut retired).is_empty());
 assert_eq!(retired,0);println!("LOCAL_REFUSALS 3 PASS");
}
