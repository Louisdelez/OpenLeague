use super::*;
use crate::audio_replay_manager_control as manager_control;
const EXTRA:u32=0x3000a920;

fn new_manager(b:&mut Backend,count:u32)->u32{
    let object=b.allocate(48).unwrap();construct(b,object).unwrap();
    for i in 0..count as usize{
        let id=[0,1,42,0x80000000,0xffffffff,7][i];
        let value=[0u64,0,1,1,u64::MAX,0x8000000000000000][i];
        b.incoming(id,value as u32,(value>>32) as u32);
        insert(b,object,INCOMING,SCRATCH).unwrap();
    }
    object
}
fn ownership_state(b:&mut Backend,v:&Value,label:&str){
    state(b,v,label);
    for row in v["pairs"].as_array().unwrap(){let p=n(&row[0]);assert_eq!(b.word(p).unwrap(),n(&row[1]),"{label}");assert_eq!(b.word(p+4).unwrap(),n(&row[2]),"{label}");}
}
fn load()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_stream_ownership_contract.json")).unwrap()}

#[test]
fn audio_replay_manager_control_matches40_complete_native_ownership_lifetimes(){
    let proof=load();let cases=proof["lifetimes"].as_array().unwrap();assert_eq!(cases.len(),40);
    for c in cases{
        let mut b=make(n(&c["fill"]) as u8);b.custom=c["custom"].as_bool().unwrap();
        for p in [HELD,INCOMING,EXTRA]{b.set(p,0);b.set(p+4,0);}
        let object=if c["count"].is_null(){0}else{new_manager(&mut b,n(&c["count"]))};
        let occupied=c["occupied"].as_bool().unwrap();let old=if occupied{new_manager(&mut b,3)}else{0};
        assert_eq!(object,n(&c["object"]));assert_eq!(old,n(&c["old"]));
        // Packet construction uses the same scratch pair above, which has been consumed.
        // These are fresh owning-pair slots, distinct from the native packet temporary.
        b.set(INCOMING,0);b.set(INCOMING+4,0);
        let weak_owner=c["weak_owner"].as_bool().unwrap();let mut ctrl=0;
        for step in c["steps"].as_array().unwrap(){
            let op=step["op"].as_str().unwrap();
            match op{
                "create"=>{},
                "factory"=>{manager_control::replace_pair(&mut b,INCOMING,object).unwrap();ctrl=b.word(INCOMING+4).unwrap();assert_eq!(ctrl,n(&c["control"]));if weak_owner{b.set(ctrl+8,2);}},
                "old_factory"=>{if occupied{manager_control::replace_pair(&mut b,HELD,old).unwrap();}},
                "acquire"=>pair::copy(&mut b,EXTRA,INCOMING).unwrap(),
                "move"=>{assert_eq!(pair::move_assign(&mut b,HELD,INCOMING).unwrap(),HELD);},
                "release_empty"=>pair::destroy(&mut b,INCOMING).unwrap(),
                "release_copy"=>pair::destroy(&mut b,EXTRA).unwrap(),
                "release_owner"=>pair::destroy(&mut b,HELD).unwrap(),
                "release_weak"=>{if weak_owner{assert_eq!(b.count(ctrl+8,false).unwrap(),1);control::release(&mut b,ctrl).unwrap();}},
                _=>panic!("unknown ownership operation"),
            }
            ownership_state(&mut b,&step["state"],op);
        }
        assert!(b.locks.is_empty());assert!(b.held.is_empty());assert!(b.counts.is_empty());assert!(b.word(ctrl).is_err());
        if object!=0{assert!(b.word(object).is_err());}if old!=0{assert!(b.word(old).is_err());}
    }
}

#[test]
fn audio_replay_manager_direct_delete_ignores_argument_and_matches32_native_lifetimes(){
    let proof=load();let cases=proof["deletions"].as_array().unwrap();assert_eq!(cases.len(),32);
    for c in cases{
        let mut b=make(n(&c["fill"]) as u8);b.custom=c["custom"].as_bool().unwrap();
        for p in [HELD,INCOMING,EXTRA]{b.set(p,0);b.set(p+4,0);}
        let object=new_manager(&mut b,n(&c["count"]));assert_eq!(object,n(&c["object"]));
        b.set(INCOMING,0);b.set(INCOMING+4,0);ownership_state(&mut b,&c["before"],"before delete");
        assert_eq!(manager_control::delete_manager(&mut b,object,n(&c["argument"])).unwrap(),n(&c["result"]));ownership_state(&mut b,&c["after"],"after delete");
        assert!(b.locks.is_empty());assert!(b.held.is_empty());assert!(b.counts.is_empty());assert!(b.word(object).is_err());
    }
}
