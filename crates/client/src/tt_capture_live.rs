//! Active own-client TT Capture presentation. No Odin profile/admission mutation.
//! Numerical source facts are separate from local clock/seed/global adapters.
use bevy::{prelude::*,asset::{AssetId,AssetEvent,AssetEventSystems},ecs::message::MessageCursor,
    image::{ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode,CompressedImageFormats},
    camera::primitives::MeshAabb};
use std::collections::{BTreeMap,HashSet};
use openleague_core::{native_random::Rng55,native_complex_quad_binding as binding,native_complex_type0_quad as quad};
use crate::{relic_pickup_events as events,tt_capture_sampler as sampler,tt_capture_state as state,
    tt_capture_material::CaptureMaterial,relic_image_reference_store::{Store,Lease},relic_rune_image_bindings::{Bindings,Source}};

pub const SPARK:&[u8]=include_bytes!("../../../assets/particles/relic_runes/Soraka_Heal_Sparkle_Green.dds");
pub const COLOR:&[u8]=include_bytes!("../../../assets/particles/relic_runes/color-bellcurve.DDS");
const OVERLAY:&str="maps/terrain_native/DefaultFogOfWarOverlay.png";
#[derive(Clone)]
struct Effect {owner:events::Binding,emitters:[state::Emitter;2]}
#[derive(Resource)]
struct Host {profiles:[sampler::Profile;2],rotations:[Vec<sampler::RotationSource>;2],
    rng:Rng55,effects:BTreeMap<events::Key,Effect>,ordinal:u64,last_clock:Option<f64>}
#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub pending:Option<String>,pub ordinal:u64,
    pub events:usize,pub particles:usize,pub draws:usize,pub completed:u64,pub retired:u64,
    pub rng_seed:Option<u32>,pub normal_cleanup:Option<bool>}
#[derive(Component,Clone,Debug,PartialEq,Eq)]
pub struct Ticket {pub key:events::Key,pub owner:events::Binding,pub group:usize,pub birth:u32,
    pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:AssetId<CaptureMaterial>,pub images:[AssetId<Image>;4],pub layouts:[ImageLayout;2]}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct ImageLayout {pub extent:[u32;3],pub mips:u32,pub format:bevy::render::render_resource::TextureFormat}
struct Owned {ticket:Ticket,mesh:Handle<Mesh>,material:Handle<CaptureMaterial>}
struct Prepared {key:events::Key,owner:events::Binding,group:usize,birth:u32,mesh:Mesh,
    bounds:bevy::camera::primitives::Aabb,material:CaptureMaterial,images:[AssetId<Image>;4],layouts:[ImageLayout;2]}
#[derive(Resource,Default)]
pub struct Backend {draws:Vec<Owned>,store:Store,bindings:Option<Bindings>,overlay:Handle<Image>,
    failed_leases:Vec<Lease>,cursor:MessageCursor<AssetEvent<Image>>,watched:Vec<AssetId<Image>>,
    invalidated:bool,pub error:Option<String>,pub published_frames:u64}
impl Backend {
    pub fn tickets(&self)->Vec<Ticket>{self.draws.iter().map(|d|d.ticket.clone()).collect()}
    fn matches(world:&World,d:&Owned)->bool {
        world.get::<Ticket>(d.ticket.draw)==Some(&d.ticket)
            &&world.get::<Mesh3d>(d.ticket.draw).map(|m|m.id())==Some(d.ticket.mesh)
            &&world.get::<MeshMaterial3d<CaptureMaterial>>(d.ticket.draw).map(|m|m.id())==Some(d.ticket.material)
            &&world.get::<ChildOf>(d.ticket.draw).is_none()
            &&world.get::<Transform>(d.ticket.draw)==Some(&Transform::IDENTITY)
            &&world.get::<GlobalTransform>(d.ticket.draw)==Some(&GlobalTransform::IDENTITY)
            &&world.get::<Visibility>(d.ticket.draw).is_some()
    }
    fn hide(&self,world:&mut World) {
        for d in &self.draws {if Self::matches(world,d) {
            if let Some(mut v)=world.get_mut::<Visibility>(d.ticket.draw){*v=Visibility::Hidden;}
            if let Some(mut assets)=world.get_resource_mut::<Assets<CaptureMaterial>>(){
                if let Some(mut m)=assets.get_mut(&d.material){m.set_admitted(false);}
            }
        }}
    }
    fn clear_draws(&mut self,world:&mut World)->Result<(),String> {
        self.hide(world);let mut retained=Vec::new();
        for d in self.draws.drain(..) {
            if !Self::matches(world,&d) {retained.push(d);continue;}
            world.despawn(d.ticket.draw);
            if let Some(mut a)=world.get_resource_mut::<Assets<Mesh>>(){a.remove(d.mesh.id());}
            if let Some(mut a)=world.get_resource_mut::<Assets<CaptureMaterial>>(){a.remove(d.material.id());}
        }
        self.draws=retained;
        if self.draws.is_empty(){Ok(())}else{Err("TT Capture foreign draw ownership retained; image leases not released".into())}
    }
    // Lost event/root/model ownership must retire draws even with a failed clock.
    // Foreign components remain owned until restored; no shared entity is removed.
    fn retire_effects(&mut self,world:&mut World,effects:&BTreeMap<events::Key,Effect>)->Result<(),String> {
        let mut retained=Vec::new();let mut foreign=false;
        for d in self.draws.drain(..) {
            if effects.get(&d.ticket.key).is_some_and(|e|e.owner==d.ticket.owner) {
                retained.push(d);continue;
            }
            if !Self::matches(world,&d) {foreign=true;retained.push(d);continue;}
            world.despawn(d.ticket.draw);
            if let Some(mut assets)=world.get_resource_mut::<Assets<Mesh>>(){assets.remove(d.mesh.id());}
            if let Some(mut assets)=world.get_resource_mut::<Assets<CaptureMaterial>>(){assets.remove(d.material.id());}
        }
        self.draws=retained;
        if foreign {Err("TT Capture lost event has foreign draw ownership; retained for safe cleanup".into())} else {Ok(())}
    }
    fn release(&mut self,world:&mut World)->Result<(),String> {
        self.clear_draws(world)?;
        let mut assets=world.get_resource_mut::<Assets<Image>>().ok_or("TT Capture image assets absent at release")?;
        if let Some(bindings)=self.bindings.take(){if let Err(error)=bindings.retire(&mut self.store,&mut assets){
            self.failed_leases.extend(error.leases);return Err(error.message);
        }}
        let mut failed=Vec::new();for lease in self.failed_leases.drain(..){
            if let Err(error)=self.store.release(lease,&mut assets){failed.push(error.lease);}
        }self.failed_leases=failed;
        if !self.failed_leases.is_empty(){return Err("TT Capture failed image leases remain owned".into());}
        self.store.cleanup_renderer(&mut assets)?;self.watched.clear();Ok(())
    }
    fn load(&mut self,world:&mut World)->Result<(),String> {
        if self.invalidated{return Err("TT Capture source asset changed; verified source restart required".into());}
        if !self.failed_leases.is_empty() {
            let mut images=world.get_resource_mut::<Assets<Image>>().ok_or("TT Capture partial lease cleanup pending")?;
            let mut retained=Vec::new();
            for lease in self.failed_leases.drain(..){if let Err(error)=self.store.release(lease,&mut images){retained.push(error.lease);}}
            self.failed_leases=retained;
            if !self.failed_leases.is_empty(){return Err("TT Capture partial leases cannot be released; no reacquire".into());}
        }
        if self.bindings.is_none() {
            // Explicit existing Bevy sampling policy, not an original device claim.
            let sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,
                address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,
                min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,lod_min_clamp:0.,..default()});
            let spark=std::ffi::CString::new("Soraka_heal_sparkle_green.tga").unwrap();
            let color=std::ffi::CString::new("color-bellcurve.tga").unwrap();
            let diffuse=Source::request(&spark,&spark,SPARK,sampler.clone(),false)?;
            let color=Source::request(&color,&color,COLOR,sampler,false)?;
            let compressed=CompressedImageFormats::from_features(world.get_resource::<bevy::render::renderer::RenderDevice>()
                .ok_or("TT Capture actual GPU device pending")?.features());
            let mut images=world.get_resource_mut::<Assets<Image>>().ok_or("TT Capture images absent")?;
            let bindings=Bindings::acquire(&mut self.store,&mut images,compressed,diffuse,color)
                .map_err(|error|{self.failed_leases.extend(error.leases);error.message})?;
            // Store the leases BEFORE registration: a failed register cannot drop ownership.
            self.bindings=Some(bindings);
            self.bindings.as_ref().unwrap().register(&mut self.store,&images)?;
        }
        let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("TT Capture FoW pending")?.output.clone();
        let images=world.get_resource::<Assets<Image>>().ok_or("TT Capture image assets absent")?;
        let handles=self.bindings.as_ref().unwrap().images_render_fog(&self.store,images,[fog,self.overlay.clone()])?;
        self.watched=handles.iter().map(Handle::id).collect();
        Ok(())
    }
    fn publish(&mut self,world:&mut World,packets:Vec<Prepared>)->Result<(),String> {
        let published_frames=self.published_frames.checked_add(1).ok_or("TT Capture publication counter overflow")?;
        let mut identities=HashSet::new();
        for p in &packets {
            if p.group>=2 || p.birth==0 || !identities.insert((p.key,p.group,p.birth)){
                return Err("TT Capture duplicate/out-of-source particle identity".into());
            }
            let playback=world.get::<crate::animation::Playback>(p.owner.root).ok_or("TT Capture owner missing")?;
            if playback.network_id()!=p.key.picker || playback.model_asset_id()!=p.owner.model
                || world.get::<crate::actor_fow::Root>(p.owner.root).is_none(){
                return Err("TT Capture propagated actor ownership changed".into());
            }
        }
        for d in &self.draws {if !Self::matches(world,d)
            ||world.resource::<Assets<Mesh>>().get(&d.mesh).is_none()
            ||world.resource::<Assets<CaptureMaterial>>().get(&d.material).is_none(){
                return Err("TT Capture retained draw/material ownership changed".into());
            }
        }
        let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"TT Capture draw allocation")?;
        self.hide(world);
        for p in packets {
            let old=self.draws.iter().position(|d|d.ticket.key==p.key&&d.ticket.owner==p.owner
                &&d.ticket.group==p.group&&d.ticket.birth==p.birth);
            let d=if let Some(index)=old {
                let mut d=self.draws.swap_remove(index);
                *world.resource_mut::<Assets<Mesh>>().get_mut(&d.mesh).unwrap()=p.mesh;
                *world.resource_mut::<Assets<CaptureMaterial>>().get_mut(&d.material).unwrap()=p.material;
                d.ticket.images=p.images;d.ticket.layouts=p.layouts;world.entity_mut(d.ticket.draw).insert((p.bounds,d.ticket.clone()));d
            }else{
                let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);
                let material=world.resource_mut::<Assets<CaptureMaterial>>().add(p.material);
                let draw=world.spawn((Name::new(format!("TT Capture group{} birth{}",p.group,p.birth)),
                    Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,
                    GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
                let ticket=Ticket {key:p.key,owner:p.owner,group:p.group,birth:p.birth,draw,
                    mesh:mesh.id(),material:material.id(),images:p.images,layouts:p.layouts};
                world.entity_mut(draw).insert(ticket.clone());Owned {ticket,mesh,material}
            };output.push(d);
        }
        let old=std::mem::replace(&mut self.draws,output);
        for d in old {
            // Ownership was validated before mutation; no external system interleaves.
            world.despawn(d.ticket.draw);world.resource_mut::<Assets<Mesh>>().remove(d.mesh.id());
            world.resource_mut::<Assets<CaptureMaterial>>().remove(d.material.id());
        }
        for d in &self.draws {
            world.resource_mut::<Assets<CaptureMaterial>>().get_mut(&d.material).unwrap().set_admitted(true);
            *world.get_mut::<Visibility>(d.ticket.draw).unwrap()=Visibility::Visible;
        }
        self.published_frames=published_frames;Ok(())
    }
}
fn initialize(world:&mut World) {
    let result=(||->Result<Host,String>{
        let seven:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/seven_source_admission.json"))
            .map_err(|error|format!("TT Capture consumer admission JSON: {error}"))?;
        if seven["normal_activation_admitted"]!=false {
            return Err("TT Capture exclusive normal consumer conflicts with the seven-group admission; explicit future routing required".into());
        }
        let profiles=sampler::profiles()?;
        let time=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_err(|_|"TT Capture host clock before epoch")?;
        let filetime=u64::try_from(time.as_nanos()/100).ok().and_then(|v|v.checked_add(116_444_736_000_000_000))
            .ok_or("TT Capture local seed overflow")?;
        let seed=Rng55::seed_from_filetime(filetime);let mut rng=Rng55::from_filetime(filetime);
        let rotations=[profiles[0].retained(&mut rng)?,profiles[1].retained(&mut rng)?];
        world.resource_mut::<Diagnostics>().rng_seed=Some(seed);
        Ok(Host {profiles,rotations,rng,effects:BTreeMap::new(),ordinal:0,last_clock:None})
    })();
    match result {Ok(host)=>{world.insert_resource(host);},Err(error)=>world.resource_mut::<Diagnostics>().error=Some(error)}
    let overlay=world.get_resource::<AssetServer>().map(|a|a.load(OVERLAY)).unwrap_or_default();
    world.resource_mut::<Backend>().overlay=overlay;
}
fn prepared(world:&World,backend:&Backend,host:&Host,key:events::Key,effect:&Effect,extent:f32,fog:Handle<Image>)
    ->Result<Vec<Prepared>,String> {
    let camera=world.get_resource::<crate::camera_native::NativeCamera>().ok_or("TT Capture native camera absent")?;
    let images=world.get_resource::<Assets<Image>>().ok_or("TT Capture images absent")?;
    let leases=backend.bindings.as_ref().ok_or("TT Capture leases pending")?;
    let (material,handles)=CaptureMaterial::owned(leases,&backend.store,images,[fog,backend.overlay.clone()],extent)?;
    let layouts=std::array::from_fn(|i|{let d=&images.get(&handles[i]).expect("owned DDS validated").texture_descriptor;
        ImageLayout {extent:[d.size.width,d.size.height,d.size.depth_or_array_layers],mips:d.mip_level_count,format:d.format}});
    let systems=openleague_core::native_troy_resource_initial::empty_instance(0,[0;3],0.)?.scales.map(f32::from_bits);
    let mut output=Vec::new();
    for emitter in &effect.emitters {
        for p in &emitter.particles {
            let fields=binding::DrawFields::from_record(&p.record,false)?;
            let axes=crate::nexus_glow_quad::current_native_axes(camera,fields.quad_angle)?;
            let factor=systems[1]*systems[0];let scale=factor*fields.scale[0];
            let [r,g,b,a]=fields.rgba;
            let geometry=crate::nexus_glow_quad::geometry(quad::Input {center:fields.matrix_center,
                // Source p0 uniformscale1 substitutes X scale for the other axis.
                axis_a:axes.a.map(|v|v*scale),axis_b:axes.b.map(|v|v*scale),
                rgba:[r*a,g*a,b*a,1.],channel0_origin:fields.uv_scroll,channel0_z:fields.atlas_frame,
                channel1_origin:fields.lookup,channel1_corners:false},[1,1])?;
            let bounds=geometry.mesh.compute_aabb().ok_or("TT Capture packet has no finite bounds")?;
            output.push(Prepared {key,owner:effect.owner,group:emitter.index,birth:p.birth,
                mesh:geometry.mesh,bounds,material:material.clone(),images:handles.each_ref().map(|h|h.id()),layouts});
        }
    }
    let _=host;Ok(output)
}
pub fn synchronize(world:&mut World) {
    let Some(mut host)=world.remove_resource::<Host>() else{return};
    let mut backend=world.remove_resource::<Backend>().unwrap_or_default();
    let mut diagnostic=world.remove_resource::<Diagnostics>().unwrap_or_default();let old=diagnostic.error.clone();
    let result=(||->Result<(),String>{
        let requests=world.get_resource::<events::Host>().ok_or("TT Capture accepted event host missing")?.requests.clone();
        // Retirement is independent of clock attachment, health and progression.
        let previous=host.effects.len();
        host.effects.retain(|key,e|requests.get(key).and_then(|r|r.owner).is_some_and(|o|o.binding==e.owner));
        diagnostic.retired=diagnostic.retired.saturating_add(u64::try_from(previous-host.effects.len()).unwrap_or(0));
        if let Some(events)=world.get_resource::<Messages<AssetEvent<Image>>>() {for event in backend.cursor.read(events){
            if matches!(event,AssetEvent::Modified{id}|AssetEvent::Removed{id} if backend.watched.contains(id)) {backend.invalidated=true;}
        }}
        let active=requests.values().any(|r|r.owner.is_some());
        backend.retire_effects(world,&host.effects)?;
        if !active && host.effects.is_empty(){backend.release(world)?;return Ok(());}
        let clock=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("TT Capture canonical effect clock missing")?;
        if !clock.presentation_ready(){return Err("TT Capture canonical effect clock is not attached, initialized and healthy".into());}
        let now=clock.now;
        if !now.is_finite() || now<0. || host.last_clock.is_some_and(|old|now<old) {
            return Err("TT Capture canonical clock regressed/unavailable".into());
        }
        let ordinal=host.ordinal.checked_add(1).ok_or("TT Capture ordinal overflow")?;
        backend.load(world)?;
        // Camera/FoW readiness precedes first burst. There is no backdated replay.
        let _=crate::nexus_glow_quad::current_native_axes(world.get_resource::<crate::camera_native::NativeCamera>()
            .ok_or("TT Capture native camera pending")?,0.)?;
        let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("TT Capture FoW pending")?.output.clone();
        let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("TT Capture FoW extent pending")?.geometry.extent;
        let mut next=host.effects.clone();let mut random=host.rng.clone();let mut completed=Vec::new();let mut packets=Vec::new();
        for (key,request) in &requests {
            let Some(owner)=request.owner else{continue};
            let time=now as f32;if !time.is_finite(){return Err("TT Capture f32 effect clock overflow".into());}
            if !next.contains_key(key){next.insert(*key,Effect {owner:owner.binding,
                emitters:[state::Emitter::new(0,time,owner)?,state::Emitter::new(1,time,owner)?]});}
            let effect=next.get_mut(key).unwrap();
            for i in 0..2 {effect.emitters[i].step(&host.profiles[i],&host.rotations[i],time,owner,&mut random)?;}
            if effect.emitters.iter().enumerate().all(|(i,e)|e.finished(&host.profiles[i],time)){completed.push(*key);continue;}
            packets.extend(prepared(world,&backend,&host,*key,effect,extent,fog.clone())?);
        }
        if completed.iter().any(|key|!world.resource::<events::Host>().requests.contains_key(key)){
            return Err("TT Capture completion identity became stale".into());
        }
        backend.publish(world,packets)?;
        for key in completed {next.remove(&key);world.resource_mut::<events::Host>().complete(key)?;diagnostic.completed=diagnostic.completed.saturating_add(1);}
        host.effects=next;host.rng=random;host.last_clock=Some(now);host.ordinal=ordinal;
        if host.effects.is_empty(){backend.release(world)?;}Ok(())
    })();
    diagnostic.error=result.err();backend.error=diagnostic.error.clone();
    if diagnostic.error.is_some(){backend.hide(world);}
    diagnostic.ordinal=host.ordinal;diagnostic.events=host.effects.len();
    diagnostic.particles=host.effects.values().flat_map(|e|&e.emitters).map(|e|e.particles.len()).sum();
    diagnostic.draws=backend.draws.len();
    if diagnostic.error!=old {if let Some(error)=&diagnostic.error {warn!("TT Capture presentation: {error}");}}
    world.insert_resource(host);world.insert_resource(backend);world.insert_resource(diagnostic);
}
pub(crate) fn shutdown(world:&mut World) {
    if !world.get_resource::<Messages<bevy::app::AppExit>>().is_some_and(|m|!m.is_empty()){return;}
    let Some(mut backend)=world.remove_resource::<Backend>() else{return};
    let result=backend.release(world);let ok=result.is_ok();
    if let Some(mut host)=world.get_resource_mut::<Host>(){host.effects.clear();}
    let mut diagnostics=world.remove_resource::<Diagnostics>().unwrap_or_default();diagnostics.normal_cleanup=Some(ok);
    if let Err(error)=result{diagnostics.error=Some(error);}
    world.insert_resource(backend);world.insert_resource(diagnostics);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Backend>().init_resource::<Diagnostics>().add_plugins(MaterialPlugin::<CaptureMaterial>::default())
            .add_plugins(crate::tt_capture_readiness::Plugin)
            .add_systems(Startup,initialize.after(crate::fow_visibility_texture::setup))
            .add_systems(PostUpdate,synchronize.after(events::Published).after(AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate))
            .add_systems(Last,shutdown.after(bevy::window::ExitSystems));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture()->(World,Backend,Host,events::Key,Effect) {
        let mut cells=Vec::new();for _ in 0..16 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());
            cells.extend(0u32.to_le_bytes());cells.push(1);}
        let navigation=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,&cells).unwrap();
        let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let picker=simulation.join("garen").unwrap();
        assert_eq!(simulation.snapshot().players.iter().find(|p|p.id==picker).unwrap().champion,"garen");
        let mut world=World::new();world.insert_resource(Assets::<Image>::default());
        world.insert_resource(Assets::<Mesh>::default());world.insert_resource(Assets::<CaptureMaterial>::default());
        let model=Handle::<Gltf>::default();let root=world.spawn((crate::actor_fow::Root,
            crate::animation::material_test_playback(picker,model.clone()),GlobalTransform::IDENTITY)).id();
        let owner=events::OwnerFrame {binding:events::Binding {root,model:model.id()},native_position:[0;3],
            native_matrix:Mat4::IDENTITY.to_cols_array().map(f32::to_bits)};
        let profiles=sampler::profiles().unwrap();let mut rng=Rng55::seeded(42);
        let rotations=[profiles[0].retained(&mut rng).unwrap(),profiles[1].retained(&mut rng).unwrap()];
        let mut effect=Effect {owner:owner.binding,emitters:[state::Emitter::new(0,0.,owner).unwrap(),state::Emitter::new(1,0.,owner).unwrap()]};
        for i in 0..2 {effect.emitters[i].step(&profiles[i],&rotations[i],0.,owner,&mut rng).unwrap();}
        let host=Host {profiles,rotations,rng,effects:BTreeMap::new(),ordinal:0,last_clock:None};
        let mut backend=Backend::default();
        let sampler=ImageSampler::Descriptor(ImageSamplerDescriptor::default());
        let diffuse=std::ffi::CString::new("Soraka_heal_sparkle_green.tga").unwrap();
        let color=std::ffi::CString::new("color-bellcurve.tga").unwrap();
        let mut images=world.resource_mut::<Assets<Image>>();
        let bindings=Bindings::acquire(&mut backend.store,&mut images,CompressedImageFormats::BC,
            Source::request(&diffuse,&diffuse,SPARK,sampler.clone(),false).unwrap(),
            Source::request(&color,&color,COLOR,sampler,false).unwrap()).unwrap();
        bindings.register(&mut backend.store,&images).unwrap();
        // Fixture-only external fog images: never a production white substitute/GPU claim.
        let fog=images.add(Image::default());let overlay=images.add(Image::default());drop(images);
        backend.overlay=overlay;backend.bindings=Some(bindings);
        let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();
        world.insert_resource(camera);
        let key=events::Key {session:7,pickup_tick:100,picker};
        // Retain fixture fog in a resource so callers can prepare CPU material refs.
        world.insert_resource(FixtureFog(fog));(world,backend,host,key,effect)
    }
    #[derive(Resource)]struct FixtureFog(Handle<Image>);
    fn packets(world:&World,backend:&Backend,host:&Host,key:events::Key,effect:&Effect)->Vec<Prepared> {
        prepared(world,backend,host,key,effect,15360.,world.resource::<FixtureFog>().0.clone()).unwrap()
    }
    #[test]
    fn Garen_simulation_fixture_publishes70_owned_packets_and_retains_draw_asset_ids() {
        let (mut world,mut backend,host,key,effect)=fixture();
        let initial=packets(&world,&backend,&host,key,&effect);backend.publish(&mut world,initial).unwrap();
        let first=backend.tickets();assert_eq!(first.len(),state::PER_EVENT);
        assert_eq!(world.resource::<Assets<Mesh>>().len(),70);assert_eq!(world.resource::<Assets<CaptureMaterial>>().len(),70);
        assert!(first.iter().all(|t|world.get::<Visibility>(t.draw)==Some(&Visibility::Visible)));
        let again=packets(&world,&backend,&host,key,&effect);backend.publish(&mut world,again).unwrap();
        assert_eq!(backend.tickets(),first);assert_eq!(world.resource::<Assets<Mesh>>().len(),70);
        backend.release(&mut world).unwrap();assert!(backend.tickets().is_empty());assert_eq!(backend.store.len(),0);
        assert_eq!(world.resource::<Assets<Mesh>>().len(),0);assert_eq!(world.resource::<Assets<CaptureMaterial>>().len(),0);
        assert!(world.get_entity(effect.owner.root).is_ok());
    }
    #[test]
    fn replaced_Garen_playback_rejects_draw_commit_before_asset_or_entity_mutation() {
        let (mut world,mut backend,host,key,effect)=fixture();let first=packets(&world,&backend,&host,key,&effect);
        backend.publish(&mut world,first).unwrap();let tickets=backend.tickets();let stale=packets(&world,&backend,&host,key,&effect);
        world.entity_mut(effect.owner.root).insert(crate::animation::material_test_playback(key.picker+1,Handle::default()));
        assert!(backend.publish(&mut world,stale).is_err());assert_eq!(backend.tickets(),tickets);
        assert_eq!(world.resource::<Assets<Mesh>>().len(),70);assert_eq!(world.resource::<Assets<CaptureMaterial>>().len(),70);
        backend.release(&mut world).unwrap();assert!(world.get_entity(effect.owner.root).is_ok());
    }
    #[test]
    fn foreign_draw_blocks_image_lease_retirement_until_exact_ownership_restored() {
        let (mut world,mut backend,host,key,effect)=fixture();let first=packets(&world,&backend,&host,key,&effect);
        backend.publish(&mut world,first).unwrap();let ticket=backend.tickets()[0].clone();
        let mut foreign=ticket.clone();foreign.birth=0;world.entity_mut(ticket.draw).insert(foreign.clone());
        assert!(backend.retire_effects(&mut world,&BTreeMap::new()).is_err());
        assert!(backend.release(&mut world).is_err());assert_eq!(world.get::<Ticket>(ticket.draw),Some(&foreign));
        assert!(backend.bindings.is_some());assert_eq!(backend.store.len(),2);
        assert!(world.resource::<Assets<Mesh>>().get(ticket.mesh).is_some());
        world.entity_mut(ticket.draw).insert(ticket);
        backend.retire_effects(&mut world,&BTreeMap::new()).unwrap();
        assert!(backend.tickets().is_empty());assert!(backend.bindings.is_some());
        backend.release(&mut world).unwrap();
        assert!(backend.tickets().is_empty());assert_eq!(backend.store.len(),0);
    }
}
