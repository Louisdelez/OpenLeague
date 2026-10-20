use super::*;

fn game() -> (Simulation, u32, u32) {
    let mut bytes = Vec::new();
    for _ in 0..6400 { bytes.extend(0f32.to_le_bytes()); bytes.extend(0u16.to_le_bytes());
        bytes.extend(0u32.to_le_bytes()); bytes.push(1); }
    let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#, &bytes).unwrap();
    let mut s = Simulation::new(nav).unwrap(); s.session = 420;
    let a = s.join("ezreal").unwrap(); let b = s.join("garen").unwrap();
    for (id, x) in [(a,200.),(b,1100.)] {
        let p = s.players.get_mut(&id).unwrap(); p.position = Point {x,z:300.};
        p.health = 10000.; p.max_health = 10000.; p.mana = 2000.; p.level = 3;
    }
    s.players.get_mut(&a).unwrap().ranks = [0,0,1,0];
    (s,a,b)
}
fn aim() -> Point { Point {x:675.,z:300.} }
fn cast(s: &mut Simulation, a: u32) { s.command(a,Action::CastAt {slot:2,point:aim()}).unwrap(); }
fn until(s: &mut Simulation, tick: u64) { while s.tick < tick {s.tick += 1; s.advance_ezreal_e();} }
fn state(s: &Simulation) -> String {
    format!("{:?}|{:?}|{:?}|{:?}",s.players,s.ezreal_e,s.projectiles,s.attack_presentation.events())
}
fn close(a:f32,b:f32) { assert!((a-b).abs()<0.005,"{a} != {b}"); }

#[test]
fn primary_e_ranks_ground_intent_and_server_learning_keep_r_explicitly_unsupported() {
    for rank in 1..=5 {
        let rule=rules(rank).unwrap();let i=rank as usize-1;
        assert_eq!((rule.base,rule.cost,rule.cooldown,rule.ap),([75.,125.,175.,225.,275.][i],90.,[19.,17.,15.,13.,11.][i],0.75));
        let(mut s,a,b)=game();let p=s.players.get_mut(&a).unwrap();p.ranks=[0,0,rank-1,0];p.level=2*rank-1;
        s.command(a,Action::Learn{slot:2}).unwrap();assert_eq!(s.players[&a].ranks[2],rank);
        assert!(s.learn(a,2).is_err());assert_eq!(progression::next_rank(&s.players[&a],3).is_ok(),s.players[&a].level>=6);
        for target in [None,Some(b)] {assert_eq!(s.cast(a,2,target).unwrap_err(),"Ezreal E requires a ground point");}
        assert_eq!(s.cast(a,3,None).unwrap_err(),"Ezreal R requires a ground point");
    }
    for rank in [0,6,255] {assert!(rules(rank).is_err());}
    let text=include_str!("../../../data/4.20/native_spells_420.json");
    for case in 0..3 {
        let mut table:serde_json::Value=serde_json::from_str(text).unwrap();let rows=table.as_array_mut().unwrap();
        let index=rows.iter().position(|r|r["spell"]=="EzrealArcaneShift").unwrap();
        match case {0=>{rows[index]["values"].as_object_mut().unwrap().remove("Effect1Level1Amount");},
            1=>{let extra=rows[index].clone();rows.push(extra);},_=>rows[index]["values"]["Coefficient"]=serde_json::json!(1.2)}
        assert!(parse(&table.to_string()).is_err());
    }
}

#[test]
fn failed_e_preflight_is_atomic_including_numeric_controls_budget_and_attack_phase() {
    for case in 0..15 {
        let(mut s,a,b)=game();let mut point=aim();
        match case {
            0=>s.players.get_mut(&a).unwrap().ranks[2]=0,
            1=>s.players.get_mut(&a).unwrap().mana=89.,
            2=>s.players.get_mut(&a).unwrap().mana=f32::INFINITY,
            3=>s.players.get_mut(&a).unwrap().effects.silence_until=1,
            4=>s.players.get_mut(&a).unwrap().cooldowns[2]=1,
            5=>point=s.players[&a].position,
            6=>point.x=f32::NAN,
            7=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),
            8=>s.ezreal_e.next_ordinal=u64::MAX,
            9=>s.tick=u64::MAX-10,
            10=>s.players.get_mut(&a).unwrap().health=0.,
            11=>s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:5}),
            12=>s.ezreal_e.session=Some(421),
            13=>{for ordinal in 1..=MAX_CASTS {s.ezreal_e.bolts.push(Bolt{session:420,owner:a,team:0,ordinal:ordinal as u64,target:b,position:aim(),expires:100,raw:75.,current:None});}},
            _=>{let p=s.players.get_mut(&a).unwrap();p.windup=Some(attacks::Windup{target:b,started:0,release:20,cancelable:false,critical:true,presentation:None});p.attack_roll=Some(true);},
        }
        let before=state(&s);assert!(s.command(a,Action::CastAt{slot:2,point}).is_err());assert_eq!(state(&s),before);
    }
}

#[test]
fn real_blink_crosses_wall_only_to_exact_bounded_landing_and_clears_height_orders_and_cache() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:1800.,z:300.};
    s.command(a,Action::Move{point:Point{x:350.,z:300.}}).unwrap();
    // A wall between endpoints is not a walking-route requirement for this blink.
    for row in 0..80 {s.navigation.cells[row*80+8].1=false;}
    let end=Point{x:675.,z:300.};let index=s.navigation.index(end).unwrap();s.navigation.cells[index].0=42.;
    let origin=s.players[&a].position;let mana=s.players[&a].mana;
    s.command(a,Action::CastAt{slot:2,point:Point{x:2000.,z:300.}}).unwrap();
    assert_eq!(s.players[&a].mana,mana-90.);assert_eq!(s.players[&a].cooldowns[2],570);
    for action in [Action::Stop,Action::Move{point:aim()},Action::Attack{target:b},Action::CastAt{slot:0,point:aim()}] {
        assert_eq!(s.command(a,action).unwrap_err(),"skill blocked during cast");
    }
    for _ in 0..7 {s.advance();assert_eq!(s.players[&a].position,origin);}
    s.advance();let p=&s.players[&a];
    assert!(squared(origin,p.position)<=f64::from(BLINK_RANGE).powi(2));close(p.position.x,end.x);assert_eq!(p.height,42.);
    assert!(p.path.is_empty()&&p.destination.is_none()&&p.target.is_none());assert_eq!(p.next_repath,0);
    assert!(p.facing.is_some());assert!(!s.ally_move_is_repeat(a,Point{x:350.,z:300.}));
    assert!(!s.ezreal_e_casting(a));assert!(s.ezreal_e.bolts.is_empty());
    let after=state(&s);s.advance_ezreal_e();assert_eq!(state(&s),after);
    // Diagonal and huge finite aims still cannot round beyond475.
    for point in [Point{x:1900.,z:1700.},Point{x:f32::MAX,z:f32::MAX}] {
        let(p,_) = clamp_landing(origin,point).unwrap();assert!(p.finite());assert!(squared(origin,p)<=f64::from(BLINK_RANGE).powi(2));
    }
}

#[test]
fn landing_checks_full_disk_terrain_pillars_occupancy_and_release_failure_never_moves_or_recharges() {
    for mode in 0..3 {
        let(mut s,a,b)=game();
        if mode==0 {s.navigation.cells[6*80+14].1=false;} // center open; body overlaps the next cell.
        else if mode==1 {s.trundle_e.pillars.insert(b,trundle_e::Pillar{owner:b,team:1,center:aim(),rank:1,started:0,until:100});}
        else {s.players.get_mut(&b).unwrap().position=aim();}
        let before=state(&s);assert!(s.cast_at(a,2,aim()).is_err());assert_eq!(state(&s),before);
    }
    let(mut s,a,b)=game();let origin=s.players[&a].position;cast(&mut s,a);let mana=s.players[&a].mana;let cd=s.players[&a].cooldowns;
    s.players.get_mut(&b).unwrap().position=aim();until(&mut s,8);
    assert_eq!(s.players[&a].position,origin);assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns,cd);
    assert!(s.ezreal_e.pending.is_empty()&&s.ezreal_e.bolts.is_empty());
    assert_eq!(s.ezreal_e_faults().last().unwrap().reason,"Ezreal E landing occupied");
    s.advance_ezreal_e();assert_eq!(s.ezreal_e_faults().len(),1);assert_eq!(s.players[&a].mana,mana);
}

#[test]
fn pending_controls_death_departure_session_end_and_skipped_clock_retire_without_blink() {
    for mode in 0..8 {
        let(mut s,a,b)=game();cast(&mut s,a);let origin=s.players[&a].position;let mana=s.players[&a].mana;
        match mode {
            0=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),
            1=>s.players.get_mut(&a).unwrap().effects.silence_until=30,
            2=>s.players.get_mut(&a).unwrap().effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:0,until:10}),
            3=>s.players.get_mut(&a).unwrap().health=0.,
            4=>{s.remove_player(a).unwrap();},
            5=>s.session=421,
            6=>s.winner=Some(1),
            _=>s.tick=9,
        }
        if s.tick<8 {s.tick=8;}s.advance_ezreal_e();
        assert!(s.ezreal_e.pending.is_empty()&&s.ezreal_e.bolts.is_empty());
        if let Some(p)=s.players.get(&a) {assert_eq!(p.position,origin);assert_eq!(p.mana,mana);}
    }
    let(mut s,a,_)=game();cast(&mut s,a);until(&mut s,3);s.tick=2;s.advance_ezreal_e();
    assert!(s.ezreal_e.pending.is_empty());
}

#[test]
fn nearest_visible_enemy_unit_includes_minions_and_uses_distance_then_id_not_champion_priority() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
    let minion=s.spawn_unit("Blue_Minion_Basic","E nearer minion",1,Point{x:875.,z:300.},0.,0.,None,None).unwrap();
    let ally=s.join("garen").unwrap();let p=s.players.get_mut(&ally).unwrap();p.team=0;p.position=Point{x:825.,z:300.};
    let hp=s.units[&minion].health;let champion_hp=s.players[&b].health;cast(&mut s,a);until(&mut s,8);
    assert_eq!(s.ezreal_e.bolts[0].target,minion);until(&mut s,20);
    assert!(s.units[&minion].health<hp);assert_eq!(s.players[&b].health,champion_hp);
    let(mut s,a,b)=game();let other=s.join("garen").unwrap();let position=s.players[&b].position;
    let p=s.players.get_mut(&other).unwrap();p.team=1;p.position=position;
    cast(&mut s,a);until(&mut s,8);assert_eq!(s.ezreal_e.bolts[0].target,b.min(other));
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:1425.,z:300.};
    cast(&mut s,a);until(&mut s,8);assert_eq!(s.ezreal_e.bolts[0].target,b);
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:1425.25,z:300.};
    cast(&mut s,a);until(&mut s,8);assert!(s.ezreal_e.bolts.is_empty());assert_eq!(s.players[&a].position,aim());
}

#[test]
fn homing_tracks_current_position_once_per_tick_then_target_loss_is_terminal_without_retarget() {
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);assert_eq!(s.ezreal_e.bolts[0].position,aim());
    s.players.get_mut(&b).unwrap().position=Point{x:1100.,z:600.};until(&mut s,9);
    let position=s.ezreal_e.bolts[0].position;assert!(position.x>675.&&position.z>300.);
    assert!(squared(position,aim())<=(f64::from(SPEED)/TICK_RATE as f64).powi(2)+0.01);
    s.advance_ezreal_e();assert_eq!(s.ezreal_e.bolts[0].position,position);
    let other=s.join("garen").unwrap();let p=s.players.get_mut(&other).unwrap();p.team=1;p.position=Point{x:800.,z:300.};
    let hp=s.players[&other].health;let mana=s.players[&a].mana;let cd=s.players[&a].cooldowns;
    s.players.get_mut(&b).unwrap().health=0.;until(&mut s,10);assert!(s.ezreal_e.bolts.is_empty());
    until(&mut s,30);assert_eq!(s.players[&other].health,hp);assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns,cd);
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:300.};s.tick=68;s.advance_ezreal_e();
    assert!(s.ezreal_e.bolts.is_empty());assert!(s.ezreal_e_faults().last().unwrap().reason.contains("expired"));
}

#[test]
fn frozen_ap_cdr_current_magic_defense_shields_and_damage_error_have_one_terminal_application() {
    let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);
    let raw=75.+0.75*s.stats(a).ability_power;let cd=cooldown::ticks(19.,s.stats(a).cooldown_reduction);
    cast(&mut s,a);assert_eq!(s.players[&a].cooldowns[2],cd);assert_eq!(s.players[&a].cooldown_totals[2],Some(cd));
    s.players.get_mut(&a).unwrap().inventory[0]=None;s.players.get_mut(&a).unwrap().ranks[2]=5;
    s.players.get_mut(&b).unwrap().inventory[0]=Some(1033);let mr=s.stats(b).magic_resist;let hp=s.players[&b].health;
    until(&mut s,25);close(hp-s.players[&b].health,raw*100./(100.+mr));let after=s.players[&b].health;
    until(&mut s,40);assert_eq!(s.players[&b].health,after);assert_eq!(s.players[&a].cooldowns[2],cd);
    let(mut s,a,b)=game();s.grant_shield(b,"E fixture",1000.,100).unwrap();let hp=s.players[&b].health;
    cast(&mut s,a);until(&mut s,25);assert_eq!(s.players[&b].health,hp);assert!(s.players[&b].shields[0].remaining<1000.);
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);let hp=s.players[&b].health;
    s.definitions.get_mut("garen").unwrap().magic_resist=f32::NAN;until(&mut s,25);
    assert_eq!(s.players[&b].health,hp);assert!(s.ezreal_e.bolts.is_empty());assert_eq!(s.ezreal_e_faults().len(),1);
    assert_eq!(s.ezreal_e_faults()[0].stage,"impact");assert_eq!(s.players[&a].mana,1910.);
}

#[test]
fn e_cancels_only_cancelable_aa_windup_and_never_removes_an_already_released_aa() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:450.,z:300.};
    s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();assert!(s.players[&a].windup.is_some());
    s.players.get_mut(&a).unwrap().attack_roll=Some(true);cast(&mut s,a);
    assert!(s.players[&a].windup.is_none());assert_eq!(s.players[&a].attack_roll,None);
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=Point{x:450.,z:300.};
    s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();let release=s.players[&a].windup.as_ref().unwrap().release;
    s.tick=release;s.advance_attacks();assert_eq!(s.projectiles.len(),1);let aa=serde_json::to_value(&s.projectiles).unwrap();
    cast(&mut s,a);assert_eq!(serde_json::to_value(&s.projectiles).unwrap(),aa);
    until(&mut s,release+8);assert_eq!(serde_json::to_value(&s.projectiles).unwrap(),aa);
}

#[test]
fn q_refunds_the_real_e_cooldown_and_w_can_contact_the_repositioned_caster_without_changing_either_module() {
    let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().ranks=[1,1,1,0];
    s.command(a,Action::CastAt{slot:1,point:Point{x:1800.,z:300.}}).unwrap();
    while s.tick<8 {s.tick+=1;s.advance_ezreal_q();s.advance_ezreal_w();s.advance_ezreal_e();}
    cast(&mut s,a);
    while s.tick<18 {s.tick+=1;s.advance_ezreal_q();s.advance_ezreal_w();s.advance_ezreal_e();}
    close(s.ezreal_w_attack_speed_bonus(a),0.2);assert!(s.players[&a].position.x>600.);
    let ready=s.players[&a].cooldowns[2];let target=s.players[&b].position;
    s.command(a,Action::CastAt{slot:0,point:target}).unwrap();
    while s.tick<40 {s.tick+=1;s.advance_ezreal_q();s.advance_ezreal_w();s.advance_ezreal_e();}
    assert_eq!(s.players[&a].cooldowns[2],ready.saturating_sub(TICK_RATE));
    assert!(s.players[&b].health<10000.);
}

#[test]
fn e_private_bolts_respect_current_fog_and_survive_source_death_but_not_departure_or_new_life() {
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();cast(&mut s,a);until(&mut s,8);
    assert_eq!(s.ezreal_e.bolts.len(),1);let hp=s.players[&b].health;
    s.players.get_mut(&a).unwrap().health=0.;let ally=s.join("garen").unwrap();let p=s.players.get_mut(&ally).unwrap();p.team=0;p.position=Point{x:900.,z:400.};
    until(&mut s,25);assert!(s.players[&b].health<hp); // source health is not bolt ownership.
    let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();cast(&mut s,a);until(&mut s,8);
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};until(&mut s,9);
    assert!(s.ezreal_e.bolts.is_empty());assert!(s.ezreal_e_faults().last().unwrap().reason.contains("visible"));
    let wire=serde_json::to_value(s.snapshot_for(b).unwrap()).unwrap();assert!(!wire.to_string().contains("ezreal_e"));
    let(mut s,a,b)=game();cast(&mut s,a);until(&mut s,8);s.clear_ezreal_e_target(b);assert!(s.ezreal_e.bolts.is_empty());
    s.players.get_mut(&a).unwrap().cooldowns[2]=0;
    s.command(a,Action::CastAt{slot:2,point:Point{x:675.,z:775.}}).unwrap();
    s.remove_player(a).unwrap();assert!(s.ezreal_e.pending.is_empty());
}


use std::collections::BTreeSet;

// Broad flat navigation is an explicit CPU fixture; the actual Map10 world
// definitions and every spawned native structure are retained without edits.
fn ordinary_map10_collision_scene() -> (Simulation,u32,u32) {
    let mut bytes=Vec::new();
    for _ in 0..160*160 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":100,"width":160,"height":160}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;s.enable_map10().unwrap();
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for(id,x)in[(a,5000.),(b,11000.)] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x,z:7000.};p.height=0.;}
    (s,a,b)
}

#[test]
fn ordinary_map10_zero_radius_native_structures_allow_real_e_learning_cast_and_exact_landing() {
    let(mut s,a,_)=ordinary_map10_collision_scene();
    let zero:Vec<_>=s.units.iter().filter(|(_,unit)|matches!(unit.kind,world::Kind::Inhibitor|world::Kind::Nexus))
        .map(|(id,unit)|(*id,unit.kind,unit.team,unit.position)).collect();
    assert_eq!(zero.len(),6);
    for team in 0..=1 {for kind in[world::Kind::Inhibitor,world::Kind::Nexus] {
        assert!(zero.iter().any(|(_,actual,t,_)|*actual==kind&&*t==team));
    }}
    for(id,_,_,_)in&zero {assert_eq!(s.target_info(*id).unwrap().radius,0.);}
    let units_before:BTreeSet<_>=s.units.keys().copied().collect();
    let definition_radii:BTreeMap<_,_>=s.world.as_ref().unwrap().config.definitions.iter()
        .map(|(name,d)|(name.clone(),(d.kind,d.radius.to_bits()))).collect();
    assert_eq!(s.players[&a].ranks,[0;4]);s.command(a,Action::Learn{slot:2}).unwrap();
    assert_eq!(s.players[&a].ranks[2],1);
    let origin=s.players[&a].position;let landing=Point{x:5475.,z:7000.};let mana=s.players[&a].mana;
    s.command(a,Action::CastAt{slot:2,point:landing}).unwrap();
    assert_eq!(s.players[&a].mana,mana-90.);assert_eq!(s.players[&a].cooldowns[2],570);
    let census=s.ezreal_e_census().unwrap();
    for(id,_,_,_)in&zero {assert!(census.iter().any(|(target,info)|target==id&&info.radius==0.));}
    // The native zero is retained as a point, so the caster disk cannot occupy it.
    assert_eq!(s.ezreal_e_landing(a,zero[0].3,&census).unwrap_err(),"Ezreal E landing occupied");
    until(&mut s,7);assert_eq!(s.players[&a].position,origin);until(&mut s,8);
    assert_eq!(s.players[&a].position,landing);assert_eq!(s.players[&a].height,s.navigation.ground(landing).unwrap());
    assert_eq!(s.players[&a].mana,mana-90.);assert_eq!(s.players[&a].cooldowns[2],570);
    assert!(s.ezreal_e.pending.is_empty()&&s.ezreal_e.bolts.is_empty()&&s.ezreal_e_faults().is_empty());
    assert_eq!(s.units.keys().copied().collect::<BTreeSet<_>>(),units_before);
    assert_eq!(s.world.as_ref().unwrap().config.definitions.iter()
        .map(|(name,d)|(name.clone(),(d.kind,d.radius.to_bits()))).collect::<BTreeMap<_,_>>(),definition_radii);
    for(id,kind,team,position)in zero {let unit=&s.units[&id];assert_eq!((unit.kind,unit.team,unit.position),(kind,team,position));}
}

#[test]
fn malformed_mobile_or_structure_collision_still_rejects_atomically_and_paid_release_never_blinks() {
    let malformed=[(true,0.),(true,-1.),(true,f32::NAN),(true,f32::INFINITY),(true,f32::NEG_INFINITY),
        (false,-1.),(false,f32::NAN),(false,f32::INFINITY),(false,f32::NEG_INFINITY)];
    for(mobile,radius)in malformed {
        let(mut s,a,_)=ordinary_map10_collision_scene();s.command(a,Action::Learn{slot:2}).unwrap();
        let target=if mobile {s.spawn_unit("Blue_Minion_Basic","E invalid mobile",1,Point{x:7000.,z:7000.},0.,0.,None,None).unwrap()}
            else {*s.units.iter().find(|(_,u)|u.kind==world::Kind::Inhibitor).unwrap().0};
        let definition=s.units[&target].definition.clone();
        s.world.as_mut().unwrap().config.definitions.get_mut(&definition).unwrap().radius=radius;
        let before=state(&s);
        assert_eq!(s.command(a,Action::CastAt{slot:2,point:Point{x:5475.,z:7000.}}).unwrap_err(),"Ezreal E target collision invalid");
        assert_eq!(state(&s),before);
    }
    // A mobile definition cannot borrow the exception by forging only unit.kind.
    let(mut s,a,_)=ordinary_map10_collision_scene();s.command(a,Action::Learn{slot:2}).unwrap();
    let bad=s.spawn_unit("Blue_Minion_Basic","E mismatched kind",1,Point{x:7000.,z:7000.},0.,0.,None,None).unwrap();
    s.units.get_mut(&bad).unwrap().kind=world::Kind::Inhibitor;
    s.world.as_mut().unwrap().config.definitions.get_mut("Blue_Minion_Basic").unwrap().radius=0.;
    let before=state(&s);assert_eq!(s.command(a,Action::CastAt{slot:2,point:Point{x:5475.,z:7000.}}).unwrap_err(),"Ezreal E target collision invalid");assert_eq!(state(&s),before);
    // The same census guard is reapplied at release, after the single payment.
    let(mut s,a,_)=ordinary_map10_collision_scene();s.command(a,Action::Learn{slot:2}).unwrap();
    let origin=s.players[&a].position;s.command(a,Action::CastAt{slot:2,point:Point{x:5475.,z:7000.}}).unwrap();
    let mana=s.players[&a].mana;let cooldowns=s.players[&a].cooldowns;
    s.spawn_unit("Blue_Minion_Basic","E late invalid mobile",1,Point{x:7000.,z:7000.},0.,0.,None,None).unwrap();
    s.world.as_mut().unwrap().config.definitions.get_mut("Blue_Minion_Basic").unwrap().radius=0.;
    until(&mut s,8);assert_eq!(s.players[&a].position,origin);assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns,cooldowns);
    assert!(s.ezreal_e.pending.is_empty()&&s.ezreal_e.bolts.is_empty());
    assert_eq!(s.ezreal_e_faults().len(),1);assert_eq!(s.ezreal_e_faults()[0].stage,"release");
    assert_eq!(s.ezreal_e_faults()[0].reason,"Ezreal E target collision invalid");
    s.advance_ezreal_e();assert_eq!(s.ezreal_e_faults().len(),1);assert_eq!(s.players[&a].mana,mana);
}


#[test]
fn e_cast_projection_is_current_visible_read_only_and_retires_at_actual_release() {
    let(mut sim,a,b)=game();sim.tick=100;cast(&mut sim,a);
    let before=state(&sim);let rows=sim.snapshot_for(b).unwrap().ezreal_e_casts;
    assert_eq!(rows.len(),1);assert_eq!(rows[0].releases,108);assert_eq!(rows[0].ordinal,1);
    assert_eq!(rows[0].facing,sim.ezreal_e.pending[&a].facing);assert_eq!(state(&sim),before);
    assert!(sim.snapshot().ezreal_e_casts.is_empty());
    assert_eq!(sim.snapshot_for_atomic(a).unwrap().ezreal_e_casts,rows);
    until(&mut sim,108);assert!(sim.ezreal_e_cast_projection(a).is_empty());
    close(sim.players[&a].position.x,675.);assert!(sim.ezreal_e.pending.is_empty());
}

#[test]
fn e_cast_projection_interruption_is_immediate_read_only_and_matches_pending_phase() {
    for mode in 0..4 {
        let(mut sim,a,b)=game();sim.tick=100;cast(&mut sim,a);sim.tick=101;
        let origin=sim.players[&a].position;let player=sim.players.get_mut(&a).unwrap();
        match mode {0=>player.stuns.push(stuns::Stun{tag:"E interrupted".into(),source:Some(b),expires_at:120}),
            1=>player.effects.silence_until=120,
            2=>player.effects.trundle_e_push=Some(trundle_e::ForcedMovement{started:101,until:112}),
            _=>player.position.z+=10.}
        let position=sim.players[&a].position;let before=state(&sim);
        assert!(sim.ezreal_e_cast_projection(a).is_empty());assert_eq!(state(&sim),before);
        assert!(sim.ezreal_e.pending.contains_key(&a),"projection is not the gameplay phase");
        sim.advance_ezreal_e();assert!(!sim.ezreal_e.pending.contains_key(&a));
        assert_eq!(sim.players[&a].position,position);assert_ne!(sim.players[&a].position,aim());
        if mode<3 {assert_eq!(sim.players[&a].position,origin);}
    }
}

#[test]
fn e_cast_projection_fog_death_session_and_end_never_leak_landing_or_history() {
    let(mut sim,a,b)=game();sim.enable_map10().unwrap();sim.units.clear();
    sim.players.get_mut(&a).unwrap().position=Point{x:200.,z:300.};
    sim.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};cast(&mut sim,a);
    assert!(!sim.visible_to(sim.players[&b].team,a));assert!(sim.ezreal_e_cast_projection(b).is_empty());
    assert_eq!(sim.ezreal_e_cast_projection(a).len(),1);
    sim.players.get_mut(&b).unwrap().position=Point{x:300.,z:300.};assert_eq!(sim.ezreal_e_cast_projection(b).len(),1);
    let row=serde_json::to_value(sim.ezreal_e_cast_projection(a)[0]).unwrap();
    let keys:std::collections::BTreeSet<_>=row.as_object().unwrap().keys().map(String::as_str).collect();
    assert_eq!(keys,["session","owner","team","ordinal","releases","facing"].into_iter().collect());
    sim.players.get_mut(&a).unwrap().health=0.;assert!(sim.ezreal_e_cast_projection(b).is_empty());
    sim.players.get_mut(&a).unwrap().health=100.;sim.winner=Some(0);assert!(sim.ezreal_e_cast_projection(a).is_empty());
    sim.winner=None;sim.session+=1;let before=state(&sim);assert!(sim.ezreal_e_cast_projection(a).is_empty());assert_eq!(state(&sim),before);
}

#[test]
fn e_cast_projection_corruption_duplicate_overflow_and_budget_fail_without_partial_prefix() {
    for mode in 0..12 {
        let(mut sim,a,b)=game();let other=sim.join("ezreal").unwrap();
        let player=sim.players.get_mut(&other).unwrap();player.ranks[2]=1;player.mana=2000.;player.position=Point{x:200.,z:700.};
        cast(&mut sim,a);sim.command(other,Action::CastAt{slot:2,point:Point{x:675.,z:700.}}).unwrap();
        match mode {
            0=>sim.ezreal_e.pending.get_mut(&other).unwrap().releases=7,
            1=>sim.ezreal_e.pending.get_mut(&other).unwrap().releases=u64::MAX,
            2=>sim.ezreal_e.pending.get_mut(&other).unwrap().landing.x=f32::NAN,
            3=>sim.ezreal_e.pending.get_mut(&other).unwrap().expires+=1,
            4=>sim.ezreal_e.pending.get_mut(&other).unwrap().session+=1,
            5=>sim.ezreal_e.pending.get_mut(&other).unwrap().raw=f32::INFINITY,
            6=>{let ordinal=sim.ezreal_e.pending[&a].ordinal;sim.ezreal_e.pending.get_mut(&other).unwrap().ordinal=ordinal;},
            7=>sim.players.get_mut(&other).unwrap().id=9999,
            8=>sim.players.get_mut(&other).unwrap().health=f32::NAN,
            9=>sim.ezreal_e.next_ordinal=0,
            10=>sim.ezreal_e.last_advanced=Some(1),
            _=>{for ordinal in 0..MAX_CASTS {sim.ezreal_e.bolts.push(Bolt{session:420,owner:a,team:0,
                ordinal:ordinal as u64+100,target:b,position:aim(),expires:100,raw:75.,current:None});}}
        }
        let before=state(&sim);assert!(sim.ezreal_e_cast_projection(a).is_empty(),"case{mode}");assert_eq!(state(&sim),before);
    }
}

#[test]
fn e_optional_wire_roundtrip_preserves_full_identity_and_absent_legacy_default() {
    let(mut sim,a,_)=game();sim.session=u64::MAX-100;sim.tick=(1u64<<53)+100;
    sim.ezreal_e.next_ordinal=(1u64<<53)+5;cast(&mut sim,a);let mut snapshot=sim.snapshot_for(a).unwrap();
    let row=snapshot.ezreal_e_casts[0];assert!(row.ordinal>1u64<<53);
    let mut legacy=serde_json::to_value(&snapshot).unwrap();legacy.as_object_mut().unwrap().remove("ezreal_e_casts");
    assert!(serde_json::from_value::<Snapshot>(legacy).unwrap().ezreal_e_casts.is_empty());
    let mut bad=serde_json::to_value(row).unwrap();bad["facing"]["yaw_degrees"]=serde_json::json!(90.);
    assert!(serde_json::from_value::<VisibleCast>(bad).is_err());
    snapshot.ezreal_e_casts=(0..MAX_CASTS).map(|n|VisibleCast{ordinal:row.ordinal+n as u64,..row}).collect();
    let context=crate::session_transport::Context{session:sim.session,player:a,epoch:u64::MAX-10};
    let mut sender=crate::session_wire::Sender::new(context).unwrap();let packets=sender.encode(&snapshot,11).unwrap();
    assert!(packets.iter().all(|p|p.len()<=1200));let mut receiver=crate::session_wire::Assembler::new(context).unwrap();let mut result=None;
    for packet in packets.iter().rev(){if let Some(frame)=receiver.push(packet).unwrap(){result=Some(frame);}}
    let decoded=result.unwrap().decode().unwrap();assert_eq!(decoded.snapshot.ezreal_e_casts,snapshot.ezreal_e_casts);assert_eq!(decoded.clock_ordinal,11);
    let packets=crate::wire::state_datagrams(&snapshot).unwrap();assert!(packets.iter().all(|p|p.len()<=1200));
    let mut legacy=crate::wire::StateAssembler::default();let mut result=None;
    for packet in packets.iter().rev(){if let Some(bytes)=legacy.push(packet,Some(sim.session)){result=Some(bytes);}}
    let ServerPacket::State(decoded)=serde_json::from_slice(&result.unwrap()).unwrap()else{panic!("State required")};
    assert_eq!(decoded.ezreal_e_casts,snapshot.ezreal_e_casts);
}
