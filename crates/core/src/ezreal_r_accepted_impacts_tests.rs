use super::*;
use crate::{Action, Navigation, ServerPacket, Snapshot, damage, wire, session_transport, session_wire};

fn game() -> (Simulation,u32,u32) {
    let mut bytes=Vec::new();
    for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for(id,x,team)in[(a,200.,0),(b,250.,1)] {let p=s.players.get_mut(&id).unwrap();
        p.team=team;p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=6;}
    s.players.get_mut(&a).unwrap().ranks=[0,0,0,1];(s,a,b)
}
fn cast(s:&mut Simulation,a:u32) {s.command(a,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).unwrap();}
fn until(s:&mut Simulation,tick:u64) {while s.tick<tick {s.tick+=1;s.prune_ezreal_passive();s.advance_ezreal_r();}}
fn view(s:&Simulation,viewer:u32)->Vec<Event> {
    let snap=s.snapshot_for_atomic(viewer).unwrap();
    decode_view(snap.ezreal_r_accepted_impacts.as_ref(),snap.tick).unwrap().unwrap()
}
fn prepared(owner:u32,target:u32,tick:u64,audience:[bool;2])->Prepared {
    Prepared {session:420,owner,source_team:0,target,tick,
        projectile_center:Point{x:225.,z:300.},target_center:Point{x:250.,z:300.},audience}
}
fn state()->State {let mut s=State{session:Some(420),..State::default()};s.register_owner(420,1);s}
fn projected(s:&State,team:u8,tick:u64)->Value {s.project(420,team,tick,|_,_,_,_|true)}
fn rows(value:Value,tick:u64)->Vec<Event> {decode_view(Some(&value),tick).unwrap().unwrap()}

#[test]
fn piercing_r_publishes_each_accepted_contact_once_in_geometry_order_without_q_refund() {
    let(mut s,a,b)=game();let c=s.join("annie").unwrap();
    {let p=s.players.get_mut(&c).unwrap();p.team=1;p.position=Point{x:400.,z:300.};p.health=10000.;p.max_health=10000.;}
    s.definitions.get_mut("garen").unwrap().magic_resist=0.;s.definitions.get_mut("annie").unwrap().magic_resist=0.;
    s.players.get_mut(&b).unwrap().level=1;s.players.get_mut(&c).unwrap().level=1;
    cast(&mut s,a);let cooldowns=s.players[&a].cooldowns;until(&mut s,30);
    assert!(view(&s,a).is_empty());assert!(s.snapshot().ezreal_r_accepted_impacts.is_none());
    until(&mut s,31);let first=view(&s,a);assert_eq!(first.len(),2);
    assert_eq!(first.iter().map(|e|(e.target,e.order,e.tick)).collect::<Vec<_>>(),vec![(b,1,31),(c,2,31)]);
    assert_eq!(first[0].target_center,Point{x:250.,z:300.});assert_eq!(first[1].target_center,Point{x:400.,z:300.});
    assert!(first[0].projectile_center.x<=first[1].projectile_center.x);
    assert!((10000.-s.players[&b].health-350.).abs()<0.01);
    assert!((10000.-s.players[&c].health-315.).abs()<0.01);
    assert_eq!(s.players[&a].cooldowns,cooldowns);s.advance_ezreal_r();assert_eq!(view(&s,a),first);
    s.players.get_mut(&b).unwrap().position=Point{x:3300.,z:2100.};until(&mut s,40);assert_eq!(view(&s,a),first);
    assert!(s.snapshot_for(a).unwrap().ezreal_r_accepted_impacts.is_none());
    assert!(s.snapshot_for(a).unwrap().ezreal_q_accepted_impacts.unwrap()["events"].as_array().unwrap().is_empty());
}

#[test]
fn fully_shielded_lethal_and_zero_damage_ok_are_facts_but_not_native_callback_claims() {
    for lethal in [false,true] {
        let(mut s,a,b)=game();
        if lethal {s.players.get_mut(&b).unwrap().health=1.;}else{s.grant_shield(b,"R accepted",10000.,100).unwrap();}
        let hp=s.players[&b].health;cast(&mut s,a);until(&mut s,31);let event=view(&s,a);assert_eq!(event.len(),1);
        if lethal {assert_eq!(s.players[&b].health,0.);s.players.remove(&b);assert_eq!(view(&s,a),event);}
        else {assert_eq!(s.players[&b].health,hp);assert!(s.players[&b].shields[0].remaining<10000.);}
    }
    // Exercise the exact Ok publication contract with a zero common-damage result.
    // The configured R ranks themselves remain positive; no artificial R rank is installed.
    let(mut s,a,b)=game();let hp=s.players[&b].health;
    let fact=s.prepare_ezreal_r_accepted_impact(a,0,b,Point{x:225.,z:300.},Point{x:250.,z:300.});
    let outcome=s.apply_damage(Some(a),b,0.,damage::DamageKind::Magical).unwrap();
    assert_eq!(outcome.health_removed,0.);s.record_ezreal_r_accepted_impact(fact);
    assert_eq!(s.players[&b].health,hp);assert_eq!(view(&s,a).len(),1);
}

#[test]
fn rejected_contact_and_non_r_damage_do_not_emit_or_replay_after_defense_repair() {
    let(mut s,a,b)=game();s.apply_damage(Some(a),b,1.,damage::DamageKind::True).unwrap();assert!(view(&s,a).is_empty());
    cast(&mut s,a);until(&mut s,30);let hp=s.players[&b].health;let cds=s.players[&a].cooldowns;
    s.definitions.get_mut("garen").unwrap().magic_resist=f32::NAN;until(&mut s,31);
    assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cds);assert!(view(&s,a).is_empty());
    assert!(s.ezreal_r_faults().iter().any(|e|e.stage=="impact"));
    s.definitions.get_mut("garen").unwrap().magic_resist=0.;until(&mut s,45);assert!(view(&s,a).is_empty());
    assert_eq!(s.players[&b].health,hp);
}

#[test]
fn hidden_accepted_contact_has_no_late_fact_or_private_order_and_does_not_change_damage() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    s.players.get_mut(&b).unwrap().position=Point{x:600.,z:300.};s.grant_shield(b,"hidden R",10000.,200).unwrap();
    cast(&mut s,a);until(&mut s,30);s.players.get_mut(&a).unwrap().position=Point{x:3500.,z:3500.};
    until(&mut s,40);assert!(s.players[&b].shields[0].remaining<10000.);
    assert!(view(&s,a).is_empty());assert!(view(&s,b).is_empty());
    s.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};assert!(view(&s,a).is_empty());assert!(view(&s,b).is_empty());
    s.players.get_mut(&a).unwrap().cooldowns[3]=0;cast(&mut s,a);until(&mut s,80);
    assert_eq!(view(&s,a).iter().map(|e|e.order).collect::<Vec<_>>(),vec![1]);
    // Denying journal owner admission cannot change damage, passive, cooldowns or ordinary snapshot.
    let(mut normal,n,_) = game();let(mut silent,m,_) = game();silent.ezreal_r.impacts.remove_owner(m);
    cast(&mut normal,n);cast(&mut silent,m);until(&mut normal,40);until(&mut silent,40);
    assert_eq!(serde_json::to_value(normal.snapshot()).unwrap(),serde_json::to_value(silent.snapshot()).unwrap());
    assert_eq!(normal.ezreal_passive_self_projection(n),silent.ezreal_passive_self_projection(m));
    assert_eq!(view(&normal,n).len(),1);assert!(view(&silent,m).is_empty());
}

#[test]
fn pending_interruptions_and_expiry_are_not_hits_but_released_owner_death_can_hit() {
    for cancel in [true,false] {
        let(mut s,a,b)=game();
        if !cancel {s.players.get_mut(&b).unwrap().position=Point{x:250.,z:1200.};}
        cast(&mut s,a);if cancel {s.players.get_mut(&a).unwrap().position.z+=1.;}
        until(&mut s,331);assert!(view(&s,a).is_empty());
        assert_eq!(s.players[&b].health,10000.);assert_eq!(s.players[&a].cooldowns[3],2400);
    }
    let(mut s,a,_)=game();cast(&mut s,a);until(&mut s,30);s.players.get_mut(&a).unwrap().health=0.;
    until(&mut s,31);assert_eq!(view(&s,a).len(),1);assert!(s.ezreal_passive_self_projection(a).is_none());
}

#[test]
fn departure_same_session_clear_session_change_and_end_retire_without_order_reuse() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,31);assert_eq!(view(&s,a)[0].order,1);
    s.clear_ezreal_r();assert!(view(&s,a).is_empty());s.players.get_mut(&a).unwrap().cooldowns[3]=0;
    cast(&mut s,a);until(&mut s,62);assert_eq!(view(&s,a)[0].order,2);
    s.remove_player(b).unwrap();assert!(view(&s,a).is_empty());
    s.session+=1;s.tick+=1;s.advance_ezreal_r();assert!(view(&s,a).is_empty());
    let target=s.join("garen").unwrap();{let p=s.players.get_mut(&target).unwrap();p.team=1;p.position=Point{x:250.,z:300.};p.health=10000.;}
    s.players.get_mut(&a).unwrap().cooldowns[3]=0;cast(&mut s,a);until(&mut s,94);assert_eq!(view(&s,a)[0].order,1);
    s.winner=Some(0);s.advance();assert!(view(&s,a).is_empty());
}

#[test]
fn optional_olsr_roundtrip_preserves_full_u64_and_legacy_wire_remains_without_r_facts() {
    let(mut s,a,_)=game();s.session=u64::MAX-7;s.clear_ezreal_r();
    let order=(1u64<<53)+3;s.ezreal_r.impacts.owners.get_mut(&a).unwrap().orders=[order,order];
    cast(&mut s,a);until(&mut s,31);let snapshot=s.snapshot_for_atomic(a).unwrap();
    assert_eq!(decode_view(snapshot.ezreal_r_accepted_impacts.as_ref(),snapshot.tick).unwrap().unwrap()[0].order,order+1);
    let context=session_transport::Context{session:s.session,player:a,epoch:u64::MAX-1};
    let mut sender=session_wire::Sender::new(context).unwrap();let packets=sender.encode(&snapshot,u64::MAX-2).unwrap();
    let mut assembler=session_wire::Assembler::new(context).unwrap();let mut decoded=None;
    for packet in packets.iter().rev() {assert!(packet.len()<=1200);if let Some(frame)=assembler.push(packet).unwrap(){decoded=Some(frame.decode().unwrap());}}
    let decoded=decoded.unwrap();assert_eq!(decoded.context,context);assert_eq!(decoded.clock_ordinal,u64::MAX-2);
    assert_eq!(decoded.snapshot.ezreal_r_accepted_impacts,snapshot.ezreal_r_accepted_impacts);
    assert_eq!(decoded.snapshot.ezreal_q_accepted_impacts,snapshot.ezreal_q_accepted_impacts);
    assert_eq!(decoded.snapshot.accepted_casts,snapshot.accepted_casts);
    let old=s.snapshot_for(a).unwrap();assert!(old.ezreal_r_accepted_impacts.is_none());
    let mut old_assembler=wire::StateAssembler::default();let mut old_bytes=None;
    for packet in wire::state_datagrams(&old).unwrap().iter().rev(){if let Some(bytes)=old_assembler.push(packet,Some(s.session)){old_bytes=Some(bytes);}}
    let ServerPacket::State(round):ServerPacket=serde_json::from_slice(&old_bytes.unwrap()).unwrap() else{panic!("state");};
    assert!(round.ezreal_r_accepted_impacts.is_none());
    let mut absent=serde_json::to_value(snapshot).unwrap();absent.as_object_mut().unwrap().remove("ezreal_r_accepted_impacts");
    let absent:Snapshot=serde_json::from_value(absent).unwrap();assert!(absent.ezreal_r_accepted_impacts.is_none());
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
    assert_eq!(rows(projected(&s,0,5+HORIZON-1),5+HORIZON-1).len(),1);assert!(rows(projected(&s,0,5+HORIZON),5+HORIZON).is_empty());
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
        let clock=if field=="tick" && v["events"][0][field]==json!(0) {HORIZON}else{5};
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

#[test]
fn retained_fact_outlives_four_seconds_but_revalidates_current_body_and_points() {
    let (mut s,a,b)=game(); cast(&mut s,a); until(&mut s,31);
    let first=view(&s,a); assert_eq!(first.len(),1); let tick=first[0].tick;
    until(&mut s,tick+120); assert_eq!(view(&s,a),first);
    let mut calls=0;
    let denied=s.ezreal_r.impacts.project(s.session,0,s.tick,|owner,team,projectile,target| {
        calls+=1; assert_eq!((owner,team),(a,0));
        assert_eq!((projectile,target),(first[0].projectile_center,first[0].target_center)); false
    });
    assert_eq!(calls,1); assert!(rows(denied,s.tick).is_empty());
    // No current target lookup: lethal or removed target keeps only frozen data.
    s.players.remove(&b); assert_eq!(view(&s,a),first);
    let owner=s.players.remove(&a).unwrap();
    assert!(rows(s.ezreal_r_accepted_impact_projection(0),s.tick).is_empty());
    s.players.insert(a,owner); assert_eq!(view(&s,a),first);
    until(&mut s,tick+HORIZON-1); assert_eq!(view(&s,a),first);
    until(&mut s,tick+HORIZON); assert!(view(&s,a).is_empty());
}
#[test]
fn longer_retention_never_adds_a_later_audience_or_extra_ring_capacity() {
    let mut s=state(); s.record(prepared(1,2,5,[true,false]));
    assert_eq!(rows(projected(&s,0,125),125).len(),1);
    assert!(rows(projected(&s,1,125),125).is_empty());
    for n in 0..(MAX_EVENTS+3) {s.record(prepared(1,2,126+n as u64,[true,false]));}
    let now=128+MAX_EVENTS as u64; let facts=rows(projected(&s,0,now),now);
    assert_eq!(facts.len(),MAX_EVENTS); assert_eq!(facts[0].order,5);
    assert!(rows(projected(&s,1,now),now).is_empty());
    assert!(serde_json::to_vec(&projected(&s,0,now)).unwrap().len()<=MAX_BYTES);
}
