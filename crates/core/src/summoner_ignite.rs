//! Official4.20.1 Ignite totals/tooltip; tick cadence and replacement reconstructed from supplied server.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules {cooldown_seconds:f32,duration_seconds:f32,range:f32,damage_level_1:f32,damage_per_level:f32,healing_multiplier:f32,tick_count:u8,tick_interval_seconds:f32}
fn rules()->&'static Rules {static R:OnceLock<Rules>=OnceLock::new();R.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/ignite_rules.json")).unwrap())}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Burn {pub source:u32,pub source_team:u8,pub expires_at:u64,pub next_tick:u64,pub remaining_ticks:u8,pub damage_per_tick:f32}
pub fn range()->f32 {rules().range}
pub fn healing_multiplier(p:&Champion,tick:u64)->f32 {
 if p.effects.ignite.as_ref().is_some_and(|b|tick<b.expires_at) {rules().healing_multiplier} else {1.}
}
impl Simulation {
 pub(crate) fn cast_ignite(&mut self,id:u32,slot:u8,target:Option<u32>)->Result<(),String> {
  let r=rules();let target=target.ok_or("ignite requires enemy champion target")?;
  let owner=&self.players[&id];let victim=self.players.get(&target).ok_or("unknown ignite champion")?;
  if victim.team==owner.team || victim.health<=0. || owner.position.distance(victim.position)>r.range {return Err("invalid ignite enemy".into());}
  if !self.visible_to(owner.team,target) {return Err("ignite enemy hidden".into());}
  let burn=Burn{source:id,source_team:owner.team,expires_at:self.tick+spells::seconds(r.duration_seconds),next_tick:self.tick,remaining_ticks:r.tick_count,damage_per_tick:(r.damage_level_1+r.damage_per_level*(owner.level.clamp(1,18)-1) as f32)/f32::from(r.tick_count)};
  self.players.get_mut(&target).unwrap().effects.ignite=Some(burn);
  self.players.get_mut(&id).unwrap().summoners.ready_at[slot as usize]=self.tick+spells::seconds(r.cooldown_seconds);
  self.apply_ignite_tick(target);
  Ok(())
 }
 fn apply_ignite_tick(&mut self,target:u32) {
  let Some(burn)=self.players.get(&target).and_then(|p|p.effects.ignite.clone()) else {return};
  if self.tick>=burn.expires_at || burn.remaining_ticks==0 || self.tick<burn.next_tick {return;}
  let current=self.players.get_mut(&target).unwrap().effects.ignite.as_mut().unwrap();
  current.remaining_ticks-=1;current.next_tick+=spells::seconds(rules().tick_interval_seconds);
  // Disconnected sources cannot retain an absent entity ID; damage persists, credit is unqualified.
  let source=self.target_info(burn.source).map(|_|burn.source);
  self.apply_damage(source,target,burn.damage_per_tick,damage::DamageKind::True).expect("validated ignite target");
 }
 pub(crate) fn advance_ignite(&mut self) {
  let targets:Vec<u32>=self.players.values().filter(|p|p.health>0.&&p.effects.ignite.is_some()).map(|p|p.id).collect();
  for target in targets {
   if self.players[&target].effects.ignite.as_ref().is_some_and(|b|self.tick>=b.expires_at) {self.players.get_mut(&target).unwrap().effects.ignite=None;}
   else {self.apply_ignite_tick(target);}
  }
 }
}

#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32,u32,u32) {
  let mut s=Simulation::new(Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  s.enable_map10().unwrap();
  let a=s.join_with_summoners("garen",[Some(summoners::Spell::Ignite),None]).unwrap();let b=s.join_with_summoners("garen",[Some(summoners::Spell::Ignite),None]).unwrap();let ally=s.join("garen").unwrap();
  let point=s.navigation.nearest_walkable(Point{x:7700.,z:7000.}).unwrap();for id in [a,b,ally] {s.players.get_mut(&id).unwrap().position=point;}
  (s,a,b,ally)
 }
 #[test]
 fn official_damage_totals_match_all18levels_and_exactly5_periodic_hits() {
  let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_summoners_420.json")).unwrap();
  for level in 1..=18 {
   let (mut s,a,b,_)=game();s.players.get_mut(&a).unwrap().level=level;{let victim=s.players.get_mut(&b).unwrap();victim.health=1000.;victim.max_health=1000.;victim.effects.courage_until=999;}
   s.players.get_mut(&a).unwrap().effects.exhaust_until=999;s.cast_summoner_on(a,0,Some(b)).unwrap();
   let per=(50.+20.*f32::from(level))/5.;assert!((s.players[&b].health-(1000.-per)).abs()<0.001);
   assert_eq!(s.players[&a].summoners.ready_at[0],5400);assert_eq!(s.players[&b].effects.ignite.as_ref().unwrap().expires_at,150);
   for tick in 1..=150 {s.tick=tick;s.advance_ignite();let hits=(1+tick/30).min(5);assert!((s.players[&b].health-(1000.-per*hits as f32)).abs()<0.001,"level{level}/tick{tick}");}
   let expected=catalog["data"]["SummonerDot"]["vars"][0]["coeff"][(level-1) as usize].as_f64().unwrap() as f32;
   assert!((1000.-s.players[&b].health-expected).abs()<0.001);assert!(s.players[&b].effects.ignite.is_none());
  }
 }
 #[test]
 fn invalid_targets_visibility_and_range_never_spend_cooldown() {
  let (mut s,a,b,ally)=game();
  for target in [None,Some(a),Some(ally),Some(999999)] {assert!(s.cast_summoner_on(a,0,target).is_err());assert_eq!(s.players[&a].summoners.ready_at[0],0);}
  let origin=Point{x:7700.,z:7000.};s.players.get_mut(&a).unwrap().position=origin;s.players.get_mut(&b).unwrap().position=Point{x:origin.x+601.,z:origin.z};assert!(s.cast_summoner_on(a,0,Some(b)).is_err());assert_eq!(s.players[&a].summoners.ready_at[0],0);
  s.players.get_mut(&b).unwrap().position=Point{x:origin.x+50.,z:origin.z};s.units.clear();
  let index=s.navigation.index(s.players[&b].position).unwrap();s.navigation.cells[index].2|=1;
  assert!(!s.visible_to(s.players[&a].team,b));assert!(s.cast_summoner_on(a,0,Some(b)).is_err());assert_eq!(s.players[&a].summoners.ready_at[0],0);
  // A visible enemy exactly at native center-range600 is accepted by the reconstructed range policy.
  s.players.get_mut(&b).unwrap().position=Point{x:origin.x+600.,z:origin.z};s.interactions=None;s.players.get_mut(&a).unwrap().effects.silence_until=999;s.cast_summoner_on(a,0,Some(b)).unwrap();assert!(s.cast_summoner_on(a,0,Some(b)).is_err());
 }
 #[test]
 fn discrete_healing_regeneration_and_lifesteal_share50percent_reduction() {
  let (mut s,a,b,_)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();s.players.get_mut(&b).unwrap().health=100.;
  assert!((s.heal(Some(a),b,100.).unwrap().restored-50.).abs()<0.001);
  let before=s.players[&b].health;let regen=s.regeneration_rates(b).unwrap().health_per_second;s.advance_regeneration();assert!((s.players[&b].health-before-regen*0.5/30.).abs()<0.001);
  s.players.get_mut(&b).unwrap().inventory[0]=Some(1053);let before=s.players[&b].health;let outcome=s.basic_attack_hit(b,a,100.).unwrap();let expected=outcome.post_mitigation*0.08*0.5;assert!((s.players[&b].health-before-expected).abs()<0.001);
  s.tick=150;s.advance_ignite();assert!((s.heal(Some(a),b,100.).unwrap().restored-100.).abs()<0.001);
 }
 #[test]
 fn burn_reveals_only_target_to_caster_team_and_expires_at5seconds() {
  let (mut s,a,b,ally)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();
  let far=Point{x:1000.,z:4400.};s.players.get_mut(&b).unwrap().position=far;s.units.clear();assert!(!s.visible_point_to(s.players[&a].team,far));assert!(s.visible_to(s.players[&a].team,b));
  let snap=s.snapshot_for(a).unwrap();assert!(snap.players.iter().any(|p|p.id==b));assert!(snap.players.iter().any(|p|p.id==ally));
  s.tick=150;s.advance_ignite();assert!(!s.visible_to(s.players[&a].team,b));assert!(!s.snapshot_for(a).unwrap().players.iter().any(|p|p.id==b));
 }
 #[test]
 fn burn_persists_after_caster_death_and_level_change_but_target_death_clears_it() {
  let (mut s,a,b,_)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();s.players.get_mut(&a).unwrap().level=18;s.apply_damage(None,a,10000.,damage::DamageKind::True).unwrap();let before=s.players[&b].health;s.tick=30;s.advance_ignite();assert!((before-s.players[&b].health-14.).abs()<0.001);
  s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();assert!(s.players[&b].effects.ignite.is_none());s.tick=60;s.advance_ignite();assert_eq!(s.players[&b].health,0.);
 }
 #[test]
 fn shields_absorb_true_damage_without_removing_healing_reduction() {
  let (mut s,a,b,_)=game();s.grant_shield(b,"fixture",100.,150).unwrap();let before=s.players[&b].health;s.cast_summoner_on(a,0,Some(b)).unwrap();assert_eq!(s.players[&b].health,before);assert_eq!(s.players[&b].shields[0].remaining,86.);assert_eq!(healing::received_multiplier(&s.players[&b],s.tick),0.5);
 }
 #[test]
 fn fountain_and_relic_use_shared_reconstructed_received_healing_policy() {
  let (mut s,a,b,_)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();
  let spawns:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/champion_spawns_map10.json")).unwrap();let team=s.players[&b].team as usize;
  let position=serde_json::from_value(spawns[team]["point"].clone()).unwrap();let p=s.players.get_mut(&b).unwrap();p.position=position;p.health=100.;let max=p.max_health;
  s.tick=30;s.advance_interactions();assert!((s.players[&b].health-100.-max*0.15*0.5).abs()<0.001);
  let (mut s,a,b,ally)=game();s.tick=5400;let relic=s.interactions.as_ref().unwrap().state.relic_position;
  s.players.get_mut(&a).unwrap().position=Point{x:relic.x+300.,z:relic.z};s.players.get_mut(&ally).unwrap().position=Point{x:relic.x+300.,z:relic.z};s.players.get_mut(&b).unwrap().position=relic;s.cast_summoner_on(a,0,Some(b)).unwrap();s.players.get_mut(&b).unwrap().health=100.;
  s.advance_interactions();assert_eq!(s.interactions.as_ref().unwrap().state.relic_last_picker,Some(b));assert!((s.players[&b].health-147.).abs()<0.001);
 }
 #[test]
 fn disconnected_source_does_not_cancel_remaining_damage_or_target_reveal() {
  let (mut s,a,b,_)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();let before=s.players[&b].health;s.players.remove(&a);s.tick=30;s.advance_ignite();assert!((before-s.players[&b].health-14.).abs()<0.001);assert!(s.players[&b].effects.ignite.is_some());
 }
 #[test]
 fn second_caster_replaces_burn_under_supplied_community_overlap_policy() {
  let (mut s,a,b,ally)=game();s.cast_summoner_on(a,0,Some(b)).unwrap();s.tick=15;s.players.get_mut(&ally).unwrap().summoners.spells[0]=Some(summoners::Spell::Ignite);s.players.get_mut(&ally).unwrap().level=18;let before=s.players[&b].health;s.cast_summoner_on(ally,0,Some(b)).unwrap();
  assert!((before-s.players[&b].health-82.).abs()<0.001);let burn=s.players[&b].effects.ignite.as_ref().unwrap();assert_eq!(burn.source,ally);assert_eq!(burn.expires_at,165);assert_eq!(burn.remaining_ticks,4);let before=s.players[&b].health;s.tick=30;s.advance_ignite();assert_eq!(s.players[&b].health,before);s.tick=45;s.advance_ignite();assert!((before-s.players[&b].health-82.).abs()<0.001);
 }

}
