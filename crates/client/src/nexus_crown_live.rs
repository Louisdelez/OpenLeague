//! Ordinary Crown Startup/On: four real base bones per Nexus, private finite particles.
//! Birth/emission math is source-qualified; global RNG interleaving, pose-field
//! assignment and Bevy rendering remain explicit local adaptations.
use bevy::{asset::{AssetEvent,AssetId,RenderAssetUsages},camera::primitives::MeshAabb,
    ecs::message::MessageCursor,image::{ImageAddressMode,ImageFilterMode,ImageLoaderSettings,ImageSampler,ImageSamplerDescriptor},
    prelude::*,render::render_resource::{Extent3d,TextureDimension,TextureFormat}};
use openleague_core::{native_crown_birth::{Profile as BirthProfile,Side,Phase},native_complex_color::ComplexColor,
    native_complex_vectors::Field,native_complex_particle_age,native_scalar_parameter::baked_scalar_index,
    native_complex_mesh_pose,native_random::Rng55};
use crate::{nexus_crown_state::{State,Particle,ParticleId,Slot},nexus_idle_particles::{Host,Owner,Frame},
    nexus_complex_mesh::{Geometry,NativeWorld},nexus_complex_material::{NexusMaterial,Inputs,Cull,OutputEncoding}};

const TEXTURE:&str="particles/nexus_crown_linear/cylinder06.dds";
#[derive(Resource)]
struct Profile {
    births:Vec<BirthProfile>,colors:Vec<ComplexColor>,geometry:Geometry,
    texture:Handle<Image>,lookup:Vec<Handle<Image>>,overlay:Handle<Image>,sampler:ImageSamplerDescriptor,
    armed:bool,invalidated:bool,events:MessageCursor<AssetEvent<Image>>,
}
// The pinned exporter keeps string scalar "0" as the one-element [0.0].
// Accept only a numeric zero, directly or in that exact scalar-array shape.
fn render_mode_zero(value:&serde_json::Value)->bool {
    match value {
        serde_json::Value::Number(_) => value.as_f64()==Some(0.),
        serde_json::Value::Array(values) if values.len()==1 => values[0].as_f64()==Some(0.),
        _ => false,
    }
}
fn profile_index(side:Side,phase:Phase)->usize {
    (if phase==Phase::Startup {2}else{0})+if side==Side::Order {0}else{1}
}
fn lifetime_colors()->Result<[ComplexColor;2],String> {lifetime_colors_for(Phase::On)}
fn lifetime_colors_for(phase:Phase)->Result<[ComplexColor;2],String> {
    let (data,references)=match phase {
        Phase::On=>(include_str!("../../../data/4.20/nexus_crown/crown_on_profiles.json"),["Order_Nexus_Base_Glow_on.troy","Chaos_Nexus_Base_Glow_on.troy"]),
        Phase::Startup=>(include_str!("../../../data/4.20/nexus_crown/crown_startup_profiles.json"),["Order_Nexus_Base_Glow.troy","Chaos_Nexus_Base_Glow.troy"]),
    };
    let doc:serde_json::Value=serde_json::from_str(data).map_err(|e|e.to_string())?;
    let mut out=Vec::new();
    for reference in references {
        let profile=doc["profiles"].as_array().ok_or("Crown profiles missing")?.iter()
            .find(|p|p["reference"]==reference).ok_or("Crown profile identity missing")?;
        let fields=&profile["fields"];let raw=&profile["raw_fields"];
        if raw["p-mesh"]!="Saucer6.sco" || raw["p-meshtex"]!="cylinder06.tga" || !render_mode_zero(&fields["rendermode"])
            || raw.get("p-backfaceon").is_some() || raw.get("pass").is_some() {
            return Err("Crown draw profile left the bounded source domain".into());
        }
        let color=ComplexColor::from_lifetime_group(fields).map_err(|e|format!("Crown lifetime color: {e:?}"))?;
        if !color.reader_accepted || color.table.len()!=256 || color.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.) {
            return Err("Crown lifetime table requires another producer".into());
        }
        out.push(color);
    }
    out.try_into().map_err(|_|"Crown requires two lifetime tables".into())
}
fn lookup_image(color:&ComplexColor)->Image {
    let bytes=color.table.iter().flatten().map(|v|(v.clamp(0.,1.)*255.).round() as u8).collect();
    let mut image=Image::new(Extent3d{width:color.table.len() as u32,height:1,depth_or_array_layers:1},
        TextureDimension::D2,bytes,TextureFormat::Rgba8Unorm,RenderAssetUsages::default());
    image.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,
        address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Nearest,min_filter:ImageFilterMode::Nearest,
        mipmap_filter:ImageFilterMode::Nearest,..default()});image
}
impl Profile {
    fn validate(&self,images:&Assets<Image>)->Result<(),String> {
        if self.invalidated {return Err("Crown source image changed; verified restart required".into());}
        let image=images.get(&self.texture).ok_or("Crown DDS still unavailable")?;let d=&image.texture_descriptor;
        if d.dimension!=TextureDimension::D2 || d.size!=(Extent3d{width:256,height:256,depth_or_array_layers:1})
            || d.mip_level_count!=9 || d.format!=TextureFormat::Bc3RgbaUnorm
            || !matches!(&image.sampler,ImageSampler::Descriptor(s) if *s==self.sampler) {
            return Err("Crown DDS descriptor or sampler changed".into());
        }
        for handle in &self.lookup {
            let image=images.get(handle).ok_or("Crown color table unavailable")?;
            if image.texture_descriptor.format!=TextureFormat::Rgba8Unorm
                || image.texture_descriptor.size!=(Extent3d{width:256,height:1,depth_or_array_layers:1}) {
                return Err("Crown color table shape changed".into());
            }
        }
        if images.get(&self.overlay).is_none() {return Err("Crown FoW overlay unavailable".into());}
        Ok(())
    }
    fn images(&self,side:Side,phase:Phase,visibility:Handle<Image>)->[Handle<Image>;4] {
        [self.texture.clone(),self.lookup[profile_index(side,phase)].clone(),visibility,self.overlay.clone()]
    }
}

#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Ticket {pub particle:ParticleId,pub owner:Owner,pub ordinal:u64,pub draw:Entity,
    pub mesh:AssetId<Mesh>,pub material:AssetId<NexusMaterial>,pub images:[AssetId<Image>;4]}
#[derive(Component,Clone,Debug)]
pub struct OwnedDraw(pub Ticket);
struct Draw {ticket:Ticket,mesh:Handle<Mesh>,material:Handle<NexusMaterial>}
#[derive(Resource,Default)]
pub struct Backend {draws:Vec<Draw>}
struct Prepared {id:ParticleId,owner:Owner,mesh:Mesh,bounds:bevy::camera::primitives::Aabb,material:NexusMaterial,images:[AssetId<Image>;4]}
impl Backend {
    pub fn tickets(&self)->Vec<Ticket> {self.draws.iter().map(|d|d.ticket.clone()).collect()}
    fn remove(world:&mut World,draw:Draw) {
        // These private entities/assets never replace an actor or its materials.
        if world.get_entity(draw.ticket.draw).is_ok(){world.despawn(draw.ticket.draw);}
        if let Some(mut assets)=world.get_resource_mut::<Assets<Mesh>>() {assets.remove(draw.mesh.id());}
        if let Some(mut assets)=world.get_resource_mut::<Assets<NexusMaterial>>() {assets.remove(draw.material.id());}
    }
    fn clear(&mut self,world:&mut World) {for draw in self.draws.drain(..){Self::remove(world,draw);}}
    fn hide(&self,world:&mut World) {
        for draw in &self.draws {
            if let Some(mut v)=world.get_mut::<Visibility>(draw.ticket.draw){*v=Visibility::Hidden;}
            if let Some(mut a)=world.get_resource_mut::<Assets<NexusMaterial>>() {if let Some(mut m)=a.get_mut(&draw.material){m.set_ready(false);}}
        }
    }
    fn publish(&mut self,world:&mut World,ordinal:u64,packets:Vec<Prepared>)->Result<(),String> {
        self.hide(world);
        if packets.len()>crate::nexus_crown_state::DRAW_CAPACITY || !world.contains_resource::<Assets<Mesh>>() || !world.contains_resource::<Assets<NexusMaterial>>() {
            return Err("Crown draw capacity or asset resources unavailable".into());
        }
        let mut ids=std::collections::HashSet::new();
        for p in &packets {
            if !ids.insert(p.id) || world.get_entity(p.owner.actor).is_err() || ordinal==0 {return Err("Crown duplicate particle or absent owner".into());}
        }
        for d in &self.draws {
            if world.get::<OwnedDraw>(d.ticket.draw).map(|v|&v.0)!=Some(&d.ticket)
                || world.get::<Mesh3d>(d.ticket.draw).map(|v|v.0.id())!=Some(d.ticket.mesh)
                || world.get::<MeshMaterial3d<NexusMaterial>>(d.ticket.draw).map(|v|v.0.id())!=Some(d.ticket.material)
                || world.get::<Transform>(d.ticket.draw)!=Some(&Transform::IDENTITY)
                || world.get::<GlobalTransform>(d.ticket.draw)!=Some(&GlobalTransform::IDENTITY)
                || world.get::<ChildOf>(d.ticket.draw).is_some() || world.get::<Visibility>(d.ticket.draw).is_none()
                || world.resource::<Assets<Mesh>>().get(&d.mesh).is_none()
                || world.resource::<Assets<NexusMaterial>>().get(&d.material).is_none() {
                return Err("Crown retained private draw ownership changed".into());
            }
        }
        let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"Crown draw storage unavailable")?;
        // All packet preparation and ownership validation precedes mutation.
        // Stable birth+owner retains entity and asset IDs across ordinary frames.
        for p in packets {
            let draw=if let Some(i)=self.draws.iter().position(|d|d.ticket.particle==p.id && d.ticket.owner==p.owner) {
                let mut draw=self.draws.swap_remove(i);
                *world.resource_mut::<Assets<Mesh>>().get_mut(&draw.mesh).expect("validated mesh")=p.mesh;
                *world.resource_mut::<Assets<NexusMaterial>>().get_mut(&draw.material).expect("validated material")=p.material;
                draw.ticket.ordinal=ordinal;draw.ticket.images=p.images;
                world.entity_mut(draw.ticket.draw).insert((p.bounds,OwnedDraw(draw.ticket.clone())));draw
            } else {
                let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);
                let material=world.resource_mut::<Assets<NexusMaterial>>().add(p.material);
                let entity=world.spawn((Name::new("Nexus Crown"),Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),
                    Transform::IDENTITY,GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
                let ticket=Ticket{particle:p.id,owner:p.owner,ordinal,draw:entity,mesh:mesh.id(),material:material.id(),images:p.images};
                world.entity_mut(entity).insert(OwnedDraw(ticket.clone()));Draw{ticket,mesh,material}
            };output.push(draw);
        }
        for old in self.draws.drain(..){Self::remove(world,old);}
        self.draws=output;
        for d in &self.draws {
            {let mut assets=world.resource_mut::<Assets<NexusMaterial>>();let mut m=assets.get_mut(&d.material).expect("owned material");m.set_ready(true);}
            *world.get_mut::<Visibility>(d.ticket.draw).expect("owned visibility")=Visibility::Visible;
        }
        Ok(())
    }
}

fn prepare_particle(profile:&Profile,slot:&Slot,particle:&Particle,owner:Owner,visibility:Handle<Image>,extent:f32)->Result<Prepared,String> {
    let age=native_complex_particle_age::evaluate(slot.age,particle.birth.schedule.time,particle.birth.life);
    let index=baked_scalar_index(profile.colors[profile_index(slot.side,slot.phase)].table.len(),age.normalized).map_err(|e|format!("Crown table age: {e:?}"))?;
    let base=Vec3::from_array(particle.birth.vector(Field::QuadRotation));
    let angular=Vec3::from_array(particle.birth.vector(Field::RotationVelocity))*age.elapsed;
    let a=(base+angular).to_array().map(f32::to_radians);
    // LOCAL mapping from real birth attachment + sampled fields to97EC60 inputs.
    // The matrix multiplication itself is qualified. Provider/packet assignment,
    // Euler XYZ degrees, cull/sampler/table encoding and GPU remain adaptations.
    let pose=Mat4::from_translation(Vec3::from_array(particle.birth.schedule.position))
        *particle.orientation*Mat4::from_quat(Quat::from_euler(EulerRot::XYZ,a[0],a[1],a[2]));
    let world=native_complex_mesh_pose::compose(native_complex_mesh_pose::Inputs {centre:profile.geometry.centre,
        scale:particle.birth.vector(Field::Scale),post_offset:particle.birth.vector(Field::PostOffset),pose:pose.to_cols_array()}).map_err(str::to_owned)?;
    let uv=particle.birth.uv.update(age.elapsed,openleague_core::native_complex_uv_scroll::Flags(0))[0];
    let images=profile.images(slot.side,slot.phase,visibility);
    let material=NexusMaterial::from_images(images.clone(),Inputs {uv_scale_offset:Vec4::new(1.,1.,uv[0],uv[1]),
        lookup_uv:Vec2::new((index as f32+0.5)/256.,0.5),color_factor:Vec4::from_array(particle.birth.color),
        native_fog_extent:extent,output_encoding:OutputEncoding::DisplayToLinear,cull:Cull::Back,
        shader_features:0,fresnel:Vec4::ZERO,render_mode:0,render_flags:0}).map_err(str::to_owned)?;
    let mesh=profile.geometry.bake(NativeWorld(world)).map_err(str::to_owned)?;
    let bounds=mesh.compute_aabb().ok_or("Crown world mesh bounds unavailable")?;
    Ok(Prepared {id:particle.id,owner,mesh,bounds,material,images:images.map(|i|i.id())})
}

#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub ordinal:u64,pub emitters:usize,pub particles:usize,pub draws:usize,
    pub missing_pose_frames:u64,pub rng_seed:Option<u32>,pub local_reconstruction:bool,pub native_complete:bool,pub gpu_draw_qualified:bool}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App){app.init_resource::<Backend>().init_resource::<Diagnostics>()
        .add_systems(Startup,setup.after(crate::fow_visibility_texture::setup))
        .add_systems(PostUpdate,synchronize.after(crate::nexus_idle_particles::Published)
            .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
            .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));}
}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut images:ResMut<Assets<Image>>,mut diagnostic:ResMut<Diagnostics>) {
    let result=(||->Result<(Profile,State,u32),String>{
        let elapsed=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_err(|_|"Crown host clock before epoch")?;
        let filetime=u64::try_from(elapsed.as_nanos()/100).ok().and_then(|t|t.checked_add(116_444_736_000_000_000)).ok_or("Crown host clock overflow")?;
        let seed=Rng55::seed_from_filetime(filetime); // actual host seed, once; not a claim of original global stream
        let sampler=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,
            mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()};
        let settings=sampler.clone();let texture=assets.load_builder().with_settings(move|s:&mut ImageLoaderSettings|{
            s.is_srgb=false;s.sampler=ImageSampler::Descriptor(settings.clone());}).load(TEXTURE);
        let colors:Vec<_>=lifetime_colors()?.into_iter().chain(lifetime_colors_for(Phase::Startup)?).collect();
        let lookup=colors.iter().map(|color|images.add(lookup_image(color))).collect();
        Ok((Profile {births:vec![BirthProfile::load(Side::Order).map_err(str::to_owned)?,BirthProfile::load(Side::Chaos).map_err(str::to_owned)?,
            BirthProfile::load_startup(Side::Order).map_err(str::to_owned)?,BirthProfile::load_startup(Side::Chaos).map_err(str::to_owned)?],
            colors,geometry:Geometry::crown(),texture,lookup,overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png"),sampler,
            armed:false,invalidated:false,events:default()},State::new(seed),seed))
    })();diagnostic.local_reconstruction=true;
    match result {Ok((p,s,seed))=>{commands.insert_resource(p);commands.insert_resource(s);diagnostic.rng_seed=Some(seed);},Err(e)=>diagnostic.error=Some(e)}
}
pub fn synchronize(world:&mut World) {
    let Some(mut backend)=world.remove_resource::<Backend>() else{return};
    let mut diagnostic=world.remove_resource::<Diagnostics>().unwrap_or_default();let old=diagnostic.error.clone();
    diagnostic.local_reconstruction=true;diagnostic.native_complete=false;diagnostic.gpu_draw_qualified=false;
    let result=(||->Result<(),String>{
        let frame=world.get_resource::<Host>().ok_or("Crown IdleParticles host missing")?.frame.clone();
        let now=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("Crown effect clock missing")?.now;
        let Some(mut profile)=world.remove_resource::<Profile>() else{return Err("Crown profile unavailable".into())};
        let inner=(||->Result<(),String>{
            let state=world.get_resource::<State>().ok_or("Crown state unavailable")?;
            if state.session==frame.session && frame.ordinal<=state.ordinal{return Ok(());}
            if let Some(events)=world.get_resource::<Messages<AssetEvent<Image>>>() {
                let watched:Vec<_>=std::iter::once(profile.texture.id()).chain(profile.lookup.iter().map(Handle::id)).chain(std::iter::once(profile.overlay.id())).collect();
                for event in profile.events.read(events) {if matches!(event,AssetEvent::Modified{id}|AssetEvent::Removed{id} if profile.armed && watched.contains(id)) {profile.invalidated=true;}}
            }
            let readiness=world.get_resource::<Assets<Image>>().ok_or_else(||"Crown images missing".to_owned()).and_then(|i|profile.validate(i));
            for r in &frame.requests {if crate::nexus_crown_state::side(r).map_err(str::to_owned)?.is_some()
                && (world.get_entity(r.owner.actor).is_err() || world.get_entity(r.bone).is_err()) {return Err("Crown bound actor or bone missing".into());}}
            let Some(planned)=state.planned(&frame,now,&profile.births,readiness.is_ok())? else{return Ok(())};
            if let Err(e)=readiness {
                // Advance private expiry/time only. Loading never consumes RNG or
                // fabricates old births; retry only with a current real pose.
                world.insert_resource(planned);return Err(e.into());
            }
            let visibility=world.get_resource::<crate::fow_gpu::Images>().ok_or("Crown FoW output absent")?.output.clone();
            let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("Crown native extent absent")?.geometry.extent;
            let mut packets=Vec::new();packets.try_reserve_exact(planned.live_count()).map_err(|_|"Crown packet reservation failed")?;
            for slot in &planned.slots {
                if !slot.seen {continue;}
                let Some(r)=frame.requests.iter().find(|r|r.cycle==slot.cycle && r.descriptor.slot==slot.key.slot) else{continue};
                for particle in &slot.particles {packets.push(prepare_particle(&profile,slot,particle,r.owner,visibility.clone(),extent)?);}
            }
            backend.publish(world,frame.ordinal,packets)?;
            profile.armed=true;world.insert_resource(planned);Ok(())
        })();world.insert_resource(profile);inner
    })();
    diagnostic.error=result.err();if diagnostic.error.is_some(){backend.clear(world);}
    diagnostic.draws=backend.draws.len();
    if let Some(state)=world.get_resource::<State>() {diagnostic.ordinal=state.ordinal;diagnostic.emitters=state.slots.len();
        diagnostic.particles=state.live_count();diagnostic.missing_pose_frames=state.slots.iter().map(|s|s.missing_pose_frames).sum();}
    if diagnostic.error!=old {if let Some(e)=&diagnostic.error{warn!("Nexus Crown local reconstruction: {e}");}}
    world.insert_resource(diagnostic);world.insert_resource(backend);
}

#[cfg(test)]
#[path="nexus_crown_live_tests.rs"]
mod tests;
