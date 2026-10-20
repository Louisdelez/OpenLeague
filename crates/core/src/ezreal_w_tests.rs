use super::*;

fn game() -> (Simulation, u32, u32, u32) {
    let mut bytes=Vec::new();
    for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut sim=Simulation::new(nav).unwrap();sim.session=420;
    let owner=sim.join("ezreal").unwrap();let enemy=sim.join("garen").unwrap();let ally=sim.join("garen").unwrap();
    for(id,x)in[(owner,200.),(enemy,600.),(ally,900.)] {
        let p=sim.players.get_mut(&id).unwrap();p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=2;
    }
    sim.players.get_mut(&owner).unwrap().ranks=[1,1,0,0];
    (sim,owner,enemy,ally)
}
fn aim()->Point {Point{x:1800.,z:300.}}
fn cast(sim:&mut Simulation,owner:u32) {sim.command(owner,Action::CastAt{slot:1,point:aim()}).unwrap();}
fn until(sim:&mut Simulation,tick:u64) {while sim.tick<tick {sim.tick+=1;sim.advance_ezreal_q();sim.advance_ezreal_w();}}
fn state(sim:&Simulation)->String {format!("{:?}|{:?}|{:?}",sim.players,sim.ezreal_w,sim.attack_presentation.events())}
fn close(a:f32,b:f32) {assert!((a-b).abs()<0.005,"{a} != {b}");}

#[test]
fn primary_w_ranks_learning_and_corrupt_data_do_not_enable_e_r() {
    for rank in 1..=5 {
        let rule=rules(rank).unwrap();let i=rank as usize-1;
        assert_eq!((rule.base,rule.cost,rule.cooldown,rule.ap),([70.,115.,160.,205.,250.][i],[50.,60.,70.,80.,90.][i],9.,0.8));
        close(rule.attack_speed,[0.2,0.25,0.3,0.35,0.4][i]);
        let(mut sim,a,_,_)=game();sim.players.get_mut(&a).unwrap().ranks=[0,rank-1,0,0];sim.players.get_mut(&a).unwrap().level=2*rank-1;
        sim.command(a,Action::Learn{slot:1}).unwrap();assert_eq!(sim.players[&a].ranks[1],rank);
        assert!(sim.command(a,Action::Learn{slot:1}).is_err());
        for slot in [3] {assert_eq!(progression::next_rank(&sim.players[&a],slot).is_ok(),sim.players[&a].level>=6);assert_eq!(sim.cast(a,slot,None).unwrap_err(),"Ezreal R requires a ground point");}
    }
    for rank in [0,6,255] {assert!(rules(rank).is_err());}
    let text=include_str!("../../../data/4.20/native_spells_420.json");
    for case in 0..3 {
        let mut table:serde_json::Value=serde_json::from_str(text).unwrap();let rows=table.as_array_mut().unwrap();
        let index=rows.iter().position(|row|row["spell"]=="EzrealEssenceFlux").unwrap();
        if case==0 {rows[index]["values"].as_object_mut().unwrap().remove("Effect1Level1Amount");}
        else if case==1 {let extra=rows[index].clone();rows.push(extra);}
        else {rows[index]["values"]["Coefficient"]=serde_json::json!("NaN");}
        assert!(parse(&table.to_string()).is_err());
    }
}

#[test]
fn invalid_casts_are_atomic_and_a_real_cast_commits_resources_and_prepared_shot_once() {
    for case in 0..11 {
        let(mut sim,a,b,_)=game();let mut point=aim();
        match case {
            0=>sim.players.get_mut(&a).unwrap().ranks[1]=0,
            1=>sim.players.get_mut(&a).unwrap().mana=49.,
            2=>sim.players.get_mut(&a).unwrap().mana=f32::NAN,
            3=>sim.players.get_mut(&a).unwrap().effects.silence_until=1,
            4=>sim.players.get_mut(&a).unwrap().cooldowns[1]=1,
            5=>point=sim.players[&a].position,
            6=>point.x=f32::NAN,
            7=>sim.grant_stun(Some(b),a,"fixture",30).unwrap(),
            8=>sim.ezreal_w.next_ordinal=u64::MAX,
            9=>sim.tick=u64::MAX-10,
            _=>{sim.command(a,Action::Attack{target:b}).unwrap();sim.advance_attacks();sim.players.get_mut(&a).unwrap().windup.as_mut().unwrap().cancelable=false;},
        }
        let before=state(&sim);assert!(sim.cast_at(a,1,point).is_err());assert_eq!(state(&sim),before);
    }
    let(mut sim,a,b,_)=game();sim.command(a,Action::Attack{target:b}).unwrap();sim.advance_attacks();
    let before=sim.players[&a].clone();cast(&mut sim,a);
    assert_eq!(sim.players[&a].mana,before.mana-50.);assert_eq!(sim.players[&a].cooldowns[1],270);
    assert_eq!(sim.players[&a].cooldown_totals[1],Some(270));assert!(sim.players[&a].windup.is_none());assert_eq!(sim.players[&a].attack_roll,None);
    assert_eq!(sim.ezreal_w.next_ordinal,2);assert_eq!(sim.ezreal_w.pending.len(),1);assert!(sim.ezreal_w.flights.is_empty());
    let before=state(&sim);assert!(sim.cast_at(a,1,aim()).is_err());assert_eq!(state(&sim),before);
    for target in [None,Some(b)] {let before=state(&sim);assert!(sim.cast(a,1,target).unwrap_err().contains("ground point"));assert_eq!(state(&sim),before);}
}

#[test]
fn release_pierces_enemy_and_ally_champions_once_but_never_hits_lane_units() {
    let(mut sim,a,b,c)=game();sim.enable_map10().unwrap();sim.units.clear();
    let minion=sim.spawn_unit("Blue_Minion_Basic","W ignored minion",1,Point{x:450.,z:300.},0.,0.,None,None).unwrap();
    let npc_health=sim.units[&minion].health;let hp=sim.players[&b].health;let ally_hp=sim.players[&c].health;
    let d=sim.join("garen").unwrap();let p=sim.players.get_mut(&d).unwrap();p.team=1;p.position=Point{x:1100.,z:300.};p.health=10000.;p.max_health=10000.;
    cast(&mut sim,a);until(&mut sim,7);assert_eq!(sim.players[&b].health,hp);assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);
    until(&mut sim,8);assert!(sim.players[&a].effects.ezreal_w.is_none());assert_eq!(sim.ezreal_w.flights.len(),1);assert_eq!(sim.players[&b].health,hp);
    until(&mut sim,28);assert!(sim.players[&b].health<hp);assert!(sim.players[&d].health<10000.);
    assert_eq!(sim.players[&c].health,ally_hp);close(sim.ezreal_w_attack_speed_bonus(c),0.2);assert_eq!(sim.units[&minion].health,npc_health);
    let damage=hp-sim.players[&b].health;let started=sim.ezreal_w.buffs[&c][0].starts;
    sim.advance_ezreal_w();assert_eq!(hp-sim.players[&b].health,damage);assert_eq!(sim.ezreal_w.buffs[&c][0].starts,started);
    until(&mut sim,50);assert_eq!(hp-sim.players[&b].health,damage);assert!(sim.ezreal_w.flights.is_empty());assert!(sim.ezreal_w_faults().is_empty());
}

#[test]
fn raw_ap_and_rank_freeze_while_common_magic_defense_and_shields_apply_at_contact() {
    let(mut sim,a,b,c)=game();sim.players.get_mut(&a).unwrap().inventory[0]=Some(1052);
    let raw=70.+0.8*sim.stats(a).ability_power;assert!(raw>70.);cast(&mut sim,a);
    sim.players.get_mut(&a).unwrap().inventory[0]=None;sim.players.get_mut(&a).unwrap().ranks[1]=5;
    sim.players.get_mut(&b).unwrap().inventory[0]=Some(1033);let mr=sim.stats(b).magic_resist;let hp=sim.players[&b].health;
    until(&mut sim,28);close(hp-sim.players[&b].health,raw*100./(100.+mr));close(sim.ezreal_w_attack_speed_bonus(c),0.2);
    let(mut sim,a,b,_)=game();sim.grant_shield(b,"W fixture",1000.,100).unwrap();let hp=sim.players[&b].health;
    cast(&mut sim,a);until(&mut sim,28);assert_eq!(sim.players[&b].health,hp);assert!(sim.players[&b].shields[0].remaining<1000.);
    assert!(sim.ezreal_w_faults().is_empty());assert!(sim.snapshot().ezreal_q_accepted_impacts.is_none());
}

#[test]
fn self_requires_exit_of_frozen_initial_disk_then_actual_repositioned_contact_without_replay() {
    let(mut sim,a,_,_)=game();cast(&mut sim,a);assert_eq!(sim.ezreal_w_attack_speed_bonus(a),0.);
    until(&mut sim,28);assert_eq!(sim.ezreal_w_attack_speed_bonus(a),0.);assert!(!sim.ezreal_w.buffs.contains_key(&a));
    let(mut sim,a,_,_)=game();cast(&mut sim,a);until(&mut sim,10);
    assert!(sim.ezreal_w.flights[0].self_armed);assert_eq!(sim.ezreal_w_attack_speed_bonus(a),0.);
    // Authoritative fixture reposition only: this implements neither E nor Flash.
    sim.players.get_mut(&a).unwrap().position=Point{x:950.,z:300.};until(&mut sim,25);
    close(sim.ezreal_w_attack_speed_bonus(a),0.2);let buff=sim.ezreal_w.buffs[&a][0];
    sim.players.get_mut(&a).unwrap().position=Point{x:1100.,z:300.};until(&mut sim,28);
    assert_eq!(sim.ezreal_w.buffs[&a].len(),1);assert_eq!(sim.ezreal_w.buffs[&a][0].starts,buff.starts);
    assert_eq!(sim.ezreal_w.buffs[&a][0].until,buff.until);until(&mut sim,buff.until);assert_eq!(sim.ezreal_w_attack_speed_bonus(a),0.);
}

#[test]
fn actual_allied_buff_uses_strongest_source_refreshes_once_and_expires_in_shared_attack_stats() {
    let(mut sim,a,_,c)=game();let second=sim.join("ezreal").unwrap();
    let team=sim.players[&a].team;let p=sim.players.get_mut(&second).unwrap();p.team=team;p.position=Point{x:200.,z:300.};p.health=10000.;p.mana=2000.;p.level=9;p.ranks[1]=5;
    let base=sim.stats(c).attack_cooldown_ticks;cast(&mut sim,a);cast(&mut sim,second);until(&mut sim,28);
    close(sim.ezreal_w_attack_speed_bonus(c),0.4);assert_eq!(sim.ezreal_w.buffs[&c].len(),2);assert!(sim.stats(c).attack_cooldown_ticks<base);assert!(sim.stats(c).attack_cooldown_ticks>=12);
    let old=sim.ezreal_w.buffs[&c].iter().find(|buff|buff.owner==a).unwrap().until;
    until(&mut sim,40);sim.players.get_mut(&a).unwrap().cooldowns[1]=0;cast(&mut sim,a);until(&mut sim,68);
    assert_eq!(sim.ezreal_w.buffs[&c].len(),2);let refreshed=*sim.ezreal_w.buffs[&c].iter().find(|buff|buff.owner==a).unwrap();assert!(refreshed.until>old);
    sim.remove_player(second);close(sim.ezreal_w_attack_speed_bonus(c),0.2);
    until(&mut sim,refreshed.until);assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);assert_eq!(sim.stats(c).attack_cooldown_ticks,base);
}

#[test]
fn pending_death_released_death_departure_session_and_terminal_cleanup_are_distinct() {
    let(mut sim,a,_,c)=game();cast(&mut sim,a);sim.players.get_mut(&a).unwrap().health=0.;until(&mut sim,8);
    assert!(sim.ezreal_w.pending.is_empty()&&sim.ezreal_w.flights.is_empty());assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);
    let(mut sim,a,_,c)=game();cast(&mut sim,a);until(&mut sim,8);sim.players.get_mut(&a).unwrap().health=0.;until(&mut sim,28);
    close(sim.ezreal_w_attack_speed_bonus(c),0.2);sim.remove_player(a);assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);
    let(mut sim,a,_,c)=game();cast(&mut sim,a);until(&mut sim,28);sim.session+=1;
    assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);sim.advance_ezreal_w();assert!(sim.ezreal_w.buffs.is_empty());
    let(mut sim,a,_,c)=game();cast(&mut sim,a);until(&mut sim,28);sim.winner=Some(0);sim.advance_ezreal_w();
    assert!(sim.ezreal_w.buffs.is_empty()&&sim.ezreal_w.flights.is_empty());assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);
    let(mut sim,a,_,c)=game();cast(&mut sim,a);until(&mut sim,28);sim.players.get_mut(&c).unwrap().health=0.;
    assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);sim.tick+=1;sim.advance_ezreal_w();assert!(!sim.ezreal_w.buffs.contains_key(&c));
    let(mut sim,a,_,c)=game();cast(&mut sim,a);until(&mut sim,28);
    sim.navigation=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let p=sim.players.get_mut(&c).unwrap();p.health=0.;p.respawn_at=Some(sim.tick);
    sim.advance_respawns();assert!(sim.players[&c].health>0.);assert!(!sim.ezreal_w.buffs.contains_key(&c));assert_eq!(sim.ezreal_w_attack_speed_bonus(c),0.);
}

#[test]
fn failed_or_skipped_geometry_never_retries_contacts_and_buff_capacity_is_atomic() {
    let(mut sim,a,b,c)=game();cast(&mut sim,a);sim.tick=9;sim.advance_ezreal_w();
    assert!(sim.ezreal_w.pending.is_empty()&&sim.ezreal_w.flights.is_empty());assert!(sim.players[&a].effects.ezreal_w.is_none());assert_eq!(sim.ezreal_w_faults()[0].stage,"release");
    let(mut sim,a,b,c)=game();cast(&mut sim,a);until(&mut sim,8);let hp=sim.players[&b].health;sim.players.get_mut(&c).unwrap().position.x=f32::NAN;
    until(&mut sim,9);assert!(sim.ezreal_w.flights.is_empty());assert_eq!(sim.players[&b].health,hp);assert!(sim.ezreal_w.buffs.is_empty());assert_eq!(sim.ezreal_w_faults()[0].stage,"advance");
    sim.players.get_mut(&c).unwrap().position=Point{x:900.,z:300.};until(&mut sim,28);assert_eq!(sim.players[&b].health,hp);
    let identity=Identity{session:sim.session,owner:a,team:sim.players[&a].team,ordinal:100};
    let entries:Vec<_>=(1000..1006).map(|owner|Buff{session:sim.session,owner,team:identity.team,rank:1,starts:sim.tick,until:sim.tick+BUFF_TICKS}).collect();
    sim.ezreal_w.buffs.insert(c,entries);let before=format!("{:?}",sim.ezreal_w);
    assert!(sim.grant_ezreal_w_buff(c,identity,1).is_err());assert_eq!(format!("{:?}",sim.ezreal_w),before);
}

#[test]
fn q_w_cast_locks_are_mutually_exclusive_and_existing_q_hit_refunds_real_w_cooldown() {
    let(mut sim,a,_,_)=game();cast(&mut sim,a);let before=state(&sim);
    assert!(sim.cast_at(a,0,aim()).is_err());assert_eq!(state(&sim),before);
    until(&mut sim,8);sim.cast_at(a,0,aim()).unwrap();let before=state(&sim);
    assert!(sim.cast_at(a,1,aim()).is_err());assert_eq!(state(&sim),before);
    until(&mut sim,35);assert_eq!(sim.players[&a].cooldowns[1],240);assert!(sim.ezreal_q_faults().is_empty());
    let(mut sim,a,_,_)=game();sim.cast_at(a,0,aim()).unwrap();let before=state(&sim);
    assert!(sim.cast_at(a,1,aim()).is_err());assert_eq!(state(&sim),before);
}

#[test]
fn w_cast_projection_is_current_visible_read_only_and_preserves_committed_controls() {
    let(mut sim,a,b,_)=game();sim.tick=100;cast(&mut sim,a);
    let before=state(&sim);let rows=sim.snapshot_for(b).unwrap().ezreal_w_casts;
    assert_eq!(rows.len(),1);assert_eq!(rows[0].releases,108);assert_eq!(rows[0].ordinal,1);
    assert_eq!(rows[0].direction,Point{x:1.,z:0.});assert_eq!(state(&sim),before);
    assert!(sim.snapshot().ezreal_w_casts.is_empty());
    for mode in 0..3 {
        let(mut sim,a,b,_)=game();sim.tick=100;cast(&mut sim,a);sim.tick=101;
        let p=sim.players.get_mut(&a).unwrap();
        match mode {0=>p.stuns.push(stuns::Stun{tag:"W committed".into(),source:Some(b),expires_at:120}),
            1=>p.effects.silence_until=120,
            _=>{p.effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:101,until:112});p.position.z+=10.;}}
        let before=state(&sim);assert_eq!(sim.ezreal_w_cast_projection(b).len(),1);assert_eq!(state(&sim),before);
        until(&mut sim,108);assert!(sim.ezreal_w_cast_projection(b).is_empty());
        assert_eq!(sim.ezreal_w.flights.len(),1,"presentation must preserve committed release");
    }
}

#[test]
fn w_cast_projection_fog_death_session_and_release_remove_without_history_or_mutation() {
    let(mut sim,a,b,c)=game();sim.enable_map10().unwrap();sim.units.clear();
    sim.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};
    sim.players.get_mut(&c).unwrap().position=Point{x:3500.,z:3000.};cast(&mut sim,a);
    assert!(!sim.visible_to(1,a));assert!(sim.ezreal_w_cast_projection(b).is_empty());
    assert_eq!(sim.ezreal_w_cast_projection(a).len(),1);
    sim.players.get_mut(&b).unwrap().position=Point{x:300.,z:300.};assert_eq!(sim.ezreal_w_cast_projection(b).len(),1);
    sim.players.get_mut(&a).unwrap().health=0.;assert!(sim.ezreal_w_cast_projection(b).is_empty());
    sim.players.get_mut(&a).unwrap().health=100.;sim.tick=8;assert!(sim.ezreal_w_cast_projection(b).is_empty());
    sim.tick=0;sim.session+=1;let before=state(&sim);assert!(sim.ezreal_w_cast_projection(b).is_empty());assert_eq!(state(&sim),before);
}

#[test]
fn w_cast_projection_rejects_corrupt_census_and_overflow_without_partial_prefix() {
    for mode in 0..12 {
        let(mut sim,a,b,_)=game();let other=sim.join("ezreal").unwrap();
        let p=sim.players.get_mut(&other).unwrap();p.ranks[1]=1;p.mana=2000.;p.position=Point{x:200.,z:500.};
        cast(&mut sim,a);cast(&mut sim,other);
        match mode {
            0=>sim.ezreal_w.pending.get_mut(&other).unwrap().releases=7,
            1=>sim.ezreal_w.pending.get_mut(&other).unwrap().releases=u64::MAX,
            2=>sim.ezreal_w.pending.get_mut(&other).unwrap().flight.direction.x=f32::NAN,
            3=>sim.ezreal_w.pending.get_mut(&other).unwrap().flight.direction=Point{x:0.,z:0.},
            4=>sim.ezreal_w.pending.get_mut(&other).unwrap().flight.self_armed=true,
            5=>sim.ezreal_w.pending.get_mut(&other).unwrap().flight.raw=f32::INFINITY,
            6=>sim.players.get_mut(&other).unwrap().effects.ezreal_w.as_mut().unwrap().direction=Point{x:0.,z:1.},
            7=>sim.players.get_mut(&other).unwrap().id=9999,
            8=>sim.players.get_mut(&other).unwrap().health=f32::NAN,
            9=>sim.ezreal_w.next_ordinal=0,
            10=>sim.ezreal_w.last_advanced=Some(1),
            _=>{let shot=&mut sim.ezreal_w.pending.get_mut(&other).unwrap().flight.shot;shot.cancel(shot.view().identity).unwrap();},
        }
        let before=state(&sim);assert!(sim.ezreal_w_cast_projection(b).is_empty(),"case{mode}");assert_eq!(state(&sim),before);
    }
}

#[test]
fn w_cast_projection_duplicate_ordinals_and_budget_fail_closed() {
    let(mut sim,a,b,_)=game();cast(&mut sim,a);let identity=sim.ezreal_w.pending[&a].flight.shot.view().identity;
    let make=|id,origin|Flight{shot:Shot::new(id,origin,aim(),Params{speed_units_per_second:SPEED,tick_rate:TICK_RATE as u32,
        max_distance:RANGE,projectile_radius:RADIUS,launch_tick:8,expires_at_tick:29,mode:Mode::Pierce,
        limits:Limits{targets_per_step:MAX_TARGETS,unique_hits:MAX_TARGETS}}).unwrap(),raw:70.,rank:1,
        origin,initial_owner_radius:65.,self_armed:false,direction:Point{x:1.,z:0.}};
    let other=sim.join("ezreal").unwrap();let origin=Point{x:200.,z:300.};
    let p=sim.players.get_mut(&other).unwrap();p.position=origin;p.effects.ezreal_w=Some(CastLock{releases:8,direction:Point{x:1.,z:0.}});
    let team=p.team;sim.ezreal_w.pending.insert(other,Pending{flight:make(Identity{owner:other,team,..identity},origin),releases:8});
    assert!(sim.ezreal_w_cast_projection(b).is_empty());sim.ezreal_w.pending.remove(&other);
    for n in 0..MAX_CASTS {sim.ezreal_w.flights.push(make(Identity{ordinal:n as u64+20,..identity},origin));}
    assert!(sim.ezreal_w_cast_projection(b).is_empty());
}

#[test]
fn w_cast_optional_wire_roundtrip_preserves_full_identity_and_legacy_default() {
    let(mut sim,a,_,_)=game();sim.session=u64::MAX-100;sim.tick=(1u64<<53)+100;
    sim.ezreal_w.next_ordinal=(1u64<<53)+5;cast(&mut sim,a);let mut snapshot=sim.snapshot_for(a).unwrap();
    let row=snapshot.ezreal_w_casts[0];assert!(row.ordinal>1u64<<53);
    let mut legacy=serde_json::to_value(&snapshot).unwrap();legacy.as_object_mut().unwrap().remove("ezreal_w_casts");
    assert!(serde_json::from_value::<Snapshot>(legacy).unwrap().ezreal_w_casts.is_empty());
    snapshot.ezreal_w_casts=(0..MAX_CASTS).map(|n|VisibleCast{ordinal:row.ordinal+n as u64,..row}).collect();
    let context=crate::session_transport::Context{session:sim.session,player:a,epoch:u64::MAX-10};
    let mut sender=crate::session_wire::Sender::new(context).unwrap();let packets=sender.encode(&snapshot,11).unwrap();
    assert!(packets.iter().all(|p|p.len()<=1200));let mut receiver=crate::session_wire::Assembler::new(context).unwrap();let mut result=None;
    for packet in packets.iter().rev(){if let Some(frame)=receiver.push(packet).unwrap(){result=Some(frame);}}
    let decoded=result.unwrap().decode().unwrap();assert_eq!(decoded.snapshot.ezreal_w_casts,snapshot.ezreal_w_casts);
    assert_eq!(decoded.clock_ordinal,11);
    let packets=crate::wire::state_datagrams(&snapshot).unwrap();assert!(packets.iter().all(|p|p.len()<=1200));
    let mut legacy=crate::wire::StateAssembler::default();let mut result=None;
    for packet in packets.iter().rev(){if let Some(bytes)=legacy.push(packet,Some(sim.session)){result=Some(bytes);}}
    let ServerPacket::State(decoded)=serde_json::from_slice(&result.unwrap()).unwrap()else{panic!("State required")};
    assert_eq!(decoded.ezreal_w_casts,snapshot.ezreal_w_casts);
}
