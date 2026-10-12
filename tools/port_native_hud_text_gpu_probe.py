from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_text_gpu_probe.rs';assert not p.exists()
p.write_text('''//! Offscreen integration probe of production packet/font/UI bridge; not ordinary HUD.
use bevy::{prelude::*,asset::RenderAssetUsages,camera::RenderTarget,core_pipeline::tonemapping::Tonemapping,render::{gpu_readback::{Readback,ReadbackComplete},render_resource::{Extent3d,TextureDimension,TextureFormat,TextureUsages},renderer::RenderAdapterInfo,RenderApp},ui_render::{UiMaterialPlugin,ui_material::MaterialNode},window::{WindowPlugin,ExitCondition,PrimaryWindow},winit::WinitPlugin};
use crate::{native_font_material::FontMaterial,native_font_gpu::Pages,native_font_metrics::{Faces,Dpi},native_hud_font_creation::Sizes,native_hud_text_render::{self,Context},native_hud_text_batch::{self,Input}};
#[derive(Resource,Default)] struct State {frames:usize,queued:bool,targets:Vec<(usize,Handle<Image>,Vec<[u8;4]>)>,reports:Vec<serde_json::Value>}
pub fn run() {
    let backend=std::env::var("WGPU_BACKEND").expect("explicit probe backend");let mut app=App::new();
    app.add_plugins(DefaultPlugins.set(AssetPlugin {file_path:"E:/OpenLeague/assets".into(),..default()}).set(WindowPlugin {primary_window:None,exit_condition:ExitCondition::DontExit,..default()}).disable::<WinitPlugin>().disable::<bevy::render::pipelined_rendering::PipelinedRenderingPlugin>()).add_plugins(UiMaterialPlugin::<FontMaterial>::default()).init_resource::<State>().add_systems(Startup,setup).add_systems(Update,queue);
    app.finish();app.cleanup();for _ in 0..600 {app.update();if app.world().resource::<State>().reports.len()==3 {break};std::thread::sleep(std::time::Duration::from_millis(20));}
    let state=app.world().resource::<State>();assert_eq!(state.reports.len(),3,"packet GPU readbacks missing");let adapter=app.sub_app(RenderApp).world().resource::<RenderAdapterInfo>();assert_eq!(format!("{:?}",adapter.backend).to_lowercase(),backend);
    let proof=serde_json::json!({"passed":true,"complete":false,"backend":format!("{:?}",adapter.backend),"adapter":adapter.name,"passes":state.reports,"pixels_per_backend":614400,"production_path":"native_hud_text_batch -> native_hud_text_render -> Pages::material_for_quad -> FontMaterial","limits":["Offscreen supplied ASCII A-space-V packets,3source Text bindings/alignments, explicit96DPI, glyph owner scale1, white fill and viewport offset0.5. Original text encoding supplier, packet context producer, projection and dynamic ordinary widgets not proven.","Compares port source atlas pixels and native blend arithmetic; original game framebuffer/font raster identity and full HUD visual acceptance remain open."]});std::fs::write(format!("logs/native-hud-text-{backend}-gpu.json"),serde_json::to_vec_pretty(&proof).unwrap()).unwrap();println!("HUD packet bridge {backend}:614400pixels checked");
}
fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<FontMaterial>>,mut state:ResMut<State>) {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let mut source=App::new();
    source.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,crate::native_font_metrics::Plugin));source.world_mut().spawn((Window {resolution:(256,800).into(),..default()},PrimaryWindow));source.update();let sizes=source.world_mut().remove_resource::<Sizes>().unwrap();let mut faces=source.world_mut().non_send_resource_mut::<Faces>();
    let mut pages=Pages::default();let mut white=Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);white.sampler=crate::native_font_material::sampler(1,false).unwrap();let white=images.add(white);
    for (order,text) in [0usize,1,153].into_iter().enumerate() {
        let batch=native_hud_text_batch::prepare(&[Input {flags:if order==1 {0x81}else{1},font:1,alignment:order as u32,color:0xffa1b2c3,rect:[0.1,0.08,0.7,0.16],text:b"A V"}],[1.0,1.0,0.0,0.0]).unwrap();let bindings=std::collections::BTreeMap::from([(1,text)]);
        let prepared=native_hud_text_render::prepare(&mut faces,&sizes,&batch,&Context {viewport:[256,800],packet_scalar:1.0,glyph_owner_scale:1.0},&bindings,|b|if b.is_ascii() {Ok(b.iter().map(|c|*c as u16).collect())}else {Err("probe ASCII only".into())}).unwrap();
        pages.sync(&faces,&sizes,&mut images).unwrap();let payloads=native_hud_text_render::ui_payloads(&prepared,&faces,&sizes,&pages,white.clone(),Vec2::splat(0.5)).unwrap();assert_eq!(payloads.len(),2);
        let mut expected=vec![[32u8,64,96,128];256*800];
        for (node,material) in &payloads {
            let (Val::Px(left),Val::Px(top),Val::Px(width),Val::Px(height))=(node.left,node.top,node.width,node.height) else {panic!("pixel nodes required")};let font=images.get(&material.font).unwrap();let atlas=font.data.as_ref().unwrap();let size=font.texture_descriptor.size.width as usize;let uv=material.parameters.uv;let c=material.parameters.color0.to_array();assert_eq!(material.parameters.color1,Vec4::ZERO);
            for y in top as i32..(top+height) as i32 {for x in left as i32..(left+width) as i32 {if !(0..256).contains(&x) || !(0..800).contains(&y) {continue}
                let u=uv.x+((x as f32+0.5-left)/width)*(uv.z-uv.x);let v=uv.y+((y as f32+0.5-top)/height)*(uv.w-uv.y);let ax=((u*size as f32).floor() as usize).min(size-1);let ay=((v*size as f32).floor() as usize).min(size-1);let coverage=atlas[(ay*size+ax)*4+2] as f32/255.0;let af=c[3]*coverage;let inverse=1.0-af;let dst=&mut expected[y as usize*256+x as usize];for channel in 0..3 {dst[channel]=(255.0*af*c[channel]+dst[channel] as f32*inverse).round().clamp(0.0,255.0) as u8;}dst[3]=(255.0*inverse+dst[3] as f32*inverse).round().clamp(0.0,255.0) as u8;
            }}
        }
        let mut target=Image::new(Extent3d {width:256,height:800,depth_or_array_layers:1},TextureDimension::D2,vec![0;256*800*4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);target.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;let target=images.add(target);
        let camera=commands.spawn((Camera2d,Camera {order:order as isize,clear_color:ClearColorConfig::Custom(Color::linear_rgba(32.0/255.0,64.0/255.0,96.0/255.0,128.0/255.0)),..default()},RenderTarget::Image(target.clone().into()),Tonemapping::None,Msaa::Off)).id();
        for (node,material) in payloads {commands.spawn((node,MaterialNode(materials.add(material)),UiTargetCamera(camera)));}
        state.targets.push((text,target,expected));
    }
}
fn queue(mut commands:Commands,mut state:ResMut<State>) {
    state.frames+=1;if state.frames<100 || state.queued {return};state.queued=true;
    for (text,target,expected) in &state.targets {let text=*text;let expected=expected.clone();commands.spawn(Readback::texture(target.clone())).observe(move |event:On<ReadbackComplete>,mut state:ResMut<State>,mut commands:Commands| {
        assert_eq!(event.data.len(),256*800*4);let mut maximum_error=0;for (index,pixel) in expected.iter().enumerate() {for c in 0..4 {let error=(event.data[index*4+c] as i32-pixel[c] as i32).abs();assert!(error<=1,"Text{text} pixel{index} channel{c}: GPU{} CPU{}",event.data[index*4+c],pixel[c]);maximum_error=maximum_error.max(error);}}
        state.reports.push(serde_json::json!({"source_text_binding":text,"pixels":204800,"channels":819200,"maximum_byte_error":maximum_error}));commands.entity(event.entity).despawn();
    });}
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod native_hud_text_gpu_probe;\n'+s;s=s.replace('fn main() {','fn main() {\n    if std::env::args().any(|a|a=="--native-hud-text-gpu-probe") {native_hud_text_gpu_probe::run();return}\n',1);p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Offscreen production HUD packet GPU probe installed; ordinary widget startup unchanged')
