use super::*;
use crate::{Action,Navigation,Snapshot,session_transport,session_wire,stuns,trundle_e};
fn game()->(Simulation,u32,u32){
    let mut bytes=Vec::new();for _ in 0..6400{bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for(id,x,team)in[(a,200.,0),(b,600.,1)]{let p=s.players.get_mut(&id).unwrap();p.team=team;p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=6;}
    s.players.get_mut(&a).unwrap().ranks=[0,0,0,1];(s,a,b)
}
fn cast(s:&mut Simulation,a:u32){s.command(a,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).unwrap();}
fn view(s:&Simulation,a:u32)->Vec<Event>{let snap=s.snapshot_for_atomic(a).unwrap();decode_view(snap.ezreal_r_accepted_casts.as_ref(),snap.tick).unwrap().unwrap()}
fn prepared(ordinal:u64,tick:u64,audience:[bool;2])->Prepared{Prepared{session:420,owner:1,source_team:0,ordinal,tick,position:Point{x:200.,z:300.},audience}}
fn state()->State{let mut s=State{session:Some(420),..State::default()};s.register(420,1);s}
fn projected(s:&State,team:u8,tick:u64)->Value{s.project(420,team,tick,|_,_,_|true)}
fn rows(v:Value,tick:u64)->Vec<Event>{decode_view(Some(&v),tick).unwrap().unwrap()}
#[test]
fn accepted_cast_commits_once_before_release_and_rejections_emit_nothing(){
    let(mut s,a,_)=game();assert!(view(&s,a).is_empty());let mana=s.players[&a].mana;cast(&mut s,a);
    let events=view(&s,a);assert_eq!(events.len(),1);assert_eq!(events[0],Event{owner:a,ordinal:1,order:1,tick:0,position:Point{x:200.,z:300.}});
    assert_eq!(s.players[&a].mana,mana-100.);assert!(s.ezreal_r_casting(a));
    assert!(s.command(a,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).is_err());assert_eq!(view(&s,a),events);
    assert!(s.snapshot().ezreal_r_accepted_casts.is_none());assert!(s.snapshot_for(a).unwrap().ezreal_r_accepted_casts.is_none());
    assert!(s.snapshot_for_atomic(a).unwrap().ezreal_r_accepted_impacts.unwrap()["events"].as_array().unwrap().is_empty());
    for mode in 0..4{let(mut s,a,_)=game();match mode{0=>s.players.get_mut(&a).unwrap().mana=0.,1=>s.players.get_mut(&a).unwrap().health=0.,2=>s.players.get_mut(&a).unwrap().effects.silence_until=10,_=>s.players.get_mut(&a).unwrap().ranks[3]=0}
        assert!(s.command(a,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).is_err());assert!(view(&s,a).is_empty());}
}
#[test]
fn post_accept_cancel_or_control_is_not_a_second_cue_and_death_revokes_projection(){
    for mode in 0..4{let(mut s,a,_)=game();cast(&mut s,a);let first=view(&s,a);
        let p=s.players.get_mut(&a).unwrap();match mode{0=>p.position.z+=20.,1=>p.effects.silence_until=120,
            2=>p.stuns.push(stuns::Stun{tag:"cancel R".into(),source:None,expires_at:120}),
            _=>p.effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:1,until:12})}
        s.tick=1;s.advance_ezreal_r();assert!(!s.ezreal_r_casting(a));assert_eq!(view(&s,a),first);
        s.players.get_mut(&a).unwrap().health=0.;assert!(view(&s,a).is_empty());
    }
    let(mut s,a,_)=game();cast(&mut s,a);let first=view(&s,a);for _ in 0..40{s.advance();}assert_eq!(view(&s,a),first);
}
#[test]
fn frozen_audience_never_gains_hidden_cast_and_current_body_and_origin_gate_history(){
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};
    cast(&mut s,a);assert!(view(&s,b).is_empty());assert_eq!(view(&s,a).len(),1);
    s.players.get_mut(&b).unwrap().position=Point{x:400.,z:300.};assert!(view(&s,b).is_empty(),"no late audience expansion");
    s.clear_ezreal_r();s.players.get_mut(&a).unwrap().cooldowns[3]=0;cast(&mut s,a);let heard=view(&s,b);assert_eq!(heard.len(),1);assert_eq!(heard[0].order,1);
    s.players.get_mut(&a).unwrap().position=Point{x:3500.,z:3500.};assert!(view(&s,b).is_empty(),"current body hidden");
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3300.};assert!(view(&s,b).is_empty(),"old cast point hidden");
    s.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};s.players.get_mut(&b).unwrap().position=Point{x:400.,z:300.};assert_eq!(view(&s,b),heard);
}
#[test]
fn optional_journal_failure_never_changes_gameplay_and_clear_keeps_orders(){
    let(mut normal,a,_)=game();let(mut silent,b,_)=game();silent.ezreal_r.cast_audio.remove(b);
    cast(&mut normal,a);cast(&mut silent,b);assert_eq!(serde_json::to_value(normal.snapshot()).unwrap(),serde_json::to_value(silent.snapshot()).unwrap());
    assert_eq!(view(&normal,a).len(),1);assert!(view(&silent,b).is_empty());
    normal.clear_ezreal_r();assert!(view(&normal,a).is_empty());normal.players.get_mut(&a).unwrap().cooldowns[3]=0;cast(&mut normal,a);
    assert_eq!((view(&normal,a)[0].ordinal,view(&normal,a)[0].order),(2,2));
    normal.session+=1;normal.advance_ezreal_r();normal.players.get_mut(&a).unwrap().cooldowns[3]=0;cast(&mut normal,a);assert_eq!(view(&normal,a)[0].order,1);
    normal.winner=Some(0);assert!(view(&normal,a).is_empty());normal.clear_ezreal_r();assert!(normal.ezreal_r.cast_audio.rings.iter().all(VecDeque::is_empty));
}
#[test]
fn private_team_orders_ring_budget_and_duplicate_cast_identity_are_independent(){
    let mut s=state();s.record(Some(prepared(1,5,[true,false])));let before=projected(&s,0,5);
    for ordinal in 2..=80{s.record(Some(prepared(ordinal,5,[false,true])));}
    assert_eq!(projected(&s,0,5),before);assert_eq!(rows(projected(&s,1,5),5).len(),MAX_EVENTS);
    s.record(Some(prepared(81,5,[true,true])));let both=projected(&s,0,5);assert_eq!(rows(both.clone(),5).last().unwrap().order,2);
    s.record(Some(prepared(81,5,[true,true])));assert_eq!(projected(&s,0,5),both);
    assert_eq!(rows(projected(&s,1,5),5).last().unwrap().order,80);
    s.owners.get_mut(&1).unwrap().orders[0]=u64::MAX;s.record(Some(prepared(82,5,[true,true])));
    assert_eq!(projected(&s,0,5),both);assert_eq!(rows(projected(&s,1,5),5).last().unwrap().order,81);
}
#[test]
fn ttl_clock_roster_admission_and_invalid_prepared_facts_fail_closed(){
    let mut s=state();for mode in 0..5{let mut f=prepared(1,5,[true,true]);match mode{0=>f.position.x=f32::NAN,1=>f.source_team=2,2=>f.session=421,3=>f.ordinal=0,_=>f.owner=999}s.record(Some(f));}
    assert_eq!(s.owners[&1].orders,[0,0]);s.record(Some(prepared(1,5,[true,true])));
    assert_eq!(rows(projected(&s,0,154),154).len(),1);assert!(rows(projected(&s,0,155),155).is_empty());
    s.prune(420,10);assert!(rows(projected(&s,0,9),9).is_empty());s.record(Some(prepared(2,9,[true,true])));assert_eq!(s.owners[&1].orders,[1,1]);
    assert!(rows(s.project(421,0,10,|_,_,_|true),10).is_empty());assert!(rows(projected(&s,2,10),10).is_empty());
    s.remove(1);s.register(420,1);assert!(!s.owners.contains_key(&1));for owner in 2..=9{s.register(420,owner);}assert_eq!(s.owners.len(),MAX_OWNERS);
}
#[test]
fn strict_decoder_rejects_ambiguous_identity_clock_fields_and_duplicate_ordinals(){
    let e=Event{owner:1,ordinal:7,order:1,tick:5,position:Point{x:200.,z:300.}};let valid=envelope(&[e]);
    assert_eq!(decode_view(None,5),Ok(None));assert_eq!(decode_view(Some(&valid),5),Ok(Some(vec![e])));
    for (field,val) in [("owner",json!(0)),("owner",json!(u64::MAX)),("ordinal",json!(0)),("ordinal",json!(1.5)),("order",json!(0)),("position",json!({"x":1e40,"z":0.})),("tick",json!(6))]{
        let mut bad=valid.clone();bad["events"][0][field]=val;assert!(decode_view(Some(&bad),5).is_err());}
    assert_eq!(decode_view(Some(&valid),155),Err(DecodeError::Time));
    for bad in [json!({"version":2,"events":[]}),json!({"version":1,"events":[],"extra":0}),json!({"version":1,"events":[{"owner":1}]})]{assert!(decode_view(Some(&bad),5).is_err());}
    for second in [e,Event{order:2,..e},Event{ordinal:8,order:2,tick:4,..e}]{assert_eq!(decode_view(Some(&envelope(&[e,second])),5),Err(DecodeError::Order));}
    assert_eq!(decode_view(Some(&envelope(&(1..=7).map(|owner|Event{owner,..e}).collect::<Vec<_>>())),5),Err(DecodeError::Owners));
}
#[test]
fn byte_and_fact_budgets_bound_projection_without_truncating_any_event(){
    let mut s=state();for ordinal in 1..=100{let mut f=prepared(ordinal,5,[true,true]);f.position=Point{x:f32::MAX,z:-f32::MAX};s.record(Some(f));}
    let v=projected(&s,0,5);assert!(serde_json::to_vec(&v).unwrap().len()<=MAX_BYTES);let events=rows(v,5);assert!(!events.is_empty() && events.len()<=MAX_EVENTS);
    let e=Event{owner:1,ordinal:1,order:1,tick:5,position:Point{x:0.,z:0.}};
    assert_eq!(decode_view(Some(&envelope(&vec![e;MAX_EVENTS+1])),5),Err(DecodeError::Budget));
    assert_eq!(decode_view(Some(&json!({"version":1,"events":[],"pad":"x".repeat(MAX_BYTES)})),5),Err(DecodeError::Budget));
}
#[test]
fn atomic_wire_keeps_u64_orders_and_ordinal_and_legacy_has_no_cast_fact(){
    let(mut s,a,_)=game();s.session=u64::MAX-7;s.clear_ezreal_r();s.ezreal_r.cast_audio.owners.get_mut(&a).unwrap().orders=[(1u64<<53)+3;2];
    cast(&mut s,a);let mut snapshot=s.snapshot_for_atomic(a).unwrap();let event=view(&s,a)[0];assert_eq!(event.ordinal,1);assert_eq!(event.order,(1u64<<53)+4);
    // Explicit codec-only full-width ordinal fixture; actual cast supplies the
    // owner, position, order and tick. No claim of billions of gameplay casts.
    snapshot.ezreal_r_accepted_casts.as_mut().unwrap()["events"][0]["ordinal"]=json!((1u64<<53)+9);
    let ctx=session_transport::Context{session:s.session,player:a,epoch:u64::MAX-1};let mut sender=session_wire::Sender::new(ctx).unwrap();
    let packets=sender.encode(&snapshot,u64::MAX-2).unwrap();let mut assembler=session_wire::Assembler::new(ctx).unwrap();let mut result=None;
    for p in packets.iter().rev(){assert!(p.len()<=1200);if let Some(frame)=assembler.push(p).unwrap(){result=Some(frame.decode().unwrap());}}
    let out=result.unwrap();assert_eq!(out.context,ctx);assert_eq!(out.clock_ordinal,u64::MAX-2);assert_eq!(out.snapshot.ezreal_r_accepted_casts,snapshot.ezreal_r_accepted_casts);
    assert!(s.snapshot_for(a).unwrap().ezreal_r_accepted_casts.is_none());
    let mut old=serde_json::to_value(snapshot).unwrap();old.as_object_mut().unwrap().remove("ezreal_r_accepted_casts");assert!(serde_json::from_value::<Snapshot>(old).unwrap().ezreal_r_accepted_casts.is_none());
}
