//! Native 4.20 potion values; queued timing/use guards reconstructed.
use crate::*;
#[derive(Debug,Clone,Copy,Deserialize,PartialEq,Eq)]
pub enum Kind {Health,Mana}
#[derive(Debug,Clone,Copy,Deserialize)]
pub struct Definition {pub kind:Kind,pub amount:f32,pub duration_seconds:f32}
impl Simulation {
 pub fn use_item(&mut self,id:u32,slot:u8)->Result<(),String> {
  if self.winner.is_some() {return Err("match ended".into());}
  let p=self.players.get(&id).ok_or("unknown player")?;if trundle_e::champion_forced(p,self.tick) {return Err("champion in forced movement".into());}if p.health<=0. {return Err("champion dead".into());}
  let index=usize::from(slot);let item_id=p.inventory.get(index).ok_or("invalid inventory slot")?.ok_or("empty inventory slot")?;
  let item=shop::catalog().iter().find(|i|i.id==item_id).ok_or("item behavior not implemented")?;
  let effect=item.consumable.ok_or("item active not implemented")?;
  let native_name=match effect.kind {Kind::Health=>"RegenerationPotion",Kind::Mana=>"FlaskOfCrystalWater"};
  if stuns::active(p,self.tick) && !stuns::allows_disabled(native_name)? {return Err("item disabled while stunned".into());}
  let duration=spells::seconds(effect.duration_seconds);
  let pending=match effect.kind {
   Kind::Health=>{if p.health>=p.max_health {return Err("health already full".into());}p.effects.health_potion_ticks},
   Kind::Mana=>{if !lifecycle::uses_mana(&p.champion) {return Err("champion does not use mana".into());}if p.mana>=self.stats(id).max_mana {return Err("mana already full".into());}p.effects.mana_potion_ticks},
  };
  if duration==0 || pending>duration*u64::from(item.max_stack.saturating_sub(1)) {return Err("potion queue full".into());}
  let p=self.players.get_mut(&id).unwrap();let count=p.inventory_counts[index].max(1);p.inventory_counts[index]=count-1;if count==1 {p.inventory[index]=None;}
  match effect.kind {Kind::Health=>p.effects.health_potion_ticks+=duration,Kind::Mana=>p.effects.mana_potion_ticks+=duration};Ok(())
 }
 pub(crate) fn advance_consumables(&mut self) {
  if self.winner.is_some() {return;}
  let active:Vec<_>=self.players.values().filter(|p|p.health>0.).map(|p|p.id).collect();
  let health=shop::catalog().iter().find(|i|i.id==2003).unwrap().consumable.unwrap();
  let mana=shop::catalog().iter().find(|i|i.id==2004).unwrap().consumable.unwrap();
  for id in active {
   let max_mana=self.stats(id).max_mana;
   let p=self.players.get_mut(&id).unwrap();
   if p.effects.health_potion_ticks>0 {p.effects.health_potion_ticks-=1;p.health=(p.health+health.amount/health.duration_seconds/TICK_RATE as f32*healing::received_multiplier(p,self.tick)).min(p.max_health);}
   if p.effects.mana_potion_ticks>0 {p.effects.mana_potion_ticks-=1;if lifecycle::uses_mana(&p.champion) {p.mana=(p.mana+mana.amount/mana.duration_seconds/TICK_RATE as f32).min(max_mana);}}
  }
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game(name:&str)->(Simulation,u32) {
  let mut s=Simulation::new(Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let id=s.join(name).unwrap();(s,id)
 }
 #[test]
 fn five_carried_potions_stack_and_sixth_purchase_is_atomic() {
  let (mut s,id)=game("garen");for _ in 0..5 {s.buy_item(id,2003).unwrap();}assert_eq!(s.players[&id].inventory[0],Some(2003));assert_eq!(s.players[&id].inventory_counts[0],5);assert_eq!(s.players[&id].gold,650.);
  let before=s.players[&id].clone();assert_eq!(s.buy_item(id,2003).unwrap_err(),"item stack limit reached");assert_eq!(s.players[&id].gold,before.gold);assert_eq!(s.players[&id].inventory_counts,before.inventory_counts);
 }
 #[test]
 fn full_inventory_can_add_to_existing_pile_and_regular_recipes_preserve_it() {
  let (mut s,id)=game("garen");s.players.get_mut(&id).unwrap().gold=10000.;for item in [2003,1052,1036,1029,1004,1028] {s.buy_item(id,item).unwrap();}s.buy_item(id,2003).unwrap();assert_eq!(s.players[&id].inventory_counts[0],2);s.buy_item(id,3108).unwrap();assert_eq!(s.players[&id].inventory_counts[0],2);assert_eq!(s.players[&id].inventory[1],Some(3108));assert_eq!(s.players[&id].inventory_counts[1],1);
 }
 #[test]
 fn swap_one_unit_sale_and_use_preserve_correct_counts() {
  let (mut s,id)=game("garen");for _ in 0..3 {s.buy_item(id,2003).unwrap();}s.swap_items(id,0,5).unwrap();assert_eq!(shop::inventory_count(&s.players[&id],5),3);s.sell_item(id,5).unwrap();assert_eq!(s.players[&id].gold,734.);assert_eq!(shop::inventory_count(&s.players[&id],5),2);s.players.get_mut(&id).unwrap().health=100.;s.use_item(id,5).unwrap();s.use_item(id,5).unwrap();assert_eq!(s.players[&id].inventory[5],None);assert_eq!(s.players[&id].inventory_counts[5],0);assert_eq!(s.players[&id].effects.health_potion_ticks,900);
 }
 #[test]
 fn native_potion_totals_restore_over_exactly450_updates() {
  let (mut s,id)=game("ahri");s.buy_item(id,2003).unwrap();s.buy_item(id,2004).unwrap();let p=s.players.get_mut(&id).unwrap();p.health=100.;p.mana=0.;s.use_item(id,0).unwrap();s.use_item(id,1).unwrap();assert_eq!(s.players[&id].health,100.);
  for _ in 0..450 {s.tick+=1;s.advance_consumables();}assert!((s.players[&id].health-250.).abs()<0.02);assert!((s.players[&id].mana-100.).abs()<0.02);assert_eq!(s.players[&id].effects.health_potion_ticks,0);assert_eq!(s.players[&id].effects.mana_potion_ticks,0);let hp=s.players[&id].health;s.advance_consumables();assert_eq!(s.players[&id].health,hp);
 }
 #[test]
 fn queued_potions_extend_duration_without_multiplying_rate_and_have_cap() {
  let (mut s,id)=game("garen");s.players.get_mut(&id).unwrap().gold=10000.;s.players.get_mut(&id).unwrap().health=1.;for _ in 0..5 {s.buy_item(id,2003).unwrap();s.use_item(id,0).unwrap();}assert_eq!(s.players[&id].effects.health_potion_ticks,2250);s.buy_item(id,2003).unwrap();assert_eq!(s.use_item(id,0).unwrap_err(),"potion queue full");assert_eq!(shop::inventory_count(&s.players[&id],0),1);s.advance_consumables();assert!((s.players[&id].health-(1.+10./30.)).abs()<0.001);
 }
 #[test]
 fn guards_full_pools_invalid_items_dead_and_finished_are_atomic() {
  let (mut s,id)=game("garen");s.buy_item(id,2003).unwrap();s.buy_item(id,2004).unwrap();assert_eq!(s.use_item(id,0).unwrap_err(),"health already full");assert_eq!(s.use_item(id,1).unwrap_err(),"champion does not use mana");assert!(s.use_item(id,6).is_err());s.buy_item(id,1036).unwrap();assert_eq!(s.use_item(id,2).unwrap_err(),"item active not implemented");s.players.get_mut(&id).unwrap().health=0.;assert!(s.use_item(id,0).is_err());s.winner=Some(0);assert!(s.use_item(id,0).is_err());assert_eq!(s.players[&id].inventory_counts[0],1);
 }
 #[test]
 fn ignite_reduces_health_potion_but_not_mana_and_death_clears_effects() {
  let (mut s,id)=game("ahri");s.buy_item(id,2003).unwrap();s.buy_item(id,2004).unwrap();let p=s.players.get_mut(&id).unwrap();p.health=100.;p.mana=0.;p.effects.ignite=Some(summoner_ignite::Burn{source:id,source_team:0,expires_at:1000,next_tick:1000,remaining_ticks:0,damage_per_tick:0.});s.use_item(id,0).unwrap();s.use_item(id,1).unwrap();for _ in 0..30 {s.tick+=1;s.advance_consumables();}assert!((s.players[&id].health-105.).abs()<0.002);assert!((s.players[&id].mana-100./15.).abs()<0.002);s.apply_damage(None,id,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&id].effects.health_potion_ticks,0);assert_eq!(s.players[&id].effects.mana_potion_ticks,0);
 }
}
