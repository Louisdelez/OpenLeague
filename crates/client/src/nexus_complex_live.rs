//! Ordinary slot1 -> three startup / three on original mesh groups. This is a bounded local reconstruction
//! using qualified field/age/table functions, NOT the complete native Complex update.
use bevy::{asset::{AssetEvent, RenderAssetUsages}, ecs::message::MessageCursor,
    image::{ImageAddressMode, ImageFilterMode, ImageSampler, ImageSamplerDescriptor}, prelude::*,
    render::render_resource::{Extent3d, TextureDimension, TextureFormat}};
use openleague_core::{native_complex_color::ComplexColor, native_complex_particle_age,
    native_scalar_parameter::baked_scalar_index, native_vector_parameter::VectorParameter,
    native_integrated_vector::IntegrationMode, native_troy_owner_pose as pose,
    native_troy_properties::{Source, Emitter}, native_troy_position_bounds};
use crate::{nexus_complex_mesh::{Group, NativeWorld}, nexus_complex_host::{Backend, DrawPacket},
    nexus_complex_material::{self as material, Bindings, Inputs, OutputEncoding, Cull},
    nexus_idle_particles::{Host, Request}};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Side { Order, Chaos }
impl Side {
    fn resource(self,on:bool)->&'static str {match (self,on) {
        (Self::Order,false)=>"Order_Nexus.troy",(Self::Order,true)=>"Order_Nexus_on.troy",
        (Self::Chaos,false)=>"Chaos_Nexus.troy",(Self::Chaos,true)=>"Chaos_Nexus_on.troy",
    }}
}
#[derive(Clone)]
pub struct GroupProfile {
    resource: &'static str, render_mode:u32,
    /// Authored presence only. The bounded single-particle producer below does
    /// not simulate the full emitter lifetime/stop logic; missing stays missing.
    pub authored_emitter_life:Option<f32>,
    pub group: Group, pub life: f32, pub scale: Vec3, pub offset: Vec3, pub birth: [f32; 4],
    pub color: ComplexColor, rotation: Option<VectorParameter>, displacement: Option<VectorParameter>,
    on_rotation_velocity: Option<Vec3>,
    uv_scroll: Option<(openleague_core::native_complex_uv_scroll::Scroll,openleague_core::native_complex_uv_scroll::Flags)>,
    /// Authored sorting input is retained, but Bevy transparent distance order is
    /// still the local renderer policy; no native pass100 ordering is claimed.
    pub authored_pass: Option<u32>,
    base_rotation: Vec3, pub backface: bool,
}
fn numeric(value: &serde_json::Value) -> Option<Vec<f32>> {
    if let Some(n) = value.as_f64() { return Some(vec![n as f32]); }
    value.as_array()?.iter().map(|v| v.as_f64().map(|n| n as f32)).collect()
}
fn vector(g: &serde_json::Value, key: &str) -> Result<Vec3, String> {
    let n = numeric(&g[key]).filter(|n| n.len()==3 && n.iter().all(|x| x.is_finite()))
        .ok_or_else(|| format!("Nexus {key} is not a finite vector"))?;
    Ok(Vec3::new(n[0], n[1], n[2]))
}
pub fn profiles() -> Result<[GroupProfile;2],String> {profiles_for(Side::Order)}
pub fn profiles_for(side:Side) -> Result<[GroupProfile; 2], String> {
    let doc: serde_json::Value = serde_json::from_str(match side {
        Side::Order=>include_str!("../../../data/4.20/nexus_complex/groups.json"),
        Side::Chaos=>include_str!("../../../data/4.20/nexus_complex/chaos_groups.json"),
    })
        .map_err(|e| e.to_string())?;
    if doc["schema"] != 1 || doc["source_reference"] != side.resource(false) {
        return Err("Nexus bounded profile identity changed".into());
    }
    let mut out = Vec::new();
    for (i, group) in [Group::GemInside, Group::Gem].into_iter().enumerate() {
        let row = &doc["groups"][i]; let g = &row["fields"];
        if row["name"] != group.authored_name() || g["p-type"] != 3 || g["rendermode"] != 1
            || g["p-life"] != 89 || g["e-life"] != 1 || g["e-rate"] != 1 || g["single-particle"] != 1
            || g["p-mesh"] != "Nexus_Gem.sco"
        { return Err("Nexus bounded group definition changed".into()); }
        let lookup = |key: &str| numeric(&g[key]);
        let rotation = VectorParameter::read_nonrotation("p-xquadrot", [0.;3], 256, lookup)
            .map_err(|e| format!("Nexus rotation reader: {e:?}"))?.ok_or("Nexus rotation missing")?;
        // Qualified integral bake reused, but its application to this legacy
        // Particle-Velocity key / lifespan is a declared local movement policy.
        let displacement = VectorParameter::read_integrated("Particle-Velocity", [0.;3], 256,
            IntegrationMode::Once, lookup).map_err(|e| format!("Nexus velocity reader: {e:?}"))?
            .ok_or("Nexus velocity missing")?;
        let color = ComplexColor::from_lifetime_group(g).map_err(|e| format!("Nexus color reader: {e:?}"))?;
        let birth = ComplexColor::from_group(g).map_err(|e| format!("Nexus birth color: {e:?}"))?;
        if birth.table.len()!=1 || !color.reader_accepted
            || rotation.probabilities.iter().chain(&displacement.probabilities).any(|p| !p.constant || p.constant_value != 1.)
            || color.probabilities.iter().flatten().any(|p| !p.constant || p.constant_value != 1.)
        { return Err("Nexus random or changing emitter fields need a separate producer".into()); }
        out.push(GroupProfile { resource:side.resource(false),render_mode:1,authored_emitter_life:Some(1.),group, life: 89., scale: vector(g,"p-scale")?, offset: vector(g,"p-offset")?,
            base_rotation: vector(g,"p-quadrot")?, birth: birth.table[0], color, rotation:Some(rotation), displacement:Some(displacement),
            on_rotation_velocity:None,uv_scroll:None,authored_pass:None,
            backface: g["p-backfaceon"].as_f64() == Some(1.) });
    }
    out.try_into().map_err(|_| "Nexus needs exactly two groups".into())
}

/// The original Startup resource has a distinct group3, not the `_on` group2.
/// Its single-particle clock and local Euler/movement policy are shared with
/// the two existing Startup meshes; UV uses the qualified native scroll helper.
pub fn startup_sparkle_profile_for(side:Side)->Result<GroupProfile,String> {
    use openleague_core::{native_complex_uv_parameters::UvParameters,native_complex_uv_scroll::Flags};
    let doc:serde_json::Value=serde_json::from_str(match side {
        Side::Order=>include_str!("../../../data/4.20/nexus_complex/startup_sparkle_group.json"),
        Side::Chaos=>include_str!("../../../data/4.20/nexus_complex/chaos_startup_sparkle_group.json"),
    }).map_err(|e|e.to_string())?;
    let row=&doc["group"];let g=&row["fields"];
    // Class is absent in both originals. Keep absence in the export; the same
    // default Complex class is already used for their Startup gem/gem_inside.
    if doc["schema"]!=1 || doc["source_reference"]!=side.resource(false)
        || row["name"]!="gem_sparkle" || row["slot"]!=3 || !row["class"].is_null()
        || g.as_object().map(|o|o.len())!=Some(33)
        || g["p-type"]!=3 || g["p-life"]!=89 || g["e-life"]!=1 || g["e-rate"]!=1 || g["single-particle"]!=1
        || g["p-mesh"]!="Nexus_Gem_Sparkle.sco" || g["p-meshtex"]!="Nexus_Gem_Sparkle.tga"
        || g["rendermode"].as_f64()!=Some(0.) || g["pass"].as_f64()!=Some(100.)
        || g["p-backfaceon"].as_f64()!=Some(0.) || g["p-xquadrot-on"]!=1
        || g["e-linger"].as_f64()!=Some(0.) || g["p-linger"].as_f64()!=Some(0.)
    {return Err("Nexus Startup sparkle differs from the bounded original".into());}
    let lookup=|key:&str|numeric(&g[key]);
    let rotation=VectorParameter::read_nonrotation("p-xquadrot",[0.;3],256,lookup)
        .map_err(|e|format!("Nexus Startup sparkle rotation: {e:?}"))?.ok_or("Startup sparkle rotation missing")?;
    let displacement=VectorParameter::read_integrated("Particle-Velocity",[0.;3],256,IntegrationMode::Once,lookup)
        .map_err(|e|format!("Nexus Startup sparkle velocity: {e:?}"))?.ok_or("Startup sparkle velocity missing")?;
    let color=ComplexColor::from_lifetime_group(g).map_err(|e|format!("Nexus Startup sparkle color: {e:?}"))?;
    let birth=ComplexColor::from_group(g).map_err(|e|format!("Nexus Startup sparkle birth color: {e:?}"))?;
    if !color.reader_accepted || birth.table.len()!=1
        || rotation.probabilities.iter().chain(&displacement.probabilities).any(|p|!p.constant || p.constant_value!=1.)
        || color.probabilities.iter().chain(&birth.probabilities).flatten().any(|p|!p.constant || p.constant_value!=1.)
    {return Err("Nexus Startup sparkle random fields require a separate producer".into());}
    let uv=UvParameters::from_group(g).map_err(|e|format!("Nexus Startup sparkle UV reader: {e:?}"))?;
    if uv.parameters.iter().any(|p|p.table.len()!=1 || p.probabilities.iter().flatten().any(|q|!q.constant || q.constant_value!=1.)) {
        return Err("Nexus Startup sparkle random/changing UV birth is unsupported".into());
    }
    let scroll=uv.sample_birth(0.,1.).map_err(|e|format!("Nexus Startup sparkle UV birth: {e:?}"))?;
    let flags=Flags::from_binary_group(g,0).map_err(|e|format!("Nexus Startup sparkle UV flags: {e:?}"))?;
    if scroll.origin!=[[0.;2];2] || scroll.rate!=[[0.5,0.25],[0.,0.]] || flags!=Flags(0) {
        return Err("Nexus Startup sparkle UV contract changed".into());
    }
    Ok(GroupProfile {resource:side.resource(false),render_mode:0,authored_emitter_life:Some(1.),group:Group::GemSparkle,
        life:89.,scale:vector(g,"p-scale")?,offset:vector(g,"p-offset")?,birth:birth.table[0],color,
        rotation:Some(rotation),displacement:Some(displacement),on_rotation_velocity:None,
        uv_scroll:Some((scroll,flags)),authored_pass:Some(100),base_rotation:vector(g,"p-quadrot")?,backface:false})
}
fn startup_all_profiles_for(side:Side)->Result<Vec<GroupProfile>,String> {
    let mut groups=Vec::from(profiles_for(side)?);groups.push(startup_sparkle_profile_for(side)?);Ok(groups)
}

pub fn on_profiles()->Result<[GroupProfile;2],String> {on_profiles_for(Side::Order)}
pub fn on_profiles_for(side:Side) -> Result<[GroupProfile;2],String> {
    use openleague_core::native_complex_vectors::{ComplexVectors,Field};
    let doc:serde_json::Value=serde_json::from_str(match side {
        Side::Order=>include_str!("../../../data/4.20/nexus_complex/on_groups.json"),
        Side::Chaos=>include_str!("../../../data/4.20/nexus_complex/chaos_on_groups.json"),
    })
        .map_err(|e|e.to_string())?;
    if doc["schema"]!=1 || doc["source_reference"]!=side.resource(true) {
        return Err("Nexus on profile identity changed".into());
    }
    let mut out=Vec::new();
    for (i,group) in [Group::GemInside,Group::Gem].into_iter().enumerate() {
        let row=&doc["groups"][i];let g=&row["fields"];
        let mode=if i==0 {0} else {1};
        if row["name"]!=group.authored_name() || g["p-type"]!=3 || g["p-mesh"]!="Nexus_Gem.sco"
            || g["rendermode"].as_f64()!=Some(mode as f64) || g["e-life"]!=-1 || g["e-rate"]!=1
            || g["single-particle"]!=1 || g["p-life"].as_f64()!=Some(1_000_000.)
            || g.get("p-xrgba").is_some() || g.get("p-xquadrot").is_some() || g.get("Particle-Velocity").is_some()
            || g["p-meshtex"]!=match (side,i) {(Side::Order,0)=>"Order_Nexus_Gem_inside.tga",(Side::Order,_)=>"Order_Nexus_Gem.tga",
                (Side::Chaos,0)=>"Purple_Gem_inside.tga",(Side::Chaos,_)=>"Purple_Gem.tga"}
        { return Err("Nexus on group differs from the bounded original".into()); }
        let vectors=ComplexVectors::from_group(g).map_err(|e|format!("Nexus on vector reader: {e:?}"))?;
        if vectors.fields.iter().any(|f|f.table.len()!=1 || f.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.)) {
            return Err("Nexus on changing/random vectors require a separate producer".into());
        }
        let color=ComplexColor::from_lifetime_group(g).map_err(|e|format!("Nexus on lifetime color: {e:?}"))?;
        let birth=ComplexColor::from_group(g).map_err(|e|format!("Nexus on birth color: {e:?}"))?;
        if color.reader_accepted || color.table!=vec![[1.;4]] || color.probabilities.iter().any(Option::is_some)
            || birth.table.len()!=1 || birth.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.) {
            return Err("Nexus on color differs from qualified missing-field/default contract".into());
        }
        // Native missing p-xrgba produces white lifetime multiplier, not an
        // invented source texture. The real colored DDS and authored birth RGBA remain.
        out.push(GroupProfile {resource:side.resource(true),render_mode:mode,authored_emitter_life:Some(-1.),group,life:1_000_000.,
            scale:Vec3::from_array(vectors.field(Field::Scale).table[0]),
            offset:Vec3::from_array(vectors.field(Field::Offset).table[0]),
            base_rotation:Vec3::from_array(vectors.field(Field::QuadRotation).table[0]),
            birth:birth.table[0],color,rotation:None,displacement:None,
            on_rotation_velocity:Some(Vec3::from_array(vectors.field(Field::RotationVelocity).table[0])),
            uv_scroll:None,authored_pass:None,
            backface:g["p-backfaceon"].as_f64()==Some(1.)});
    }
    out.try_into().map_err(|_|"Nexus on needs exactly two groups".into())
}

pub fn sparkle_profile()->Result<GroupProfile,String> {sparkle_profile_for(Side::Order)}
pub fn sparkle_profile_for(side:Side) -> Result<GroupProfile,String> {
    use openleague_core::{native_complex_vectors::{ComplexVectors,Field},
        native_complex_uv_parameters::UvParameters,native_complex_uv_scroll::Flags};
    let doc:serde_json::Value=serde_json::from_str(match side {
        Side::Order=>include_str!("../../../data/4.20/nexus_complex/sparkle_group.json"),
        Side::Chaos=>include_str!("../../../data/4.20/nexus_complex/chaos_sparkle_group.json"),
    })
        .map_err(|e|e.to_string())?;
    let row=&doc["group"];let g=&row["fields"];
    if doc["schema"]!=1 || doc["source_reference"]!=side.resource(true)
        || row["name"]!="gem_sparkle" || row["class"]!="Complex" || row["slot"]!=2
        || g.as_object().map(|o|o.len())!=Some(if side==Side::Order {15} else {14})
        || g["p-type"]!=3 || g["p-mesh"]!="Nexus_Gem_Sparkle.sco" || g["p-meshtex"]!="Nexus_Gem_Sparkle.tga"
        || (if side==Side::Order {g["e-life"]!=-1} else {g.get("e-life").is_some()}) || g["e-rate"]!=1 || g["single-particle"]!=1
        || g["p-life"].as_f64()!=Some(1_000_000.) || g["rendermode"].as_f64()!=Some(0.)
        || g["p-backfaceon"].as_f64()!=Some(0.) || g["pass"].as_f64()!=Some(100.)
    { return Err("Nexus sparkle differs from the bounded original".into()); }
    let vectors=ComplexVectors::from_group(g).map_err(|e|format!("Nexus sparkle vectors: {e:?}"))?;
    if vectors.fields.iter().any(|f|f.table.len()!=1 || f.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.)) {
        return Err("Nexus sparkle changing/random vectors are unsupported".into());
    }
    let color=ComplexColor::from_lifetime_group(g).map_err(|e|format!("Nexus sparkle lifetime color: {e:?}"))?;
    let birth=ComplexColor::from_group(g).map_err(|e|format!("Nexus sparkle birth color: {e:?}"))?;
    if color.reader_accepted || color.table!=vec![[1.;4]] || color.probabilities.iter().any(Option::is_some)
        || birth.table.len()!=1 || birth.probabilities.iter().flatten().any(|p|!p.constant || p.constant_value!=1.) {
        return Err("Nexus sparkle color requires a different producer".into());
    }
    let uv=UvParameters::from_group(g).map_err(|e|format!("Nexus sparkle UV reader: {e:?}"))?;
    if uv.parameters.iter().any(|p|p.table.len()!=1 || p.probabilities.iter().flatten().any(|q|!q.constant || q.constant_value!=1.)) {
        return Err("Nexus sparkle random/changing UV birth is unsupported".into());
    }
    let scroll=uv.sample_birth(0.,1.).map_err(|e|format!("Nexus sparkle UV birth: {e:?}"))?;
    let flags=Flags::from_binary_group(g,0).map_err(|e|format!("Nexus sparkle UV flags: {e:?}"))?;
    if scroll.origin!=[[0.;2];2] || scroll.rate!=[[1.,0.5],[0.,0.]] || flags!=Flags(0) {
        return Err("Nexus sparkle UV contract changed".into());
    }
    Ok(GroupProfile {resource:side.resource(true),render_mode:0,
        authored_emitter_life:g.get("e-life").and_then(|v|v.as_f64()).map(|n|n as f32),group:Group::GemSparkle,life:1_000_000.,
        scale:Vec3::from_array(vectors.field(Field::Scale).table[0]),offset:Vec3::from_array(vectors.field(Field::Offset).table[0]),
        base_rotation:Vec3::from_array(vectors.field(Field::QuadRotation).table[0]),birth:birth.table[0],color,
        rotation:None,displacement:None,on_rotation_velocity:Some(Vec3::from_array(vectors.field(Field::RotationVelocity).table[0])),
        uv_scroll:Some((scroll,flags)),authored_pass:Some(100),backface:false})
}
fn on_all_profiles()->Result<Vec<GroupProfile>,String> {on_all_profiles_for(Side::Order)}
fn on_all_profiles_for(side:Side)->Result<Vec<GroupProfile>,String> {
    let mut groups=Vec::from(on_profiles_for(side)?);groups.push(sparkle_profile_for(side)?);Ok(groups)
}

struct Attachment { world: Mat4 }
impl pose::Backend for Attachment {
    fn eligible(&mut self)->u8 { 1 }
    fn position(&mut self)->Option<[u32;3]> { Some((self.world.w_axis.truncate()*20.).to_array().map(f32::to_bits)) }
    fn direction(&mut self)->Option<[u32;3]> { None }
    fn orientation(&mut self)->Option<[u32;16]> {
        // GLB vertices/bones retain native units; this affine maps them to D.
        // Convert its output basis back to native before clearing translation.
        Some((Mat4::from_scale(Vec3::splat(20.))*self.world).to_cols_array().map(f32::to_bits))
    }
    fn secondary_status(&mut self)->u8 { 0 }
    fn primary_status(&mut self)->u8 { 0 }
    fn deferred(&mut self,_:pose::DeferredCall,_:&mut Vec<pose::DeferredCall>) { unreachable!("no Nexus deferred callbacks") }
}
/// Reuse the original owner transfer's translation clearing, independently of
/// the locally adapted particle transform which follows it.
pub(crate) fn owner_pose(request: &Request) -> Result<(Mat4, Vec3), String> {
    if !request.attachment_world.is_finite() || request.native_idle_resource_flag != 0x10 {
        return Err("Nexus attachment/owner flags unavailable".into());
    }
    let identity = Mat4::IDENTITY.to_cols_array().map(f32::to_bits);
    let mut source=Source {requests:0,flags:0x10,visibility:0,params:[0;3],color:[0;8],matrix:identity,
        channels:[0;3],field_80:0,position:[0;3],direction:[0;3]};
    let mut emitter=Emitter {flags:0,source_flags:0x10,channels:[0;3],field_80:0,params:[0;3],color:[0;8],
        matrix:identity,bounds:native_troy_position_bounds::apply([0;3],0f32.to_bits()),direction:[0;3]};
    pose::transfer(&mut source,&mut emitter,pose::Config {group_vis:0f32.to_bits(),flags:0},true,
        &mut Vec::new(),&mut Attachment {world:request.attachment_world});
    Ok((Mat4::from_cols_array(&source.matrix.map(f32::from_bits)),Vec3::from_array(source.position.map(f32::from_bits))))
}

pub fn packet(profile: &GroupProfile, request: &Request, extent: f32) -> Result<Option<DrawPacket>, String> {
    if request.descriptor.resource!=profile.resource {return Err("Nexus packet resource/profile mismatch".into());}
    if !request.age_seconds.is_finite() || request.age_seconds < 0. || request.age_seconds > f32::MAX as f64 {
        return Err("Nexus elapsed clock is invalid".into());
    }
    let elapsed=request.age_seconds as f32;
    // Qualified strict > life predicate. No restart and no whole-resource completion.
    if elapsed > profile.life { return Ok(None); }
    let age=native_complex_particle_age::evaluate(elapsed,0.,profile.life).normalized;
    let index=baked_scalar_index(profile.color.table.len(),age).map_err(|e| format!("Nexus color age: {e:?}"))?;
    let rotation=match &profile.rotation {Some(p)=>Vec3::from_array(p.sample_instance_age(age,[1.;3]).map_err(|e|format!("Nexus rotation age: {e:?}"))?),None=>Vec3::ZERO};
    let displacement=match &profile.displacement {Some(p)=>Vec3::from_array(p.sample_instance_age(age,[1.;3]).map_err(|e|format!("Nexus motion age: {e:?}"))?)*profile.life,None=>Vec3::ZERO};
    let (orientation,position)=owner_pose(request)?;
    // LOCAL reconstruction boundaries: authored Euler values interpreted as degrees
    // XYZ; integrated velocity applies over normalized particle life; SCB origin is
    // retained rather than guessing mesh+A0/centre correction from 97EC60.
    // `_on`: native reader gives p-rotvel=[0,30,0]. Applying degrees/second
    // to elapsed phase age is a declared local angular-motion reconstruction.
    let angular=profile.on_rotation_velocity.map(|v|v*elapsed).unwrap_or(Vec3::ZERO);
    let angles=Vec3::from_array((profile.base_rotation+rotation+angular).to_array().map(f32::to_radians));
    let local=Mat4::from_translation(profile.offset+displacement)
        *Mat4::from_quat(Quat::from_euler(EulerRot::XYZ,angles.x,angles.y,angles.z))
        *Mat4::from_scale(profile.scale);
    let world=Mat4::from_translation(position)*orientation*local;
    let uv=profile.uv_scroll.map(|(state,flags)|state.update(elapsed,flags)[0]).unwrap_or([0.;2]);
    let input=Inputs {uv_scale_offset:Vec4::new(1.,1.,uv[0],uv[1]),
        lookup_uv:Vec2::new((index as f32+0.5)/profile.color.table.len() as f32,0.5),
        color_factor:Vec4::from_array(profile.birth), native_fog_extent:extent,
        output_encoding:OutputEncoding::DisplayToLinear,
        // Explicit local mapping; the native backface->device state is not yet qualified.
        cull:if profile.backface {Cull::None} else {Cull::Back},shader_features:0,fresnel:Vec4::ZERO,
        render_mode:profile.render_mode,render_flags:0};
    input.validate().map_err(str::to_owned)?;
    Ok(Some(DrawPacket {group:profile.group,world:NativeWorld(world.to_cols_array()),material:input}))
}

fn lookup_image(profile: &GroupProfile) -> Image {
    // Source curve table, not a white fallback. RGBA8 quantization and nearest
    // lookup replace the original renderer's table allocator/sampler in this host.
    let bytes:Vec<u8>=profile.color.table.iter().flatten().map(|c| (c.clamp(0.,1.)*255.).round() as u8).collect();
    let mut image=Image::new(Extent3d {width:profile.color.table.len() as u32,height:1,depth_or_array_layers:1},
        TextureDimension::D2,bytes,TextureFormat::Rgba8Unorm,RenderAssetUsages::default());
    image.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,
        address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Nearest,
        min_filter:ImageFilterMode::Nearest,mipmap_filter:ImageFilterMode::Nearest,..default()});
    image
}

struct ResourceProfile {groups:Vec<GroupProfile>,bindings:Bindings,armed:bool,invalidated:bool}
#[derive(Resource)]
struct Profile {resources:Vec<ResourceProfile>,events:MessageCursor<AssetEvent<Image>>}
#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub draws:usize,pub ages:Vec<(u64,f64)>,
    pub issues:Vec<(u32,String)>,
    pub local_reconstruction:bool,pub gpu_draw_qualified:bool}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.insert_resource(Backend::new(2).expect("two native Nexus source owners"))
            .init_resource::<Diagnostics>().add_plugins(crate::nexus_complex_host::Plugin)
            .add_systems(Startup,setup.after(crate::fow_visibility_texture::setup))
            .add_systems(PostUpdate,synchronize.after(crate::nexus_idle_particles::Published)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));
    }
}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut images:ResMut<Assets<Image>>,
    fog:Res<crate::fow_gpu::Images>,mut diagnostics:ResMut<Diagnostics>)
{
    let result=(||->Result<Profile,String>{
        // Filtering/wrap are stated host policies, not discovered D3D sampler state.
        let sampler=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,
            mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()};
        let mut make=|groups:Vec<GroupProfile>,set|->Result<ResourceProfile,String>{
            let textures=material::Textures::load_set(&assets,sampler.clone(),set).map_err(str::to_owned)?;
            let lookup=[images.add(lookup_image(&groups[0])),images.add(lookup_image(&groups[1]))];
            let sparkle_lookup=groups.get(2).map(|g|images.add(lookup_image(g)));
            Ok(ResourceProfile {groups,bindings:Bindings {textures,lookup,sparkle_lookup,visibility:fog.output.clone(),
                overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png")},armed:false,invalidated:false})
        };
        Ok(Profile {resources:vec![make(startup_all_profiles_for(Side::Order)?,material::TextureSet::StartupWithSparkle)?,make(on_all_profiles()?,material::TextureSet::On)?,
            make(startup_all_profiles_for(Side::Chaos)?,material::TextureSet::StartupWithSparkle)?,
            make(on_all_profiles_for(Side::Chaos)?,material::TextureSet::ChaosOn)?],events:default()})
    })();
    diagnostics.local_reconstruction=true;
    match result {Ok(profile)=>{commands.insert_resource(profile);},Err(e)=>{diagnostics.error=Some(e);}}
}
pub fn synchronize(world:&mut World) {
    let Some(mut backend)=world.remove_resource::<Backend>() else{return};
    let mut diagnostics=world.remove_resource::<Diagnostics>().unwrap_or_default();
    diagnostics.local_reconstruction=true;diagnostics.gpu_draw_qualified=false;diagnostics.draws=0;diagnostics.ages.clear();
    let previous=diagnostics.error.clone();diagnostics.issues.clear();
    if let Some(host)=world.get_resource::<Host>() {diagnostics.issues.extend(host.issues.iter().cloned());}
    let result=(||->Result<(),String>{
        let frame=world.get_resource::<Host>().ok_or("Nexus IdleParticles host missing")?.frame.clone();
        if !backend.reconcile(world,&frame).map_err(str::to_owned)? {return Ok(());}
        let Some(mut profile)=world.remove_resource::<Profile>() else{return Err("Nexus render profile unavailable".into())};
        let inner=(||->Result<(),String>{
            if let Some(events)=world.get_resource::<Messages<AssetEvent<Image>>>() {
                for event in profile.events.read(events) {
                    for resource in &mut profile.resources {
                        let ids=resource.bindings.watched_images();
                        match event {AssetEvent::Modified {id}|AssetEvent::Removed {id} if resource.armed && ids.contains(id)=>resource.invalidated=true,_=>{}}
                    }
                }
            }
            let visibility=world.get_resource::<crate::fow_gpu::Images>().ok_or("Nexus live FoW missing")?.output.clone();
            let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("Nexus native map extent missing")?.geometry.extent;
            for request in frame.requests.iter().filter(|r|r.descriptor.slot==1) {
                let result=(||->Result<usize,String>{
                    let resource=profile.resources.iter_mut().find(|p|p.groups.first().is_some_and(|g|g.resource==request.descriptor.resource))
                        .ok_or("Nexus renderer has no exact profile for this resource")?;
                    if resource.invalidated {return Err("Nexus render image changed; restart with verified sources".into());}
                    let images=world.get_resource::<Assets<Image>>().ok_or("Nexus images missing")?;
                    if resource.bindings.validate(images).is_err() || images.get(&resource.bindings.overlay).is_none() {
                        return Err("Nexus source images are still unavailable".into());
                    }
                    resource.armed=true;resource.bindings.visibility=visibility.clone();
                    diagnostics.ages.push((request.owner.effect_id,request.age_seconds));
                    let packets=resource.groups.iter().map(|p|packet(p,request,extent)).collect::<Result<Vec<_>,_>>()?.into_iter().flatten().collect();
                    let tickets=backend.replace_frame(world,request.owner,frame.ordinal,packets,&resource.bindings).map_err(str::to_owned)?;
                    for ticket in &tickets {backend.admit_cpu_resources(world,ticket).map_err(str::to_owned)?;}
                    Ok(tickets.len())
                })();
                match result {Ok(count)=>diagnostics.draws+=count,Err(error)=>{
                    backend.retire(world,request.owner);diagnostics.issues.push((request.cycle.source,error));
                }}
            }
            Ok(())
        })();
        world.insert_resource(profile);inner
    })();
    diagnostics.error=result.err();
    if diagnostics.error.is_some() {backend.clear(world);diagnostics.draws=0;}
    else if !diagnostics.issues.is_empty() {
        diagnostics.error=Some(diagnostics.issues.iter().map(|(id,e)|format!("source {id}: {e}")).collect::<Vec<_>>().join("; "));
    }
    if diagnostics.error!=previous {if let Some(e)=&diagnostics.error {warn!("Nexus Complex local reconstruction: {e}");}}
    world.insert_resource(diagnostics);world.insert_resource(backend);
}

#[cfg(test)]
#[path="nexus_complex_live_tests.rs"]
mod tests;
