//! Actual indexed LineStrip readback. Native D3D9 pixel raster identity is unqualified.
use bevy::{prelude::*,asset::RenderAssetUsages,camera::{RenderTarget,visibility::RenderLayers},core_pipeline::tonemapping::Tonemapping,render::{gpu_readback::{Readback,ReadbackComplete},render_resource::{Extent3d,TextureDimension,TextureFormat,TextureUsages},renderer::RenderAdapterInfo,RenderApp},sprite_render::Material2dPlugin,window::{WindowPlugin,ExitCondition},winit::WinitPlugin};
use crate::native_hud_recharge_line::{self,LineMaterial,Parameters};
const WIDTH:usize=64;const CASES:usize=18;
#[derive(Clone)] struct Case {index:usize,target:Handle<Image>,points:[Vec2;3],color:Vec4}
#[derive(Resource,Default)] struct State {frames:usize,queued:bool,targets:Vec<Case>,reports:Vec<serde_json::Value>}
pub fn run() {
 let backend=std::env::var("WGPU_BACKEND").expect("explicit probe backend");let mut app=App::new();
 app.add_plugins(DefaultPlugins.set(AssetPlugin {file_path:"E:/OpenLeague/assets".into(),..default()}).set(WindowPlugin {primary_window:None,exit_condition:ExitCondition::DontExit,..default()}).disable::<WinitPlugin>().disable::<bevy::render::pipelined_rendering::PipelinedRenderingPlugin>()).add_plugins(Material2dPlugin::<LineMaterial>::default()).init_resource::<State>().add_systems(Startup,setup).add_systems(Update,queue);
 app.finish();app.cleanup();for _ in 0..600 {app.update();if app.world().resource::<State>().reports.len()==CASES {break;}std::thread::sleep(std::time::Duration::from_millis(20));}
 let state=app.world().resource::<State>();assert_eq!(state.reports.len(),CASES,"LineStrip GPU readbacks missing");let adapter=app.sub_app(RenderApp).world().resource::<RenderAdapterInfo>();assert_eq!(format!("{:?}",adapter.backend).to_lowercase(),backend);
 let proof=serde_json::json!({"passed":true,"complete":false,"backend":format!("{:?}",adapter.backend),"adapter":adapter.name,"cases":state.reports,"pixels":WIDTH*WIDTH*CASES,"path":"native geometry seven vertices -> U16 indices[4,5,6] -> LineStrip -> native vertex/pixel shader ports","limits":["Supplied normalized-to-clip matrix,64-square viewport and source rect. Native projection/context/gamma are not qualified. Mesh transport preserves attributes and source line indices, not native interleaved buffer layout.","Checks coverage near both native segments and shader premultiplication. Does not claim identical D3D9 edge coverage, original game framebuffer, ordinary HUD or current live cooldown integration."]});std::fs::write(format!("logs/native-hud-recharge-line-{backend}-gpu.json"),serde_json::to_vec_pretty(&proof).unwrap()).unwrap();println!("LineStrip {backend}: {CASES} cases checked");
}
fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>,mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<LineMaterial>>,mut state:ResMut<State>) {
 for index in 0..CASES {
  let angle=if index==17 {std::f32::consts::FRAC_PI_2}else {std::f32::consts::TAU*index as f32/16.};let direction=crate::native_hud_recharge::direction(angle).unwrap().1;
  let packed=if index==17 {0x80ff8040}else {0xff8080ff};let color=crate::native_font_material::packed_color(packed);let vertices=crate::native_hud_recharge::geometry([0.125,0.125,0.875,0.875],[WIDTH as u32;2],packed).unwrap();
  let points=std::array::from_fn(|i| {let v=vertices[i+4];(Vec2::new(v.position[0],v.position[1])+direction.truncate().truncate()*Vec2::from_array(v.uv)*direction.z)*WIDTH as f32});
  let mut target=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH*4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);target.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;let target=images.add(target);
  commands.spawn((Camera2d,Camera {order:index as isize,clear_color:ClearColorConfig::Custom(Color::linear_rgba(0.,0.,0.,0.)),..default()},RenderTarget::Image(target.clone().into()),Tonemapping::None,Msaa::Off,RenderLayers::layer(index)));
  commands.spawn((Mesh2d(meshes.add(native_hud_recharge_line::mesh(&vertices))),MeshMaterial2d(materials.add(LineMaterial {parameters:Parameters {projection:native_hud_recharge_line::viewport_projection(),direction}})),Transform::default(),RenderLayers::layer(index)));
  state.targets.push(Case {index,target,points,color});
 }
}
fn distance(p:Vec2,a:Vec2,b:Vec2)->f32 {let d=b-a;if d.length_squared()==0. {return p.distance(a);}let t=((p-a).dot(d)/d.length_squared()).clamp(0.,1.);p.distance(a+t*d)}
fn queue(mut commands:Commands,mut state:ResMut<State>) {
 state.frames+=1;if state.frames<100 || state.queued {return;}state.queued=true;
 for case in &state.targets {let case=case.clone();commands.spawn(Readback::texture(case.target.clone())).observe(move |event:On<ReadbackComplete>,mut state:ResMut<State>,mut commands:Commands| {
  assert_eq!(event.data.len(),WIDTH*WIDTH*4);let mut colored=Vec::new();let mut max_distance=0f32;let one=(case.color.truncate()*case.color.w).extend(case.color.w);let two=one+one*(1.-one.w);
  for index in 0..WIDTH*WIDTH {let pixel=&event.data[index*4..index*4+4];if pixel[3]==0 {assert_eq!(pixel,[0;4]);continue;}
   let p=Vec2::new((index%WIDTH) as f32+0.5,(index/WIDTH) as f32+0.5);let distances=[distance(p,case.points[0],case.points[1]),distance(p,case.points[1],case.points[2])];let near=distances[0].min(distances[1]);assert!(near<=1.1,"case{} pixel{index} outside line {near}",case.index);max_distance=max_distance.max(near);colored.push(p);
   let error=|want:Vec4| (0..4).map(|c|(pixel[c] as i32-(want[c]*255.).round() as i32).abs()).max().unwrap();let err=if distances.iter().all(|d|*d<=1.1) {error(one).min(error(two))}else {error(one)};assert!(err<=1,"case{} pixel{index} RGBA{pixel:?}, expected{one:?}",case.index);
  }
  assert!((20..130).contains(&colored.len()),"case{} colored{}: wrong primitive/empty draw",case.index,colored.len());
  for segment in 0..2 {for step in 1..10 {let p=case.points[segment].lerp(case.points[segment+1],step as f32/10.);assert!(colored.iter().any(|q|q.distance(p)<=1.6),"case{} missing segment{segment} sample{step}",case.index);}}
  let backend=std::env::var("WGPU_BACKEND").unwrap();std::fs::write(format!("logs/native-hud-recharge-line-{backend}-case{}.rgba",case.index),&event.data).unwrap();state.reports.push(serde_json::json!({"case":case.index,"pixels":WIDTH*WIDTH,"colored_pixels":colored.len(),"maximum_segment_distance_pixels":max_distance,"points":case.points.map(|p|p.to_array()),"color":case.color.to_array()}));commands.entity(event.entity).despawn();
 });}
}
