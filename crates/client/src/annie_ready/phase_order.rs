//! Deterministic host tie-breaking for colocated Ready quads.
//! Native particle ordering remains unqualified. No geometry/depth bias changes.
use bevy::{prelude::*,core_pipeline::core_3d::Transparent3d,render::{Render,RenderApp,RenderSystems,extract_component::ExtractComponentPlugin,render_phase::{ViewSortedRenderPhases,sort_phase_system}}};
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){
  app.add_plugins(ExtractComponentPlugin::<super::ReadyQuad>::default());
  app.sub_app_mut(RenderApp).add_systems(Render,stabilize.in_set(RenderSystems::PhaseSort).after(sort_phase_system::<Transparent3d>));
 }
}
fn stabilize(mut phases:ResMut<ViewSortedRenderPhases<Transparent3d>>,ready:Query<&bevy::render::sync_world::MainEntity,With<super::ReadyQuad>>){
 let ready_ids:std::collections::HashSet<_>=ready.iter().map(|entity|entity.id()).collect();
 for phase in phases.0.values_mut(){
  let mut groups=std::collections::BTreeMap::<u32,Vec<_>>::new();
  for (index,(key,item)) in phase.items.iter().enumerate(){
   if ready_ids.contains(&item.entity.1.id()) {groups.entry(item.distance.to_bits()).or_default().push((index,*key));}
  }
  for entries in groups.values(){
   if entries.len()<2 {continue;}
   let mut keys:Vec<_>=entries.iter().map(|(_,key)|*key).collect();keys.sort_by_key(|key|key.1.id().to_bits());
   for ((destination,_),key) in entries.iter().zip(keys){
    let source=phase.items.get_index_of(&key).expect("phase item retained");phase.items.swap_indices(*destination,source);
   }
  }
 }
}
