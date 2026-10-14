//! Opt-in actual state/material/screenshot observation; no gameplay or material mutation.
use bevy::{prelude::*,render::view::screenshot::{Screenshot,ScreenshotCaptured}};
use std::{collections::{HashMap,HashSet},path::PathBuf};
use crate::{native_minion_fade_material::{Guard,Material},map_fog::FogMaterial};
#[derive(Resource,Default)]struct Journal{directory:Option<PathBuf>,key:Option<(u64,u64,u32)>,next:f64,frames:u64,requested:HashSet<String>,saved:HashSet<String>,errors:Vec<String>,stopped:bool}
#[derive(Component)]struct Capture{key:(u64,u64,u32),winner:u8,name:String,path:PathBuf,age:f64,bindings:Vec<(u32,Entity,bevy::asset::AssetId<Gltf>)>}
fn write(journal:&mut Journal,row:serde_json::Value){if let Some(directory)=&journal.directory{use std::io::Write;let r=(||->std::io::Result<()>{let mut f=std::fs::OpenOptions::new().create(true).append(true).open(directory.join("events.jsonl"))?;writeln!(f,"{row}")})();if let Err(e)=r{journal.errors.push(format!("fade journal write: {e}"));}}}
fn setup(mut journal:ResMut<Journal>){
 let Some(raw)=std::env::var_os("OPENLEAGUE_ENDGAME_FADE_OBSERVATION")else{return;};let path=PathBuf::from(raw);
 let allowed=path.starts_with("E:/mapslol3v3")||path.starts_with("E:/OpenLeague/logs");
 if !path.is_absolute()||!allowed||path.components().any(|p|matches!(p,std::path::Component::ParentDir))||path.exists(){warn!("Fade observation requires a fresh absolute output child in scratch/logs");return;}
 match std::fs::create_dir(&path){Ok(())=>journal.directory=Some(path),Err(e)=>warn!("Fade observation output unavailable: {e}")}
}
fn select(world:&World)->Option<((u64,u64,u32),u8,f64,f64)>{
 let identity=world.get_resource::<crate::Connection>()?.inventory_input_identity()?;let snapshot=world.get_resource::<crate::Match>()?.snapshot.as_ref()?;let result=snapshot.result.as_ref()?;
 if result.session!=identity.0||snapshot.session!=identity.0||result.winner>1||snapshot.winner!=Some(result.winner)||!result.players.iter().any(|p|p.id==identity.1){return None;}
 let now=world.get_resource::<Time>()?.elapsed_secs_f64();let age=world.get_resource::<crate::endgame_timeline::Clock>()?.age(now)?;Some(((result.session,result.ended_tick,identity.1),result.winner,now,age))
}
fn captured(event:On<ScreenshotCaptured>,captures:Query<&Capture>,playbacks:Query<(&crate::animation::Playback,Option<&crate::actor_fow::Root>)>,state:Res<crate::Match>,connection:Res<crate::Connection>,time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,mut journal:ResMut<Journal>){
 let Ok(request)=captures.get(event.entity)else{return;};let key=request.key;
 let valid=!journal.stopped&&journal.key==Some(key)&&connection.inventory_input_identity().is_some_and(|i|i.0==key.0&&i.1==key.2)&&state.snapshot.as_ref().is_some_and(|s|s.session==key.0&&s.winner==Some(request.winner)&&s.result.as_ref().is_some_and(|r|r.session==key.0&&r.ended_tick==key.1&&r.winner==request.winner&&r.players.iter().any(|p|p.id==key.2)))&&request.bindings.iter().all(|(id,root,model)|state.visuals.get(id)==Some(root)&&playbacks.get(*root).is_ok_and(|(p,marker)|marker.is_some()&&p.network_id()==*id&&p.model_asset_id()==*model));
 if !valid{journal.errors.push("fade capture owner/model/session changed".into());write(&mut journal,serde_json::json!({"stage":"failed","key":key,"capture":request.name,"reason":"capture_owner_changed"}));return;}
 let image=event.image.clone();let dimensions=[image.width(),image.height()];let saved=image.try_into_dynamic().map_err(|e|e.to_string()).and_then(|i|i.to_rgb8().save(&request.path).map_err(|e|e.to_string()));
 match saved{Ok(())=>{journal.saved.insert(request.name.clone());write(&mut journal,serde_json::json!({"stage":"framebuffer_saved","key":key,"capture":request.name,"path":request.path,"dimensions":dimensions,"request_age":request.age,"callback_age":clock.age(time.elapsed_secs_f64()),"owner_guard_rechecked":true,"exact_GPU_exposure_time":null,"visually_reviewed":false}));},Err(e)=>{journal.errors.push(e.clone());write(&mut journal,serde_json::json!({"stage":"failed","key":key,"reason":e}));}}
}
/// One real primary target request at a time, including explicit window aliases.
/// Both opt-in observers call this same exclusive-World operation. Captured
/// entities have completed readback and no longer reserve the target.
pub fn try_primary_capture(world:&mut World)->Option<Entity>{
 let primary={let mut q=world.query_filtered::<Entity,With<bevy::window::PrimaryWindow>>();let mut rows=q.iter(world);let e=rows.next()?;if rows.next().is_some(){return None;}e};
 let target=Screenshot::primary_window().0.normalize(Some(primary))?;
 let busy={let mut q=world.query::<(&Screenshot,Option<&bevy::render::view::screenshot::Captured>)>();q.iter(world).any(|(s,c)|c.is_none()&&s.0.normalize(Some(primary)).as_ref()==Some(&target))};
 if busy{return None;}
 Some(world.spawn(Screenshot::primary_window()).id())
}
/// Opt-in UI test waits for the cleanup readback of this accepted result.
/// Missing/disabled fade observation leaves the standalone UI exercise intact.
pub fn cleanup_complete_for(world:&World,key:(u64,u64,u32))->bool{
 let Some(journal)=world.get_resource::<Journal>()else{return true;};
 if journal.directory.is_none(){return true;}
 !journal.stopped&&journal.key==Some(key)&&journal.errors.is_empty()&&journal.saved.contains("fade-cleanup")
}
pub fn observe(world:&mut World){
 let mut journal=world.remove_resource::<Journal>().unwrap_or_default();if journal.directory.is_none(){world.insert_resource(journal);return;}
 if journal.stopped{*world.resource_mut::<crate::native_minion_fade_gpu_observation::Frame>()=default();world.insert_resource(journal);return;}
 let Some((key,winner,now,age))=select(world)else{*world.resource_mut::<crate::native_minion_fade_gpu_observation::Frame>()=default();world.insert_resource(journal);return;};
 if journal.key.is_none(){journal.key=Some(key);}else if journal.key!=Some(key){write(&mut journal,serde_json::json!({"stage":"failed","key":key,"reason":"accepted_result_replaced"}));journal.errors.push("accepted_result_replaced".into());journal.stopped=true;*world.resource_mut::<crate::native_minion_fade_gpu_observation::Frame>()=default();world.insert_resource(journal);return;}
 if now<journal.next{world.insert_resource(journal);return;}journal.next=now+0.05;journal.frames+=1;
 let clock_bits=(now as f32).to_bits();let skin=crate::endgame_timeline::schedule().skin;let duration=crate::endgame_timeline::schedule().minion_fade;let deadline=skin+duration;
 let producer=world.get_resource::<crate::native_minion_fade_producer::Host>();let curves:HashMap<_,_>=producer.map(|h|h.observations().into_iter().map(|v|(v.owner.network,v)).collect()).unwrap_or_default();let producer_issues=producer.map(|h|h.issues.clone()).unwrap_or_else(||vec!["actual fade Host unavailable".into()]);
 let actors:Vec<_>={let state=world.resource::<crate::Match>();let snapshot=state.snapshot.as_ref().unwrap();snapshot.units.iter().filter(|u|u.kind.lane()&&u.team==1-winner).map(|u|(u.id,u.definition.clone(),u.health,state.visuals.get(&u.id).copied())).collect()};
 if age>deadline+3.{*world.resource_mut::<crate::native_minion_fade_gpu_observation::Frame>()=default();world.insert_resource(journal);return;}
 let mut rows=Vec::new();let mut bindings=Vec::new();let mut visible=0;let mut private=0;let mut tickets=Vec::new();
 for(id,name,health,root)in actors{
  let Some(root)=root else{rows.push(serde_json::json!({"id":id,"owned":false,"root":null}));continue;};
  let Some(playback)=world.get::<crate::animation::Playback>(root)else{rows.push(serde_json::json!({"id":id,"owned":false,"root":format!("{root:?}")}));continue;};let model=playback.model_asset_id();
  let owned=playback.network_id()==id&&playback.model_name()==name&&world.get::<crate::actor_fow::Root>(root).is_some()&&world.get::<ChildOf>(root).is_none();
  if owned{bindings.push((id,root,model));}
  let curve=curves.get(&id).filter(|v|v.owner.root==root&&v.owner.model==model&&v.owner.session==key.0&&v.owner.ended_tick==key.1);
  let mut queue=vec![root];let mut seen=HashSet::new();let mut meshes=Vec::new();let mut overflow=false;
  while let Some(entity)=queue.pop(){if !seen.insert(entity){continue;}if seen.len()>2048{overflow=true;break;}if let Some(children)=world.get::<Children>(entity){queue.extend(children.iter());}
   if let Some(mesh)=world.get::<Mesh3d>(entity){
    let in_view=world.get::<ViewVisibility>(entity).map(|v|v.get());let inherited=world.get::<InheritedVisibility>(entity).map(|v|v.get());if owned&&in_view==Some(true)&&inherited==Some(true){visible+=1;}
    let guard=world.get::<Guard>(entity);let private_handle=world.get::<MeshMaterial3d<Material>>(entity);let baseline=world.get::<MeshMaterial3d<FogMaterial>>(entity);
    let asset=private_handle.and_then(|h|world.get_resource::<Assets<Material>>()?.get(&h.0));let guard_owned=guard.is_some_and(|g|g.owner.session==key.0&&g.owner.ended_tick==key.1&&g.owner.network==id&&g.owner.root==root&&g.owner.model==model&&private_handle.is_some_and(|h|h.0==g.owned)&&baseline.is_none()&&world.get::<crate::actor_fow::BaselineLease>(entity).is_some_and(|l|l.source==g.standard&&l.previous==g.previous)&&world.get::<crate::actor_fow::Bound>(entity).is_some_and(|b|b.source==g.standard));
    if guard_owned{if let(Some(asset),Some(handle))=(asset,private_handle){private+=1;let extension=&asset.base.extension;let mut images=vec![extension.cloud_opacity.id(),extension.lighting.id(),extension.visibility_map.id(),extension.visibility_overlay.id(),extension.colormap.id()];if let Some(diffuse)=&asset.base.base.base_color_texture{images.push(diffuse.id());}images.sort();images.dedup();tickets.push(crate::native_minion_fade_gpu_observation::Ticket{network:id,root,model:format!("{model:?}"),draw:entity,mesh:mesh.0.id(),material:handle.0.id(),images,visibility:extension.visibility_map.id()});}}
    let baseline_alpha=baseline.and_then(|h|world.get_resource::<Assets<FogMaterial>>()?.get(&h.0)).map(|m|m.base.base_color.alpha().to_bits());
    meshes.push(serde_json::json!({"entity":format!("{entity:?}"),"mesh":format!("{:?}",mesh.0.id()),"view_visible":in_view,"inherited_visible":inherited,"guard_owned":guard_owned,"submitted_bits":guard.map(|g|g.submitted.to_bits()),"private_material":private_handle.map(|h|format!("{:?}",h.0.id())),"private_asset_present":asset.is_some(),"uniform_opacity_bits":asset.map(|m|m.extension.opacity.to_bits()),"baseline_alpha_bits":baseline_alpha,"baseline_bound":baseline.is_some()}));
   }
  }
  rows.push(serde_json::json!({"id":id,"definition":name,"health":health,"root":format!("{root:?}"),"model":format!("{model:?}"),"owned":owned,"traversal_overflow":overflow,"root_visibility":world.get::<Visibility>(root).map(|v|format!("{v:?}")),"curve":curve.map(|v|serde_json::json!({"current_bits":v.current.to_bits(),"deadline_bits":v.deadline.to_bits(),"target_bits":v.target.to_bits(),"rate_bits":v.rate.to_bits(),"cache_bits":v.cache.map(f32::to_bits),"brush":v.brush})),"meshes":meshes}));
 }
 let frame=journal.frames;let errors=journal.errors.clone();write(&mut journal,serde_json::json!({"stage":"sample","schema":1,"key":key,"frame":frame,"age":age,"local_time":now,"sample_clock_bits":clock_bits,"skin":skin,"duration":duration,"native_no_render_deadline":deadline,"producer_issues":producer_issues,"observer_issues":errors,"visible_owned_meshes":visible,"private_owned_meshes":private,"roots":rows,"draw_submission_qualified":false,"pixels_qualified":false}));
 *world.resource_mut::<crate::native_minion_fade_gpu_observation::Frame>()=crate::native_minion_fade_gpu_observation::Frame{directory:journal.directory.clone(),key:Some(key),probe_frame:frame,age,tickets};
 let captures=[("fade-before",0.,skin), ("fade-start",skin+duration*0.10,skin+duration*0.35),("fade-middle",skin+duration*0.45,skin+duration*0.70),("fade-tail",skin+duration*0.80,deadline),("fade-cleanup",deadline,deadline+3.)];
 for(name,start,end)in captures{if age>=start&&age<end&&!journal.requested.contains(name)&&!bindings.is_empty()&&(name=="fade-cleanup"||visible>0)&&(name=="fade-before"||name=="fade-cleanup"||private>0){
  let path=journal.directory.as_ref().unwrap().join(format!("{name}.png"));if path.exists(){journal.errors.push("fresh fade capture path already exists".into());continue;}
  let Some(entity)=try_primary_capture(world)else{continue;};journal.requested.insert(name.into());world.entity_mut(entity).insert(Capture{key,winner,name:name.into(),path:path.clone(),age,bindings:bindings.clone()}).observe(captured);write(&mut journal,serde_json::json!({"stage":"framebuffer_requested","key":key,"capture":name,"path":path,"request_age":age,"source_probe_frame":frame,"visible_owned_meshes":visible,"private_owned_meshes":private,"exact_GPU_exposure_time":null}));
 }}
 world.insert_resource(journal);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){crate::native_minion_fade_gpu_observation::install(app);app.init_resource::<Journal>().add_systems(Startup,setup).add_systems(PostUpdate,observe.after(crate::native_minion_fade_producer::synchronize).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));}}

#[cfg(test)]mod capture_coordination_tests{
 use super::*;
 #[test]fn same_primary_capture_requests_serialize_until_readback_and_same_owner_cleanup(){
  use bevy::render::view::screenshot::Captured;
  let mut world=World::new();let primary=world.spawn((Window::default(),bevy::window::PrimaryWindow)).id();
  let key=(61,82,21);let mut journal=Journal::default();journal.directory=Some(PathBuf::from("E:/mapslol3v3/capture_test_fixture_no_io"));journal.key=Some(key);world.insert_resource(journal);
  // The two actual observer producers call this exact shared operation in
  // either PostUpdate order. First one reserves; second remains unrequested.
  let splash=try_primary_capture(&mut world).unwrap();assert!(try_primary_capture(&mut world).is_none());
  let mut q=world.query::<&Screenshot>();assert_eq!(q.iter(&world).count(),1);
  assert!(!cleanup_complete_for(&world,key));
  // Actual Bevy readback lifecycle marker (controlled ECS fixture; no GPU).
  world.entity_mut(splash).insert(Captured);
  let cleanup=try_primary_capture(&mut world).unwrap();assert!(try_primary_capture(&mut world).is_none());
  assert!(!cleanup_complete_for(&world,key));world.entity_mut(cleanup).insert(Captured);
  world.resource_mut::<Journal>().saved.insert("fade-cleanup".into());assert!(cleanup_complete_for(&world,key));assert!(!cleanup_complete_for(&world,(61,83,21)));
  // Explicit window target aliases normalize to the same primary target.
  let foreign=world.spawn(Screenshot::window(primary)).id();assert!(try_primary_capture(&mut world).is_none());world.entity_mut(foreign).insert(Captured);assert!(try_primary_capture(&mut world).is_some());
 }
}
