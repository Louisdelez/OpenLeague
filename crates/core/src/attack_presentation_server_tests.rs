//! Integration tests for local presentation facts. Combat values are the existing
//! simulation's values, not a new claim about native Garen Q timing/cancellation.
use crate::*;
use attack_presentation::{Attack, CancelReason, Event, Kind, Phase};

fn game(name: &str) -> (Simulation, u32, u32) {
    let mut bytes = Vec::new();
    for _ in 0..400 {
        bytes.extend(0f32.to_le_bytes()); bytes.extend(0u16.to_le_bytes());
        bytes.extend(0u32.to_le_bytes()); bytes.push(1);
    }
    let navigation = Navigation::load(
        r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#, &bytes).unwrap();
    let mut s = Simulation::new(navigation).unwrap();
    s.session = 41;
    let a = s.join(name).unwrap(); let b = s.join("garen").unwrap();
    s.players.get_mut(&a).unwrap().position = Point { x:100., z:100. };
    s.players.get_mut(&b).unwrap().position = Point { x:150., z:100. };
    // Explicit level/rank preconditions; no rank/cooldown progression is under test.
    s.players.get_mut(&a).unwrap().ranks = [1,1,1,1];
    (s,a,b)
}
fn begin(s: &mut Simulation, a:u32, b:u32) -> Attack {
    s.command(a, Action::Attack {target:b}).unwrap();
    s.tick += 1; s.advance_attacks();
    s.players[&a].windup.as_ref().unwrap().presentation.unwrap()
}
fn terminal(s:&Simulation, attack:Attack) -> Event {
    *s.snapshot().attack_events.iter().find(|event| event.attack == attack && !matches!(event.phase,Phase::Started{..})).unwrap()
}
fn started_kind(s:&Simulation,attack:Attack)->Kind {
    let event=*s.snapshot().attack_events.iter().find(|event|event.attack==attack&&matches!(event.phase,Phase::Started{..})).unwrap();
    let Phase::Started{kind}=event.phase else{unreachable!()};kind
}
fn cancelled(s:&Simulation, attack:Attack, reason:CancelReason) {
    assert_eq!(terminal(s,attack).phase,Phase::Cancelled{reason});
    assert_eq!(s.snapshot().attack_events.iter().filter(|e| e.attack.id==attack.id && !matches!(e.phase,Phase::Started{..})).count(),1);
    assert!(s.attack_presentation.active(attack.source).is_none());
    assert!(s.attack_presentation_error.is_none());
}
fn expected_damage(s:&Simulation,a:u32,b:u32,kind:Kind)->f32 {
    let stats=s.stats(a);
    let raw=match kind {Kind::GarenQ=>1.4*stats.damage+spells::garen_value(0,"Effect1",s.players[&a].ranks[0]),
        Kind::Critical=>stats.damage*stats.critical_multiplier,Kind::Basic=>stats.damage};
    damage::mitigate(raw,damage::DamageKind::Physical,s.stats(b).armor,s.stats(b).magic_resist,1.).unwrap()
}

#[test]
fn garen_presentation_q_only_attacks_and_preserves_current_timing_damage_and_next_basic() {
    let(mut s,a,b)=game("garen");
    s.cast(a,0,None).unwrap(); assert!(s.snapshot().attack_events.is_empty());
    s.advance(); assert!(s.snapshot().attack_events.is_empty());
    let hp=s.players[&b].health; let damage=expected_damage(&s,a,b,Kind::GarenQ);
    let attack=begin(&mut s,a,b);
    assert_eq!(started_kind(&s,attack),Kind::GarenQ);
    assert_eq!(attack.release-attack.started,attacks::windup_ticks("garen",s.stats(a).attack_cooldown_ticks));
    assert_eq!(s.players[&b].health,hp);
    s.tick=attack.release-1; s.advance_attacks(); assert_eq!(s.players[&b].health,hp);
    s.tick=attack.release; s.advance_attacks();
    assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::GarenQ,hit_succeeded:true});
    assert!((hp-s.players[&b].health-damage).abs()<0.001);
    assert_eq!(s.players[&a].effects.empowered_until,0);
    assert!(s.players[&a].windup.is_none());
    // Both events are retained even if no snapshot was transmitted during windup.
    assert_eq!(s.snapshot_for(a).unwrap().attack_events.len(),2);
    s.tick=s.players[&a].next_attack; s.advance_attacks();
    let next=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();
    assert!(next.id>attack.id); assert_eq!(started_kind(&s,next),Kind::Basic);
}

#[test]
fn garen_presentation_release_records_q_activation_and_expiry_without_freezing_damage() {
    // Critical was chosen at start; Q is activated while winding up and wins at release.
    let(mut s,a,b)=game("garen"); s.players.get_mut(&a).unwrap().attack_roll=Some(true);
    let attack=begin(&mut s,a,b); assert_eq!(started_kind(&s,attack),Kind::Critical);
    s.cast(a,0,None).unwrap(); let expected=expected_damage(&s,a,b,Kind::GarenQ); let hp=s.players[&b].health;
    s.tick=attack.release; s.advance_attacks();
    assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::GarenQ,hit_succeeded:true});
    assert!((hp-s.players[&b].health-expected).abs()<0.001);
    // Q started this attack, then expires. Existing saved critical=false remains unchanged.
    let(mut s,a,b)=game("garen"); s.cast(a,0,None).unwrap();
    let attack=begin(&mut s,a,b); s.players.get_mut(&a).unwrap().effects.empowered_until=attack.release;
    let expected=expected_damage(&s,a,b,Kind::Basic); let hp=s.players[&b].health;
    s.tick=attack.release; s.advance_attacks();
    assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::Basic,hit_succeeded:true});
    assert!((hp-s.players[&b].health-expected).abs()<0.001);
    assert_eq!(s.players[&a].effects.empowered_until,attack.release);
}

#[test]
fn garen_presentation_basic_and_critical_are_distinct_and_other_champions_stay_untracked() {
    for (critical,kind) in [(false,Kind::Basic),(true,Kind::Critical)] {
        let(mut s,a,b)=game("garen"); s.players.get_mut(&a).unwrap().attack_roll=Some(critical);
        let hp=s.players[&b].health; let expected=expected_damage(&s,a,b,kind);
        let attack=begin(&mut s,a,b); assert_eq!(started_kind(&s,attack),kind);
        s.tick=attack.release; s.advance_attacks();
        assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind,hit_succeeded:true});
        assert!((hp-s.players[&b].health-expected).abs()<0.001);
    }
    let(mut s,a,b)=game("annie"); s.command(a,Action::Attack{target:b}).unwrap();s.advance();
    assert!(s.players[&a].windup.as_ref().unwrap().presentation.is_none());
    assert!(s.snapshot().attack_events.is_empty());
}

#[test]
fn garen_presentation_orders_cancel_once_and_rejected_uncancellable_orders_keep_identity() {
    for action in [Action::Stop,Action::Move{point:Point{x:200.,z:200.}}] {
        let(mut s,a,b)=game("garen");s.cast(a,0,None).unwrap();let attack=begin(&mut s,a,b);
        let hp=s.players[&b].health; let armed=s.players[&a].effects.empowered_until;
        s.command(a,action).unwrap();s.command(a,Action::Stop).unwrap();
        cancelled(&s,attack,CancelReason::Order);assert_eq!(s.players[&b].health,hp);
        assert_eq!(s.players[&a].effects.empowered_until,armed);
    }
    let(mut s,a,b)=game("garen");let attack=begin(&mut s,a,b);
    let c=s.join("garen").unwrap();let d=s.join("garen").unwrap();
    s.players.get_mut(&d).unwrap().position=Point{x:160.,z:100.};
    s.command(a,Action::Attack{target:d}).unwrap();cancelled(&s,attack,CancelReason::Order);
    assert!(s.players.contains_key(&c));
    let(mut s,a,b)=game("garen");let attack=begin(&mut s,a,b);
    // Inject the existing non-cancellable policy to verify refusal is atomic.
    s.players.get_mut(&a).unwrap().windup.as_mut().unwrap().cancelable=false;
    assert!(s.command(a,Action::Stop).is_err());
    assert_eq!(s.players[&a].windup.as_ref().unwrap().presentation,Some(attack));
    assert_eq!(s.snapshot().attack_events.len(),1);
}

#[test]
fn garen_presentation_invalid_target_stun_death_and_casts_close_existing_identity() {
    for path in 0..6 {
        let(mut s,a,b)=game("garen");s.cast(a,0,None).unwrap();let attack=begin(&mut s,a,b);
        let armed=s.players[&a].effects.empowered_until;
        let reason=match path {
            0=>{s.players.get_mut(&b).unwrap().position=Point{x:900.,z:900.};s.tick+=1;s.advance_attacks();CancelReason::TargetInvalid},
            1=>{s.grant_stun(Some(b),a,"test",30).unwrap();CancelReason::Control},
            2=>{s.apply_damage(Some(b),a,100_000.,damage::DamageKind::True).unwrap();CancelReason::Death},
            3=>{s.cast(a,2,None).unwrap();s.tick+=1;s.advance_attacks();CancelReason::OtherCast},
            4=>{s.cast(a,3,Some(b)).unwrap();s.tick+=1;s.advance_attacks();CancelReason::OtherCast},
            _=>{s.apply_damage(Some(a),b,100_000.,damage::DamageKind::True).unwrap();s.tick+=1;s.advance_attacks();CancelReason::TargetInvalid},
        };
        cancelled(&s,attack,reason);
        if path!=2 {assert_eq!(s.players[&a].effects.empowered_until,armed);}
    }
}

#[test]
fn garen_presentation_departure_and_match_end_retire_once_without_changing_pending_combat() {
    for leave_target in [false,true] {
        let(mut s,a,b)=game("garen");let attack=begin(&mut s,a,b);
        let leaving=if leave_target{b}else{a};assert!(s.remove_player(leaving).is_some());
        cancelled(&s,attack,CancelReason::Departure);assert!(s.remove_player(leaving).is_none());
        if leave_target {assert!(s.players[&a].windup.is_some());s.tick+=1;s.advance_attacks();cancelled(&s,attack,CancelReason::Departure);}
    }
    let(mut s,a,b)=game("garen");let attack=begin(&mut s,a,b);let cadence=s.players[&a].next_attack;
    s.winner=Some(0);s.advance();cancelled(&s,attack,CancelReason::MatchEnded);
    assert_eq!(s.players[&a].next_attack,cadence);assert!(s.players[&a].windup.is_some());
    let saved=serde_json::to_value(s.final_results()).unwrap();s.remove_player(a);s.advance();
    assert_eq!(serde_json::to_value(s.final_results()).unwrap(),saved);cancelled(&s,attack,CancelReason::MatchEnded);
}

#[test]
fn garen_presentation_respawn_cleanup_handles_a_preexisting_windup_without_duplicate_death() {
    let navigation=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s=Simulation::new(navigation).unwrap();let a=s.join("garen").unwrap();let b=s.join("garen").unwrap();
    let position=s.navigation.nearest_walkable(Point{x:7700.,z:7000.}).unwrap();
    s.players.get_mut(&a).unwrap().position=position;s.players.get_mut(&b).unwrap().position=position;
    let attack=begin(&mut s,a,b);
    // Deliberately restore a legacy/injected dead state with a pending identity.
    let p=s.players.get_mut(&a).unwrap();p.health=0.;p.respawn_at=Some(s.tick);
    s.advance_respawns();cancelled(&s,attack,CancelReason::Respawn);assert!(s.players[&a].health>0.);
    s.advance_respawns();cancelled(&s,attack,CancelReason::Respawn);
}

#[test]
fn garen_presentation_historical_audience_hides_target_kind_until_a_permitted_attack() {
    let(mut s,a,viewer)=game("garen");s.enable_map10().unwrap();
    // Camps have not reached their spawn tick; explicitly create this native unit
    // as the visibility fixture rather than assuming enable_map10 spawns camps.
    let target=s.spawn_unit("TT_NWraith2","visibility_fixture",2,Point{x:200.,z:100.},0.,0.,None,None).unwrap();
    s.units.retain(|id,_|*id==target);
    s.units.get_mut(&target).unwrap().position=Point{x:200.,z:100.};
    s.players.get_mut(&viewer).unwrap().position=Point{x:50.,z:100.};
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers=vision::RadiusModifiers{percent_bubble_radius_mod:-1.,flat_bubble_radius_mod:75.};
    assert!(s.visible_to(1,a));assert!(!s.visible_to(1,target));
    s.cast(a,0,None).unwrap();let attack=begin(&mut s,a,target);
    let view=s.snapshot_for(viewer).unwrap();assert!(view.attack_events.is_empty());
    assert!(view.players.iter().find(|p|p.id==a).unwrap().windup.as_ref().unwrap().presentation.is_none());
    // Later visibility must not retroactively authorize the hidden Started event.
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers=Default::default();
    assert!(s.visible_to(1,target));assert!(s.snapshot_for(viewer).unwrap().attack_events.is_empty());
    s.command(a,Action::Stop).unwrap();
    let view=s.snapshot_for(viewer).unwrap();assert_eq!(view.attack_events.len(),1);
    assert_eq!(view.attack_events[0].phase,Phase::Cancelled{reason:CancelReason::Order});
    assert_eq!(view.attack_events[0].attack.id,attack.id);
    assert!(!serde_json::to_string(&view.attack_events).unwrap().contains("GarenQ"));
    // Current hidden source also suppresses an otherwise eligible terminal event.
    s.players.get_mut(&viewer).unwrap().position=Point{x:900.,z:900.};
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers=vision::RadiusModifiers{percent_bubble_radius_mod:-1.,flat_bubble_radius_mod:1.};
    assert!(s.snapshot_for(viewer).unwrap().attack_events.is_empty());
}

#[test]
fn garen_presentation_lethal_hit_keeps_audience_from_before_the_last_enemy_vision_source_dies() {
    let(mut s,a,b)=game("garen");s.enable_interactions();
    s.players.get_mut(&b).unwrap().health=1.;let attack=begin(&mut s,a,b);
    assert!(s.visible_to(1,a));s.tick=attack.release;s.advance_attacks();
    assert!(!s.visible_to(1,a));
    assert!(s.snapshot_for(b).unwrap().attack_events.is_empty());
    // Restore only CURRENT visibility after the hit. The prior audience survives death.
    let c=s.join("garen").unwrap();let d=s.join("garen").unwrap();
    s.players.get_mut(&d).unwrap().position=Point{x:100.,z:100.};
    assert!(s.players.contains_key(&c));assert!(s.visible_to(1,a));
    let view=s.snapshot_for(b).unwrap();assert!(view.attack_events.iter().any(|e|e.attack==attack&&matches!(e.phase,Phase::Resolved{..})));
}

#[test]
fn garen_presentation_capacity_error_is_visible_and_never_changes_attack_damage() {
    let(mut s,a,b)=game("garen");
    s.attack_presentation=attack_presentation::State::new(attack_presentation::Limits::new(1).unwrap());
    s.command(a,Action::Attack{target:b}).unwrap();s.command(b,Action::Attack{target:a}).unwrap();
    s.tick+=1;s.advance_attacks();
    assert!(s.attack_presentation_error.as_ref().unwrap().contains("ActiveLimit"));
    let first=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();
    assert!(s.players[&b].windup.as_ref().unwrap().presentation.is_none());
    let hp_a=s.players[&a].health;let hp_b=s.players[&b].health;
    s.tick=first.release;s.advance_attacks();
    assert!(s.players[&a].health<hp_a);assert!(s.players[&b].health<hp_b);
    assert!(s.snapshot_for(a).unwrap().attack_presentation_error.is_some());
}

#[test]
fn garen_presentation_rejected_hit_is_not_success_and_does_not_consume_q() {
    let(mut s,a,b)=game("garen");s.cast(a,0,None).unwrap();let attack=begin(&mut s,a,b);
    let armed=s.players[&a].effects.empowered_until;let hp=s.players[&b].health;
    // Explicit invalid-data injection reaches the existing hit Result::Err path;
    // this is not a possible client command or a qualified native gameplay input.
    s.definitions.get_mut("garen").unwrap().attack_damage=f32::NAN;
    s.tick=attack.release;s.advance_attacks();
    assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::GarenQ,hit_succeeded:false});
    assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&a].effects.empowered_until,armed);
}

#[test]
fn garen_presentation_lost_vision_cancels_without_impact_or_retroactive_audience() {
    let(mut s,a,b)=game("garen");s.enable_interactions();let attack=begin(&mut s,a,b);
    let hp=s.players[&b].health;
    s.players.get_mut(&a).unwrap().vision_radius_modifiers=vision::RadiusModifiers{percent_bubble_radius_mod:-1.,flat_bubble_radius_mod:1.};
    assert!(!s.visible_to(0,b));s.tick+=1;s.advance_attacks();
    cancelled(&s,attack,CancelReason::TargetInvalid);assert_eq!(s.players[&b].health,hp);
    // The unseen cancellation is not exposed later to the attacker team either.
    s.players.get_mut(&a).unwrap().vision_radius_modifiers=Default::default();
    assert!(s.snapshot_for(a).unwrap().attack_events.iter().all(|e|matches!(e.phase,Phase::Started{..})));
    assert!(s.players[&a].windup.is_none());
}

#[test]
fn garen_presentation_full_history_fragments_and_old_snapshots_remain_readable() {
    let(mut s,a,b)=game("garen");
    for _ in 0..80 {begin(&mut s,a,b);s.command(a,Action::Stop).unwrap();}
    assert_eq!(s.attack_presentation.history_len(),attack_presentation::HISTORY_CAPACITY);
    // Also fill all six active slots; active beginnings remain represented.
    while s.players.len()<6{s.join("garen").unwrap();}
    let ids:Vec<_>=s.players.keys().copied().collect();
    for id in &ids {let p=s.players.get_mut(id).unwrap();p.position=Point{x:100.,z:100.};p.next_attack=s.tick;}
    for id in &ids {let team=s.players[id].team;let target=*ids.iter().find(|other|s.players[*other].team!=team).unwrap();s.command(*id,Action::Attack{target}).unwrap();}
    s.tick+=1;s.advance_attacks();assert_eq!(s.attack_presentation.active_len(),6);
    let snapshot=s.snapshot_for(a).unwrap();let frames=wire::state_datagrams(&snapshot).unwrap();
    assert!(frames.len()>1);assert!(frames.iter().all(|f|f.len()<=1200));
    let mut assembler=wire::StateAssembler::default();let mut bytes=None;
    for frame in frames.iter().rev() {if let Some(complete)=assembler.push(frame,Some(s.session)){bytes=Some(complete);}}
    let decoded:ServerPacket=serde_json::from_slice(&bytes.unwrap()).unwrap();
    let ServerPacket::State(decoded)=decoded else {panic!("wrong packet")};
    assert_eq!(decoded.attack_events,snapshot.attack_events);
    let mut old=serde_json::to_value(&snapshot).unwrap();old.as_object_mut().unwrap().remove("attack_events");old.as_object_mut().unwrap().remove("attack_presentation_error");
    let old:Snapshot=serde_json::from_value(old).unwrap();assert!(old.attack_events.is_empty());assert!(old.attack_presentation_error.is_none());
    let attack=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();let mut old=serde_json::to_value(s.players[&a].windup.as_ref().unwrap()).unwrap();old.as_object_mut().unwrap().remove("presentation");
    let old:attacks::Windup=serde_json::from_value(old).unwrap();assert!(old.presentation.is_none());assert_eq!(old.release,attack.release);
    assert!(!serde_json::to_string(&snapshot).unwrap().contains("audience"));
}
