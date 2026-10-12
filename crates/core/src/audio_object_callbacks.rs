//! Original704A00/704A40 callback dispatch, distinct from deferred pool cleanup.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind { Bound, Unbound }
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct InterfaceCall { pub slot:u32, pub argument:Option<u32> }
/// Cookie existence and linked target are explicit caller state. Returned interface
/// actions need a real consumer; this layer does not unregister an audio source.
pub fn deliver(kind:Kind,event_type:u32,cookie_present:bool,linked_present:bool,
    retired:&mut u8)->Vec<InterfaceCall> {
    if !cookie_present {return vec![];}
    match (kind,event_type) {
        (Kind::Bound,1)=>vec![InterfaceCall {slot:4,argument:None},InterfaceCall {slot:0,argument:Some(1)}],
        (Kind::Bound,4)=>vec![InterfaceCall {slot:8,argument:None}],
        (Kind::Unbound,1)=>{
            *retired=1;
            if linked_present {vec![InterfaceCall {slot:4,argument:None}]} else {vec![]}
        },
        (Kind::Unbound,4) if linked_present=>vec![InterfaceCall {slot:8,argument:None}],
        _=>vec![],
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_80_original_bound_and_unbound_callback_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_callbacks_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),80);
        for case in cases {
            let kind=if case["kind"]=="bound" {Kind::Bound} else {Kind::Unbound};
            let mut retired=case["initial_retired"].as_u64().unwrap() as u8;
            let calls=deliver(kind,case["event_type"].as_u64().unwrap() as u32,case["cookie_present"].as_bool().unwrap(),case["linked_object_present"].as_bool().unwrap(),&mut retired);
            let actual:Vec<_>=calls.iter().map(|c|serde_json::json!({"slot":c.slot,"argument":c.argument})).collect();
            assert_eq!(actual,*case["calls"].as_array().unwrap());assert_eq!(retired,case["final_retired"].as_u64().unwrap() as u8);
        }
    }
    #[test]
    fn exact_types_and_repeated_end_do_not_invent_immediate_unregister_or_deduplicate() {
        let mut retired=0;
        assert!(deliver(Kind::Unbound,5,true,true,&mut retired).is_empty());assert_eq!(retired,0);
        assert_eq!(deliver(Kind::Unbound,1,true,false,&mut retired),vec![]);assert_eq!(retired,1);
        for _ in 0..2 {assert_eq!(deliver(Kind::Unbound,1,true,true,&mut retired),vec![InterfaceCall {slot:4,argument:None}]);}
        assert_eq!(retired,1);
        assert_eq!(deliver(Kind::Bound,1,true,false,&mut retired),vec![InterfaceCall {slot:4,argument:None},InterfaceCall {slot:0,argument:Some(1)}]);
    }
}
