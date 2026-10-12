use crate::*;
fn game()->(Simulation,u32,u32) {
 let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
 let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap()).unwrap();s.enable_map10().unwrap();s.interactions=None;let a=s.join("annie").unwrap();let b=s.join("garen").unwrap();for id in [a,b] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x:400.,z:400.};p.level=6;p.mana=1000.;}for slot in 0..4 {s.learn(a,slot).unwrap();}(s,a,b)
}
#[test] fn four_accepted_nonoffensive_casts_prepare_stun_without_modern_spawn_charges() {
 let(mut s,a,_)=game();assert_eq!(s.players[&a].effects.pyromania,0);
 for count in 1..=4 {s.cast(a,2,None).unwrap();assert_eq!(s.players[&a].effects.pyromania,count);s.tick+=300;}
 s.cast(a,2,None).unwrap();assert_eq!(s.players[&a].effects.pyromania,4);
 let mana=s.players[&a].mana;assert!(s.cast(a,2,None).is_err());assert_eq!(s.players[&a].effects.pyromania,4);assert_eq!(s.players[&a].mana,mana);
 let blob=serde_json::to_string(&s.snapshot()).unwrap();let snap:Snapshot=serde_json::from_str(&blob).unwrap();assert_eq!(snap.players.iter().find(|p|p.id==a).unwrap().effects.pyromania,4);
}
#[test] fn q_charge_is_delayed_until_hit_and_e_can_prepare_inflight_stun() {
 for shield in [false,true] {
  let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.x=850.;s.players.get_mut(&a).unwrap().effects.pyromania=3;
  s.cast(a,0,Some(b)).unwrap();assert_eq!(s.players[&a].effects.pyromania,3);s.tick=8;s.advance_annie();assert_eq!(s.players[&a].effects.pyromania,3);
  if shield {s.cast(a,2,None).unwrap();assert_eq!(s.players[&a].effects.pyromania,4);}
  for tick in 9..=18 {s.tick=tick;s.advance_annie();}
  assert_eq!(s.players[&a].effects.pyromania,if shield {0} else {4});assert_eq!(stuns::active(&s.players[&b],s.tick),shield);
  if shield {assert_eq!(s.players[&b].stuns[0].expires_at,s.tick+45);}
 }
}
#[test] fn w_applies_one_empowered_event_to_all_enemies_and_never_to_allies() {
 let(mut s,a,b)=game();let other=s.join("annie").unwrap();let c=s.join("garen").unwrap();for id in [b,other,c] {s.players.get_mut(&id).unwrap().position=Point{x:500.,z:400.};}s.players.get_mut(&a).unwrap().effects.pyromania=4;
 s.cast_at(a,1,Point{x:800.,z:400.}).unwrap();s.tick=8;s.advance_annie_w();assert_eq!(s.players[&a].effects.pyromania,0);
 for id in [b,c] {assert!(stuns::active(&s.players[&id],8));assert_eq!(s.players[&id].stuns[0].source,Some(a));}assert!(!stuns::active(&s.players[&other],8));
}
#[test] fn r_stuns_on_summon_but_guide_aura_and_reflection_do_not_charge_or_consume() {
 let(mut s,a,b)=game();let point=s.players[&a].position;s.players.get_mut(&a).unwrap().effects.pyromania=4;s.cast_at(a,3,point).unwrap();s.tick=8;s.advance_annie_r();assert_eq!(s.players[&a].effects.pyromania,0);assert!(stuns::active(&s.players[&b],8));
 s.players.get_mut(&a).unwrap().effects.pyromania=4;s.cast_at(a,3,point).unwrap();assert_eq!(s.players[&a].effects.pyromania,4);s.tick=38;s.advance_pet_aura();assert_eq!(s.players[&a].effects.pyromania,4);
 s.cast(a,2,None).unwrap();s.basic_attack_hit(b,a,10.).unwrap();assert_eq!(s.players[&a].effects.pyromania,4);
}
#[test] fn passive_duration_level_boundaries_use_existing_tenacity_once() {
 for (level,ticks) in [(1,38),(5,38),(6,45),(10,45),(11,53),(18,53)] {
  let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=level;s.players.get_mut(&a).unwrap().effects.pyromania=4;let duration=s.pyromania_spell(a,true);assert_eq!(duration,ticks);s.pyromania_hit(a,b,duration);assert_eq!(s.players[&b].stuns[0].expires_at,ticks);
 }
 let(mut s,a,b)=game();s.learn(b,1).unwrap();s.cast(b,1,None).unwrap();s.players.get_mut(&a).unwrap().effects.pyromania=4;let d=s.pyromania_spell(a,true);s.pyromania_hit(a,b,d);assert_eq!(s.players[&b].stuns[0].expires_at,32);
}
#[test] fn lethal_and_invalid_q_do_not_stun_and_dead_target_flights_leave_charges_unchanged() {
 let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().effects.pyromania=4;assert!(s.cast(a,0,Some(a)).is_err());assert_eq!(s.players[&a].effects.pyromania,4);s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,Some(b)).unwrap();s.tick=8;s.advance_annie();s.tick=9;s.advance_annie();assert_eq!(s.players[&a].effects.pyromania,0);assert_eq!(s.players[&b].health,0.);assert!(s.players[&b].stuns.is_empty());
 let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().effects.pyromania=4;s.cast(a,0,Some(b)).unwrap();s.tick=8;s.advance_annie();s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();s.tick=9;s.advance_annie();assert_eq!(s.players[&a].effects.pyromania,4);
}
