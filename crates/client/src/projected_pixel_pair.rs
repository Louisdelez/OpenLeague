//! Opt-in same-frame GPU A/B views. Never enabled in ordinary gameplay.
use bevy::{prelude::*,asset::RenderAssetUsages,camera::{RenderTarget,visibility::RenderLayers},
    core_pipeline::{tonemapping::Tonemapping,schedule::camera_driver},
    render::{RenderApp,extract_resource::{ExtractResource,ExtractResourcePlugin},
        render_asset::RenderAssets,texture::GpuImage,renderer::{RenderContext,RenderDevice,RenderGraph},
        render_resource::*,gpu_readback::{Readback,ReadbackComplete}}};
const W:u32=1280;const H:u32=800;
#[derive(Component)] struct PairCamera;
#[derive(Resource,Clone,ExtractResource)]
struct Pair {on:Handle<Image>,off:Handle<Image>,atlas:Handle<Image>,time:f32,draws:u32,entity:u64,effect_time:u32,paused:u32,ready:bool}
#[derive(Resource,Default)] struct Serial(u32);
#[derive(Resource)] struct Results {path:std::path::PathBuf,rows:Vec<serde_json::Value>,saved:std::collections::HashSet<u64>,cleanup_saved:std::collections::HashSet<u64>,paused_frames:Vec<u32>}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        let Some(path)=std::env::var_os("OPENLEAGUE_PROJECTED_PIXEL_PAIR").map(std::path::PathBuf::from)
            .filter(|p|p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs"))) else{return;};
        app.insert_resource(Results{path,rows:Vec::new(),saved:default(),cleanup_saved:default(),paused_frames:Vec::new()})
            .add_plugins(ExtractResourcePlugin::<Pair>::default())
            .add_systems(Update,setup.after(crate::projected_live::update))
            .add_systems(PostUpdate,frame.before(bevy::transform::TransformSystems::Propagate));
        app.sub_app_mut(RenderApp).init_resource::<Serial>()
            .add_systems(RenderGraph,copy.after(camera_driver));
    }
}
fn image(w:u32,h:u32)->Image {
    let mut i=Image::new(Extent3d{width:w,height:h,depth_or_array_layers:1},TextureDimension::D2,
        vec![0;(w*h*4) as usize],TextureFormat::Rgba8UnormSrgb,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
    i.texture_descriptor.usage=TextureUsages::RENDER_ATTACHMENT|TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST;i
}
fn setup(mut commands:Commands,existing:Option<Res<Pair>>,mut images:ResMut<Assets<Image>>,
    cameras:Query<(Entity,&Transform,&Projection,&Msaa,&Camera), (With<Camera3d>,Without<PairCamera>)>) {
    if existing.is_some(){return;}
    let Some((main,transform,projection,msaa,camera))=cameras.iter().next() else{return;};
    let on=images.add(image(W,H));let off=images.add(image(W,H));let atlas=images.add(image(W*2,H+1));
    commands.entity(main).insert(RenderLayers::from_layers(&[0,1]));
    for (target,order,layers) in [(on.clone(),-2,RenderLayers::from_layers(&[0,1])),(off.clone(),-1,RenderLayers::layer(0))] {
        commands.spawn((PairCamera,Camera3d::default(),Camera{order,invert_culling:camera.invert_culling,..default()},RenderTarget::Image(target.into()),
            *transform,projection.clone(),if std::env::var("OPENLEAGUE_PAIR_NO_MSAA").as_deref()==Ok("1"){Msaa::Off}else{*msaa},
            Tonemapping::None,{
                let mut gamma=crate::native_gamma::Map10Gamma::native_map10();
                if std::env::var("OPENLEAGUE_PAIR_NO_GAMMA").as_deref()==Ok("1"){gamma.state.x=0.;}
                gamma
            },layers));
    }
    commands.spawn(Readback::texture(atlas.clone())).observe(read);
    commands.insert_resource(Pair{on,off,atlas,time:0.,draws:0,entity:0,effect_time:0,paused:0,ready:std::env::var("OPENLEAGUE_PAIR_TARGET").as_deref()==Ok("ready")});
}
fn frame(mut commands:Commands,time:Res<Time>,clock:Res<crate::native_effect_clock::EffectClock>,pair:Option<ResMut<Pair>>,
    draws:Query<Entity,With<crate::projected_live::ProjectedDraw>>,ready:Query<Entity,With<crate::annie_ready::ReadyQuad>>) {
    let Some(mut pair)=pair else{return;};pair.time=time.elapsed_secs();pair.effect_time=(clock.now as f32).to_bits();pair.paused=u32::from(clock.paused());let mut selected:Vec<_>=if pair.ready {ready.iter().collect()}else{draws.iter().collect()};
    selected.sort_by_key(|e|e.to_bits());pair.draws=selected.len() as u32;
    pair.entity=selected.first().map_or(0,|e|e.to_bits());
    for entity in selected {commands.entity(entity).insert(RenderLayers::layer(1));}
}
fn copy(mut context:RenderContext,images:Res<RenderAssets<GpuImage>>,pair:Option<Res<Pair>>,device:Res<RenderDevice>,mut serial:ResMut<Serial>,phases:Res<bevy::render::render_phase::ViewSortedRenderPhases<bevy::core_pipeline::core_3d::Transparent3d>>) {
    let Some(pair)=pair else{return;};
    let (Some(on),Some(off),Some(atlas))=(images.get(pair.on.id()),images.get(pair.off.id()),images.get(pair.atlas.id())) else{return;};
    for (source,x) in [(on,0),(off,W)] {
        context.command_encoder().copy_texture_to_texture(source.texture.as_image_copy(),TexelCopyTextureInfo{
            texture:&atlas.texture,mip_level:0,origin:Origin3d{x,y:0,z:0},aspect:TextureAspect::All},Extent3d{width:W,height:H,depth_or_array_layers:1});
    }
    serial.0+=1;
    if pair.paused!=0 && std::env::var("OPENLEAGUE_PAIR_PHASE_TRACE").as_deref()==Ok("1") {
        if let Some(path)=std::env::var_os("OPENLEAGUE_PROJECTED_PIXEL_PAIR").map(std::path::PathBuf::from).filter(|p|p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs"))) {
            use std::io::Write;
            let views:Vec<_>=phases.0.iter().map(|(view,phase)|serde_json::json!({"view":format!("{view:?}"),"items":phase.items.values().map(|item|serde_json::json!({"entity":item.entity.1.id().to_bits(),"distance_bits":item.distance.to_bits(),"batch_start":item.batch_range.start,"batch_end":item.batch_range.end})).collect::<Vec<_>>()})).collect();
            if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path.with_extension("phase.jsonl")) {
                let _=writeln!(file,"{}",serde_json::json!({"gpu_frame":serial.0,"effect_time_bits":pair.effect_time,"views":views}));
            }
        }
    }

    // This header is copied by the same encoder after both cameras. Async readback
    // therefore retains the rendered frame identity, rather than callback time.
    let mut data=vec![0u8;256];
    for (i,word) in [0x4f4c5052,serial.0,pair.draws,pair.time.to_bits(),pair.entity as u32,(pair.entity>>32) as u32,pair.effect_time,pair.paused].iter().enumerate() {
        data[i*4..i*4+4].copy_from_slice(&word.to_le_bytes());
    }
    let buffer=device.create_buffer_with_data(&BufferInitDescriptor{label:Some("projected-pair-frame-header"),contents:&data,usage:BufferUsages::COPY_SRC});
    context.command_encoder().copy_buffer_to_texture(TexelCopyBufferInfo{buffer:&buffer,layout:TexelCopyBufferLayout{offset:0,bytes_per_row:Some(256),rows_per_image:Some(1)}},
        TexelCopyTextureInfo{texture:&atlas.texture,mip_level:0,origin:Origin3d{x:0,y:H,z:0},aspect:TextureAspect::All},Extent3d{width:8,height:1,depth_or_array_layers:1});
}
fn read(event:On<ReadbackComplete>,mut result:ResMut<Results>) {
    let data=&event.data;let header=(W*2*H*4) as usize;
    if data.len()!=(W*2*(H+1)*4) as usize{return;}
    let word=|n:usize|u32::from_le_bytes(data[header+n*4..header+n*4+4].try_into().unwrap());
    if word(0)!=0x4f4c5052{return;}
    let entity=word(4) as u64|((word(5) as u64)<<32);let mut changed=0usize;let mut max=0u8;let mut energy=0u64;
    let mut bounds=[W,H,0,0];
    for y in 0..H {for x in 0..W {
        let a=((y*W*2+x)*4) as usize;let b=a+(W*4) as usize;
        let pixel=(0..3).map(|c|data[a+c].abs_diff(data[b+c])).max().unwrap();
        max=max.max(pixel);energy+=pixel as u64;
        if pixel>0 {changed+=1;bounds[0]=bounds[0].min(x);bounds[1]=bounds[1].min(y);bounds[2]=bounds[2].max(x);bounds[3]=bounds[3].max(y);}
    }}
    let output=if !result.saved.contains(&entity) && ((entity==0 && f32::from_bits(word(3))>=24.)|| (entity!=0 && changed>0)) {
        let p=result.path.with_extension(format!("entity-{entity}.rgba"));
        if std::fs::write(&p,data).is_ok(){result.saved.insert(entity);Some(p.to_string_lossy().into_owned())}else{None}
    } else {None};
    // Keep the actual post-draw atlas with its GPU frame header, instead of
    // treating an asynchronous primary-window screenshot as a cleanup receipt.
    let previous_active=result.rows.iter().filter(|r|r["draws"].as_u64().unwrap_or(0)>0
        && r["gpu_frame"].as_u64().unwrap_or(u64::MAX)<u64::from(word(1)))
        .max_by_key(|r|r["gpu_frame"].as_u64()).map(|r|r["entity"].as_u64().unwrap());
    let cleanup_rgba=if word(2)==0 && changed==0 {
        previous_active.and_then(|owner| {
            if result.cleanup_saved.contains(&owner){return None;}
            let p=result.path.with_extension(format!("entity-{owner}-clean.rgba"));
            // Publish only complete atlases: fixture shutdown may interrupt this callback.
            let pending=p.with_extension("rgba.pending");
            // Never overwrite a published atlas: journal rows must retain their exact frame.
            std::fs::write(&pending,data).and_then(|_|std::fs::rename(&pending,&p)).ok().map(|_|{result.cleanup_saved.insert(owner);p.to_string_lossy().into_owned()})
        })
    } else {None};
    // Save even zero-contribution paused frames: absence is useful evidence.
    let paused_rgba=if word(7)!=0 && word(2)>0 && result.paused_frames.len()<2
        && result.paused_frames.first().is_none_or(|first|word(1)>=first.saturating_add(10)) {
        let p=result.path.with_extension(format!("paused-{}.rgba",word(1)));let pending=p.with_extension("rgba.pending");
        std::fs::write(&pending,data).and_then(|_|std::fs::rename(&pending,&p)).ok().map(|_|{result.paused_frames.push(word(1));p.to_string_lossy().into_owned()})
    } else {None};
    result.rows.push(serde_json::json!({"gpu_frame":word(1),"time":f32::from_bits(word(3)),"draws":word(2),"entity":entity,"effect_time_bits":word(6),"paused":word(7)!=0,
        "paused_rgba":paused_rgba,"cleanup_rgba":cleanup_rgba,"changed_pixels":changed,"max_rgb_difference":max,"difference_energy":energy,"bounds":if changed>0{Some(bounds)}else{None},"rgba":output}));
    let report=serde_json::json!({"complete":false,"same_frame_gpu_pair":true,"target":if std::env::var("OPENLEAGUE_PAIR_TARGET").as_deref()==Ok("ready"){"ready"}else{"projected"},"width_each":W,"height":H,"rgba_atlas_header_row":true,"diagnostic_no_gamma":std::env::var("OPENLEAGUE_PAIR_NO_GAMMA").as_deref()==Ok("1"),"diagnostic_no_msaa":std::env::var("OPENLEAGUE_PAIR_NO_MSAA").as_deref()==Ok("1"),
        "rows":result.rows,"limits":["Opt-in duplicate camera views render the same scene snapshot; only selected effect render layer differs. Raw atlas and frame metadata copied after both camera passes, before one GPU readback.","Baseline equality must pass; no original D3D pixel equivalence, audio or full kit acceptance."]});
    let pending=result.path.with_extension("json.pending");
    if let Err(e)=std::fs::write(&pending,serde_json::to_vec_pretty(&report).unwrap()).and_then(|_|std::fs::rename(&pending,&result.path)){warn!("Projected GPU pair: {e}");}
}
