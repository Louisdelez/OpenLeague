from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/examples/native_font_ui_probe.rs';s=p.read_text(encoding='utf-8')
s=s.replace('targets:Vec<(String,Handle<Image>)>','targets:Vec<(String,Handle<Image>,serde_json::Value)>')
s=s.replace('reports.len()==2','reports.len()==7').replace('state.reports.len(),2','state.reports.len(),7').replace('Native UI font material {backend}:8192pixels verified','Native UI font material {backend}:28672pixels verified,including5source glyphs')
s=s.replace('state.targets.push((name.into(),target));','''let reference:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_raster_reference.json")).unwrap();state.targets.push((name.into(),target,reference[name].clone()));''')
marker='\n}\nfn queue_readbacks';assert marker in s
addition='''
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
'''
s=s.replace(marker,addition+marker)
s=s.replace('for (name,target) in &state.targets {','for (name,target,reference) in &state.targets {').replace('let name=name.clone();let expected=proof[&name].clone();','let name=name.clone();let expected=reference.clone();')
s=s.replace('"production_material":"native_font_material::FontMaterial",','"source_glyph_cases":5,"production_material":"native_font_material::FontMaterial",')
s=s.replace('logs/native-font-ui-sampler-{backend}-gpu.json','logs/native-font-ui-source-{backend}-gpu.json')
s=s.replace('Production UI material and shader compile and render explicit synthetic BGRA font textures through Bevy offscreen cameras; every framebuffer byte compared against rational HLSL/blend reference.','Production UI material renders synthetic BGRA textures plus actual native FreeType glyphs from5archived source families through offscreen cameras. Synthetic pixels use rational HLSL/blend reference; actual glyph pixels compare archived-source CPU atlas coverage/UV and native blend arithmetic, not original-game glyph pixel identity.')
p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/extend_native_font_ui_source_glyphs.py'),r/'tools/extend_native_font_ui_source_glyphs.py');print('5actual source glyphs added to production UI GPU verification')
