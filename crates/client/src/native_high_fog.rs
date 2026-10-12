//! Map10 native fog/cloud binding from the qualified environment setting suffix.
//! Cloud phase uses the qualified native GameClock delta; settings dispatch remains partial.
use bevy::{prelude::*,image::{ImageLoaderSettings,ImageSampler,ImageSamplerDescriptor,ImageFilterMode,ImageAddressMode}};
#[derive(Resource,Default)] pub struct CloudState {phase:crate::native_cloud_phase::Phase}
pub fn fog_vectors()->(Vec4,Vec4) {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 let v=|key:&str|Vec4::from_array(std::array::from_fn(|i|d[key][i].as_f64().unwrap() as f32));(v("fog_data0"),v("fog_data1"))
}
pub fn profile_uniform(setting:i32)->UVec4 {
 let p=crate::native_fog_profile::Profile::from_setting(setting);
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 UVec4::new(p.fog,u32::from(p.clouds),u32::from(d["enabled"].as_bool().unwrap()),0)
}
pub fn fog_constant()->Vec4 {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 Vec4::new(d["native_fog_rgb"][0].as_u64().unwrap() as f32/255.,d["native_fog_rgb"][1].as_u64().unwrap() as f32/255.,d["native_fog_rgb"][2].as_u64().unwrap() as f32/255.,1.)
}
pub fn synchronize(profile:UVec4,constants:Vec4,fog:&mut Assets<crate::map_fog::FogMaterial>,terrain:&mut Assets<crate::terrain_material::TerrainMaterial>,catalog:&mut crate::map_fog::FogCatalog) {
 catalog.extension.cloud_phase=constants;catalog.extension.fog_profile=profile;
 for (_,m) in fog.iter_mut() {m.extension.cloud_phase=constants;m.extension.fog_profile=profile;}
 for (_,m) in terrain.iter_mut() {m.cloud_phase=constants;m.fog_profile=profile;}
}
pub fn cloud_image(assets:&AssetServer)->Handle<Image> {
 assets.load_builder().with_settings(|s:&mut ImageLoaderSettings| {
 s.is_srgb=false;s.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()});
 }).load("maps/terrain_native/cloudOpacityMap.ktx2")
}
pub fn advance(quality:Res<crate::native_environment_draw::Quality>,delta:Res<bevy::animation::AnimationDelta>,mut state:ResMut<CloudState>,mut fog:ResMut<Assets<crate::map_fog::FogMaterial>>,mut terrain:ResMut<Assets<crate::terrain_material::TerrainMaterial>>,mut catalog:ResMut<crate::map_fog::FogCatalog>) {
 state.phase.advance(delta.0,delta.0,0.009999999776482582,0.009999999776482582);
 let constants=Vec4::from_array(state.phase.constants(2000.));
 synchronize(profile_uniform(quality.value),constants,&mut fog,&mut terrain,&mut catalog);
}
