from pathlib import Path
r=Path(r'E:/OpenLeague')
(r/'crates/core/src/champion_kills.rs').write_text('''//! Champion death/reward bookkeeping. Native values qualified; detailed policies reconstructed.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Copy,Default,Serialize,Deserialize)]
pub struct Score {pub kills:u32,pub deaths:u32,pub assists:u32,pub kill_streak:u32,pub death_streak:u32}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Event {pub sequence:u64,pub tick:u64,pub victim:u32,pub killer:Option<u32>,pub assists:Vec<u32>,pub first_blood:bool,pub killer_gold:f32}
#[derive(Default)]
pub(crate) struct State {hits:BTreeMap<u32,BTreeMap<u32,u64>>,pub events:VecDeque<Event>,first_blood:bool,next_event:u64}
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
  self.kill_rewards.hits.entry(target).or_default().insert(source,self.tick);
 }
 pub(crate) fn reward_champion_death(&mut self,source:Option<u32>,target:u32) {
  let Some(victim)=self.players.get(&target) else {return};let victim_team=victim.team;let victim_level=victim.level;
  let history=self.kill_rewards.hits.remove(&target).unwrap_or_default();let window=spells::seconds(rules().assist_seconds);
  let eligible=|id:&u32,at:&u64|self.tick.saturating_sub(*at)<=window&&self.players.get(id).is_some_and(|p|p.team!=victim_team);
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
''',encoding='utf-8')
def edit(name,old,new):
 p=r/name;s=p.read_text(encoding='utf-8');assert old in s,(name,old);p.write_text(s.replace(old,new,1),encoding='utf-8')
edit('crates/core/src/lib.rs','pub mod combat;','pub mod combat;\npub mod champion_kills;')
edit('crates/core/src/lib.rs','    pub experience: f32,','    pub experience: f32,\n    #[serde(default)]\n    pub score: champion_kills::Score,')
edit('crates/core/src/lib.rs','    pub winner: Option<u8>,\n    #[serde(default)]','    pub winner: Option<u8>,\n    #[serde(default)]\n    pub kill_events: Vec<champion_kills::Event>,\n    #[serde(default)]')
edit('crates/core/src/lib.rs','    pub(crate) critical_rng: u64,','    pub(crate) critical_rng: u64,\n    pub(crate) kill_rewards: champion_kills::State,')
edit('crates/core/src/lib.rs','            critical_rng: 0,','            critical_rng: 0,\n            kill_rewards: Default::default(),')
edit('crates/core/src/lib.rs','                experience: 0.,','                experience: 0.,\n                score: Default::default(),')
edit('crates/core/src/lib.rs','                    team: p.team,','                    team: p.team,\n                    score: p.score,')
edit('crates/core/src/lib.rs','            winner: self.winner,','            winner: self.winner,\n            kill_events: self.kill_rewards.events.iter().cloned().collect(),')
edit('crates/core/src/vision.rs','    pub team: u8,','    pub team: u8,\n    #[serde(default)]\n    pub score: champion_kills::Score,')
edit('crates/core/src/progression.rs','fn threshold(level: u8)','pub(crate) fn threshold(level: u8)')
edit('crates/core/src/damage.rs','        let before = info.health;','''        if raw>0. && self.players.contains_key(&target) {if let Some(id)=source {self.record_champion_contribution(id,target);}}
        let before = info.health;''')
edit('crates/core/src/damage.rs','        Ok(DamageOutcome {','''        if before>0. && after==0. && self.players.contains_key(&target) {self.reward_champion_death(source,target);}
        Ok(DamageOutcome {''')
edit('crates/core/src/summoner_exhaust.rs','        self.record_enemy_ability_hit(target)?;','        self.record_enemy_ability_hit(target)?;\n        self.record_champion_contribution(id,target);')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s=s.replace('| niveau {} | XP','| niveau {} | K/D/A {}/{}/{} | XP',1);s=s.replace('player.level,player.experience','player.level,player.score.kills,player.score.deaths,player.score.assists,player.experience',1);p.write_text(s,encoding='utf-8')
print('Champion death credit, baseline rewards, score and snapshot integration written')
