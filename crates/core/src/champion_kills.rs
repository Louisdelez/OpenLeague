//! Champion death/reward bookkeeping. Native values qualified; detailed policies reconstructed.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Copy,Default,Serialize,Deserialize)]
pub struct Score {pub kills:u32,pub deaths:u32,pub assists:u32,pub kill_streak:u32,pub death_streak:u32}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Event {pub sequence:u64,pub tick:u64,pub victim:u32,pub killer:Option<u32>,pub assists:Vec<u32>,pub first_blood:bool,pub killer_gold:f32}
#[derive(Default)]
pub(crate) struct State {hits:BTreeMap<u32,BTreeMap<u32,(u64,u64)>>,pub events:VecDeque<Event>,first_blood:bool,next_event:u64,next_hit:u64}
#[derive(Deserialize)]
struct Rules {base_gold:f32,first_blood_bonus:f32,assist_seconds:f32,assist_pool_min:f32,assist_pool_max:f32,assist_pool_min_time:f32,assist_pool_max_time:f32,base_experience_multiplier:f32,level_difference_multiplier:f32,minimum_experience_multiplier:f32}
fn rules()->&'static Rules {static R:OnceLock<Rules>=OnceLock::new();R.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/champion_kill_rules.json")).unwrap())}
pub fn base_experience(victim_level:u8,recipient_level:u8)->f32 {
 let level=victim_level.clamp(1,18);let current=if level==1 {0.} else {progression::threshold(level)};
 let increment=progression::threshold(level+1)-current;
 let multiplier=(1.+(i32::from(level)-i32::from(recipient_level.clamp(1,18))) as f32*rules().level_difference_multiplier).max(rules().minimum_experience_multiplier);
 increment*rules().base_experience_multiplier*multiplier
}
pub fn assist_pool_fraction(tick:u64)->f32 {
 let r=rules();let elapsed=tick as f32/TICK_RATE as f32;
 let t=((elapsed-r.assist_pool_min_time)/(r.assist_pool_max_time-r.assist_pool_min_time)).clamp(0.,1.);
 r.assist_pool_min+(r.assist_pool_max-r.assist_pool_min)*t
}
impl Simulation {
 /// Damage/control contribution only; support-heal/shield and pet attribution remain work.
 pub(crate) fn record_champion_contribution(&mut self,source:u32,target:u32) {
  let (Some(a),Some(b))=(self.players.get(&source),self.players.get(&target)) else {return};
  if a.team==b.team || b.health<=0. {return;}
  let players=&self.players;let tick=self.tick;let window=spells::seconds(rules().assist_seconds);
  let history=self.kill_rewards.hits.entry(target).or_default();history.retain(|id,at|players.contains_key(id)&&tick.saturating_sub(at.0)<=window);self.kill_rewards.next_hit+=1;history.insert(source,(tick,self.kill_rewards.next_hit));
 }
 pub(crate) fn reward_champion_death(&mut self,source:Option<u32>,target:u32) {
  let Some(victim)=self.players.get(&target) else {return};let victim_team=victim.team;let victim_level=victim.level;
  let history=self.kill_rewards.hits.remove(&target).unwrap_or_default();let window=spells::seconds(rules().assist_seconds);
  let eligible=|id:&u32,at:&(u64,u64)|self.tick.saturating_sub(at.0)<=window&&self.players.get(id).is_some_and(|p|p.team!=victim_team);
  let direct=source.filter(|id|self.players.get(id).is_some_and(|p|p.team!=victim_team));
  let killer=direct.or_else(||history.iter().filter(|(id,at)|eligible(id,at)).max_by_key(|(id,at)|(**at,**id)).map(|(id,_)|*id));
  let assists:Vec<u32>=if killer.is_some() {history.iter().filter(|(id,at)|Some(**id)!=killer&&eligible(id,at)).map(|(id,_)|*id).collect()} else {Vec::new()};
  let victim=self.players.get_mut(&target).unwrap();victim.score.deaths=victim.score.deaths.saturating_add(1);victim.score.kill_streak=0;victim.score.death_streak=victim.score.death_streak.saturating_add(1);
  let mut gold=0.;let mut first=false;
  if let Some(id)=killer {
   first=!self.kill_rewards.first_blood;self.kill_rewards.first_blood=true;
   // Streak/death/minion-farm bounty adjustments deliberately remain unqualified.
   gold=rules().base_gold+if first {rules().first_blood_bonus} else {0.};
   let level=self.players[&id].level;let owner=self.players.get_mut(&id).unwrap();owner.gold+=gold;owner.score.kills=owner.score.kills.saturating_add(1);owner.score.kill_streak=owner.score.kill_streak.saturating_add(1);owner.score.death_streak=0;
   self.award_experience(id,base_experience(victim_level,level)).expect("valid kill experience recipient");
   let share=rules().base_gold*assist_pool_fraction(self.tick)/assists.len().max(1) as f32;
   for id in &assists {let owner=self.players.get_mut(id).unwrap();owner.gold+=share;owner.score.assists=owner.score.assists.saturating_add(1);}
  }
  self.kill_rewards.next_event+=1;self.kill_rewards.events.push_back(Event{sequence:self.kill_rewards.next_event,tick:self.tick,victim:target,killer,assists,first_blood:first,killer_gold:gold});
  while self.kill_rewards.events.len()>128 {self.kill_rewards.events.pop_front();}
 }
}

#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32,u32,u32) {
  let mut s=Simulation::new(Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  let a=s.join("garen").unwrap();let b=s.join("garen").unwrap();let c=s.join("garen").unwrap();(s,a,b,c)
 }
 #[test]
 fn direct_death_awards_firstblood_once_and_updates_public_score_without_duplicate_rewards() {
  let (mut s,a,b,_)=game();let gold=s.players[&a].gold;s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();
  assert_eq!(s.players[&a].gold,gold+400.);assert_eq!(s.players[&a].experience,165.);assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.players[&b].score.deaths,1);assert!(s.kill_rewards.events.back().unwrap().first_blood);
  assert!(s.apply_damage(Some(a),b,1.,damage::DamageKind::True).is_err());assert_eq!(s.players[&a].gold,gold+400.);assert_eq!(s.kill_rewards.events.len(),1);
  let p=s.players.get_mut(&b).unwrap();p.health=p.max_health;p.respawn_at=None;s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&a].gold,gold+700.);assert_eq!(s.players[&a].level,2);assert_eq!(s.players[&b].score.deaths,2);assert!(!s.kill_rewards.events.back().unwrap().first_blood);
  assert_eq!(s.snapshot().roster.iter().find(|p|p.id==a).unwrap().score.kills,2);
 }
 #[test]
 fn native_xp_increment_values_and_inferred_level_modifiers_remain_separate() {
  assert_eq!(base_experience(1,1),165.);assert_eq!(base_experience(2,2),220.);assert_eq!(base_experience(18,18),1955.25);
  assert!((base_experience(1,18)-24.75).abs()<0.001);assert!((base_experience(2,1)-246.4).abs()<0.001);
  assert_eq!(assist_pool_fraction(0),0.25);assert_eq!(assist_pool_fraction(90*TICK_RATE),0.25);assert_eq!(assist_pool_fraction(150*TICK_RATE),0.375);assert_eq!(assist_pool_fraction(210*TICK_RATE),0.5);
 }
 #[test]
 fn recent_damage_assistant_receives_native_field_pool_without_firstblood_bonus() {
  let (mut s,a,b,c)=game();let gold=s.players[&c].gold;s.apply_damage(Some(c),b,1.,damage::DamageKind::True).unwrap();s.tick=450;s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&c].gold,gold+75.);assert_eq!(s.players[&c].score.assists,1);assert_eq!(s.kill_rewards.events.back().unwrap().assists,vec![c]);
 }
 #[test]
 fn expired_assistant_disconnected_source_and_self_damage_cannot_receive_kill_credit() {
  let (mut s,a,b,c)=game();let gold=s.players[&c].gold;s.apply_damage(Some(c),b,1.,damage::DamageKind::True).unwrap();s.tick=451;s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&c].gold,gold);assert!(s.kill_rewards.events.back().unwrap().assists.is_empty());
  let (mut s,a,b,c)=game();s.record_champion_contribution(c,b);s.players.remove(&c);s.apply_damage(Some(b),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&b].score.kills,0);assert_eq!(s.players[&a].score.kills,0);assert!(s.kill_rewards.events.back().unwrap().killer.is_none());assert!(!s.kill_rewards.first_blood);
 }
 #[test]
 fn environmental_execution_uses_recent_enemy_then_later_execution_stays_uncredited() {
  let (mut s,a,b,_)=game();s.record_champion_contribution(a,b);s.tick=450;s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&a].score.kills,1);assert_eq!(s.kill_rewards.events.back().unwrap().killer,Some(a));
  let (mut s,a,b,_)=game();s.record_champion_contribution(a,b);s.tick=451;s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&a].score.kills,0);assert_eq!(s.players[&b].score.deaths,1);assert!(s.kill_rewards.events.back().unwrap().killer.is_none());
 }
 #[test]
 fn control_only_assistance_and_shielded_hits_participate_in_credit() {
  let (mut s,a,b,c)=game();for id in [a,b,c] {s.players.get_mut(&id).unwrap().position=Point{x:7700.,z:7000.};}
  s.players.get_mut(&c).unwrap().summoners.spells[0]=Some(summoners::Spell::Exhaust);s.cast_summoner_on(c,0,Some(b)).unwrap();s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&c].score.assists,1);
  let (mut s,a,b,c)=game();s.grant_shield(b,"fixture",100.,300).unwrap();let hp=s.players[&b].health;s.apply_damage(Some(c),b,1.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&b].health,hp);s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();assert_eq!(s.players[&c].score.assists,1);
 }
 #[test]
 fn score_survives_respawn_and_global_event_ring_is_bounded() {
  let (mut s,a,b,_)=game();for _ in 0..130 {let p=s.players.get_mut(&b).unwrap();p.health=p.max_health;p.respawn_at=None;s.apply_damage(Some(a),b,10000.,damage::DamageKind::True).unwrap();}
  assert_eq!(s.kill_rewards.events.len(),128);assert_eq!(s.kill_rewards.events.front().unwrap().sequence,3);assert_eq!(s.players[&b].score.deaths,130);
  s.tick=s.players[&b].respawn_at.unwrap();s.advance_respawns();assert!(s.players[&b].health>0.);assert_eq!(s.players[&b].score.deaths,130);
 }
 #[test]
 fn execution_credit_uses_hit_order_within_same_tick_instead_of_network_id_order() {
  let (mut s,a,b,c)=game();s.record_champion_contribution(c,b);s.record_champion_contribution(a,b);s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();let event=s.kill_rewards.events.back().unwrap();assert_eq!(event.killer,Some(a));assert_eq!(event.assists,vec![c]);
 }

}
