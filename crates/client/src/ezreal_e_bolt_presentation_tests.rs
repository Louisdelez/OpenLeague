use super::*;
use serde_json::{Value,json};

fn fixture()->(State,Snapshot,u32,Context) {
    let mut bytes=Vec::new();for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());
        bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut sim=openleague_core::Simulation::new(nav).unwrap();sim.session=u64::MAX-7;
    let owner=sim.join("ezreal").unwrap();let viewer=sim.join("garen").unwrap();let mut snap=sim.snapshot();
    snap.tick=(1u64<<53)+11;snap.players.retain(|p|p.id!=owner);
    snap.ezreal_e_current_bolts=Some(json!({"policy":wire::POLICY,"rows":[{
        "owner":owner,"team":0,"ordinal":u64::MAX,"x":7000,"z":8000,"y_native":150,"dx":1,"dz":0}]}));
    let c=Context{session:snap.session,player:viewer,epoch:(1u64<<53)+5};
    let mut state=State::default();state.reset_session(c.session,viewer);state.begin_epoch(Some(c.epoch));
    (state,snap,viewer,c)
}
fn observe(s:&mut State,snap:&Snapshot,v:u32,c:Context,frame:u64,now:f64) {
    s.observe_accepted_frame(snap,v,now,false,true,Some((c,frame))).unwrap();
}
fn samples(s:&State,snap:&Snapshot,v:u32,c:Context,now:f64)->Vec<CurrentE> {
    s.samples(snap,v,c.session,Some(c.epoch),now,false,true)
}
fn active()->(State,Snapshot,u32,Context) {
    let(mut s,mut snap,v,c)=fixture();observe(&mut s,&snap,v,c,1,1.);snap.tick+=1;
    observe(&mut s,&snap,v,c,2,1.01);assert_eq!(samples(&s,&snap,v,c,1.01).len(),1);(s,snap,v,c)
}
#[test]
fn baseline_has_no_history_then_current_homing_xyz_and_full_u64_are_atomic() {
    let(mut s,mut snap,v,c)=fixture();let high=(1u64<<53)+9;
    observe(&mut s,&snap,v,c,high,1.);assert!(samples(&s,&snap,v,c,1.).is_empty());
    snap.tick+=1;observe(&mut s,&snap,v,c,high+1,1.01);let a=samples(&s,&snap,v,c,1.01)[0];
    assert_eq!((a.key.session,a.key.ordinal,a.epoch,a.sample_tick,a.sample_frame),(c.session,u64::MAX,c.epoch,snap.tick,high+1));
    let row=&mut snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0];
    row["x"]=json!(7010);row["z"]=json!(8020);row["y_native"]=json!(123);row["dx"]=json!(0);row["dz"]=json!(1);
    snap.tick+=1;observe(&mut s,&snap,v,c,high+2,1.02);let b=samples(&s,&snap,v,c,1.1)[0];
    assert_eq!((b.position,b.y_native,b.direction),(Point{x:7010.,z:8020.},123.,Point{x:0.,z:1.}));
    assert_eq!(b.incarnation,a.incarnation);assert_eq!(b.sample_frame,b.authorization_frame);
    // No current owner or target exists in visible players; no extrapolation.
    snap.players.clear();assert_eq!(samples(&s,&snap,v,c,1.11)[0],b);
}
#[test]
fn same_tick_permission_frames_keep_sample_stamp_and_never_refresh_freshness() {
    let(mut s,snap,v,c)=active();let first=samples(&s,&snap,v,c,1.01)[0];
    observe(&mut s,&snap,v,c,3,1.10);let next=samples(&s,&snap,v,c,1.10)[0];
    assert_eq!(next.sample_frame,first.sample_frame);assert_eq!(next.authorization_frame,3);
    assert_eq!(next.position,first.position);assert!(samples(&s,&snap,v,c,1.22).is_empty());
    s.maintain(1.22,false,true);assert!(s.rows.is_empty());assert!(s.baseline);
}
#[test]
fn same_tick_pose_or_direction_rewrite_is_rejected_and_frame_is_consumed() {
    for field in ["x","y_native","dx"] {
        let(mut s,mut snap,v,c)=active();snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0][field]=json!(-1);
        assert!(s.observe_accepted_frame(&snap,v,1.02,false,true,Some((c,3))).is_err());
        assert!(s.rows.is_empty());assert_eq!(s.last_frame,Some(3));
        assert!(s.observe_accepted_frame(&snap,v,1.02,false,true,Some((c,3))).is_err());
    }
}
#[test]
fn same_batch_absence_and_reveal_never_reuse_old_episode_or_backfill() {
    let(mut s,mut snap,v,c)=active();let old=samples(&s,&snap,v,c,1.01)[0];
    let raw=snap.ezreal_e_current_bolts.take();observe(&mut s,&snap,v,c,3,1.02);
    assert!(samples(&s,&snap,v,c,1.02).is_empty());snap.ezreal_e_current_bolts=raw;
    observe(&mut s,&snap,v,c,4,1.02);assert!(samples(&s,&snap,v,c,1.02).is_empty());
    snap.tick+=1;observe(&mut s,&snap,v,c,5,1.03);let new=samples(&s,&snap,v,c,1.03)[0];
    assert!(new.incarnation>old.incarnation);assert_eq!(new.sample_tick,snap.tick);assert_eq!(new.sample_frame,5);
}
#[test]
fn pause_retires_and_resume_uses_a_new_baseline_and_new_current_episode() {
    let(mut s,mut snap,v,c)=active();let old=samples(&s,&snap,v,c,1.01)[0];
    s.maintain(1.01,true,true);assert!(s.rows.is_empty());
    s.observe_accepted_frame(&snap,v,1.01,true,true,Some((c,3))).unwrap();
    assert!(s.samples(&snap,v,c.session,Some(c.epoch),1.01,true,true).is_empty());
    observe(&mut s,&snap,v,c,4,1.01);assert!(samples(&s,&snap,v,c,1.01).is_empty());
    snap.tick+=1;observe(&mut s,&snap,v,c,5,1.02);assert!(samples(&s,&snap,v,c,1.02)[0].incarnation>old.incarnation);
}
#[test]
fn lost_connection_legacy_and_missing_height_retire_without_gameplay_mutation() {
    for mode in 0..4 {
        let(mut s,mut snap,v,c)=active();let before=serde_json::to_vec(&snap).unwrap();
        match mode {0=>s.maintain(1.02,false,false),
            1=>s.observe_accepted_frame(&snap,v,1.02,false,true,None).unwrap(),
            2=>{snap.ezreal_e_current_bolts=None;observe(&mut s,&snap,v,c,3,1.02);},
            _=>{snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0].as_object_mut().unwrap().remove("y_native");
                assert!(s.observe_accepted_frame(&snap,v,1.02,false,true,Some((c,3))).is_err());}}
        assert!(samples(&s,&snap,v,c,1.02).is_empty());assert!(s.rows.is_empty());
        if mode<2{assert_eq!(serde_json::to_vec(&snap).unwrap(),before);}
    }
}
#[test]
fn session_epoch_viewer_team_and_clock_boundaries_fail_closed() {
    for mode in 0..8 {
        let(mut s,mut snap,v,c)=active();let mut context=c;let mut now=1.02;let mut viewer=v;
        match mode {0=>context.epoch+=1,1=>context.session-=1,2=>context.player+=1,
            3=>snap.session-=1,4=>viewer+=1,5=>now=f64::NAN,6=>now=1.,_=>snap.tick-=1}
        assert!(s.observe_accepted_frame(&snap,viewer,now,false,true,Some((context,3))).is_err());assert!(s.rows.is_empty());
    }
    let(mut s,mut snap,v,c)=active();snap.roster.iter_mut().find(|p|p.id==v).unwrap().team=0;
    observe(&mut s,&snap,v,c,3,1.02);assert!(samples(&s,&snap,v,c,1.02).is_empty());
}
#[test]
fn winner_is_terminal_and_new_epoch_requires_baseline_without_old_episode() {
    let(mut s,mut snap,v,c)=active();let old=samples(&s,&snap,v,c,1.01)[0];
    snap.winner=Some(0);observe(&mut s,&snap,v,c,3,1.02);snap.winner=None;snap.tick+=1;
    observe(&mut s,&snap,v,c,4,1.03);assert!(samples(&s,&snap,v,c,1.03).is_empty());
    let next=Context{epoch:c.epoch+1,..c};s.begin_epoch(Some(next.epoch));
    observe(&mut s,&snap,v,next,1,1.03);assert!(samples(&s,&snap,v,next,1.03).is_empty());
    snap.tick+=1;observe(&mut s,&snap,v,next,2,1.04);let row=samples(&s,&snap,v,next,1.04)[0];
    assert_eq!(row.epoch,next.epoch);assert!(row.incarnation>old.incarnation);
}
#[test]
fn malformed_duplicate_budget_roster_and_counter_exhaustion_never_publish_partial_rows() {
    for mode in 0..7 {
        let(mut s,mut snap,v,c)=active();snap.tick+=1;
        match mode {0=>{let row=snap.ezreal_e_current_bolts.as_ref().unwrap()["rows"][0].clone();snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"].as_array_mut().unwrap().push(row);},
            1=>snap.roster.push(snap.roster[0].clone()),
            2=>snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0]["y_native"]=json!(1e100),
            3=>snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0]["target"]=json!(123),
            4=>{s.next=u64::MAX;snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0]["ordinal"]=json!(1);},
            5=>snap.ezreal_e_current_bolts=Some(json!({"policy":wire::POLICY,"rows":[],"padding":"x".repeat(wire::MAX_BYTES)})),
            _=>{let mut other=snap.roster[0].clone();other.id=99;snap.roster.push(other);
                snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"][0]["owner"]=json!(99);}}
        assert!(s.observe_accepted_frame(&snap,v,1.02,false,true,Some((c,3))).is_err(),"mode{mode}");assert!(s.rows.is_empty());
    }
}
#[test]
fn bounded64_rows_accept_then_65_or_duplicate_global_ordinals_reject_whole_channel() {
    let(mut s,mut snap,v,c)=fixture();let base=snap.ezreal_e_current_bolts.as_ref().unwrap()["rows"][0].clone();
    let rows:Vec<Value>=(1..=wire::MAX_ROWS).map(|n|{let mut r=base.clone();r["ordinal"]=json!(n as u64);r}).collect();
    snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"]=json!(rows);
    observe(&mut s,&snap,v,c,1,1.);snap.tick+=1;observe(&mut s,&snap,v,c,2,1.01);
    assert_eq!(samples(&s,&snap,v,c,1.01).len(),wire::MAX_ROWS);
    let mut extra=base;extra["ordinal"]=json!(65);snap.ezreal_e_current_bolts.as_mut().unwrap()["rows"].as_array_mut().unwrap().push(extra);
    snap.tick+=1;assert!(s.observe_accepted_frame(&snap,v,1.02,false,true,Some((c,3))).is_err());assert!(s.rows.is_empty());
}
