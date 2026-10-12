use crate::*;
fn game()->(Simulation,u32,u32) {
 let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
 let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap()).unwrap();s.enable_map10().unwrap();s.interactions=None;let a=s.join("annie").unwrap();let b=s.join("garen").unwrap();for id in [a,b] {s.players.get_mut(&id).unwrap().position=Point{x:400.,z:400.};}(s,a,b)
}
fn unit(s:&mut Simulation,name:&str,team:u8,point:Point)->u32 {s.spawn_unit(name,"stun_fixture",team,point,0.,0.,None,None).unwrap()}
#[test] fn lane_movement_pauses_without_losing_route_and_resumes_at_exact_expiry() {
 let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=Point{x:900.,z:900.};s.players.get_mut(&b).unwrap().position=Point{x:900.,z:900.};let u=unit(&mut s,"Blue_Minion_Basic",0,Point{x:100.,z:100.});s.units.get_mut(&u).unwrap().route.push_back(Point{x:500.,z:100.});s.advance();let before=s.units[&u].position;let path=s.units[&u].path.clone();let route=s.units[&u].route.clone();s.grant_stun(Some(b),u,"test",6).unwrap();
 for _ in 0..5 {s.advance();assert_eq!(s.units[&u].position,before);assert_eq!(s.units[&u].path,path);assert_eq!(s.units[&u].route,route);}s.advance();assert!(!stuns::unit_active(&s.units[&u],s.tick));assert_ne!(s.units[&u].position,before);
}
#[test] fn windup_stun_cancels_npc_melee_hit_but_keeps_attack_recovery() {
 let(mut s,_a,b)=game();let u=unit(&mut s,"Blue_Minion_Basic",0,Point{x:400.,z:400.});s.advance_world();let recovery=s.units[&u].next_attack;assert_eq!(recovery,24);let hp=s.players[&b].health;s.grant_stun(Some(b),u,"test",30).unwrap();s.tick=21;s.advance_world();assert_eq!(s.players[&b].health,hp);assert_eq!(s.units[&u].next_attack,recovery);s.tick=30;s.advance_stuns();s.advance_world();assert_eq!(s.units[&u].next_attack,54);s.tick=51;s.advance_world();assert!(s.players[&b].health<hp);
}
#[test] fn released_ranged_shots_survive_stun_or_death_but_unreleased_windups_do_not() {
 for after_release in [false,true] {for death in [false,true] {
  let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=Point{x:100.,z:100.};s.players.get_mut(&b).unwrap().position=Point{x:700.,z:400.};let u=unit(&mut s,"Blue_Minion_Wizard",0,Point{x:400.,z:400.});let hp=s.players[&b].health;s.advance_world();s.tick=if after_release {15} else {14};s.advance_world();
  if death {s.apply_damage(Some(b),u,10000.,damage::DamageKind::True).unwrap();} else {s.grant_stun(Some(b),u,"test",100).unwrap();}
  s.tick=28;s.advance_world();assert_eq!(s.players[&b].health,hp);s.tick=29;s.advance_world();if after_release {assert!(s.players[&b].health<hp);} else {assert_eq!(s.players[&b].health,hp);}
 }}
}
#[test] fn npc_tags_serialization_guards_and_death_cleanup_are_atomic() {
 let(mut s,a,b)=game();let u=unit(&mut s,"Blue_Minion_Basic",0,Point{x:100.,z:100.});for (source,tag,duration) in [(Some(999),"test",10),(None,"",10),(None,"test",0)] {assert!(s.grant_stun(source,u,tag,duration).is_err());assert!(s.units[&u].stuns.is_empty());}
 s.grant_stun(Some(b),u,"one",10).unwrap();s.tick=3;s.grant_stun(Some(b),u,"one",5).unwrap();s.grant_stun(None,u,"two",10).unwrap();assert_eq!(s.units[&u].stuns.len(),2);s.tick=8;s.advance_stuns();assert_eq!(s.units[&u].stuns.len(),1);assert_eq!(s.units[&u].stuns[0].expires_at,13);
 let blob=serde_json::to_string(&s.snapshot()).unwrap();let snap:Snapshot=serde_json::from_str(&blob).unwrap();assert_eq!(snap.units.iter().find(|p|p.id==u).unwrap().stuns[0].source,None);
 s.apply_damage(Some(b),u,10000.,damage::DamageKind::True).unwrap();assert!(s.units[&u].stuns.is_empty());assert_eq!(s.grant_stun(Some(a),u,"test",10).unwrap_err(),"stun target dead");
 let boss=unit(&mut s,"TT_Spiderboss",2,Point{x:100.,z:100.});assert_eq!(s.grant_stun(Some(a),boss,"test",10).unwrap_err(),"boss stun policy not qualified");let turret=s.units.values().find(|u|u.kind==world::Kind::Turret).unwrap().id;assert_eq!(s.grant_stun(Some(a),turret,"test",10).unwrap_err(),"structure stun unsupported");
}
#[test] fn stunned_pet_keeps_queued_guide_aura_regeneration_and_lifetime_without_teleporting() {
 let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=6;s.learn(a,3).unwrap();let point=s.players[&a].position;s.cast_at(a,3,point).unwrap();s.tick=8;s.advance_annie_r();let u=s.tibbers(a).unwrap();s.units.get_mut(&u).unwrap().health=1000.;s.grant_stun(Some(b),u,"test",100).unwrap();let hp=s.players[&b].health;s.tick=38;s.advance_pet_orders();s.advance_world();s.advance_pet_aura();assert!(s.units[&u].health>1000.);assert!(s.players[&b].health<hp);assert_eq!(s.units[&u].next_attack,0);
 let goal=Point{x:100.,z:100.};s.cast_at(a,3,goal).unwrap();s.tick=39;s.advance_pet_orders();s.advance_world();assert_eq!(s.units[&u].position,point);assert!(matches!(s.units[&u].pet.as_ref().unwrap().order,annie_r::Order::Move{..}));s.tick=108;s.advance_stuns();s.advance_pet_orders();s.advance_world();assert_ne!(s.units[&u].position,point);
 s.grant_stun(Some(b),u,"test",2000).unwrap();s.tick=1358;s.advance_pet_orders();assert_eq!(s.units[&u].health,0.);assert!(s.units[&u].stuns.is_empty());
}
#[test] fn pet_source_controls_attribute_champion_execution_credit_to_owner() {
 let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=6;s.learn(a,3).unwrap();let point=s.players[&a].position;s.cast_at(a,3,point).unwrap();s.tick=8;s.advance_annie_r();let u=s.tibbers(a).unwrap();s.grant_stun(Some(u),b,"pet_control_fixture",10).unwrap();s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(a));
}
