use super::*;
fn state()->State {let mut s=State{session:Some(u64::MAX-7),..State::default()};s.register(u64::MAX-7,1);s}
fn fact(ordinal:u64,phase:Phase,tick:u64,audience:[bool;2])->Prepared {
    Prepared{session:u64::MAX-7,owner:1,source_team:0,ordinal,tick,phase,
        position:Point{x:if phase==Phase::Departure{200.}else{675.},z:7300.},audience}
}
fn events(s:&State,team:u8,tick:u64)->Vec<Event> {decode_view(Some(&s.project(u64::MAX-7,team,tick,|_,_,_|true)),tick).unwrap().unwrap()}
#[test]
fn independent_phase_admissions_never_serialize_the_other_point_or_private_ordinal() {
    let mut s=state();s.record(Some(fact((1<<53)+7,Phase::Departure,8,[true,false])));
    s.record(Some(fact((1<<53)+7,Phase::Arrival,8,[false,true])));
    for (team,phase,x) in [(0,Phase::Departure,200.),(1,Phase::Arrival,675.)] {
        let out=events(&s,team,8);assert_eq!(out.len(),1);assert_eq!((out[0].phase,out[0].position.x,out[0].order),(phase,x,1));
        let v=s.project(u64::MAX-7,team,8,|_,_,_|true);let row=&v["events"][0];
        assert_eq!(row.as_object().unwrap().len(),5);
        for name in ["ordinal","landing","origin","target","damage","other_point"]{assert!(row.get(name).is_none());}
    }
}
#[test]
fn hidden_and_duplicate_phases_never_advance_other_view_or_reveal_later() {
    let mut s=state();s.record(Some(fact(1,Phase::Departure,8,[true,false])));
    for ordinal in 2..100 {s.record(Some(fact(ordinal,Phase::Departure,8,[false,true])));}
    assert_eq!(events(&s,0,8).len(),1);assert_eq!(events(&s,0,8)[0].order,1);
    assert_eq!(events(&s,1,8).len(),MAX_EVENTS);
    s.record(Some(fact(99,Phase::Departure,8,[true,true]))); // already privately admitted
    s.record(Some(fact(98,Phase::Arrival,8,[true,true]))); // stale ordinal
    assert_eq!(events(&s,0,8).len(),1);
    s.record(Some(fact(99,Phase::Arrival,8,[true,false])));
    assert_eq!(events(&s,0,8).iter().map(|e|e.order).collect::<Vec<_>>(),vec![1,2]);
}
#[test]
fn current_permission_is_read_only_and_cannot_create_an_unadmitted_fact() {
    let mut s=state();s.record(Some(fact(1,Phase::Departure,8,[true,false])));
    let before=format!("{s:?}");
    assert!(decode_view(Some(&s.project(u64::MAX-7,0,8,|_,_,_|false)),8).unwrap().unwrap().is_empty());
    assert_eq!(events(&s,0,8).len(),1);assert!(events(&s,1,8).is_empty());
    assert_eq!(format!("{s:?}"),before);
}
#[test]
fn full_u64_orders_ticks_overflow_per_view_and_freshness_do_not_wrap() {
    let mut s=state();s.owners.get_mut(&1).unwrap().orders=[u64::MAX-1,0];
    s.record(Some(fact(1,Phase::Departure,u64::MAX-2,[true,true])));
    s.record(Some(fact(1,Phase::Arrival,u64::MAX-2,[true,true])));
    let left=events(&s,0,u64::MAX);let right=events(&s,1,u64::MAX);
    assert_eq!(left.len(),1);assert_eq!(left[0].order,u64::MAX);assert_eq!(right.len(),2);
    assert!(left[0].fresh_at(u64::MAX));assert!(!left[0].fresh_at(u64::MAX-3));
    let raw=s.project(u64::MAX-7,0,u64::MAX,|_,_,_|true);
    assert_eq!(decode_view(Some(&serde_json::from_slice::<Value>(&serde_json::to_vec(&raw).unwrap()).unwrap()),u64::MAX).unwrap().unwrap(),left);
}
#[test]
fn authorization_retention_is_distinct_from_three_tick_birth_freshness() {
    let mut s=state();s.record(Some(fact(1,Phase::Departure,8,[true,false])));
    assert!(events(&s,0,11)[0].fresh_at(11));assert!(!events(&s,0,12)[0].fresh_at(12));
    assert_eq!(events(&s,0,187).len(),1);assert!(events(&s,0,188).is_empty());
    s.prune(u64::MAX-7,188);assert!(s.rings[0].is_empty());
    s.record(Some(fact(2,Phase::Arrival,9,[true,true])));assert!(s.rings[0].is_empty());
}
#[test]
fn owner_departure_reuse_capacity_and_wrong_session_fail_closed() {
    let mut s=state();s.record(Some(fact(1,Phase::Departure,8,[true,true])));s.remove(1);
    s.register(u64::MAX-7,1);s.record(Some(fact(2,Phase::Arrival,9,[true,true])));assert!(events(&s,0,9).is_empty());
    for owner in 2..=8{s.register(u64::MAX-7,owner);}assert_eq!(s.owners.len(),MAX_OWNERS);assert!(!s.owners.contains_key(&8));
    assert!(decode_view(Some(&s.project(1,0,9,|_,_,_|true)),9).unwrap().unwrap().is_empty());
    assert!(decode_view(None,9).unwrap().is_none());
}
#[test]
fn strict_release_decoder_rejects_bad_shapes_orders_time_and_numeric_fields() {
    let mut s=state();s.record(Some(fact(1,Phase::Departure,8,[true,true])));let raw=s.project(u64::MAX-7,0,8,|_,_,_|true);
    for case in 0..10 {
        let mut v=raw.clone();match case {
            0=>v["events"][0]["order"]=json!(1.5),1=>v["events"][0]["owner"]=json!(0),
            2=>v["events"][0]["tick"]=json!(9),3=>v["events"][0]["phase"]=json!("cast"),
            4=>v["events"][0]["position"]["x"]=json!(1e100),5=>v["events"][0]["ordinal"]=json!(7),
            6=>{let row=v["events"][0].clone();v["events"].as_array_mut().unwrap().push(row);},
            7=>v["policy"]=json!("native"),8=>v["events"][0]["position"]["y"]=json!(0),
            _=>v["extra"]=json!(true)}
        assert!(decode_view(Some(&v),8).is_err(),"case{case}");
    }
    assert!(matches!(decode_view(Some(&raw),188),Err(DecodeError::Time)));
    assert!(decode_view(Some(&json!({"policy":POLICY,"events":[],"padding":"x".repeat(MAX_BYTES)})),8).is_err());
    let rows:Vec<_>=(1..=7).map(|owner|json!({"owner":owner,"order":1,"tick":8,"phase":"arrival","position":{"x":1,"z":2}})).collect();
    assert!(matches!(decode_view(Some(&json!({"policy":POLICY,"events":rows})),8),Err(DecodeError::Owners)));
    let rows=vec![raw["events"][0].clone();MAX_EVENTS+1];assert!(matches!(decode_view(Some(&json!({"policy":POLICY,"events":rows})),8),Err(DecodeError::Budget)));
}
