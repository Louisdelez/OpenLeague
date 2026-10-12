//! Offscreen qualification of native recharge fragment math and alpha blend.
//! This is not an ordinary game HUD or the native LineStrip draw.
use bevy::{prelude::*,asset::RenderAssetUsages,camera::RenderTarget,core_pipeline::tonemapping::Tonemapping,render::{gpu_readback::{Readback,ReadbackComplete},render_resource::{Extent3d,TextureDimension,TextureFormat,TextureUsages},renderer::RenderAdapterInfo,RenderApp},ui_render::{UiMaterialPlugin,ui_material::MaterialNode},window::{WindowPlugin,ExitCondition},winit::WinitPlugin};
use crate::native_hud_recharge_material::{RechargeMaterial,Parameters};
const WIDTH:usize=64;
const CASES:usize=15;
#[derive(Resource,Default)] struct State {frames:usize,queued:bool,targets:Vec<(usize,Handle<Image>,Vec<[u8;4]>)>,reports:Vec<serde_json::Value>}
pub fn run() {
 let backend=std::env::var("WGPU_BACKEND").expect("explicit probe backend");let mut app=App::new();
 app.add_plugins(DefaultPlugins.set(AssetPlugin {file_path:"E:/OpenLeague/assets".into(),..default()}).set(WindowPlugin {primary_window:None,exit_condition:ExitCondition::DontExit,..default()}).disable::<WinitPlugin>().disable::<bevy::render::pipelined_rendering::PipelinedRenderingPlugin>()).add_plugins(UiMaterialPlugin::<RechargeMaterial>::default()).init_resource::<State>().add_systems(Startup,setup).add_systems(Update,queue);
 app.finish();app.cleanup();for _ in 0..600 {app.update();if app.world().resource::<State>().reports.len()==CASES {break;}std::thread::sleep(std::time::Duration::from_millis(20));}
 let state=app.world().resource::<State>();assert_eq!(state.reports.len(),CASES,"recharge GPU readbacks missing");let adapter=app.sub_app(RenderApp).world().resource::<RenderAdapterInfo>();assert_eq!(format!("{:?}",adapter.backend).to_lowercase(),backend);
 let proof=serde_json::json!({"passed":true,"complete":false,"backend":format!("{:?}",adapter.backend),"adapter":adapter.name,"cases":state.reports,"pixels":WIDTH*WIDTH*CASES,"path":"native_hud_recharge_material -> native_hud_recharge.wgsl -> native alpha blend","limits":["Supplied normalized UV quad, five angles and three linear UNORM backgrounds. Original source colors used; no texture or vertex color used by the native fragment shader.","Offscreen fragment shader and blend only. Native matrices, indexed LineStrip, live snapshot transport, ordinary HUD, gamma and original game framebuffer identity remain unqualified."]});std::fs::write(format!("logs/native-hud-recharge-{backend}-gpu.json"),serde_json::to_vec_pretty(&proof).unwrap()).unwrap();println!("Recharge {backend}: {} pixels checked",WIDTH*WIDTH*CASES);
}
fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<RechargeMaterial>>,mut state:ResMut<State>) {
 let factor=f32::from_bits(0x3b808081);let color1=Vec4::new(0.,0.,128.*factor,180.*factor);
 for (a,remaining) in [0.,2.5,5.,7.5,10.].into_iter().enumerate() {for (b,background) in [[0u8;4],[32,64,96,128],[255,255,255,255]].into_iter().enumerate() {
  let case=a*3+b;let params=crate::native_hud_recharge::angle(remaining,10.).unwrap();let mut expected=Vec::with_capacity(WIDTH*WIDTH);
  for y in 0..WIDTH {for x in 0..WIDTH {let uv=Vec2::new((x as f32+0.5)/WIDTH as f32,(y as f32+0.5)/WIDTH as f32);let src=crate::native_hud_recharge::shade(uv,params,Vec4::ZERO,color1).unwrap().clamp(Vec4::ZERO,Vec4::ONE);expected.push(std::array::from_fn(|c|(src[c]*255.+background[c] as f32*(1.-src.w)).round().clamp(0.,255.) as u8));}}
  let mut target=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH*4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);target.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;let target=images.add(target);
  let c=background.map(|n|n as f32/255.);let camera=commands.spawn((Camera2d,Camera {order:case as isize,clear_color:ClearColorConfig::Custom(Color::linear_rgba(c[0],c[1],c[2],c[3])),..default()},RenderTarget::Image(target.clone().into()),Tonemapping::None,Msaa::Off)).id();
  commands.spawn((Node {position_type:PositionType::Absolute,left:Val::Px(0.),top:Val::Px(0.),width:Val::Px(WIDTH as f32),height:Val::Px(WIDTH as f32),..default()},MaterialNode(materials.add(RechargeMaterial {parameters:Parameters {params,color0:Vec4::ZERO,color1}})),UiTargetCamera(camera)));
  state.targets.push((case,target,expected));
 }}
}
fn queue(mut commands:Commands,mut state:ResMut<State>) {
 state.frames+=1;if state.frames<100 || state.queued {return;}state.queued=true;
 for (case,target,expected) in &state.targets {let case=*case;let expected=expected.clone();commands.spawn(Readback::texture(target.clone())).observe(move |event:On<ReadbackComplete>,mut state:ResMut<State>,mut commands:Commands| {
  assert_eq!(event.data.len(),WIDTH*WIDTH*4);let mut maximum_error=0;for (index,pixel) in expected.iter().enumerate() {for c in 0..4 {let error=(event.data[index*4+c] as i32-pixel[c] as i32).abs();assert!(error<=1,"case{case} pixel{index} channel{c}: GPU{} CPU{}",event.data[index*4+c],pixel[c]);maximum_error=maximum_error.max(error);}}
  state.reports.push(serde_json::json!({"case":case,"pixels":WIDTH*WIDTH,"maximum_byte_error":maximum_error}));commands.entity(event.entity).despawn();
 });}
}
