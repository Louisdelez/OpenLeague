//! Transport of qualified CPU expansion into a render-world Image asset.
//! Raw visibility only: native fade/blur, material sampling and backend readback remain open.
use bevy::{prelude::*,asset::RenderAssetUsages,image::{ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode},render::render_resource::{Extent3d,TextureDimension,TextureFormat}};
const DIM:usize=128;
const WIDTH:usize=DIM*4;
#[derive(Default)]
pub struct Staging {session:Option<(u64,u8)>,previous:f32,pub pixels:Vec<u8>,pub uploads:u64}
impl Staging {
    pub fn prepare(&mut self,session:(u64,u8),now:f32,source:&[u8])->Result<bool,&'static str> {
        if source.len()!=DIM*DIM {return Err("Map10 visibility source size mismatch");}
        if !now.is_finite() || now<0. {return Err("invalid visibility upload clock");}
        let reset=self.session!=Some(session);
        let previous=if reset {0.}else{self.previous};
        let due=crate::fow_timing::upload_due(now,previous)?;
        if reset {
            // Explicit Bevy allocation adapter: native untouched corners' allocation contents are unknown.
            self.pixels=vec![0;WIDTH*WIDTH];self.previous=0.;self.session=Some(session);
        }
        if due {crate::fow_upscale::expand_native(source,DIM,&mut self.pixels,WIDTH)?;self.previous=now;self.uploads+=1;}
        Ok(reset || due)
    }
}
#[derive(Resource)]
pub struct VisibilityTexture {pub image:Handle<Image>,pub settings:crate::fow_settings::Settings,pub staging:Staging,last_error:Option<&'static str>}
pub fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>) {
    let settings=crate::fow_settings::Settings::map10();
    // This qualified Map10 pipeline requires the native default upscale choice.
    // A different map/configuration must construct its own texture dimensions.
    assert!(settings.upscale,"Map10 recovered configuration requires native upscale");
    let mut image=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH],TextureFormat::R8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
    // Bevy transport sampler; native device/sampler producer qualification remains pending.
    image.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,lod_min_clamp:0.,lod_max_clamp:0.,..default()});
    let image=images.add(image);
    let gpu=crate::fow_gpu::Images::new(image.clone(),&mut images,settings.blur_kernel_sigma);
    crate::fow_gpu::observe_readback(&mut commands,&gpu);commands.insert_resource(gpu);
    commands.insert_resource(VisibilityTexture {image,settings,staging:Staging::default(),last_error:None});
}
pub fn update(state:Res<crate::Match>,connection:Res<crate::Connection>,map:Res<crate::map10_vision_view::Map10VisionView>,time:Res<Time>,mut texture:ResMut<VisibilityTexture>,mut images:ResMut<Assets<Image>>) {
    let (Some(snapshot),Some(viewer))=(&state.snapshot,connection.id) else {return;};
    let result=(|| {
        let team=snapshot.roster.iter().find(|p|p.id==viewer).ok_or("missing texture viewer roster")?.team;
        if team>1 {return Err("unsupported texture viewer team");}
        // Validate the destination before committing staging timestamps.
        let mut image=images.get_mut(&texture.image).ok_or("missing visibility Image asset")?;
        let view=map.view.lock().map_err(|_|"poisoned visibility view")?;
        if texture.staging.prepare((snapshot.session,team),time.elapsed_secs(),&view.circle.layer.pixels)? {image.data=Some(texture.staging.pixels.clone());}
        Ok(())
    })();
    let error=result.err();if error!=texture.last_error {if let Some(e)=error {eprintln!("OpenLeague visibility texture: {e}");}texture.last_error=error;}
    if let Ok(path)=std::env::var("OPENLEAGUE_VISIBILITY_TEXTURE_PROBE") {
        let report=serde_json::json!({"complete":false,"width":WIDTH,"height":WIDTH,"format":"R8Unorm","native_upscale":texture.settings.upscale,"native_blur_sigma":texture.settings.blur_kernel_sigma,"configuration_profile":"native_map10_inibin_no_launch_override","logical_configuration":crate::map10_native_config::LOGICAL_PATH,"binary_configuration":crate::map10_native_config::PHYSICAL_PATH,"uploads":texture.staging.uploads,"nonzero_texels":texture.staging.pixels.iter().filter(|v|**v!=0).count(),"error":texture.last_error,"render_asset_registered":images.get(&texture.image).is_some(),"gpu_readback_verified":false,"material_bound":false,"limits":["Raw visibility only; native fade/blur and material binding pending.","Corner allocation and sampler are explicit Bevy adapters; original initialization/device producers remain open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn transport_keeps_native_cadence_flip_boundary_and_session_isolation() {
        let mut staging=Staging::default();let mut source=vec![0;DIM*DIM];source[3*DIM+8]=255;
        assert!(staging.prepare((1,0),0.,&source).unwrap());assert_eq!(staging.uploads,0);
        assert!(!staging.prepare((1,0),0.2,&source).unwrap());
        assert!(staging.prepare((1,0),f32::from_bits(0.2f32.to_bits()+1),&source).unwrap());
        let mut expected=vec![0;WIDTH*WIDTH];crate::fow_upscale::expand_native(&source,DIM,&mut expected,WIDTH).unwrap();assert_eq!(staging.pixels,expected);
        assert!(staging.pixels[10*WIDTH..20*WIDTH].iter().any(|v|*v!=0));assert!(staging.pixels[WIDTH*400..].iter().all(|v|*v==0));
        // Team change before the next upload never leaks the previous team's texture.
        assert!(staging.prepare((1,1),0.1,&source).unwrap());assert!(staging.pixels.iter().all(|v|*v==0));
        assert!(staging.prepare((2,1),0.3,&vec![0;DIM*DIM]).unwrap());assert!(staging.pixels.iter().all(|v|*v==0));
        let before=staging.pixels.clone();let previous=staging.previous;assert!(staging.prepare((2,1),0.4,&[]).is_err());assert!(staging.prepare((2,1),0.2,&source).is_err());assert_eq!(staging.previous,previous);assert_eq!(staging.pixels,before);
    }
}

/// Explicit screenshot diagnostic; normal material color is unchanged until full factors qualify.
pub fn diagnostic_enabled()->bool {std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var("OPENLEAGUE_FOW_MASK_PROBE").as_deref()==Ok("1")}
pub fn bind_materials(gpu:Res<crate::fow_gpu::Images>,texture:Res<VisibilityTexture>,map:Res<crate::map10_vision_view::Map10VisionView>,mut terrain:ResMut<Assets<crate::terrain_material::TerrainMaterial>>,mut environment:ResMut<Assets<crate::map_fog::FogMaterial>>,assets:Res<AssetServer>,mut projected:ResMut<Assets<crate::projected_render::ProjectedMaterial>>) {
    let uniforms=texture.settings.shader_parameters(map.geometry.extent).expect("qualified native Map10 FoW uniforms");
    let native=Vec4::from_array(uniforms.coordinates);
    let below=crate::native_fow::always_below_params();let height=Vec4::from_array(uniforms.height);let edge=Vec4::from_array(uniforms.edge);
    let params=Vec4::new(native.x*20.,native.y*20.,native.z,native.w);
    // Native catalog-qualified fallback overlay; original DDS conversion is pixel-equal.
    let overlay:Handle<Image>=assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png");
    let ids:Vec<_>=projected.iter().filter(|(_,m)|m.visibility_map!=gpu.output || m.visibility_params!=params || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in ids {let mut m=projected.get_mut(id).expect("existing projected material");m.visibility_map=gpu.output.clone();m.visibility_overlay=overlay.clone();m.visibility_params=params;m.visibility_edge=edge;m.visibility_ready=1;}

    // Assets::iter_mut marks every visited asset modified. Inspect immutably first,
    // then mutate only missing bindings, including new assets added after startup.
    let terrain_ids:Vec<_>=terrain.iter().filter(|(_,m)|m.visibility_map!=gpu.output || m.visibility_params!=params || m.visibility_height!=height || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_below!=below || m.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in terrain_ids {let mut m=terrain.get_mut(id).expect("existing terrain material");m.visibility_map=gpu.output.clone();m.visibility_params=params;m.visibility_height=height;m.visibility_edge=edge;m.visibility_overlay=overlay.clone();m.visibility_below=below;m.visibility_ready=1;m.visibility_diagnostic=if parameter_diagnostic_enabled() {2} else {u32::from(diagnostic_enabled())};}
    let environment_ids:Vec<_>=environment.iter().filter(|(_,m)|m.extension.visibility_map!=gpu.output || m.extension.visibility_params!=params || m.extension.visibility_height!=height || m.extension.visibility_edge!=edge || m.extension.visibility_overlay!=overlay || m.extension.visibility_below!=below || m.extension.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in environment_ids {let mut m=environment.get_mut(id).expect("existing environment material");m.extension.visibility_map=gpu.output.clone();m.extension.visibility_params=params;m.extension.visibility_height=height;m.extension.visibility_edge=edge;m.extension.visibility_overlay=overlay.clone();m.extension.visibility_below=below;m.extension.visibility_ready=1;}
}

pub fn parameter_diagnostic_enabled()->bool {std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var("OPENLEAGUE_FOW_PARAMETER_PROBE").as_deref()==Ok("1")}
