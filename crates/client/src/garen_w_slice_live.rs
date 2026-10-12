//! Local ordinary-W activation of the original base shimmer profile.
//! Cast identity/age comes from the existing accepted snapshot journal. The
//! original six-effect script caller and full native emitter cadence remain open.
use bevy::prelude::*;
use bevy::image::{ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode};
use openleague_core::{garen_w_shimmer_profile,native_simple_type11_draw as draw};
use crate::{garen_w_slice_host as host,garen_w_slice_material as material};

#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub active:usize,pub last_ages:Vec<(u32,f32)>}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Diagnostics>().init_resource::<host::Requests>().init_resource::<host::Host>()
            .add_plugins((MaterialPlugin::<material::SliceMaterial>::default(),crate::garen_w_slice_readiness::Plugin))
            .add_systems(Startup,setup.after(crate::fow_visibility_texture::setup))
            .add_systems(PostUpdate,(update_requests,host::synchronize).chain()
                .after(bevy::transform::TransformSystems::Propagate).after(bevy::asset::AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate))
            .add_systems(PostUpdate,probe.after(host::synchronize));
    }
}

/// Native wrap/clamp addressing; filtering is an explicit renderer adaptation
/// until the original sampler-device producer is qualified.
/// Raw BC3 data is mandatory: converting Scroll.r from sRGB changes the slice.
fn scroll_sampler()->ImageSamplerDescriptor {
    ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,
        mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,
        lod_min_clamp:0.,lod_max_clamp:0.,..default()}
}
fn lookup_sampler()->ImageSamplerDescriptor {
    ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,
        mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,
        lod_min_clamp:0.,lod_max_clamp:7.,..default()}
}
pub fn setup(mut commands:Commands,assets:Res<AssetServer>,fog:Res<crate::fow_gpu::Images>,mut diagnostics:ResMut<Diagnostics>) {
    let result=(||->Result<host::Profile,String>{
        garen_w_shimmer_profile::authored()?;
        let textures=material::LinearTextures::load(&assets,scroll_sampler(),lookup_sampler())?;
        host::Profile::new(assets.load(crate::garen_w_material_host::BASE_MODEL),textures,fog.output.clone(),
            assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png"),1,
            host::ResidualBudget {absolute:0.0001,relative:0.000002})
    })();
    match result {Ok(profile)=>{commands.insert_resource(profile);},Err(error)=>{
        warn!("Courage shimmer initialization: {error}");diagnostics.error=Some(error);
    }}
}

fn frame(root:&Transform,scale:f32)->Result<draw::Frame,String> {
    if !root.translation.is_finite()||!root.rotation.is_finite()||!root.scale.is_finite() {
        return Err("nonfinite Courage owner transform".into())
    }
    // Bevy column-major storage is the native row-major transposed representation.
    // Actor scale/translation return to original model units; the private palette
    // adapter applies 1/20 once at the final world transform.
    // native_troy_owner_pose clears the provider matrix translation; particle
    // position travels separately. Zero attachment offset and the original
    // default system scale factors BC=C0=E0=1 form the declared local adapter.
    let owner=Mat4::from_scale_rotation_translation(root.scale*20.,root.rotation,Vec3::ZERO);
    Ok(draw::Frame {position:(root.translation*20.).to_array().map(f32::to_bits),
        right:[1f32,0.,-0.].map(f32::to_bits),up:[0f32,1.,-0.].map(f32::to_bits),
        scale:scale.to_bits(),matrix:owner.to_cols_array().map(f32::to_bits)})
}

pub fn update_requests(state:Res<crate::Match>,clock:Res<crate::native_effect_clock::EffectClock>,
    transforms:Query<&Transform>,profile:Option<Res<host::Profile>>,fog:Res<crate::fow_visibility_texture::VisibilityTexture>,
    map:Res<crate::map10_vision_view::Map10VisionView>,mut requests:ResMut<host::Requests>,mut diagnostics:ResMut<Diagnostics>) {
    diagnostics.active=0;diagnostics.last_ages.clear();
    let session=state.snapshot.as_ref().map(|snapshot|snapshot.session);
    let result=(||->Result<Vec<host::Request>,String>{
        if profile.is_none()||clock.diagnostic()["failed"].as_bool().unwrap_or(true) {return Ok(Vec::new())}
        let Some(snapshot)=state.snapshot.as_ref() else{return Ok(Vec::new())};
        let profile=garen_w_shimmer_profile::authored()?;
        let coordinates=fog.settings.shader_parameters(map.geometry.extent)?.coordinates;
        let fog_scale_offset=Vec4::new(coordinates[0]*20.,coordinates[1]*20.,coordinates[2],coordinates[3]);
        let mut desired=Vec::new();
        for player in &snapshot.players {
            if player.champion!="garen" {continue;}
            let Some(sustained)=state.w_visuals.0.sustained(player.id,clock.now) else {continue};
            let Some(sample)=profile.at_cast_age(sustained.age_seconds)? else {continue};
            let Some(root)=state.visuals.get(&player.id).copied() else {continue};
            let Ok(transform)=transforms.get(root) else {continue};
            let effect=sustained.identity.started.checked_add(1).ok_or("Courage shimmer identity exhausted")?;
            desired.push(host::Request {
                key:host::Key {session:snapshot.session,effect,source:player.id,root},
                frame:frame(transform,sample.scale)?,
                inputs:material::Inputs {
                    uv_scale_offset:Vec4::new(1.,1.,0.,0.),color_lookup:Vec2::from_array(sample.lookup),
                    color_factor:Vec4::ONE,slice_range:Vec2::from_array(sample.slice_range),fog_scale_offset,
                    output_encoding:material::OutputEncoding::RawNumeric,
                },
                // Host still requires its exact GPU ticket to be acknowledged.
                render_ready:true,
            });
            diagnostics.last_ages.push((player.id,sustained.age_seconds));
        }
        Ok(desired)
    })();
    let result=match result {Ok(rows)=>{diagnostics.active=rows.len();requests.replace(session,rows)},Err(error)=>{requests.clear();Err(error)}};
    let next=result.err();
    if next!=diagnostics.error {if let Some(error)=&next {warn!("Courage shimmer requests: {error}")};diagnostics.error=next;}
}

fn probe(state:Res<crate::Match>,clock:Res<crate::native_effect_clock::EffectClock>,diagnostics:Res<Diagnostics>,host:Res<host::Host>,
    draws:Query<(&host::Ticket,&ChildOf,&bevy::mesh::skinning::SkinnedMesh),With<host::Draw>>,
    skins:Query<&bevy::mesh::skinning::SkinnedMesh>,mut history:Local<Vec<serde_json::Value>>) {
    let Ok(path)=std::env::var("OPENLEAGUE_GAREN_SLICE_PROBE") else{return};
    let draws:Vec<_>=draws.iter().map(|(ticket,parent,skin)|serde_json::json!({
        "source":ticket.key.source,"effect":ticket.key.effect,"root":format!("{:?}",ticket.key.root),
        "draw":format!("{:?}",ticket.draw),"mesh":format!("{:?}",ticket.mesh),"generation":ticket.generation,
        "private_joints":skin.joints.iter().map(|id|format!("{id:?}")).collect::<Vec<_>>(),
        "original_joints":skins.get(parent.parent()).ok().map(|source|source.joints.iter().map(|id|format!("{id:?}")).collect::<Vec<_>>()),
    })).collect();
    let issues:Vec<_>=host.issues.iter().map(|(key,error)|serde_json::json!({"source":key.source,"effect":key.effect,"error":error})).collect();
    if history.len()==512 {history.remove(0);}
    history.push(serde_json::json!({"time":clock.now,"session":state.snapshot.as_ref().map(|s|s.session),
        "tick":state.snapshot.as_ref().map(|s|s.tick),"ages":diagnostics.last_ages,"error":diagnostics.error,
        "owners":host.owners(),"published":host.published(),"installed":host.installed,"retired":host.retired,
        "maximum_inverse_bind_residual":host.maximum_residual,"issues":issues,"draws":draws}));
    let report=serde_json::json!({"activation":"local_committed_W_identity","native_six_effect_caller":false,
        "sampler_filtering":"local_linear","full_shader_equivalence":false,"frames":*history});
    if let Err(error)=std::fs::write(path,serde_json::to_vec(&report).unwrap()) {warn!("Courage shimmer probe: {error}")}
}
