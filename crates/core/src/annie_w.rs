//! Native Incinerate numbers; reconstructed cast sequencing and circle-sector contact.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Pending {pub direction:Point,pub releases:u64,pub raw:f32}
pub fn value(key:&str)->f32 {
 static DATA:OnceLock<serde_json::Value>=OnceLock::new();
 DATA.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/annie_w_rules.json")).unwrap())[key].as_f64().unwrap() as f32
}
/// Closed circle intersects a finite cone sector. Direction is a unit vector.
/// Geometry is reconstructed; no equivalence to Riot's missing server code implied.
pub fn intersects(origin:Point,direction:Point,center:Point,radius:f32,range:f32,half_angle:f32)->bool {
 if !origin.finite() || !direction.finite() || !center.finite() || !radius.is_finite() || radius<0. || !range.is_finite() || range<=0. || !half_angle.is_finite() || half_angle<=0. || half_angle>=90. {return false;}
 let norm=direction.x.hypot(direction.z);if !norm.is_finite() || (norm-1.).abs()>0.00001 {return false;}
 let x=center.x-origin.x;let z=center.z-origin.z;let d=x.hypot(z);if !d.is_finite() {return false;}
 if d<=radius {return true;}
 if d>range+radius {return false;}
 let angle=half_angle.to_radians();let(c,s)=(angle.cos(),angle.sin());
 let dot=x*direction.x+z*direction.z;
 if dot>=d*c {return (d-range).max(0.)<=radius;}
 [-1.,1.].into_iter().any(|sign| {
  let dx=direction.x*c-sign*direction.z*s;let dz=direction.z*c+sign*direction.x*s;
  let projection=(x*dx+z*dz).clamp(0.,range);
  (x-projection*dx).hypot(z-projection*dz)<=radius+0.0001
 })
}
pub(crate) use crate::collision::body_radius;
impl Simulation {
 pub fn cast_at(&mut self,id:u32,slot:u8,point:Point)->Result<(),String> {
  if self.winner.is_some() {return Err("match ended".into());}
  if slot>3 {return Err("invalid skill slot".into());}
  if !point.finite() {return Err("invalid spell point".into());}
  let p=self.players.get(&id).ok_or("unknown player")?;
  if trundle_e::champion_forced(p,self.tick) {return Err("champion in forced movement".into());}
  if p.health<=0. {return Err("champion dead".into());}
  if p.champion=="trundle" && slot==1 {return self.cast_trundle_w_at(id,point);}
  if p.champion=="trundle" && slot==2 {return self.cast_trundle_e_at(id,point);}
  if p.champion=="annie" && slot==3 {return self.cast_tibbers(id,point);}
  if stuns::active(p,self.tick) {return Err("champion stunned".into());}
  if p.champion!="annie" || slot!=1 {return Err("champion ground spell not implemented".into());}
  let rank=p.ranks[1];if rank==0 {return Err("skill not learned".into());}
  if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
  if p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.effects.annie_r.is_some() {return Err("skill blocked during cast".into());}
  if self.tick<p.cooldowns[1] {return Err("skill on cooldown".into());}
  let x=point.x-p.position.x;let z=point.z-p.position.z;let length=x.hypot(z);
  if !length.is_finite() || length<=0. {return Err("spell direction undefined".into());}
  let direction=Point{x:x/length,z:z/length};let cost=value(&format!("cost{rank}"));
  if p.mana<cost {return Err("insufficient mana".into());}
  let stats=self.stats(id);let raw=value(&format!("damage{rank}"))+stats.ability_power*value("coefficient");let cd=cooldown::ticks(value("cooldown"),stats.cooldown_reduction);
  // Only a validated initial cast closes the current presentation identity.
  self.cancel_attack_presentation(id,attack_presentation::CancelReason::OtherCast);
  let p=self.players.get_mut(&id).unwrap();p.mana-=cost;p.cooldowns[1]=self.tick+cd;p.cooldown_totals[1]=Some(cd);p.windup=None;
  p.effects.annie_w=Some(Pending{direction,releases:self.tick+spells::seconds(value("cast_seconds")),raw});Ok(())
 }
 pub(crate) fn advance_annie_w(&mut self) {
  if self.winner.is_some() {return;}
  let mut casts=Vec::new();
  for p in self.players.values_mut() {
   if p.health<=0. {p.effects.annie_w=None;continue;}
   if p.effects.annie_w.as_ref().is_some_and(|w|self.tick>=w.releases) {casts.push((p.id,p.team,p.position,p.effects.annie_w.take().unwrap()));}
  }
  for(id,team,origin,w) in casts {
   let stun=self.pyromania_spell(id,true);
   let targets:Vec<_>=self.players.values().filter(|p|p.team!=team&&p.health>0.).map(|p| {
    // Missing native radius remains absent in profiles. Community CharData
    // loads absent values as65; ObjAIBase uses40 only for nonpositive values.
    // This cone policy is reconstructed, not recovered Riot server behavior.
    (p.id,p.position,body_radius(collision::profile(&p.champion).gameplay_radius))
   }).chain(self.units.values().filter(|u|u.team!=team&&u.health>0.&&!u.kind.structure()).filter_map(|u|self.target_info(u.id).map(|i|(u.id,i.position,i.radius))))
   .filter(|(target,p,r)|!self.protected(*target)&&intersects(origin,w.direction,*p,*r,value("range"),value("half_angle"))).map(|(id,_,_)|id).collect();
   for target in targets {if self.apply_damage(Some(id),target,w.raw,damage::DamageKind::Magical).is_ok() {self.pyromania_hit(id,target,stun);}}
  }
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn game()->(Simulation,u32,u32) {
  let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
  let mut s=Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap()).unwrap();let a=s.join("annie").unwrap();let b=s.join("garen").unwrap();s.players.get_mut(&a).unwrap().position=Point{x:100.,z:100.};s.players.get_mut(&b).unwrap().position=Point{x:500.,z:100.};s.learn(a,1).unwrap();(s,a,b)
 }
 fn aim()->Point {Point{x:900.,z:100.}}
 #[test] fn closed_cone_circle_boundaries_cap_and_rotations() {
  for theta in [0f32,90.,180.,270.] {
   let rad=theta.to_radians();let origin=Point{x:10.,z:20.};let dir=Point{x:rad.cos(),z:rad.sin()};
   let point=|d:f32,a:f32|Point{x:origin.x+d*(rad+a.to_radians()).cos(),z:origin.z+d*(rad+a.to_radians()).sin()};
   assert!(intersects(origin,dir,point(500.,24.75),0.,625.,24.76));assert!(!intersects(origin,dir,point(500.,24.77),0.,625.,24.76));
   assert!(intersects(origin,dir,point(500.,28.),40.,625.,24.76));assert!(!intersects(origin,dir,point(500.,30.),40.,625.,24.76));
   assert!(intersects(origin,dir,point(664.,0.),40.,625.,24.76));assert!(!intersects(origin,dir,point(666.,0.),40.,625.,24.76));
   assert!(intersects(origin,dir,origin,0.,625.,24.76));assert!(!intersects(origin,dir,point(100.,180.),0.,625.,24.76));
  }
 }
 #[test] fn community_radius_default_affects_cone_contact_without_mutating_native_profiles() {
  assert_eq!(body_radius(None),65.);assert_eq!(body_radius(Some(0.)),40.);assert_eq!(body_radius(Some(-1.)),40.);assert_eq!(body_radius(Some(55.)),55.);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  assert_eq!(collision::profile("annie").gameplay_radius,Some(55.));
  let(mut s,a,b)=game();let enemy_annie=s.join("annie").unwrap();
  // Fourth join is enemy team1; third join above is allied and not used.
  let enemy_annie2=s.join("annie").unwrap();assert_ne!(s.players[&a].team,s.players[&enemy_annie2].team);
  let angle=(value("half_angle")+7.).to_radians();let center=Point{x:100.+500.*angle.cos(),z:100.+500.*angle.sin()};
  s.players.get_mut(&b).unwrap().position=center;s.players.get_mut(&enemy_annie2).unwrap().position=center;
  let garen_hp=s.players[&b].health;let annie_hp=s.players[&enemy_annie2].health;
  assert!(!intersects(s.players[&a].position,Point{x:1.,z:0.},center,40.,625.,value("half_angle")));
  s.cast_at(a,1,aim()).unwrap();s.tick=8;s.advance_annie_w();
  assert!(s.players[&b].health<garen_hp);assert_eq!(s.players[&enemy_annie2].health,annie_hp);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  assert_eq!(s.players[&enemy_annie].team,s.players[&a].team);
 }
 #[test] fn invalid_geometry_and_ground_cast_guards_are_atomic() {
  let(mut s,a,b)=game();let mana=s.players[&a].mana;for point in [s.players[&a].position,Point{x:f32::NAN,z:0.},Point{x:f32::INFINITY,z:0.}] {assert!(s.cast_at(a,1,point).is_err());assert_eq!(s.players[&a].mana,mana);assert_eq!(s.players[&a].cooldowns[1],0);assert!(s.players[&a].effects.annie_w.is_none());}
  assert!(s.cast_at(b,1,aim()).is_err());assert!(s.cast_at(a,4,aim()).is_err());assert!(s.cast_at(999,1,aim()).is_err());
  s.players.get_mut(&a).unwrap().mana=69.;assert_eq!(s.cast_at(a,1,aim()).unwrap_err(),"insufficient mana");assert_eq!(s.players[&a].mana,69.);
  s.players.get_mut(&a).unwrap().effects.silence_until=10;assert_eq!(s.cast_at(a,1,aim()).unwrap_err(),"champion silenced");
  assert!(!intersects(Point{x:0.,z:0.},Point{x:0.,z:0.},Point{x:1.,z:0.},1.,625.,24.76));
 }
 #[test] fn all_native_rank_costs_damage_ap_and_cooldown_with_eight_tick_cast() {
  for rank in 1..=5 {
   let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().ranks[1]=rank;s.players.get_mut(&a).unwrap().inventory[0]=Some(1052);s.players.get_mut(&a).unwrap().mana=500.;let hp=s.players[&b].health;
   s.cast_at(a,1,aim()).unwrap();assert_eq!(s.players[&a].mana,500.-(60.+10.*rank as f32));assert_eq!(s.players[&a].cooldowns[1],240);
   for tick in 1..8 {s.tick=tick;s.advance_annie_w();assert_eq!(s.players[&b].health,hp);}
   s.tick=8;s.advance_annie_w();let raw=25.+45.*rank as f32+20.*0.85;assert!((hp-s.players[&b].health-raw*100./(100.+s.stats(b).magic_resist)).abs()<0.001);assert!(s.players[&a].effects.annie_w.is_none());let hp=s.players[&b].health;s.tick=9;s.advance_annie_w();assert_eq!(s.players[&b].health,hp);
  }
 }
 #[test] fn cone_hits_current_positions_once_and_excludes_allies() {
  let(mut s,a,b)=game();let ally=s.join("annie").unwrap();s.players.get_mut(&ally).unwrap().position=Point{x:400.,z:100.};let hp=s.players[&b].health;let ally_hp=s.players[&ally].health;s.cast_at(a,1,aim()).unwrap();s.players.get_mut(&b).unwrap().position=Point{x:100.,z:600.};s.tick=8;s.advance_annie_w();assert_eq!(s.players[&b].health,hp);assert_eq!(s.players[&ally].health,ally_hp);
  s.tick=240;s.cast_at(a,1,aim()).unwrap();s.players.get_mut(&b).unwrap().position=Point{x:500.,z:100.};s.tick=248;s.advance_annie_w();assert!(s.players[&b].health<hp);assert_eq!(s.players[&ally].health,ally_hp);
 }
 #[test] fn committed_w_freezes_movement_and_survives_later_stun_stop_and_move_orders() {
  let(mut s,a,b)=game();s.command(a,Action::Move{point:Point{x:300.,z:100.}}).unwrap();s.cast_at(a,1,aim()).unwrap();let origin=s.players[&a].position;s.advance();assert_eq!(s.players[&a].position,origin);s.command(a,Action::Stop).unwrap();assert!(s.players[&a].effects.annie_w.is_some());s.grant_stun(Some(b),a,"test",30).unwrap();for _ in 0..7 {s.advance();}assert!(s.players[&a].effects.annie_w.is_none());assert!(s.players[&b].health<s.players[&b].max_health);
 }
 #[test] fn q_w_are_mutually_exclusive_but_instant_e_does_not_cancel_w() {
  let(mut s,a,b)=game();let p=s.players.get_mut(&a).unwrap();p.level=3;s.learn(a,0).unwrap();s.learn(a,2).unwrap();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.cast_at(a,1,aim()).unwrap();assert_eq!(s.players[&a].cooldowns[1],216);assert_eq!(s.cast(a,0,Some(b)).unwrap_err(),"skill blocked during cast");s.cast(a,2,None).unwrap();assert!(s.players[&a].effects.annie_w.is_some());s.tick=8;s.advance_annie_w();s.cast(a,0,Some(b)).unwrap();assert_eq!(s.cast_at(a,1,aim()).unwrap_err(),"skill blocked during cast");
 }
 #[test] fn world_monster_is_hit_but_tower_is_excluded_and_death_cancels_pending_w() {
  let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=Simulation::new(nav).unwrap();s.enable_map10().unwrap();let a=s.join("annie").unwrap();s.learn(a,1).unwrap();s.tick=3300;s.advance_world();let monster=s.units.values().find(|u|u.kind==world::Kind::Monster).unwrap().id;let turret=s.units.values().find(|u|u.kind==world::Kind::Turret&&u.team!=s.players[&a].team).unwrap().id;let point=s.units[&monster].position;s.units.get_mut(&turret).unwrap().position=point;s.players.get_mut(&a).unwrap().position=Point{x:point.x-100.,z:point.z};let hp=s.units[&monster].health;let tower_hp=s.units[&turret].health;s.cast_at(a,1,point).unwrap();s.tick+=8;s.advance_annie_w();assert!(s.units[&monster].health<hp);assert_eq!(s.units[&turret].health,tower_hp);
  s.tick+=240;s.cast_at(a,1,point).unwrap();s.apply_damage(Some(monster),a,10000.,damage::DamageKind::True).unwrap();assert!(s.players[&a].effects.annie_w.is_none());let hp=s.units[&monster].health;s.tick+=8;s.advance_annie_w();assert_eq!(s.units[&monster].health,hp);
 }
}
