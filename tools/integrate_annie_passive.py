from pathlib import Path
import shutil
r=Path('E:/OpenLeague/crates/core/src')
for name in ['annie_passive.rs','annie_passive_tests.rs']:shutil.copyfile(Path('E:/mapslol3v3')/name,r/name)
def edit(name,old,new):
 p=r/name;s=p.read_text(encoding='utf-8');assert old in s,(name,old);p.write_text(s.replace(old,new,1),encoding='utf-8')
edit('lib.rs','pub mod annie;','pub mod annie;\npub mod annie_passive;')
edit('spells.rs','pub struct Effects {','pub struct Effects {\n    #[serde(default)]\n    pub pyromania: u8,')
edit('annie.rs','self.forward_molten_to_pet(id,rank,until);Ok(())','self.forward_molten_to_pet(id,rank,until);self.pyromania_spell(id,false);Ok(())')
edit('annie.rs','if let Ok(out)=self.apply_damage(Some(m.source),m.target,m.raw,damage::DamageKind::Magical) {','if let Ok(out)=self.apply_damage(Some(m.source),m.target,m.raw,damage::DamageKind::Magical) {\n     let stun=self.pyromania_spell(m.source,true);self.pyromania_hit(m.source,m.target,stun);')
edit('annie_w.rs','for(id,team,origin,w) in casts {','for(id,team,origin,w) in casts {\n   let stun=self.pyromania_spell(id,true);')
edit('annie_w.rs','for target in targets {let _=self.apply_damage(Some(id),target,w.raw,damage::DamageKind::Magical);}','for target in targets {if self.apply_damage(Some(id),target,w.raw,damage::DamageKind::Magical).is_ok() {self.pyromania_hit(id,target,stun);}}')
edit('annie_r.rs','for target in self.tibbers_area(team,r.point,value("radius")) {let _=self.apply_damage(Some(owner),target,r.raw,damage::DamageKind::Magical);}','let stun=self.pyromania_spell(owner,true);\n   for target in self.tibbers_area(team,r.point,value("radius")) {if self.apply_damage(Some(owner),target,r.raw,damage::DamageKind::Magical).is_ok() {self.pyromania_hit(owner,target,stun);}}')
