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
        Kind::TrundleQ=>{let q=trundle_q::rules(s.players[&a].ranks[0]).unwrap();q.base+q.ad_coefficient*stats.damage},
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
fn garen_presentation_basic_and_critical_are_distinct_and_ahri_is_tracked() {
    for (critical,kind) in [(false,Kind::Basic),(true,Kind::Critical)] {
        let(mut s,a,b)=game("garen"); s.players.get_mut(&a).unwrap().attack_roll=Some(critical);
        let hp=s.players[&b].health; let expected=expected_damage(&s,a,b,kind);
        let attack=begin(&mut s,a,b); assert_eq!(started_kind(&s,attack),kind);
        s.tick=attack.release; s.advance_attacks();
        assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind,hit_succeeded:true});
        assert!((hp-s.players[&b].health-expected).abs()<0.001);
    }
    // Ahri is now a canonical presentation source, like the other 121 IDs.
    let(mut s,a,b)=game("ahri");let attack=begin(&mut s,a,b);
    assert_eq!(started_kind(&s,attack),Kind::Basic);
    assert_eq!(s.attack_presentation.active(a),Some(&attack));
    assert_eq!(s.snapshot().attack_events.len(),1);
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


#[test]
fn annie_ashe_presentation_records_windup_release_without_claiming_ranged_impact() {
    for name in ["annie", "ashe"] {
        let (mut s,a,b)=game(name);
        let cadence=s.stats(a).attack_cooldown_ticks;
        let hp=s.players[&b].health;let expected=expected_damage(&s,a,b,Kind::Basic);
        let attack=begin(&mut s,a,b);
        assert_eq!(started_kind(&s,attack),Kind::Basic);
        assert_eq!(attack.release-attack.started,attacks::windup_ticks(name,cadence).min(cadence));
        assert_eq!(s.players[&a].next_attack,attack.started+cadence);
        s.tick=attack.release-1;s.advance_attacks();
        assert!(s.projectiles.is_empty());assert_eq!(s.players[&b].health,hp);
        s.tick=attack.release;s.advance_attacks();
        assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::Basic,hit_succeeded:false});
        assert_eq!(s.projectiles.len(),1);assert_eq!(s.projectiles[0].launched,attack.release);
        assert_eq!(s.players[&b].health,hp);
        s.command(a,Action::Stop).unwrap();
        for _ in 0..10 {s.tick+=1;s.advance_attacks();if s.projectiles.is_empty(){break;}}
        assert!(s.projectiles.is_empty());assert!((hp-s.players[&b].health-expected).abs()<0.001);
        assert_eq!(s.snapshot().attack_events.iter().filter(|e|e.attack==attack&&!matches!(e.phase,Phase::Started{..})).count(),1);
    }
}

#[test]
fn annie_ashe_presentation_cancels_once_for_order_or_death_and_scope_stays_bounded() {
    for name in ["annie", "ashe"] {
        assert!(attacks::supports_champion_presentation(name));
        for death in [false,true] {
            let(mut s,a,b)=game(name);let attack=begin(&mut s,a,b);let hp=s.players[&b].health;
            if death {s.apply_damage(Some(b),a,100_000.,damage::DamageKind::True).unwrap();}
            else {s.command(a,Action::Stop).unwrap();s.command(a,Action::Stop).unwrap();}
            cancelled(&s,attack,if death{CancelReason::Death}else{CancelReason::Order});
            assert_eq!(s.players[&b].health,hp);assert!(s.projectiles.is_empty());
        }
    }
    assert!(attacks::supports_champion_presentation("ahri"));
    assert!(!attacks::supports_champion_presentation("Annie"));
}

#[test]
fn annie_ashe_presentation_enabled_and_disabled_preserve_combat_snapshots() {
    fn combat(snapshot:Snapshot)->serde_json::Value {
        let mut value=serde_json::to_value(snapshot).unwrap();
        value.as_object_mut().unwrap().remove("attack_events");
        value.as_object_mut().unwrap().remove("attack_presentation_error");
        for player in value["players"].as_array_mut().unwrap() {
            if let Some(windup)=player.get_mut("windup").and_then(serde_json::Value::as_object_mut) {windup.remove("presentation");}
        }
        value
    }
    for name in ["annie","ashe"] {
        let(mut enabled,a,b)=game(name);let(mut disabled,c,d)=game(name);
        disabled.attack_presentation_error=Some("test-only disabled presentation".into());
        enabled.command(a,Action::Attack{target:b}).unwrap();disabled.command(c,Action::Attack{target:d}).unwrap();
        for _ in 0..80 {
            enabled.advance();disabled.advance();
            assert_eq!(combat(enabled.snapshot()),combat(disabled.snapshot()),"{name}: combat drift");
        }
        assert!(enabled.attack_presentation_error.is_none());
    }
}

fn annie_cast_attack_game() -> (Simulation, u32, u32, Point) {
    let navigation = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(navigation).unwrap();
    s.session = 41; s.enable_map10().unwrap(); s.interactions = None;
    let a = s.join("annie").unwrap(); let b = s.join("garen").unwrap();
    let point = s.navigation.nearest_walkable(Point { x:7700., z:7000. }).unwrap();
    // Explicit spell/rank/resource preconditions; progression is not under test.
    for id in [a,b] { let p=s.players.get_mut(&id).unwrap(); p.position=point;
        p.health=p.max_health; p.mana=1000.; p.ranks=[1,1,1,1]; }
    (s,a,b,point)
}
fn commit_annie_attack_cast(s:&mut Simulation, a:u32, b:u32, slot:u8, point:Point) -> Result<(),String> {
    match slot {
        0 => s.cast(a,0,Some(b)),
        1 => s.cast_at(a,1,Point { x:point.x+50., z:point.z }),
        3 => s.cast_at(a,3,point),
        _ => unreachable!(),
    }
}

#[test]
fn annie_initial_q_w_r_casts_cancel_active_attack_once_and_allow_next_identity() {
    for slot in [0,1,3] {
        let (mut s,a,b,point)=annie_cast_attack_game();
        let attack=begin(&mut s,a,b);
        let cadence=s.players[&a].next_attack; let roll=s.players[&a].attack_roll;
        let hp=s.players[&b].health; let target=s.players[&a].target;
        commit_annie_attack_cast(&mut s,a,b,slot,point).unwrap();
        cancelled(&s,attack,CancelReason::OtherCast);
        assert!(s.players[&a].windup.is_none());
        assert_eq!(s.players[&a].next_attack,cadence);
        assert_eq!(s.players[&a].attack_roll,roll);
        assert_eq!(s.players[&a].target,target);
        assert_eq!(s.players[&a].position,point);
        assert_eq!(s.players[&b].health,hp); assert!(s.projectiles.is_empty());
        let release=match slot {
            0 => s.players[&a].effects.annie_q.as_ref().unwrap().releases,
            1 => s.players[&a].effects.annie_w.as_ref().unwrap().releases,
            3 => s.players[&a].effects.annie_r.as_ref().unwrap().releases,
            _ => unreachable!(),
        };
        s.advance_attacks(); cancelled(&s,attack,CancelReason::OtherCast);
        s.tick=release;
        match slot {0=>s.advance_annie(),1=>s.advance_annie_w(),3=>s.advance_annie_r(),_=>unreachable!()}
        s.tick=cadence.max(release); s.advance_attacks();
        let next=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();
        assert!(next.id>attack.id); assert_eq!(next.source,a);
        assert_eq!(s.attack_presentation.active(a),Some(&next));
        assert!(s.attack_presentation_error.is_none());
        assert_eq!(s.snapshot().attack_events.iter().filter(|e|
            e.attack==attack && matches!(e.phase,Phase::Cancelled{reason:CancelReason::OtherCast})).count(),1);
    }
}

#[test]
fn annie_rejected_initial_q_w_r_casts_preserve_attack_identity_and_combat_state() {
    for slot in [0,1,3] { for refusal in 0..3 {
        let (mut s,a,b,point)=annie_cast_attack_game();
        let attack=begin(&mut s,a,b);
        if refusal==1 {s.players.get_mut(&a).unwrap().mana=0.;}
        if refusal==2 {s.players.get_mut(&a).unwrap().ranks[slot as usize]=0;}
        let before=serde_json::to_value(s.snapshot()).unwrap();
        let result=if refusal==0 {match slot {
            0=>s.cast(a,0,None),
            1=>s.cast_at(a,1,point),
            3=>s.cast_at(a,3,Point{x:point.x+annie_r::value("range")+1.,z:point.z}),
            _=>unreachable!(),
        }} else {commit_annie_attack_cast(&mut s,a,b,slot,point)};
        assert!(result.is_err(),"slot {slot}, refusal {refusal}");
        assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);
        assert_eq!(s.players[&a].windup.as_ref().unwrap().presentation,Some(attack));
        assert_eq!(s.attack_presentation.active(a),Some(&attack));
        assert!(s.attack_presentation_error.is_none());
        s.tick=attack.release; s.advance_attacks();
        assert!(matches!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::Basic,hit_succeeded:false}));
        assert_eq!(s.projectiles.len(),1);
    }}
}

#[test]
fn annie_instant_e_and_tibbers_guidance_do_not_cancel_owner_attack_identity() {
    for guide in [false,true] {
        let (mut s,a,b,point)=annie_cast_attack_game();
        if guide {
            s.cast_at(a,3,point).unwrap();
            s.tick=s.players[&a].effects.annie_r.as_ref().unwrap().releases;
            s.advance_annie_r(); assert!(s.tibbers(a).is_some());
        }
        let attack=begin(&mut s,a,b); let cadence=s.players[&a].next_attack;
        let mana=s.players[&a].mana; let cooldown=s.players[&a].cooldowns[3];
        if guide {s.cast_at(a,3,point).unwrap();
            assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns[3],cooldown);
        } else {s.cast(a,2,None).unwrap();}
        assert_eq!(s.players[&a].windup.as_ref().unwrap().presentation,Some(attack));
        assert_eq!(s.attack_presentation.active(a),Some(&attack));
        assert_eq!(s.players[&a].next_attack,cadence);
        assert_eq!(s.snapshot().attack_events.len(),1);
        assert!(s.attack_presentation_error.is_none());
        s.tick=attack.release;s.advance_attacks();
        assert!(matches!(terminal(&s,attack).phase,Phase::Resolved{kind:Kind::Basic,hit_succeeded:false}));
    }
}

#[test]
fn non_annie_cast_routes_do_not_gain_other_cast_cancellations() {
    for name in ["garen","ashe"] {
        let (mut s,a,b)=game(name);let attack=begin(&mut s,a,b);
        let before=serde_json::to_value(s.snapshot()).unwrap();
        if name=="garen" {s.cast(a,0,None).unwrap();}
        else {assert_eq!(s.cast(a,0,None).unwrap_err(),"champion spell not implemented");
            assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);}
        assert_eq!(s.players[&a].windup.as_ref().unwrap().presentation,Some(attack));
        assert_eq!(s.attack_presentation.active(a),Some(&attack));
        assert_eq!(s.snapshot().attack_events.len(),1);
        s.tick=attack.release;s.advance_attacks();
        let expected=if name=="garen" {Kind::GarenQ} else {Kind::Basic};
        assert!(matches!(terminal(&s,attack).phase,Phase::Resolved{kind,..} if kind==expected));
        assert!(!s.snapshot().attack_events.iter().any(|e|matches!(e.phase,
            Phase::Cancelled{reason:CancelReason::OtherCast})));
        assert!(s.attack_presentation_error.is_none());
    }
}

// Engine facts and reconstructed policies; no native champion kit claim.
#[test]
fn all122_engine_basic_and_critical_attacks_record_start_and_one_actual_release() {
    let names:Vec<_>=champion_catalog().unwrap().into_keys().collect();assert_eq!(names.len(),122);
    for name in names {for critical in [false,true] {
        let(mut s,a,b)=game(&name);s.players.get_mut(&a).unwrap().attack_roll=Some(critical);
        let kind=if critical {Kind::Critical} else {Kind::Basic};let expected=expected_damage(&s,a,b,kind);let hp=s.players[&b].health;
        let cadence=s.stats(a).attack_cooldown_ticks;let attack=begin(&mut s,a,b);
        assert_eq!(started_kind(&s,attack),kind,"{name}");assert_eq!(attack.source,a);
        assert_eq!(s.attack_presentation.active(a),Some(&attack));assert_eq!(s.players[&a].windup.as_ref().unwrap().critical,critical);
        assert_eq!(s.players[&a].next_attack,attack.started+cadence);assert_eq!(s.players[&b].health,hp);
        s.tick=attack.release;s.advance_attacks();
        let melee=critical::profile(&name).attack.melee;
        assert_eq!(terminal(&s,attack).phase,Phase::Resolved{kind,hit_succeeded:melee},"{name}");
        assert!(s.attack_presentation.active(a).is_none());assert!(s.attack_presentation_error.is_none());
        if melee {assert!((hp-s.players[&b].health-expected).abs()<0.001,"{name}");assert!(s.projectiles.is_empty());}
        else {
            assert_eq!(s.projectiles.len(),1,"{name}");assert_eq!(s.projectiles[0].launched,attack.release);assert_eq!(s.players[&b].health,hp);
            s.command(a,Action::Stop).unwrap();
            for _ in 0..10 {s.tick+=1;s.advance_attacks();if s.projectiles.is_empty(){break;}}
            assert!(s.projectiles.is_empty(),"{name}");assert!((hp-s.players[&b].health-expected).abs()<0.001,"{name}");
        }
        assert_eq!(s.snapshot().attack_events.iter().filter(|event|event.attack==attack&&!matches!(event.phase,Phase::Started{..})).count(),1);
    }}
}

#[test]
fn all122_engine_rejected_orders_preserve_identity_and_existing_cancel_policies() {
    for name in champion_catalog().unwrap().keys() {
        let(mut s,a,b)=game(name);let attack=begin(&mut s,a,b);let before=serde_json::to_value(s.snapshot()).unwrap();
        assert!(s.command(a,Action::Attack{target:u32::MAX}).is_err());
        assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before,"{name}");assert_eq!(s.attack_presentation.active(a),Some(&attack));
        let cancelable=s.players[&a].windup.as_ref().unwrap().cancelable;let hp=s.players[&b].health;
        if cancelable {
            s.command(a,Action::Stop).unwrap();s.command(a,Action::Stop).unwrap();cancelled(&s,attack,CancelReason::Order);
            assert_eq!(s.players[&b].health,hp);let next=begin(&mut s,a,b);assert!(next.id>attack.id,"{name}");
        } else {
            assert!(s.command(a,Action::Stop).is_err());assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before,"{name}");
        }
        let(mut s,a,b)=game(name);let attack=begin(&mut s,a,b);
        s.apply_damage(Some(b),a,100_000.,damage::DamageKind::True).unwrap();cancelled(&s,attack,CancelReason::Death);
        s.advance_attacks();cancelled(&s,attack,CancelReason::Death);assert!(s.projectiles.is_empty());
    }
}

#[test]
fn all122_engine_fog_audience_does_not_retroactively_expose_hidden_started_kind() {
    for name in champion_catalog().unwrap().keys() {
        let(mut s,a,viewer)=game(name);s.enable_map10().unwrap();
        let target=s.spawn_unit("TT_NWraith2","all122_visibility_fixture",2,Point{x:200.,z:100.},0.,0.,None,None).unwrap();
        s.units.retain(|id,_|*id==target);
        s.players.get_mut(&viewer).unwrap().position=Point{x:50.,z:100.};
        s.players.get_mut(&viewer).unwrap().vision_radius_modifiers=vision::RadiusModifiers{percent_bubble_radius_mod:-1.,flat_bubble_radius_mod:75.};
        assert!(s.visible_to(1,a));assert!(!s.visible_to(1,target));s.players.get_mut(&a).unwrap().attack_roll=Some(false);
        let attack=begin(&mut s,a,target);let view=s.snapshot_for(viewer).unwrap();assert!(view.attack_events.is_empty(),"{name}");
        assert!(view.players.iter().find(|p|p.id==a).unwrap().windup.as_ref().unwrap().presentation.is_none());
        s.players.get_mut(&viewer).unwrap().vision_radius_modifiers=Default::default();assert!(s.visible_to(1,target));
        assert!(s.snapshot_for(viewer).unwrap().attack_events.is_empty(),"{name}");
        // Controls close all windups regardless of their ordinary Stop policy.
        s.grant_stun(Some(viewer),a,"all122_visibility_control",30).unwrap();
        cancelled(&s,attack,CancelReason::Control);let view=s.snapshot_for(viewer).unwrap();assert_eq!(view.attack_events.len(),1,"{name}");
        assert_eq!(view.attack_events[0].attack,attack);assert_eq!(view.attack_events[0].phase,Phase::Cancelled{reason:CancelReason::Control});
    }
}

#[test]
fn all122_engine_identity_enabled_and_disabled_preserve_combat_snapshots() {
    fn combat(snapshot:Snapshot)->serde_json::Value {
        let mut value=serde_json::to_value(snapshot).unwrap();value.as_object_mut().unwrap().remove("attack_events");
        value.as_object_mut().unwrap().remove("attack_presentation_error");
        for player in value["players"].as_array_mut().unwrap() {
            if let Some(windup)=player.get_mut("windup").and_then(serde_json::Value::as_object_mut){windup.remove("presentation");}
        }
        value
    }
    for name in champion_catalog().unwrap().keys() {for critical in [false,true] {
        let(mut enabled,a,b)=game(name);let(mut disabled,c,d)=game(name);
        enabled.players.get_mut(&a).unwrap().attack_roll=Some(critical);disabled.players.get_mut(&c).unwrap().attack_roll=Some(critical);
        disabled.attack_presentation_error=Some("test-only disabled presentation".into());
        enabled.command(a,Action::Attack{target:b}).unwrap();disabled.command(c,Action::Attack{target:d}).unwrap();
        for _ in 0..80 {enabled.advance();disabled.advance();assert_eq!(combat(enabled.snapshot()),combat(disabled.snapshot()),"{name}: combat drift");}
        assert!(enabled.attack_presentation_error.is_none(),"{name}");
    }}
}

#[test]
fn six_distinct_engine_champions_fill_existing_capacity_and_seventh_join_is_atomic() {
    let(mut s,a,b)=game("aatrox");assert_eq!(s.players[&b].champion,"garen");
    for name in ["ahri","akali","alistar","amumu"] {s.join(name).unwrap();}
    let ids:Vec<_>=s.players.keys().copied().collect();assert_eq!(ids.len(),6);
    let names:std::collections::BTreeSet<_>=s.players.values().map(|p|p.champion.clone()).collect();assert_eq!(names.len(),6);
    for id in &ids {let p=s.players.get_mut(id).unwrap();p.position=Point{x:100.,z:100.};p.next_attack=s.tick;}
    for id in &ids {
        let team=s.players[id].team;let target=*ids.iter().find(|other|s.players[*other].team!=team).unwrap();
        s.command(*id,Action::Attack{target}).unwrap();
    }
    s.tick+=1;s.advance_attacks();assert_eq!(s.attack_presentation.active_len(),6);
    assert_eq!(s.attack_presentation.limits().active_sources(),6);assert_eq!(attack_presentation::HISTORY_CAPACITY,128);
    assert_eq!(s.attack_presentation.limits().snapshot_events(),134);assert!(s.attack_presentation_error.is_none());
    let before=serde_json::to_value(s.snapshot()).unwrap();assert_eq!(s.join("anivia").unwrap_err(),"3v3 lobby full");
    assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);assert!(s.players.contains_key(&a));
}
