from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8').replace('pub mod slows;','pub mod slows;\npub mod stuns;',1).replace('    pub slows: Vec<slows::Slow>,','    pub slows: Vec<slows::Slow>,\n    #[serde(default)]\n    pub stuns: Vec<stuns::Stun>,',1).replace('                slows: Vec::new(),','                slows: Vec::new(),\n                stuns: Vec::new(),',1).replace('        match action {','        if stuns::active(player,self.tick) && matches!(&action,Action::Move{..}|Action::Attack{..}) {return Err("champion stunned".into());}\n        match action {',1).replace('        self.advance_slows();','        self.advance_slows();\n        self.advance_stuns();',1).replace('            if p.health <= 0. {\n                continue;\n            }','            if p.health <= 0. || stuns::active(p,self.tick) {\n                continue;\n            }',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/damage.rs';s=p.read_text(encoding='utf-8').replace('                    p.slows.clear();','                    p.slows.clear();\n                    p.stuns.clear();',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/lifecycle.rs';s=p.read_text(encoding='utf-8').replace('            p.slows.clear();','            p.slows.clear();\n            p.stuns.clear();',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/combat.rs';s=p.read_text(encoding='utf-8').replace('if p.health <= 0. || p.effects.ultimate.is_some() || p.windup.is_some()','if p.health <= 0. || stuns::active(p,self.tick) || p.effects.ultimate.is_some() || p.windup.is_some()',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/attacks.rs';s=p.read_text(encoding='utf-8').replace('if p.health <= 0. || p.effects.ultimate.is_some() || self.tick < p.effects.spin_until','if p.health <= 0. || stuns::active(p,self.tick) || p.effects.ultimate.is_some() || self.tick < p.effects.spin_until',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/spells.rs';s=p.read_text(encoding='utf-8').replace('        if p.champion != "garen" {','        if stuns::active(p,self.tick) {return Err("champion stunned".into());}\n        if p.champion != "garen" {',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/summoners.rs';s=p.read_text(encoding='utf-8').replace('        if self.tick < p.summoners.ready_at[slot as usize] {','        let native_name=match spell {Spell::Barrier=>"SummonerBarrier",Spell::Heal=>"SummonerHeal",Spell::Exhaust=>"SummonerExhaust",Spell::Ignite=>"SummonerDot"};\n        if stuns::active(p,self.tick) && !stuns::allows_disabled(native_name)? {return Err("summoner disabled while stunned".into());}\n        if self.tick < p.summoners.ready_at[slot as usize] {',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/consumables.rs';s=p.read_text(encoding='utf-8').replace('  let effect=item.consumable.ok_or("item active not implemented")?;let duration=', '  let effect=item.consumable.ok_or("item active not implemented")?;\n  let native_name=match effect.kind {Kind::Health=>"RegenerationPotion",Kind::Mana=>"FlaskOfCrystalWater"};\n  if stuns::active(p,self.tick) && !stuns::allows_disabled(native_name)? {return Err("item disabled while stunned".into());}\n  let duration=',1);p.write_text(s,encoding='utf-8')
(r/'crates/core/src/stuns.rs').write_text('''//! Champion stuns and native disabled-cast flags; detailed CC policies reconstructed.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Stun {pub tag:String,pub source:Option<u32>,pub expires_at:u64}
pub fn active(p:&Champion,tick:u64)->bool {p.health>0. && p.stuns.iter().any(|s|s.expires_at>tick)}
pub fn allows_disabled(name:&str)->Result<bool,String> {
 #[derive(Deserialize)]struct Rules {allows:BTreeMap<String,bool>}
 static R:OnceLock<Rules>=OnceLock::new();
 R.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/disabled_cast_rules.json")).unwrap()).allows.get(name).copied().ok_or_else(||"disabled cast policy not qualified".into())
}
impl Simulation {
 /// Server event API only. Clients cannot issue arbitrary stuns.
 pub fn grant_stun(&mut self,source:Option<u32>,target:u32,tag:&str,duration:u64)->Result<(),String> {
  if self.winner.is_some() {return Err("match ended".into());}
  if tag.is_empty() || duration==0 {return Err("invalid stun".into());}
  if source.is_some_and(|id|self.target_info(id).is_none()) {return Err("unknown stun source".into());}
  let p=self.players.get(&target).ok_or("champion stun target required")?;if p.health<=0. {return Err("stun target dead".into());}
  let duration=spells::control_duration(p,self.tick,duration);
  let p=self.players.get_mut(&target).unwrap();p.stuns.retain(|s|s.tag!=tag && s.expires_at>self.tick);
  p.stuns.push(Stun{tag:tag.into(),source,expires_at:self.tick.saturating_add(duration)});
  // Force interruption preserves the roll and cadence; order buffers resume after expiry.
  p.windup=None;
  if let Some(id)=source {self.record_champion_contribution(id,target);}
  Ok(())
 }
 pub(crate) fn advance_stuns(&mut self) {for p in self.players.values_mut() {p.stuns.retain(|s|p.health>0. && s.expires_at>self.tick);}}
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game(name:&str)->(Simulation,u32,u32) {
  let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
  let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap()).unwrap();let a=s.join(name).unwrap();let b=s.join("garen").unwrap();s.players.get_mut(&a).unwrap().position=Point{x:100.,z:100.};s.players.get_mut(&b).unwrap().position=Point{x:150.,z:100.};(s,a,b)
 }
 #[test]
 fn movement_pauses_and_preserved_order_resumes_at_exact_expiry() {
  let (mut s,a,b)=game("garen");s.command(a,Action::Move{point:Point{x:400.,z:100.}}).unwrap();s.advance();let before=s.players[&a].position;s.grant_stun(Some(b),a,"cc",6).unwrap();let path=s.players[&a].path.clone();
  assert!(s.command(a,Action::Move{point:Point{x:500.,z:100.}}).is_err());assert!(s.command(a,Action::Attack{target:b}).is_err());assert_eq!(s.players[&a].path,path);assert_eq!(s.stats(a).move_speed,345.);
  for _ in 0..5 {s.advance();assert_eq!(s.players[&a].position,before);}s.advance();assert!(!active(&s.players[&a],s.tick));assert_ne!(s.players[&a].position,before);
 }
 #[test]
 fn stun_cancels_windup_and_prevents_damage_until_attacks_can_resume() {
  let (mut s,a,b)=game("garen");s.command(a,Action::Attack{target:b}).unwrap();s.advance();assert!(s.players[&a].windup.is_some());let hp=s.players[&b].health;s.grant_stun(Some(b),a,"cc",30).unwrap();assert!(s.players[&a].windup.is_none());for _ in 0..29 {s.advance();assert_eq!(s.players[&b].health,hp);}s.advance();while s.players[&b].health==hp {s.advance();assert!(s.tick<100);}assert!(s.players[&b].health<hp);
 }
 #[test]
 fn launched_projectile_survives_caster_stun() {
  let (mut s,a,b)=game("ahri");s.players.get_mut(&b).unwrap().position=Point{x:450.,z:100.};s.command(a,Action::Attack{target:b}).unwrap();while s.projectiles.is_empty() {s.advance();assert!(s.tick<100);}let hp=s.players[&b].health;s.grant_stun(Some(b),a,"cc",90).unwrap();while s.players[&b].health==hp {s.advance();assert!(s.tick<150);}assert!(active(&s.players[&a],s.tick));
 }
 #[test]
 fn same_tag_refresh_and_independent_tags_expire_without_cumulative_tenacity() {
  let (mut s,a,_)=game("garen");s.command(a,Action::Learn{slot:1}).unwrap();s.cast(a,1,None).unwrap();s.grant_stun(None,a,"one",100).unwrap();assert_eq!(s.players[&a].stuns[0].expires_at,70);s.tick=3;s.grant_stun(None,a,"one",10).unwrap();assert_eq!(s.players[&a].stuns.len(),1);assert_eq!(s.players[&a].stuns[0].expires_at,10);s.grant_stun(None,a,"two",30).unwrap();s.tick=10;s.advance_stuns();assert!(active(&s.players[&a],s.tick));assert_eq!(s.players[&a].stuns.len(),1);s.tick=24;s.advance_stuns();assert!(!active(&s.players[&a],s.tick));
 }
 #[test]
 fn native_summoners_remain_castable_and_garen_spells_potions_are_blocked() {
  for spell in [summoners::Spell::Barrier,summoners::Spell::Heal,summoners::Spell::Exhaust,summoners::Spell::Ignite] {
   let (mut s,a,b)=game("garen");s.players.get_mut(&a).unwrap().summoners.spells[0]=Some(spell);s.command(a,Action::Learn{slot:0}).unwrap();s.buy_item(a,2003).unwrap();s.players.get_mut(&a).unwrap().health=100.;s.grant_stun(Some(b),a,"cc",100).unwrap();assert!(s.cast(a,0,None).is_err());assert_eq!(s.players[&a].cooldowns[0],0);assert!(s.use_item(a,0).is_err());assert_eq!(s.players[&a].inventory_counts[0],1);s.cast_summoner_on(a,0,Some(b)).unwrap();assert!(s.players[&a].summoners.ready_at[0]>0);
  }
 }
 #[test]
 fn periodic_spin_and_native_noncancelable_ultimate_keep_resolving() {
  let (mut s,a,b)=game("garen");s.command(a,Action::Learn{slot:2}).unwrap();s.cast(a,2,None).unwrap();let until=s.players[&a].effects.spin_until;s.grant_stun(Some(b),a,"cc",100).unwrap();assert!(s.cast(a,2,None).is_err());assert_eq!(s.players[&a].effects.spin_until,until);let hp=s.players[&b].health;s.tick=15;s.advance_spells();assert!(s.players[&b].health<hp);
  let (mut s,a,b)=game("garen");s.award_experience(a,progression::threshold(6)).unwrap();s.command(a,Action::Learn{slot:3}).unwrap();s.cast(a,3,Some(b)).unwrap();s.grant_stun(Some(b),a,"cc",100).unwrap();let hp=s.players[&b].health;s.tick=15;s.advance_spells();assert!(s.players[&b].health<hp);
 }
 #[test]
 fn invalid_events_death_cleanup_and_control_execution_credit_are_atomic() {
  let (mut s,a,b)=game("garen");for (source,tag,duration) in [(Some(999),"cc",10),(None,"",10),(None,"cc",0)] {assert!(s.grant_stun(source,b,tag,duration).is_err());assert!(s.players[&b].stuns.is_empty());}s.grant_stun(Some(a),b,"cc",30).unwrap();s.apply_damage(None,b,10000.,damage::DamageKind::True).unwrap();assert!(s.players[&b].stuns.is_empty());assert_eq!(s.players[&a].score.kills,1);assert!(s.grant_stun(None,b,"cc",30).is_err());s.winner=Some(0);assert!(s.grant_stun(None,a,"cc",30).is_err());
 }
}
''',encoding='utf-8');print('Integrated championstuns/nativecast flags,sevenbehavior tests')
