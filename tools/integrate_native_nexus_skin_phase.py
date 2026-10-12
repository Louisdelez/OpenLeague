from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/endgame_timeline.rs';s=p.read_text(encoding='utf-8')
needle=' pub fn scoreboard_due(&self,now:f64)->bool'
assert needle in s and 'skin_due_for' not in s
s=s.replace(needle,' pub fn skin_due_for(&self,result:&openleague_core::match_results::MatchResult,now:f64)->bool {self.key==Some((result.session,result.ended_tick)) && self.age(now).is_some_and(|age|age>=schedule().skin)}\n'+needle)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod nexus_ceremony;' not in s
s='mod nexus_ceremony;\n'+s
needle='    catalog: Res<animation::Catalog>,\n) {';assert s.count(needle)==1
s=s.replace(needle,'    catalog: Res<animation::Catalog>,\n    clock: Res<endgame_timeline::Clock>,\n    time: Res<Time>,\n) {')
s=s.replace('let destroyed = unit.kind.structure() && unit.health <= 0.;','let destroyed = nexus_ceremony::destroyed(unit, snapshot.result.as_ref(), &clock, time.elapsed_secs_f64());')
needle='        .add_systems(Update, endgame_timeline::update.after(receive).before(camera).before(native_endgame_ui::update))';assert needle in s
s=s.replace(needle,needle+'\n        .add_systems(Update, nexus_ceremony::update.after(endgame_timeline::update).before(animation::load_models).before(animation::animate))')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/animation.rs';s=p.read_text(encoding='utf-8')
needle='let role = if health <= 0. {';assert s.count(needle)==1
s=s.replace(needle,'let role = if crate::nexus_ceremony::holds_default_idle(actor.playback.id,snapshot.result.as_ref()) {\n            "idle"\n        } else if health <= 0. {')
p.write_text(s,encoding='utf-8')
module=r'''//! Original default EndOfGame: SetHQCurrentSkin after3.5s; death-animation flag defaults false.
use bevy::prelude::*;
use openleague_core::{match_results::MatchResult,world::{Unit,Kind}};
use crate::{Match,animation,endgame_timeline};
pub fn holds_default_idle(id:u32,result:Option<&MatchResult>)->bool {
 result.and_then(|r|r.destroyed_nexus.as_ref()).is_some_and(|n|n.id==id)
}
pub fn destroyed(unit:&Unit,result:Option<&MatchResult>,clock:&endgame_timeline::Clock,now:f64)->bool {
 if unit.kind==Kind::Nexus && holds_default_idle(unit.id,result) {
  return result.is_some_and(|result|clock.skin_due_for(result,now));
 }
 unit.kind.structure() && unit.health<=0.
}
/// Runs on the phase clock even when the final network tick never changes.
pub fn update(mut state:ResMut<Match>,clock:Res<endgame_timeline::Clock>,time:Res<Time>,assets:Res<AssetServer>,catalog:Res<animation::Catalog>,mut commands:Commands) {
 let Some(snapshot)=state.snapshot.as_ref() else{return};
 let Some(result)=snapshot.result.as_ref() else{return};
 let Some(nexus)=result.destroyed_nexus.as_ref() else{return};
 if !clock.skin_due_for(result,time.elapsed_secs_f64()) || state.destroyed_structures.get(&nexus.id)==Some(&true) {return;}
 // Model definition comes from the verified actor; absent fog-filtered resources remain unresolved.
 let Some(unit)=snapshot.units.iter().find(|u|u.id==nexus.id && u.kind==Kind::Nexus) else{return};
 let name=format!("{}_destroyed",unit.definition);
 let (request,scale)=animation::request(unit.id,&name,&catalog,&assets);
 let id=unit.id;
 let transform=Transform::from_xyz(unit.position.x/20.,unit.height/20.,unit.position.z/20.).with_rotation(Quat::from_rotation_y(unit.facing)).with_scale(Vec3::splat(scale*0.05));
 if let Some(entity)=state.visuals.remove(&id) {commands.entity(entity).despawn();}
 let entity=commands.spawn((transform,request)).id();
 state.visuals.insert(id,entity);state.destroyed_structures.insert(id,true);
}
#[cfg(test)] mod tests {
 use super::*;
 fn fixture()->(openleague_core::world::Snapshot,u32) {
  let mut simulation=openleague_core::world::Simulation::new();
  simulation.winner=Some(0);simulation.advance();
  let snapshot=simulation.snapshot();let id=snapshot.result.as_ref().unwrap().destroyed_nexus.as_ref().unwrap().id;
  (snapshot,id)
 }
 #[test] fn nexus_waits_for_original_skin_deadline_and_other_buildings_do_not() {
  let (snapshot,id)=fixture();let result=snapshot.result.as_ref().unwrap();
  let mut app=App::new();app.init_resource::<Match>().init_resource::<Time>().init_resource::<endgame_timeline::Clock>().add_systems(Update,endgame_timeline::update);
  app.world_mut().resource_mut::<Match>().snapshot=Some(snapshot.clone());app.update();
  let clock=app.world().resource::<endgame_timeline::Clock>();let mut unit=snapshot.units.iter().find(|u|u.id==id).unwrap().clone();unit.health=0.;
  assert!(!destroyed(&unit,Some(result),clock,3.499999));assert!(destroyed(&unit,Some(result),clock,3.5));
  let mut another=result.clone();another.session+=1;assert!(!destroyed(&unit,Some(&another),clock,100.));
  assert!(holds_default_idle(id,Some(result)));assert!(!holds_default_idle(id+1,Some(result)));
  assert!(destroyed(&unit,None,clock,0.));
  let mut tower=snapshot.units.iter().find(|u|u.kind.structure()&&u.kind!=Kind::Nexus).unwrap().clone();tower.health=0.;assert!(destroyed(&tower,Some(result),clock,0.));
 }
 #[test] fn frozen_tick_still_swaps_the_actual_nexus_entity_once_at_deadline() {
  let (snapshot,id)=fixture();let tick=snapshot.tick;
  let mut app=App::new();app.add_plugins((MinimalPlugins,bevy::asset::AssetPlugin::default())).init_asset::<Gltf>().init_resource::<animation::Catalog>().init_resource::<Match>().init_resource::<endgame_timeline::Clock>().add_systems(Update,(endgame_timeline::update,update).chain());
  let entity=app.world_mut().spawn(Transform::default()).id();
  {let mut state=app.world_mut().resource_mut::<Match>();state.snapshot=Some(snapshot);state.visuals.insert(id,entity);state.destroyed_structures.insert(id,false);}
  app.update();assert!(app.world().get_entity(entity).is_ok());
  // Use manual clock; the simulation snapshot and tick are unchanged throughout.
  app.world_mut().insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs_f64(3.499)));
  app.world_mut().resource_mut::<Time<Virtual>>().set_max_delta(std::time::Duration::from_secs(10));
  app.update();assert!(app.world().get_entity(entity).is_ok());
  app.world_mut().insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_millis(2)));app.update();
  let state=app.world().resource::<Match>();let replacement=state.visuals[&id];assert_ne!(replacement,entity);assert_eq!(state.destroyed_structures[&id],true);assert_eq!(state.snapshot.as_ref().unwrap().tick,tick);
  assert!(app.world().get_entity(entity).is_err());assert!(app.world().get::<animation::ModelRequest>(replacement).is_some());
  app.update();assert_eq!(app.world().resource::<Match>().visuals[&id],replacement);
 }
}
'''
assert not (r/'crates/client/src/nexus_ceremony.rs').exists();(r/'crates/client/src/nexus_ceremony.rs').write_text(module,encoding='utf-8')
print('Native default nexus phase consumer integrated; qualification pending')
