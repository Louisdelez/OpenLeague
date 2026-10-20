//! Bounded impact group3 Simple→QUAD adapter, separate from missile Sparks. Strict same-draw FoW
//! authorization is independent of the frozen contact and its local lifetime.
use bevy::{asset::RenderAssetUsages, camera::primitives::MeshAabb,
    image::{ImageAddressMode,ImageFilterMode,ImageLoaderSettings,ImageSampler,ImageSamplerDescriptor},
    mesh::{Indices,PrimitiveTopology}, prelude::*, render::{batching::NoAutomaticBatching,
        render_resource::{TextureDimension,TextureFormat}}};
use std::collections::BTreeMap;
use crate::{ezreal_e_release_events::{Identity as Key,Request as EventRequest,State as Events},
    ezreal_e_release_profile::{self as authored,Profile as Authored},
    ezreal_e_release_simulation::{self as simulation,State},
    ezreal_e_release_draw::{Current,Frontier,Request},ezreal_e_release_material::StrictMaterial,
    ezreal_r_flash_quad_material::FlashQuadMaterial,nexus_glow_material::{Textures,Inputs},nexus_complex_material::{Cull,OutputEncoding}};
const IMAGE_BYTES:[&[u8];2]=[include_bytes!("../../../assets/particles/ezreal/e_release_flashes/flare-sun_orange.dds"),
    include_bytes!("../../../assets/particles/ezreal/e_release_flashes/flare-sun.dds")];
const COLOR_BYTES:&[u8]=include_bytes!("../../../assets/particles/ezreal/e_release_flashes/color-hold.dds");
#[derive(Resource)]
struct Profile {authored:Authored,textures:[Textures;2],overlay:Handle<Image>}
fn samplers()->[ImageSamplerDescriptor;2]{
    // Named local sampler: no native sampling-state equivalence is claimed.
    let s=ImageSamplerDescriptor{address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,
        address_mode_w:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,
        mipmap_filter:ImageFilterMode::Linear,..default()};[s.clone(),s]
}
impl Profile {
    fn validate(&self,images:&Assets<Image>)->Result<(),&'static str>{
        for (i,textures) in self.textures.iter().enumerate(){
            for (handle,bytes,size,mips,format,sampler) in [
                (&textures.image,IMAGE_BYTES[i],if i==0{128}else{256},if i==0{8}else{9},TextureFormat::Bc3RgbaUnorm,&textures.samplers[0]),
                (&textures.color,COLOR_BYTES,8,1,TextureFormat::Bc1RgbaUnorm,&textures.samplers[1])]{
                let image=images.get(handle).ok_or("E release DDS unavailable")?;let d=&image.texture_descriptor;
                if d.dimension!=TextureDimension::D2||d.size.width!=size||d.size.height!=size||d.size.depth_or_array_layers!=1
                    ||d.mip_level_count!=mips||d.format!=format||image.data.as_deref()!=Some(&bytes[128..])
                    ||!matches!(&image.sampler,ImageSampler::Descriptor(actual) if actual==sampler){return Err("E release exact DDS changed");}
            }
        }
        if !images.contains(self.overlay.id()){return Err("E release overlay unavailable");}Ok(())
    }
}
fn setup(mut commands:Commands,assets:Res<AssetServer>){
    match Authored::load(){Ok(authored)=>{
        let load=|path:&'static str,sampler:ImageSamplerDescriptor|assets.load_builder().with_settings(move|s:&mut ImageLoaderSettings|{
            s.is_srgb=false;s.sampler=ImageSampler::Descriptor(sampler.clone());}).load(path);
        let textures=std::array::from_fn(|i|{let samplers=samplers();Textures{
            image:load(authored::IMAGES[i],samplers[0].clone()),color:load(authored::COLOR,samplers[1].clone()),samplers}});
        commands.insert_resource(Profile{authored,textures,overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png")});
    },Err(e)=>warn!("E release profile unavailable: {e}")}
}
#[derive(Component)]
struct Owned;
struct Draw {entity:Entity,mesh:Handle<Mesh>,material:Handle<StrictMaterial>,incarnation:u64,
    geometry:(u64,u64,[u32;16])}
#[derive(Resource,Default)]
struct Live {state:State,rows:BTreeMap<Key,Draw>,revision:u64,last_error:Option<&'static str>}
#[derive(Clone)]
struct Frame {frontier:Frontier,visibility:Handle<Image>,extent:f32,view:[f32;16],clock:f64}
fn material(profile:&Profile,frame:&Frame,phase:openleague_core::ezreal_e_accepted_releases::Phase) -> Result<StrictMaterial,&'static str> {
    let mut inner=FlashQuadMaterial::new(&profile.textures[authored::phase_index(phase)],frame.visibility.clone(),profile.overlay.clone(),
        Inputs {native_fog_extent:frame.extent,encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,
            render_mode:0,render_flags:1,shader_features:0})?;
    inner.set_admitted(true); let strict=StrictMaterial::new(inner);
    strict.source_key().ok_or("E release flash source key invalid")?; Ok(strict)
}
fn geometry(entry:&simulation::Entry,view:[f32;16])->Result<Mesh,&'static str>{
    crate::ezreal_e_bolt_geometry::simple(&entry.particles,crate::ezreal_e_simple_parameters::Group::ReleaseFlash,view)?
        .ok_or("E release live particle geometry absent")
}
fn release(draw:Draw,commands:&mut Commands,meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>) {
    commands.entity(draw.entity).try_despawn();meshes.remove(draw.mesh.id());materials.remove(draw.material.id());
}
fn clear(live:&mut Live,current:&mut Current,commands:&mut Commands,
    meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>) {
    current.invalidate();live.state=State::default();
    for (_,draw) in std::mem::take(&mut live.rows) {release(draw,commands,meshes,materials);}
}
type OwnedQuery<'w,'s> = Query<'w,'s,(&'static Mesh3d,&'static MeshMaterial3d<StrictMaterial>,
    &'static Transform,&'static GlobalTransform,Has<NoAutomaticBatching>,Has<ChildOf>),With<Owned>>;
fn synchronize(commands:&mut Commands,live:&mut Live,current:&mut Current,
    meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>,profile:&Profile,frame:&Frame,
    events:&Events,requests:&[EventRequest],paused:bool,owned:&OwnedQuery,base_model_selected:bool) -> Result<(),&'static str> {
    if !base_model_selected {return Err("E release flash restored base model not selected");}
    if !events.context().is_some_and(|(session,epoch,_)|session==frame.frontier.source.session && epoch==frame.frontier.accepted_epoch) {
        return Err("E release flash authority/frontier mismatch");
    }
    let plan=live.state.plan(events,requests,frame.clock,paused,&profile.authored,simulation::map10_height)?;
    let mut prepared=Vec::new();
    for (key,entry) in &plan.rows {
        if entry.particles.live_indices().next().is_none(){continue;}
        let mesh=geometry(entry,frame.view)?;
        let bounds=mesh.compute_aabb().ok_or("E release flash mesh bounds invalid")?;
        prepared.push((*key,entry.request.incarnation(),mesh,bounds,material(profile,frame,entry.request.phase)?));
    }
    let revision=live.revision.checked_add(1).ok_or("E release flash revision exhausted")?;
    // Preparation has no externally committed RNG or particles. Check all owned
    // references before altering assets. A failed frame clears only this host.
    for draw in live.rows.values() {
        if !meshes.contains(draw.mesh.id()) || !materials.contains(draw.material.id())
            || !owned.get(draw.entity).is_ok_and(|(mesh,material,t,g,no_batch,parent)|
                mesh.0.id()==draw.mesh.id() && material.0.id()==draw.material.id()
                && *t==Transform::IDENTITY && *g==GlobalTransform::IDENTITY && no_batch && !parent) {
            return Err("E release flash owned draw changed");
        }
    }
    let retired:Vec<_>=live.rows.keys().filter(|key|!prepared.iter().any(|p|p.0==**key)).copied().collect();
    for key in retired {release(live.rows.remove(&key).unwrap(),commands,meshes,materials);}
    let mut requests=Vec::new();
    for (key,incarnation,mesh,bounds,material) in prepared {
        if live.rows.get(&key).is_some_and(|old|old.incarnation!=incarnation) {
            release(live.rows.remove(&key).unwrap(),commands,meshes,materials);
        }
        let geometry=(frame.frontier.accepted_epoch,frame.clock.to_bits(),frame.view.map(f32::to_bits));
        if let Some(draw)=live.rows.get_mut(&key) {
            if draw.geometry!=geometry {
                // A changed population/camera gets a NEW AssetId. RenderAssets
                // cannot substitute the preceding GPU mesh while upload waits.
                let replacement=meshes.add(mesh);meshes.remove(draw.mesh.id());
                draw.mesh=replacement;draw.geometry=geometry;
                commands.entity(draw.entity).insert((Mesh3d(draw.mesh.clone()),bounds));
            }
            *materials.get_mut(draw.material.id()).ok_or("E release flash material disappeared")?=material;
        } else {
            let mesh=meshes.add(mesh);let material=materials.add(material);
            let entity=commands.spawn((Owned,Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),bounds,
                Transform::IDENTITY,GlobalTransform::IDENTITY,Visibility::Inherited,NoAutomaticBatching,
                bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();
            live.rows.insert(key,Draw {entity,mesh,material,incarnation,geometry});
        }
        let draw=&live.rows[&key];requests.push(Request {entity:draw.entity,material:draw.material.clone(),
            pool_incarnation:incarnation,input_revision:revision});
    }
    current.replace(frame.frontier.clone(),requests)?;
    live.state=plan;live.revision=revision;Ok(())
}
fn update(mut commands:Commands,
    inputs:(Res<crate::native_effect_clock::EffectClock>,Res<crate::Match>,Res<crate::Connection>,
        Res<crate::fow_champion_sources::Sources>,Res<crate::map10_vision_view::Map10VisionView>,
        Res<crate::fow_visibility_texture::VisibilityTexture>,Res<crate::fow_gpu::Images>,
        Res<crate::camera_native::NativeCamera>,Res<crate::animation::Catalog>),
    batch:Res<crate::ezreal_e_release_dispatch::Batch>,frame_number:Res<bevy::diagnostic::FrameCount>,
    profile:Option<Res<Profile>>,images:Res<Assets<Image>>,mut meshes:ResMut<Assets<Mesh>>,
    mut materials:ResMut<Assets<StrictMaterial>>,mut live:ResMut<Live>,mut current:ResMut<Current>,
    cameras:Query<(Entity,&Camera),With<Camera3d>>,owned:OwnedQuery) {
    let (clock,state,connection,sources,map,texture,gpu,native_camera,catalog)=inputs;
    // The dedicated E dispatcher drains once; no other effect queue is read.
    let result=(|| {
        let requests=batch.requests(frame_number.0,clock.now,&state.ezreal_e_release_events)?;
        let profile=profile.as_deref().ok_or("E release flash profile unavailable")?;
        profile.validate(&images)?;
        let (session,viewer,Some(epoch))=connection.inventory_input_identity().ok_or("E release flash session unavailable")?
            else {return Err("E release flash requires atomic OLSR");};
        if !connection.ready() || !clock.presentation_ready() || !clock.now.is_finite() {return Err("E release flash clock unavailable");}
        let snapshot=state.snapshot.as_ref().ok_or("E release flash snapshot absent")?;
        if snapshot.session!=session || snapshot.winner.is_some() || snapshot.result.is_some() || snapshot.map10.is_none() {return Err("E release flash session ended");}
        let team=snapshot.roster.iter().find(|p|p.id==viewer).ok_or("E release flash viewer absent")?.team;
        let mut active=cameras.iter().filter(|(_,camera)|camera.is_active);
        let (camera,_)=active.next().ok_or("E release flash camera absent")?;
        if active.next().is_some() {return Err("E release flash camera ambiguous");}
        let source=sources.mask_stamp(&map,session,team).ok_or("E release flash FoW source absent")?;
        if source.represented_tick!=snapshot.tick {return Err("E release flash FoW tick stale");}
        let publication=texture.publication_for(&sources,&map,session,team).ok_or("E release flash FoW publication absent")?;
        if !publication.source.same_episode(&source) || !images.contains(gpu.output.id()) {
            return Err("E release flash FoW episode/output unavailable");
        }
        let uniforms=texture.settings.shader_parameters(map.geometry.extent).map_err(|_|"E release flash FoW parameters invalid")?;
        if Vec4::from_array(uniforms.coordinates)!=crate::native_fow::FogParams::from_native_extent(map.geometry.extent)?.params() {
            return Err("E release flash unsupported FoW coordinate policy");
        }
        let view=openleague_core::camera_view::from_parameters(native_camera.native_parameters()
            .ok_or("E release flash native camera not ready")?)?;
        let frame=Frame {frontier:Frontier {source,accepted_epoch:epoch,camera},visibility:gpu.output.clone(),
            extent:map.geometry.extent,view,clock:clock.now};
        let events=&state.ezreal_e_release_events;
        if events.context()!=Some((session,epoch,viewer)) {return Err("E release flash event context changed");}
        synchronize(&mut commands,&mut live,&mut current,&mut meshes,&mut materials,profile,&frame,
            events,requests,clock.paused(),&owned,catalog.r_sparks_base_model_selected())
    })();
    if let Err(error)=result {
        clear(&mut live,&mut current,&mut commands,&mut meshes,&mut materials);
        if live.last_error!=Some(error) {debug!("{} waiting: {error}",authored::POLICY);live.last_error=Some(error);}
    } else {live.last_error=None;}
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Live>().add_systems(Startup,setup)
            .add_systems(PostUpdate,update.after(crate::ezreal_e_release_dispatch::Dispatch).after(bevy::asset::AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));
    }
}

#[cfg(test)]
#[path="ezreal_e_release_live_tests.rs"]
mod tests;
