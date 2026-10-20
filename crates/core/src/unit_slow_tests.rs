use crate::*;
fn point(x:f32)->Point {Point{x,z:100.}}
fn game(first:&str,second:&str)->(Simulation,u32,u32) {
    let mut bytes=Vec::new();for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap()).unwrap();
    s.enable_map10().unwrap();s.interactions=None;s.session=8401;
    let a=s.join(first).unwrap();let b=s.join(second).unwrap();
    s.players.get_mut(&a).unwrap().position=point(100.);
    s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};
    (s,a,b)
}
fn unit(s:&mut Simulation,definition:&str,team:u8,x:f32)->u32 {
    s.spawn_unit(definition,"npc_slow_fixture",team,point(x),0.,0.,None,None).unwrap()
}
fn path(s:&mut Simulation,id:u32,goal:f32) {
    let u=s.units.get_mut(&id).unwrap();u.path=VecDeque::from([point(goal)]);u.destination=Some(point(goal));u.next_ai=u64::MAX;
}
fn speed(s:&Simulation,id:u32)->f32 {s.world.as_ref().unwrap().config.definitions[&s.units[&id].definition].move_speed}
fn distance_step(s:&mut Simulation,id:u32)->f32 {let before=s.units[&id].position;s.advance();before.distance(s.units[&id].position)}
fn approx(a:f32,b:f32) {assert!((a-b).abs()<0.001,"{a} != {b}");}
fn raw(s:&Simulation,id:u32)->f32 {let rank=s.players[&id].effects.trundle_q.armed_rank;let q=trundle_q::rules(rank).unwrap();q.base+q.ad_coefficient*s.stats(id).damage}
fn pet()->(Simulation,u32,u32,u32) {
    let(mut s,a,b)=game("annie","trundle");s.players.get_mut(&a).unwrap().level=6;s.learn(a,3).unwrap();
    s.cast_at(a,3,point(300.)).unwrap();s.tick=8;s.advance_annie_r();let id=s.tibbers(a).unwrap();(s,a,b,id)
}

#[test]
fn lane_and_monster_slow_modify_actual_motion_until_exact_expiry_without_softcap() {
    for definition in ["Blue_Minion_Basic","TT_NWolf"] {
        let(mut s,_,_)=game("trundle","garen");let id=unit(&mut s,definition,0,100.);path(&mut s,id,600.);
        let base=speed(&s,id);approx(distance_step(&mut s,id),base/TICK_RATE as f32);
        let order=s.units[&id].destination;let recovery=s.units[&id].next_attack;
        s.grant_slow(id,"timed",0.5,3).unwrap();assert_eq!(s.units[&id].slows[0].expires_at,4);
        for expected in [2,3] {approx(distance_step(&mut s,id),base*0.5/TICK_RATE as f32);assert_eq!(s.tick,expected);}
        approx(distance_step(&mut s,id),base/TICK_RATE as f32);assert!(s.units[&id].slows.is_empty());
        assert_eq!(s.units[&id].destination,order);assert_eq!(s.units[&id].next_attack,recovery);
    }
}

#[test]
fn npc_refresh_and_dynamic_pillar_slow_take_maximum_in_actual_motion() {
    let(mut s,a,_)=game("trundle","garen");s.players.get_mut(&a).unwrap().ranks[2]=1;
    let id=unit(&mut s,"Blue_Minion_Basic",1,700.);path(&mut s,id,1000.);
    s.cast_at(a,2,point(500.)).unwrap();assert_eq!(s.trundle_e_slow(id),0.25);
    let base=speed(&s,id);s.grant_slow(id,"other",0.2,30).unwrap();s.grant_slow(id,"refresh",0.6,3).unwrap();
    approx(distance_step(&mut s,id),base*0.4/TICK_RATE as f32);
    s.grant_slow(id,"refresh",0.5,4).unwrap();assert_eq!(s.units[&id].slows.len(),2);
    assert_eq!(s.units[&id].slows.iter().find(|v|v.tag=="refresh").unwrap().expires_at,5);
    for _ in 2..=4 {approx(distance_step(&mut s,id),base*0.5/TICK_RATE as f32);}
    approx(distance_step(&mut s,id),base*0.75/TICK_RATE as f32);
    assert_eq!(s.tick,5);assert_eq!(slows::unit_strongest(&s.units[&id],s.tick),0.2);
    assert_eq!(s.units[&id].slows.len(),1);assert_eq!(s.trundle_e_slow(id),0.25);
}

#[test]
fn unsupported_npc_and_invalid_slow_events_are_atomic_not_native_immunity_claims() {
    for case in 0..13 {
        let(mut s,_,_)=game("trundle","garen");let id=unit(&mut s,"Blue_Minion_Basic",1,200.);
        let(mut target,mut tag,mut fraction,mut duration)=(id,"valid",0.5,30);
        match case {
            0=>target=u32::MAX,1=>tag="",2=>fraction=f32::NAN,3=>fraction=f32::INFINITY,
            4=>fraction=0.,5=>fraction=1.1,6=>duration=0,7=>s.units.get_mut(&id).unwrap().health=0.,
            8=>s.units.get_mut(&id).unwrap().health=f32::NAN,
            9=>s.winner=Some(0),10=>s.units.get_mut(&id).unwrap().kind=world::Kind::Boss,
            11=>s.units.get_mut(&id).unwrap().definition="UnknownDefinition".into(),
            _=>s.units.get_mut(&id).unwrap().kind=world::Kind::Pet,
        }
        let before=(serde_json::to_value(&s.players).unwrap(),serde_json::to_value(&s.units).unwrap());
        assert!(s.grant_slow(target,tag,fraction,duration).is_err());
        assert_eq!((serde_json::to_value(&s.players).unwrap(),serde_json::to_value(&s.units).unwrap()),before);
        assert!(s.units[&id].slows.is_empty());
    }
    let(mut s,_,_)=game("trundle","garen");
    for definition in ["TT_Spiderboss","TT_OrderTurret1","TT_OrderInhibitor","OrderNexus"] {
        let id=unit(&mut s,definition,1,200.);let before=serde_json::to_value(&s.units).unwrap();
        assert_eq!(s.grant_slow(id,"unsupported",0.5,30).unwrap_err(),"NPC slow policy not qualified for this definition");
        assert_eq!(serde_json::to_value(&s.units).unwrap(),before);
    }
}

#[test]
fn only_identified_tibbers_not_an_arbitrary_pet_definition_is_admitted() {
    let(mut s,_,_,id)=pet();s.grant_slow(id,"tibbers",0.5,30).unwrap();
    let mut fake=s.world.as_ref().unwrap().config.definitions["annietibbers"].clone();fake.id="other_pet".into();
    s.world.as_mut().unwrap().config.definitions.insert("other_pet".into(),fake);
    let other=unit(&mut s,"other_pet",1,500.);let before=serde_json::to_value(&s.units).unwrap();
    assert!(s.grant_slow(other,"unknown_pet",0.5,30).is_err());
    assert_eq!(serde_json::to_value(&s.units).unwrap(),before);assert_eq!(s.units[&id].slows.len(),1);
}

#[test]
fn npc_combat_death_clears_slows_before_retained_corpse_and_rejects_new_events() {
    let(mut s,a,_)=game("trundle","garen");let id=unit(&mut s,"TT_NWolf",2,200.);
    s.grant_slow(id,"live",0.5,300).unwrap();s.apply_damage(Some(a),id,100000.,damage::DamageKind::True).unwrap();
    assert_eq!(s.units[&id].health,0.);assert!(s.units[&id].slows.is_empty());assert!(s.units[&id].remove_at.is_some());
    assert!(s.grant_slow(id,"dead",0.5,30).is_err());
}

#[test]
fn slowed_tibbers_keeps_order_regeneration_aura_and_natural_lifetime() {
    let(mut s,owner,enemy,id)=pet();s.players.get_mut(&enemy).unwrap().position=point(300.);
    s.cast_at(owner,3,point(800.)).unwrap();let expires=s.units[&id].pet.as_ref().unwrap().expires;
    let pulse=s.units[&id].pet.as_ref().unwrap().next_aura;s.units.get_mut(&id).unwrap().health=1000.;
    s.grant_slow(id,"lasting",0.5,expires+100).unwrap();let hp=s.players[&enemy].health;s.tick=pulse-1;
    s.advance();assert!(s.units[&id].health>1000.);assert!(s.players[&enemy].health<hp);
    assert!(matches!(s.units[&id].pet.as_ref().unwrap().order,annie_r::Order::Move{..}));
    assert_eq!(s.units[&id].pet.as_ref().unwrap().expires,expires);assert!(s.units[&id].pet.as_ref().unwrap().next_aura>pulse);
    s.tick=expires-1;s.advance();assert_eq!(s.units[&id].health,0.);assert!(s.units[&id].slows.is_empty());
}

#[test]
fn owner_departure_clears_tibbers_slow_in_the_normal_advance_phase() {
    let(mut s,owner,_,id)=pet();s.grant_slow(id,"lasting",0.5,300).unwrap();s.players.remove(&owner);
    s.advance();assert_eq!(s.units[&id].health,0.);assert!(s.units[&id].slows.is_empty());
}

#[test]
fn old_unit_json_defaults_slows_empty_and_populated_snapshot_roundtrips() {
    let(mut s,_,_)=game("trundle","garen");let id=unit(&mut s,"Blue_Minion_Wizard",1,200.);
    let mut legacy=serde_json::to_value(&s.units[&id]).unwrap();assert!(legacy.get("slows").is_none());
    legacy.as_object_mut().unwrap().remove("slows");let restored:world::Unit=serde_json::from_value(legacy).unwrap();
    assert!(restored.slows.is_empty());assert!(serde_json::to_value(restored).unwrap().get("slows").is_none());
    s.grant_slow(id,"serialized",0.4,30).unwrap();let encoded=serde_json::to_vec(&s.snapshot()).unwrap();
    let decoded:Snapshot=serde_json::from_slice(&encoded).unwrap();let u=decoded.units.iter().find(|u|u.id==id).unwrap();
    assert_eq!((u.slows[0].tag.as_str(),u.slows[0].fraction,u.slows[0].expires_at),("serialized",0.4,30));
}

#[test]
fn both_snapshot_wire_paths_preserve_visible_npc_slow_tags() {
    let(mut s,a,_)=game("trundle","garen");let id=unit(&mut s,"Blue_Minion_Basic",1,200.);s.grant_slow(id,"wire",0.4,30).unwrap();
    let state=s.snapshot_for(a).unwrap();let mut assembler=wire::StateAssembler::default();let mut blob=None;
    for bytes in wire::state_datagrams(&state).unwrap().into_iter().rev() {if let Some(b)=assembler.push(&bytes,Some(s.session)){blob=Some(b);}}
    let ServerPacket::State(legacy)=serde_json::from_slice::<ServerPacket>(&blob.unwrap()).unwrap() else {panic!("wrong legacy packet")};
    assert_eq!(legacy.units.iter().find(|u|u.id==id).unwrap().slows[0].tag,"wire");
    let context=session_transport::Context{session:s.session,player:a,epoch:1};
    let mut sender=session_wire::Sender::new(context).unwrap();let mut assembler=session_wire::Assembler::new(context).unwrap();let mut completed=None;
    for bytes in sender.encode(&state,0).unwrap().into_iter().rev() {if let Some(v)=assembler.push(&bytes).unwrap(){completed=Some(v);}}
    let resumed=completed.unwrap().decode().unwrap();assert_eq!(resumed.snapshot.units.iter().find(|u|u.id==id).unwrap().slows[0].tag,"wire");
}

#[test]
fn hidden_unit_slow_does_not_bypass_snapshot_vision_filtering() {
    let(mut s,a,_)=game("trundle","garen");s.enable_interactions();s.units.clear();
    let near=unit(&mut s,"Red_Minion_Basic",1,200.);let far=unit(&mut s,"Red_Minion_Basic",1,3500.);
    s.grant_slow(near,"visible_effect",0.4,30).unwrap();s.grant_slow(far,"hidden_effect",0.4,30).unwrap();
    let state=s.snapshot_for(a).unwrap();assert!(state.units.iter().any(|u|u.id==near));assert!(!state.units.iter().any(|u|u.id==far));
    assert!(!serde_json::to_string(&state).unwrap().contains("hidden_effect"));
}

#[test]
fn q_impact_slows_supported_monster_after_its_impact_tick_motion_only() {
    let(mut s,a,_)=game("trundle","garen");let id=unit(&mut s,"TT_NWolf",2,150.);path(&mut s,id,600.);
    s.players.get_mut(&a).unwrap().ranks[0]=1;s.cast(a,0,None).unwrap();s.command(a,Action::Attack{target:id}).unwrap();
    s.tick=1;s.advance_attacks();let impact=s.players[&a].windup.as_ref().unwrap().release;s.tick=impact-1;
    let base=speed(&s,id);approx(distance_step(&mut s,id),base/TICK_RATE as f32);
    assert_eq!(s.tick,impact);assert_eq!(s.units[&id].slows[0].expires_at,impact+3);
    for _ in 0..2 {approx(distance_step(&mut s,id),base*0.25/TICK_RATE as f32);}
    approx(distance_step(&mut s,id),base/TICK_RATE as f32);assert!(s.units[&id].slows.is_empty());
}

#[test]
fn q_supported_tibbers_slow_survives_source_retaliation_and_omits_lethal_target() {
    for lethal in [false,true] {
        let(mut s,_,source,id)=pet();s.players.get_mut(&source).unwrap().position=point(350.);
        s.players.get_mut(&source).unwrap().ranks[0]=1;s.players.get_mut(&source).unwrap().health=1.;
        let u=s.units.get_mut(&id).unwrap();u.pet.as_mut().unwrap().molten_rank=5;u.pet.as_mut().unwrap().molten_until=1000;
        if lethal {u.health=1.;s.grant_slow(id,"old",0.2,100).unwrap();}
        s.cast(source,0,None).unwrap();let damage=raw(&s,source);let outcome=s.trundle_q_attack_hit(source,id,damage,1).unwrap();
        assert_eq!(outcome.lethal,lethal);
        if lethal {assert!(s.units[&id].slows.is_empty());} else {assert_eq!(s.players[&source].health,0.);assert_eq!(s.units[&id].slows.len(),1);assert_eq!(s.units[&id].slows[0].tag,trundle_q::BRIEF_SLOW_TAG);}
    }
}
