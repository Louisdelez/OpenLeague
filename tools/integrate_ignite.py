from pathlib import Path
r=Path(r'E:/OpenLeague')
(r/'crates/core/src/summoner_ignite.rs').write_text('''//! Official4.20.1 Ignite totals/tooltip; tick cadence and replacement reconstructed from supplied server.
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
''',encoding='utf-8')
def edit(name,old,new):
 p=r/name;s=p.read_text(encoding='utf-8');assert old in s,(name,old);p.write_text(s.replace(old,new,1),encoding='utf-8')
edit('crates/core/src/lib.rs','pub mod summoner_heal;','pub mod summoner_heal;\npub mod summoner_ignite;')
edit('crates/core/src/lib.rs','        self.advance_interactions();','        self.advance_ignite();\n        self.advance_interactions();')
edit('crates/core/src/spells.rs','pub struct Effects {','pub struct Effects {\n    #[serde(default)]\n    pub ignite: Option<summoner_ignite::Burn>,')
edit('crates/core/src/summoners.rs','    Exhaust,','    Exhaust,\n    Ignite,')
edit('crates/core/src/summoners.rs','            Spell::Heal =>','            Spell::Ignite => self.cast_ignite(id, slot, target)?,\n            Spell::Heal =>')
edit('crates/core/src/healing.rs','impl Simulation {','/// Shared received-healing policy. Additional native debuffs/modifiers remain unimplemented.\npub fn received_multiplier(p: &Champion, tick: u64) -> f32 {summoner_ignite::healing_multiplier(p,tick)}\nimpl Simulation {')
edit('crates/core/src/healing.rs','p.health + amount','p.health + amount * received_multiplier(p,self.tick)')
edit('crates/core/src/regeneration.rs','(rates.health_per_second + passive) / TICK_RATE as f32','(rates.health_per_second + passive) * healing::received_multiplier(p,self.tick) / TICK_RATE as f32')
edit('crates/core/src/lifesteal.rs','''                let p = self.players.get_mut(&source).unwrap();
                p.health = (p.health + amount).min(p.max_health);''','''                self.heal(Some(source),source,amount)?;''')
edit('crates/core/src/interactions.rs','p.max_health * c.fountain_heal_fraction).min','p.max_health * c.fountain_heal_fraction * healing::received_multiplier(p,self.tick)).min')
edit('crates/core/src/interactions.rs','p.health + c.relic_health_base + c.relic_health_per_level * level','p.health + (c.relic_health_base + c.relic_health_per_level * level) * healing::received_multiplier(p,self.tick)')
edit('crates/core/src/vision.rs','        self.visible_point_to(team, enemy.position)','''        if self.players.get(&target).and_then(|p|p.effects.ignite.as_ref()).is_some_and(|b|b.source_team==team && self.tick<b.expires_at) {return true;}
        self.visible_point_to(team, enemy.position)''')
edit('crates/client/src/picking.rs','pub fn exhaust_target(','''pub fn ignite_target(snapshot:&Snapshot,own_id:u32,origin:[f32;3],direction:[f32;3])->Option<u32> {
 enemy_target(snapshot,own_id,origin,direction,true,Some(openleague_core::summoner_ignite::range()))
}
pub fn exhaust_target(''')
edit('crates/client/src/main.rs','                    | openleague_core::summoners::Spell::Exhaust','                    | openleague_core::summoners::Spell::Exhaust\n                    | openleague_core::summoners::Spell::Ignite')
edit('crates/client/src/main.rs','''                    } else {
                        picking::exhaust_target
                    };''','''                    } else if connection.summoners[slot as usize]==Some(openleague_core::summoners::Spell::Ignite) {
                        picking::ignite_target
                    } else {
                        picking::exhaust_target
                    };''')
edit('crates/client/src/main.rs','Some(openleague_core::summoners::Spell::Exhaust) => "Fatigue",','Some(openleague_core::summoners::Spell::Exhaust) => "Fatigue",\n                            Some(openleague_core::summoners::Spell::Ignite) => "Embrasement",')
edit('launcher/src-tauri/src/main.rs','s != "Exhaust"','s != "Exhaust" && s != "Ignite"')
p=r/'launcher/web/index.html';s=p.read_text(encoding='utf-8');s=s.replace('<option value="Exhaust">Fatigue</option>','<option value="Exhaust">Fatigue</option><option value="Ignite">Embrasement</option>');p.write_text(s,encoding='utf-8')
print('Ignite and shared healing/vision integration written')
