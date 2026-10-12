//! Opt-in observation of real StunReady ECS transforms/materials after visibility.
use super::*;
pub fn observe(mut commands:Commands,clock:Res<crate::native_effect_clock::EffectClock>,
 materials:Res<Assets<ReadyMaterial>>,quads:Query<(Entity,&Transform,&Visibility,&ViewVisibility,&MeshMaterial3d<ReadyMaterial>),With<ReadyQuad>>,players:Query<(Entity,&AnimationPlayer)>,bones:Query<(Entity,&bevy::animation::AnimatedBy,&Transform)>,fog:Res<Assets<crate::map_fog::FogMaterial>>,terrain:Res<Assets<crate::terrain_material::TerrainMaterial>>,audio:Res<crate::map_audio_requests::AmbientRequests>,mut observation:Local<u64>,mut captured:Local<bool>) {
 let Some(path)=std::env::var_os("OPENLEAGUE_READY_LIVE_PROBE").map(std::path::PathBuf::from).filter(|p|p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs"))) else{return;};
 let mut rows:Vec<_>=quads.iter().map(|(e,t,v,view,m)|serde_json::json!({"entity":e.to_bits(),"translation":t.translation.to_array(),"rotation":t.rotation.to_array(),"scale":t.scale.to_array(),"hidden":*v==Visibility::Hidden,"in_view":view.get(),"color":materials.get(&m.0).map(|m|m.color.to_array()),"uv":materials.get(&m.0).map(|m|m.uv_scroll.to_array())})).collect();
 rows.sort_by_key(|v|v["entity"].as_u64());
 let visible=rows.iter().filter(|r|r["in_view"]==true && r["hidden"]==false).count();
 if clock.paused() && visible>0 && !*captured {
  commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(path.with_extension("paused.png")));*captured=true;
 }
 let mut animations:Vec<_>=players.iter().map(|(entity,player)|{
  let mut clips:Vec<_>=player.playing_animations().map(|(index,active)|serde_json::json!({"index":index.index(),"seek":active.seek_time(),"elapsed":active.elapsed(),"weight":active.weight(),"speed":active.speed(),"paused":active.is_paused()})).collect();
  clips.sort_by_key(|v|v["index"].as_u64());serde_json::json!({"entity":entity.to_bits(),"clips":clips})
 }).collect();animations.sort_by_key(|v|v["entity"].as_u64());
 let mut bone_rows:Vec<_>=bones.iter().filter(|(_,owner,_)|players.contains(owner.0)).map(|(entity,owner,t)|serde_json::json!({"entity":entity.to_bits(),"player":owner.0.to_bits(),"translation":t.translation.to_array(),"rotation":t.rotation.to_array(),"scale":t.scale.to_array()})).collect();
 bone_rows.sort_by_key(|v|v["entity"].as_u64());
 let mut fog_clouds:Vec<_>=fog.iter().map(|(id,m)|serde_json::json!({"id":format!("{id:?}"),"phase":m.extension.cloud_phase.to_array(),"profile":m.extension.fog_profile.to_array()})).collect();
 fog_clouds.sort_by(|a,b|a["id"].as_str().cmp(&b["id"].as_str()));
 let mut terrain_clouds:Vec<_>=terrain.iter().map(|(id,m)|serde_json::json!({"id":format!("{id:?}"),"phase":m.cloud_phase.to_array(),"profile":m.fog_profile.to_array()})).collect();
 terrain_clouds.sort_by(|a,b|a["id"].as_str().cmp(&b["id"].as_str()));
 *observation+=1;
 let record=serde_json::json!({"observation":*observation,"audio":audio.diagnostic(),"clock":clock.diagnostic(),"visible_quads":visible,"quads":rows,"animations":animations,"bones":bone_rows,"clouds":{"fog":fog_clouds,"terrain":terrain_clouds}});
 let pending=path.with_extension("json.pending");
 if let Err(e)=std::fs::write(&pending,serde_json::to_vec(&record).unwrap()).and_then(|_|std::fs::rename(&pending,&path)){warn!("Ready pause probe: {e}");}
}
