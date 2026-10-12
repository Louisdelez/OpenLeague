#[allow(dead_code)] #[path="../src/native_font_material.rs"] mod native_font_material;
use native_font_material::{FontMaterial,Parameters};
use bevy::{prelude::*,asset::RenderAssetUsages,camera::RenderTarget,core_pipeline::tonemapping::Tonemapping,image::ImageSampler,render::{gpu_readback::{Readback,ReadbackComplete},render_resource::{Extent3d,TextureDimension,TextureFormat,TextureUsages},renderer::RenderAdapterInfo,RenderApp},ui_render::{UiMaterialPlugin,ui_material::MaterialNode},window::{WindowPlugin,ExitCondition},winit::WinitPlugin};
#[derive(Resource,Default)] struct State {frames:usize,targets:Vec<(String,Handle<Image>,serde_json::Value)>,queued:bool,reports:Vec<serde_json::Value>}
fn main() {
    let backend=std::env::args().nth(1).unwrap_or("vulkan".into());let mut app=App::new();
    app.add_plugins(DefaultPlugins.set(AssetPlugin {file_path:"E:/OpenLeague/assets".into(),..default()}).set(WindowPlugin {primary_window:None,exit_condition:ExitCondition::DontExit,..default()}).disable::<WinitPlugin>().disable::<bevy::render::pipelined_rendering::PipelinedRenderingPlugin>()).add_plugins(UiMaterialPlugin::<FontMaterial>::default()).init_resource::<State>().add_systems(Startup,setup).add_systems(Update,queue_readbacks);
    app.finish();app.cleanup();
    for _ in 0..600 {app.update();if app.world().resource::<State>().reports.len()==7 {break};std::thread::sleep(std::time::Duration::from_millis(20));}
    let state=app.world().resource::<State>();assert_eq!(state.reports.len(),7,"UI glyph readbacks timed out");let adapter=app.sub_app(RenderApp).world().resource::<RenderAdapterInfo>();assert_eq!(format!("{:?}",adapter.backend).to_lowercase(),backend);
    let proof=serde_json::json!({"passed":true,"complete":false,"backend":format!("{:?}",adapter.backend),"adapter":adapter.name,"passes":state.reports,"source_glyph_cases":5,"production_material":"native_font_material::FontMaterial","production_shader":"assets/shaders/native_font_ui.wgsl","limits":["Production UI material renders synthetic BGRA textures plus actual native FreeType glyphs from5archived source families through offscreen cameras. Synthetic pixels use rational HLSL/blend reference; actual glyph pixels compare archived-source CPU atlas coverage/UV and native blend arithmetic, not original-game glyph pixel identity.","Native glyph layout, source color swizzle/filtering and final game viewport color-space context remain open; no original-game framebuffer reference or HUD widget acceptance."]});std::fs::write(format!("logs/native-font-ui-source-{backend}-gpu.json"),serde_json::to_vec_pretty(&proof).unwrap()).unwrap();println!("Native UI font material {backend}:28672pixels verified,including5source glyphs");
}
fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<FontMaterial>>,mut state:ResMut<State>) {
    let size=Extent3d {width:64,height:64,depth_or_array_layers:1};let mut bytes=Vec::new();for y in 0..64u8 {for x in 0..64u8 {let fill=x*4;bytes.extend([(y*4).min(255-fill),0,fill,255]);}}
    let mut font=Image::new(size,TextureDimension::D2,bytes,TextureFormat::Bgra8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);font.sampler=native_font_material::sampler(0,false).unwrap();let mut glow_font=font.clone();glow_font.sampler=native_font_material::sampler(0,true).unwrap();let font=images.add(font);let glow_font=images.add(glow_font);
    let mut fill=Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![64,128,192,128],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);fill.sampler=native_font_material::sampler(1,false).unwrap();let fill=images.add(fill);
    for (order,name) in ["fill_outline","glow"].into_iter().enumerate() {
        let mut target=Image::new(size,TextureDimension::D2,vec![0;16384],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);target.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;let target=images.add(target);
        let camera=commands.spawn((Camera2d,Camera {order:order as isize,clear_color:ClearColorConfig::Custom(Color::linear_rgba(32./255.,64./255.,96./255.,128./255.)),..default()},RenderTarget::Image(target.clone().into()),Tonemapping::None,Msaa::Off)).id();
        let material=materials.add(FontMaterial {parameters:Parameters {uv:Vec4::new(0.,0.,1.,1.),fill_uv:Vec4::new(0.,0.,1.,1.),color0:Vec4::new(0.75,0.5,0.25,0.8),color1:Vec4::new(0.25,0.75,0.5,0.6)},font:if name=="glow" {glow_font.clone()}else {font.clone()},fill:fill.clone(),glow:name=="glow"});
        commands.spawn((MaterialNode(material),Node {position_type:PositionType::Absolute,left:Val::Px(0.),top:Val::Px(0.),width:Val::Px(64.),height:Val::Px(64.),..default()},UiTargetCamera(camera)));let reference:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_raster_reference.json")).unwrap();state.targets.push((name.into(),target,reference[name].clone()));
    }
    // Actual archived source glyphs exercise native FreeType, packing, pixels, UV and UI raster.
    for (index,file,character) in [(0,"GillSansMTPro-Medium.otf",0x0041u16),(1,"GillSansMTProCyr-Medium.otf",0x0416),(2,"GillSansMTProGrk-Medium.otf",0x03a9),(3,"ARIALUNI.TTF",0x4e2d),(4,"UttumDotum.ttf",0xac00)] {
        use openleague_font_raster::{Face,native_font_atlas::Bank,native_text_measure::node,native_font_atlas_pixels::update};
        let bytes=std::fs::read(format!("assets/fonts/native4.20/{file}")).unwrap();let mut face=Face::new(bytes).unwrap();assert_eq!(face.version(),[2,4,8]);face.fit(48,16,96,96,10000).unwrap();let glyph=face.native_glyph(character).unwrap();assert!(glyph.bitmap.coverage.iter().any(|v|*v>0));
        let cell=node(character,&glyph.metrics,0,16);assert!(cell.width>0 && cell.height>0 && cell.width<64 && cell.height<64);let mut bank=Bank::default();let binding=bank.request(&cell).unwrap();assert_eq!(bank.pages[0].size,256);
        let pixels=update(&bank.page_cells(0).unwrap(),256,0,false,|_|Ok(glyph.bitmap.clone())).unwrap();
        let mut font_image=Image::new(Extent3d {width:256,height:256,depth_or_array_layers:1},TextureDimension::D2,pixels.clone(),TextureFormat::Bgra8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);font_image.sampler=native_font_material::sampler(0,false).unwrap();let font_image=images.add(font_image);
        let mut white=Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);white.sampler=native_font_material::sampler(1,false).unwrap();let white=images.add(white);
        let mut target=Image::new(size,TextureDimension::D2,vec![0;16384],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);target.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;let target=images.add(target);
        let camera=commands.spawn((Camera2d,Camera {order:2+index,clear_color:ClearColorConfig::Custom(Color::linear_rgba(32./255.,64./255.,96./255.,128./255.)),..default()},RenderTarget::Image(target.clone().into()),Tonemapping::None,Msaa::Off)).id();
        let material=materials.add(FontMaterial {parameters:Parameters {uv:Vec4::from_array(binding.placement.uv),fill_uv:Vec4::new(0.,0.,1.,1.),color0:Vec4::ONE,color1:Vec4::ZERO},font:font_image,fill:white,glow:false});
        commands.spawn((MaterialNode(material),Node {position_type:PositionType::Absolute,left:Val::Px(0.),top:Val::Px(0.),width:Val::Px(cell.width as f32),height:Val::Px(cell.height as f32),..default()},UiTargetCamera(camera)));
        let mut expected=Vec::new();for y in 0..64 {for x in 0..64 {
            if x<cell.width as usize && y<cell.height as usize {
                let coverage=u32::from(pixels[(y*256+x)*4+2]);let inverse=255-coverage;
                let mut rgba=[0u32;4];for (channel,background) in [32u32,64,96].into_iter().enumerate() {rgba[channel]=(coverage*255+background*inverse+127)/255;}rgba[3]=((inverse*383+127)/255).min(255);expected.push(rgba);
            }else {expected.push([32,64,96,128]);}
        }}
        state.targets.push((format!("source_glyph_{character:04x}"),target,serde_json::to_value(expected).unwrap()));
    }

}
fn queue_readbacks(mut commands:Commands,mut state:ResMut<State>) {
    state.frames+=1;if state.frames<100 || state.queued {return};state.queued=true;
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_raster_reference.json")).unwrap();
    for (name,target,reference) in &state.targets {
        let name=name.clone();let expected=reference.clone();
        commands.spawn(Readback::texture(target.clone())).observe(move |event:On<ReadbackComplete>,mut state:ResMut<State>,mut commands:Commands| {
            assert_eq!(event.data.len(),16384);let mut maximum_error=0i32;
            for (index,pixel) in expected.as_array().unwrap().iter().enumerate() {for channel in 0..4 {let value=pixel[channel].as_i64().unwrap() as i32;let actual=event.data[index*4+channel] as i32;let error=(value-actual).abs();assert!(error<=1,"UI{name} pixel{index} channel{channel}: actual{actual} reference{value}");maximum_error=maximum_error.max(error);}}
            state.reports.push(serde_json::json!({"pass":name,"pixels":4096,"channels":16384,"maximum_byte_error":maximum_error}));commands.entity(event.entity).despawn();
        });
    }
}
