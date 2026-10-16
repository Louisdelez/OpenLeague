//! Ordinary accepted-result adapter to the native opacity/cache/draw contracts.
//! Scope: current loaded lane actors, base MeshSkin, opaque mode0 baselines.
//! The original packet dispatcher/actor registry and dynamic radius override remain open.
use bevy::prelude::*;
use std::{collections::{HashMap,HashSet},sync::OnceLock};
use crate::native_minion_fade_material::{self as material,Owner,Guard};
struct Fade{owner:Owner,opacity:crate::native_minion_opacity::OpacityState,grass:crate::grass_actor_cache::Cache}
#[derive(Resource,Default)]pub struct Host{key:Option<(u64,u64)>,fired:bool,actors:HashMap<u32,Fade>,pub issues:Vec<String>}
/// Readonly copy of the states actually sampled by synchronize this frame.
pub(crate) struct Observation {pub owner:Owner,pub current:f32,pub deadline:f32,pub target:f32,pub rate:f32,pub cache:[f32;3],pub brush:u8}
impl Host {
 pub(crate) fn observations(&self)->Vec<Observation>{
  let mut rows:Vec<_>=self.actors.values().map(|v|Observation{owner:v.owner,current:v.opacity.current,deadline:v.opacity.deadline,target:v.opacity.target,rate:v.opacity.rate,cache:[v.grass.x,v.grass.z,v.grass.radius],brush:v.grass.result}).collect();
  rows.sort_by_key(|v|v.owner.network);rows
 }
}
struct Actor{owner:Owner,position:[f32;3],raw_radius:f32}
#[derive(serde::Deserialize)]struct Metadata{min:[f32;3],#[serde(rename="cellSize")]cell_size:f32,width:usize,height:usize}
struct Terrain{metadata:Metadata,flags:Vec<u16>}
fn admitted_base_lane(name:&str)->bool{
 static NAMES:OnceLock<HashSet<String>>=OnceLock::new();NAMES.get_or_init(||{let world:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_world.json")).expect("actual base lane model definitions");world["definitions"].as_object().unwrap().iter().filter(|(_,v)|matches!(v["kind"].as_str(),Some("Melee"|"Caster"|"Siege"|"Super"))).map(|(n,_)|n.to_ascii_lowercase()).collect()}).contains(&name.to_ascii_lowercase())
}
fn terrain()->&'static Terrain{
 static VALUE:OnceLock<Terrain>=OnceLock::new();VALUE.get_or_init(||{let metadata:Metadata=serde_json::from_str(include_str!("../../../assets/maps/tt_navigation_grid.json")).expect("actual Map10 navigation metadata");let bytes=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");assert_eq!(bytes.len(),metadata.width.checked_mul(metadata.height).and_then(|v|v.checked_mul(11)).expect("actual Map10 grid size"));let flags=bytes.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();Terrain{metadata,flags}})
}
fn grass(cache:&mut crate::grass_actor_cache::Cache,position:[f32;3],raw_radius:f32)->Result<bool,String>{
 let data=terrain();let grid=crate::fow_terrain_ray::TerrainGrid{width:data.metadata.width,height:data.metadata.height,origin:data.metadata.min,cell_size:data.metadata.cell_size,flags:&data.flags};
 let mut error=None;let value=cache.update(position,0.,raw_radius,|x,z,r|match crate::fow_terrain_ray::source_flag([x,z],r,&grid){Ok(v)=>u8::from(v),Err(e)=>{error=Some(e.to_owned());0}});
 if let Some(error)=error{return Err(error);}Ok(value!=0)
}
fn actor_inputs(world:&World)->Result<Option<((u64,u64),f32,bool,Vec<Actor>)>,String>{
 let Some(identity)=world.get_resource::<crate::Connection>().and_then(crate::Connection::inventory_input_identity)else{return Ok(None);};
 let Some(state)=world.get_resource::<crate::Match>()else{return Ok(None);};let Some(snapshot)=state.snapshot.as_ref()else{return Ok(None);};
 let Some(result)=snapshot.result.as_ref().filter(|r|r.session==identity.0&&snapshot.session==identity.0&&r.winner<2&&snapshot.winner==Some(r.winner)&&r.players.iter().any(|p|p.id==identity.1))else{return Ok(None);};
 let now=world.get_resource::<Time>().ok_or("actual endgame Time unavailable")?.elapsed_secs_f64();let clock=world.get_resource::<crate::endgame_timeline::Clock>().ok_or("actual endgame Clock unavailable")?;
 let due=clock.skin_due_for(result,now)&&clock.age(now).is_some_and(|age|age<crate::endgame_timeline::schedule().skin+crate::endgame_timeline::schedule().minion_fade);
 let mut actors=Vec::new();let mut roots=HashSet::new();
 if due{for unit in snapshot.units.iter().filter(|u|u.kind.lane()&&u.team==1-result.winner){
  let Some(&root)=state.visuals.get(&unit.id)else{continue;};let Some(playback)=world.get::<crate::animation::Playback>(root)else{continue;};
  if playback.network_id()!=unit.id||playback.model_name()!=unit.definition||world.get::<crate::actor_fow::Root>(root).is_none()||world.get::<ChildOf>(root).is_some(){continue;}
  let Some(global)=world.get::<GlobalTransform>(root)else{continue;};let position=(global.translation()*20.).to_array();
  if position.iter().any(|v|!v.is_finite()){return Err("actual minion GlobalTransform nonfinite".into());}
  if !admitted_base_lane(&unit.definition){return Err("lane definition outside checked native base MeshSkin catalog".into());}
  let geometry=crate::fow_character_geometry::native_character(&unit.definition,None).map_err(str::to_owned)?;
  if !geometry.radius.is_finite(){return Err("native raw actor37C radius nonfinite".into());}
  if !roots.insert(root){return Err("multiple lane identities share actual actor root".into());}
  actors.push(Actor{owner:Owner{session:result.session,ended_tick:result.ended_tick,network:unit.id,root,model:playback.model_asset_id()},position,raw_radius:geometry.radius});
 }}
 Ok(Some(((result.session,result.ended_tick),now as f32,due,actors)))
}
fn primitive_for(world:&World,entity:Entity,root:Entity)->bool{let mut current=entity;for _ in 0..128{if current==root{return true;}let Some(parent)=world.get::<ChildOf>(current)else{return false;};current=parent.parent();}false}
pub fn synchronize(world:&mut World){
 let mut host=world.remove_resource::<Host>().unwrap_or_default();host.issues.clear();
 let inputs=match actor_inputs(world){Ok(v)=>v,Err(e)=>{host.issues.push(e);None}};let key=inputs.as_ref().map(|v|v.0);
 if host.key!=key{host.key=key;host.fired=false;host.actors.clear();}
 let mut desired=HashMap::new();
 if let Some((_,now,true,actors))=inputs{
  // The actual first skin-due update owns the local FadeMinions event. Do not
  // replay that historical event into actors/models loaded or replaced later.
  if !host.fired{for actor in &actors{host.actors.insert(actor.owner.network,Fade{owner:actor.owner,opacity:crate::native_minion_opacity::OpacityState::begin(1.,0.,crate::endgame_timeline::schedule().minion_fade as f32,now),grass:crate::grass_actor_cache::Cache{x:f32::NAN,z:f32::NAN,radius:f32::NAN,result:0}});}host.fired=true;}
  let mut alive=HashSet::new();for actor in actors{
   let Some(fade)=host.actors.get_mut(&actor.owner.network).filter(|v|v.owner==actor.owner)else{continue;};alive.insert(actor.owner.network);
   match grass(&mut fade.grass,actor.position,actor.raw_radius){Ok(inside)=>{
    let sampled=fade.opacity.sample(now);
    // 9648F2 default .25; checked base lane MeshSkin has no authored override.
    // Compare/fallthrough is preserved; no f32::min/NaN-domain substitution.
    desired.insert(actor.owner.root,(actor.owner,material::brush_cap(sampled,inside,0.25)));
   },Err(e)=>host.issues.push(e)}
  }host.actors.retain(|id,_|alive.contains(id));
 }else{host.actors.clear();}
 let guards:Vec<_>={let mut query=world.query::<(Entity,&Guard)>();query.iter(world).map(|(e,g)|(e,g.owner)).collect()};
 for(entity,owner)in guards{if desired.get(&owner.root).is_none_or(|v|v.0!=owner){if let Err(e)=material::release(world,entity){host.issues.push(e);}}}
 let primitives:Vec<_>={let mut query=world.query_filtered::<Entity,(With<Mesh3d>,With<crate::actor_fow::Bound>)>();query.iter(world).collect()};
 for(root,(owner,submitted))in desired{let owned:Vec<_>=primitives.iter().copied().filter(|e|primitive_for(world,*e,root)).collect();for entity in owned{if let Err(e)=material::publish(world,owner,entity,submitted){host.issues.push(e);}}}
 world.insert_resource(host);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Host>().add_systems(PostUpdate,synchronize.after(bevy::transform::TransformSystems::Propagate).before(crate::endgame_minion_no_render::synchronize).before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}}
#[cfg(test)]#[path="native_minion_fade_producer_tests.rs"]mod tests;
