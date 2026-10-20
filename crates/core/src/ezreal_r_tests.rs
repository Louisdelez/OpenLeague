use super::*;
fn game() -> (Simulation,u32,u32) {
    let mut bytes=Vec::new();
    for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for(id,x,team)in[(a,200.,0),(b,1000.,1)] {let p=s.players.get_mut(&id).unwrap();p.team=team;p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=6;}
    s.players.get_mut(&a).unwrap().ranks=[0,0,0,1];(s,a,b)
}
fn aim()->Point {Point{x:3000.,z:300.}}
fn cast(s:&mut Simulation,a:u32) {s.command(a,Action::CastAt{slot:3,point:aim()}).unwrap();}
fn until(s:&mut Simulation,tick:u64) {while s.tick<tick {s.tick+=1;s.prune_ezreal_passive();s.advance_ezreal_r();}}
fn state(s:&Simulation)->String {format!("{:?}|{:?}|{:?}|{:?}|{:?}",s.players,s.ezreal_r,s.ezreal_passive,s.projectiles,s.attack_presentation.events())}
fn close(a:f32,b:f32) {assert!((a-b).abs()<0.01,"{a} != {b}");}

#[test]
fn primary_r_rules_learning_and_ground_dispatch_reject_corrupt_inherited_fallbacks() {
    for(rank,level)in[(1,6),(2,11),(3,16)] {
        let rule=rules(rank).unwrap();assert_eq!((rule.base,rule.cost,rule.cooldown,rule.ap,rule.bonus_ad),([350.,500.,650.][rank as usize-1],100.,80.,0.9,1.));
        let(mut s,a,_)=game();let p=s.players.get_mut(&a).unwrap();p.level=level-1;p.ranks[3]=rank-1;
        assert!(s.learn(a,3).is_err());s.players.get_mut(&a).unwrap().level=level;s.command(a,Action::Learn{slot:3}).unwrap();
        assert_eq!(s.players[&a].ranks[3],rank);assert!(s.learn(a,3).is_err());
        assert_eq!(s.cast(a,3,None).unwrap_err(),"Ezreal R requires a ground point");
    }
    for rank in[0,4,255] {assert!(rules(rank).is_err());}
    let text=include_str!("../../../data/4.20/native_spells_420.json");
    for case in 0..4 {
        let mut table:serde_json::Value=serde_json::from_str(text).unwrap();let rows=table.as_array_mut().unwrap();
        let index=rows.iter().position(|r|r["spell"]=="EzrealTrueshotBarrage").unwrap();
        match case {0=>{rows[index]["values"].as_object_mut().unwrap().remove("Effect1Level1Amount");},
            1=>{let duplicate=rows[index].clone();rows.push(duplicate);},
            2=>rows[index]["values"]["Coefficient"]=serde_json::json!("NaN"),
            _=>rows[index]["values"]["Effect3Level2Amount"]=serde_json::json!(25)}
        assert!(parse(&table.to_string()).is_err());
    }
}

#[test]
fn r_preflight_is_atomic_for_geometry_controls_stats_resources_clocks_and_attack_phase() {
    for case in 0..14 {
        let(mut s,a,b)=game();let mut point=aim();
        match case {
            0=>point=s.players[&a].position,1=>point.x=f32::NAN,
            2=>s.players.get_mut(&a).unwrap().mana=99.,3=>s.players.get_mut(&a).unwrap().mana=f32::INFINITY,
            4=>s.players.get_mut(&a).unwrap().ranks[3]=0,5=>s.players.get_mut(&a).unwrap().cooldowns[3]=1,
            6=>s.players.get_mut(&a).unwrap().effects.silence_until=1,
            7=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),
            8=>s.ezreal_r.next_ordinal=u64::MAX,9=>s.tick=u64::MAX-100,
            10=>s.definitions.get_mut("ezreal").unwrap().attack_damage=f32::NAN,
            11=>s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:5}),
            12=>s.players.get_mut(&a).unwrap().windup=Some(attacks::Windup{target:b,started:0,release:20,cancelable:false,critical:true,presentation:None}),
            _=>{for ordinal in 1..=MAX_CASTS {let identity=Identity{session:420,owner:a,team:0,ordinal:ordinal as u64};
                let shot=Shot::new(identity,s.players[&a].position,aim(),Params{speed_units_per_second:SPEED,tick_rate:TICK_RATE as u32,
                    max_distance:RANGE,projectile_radius:RADIUS,launch_tick:30,expires_at_tick:331,mode:Mode::Pierce,
                    limits:Limits{targets_per_step:MAX_TARGETS,unique_hits:MAX_TARGETS}}).unwrap();
                s.ezreal_r.flights.push(Flight{shot,raw:350.,accepted_hits:0,direction:Point{x:1.,z:0.},
                    cast_ground_seed:Err(CastGroundUnavailable::ContextDisabled),
            vertical:Err(VerticalUnavailable::CastGround(CastGroundUnavailable::ContextDisabled))});}},
        }
        let before=state(&s);assert!(s.command(a,Action::CastAt{slot:3,point}).is_err());assert_eq!(state(&s),before);
    }
}

#[test]
fn engaged_thirty_tick_cast_is_once_only_and_paid_interruptions_never_release_or_refund() {
    let(mut s,a,b)=game();let hp=s.players[&b].health;cast(&mut s,a);
    assert_eq!(s.players[&a].mana,1900.);assert_eq!(s.players[&a].cooldowns[3],2400);
    for action in[Action::Move{point:aim()},Action::Attack{target:b},Action::Stop,Action::CastAt{slot:3,point:aim()}] {
        assert_eq!(s.command(a,action).unwrap_err(),"skill blocked during cast");
    }
    until(&mut s,29);assert!(s.ezreal_r.flights.is_empty());assert_eq!(s.players[&b].health,hp);
    until(&mut s,30);assert!(s.ezreal_r.pending.is_empty());assert_eq!(s.ezreal_r.flights.len(),1);
    let at=s.ezreal_r.flights[0].shot.view().position;s.advance_ezreal_r();assert_eq!(s.ezreal_r.flights[0].shot.view().position,at);
    until(&mut s,31);assert!(s.ezreal_r.flights[0].shot.view().position.x>at.x);
    for case in 0..6 {
        let(mut s,a,b)=game();cast(&mut s,a);
        match case {0=>s.players.get_mut(&a).unwrap().health=0.,
            1=>s.players.get_mut(&a).unwrap().effects.silence_until=100,
            2=>s.grant_stun(Some(b),a,"fixture",100).unwrap(),
            3=>{s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:5});
                assert!(trundle_e::champion_forced(&s.players[&a],s.tick),"case {case}: forced-movement fixture must be active");},
            4=>s.players.get_mut(&a).unwrap().position.z+=1.,_=>s.tick=31}
        s.advance_ezreal_r();until(&mut s,40);assert!(s.ezreal_r.pending.is_empty()&&s.ezreal_r.flights.is_empty(),"case {case}: paid R interruption must retire pending and flight");
        assert_eq!(s.players[&a].mana,1900.);assert_eq!(s.players[&a].cooldowns[3],2400);assert_eq!(s.players[&b].health,10000.);
        assert!(!s.ezreal_r_faults().is_empty());
    }
}

#[test]
fn r_pierces_unique_units_in_distance_id_order_and_applies_accepted_hit_floor() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    s.definitions.get_mut("garen").unwrap().magic_resist=0.;
    {let p=s.players.get_mut(&b).unwrap();p.position=Point{x:500.,z:300.};p.level=1;}
    let definition=s.world.as_ref().unwrap().config.definitions.iter()
        .find(|(_,d)|d.kind==world::Kind::Melee).map(|(name,_)|name.clone()).unwrap();
    let mut ids=vec![b];
    for i in 1..9 {
        let target=s.spawn_unit(&definition,"R pierce fixture",1,Point{x:500.+i as f32*100.,z:300.},0.,0.,None,None).unwrap();
        let unit=s.units.get_mut(&target).unwrap();unit.health=10000.;unit.max_health=10000.;unit.magic_resist=0.;
        ids.push(target);
    }
    assert_eq!(s.players.len(),2);assert_eq!(s.units.len(),8);
    // Equal centers and equal radii for two NPCs: numeric id breaks the true contact tie.
    let tied=s.units[&ids[1]].position;s.units.get_mut(&ids[2]).unwrap().position=tied;
    assert_eq!(s.target_info(ids[1]).unwrap().radius,s.target_info(ids[2]).unwrap().radius);
    cast(&mut s,a);until(&mut s,65);
    for(i,id)in ids.iter().enumerate() {close(10000.-s.target_info(*id).unwrap().health,350.*(1.-0.1*i.min(7) as f32).max(0.3));}
    assert_eq!(s.ezreal_r.flights[0].accepted_hits,9);assert_eq!(s.ezreal_passive_stacks(a),5);
    let after:Vec<_>=ids.iter().map(|id|s.target_info(*id).unwrap().health).collect();until(&mut s,80);
    assert_eq!(after,ids.iter().map(|id|s.target_info(*id).unwrap().health).collect::<Vec<_>>());
}

#[test]
fn rejected_damage_does_not_decay_but_absorbed_ok_does_and_no_contact_retries() {
    let(mut s,a,b)=game();s.definitions.get_mut("garen").unwrap().magic_resist=0.;
    let bad=s.join("annie").unwrap();let later=s.join("garen").unwrap();
    for(id,x)in[(bad,450.),(b,650.),(later,850.)] {let p=s.players.get_mut(&id).unwrap();p.team=1;p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.level=1;}
    s.definitions.get_mut("annie").unwrap().magic_resist=f32::NAN;
    s.grant_shield(b,"R fixture",1000.,100).unwrap();cast(&mut s,a);until(&mut s,55);
    assert_eq!(s.players[&bad].health,10000.);assert_eq!(s.players[&b].health,10000.);
    close(s.players[&b].shields[0].remaining,650.);close(10000.-s.players[&later].health,315.);
    assert_eq!(s.ezreal_r.flights[0].accepted_hits,2);assert_eq!(s.ezreal_passive_stacks(a),2);
    assert_eq!(s.ezreal_r_faults().iter().filter(|f|f.stage=="impact").count(),1);
    until(&mut s,70);assert_eq!(s.ezreal_r_faults().iter().filter(|f|f.stage=="impact").count(),1);
}

#[test]
fn cast_frozen_signed_bonus_ap_cdr_and_live_mitigation_use_one_common_damage_path() {
    let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.players.get_mut(&a).unwrap().inventory[1]=Some(1036);
    let ad=s.attack_damage_components(a).unwrap();let stats=s.stats(a);assert!(ad.bonus>0.);
    let raw=350.+ad.bonus+0.9*stats.ability_power;let cd=cooldown::ticks(80.,stats.cooldown_reduction);
    cast(&mut s,a);close(s.ezreal_r.pending[&a].flight.raw,raw);assert_eq!(s.players[&a].cooldowns[3],cd);
    s.players.get_mut(&a).unwrap().inventory=[None;6];s.players.get_mut(&a).unwrap().inventory[0]=Some(3020);
    s.players.get_mut(&a).unwrap().ranks[3]=3;s.players.get_mut(&a).unwrap().effects.exhaust_until=100;
    s.players.get_mut(&b).unwrap().inventory[0]=Some(1033);let mr=s.stats(b).magic_resist;
    let current=s.stats(a);let effective=penetration::effective(mr,current.magic_penetration,current.magic_penetration_percent).unwrap();
    let outgoing=raw*s.exhaust_damage_multiplier(Some(a),damage::DamageKind::Magical);
    let expected=damage::mitigate(outgoing,damage::DamageKind::Magical,0.,effective,1.).unwrap();
    until(&mut s,60);close(10000.-s.players[&b].health,expected);assert_eq!(s.players[&a].cooldowns[3],cd);
    let(mut s,a,_)=game();assert!(s.attack_damage_components(a).unwrap().level_base<80.);
    for slot in 0..4 {let t=s.join("trundle").unwrap();s.players.get_mut(&t).unwrap().team=1;
        s.players.get_mut(&a).unwrap().effects.trundle_q.losses[slot]=Some(trundle_q::Loss{source:t,amount:20.,until:200});}
    assert_eq!(s.players.len(),6);
    let ad=s.attack_damage_components(a).unwrap();assert_eq!(ad.total,0.);close(ad.bonus,-ad.level_base);
    cast(&mut s,a);close(s.ezreal_r.pending[&a].flight.raw,(350.-ad.level_base).max(0.));
}

#[test]
fn hidden_global_contact_has_no_new_wire_state_and_released_r_survives_death_not_departure() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:300.};
    assert!(!s.visible_to(0,b));cast(&mut s,a);until(&mut s,30);s.players.get_mut(&a).unwrap().health=0.;until(&mut s,90);
    assert!(s.players[&b].health<10000.);assert_eq!(s.ezreal_passive_stacks(a),0);
    let wire=serde_json::to_value(s.snapshot_for(b).unwrap()).unwrap();
    // Historical name retained: the newly admitted current-point channel must
    // never export private R contacts/damage/history or another owner's passive.
    assert!(wire.get("ezreal_passive_self").is_none());
    for row in wire.get("ezreal_r_projectiles").and_then(serde_json::Value::as_array).into_iter().flatten() {
        assert_eq!(row.as_object().unwrap().keys().map(String::as_str).collect::<std::collections::BTreeSet<_>>(),
            std::collections::BTreeSet::from(["session","owner","team","ordinal","position","direction"]));
    }
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,30);s.remove_player(a).unwrap();until(&mut s,70);
    assert_eq!(s.players[&b].health,10000.);assert!(s.ezreal_r.flights.is_empty());
    let(mut s,a,_)=game();cast(&mut s,a);s.session+=1;s.advance_ezreal_r();assert!(s.ezreal_r.pending.is_empty());
}

#[test]
fn bounded_flight_clock_range_and_census_failures_retire_without_catchup_or_replay() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.z=1000.;cast(&mut s,a);until(&mut s,30);
    assert_eq!(s.ezreal_r.flights[0].shot.view().position,s.players[&a].position);until(&mut s,331);assert!(s.ezreal_r.flights.is_empty());
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,30);s.tick=32;s.advance_ezreal_r();
    assert!(s.ezreal_r.flights.is_empty());assert_eq!(s.players[&b].health,10000.);assert_eq!(s.ezreal_r_faults()[0].stage,"advance");
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,30);s.players.get_mut(&b).unwrap().position.x=f32::NAN;s.tick=31;s.advance_ezreal_r();
    assert!(s.ezreal_r.flights.is_empty());assert_eq!(s.ezreal_r_faults()[0].stage,"census");assert_eq!(s.players[&a].mana,1900.);
}

#[test]
fn real_q_refunds_paid_r_and_r_commit_preserves_released_autoattack_projectiles() {
    let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().ranks[0]=1;s.players.get_mut(&b).unwrap().position.x=600.;
    s.command(a,Action::CastAt{slot:0,point:aim()}).unwrap();
    while s.tick<8 {s.tick+=1;s.advance_ezreal_q();}cast(&mut s,a);let ready=s.players[&a].cooldowns[3];
    while s.tick<25 {s.tick+=1;s.advance_ezreal_q();s.advance_ezreal_r();}
    assert_eq!(s.players[&a].cooldowns[3],ready-ezreal_q::REFUND_TICKS);
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.x=450.;
    s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();assert!(s.players[&a].windup.is_some());cast(&mut s,a);assert!(s.players[&a].windup.is_none());
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.x=450.;
    s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();s.tick=s.players[&a].windup.as_ref().unwrap().release;s.advance_attacks();
    assert_eq!(s.projectiles.len(),1);let aa=serde_json::to_value(&s.projectiles).unwrap();cast(&mut s,a);until(&mut s,60);
    assert_eq!(serde_json::to_value(&s.projectiles).unwrap(),aa);
}
use std::collections::BTreeSet;
#[test]
fn current_r_projection_is_pure_and_late_reveal_omits_every_travel_history_field() {
    let(mut old,a,b)=game();old.players.get_mut(&b).unwrap().position.x=3500.;
    cast(&mut old,a);until(&mut old,29);assert!(old.snapshot_for(b).unwrap().ezreal_r_projectiles.is_empty());
    until(&mut old,78);let current=old.ezreal_r.flights[0].shot.view().position;
    old.players.get_mut(&b).unwrap().position=current;
    let before=state(&old);let rows=old.snapshot_for(b).unwrap().ezreal_r_projectiles;
    assert_eq!(state(&old),before);assert_eq!(rows.len(),1);
    let json=serde_json::to_value(rows[0]).unwrap();
    let names=json.as_object().unwrap().keys().map(String::as_str).collect::<BTreeSet<_>>();
    assert_eq!(names,BTreeSet::from(["session","owner","team","ordinal","position","direction"]));
    // Same allowed current point/direction/identity, but a different real cast
    // origin and launch tick: public R data must be indistinguishable.
    let(mut recent,ra,rb)=game();recent.tick=48;
    recent.players.get_mut(&ra).unwrap().position=current;
    recent.players.get_mut(&rb).unwrap().position=current;
    recent.command(ra,Action::CastAt{slot:3,point:Point{x:current.x+500.,z:current.z}}).unwrap();
    until(&mut recent,78);
    assert_eq!(recent.snapshot_for(rb).unwrap().ezreal_r_projectiles,rows);
    assert_ne!(old.players[&a].position,recent.players[&ra].position);
    assert_eq!(old.snapshot().ezreal_r_projectiles.len(),0);
    assert!(old.snapshot().ezreal_passive_self.is_none());
}

#[test]
fn r_point_only_audience_hides_immediately_without_caster_body_and_preserves_released_death() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:300.};
    cast(&mut s,a);until(&mut s,78);let point=s.ezreal_r.flights[0].shot.view().position;
    s.players.get_mut(&b).unwrap().position=point;
    assert!(!s.visible_to(1,a));assert!(s.visible_point_to(1,point));
    assert_eq!(s.snapshot_for(b).unwrap().ezreal_r_projectiles.len(),1);
    let owner_point=s.players[&a].position;s.players.get_mut(&b).unwrap().position=owner_point;
    assert!(s.visible_to(1,a));assert!(!s.visible_point_to(1,point));
    assert!(s.snapshot_for(b).unwrap().ezreal_r_projectiles.is_empty());
    let ally=s.join("garen").unwrap();s.players.get_mut(&ally).unwrap().team=0;
    s.players.get_mut(&ally).unwrap().position=point;
    assert_eq!(s.snapshot_for(ally).unwrap().ezreal_r_projectiles.len(),1);
    s.players.get_mut(&a).unwrap().health=0.;
    assert_eq!(s.snapshot_for(ally).unwrap().ezreal_r_projectiles.len(),1);
    s.players.get_mut(&ally).unwrap().position=Point{x:100.,z:300.};
    assert!(s.snapshot_for(ally).unwrap().ezreal_r_projectiles.is_empty());
    s.players.get_mut(&ally).unwrap().position=point;s.remove_player(a).unwrap();
    assert!(s.snapshot_for(ally).unwrap().ezreal_r_projectiles.is_empty());
}

#[test]
fn r_projection_rejects_invalid_viewer_metadata_session_and_end_without_mutating_flight() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,30);
    assert_eq!(s.ezreal_r_projection(b).len(),1);
    for bad in[Point{x:f32::NAN,z:0.},Point{x:0.,z:0.},Point{x:2.,z:0.}] {
        s.ezreal_r.flights[0].direction=bad;let before=state(&s);
        assert!(s.ezreal_r_projection(b).is_empty());assert_eq!(state(&s),before);
    }
    s.ezreal_r.flights[0].direction=Point{x:1.,z:0.};
    s.players.get_mut(&b).unwrap().team=2;assert!(s.ezreal_r_projection(b).is_empty());
    s.players.get_mut(&b).unwrap().team=1;s.players.get_mut(&b).unwrap().id=b+100;
    assert!(s.ezreal_r_projection(b).is_empty());s.players.get_mut(&b).unwrap().id=b;
    s.winner=Some(0);assert!(s.ezreal_r_projection(b).is_empty());s.winner=None;
    s.session+=1;assert!(s.ezreal_r_projection(b).is_empty());assert!(s.ezreal_r_projection(999999).is_empty());
}

#[test]
fn maximum_r_projection_and_owner_count_roundtrip_both_existing_wires_with_u64_identity() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,30);
    let mut snapshot=s.snapshot_for(a).unwrap();let mut row=snapshot.ezreal_r_projectiles[0];
    snapshot.ezreal_r_projectiles=(0..MAX_CASTS).map(|i|{row.ordinal=u32::MAX as u64+1+i as u64;row}).collect();
    snapshot.ezreal_passive_self=Some(crate::ezreal_passive::OwnerPassive{session:s.session,owner:a,stacks:5});
    let expected=serde_json::to_value(&snapshot).unwrap();
    assert!(serde_json::to_vec(&ServerPacket::State(snapshot.clone())).unwrap().len()<1024*1024);
    let packets=crate::wire::state_datagrams(&snapshot).unwrap();assert!(packets.iter().all(|p|p.len()<=1200));
    let mut assembler=crate::wire::StateAssembler::default();let mut complete=None;
    for p in packets.iter().rev() {if let Some(bytes)=assembler.push(p,Some(s.session)) {complete=Some(bytes);}}
    let ServerPacket::State(decoded)=serde_json::from_slice(&complete.unwrap()).unwrap() else {panic!("real legacy State required")};
    assert_eq!(serde_json::to_value(decoded).unwrap(),expected);
    let context=crate::session_transport::Context{session:s.session,player:a,epoch:7};
    let mut sender=crate::session_wire::Sender::new(context).unwrap();
    let packets=sender.encode(&snapshot,11).unwrap();assert!(packets.iter().all(|p|p.len()<=1200));
    let mut assembler=crate::session_wire::Assembler::new(context).unwrap();let mut complete=None;
    for p in packets.iter().rev() {if let Some(frame)=assembler.push(p).unwrap() {complete=Some(frame);}}
    let decoded=complete.unwrap().decode().unwrap();assert_eq!(decoded.clock_ordinal,11);
    assert_eq!(serde_json::to_value(decoded.snapshot).unwrap(),expected);
    let mut older=expected;older.as_object_mut().unwrap().remove("ezreal_r_projectiles");
    older.as_object_mut().unwrap().remove("ezreal_passive_self");
    let old:Snapshot=serde_json::from_value(older).unwrap();assert!(old.ezreal_r_projectiles.is_empty());assert!(old.ezreal_passive_self.is_none());
    assert!(s.snapshot_for(b).unwrap().ezreal_passive_self.is_none());
}

#[test]
fn real_pending_cast_projects_only_current_windup_without_mutating_authority() {
    let (mut s,a,b)=game();s.ezreal_r.next_ordinal=u32::MAX as u64+17;
    cast(&mut s,a);let pending=&s.ezreal_r.pending[&a];
    let expected=VisibleCast{session:420,owner:a,team:0,ordinal:u32::MAX as u64+17,
        releases:30,direction:pending.flight.direction};
    let before=(s.session,s.tick,state(&s));
    for viewer in [a,b,a,b] {
        let snapshot=s.snapshot_for(viewer).unwrap();
        assert_eq!(snapshot.ezreal_r_casts,vec![expected]);
        assert!(snapshot.ezreal_r_projectiles.is_empty());
    }
    assert_eq!((s.session,s.tick,state(&s)),before);
    assert!(s.snapshot().ezreal_r_casts.is_empty());
    let json=serde_json::to_value(expected).unwrap();
    assert_eq!(json.as_object().unwrap().keys().map(String::as_str).collect::<BTreeSet<_>>(),
        BTreeSet::from(["session","owner","team","ordinal","releases","direction"]));
    assert_eq!(json["ordinal"].as_u64(),Some(u32::MAX as u64+17));
    until(&mut s,29);assert_eq!(s.snapshot_for(a).unwrap().ezreal_r_casts,vec![expected]);
    // Hide at the boundary even before the gameplay update removes Pending.
    s.tick=30;let before=state(&s);
    assert!(s.snapshot_for(a).unwrap().ezreal_r_casts.is_empty());assert_eq!(state(&s),before);
    assert_eq!(s.ezreal_r.pending.len(),1);s.advance_ezreal_r();
    assert!(s.ezreal_r.pending.is_empty());assert_eq!(s.snapshot_for(a).unwrap().ezreal_r_projectiles.len(),1);
    until(&mut s,31);assert!(s.snapshot_for(a).unwrap().ezreal_r_casts.is_empty());
}

#[test]
fn pending_cast_audience_tracks_body_fow_without_late_reveal_history() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:300.};
    cast(&mut s,a);let row=s.snapshot_for(a).unwrap().ezreal_r_casts[0];
    assert!(!s.visible_to(1,a));assert!(s.snapshot_for(b).unwrap().ezreal_r_casts.is_empty());
    until(&mut s,20);let origin=s.players[&a].position;
    s.players.get_mut(&b).unwrap().position=origin;
    assert!(s.visible_to(1,a));assert_eq!(s.snapshot_for(b).unwrap().ezreal_r_casts,vec![row]);
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:300.};
    assert!(!s.visible_to(1,a));assert!(s.snapshot_for(b).unwrap().ezreal_r_casts.is_empty());
    assert_eq!(s.snapshot_for(a).unwrap().ezreal_r_casts,vec![row]);
    until(&mut s,30);s.players.get_mut(&b).unwrap().position=origin;
    assert!(s.snapshot_for(b).unwrap().ezreal_r_casts.is_empty());
}

fn another_r_caster(s:&mut Simulation)->u32 {
    let owner=s.join("ezreal").unwrap();let p=s.players.get_mut(&owner).unwrap();
    p.team=0;p.position=Point{x:400.,z:600.};p.health=10000.;p.max_health=10000.;
    p.mana=2000.;p.level=6;p.ranks=[0,0,0,1];owner
}

#[test]
fn real_paid_interruptions_hide_immediately_and_leave_other_active_casts() {
    for case in 0..6 {
        let(mut s,a,b)=game();let other=another_r_caster(&mut s);cast(&mut s,a);cast(&mut s,other);
        assert_eq!(s.snapshot_for(b).unwrap().ezreal_r_casts.len(),2);
        match case {
            0=>s.players.get_mut(&a).unwrap().health=0.,
            1=>s.players.get_mut(&a).unwrap().effects.silence_until=100,
            2=>s.grant_stun(Some(b),a,"R cast projection",100).unwrap(),
            3=>s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:5}),
            4=>s.players.get_mut(&a).unwrap().position.z+=1.,
            _=>{s.remove_player(a).unwrap();},
        }
        let before=(s.tick,state(&s));let rows=s.snapshot_for(b).unwrap().ezreal_r_casts;
        assert_eq!(rows.len(),1,"interruption case {case}");assert_eq!(rows[0].owner,other);
        assert_eq!((s.tick,state(&s)),before);
        if let Some(p)=s.players.get(&a) {assert_eq!(p.mana,1900.);assert_eq!(p.cooldowns[3],2400);}
    }
}

#[test]
fn cast_projection_rejects_wrong_audience_session_end_and_clock_regression() {
    let(mut s,a,b)=game();s.tick=10;cast(&mut s,a);
    assert_eq!(s.ezreal_r_cast_projection(a).len(),1);
    s.tick=9;assert!(s.ezreal_r_cast_projection(a).is_empty());
    s.tick=10;s.ezreal_r.last_advanced=Some(11);assert!(s.ezreal_r_cast_projection(a).is_empty());
    s.ezreal_r.last_advanced=None;s.tick=41;assert!(s.ezreal_r_cast_projection(a).is_empty());s.tick=10;
    assert!(s.ezreal_r_cast_projection(999999).is_empty());
    s.players.get_mut(&b).unwrap().team=2;assert!(s.ezreal_r_cast_projection(b).is_empty());
    s.players.get_mut(&b).unwrap().team=1;s.players.get_mut(&b).unwrap().id=b+100;
    assert!(s.ezreal_r_cast_projection(b).is_empty());s.players.get_mut(&b).unwrap().id=b;
    s.winner=Some(0);assert!(s.ezreal_r_cast_projection(a).is_empty());s.winner=None;
    s.session+=1;let before=state(&s);assert!(s.ezreal_r_cast_projection(a).is_empty());assert_eq!(state(&s),before);
    s.advance_ezreal_r();assert!(s.ezreal_r.pending.is_empty());
}

#[test]
fn malformed_pending_census_clears_whole_cast_channel_without_repairing_it() {
    for case in 0..15 {
        let(mut s,a,b)=game();let other=another_r_caster(&mut s);cast(&mut s,a);cast(&mut s,other);
        // Corrupt the later owner, so a valid earlier row must not escape.
        match case {
            0=>s.ezreal_r.pending.get_mut(&other).unwrap().releases=29,
            1=>s.ezreal_r.pending.get_mut(&other).unwrap().releases=u64::MAX,
            2=>s.ezreal_r.pending.get_mut(&other).unwrap().flight.direction=Point{x:f32::NAN,z:0.},
            3=>s.ezreal_r.pending.get_mut(&other).unwrap().flight.direction=Point{x:0.,z:0.},
            4=>s.ezreal_r.pending.get_mut(&other).unwrap().flight.direction=Point{x:2.,z:0.},
            5=>s.players.get_mut(&other).unwrap().id=other+100,
            6=>s.players.get_mut(&other).unwrap().team=1,
            7=>s.players.get_mut(&other).unwrap().champion="garen".into(),
            8=>s.players.get_mut(&other).unwrap().health=f32::NAN,
            9=>s.players.get_mut(&other).unwrap().position.x=f32::INFINITY,
            10=>s.ezreal_r.pending.get_mut(&other).unwrap().origin.x=f32::NAN,
            11=>s.ezreal_r.pending.get_mut(&other).unwrap().flight.raw=f32::INFINITY,
            12=>s.ezreal_r.pending.get_mut(&other).unwrap().flight.accepted_hits=1,
            13=>s.ezreal_r.next_ordinal=0,
            _=>{let p=s.ezreal_r.pending.get_mut(&other).unwrap();let id=p.flight.shot.view().identity;
                p.flight.shot.cancel(id).unwrap();},
        }
        let before=(s.tick,state(&s));assert!(s.ezreal_r_cast_projection(b).is_empty(),"case {case}");
        assert_eq!((s.tick,state(&s)),before);
    }
}

#[test]
fn duplicate_cast_ordinals_and_total_active_budget_fail_closed() {
    let(mut s,a,b)=game();let other=another_r_caster(&mut s);cast(&mut s,a);cast(&mut s,other);
    let identity=s.ezreal_r.pending[&a].flight.shot.view().identity;
    let make_shot=|identity,origin|Shot::new(identity,origin,aim(),Params{
        speed_units_per_second:SPEED,tick_rate:TICK_RATE as u32,max_distance:RANGE,projectile_radius:RADIUS,
        launch_tick:30,expires_at_tick:331,mode:Mode::Pierce,
        limits:Limits{targets_per_step:MAX_TARGETS,unique_hits:MAX_TARGETS}}).unwrap();
    let replacement=make_shot(Identity{owner:other,..identity},s.players[&other].position);
    s.ezreal_r.pending.get_mut(&other).unwrap().flight.shot=replacement;
    let before=state(&s);assert!(s.ezreal_r_cast_projection(b).is_empty());assert_eq!(state(&s),before);
    // Restore the real distinct ordinal, then exceed only the combined budget.
    let replacement=make_shot(Identity{owner:other,ordinal:identity.ordinal+1,..identity},s.players[&other].position);
    s.ezreal_r.pending.get_mut(&other).unwrap().flight.shot=replacement;
    assert_eq!(s.ezreal_r_cast_projection(b).len(),2);
    for n in 0..MAX_CASTS-1 {
        s.ezreal_r.flights.push(Flight{shot:make_shot(Identity{ordinal:100+n as u64,..identity},s.players[&a].position),
            raw:350.,accepted_hits:0,direction:Point{x:1.,z:0.},
            cast_ground_seed:Err(CastGroundUnavailable::ContextDisabled),
            vertical:Err(VerticalUnavailable::CastGround(CastGroundUnavailable::ContextDisabled))});
    }
    assert_eq!(s.ezreal_r.pending.len()+s.ezreal_r.flights.len(),MAX_CASTS+1);
    let before=state(&s);assert!(s.ezreal_r_cast_projection(b).is_empty());assert_eq!(state(&s),before);
}

#[test]
fn pending_cast_projection_uses_committed_direction_without_rewriting_facing() {
    let(mut s,a,b)=game();s.command(a,Action::CastAt{slot:3,point:Point{x:1200.,z:1300.}}).unwrap();
    let expected=s.ezreal_r.pending[&a].flight.direction;
    close(expected.x,1./2f32.sqrt());close(expected.z,1./2f32.sqrt());
    // A presentation read must not "repair" a later facing or derive its aim.
    s.players.get_mut(&a).unwrap().facing=None;
    let before=state(&s);let row=s.snapshot_for(b).unwrap().ezreal_r_casts[0];
    assert_eq!(row.direction,expected);assert_eq!(state(&s),before);assert!(s.players[&a].facing.is_none());
}

#[test]
fn cast_channel_default_and_maximum_wire_budget_preserve_u64_identity() {
    let(mut s,a,_)=game();cast(&mut s,a);let mut snapshot=s.snapshot_for(a).unwrap();
    let row=snapshot.ezreal_r_casts[0];
    let mut legacy=serde_json::to_value(&snapshot).unwrap();legacy.as_object_mut().unwrap().remove("ezreal_r_casts");
    let old:Snapshot=serde_json::from_value(legacy).unwrap();assert!(old.ezreal_r_casts.is_empty());
    // Wire-only maximum DTO volume, not a claim of 64 simultaneous player casts.
    snapshot.ezreal_r_casts=(0..MAX_CASTS).map(|n|VisibleCast{
        ordinal:u32::MAX as u64+1+n as u64,..row}).collect();
    let expected=serde_json::to_value(&snapshot).unwrap();
    assert!(serde_json::to_vec(&ServerPacket::State(snapshot.clone())).unwrap().len()<1024*1024);
    let packets=crate::wire::state_datagrams(&snapshot).unwrap();assert!(packets.iter().all(|p|p.len()<=1200));
    let mut assembler=crate::wire::StateAssembler::default();let mut complete=None;
    for packet in packets.iter().rev() {if let Some(bytes)=assembler.push(packet,Some(s.session)){complete=Some(bytes);}}
    let ServerPacket::State(decoded)=serde_json::from_slice(&complete.unwrap()).unwrap() else {panic!("legacy State required")};
    assert_eq!(serde_json::to_value(decoded).unwrap(),expected);
    let context=crate::session_transport::Context{session:s.session,player:a,epoch:7};
    let mut sender=crate::session_wire::Sender::new(context).unwrap();let packets=sender.encode(&snapshot,12).unwrap();
    assert!(packets.iter().all(|p|p.len()<=1200));
    let mut assembler=crate::session_wire::Assembler::new(context).unwrap();let mut complete=None;
    for packet in packets.iter().rev() {if let Some(frame)=assembler.push(packet).unwrap(){complete=Some(frame);}}
    let decoded=complete.unwrap().decode().unwrap();assert_eq!(decoded.clock_ordinal,12);
    assert_eq!(serde_json::to_value(decoded.snapshot).unwrap(),expected);
}

// Actual recovered Map10 height/navigation data, isolated from world stepping.
fn cast_ground_game(enabled: bool, origin: Point) -> (Simulation, u32, u32) {
    let (mut s,a,b) = game();
    s.navigation = Navigation::load(
        include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
    ).unwrap();
    s.enable_map10().unwrap();
    s.units.clear();
    if enabled { s.enable_map10_cast_ground().unwrap(); }
    s.players.get_mut(&a).unwrap().position = origin;
    s.players.get_mut(&b).unwrap().position = Point { x: origin.x + 600., z: origin.z };
    (s,a,b)
}
fn cast_ground_origin() -> Point { Point { x: 3675., z: 9872.936 } }
fn cast_ground_cast(s: &mut Simulation, a: u32) {
    let origin = s.players[&a].position;
    s.command(a, Action::CastAt { slot: 3, point: Point { x: origin.x + 1600., z: origin.z } }).unwrap();
}

#[test]
fn cast_ground_context_is_explicit_and_startup_only() {
    let (mut s,_,_) = game();
    assert!(s.map10_cast_ground.is_none());
    assert!(s.enable_map10_cast_ground().is_err());
    assert!(s.map10_cast_ground.is_none());
    s.enable_map10().unwrap();
    assert!(s.map10_cast_ground.is_none(), "world activation must not select height policy implicitly");
    s.enable_map10_cast_ground().unwrap();
    let selected = s.map10_cast_ground.unwrap();
    assert!(std::ptr::eq(selected, map10_dense_height::binding().unwrap()));
    assert!(s.enable_map10_cast_ground().is_err());
    assert!(std::ptr::eq(selected, s.map10_cast_ground.unwrap()));
    let (mut late,_,_) = cast_ground_game(false, cast_ground_origin());
    late.tick = 1;
    assert!(late.enable_map10_cast_ground().is_err());
    assert!(late.map10_cast_ground.is_none());
}

#[test]
fn cast_ground_seed_uses_actual_dense_corner_not_actor_or_traversal_height() {
    let binding = map10_dense_height::binding().unwrap();
    let [x,z] = binding.grid().spec().min_xz;
    let (mut s,a,_) = cast_ground_game(true, Point { x,z });
    assert_eq!(s.navigation.ground(Point { x,z }), None, "actual first traversal cell is blocked");
    s.players.get_mut(&a).unwrap().height = 123456.;
    s.tick = 7;
    cast_ground_cast(&mut s,a);
    let seed = s.ezreal_r.pending[&a].flight.cast_ground_seed.as_ref().unwrap();
    assert_eq!(seed.position.map(f32::to_bits), [x.to_bits(),0x4315_7f68,z.to_bits()]);
    assert_eq!(seed.captured_tick, 7);
    assert_eq!(Some(seed.facing), s.players[&a].facing);
    assert_eq!(s.players[&a].height, 123456., "capture does not rewrite the displayed actor height");
    assert_eq!(s.players[&a].mana, 1900.);
    assert_eq!(s.players[&a].cooldowns[3], 2407);
}

#[test]
fn cast_ground_absence_and_outside_are_explicit_without_changing_paid_cast() {
    let (mut disabled,disabled_owner,_) = cast_ground_game(false, cast_ground_origin());
    cast_ground_cast(&mut disabled,disabled_owner);
    assert_eq!(disabled.ezreal_r.pending[&disabled_owner].flight.cast_ground_seed,
        Err(CastGroundUnavailable::ContextDisabled));
    assert!(disabled.ezreal_r_faults().is_empty());
    let spec = map10_dense_height::binding().unwrap().grid().spec();
    let (mut outside,outside_owner,_) = cast_ground_game(true, Point { x: spec.min_xz[0]-1., z: 7000. });
    cast_ground_cast(&mut outside,outside_owner);
    assert!(matches!(outside.ezreal_r.pending[&outside_owner].flight.cast_ground_seed,
        Err(CastGroundUnavailable::Terrain(dense_height_grid::Error::OutsideBounds { .. }))));
    assert_eq!(outside.ezreal_r_faults().len(),1);
    assert_eq!(outside.ezreal_r_faults()[0].stage,"cast_ground_seed");
    for (s,owner) in [(&disabled,disabled_owner),(&outside,outside_owner)] {
        assert_eq!(s.players[&owner].mana,1900.);
        assert_eq!(s.players[&owner].cooldowns[3],2400);
        assert_eq!(s.ezreal_r.pending.len(),1);
    }
    until(&mut disabled,30);
    until(&mut outside,30);
    assert_eq!(disabled.ezreal_r.flights.len(),1);
    assert_eq!(outside.ezreal_r.flights.len(),1);
}

#[test]
fn cast_ground_capture_rejects_nonfinite_coordinates_without_zero_substitution() {
    let binding = map10_dense_height::binding().unwrap();
    let facing = entity_facing::Facing::from_yaw(0.).unwrap();
    for origin in [Point { x:f32::NAN,z:7000. }, Point { x:4000.,z:f32::INFINITY }] {
        assert!(matches!(capture_cast_ground(Some(binding),origin,5,facing),
            Err(CastGroundUnavailable::Terrain(dense_height_grid::Error::NonFiniteCoordinate { .. }))));
    }
}

#[test]
fn cast_ground_seed_is_frozen_across_pause_release_and_later_owner_motion() {
    let (mut s,a,_) = cast_ground_game(true,cast_ground_origin());
    cast_ground_cast(&mut s,a);
    let captured = s.ezreal_r.pending[&a].flight.cast_ground_seed.clone();
    until(&mut s,29);
    // The local host pauses by not advancing the simulation tick.
    for _ in 0..3 {
        s.advance_ezreal_r();
        let _ = s.snapshot_for(a).unwrap();
        assert_eq!(s.ezreal_r.pending[&a].flight.cast_ground_seed,captured);
        assert!(s.ezreal_r.flights.is_empty());
    }
    until(&mut s,30);
    assert!(s.ezreal_r.pending.is_empty());
    assert_eq!(s.ezreal_r.flights[0].cast_ground_seed,captured);
    let launch = s.ezreal_r.flights[0].shot.view().position;
    s.players.get_mut(&a).unwrap().position.x += 900.;
    s.players.get_mut(&a).unwrap().height = -999.;
    s.players.get_mut(&a).unwrap().facing = Some(entity_facing::Facing::from_yaw(-180.).unwrap());
    until(&mut s,31);
    assert_ne!(s.ezreal_r.flights[0].shot.view().position,launch);
    assert_eq!(s.ezreal_r.flights[0].cast_ground_seed,captured);
}

#[test]
fn cast_ground_seed_retires_with_existing_pending_interruptions() {
    for case in 0..6 {
        let (mut s,a,b) = cast_ground_game(true,cast_ground_origin());
        cast_ground_cast(&mut s,a);
        assert!(s.ezreal_r.pending[&a].flight.cast_ground_seed.is_ok());
        match case {
            0 => s.players.get_mut(&a).unwrap().health = 0.,
            1 => s.players.get_mut(&a).unwrap().position.z += 1.,
            2 => s.players.get_mut(&a).unwrap().effects.silence_until = 100,
            3 => { s.grant_stun(Some(b),a,"cast-ground interruption",100).unwrap(); },
            4 => s.clear_ezreal_r_pending(a),
            _ => s.session += 1,
        }
        s.advance_ezreal_r();
        until(&mut s,31);
        assert!(s.ezreal_r.pending.is_empty() && s.ezreal_r.flights.is_empty(),"case {case}");
        assert_eq!(s.players[&a].mana,1900.);
        assert_eq!(s.players[&a].cooldowns[3],2400);
    }
}

#[test]
fn cast_ground_released_seed_survives_owner_death_then_retires_normally() {
    for departure in [false,true] {
        let (mut s,a,_) = cast_ground_game(true,cast_ground_origin());
        cast_ground_cast(&mut s,a);
        until(&mut s,30);
        let captured = s.ezreal_r.flights[0].cast_ground_seed.clone();
        s.players.get_mut(&a).unwrap().health = 0.;
        until(&mut s,31);
        assert_eq!(s.ezreal_r.flights[0].cast_ground_seed,captured);
        if departure { s.remove_player(a).unwrap(); until(&mut s,32); }
        else { until(&mut s,331); }
        assert!(s.ezreal_r.pending.is_empty() && s.ezreal_r.flights.is_empty());
    }
}

#[test]
fn cast_ground_context_preserves_gameplay_and_exact_public_snapshots() {
    let (mut off,a,b) = cast_ground_game(false,cast_ground_origin());
    let (mut on,aa,bb) = cast_ground_game(true,cast_ground_origin());
    assert_eq!((a,b),(aa,bb));
    cast_ground_cast(&mut off,a);
    cast_ground_cast(&mut on,a);
    assert!(on.ezreal_r.pending[&a].flight.cast_ground_seed.is_ok());
    assert_eq!(off.ezreal_r.pending[&a].flight.cast_ground_seed,Err(CastGroundUnavailable::ContextDisabled));
    for tick in [0,29,30,40,60] {
        until(&mut off,tick); until(&mut on,tick);
        assert_eq!(serde_json::to_value(off.snapshot()).unwrap(),serde_json::to_value(on.snapshot()).unwrap());
        assert_eq!(serde_json::to_value(off.snapshot_for(a).unwrap()).unwrap(),
                   serde_json::to_value(on.snapshot_for(a).unwrap()).unwrap());
        assert_eq!(off.players[&b].health,on.players[&b].health);
        assert_eq!(off.ezreal_passive_stacks(a),on.ezreal_passive_stacks(a));
        assert_eq!(off.ezreal_r_faults(),on.ezreal_r_faults());
    }
    assert!(on.players[&b].health<10000.,"comparison must include an actual accepted hit");
    assert_eq!(on.players[&a].mana,1900.);
    assert_eq!(on.players[&a].cooldowns[3],2400);
}

#[test]
fn cast_ground_failed_gameplay_preflight_has_no_seed_or_diagnostic_mutation() {
    let spec = map10_dense_height::binding().unwrap().grid().spec();
    let (mut s,a,_) = cast_ground_game(true,Point { x:spec.min_xz[0]-1.,z:7000. });
    s.players.get_mut(&a).unwrap().mana = 99.;
    let before = state(&s);
    let origin = s.players[&a].position;
    assert!(s.command(a,Action::CastAt { slot:3,point:Point { x:origin.x+1600.,z:origin.z } }).is_err());
    assert_eq!(state(&s),before);
    assert!(s.ezreal_r_faults().is_empty());
}

#[test]
fn vertical_release_uses_frozen_cast_actor_height_and_facing_separate_from_dense_seed() {
    let (mut low,a,_) = cast_ground_game(true,cast_ground_origin());
    let (mut high,aa,_) = cast_ground_game(true,cast_ground_origin());
    low.players.get_mut(&a).unwrap().height=300.;
    high.players.get_mut(&aa).unwrap().height=1300.;
    cast_ground_cast(&mut low,a);cast_ground_cast(&mut high,aa);
    assert_eq!(low.ezreal_r.pending[&a].flight.cast_ground_seed,
        high.ezreal_r.pending[&aa].flight.cast_ground_seed);
    let frozen=low.ezreal_r.pending[&a].flight.vertical.clone().unwrap();
    let identity=low.ezreal_r.pending[&a].flight.shot.view().identity;
    let origin=cast_ground_origin();
    let y=frozen.current_y(identity,30,origin).unwrap();
    let upper=high.ezreal_r.pending[&aa].flight.vertical.as_ref().unwrap()
        .current_y(identity,30,origin).unwrap();
    assert!((upper-y-1000.).abs()<0.001,"model root Y must not become dense cast Y");
    until(&mut low,29);
    // Y/heading alone do not interrupt current gameplay. This named local
    // policy retains CAST root/heading, not an invented release-time observation.
    low.players.get_mut(&a).unwrap().height=-999.;
    low.players.get_mut(&a).unwrap().facing=Some(entity_facing::Facing::from_yaw(-180.).unwrap());
    for _ in 0..3 { low.advance_ezreal_r(); assert_eq!(low.ezreal_r.pending[&a].flight.vertical,Ok(frozen.clone())); }
    until(&mut low,30);
    assert_eq!(low.ezreal_r.flights[0].vertical,Ok(frozen));
    assert_eq!(low.ezreal_r.flights[0].vertical.as_ref().unwrap().current_y(identity,30,origin),Some(y));
    low.players.get_mut(&a).unwrap().position.x+=900.;
    until(&mut low,31);
    let flight=&low.ezreal_r.flights[0];let view=flight.shot.view();
    assert!(flight.vertical.as_ref().unwrap().current_y(identity,31,view.position).is_some());
    assert_eq!(flight.vertical.as_ref().unwrap().current_y(identity,30,origin),None);
}

#[test]
fn vertical_release_nonfinite_actor_height_is_explicit_and_does_not_reject_paid_gameplay() {
    let (mut s,a,_) = cast_ground_game(true,cast_ground_origin());
    s.players.get_mut(&a).unwrap().height=f32::NAN;
    cast_ground_cast(&mut s,a);
    assert!(s.ezreal_r.pending[&a].flight.cast_ground_seed.is_ok());
    assert!(matches!(s.ezreal_r.pending[&a].flight.vertical,
        Err(VerticalUnavailable::Calculation(ezreal_r_vertical_local::Error::NonFiniteInput{field:"actor_root_y",..}))));
    assert_eq!(s.ezreal_r_faults().len(),1);assert_eq!(s.ezreal_r_faults()[0].stage,"vertical_release");
    assert_eq!(s.players[&a].mana,1900.);assert_eq!(s.players[&a].cooldowns[3],2400);
    until(&mut s,31);
    assert_eq!(s.ezreal_r.flights.len(),1);assert!(s.ezreal_r.flights[0].vertical.is_err());
    assert_ne!(s.ezreal_r.flights[0].shot.view().position,cast_ground_origin());
}

#[test]
fn vertical_update_failure_retires_only_height_and_faults_once() {
    let (mut s,a,b) = cast_ground_game(true,cast_ground_origin());
    cast_ground_cast(&mut s,a);until(&mut s,30);
    assert!(s.ezreal_r.flights[0].vertical.is_ok());
    // Inject a discontinuity into PRIVATE vertical state only. Geometry still
    // owns release tick30, so the next real height update must fail atomically.
    let view=s.ezreal_r.flights[0].shot.view();
    s.ezreal_r.flights[0].vertical.as_mut().unwrap().advance(view.identity,31,view.position,
        map10_dense_height::binding().unwrap().grid()).unwrap();
    until(&mut s,31);
    assert!(matches!(s.ezreal_r.flights[0].vertical,
        Err(VerticalUnavailable::Calculation(ezreal_r_vertical_local::Error::UnexpectedTick))));
    assert_ne!(s.ezreal_r.flights[0].shot.view().position,view.position);
    assert_eq!(s.ezreal_r_faults().iter().filter(|f|f.stage=="vertical_update").count(),1);
    until(&mut s,40);
    assert!(s.players[&b].health<10000.,"height failure must not suppress a real accepted hit");
    assert_eq!(s.ezreal_r_faults().iter().filter(|f|f.stage=="vertical_update").count(),1);
}

#[test]
fn vertical_height_retires_with_pending_interruptions_and_released_owner_lifecycle() {
    for interrupted in [true,false] {
        let (mut s,a,_) = cast_ground_game(true,cast_ground_origin());
        cast_ground_cast(&mut s,a);
        assert!(s.ezreal_r.pending[&a].flight.vertical.is_ok());
        if interrupted {
            s.players.get_mut(&a).unwrap().position.x+=1.;
            until(&mut s,30);
            assert!(s.ezreal_r.pending.is_empty() && s.ezreal_r.flights.is_empty());
        } else {
            until(&mut s,30);s.players.get_mut(&a).unwrap().health=0.;until(&mut s,31);
            let flight=&s.ezreal_r.flights[0];let view=flight.shot.view();
            assert!(flight.vertical.as_ref().unwrap().current_y(view.identity,s.tick,view.position).is_some());
            s.remove_player(a).unwrap();assert!(s.ezreal_r.flights.is_empty());
        }
    }
}

