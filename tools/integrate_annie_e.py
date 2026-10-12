from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def edit(p,a,b):
 f=r/p;s=f.read_text(encoding='utf-8');assert a in s,(p,a);f.write_text(s.replace(a,b),encoding='utf-8')
source=json.loads((r/'docs/annie_native_sources.json').read_text(encoding='utf-8'));v=next(s['values'] for s in source['native_spells'] if s['spell']=='MoltenShield');official=source['official_spells'][2]
d={'cooldown':float(v['Cooldown']),'duration':float(v['Effect3Level1Amount']),'coefficient':float(v['Coefficient'])};checks=0
for rank in range(1,6):
 for key,native,expected in [('cost',f'ManaCost{rank}',official['cost'][rank-1]),('defense',f'Effect1Level{rank}Amount',official['effect'][1][rank-1]),('return',f'Effect2Level{rank}Amount',official['effect'][2][rank-1])]:
  value=float(v[native]);assert value==expected;d[f'{key}{rank}']=value;checks+=1
 assert d['duration']==official['effect'][3][rank-1];assert d['cooldown']==official['cooldown'][rank-1];checks+=2
(r/'data/4.20/annie_e_rules.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
edit('crates/core/src/spells.rs','pub struct Effects {','pub struct Effects {\n    #[serde(default)]\n    pub molten_until: u64,\n    #[serde(default)]\n    pub molten_rank: u8,')
methods='''
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
  let p=self.players.get_mut(&id).unwrap();p.mana-=cost;p.cooldowns[2]=self.tick+cd;p.effects.molten_until=self.tick+spells::seconds(e_value("duration"));p.effects.molten_rank=rank;Ok(())
 }
 pub(crate) fn molten_retaliation(&self,owner:u32,attacker:u32)->Option<f32> {
  let p=self.players.get(&owner)?;if defense(p,self.tick)==0. {return None;}
  let a=self.target_info(attacker)?;
  if a.health<=0. || a.team==p.team || self.units.get(&attacker).is_some_and(|u|u.kind.structure()) {return None;}
  Some(e_value(&format!("return{}",p.effects.molten_rank))+e_value("coefficient")*self.stats(owner).ability_power)
 }
 pub(crate) fn empowered_attack_hit(&mut self,source:u32,target:u32,raw:f32)->Result<damage::DamageOutcome,String> {
  let ret=if raw>0. {self.molten_retaliation(target,source)} else {None};
  let out=self.apply_damage(Some(source),target,raw,damage::DamageKind::Physical)?;
  if let Some(damage)=ret {let _=self.apply_damage(Some(target),source,damage,damage::DamageKind::Magical);}Ok(out)
 }
}
'''
edit('crates/core/src/annie.rs','impl Simulation {',methods+'\nimpl Simulation {')
edit('crates/core/src/annie.rs','if slot!=0 {','if slot==2 {return self.cast_molten(id);}\n  if slot!=0 {')
edit('crates/core/src/progression.rs','items.armor * bonus_defense\n','items.armor * bonus_defense + annie::defense(p,self.tick)\n')
edit('crates/core/src/progression.rs','items.magic_resist * bonus_defense\n','items.magic_resist * bonus_defense + annie::defense(p,self.tick)\n')
edit('crates/core/src/lifesteal.rs','let outcome = self.apply_damage','let retaliation=if raw>0. {self.molten_retaliation(target,source)} else {None};\n        let outcome = self.apply_damage')
edit('crates/core/src/lifesteal.rs','        Ok(outcome)','        if let Some(raw)=retaliation {let _=self.apply_damage(Some(target),source,raw,damage::DamageKind::Magical);}\n        Ok(outcome)')
edit('crates/core/src/attacks.rs','self.apply_damage(Some(id), w.target, raw, damage::DamageKind::Physical)','self.empowered_attack_hit(id,w.target,raw)')
edit('crates/core/src/world.rs','        let _ = self.apply_damage(\n            Some(source),\n            target,\n            raw,\n            damage::DamageKind::from_magic(magic),\n        );','        if !magic {let _=self.basic_attack_hit(source,target,raw);} else {let _=self.apply_damage(Some(source),target,raw,damage::DamageKind::Magical);}')
paths=[Path('D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Scripts')/p for p in ['Characters/Annie/E.cs','Buffs/Annie/EBuff.cs']]
receipt={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_contract':'docs/annie_native_sources.json','official_numeric_crosschecks':checks,'community_sources':[{'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],'limits':['Native and Riot4.20.1 match25cost/defense/retaliation/duration/cooldown values. Coefficient0.2 native recovered.','Community buff incorrectly scales armor/MR with champion level; implementation uses native spell-rank20/30/40/50/60.','Instant self-cast, allowance during committed Q, retaliation snapshot before damage/death, lifesteal-before-retaliation ordering and zero-damage policy reconstructed; original server event order unqualified.','Only basic and empowered attack paths trigger magical retaliation; no recursive spell retaliation. Champion/lane/camp attackers connected, structures excluded. Shield absorption behavior needs historical acceptance.','Tibbers application missing with pet system, passive charge/stun sequencing unresolved, W/R/animations/particles/audio/nativeHUD incomplete. Entiregame incomplete.']}
(r/'docs/annie_e_sources.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print('Integrated native historical Molten Shield;25official comparisons. Fixed community champion-level defense error using native spell rank.')
