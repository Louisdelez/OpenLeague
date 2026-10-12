//! Percentage-before-flat is explicit in native LastWhisper/VoidStaff descriptions.
//! Zero-floor and negative-resistance rules reconstructed; source server body absent.
use crate::*;
pub fn effective(resistance:f32,flat:f32,percent:f32)->Option<f32> {
 if !resistance.is_finite() || !flat.is_finite() || flat<0. || !percent.is_finite() || !(0. ..=1.).contains(&percent) {return None;}
 Some(if resistance<=0. {resistance} else {(resistance*(1.-percent)-flat).max(0.)})
}
impl Simulation {
 pub(crate) fn penetrated_defenses(&self,source:Option<u32>,kind:damage::DamageKind,armor:f32,mr:f32)->Result<(f32,f32),String> {
  if kind==damage::DamageKind::True {return Ok((armor,mr));}
  let modifiers=source.and_then(|id|self.players.get(&id)).map(shop::bonuses).unwrap_or_default();
  match kind {
   damage::DamageKind::Physical=>Ok((effective(armor,modifiers.armor_penetration,modifiers.armor_penetration_percent).ok_or("invalid penetration/armor")?,mr)),
   damage::DamageKind::Magical=>Ok((armor,effective(mr,modifiers.magic_penetration,modifiers.magic_penetration_percent).ok_or("invalid penetration/magic resistance")?)),
   damage::DamageKind::True=>unreachable!(),
  }
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32,u32) {
  let mut s=Simulation::new(Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();s.enable_map10().unwrap();let a=s.join("garen").unwrap();let b=s.join("ahri").unwrap();s.players.get_mut(&a).unwrap().gold=20000.;(s,a,b)
 }
 #[test]
 fn percent_before_flat_zero_floor_negative_and_invalid_inputs() {
  assert_eq!(effective(100.,10.,0.35),Some(55.));assert_eq!(effective(10.,15.,0.35),Some(0.));assert_eq!(effective(-20.,100.,0.35),Some(-20.));assert_eq!(effective(0.,10.,1.),Some(0.));
  for (r,f,p) in [(f32::NAN,0.,0.),(100.,-1.,0.),(100.,f32::INFINITY,0.),(100.,0.,1.1)] {assert!(effective(r,f,p).is_none());}
 }
 #[test]
 fn source_owned_items_change_damage_without_mutating_target_stats() {
  let (mut s,a,b)=game();for item in [3134,3035,3135,3136] {s.buy_item(a,item).unwrap();}
  let stats=s.stats(b);let physical=s.apply_damage(Some(a),b,100.,damage::DamageKind::Physical).unwrap();let expect=damage::mitigate(100.,damage::DamageKind::Physical,effective(stats.armor,10.,0.35).unwrap(),stats.magic_resist,1.).unwrap();assert!((physical.post_mitigation-expect).abs()<0.001);
  let magic=s.apply_damage(Some(a),b,100.,damage::DamageKind::Magical).unwrap();let expect=damage::mitigate(100.,damage::DamageKind::Magical,stats.armor,effective(stats.magic_resist,15.,0.35).unwrap(),1.).unwrap();assert!((magic.post_mitigation-expect).abs()<0.001);assert_eq!(s.stats(b).armor,stats.armor);assert_eq!(s.stats(b).magic_resist,stats.magic_resist);
  assert_eq!(s.apply_damage(Some(a),b,100.,damage::DamageKind::True).unwrap().post_mitigation,100.);
 }
 #[test]
 fn unique_passives_deduplicate_but_direct_stats_stack() {
  let (mut s,a,_)=game();for item in [3134,3134,3135,3135] {s.buy_item(a,item).unwrap();}let stats=s.stats(a);assert_eq!(stats.armor_penetration,10.);assert!((stats.magic_penetration_percent-0.35).abs()<1e-6);assert_eq!(stats.ability_power,140.);assert_eq!(stats.cooldown_reduction,0.1);assert_eq!(stats.damage,s.definitions["garen"].attack_damage+50.);
 }
 #[test]
 fn world_targets_receive_identical_post_mitigation_amount_once() {
  let (mut s,a,_)=game();s.buy_item(a,3134).unwrap();s.buy_item(a,3035).unwrap();s.tick=2999;s.advance();
  for target in s.units.values().filter(|u|u.kind==world::Kind::Monster||u.kind==world::Kind::Turret).map(|u|u.id).collect::<Vec<_>>() {
   if s.protected(target) {continue;}
   s.units.get_mut(&target).unwrap().armor=100.;let before=s.units[&target].health;
   let out=s.apply_damage(Some(a),target,100.,damage::DamageKind::Physical).unwrap();assert!((out.post_mitigation-100./1.55).abs()<0.001);assert!((before-s.units[&target].health-out.post_mitigation).abs()<0.001);assert!(s.apply_damage(Some(a),target,10000.,damage::DamageKind::True).unwrap().lethal);
  }
 }
 #[test]
 fn boot_upgrade_unique_group_and_separate_magic_pen_sources() {
  let (mut s,a,_)=game();s.buy_item(a,1001).unwrap();s.buy_item(a,3020).unwrap();assert_eq!(s.players[&a].inventory.iter().flatten().copied().collect::<Vec<_>>(),vec![3020]);assert_eq!(s.stats(a).magic_penetration,15.);assert!(s.buy_item(a,1001).is_err());assert!(s.buy_item(a,3020).is_err());s.buy_item(a,3136).unwrap();s.buy_item(a,3136).unwrap();assert_eq!(s.stats(a).magic_penetration,30.);assert_eq!(s.stats(a).ability_power,50.);
 }
 #[test]
 fn official_integer_sell_refunds_replace_fractional_gold() {
  let (mut s,a,_)=game();s.buy_item(a,3134).unwrap();let before=s.players[&a].gold;s.sell_item(a,0).unwrap();assert_eq!(s.players[&a].gold-before,936.);
  s.buy_item(a,3135).unwrap();let before=s.players[&a].gold;s.sell_item(a,0).unwrap();assert_eq!(s.players[&a].gold-before,1607.);
 }
 #[test]
 fn ultimate_retains_caster_penetration_and_kill_attribution() {
  let (mut s,a,b)=game();s.buy_item(a,3136).unwrap();s.award_experience(a,progression::threshold(6)).unwrap();s.command(a,Action::Learn{slot:3}).unwrap();let center=Point{x:7700.,z:7000.};s.players.get_mut(&a).unwrap().position=center;s.players.get_mut(&b).unwrap().position=center;
  let before=s.players[&b].health;let raw=spells::garen_value(3,"Effect1",1);let mr=s.stats(b).magic_resist;let expect=damage::mitigate(raw,damage::DamageKind::Magical,0.,effective(mr,15.,0.).unwrap(),1.).unwrap();s.cast(a,3,Some(b)).unwrap();s.tick+=15;s.advance_spells();assert!((before-s.players[&b].health-expect).abs()<0.001);
  s.players.get_mut(&b).unwrap().health=1.;let ready=s.players[&a].cooldowns[3];s.tick=ready;s.cast(a,3,Some(b)).unwrap();s.tick+=15;let gold=s.players[&a].gold;s.advance_spells();assert_eq!(s.players[&b].health,0.);assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(a));assert_eq!(s.players[&a].gold,gold+400.);
 }
}
