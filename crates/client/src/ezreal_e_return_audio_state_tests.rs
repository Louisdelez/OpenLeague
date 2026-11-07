use super::*;
use openleague_core::{Navigation,Simulation,Action,ezreal_e_accepted_releases::{Phase,POLICY}};
pub(super) fn fixture()->(Snapshot,u32,State){
    let(mut g,o)=game();g.tick=100;let s=g.snapshot_for_atomic(o).unwrap();
    let mut state=State::default();state.begin_epoch(s.session,(1<<60)+9,o);observe(&mut state,&s,1.,true,false);
    (s,o,state)
}
fn game()->(Simulation,u32){
    let mut cells=Vec::new();for _ in 0..6400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
    let mut g=Simulation::new(nav).unwrap();g.session=(1<<60)+7;let o=g.join("ezreal").unwrap();
    let p=g.players.get_mut(&o).unwrap();p.position=Point{x:200.,z:300.};p.level=6;p.ranks=[0,0,1,0];p.mana=2000.;(g,o)
}
pub(super) fn event(s:&mut Snapshot,o:u32,order:u64,phase:Phase){
    s.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":POLICY,"events":[{
        "owner":o,"order":order,"tick":s.tick,"phase":phase,"position":{"x":500.,"z":300.}}]}));
}
fn observe(state:&mut State,s:&Snapshot,now:f64,ready:bool,paused:bool){
    let (session,epoch,player)=state.context().unwrap();let frame=state.last_frame.unwrap_or(0)+1;
    state.observe_accepted_frame(s,now,ready,paused,Some((Context{session,epoch,player},frame))).unwrap();
}
#[test]
fn shared_departure_orders_full_width_identity_and_playlist_cycle_are_exact(){
    let(mut s,o,mut state)=fixture();state.last_frame=Some((1<<60)+20);let mut variants=Vec::new();
    for n in 0..4 {s.tick+=1;let order=(1<<60)+2*n+1;event(&mut s,o,order,Phase::Departure);
        observe(&mut state,&s,1.01,true,false);assert!(state.take(1.01,true,false).is_empty());assert_eq!(state.seen[&o].0,order);
        event(&mut s,o,order+1,Phase::Arrival);observe(&mut state,&s,1.01,true,false);
        let requests=state.take(1.01,true,false);assert_eq!(requests.len(),1);let r=requests[0];variants.push(r.variant);
        assert_eq!((r.identity.session,r.identity.epoch,r.identity.viewer,r.identity.order),(s.session,(1<<60)+9,o,order+1));
        assert!(state.authorizes(&r));let mut changed=r;changed.identity.viewer+=1;assert!(!state.authorizes(&changed));
        let mut changed=r;changed.position.x+=1.;assert!(!state.authorizes(&changed));
        observe(&mut state,&s,1.01,true,false);assert!(state.take(1.01,true,false).is_empty());
    }
    assert_eq!(variants,[0,1,2,0]);assert!(state.last_frame.unwrap()>(1<<60));
}
#[test]
fn authority_loss_and_same_batch_reveal_cannot_reauthorize_a_taken_voice(){
    for mode in 0..3 {let(mut s,o,mut state)=fixture();s.tick+=1;event(&mut s,o,2,Phase::Arrival);
        observe(&mut state,&s,1.01,true,false);let r=state.take(1.01,true,false)[0];let full=s.ezreal_e_accepted_releases.clone();let players=s.players.clone();
        s.tick+=1;s.ezreal_e_accepted_releases=if mode==0{None}else{Some(serde_json::json!({"policy":POLICY,"events":[]}))};if mode==2{s.players.clear();}
        observe(&mut state,&s,1.02,true,false);assert!(!state.authorizes(&r));
        s.ezreal_e_accepted_releases=full;s.players=players;observe(&mut state,&s,1.02,true,false);
        assert!(!state.authorizes(&r));assert!(state.take(1.02,true,false).is_empty());
    }
}
#[test]
fn pause_unready_epoch_legacy_stale_and_clock_failure_are_consumed_without_retry(){
    for mode in 0..8 {let(mut s,o,mut state)=fixture();s.tick+=1;event(&mut s,o,1,Phase::Arrival);
        let(session,epoch,player)=state.context().unwrap();
        match mode {
            0=>observe(&mut state,&s,1.01,true,true),1=>observe(&mut state,&s,1.01,false,false),
            2=>{state.begin_epoch(session,epoch+1,player);observe(&mut state,&s,1.01,true,false);},
            3=>{state.observe_accepted_frame(&s,1.01,true,false,None).unwrap();},
            4=>{s.tick+=MAX_AGE_TICKS+1;observe(&mut state,&s,1.01,true,false);},
            5=>{assert!(state.observe_accepted_frame(&s,f64::NAN,true,false,Some((Context{session,epoch,player},2))).is_err());},
            6=>{observe(&mut state,&s,1.01,true,false);assert!(state.take(1.01+MAX_DELAY+0.01,true,false).is_empty());},
            _=>{observe(&mut state,&s,1.01,true,false);state.suspend();},
        }
        assert!(state.take(1.2,true,false).is_empty());observe(&mut state,&s,1.21,true,false);assert!(state.take(1.21,true,false).is_empty());
    }
}
#[test]
fn malformed_conflicting_and_wrong_context_frames_revoke_without_partial_watermarks(){
    let(mut s,o,mut state)=fixture();s.tick+=1;event(&mut s,o,u64::MAX-2,Phase::Arrival);
    let good=s.clone();s.ezreal_e_accepted_releases.as_mut().unwrap()["events"][0]["position"]["x"]=serde_json::json!("bad");
    let old=state.seen.clone();let(session,epoch,player)=state.context().unwrap();let delivery=Some((Context{session,epoch,player},2));
    assert!(state.observe_accepted_frame(&s,1.01,true,false,delivery).is_err());assert_eq!(state.seen,old);
    assert_eq!(state.observe_accepted_frame(&good,1.01,true,false,delivery),Ok(false));
    observe(&mut state,&good,1.02,true,false);assert!(state.take(1.02,true,false).is_empty());
    let mut next=good.clone();next.tick+=1;event(&mut next,o,u64::MAX-1,Phase::Arrival);observe(&mut state,&next,1.03,true,false);
    let r=state.take(1.03,true,false)[0];next.ezreal_e_accepted_releases.as_mut().unwrap()["events"][0]["phase"]=serde_json::json!("departure");
    assert!(state.observe_accepted_frame(&next,1.04,true,false,Some((Context{session,epoch,player},5))).is_err());assert!(!state.authorizes(&r));
    assert!(state.observe_accepted_frame(&good,1.05,true,false,Some((Context{session,epoch:epoch+1,player},6))).is_err());
}
#[test]
fn real_targetless_blink_audio_and_vfx_consume_independent_arrival_authority(){
    let(mut g,o)=game();let context=Context{session:g.session,epoch:(1<<60)+9,player:o};
    let mut audio=State::default();audio.begin_epoch(g.session,context.epoch,o);
    let mut vfx=crate::ezreal_e_release_events::State::default();vfx.begin_epoch(g.session,context.epoch,o);
    let s=g.snapshot_for_atomic(o).unwrap();audio.observe_accepted_frame(&s,1.,true,false,Some((context,1))).unwrap();
    vfx.observe_accepted_frame(&s,1.,true,false,Some((context,1))).unwrap();
    g.command(o,Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).unwrap();
    let(mut sounds,mut flashes)=(Vec::new(),Vec::new());
    for frame in 2..=14 {g.advance();let s=g.snapshot_for_atomic(o).unwrap();let now=1.+g.tick as f64/TICK_RATE as f64;
        let before=serde_json::to_value(&s).unwrap();audio.observe_accepted_frame(&s,now,true,false,Some((context,frame))).unwrap();
        vfx.observe_accepted_frame(&s,now,true,false,Some((context,frame))).unwrap();flashes.extend(vfx.take(now,true,false));
        sounds.extend(audio.take(now,true,false));assert_eq!(serde_json::to_value(&s).unwrap(),before);}
    assert_eq!(sounds.len(),1);assert_eq!(flashes.len(),2);assert_eq!(sounds[0].position,g.players[&o].position);
    assert_eq!(flashes.iter().filter(|f|f.phase==Phase::Arrival).count(),1);
    assert!(g.snapshot_for_atomic(o).unwrap().ezreal_e_current_bolts.is_none());
}
#[test]
fn rejected_and_interrupted_casts_never_create_an_arrival_request(){
    for interrupt in [false,true] {let(mut g,o)=game();let context=Context{session:g.session,epoch:9,player:o};let mut state=State::default();state.begin_epoch(g.session,9,o);
        state.observe_accepted_frame(&g.snapshot_for_atomic(o).unwrap(),1.,true,false,Some((context,1))).unwrap();
        if interrupt {g.command(o,Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).unwrap();g.players.get_mut(&o).unwrap().effects.silence_until=30;}
        else {g.players.get_mut(&o).unwrap().mana=0.;assert!(g.command(o,Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).is_err());}
        for frame in 2..=14 {g.advance();let s=g.snapshot_for_atomic(o).unwrap();let now=1.+g.tick as f64/TICK_RATE as f64;
            state.observe_accepted_frame(&s,now,true,false,Some((context,frame))).unwrap();assert!(state.take(now,true,false).is_empty());}
    }
}
#[test]
fn full_pcm_duration_retains_real_authority_but_late_observer_never_births(){
    let(mut g,o)=game();let context=Context{session:g.session,epoch:9,player:o};let mut state=State::default();state.begin_epoch(g.session,9,o);
    state.observe_accepted_frame(&g.snapshot_for_atomic(o).unwrap(),1.,true,false,Some((context,1))).unwrap();
    g.command(o,Action::CastAt{slot:2,point:Point{x:500.,z:300.}}).unwrap();let mut request=None;
    for frame in 2..=200 {g.advance();let s=g.snapshot_for_atomic(o).unwrap();let now=1.+g.tick as f64/TICK_RATE as f64;
        state.observe_accepted_frame(&s,now,true,false,Some((context,frame))).unwrap();let q=state.take(now,true,false);
        if !q.is_empty(){assert!(request.is_none());request=Some(q[0]);}
        if let Some(r)=request {
            let age=g.tick-r.fingerprint.tick;assert_eq!(state.authorizes(&r),age<ezreal_e_accepted_releases::HORIZON);
            if age==100 {assert!(100./TICK_RATE as f64>119803./44100.+0.6);assert!(state.authorizes(&r));
                let mut late=State::default();late.begin_epoch(g.session,10,o);late.observe_accepted_frame(&s,now,true,false,Some((Context{epoch:10,..context},1))).unwrap();assert!(late.take(now,true,false).is_empty());}
        }
    }
    assert!(request.is_some());assert!(!state.authorizes(&request.unwrap()));
}
