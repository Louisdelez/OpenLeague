from pathlib import Path
r=Path('E:/OpenLeague')
def edit(path,old,new):
 p=r/path;s=p.read_text(encoding='utf-8');assert old in s,(path,old);p.write_text(s.replace(old,new,1),encoding='utf-8')
edit('crates/core/src/world.rs','    pub pet: Option<annie_r::Pet>,','    pub pet: Option<annie_r::Pet>,\n    #[serde(default)]\n    pub stuns: Vec<stuns::Stun>,')
edit('crates/core/src/world.rs','            pet: None,','            pet: None,\n            stuns: Vec::new(),')
edit('crates/core/src/world.rs','    resolves: u64,','    resolves: u64,\n    releases: u64,\n    ranged: bool,')
edit('crates/core/src/world.rs','        unit.path.clear();','        unit.stuns.clear();\n        unit.path.clear();')
edit('crates/core/src/world.rs','            let def = &definitions[&unit.definition];','            if stuns::unit_active(unit,self.tick) {continue;}\n            let def = &definitions[&unit.definition];')
edit('crates/core/src/world.rs','                            resolves: self.tick + def.attack_windup + travel,','                            resolves: self.tick + def.attack_windup + travel,\n                            releases: self.tick + def.attack_windup,\n                            ranged: def.projectile_speed > 0.,')
old='''            } else if self
                .units
                .get(&attack.source)
                .is_some_and(|u| u.health > 0.)'''
new='''            } else if (attack.ranged && attack.releases<=self.tick && self.units.contains_key(&attack.source)) || self
                .units
                .get(&attack.source)
                .is_some_and(|u| u.health > 0. && !stuns::unit_active(u,self.tick))'''
edit('crates/core/src/world.rs',old,new)
edit('crates/core/src/world.rs','    pub(crate) fn cancel_pet_attack(&mut self,id:u32) {','    pub(crate) fn interrupt_unit_windup(&mut self,id:u32) {\n        if let Some(world)=&mut self.world {world.attacks.retain(|a|a.source!=id || (a.ranged && a.releases<=self.tick));}\n    }\n    pub(crate) fn cancel_pet_attack(&mut self,id:u32) {')
edit('crates/core/src/annie_r.rs','u.health=0.;u.target=None;', 'u.health=0.;u.stuns.clear();u.target=None;')
edit('crates/core/src/annie_r.rs','   if u.position.distance(owner)>value("teleport_distance") {','   if stuns::unit_active(&u,self.tick) {continue;}\n   if u.position.distance(owner)>value("teleport_distance") {')
edit('crates/core/src/stuns.rs','pub fn allows_disabled(name:&str)', 'pub fn unit_active(p:&world::Unit,tick:u64)->bool {p.health>0. && p.stuns.iter().any(|s|s.expires_at>tick)}\npub fn allows_disabled(name:&str)')
old='  let p=self.players.get(&target).ok_or("champion stun target required")?;'
new='''  if !self.players.contains_key(&target) {
   let u=self.units.get(&target).ok_or("unknown stun target")?;
   if u.health<=0. {return Err("stun target dead".into());}
   if u.kind.structure() {return Err("structure stun unsupported".into());}
   if u.kind==world::Kind::Boss {return Err("boss stun policy not qualified".into());}
   let u=self.units.get_mut(&target).unwrap();u.stuns.retain(|s|s.tag!=tag&&s.expires_at>self.tick);u.stuns.push(Stun{tag:tag.into(),source,expires_at:self.tick.saturating_add(duration)});u.next_ai=self.tick;
   self.interrupt_unit_windup(target);return Ok(());
  }
  let p=self.players.get(&target).unwrap();'''
edit('crates/core/src/stuns.rs',old,new)
edit('crates/core/src/stuns.rs','self.record_champion_contribution(id,target);','if let Some(owner)=self.combat_owner(id) {self.record_champion_contribution(owner,target);}')
edit('crates/core/src/stuns.rs','pub(crate) fn advance_stuns(&mut self) {for p in self.players.values_mut() {p.stuns.retain(|s|p.health>0. && s.expires_at>self.tick);}}','pub(crate) fn advance_stuns(&mut self) {for p in self.players.values_mut() {p.stuns.retain(|s|p.health>0. && s.expires_at>self.tick);}for u in self.units.values_mut() {u.stuns.retain(|s|u.health>0. && s.expires_at>self.tick);}}')
edit('crates/client/src/animation.rs','                            u.destination.is_some(),','                            u.destination.is_some() && !openleague_core::stuns::unit_active(u,snapshot.tick),')
old='''                            false,
                            false,
                            if u.pet.as_ref()'''
new='''                            false,
                            openleague_core::stuns::unit_active(u,snapshot.tick),
                            if u.pet.as_ref()'''
edit('crates/client/src/animation.rs',old,new)
print('NPC/pet stun lifecycle, queued orders, windup vs released shots and visual idle gating integrated')
