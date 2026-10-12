//! Native summon values; explicitly reconstructed pet control/AI/cadence policies.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Pending {pub point:Point,pub releases:u64,pub rank:u8,pub raw:f32}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub enum Order {Follow,Move{point:Point},Attack{target:u32}}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Pet {pub owner:u32,pub rank:u8,pub spawned:u64,pub expires:u64,pub next_aura:u64,pub order:Order,pub molten_until:u64,pub molten_rank:u8}
pub fn value(key:&str)->f32 {
 static R:OnceLock<serde_json::Value>=OnceLock::new();
 R.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/annie_r_rules.json")).unwrap())[key].as_f64().unwrap() as f32
}
pub fn definition()->world::Definition {serde_json::from_str(include_str!("../../../data/4.20/tibbers_definition.json")).unwrap()}
pub fn defense(u:&world::Unit,tick:u64)->f32 {
 u.pet.as_ref().filter(|p|u.health>0.&&tick<p.molten_until&&(1..=5).contains(&p.molten_rank)).map(|p|annie::e_value(&format!("defense{}",p.molten_rank))).unwrap_or(0.)
}
impl Simulation {
 /// Attribution changes rewards only: a pet attack does not inherit owner penetration/life steal.
 pub(crate) fn combat_owner(&self,id:u32)->Option<u32> {
  if self.players.contains_key(&id) {Some(id)} else {self.units.get(&id)?.pet.as_ref().map(|p|p.owner).filter(|owner|self.players.contains_key(owner))}
 }
 pub fn tibbers(&self,owner:u32)->Option<u32> {
  self.units.values().find(|u|u.health>0.&&u.pet.as_ref().is_some_and(|p|p.owner==owner&&self.tick<p.expires)).map(|u|u.id)
 }
 pub(crate) fn cast_tibbers(&mut self,id:u32,point:Point)->Result<(),String> {
  if self.winner.is_some() {return Err("match ended".into());}
  let p=self.players.get(&id).ok_or("unknown player")?;
  if let Some(pet)=self.tibbers(id) {return self.guide_tibbers(id,pet,point);}
  if stuns::active(p,self.tick) {return Err("champion stunned".into());}
  if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
  let rank=p.ranks[3];if rank==0 {return Err("skill not learned".into());}
  if p.effects.annie_q.is_some()||p.effects.annie_w.is_some()||p.effects.annie_r.is_some() {return Err("skill blocked during cast".into());}
  if self.tick<p.cooldowns[3] {return Err("skill on cooldown".into());}
  if p.position.distance(point)>value("range") {return Err("spell point out of range".into());}
  if self.world.is_none() {return Err("world disabled".into());}
  if self.navigation.ground(point).is_none() {return Err("summon point blocked".into());}
  let cost=value(&format!("cost{rank}"));if p.mana<cost {return Err("insufficient mana".into());}
  let stats=self.stats(id);let raw=value(&format!("damage{rank}"))+value("coefficient")*stats.ability_power;let cd=cooldown::ticks(value(&format!("cooldown{rank}")),stats.cooldown_reduction);
  let p=self.players.get_mut(&id).unwrap();p.mana-=cost;p.cooldowns[3]=self.tick+cd;p.cooldown_totals[3]=Some(cd);p.windup=None;p.effects.annie_r=Some(Pending{point,releases:self.tick+spells::seconds(value("cast_seconds")),rank,raw});Ok(())
 }
 fn guide_tibbers(&mut self,owner:u32,pet:u32,point:Point)->Result<(),String> {
  let p=&self.players[&owner];
  // Guide has native CanCastWhileDisabled=true. Silence policy remains separately scoped.
  if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
  if p.position.distance(point)>value("guide_range") {return Err("pet point out of range".into());}
  let target=self.players.keys().chain(self.units.keys()).copied().filter_map(|id| {
   let t=self.target_info(id)?;let d=t.position.distance(point);
   (id!=pet&&t.team!=p.team&&t.health>0.&&!self.protected(id)&&d<=value("guide_pick_radius")&&self.visible_to(p.team,id)).then_some((id,d))
  }).min_by(|a,b|a.1.total_cmp(&b.1).then(a.0.cmp(&b.0))).map(|t|t.0);
  let order=if let Some(target)=target {Order::Attack{target}} else {
   self.navigation.path(self.units[&pet].position,point).ok_or("pet destination unreachable")?;
   Order::Move{point}
  };
  // Native TibbersBasicAttack permits cancelling a windup; keep attack recovery deadline.
  self.cancel_pet_attack(pet);
  let u=self.units.get_mut(&pet).unwrap();u.pet.as_mut().unwrap().order=order;u.next_ai=0;u.target=None;u.path.clear();u.destination=None;Ok(())
 }
 pub(crate) fn advance_annie_r(&mut self) {
  if self.winner.is_some() {return;}
  let mut casts=Vec::new();for p in self.players.values_mut() {
   if p.health<=0. {p.effects.annie_r=None;continue;}
   if p.effects.annie_r.as_ref().is_some_and(|r|self.tick>=r.releases) {casts.push((p.id,p.team,p.height,p.effects.annie_r.take().unwrap()));}
  }
  for (owner,team,height,r) in casts {
   let Ok(id)=self.spawn_unit("annietibbers","Tibbers",team,r.point,height,0.,None,None) else {continue};
   let u=self.units.get_mut(&id).unwrap();u.max_health=value(&format!("health{}",r.rank));u.health=u.max_health;u.damage=value(&format!("attack_damage{}",r.rank));u.armor=value(&format!("defense{}",r.rank));u.magic_resist=u.armor;
   u.pet=Some(Pet{owner,rank:r.rank,spawned:self.tick,expires:self.tick+spells::seconds(value(&format!("lifetime{}",r.rank))),next_aura:self.tick+spells::seconds(value("aura_seconds")),order:Order::Follow,molten_until:0,molten_rank:0});
   let stun=self.pyromania_spell(owner,true);
   for target in self.tibbers_area(team,r.point,value("radius")) {if self.apply_damage(Some(owner),target,r.raw,damage::DamageKind::Magical).is_ok() {self.pyromania_hit(owner,target,stun);}}
  }
 }
 fn tibbers_area(&self,team:u8,point:Point,radius:f32)->Vec<u32> {
  self.players.values().filter(|p|p.team!=team&&p.health>0.).map(|p|(p.id,p.position,annie_w::body_radius(collision::profile(&p.champion).gameplay_radius)))
   .chain(self.units.values().filter(|u|u.team!=team&&u.health>0.&&!u.kind.structure()).filter_map(|u|self.target_info(u.id).map(|t|(u.id,t.position,t.radius))))
   .filter(|(id,p,r)|!self.protected(*id)&&point.distance(*p)<=radius+*r).map(|(id,_,_)|id).collect()
 }
 /// Expiration runs before NPC attacks; no bounty or XP for natural expiry.
 pub(crate) fn advance_pet_orders(&mut self) {
  if self.winner.is_some() {return;}
  let ids:Vec<_>=self.units.values().filter(|u|u.health>0.&&u.pet.is_some()).map(|u|u.id).collect();
  for id in ids {
   let u=self.units[&id].clone();let pet=u.pet.as_ref().unwrap();
   if self.tick>=pet.expires||!self.players.contains_key(&pet.owner) {
    let u=self.units.get_mut(&id).unwrap();u.health=0.;u.stuns.clear();u.target=None;u.destination=None;u.path.clear();u.remove_at=Some(self.tick+3*TICK_RATE);self.cancel_pet_attack(id);continue;
   }
   let owner=self.players[&pet.owner].position;
   self.units.get_mut(&id).unwrap().health=(u.health+value("pet_regeneration")/TICK_RATE as f32).min(u.max_health);
   if stuns::unit_active(&u,self.tick) {continue;}
   if u.position.distance(owner)>value("teleport_distance") {
    if let Some(point)=self.navigation.nearest_walkable(owner) {self.cancel_pet_attack(id);let u=self.units.get_mut(&id).unwrap();u.position=point;u.height=self.navigation.ground(point).unwrap_or(u.height);u.pet.as_mut().unwrap().order=Order::Follow;u.target=None;u.path.clear();u.destination=None;u.next_ai=0;}
   }
   if self.tick<self.units[&id].next_ai {continue;}
   let u=self.units[&id].clone();let def=&self.world.as_ref().unwrap().config.definitions[&u.definition];
   let valid=|target:u32|self.target_info(target).filter(|t|t.health>0.&&t.team!=u.team&&!self.protected(target)&&self.visible_to(u.team,target));
   let mut order=u.pet.as_ref().unwrap().order.clone();let mut target=None;let mut goal=None;
   match order {
    Order::Attack{target:t}=>if let Some(ti)=valid(t) {target=Some(t);if u.position.distance(ti.position)>def.attack_range+ti.radius {goal=Some(ti.position);}} else {order=Order::Follow;},
    Order::Move{point}=>if u.position.distance(point)>5. {goal=Some(point);} else {order=Order::Follow;},
    Order::Follow=>{}
   }
   if matches!(order,Order::Follow) {
    target=u.target.filter(|t|valid(*t).is_some_and(|ti|u.position.distance(ti.position)<=def.attack_range+ti.radius));
    if target.is_none() {target=self.players.keys().chain(self.units.keys()).copied().filter(|t|*t!=id).filter_map(|t| {let ti=valid(t)?;let d=u.position.distance(ti.position);(d<=def.acquisition+ti.radius).then_some((t,d))}).min_by(|a,b|a.1.total_cmp(&b.1).then(a.0.cmp(&b.0))).map(|t|t.0);}
    if target.is_none()&&u.position.distance(owner)>value("return_radius") {goal=Some(owner);}
   }
   let path=goal.and_then(|point|self.navigation.path(u.position,point));
   let u=self.units.get_mut(&id).unwrap();u.pet.as_mut().unwrap().order=order;u.target=target;u.path=path.unwrap_or_default();u.destination=goal.filter(|_|!u.path.is_empty());u.next_ai=self.tick+8;
  }
 }
 pub(crate) fn advance_pet_aura(&mut self) {
  if self.winner.is_some() {return;}
  let pulses:Vec<_>=self.units.values().filter(|u|u.health>0.).filter_map(|u|u.pet.as_ref().filter(|p|self.tick<p.expires&&self.tick>=p.next_aura&&self.players.contains_key(&p.owner)).map(|p|(u.id,u.team,u.position,p.owner,p.rank))).collect();
  for (id,team,position,owner,rank) in pulses {
   self.units.get_mut(&id).unwrap().pet.as_mut().unwrap().next_aura=self.tick+spells::seconds(value("aura_seconds"));
   let raw=value(&format!("aura_damage{rank}"))+value("aura_coefficient")*self.stats(owner).ability_power;
   for target in self.tibbers_area(team,position,value("aura_radius")) {let _=self.apply_damage(Some(owner),target,raw,damage::DamageKind::Magical);}
  }
 }
 pub(crate) fn forward_molten_to_pet(&mut self,owner:u32,rank:u8,until:u64) {
  if let Some(id)=self.tibbers(owner) {let p=self.units.get_mut(&id).unwrap().pet.as_mut().unwrap();p.molten_rank=rank;p.molten_until=until;}
 }
 pub(crate) fn pet_molten_retaliation(&self,target:u32,attacker:u32)->Option<f32> {
  let u=self.units.get(&target)?;if defense(u,self.tick)==0. {return None;}
  let a=self.target_info(attacker)?;if a.health<=0.||a.team==u.team||self.units.get(&attacker).is_some_and(|u|u.kind.structure()) {return None;}
  let pet=u.pet.as_ref()?;Some(annie::e_value(&format!("return{}",pet.molten_rank))+annie::e_value("coefficient")*self.stats(pet.owner).ability_power)
 }
}

#[cfg(test)]
#[path="annie_r_tests.rs"]
mod tests;
