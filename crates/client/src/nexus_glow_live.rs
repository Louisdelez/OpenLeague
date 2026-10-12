//! Ordinary CrystalGlow: Complex Startup and genuine Simple On producer ports.
use bevy::{asset::{AssetEvent,AssetId,AssetEventSystems},camera::primitives::MeshAabb,
    ecs::message::MessageCursor,image::{ImageAddressMode,ImageFilterMode,ImageSamplerDescriptor},prelude::*};
use openleague_core::{native_complex_particle_age,native_complex_quad_binding as binding,
    native_complex_type0_quad as quad,native_random::Rng55};
use crate::{nexus_glow_state::{State,Particle,ParticleId,Slot,Profile as BirthProfile,Side},
    nexus_idle_particles::{Host,Owner,Frame,Request},nexus_glow_material::{GlowMaterial,Textures,Inputs},
    nexus_complex_material::{Cull,OutputEncoding},nexus_glow_quad};

#[derive(Resource)]
struct Profile {births:[BirthProfile;2],simple:[crate::nexus_glow_simple::Profile;2],textures:Textures,on_textures:[Textures;2],overlay:Handle<Image>,armed:bool,invalidated:bool,
    events:MessageCursor<AssetEvent<Image>>}
impl Profile {
    fn validate(&self,images:&Assets<Image>)->Result<(),String> {
        if self.invalidated {return Err("Glow source changed; verified restart required".into());}
        self.textures.validate(images).map_err(str::to_owned)?;
        for t in &self.on_textures{t.validate_palette(images,true).map_err(str::to_owned)?;}
        if images.get(&self.overlay).is_none() {return Err("Glow FoW overlay missing".into());}Ok(())
    }
}

#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Ticket {pub particle:ParticleId,pub owner:Owner,pub ordinal:u64,pub draw:Entity,
    pub mesh:AssetId<Mesh>,pub material:AssetId<GlowMaterial>,pub images:[AssetId<Image>;4]}
#[derive(Component,Clone,Debug)]
pub struct OwnedDraw(pub Ticket);
struct Draw {ticket:Ticket,mesh:Handle<Mesh>,material:Handle<GlowMaterial>}
#[derive(Resource,Default)]
pub struct Backend {draws:Vec<Draw>}
struct Prepared {id:ParticleId,owner:Owner,mesh:Mesh,bounds:bevy::camera::primitives::Aabb,material:GlowMaterial,images:[AssetId<Image>;4]}
impl Backend {
    pub fn tickets(&self)->Vec<Ticket> {self.draws.iter().map(|d|d.ticket.clone()).collect()}
    fn remove(world:&mut World,draw:Draw) {
        // These private entities/assets never replace an actor or its materials.
        if world.get::<OwnedDraw>(draw.ticket.draw).map(|v|&v.0)==Some(&draw.ticket) {world.despawn(draw.ticket.draw);}
        if let Some(mut assets)=world.get_resource_mut::<Assets<Mesh>>() {assets.remove(draw.mesh.id());}
        if let Some(mut assets)=world.get_resource_mut::<Assets<GlowMaterial>>() {assets.remove(draw.material.id());}
    }
    fn clear(&mut self,world:&mut World) {for draw in self.draws.drain(..){Self::remove(world,draw);}}
    fn hide(&self,world:&mut World) {
        for draw in &self.draws {
            if let Some(mut v)=world.get_mut::<Visibility>(draw.ticket.draw){*v=Visibility::Hidden;}
            if let Some(mut a)=world.get_resource_mut::<Assets<GlowMaterial>>() {if let Some(mut m)=a.get_mut(&draw.material){m.set_admitted(false);}}
        }
    }
    fn publish(&mut self,world:&mut World,ordinal:u64,packets:Vec<Prepared>)->Result<(),String> {
        self.hide(world);
        if packets.len()>crate::nexus_glow_simple::DRAW_CAPACITY || !world.contains_resource::<Assets<Mesh>>() || !world.contains_resource::<Assets<GlowMaterial>>() {
            return Err("CrystalGlow draw capacity or asset resources unavailable".into());
        }
        let mut ids=std::collections::HashSet::new();
        for p in &packets {
            if !ids.insert(p.id) || world.get_entity(p.owner.actor).is_err() || ordinal==0 {return Err("CrystalGlow duplicate particle or absent owner".into());}
        }
        for d in &self.draws {
            if world.get::<OwnedDraw>(d.ticket.draw).map(|v|&v.0)!=Some(&d.ticket)
                || world.get::<Mesh3d>(d.ticket.draw).map(|v|v.0.id())!=Some(d.ticket.mesh)
                || world.get::<MeshMaterial3d<GlowMaterial>>(d.ticket.draw).map(|v|v.0.id())!=Some(d.ticket.material)
                || world.get::<Transform>(d.ticket.draw)!=Some(&Transform::IDENTITY)
                || world.get::<GlobalTransform>(d.ticket.draw)!=Some(&GlobalTransform::IDENTITY)
                || world.get::<ChildOf>(d.ticket.draw).is_some() || world.get::<Visibility>(d.ticket.draw).is_none()
                || world.resource::<Assets<Mesh>>().get(&d.mesh).is_none()
                || world.resource::<Assets<GlowMaterial>>().get(&d.material).is_none() {
                return Err("CrystalGlow retained private draw ownership changed".into());
            }
        }
        let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"CrystalGlow draw storage unavailable")?;
        // All packet preparation and ownership validation precedes mutation.
        // Stable birth+owner retains entity and asset IDs across ordinary frames.
        for p in packets {
            let draw=if let Some(i)=self.draws.iter().position(|d|d.ticket.particle==p.id && d.ticket.owner==p.owner) {
                let mut draw=self.draws.swap_remove(i);
                *world.resource_mut::<Assets<Mesh>>().get_mut(&draw.mesh).expect("validated mesh")=p.mesh;
                *world.resource_mut::<Assets<GlowMaterial>>().get_mut(&draw.material).expect("validated material")=p.material;
                draw.ticket.ordinal=ordinal;draw.ticket.images=p.images;
                world.entity_mut(draw.ticket.draw).insert((p.bounds,OwnedDraw(draw.ticket.clone())));draw
            } else {
                let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);
                let material=world.resource_mut::<Assets<GlowMaterial>>().add(p.material);
                let entity=world.spawn((Name::new("Nexus CrystalGlow"),Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),
                    Transform::IDENTITY,GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
                let ticket=Ticket{particle:p.id,owner:p.owner,ordinal,draw:entity,mesh:mesh.id(),material:material.id(),images:p.images};
                world.entity_mut(entity).insert(OwnedDraw(ticket.clone()));Draw{ticket,mesh,material}
            };output.push(draw);
        }
        for old in self.draws.drain(..){Self::remove(world,old);}
        self.draws=output;
        for d in &self.draws {
            {let mut assets=world.resource_mut::<Assets<GlowMaterial>>();let mut m=assets.get_mut(&d.material).expect("owned material");m.set_admitted(true);}
            *world.get_mut::<Visibility>(d.ticket.draw).expect("owned visibility")=Visibility::Visible;
        }
        Ok(())
    }
}

fn prepare_particle(profile:&Profile,slot:&Slot,particle:&Particle,r:&Request,axes:binding::Axes,
    visibility:Handle<Image>,extent:f32)->Result<Prepared,String> {
    let age=native_complex_particle_age::evaluate(slot.age,particle.birth.time,particle.birth.life);
    // Explicit LOCAL bound-center adapter: the six actual gnome GlobalTransforms
    // supply center*20 each frame. p-bindtoemitter=[1,1], offset/motion are zero.
    // The native general bind/shape writer is not claimed qualified by this step.
    let (_,position)=crate::nexus_complex_live::owner_pose(r)?;
    let scale=particle.birth.scale;
    //923E68 mode0 prepares premultiplied RGB and stores alpha=1 before ARGB8.
    let [red,green,blue,alpha]=particle.rgba;
    let uv=particle.birth.uv.update(age.elapsed,openleague_core::native_complex_uv_scroll::Flags(0))[0];
    let lookup=binding::lookup_uv(age.normalized,[1,0],[1.,1.],[0.,0.]).map_err(str::to_owned)?;
    let mesh=nexus_glow_quad::geometry(quad::Input {center:position.to_array(),
        axis_a:axes.a.map(|v|v*scale[1]),axis_b:axes.b.map(|v|v*scale[0]),
        rgba:[red*alpha,green*alpha,blue*alpha,1.],channel0_origin:uv,channel0_z:3.,
        channel1_origin:lookup,channel1_corners:false},[2,2]).map_err(str::to_owned)?.mesh;
    let bounds=mesh.compute_aabb().ok_or("Glow bounds unavailable")?;
    let images=[profile.textures.image.id(),profile.textures.color.id(),visibility.id(),profile.overlay.id()];
    let material=GlowMaterial::new(&profile.textures,visibility,profile.overlay.clone(),Inputs {
        native_fog_extent:extent,encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,
        render_mode:0,render_flags:0,shader_features:0}).map_err(str::to_owned)?;
    Ok(Prepared {id:particle.id,owner:r.owner,mesh,bounds,material,images})
}

fn prepare_simple(profile:&Profile,slot:&crate::nexus_glow_simple::Slot,index:usize,r:&Request,axes:openleague_core::native_simple_type0_quad::Axes,
    visibility:Handle<Image>,extent:f32)->Result<Prepared,String> {
    let storage=&slot.storage;let scale=f32::from_bits(storage.scales[index]);
    let lookup=[storage.attribute_a[index],storage.attribute_b[index]].map(f32::from_bits);
    let native=openleague_core::native_simple_type0_quad::pack(openleague_core::native_simple_type0_quad::Input{center:storage.positions[index].map(f32::from_bits),
        axis_a:axes.a.map(|v|v*scale),axis_b:axes.b.map(|v|v*scale),rgba:[1.;4],
        channel0_origin:[0.;2],channel0_z:3.,channel1_origin:lookup}).map_err(|e|format!("Simple quad {e:?}"))?;
    let mesh=nexus_glow_quad::from_packet(quad::Quad{words:native.words},[2,2]).map_err(str::to_owned)?.mesh;
    let bounds=mesh.compute_aabb().ok_or("Simple glow bounds unavailable")?;
    let textures=&profile.on_textures[slot.side.index()];
    let images=[textures.image.id(),textures.color.id(),visibility.id(),profile.overlay.id()];
    let material=GlowMaterial::new(textures,visibility,profile.overlay.clone(),Inputs{native_fog_extent:extent,
        encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,render_mode:0,render_flags:0,shader_features:0}).map_err(str::to_owned)?;
    Ok(Prepared{id:slot.id(index),owner:r.owner,mesh,bounds,material,images})
}

#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub ordinal:u64,pub emitters:usize,pub particles:usize,pub draws:usize,
    pub missing_pose_frames:u64,pub rng_seed:Option<u32>,pub local_reconstruction:bool,pub native_complete:bool,pub gpu_draw_qualified:bool}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App){app.add_plugins(MaterialPlugin::<GlowMaterial>::default())
        .init_resource::<Backend>().init_resource::<Diagnostics>().init_resource::<crate::nexus_glow_simple::State>()
        .add_systems(Startup,setup.after(crate::fow_visibility_texture::setup))
        .add_systems(PostUpdate,synchronize.after(AssetEventSystems).after(crate::nexus_idle_particles::Published)
            .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
            .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}
}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut diagnostic:ResMut<Diagnostics>) {
    let result=(||->Result<(Profile,State,u32),String>{
        let elapsed=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_err(|_|"Glow host clock before epoch")?;
        let filetime=u64::try_from(elapsed.as_nanos()/100).ok().and_then(|t|t.checked_add(116_444_736_000_000_000)).ok_or("Glow host clock overflow")?;
        let seed=Rng55::seed_from_filetime(filetime); // actual host seed, separate LOCAL stream once
        let repeat=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,
            mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()};
        let clamp=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,..repeat.clone()};
        let textures=Textures::load(&assets,[repeat.clone(),clamp.clone()]).map_err(str::to_owned)?;
        let on_textures=[Textures::load_color(&assets,[repeat.clone(),clamp.clone()],crate::nexus_glow_material::ORDER_COLOR).map_err(str::to_owned)?,
            Textures::load_color(&assets,[repeat,clamp],crate::nexus_glow_material::CHAOS_COLOR).map_err(str::to_owned)?];
        Ok((Profile {births:[BirthProfile::load(Side::Order)?,BirthProfile::load(Side::Chaos)?],simple:[crate::nexus_glow_simple::Profile::load(Side::Order)?,crate::nexus_glow_simple::Profile::load(Side::Chaos)?],textures,on_textures,
            overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png"),armed:false,invalidated:false,events:default()},State::new(seed),seed))
    })();diagnostic.local_reconstruction=true;
    match result {Ok((p,s,seed))=>{commands.insert_resource(p);commands.insert_resource(s);diagnostic.rng_seed=Some(seed);},Err(e)=>diagnostic.error=Some(e)}
}
pub fn synchronize(world:&mut World) {
    let Some(mut backend)=world.remove_resource::<Backend>() else{return};
    let mut diagnostic=world.remove_resource::<Diagnostics>().unwrap_or_default();let old=diagnostic.error.clone();
    diagnostic.local_reconstruction=true;diagnostic.native_complete=false;diagnostic.gpu_draw_qualified=false;
    let result=(||->Result<(),String>{
        let frame=world.get_resource::<Host>().ok_or("Glow IdleParticles host missing")?.frame.clone();
        let now=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("Glow effect clock missing")?.now;
        let Some(mut profile)=world.remove_resource::<Profile>() else{return Err("Glow profile unavailable".into())};
        let inner=(||->Result<(),String>{
            // Always drain source events before deciding whether a frame is old.
            if let Some(events)=world.get_resource::<Messages<AssetEvent<Image>>>() {
                let watched=[profile.textures.image.id(),profile.textures.color.id(),profile.on_textures[0].image.id(),profile.on_textures[0].color.id(),
                    profile.on_textures[1].image.id(),profile.on_textures[1].color.id(),profile.overlay.id()];
                for event in profile.events.read(events) {
                    if matches!(event,AssetEvent::Modified{id}|AssetEvent::Removed{id} if profile.armed && watched.contains(id)) {profile.invalidated=true;}
                }
            }
            let state=world.get_resource::<State>().ok_or("Glow state unavailable")?;
            let readiness=world.get_resource::<Assets<Image>>().ok_or_else(||"Glow images missing".to_owned()).and_then(|i|profile.validate(i));
            // Stale frames are not re-published. Reload still retires their draws.
            if state.session==frame.session && frame.ordinal<=state.ordinal {return readiness;}
            for r in &frame.requests {if (crate::nexus_glow_state::side(r).map_err(str::to_owned)?.is_some() || crate::nexus_glow_simple::side(r).map_err(str::to_owned)?.is_some())
                && (world.get_entity(r.owner.actor).is_err() || world.get_entity(r.bone).is_err()) {return Err("Glow current bound actor or bone missing".into());}}
            let Some(mut planned)=state.planned(&frame,now,&profile.births,readiness.is_ok())? else{return Ok(())};
            let simple=world.get_resource::<crate::nexus_glow_simple::State>().ok_or("Glow Simple state absent")?;
            let (simple,random)=simple.planned(&frame,now,&profile.simple,readiness.is_ok(),&planned.rng)?.ok_or("Glow producer ordinal disagreement")?;
            planned.rng=random;
            if let Err(e)=readiness {world.insert_resource(planned);world.insert_resource(simple);return Err(e);}
            // A visible native camera pose is necessary; no guessed screen-facing basis.
            let axes=if planned.slots.iter().any(|s|s.seen&&!s.particles.is_empty()) {
                let camera=world.get_resource::<crate::camera_native::NativeCamera>().ok_or("Glow native camera unavailable")?;
                Some(nexus_glow_quad::current_native_axes(camera,0.).map_err(str::to_owned)?)
            }else{None};
            let simple_axes=if simple.slots.iter().any(|s|s.seen&&s.live_indices().next().is_some()) {
                let camera=world.get_resource::<crate::camera_native::NativeCamera>().ok_or("Glow Simple camera absent")?;
                let params=camera.native_parameters().ok_or("Glow Simple camera not ready")?;
                let view=openleague_core::camera_view::from_parameters(params).map_err(str::to_owned)?;
                Some(openleague_core::native_simple_type0_quad::axes_zero(view).map_err(|e|format!("Simple basis {e:?}"))?)
            }else{None};
            let visibility=world.get_resource::<crate::fow_gpu::Images>().ok_or("Glow FoW image absent")?.output.clone();
            let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("Glow FoW extent absent")?.geometry.extent;
            let mut packets=Vec::new();packets.try_reserve_exact(planned.live_count()+simple.live_count()).map_err(|_|"Glow packet reservation failed")?;
            for slot in &planned.slots {if slot.seen {
                let r=frame.requests.iter().find(|r|r.cycle==slot.cycle&&r.descriptor.slot==slot.key.slot).ok_or("Glow current request disappeared")?;
                for particle in &slot.particles {packets.push(prepare_particle(&profile,slot,particle,r,axes.ok_or("Glow axes absent")?,visibility.clone(),extent)?);}
            }}
            for slot in &simple.slots {if slot.seen {
                let r=frame.requests.iter().find(|r|r.cycle==slot.cycle&&r.descriptor.slot==slot.key.slot).ok_or("Glow Simple request disappeared")?;
                for i in slot.live_indices(){packets.push(prepare_simple(&profile,slot,i,r,simple_axes.ok_or("Glow Simple axes absent")?,visibility.clone(),extent)?);}
            }}
            backend.publish(world,frame.ordinal,packets)?;profile.armed=true;world.insert_resource(planned);world.insert_resource(simple);Ok(())
        })();world.insert_resource(profile);inner
    })();
    diagnostic.error=result.err();if diagnostic.error.is_some(){backend.clear(world);}
    diagnostic.draws=backend.draws.len();
    if let Some(state)=world.get_resource::<State>() {diagnostic.ordinal=state.ordinal;diagnostic.emitters=state.slots.len();
        diagnostic.particles=state.live_count();diagnostic.missing_pose_frames=state.slots.iter().map(|s|s.missing_pose_frames).sum();}
    if let Some(simple)=world.get_resource::<crate::nexus_glow_simple::State>() {diagnostic.emitters+=simple.slots.len();diagnostic.particles+=simple.live_count();diagnostic.missing_pose_frames+=simple.slots.iter().map(|s|s.missing_pose_frames).sum::<u64>();}
    if diagnostic.error!=old {if let Some(e)=&diagnostic.error{warn!("Nexus CrystalGlow: {e}");}}
    world.insert_resource(diagnostic);world.insert_resource(backend);
}
#[cfg(test)]
#[path="nexus_glow_live_tests.rs"]
pub(crate) mod tests;

