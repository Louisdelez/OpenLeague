//! Historical Disintegrate foundation. Full Annie kit/passive/VFX remain incomplete.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Pending {pub target:u32,pub releases:u64,pub raw:f32,pub cost:f32,#[serde(default)] pub refund_ticks:u64,#[serde(default)] pub cooldown_ready:u64}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Missile {pub source:u32,pub target:u32,pub position:Point,pub raw:f32,pub cost:f32,#[serde(default)] pub refund_ticks:u64,#[serde(default)] pub cooldown_ready:u64}
pub fn value(key:&str)->f32 {
 static DATA:OnceLock<serde_json::Value>=OnceLock::new();
 let v=&DATA.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/annie_q_rules.json")).unwrap())[key];
 v.as_f64().unwrap() as f32
}

pub fn e_value(key:&str)->f32 {
 static DATA:OnceLock<serde_json::Value>=OnceLock::new();
 DATA.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/annie_e_rules.json")).unwrap())[key].as_f64().unwrap() as f32
}
pub fn defense(p:&Champion,tick:u64)->f32 {
 if p.champion=="annie" && p.health>0. && tick<p.effects.molten_until && (1..=5).contains(&p.effects.molten_rank) {e_value(&format!("defense{}",p.effects.molten_rank))} else {0.}
}
impl Simulation {
 pub(crate) fn cast_molten(&mut self,id:u32)->Result<(),String> {
  let p=self.players.get(&id).ok_or("unknown player")?;let rank=p.ranks[2];
  if rank==0 {return Err("skill not learned".into());}
  if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
  if self.tick<p.cooldowns[2] {return Err("skill on cooldown".into());}
  let cost=e_value(&format!("cost{rank}"));if p.mana<cost {return Err("insufficient mana".into());}
  let cd=cooldown::ticks(e_value("cooldown"),self.stats(id).cooldown_reduction);
  let p=self.players.get_mut(&id).unwrap();p.mana-=cost;p.cooldowns[2]=self.tick+cd;p.cooldown_totals[2]=Some(cd);p.effects.molten_until=self.tick+spells::seconds(e_value("duration"));p.effects.molten_rank=rank;let until=p.effects.molten_until;self.forward_molten_to_pet(id,rank,until);self.pyromania_spell(id,false);Ok(())
 }
 pub(crate) fn molten_retaliation(&self,owner:u32,attacker:u32)->Option<f32> {
  if self.units.contains_key(&owner) {return self.pet_molten_retaliation(owner,attacker);}
  let p=self.players.get(&owner)?;if defense(p,self.tick)==0. {return None;}
  let a=self.target_info(attacker)?;
  if a.health<=0. || a.team==p.team || self.units.get(&attacker).is_some_and(|u|u.kind.structure()) {return None;}
  Some(e_value(&format!("return{}",p.effects.molten_rank))+e_value("coefficient")*self.stats(owner).ability_power)
 }
 pub(crate) fn empowered_attack_hit(&mut self,source:u32,target:u32,raw:f32)->Result<damage::DamageOutcome,String> {
  // Garen Q is the sole caller: its empowered basic hit uses ordinary attack effects.
  self.basic_attack_hit(source,target,raw)
 }
}

impl Simulation {
 pub(crate) fn cast_annie(&mut self,id:u32,slot:u8,target:Option<u32>)->Result<(),String> {
  if slot==2 {return self.cast_molten(id);}
  if slot==1 {return Err("directional spell requires ground point".into());}
  if slot==3 {
   if self.tibbers(id).is_some() {let target=target.ok_or("pet command requires target or ground point")?;let point=self.target_info(target).ok_or("unknown target")?.position;return self.cast_tibbers(id,point);}
   return Err("summon spell requires ground point".into());
  }
  if slot!=0 {return Err("Annie spell not implemented".into());}
  let p=self.players.get(&id).ok_or("unknown player")?;
  let rank=p.ranks[0];if rank==0 {return Err("skill not learned".into());}
  if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
  if p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.effects.annie_r.is_some() {return Err("skill blocked during cast".into());}
  if self.tick<p.cooldowns[0] {return Err("skill on cooldown".into());}
  let target=target.ok_or("Disintegrate requires enemy target")?;
  let e=self.target_info(target).ok_or("unknown target")?;
  if e.team==p.team || e.health<=0. || self.units.get(&target).is_some_and(|u|u.kind.structure()) || self.protected(target) {return Err("invalid enemy target".into());}
  if !self.visible_to(p.team,target) {return Err("spell target not visible".into());}
  if p.position.distance(e.position)>value("range") {return Err("spell target out of range".into());}
  let cost=value(&format!("cost{rank}"));if p.mana<cost {return Err("insufficient mana".into());}
  let stats=self.stats(id);let raw=value(&format!("damage{rank}"))+value("coefficient")*stats.ability_power;
  let cd=cooldown::ticks(value("cooldown"),stats.cooldown_reduction);
  // Native cannot-cancel flag: preserve the committed spell through later controls.
  // Cast duration uses supplied community SpellData.GetCastTime interpretation.
  let p=self.players.get_mut(&id).unwrap();p.mana-=cost;p.cooldowns[0]=self.tick+cd;p.cooldown_totals[0]=Some(cd);
  p.windup=None;p.effects.annie_q=Some(Pending{target,releases:self.tick+spells::seconds(value("cast_seconds")),raw,cost,refund_ticks:(cd as f32*value("kill_cooldown_refund_fraction")).floor() as u64,cooldown_ready:self.tick+cd});Ok(())
 }
 pub(crate) fn advance_annie(&mut self) {
  let mut launches=Vec::new();
  for p in self.players.values_mut() {
   if p.health<=0. {p.effects.annie_q=None;continue;}
   if p.effects.annie_q.as_ref().is_some_and(|q|self.tick>=q.releases) {
    let q=p.effects.annie_q.take().unwrap();launches.push(Missile{source:p.id,target:q.target,position:p.position,raw:q.raw,cost:q.cost,refund_ticks:q.refund_ticks,cooldown_ready:q.cooldown_ready});
   }
  }
  // Existing flights advance first; newly released missiles start travelling next tick.
  for mut m in std::mem::take(&mut self.spell_projectiles) {
   let Some(e)=self.target_info(m.target).filter(|e|e.health>0.) else {continue;};
   if !self.players.contains_key(&m.source) {continue;}
   let d=m.position.distance(e.position);let step=value("missile_speed")/TICK_RATE as f32;
   if d<=step {
    if let Ok(out)=self.apply_damage(Some(m.source),m.target,m.raw,damage::DamageKind::Magical) {
     let stun=self.pyromania_spell(m.source,true);self.pyromania_hit(m.source,m.target,stun);
     if out.lethal {let max=self.stats(m.source).max_mana;let p=self.players.get_mut(&m.source).unwrap();p.mana=(p.mana+m.cost).min(max);if p.cooldowns[0]==m.cooldown_ready {p.cooldowns[0]=p.cooldowns[0].saturating_sub(m.refund_ticks).max(self.tick);}}
    }
   } else {m.position.x+=(e.position.x-m.position.x)*step/d;m.position.z+=(e.position.z-m.position.z)*step/d;self.spell_projectiles.push(m);}
  }
  let launches:Vec<_>=launches.into_iter().filter(|m|self.target_info(m.target).is_some_and(|e|e.health>0.)).collect();self.spell_projectiles.extend(launches);
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32,u32) {
  let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
  let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap()).unwrap();let a=s.join("annie").unwrap();let b=s.join("garen").unwrap();s.players.get_mut(&a).unwrap().position=Point{x:100.,z:100.};s.players.get_mut(&b).unwrap().position=Point{x:600.,z:100.};s.learn(a,0).unwrap();(s,a,b)
 }
 #[test] fn native_cost_cast_delay_damage_and_refund_only_on_own_lethal_hit() {
  let(mut s,a,b)=game();let mana=s.players[&a].mana;let hp=s.players[&b].health;
  s.cast(a,0,Some(b)).unwrap();assert_eq!(s.players[&a].mana,mana-60.);assert_eq!(s.players[&a].cooldowns[0],120);
  for tick in 1..8 {s.tick=tick;s.advance_annie();assert!(s.spell_projectiles.is_empty());}
  s.tick=8;s.advance_annie();assert_eq!(s.spell_projectiles.len(),1);assert_eq!(s.players[&b].health,hp);
  for tick in 9..=19 {s.tick=tick;s.advance_annie();}assert!(s.spell_projectiles.is_empty());let expected=80.*100./(100.+s.stats(b).magic_resist);assert!((hp-s.players[&b].health-expected).abs()<0.001);assert_eq!(s.players[&a].mana,mana-60.);
  s.tick=120;s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,Some(b)).unwrap();for tick in 121..=139 {s.tick=tick;s.advance_annie();}assert_eq!(s.players[&a].mana,mana-60.);assert_eq!(s.players[&a].cooldowns[0],180);assert_eq!(s.players[&a].score.kills,1);
 }
 #[test] fn kill_refund_snapshots_cdr_and_reduces_half_total_cooldown_not_half_remaining() {
  let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.players.get_mut(&b).unwrap().health=1.;let mana=s.players[&a].mana;s.cast(a,0,Some(b)).unwrap();assert_eq!(s.players[&a].cooldowns[0],108);
  // Selling the CDR source after commitment must not change the refund amount.
  s.players.get_mut(&a).unwrap().inventory[0]=None;for tick in 1..=19 {s.tick=tick;s.advance_annie();}assert_eq!(s.players[&a].cooldowns[0],54);assert_eq!(s.players[&a].mana,mana);
  s.tick=53;assert_eq!(s.cast(a,0,Some(b)).unwrap_err(),"skill on cooldown");
 }
 #[test] fn late_lethal_missile_clamps_refund_and_cannot_modify_newer_cast_cooldown() {
  for newer in [false,true] {
   let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,Some(b)).unwrap();s.tick=8;s.advance_annie();s.spell_projectiles[0].position=s.players[&b].position;
   s.tick=150;if newer {s.players.get_mut(&a).unwrap().cooldowns[0]=270;}
   s.advance_annie();assert_eq!(s.players[&a].cooldowns[0],if newer {270} else {150});assert_eq!(s.players[&a].score.kills,1);
  }
 }
 #[test] fn failed_targets_and_resource_checks_leave_cost_and_cooldown_untouched() {
  let(mut s,a,b)=game();let mana=s.players[&a].mana;
  for target in [None,Some(a),Some(999)] {assert!(s.cast(a,0,target).is_err());assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns[0],0);}
  s.players.get_mut(&b).unwrap().position.x=800.;assert!(s.cast(a,0,Some(b)).is_err());s.players.get_mut(&b).unwrap().position.x=600.;s.players.get_mut(&a).unwrap().mana=59.;assert_eq!(s.cast(a,0,Some(b)).unwrap_err(),"insufficient mana");assert_eq!(s.players[&a].mana,59.);assert_eq!(s.players[&a].cooldowns[0],0);
 }
 #[test] fn committed_cast_survives_stun_and_projectile_survives_caster_death() {
  let(mut s,a,b)=game();s.cast(a,0,Some(b)).unwrap();s.grant_stun(Some(b),a,"test",90).unwrap();s.tick=8;s.advance_annie();assert_eq!(s.spell_projectiles.len(),1);let hp=s.players[&b].health;s.players.get_mut(&a).unwrap().health=0.;for tick in 9..=19 {s.tick=tick;s.advance_annie();}assert!(s.players[&b].health<hp);
 }
 #[test] fn dead_target_dissipates_without_mana_refund_and_snapshot_filters_visibility() {
  let(mut s,a,b)=game();s.cast(a,0,Some(b)).unwrap();s.tick=8;s.advance_annie();assert_eq!(s.snapshot_for(a).unwrap().spell_projectiles.len(),1);let mana=s.players[&a].mana;s.players.get_mut(&b).unwrap().health=0.;s.tick=9;s.advance_annie();assert!(s.spell_projectiles.is_empty());assert_eq!(s.players[&a].mana,mana);
 }
 #[test] fn molten_defenses_use_spell_rank_not_champion_level_and_expire_exactly() {
  for rank in 1..=5 {
   let(mut s,a,_)=game();let p=s.players.get_mut(&a).unwrap();p.level=18;p.ranks[2]=rank;
   let stats=s.stats(a);let mana=s.players[&a].mana;s.cast(a,2,None).unwrap();let bonus=10.+10.*rank as f32;
   assert_eq!(s.stats(a).armor,stats.armor+bonus);assert_eq!(s.stats(a).magic_resist,stats.magic_resist+bonus);assert_eq!(s.players[&a].mana,mana-20.);assert_eq!(s.players[&a].cooldowns[2],300);assert_eq!(s.players[&a].effects.molten_until,150);
   s.tick=149;assert_eq!(defense(&s.players[&a],s.tick),bonus);s.tick=150;assert_eq!(s.stats(a).armor,stats.armor);assert_eq!(s.stats(a).magic_resist,stats.magic_resist);
  }
 }
 #[test] fn molten_guards_are_atomic_and_cdr_changes_cooldown_only() {
  let(mut s,a,b)=game();assert!(s.cast(a,2,None).is_err());let p=s.players.get_mut(&a).unwrap();p.level=2;s.learn(a,2).unwrap();s.players.get_mut(&a).unwrap().mana=19.;assert_eq!(s.cast(a,2,None).unwrap_err(),"insufficient mana");assert_eq!(s.players[&a].effects.molten_until,0);assert_eq!(s.players[&a].cooldowns[2],0);
  s.players.get_mut(&a).unwrap().mana=100.;s.grant_stun(Some(b),a,"stun",10).unwrap();assert_eq!(s.cast(a,2,None).unwrap_err(),"champion stunned");s.players.get_mut(&a).unwrap().stuns.clear();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.cast(a,2,None).unwrap();assert_eq!(s.players[&a].cooldowns[2],270);assert_eq!(s.players[&a].effects.molten_until,150);assert_eq!(s.players[&a].mana,80.);assert_eq!(s.cast(a,2,None).unwrap_err(),"skill on cooldown");assert_eq!(s.players[&a].mana,80.);
 }
 #[test] fn molten_retaliates_basic_hits_with_native_ap_but_not_spell_damage() {
  let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=2;s.learn(a,2).unwrap();s.players.get_mut(&a).unwrap().inventory[0]=Some(1052);s.cast(a,2,None).unwrap();let hp=s.players[&b].health;let expected=(20.+20.*0.2)*100./(100.+s.stats(b).magic_resist);
  s.basic_attack_hit(b,a,40.).unwrap();assert!((hp-s.players[&b].health-expected).abs()<0.001);let hp=s.players[&b].health;s.apply_damage(Some(b),a,40.,damage::DamageKind::Magical).unwrap();assert_eq!(s.players[&b].health,hp);s.tick=150;s.basic_attack_hit(b,a,40.).unwrap();assert_eq!(s.players[&b].health,hp);
 }
 #[test] fn molten_retaliation_does_not_recurse_and_survives_lethal_basic_hit() {
  let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().champion="annie".into();for id in [a,b] {let p=s.players.get_mut(&id).unwrap();p.level=2;p.ranks[2]=1;p.mana=100.;s.cast(id,2,None).unwrap();}
  let bhp=s.players[&b].health;let ahp=s.players[&a].health;s.basic_attack_hit(b,a,10.).unwrap();let expected=20.*100./(100.+s.stats(b).magic_resist);assert!((bhp-s.players[&b].health-expected).abs()<0.001);assert!((ahp-s.players[&a].health-10.*100./(100.+s.stats(a).armor)).abs()<0.001);
  let bhp=s.players[&b].health;s.players.get_mut(&a).unwrap().health=1.;s.basic_attack_hit(b,a,100.).unwrap();assert_eq!(s.players[&a].health,0.);assert_eq!(s.players[&a].effects.molten_until,0);assert!((bhp-s.players[&b].health-expected).abs()<0.001);
 }
 #[test] fn molten_world_attack_pipeline_retaliates_monsters_and_excludes_towers() {
  let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=Simulation::new(nav).unwrap();s.enable_map10().unwrap();let a=s.join("annie").unwrap();s.tick=3300;s.advance_world();s.players.get_mut(&a).unwrap().level=2;s.learn(a,2).unwrap();s.cast(a,2,None).unwrap();let monster=s.units.values().find(|u|u.kind==world::Kind::Monster).unwrap().id;let hp=s.units[&monster].health;s.hit(monster,a,20.,false);assert!(s.units[&monster].health<hp);let turret=s.units.values().find(|u|u.kind==world::Kind::Turret&&u.team!=s.players[&a].team).unwrap().id;let hp=s.units[&turret].health;s.hit(turret,a,20.,false);assert_eq!(s.units[&turret].health,hp);
 }

}
