//! Native-rate arithmetic with a distinct immutable Image for each real CPU expansion.
//! Local Bevy transport/ownership only: encoded commands are not pixel or native-parity proof.
use bevy::{prelude::*,asset::RenderAssetUsages,core_pipeline::schedule::camera_driver,render::{Extract,ExtractSchedule,render_asset::{prepare_assets,AssetExtractionSystems,ExtractedAssets,RenderAssets},render_resource::{binding_types::{texture_2d,sampler,uniform_buffer,texture_storage_2d},*},renderer::{RenderContext,RenderDevice,RenderGraph,RenderQueue},texture::GpuImage,Render,RenderApp,RenderStartup,RenderSystems}};
use crate::fow_visibility_texture::{TransportSnapshot,VisibilityTexture};
#[derive(Resource,Clone)]
pub struct Images {pub source:Handle<Image>,fade:[Handle<Image>;2],horizontal:Handle<Image>,pub output:Handle<Image>,session:Option<(u64,u8)>,now:f32,sigma:f32,report:Option<String>,publication:Option<TransportSnapshot>}
impl Default for Images {
    fn default()->Self {
        // Persistent Render slot only. No Image allocation, admitted source,
        // native defaults or readiness are supplied by this empty sentinel.
        Self {source:Handle::default(),fade:[Handle::default(),Handle::default()],horizontal:Handle::default(),output:Handle::default(),session:None,now:0.,sigma:0.,report:None,publication:None}
    }
}
impl Images {
    pub fn new(source:Handle<Image>,assets:&mut Assets<Image>,sigma:f32)->Self {
        let mut image=Image::new(Extent3d {width:512,height:512,depth_or_array_layers:1},TextureDimension::D2,vec![0;512*512*4],TextureFormat::Rgba8Unorm,RenderAssetUsages::RENDER_WORLD);
        image.texture_descriptor.usage=TextureUsages::TEXTURE_BINDING|TextureUsages::STORAGE_BINDING|TextureUsages::COPY_DST|TextureUsages::COPY_SRC;
        let fade=[assets.add(image.clone()),assets.add(image.clone())];let horizontal=assets.add(image.clone());let output=assets.add(image);
        Self {source,fade,horizontal,output,session:None,now:0.,sigma,report:std::env::var("OPENLEAGUE_FOW_GPU_PROBE").ok(),publication:None}
    }
}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.add_systems(Update,clock.after(crate::fow_visibility_texture::update));
        app.sub_app_mut(RenderApp).init_resource::<Images>().init_resource::<State>().init_resource::<Prepared>().init_resource::<Extraction>()
            .add_systems(RenderStartup,(pipeline,recover))
            .add_systems(ExtractSchedule,extract_transport.after(AssetExtractionSystems))
            .add_systems(Render,handoff.in_set(RenderSystems::PrepareAssets).before(prepare_assets::<GpuImage>))
            .add_systems(Render,prepare.in_set(RenderSystems::PrepareBindGroups))
            .add_systems(RenderGraph,compute.in_set(Encoded).before(camera_driver));
    }
}
fn clock(time:Res<Time>,texture:Option<Res<VisibilityTexture>>,sources:Option<Res<crate::fow_champion_sources::Sources>>,map:Option<Res<crate::map10_vision_view::Map10VisionView>>,mut images:ResMut<Images>) {
    images.now=time.elapsed_secs();images.publication=None;images.session=None;
    if !images.now.is_finite() || images.now<0. {return;}
    let (Some(texture),Some(sources),Some(map))=(texture,sources,map) else{return;};
    let Some(publication)=texture.transport_snapshot(&sources,&map) else{return;};
    images.source=publication.image.clone();
    images.session=Some((publication.cpu.source.session,publication.cpu.source.team));
    images.publication=Some(publication);
}

/// Owner is separate from admission and is recorded before GPU preparation can queue.
/// There is no history of IDs that this render world never owned/extracted.
#[derive(Resource,Default)]
struct Extraction {
    // Last ID handed to generic prepare in Render: NEVER advanced by Extract.
    owner:Option<AssetId<Image>>,
    current_owner:Option<AssetId<Image>>,admitted:Option<TransportSnapshot>,
    replay_pending:bool,replay_arranged:Option<TransportSnapshot>,recovery:u64,exhausted:bool,
}
impl Extraction {
    fn restart(&mut self) {
        self.admitted=None;self.replay_arranged=None;self.replay_pending=true;
        match self.recovery.checked_add(1) {Some(next)=>self.recovery=next,None=>{self.exhausted=true;self.replay_pending=false;}}
    }
}
fn recover(mut extraction:ResMut<Extraction>,mut state:ResMut<State>,mut prepared:ResMut<Prepared>) {
    extraction.restart();state.ready=None;prepared.0=None;
}
fn purge_owned(extracted:&mut ExtractedAssets<GpuImage>,id:AssetId<Image>) {
    // removed alone cannot prevent a fresh extracted entry from resurrecting it.
    extracted.extracted.retain(|(candidate,_)|*candidate!=id);
    extracted.added.remove(&id);extracted.modified.remove(&id);extracted.removed.insert(id);
}
fn valid_snapshot_image(image:&Image)->bool {
    let size=image.texture_descriptor.size;
    size.width==512 && size.height==512 && size.depth_or_array_layers==1
        && image.texture_descriptor.dimension==TextureDimension::D2 && image.texture_descriptor.format==TextureFormat::R8Unorm
        && image.asset_usage.contains(RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD)
        && image.data.as_ref().is_some_and(|bytes|bytes.len()==512*512)
}
/// Runs after the normal Image extractor, before prepare_assets in the later Render schedule.
/// A replay is tied to one admission/recovery episode, never to gpu.get(id)==None.
fn reconcile_extracted(extraction:&mut Extraction,extracted:&mut ExtractedAssets<GpuImage>,owner:Option<AssetId<Image>>,publication:Option<TransportSnapshot>,assets:Option<&Assets<Image>>)->bool {
    extraction.replay_arranged=None;
    if extraction.current_owner!=owner {if let Some(old)=extraction.current_owner {purge_owned(extracted,old);}extraction.current_owner=owner;}
    let publication=publication.filter(|p|Some(p.image.id())==owner && !extraction.exhausted);
    let Some(publication)=publication else {
        if let Some(id)=extraction.current_owner {purge_owned(extracted,id);}
        extraction.admitted=None;extraction.replay_pending=false;return false;
    };
    let source=assets.and_then(|assets|assets.get(publication.image.id())).filter(|image|valid_snapshot_image(image));
    let Some(source)=source else {
        if let Some(id)=extraction.current_owner {purge_owned(extracted,id);}
        extraction.admitted=None;extraction.replay_pending=true;return false;
    };
    if !extraction.admitted.as_ref().is_some_and(|old|old.same_publication(&publication)) {extraction.replay_pending=true;}
    extraction.admitted=Some(publication.clone());
    if extraction.replay_pending {
        let id=publication.image.id();
        // Replay exactly the immutable current Main value, including queued-only
        // images lost by device recovery's private retry-queue reset.
        extracted.extracted.retain(|(candidate,_)|*candidate!=id);
        extracted.extracted.push((id,source.clone()));
        extracted.added.insert(id);extracted.modified.remove(&id);extracted.removed.remove(&id);
        // Keep pending until Render actually hands this to generic prepare.
        // Several Extracts may run while Render is non-ready and clear fresh.
        extraction.replay_arranged=Some(publication);
    }
    true
}
fn extract_transport(main_images:Extract<Option<Res<Images>>>,texture:Extract<Option<Res<VisibilityTexture>>>,sources:Extract<Option<Res<crate::fow_champion_sources::Sources>>>,map:Extract<Option<Res<crate::map10_vision_view::Map10VisionView>>>,assets:Extract<Option<Res<Assets<Image>>>>,mut extraction:ResMut<Extraction>,mut extracted:ResMut<ExtractedAssets<GpuImage>>,mut target:ResMut<Images>,mut state:ResMut<State>,mut prepared:ResMut<Prepared>) {
    prepared.0=None;
    let owner=texture.as_ref().map(|texture|texture.transport_owner_id()).flatten();
    // Revalidate the producer at extraction as well as at clock time. An absent
    // Main resource must revoke the Render resource; the generic plugin does not.
    let current=match (texture.as_ref(),sources.as_ref(),map.as_ref()) {
        (Some(texture),Some(sources),Some(map))=>texture.transport_snapshot(sources,map),_=>None,
    };
    let mut next=main_images.as_ref().map(|images|(**images).clone());
    let publication=next.as_ref().and_then(|images|images.publication.clone()).filter(|p|current.as_ref().is_some_and(|current|current.same_publication(p)));
    let asset_ref=assets.as_ref().map(|assets|&**assets);
    if !reconcile_extracted(&mut extraction,&mut extracted,owner,publication,asset_ref) {
        state.ready=None;
        if let Some(images)=next.as_mut() {images.publication=None;images.session=None;}
    }
    // No Commands: pending insertions would retain B/C/D while Render is skipped.
    *target=next.unwrap_or_default();
}
/// Runs in Render after ExtractCommands and before generic Image preparation.
/// The old owner persists through ALL skipped Render frames, including
/// StopRendering -> Ignore (which does not run RenderStartup).
fn handoff_owned(extraction:&mut Extraction,extracted:&mut ExtractedAssets<GpuImage>,publication:Option<&TransportSnapshot>)->bool {
    let next=publication.filter(|p|!extraction.exhausted && Some(p.image.id())==extraction.current_owner
        && extraction.admitted.as_ref().is_some_and(|a|a.same_publication(p)));
    let owner=next.map(|p|p.image.id());
    if extraction.owner!=owner {if let Some(old)=extraction.owner {purge_owned(extracted,old);}extraction.owner=owner;}
    let Some(next)=next else {
        if let Some(id)=extraction.current_owner {purge_owned(extracted,id);}
        extraction.admitted=None;extraction.replay_pending=false;extraction.replay_arranged=None;return false;
    };
    if extraction.replay_pending {
        if !extraction.replay_arranged.as_ref().is_some_and(|p|p.same_publication(next))
            || !extracted.extracted.iter().any(|(id,image)|*id==next.image.id() && valid_snapshot_image(image)) {
            purge_owned(extracted,next.image.id());extraction.admitted=None;return false;
        }
        extraction.replay_pending=false;extraction.replay_arranged=None;
    }
    true
}
fn handoff(mut extraction:ResMut<Extraction>,mut extracted:ResMut<ExtractedAssets<GpuImage>>,images:Res<Images>,mut state:ResMut<State>,mut prepared:ResMut<Prepared>) {
    if !handoff_owned(&mut extraction,&mut extracted,images.publication.as_ref()) {state.ready=None;prepared.0=None;}
}

#[derive(ShaderType)] struct Coefficients {coefficients:Vec4,mode:Vec4}
#[derive(Resource)] struct Pipeline {layout:BindGroupLayoutDescriptor,id:CachedComputePipelineId}
fn pipeline(mut commands:Commands,assets:Res<AssetServer>,cache:Res<PipelineCache>) {
    let layout=BindGroupLayoutDescriptor::new("native-fow-live-stages",&BindGroupLayoutEntries::sequential(ShaderStages::COMPUTE,(texture_2d(TextureSampleType::Float {filterable:true}),sampler(SamplerBindingType::Filtering),uniform_buffer::<Coefficients>(false),texture_storage_2d(TextureFormat::Rgba8Unorm,StorageTextureAccess::WriteOnly),texture_2d(TextureSampleType::Float {filterable:true}))));
    let id=cache.queue_compute_pipeline(ComputePipelineDescriptor {layout:vec![layout.clone()],shader:assets.load("shaders/fow_postprocess_texture.wgsl"),entry_point:Some("main".into()),..default()});commands.insert_resource(Pipeline {layout,id});
}
#[derive(Clone,Debug,PartialEq,Eq)]
struct Allocations<T> {fade:[(AssetId<Image>,T);2],horizontal:(AssetId<Image>,T),output:(AssetId<Image>,T)}
struct History<A> {session:Option<(u64,u8)>,previous:f32,first_done:bool,current:usize,allocations:Option<A>}
impl<A> Default for History<A> {fn default()->Self {Self {session:None,previous:0.,first_done:false,current:0,allocations:None}}}
impl<A:PartialEq> History<A> {
    fn reconcile(&mut self,session:(u64,u8),allocations:A) {
        // Local Bevy adapter decision: any of the four destination allocations
        // changing resets history. A new source ID/publication alone never does.
        if self.session!=Some(session) || self.allocations.as_ref()!=Some(&allocations) {self.previous=0.;self.first_done=false;self.current=0;}
        self.session=Some(session);self.allocations=Some(allocations);
    }
}
#[derive(Clone,Debug)]
struct ReadyKey<T> {publication:TransportSnapshot,recovery:u64,source_texture:T,allocations:Allocations<T>}
impl<T:PartialEq> ReadyKey<T> {
    fn same(&self,other:&Self)->bool {self.publication.same_publication(&other.publication) && self.recovery==other.recovery && self.source_texture==other.source_texture && self.allocations==other.allocations}
}
#[derive(Clone)]
struct WorkStamp<T> {key:ReadyKey<T>,now:f32,previous:f32,current:usize,first_done:bool}
impl<T:PartialEq> WorkStamp<T> {
    fn matches(&self,key:&ReadyKey<T>,now:f32,history:&History<Allocations<T>>)->bool {
        self.key.same(key) && self.now.to_bits()==now.to_bits() && self.previous.to_bits()==history.previous.to_bits()
            && self.current==history.current && self.first_done==history.first_done && history.allocations.as_ref()==Some(&key.allocations)
    }
}
// Views are binding identities only. They never enter History's TextureId reset key.
#[derive(Clone,Debug,PartialEq,Eq)]
struct BindingViews<V> {source:V,fade:[V;2],horizontal:V,output:V}
#[derive(Clone,Debug)]
struct BindingKey<T,V> {textures:ReadyKey<T>,views:BindingViews<V>}
impl<T:PartialEq,V:PartialEq> BindingKey<T,V> {
    fn same(&self,other:&Self)->bool {self.textures.same(&other.textures) && self.views==other.views}
}
#[derive(Clone)]
struct BindingWorkStamp<T,V> {textures:WorkStamp<T>,views:BindingViews<V>}
impl<T:PartialEq,V:PartialEq> BindingWorkStamp<T,V> {
    fn matches(&self,key:&BindingKey<T,V>,now:f32,history:&History<Allocations<T>>)->bool {
        self.textures.matches(&key.textures,now,history) && self.views==key.views
    }
}
fn binding_views(source:&GpuImage,a:&GpuImage,b:&GpuImage,horizontal:&GpuImage,output:&GpuImage)->BindingViews<TextureViewId> {
    BindingViews {source:source.texture_view.id(),fade:[a.texture_view.id(),b.texture_view.id()],horizontal:horizontal.texture_view.id(),output:output.texture_view.id()}
}
fn encoded_identity_matches<T:PartialEq,V:PartialEq>(key:&BindingKey<T,V>,ready:Option<&BindingKey<T,V>>,history:&History<Allocations<T>>,session:u64,image:AssetId<Image>)->bool {
    key.textures.allocations.output.0==image && key.textures.publication.cpu.source.session==session
        && history.session==Some((session,key.textures.publication.cpu.source.team)) && history.first_done
        && ready.is_some_and(|ready|ready.same(key))
}
/// Readonly copy of one currently revalidated encoded identity. Obtain it again
/// at the actual Draw after Encoded; retaining this value is not fresh admission.
/// No fields expose source internals or mutable readiness. No GPU ack is implied.
#[derive(Clone)]
pub(crate) struct EncodedOutputProof<T=TextureId,V=TextureViewId> {key:BindingKey<T,V>}
impl<T:PartialEq,V:PartialEq> EncodedOutputProof<T,V> {
    pub(crate) fn matches_output(&self,session:u64,team:u8,image:AssetId<Image>,texture:T,view:V)->bool {
        team<2 && self.key.textures.publication.cpu.source.session==session && self.key.textures.publication.cpu.source.team==team
            && self.key.textures.allocations.output.0==image && self.key.textures.allocations.output.1==texture && self.key.views.output==view
    }
    pub(crate) fn matches_source(&self,source:&crate::fow_champion_sources::MaskSourceStamp)->bool {
        self.key.textures.publication.cpu.source.same_episode(source)
    }
    pub(crate) fn same_identity(&self,other:&Self)->bool {self.key.same(&other.key)}
    pub(crate) fn recovery(&self)->u64 {self.key.textures.recovery}
}
#[derive(Resource,Default)] struct State {history:History<Allocations<TextureId>>,frames:u64,last_parameters:[f32;4],ready:Option<BindingKey<TextureId,TextureViewId>>}
struct Work {groups:[BindGroup;3],next:usize,previous:f32,parameters:[f32;4],stamp:BindingWorkStamp<TextureId,TextureViewId>}
#[derive(Resource,Default)] struct Prepared(Option<Work>);
fn current_key(images:&Images,extraction:&Extraction,gpu:&RenderAssets<GpuImage>)->Option<BindingKey<TextureId,TextureViewId>> {
    if extraction.exhausted || extraction.replay_pending || !images.now.is_finite() || images.now<0. {return None;}
    let publication=images.publication.as_ref()?;
    if Some(publication.image.id())!=extraction.owner || extraction.owner!=extraction.current_owner || images.source.id()!=publication.image.id()
        || images.session!=Some((publication.cpu.source.session,publication.cpu.source.team))
        || !extraction.admitted.as_ref().is_some_and(|p|p.same_publication(publication)) {return None;}
    let source=gpu.get(publication.image.id())?;
    let valid=|image:&GpuImage,format:TextureFormat| {
        let size=image.texture_descriptor.size;
        size.width==512 && size.height==512 && size.depth_or_array_layers==1 && image.texture_descriptor.dimension==TextureDimension::D2 && image.texture_descriptor.format==format
    };
    if !source.had_data || !valid(source,TextureFormat::R8Unorm) {return None;}
    let (a,b,horizontal,output)=(gpu.get(images.fade[0].id())?,gpu.get(images.fade[1].id())?,gpu.get(images.horizontal.id())?,gpu.get(images.output.id())?);
    if [a,b,horizontal,output].iter().any(|image|!valid(image,TextureFormat::Rgba8Unorm)) {return None;}
    Some(BindingKey {textures:ReadyKey {publication:publication.clone(),recovery:extraction.recovery,source_texture:source.texture.id(),allocations:Allocations {fade:[(images.fade[0].id(),a.texture.id()),(images.fade[1].id(),b.texture.id())],horizontal:(images.horizontal.id(),horizontal.texture.id()),output:(images.output.id(),output.texture.id())}},views:binding_views(source,a,b,horizontal,output)})
}
fn prepare(images:Option<Res<Images>>,extraction:Res<Extraction>,pipeline:Option<Res<Pipeline>>,cache:Res<PipelineCache>,gpu:Res<RenderAssets<GpuImage>>,device:Res<RenderDevice>,queue:Res<RenderQueue>,mut state:ResMut<State>,mut prepared:ResMut<Prepared>) {
    prepared.0=None;
    let Some(images)=images else{state.ready=None;return;};
    let Some(key)=current_key(&images,&extraction,&gpu) else{state.ready=None;return;};
    let session=(key.textures.publication.cpu.source.session,key.textures.publication.cpu.source.team);
    state.history.reconcile(session,key.textures.allocations.clone());
    if !state.ready.as_ref().is_some_and(|ready|ready.same(&key)) {state.ready=None;}
    let Some(pipeline)=pipeline else{state.ready=None;return;};
    if cache.get_compute_pipeline(pipeline.id).is_none() {state.ready=None;return;}
    let step=match crate::fow_timing::prepare_fade(images.now,state.history.previous,!state.history.first_done) {Ok(Some(step))=>step,Ok(None)=>return,Err(_)=>{state.ready=None;return;}};
    let Ok(kernel)=crate::fow_postprocess::GaussianKernel::native(images.sigma,true) else{state.ready=None;return;};
    let (Some(source),Some(a),Some(b),Some(horizontal),Some(output))=(gpu.get(key.textures.publication.image.id()),gpu.get(images.fade[0].id()),gpu.get(images.fade[1].id()),gpu.get(images.horizontal.id()),gpu.get(images.output.id())) else{state.ready=None;return;};
    // These are exactly the views passed below to the three bind groups.
    if binding_views(source,a,b,horizontal,output)!=key.views {state.ready=None;return;}
    let sampler=device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,min_filter:FilterMode::Linear,mag_filter:FilterMode::Linear,lod_min_clamp:0.,lod_max_clamp:0.,..default()});
    let views=[a,b];let next=1-state.history.current;let old=views[state.history.current];let target=views[next];
    let group=|source:&GpuImage,current:&GpuImage,out:&GpuImage,coefficients:[f32;4],mode:f32| {
        let mut buffer=UniformBuffer::from(Coefficients {coefficients:Vec4::from_array(coefficients),mode:Vec4::new(mode,0.,0.,0.)});buffer.write_buffer(&device,&queue);
        device.create_bind_group("native-fow-stage",&cache.get_bind_group_layout(&pipeline.layout),&BindGroupEntries::sequential((&source.texture_view,&sampler,&buffer,&out.texture_view,&current.texture_view)))
    };
    let groups=[group(source,old,target,step.parameters,0.),group(target,old,horizontal,[kernel.offset/512.,0.,kernel.center,kernel.paired],1.),group(horizontal,old,output,[0.,kernel.offset/512.,kernel.center,kernel.paired],1.)];
    let stamp=BindingWorkStamp {textures:WorkStamp {key:key.textures,now:images.now,previous:state.history.previous,current:state.history.current,first_done:state.history.first_done},views:key.views};
    prepared.0=Some(Work {groups,next,previous:step.next_previous,parameters:step.parameters,stamp});
}
fn compute(mut context:RenderContext,mut prepared:ResMut<Prepared>,mut state:ResMut<State>,pipeline:Option<Res<Pipeline>>,cache:Res<PipelineCache>,images:Option<Res<Images>>,extraction:Res<Extraction>,gpu:Res<RenderAssets<GpuImage>>) {
    let Some(work)=prepared.0.take() else{return;};
    let Some(images)=images else{state.ready=None;return;};
    let Some(key)=current_key(&images,&extraction,&gpu) else{state.ready=None;return;};
    if !work.stamp.matches(&key,images.now,&state.history) {state.ready=None;return;}
    let Some(pipeline)=pipeline.and_then(|pipeline|cache.get_compute_pipeline(pipeline.id)) else{state.ready=None;return;};
    let Some(frames)=state.frames.checked_add(1).filter(|frames|frames.checked_mul(3).is_some()) else{state.ready=None;return;};
    {let mut pass=context.command_encoder().begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(pipeline);for group in &work.groups {pass.set_bind_group(0,group,&[]);pass.dispatch_workgroups(64,64,1);}}
    // No readiness before all three commands have been encoded. This is neither
    // a GPU completion acknowledgement nor evidence of a material's draw/pixels.
    state.history.previous=work.previous;state.history.current=work.next;state.history.first_done=true;state.frames=frames;state.last_parameters=work.parameters;state.ready=Some(key);
    if let Some(path)=&images.report {let report=serde_json::json!({"complete":false,"frames":state.frames,"passes":state.frames*3,"session":state.history.session,"previous":state.history.previous,"last_fade_parameters":state.last_parameters,"format":"Rgba8Unorm","width":512,"height":512,"before_camera":true,"live_source_bound":true,"normal_fog_factors_enabled":false,"limits":["Exact immutable CPU publication and prepared GPU image were rechecked before three encodes; this is not completion or pixel proof.","Revocation applies at the next coherent extraction, not retroactively to previously extracted or in-flight work.","Original D3D target rounding, full native constructor/override and normal overlay/material factors remain open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());}
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
/// Current exact CPU publication, prepared source and all four allocations/views
/// have three commands encoded. Call after Encoded; not material/pixel/GPU ack.
fn validated_encoded_key(world:&World,session:u64,image:AssetId<Image>)->Option<BindingKey<TextureId,TextureViewId>> {
    let images=world.get_resource::<Images>()?;
    let state=world.get_resource::<State>()?;
    let extraction=world.get_resource::<Extraction>()?;
    let gpu=world.get_resource::<RenderAssets<GpuImage>>()?;
    let pipeline=world.get_resource::<Pipeline>()?;
    let cache=world.get_resource::<PipelineCache>()?;
    cache.get_compute_pipeline(pipeline.id)?;
    let key=current_key(images,extraction,gpu)?;
    (images.output.id()==image && state.history.session==images.session
        && encoded_identity_matches(&key,state.ready.as_ref(),&state.history,session,image)).then_some(key)
}
pub(crate) fn ready_for(world:&World,session:u64,image:AssetId<Image>)->bool {
    validated_encoded_key(world,session,image).is_some()
}

/// Team-exact variant. No main-world CPU flag or first_done-only shortcut.
pub(crate) fn ready_for_team(world:&World,session:u64,team:u8,image:AssetId<Image>)->bool {
    team<2 && world.get_resource::<Images>().is_some_and(|images|images.session==Some((session,team)))
        && ready_for(world,session,image)
}

/// The current output's logical source/recovery context for material preparation.
/// Call after the Image handoff in PrepareAssets. This does NOT require State,
/// a prepared compute pipeline, source GpuImage or an Encoded record: those come
/// later. The caller must separately inspect its real prepared image bindings.
/// The returned scalar grants no draw readiness and retains no transport handle.
pub(crate) fn output_recovery_for_preparation(world:&World,source:&crate::fow_champion_sources::MaskSourceStamp,image:AssetId<Image>)->Option<u64> {
    let images=world.get_resource::<Images>()?;
    let extraction=world.get_resource::<Extraction>()?;
    if source.team>=2 || extraction.exhausted || extraction.replay_pending || !images.now.is_finite() || images.now<0.
        || images.output.id()!=image || images.session!=Some((source.session,source.team)) {return None;}
    let publication=images.publication.as_ref()?;
    if !publication.cpu.source.same_episode(source) || images.source.id()!=publication.image.id()
        || extraction.owner!=Some(publication.image.id()) || extraction.current_owner!=extraction.owner
        || !extraction.admitted.as_ref().is_some_and(|p|p.same_publication(publication)) {return None;}
    Some(extraction.recovery)
}

/// Obtain a fresh opaque output proof from the coherent Render World at Draw,
/// after Encoded. The caller still validates its own accepted client epoch and
/// incarnation; source comparison uses the full CPU episode/instance/view token.
pub(crate) fn encoded_output_for_team(world:&World,session:u64,team:u8,image:AssetId<Image>)->Option<EncodedOutputProof> {
    if team>=2 || !world.get_resource::<Images>().is_some_and(|images|images.session==Some((session,team))) {return None;}
    Some(EncodedOutputProof {key:validated_encoded_key(world,session,image)?})
}

#[cfg(test)]
mod transport_extraction_tests {
    use super::*;
    use crate::fow_visibility_texture::transport_snapshot_tests::{published_fixture,refresh_fixture};
    fn uploaded(extracted:&mut ExtractedAssets<GpuImage>) {
        // Model only the public extraction handoff, not GPU preparation or ack.
        extracted.extracted.clear();extracted.added.clear();extracted.modified.clear();extracted.removed.clear();
    }
    #[test]
    fn actual_assets_extraction_purges_queued_owner_before_fresh_replacement_and_preserves_foreign() {
        let (snapshot,viewer,map,sources,mut texture,mut assets)=published_fixture();
        let b=texture.transport_snapshot(&sources,&map).unwrap();let b_pixels=assets.get(b.image.id()).unwrap().data.clone();
        let foreign=assets.add(assets.get(b.image.id()).unwrap().clone());
        let mut extraction=Extraction::default();let mut extracted=ExtractedAssets::<GpuImage>::default();
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&b)));
        assert_eq!(extraction.owner,Some(b.image.id()),"ownership is recorded before any GPU preparation or readiness");
        uploaded(&mut extracted); // B can now be in the private normal retry queue.
        refresh_fixture(&mut texture,&snapshot,viewer,&sources,&map,0.5,&mut assets).unwrap();
        let c=texture.transport_snapshot(&sources,&map).unwrap();assert_ne!(b.image.id(),c.image.id());
        assert!(assets.get(b.image.id()).is_none());assert_eq!(assets.get(c.image.id()).unwrap().data,b_pixels);
        // Adversarial stale fresh+added+modified entries must not resurrect B.
        extracted.extracted.push((b.image.id(),assets.get(c.image.id()).unwrap().clone()));
        extracted.added.insert(b.image.id());extracted.modified.insert(b.image.id());
        extracted.extracted.push((foreign.id(),assets.get(foreign.id()).unwrap().clone()));extracted.added.insert(foreign.id());
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(c.clone()),Some(&assets)));
        assert_eq!(extraction.owner,Some(b.image.id()),"Extract cannot forget a queued Render owner");
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&c)));
        assert_eq!(extraction.owner,Some(c.image.id()));assert!(extracted.removed.contains(&b.image.id()));
        assert!(!extracted.extracted.iter().any(|(id,_)|*id==b.image.id()));assert!(!extracted.added.contains(&b.image.id()));assert!(!extracted.modified.contains(&b.image.id()));
        assert_eq!(extracted.extracted.iter().filter(|(id,_)|*id==c.image.id()).count(),1);
        assert!(extracted.extracted.iter().any(|(id,_)|*id==foreign.id()));assert!(extracted.added.contains(&foreign.id()));assert!(!extracted.removed.contains(&foreign.id()));
        uploaded(&mut extracted);
        // Skip a whole Main publication before extracting again: only admitted C
        // needs Render cleanup; the unextracted intermediate has no Render owner.
        refresh_fixture(&mut texture,&snapshot,viewer,&sources,&map,0.75,&mut assets).unwrap();let skipped=texture.transport_owner_id().unwrap();
        refresh_fixture(&mut texture,&snapshot,viewer,&sources,&map,1.,&mut assets).unwrap();let newest=texture.transport_snapshot(&sources,&map).unwrap();
        assert!(assets.get(skipped).is_none());
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(newest.clone()),Some(&assets)));
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&newest)));
        assert!(extracted.removed.contains(&c.image.id()));assert!(!extracted.removed.contains(&skipped));assert_eq!(extraction.owner,Some(newest.image.id()));
    }
    #[test]
    fn device_recovery_replays_the_real_current_image_once_without_restarting_ordinary_retry() {
        let (_,_,map,sources,texture,assets)=published_fixture();let b=texture.transport_snapshot(&sources,&map).unwrap();
        let mut extraction=Extraction::default();let mut extracted=ExtractedAssets::<GpuImage>::default();
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&b)));
        uploaded(&mut extracted);
        for _ in 0..3 {assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));assert!(extracted.extracted.is_empty(),"ordinary queued preparation is not continually cancelled/re-added");}
        extraction.restart();assert_eq!(extraction.recovery,1);
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));
        assert_eq!(extracted.extracted.len(),1);assert_eq!(extracted.extracted[0].0,b.image.id());
        assert_eq!(extracted.extracted[0].1.data,assets.get(b.image.id()).unwrap().data);assert!(extracted.added.contains(&b.image.id()));
        assert!(extraction.replay_pending);assert!(handoff_owned(&mut extraction,&mut extracted,Some(&b)));assert!(!extraction.replay_pending);
        uploaded(&mut extracted);
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b),Some(&assets)));assert!(extracted.extracted.is_empty());
    }
    #[test]
    fn absence_invalidity_and_explicit_main_teardown_revoke_fresh_and_retained_owner() {
        let (_,_,map,sources,mut texture,mut assets)=published_fixture();let b=texture.transport_snapshot(&sources,&map).unwrap();
        let foreign=assets.add(assets.get(b.image.id()).unwrap().clone());let mut extraction=Extraction::default();let mut extracted=ExtractedAssets::<GpuImage>::default();
        assert!(reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&b)));
        assert!(!reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),None,Some(&assets)),"missing/invalid Main envelope revokes despite the producer retaining cleanup identity");
        assert!(extraction.admitted.is_none());assert_eq!(extraction.owner,Some(b.image.id()));assert!(extracted.removed.contains(&b.image.id()));assert!(extracted.extracted.is_empty());
        texture.retire_transport(&mut assets);assert!(assets.get(b.image.id()).is_none());assert!(texture.transport_owner_id().is_none());
        assert!(!reconcile_extracted(&mut extraction,&mut extracted,None,None,Some(&assets)));assert_eq!(extraction.owner,Some(b.image.id()));
        assert!(!handoff_owned(&mut extraction,&mut extracted,None));assert!(extraction.owner.is_none());assert!(assets.get(foreign.id()).is_some());
        // Teardown before the first custom extraction also removes the Main
        // value, so a generic Added event cannot clone it later.
        let (_,_,_,_,mut early,mut early_assets)=published_fixture();let id=early.transport_owner_id().unwrap();early.retire_transport(&mut early_assets);assert!(early_assets.get(id).is_none());
    }
    fn token_key(publication:TransportSnapshot,recovery:u64)->ReadyKey<u64> {
        let id=publication.image.id();ReadyKey {publication,recovery,source_texture:10,allocations:Allocations {fade:[(id,20),(id,21)],horizontal:(id,22),output:(id,23)}}
    }
    #[test]
    fn readiness_identity_and_work_rechecks_reject_stale_publication_recovery_clock_and_history() {
        let (snapshot,viewer,map,sources,mut texture,mut assets)=published_fixture();let b=texture.transport_snapshot(&sources,&map).unwrap();let key=token_key(b.clone(),1);
        let mut history=History::default();history.reconcile((snapshot.session,b.cpu.source.team),key.allocations.clone());history.previous=0.2;history.first_done=true;history.current=1;
        let stamp=WorkStamp {key:key.clone(),now:0.25,previous:history.previous,current:history.current,first_done:history.first_done};assert!(stamp.matches(&key,0.25,&history));
        let mut recovered=key.clone();recovered.recovery+=1;assert!(!stamp.matches(&recovered,0.25,&history));
        let mut reallocated_source=key.clone();reallocated_source.source_texture+=1;assert!(!stamp.matches(&reallocated_source,0.25,&history));
        assert!(!stamp.matches(&key,0.26,&history));history.current=0;assert!(!stamp.matches(&key,0.25,&history));history.current=1;
        refresh_fixture(&mut texture,&snapshot,viewer,&sources,&map,0.5,&mut assets).unwrap();let c=texture.transport_snapshot(&sources,&map).unwrap();let next=token_key(c,1);
        assert!(!key.same(&next));assert!(!stamp.matches(&next,0.25,&history));
        // The persistent identity intentionally has no variable time field;
        // readiness may survive a healthy no-fade frame only for this exact key.
        assert!(key.same(&key.clone()));assert!(crate::fow_timing::prepare_fade(0.2,0.2,false).unwrap().is_none());
    }
    #[test]
    fn all_four_destination_allocations_reset_history_but_upload_identity_is_not_a_reset_input() {
        let mut history=History::<[u64;4]>::default();let initial=[10,11,12,13];
        history.reconcile((1,0),initial);history.previous=2.;history.first_done=true;history.current=1;
        history.reconcile((1,0),initial);assert_eq!(history.previous,2.);assert!(history.first_done);assert_eq!(history.current,1);
        for slot in 0..4 {history.previous=2.;history.first_done=true;history.current=1;let mut next=initial;next[slot]+=100;history.reconcile((1,0),next);assert_eq!(history.previous,0.);assert!(!history.first_done);assert_eq!(history.current,0);history.previous=2.;history.first_done=true;history.current=1;history.reconcile((1,0),initial);}
        history.previous=2.;history.first_done=true;history.current=1;history.reconcile((1,1),initial);assert_eq!(history.previous,0.);assert!(!history.first_done);assert_eq!(history.current,0);
    }
    #[test]
    fn recovery_epoch_exhaustion_and_missing_bytes_fail_closed_without_foreign_cleanup() {
        let (_,_,map,sources,texture,mut assets)=published_fixture();let b=texture.transport_snapshot(&sources,&map).unwrap();let foreign=assets.add(assets.get(b.image.id()).unwrap().clone());
        let mut extraction=Extraction::default();let mut extracted=ExtractedAssets::<GpuImage>::default();
        assets.get_mut(b.image.id()).unwrap().data=None;
        assert!(!reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b.clone()),Some(&assets)));assert!(extraction.admitted.is_none());assert!(extracted.removed.contains(&b.image.id()));
        let recovered_bytes=assets.get(foreign.id()).unwrap().data.clone();assets.get_mut(b.image.id()).unwrap().data=recovered_bytes;
        extraction.recovery=u64::MAX;extraction.restart();assert!(extraction.exhausted);assert_eq!(extraction.recovery,u64::MAX);
        assert!(!reconcile_extracted(&mut extraction,&mut extracted,texture.transport_owner_id(),Some(b),Some(&assets)));assert!(extraction.admitted.is_none());assert!(!extracted.removed.contains(&foreign.id()));assert!(assets.get(foreign.id()).is_some());
    }
    #[test]
    fn real_extract_schedule_keeps_one_slot_and_remembers_queued_owner_until_render_handoff() {
        use bevy::{ecs::schedule::{Schedule,ScheduleBuildSettings},render::MainWorld};
        let (snapshot,viewer,map,sources,texture,mut assets)=published_fixture();let b=texture.transport_snapshot(&sources,&map).unwrap();
        let mut images=Images::new(texture.image.clone(),&mut assets,texture.settings.blur_kernel_sigma);
        images.source=b.image.clone();images.session=Some((snapshot.session,b.cpu.source.team));images.now=0.25;images.publication=Some(b.clone());
        // MainWorld's tuple field is private; use its public Default/DerefMut API.
        let mut main=MainWorld::default();main.insert_resource(images);main.insert_resource(texture);main.insert_resource(assets);main.insert_resource(map);main.insert_resource(sources);
        let mut render=World::new();render.insert_resource(main);render.insert_resource(Images::default());render.insert_resource(Extraction::default());render.insert_resource(State::default());render.insert_resource(Prepared::default());render.insert_resource(ExtractedAssets::<GpuImage>::default());
        let mut extract=Schedule::new(ExtractSchedule);extract.set_build_settings(ScheduleBuildSettings {auto_insert_apply_deferred:false,..default()});extract.set_apply_final_deferred(false);extract.add_systems(extract_transport);
        let mut pre_prepare=Schedule::new(Render);pre_prepare.add_systems(handoff);
        extract.run(&mut render);pre_prepare.run(&mut render);
        assert_eq!(render.resource::<Extraction>().owner,Some(b.image.id()));
        uploaded(&mut render.resource_mut::<ExtractedAssets<GpuImage>>());
        let mut latest=b.clone();
        // No Render or ExtractCommands is run in this loop. The persistent slot
        // replaces itself directly, and the previous handoff owner remains B.
        for i in 2..=48 {
            let mut main=render.remove_resource::<MainWorld>().unwrap();
            let mut assets=main.remove_resource::<Assets<Image>>().unwrap();let mut texture=main.remove_resource::<VisibilityTexture>().unwrap();
            let sources=main.resource::<crate::fow_champion_sources::Sources>();let map=main.resource::<crate::map10_vision_view::Map10VisionView>();
            let now=i as f32*0.25;refresh_fixture(&mut texture,&snapshot,viewer,sources,map,now,&mut assets).unwrap();latest=texture.transport_snapshot(sources,map).unwrap();
            {let mut images=main.resource_mut::<Images>();images.source=latest.image.clone();images.session=Some((snapshot.session,latest.cpu.source.team));images.now=now;images.publication=Some(latest.clone());}
            assert_eq!(assets.iter().count(),6,"only CPU S, current source and the four destinations remain in Main");
            main.insert_resource(texture);main.insert_resource(assets);render.insert_resource(main);
            // Exact generic collector's public per-extraction clear; no private
            // prepare/retry API and no fake GPU texture or completion is used.
            uploaded(&mut render.resource_mut::<ExtractedAssets<GpuImage>>());
            extract.run(&mut render);
            let slot=render.resource::<Images>();assert!(slot.publication.as_ref().unwrap().same_publication(&latest));
            let extraction=render.resource::<Extraction>();assert_eq!(extraction.owner,Some(b.image.id()));assert_eq!(extraction.current_owner,Some(latest.image.id()));assert!(extraction.replay_pending);
            assert_eq!(render.resource::<ExtractedAssets<GpuImage>>().extracted.len(),1);
            assert!(!ready_for(&render,snapshot.session,slot.output.id()),"CPU extraction alone is never GPU readiness");
        }
        let epoch=render.resource::<Extraction>().recovery;
        for _ in 0..3 {
            uploaded(&mut render.resource_mut::<ExtractedAssets<GpuImage>>());extract.run(&mut render);
            assert_eq!(render.resource::<Extraction>().owner,Some(b.image.id()));assert!(render.resource::<Extraction>().replay_pending);
            assert_eq!(render.resource::<ExtractedAssets<GpuImage>>().extracted.iter().filter(|(id,_)|*id==latest.image.id()).count(),1,"unchanged D is not lost across non-ready extractions");
        }
        // A StopRendering -> Ignore return does not run RenderStartup. Prior
        // removed(B) entries have been cleared; the private owner still has B.
        render.resource_mut::<ExtractedAssets<GpuImage>>().removed.clear();
        pre_prepare.run(&mut render);
        let extraction=render.resource::<Extraction>();assert_eq!(extraction.recovery,epoch);assert_eq!(extraction.owner,Some(latest.image.id()));assert!(!extraction.replay_pending);
        let extracted=render.resource::<ExtractedAssets<GpuImage>>();assert!(extracted.removed.contains(&b.image.id()));assert_eq!(extracted.extracted.iter().filter(|(id,_)|*id==latest.image.id()).count(),1);
        uploaded(&mut render.resource_mut::<ExtractedAssets<GpuImage>>());
        extract.run(&mut render);assert!(render.resource::<ExtractedAssets<GpuImage>>().extracted.is_empty(),"ordinary retry is not re-added after one actual handoff");
        render.resource_mut::<MainWorld>().remove_resource::<Images>();
        uploaded(&mut render.resource_mut::<ExtractedAssets<GpuImage>>());extract.run(&mut render);
        assert!(render.resource::<Images>().publication.is_none(),"Main absence updates the persistent Render sentinel immediately");
        pre_prepare.run(&mut render);assert!(render.resource::<Extraction>().owner.is_none());assert!(render.resource::<ExtractedAssets<GpuImage>>().removed.contains(&latest.image.id()));
    }
}

#[cfg(test)]
mod view_identity_tests {
    use super::*;
    use crate::fow_visibility_texture::transport_snapshot_tests::published_fixture;
    fn fixture()->(BindingKey<u64,u64>,History<Allocations<u64>>) {
        let (snapshot,_,map,sources,texture,_assets)=published_fixture();
        let publication=texture.transport_snapshot(&sources,&map).unwrap();let id=publication.image.id();
        let textures=ReadyKey {publication,recovery:1,source_texture:10,allocations:Allocations {fade:[(id,20),(id,21)],horizontal:(id,22),output:(id,23)}};
        let key=BindingKey {textures,views:BindingViews {source:100,fade:[200,201],horizontal:202,output:203}};
        let mut history=History::default();history.reconcile((snapshot.session,key.textures.publication.cpu.source.team),key.textures.allocations.clone());
        history.previous=2.;history.first_done=true;history.current=1;(key,history)
    }
    fn stamp(key:&BindingKey<u64,u64>,history:&History<Allocations<u64>>,now:f32)->BindingWorkStamp<u64,u64> {
        BindingWorkStamp {textures:WorkStamp {key:key.textures.clone(),now,previous:history.previous,current:history.current,first_done:history.first_done},views:key.views.clone()}
    }
    #[test]
    fn source_and_all_four_destination_view_changes_reject_work_and_ready_without_history_reset() {
        let (key,mut history)=fixture();let prepared=stamp(&key,&history,2.25);let session=key.textures.publication.cpu.source.session;let image=key.textures.allocations.output.0;
        assert!(prepared.matches(&key,2.25,&history));assert!(encoded_identity_matches(&key,Some(&key),&history,session,image));
        for slot in 0..5 {
            let mut changed=key.clone();match slot {0=>changed.views.source+=1,1=>changed.views.fade[0]+=1,2=>changed.views.fade[1]+=1,3=>changed.views.horizontal+=1,_=>changed.views.output+=1}
            assert!(!key.same(&changed),"each actual binding view is part of Ready identity");
            assert!(!prepared.matches(&changed,2.25,&history),"construction-time Work rejects a view-only replacement before encode");
            assert!(!encoded_identity_matches(&changed,Some(&key),&history,session,image));
            history.reconcile((session,key.textures.publication.cpu.source.team),changed.textures.allocations.clone());
            assert_eq!(history.previous,2.);assert!(history.first_done);assert_eq!(history.current,1);
            assert_eq!(history.allocations.as_ref(),Some(&key.textures.allocations));
        }
    }
    #[test]
    fn view_only_replacement_needs_a_new_legal_encode_record_and_does_not_force_fade() {
        let (key,mut history)=fixture();let session=key.textures.publication.cpu.source.session;let image=key.textures.allocations.output.0;
        let mut current=key.clone();current.views.output+=1;
        history.reconcile((session,key.textures.publication.cpu.source.team),current.textures.allocations.clone());
        assert!(!encoded_identity_matches(&current,Some(&key),&history,session,image));
        assert!(crate::fow_timing::prepare_fade(2.,history.previous,!history.first_done).unwrap().is_none());
        assert!(!encoded_identity_matches(&current,None,&history,session,image),"a healthy no-fade frame cannot mint a new identity");
        let step=crate::fow_timing::prepare_fade(2.5,history.previous,!history.first_done).unwrap().unwrap();
        let work=stamp(&current,&history,2.5);assert!(work.matches(&current,2.5,&history));
        let mut changed_again=current.clone();changed_again.views.source+=1;assert!(!work.matches(&changed_again,2.5,&history));
        // CPU oracle of the post-encode record only. Production assigns Ready
        // after three real dispatch encodes; this test does not run those encodes.
        history.previous=step.next_previous;history.current=1-history.current;
        assert!(encoded_identity_matches(&current,Some(&current),&history,session,image));
        assert!(!encoded_identity_matches(&changed_again,Some(&current),&history,session,image));
    }
    #[test]
    fn opaque_output_proof_keeps_exact_audience_source_incarnation_and_full_binding_identity() {
        let (key,_)=fixture();let session=key.textures.publication.cpu.source.session;let team=key.textures.publication.cpu.source.team;let image=key.textures.allocations.output.0;
        let proof=EncodedOutputProof {key:key.clone()};assert!(proof.matches_output(session,team,image,23,203));assert_eq!(proof.recovery(),1);
        assert!(!proof.matches_output(session+1,team,image,23,203));assert!(!proof.matches_output(session,1-team,image,23,203));
        assert!(!proof.matches_output(session,team,image,24,203));assert!(!proof.matches_output(session,team,image,23,204));
        let mut foreign=Assets::<Image>::default();let other=foreign.add(Image::default());assert_ne!(image,other.id());assert!(!proof.matches_output(session,team,other.id(),23,203));
        assert!(proof.matches_source(&key.textures.publication.cpu.source));
        let mut other_episode=key.textures.publication.cpu.source.clone();other_episode.episode+=1;assert!(!proof.matches_source(&other_episode));
        let (other_fixture,_)=fixture();let different_source=other_fixture.textures.publication.cpu.source;
        assert_eq!(different_source.session,session);assert_eq!(different_source.team,team);assert_eq!(different_source.episode,key.textures.publication.cpu.source.episode);
        assert!(!proof.matches_source(&different_source),"equal numeric episode is not the same Sources instance and registered view");
        let mut replaced=key.clone();replaced.textures.publication.cpu.source=different_source;
        assert!(!proof.same_identity(&EncodedOutputProof {key:replaced}));
        let mut recovered=key.clone();recovered.textures.recovery+=1;assert!(!proof.same_identity(&EncodedOutputProof {key:recovered}));
        let mut changed_view=key.clone();changed_view.views.fade[0]+=1;assert!(!proof.same_identity(&EncodedOutputProof {key:changed_view}));
        assert!(proof.same_identity(&EncodedOutputProof {key}));
    }
    #[test]
    fn readonly_output_api_refuses_real_cpu_assets_without_prepared_render_images_or_encodes() {
        let (snapshot,_,map,sources,texture,mut assets)=published_fixture();let publication=texture.transport_snapshot(&sources,&map).unwrap();
        let mut images=Images::new(texture.image.clone(),&mut assets,texture.settings.blur_kernel_sigma);
        images.source=publication.image.clone();images.session=Some((snapshot.session,publication.cpu.source.team));images.now=0.25;images.publication=Some(publication.clone());let output=images.output.id();
        let mut state=State::default();state.history.session=images.session;state.history.first_done=true;
        let mut world=World::new();world.insert_resource(images);world.insert_resource(state);world.insert_resource(Extraction::default());world.insert_resource(assets);
        assert!(encoded_output_for_team(&world,snapshot.session,publication.cpu.source.team,output).is_none());
        assert!(!ready_for_team(&world,snapshot.session,publication.cpu.source.team,output));
        assert!(encoded_output_for_team(&world,snapshot.session,2,output).is_none());
        world.remove_resource::<Images>();assert!(encoded_output_for_team(&world,snapshot.session,publication.cpu.source.team,output).is_none());
    }
}

#[cfg(test)]
mod preparation_context_tests {
    use super::*;
    use crate::fow_visibility_texture::transport_snapshot_tests::{published_fixture,refresh_fixture};

    #[test]
    fn first_frame_replacement_publications_and_recovery_supply_context_without_encoded_readiness() {
        let (snapshot,viewer,map,sources,mut texture,mut assets)=published_fixture();
        let first=texture.transport_snapshot(&sources,&map).unwrap();
        let images=Images::new(texture.image.clone(),&mut assets,texture.settings.blur_kernel_sigma);
        let output=images.output.id();let source=first.cpu.source.clone();
        let mut world=World::new();world.insert_resource(images);world.init_resource::<Extraction>();
        world.resource_mut::<Extraction>().restart(); // Same counter transition as RenderStartup recovery.
        assert!(output_recovery_for_preparation(&world,&source,output).is_none());
        let mut extracted=ExtractedAssets::<GpuImage>::default();let mut previous=None;
        // Use actual CPU publications and the production Image handoff. No
        // State, PipelineCache, RenderAssets<GpuImage> or fake GPU ID exists.
        for frame in 0..4 {
            let now=(frame+1) as f32*0.25;
            if frame>0 {refresh_fixture(&mut texture,&snapshot,viewer,&sources,&map,now,&mut assets).unwrap();}
            let publication=texture.transport_snapshot(&sources,&map).unwrap();
            if let Some(previous)=previous {assert_ne!(publication.image.id(),previous);}
            previous=Some(publication.image.id());
            {let mut images=world.resource_mut::<Images>();images.source=publication.image.clone();images.session=Some((source.session,source.team));images.now=now;images.publication=Some(publication.clone());}
            extracted.extracted.clear();extracted.added.clear();extracted.modified.clear();extracted.removed.clear();
            let mut extraction=world.remove_resource::<Extraction>().unwrap();
            assert!(reconcile_extracted(&mut extraction,&mut extracted,Some(publication.image.id()),Some(publication.clone()),Some(&assets)));
            assert!(handoff_owned(&mut extraction,&mut extracted,Some(&publication)));
            world.insert_resource(extraction);
            assert_eq!(output_recovery_for_preparation(&world,&source,output),Some(1),"binding metadata is available in PrepareAssets on the same first/publication frame");
            assert!(encoded_output_for_team(&world,source.session,source.team,output).is_none(),"preparation metadata never stands in for a real GPU encode");
        }
        world.resource_mut::<Extraction>().restart();
        assert!(output_recovery_for_preparation(&world,&source,output).is_none(),"recovery revokes the old handoff context");
        let publication=texture.transport_snapshot(&sources,&map).unwrap();
        let mut extraction=world.remove_resource::<Extraction>().unwrap();
        assert!(reconcile_extracted(&mut extraction,&mut extracted,Some(publication.image.id()),Some(publication.clone()),Some(&assets)));
        assert!(handoff_owned(&mut extraction,&mut extracted,Some(&publication)));
        world.insert_resource(extraction);
        assert_eq!(output_recovery_for_preparation(&world,&source,output),Some(2));
        assert!(encoded_output_for_team(&world,source.session,source.team,output).is_none());
        let mut wrong=source.clone();wrong.episode+=1;
        assert!(output_recovery_for_preparation(&world,&wrong,output).is_none());
        let foreign=assets.add(Image::default());
        assert!(output_recovery_for_preparation(&world,&source,foreign.id()).is_none());
        world.resource_mut::<Extraction>().exhausted=true;
        assert!(output_recovery_for_preparation(&world,&source,output).is_none());
    }
}
