//! V791 comparison against native natural-end and deferred-cleanup observations.
//! This composes real core methods. Storage, callback interface and queue timing
//! are test adapters, not the game's physical backend or whole705150 update.
use openleague_core::{audio_deferred_pool::{Allocation, Cleanup, Pool, ScratchSubsystem},
    audio_engine_objects::ObjectIndex,
    audio_object_registration::{Registry, RegisterCommand, RemovedObject, unregister_command}};
use serde_json::{json, Value};
use std::cell::RefCell;
fn num(v:&Value)->u32 {v.as_u64().unwrap().try_into().unwrap()}
#[test]
fn natural_end_retirement_matches_native_stages() {
    let c:Value=serde_json::from_str(r#"{"object_id":3,"object_token":1612868880,"scratch":1612868960,"callback_cookie":856507392,"cleanup":["dispose","destroy_linked","remove"],"callback_methods":[{"slot":4,"argument":null},{"slot":0,"argument":1}],"registration_flags_before":3221225475,"registration_flags_after_natural_end":3221225473}"#).unwrap();
    let id=num(&c["object_id"]); let object=u64::from(num(&c["object_token"]));
    let token=u64::from(num(&c["scratch"])); let cookie=num(&c["callback_cookie"]);
    let mut registry=Registry::default();
    assert!(registry.register(RegisterCommand {object_id:id,listener_mask:1,extra_raw:0}, |_|Some(0)));
    registry.acquire(id).unwrap(); registry.acquire(id).unwrap();
    assert_eq!(registry.get(id).unwrap().dirty_flags,num(&c["registration_flags_before"]));
    let mut pool=Pool::default();let mut subsystem=ScratchSubsystem {initialized:true};
    assert!(matches!(pool.allocate(&mut subsystem,Some(cookie),||Some(object),||panic!("already initialized"),||Some(token)),Allocation::Registered {token:t}if t==token));
    let mut index=ObjectIndex::default();index.insert(id,object);
    pool.cleanup(|_|panic!("active entry cannot be removed"));
    assert_eq!(pool.entries().len(),1);assert_eq!(pool.entries()[0].retired,0);assert_eq!(index.tokens(id),[object]);
    // Each observed native voice releases its registered reference at natural end.
    for _ in 0..2 {assert!(!registry.get_mut(id).unwrap().release_reference());}
    assert_eq!(registry.get(id).unwrap().dirty_flags,num(&c["registration_flags_after_natural_end"]));
    let methods=RefCell::new(vec![]);
    assert!(pool.deliver_callback(token,1,|linked,call| {assert_eq!(*linked,cookie);methods.borrow_mut().push(json!({"slot":call.slot,"argument":call.argument}));}));
    assert_eq!(pool.entries()[0].retired,1);assert_eq!(index.tokens(id),[object]);
    assert_eq!(methods.borrow().len(),1);assert_eq!(methods.borrow()[0],c["callback_methods"][0]);
    let mut queue=vec![];let mut cleanup=vec![];
    pool.cleanup(|command| match command {
        Cleanup::DisposeObject(o)=>{
            assert_eq!(*o,object);
            assert!(index.dispose(Some(*o),|_|id,|actual,removed|{assert_eq!(actual,id);assert_eq!(removed,[object]);},
                |actual,flags|{assert_eq!((actual,flags),(object,1));queue.push(unregister_command(id).unwrap());}));
            cleanup.push("dispose");
        },
        Cleanup::DestroyLinked(linked)=>{assert_eq!(*linked,cookie);methods.borrow_mut().push(json!({"slot":0,"argument":1}));cleanup.push("destroy_linked");},
        Cleanup::RemoveScratch(t)=>{assert_eq!(t,token);cleanup.push("remove");},
    });
    assert!(pool.entries().is_empty());assert!(index.tokens(id).is_empty());
    assert!(registry.get(id).is_some());assert_eq!(queue.len(),1);
    pool.cleanup(|_|panic!("repeat update cannot destroy twice"));
    assert!(registry.get(id).is_some());assert_eq!(queue.len(),1);
    // Explicit test queue drain matches the later native worker stage. No claim
    // that this Vec implements the original publication/scheduler/transport.
    let removed=registry.unregister(queue.remove(0));
    assert_eq!(removed,vec![RemovedObject::Destroyed {dirty_flags:0x40000000}]);
    assert!(registry.get(id).is_none());
    assert_eq!(json!(cleanup),c["cleanup"]);assert_eq!(json!(*methods.borrow()),c["callback_methods"]);
    println!("OBSERVATION {}",json!({"object_id":id,"active_preserved":true,"retired_before_cleanup":true,
        "registry_deferred":true,"repeat_cleanup_empty":true,"registry_removed_after_drain":true,
        "cleanup":cleanup,"callback_methods":*methods.borrow(),"flags_before":c["registration_flags_before"],"flags_after_end":c["registration_flags_after_natural_end"]}));
}
#[test]
fn missing_cookie_and_null_disposal_leave_state_untouched() {
    let mut pool:Pool<u64,u32>=Pool::default();
    assert!(!pool.deliver_callback(999,1,|_,_|panic!("missing cookie")));
    pool.cleanup(|_|panic!("empty pool"));assert!(pool.entries().is_empty());
    let mut index=ObjectIndex::default();index.insert(3,44);
    assert!(!index.dispose::<u64>(None,|_|panic!("null object"),|_,_|panic!("null erase"),|_,_|panic!("null destroy")));
    assert_eq!(index.tokens(3),[44]);assert_eq!(unregister_command(0),None);
    println!("LOCAL_REFUSALS 3 PASS");
}
