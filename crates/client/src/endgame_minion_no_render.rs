//! Native Lua SetMinionsNoRender(team_loser,true) final ceremony consumer.
//! Fade interpolation is deliberately unresolved. Local Kind::lane identifies
//! ordinary wave minions; the native actor-class population is not qualified.
use bevy::prelude::*;
use std::collections::{HashMap,HashSet};

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
struct Binding {session:u64,ended_tick:u64,network:u32,root:Entity,model:bevy::asset::AssetId<Gltf>}
#[derive(Component,Clone,Copy,Debug,PartialEq,Eq)]
struct Suppressed(Binding);
struct Entry {binding:Binding,previous:Visibility}
#[derive(Resource,Default)]
pub struct Host {entries:HashMap<Entity,Entry>,pub issues:Vec<String>}
fn same_actor(world:&World,binding:Binding)->bool {
 world.get::<crate::animation::Playback>(binding.root).is_some_and(|p|p.network_id()==binding.network&&p.model_asset_id()==binding.model)
  &&world.get::<crate::actor_fow::Root>(binding.root).is_some()&&world.get::<ChildOf>(binding.root).is_none()
}
fn retire(world:&mut World,entry:Entry){
 if world.get::<Suppressed>(entry.binding.root)!=Some(&Suppressed(entry.binding)){return;}
 if same_actor(world,entry.binding)&&world.get::<Visibility>(entry.binding.root)==Some(&Visibility::Hidden){
  world.entity_mut(entry.binding.root).insert(entry.previous);
 }
 if let Ok(mut root)=world.get_entity_mut(entry.binding.root){root.remove::<Suppressed>();}
}
/// Runs after all Update model/visibility producers and before visibility inheritance.
pub fn synchronize(world:&mut World){
 let mut host=world.remove_resource::<Host>().unwrap_or_default();host.issues.clear();
 let mut desired=HashMap::new();let mut roots=HashSet::new();
 let result=(||->Result<(),String>{
  let Some(identity)=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity)else{return Ok(());};
  let Some(snapshot)=world.get_resource::<crate::Match>().and_then(|m|m.snapshot.as_ref())else{return Ok(());};
  let Some(result)=snapshot.result.as_ref()else{return Ok(());};
  if result.winner>1||snapshot.session!=identity.0||result.session!=identity.0||snapshot.winner!=Some(result.winner)
   ||!result.players.iter().any(|p|p.id==identity.1){return Ok(());}
  let now=world.get_resource::<Time>().ok_or("endgame minion clock unavailable")?.elapsed_secs_f64();
  let clock=world.get_resource::<crate::endgame_timeline::Clock>().ok_or("endgame timeline unavailable")?;
  if !clock.skin_due_for(result,now)||!clock.age(now).is_some_and(|age|age>=crate::endgame_timeline::schedule().skin+crate::endgame_timeline::schedule().minion_fade){return Ok(());}
  let state=world.resource::<crate::Match>();
  for unit in snapshot.units.iter().filter(|u|u.kind.lane()&&u.team==1-result.winner){
   let Some(&root)=state.visuals.get(&unit.id)else{continue;};
   let Some(playback)=world.get::<crate::animation::Playback>(root)else{continue;};
   if playback.network_id()!=unit.id||!playback.model_name().eq_ignore_ascii_case(&unit.definition)
    ||world.get::<crate::actor_fow::Root>(root).is_none()||world.get::<ChildOf>(root).is_some(){host.issues.push(format!("endgame minion {} root/model mismatch",unit.id));continue;}
   if world.get::<Visibility>(root).is_none(){continue;}
   if !roots.insert(root){return Err("multiple minion identities use the same render root".into());}
   desired.insert(root,Binding{session:result.session,ended_tick:result.ended_tick,network:unit.id,root,model:playback.model_asset_id()});
  }
  Ok(())
 })();
 if let Err(error)=result{host.issues.push(error);desired.clear();}
 let old:Vec<_>=host.entries.keys().copied().filter(|root|desired.get(root)!=host.entries.get(root).map(|entry|&entry.binding)).collect();
 for root in old{if let Some(entry)=host.entries.remove(&root){retire(world,entry);}}
 for (root,binding) in desired{
  if !host.entries.contains_key(&root){
   let previous=*world.get::<Visibility>(root).expect("desired loaded root visibility");
   host.entries.insert(root,Entry{binding,previous});world.entity_mut(root).insert(Suppressed(binding));
  }
  // Reassert each final PostUpdate pass, after model loading may restore Inherited.
  if same_actor(world,binding)&&world.get::<Suppressed>(root)==Some(&Suppressed(binding)){
   world.entity_mut(root).insert(Visibility::Hidden);
  }
 }
 world.insert_resource(host);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){app.init_resource::<Host>().add_systems(PostUpdate,synchronize
  .after(bevy::transform::TransformSystems::Propagate)
  .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}
}

#[cfg(test)]
#[path="endgame_minion_no_render_tests.rs"]mod tests;
