//! Original default EndOfGame: SetHQCurrentSkin after3.5s; death-animation flag defaults false.
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
 let destroyed=clock.skin_due_for(result,time.elapsed_secs_f64());
 let id=nexus.id;
 if state.visuals.contains_key(&id) && state.destroyed_structures.get(&id)==Some(&destroyed) {return;}
 // This definition/pose is supplied by the server's unfiltered frozen result for the ceremony.
 if nexus.definition.is_empty() {return;}
 let name=if destroyed {format!("{}_destroyed",nexus.definition)} else {nexus.definition.clone()};
 let (request,scale)=animation::request(id,&name,&catalog,&assets);
 let transform=Transform::from_translation(Vec3::from_array(nexus.position)/20.).with_rotation(Quat::from_rotation_y(nexus.facing)).with_scale(Vec3::splat(scale*0.05));
 if let Some(entity)=state.visuals.remove(&id) {commands.entity(entity).despawn();}
 let entity=commands.spawn((transform,request)).id();
 state.visuals.insert(id,entity);state.destroyed_structures.insert(id,destroyed);
}
#[cfg(test)] mod tests {
 use super::*;
 fn fixture()->(openleague_core::Snapshot,u32) {
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();
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
  let (mut snapshot,id)=fixture();let tick=snapshot.tick;snapshot.units.retain(|u|u.id!=id);
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
 #[test] fn absent_fog_actor_is_created_from_frozen_server_definition_and_pose() {
  let (mut snapshot,id)=fixture();let nexus=snapshot.result.as_ref().unwrap().destroyed_nexus.as_ref().unwrap().clone();snapshot.units.retain(|u|u.id!=id);
  let mut app=App::new();app.add_plugins((MinimalPlugins,bevy::asset::AssetPlugin::default())).init_asset::<Gltf>().init_resource::<animation::Catalog>().init_resource::<Match>().init_resource::<endgame_timeline::Clock>().add_systems(Update,(endgame_timeline::update,update).chain());
  app.world_mut().resource_mut::<Match>().snapshot=Some(snapshot);app.update();
  let state=app.world().resource::<Match>();let entity=state.visuals[&id];assert!(!state.destroyed_structures[&id]);
  let transform=app.world().get::<Transform>(entity).unwrap();assert_eq!(transform.translation,Vec3::from_array(nexus.position)/20.);assert_eq!(transform.rotation,Quat::from_rotation_y(nexus.facing));assert!(app.world().get::<animation::ModelRequest>(entity).is_some());
  app.update();assert_eq!(app.world().resource::<Match>().visuals[&id],entity);
 }

}

/// Readonly, explicitly enabled diagnostic of the live root and loaded GLTF model.
pub fn probe(state:Res<Match>,clock:Res<endgame_timeline::Clock>,time:Res<Time>,pan:Res<crate::camera_native::EndPan>,camera:Res<crate::camera_native::NativeCamera>,roots:Query<&animation::Playback>,mut previous:Local<f64>) {
 let Ok(path)=std::env::var("OPENLEAGUE_NEXUS_SKIN_PROBE") else{return};
 let now=time.elapsed_secs_f64();if now-*previous<0.1{return;}*previous=now;
 let Some(result)=state.snapshot.as_ref().and_then(|s|s.result.as_ref()) else{return};
 let Some(nexus)=result.destroyed_nexus.as_ref() else{return};
 let entity=state.visuals.get(&nexus.id).copied();
 let row=serde_json::json!({"pan_initial":pan.initial,"pan_started":pan.started,"pan_now":time.elapsed_secs(),"pan_target":pan.pan.as_ref().map(|_|nexus.position),"pan_current":pan.pan.as_ref().map(|p|p.current),"pan_finished":pan.pan.as_ref().map(|p|p.finished),"native_render_focus":camera.native_focus(),"age":clock.age(now),"now":now,"id":nexus.id,"destroyed":state.destroyed_structures.get(&nexus.id),"entity":entity.map(|e|format!("{e:?}")),"loaded_model":entity.and_then(|e|roots.get(e).ok()).map(|p|p.model_name()),"tick":state.snapshot.as_ref().map(|s|s.tick)});
 use std::io::Write;if let Ok(mut f)=std::fs::OpenOptions::new().create(true).append(true).open(path){let _=writeln!(f,"{row}");}
}
