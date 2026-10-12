use super::*;
use crate::audio_replay_stream as stream;
use crate::audio_announcer_owner_metadata as callback;
use crate::audio_replay_manager_control as manager_control;

impl callback::Boundaries for Backend{
    fn allocate_callback_clone(&mut self,bytes:u32)->Result<u32,&'static str>{let p=self.allocate(bytes).map_err(|_|"callback allocation failed")?;self.clone_labels.insert(p);Ok(p)}
    fn register_listener(&mut self,_:u32,_:u32,_:u32,_:&mut u32)->Result<(),&'static str>{Err("unexpected listener registration")}
    fn unregister_listener(&mut self,_:u32,_:u32,_:u32)->Result<(),&'static str>{Err("unexpected listener unregistration")}
}
impl stream::Boundary for Backend{
    fn state_action(&mut self,action:stream::Action)->Result<(),&'static str>{
        self.actions.push(action);
        if action.method==0x32008400{if let Some(node)=self.state_mutation.take(){self.set(action.object+4,node);}Ok(())}
        else{stream::no_op_action(action.method)}
    }
    fn observe_event_callback(&mut self,handler:u32,owner:u32,member:u32,event:u32){self.event_calls.push(json!({"handler":handler,"member":member,"owner":owner,"event":event}));}
}
fn make_stream(fill:u8,custom:bool)->Backend{
    let mut b=make(fill);b.custom=custom;
    for (p,len) in [(callback::HANDLER_VTABLE,12),(stream::MACHINE_VTABLE,40),(0x3000c000,512)]{b.memory.reserve_at(p,len).unwrap();}
    for (off,v) in [(0,callback::HANDLER_DELETE),(4,callback::HANDLER_CLONE),(8,0x5cce30)]{b.set(callback::HANDLER_VTABLE+off,v);}
    b.set(stream::MACHINE_VTABLE,0x901c3c);b.set(stream::MACHINE_VTABLE+4,0x8fb9a0);
    for off in (8..40).step_by(4){b.set(stream::MACHINE_VTABLE+off,stream::NO_OP_ACTION);}
    for p in [HELD,INCOMING,0x3000a920]{b.set(p,0);b.set(p+4,0);}b
}
fn observed(b:&mut Backend,v:&Value,label:&str){
    let allocations:Vec<_>=b.memory.allocations.iter().map(|&(bytes,pointer)|{
        let mut item=json!({"bytes":bytes,"pointer":pointer});if b.clone_labels.contains(&pointer){item["allocator"]=json!("engine_operator_new");}item
    }).collect();
    assert_eq!(json!(allocations),v["allocations"],"allocations {label}");assert_eq!(json!(b.memory.released_labels),v["freed"],"frees {label}");assert_eq!(json!(b.events),v["events"],"events {label}");
    for row in v["words"].as_array().unwrap(){assert_eq!(b.word(n(&row[0])).unwrap(),n(&row[1]),"memory {label} {row}");}
    for row in v["pairs"].as_array().unwrap(){let p=n(&row[0]);assert_eq!(b.word(p).unwrap(),n(&row[1]),"pair {label}");assert_eq!(b.word(p+4).unwrap(),n(&row[2]),"pair control {label}");}
    let calls:Vec<_>=b.actions.iter().map(|a|json!({"method":a.method,"object":a.object,"args":a.args})).collect();assert_eq!(json!(calls),v["callbacks"],"virtual actions {label}");
    if let Some(expected)=v.get("action_calls"){
        let calls:Vec<_>=b.actions.iter().map(|a|json!({"handler":a.handler,"member":a.member,"owner":a.object,"args":a.args})).collect();assert_eq!(json!(calls),*expected,"member actions {label}");assert_eq!(json!(b.event_calls),v["event_calls"],"event callbacks {label}");
    }
    b.memory.allocations.clear();b.memory.released_labels.clear();b.events.clear();b.actions.clear();b.event_calls.clear();
}
fn new_stream(b:&mut Backend)->u32{let p=b.allocate(120).unwrap();assert_eq!(stream::construct(b,p).unwrap(),p);p}
fn new_manager(b:&mut Backend)->u32{
    let p=b.allocate(48).unwrap();construct(b,p).unwrap();
    for (i,id) in [0,1,42,0x80000000,0xffffffff,7].into_iter().enumerate(){let value=[0u64,0,1,1,u64::MAX,0x8000000000000000][i];b.incoming(id,value as u32,(value>>32) as u32);insert(b,p,INCOMING,SCRATCH).unwrap();}
    b.set(INCOMING,0);b.set(INCOMING+4,0);p
}
#[test]
fn audio_replay_stream_matches32_native_complete_initialization_and_teardown_lifetimes(){
    let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_stream_initialization_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),32);
    for c in cases{
        let mut b=make_stream(n(&c["fill"]) as u8,c["custom"].as_bool().unwrap());let p=new_stream(&mut b);assert_eq!(p,n(&c["stream"]));observed(&mut b,&c["initial"],"construct");
        if c["populated_object_manager"].as_bool().unwrap(){let manager=new_manager(&mut b);manager_control::replace_pair(&mut b,INCOMING,manager).unwrap();pair::move_assign(&mut b,p+0x6c,INCOMING).unwrap();}
        observed(&mut b,&c["attached"],"attach manager");let flags=n(&c["flags"]);assert_eq!(stream::scalar_delete(&mut b,p,flags).unwrap(),n(&c["result"]));observed(&mut b,&c["destroyed"],"destructor");
        if flags&1==0{b.free(p,removal::Deallocator::Standard).unwrap();}observed(&mut b,&c["caller_cleanup"],"caller cleanup");assert!(b.word(p).is_err());assert!(b.locks.is_empty());assert!(b.held.is_empty());assert!(b.counts.is_empty());
    }
}

fn hierarchy(b:&mut Backend,p:u32)->(Vec<u32>,u32,u32){
    let nodes:Vec<_>=(0x50..0x64).step_by(4).map(|off|b.word(p+off).unwrap()).collect();let foreign=0x3000c000;let mut deep=nodes[0];
    for index in 0..9{let node=foreign+index*32;let parent=if index==0{0}else{deep};let enter=b.word(nodes[2]).unwrap();let exit=b.word(nodes[2]+4).unwrap();let event=b.word(nodes[3]+8).unwrap();
        for (off,v) in [(0,enter),(4,exit),(8,event),(12,88+index),(16,parent)]{b.set(node+off,v);}if index!=0{deep=node;}}
    (nodes,foreign,deep)
}
fn state_proof()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_stream_states_contract.json")).unwrap()}
#[test]
fn audio_replay_stream_matches192_native_direct_transitions_and_all_temporary_vector_lifetimes(){
    let proof=state_proof();let cases=proof["transitions"].as_array().unwrap();assert_eq!(cases.len(),192);
    for c in cases{
        let mut b=make_stream(n(&c["fill"]) as u8,c["custom"].as_bool().unwrap());let p=new_stream(&mut b);let (nodes,foreign,deep)=hierarchy(&mut b,p);observed(&mut b,&c["initial"],"construct");
        let current=c["current"].as_i64().unwrap();let target=c["target"].as_i64().unwrap();let before=if current==-1{0}else{nodes[current as usize]};let after=match target{-1=>0,5=>foreign,6=>deep,_=>nodes[target as usize]};b.set(p+0x44,before);
        stream::transition(&mut b,p+0x40,after).unwrap();assert_eq!(b.word(p+0x44).unwrap(),n(&c["current_after"]));observed(&mut b,&c["after"],&format!("transition {current}->{target}"));
        stream::scalar_delete(&mut b,p,1).unwrap();observed(&mut b,&c["destroyed"],"destructor");assert!(b.locks.is_empty());assert!(b.word(p).is_err());
    }
}
#[test]
fn audio_replay_stream_matches1076_native_event_stop_and_transition_operations(){
    let proof=state_proof();let cases=proof["sequences"].as_array().unwrap();assert_eq!(cases.len(),4);let mut operations=0;
    for c in cases{
        let mut b=make_stream(n(&c["fill"]) as u8,c["custom"].as_bool().unwrap());let p=new_stream(&mut b);let (nodes,_,_)=hierarchy(&mut b,p);observed(&mut b,&c["initial"],"construct");
        for step in c["steps"].as_array().unwrap(){let op=&step["op"];
            match op[0].as_str().unwrap(){"event"=>stream::dispatch_event(&mut b,p+0x40,n(&op[1])).unwrap(),"stop"=>stream::stop(&mut b,p).unwrap(),"transition"=>stream::transition(&mut b,p+0x40,nodes[n(&op[1]) as usize]).unwrap(),_=>panic!("unknown state operation")}
            assert_eq!(b.word(p+0x44).unwrap(),n(&step["current"]));observed(&mut b,&step["state"],&op.to_string());operations+=1;
        }
        stream::scalar_delete(&mut b,p,1).unwrap();observed(&mut b,&c["destroyed"],"active state destructor");assert!(b.locks.is_empty());assert!(b.word(p).is_err());
    }
    assert_eq!(operations,1076);
}
#[test]
fn audio_replay_stream_callback_mutations_preserve_fresh_current_and_original_target_arguments(){
    let proof=state_proof();let cases=proof["mutations"].as_array().unwrap();assert_eq!(cases.len(),4);
    for c in cases{
        let mut b=make_stream(n(&c["fill"]) as u8,c["custom"].as_bool().unwrap());let p=new_stream(&mut b);let (nodes,_,_)=hierarchy(&mut b,p);observed(&mut b,&c["initial"],"construct");
        for off in (8..40).step_by(4){b.set(stream::MACHINE_VTABLE+off,0x32008400);}b.state_mutation=Some(nodes[0]);stream::transition(&mut b,p+0x40,nodes[4]).unwrap();assert_eq!(b.word(p+0x44).unwrap(),nodes[0]);assert!(b.state_mutation.is_none());observed(&mut b,&c["after"],"mutating virtual action");
        stream::scalar_delete(&mut b,p,1).unwrap();observed(&mut b,&c["destroyed"],"destructor");assert!(b.locks.is_empty());
    }
}
#[test]
fn audio_replay_stream_rejects_missing_worker_and_implementation_without_fake_stop_success(){
    let mut b=make_stream(0,false);let p=new_stream(&mut b);let active=b.word(p+0x60).unwrap();b.set(p+0x44,active);b.write_byte(p+4,0).unwrap();b.write_byte(p+5,1).unwrap();
    assert_eq!(stream::stop(&mut b,p),Err(stream::Error::Boundary("replay worker wait8A8C50 is not connected")));assert_eq!(b.memory.read_byte(p+4).unwrap(),0);assert_eq!(b.memory.read_byte(p+5).unwrap(),0);
    b.write_byte(p+4,1).unwrap();b.set(p+0x64,0x3000ad00);b.set(0x3000ad00,0x3000ad40);b.set(0x3000ad5c,0x12345678);
    assert_eq!(stream::stop(&mut b,p),Err(stream::Error::Boundary("replay implementation stop is not connected")));assert_eq!(b.word(p+0x44).unwrap(),active);
    b.set(p+0x64,0);stream::scalar_delete(&mut b,p,1).unwrap();assert!(b.locks.is_empty());
}
#[test]
fn audio_replay_stream_detects_invalid_state_cycles_and_releases_partial_transition_vectors(){
    let mut b=make_stream(0,false);let p=new_stream(&mut b);let current=b.word(p+0x44).unwrap();let parent=b.word(current+16).unwrap();let target=b.word(p+0x60).unwrap();b.set(current+16,current);
    assert_eq!(stream::transition(&mut b,p+0x40,target),Err(stream::Error::InvalidHierarchy));let temporary=b.memory.allocations.last().unwrap().1;assert!(b.word(temporary).is_err());
    assert_eq!(stream::dispatch_event(&mut b,p+0x40,255),Err(stream::Error::InvalidHierarchy));b.set(current+16,parent);stream::scalar_delete(&mut b,p,1).unwrap();assert!(b.locks.is_empty());
}

#[path="audio_replay_stream_running_tests.rs"]
mod running_tests;
