use super::*;
use openleague_core::{Navigation,Simulation,ezreal_e_accepted_releases::{Phase,POLICY}};
pub(super) fn fixture()->(Snapshot,u32,State){
    let mut cells=Vec::new();for _ in 0..400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
    let mut game=Simulation::new(nav).unwrap();game.session=(1<<60)+7;game.tick=100;let owner=game.join("ezreal").unwrap();
    let mut snapshot=game.snapshot();snapshot.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":POLICY,"events":[]}));
    let mut state=State::default();state.begin_epoch(snapshot.session,(1<<60)+9,owner);
    state.observe_test_frame(&snapshot,1.,true,false).unwrap();(snapshot,owner,state)
}
pub(super) fn event(snapshot:&mut Snapshot,owner:u32,order:u64,phase:Phase,position:Point){
    snapshot.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":POLICY,"events":[{
        "owner":owner,"order":order,"tick":snapshot.tick,"phase":phase,"position":position}]}));
}
#[test]
fn phases_have_independent_points_and_same_batch_loss_prevents_reappearance(){
    let (mut s,o,mut state)=fixture();s.tick+=1;
    event(&mut s,o,(1<<60)+1,Phase::Departure,Point{x:100.,z:5000.});
    state.observe_test_frame(&s,1.01,true,false).unwrap();let departure=s.ezreal_e_accepted_releases.as_ref().unwrap()["events"][0].clone();
    event(&mut s,o,(1<<60)+2,Phase::Arrival,Point{x:500.,z:5000.});
    s.ezreal_e_accepted_releases.as_mut().unwrap()["events"].as_array_mut().unwrap().insert(0,departure);
    state.observe_test_frame(&s,1.01,true,false).unwrap();let requests=state.take(1.01,true,false);
    assert_eq!(requests.len(),2);assert_eq!(requests[0].phase,Phase::Departure);assert_eq!(requests[1].phase,Phase::Arrival);
    assert_ne!(requests[0].position,requests[1].position);let mut forged=requests[0];forged.phase=Phase::Arrival;assert!(!state.authorizes(&forged));assert_ne!(requests[0].identity.order,requests[1].identity.order);
    let original=s.ezreal_e_accepted_releases.take();state.observe_test_frame(&s,1.01,true,false).unwrap();
    s.ezreal_e_accepted_releases=original;state.observe_test_frame(&s,1.01,true,false).unwrap();
    assert!(requests.iter().all(|r|!state.authorizes(r)));assert!(state.take(1.01,true,false).is_empty());
}
#[test]
fn arrival_alone_never_synthesizes_departure_or_looks_up_actor_position(){
    let (mut s,o,mut state)=fixture();s.tick+=1;let point=Point{x:300.,z:6000.};
    event(&mut s,o,1,Phase::Arrival,point);s.players.iter_mut().find(|p|p.id==o).unwrap().position=Point{x:999.,z:999.};
    state.observe_test_frame(&s,1.01,true,false).unwrap();let r=state.take(1.01,true,false);assert_eq!(r.len(),1);assert_eq!(r[0].position,point);
    s.ezreal_e_accepted_releases.as_mut().unwrap()["events"][0]["phase"]=serde_json::json!("departure");
    assert!(state.observe_test_frame(&s,1.02,true,false).is_err());assert!(!state.authorizes(&r[0]));
}
#[test]
fn legacy_epoch_pause_stale_frame_and_clock_failures_never_queue_late_flashes(){
    for mode in 0..5 {let (mut s,o,mut state)=fixture();s.tick+=1;event(&mut s,o,1,Phase::Departure,Point{x:100.,z:5000.});
        let (session,epoch,player)=state.context().unwrap();let context=Context{session,epoch,player};
        match mode{0=>{state.observe_accepted_frame(&s,1.01,true,false,None).unwrap();},
            1=>{state.begin_epoch(session,epoch+1,player);state.observe_test_frame(&s,1.01,true,false).unwrap();},
            2=>{state.observe_test_frame(&s,1.01,true,true).unwrap();},
            3=>{state.observe_accepted_frame(&s,1.01,true,false,Some((context,1))).unwrap();},
            _=>{assert!(state.observe_test_frame(&s,0.9,true,false).is_err());}}
        assert!(state.take(1.01,true,false).is_empty());state.observe_test_frame(&s,1.02,true,false).unwrap();assert!(state.take(1.02,true,false).is_empty());
    }
}
#[test]
fn malformed_projection_does_not_partially_advance_orders_or_repair_same_frame(){
    let (mut s,o,mut state)=fixture();s.tick+=1;event(&mut s,o,u64::MAX-2,Phase::Arrival,Point{x:100.,z:5000.});
    let good=s.clone();s.ezreal_e_accepted_releases.as_mut().unwrap()["events"][0]["position"]["x"]=serde_json::json!("bad");
    let seen=state.seen.clone();assert!(state.observe_test_frame(&s,1.01,true,false).is_err());assert_eq!(state.seen,seen);
    let (session,epoch,player)=state.context().unwrap();assert_eq!(state.observe_accepted_frame(&good,1.01,true,false,Some((Context{session,epoch,player},2))),Ok(false));
    assert!(state.take(1.01,true,false).is_empty());state.observe_test_frame(&good,1.02,true,false).unwrap();assert!(state.take(1.02,true,false).is_empty());
}
#[test]
fn real_committed_blink_without_target_delivers_two_flashes_from_atomic_frames_only(){
    let mut cells=Vec::new();for _ in 0..6400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
    let mut g=Simulation::new(nav).unwrap();g.session=(1<<60)+17;let o=g.join("ezreal").unwrap();
    {let p=g.players.get_mut(&o).unwrap();p.position=Point{x:200.,z:300.};p.level=6;p.ranks=[0,0,1,0];p.mana=2000.;}
    let context=Context{session:g.session,epoch:(1<<60)+19,player:o};let mut channel=State::default();channel.begin_epoch(g.session,context.epoch,o);
    channel.observe_accepted_frame(&g.snapshot_for_atomic(o).unwrap(),1.,true,false,Some((context,1))).unwrap();
    let origin=g.players[&o].position;g.command(o,openleague_core::Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).unwrap();
    let mut requests=Vec::new();
    for frame in 2..=14 {g.advance();let s=g.snapshot_for_atomic(o).unwrap();let before=serde_json::to_value(&s).unwrap();let now=1.+g.tick as f64/TICK_RATE as f64;
        channel.observe_accepted_frame(&s,now,true,false,Some((context,frame))).unwrap();requests.extend(channel.take(now,true,false));assert_eq!(serde_json::to_value(&s).unwrap(),before);}
    assert_eq!(requests.len(),2);assert_eq!(requests[0].phase,Phase::Departure);assert_eq!(requests[0].position,origin);
    assert_eq!(requests[1].phase,Phase::Arrival);assert_eq!(requests[1].position,g.players[&o].position);assert_ne!(origin,requests[1].position);
    assert!(g.snapshot().ezreal_e_accepted_releases.is_none());assert!(g.snapshot_for(o).unwrap().ezreal_e_accepted_releases.is_none());
}
