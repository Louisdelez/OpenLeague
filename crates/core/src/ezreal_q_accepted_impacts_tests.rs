use super::*;
use crate::{Action, Navigation, ServerPacket, Snapshot, damage, wire};

fn game()->(Simulation,u32,u32) {
    let mut bytes=Vec::new();
    for _ in 0..3200 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":40}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    s.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};
    s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};
    s.command(a,Action::Learn{slot:0}).unwrap();(s,a,b)
}
fn cast(s:&mut Simulation,a:u32) {s.command(a,Action::CastAt{slot:0,point:Point{x:1800.,z:300.}}).unwrap();}
fn until(s:&mut Simulation,tick:u64) {while s.tick<tick {s.tick+=1;s.advance_ezreal_q();}}
fn view(s:&Simulation,viewer:u32)->Vec<Event> {
    let snap=s.snapshot_for(viewer).unwrap();
    decode_view(snap.ezreal_q_accepted_impacts.as_ref(),snap.tick).unwrap().unwrap()
}
fn prepared(owner:u32,target:u32,tick:u64,audience:[bool;2])->Prepared {
    Prepared {session:420,owner,source_team:0,target,tick,
        projectile_center:Point{x:225.,z:300.},target_center:Point{x:250.,z:300.},audience}
}
fn state()->State {
    let mut s=State {session:Some(420),..State::default()};
    s.register_owner(420,1);s
}
fn projected(s:&State,team:u8,tick:u64)->Value {s.project(420,team,tick,|_,_,_,_|true)}
fn rows(value:Value,tick:u64)->Vec<Event> {decode_view(Some(&value),tick).unwrap().unwrap()}

#[test]
fn accepted_hit_records_once_after_damage_and_preserves_frozen_contact_points() {
    let(mut s,a,b)=game();let hp=s.players[&b].health;cast(&mut s,a);let cd=s.players[&a].cooldowns[0];
    until(&mut s,9);assert!(s.players[&b].health<hp);assert_eq!(s.players[&a].cooldowns[0],cd-30);
    let first=view(&s,a);assert_eq!(first.len(),1);assert_eq!((first[0].owner,first[0].target,first[0].order,first[0].tick),(a,b,1,9));
    assert_eq!(first[0].target_center,Point{x:250.,z:300.});
    s.advance_ezreal_q();assert_eq!(view(&s,a),first);
    s.players.get_mut(&b).unwrap().position=Point{x:2100.,z:1100.};until(&mut s,20);
    assert_eq!(view(&s,a),first);assert!(s.snapshot().ezreal_q_accepted_impacts.is_none());
}

#[test]
fn fully_shielded_ok_emits_one_fact_and_keeps_the_original_four_deadline_refund() {
    let(mut s,a,b)=game();s.grant_shield(b,"accepted Q",10000.,100).unwrap();let hp=s.players[&b].health;
    cast(&mut s,a);let p=s.players.get_mut(&a).unwrap();p.cooldowns=[180,50,20,0];
    p.cooldown_totals=[Some(180),Some(50),Some(20),None];let totals=p.cooldown_totals;let summoners=p.summoners.ready_at;
    until(&mut s,9);assert_eq!(s.players[&b].health,hp);assert!(s.players[&b].shields[0].remaining<10000.);
    assert_eq!(s.players[&a].cooldowns,[150,20,9,0]);assert_eq!(s.players[&a].cooldown_totals,totals);
    assert_eq!(s.players[&a].summoners.ready_at,summoners);assert_eq!(view(&s,a).len(),1);
    until(&mut s,25);assert_eq!(view(&s,a).len(),1);assert_eq!(s.players[&a].cooldowns,[150,20,9,0]);
}

#[test]
fn lethal_champion_ok_keeps_a_frozen_fact_without_resolving_a_live_target() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;let gold=s.players[&a].gold;
    cast(&mut s,a);until(&mut s,9);assert_eq!(s.players[&b].health,0.);assert_eq!(s.players[&a].score.kills,1);
    assert!(s.players[&a].gold>gold);let fact=view(&s,a);assert_eq!(fact.len(),1);assert_eq!(fact[0].target,b);
    // Projection does not consult current target existence/health/position.
    s.players.remove(&b);assert_eq!(view(&s,a),fact);
    until(&mut s,20);assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.kill_rewards.events.len(),1);
}

#[test]
fn rejected_damage_and_non_q_damage_never_publish_or_refund_a_q_hit() {
    let(mut s,a,b)=game();s.apply_damage(Some(a),b,1.,damage::DamageKind::True).unwrap();assert!(view(&s,a).is_empty());
    cast(&mut s,a);let cd=s.players[&a].cooldowns;until(&mut s,8);
    s.definitions.get_mut("garen").unwrap().armor=f32::NAN;let hp=s.players[&b].health;
    until(&mut s,9);assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
    assert_eq!(s.ezreal_q_faults().len(),1);assert!(view(&s,a).is_empty());
    s.definitions.get_mut("garen").unwrap().armor=20.;until(&mut s,30);assert!(view(&s,a).is_empty());
}

#[test]
fn expiry_departure_and_terminal_context_changes_cannot_be_inferred_as_hits() {
    for cause in 0..5 {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:2000.,z:300.};
        cast(&mut s,a);let cd=s.players[&a].cooldowns;until(&mut s,8);
        match cause {0=>{},1=>{s.remove_player(b).unwrap();},2=>{s.remove_player(a).unwrap();},
            3=>{s.session+=1;},_=>{s.winner=Some(0);s.advance();}}
        until(&mut s,30);assert!(s.snapshot().ezreal_q_accepted_impacts.is_none());
        if s.players.contains_key(&a) {assert!(view(&s,a).is_empty());assert_eq!(s.players[&a].cooldowns,cd);}
        assert!(s.ezreal_q_accepted_impact_projection(0)["events"].as_array().unwrap().is_empty());
    }
}

#[test]
fn accepted_hidden_hit_has_no_late_replay_no_private_order_and_no_gameplay_change() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    s.players.get_mut(&b).unwrap().position=Point{x:600.,z:300.};s.grant_shield(b,"hidden Q",10000.,200).unwrap();
    cast(&mut s,a);let cd=s.players[&a].cooldowns[0];until(&mut s,8);
    s.players.get_mut(&a).unwrap().position=Point{x:3500.,z:1800.};until(&mut s,20);
    assert!(s.players[&b].shields[0].remaining<10000.);assert_eq!(s.players[&a].cooldowns[0],cd-30);
    assert!(view(&s,a).is_empty());assert!(view(&s,b).is_empty());
    s.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};assert!(view(&s,a).is_empty());assert!(view(&s,b).is_empty());
    s.players.get_mut(&a).unwrap().cooldowns[0]=0;s.players.get_mut(&a).unwrap().mana=10000.;
    cast(&mut s,a);until(&mut s,40);let visible=view(&s,a);assert_eq!(visible.len(),1);assert_eq!(visible[0].order,1);
}

#[test]
fn private_team_rings_orders_and_eviction_are_independent_under_hidden_floods() {
    let mut s=state();s.record(prepared(1,2,5,[true,false]));let before=projected(&s,0,5);
    for _ in 0..80 {s.record(prepared(1,2,5,[false,true]));}
    assert_eq!(projected(&s,0,5),before);assert_eq!(rows(projected(&s,1,5),5).len(),MAX_EVENTS);
    s.record(prepared(1,2,5,[true,true]));let own=rows(projected(&s,0,5),5);
    assert_eq!(own.iter().map(|e|e.order).collect::<Vec<_>>(),vec![1,2]);
    let enemy=rows(projected(&s,1,5),5);assert_eq!(enemy.last().unwrap().order,81);assert_eq!(enemy.len(),MAX_EVENTS);
}

#[test]
fn one_view_order_overflow_disables_only_that_view_without_recycling_identity() {
    let mut s=state();s.owners.get_mut(&1).unwrap().orders[0]=u64::MAX;
    s.record(prepared(1,2,5,[true,true]));assert!(rows(projected(&s,0,5),5).is_empty());
    assert_eq!(rows(projected(&s,1,5),5)[0].order,1);
    s.record(prepared(1,2,6,[true,true]));assert!(rows(projected(&s,0,6),6).is_empty());
    assert_eq!(rows(projected(&s,1,6),6).last().unwrap().order,2);
    assert_eq!(projected(&s,0,6),json!({"version":1,"events":[]}));
}

#[test]
fn audience_is_frozen_but_current_owner_and_both_frozen_points_are_required() {
    let mut s=state();s.record(prepared(1,2,5,[true,false]));
    assert!(rows(s.project(420,0,5,|_,_,_,_|false),5).is_empty());
    assert!(rows(projected(&s,1,5),5).is_empty());
    let visible=s.project(420,0,5,|owner,team,projectile,target|owner==1 && team==0
        && projectile==(Point{x:225.,z:300.}) && target==(Point{x:250.,z:300.}));
    assert_eq!(rows(visible,5).len(),1);
}

#[test]
fn ttl_clock_session_invalid_team_and_admission_boundaries_fail_closed_locally() {
    let mut s=state();s.record(prepared(1,2,5,[true,true]));
    assert_eq!(rows(projected(&s,0,64),64).len(),1);assert!(rows(projected(&s,0,65),65).is_empty());
    assert!(rows(s.project(421,0,5,|_,_,_,_|true),5).is_empty());
    assert!(rows(projected(&s,2,5),5).is_empty());s.prune(420,10);
    assert!(rows(projected(&s,0,9),9).is_empty());s.record(prepared(1,2,9,[true,true]));
    assert_eq!(rows(projected(&s,0,10),10).len(),1);
    s.remove_owner(1);s.register_owner(420,1);s.record(prepared(1,2,10,[true,true]));
    assert!(rows(projected(&s,0,10),10).is_empty());assert!(!s.owners.contains_key(&1));
    for owner in 2..=9 {s.register_owner(420,owner);}assert_eq!(s.owners.len(),MAX_OWNERS);
    let mut wrong=prepared(2,3,10,[true,true]);wrong.session=421;s.record(wrong);
    assert!(rows(projected(&s,0,10),10).is_empty());
}

#[test]
fn departure_removes_target_facts_and_same_session_clear_keeps_other_orders() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,9);assert_eq!(view(&s,a)[0].order,1);
    s.clear_ezreal_q();assert!(view(&s,a).is_empty());
    s.players.get_mut(&a).unwrap().cooldowns[0]=0;cast(&mut s,a);until(&mut s,18);
    assert_eq!(view(&s,a)[0].order,2);s.remove_player(b).unwrap();assert!(view(&s,a).is_empty());
    s.session+=1;s.tick+=1;s.advance_ezreal_q();assert!(view(&s,a).is_empty());
    let target=s.join("garen").unwrap();s.players.get_mut(&target).unwrap().position=Point{x:250.,z:300.};
    s.players.get_mut(&a).unwrap().cooldowns[0]=0;s.players.get_mut(&a).unwrap().mana=10000.;cast(&mut s,a);until(&mut s,28);
    assert_eq!(view(&s,a)[0].order,1);s.winner=Some(0);s.advance();assert!(view(&s,a).is_empty());
}

#[test]
fn projected_payload_and_decoder_enforce_whole_fact_limits_and_byte_budget() {
    let mut s=state();for _ in 0..100 {let mut p=prepared(1,u32::MAX,5,[true,true]);
        p.projectile_center=Point{x:f32::MAX,z:-f32::MAX};p.target_center=p.projectile_center;s.record(p);}
    let value=projected(&s,0,5);assert!(serde_json::to_vec(&value).unwrap().len()<=MAX_BYTES);
    let events=rows(value,5);assert!(!events.is_empty());assert!(events.len()<=MAX_EVENTS);
    let too_many=envelope(&vec![Event {owner:1,target:2,order:1,tick:5,
        projectile_center:Point{x:1.,z:1.},target_center:Point{x:1.,z:1.}};MAX_EVENTS+1]);
    assert_eq!(decode_view(Some(&too_many),5),Err(DecodeError::Budget));
    let big=json!({"version":1,"events":[],"padding":"x".repeat(MAX_BYTES)});
    assert_eq!(decode_view(Some(&big),5),Err(DecodeError::Budget));
}

#[test]
fn strict_decoder_rejects_future_expired_malformed_version_and_ambiguous_ids() {
    let valid=envelope(&[Event {owner:1,target:2,order:1,tick:5,
        projectile_center:Point{x:1.,z:2.},target_center:Point{x:3.,z:4.}}]);
    assert_eq!(decode_view(None,5),Ok(None));assert_eq!(decode_view(Some(&envelope(&[])),5),Ok(Some(vec![])));
    for (field,value,error) in [("tick",json!(6),DecodeError::Time),("tick",json!(0),DecodeError::Time),
        ("owner",json!(0),DecodeError::Event),("owner",json!(u64::MAX),DecodeError::Event),
        ("target",json!(1),DecodeError::Event),("order",json!(0),DecodeError::Event),
        ("projectile_center",json!({"x":1e40,"z":2.}),DecodeError::Event),
        ("target_center",json!({"x":3.,"z":4.,"extra":0}),DecodeError::Event)] {
        let mut v=valid.clone();v["events"][0][field]=value;
        let clock=if field=="tick" && v["events"][0][field]==json!(0) {60}else{5};
        assert_eq!(decode_view(Some(&v),clock),Err(error));
    }
    let mut v=valid.clone();v["version"]=json!(2);assert_eq!(decode_view(Some(&v),5),Err(DecodeError::Version));
    v=valid.clone();v["extra"]=json!(0);assert_eq!(decode_view(Some(&v),5),Err(DecodeError::Envelope));
    v=valid;v["events"][0]["extra"]=json!(0);assert_eq!(decode_view(Some(&v),5),Err(DecodeError::Event));
}

#[test]
fn decoder_rejects_duplicate_orders_regressive_ticks_and_seventh_owner() {
    let event=Event {owner:1,target:20,order:1,tick:5,projectile_center:Point{x:1.,z:2.},target_center:Point{x:3.,z:4.}};
    let mut second=event;assert_eq!(decode_view(Some(&envelope(&[event,second])),5),Err(DecodeError::Order));
    second.order=2;second.tick=4;assert_eq!(decode_view(Some(&envelope(&[event,second])),5),Err(DecodeError::Order));
    let events:Vec<_>=(1..=7).map(|owner|Event{owner,..event}).collect();
    assert_eq!(decode_view(Some(&envelope(&events)),5),Err(DecodeError::Owners));
}

#[test]
fn optional_snapshot_roundtrip_and_fragmentation_preserve_separate_trundle_channel() {
    let(mut s,a,_)=game();cast(&mut s,a);until(&mut s,9);let snapshot=s.snapshot_for(a).unwrap();
    let trundle=snapshot.accepted_casts.clone();let mut assembler=wire::StateAssembler::default();let mut decoded=None;
    for d in wire::state_datagrams(&snapshot).unwrap().iter().rev() {assert!(d.len()<=1200);
        if let Some(bytes)=assembler.push(d,Some(s.session)){decoded=Some(bytes);}}
    let ServerPacket::State(round):ServerPacket=serde_json::from_slice(&decoded.unwrap()).unwrap() else{panic!("state");};
    assert_eq!(round.ezreal_q_accepted_impacts,snapshot.ezreal_q_accepted_impacts);assert_eq!(round.accepted_casts,trundle);
    let mut legacy=serde_json::to_value(&snapshot).unwrap();legacy.as_object_mut().unwrap().remove("ezreal_q_accepted_impacts");
    let legacy:Snapshot=serde_json::from_value(legacy).unwrap();assert!(legacy.ezreal_q_accepted_impacts.is_none());
    assert_eq!(legacy.accepted_casts,trundle);
}

#[test]
fn invalid_optional_facts_do_not_mutate_orders_and_cannot_admit_an_unknown_owner() {
    let mut s=state();
    let mut variants=vec![prepared(1,2,5,[false,false]),prepared(7,2,5,[true,true]),
        prepared(1,1,5,[true,true]),prepared(0,2,5,[true,true])];
    let mut bad=prepared(1,2,5,[true,true]);bad.projectile_center.x=f32::NAN;variants.push(bad);
    bad=prepared(1,2,5,[true,true]);bad.source_team=2;variants.push(bad);
    for bad in variants {s.record(bad);}
    assert_eq!(s.owners.len(),1);assert_eq!(s.owners[&1].orders,[0,0]);
    assert!(rows(projected(&s,0,5),5).is_empty());s.record(prepared(1,2,5,[true,true]));
    assert_eq!(rows(projected(&s,0,5),5)[0].order,1);
}
