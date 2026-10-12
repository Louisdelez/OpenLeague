//! Effect registry using the existing native spatial ownership and tree contracts.
//! Stable local nonzero identities adapt native descriptor addresses.
use std::collections::BTreeMap;
use crate::{grass_object_registry::{self,Registry},grass_subdivision::{self,Tree},grass_tree_service::{self,Service}};
use openleague_core::{audio_emitter_camera_volume::Volume,entity_visibility_merge::{self,Object,Transition},entity_visibility_frame,spatial_visibility,spatial_visibility_query};
pub struct Effects {registry:Registry,tree:Tree,service:Service,active:BTreeMap<u32,usize>,previous:Vec<u32>}
impl Default for Effects {
 fn default()->Self {
  let mut tree=Tree{nodes:Vec::new(),midpoints:Vec::new(),depths:Vec::new(),queued:Vec::new(),queue:Vec::new(),pool:Vec::new(),pool_capacity:0,max_depth:0};
  let service=grass_tree_service::create(&mut tree).expect("native effect spatial defaults");
  Self{registry:Registry{objects:Vec::new(),recycled:Vec::new(),recycled_capacity:0},tree,service,active:BTreeMap::new(),previous:Vec::new()}
 }
}
impl Effects {
 /// Removal phase: unlink wrappers without emitting visibility callbacks.
 /// Their particle resources may remain alive independently.
 pub fn retain_wrappers(&mut self,identities:&[u32])->Result<(),&'static str> {
  let keep:std::collections::BTreeSet<_>=identities.iter().copied().collect();
  let removed=self.active.keys().filter(|id|!keep.contains(id)).copied().collect::<Vec<_>>();
  for id in removed {
   let index=self.active[&id];
   grass_object_registry::unregister(&mut self.registry,&mut self.tree,index)?;
   self.active.remove(&id);self.previous.retain(|previous|*previous!=id);
  }
  Ok(())
 }
 /// Caller supplies bounds exported by the Troy owner at the correct frame phase.
 pub fn synchronize(&mut self,observations:&[(u32,[f32;6])])->Result<(),&'static str> {
  let mut desired=BTreeMap::new();
  for (id,bounds) in observations {
   if *id==0 || bounds.iter().any(|v|!v.is_finite()) {return Err("invalid effect spatial observation");}
   if desired.insert(*id,*bounds).is_some(){return Err("duplicate effect spatial identity");}
  }
  let remove=self.active.keys().filter(|id|!desired.contains_key(id)).copied().collect::<Vec<_>>();
  for id in remove {
   let index=self.active[&id];grass_object_registry::unregister(&mut self.registry,&mut self.tree,index)?;self.active.remove(&id);
  }
  for (id,bounds) in desired {
   if let Some(index)=self.active.get(&id) {
    grass_object_registry::update_aabb(&mut self.registry,&mut self.tree,&self.service,*index,bounds,|_,_|{})?;
   } else {
    // Native71A470 registers the new wrapper through95EE90 with zero center
    // and zero extents. The later bounds callback updates this existing node.
    // Registering directly at the final bounds skips the native reindex path.
    let index=grass_object_registry::register(&mut self.registry,&mut self.tree,&self.service,u64::from(id),[0.;3],[0.;6],crate::grass_spatial_bounds::IntegerProfile::Sse,[0;4],|_,_|{})?;
    grass_object_registry::update_aabb(&mut self.registry,&mut self.tree,&self.service,index,bounds,|_,_|{})?;
    self.active.insert(id,index);
   }
  }
  let mut actors=self.registry.objects.iter().map(|object|grass_subdivision::Actor{bounds:object.indexed.integer_bounds,center_y:object.indexed.node.center[1],local_y:[object.indexed.local_bounds[1],object.indexed.local_bounds[4]],parent:object.parent}).collect::<Vec<_>>();
  let result=grass_subdivision::drain(&mut self.tree,&mut actors,|_|{});
  for (object,actor) in self.registry.objects.iter_mut().zip(actors){object.parent=actor.parent;object.indexed.node.parent_present=actor.parent.is_some();}
  result
 }
 // Explicit local adapter: a zero-area window has no selected effects.
 pub fn select_none(&mut self)->Result<Vec<Transition>,&'static str> {
  let mut events=Vec::new();
  entity_visibility_merge::process(&self.previous,&[],|id|self.active.contains_key(&id).then_some(Object{identity:id,active:1,type_flags:0x212}),|event|events.push(event))?;
  self.previous.clear();Ok(events)
 }
 pub fn select(&mut self,volume:&Volume)->Result<Vec<Transition>,&'static str> {
  let nodes=self.tree.nodes.iter().map(|node|{
   let records=node.members.iter().map(|member|{
    let index=usize::try_from(member.id).map_err(|_|"effect spatial member outside address range")?;
    let object=self.registry.objects.get(index).ok_or("missing effect spatial member")?;
    let identity=u32::try_from(object.owner).map_err(|_|"effect identity exceeds native width")?;
    if self.active.get(&identity)!=Some(&index){return Err("stale effect spatial member");}
    let local=object.indexed.local_bounds;
    Ok(spatial_visibility_query::Record{identity,position:object.indexed.node.center,minimum:[local[0],local[1],local[2]],maximum:[local[3],local[4],local[5]]})
   }).collect::<Result<Vec<_>,&'static str>>()?;
   Ok(spatial_visibility::Node{grid_bounds:node.bounds,heights:[node.vertical[0],node.vertical[1]],records,children:node.children})
  }).collect::<Result<Vec<_>,&'static str>>()?;
  let current=entity_visibility_frame::visible_handles(&nodes,self.service.root,volume,false)?;
  let mut events=Vec::new();
  entity_visibility_merge::process(&self.previous,&current,|id|self.active.contains_key(&id).then_some(Object{identity:id,active:1,type_flags:0x212}),|event|events.push(event))?;
  self.previous=current;Ok(events)
 }
}
#[cfg(test)]
mod tests {
 use super::*;use bevy::prelude::*;
 fn bounds(position:[f32;3])->[f32;6]{let b=openleague_core::native_troy_position_bounds::apply(position.map(f32::to_bits),250f32.to_bits());[b.minimum[0],b.minimum[1],b.minimum[2],b.maximum[0],b.maximum[1],b.maximum[2]].map(f32::from_bits)}
 #[test]
 fn effect_registry_tracks_motion_camera_exit_reentry_and_disposal(){
  let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();let volume=camera.culling_volume(16./9.).unwrap();
  let mut effects=Effects::default();let inside=bounds([7400.,0.,7700.]);let outside=bounds([-20000.,0.,-20000.]);
  effects.synchronize(&[(1,inside)]).unwrap();assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:1,active:true}]);
  assert!(effects.select(&volume).unwrap().is_empty());
  effects.synchronize(&[(1,outside)]).unwrap();assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:1,active:false}]);
  effects.synchronize(&[(1,inside)]).unwrap();assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:1,active:true}]);
  effects.synchronize(&[]).unwrap();assert!(effects.select(&volume).unwrap().is_empty());assert!(effects.active.is_empty());
  effects.synchronize(&[(2,inside)]).unwrap();assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:2,active:true}]);
 }
 #[test]
 fn retired_wrapper_cannot_receive_camera_callbacks_and_its_slot_can_be_reused() {
  let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();
  let volume=camera.culling_volume(16./9.).unwrap();let mut effects=Effects::default();let inside=bounds([7400.,0.,7700.]);
  effects.synchronize(&[(1,inside),(2,inside)]).unwrap();assert_eq!(effects.select(&volume).unwrap().len(),2);
  let retired_index=effects.active[&1];effects.retain_wrappers(&[2]).unwrap();
  assert!(!effects.active.contains_key(&1));assert!(!effects.previous.contains(&1));
  assert_eq!(effects.select_none().unwrap(),vec![Transition{identity:2,active:false}]);
  effects.synchronize(&[(2,inside),(3,inside)]).unwrap();assert_eq!(effects.active[&3],retired_index);
  assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:2,active:true},Transition{identity:3,active:true}]);
 }
 #[test]
 fn minimized_selection_deactivates_once_and_restores_existing_identity() {
  let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();
  let volume=camera.culling_volume(16./9.).unwrap();let mut effects=Effects::default();
  effects.synchronize(&[(7,bounds([7400.,0.,7700.]))]).unwrap();
  assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:7,active:true}]);
  let index=effects.active[&7];
  assert_eq!(effects.select_none().unwrap(),vec![Transition{identity:7,active:false}]);
  assert!(effects.select_none().unwrap().is_empty());assert_eq!(effects.active[&7],index);
  assert_eq!(effects.select(&volume).unwrap(),vec![Transition{identity:7,active:true}]);
  effects.synchronize(&[]).unwrap();assert!(effects.select_none().unwrap().is_empty());
 }
 #[test]
 fn effect_registry_preserves_members_through_subdivision_and_removal(){
  let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();let volume=camera.culling_volume(16./9.).unwrap();
  let mut effects=Effects::default();let observations=(1..=80).map(|id|(id,bounds([7300.+id as f32,0.,7700.]))).collect::<Vec<_>>();
  effects.synchronize(&observations).unwrap();let events=effects.select(&volume).unwrap();assert_eq!(events.len(),80);assert!(events.iter().all(|e|e.active));
  effects.synchronize(&observations[40..]).unwrap();assert!(effects.select(&volume).unwrap().is_empty());assert_eq!(effects.active.len(),40);
  assert!(effects.synchronize(&[(0,bounds([0.;3]))]).is_err());assert_eq!(effects.active.len(),40);
 }
}
