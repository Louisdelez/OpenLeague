//! Live native-rate fade and separable Gaussian passes before camera rendering.
//! Compute transports qualified arithmetic; original D3D rasterization is separate.
use bevy::{prelude::*,asset::RenderAssetUsages,core_pipeline::schedule::camera_driver,render::{extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,render_resource::{binding_types::{texture_2d,sampler,uniform_buffer,texture_storage_2d},*},renderer::{RenderContext,RenderDevice,RenderGraph,RenderQueue},texture::GpuImage,Render,RenderApp,RenderStartup,RenderSystems}};
#[derive(Resource,Clone,ExtractResource)]
pub struct Images {pub source:Handle<Image>,fade:[Handle<Image>;2],horizontal:Handle<Image>,pub output:Handle<Image>,session:Option<(u64,u8)>,now:f32,sigma:f32,report:Option<String>}
impl Images {
    pub fn new(source:Handle<Image>,assets:&mut Assets<Image>,sigma:f32)->Self {
        let mut image=Image::new(Extent3d {width:512,height:512,depth_or_array_layers:1},TextureDimension::D2,vec![0;512*512*4],TextureFormat::Rgba8Unorm,RenderAssetUsages::RENDER_WORLD);
        image.texture_descriptor.usage=TextureUsages::TEXTURE_BINDING|TextureUsages::STORAGE_BINDING|TextureUsages::COPY_DST|TextureUsages::COPY_SRC;
        let fade=[assets.add(image.clone()),assets.add(image.clone())];let horizontal=assets.add(image.clone());let output=assets.add(image);
        Self {source,fade,horizontal,output,session:None,now:0.,sigma,report:std::env::var("OPENLEAGUE_FOW_GPU_PROBE").ok()}
    }
}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.add_plugins(ExtractResourcePlugin::<Images>::default());
        app.add_systems(Update,clock.after(crate::fow_visibility_texture::update));
        app.sub_app_mut(RenderApp).init_resource::<State>().init_resource::<Prepared>().add_systems(RenderStartup,pipeline).add_systems(Render,prepare.in_set(RenderSystems::PrepareBindGroups)).add_systems(RenderGraph,compute.in_set(Encoded).before(camera_driver));
    }
}
fn clock(time:Res<Time>,state:Res<crate::Match>,connection:Res<crate::Connection>,mut images:ResMut<Images>) {
    images.now=time.elapsed_secs();images.session=state.snapshot.as_ref().and_then(|s|connection.id.and_then(|id|s.roster.iter().find(|p|p.id==id).map(|p|(s.session,p.team))));
}
#[derive(ShaderType)] struct Coefficients {coefficients:Vec4,mode:Vec4}
#[derive(Resource)] struct Pipeline {layout:BindGroupLayoutDescriptor,id:CachedComputePipelineId}
fn pipeline(mut commands:Commands,assets:Res<AssetServer>,cache:Res<PipelineCache>) {
    let layout=BindGroupLayoutDescriptor::new("native-fow-live-stages",&BindGroupLayoutEntries::sequential(ShaderStages::COMPUTE,(texture_2d(TextureSampleType::Float {filterable:true}),sampler(SamplerBindingType::Filtering),uniform_buffer::<Coefficients>(false),texture_storage_2d(TextureFormat::Rgba8Unorm,StorageTextureAccess::WriteOnly),texture_2d(TextureSampleType::Float {filterable:true}))));
    let id=cache.queue_compute_pipeline(ComputePipelineDescriptor {layout:vec![layout.clone()],shader:assets.load("shaders/fow_postprocess_texture.wgsl"),entry_point:Some("main".into()),..default()});commands.insert_resource(Pipeline {layout,id});
}
#[derive(Resource,Default)] struct State {session:Option<(u64,u8)>,previous:f32,first_done:bool,current:usize,frames:u64,last_parameters:[f32;4],target_texture:Option<TextureId>}
struct Work {groups:[BindGroup;3],next:usize,previous:f32,parameters:[f32;4]}
#[derive(Resource,Default)] struct Prepared(Option<Work>);
fn prepare(images:Option<Res<Images>>,pipeline:Res<Pipeline>,cache:Res<PipelineCache>,gpu:Res<RenderAssets<GpuImage>>,device:Res<RenderDevice>,queue:Res<RenderQueue>,mut state:ResMut<State>,mut prepared:ResMut<Prepared>) {
    prepared.0=None;let Some(images)=images else{return;};let Some(session)=images.session else{return;};
    if state.session!=Some(session) {state.session=Some(session);state.previous=0.;state.first_done=false;state.current=0;}
    if cache.get_compute_pipeline(pipeline.id).is_none() {return;}
    let (Some(source),Some(a),Some(b),Some(horizontal),Some(output))=(gpu.get(&images.source),gpu.get(&images.fade[0]),gpu.get(&images.fade[1]),gpu.get(&images.horizontal),gpu.get(&images.output)) else{return;};
    // A same-session allocation/reload needs an initial pass on the new texture.
    if state.target_texture!=Some(output.texture.id()) {
        state.target_texture=Some(output.texture.id());state.previous=0.;state.first_done=false;state.current=0;
    }
    let Some(step)=crate::fow_timing::prepare_fade(images.now,state.previous,!state.first_done).expect("monotonic extracted native fog clock") else{return;};
    let kernel=crate::fow_postprocess::GaussianKernel::native(images.sigma,true).expect("qualified Map10 native kernel");
    let sampler=device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,min_filter:FilterMode::Linear,mag_filter:FilterMode::Linear,lod_min_clamp:0.,lod_max_clamp:0.,..default()});
    let views=[a,b];let next=1-state.current;let old=views[state.current];let target=views[next];
    let group=|source:&GpuImage,current:&GpuImage,out:&GpuImage,coefficients:[f32;4],mode:f32| {
        let mut buffer=UniformBuffer::from(Coefficients {coefficients:Vec4::from_array(coefficients),mode:Vec4::new(mode,0.,0.,0.)});buffer.write_buffer(&device,&queue);
        device.create_bind_group("native-fow-stage",&cache.get_bind_group_layout(&pipeline.layout),&BindGroupEntries::sequential((&source.texture_view,&sampler,&buffer,&out.texture_view,&current.texture_view)))
    };
    let groups=[group(source,old,target,step.parameters,0.),group(target,old,horizontal,[kernel.offset/512.,0.,kernel.center,kernel.paired],1.),group(horizontal,old,output,[0.,kernel.offset/512.,kernel.center,kernel.paired],1.)];
    prepared.0=Some(Work {groups,next,previous:step.next_previous,parameters:step.parameters});
}
fn compute(mut context:RenderContext,mut prepared:ResMut<Prepared>,mut state:ResMut<State>,pipeline:Res<Pipeline>,cache:Res<PipelineCache>,images:Option<Res<Images>>) {
    let Some(work)=prepared.0.take() else{return;};let Some(pipeline)=cache.get_compute_pipeline(pipeline.id) else{return;};
    {let mut pass=context.command_encoder().begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(pipeline);for group in &work.groups {pass.set_bind_group(0,group,&[]);pass.dispatch_workgroups(64,64,1);}}
    // Commit after all three commands have been encoded, never while shaders/images load.
    state.previous=work.previous;state.current=work.next;state.first_done=true;state.frames+=1;state.last_parameters=work.parameters;
    if let Some(images)=images {if let Some(path)=&images.report {let report=serde_json::json!({"complete":false,"frames":state.frames,"passes":state.frames*3,"session":state.session,"previous":state.previous,"last_fade_parameters":state.last_parameters,"format":"Rgba8Unorm","width":512,"height":512,"before_camera":true,"live_source_bound":true,"normal_fog_factors_enabled":false,"limits":["Live raw GPU mask drives native-rate fade/horizontal/vertical stages; current/previous textures ping-pong.","Original D3D target rounding, full native constructor/override and normal overlay/material factors remain open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());}}
}
pub fn observe_readback(commands:&mut Commands,images:&Images) {
    if std::env::var_os("OPENLEAGUE_FOW_GPU_READBACK").is_none() {return;}
    commands.spawn(bevy::render::gpu_readback::Readback::texture(images.output.clone())).observe(|event:On<bevy::render::gpu_readback::ReadbackComplete>| {
        let data=&event.data;let mut values=std::collections::BTreeSet::new();let mut nonzero=0;let mut rgb_equal=true;let mut alpha_ready=true;
        for p in data.chunks_exact(4) {values.insert(p[0]);nonzero+=usize::from(p[0]!=0);rgb_equal &= p[0]==p[1] && p[0]==p[2];alpha_ready &= p[3]==255;}
        let report=serde_json::json!({"complete":false,"bytes":data.len(),"expected_bytes":512*512*4,"nonzero_texels":nonzero,"distinct_red_values":values.len(),"rgb_equal":rgb_equal,"alpha_ready":alpha_ready,"gpu_readback":true,"limits":["Asynchronous readback of the actual final live GPU texture; this is not an original D3D comparison or frame-aligned CPU reference."]});if let Ok(path)=std::env::var("OPENLEAGUE_FOW_GPU_READBACK") {let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());}
    });
}

/// Orders consumers after the actual FoW passes have been encoded for this frame.
#[derive(SystemSet,Clone,Debug,PartialEq,Eq,Hash)]
pub struct Encoded;
/// Current render-world session has produced its initial FoW passes. Call after Encoded.
pub(crate) fn ready_for(world:&World,session:u64,image:AssetId<Image>)->bool {
    let Some(images)=world.get_resource::<Images>() else{return false};
    let Some(state)=world.get_resource::<State>() else{return false};
    let Some(gpu)=world.get_resource::<RenderAssets<GpuImage>>() else{return false};
    let Some(output)=gpu.get(image) else{return false};
    images.output.id()==image && state.target_texture==Some(output.texture.id())
        && images.session.is_some_and(|s|s.0==session) && state.session==images.session && state.first_done
}

/// Team-exact variant for UI consumers. Still requires render-world GPU state
/// and invocation after Encoded; this is not a main-world readiness shortcut.
pub(crate) fn ready_for_team(world:&World,session:u64,team:u8,image:AssetId<Image>)->bool {
    team<2 && world.get_resource::<Images>().is_some_and(|images|images.session==Some((session,team)))
        && ready_for(world,session,image)
}
