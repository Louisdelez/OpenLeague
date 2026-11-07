//! Read-only future ordinary probe. Does not leave a session, retire an owner,
//! hide a draw, remove assets, reset the clock, or change render admission.
//! Exact old Entity generations and typed AssetIds are retained from real tickets.
use bevy::prelude::*;
use crate::{spawn_mist_live::{Backend,SourceRoot,Ticket,ReadyAnswers},spawn_mist_state::{Binding,State},spawn_mist_material::MistMaterial};

#[derive(Clone)]
struct Previous{binding:Binding,tickets:Vec<Ticket>,published_frames:u64,ordinal:u64,presence:serde_json::Value}
#[derive(Resource,Default)]
struct Journal{previous:Option<Previous>,last_sample:Option<u64>,completed:usize,stopped:bool}

pub struct Plugin;
impl bevy::app::Plugin for Plugin{
 fn build(&self,app:&mut App){app.init_resource::<Journal>().add_systems(PostUpdate,observe.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));}
}
fn observe(world:&mut World){
 let Ok(path)=std::env::var("OPENLEAGUE_SPAWN_MIST_CLEANUP_PROBE")else{return};
 let Some(mut journal)=world.remove_resource::<Journal>()else{return};
 if journal.stopped{world.insert_resource(journal);return;}
 let result=inspect(world,&mut journal);
 if let Some(doc)=result{
  // Fail closed for this read-only journal on I/O errors. No gameplay or
  // readiness state is changed, and missing evidence remains unavailable.
  let written=serde_json::to_vec(&doc).ok().and_then(|mut bytes|{
   bytes.push(b'\n');std::fs::OpenOptions::new().create(true).append(true).open(&path).ok().and_then(|mut file|{
    use std::io::Write;file.write_all(&bytes).ok()
   })
  }).is_some();
  if !written{journal.stopped=true;}
 }
 world.insert_resource(journal);
}
fn inspect(world:&World,journal:&mut Journal)->Option<serde_json::Value>{
 let backend=world.get_resource::<Backend>()?;
 let state=world.get_resource::<State>()?;
 let identity=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity);
 if let (Some(binding),Some(active),Some((session,_,_)))=(backend.binding,state.active.as_ref(),identity){
  if backend.error.is_none()&&binding==active.binding&&binding.session==session{
   let tickets=backend.tickets();
   if tickets.len()>128||tickets.iter().any(|t|t.binding!=binding){journal.stopped=true;return None;}
   if !tickets.is_empty(){
    let Some(presence)=capture_previous(world,binding,&tickets,backend.published_frames,state.ordinal)else{return None};
    journal.previous=Some(Previous{binding,tickets,published_frames:backend.published_frames,ordinal:state.ordinal,presence});
    journal.last_sample=None;
   }
  }
  return None;
 }
 // A cold/error publication or lack of resources is not a successful clear.
 if identity.is_some()||backend.binding.is_some()||state.active.is_some()||backend.error.is_some()||!backend.tickets().is_empty(){return None;}
 let previous=journal.previous.as_ref()?;
 if backend.published_frames<=previous.published_frames||state.ordinal<=previous.ordinal||journal.last_sample==Some(backend.published_frames){return None;}
 if journal.completed>=32{journal.stopped=true;return None;}
 let meshes=world.get_resource::<Assets<Mesh>>()?;
 let materials=world.get_resource::<Assets<MistMaterial>>()?;
 let roots=previous.binding.roots.into_iter().enumerate().map(|(source,entity)|{
  let actual=world.get::<SourceRoot>(entity);
  serde_json::json!({"source":source,"source_root":entity.to_bits(),"entity_exists":world.get_entity(entity).is_ok(),
   "SourceRoot_marker_present":actual.is_some(),"SourceRoot_marker_matches_previous":actual.is_some_and(|r|r.session==previous.binding.session&&r.slot==source&&r.map_root==previous.binding.map_root&&r.model==previous.binding.model&&r.position==previous.binding.positions[source])})
 }).collect::<Vec<_>>();
 let draws=previous.tickets.iter().map(|t|serde_json::json!({"session":t.binding.session,"source":t.source,"slot":t.slot,"birth":t.birth,"counter":t.counter,
  "draw":t.draw.to_bits(),"map_root":t.binding.map_root.to_bits(),"source_root":t.binding.roots[t.source].to_bits(),
  "draw_entity_exists":world.get_entity(t.draw).is_ok(),"exact_old_Ticket_present":world.get::<Ticket>(t.draw)==Some(t),
  "mesh_asset_id":format!("{:?}",t.mesh),"material_asset_id":format!("{:?}",t.material),
  "CPU_mesh_asset_present":meshes.get(t.mesh).is_some(),"CPU_material_asset_present":materials.get(t.material).is_some()})).collect::<Vec<_>>();
 let answer_count=world.get_resource::<ReadyAnswers>().and_then(|r|r.0.lock().ok().map(|list|list.len()));
 journal.last_sample=Some(backend.published_frames);
 journal.completed+=1;
 let doc=serde_json::json!({"schema":"map10_spawn_mist_retired_object_observation_v2","read_only":true,"previous_typed_presence":previous.presence,
  "session":previous.binding.session,"previous_published_frames":previous.published_frames,"previous_ordinal":previous.ordinal,
  "published_frames":backend.published_frames,"ordinal":state.ordinal,"State_last_good_clock":state.last_clock,
  "canonical_clock":world.get_resource::<crate::native_effect_clock::EffectClock>().map(|c|c.diagnostic()),
  "current_connection_identity_absent":true,"current_Backend_binding_absent":true,"current_State_active_absent":true,
  "current_Backend_error":backend.error,"current_ticket_count":0,"actual_ready_answer_count":answer_count,
  "current_map_root_exists":world.get_entity(previous.binding.map_root).is_ok(),"previous_source_roots":roots,"previous_draws":draws,
  "GPU_assets_absence_observed":false,"GPU_buffer_readback":false,"RNG_observed":false,"pixels_or_original_fidelity_qualified":false});
 // Keep a bounded 32 confirmation samples for this actual generation. A real
 // later admitted binding refreshes Previous; old Entity generations are never
 // interpreted as the corresponding new generation's objects.
 Some(doc)
}

// Actual read-only presence at the previous committed publication. This captures
// neither a synthetic CPU report nor strong Handles. The private typed Ticket
// list remains the authority later used for old-ID absence lookup.
fn capture_previous(world:&World,binding:Binding,tickets:&[Ticket],published_frames:u64,ordinal:u64)->Option<serde_json::Value>{
 let meshes=world.get_resource::<Assets<Mesh>>()?;
 let materials=world.get_resource::<Assets<MistMaterial>>()?;
 let roots=binding.roots.into_iter().enumerate().map(|(source,entity)|{
  let marker=world.get::<SourceRoot>(entity);
  serde_json::json!({"source":source,"source_root":entity.to_bits(),"entity_exists":world.get_entity(entity).is_ok(),
   "SourceRoot_marker_present":marker.is_some(),"SourceRoot_marker_matches_expected":marker.is_some_and(|r|r.session==binding.session&&r.slot==source&&r.map_root==binding.map_root&&r.model==binding.model&&r.position==binding.positions[source]),
   "source_parent_matches_map":world.get::<ChildOf>(entity).map(ChildOf::parent)==Some(binding.map_root)})
 }).collect::<Vec<_>>();
 let draws=tickets.iter().map(|t|serde_json::json!({"session":t.binding.session,"source":t.source,"slot":t.slot,"birth":t.birth,"counter":t.counter,
  "draw":t.draw.to_bits(),"map_root":t.binding.map_root.to_bits(),"source_root":t.binding.roots[t.source].to_bits(),
  "draw_entity_exists":world.get_entity(t.draw).is_ok(),"exact_published_Ticket_matches":world.get::<Ticket>(t.draw)==Some(t),
  "mesh_binding_matches_typed_Ticket":world.get::<Mesh3d>(t.draw).map(|m|m.0.id())==Some(t.mesh),
  "material_binding_matches_typed_Ticket":world.get::<MeshMaterial3d<MistMaterial>>(t.draw).map(|m|m.0.id())==Some(t.material),
  "mesh_asset_id":format!("{:?}",t.mesh),"material_asset_id":format!("{:?}",t.material),
  "CPU_mesh_asset_present":meshes.get(t.mesh).is_some(),"CPU_material_asset_present":materials.get(t.material).is_some()})).collect::<Vec<_>>();
 Some(serde_json::json!({"schema":"map10_spawn_mist_live_typed_previous_capture_v1","read_only":true,
  "origin":"actual_World_and_Assets_lookups_at_retained_committed_Backend_tickets",
  "session":binding.session,"map_root":binding.map_root.to_bits(),"map_root_exists":world.get_entity(binding.map_root).is_ok(),
  "model_asset_id":format!("{:?}",binding.model),"published_frames":published_frames,"ordinal":ordinal,
  "source_roots":roots,"draws":draws,"GPU_state_observed":false,"strong_Handles_retained":false}))
}
