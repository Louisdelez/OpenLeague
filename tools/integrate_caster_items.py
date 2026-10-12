from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/core/src/shop.rs';s=p.read_text(encoding='utf-8');s=s.replace('    pub damage: f32,','    pub damage: f32,\n    pub ability_power: f32,\n    pub cooldown_reduction: f32,',1).replace('pub(crate) fn bonuses(p: &Champion) -> Bonuses {','pub(crate) fn bonuses(p: &Champion) -> Bonuses {\n    let mut unique_cooldowns = std::collections::BTreeSet::new();').replace('            b.damage += v.damage;','            b.damage += v.damage;\n            b.ability_power += v.ability_power;\n            if unique_cooldowns.insert(i.id) { b.cooldown_reduction += v.cooldown_reduction; }',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/progression.rs';s=p.read_text(encoding='utf-8').replace('    pub damage: f32,\n    pub critical_chance:', '    pub damage: f32,\n    pub ability_power: f32,\n    pub cooldown_reduction: f32,\n    pub critical_chance:',1).replace('        Stats {','        Stats {\n            ability_power: items.ability_power * self.altar_damage_multiplier(p.team),\n            cooldown_reduction: items.cooldown_reduction.clamp(0., cooldown::maximum_reduction()),',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/spells.rs';s=p.read_text(encoding='utf-8').replace('        let p = self.players.get_mut(&id).unwrap();\n        p.cooldowns[slot as usize] = self.tick + seconds(garen_value(slot, "Cooldown", rank));','        let cooldown = cooldown::ticks(garen_value(slot, "Cooldown", rank), self.stats(id).cooldown_reduction);\n        let p = self.players.get_mut(&id).unwrap();\n        p.cooldowns[slot as usize] = self.tick + cooldown;',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8').replace('pub mod combat;','pub mod combat;\npub mod cooldown;',1);p.write_text(s,encoding='utf-8')
(r/'crates/core/src/cooldown.rs').write_text('''//! Historical CDR, from Map10 constants and native unique item descriptions.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules { maximum_reduction:f32, minimum_seconds:f32 }
fn rules()->&'static Rules {
 static R:OnceLock<Rules>=OnceLock::new();
 R.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/cooldown_rules.json")).unwrap())
}
pub fn maximum_reduction()->f32 {rules().maximum_reduction}
pub fn ticks(base_seconds:f32,reduction:f32)->u64 {
 assert!(base_seconds.is_finite() && base_seconds>=0. && reduction.is_finite());
 spells::seconds((base_seconds*(1.-reduction.clamp(0.,maximum_reduction()))).max(rules().minimum_seconds))
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32) {
  let mut s=Simulation::new(Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  s.enable_map10().unwrap();let id=s.join("garen").unwrap();(s,id)
 }
 #[test]
 fn unique_same_item_cdr_does_not_prevent_power_stacking() {
  let (mut s,id)=game();s.players.get_mut(&id).unwrap().gold=10000.;
  s.buy_item(id,3108).unwrap();s.buy_item(id,3108).unwrap();assert_eq!(s.stats(id).ability_power,60.);assert_eq!(s.stats(id).cooldown_reduction,0.1);
  s.swap_items(id,0,4).unwrap();assert_eq!(s.stats(id).cooldown_reduction,0.1);
  s.sell_item(id,4).unwrap();assert_eq!(s.stats(id).ability_power,30.);assert_eq!(s.stats(id).cooldown_reduction,0.1);
  s.sell_item(id,1).unwrap();assert_eq!(s.stats(id).ability_power,0.);assert_eq!(s.stats(id).cooldown_reduction,0.);
 }
 #[test]
 fn different_unique_components_stack_up_to_native_cap() {
  let (mut s,id)=game();s.players.get_mut(&id).unwrap().gold=10000.;
  for item in [3108,3114,3067,3101,3024] {s.buy_item(id,item).unwrap();}
  assert_eq!(s.stats(id).cooldown_reduction,0.4);assert_eq!(ticks(10.,0.5),180);assert_eq!(ticks(10.,-0.2),300);
 }
 #[test]
 fn native_recipes_consume_components_and_apply_only_result_bonuses() {
  let (mut s,id)=game();s.buy_item(id,1052).unwrap();assert_eq!(s.players[&id].gold,390.);assert_eq!(s.stats(id).ability_power,20.);
  s.buy_item(id,3108).unwrap();assert_eq!(s.players[&id].gold,5.);assert_eq!(s.players[&id].inventory.iter().flatten().copied().collect::<Vec<_>>(),vec![3108]);assert_eq!(s.stats(id).ability_power,30.);assert_eq!(s.stats(id).cooldown_reduction,0.1);
  assert!(s.buy_item(id,1052).is_err());assert_eq!(s.players[&id].gold,5.);
 }
 #[test]
 fn purchase_or_sale_does_not_rewrite_existing_cooldown() {
  let (mut s,id)=game();s.players.get_mut(&id).unwrap().gold=10000.;s.command(id,Action::Learn{slot:0}).unwrap();s.cast(id,0,None).unwrap();let original=s.players[&id].cooldowns[0];
  s.buy_item(id,3108).unwrap();assert_eq!(s.players[&id].cooldowns[0],original);
  s.tick=original;s.cast(id,0,None).unwrap();let reduced=s.players[&id].cooldowns[0];assert_eq!(reduced-original,ticks(spells::garen_value(0,"Cooldown",1),0.1));assert!(reduced-original<original);
  s.sell_item(id,0).unwrap();assert_eq!(s.players[&id].cooldowns[0],reduced);
 }
 #[test]
 fn cancellation_preserves_reduced_spin_cooldown_and_summoners_ignore_items() {
  let (mut s,id)=game();s.players.get_mut(&id).unwrap().gold=10000.;s.buy_item(id,3108).unwrap();s.command(id,Action::Learn{slot:2}).unwrap();s.cast(id,2,None).unwrap();let ready=s.players[&id].cooldowns[2];s.tick+=1;s.cast(id,2,None).unwrap();assert_eq!(s.players[&id].cooldowns[2],ready);assert_eq!(s.players[&id].effects.spin_until,s.tick);
  s.command(id,Action::Summoner{slot:0}).unwrap();assert_eq!(s.players[&id].summoners.ready_at[0]-s.tick,6300);
 }
 #[test]
 fn two_altar_power_bonus_uses_the_current_item_power() {
  let (mut s,id)=game();s.players.get_mut(&id).unwrap().gold=10000.;s.buy_item(id,1058).unwrap();assert_eq!(s.stats(id).ability_power,80.);
  for altar in &mut s.interactions.as_mut().unwrap().state.altars {altar.owner=Some(0);}
  assert_eq!(s.stats(id).ability_power,88.);s.sell_item(id,0).unwrap();assert_eq!(s.stats(id).ability_power,0.);
 }
}
''',encoding='utf-8')
print('Implemented AP, unique-itemCDR, cap, cast-time application and six tests')
