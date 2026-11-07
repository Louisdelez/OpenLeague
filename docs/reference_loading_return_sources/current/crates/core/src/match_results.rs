//! Immutable server-owned result. Only tracked statistics are exposed.
use crate::*;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct PlayerResult {
 pub id:u32,pub champion:String,pub team:u8,pub level:u8,
 pub score:champion_kills::Score,pub gold_remaining:f32,
 pub inventory:[Option<u32>;6],pub inventory_counts:[u8;6],
}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct NexusResult {pub id:u32,pub team:u8,pub position:[f32;3],#[serde(default)] pub definition:String,#[serde(default)] pub facing:f32}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct MatchResult {pub session:u64,pub ended_tick:u64,pub winner:u8,pub players:Vec<PlayerResult>,#[serde(default)] pub destroyed_nexus:Option<NexusResult>}
impl Simulation {
 pub fn final_results(&self)->Option<&MatchResult> {self.final_result.as_ref()}
 pub(crate) fn capture_final_results(&mut self) {
  if self.final_result.is_some(){return;}
  let Some(winner)=self.winner.filter(|team|*team<2) else {return;};
  self.clear_ezreal_q();
  self.clear_ezreal_w();
  self.clear_ezreal_e();
  self.clear_ezreal_r();
  self.clear_ezreal_passive();
  self.finish_attack_presentations();
  self.finish_vilemaw_attacks();
  self.final_result=Some(MatchResult {session:self.session,ended_tick:self.tick,winner,
   destroyed_nexus:self.units.values().find(|u|u.kind==world::Kind::Nexus&&u.team==1-winner).map(|u|NexusResult{id:u.id,team:u.team,position:[u.position.x,u.height,u.position.z],definition:u.definition.clone(),facing:u.facing}),
   players:self.players.values().map(|p|PlayerResult{id:p.id,champion:p.champion.clone(),team:p.team,level:p.level,score:p.score,gold_remaining:p.gold,inventory:p.inventory,inventory_counts:p.inventory_counts}).collect()});
 }
}
#[cfg(test)] mod tests {
 use super::*;
 fn game()->Simulation {
  let navigation=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
  let mut s=Simulation::new(navigation).unwrap();s.enable_map10().unwrap();s.session=734;for _ in 0..6{s.join("garen").unwrap();}s
 }
 #[test] fn results_do_not_disclose_enemy_loadouts_before_match_end_and_survive_disconnects(){
  let mut s=game();let id=*s.players.keys().next().unwrap();assert!(s.snapshot_for(id).unwrap().result.is_none());
  let p=s.players.get_mut(&id).unwrap();p.score.kills=3;p.inventory[0]=Some(1036);p.inventory_counts[0]=1;p.gold=71.;
  s.winner=Some(0);s.advance();let result=s.final_results().unwrap();assert_eq!(result.players.len(),6);assert_eq!(result.session,734);assert_eq!(result.players[0].score.kills,3);assert_eq!(result.players[0].gold_remaining,71.);assert_eq!(result.players[0].inventory[0],Some(1036));
  let original=serde_json::to_value(result).unwrap();s.players.remove(&id);s.players.values_mut().next().unwrap().gold=99999.;s.advance();
  assert_eq!(serde_json::to_value(s.final_results()).unwrap(),original);assert!(s.join("garen").is_err());
  let snapshot=s.snapshot();let encoded=serde_json::to_vec(&snapshot).unwrap();let decoded:Snapshot=serde_json::from_slice(&encoded).unwrap();assert_eq!(serde_json::to_value(decoded.result).unwrap(),original);
 }
 #[test] fn actual_nexus_death_captures_terminal_results_after_dependency_chain(){
  let mut s=game();let source=*s.players.keys().next().unwrap();
  let targets=["Turret_T2_L_02","Turret_T2_L_01","Barracks_T2_L1","Turret_T2_C_01","HQ_T2"];
  for name in targets {let target=s.units.values().find(|u|u.name==name).unwrap().id;assert!(!s.protected(target),"{name}");s.damage_unit(source,target,1_000_000.);}
  assert_eq!(s.winner,Some(0));let result=s.final_results().unwrap();assert_eq!(result.winner,0);assert_eq!(result.players.len(),6);assert_eq!(result.ended_tick,s.tick);let nexus=result.destroyed_nexus.as_ref().unwrap();assert_eq!(nexus.team,1);assert_eq!(nexus.definition,s.units[&nexus.id].definition);assert_eq!(nexus.facing,s.units[&nexus.id].facing);assert_eq!(nexus.id,s.units.values().find(|u|u.name=="HQ_T2").unwrap().id);
 }
}
