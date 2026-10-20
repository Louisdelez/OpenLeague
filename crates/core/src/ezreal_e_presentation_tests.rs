use super::*;
use crate::ezreal_e_accepted_releases::{decode_view,Event,Phase};
fn game(ground:bool)->(Simulation,u32,u32) {
    // Synthetic walkable collision fixture; height assertions use the real dense
    // Map10 resource through the public startup binding, never this flat height.
    let mut bytes=Vec::new();for _ in 0..(160*120) {bytes.extend(0f32.to_le_bytes());
        bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":100,"width":160,"height":120}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=u64::MAX-7;s.enable_map10().unwrap();s.units.clear();
    if ground{s.enable_map10_cast_ground().unwrap();}
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for (id,x) in [(a,5000.),(b,5900.)] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x,z:7300.};
        p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=3;}
    s.players.get_mut(&a).unwrap().ranks=[0,0,1,0];
    s.ezreal_e.next_ordinal=(1u64<<53)+7;(s,a,b)
}
fn landing()->Point {Point{x:5475.,z:7300.}}
fn cast(s:&mut Simulation,a:u32){s.command(a,Action::CastAt{slot:2,point:landing()}).unwrap();}
fn until(s:&mut Simulation,tick:u64){while s.tick<tick{s.tick+=1;s.advance_ezreal_e();}}
fn events(s:&Simulation,team:u8)->Vec<Event>{decode_view(Some(&s.ezreal_e_accepted_release_projection(team)),s.tick).unwrap().unwrap()}
fn rows(s:&Simulation,viewer:u32)->Vec<crate::ezreal_e_projectile_view::Row>{s.ezreal_e_current_projection(viewer)
    .map(|v|crate::ezreal_e_projectile_view::decode(&v).unwrap()).unwrap_or_default()}
fn radius(s:&mut Simulation,owner:u32,value:f32){s.players.get_mut(&owner).unwrap().vision_radius_modifiers=
    vision::RadiusModifiers{percent_bubble_radius_mod:-1.,flat_bubble_radius_mod:value};}
#[test]
fn successful_commit_records_two_frozen_points_even_without_a_bolt_target() {
    let(mut s,a,b)=game(true);s.players.get_mut(&b).unwrap().position.x=10000.;cast(&mut s,a);
    let origin=s.players[&a].position;assert!(events(&s,0).is_empty());until(&mut s,7);assert!(events(&s,0).is_empty());
    until(&mut s,8);let out=events(&s,0);assert_eq!(out.len(),2);
    assert_eq!((out[0].phase,out[0].position,out[0].tick,out[0].order),(Phase::Departure,origin,8,1));
    assert_eq!((out[1].phase,out[1].position,out[1].tick,out[1].order),(Phase::Arrival,landing(),8,2));
    assert_eq!(s.players[&a].position,landing());assert!(s.ezreal_e.bolts.is_empty());assert!(rows(&s,a).is_empty());
    let before=format!("{:?}",s.ezreal_e);s.advance_ezreal_e();assert_eq!(format!("{:?}",s.ezreal_e),before);
    s.players.get_mut(&a).unwrap().position.x+=50.;assert_eq!(events(&s,0),out); // frozen facts
}
#[test]
fn real_pre_and_post_commit_visibility_admits_each_phase_independently() {
    for departure in [false,true] {
        let(mut s,a,b)=game(true);s.players.get_mut(&b).unwrap().position.x=if departure{4900.}else{5800.};
        radius(&mut s,b,if departure{200.}else{400.});cast(&mut s,a);until(&mut s,8);
        if departure {assert!(events(&s,1).is_empty());} // current body moved out of enemy vision
        else {let out=events(&s,1);assert_eq!(out.len(),1);assert_eq!(out[0].phase,Phase::Arrival);}
        s.players.get_mut(&b).unwrap().position.x=5200.;radius(&mut s,b,1000.);
        let out=events(&s,1);assert_eq!(out.len(),1);assert_eq!(out[0].order,1);
        assert_eq!(out[0].phase,if departure{Phase::Departure}else{Phase::Arrival});
        assert_eq!(out[0].position.x,if departure{5000.}else{5475.});
        radius(&mut s,b,1.);assert!(events(&s,1).is_empty());radius(&mut s,b,1000.);assert_eq!(events(&s,1),out);
    }
}
#[test]
fn rejected_and_interrupted_or_failed_release_never_publishes_success() {
    let(mut s,a,_)=game(true);s.players.get_mut(&a).unwrap().mana=0.;assert!(s.command(a,Action::CastAt{slot:2,point:landing()}).is_err());assert!(events(&s,0).is_empty());
    for mode in 0..10 {
        let(mut s,a,b)=game(true);cast(&mut s,a);let mana=s.players[&a].mana;
        match mode {
            0=>s.grant_stun(Some(b),a,"presentation test",30).unwrap(),
            1=>s.players.get_mut(&a).unwrap().effects.silence_until=30,
            2=>s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:10}),
            3=>s.players.get_mut(&a).unwrap().health=0.,
            4=>s.players.get_mut(&a).unwrap().position.x+=1.,
            5=>s.players.get_mut(&b).unwrap().position=landing(),
            6=>{s.remove_player(a).unwrap();},7=>s.session=42,8=>s.winner=Some(1),_=>s.tick=9}
        if s.tick<8{s.tick=8;}s.advance_ezreal_e();assert!(events(&s,0).is_empty(),"mode{mode}");
        assert!(s.ezreal_e.bolts.is_empty());
        if let Some(p)=s.players.get(&a){assert_ne!(p.position,landing());assert_eq!(p.mana,mana);}
    }
}
#[test]
fn real_dense_xyz_atomic_only_and_full_integer_identity_are_read_only() {
    let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);let before=format!("{:?}|{:?}",s.players,s.ezreal_e);
    let row=rows(&s,a)[0];assert_eq!(row.ordinal,(1u64<<53)+7);assert_eq!(row.position,landing());
    assert_eq!(row.y_native.to_bits(),s.map10_cast_ground.unwrap().sample_local_f32([5475.,7300.]).unwrap().to_bits());
    for snap in [s.snapshot(),s.snapshot_for(a).unwrap()] {assert!(snap.ezreal_e_current_bolts.is_none());assert!(snap.ezreal_e_accepted_releases.is_none());}
    let snapshot=s.snapshot_for_atomic(a).unwrap();let snapshot:Snapshot=serde_json::from_slice(&serde_json::to_vec(&snapshot).unwrap()).unwrap();
    assert_eq!(snapshot.session,u64::MAX-7);assert_eq!(crate::ezreal_e_projectile_view::decode(snapshot.ezreal_e_current_bolts.as_ref().unwrap()).unwrap(),vec![row]);
    assert_eq!(decode_view(snapshot.ezreal_e_accepted_releases.as_ref(),8).unwrap().unwrap().len(),2);
    assert_eq!(format!("{:?}|{:?}",s.players,s.ezreal_e),before);
}
#[test]
fn current_direction_tracks_actual_move_and_never_requeries_the_target_on_projection() {
    let(mut s,a,b)=game(true);cast(&mut s,a);until(&mut s,8);let first=rows(&s,a)[0];assert_eq!(first.direction,Point{x:1.,z:0.});
    s.players.get_mut(&b).unwrap().position=Point{x:5475.,z:7700.};assert_eq!(rows(&s,a)[0],first);
    until(&mut s,9);let second=rows(&s,a)[0];assert_eq!(second.direction,Point{x:0.,z:1.});
    assert_eq!(second.position,s.ezreal_e.bolts[0].position);assert!((second.position.z-7300.-SPEED/TICK_RATE as f32).abs()<0.001);
    s.players.get_mut(&b).unwrap().position=Point{x:f32::NAN,z:7300.};assert_eq!(rows(&s,a)[0],second);
    until(&mut s,10);assert!(rows(&s,a).is_empty());assert!(s.ezreal_e.bolts.is_empty());
}
#[test]
fn missing_ground_or_sample_drops_only_presentation_and_never_substitutes_actor_height() {
    let(mut s,a,_)=game(false);cast(&mut s,a);until(&mut s,8);assert!(rows(&s,a).is_empty());assert_eq!(events(&s,0).len(),2);
    assert!(s.enable_map10_cast_ground().is_err()); // explicit startup-only context
    let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);let normal=rows(&s,a)[0];
    s.players.get_mut(&a).unwrap().height=99999.;assert_eq!(rows(&s,a)[0],normal);
    s.ezreal_e.bolts[0].current=None;assert!(rows(&s,a).is_empty());assert_eq!(s.ezreal_e.bolts.len(),1);
    s.ezreal_e.bolts[0].position=Point{x:-1.,z:7300.};
    s.ezreal_e.bolts[0].current=Some(CurrentSample{tick:8,position:s.ezreal_e.bolts[0].position,direction:normal.direction});
    assert!(rows(&s,a).is_empty());assert_eq!(s.ezreal_e.bolts.len(),1);
}
#[test]
fn stale_tick_corrupt_identity_direction_and_duplicate_census_never_publish_partial_rows() {
    for mode in 0..9 {
        let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);
        match mode {
            0=>s.tick+=1,1=>s.ezreal_e.bolts[0].current.as_mut().unwrap().tick=7,
            2=>s.ezreal_e.bolts[0].current.as_mut().unwrap().direction.x=f32::NAN,
            3=>s.ezreal_e.bolts[0].current.as_mut().unwrap().position.x+=1.,
            4=>s.ezreal_e.next_ordinal=s.ezreal_e.bolts[0].ordinal,
            5=>s.ezreal_e.bolts[0].team=1,
            6=>s.ezreal_e.bolts[0].raw=f32::NAN,
            7=>{let b=&s.ezreal_e.bolts[0];let copy=Bolt{session:b.session,owner:b.owner,team:b.team,ordinal:b.ordinal,
                target:b.target,position:b.position,expires:b.expires,raw:b.raw,current:b.current};s.ezreal_e.bolts.push(copy);}
            _=>{for ordinal in 1..=MAX_CASTS {let b=&s.ezreal_e.bolts[0];let copy=Bolt{session:b.session,owner:b.owner,team:b.team,ordinal:ordinal as u64,
                target:b.target,position:b.position,expires:b.expires,raw:b.raw,current:b.current};s.ezreal_e.bolts.push(copy);}}}
        assert!(rows(&s,a).is_empty(),"mode{mode}");
    }
}
#[test]
fn current_bolt_point_fow_owner_death_and_terminal_removal_follow_gameplay() {
    let(mut s,a,b)=game(true);cast(&mut s,a);until(&mut s,8);let current=rows(&s,a)[0];
    s.players.get_mut(&a).unwrap().health=0.;assert_eq!(rows(&s,b)[0],current); // released bolt survives owner death
    s.players.get_mut(&b).unwrap().position.x=10000.;assert!(rows(&s,b).is_empty());
    s.players.get_mut(&b).unwrap().position.x=5900.;assert_eq!(rows(&s,b)[0],current);
    s.tick=s.ezreal_e.bolts[0].expires;s.advance_ezreal_e();assert!(rows(&s,b).is_empty());
    let(mut s,a,b)=game(true);cast(&mut s,a);until(&mut s,8);s.remove_player(a).unwrap();assert!(rows(&s,b).is_empty());assert!(events(&s,1).is_empty());
}
#[test]
fn disabled_and_repeated_projection_preserve_movement_damage_cooldown_and_passive() {
    let(mut left,a,_)=game(false);let(mut right,c,_)=game(true);assert_eq!(a,c);cast(&mut left,a);cast(&mut right,c);
    for tick in 1..=80 {
        until(&mut left,tick);until(&mut right,tick);
        for _ in 0..3{let _=right.snapshot_for_atomic(c);}
        assert_eq!(format!("{:?}|{:?}|{:?}",left.players,left.ezreal_e,left.ezreal_passive),
            format!("{:?}|{:?}|{:?}",right.players,right.ezreal_e,right.ezreal_passive),"tick{tick}");
    }
    assert!(right.ezreal_e.bolts.is_empty());
}
#[test]
fn unavailable_journal_owner_does_not_prevent_real_blink_or_bolt() {
    let(mut s,a,_)=game(true);cast(&mut s,a);s.remove_ezreal_e_release_owner(a);until(&mut s,8);
    assert_eq!(s.players[&a].position,landing());assert_eq!(rows(&s,a).len(),1);assert!(events(&s,0).is_empty());
}
#[test]
fn pause_repetition_retention_rewind_session_and_winner_never_mint_new_release() {
    let(mut s,a,b)=game(true);cast(&mut s,a);until(&mut s,8);let old=events(&s,0);
    for _ in 0..4{s.advance_ezreal_e();assert_eq!(events(&s,0),old);} // same authoritative tick, no new fact
    until(&mut s,187);assert_eq!(events(&s,0),old);assert!(!old[0].fresh_at(187));
    until(&mut s,188);assert!(events(&s,0).is_empty());
    for mode in 0..3 {
        let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);
        match mode{0=>s.tick=7,1=>s.session=42,_=>s.winner=Some(1)}s.advance_ezreal_e();
        assert!(events(&s,0).is_empty());assert!(rows(&s,a).is_empty());
    }
    s.remove_player(b).unwrap(); // unrelated departure cannot resurrect the expired owner's facts
    assert!(events(&s,0).is_empty());
}
