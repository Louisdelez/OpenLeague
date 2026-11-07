use super::*;

fn game() -> (Simulation,u32,u32) {
    let mut bytes=Vec::new();
    for _ in 0..3200 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":40}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    s.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};
    s.players.get_mut(&b).unwrap().position=Point{x:600.,z:300.};
    s.command(a,Action::Learn{slot:0}).unwrap();(s,a,b)
}
fn aim() -> Point {Point{x:1800.,z:300.}}
fn cast(s:&mut Simulation,a:u32) {s.command(a,Action::CastAt{slot:0,point:aim()}).unwrap();}
fn until(s:&mut Simulation,tick:u64) {while s.tick<tick {s.tick+=1;s.advance_ezreal_q();}}
fn state(s:&Simulation)->String {
    // Public snapshot omits cached rolls and paths; preserve their actual Debug
    // state as well as the private shot issuer and attack presentation evidence.
    format!("{:?}|{:?}|{:?}|{:?}",s.players,s.ezreal_q,s.attack_presentation.events(),s.attack_presentation_error)
}
fn rejected(s:&mut Simulation,a:u32,point:Point) {
    let before=state(s);assert!(s.command(a,Action::CastAt{slot:0,point}).is_err());assert_eq!(state(s),before);
}
fn raw(s:&Simulation,a:u32,rank:u8)->f32 {let q=rules(rank).unwrap();q.base+1.1*s.stats(a).damage+0.4*s.stats(a).ability_power}

#[test]
fn only_q_progression_is_admitted_and_targeted_cast_cannot_replace_ground_intent() {
    let(mut s,a,b)=game();
    for slot in 3..=3 {
        s.players.get_mut(&a).unwrap().level=18;
        let before=state(&s);assert_eq!(progression::next_rank(&s.players[&a],slot).unwrap(),1);assert_eq!(state(&s),before);
        assert_eq!(s.command(a,Action::CastAt{slot,point:aim()}).unwrap_err(),"Ezreal R rank out of range");assert_eq!(state(&s),before);
    }
    for target in [None,Some(b)] {let before=state(&s);assert_eq!(s.command(a,Action::Cast{slot:0,target}).unwrap_err(),"Ezreal Q requires a ground point");assert_eq!(state(&s),before);}
    for rank in 2..=5 {s.players.get_mut(&a).unwrap().level=2*rank-1;s.command(a,Action::Learn{slot:0}).unwrap();assert_eq!(s.players[&a].ranks[0],rank);}
    assert!(s.learn(a,0).is_err());
}

#[test]
fn rejected_geometry_mana_stats_and_uncancellable_attack_preserve_all_cast_state() {
    let(mut s,a,b)=game();
    for point in [s.players[&a].position,Point{x:f32::NAN,z:0.},Point{x:0.,z:f32::INFINITY}] {rejected(&mut s,a,point);}
    for mana in [27.,f32::NAN,f32::INFINITY] {s.players.get_mut(&a).unwrap().mana=mana;rejected(&mut s,a,aim());}
    s.players.get_mut(&a).unwrap().mana=500.;
    for ad in [f32::NAN,f32::INFINITY,f32::MAX] {s.definitions.get_mut("ezreal").unwrap().attack_damage=ad;rejected(&mut s,a,aim());}
    s.definitions.get_mut("ezreal").unwrap().attack_damage=50.;
    let p=s.players.get_mut(&a).unwrap();p.windup=Some(attacks::Windup{target:b,started:0,release:20,cancelable:false,critical:true,presentation:None});p.attack_roll=Some(true);
    rejected(&mut s,a,aim());assert_eq!(s.players[&a].attack_roll,Some(true));
}

#[test]
fn rejected_control_rank_cooldown_pending_and_unknown_owner_are_atomic() {
    for mode in 0..6 {
        let(mut s,a,b)=game();
        match mode {
            0=>s.players.get_mut(&a).unwrap().ranks[0]=0,
            1=>s.players.get_mut(&a).unwrap().effects.silence_until=10,
            2=>{s.grant_stun(Some(b),a,"test",30).unwrap();},
            3=>s.players.get_mut(&a).unwrap().cooldowns[0]=1,
            4=>s.players.get_mut(&a).unwrap().health=0.,
            _=>{cast(&mut s,a);s.players.get_mut(&a).unwrap().cooldowns[0]=0;},
        }
        rejected(&mut s,a,aim());
    }
    let(mut s,_,_)=game();let before=state(&s);assert!(s.command(999,Action::CastAt{slot:0,point:aim()}).is_err());assert_eq!(state(&s),before);
}

#[test]
fn ordinal_budget_session_transition_and_clock_overflows_reject_before_commit() {
    let(mut s,a,_)=game();s.ezreal_q.next_ordinal=u64::MAX;rejected(&mut s,a,aim());
    s.ezreal_q.next_ordinal=0;rejected(&mut s,a,aim());s.ezreal_q.next_ordinal=1;
    s.ezreal_q.session=Some(421);rejected(&mut s,a,aim());s.ezreal_q.session=None;
    s.tick=u64::MAX-1;rejected(&mut s,a,aim());
    s.tick=u64::MAX-26; //Rank5CD120 still rejects before shorter flight dates could commit.
    s.players.get_mut(&a).unwrap().ranks[0]=5;rejected(&mut s,a,aim());
    // Explicit resource limit, using fully prepared pending+flying casts rather
    // than truncating the target census or wrapping the issuer.
    let(mut s,a,_)=game();
    for _ in 0..MAX_CASTS {cast(&mut s,a);let p=s.ezreal_q.pending.remove(&a).unwrap();s.ezreal_q.flights.push(p.flight);s.players.get_mut(&a).unwrap().effects.ezreal_q=None;s.players.get_mut(&a).unwrap().cooldowns[0]=0;s.players.get_mut(&a).unwrap().mana=500.;}
    rejected(&mut s,a,aim());assert_eq!(s.ezreal_q.flights.len(),MAX_CASTS);
}

#[test]
fn each_primary_rank_freezes_damage_origin_direction_cost_and_committed_cdr() {
    for rank in 1..=5 {
        let(mut s,a,b)=game();let p=s.players.get_mut(&a).unwrap();p.ranks[0]=rank;p.mana=500.;p.inventory[0]=Some(3108);
        let expected=raw(&s,a,rank);let cd=cooldown::ticks([6.,5.5,5.,4.5,4.][rank as usize-1],0.1);
        let hp=s.players[&b].health;let armor=s.stats(b).armor;
        cast(&mut s,a);assert_eq!(s.players[&a].mana,500.-[28.,31.,34.,37.,40.][rank as usize-1]);
        assert_eq!(s.players[&a].cooldowns[0],cd);assert_eq!(s.players[&a].cooldown_totals[0],Some(cd));
        s.players.get_mut(&a).unwrap().inventory=[None;6];s.definitions.get_mut("ezreal").unwrap().attack_damage=5000.;
        s.players.get_mut(&a).unwrap().position=Point{x:200.,z:800.};
        until(&mut s,20);assert!((hp-s.players[&b].health-damage::mitigate(expected,damage::DamageKind::Physical,armor,0.,1.).unwrap()).abs()<0.001);
        assert_eq!(s.players[&a].cooldowns[0],cd-30);assert_eq!(s.players[&a].cooldown_totals[0],Some(cd));
        assert!(s.ezreal_q.faults.is_empty());
    }
}

#[test]
fn cast_raw_is_frozen_but_shared_penetration_exhaust_and_target_defenses_are_sampled_on_contact() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};
    let frozen=raw(&s,a,1);cast(&mut s,a);until(&mut s,8);
    // New AD must not change the frozen raw, while the common damage pipeline
    // deliberately reads this new item's penetration at impact.
    s.players.get_mut(&a).unwrap().inventory[0]=Some(3134);
    s.players.get_mut(&a).unwrap().effects.exhaust_until=100;
    s.definitions.get_mut("garen").unwrap().armor=100.;
    let armor=s.stats(b).armor;let outgoing=frozen*s.exhaust_damage_multiplier(Some(a),damage::DamageKind::Physical);
    let expected=damage::mitigate(outgoing,damage::DamageKind::Physical,penetration::effective(armor,10.,0.).unwrap(),0.,1.).unwrap();
    let hp=s.players[&b].health;until(&mut s,9);assert!((hp-s.players[&b].health-expected).abs()<0.001);
    assert!(raw(&s,a,1)>frozen);assert!(s.ezreal_q_faults().is_empty());
}

#[test]
fn actual_simulation_phase_holds_motion_and_attacks_during_committed_windup() {
    let(mut s,a,b)=game();s.command(a,Action::Move{point:Point{x:1000.,z:300.}}).unwrap();cast(&mut s,a);
    let origin=s.players[&a].position;
    // New orders may replace intent, but cannot move or attack before release.
    s.command(a,Action::Attack{target:b}).unwrap();
    for _ in 0..7 {s.advance();assert_eq!(s.players[&a].position,origin);assert!(s.players[&a].windup.is_none());assert!(s.projectiles.is_empty());}
    s.advance();assert!(s.players[&a].effects.ezreal_q.is_none());
    assert_eq!(s.snapshot().ezreal_q_projectiles[0].position,origin);
    // Mobility may resume in the release tick's later allied-motion phase.
    s.advance();assert!(s.snapshot().ezreal_q_projectiles[0].position.x>origin.x);
}

#[test]
fn release_has_no_contact_and_duplicate_phase_cannot_advance_or_hit_twice() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};let hp=s.players[&b].health;
    cast(&mut s,a);until(&mut s,7);assert!(s.ezreal_q.flights.is_empty());assert_eq!(s.players[&b].health,hp);
    until(&mut s,8);assert_eq!(s.ezreal_q.flights.len(),1);assert_eq!(s.players[&b].health,hp);
    let before=state(&s);s.advance_ezreal_q();assert_eq!(state(&s),before);
    until(&mut s,9);assert!(s.ezreal_q.flights.is_empty());assert!(s.players[&b].health<hp);
    let hp=s.players[&b].health;let cd=s.players[&a].cooldowns;s.advance_ezreal_q();until(&mut s,20);assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
}

#[test]
fn first_contact_uses_swept_current_circles_once_and_skips_allies() {
    let(mut s,a,b)=game();let ally=s.join("annie").unwrap();let second=s.join("annie").unwrap();
    s.players.get_mut(&ally).unwrap().position=Point{x:220.,z:300.};
    s.players.get_mut(&b).unwrap().position=Point{x:800.,z:300.};s.players.get_mut(&second).unwrap().position=Point{x:950.,z:300.};
    let ally_hp=s.players[&ally].health;let hp=s.players[&b].health;let second_hp=s.players[&second].health;
    cast(&mut s,a);until(&mut s,8);
    // Target enters a sampled step after launch; a homing target ID was never captured.
    s.players.get_mut(&b).unwrap().position=Point{x:400.,z:300.};until(&mut s,26);
    assert!(s.players[&b].health<hp);assert_eq!(s.players[&second].health,second_hp);assert_eq!(s.players[&ally].health,ally_hp);assert!(s.ezreal_q.flights.is_empty());
}

#[test]
fn miss_exhausts_exact_local_range_without_cooldown_refund() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:2000.,z:300.};let hp=s.players[&b].health;
    cast(&mut s,a);let cd=s.players[&a].cooldowns;until(&mut s,25);
    assert_eq!(s.ezreal_q.flights.len(),1);assert!((s.ezreal_q.flights[0].shot.view().traveled-17.*2000./30.).abs()<0.00001);
    until(&mut s,26);assert!(s.ezreal_q.flights.is_empty());assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
}

#[test]
fn full_shield_is_an_accepted_impact_and_refunds_all_four_deadlines_only_once() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};s.grant_shield(b,"Q shield",10000.,100).unwrap();
    let hp=s.players[&b].health;cast(&mut s,a);
    let p=s.players.get_mut(&a).unwrap();p.cooldowns=[180,50,20,0];p.cooldown_totals=[Some(180),Some(50),Some(20),None];
    let totals=p.cooldown_totals;let summoners=p.summoners.ready_at;
    until(&mut s,9);assert_eq!(s.players[&b].health,hp);assert!(s.players[&b].shields[0].remaining<10000.);
    assert_eq!(s.players[&a].cooldowns,[150,20,9,0]);assert_eq!(s.players[&a].cooldown_totals,totals);assert_eq!(s.players[&a].summoners.ready_at,summoners);
    let cd=s.players[&a].cooldowns;until(&mut s,20);assert_eq!(s.players[&a].cooldowns,cd);
}

#[test]
fn two_real_flights_refund_the_current_new_cast_deadline_without_reapplying_cdr() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:800.,z:300.};
    s.grant_shield(b,"both Q",10000.,100).unwrap();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);
    cast(&mut s,a);until(&mut s,8);
    s.players.get_mut(&a).unwrap().cooldowns[0]=0;cast(&mut s,a);
    let second_ready=s.players[&a].cooldowns[0];let total=s.players[&a].cooldown_totals[0];
    assert_eq!(second_ready,8+162);until(&mut s,16);assert_eq!(s.players[&a].cooldowns[0],second_ready-30);
    until(&mut s,24);assert_eq!(s.players[&a].cooldowns[0],second_ready-60);
    assert_eq!(s.players[&a].cooldown_totals[0],total);assert!(s.ezreal_q.flights.is_empty());
    until(&mut s,30);assert_eq!(s.players[&a].cooldowns[0],second_ready-60);
}

#[test]
fn lethal_impact_uses_shared_rewards_once_and_does_not_add_a_basic_attack() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};s.players.get_mut(&b).unwrap().health=1.;
    let gold=s.players[&a].gold;cast(&mut s,a);until(&mut s,9);
    assert_eq!(s.players[&b].health,0.);assert_eq!(s.players[&a].score.kills,1);assert!(s.players[&a].gold>gold);
    assert_eq!(s.kill_rewards.events.len(),1);assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(a));
    assert!(s.projectiles.is_empty());assert!(s.players[&a].windup.is_none());
    let gold=s.players[&a].gold;until(&mut s,30);assert_eq!(s.players[&a].gold,gold);assert_eq!(s.kill_rewards.events.len(),1);
}

#[test]
fn rejected_impact_is_terminal_records_fault_and_cannot_create_hidden_kill_credit() {
    let(mut s,a,b)=game();let contributor=s.join("annie").unwrap();
    s.players.get_mut(&b).unwrap().position=Point{x:250.,z:300.};
    s.players.get_mut(&contributor).unwrap().position=Point{x:200.,z:900.};
    s.apply_damage(Some(contributor),b,1.,damage::DamageKind::True).unwrap();
    cast(&mut s,a);let cd=s.players[&a].cooldowns;let gold=s.players[&a].gold;let xp=s.players[&a].experience;
    until(&mut s,8);s.definitions.get_mut("garen").unwrap().armor=f32::NAN;
    let hp=s.players[&b].health;until(&mut s,9);assert!(s.ezreal_q.flights.is_empty());assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
    assert_eq!(s.ezreal_q_faults().len(),1);assert_eq!(s.ezreal_q_faults()[0].stage,"impact");assert_eq!(s.ezreal_q_faults()[0].reason,"invalid penetration/armor");
    s.definitions.get_mut("garen").unwrap().armor=20.;until(&mut s,20);
    assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
    s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();
    assert_eq!(s.players[&a].score.kills,0);assert_eq!(s.players[&a].score.assists,0);assert_eq!(s.players[&a].gold,gold);assert_eq!(s.players[&a].experience,xp);
    assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(contributor));
}

#[test]
fn owner_death_cancels_pending_but_released_flight_survives_and_departure_cancels_it() {
    for launched in [false,true] {
        let(mut s,a,b)=game();cast(&mut s,a);if launched {until(&mut s,8);}
        s.apply_damage(Some(b),a,10000.,damage::DamageKind::True).unwrap();let hp=s.players[&b].health;
        until(&mut s,20);
        assert!(s.ezreal_q.pending.is_empty());assert!(s.ezreal_q.flights.is_empty());
        assert_eq!(s.players[&b].health<hp,launched);
    }
    for launched in [false,true] {
        let(mut s,a,b)=game();cast(&mut s,a);if launched {until(&mut s,8);}
        let hp=s.players[&b].health;s.remove_player(a).unwrap();assert!(s.ezreal_q.pending.is_empty());assert!(s.ezreal_q.flights.is_empty());
        until(&mut s,20);assert_eq!(s.players[&b].health,hp);
        let replacement=s.join("ezreal").unwrap();assert_ne!(replacement,a);
    }
}

#[test]
fn session_change_and_match_end_retire_pending_and_flying_without_effect_or_refund() {
    for launched in [false,true] {for ended in [false,true] {
        let(mut s,a,b)=game();cast(&mut s,a);if launched {until(&mut s,8);}
        let hp=s.players[&b].health;let cd=s.players[&a].cooldowns;
        if ended {s.winner=Some(0);s.advance();} else {s.session+=1;s.tick+=1;s.advance_ezreal_q();}
        assert!(s.ezreal_q.pending.is_empty());assert!(s.ezreal_q.flights.is_empty());assert!(s.players[&a].effects.ezreal_q.is_none());
        assert!(s.snapshot().ezreal_q_projectiles.is_empty());assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
    }}
}

#[test]
fn skipped_tick_is_a_terminal_diagnostic_and_never_catches_up_or_retries() {
    for launched in [false,true] {
        let(mut s,a,b)=game();cast(&mut s,a);if launched {until(&mut s,8);}
        let hp=s.players[&b].health;let cd=s.players[&a].cooldowns;s.tick=10;s.advance_ezreal_q();
        assert!(s.ezreal_q.pending.is_empty());assert!(s.ezreal_q.flights.is_empty());assert_eq!(s.ezreal_q_faults().len(),1);
        assert_eq!(s.ezreal_q_faults()[0].stage,if launched {"advance"} else {"release"});
        until(&mut s,30);assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
    }
}

#[test]
fn invalid_circle_and_oversized_target_census_cancel_without_partial_hit_or_truncation() {
    for over_budget in [false,true] {
        let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);let hp=s.players[&b].health;let cd=s.players[&a].cooldowns;
        if over_budget {
            let template=s.players[&b].clone();
            for id in 100..100+MAX_TARGETS as u32 {let mut p=template.clone();p.id=id;s.players.insert(id,p);}
        } else {s.players.get_mut(&b).unwrap().position.x=f32::NAN;}
        until(&mut s,9);assert!(s.ezreal_q.flights.is_empty());assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].cooldowns,cd);
        assert_eq!(s.ezreal_q_faults().len(),1);assert_eq!(s.ezreal_q_faults()[0].stage,if over_budget {"census"} else {"advance"});
        assert!(s.kill_rewards.events.is_empty());
    }
}

#[test]
fn configured_enemy_lane_monster_and_exact_tibbers_are_supported_but_boss_buildings_other_pets_are_not() {
    for kind in [world::Kind::Melee,world::Kind::Monster,world::Kind::Pet,world::Kind::Boss,world::Kind::Turret] {
        let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();s.players.get_mut(&b).unwrap().position=Point{x:1800.,z:1200.};
        let def=if kind==world::Kind::Pet {"annietibbers"} else {"Blue_Minion_Basic"};
        let id=s.spawn_unit(def,"Q test",1,Point{x:300.,z:300.},0.,0.,None,None).unwrap();
        s.units.get_mut(&id).unwrap().kind=kind;s.world.as_mut().unwrap().config.definitions.get_mut(def).unwrap().kind=kind;
        if kind==world::Kind::Pet {let owner=s.join("annie").unwrap();s.players.get_mut(&owner).unwrap().team=1;s.units.get_mut(&id).unwrap().pet=Some(annie_r::Pet{owner,rank:1,spawned:0,expires:100,next_aura:100,order:annie_r::Order::Follow,molten_until:0,molten_rank:0});}
        let hp=s.units[&id].health;cast(&mut s,a);until(&mut s,26);
        assert_eq!(s.units[&id].health<hp,matches!(kind,world::Kind::Melee|world::Kind::Monster|world::Kind::Pet),"{kind:?}");
    }
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();s.players.get_mut(&b).unwrap().position=Point{x:1800.,z:1200.};
    let pet=s.spawn_unit("annietibbers","wrong pet",1,Point{x:300.,z:300.},0.,0.,None,None).unwrap();let hp=s.units[&pet].health;
    assert!(s.units[&pet].pet.is_none());cast(&mut s,a);until(&mut s,26);assert_eq!(s.units[&pet].health,hp);
}

#[test]
fn flight_snapshot_defaults_roundtrip_fragment_and_single_team_fog_filter_do_not_leak_hidden_shots() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);
    let snapshot=s.snapshot_for(a).unwrap();assert_eq!(snapshot.ezreal_q_projectiles.len(),1);
    let mut assembler=wire::StateAssembler::default();let mut decoded=None;
    for d in wire::state_datagrams(&snapshot).unwrap().iter().rev() {assert!(d.len()<=1200);if let Some(bytes)=assembler.push(d,Some(s.session)){decoded=Some(bytes);}}
    let ServerPacket::State(round):ServerPacket=serde_json::from_slice(&decoded.unwrap()).unwrap() else {panic!("state");};
    assert_eq!(round.ezreal_q_projectiles,snapshot.ezreal_q_projectiles);
    let mut legacy=serde_json::to_value(&snapshot).unwrap();legacy.as_object_mut().unwrap().remove("ezreal_q_projectiles");
    let legacy:Snapshot=serde_json::from_value(legacy).unwrap();assert!(legacy.ezreal_q_projectiles.is_empty());
    s.enable_map10().unwrap();s.units.clear();s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:1800.};
    assert_eq!(s.snapshot_for(a).unwrap().ezreal_q_projectiles.len(),1);
    assert!(s.snapshot_for(b).unwrap().ezreal_q_projectiles.is_empty());assert_eq!(s.snapshot().ezreal_q_projectiles.len(),1);
    // One observer seeing a projectile does not union that visibility into the other team.
    s.players.get_mut(&b).unwrap().position=Point{x:300.,z:300.};assert_eq!(s.snapshot_for(b).unwrap().ezreal_q_projectiles.len(),1);
    s.players.get_mut(&a).unwrap().position=Point{x:3500.,z:1800.};assert!(s.snapshot_for(b).unwrap().ezreal_q_projectiles.is_empty());
}
