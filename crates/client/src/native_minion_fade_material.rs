//! Private actor fade material, admitted only for actual opaque lane baselines.
//! Native 73BE3F threshold/c23 and 0x80C D3D route qualify this alpha delta.
//! Whole actor lighting, native incoming alpha-test state and ordinary host remain separate.
use bevy::{prelude::*,pbr::{ExtendedMaterial,MaterialExtension,MaterialExtensionKey,MaterialExtensionPipeline},reflect::TypePath,render::render_resource::{AsBindGroup,BlendState,BlendComponent,BlendFactor,BlendOperation,RenderPipelineDescriptor,SpecializedMeshPipelineError},shader::ShaderRef};
use crate::map_fog::FogMaterial;

pub const THRESHOLD:f32=f32::from_bits(0x3f7d70a4);
pub fn shader_factor(submitted:f32)->f32 {if submitted<THRESHOLD{submitted}else{1.}}
pub fn brush_cap(opacity:f32,inside:bool,override_alpha:f32)->f32 {if inside&&opacity>override_alpha{override_alpha}else{opacity}}
pub fn native_blend()->BlendState {
 let part=BlendComponent{src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add};BlendState{color:part,alpha:part}
}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
pub struct Extension {#[uniform(131)]pub opacity:f32}
impl MaterialExtension for Extension {
 fn fragment_shader()->ShaderRef {"shaders/native_minion_fade.wgsl".into()}
 fn alpha_mode()->Option<AlphaMode> {Some(AlphaMode::Blend)}
 fn specialize(_: &MaterialExtensionPipeline,descriptor:&mut RenderPipelineDescriptor,_:&bevy::mesh::MeshVertexBufferLayoutRef,_:MaterialExtensionKey<Self>)->Result<(),SpecializedMeshPipelineError> {
  let fragment=descriptor.fragment.as_mut().expect("actor fade requires actual PBR fragment pipeline");
  if let Some(Some(target))=fragment.targets.first_mut(){target.blend=Some(native_blend());}
  // 0x80C explicitly retains depth test and depth writes; keep Bevy's reversed-Z comparison.
  if let Some(depth)=descriptor.depth_stencil.as_mut(){depth.depth_write_enabled=Some(true);}
  Ok(())
 }
}
pub type Material=ExtendedMaterial<FogMaterial,Extension>;

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct Owner {pub session:u64,pub ended_tick:u64,pub network:u32,pub root:Entity,pub model:bevy::asset::AssetId<Gltf>}
#[derive(Component,Clone)]
pub struct Guard {pub owner:Owner,pub previous:Handle<FogMaterial>,pub owned:Handle<Material>,pub standard:Handle<StandardMaterial>,pub submitted:f32}

fn same_actor(world:&World,owner:Owner)->bool {
 let Some(identity)=world.get_resource::<crate::Connection>().and_then(|c|c.inventory_input_identity())else{return false;};
 if identity.0!=owner.session{return false;}
 let Some(state)=world.get_resource::<crate::Match>()else{return false;};
 let Some(snapshot)=state.snapshot.as_ref().filter(|s|s.session==owner.session)else{return false;};
 let Some(result)=snapshot.result.as_ref().filter(|r|r.session==owner.session&&r.ended_tick==owner.ended_tick&&r.winner<2&&snapshot.winner==Some(r.winner))else{return false;};
 let Some(now)=world.get_resource::<Time>().map(|t|t.elapsed_secs_f64())else{return false;};
 let Some(clock)=world.get_resource::<crate::endgame_timeline::Clock>()else{return false;};
 if !clock.skin_due_for(result,now)||!clock.age(now).is_some_and(|age|age<crate::endgame_timeline::schedule().scoreboard()){return false;}
 if !result.players.iter().any(|p|p.id==identity.1)||state.visuals.get(&owner.network)!=Some(&owner.root){return false;}
 let Some(unit)=snapshot.units.iter().find(|u|u.id==owner.network&&u.kind.lane()&&u.team==1-result.winner)else{return false;};
 world.get::<crate::actor_fow::Root>(owner.root).is_some()&&world.get::<crate::animation::Playback>(owner.root).is_some_and(|p|p.network_id()==owner.network&&p.model_asset_id()==owner.model&&p.model_name()==unit.definition)
}
fn descendant(world:&World,entity:Entity,root:Entity)->bool {
 let mut current=entity;for _ in 0..128{if current==root{return true;}let Some(parent)=world.get::<ChildOf>(current)else{return false;};current=parent.parent();}false
}
fn binding_owned(world:&World,entity:Entity,guard:&Guard)->bool {
 world.get::<crate::actor_fow::Bound>(entity).is_some_and(|b|b.source==guard.standard)
 &&world.get::<MeshMaterial3d<Material>>(entity).is_some_and(|m|m.0==guard.owned)
 &&world.get::<MeshMaterial3d<FogMaterial>>(entity).is_none()
}
fn lease_owned(world:&World,entity:Entity,guard:&Guard)->bool {
 world.get::<crate::actor_fow::BaselineLease>(entity).is_some_and(|l|l.source==guard.standard&&l.previous==guard.previous)
}
pub(crate)fn admitted(base:&FogMaterial)->bool {base.base.alpha_mode==AlphaMode::Opaque&&base.extension.native_draw_mode==0&&base.extension.factor_mode==0&&base.extension.alpha_test_enabled==0&&base.base.base_color.alpha()==1.}
pub fn release(world:&mut World,entity:Entity)->Result<bool,String> {
 let Some(guard)=world.get::<Guard>(entity).cloned()else{return Ok(false);};
 if !binding_owned(world,entity,&guard){
  // Remove only our stale component/asset handle; preserve every foreign binding.
  if world.get::<MeshMaterial3d<Material>>(entity).is_some_and(|m|m.0==guard.owned){world.entity_mut(entity).remove::<MeshMaterial3d<Material>>();}
  if lease_owned(world,entity,&guard){world.entity_mut(entity).remove::<crate::actor_fow::BaselineLease>();}
  world.entity_mut(entity).remove::<Guard>();return Ok(false);
 }
 if !lease_owned(world,entity,&guard){return Err("actor fade baseline lease replaced externally; preserve foreign lease and binding".into());}
 if world.resource::<Assets<FogMaterial>>().get(&guard.previous).is_none(){return Err("actor fade baseline unavailable; exact restoration pending".into());}
 world.entity_mut(entity).remove::<(MeshMaterial3d<Material>,Guard,crate::actor_fow::BaselineLease)>().insert(MeshMaterial3d(guard.previous));Ok(true)
}
/// The ordinary producer supplies the native sampled opacity after its actual
/// Map10 brush-cap query. This API invents no clock, packet or grass result.
pub fn publish(world:&mut World,owner:Owner,entity:Entity,submitted:f32)->Result<bool,String> {
 if !submitted.is_finite(){return Err("nonfinite actor opacity is outside this admitted host domain".into());}
 if !same_actor(world,owner)||!descendant(world,entity,owner.root)||world.get::<Mesh3d>(entity).is_none(){return Err("actor fade session/root/model/primitive ownership rejected".into());}
 if let Some(guard)=world.get::<Guard>(entity).cloned(){
  if guard.owner!=owner||!binding_owned(world,entity,&guard){release(world,entity)?;return Ok(false);}
  if submitted>=THRESHOLD{release(world,entity)?;return Ok(false);}
  world.get_mut::<Guard>(entity).unwrap().submitted=submitted;refresh(world,entity)?;return Ok(true);
 }
 // Above threshold, preserve the incoming actual material; no synthetic mode reset.
 if submitted>=THRESHOLD{return Ok(false);}
 if world.get::<MeshMaterial3d<Material>>(entity).is_some(){return Err("unowned actor fade material".into());}
 let standard=world.get::<crate::actor_fow::Bound>(entity).ok_or("actor fog source missing")?.source.clone();
 let previous=world.get::<MeshMaterial3d<FogMaterial>>(entity).ok_or("actor fog baseline missing")?.0.clone();
 if !world.resource::<crate::actor_fow::Cache>().bindings.get(&standard.id()).is_some_and(|h|*h==previous){return Err("untracked foreign actor fog baseline".into());}
 let base=world.resource::<Assets<FogMaterial>>().get(&previous).ok_or("actor baseline asset missing")?.clone();
 if !admitted(&base){return Err("actor fade supports the observed opaque, untinted actor baseline only".into());}
 let Some(owned)=crate::native_minion_fade_warmup::take_ready(world,owner,entity,&standard,&previous)?else{return Ok(false);};
 {let mut assets=world.resource_mut::<Assets<Material>>();let mut material=assets.get_mut(&owned).ok_or("prepared fade candidate unavailable")?;material.base=base;material.extension.opacity=shader_factor(submitted);}
 world.entity_mut(entity).remove::<MeshMaterial3d<FogMaterial>>().insert((MeshMaterial3d(owned.clone()),Guard{owner,previous:previous.clone(),owned,standard:standard.clone(),submitted},crate::actor_fow::BaselineLease{source:standard,previous}));Ok(true)
}
/// Refresh from the actually retained baseline, including current GPU fog
/// handles and source reloads. Call after the normal fog consumers, before extraction.
pub fn refresh(world:&mut World,entity:Entity)->Result<bool,String> {
 let Some(guard)=world.get::<Guard>(entity).cloned()else{return Ok(false);};
 if !same_actor(world,guard.owner)||!binding_owned(world,entity,&guard){return release(world,entity);}
 let base=world.resource::<Assets<FogMaterial>>().get(&guard.previous).ok_or("actor fade leased baseline unavailable")?.clone();
 if !lease_owned(world,entity,&guard){return Err("actor fade baseline lease replaced externally".into());}
 if !admitted(&base){return release(world,entity);}
 let mut materials=world.resource_mut::<Assets<Material>>();let mut material=materials.get_mut(&guard.owned).ok_or("actor fade private asset unavailable")?;
 material.base=base;material.extension.opacity=shader_factor(guard.submitted);Ok(true)
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App){app.add_plugins(bevy::pbr::MaterialPlugin::<Material>::default());crate::native_minion_fade_warmup::install(app);}}
#[cfg(test)]#[path="native_minion_fade_material_tests.rs"]mod tests;
