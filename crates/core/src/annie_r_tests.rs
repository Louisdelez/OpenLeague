use super::*;
fn game()->(Simulation,u32,u32,Point) {
 let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=Simulation::new(nav).unwrap();s.enable_map10().unwrap();s.interactions=None;
 let a=s.join("annie").unwrap();let b=s.join("garen").unwrap();let point=s.navigation.nearest_walkable(Point{x:7700.,z:7000.}).unwrap();
 for id in [a,b] {let p=s.players.get_mut(&id).unwrap();p.position=point;p.health=p.max_health;p.mana=1000.;p.level=18;}
 s.learn(a,3).unwrap();(s,a,b,point)
}
fn summon(s:&mut Simulation,a:u32,point:Point)->u32 {s.cast_at(a,3,point).unwrap();s.tick+=8;s.advance_annie_r();s.tibbers(a).unwrap()}
#[test] fn all_native_ranks_summon_once_with_native_stats_damage_cost_cooldown_and_lifetime() {
 for rank in 1..=3 {let(mut s,a,b,point)=game();s.players.get_mut(&a).unwrap().ranks[3]=rank;s.players.get_mut(&a).unwrap().inventory[0]=Some(1052);let hp=s.players[&b].health;let mana=s.players[&a].mana;
  s.cast_at(a,3,point).unwrap();assert_eq!(s.players[&a].mana,mana-100.);assert_eq!(s.players[&a].cooldowns[3],(140-20*rank as u64)*30);s.tick=7;s.advance_annie_r();assert!(s.tibbers(a).is_none());assert_eq!(s.players[&b].health,hp);
  s.tick=8;s.advance_annie_r();let id=s.tibbers(a).unwrap();let u=&s.units[&id];assert_eq!(u.health,300.+900.*rank as f32);assert_eq!(u.damage,55.+25.*rank as f32);assert_eq!(u.armor,10.+20.*rank as f32);assert_eq!(u.magic_resist,u.armor);assert_eq!(u.pet.as_ref().unwrap().expires,1358);assert_eq!(u.kind,world::Kind::Pet);
  let expected=(50.+125.*rank as f32+16.)*100./(100.+s.stats(b).magic_resist);assert!((hp-s.players[&b].health-expected).abs()<0.001);
  let hp=s.players[&b].health;s.tick=9;s.advance_annie_r();assert_eq!(s.units.values().filter(|u|u.pet.is_some()).count(),1);assert_eq!(s.players[&b].health,hp);
 }
}
#[test] fn summon_guards_are_atomic_and_committed_cast_survives_control_but_not_death() {
 let(mut s,a,b,point)=game();let mana=s.players[&a].mana;
 assert!(s.cast_at(a,3,Point{x:f32::NAN,z:point.z}).is_err());assert_eq!(s.cast_at(a,3,Point{x:point.x+601.,z:point.z}).unwrap_err(),"spell point out of range");assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns[3],0);
 s.players.get_mut(&a).unwrap().mana=99.;assert_eq!(s.cast_at(a,3,point).unwrap_err(),"insufficient mana");s.players.get_mut(&a).unwrap().mana=mana;
 s.grant_stun(Some(b),a,"test",30).unwrap();assert_eq!(s.cast_at(a,3,point).unwrap_err(),"champion stunned");s.players.get_mut(&a).unwrap().stuns.clear();
 s.cast_at(a,3,point).unwrap();s.command(a,Action::Stop).unwrap();s.grant_stun(Some(b),a,"test",30).unwrap();assert!(s.players[&a].effects.annie_r.is_some());for _ in 0..8 {s.advance();}assert!(s.tibbers(a).is_some());
 let(mut s,a,b,point)=game();s.cast_at(a,3,point).unwrap();s.apply_damage(Some(b),a,10000.,damage::DamageKind::True).unwrap();s.tick=8;s.advance_annie_r();assert!(s.tibbers(a).is_none());
}
#[test] fn q_w_and_r_casts_exclude_each_other_and_e_preserves_committed_r() {
 let(mut s,a,b,point)=game();s.learn(a,0).unwrap();s.learn(a,1).unwrap();s.learn(a,2).unwrap();s.cast_at(a,3,point).unwrap();
 assert_eq!(s.cast(a,0,Some(b)).unwrap_err(),"skill blocked during cast");assert_eq!(s.cast_at(a,1,Point{x:point.x+1.,z:point.z}).unwrap_err(),"skill blocked during cast");s.cast(a,2,None).unwrap();assert!(s.players[&a].effects.annie_r.is_some());
 let(mut s,a,b,point)=game();s.learn(a,0).unwrap();s.cast(a,0,Some(b)).unwrap();assert_eq!(s.cast_at(a,3,point).unwrap_err(),"skill blocked during cast");
}
#[test] fn aura_uses_live_owner_ap_once_per_second_excludes_allies_structures_and_expiration() {
 let(mut s,a,b,point)=game();let ally=s.join("annie").unwrap();s.players.get_mut(&ally).unwrap().position=point;let ally_hp=s.players[&ally].health;let tower=s.units.values().find(|u|u.kind==world::Kind::Turret&&u.team!=s.players[&a].team).unwrap().id;s.units.get_mut(&tower).unwrap().position=point;let tower_hp=s.units[&tower].health;
 let pet=summon(&mut s,a,point);let hp=s.players[&b].health;s.tick=37;s.advance_pet_aura();assert_eq!(s.players[&b].health,hp);s.players.get_mut(&a).unwrap().inventory[0]=Some(1052);s.tick=38;s.advance_pet_aura();let expected=39.*100./(100.+s.stats(b).magic_resist);assert!((hp-s.players[&b].health-expected).abs()<0.001);let hp=s.players[&b].health;s.advance_pet_aura();assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&ally].health,ally_hp);assert_eq!(s.units[&tower].health,tower_hp);
 s.tick=1358;s.advance_pet_aura();assert_eq!(s.players[&b].health,hp);s.advance_pet_orders();assert_eq!(s.units[&pet].health,0.);
}
#[test] fn guide_keeps_original_cooldown_cost_and_ownership_and_is_allowed_when_stunned() {
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);let mana=s.players[&a].mana;let cooldown=s.players[&a].cooldowns[3];s.grant_stun(Some(b),a,"test",30).unwrap();
 s.cast_at(a,3,point).unwrap();assert!(matches!(s.units[&pet].pet.as_ref().unwrap().order,Order::Attack{target} if target==b));assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns[3],cooldown);assert_eq!(s.units[&pet].pet.as_ref().unwrap().expires,1358);
 let other=s.join("annie").unwrap();assert_eq!(s.cast_at(other,3,s.players[&other].position).unwrap_err(),"skill not learned");assert_eq!(s.tibbers(other),None);
 s.players.get_mut(&b).unwrap().position=Point{x:point.x+1000.,z:point.z};let goal=s.navigation.nearest_walkable(Point{x:point.x-150.,z:point.z}).unwrap();s.cast_at(a,3,goal).unwrap();assert!(matches!(s.units[&pet].pet.as_ref().unwrap().order,Order::Move{..}));let start=s.units[&pet].position;s.advance_pet_orders();s.advance_world();assert!(s.units[&pet].position.distance(start)>0.);assert_eq!(s.units[&pet].target,None);
}
#[test] fn pet_basic_attack_credit_bounty_and_expiry_do_not_inherit_owner_items() {
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);s.players.get_mut(&a).unwrap().inventory[0]=Some(3035);s.players.get_mut(&a).unwrap().inventory[1]=Some(1053);s.players.get_mut(&a).unwrap().health=100.;
 let expected=80.*100./(100.+s.stats(b).armor);let out=s.basic_attack_hit(pet,b,80.).unwrap();assert_eq!(out.source,Some(pet));assert!((out.post_mitigation-expected).abs()<0.001);assert_eq!(s.players[&a].health,100.);
 let gold=s.players[&a].gold;s.apply_damage(Some(pet),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.players[&a].gold,gold+400.);assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(a));
 let p=s.players.get_mut(&b).unwrap();p.health=p.max_health;let gold=s.players[&b].gold;s.apply_damage(Some(b),pet,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&b].gold,gold+50.);assert_eq!(s.tibbers(a),None);
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);let gold=s.players[&b].gold;s.tick=1358;s.advance_pet_orders();assert_eq!(s.units[&pet].health,0.);assert_eq!(s.players[&b].gold,gold);assert_eq!(s.tibbers(a),None);
}
#[test] fn pet_ai_attacks_after_native_windup_and_command_cancels_without_resetting_recovery() {
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);let hp=s.players[&b].health;s.advance_pet_orders();s.advance_world();assert_eq!(s.units[&pet].next_attack,56);assert_eq!(s.players[&b].health,hp);
 s.tick=26;s.advance_world();assert_eq!(s.players[&b].health,hp);s.tick=27;s.advance_world();assert!(s.players[&b].health<hp);
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);s.advance_pet_orders();s.advance_world();let hp=s.players[&b].health;let goal=s.navigation.nearest_walkable(Point{x:point.x-150.,z:point.z}).unwrap();s.cast_at(a,3,goal).unwrap();s.tick=28;s.advance_pet_orders();s.advance_world();assert_eq!(s.players[&b].health,hp);assert_eq!(s.units[&pet].next_attack,56);
}
#[test] fn molten_forwarding_adds_defenses_and_returns_damage_until_exact_expiry() {
 let(mut s,a,b,point)=game();s.learn(a,2).unwrap();s.players.get_mut(&a).unwrap().inventory[0]=Some(1052);let pet=summon(&mut s,a,point);s.cast(a,2,None).unwrap();assert_eq!(defense(&s.units[&pet],s.tick),20.);let hp=s.units[&pet].health;let enemy_hp=s.players[&b].health;
 let out=s.basic_attack_hit(b,pet,100.).unwrap();assert!((out.health_removed-100./1.5).abs()<0.001);assert!((hp-s.units[&pet].health-out.health_removed).abs()<0.001);let expected=24.*100./(100.+s.stats(b).magic_resist);assert!((enemy_hp-s.players[&b].health-expected).abs()<0.001);
 s.tick=158;assert_eq!(defense(&s.units[&pet],s.tick),0.);let hp=s.players[&b].health;s.basic_attack_hit(b,pet,100.).unwrap();assert_eq!(s.players[&b].health,hp);
}
#[test] fn teleport_follow_owner_death_and_removed_owner_cleanup_are_scoped_lifecycle_policies() {
 let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);let far=s.navigation.nearest_walkable(Point{x:point.x+2500.,z:point.z}).unwrap();s.units.get_mut(&pet).unwrap().position=far;s.advance_pet_orders();assert!(s.units[&pet].position.distance(s.players[&a].position)<100.);
 s.apply_damage(Some(b),a,10000.,damage::DamageKind::True).unwrap();s.tick=10;s.advance_pet_orders();assert!(s.units[&pet].health>0.);assert!(s.command(a,Action::CastAt{slot:3,point}).is_err());s.players.remove(&a);s.tick=11;s.advance_pet_orders();assert_eq!(s.units[&pet].health,0.);
}

#[test]
fn pet_attack_range_uses_champion_body_and_preserves_native_radius_fields() {
 for (distance, attacks) in [(189.,true),(190.,true),(191.,false)] {
  let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);
  s.players.get_mut(&b).unwrap().position=Point{x:point.x+distance,z:point.z};
  s.units.get_mut(&pet).unwrap().pet.as_mut().unwrap().order=Order::Attack{target:b};
  assert_eq!(s.target_info(b).unwrap().radius,65.);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  s.advance_pet_orders();
  assert_eq!(s.units[&pet].destination.is_none(),attacks,"distance {distance}");
  if attacks {s.advance_world();assert!(s.units[&pet].next_attack>0);assert_eq!(s.units[&pet].position,point);}
 }
 let(mut s,a,b,point)=game();s.players.get_mut(&b).unwrap().champion="annie".into();
 assert_eq!(s.target_info(b).unwrap().radius,55.);
 let pet=summon(&mut s,a,point);
 s.players.get_mut(&b).unwrap().position=Point{x:point.x+181.,z:point.z};
 s.units.get_mut(&pet).unwrap().pet.as_mut().unwrap().order=Order::Attack{target:b};
 s.advance_pet_orders();assert!(s.units[&pet].destination.is_some());assert_eq!(s.units[&pet].next_attack,0);
}
