//! Map10 ambient gold. Native parameters; payment boundary is a reconstruction.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules {amount:f32,interval_seconds:f32,delay_seconds:f32,disable_while_dead:bool}
fn rules()->&'static Rules {
 static R:OnceLock<Rules>=OnceLock::new();
 R.get_or_init(|| {
  let r:Rules=serde_json::from_str(include_str!("../../../data/4.20/passive_gold_rules.json")).unwrap();
  assert!(r.amount.is_finite() && r.amount>=0. && r.interval_seconds.is_finite() && r.interval_seconds>0. && r.delay_seconds.is_finite() && r.delay_seconds>=0.);
  assert!(spells::seconds(r.interval_seconds)>0);
  r
 })
}
impl Simulation {
 pub(crate) fn advance_passive_gold(&mut self) {
  let r=rules();let delay=spells::seconds(r.delay_seconds);let interval=spells::seconds(r.interval_seconds);
  // A fixed global clock grants once per boundary, with no historical catch-up for joins.
  // Item/mastery/champion passive-income modifiers remain unsupported.
  if self.winner.is_some() || self.tick<delay || (self.tick-delay)%interval!=0 {return;}
  for p in self.players.values_mut() {
   if !r.disable_while_dead || p.health>0. {p.gold+=r.amount;}
  }
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32) {
  let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
  let mut s=Simulation::new(nav).unwrap();let id=s.join("garen").unwrap();(s,id)
 }
 #[test]
 fn first_payment_and_subsequent_boundaries_use_match_clock() {
  let (mut s,id)=game();let starting=s.players[&id].gold;
  for _ in 0..2249 {s.advance();}assert_eq!(s.players[&id].gold,starting);
  s.advance();assert_eq!(s.tick,2250);assert_eq!(s.players[&id].gold,starting+8.);
  for _ in 0..149 {s.advance();}assert_eq!(s.players[&id].gold,starting+8.);
  s.advance();assert_eq!(s.tick,2400);assert_eq!(s.players[&id].gold,starting+16.);
 }
 #[test]
 fn dead_players_receive_income_without_respawn() {
  let (mut s,id)=game();s.tick=2249;let p=s.players.get_mut(&id).unwrap();p.health=0.;p.respawn_at=Some(3000);let gold=p.gold;
  s.advance();assert_eq!(s.players[&id].health,0.);assert_eq!(s.players[&id].gold,gold+8.);
 }
 #[test]
 fn late_join_receives_only_next_global_payment() {
  let (mut s,id)=game();s.tick=2250;let late=s.join("ahri").unwrap();let gold=s.players[&late].gold;
  for _ in 0..149 {s.advance();}assert_eq!(s.players[&late].gold,gold);
  s.advance();assert_eq!(s.players[&late].gold,gold+8.);assert_eq!(s.players[&id].gold,gold+8.);
 }
 #[test]
 fn winner_freezes_clock_and_income() {
  let (mut s,id)=game();s.tick=2249;s.winner=Some(0);let gold=s.players[&id].gold;
  s.advance();assert_eq!(s.tick,2249);assert_eq!(s.players[&id].gold,gold);
 }
 #[test]
 fn ordinary_first_blood_does_not_change_classic_start_delay() {
  let (mut s,id)=game();let victim=s.join("ahri").unwrap();s.tick=899;
  s.apply_damage(Some(id),victim,10000.,damage::DamageKind::True).unwrap();let gold=s.players[&id].gold;assert_eq!(gold,1225.);
  s.advance();assert_eq!(s.players[&id].gold,gold);s.tick=2249;s.advance();assert_eq!(s.players[&id].gold,gold+8.);
 }
}
