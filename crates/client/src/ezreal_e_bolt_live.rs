//! Three original E groups, visible-current episodes only. All native arithmetic
//! and the explicitly named local bindings are prepared before asset publication.
use std::collections::BTreeMap;
use bevy::{prelude::*,camera::primitives::MeshAabb,render::batching::NoAutomaticBatching};
use crate::{ezreal_e_bolt_presentation::CurrentE,ezreal_e_bolt_simulation::{self as simulation,Identity,Profiles,State},
    ezreal_e_bolt_draw as simple_draw,ezreal_e_complex_draw as complex_draw,
    ezreal_e_bolt_material::StrictMaterial as SimpleMaterial,ezreal_e_complex_material::StrictMaterial as ComplexMaterial,
    ezreal_e_bolt_quad_material::EQuadMaterial,ezreal_e_bolt_images,ezreal_e_bolt_geometry as geometry,
    ezreal_e_simple_parameters::Group,nexus_glow_material::Inputs,nexus_complex_material::{Cull,OutputEncoding}};
#[derive(Resource)]
struct Profile {simulation:Profiles,images:ezreal_e_bolt_images::Images}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut images:ResMut<Assets<Image>>){
    match Profiles::load(){Ok(simulation)=>{commands.insert_resource(Profile{simulation,images:ezreal_e_bolt_images::Images::load(&assets,&mut images)});},
        Err(error)=>warn!("E current profile unavailable: {error}")}
}
type Key=(Identity,u8);
#[derive(Component)]
struct Owned;
enum Material {Simple(Handle<SimpleMaterial>),Complex(Handle<ComplexMaterial>)}
struct Draw {entity:Entity,mesh:Handle<Mesh>,material:Material,geometry:(u64,[u32;16])}
#[derive(Resource,Default)]
struct Live {state:State,rows:BTreeMap<Key,Draw>,revision:u64,last_error:Option<&'static str>}
#[derive(Clone)]
struct Frame {frontier:simple_draw::Frontier,visibility:Handle<Image>,extent:f32,view:[f32;16],clock:f64,ready:bool}
enum PreparedMaterial {Simple(SimpleMaterial),Complex(ComplexMaterial)}
fn material(profile:&Profile,frame:&Frame,group:u8)->Result<PreparedMaterial,&'static str>{
    let mut inner=EQuadMaterial::new(profile.images.textures.get(group as usize).ok_or("E group outside original order")?,
        frame.visibility.clone(),profile.images.overlay.clone(),Inputs{native_fog_extent:frame.extent,
            encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,render_mode:0,render_flags:0,shader_features:0})?;
    inner.set_admitted(true);
    if group==0{let strict=ComplexMaterial::new(inner);strict.source_key().ok_or("E Complex source key invalid")?;
        Ok(PreparedMaterial::Complex(strict))}
    else{let strict=SimpleMaterial::new(inner);strict.source_key().ok_or("E Simple source key invalid")?;
        Ok(PreparedMaterial::Simple(strict))}
}
fn release(draw:Draw,commands:&mut Commands,meshes:&mut Assets<Mesh>,simple:&mut Assets<SimpleMaterial>,complex:&mut Assets<ComplexMaterial>){
    commands.entity(draw.entity).try_despawn();meshes.remove(draw.mesh.id());
    match draw.material{Material::Simple(h)=>{simple.remove(h.id());},Material::Complex(h)=>{complex.remove(h.id());}}
}
fn clear(live:&mut Live,simple_current:&mut simple_draw::Current,complex_current:&mut complex_draw::Current,
    commands:&mut Commands,meshes:&mut Assets<Mesh>,simple:&mut Assets<SimpleMaterial>,complex:&mut Assets<ComplexMaterial>){
    simple_current.invalidate();complex_current.invalidate();live.state.reject_active();
    for (_,draw) in std::mem::take(&mut live.rows){release(draw,commands,meshes,simple,complex);}
}
type OwnedQuery<'w,'s>=Query<'w,'s,(&'static Mesh3d,Option<&'static MeshMaterial3d<SimpleMaterial>>,
    Option<&'static MeshMaterial3d<ComplexMaterial>>,&'static Transform,&'static GlobalTransform,
    Has<NoAutomaticBatching>,Has<ChildOf>),With<Owned>>;
fn synchronize(commands:&mut Commands,live:&mut Live,simple_current:&mut simple_draw::Current,
    complex_current:&mut complex_draw::Current,meshes:&mut Assets<Mesh>,simple:&mut Assets<SimpleMaterial>,complex:&mut Assets<ComplexMaterial>,
    profile:&Profile,frame:&Frame,samples:&[CurrentE],owned:&OwnedQuery,base_model:bool)->Result<(),&'static str>{
    if !frame.ready||!base_model{return Err("E current boundary/base model unavailable");}
    let context=(frame.frontier.source.session,frame.frontier.accepted_epoch);
    let plan=live.state.plan(samples,frame.clock,context,&profile.simulation)?;
    let mut prepared=Vec::new();
    for (id,entry) in &plan.rows{
        // Preserve the original group sequence and use separate strict tables
        // only because their material ownership types differ.
        for group in 0..3u8{
            let mesh=match group{0=>geometry::complex(entry.complex.particles(),frame.view)?,
                1=>geometry::simple(&entry.simple[0],Group::Magicdust,frame.view)?,
                _=>geometry::simple(&entry.simple[1],Group::Dust,frame.view)?};
            let Some(mesh)=mesh else{continue;};let bounds=mesh.compute_aabb().ok_or("E mesh bounds invalid")?;
            prepared.push(((*id,group),mesh,bounds,material(profile,frame,group)?));
        }
    }
    let revision=live.revision.checked_add(1).ok_or("E draw revision exhausted")?;
    for draw in live.rows.values(){
        let valid=owned.get(draw.entity).is_ok_and(|(mesh,s,c,t,g,no_batch,parent)|{
            let binding=match &draw.material{Material::Simple(h)=>simple.contains(h.id())&&c.is_none()&&s.is_some_and(|v|v.0.id()==h.id()),
                Material::Complex(h)=>complex.contains(h.id())&&s.is_none()&&c.is_some_and(|v|v.0.id()==h.id())};
            binding&&mesh.0.id()==draw.mesh.id()&&*t==Transform::IDENTITY&&*g==GlobalTransform::IDENTITY&&no_batch&&!parent});
        if !meshes.contains(draw.mesh.id())||!valid{return Err("E owned draw was changed");}
    }
    let retired:Vec<_>=live.rows.keys().filter(|k|!prepared.iter().any(|row|row.0==**k)).copied().collect();
    for key in retired{release(live.rows.remove(&key).unwrap(),commands,meshes,simple,complex);}
    let mut simple_requests=Vec::new();let mut complex_requests=Vec::new();
    for (key,mesh,bounds,material) in prepared{
        let geometry=(frame.clock.to_bits(),frame.view.map(f32::to_bits));
        if let Some(draw)=live.rows.get_mut(&key){
            if draw.geometry!=geometry{
                let replacement=meshes.add(mesh);meshes.remove(draw.mesh.id());draw.mesh=replacement;draw.geometry=geometry;
                commands.entity(draw.entity).insert((Mesh3d(draw.mesh.clone()),bounds));
            }
            match (&draw.material,material){
                (Material::Simple(h),PreparedMaterial::Simple(value))=>*simple.get_mut(h).ok_or("E Simple material lost")?=value,
                (Material::Complex(h),PreparedMaterial::Complex(value))=>*complex.get_mut(h).ok_or("E Complex material lost")?=value,
                _=>return Err("E material ownership type changed"),
            }
        }else{
            let mesh=meshes.add(mesh);let mut entity=commands.spawn((Owned,Mesh3d(mesh.clone()),bounds,Transform::IDENTITY,
                GlobalTransform::IDENTITY,Visibility::Inherited,NoAutomaticBatching,bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver));
            let material=match material{PreparedMaterial::Simple(value)=>{let h=simple.add(value);entity.insert(MeshMaterial3d(h.clone()));Material::Simple(h)},
                PreparedMaterial::Complex(value)=>{let h=complex.add(value);entity.insert(MeshMaterial3d(h.clone()));Material::Complex(h)}};
            live.rows.insert(key,Draw{entity:entity.id(),mesh,material,geometry});
        }
        let draw=&live.rows[&key];match &draw.material{
            Material::Simple(h)=>simple_requests.push(simple_draw::Request{entity:draw.entity,material:h.clone(),pool_incarnation:key.0.incarnation,input_revision:revision}),
            Material::Complex(h)=>complex_requests.push(complex_draw::Request{entity:draw.entity,material:h.clone(),pool_incarnation:key.0.incarnation,input_revision:revision}),
        }
    }
    simple_current.replace(frame.frontier.clone(),simple_requests)?;
    complex_current.replace(complex_draw::Frontier{source:frame.frontier.source.clone(),accepted_epoch:frame.frontier.accepted_epoch,
        camera:frame.frontier.camera},complex_requests)?;
    live.state=plan;live.revision=revision;Ok(())
}
fn update(mut commands:Commands,
    inputs:(Res<crate::native_effect_clock::EffectClock>,Res<crate::Match>,Res<crate::Connection>,
        Res<crate::fow_champion_sources::Sources>,Res<crate::map10_vision_view::Map10VisionView>,
        Res<crate::fow_visibility_texture::VisibilityTexture>,Res<crate::fow_gpu::Images>,
        Res<crate::camera_native::NativeCamera>,Res<crate::animation::Catalog>),
    profile:Option<Res<Profile>>,images:Res<Assets<Image>>,mut meshes:ResMut<Assets<Mesh>>,
    mut simple:ResMut<Assets<SimpleMaterial>>,mut complex:ResMut<Assets<ComplexMaterial>>,mut live:ResMut<Live>,
    mut simple_current:ResMut<simple_draw::Current>,mut complex_current:ResMut<complex_draw::Current>,
    cameras:Query<(Entity,&Camera),With<Camera3d>>,owned:OwnedQuery){
    let (clock,state,connection,sources,map,texture,gpu,native_camera,catalog)=inputs;
    let mut attempted=None;
    let result=(||{
        let profile=profile.as_deref().ok_or("E profile unavailable")?;profile.images.validate(&images)?;
        let (session,viewer,Some(epoch))=connection.inventory_input_identity().ok_or("E current session unavailable")?
            else{return Err("E requires atomic OLSR");};
        if !connection.ready()||!clock.presentation_ready()||clock.paused()||!clock.now.is_finite(){return Err("E clock/connection unavailable");}
        let snapshot=state.snapshot.as_ref().ok_or("E snapshot absent")?;
        if snapshot.session!=session||snapshot.winner.is_some(){return Err("E session ended");}
        let samples=state.ezreal_e_bolts.samples(snapshot,viewer,session,Some(epoch),clock.now,clock.paused(),true);
        attempted=Some((samples.clone(),(session,epoch)));
        let team=snapshot.roster.iter().find(|p|p.id==viewer).ok_or("E viewer absent")?.team;
        let mut active=cameras.iter().filter(|(_,c)|c.is_active);let (camera,_)=active.next().ok_or("E camera absent")?;
        if active.next().is_some(){return Err("E camera ambiguous");}
        let source=sources.mask_stamp(&map,session,team).ok_or("E FoW source absent")?;
        if source.represented_tick!=snapshot.tick{return Err("E FoW tick stale");}
        let publication=texture.publication_for(&sources,&map,session,team).ok_or("E FoW publication absent")?;
        if !publication.source.same_episode(&source)||!images.contains(gpu.output.id()){return Err("E FoW episode/output unavailable");}
        let uniforms=texture.settings.shader_parameters(map.geometry.extent).map_err(|_|"E FoW parameters invalid")?;
        if Vec4::from_array(uniforms.coordinates)!=crate::native_fow::FogParams::from_native_extent(map.geometry.extent)?.params(){return Err("E FoW coordinate policy unsupported");}
        let view=openleague_core::camera_view::from_parameters(native_camera.native_parameters().ok_or("E camera parameters unavailable")?)?;
        let frame=Frame{frontier:simple_draw::Frontier{source,accepted_epoch:epoch,camera},visibility:gpu.output.clone(),
            extent:map.geometry.extent,view,clock:clock.now,ready:true};
        synchronize(&mut commands,&mut live,&mut simple_current,&mut complex_current,&mut meshes,&mut simple,&mut complex,
            profile,&frame,&samples,&owned,catalog.r_sparks_base_model_selected())
    })();
    if let Err(error)=result{
        if let Some((samples,context))=attempted{live.state.reject(&samples,clock.now,context);}
        clear(&mut live,&mut simple_current,&mut complex_current,&mut commands,&mut meshes,&mut simple,&mut complex);
        if live.last_error!=Some(error){debug!("{} waiting: {error}",crate::ezreal_e_bolt_local::POLICY);live.last_error=Some(error);}
    }else{live.last_error=None;}
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin{
    fn build(&self,app:&mut App){app.init_resource::<Live>().add_systems(Startup,setup)
        .add_systems(PostUpdate,update.after(bevy::asset::AssetEventSystems)
            .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
            .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}
}
#[cfg(test)]
#[path="ezreal_e_bolt_live_tests.rs"]
mod tests;
