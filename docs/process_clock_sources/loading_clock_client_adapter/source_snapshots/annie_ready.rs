//! Original StunReady texture/fields, with explicitly reconstructed base-skin quad playback.
pub mod live_probe;
pub mod phase_order;
use crate::{terrain_material, Match};
use bevy::{prelude::*, reflect::TypePath, mesh::MeshVertexBufferLayoutRef, pbr::{MaterialPipeline,MaterialPipelineKey}, render::render_resource::{AsBindGroup,RenderPipelineDescriptor,SpecializedMeshPipelineError,BlendState,BlendComponent,BlendFactor,BlendOperation}, shader::ShaderRef};
use std::{collections::HashMap, sync::OnceLock};
fn data()->&'static serde_json::Value {
 static D:OnceLock<serde_json::Value>=OnceLock::new();
 D.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/particles/StunReady.json")).expect("native StunReady"))
}
fn number(name:&str)->f32 {data()["sections"]["ready1"][name].as_f64().unwrap() as f32}
fn vector(name:&str)->Vec3 {let a=data()["sections"]["ready1"][name].as_array().unwrap();Vec3::new(a[0].as_f64().unwrap() as f32,a[1].as_f64().unwrap() as f32,a[2].as_f64().unwrap() as f32)}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
pub struct ReadyMaterial {
 #[uniform(0)] color:Vec4,
 #[uniform(1)] uv_scroll:Vec4,
 #[texture(2)] #[sampler(3)] texture:Handle<Image>,
}
impl Material for ReadyMaterial {
 fn fragment_shader()->ShaderRef {"shaders/annie_ready.wgsl".into()}
 // Keep transparent queue/depth semantics, then bind explicit ALPHAADD factors.
 // Community Troy conversion preserves rendermode; mode4 maps SrcAlpha/One.
 // This cross-version evidence does not qualify original 4.20 runtime fidelity.
 fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
 fn specialize(_pipeline:&MaterialPipeline,descriptor:&mut RenderPipelineDescriptor,_layout:&MeshVertexBufferLayoutRef,_key:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError> {
  descriptor.primitive.cull_mode=None; // Particle quads are two-sided in the referenced renderer.
  if let Some(fragment)=descriptor.fragment.as_mut() {
   for target in fragment.targets.iter_mut().flatten() {target.blend=Some(alpha_add());}
  }
  if let Some(depth)=descriptor.depth_stencil.as_mut() {depth.depth_write_enabled=Some(false);}
  Ok(())
 }
}
// Alpha channel preserved with normal alpha compositing; original alpha factors unqualified.
fn alpha_add()->BlendState {BlendState {color:BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::One,operation:BlendOperation::Add},alpha:BlendComponent::OVER}}
#[derive(Clone,Debug,PartialEq)]
struct Sample {slot:usize,age:f32,alpha:f32,scale:Vec3,rotation:f32,uv:Vec2}
fn samples(age:f32)->Vec<Sample> {
 if !age.is_finite() || age<0. {return vec![];}
 let rate=number("e-rate");let life=number("p-life");let cap=(rate*life).ceil() as usize;
 // Reconstructed first emission at readiness observation; no original birth/RNG clock claim.
 let last=(age as f64*rate as f64).floor() as u64;
 let first=last.saturating_sub(cap as u64);
 let scale=vector("p-scale");let speed=vector("p-rotvel").y.to_radians();
 let mut out=vec![];
 for index in first..=last {
  let t=age-index as f32/rate;if !(0. ..life).contains(&t) {continue;}
  let u=t/life;
  let keys=data()["sections"]["ready1"].as_object().unwrap();
  let mut alpha=0.;
  for pair in [1,2,3].map(|i|(&keys[&format!("p-xrgba{i}")],&keys[&format!("p-xrgba{}",i+1)])) {
   let x=pair.0[0].as_f64().unwrap() as f32;let y=pair.1[0].as_f64().unwrap() as f32;
   if u>=x && u<=y {let a=pair.0[4].as_f64().unwrap() as f32;let b=pair.1[4].as_f64().unwrap() as f32;alpha=a+(b-a)*(u-x)/(y-x);break;}
  }
  let s0=keys["p-xscale1"][1].as_f64().unwrap() as f32;let s1=keys["p-xscale2"][1].as_f64().unwrap() as f32;
  let r0=keys["p-rotvelYP1"][1].as_f64().unwrap() as f32;let r1=keys["p-rotvelYP2"][1].as_f64().unwrap() as f32;
  let v0=keys["p-uvscroll-rgbYP1"][1].as_f64().unwrap() as f32;let v1=keys["p-uvscroll-rgbYP2"][1].as_f64().unwrap() as f32;
  let v=keys["p-uvscroll-rgb"].as_array().unwrap();
  // Integrate linear normalized-lifetime velocity curves. Original integration,
  // emitter-age UV offsets and initial rotation semantics still need qualification.
  out.push(Sample{slot:index as usize%cap,age:t,alpha,scale:scale*(s0+(s1-s0)*u)/20.,rotation:vector("p-quadrot").y.to_radians()+speed*(r0*t+(r1-r0)*t*t/(2.*life)),uv:Vec2::new(v[0].as_f64().unwrap() as f32*t,v[1].as_f64().unwrap() as f32*(v0*t+(v1-v0)*t*t/(2.*life)))});
 }
 out
}
struct Emitter {started:f64,slots:Vec<(Entity,Handle<ReadyMaterial>)>}
#[derive(Resource,Default)]
pub struct Ready {session:Option<u64>,emitters:HashMap<u32,Emitter>,mesh:Option<Handle<Mesh>>,texture:Option<Handle<Image>>}
#[derive(Component,Clone,bevy::render::extract_component::ExtractComponent)]
pub struct ReadyQuad;
#[derive(Resource,Default)]
pub struct Probe {saw_ready:bool,off_at:Option<f64>,written:bool,max_emitters:usize,max_quads:usize,max_visible_quads:usize}
pub fn update(
 mut commands:Commands,time:Res<Time>,clock:Res<crate::native_effect_clock::EffectClock>,state:Res<Match>,assets:Res<AssetServer>,mut meshes:ResMut<Assets<Mesh>>,
 mut materials:ResMut<Assets<ReadyMaterial>>,mut ready:ResMut<Ready>,mut quads:Query<(&mut Transform,&mut Visibility),With<ReadyQuad>>,
 mut probe:ResMut<Probe>,
) {
 let snapshot=state.snapshot.as_ref();
 let session=snapshot.map(|s|s.session);
 let reset=ready.session!=session;ready.session=session;
 let actors:HashMap<_,_>=snapshot.into_iter().flat_map(|s|s.players.iter()).filter(|p|p.champion=="annie"&&p.health>0.&&p.effects.pyromania>=4).map(|p|(p.id,Vec3::new(p.position.x,p.height,p.position.z))).collect();
 let gone:Vec<_>=ready.emitters.keys().copied().filter(|id|reset||!actors.contains_key(id)).collect();
 for id in gone {let emitter=ready.emitters.remove(&id).unwrap();for (entity,handle) in emitter.slots {commands.entity(entity).despawn();materials.remove(handle.id());}}
 if ready.mesh.is_none() {ready.mesh=Some(meshes.add(Rectangle::new(1.,1.)));ready.texture=Some(terrain_material::image(&assets,"particles/annie/AnnieStunReady.png".into(),true));}
 let capacity=(number("e-rate")*number("p-life")).ceil() as usize;
 for (id,position) in actors {
  if !ready.emitters.contains_key(&id) {
   let slots=(0..capacity).map(|slot| {
    let handle=materials.add(ReadyMaterial{color:Vec4::ONE,uv_scroll:Vec4::ZERO,texture:ready.texture.as_ref().unwrap().clone()});
    let entity=commands.spawn((Name::new(format!("StunReady::{id}::{slot}")),Mesh3d(ready.mesh.as_ref().unwrap().clone()),MeshMaterial3d(handle.clone()),Transform::default(),Visibility::Hidden,ReadyQuad,bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();(entity,handle)
   }).collect();ready.emitters.insert(id,Emitter{started:clock.now,slots});
  }
  let emitter=&ready.emitters[&id];
  for (entity,_) in &emitter.slots {if let Ok((_,mut v))=quads.get_mut(*entity) {*v=Visibility::Hidden;}}
  for s in samples((clock.now-emitter.started) as f32) {
   let (entity,handle)=&emitter.slots[s.slot];
   let color=Vec4::new(1.,1.,1.,s.alpha);let uv_scroll=Vec4::new(s.uv.x,s.uv.y,0.,0.);
   // Avoid re-preparing identical GPU materials during a stopped game clock.
   // Writing through AssetMut marks it modified even if values are unchanged.
   if materials.get(handle).is_some_and(|m|m.color!=color || m.uv_scroll!=uv_scroll) {
    if let Some(mut material)=materials.get_mut(handle) {material.color=color;material.uv_scroll=uv_scroll;}
   }
   if let Ok((mut transform,mut visibility))=quads.get_mut(*entity) {
    *transform=Transform::from_translation((position+vector("p-offset"))/20.).with_rotation(Quat::from_euler(EulerRot::YXZ,s.rotation,vector("p-quadrot").x.to_radians(),0.)).with_scale(s.scale);
    *visibility=Visibility::Inherited;
   }
  }
 }
 if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var_os("OPENLEAGUE_READY_PROBE").is_some() {
  if !ready.emitters.is_empty() {probe.saw_ready=true;probe.max_emitters=probe.max_emitters.max(ready.emitters.len());probe.max_quads=probe.max_quads.max(quads.iter().count());probe.max_visible_quads=probe.max_visible_quads.max(quads.iter().filter(|(_,v)|**v!=Visibility::Hidden).count());}
  if probe.saw_ready && ready.emitters.is_empty() && probe.off_at.is_none() {probe.off_at=Some(time.elapsed_secs_f64());}
  if !probe.written && probe.off_at.is_some_and(|t|time.elapsed_secs_f64()-t>=0.5) {
   let path=std::env::var("OPENLEAGUE_READY_PROBE").unwrap();let p=std::path::Path::new(&path);
   assert_eq!(p.parent(),Some(std::path::Path::new(r"E:\OpenLeague\logs")),"diagnostic path restricted to logs");
   let off=p.with_extension("png");
   commands.spawn(bevy::render::view::screenshot::Screenshot::primary_window()).observe(bevy::render::view::screenshot::save_to_disk(off));
   let record=serde_json::json!({"diagnostic":true,"ready_seen":true,"emitters_after_consume":ready.emitters.len(),"remaining_particle_materials":materials.len(),"remaining_quads":quads.iter().count(),"max_emitters":probe.max_emitters,"max_quads":probe.max_quads,"max_visible_quads":probe.max_visible_quads,"capacity_per_emitter":capacity,"texture":"particles/annie/AnnieStunReady.png","native_shader_formula":"QUAD_PS_FixedAlphaUV.ps_2_0","blend_state_original_qualified":false,"color_blend":"SrcAlpha/One/Add","blend_basis":"ReyEngine Troy identity mapping and VfxBlend mode4; cross-version community evidence","tick":snapshot.map(|s|s.tick)});
   std::fs::write(p,serde_json::to_vec_pretty(&record).unwrap()).expect("ready diagnostic write");probe.written=true;
  }
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[cfg(windows)]
 #[test] fn native_pause_freezes_ready_emission_rotation_and_uv_then_resumes() {
  let mut app=App::new();app.add_plugins(crate::native_effect_clock::Plugin);app.update();app.update();
  let start=app.world().resource::<crate::native_effect_clock::EffectClock>().now-1.;
  let before=samples((app.world().resource::<crate::native_effect_clock::EffectClock>().now-start) as f32);
  let mut packet=vec![0;14];packet[9..13].copy_from_slice(&30i32.to_le_bytes());packet[13]=1;
  app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(1,0xa1,&packet).unwrap();
  for _ in 0..12 {app.update();assert_eq!(samples((app.world().resource::<crate::native_effect_clock::EffectClock>().now-start) as f32),before);}
  app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(2,0x0a,&[0;10]).unwrap();app.update();
  assert_ne!(samples((app.world().resource::<crate::native_effect_clock::EffectClock>().now-start) as f32),before);
 }
 #[test] fn emission_is_bounded_after_skipped_frames_and_exact_lifetime_rollover() {
  assert_eq!(samples(0.).len(),1);assert_eq!(samples(0.249).len(),1);assert_eq!(samples(0.25).len(),2);assert_eq!(samples(2.499).len(),10);assert_eq!(samples(2.5).len(),10);
  for age in [0.,0.25,1.,2.5,600.,7200.] {let s=samples(age);assert!(s.len()<=10);let mut slots:Vec<_>=s.iter().map(|s|s.slot).collect();slots.sort();slots.dedup();assert_eq!(slots.len(),s.len());assert!(s.iter().all(|s|s.age>=0.&&s.age<2.5));}
  assert!(samples(f32::NAN).is_empty());assert!(samples(-1.).is_empty());
 }
 #[test] fn native_alpha_envelope_fixed_alpha_uv_and_integrated_velocity_are_independent() {
  let at=|age:f32|samples(age).into_iter().find(|s|s.slot==0).unwrap();
  let born=at(0.);assert_eq!(born.alpha,0.);assert_eq!(born.scale,Vec3::splat(5.));
  let half=at(0.25);assert!((half.alpha-0.5).abs()<1e-6);assert!((half.uv.x-0.05).abs()<1e-6);assert!((half.uv.y-0.071875).abs()<1e-6);
  assert_eq!(at(0.5).alpha,1.);assert_eq!(at(1.75).alpha,1.);assert!((at(2.).alpha-2./3.).abs()<1e-6);
  assert_eq!(data()["sections"]["ready1"]["p-uvscroll-no-alpha"],1);assert_eq!(number("p-life"),2.5);assert_eq!(number("e-rate"),4.);
 }
}
