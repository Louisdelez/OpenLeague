#[path="../src/grass_constants.rs"] mod grass_constants;
#[path="../src/grass_target_viewport.rs"] mod grass_target_viewport;
#[path="../src/grass_buffers.rs"] mod grass_buffers;
#[path="../src/grass_screen_matrix.rs"] mod grass_screen_matrix;
#[path="../src/grass_pass_state.rs"] mod grass_pass_state;
#[path="../src/grass_quad.rs"] mod grass_quad;
use wgpu::*;
use wgpu::util::DeviceExt;
use std::sync::mpsc;
fn main() {
    let width = 1024u32; let height = 512u32;
    let profile=std::env::var("OPENLEAGUE_GRASS_FILTER_PROFILE").unwrap_or_else(|_|"point".into());
    let linear=match profile.as_str() {"point"=>false,"linear"=>true,_=>panic!("unqualified filter profile")};
    let output=std::env::var("OPENLEAGUE_GRASS_PROBE_OUTPUT").unwrap_or_else(|_|"logs/grass-mask-gpu".into());
    let inherited_filters=if linear {[2,2,0]} else {grass_pass_state::RESET_D3D_FILTERS};
    let brush = include_bytes!("../../../assets/maps/grass_native/wall_of_grass_mask.rgba");
    let mut descriptor = InstanceDescriptor::new_without_display_handle(); descriptor.backends = Backends::VULKAN;
    let instance = Instance::new(descriptor);
    let adapter = bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap(); let info = adapter.get_info();
    let (device, queue) = bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits: Limits::downlevel_defaults(), ..Default::default()})).unwrap();
    let texture = device.create_texture(&TextureDescriptor {label: None,size: Extent3d {width:256,height:256,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba8Unorm,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST,view_formats:&[]});
    queue.write_texture(TexelCopyTextureInfo {texture:&texture,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},brush,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(1024),rows_per_image:Some(256)},Extent3d {width:256,height:256,depth_or_array_layers:1});
    let texture_view = texture.create_view(&TextureViewDescriptor::default());
    // Native reset filtering + quad U/V clamp; later scene inheritance remains unqualified.
    let sampler_config = grass_pass_state::mask_sampler(inherited_filters).unwrap();
    let sampler = device.create_sampler(&sampler_config.as_wgpu());
    let shader = device.create_shader_module(ShaderModuleDescriptor {label:None,source:ShaderSource::Wgsl(include_str!("../../../assets/shaders/native_grass_mask.wgsl").into())});
    let pipeline = device.create_render_pipeline(&RenderPipelineDescriptor {label:None,layout:None,vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[VertexBufferLayout {array_stride:grass_buffers::STRIDE,step_mode:VertexStepMode::Vertex,attributes:&[VertexAttribute {format:VertexFormat::Float32x3,offset:0,shader_location:0},VertexAttribute {format:VertexFormat::Unorm8x4,offset:12,shader_location:1},VertexAttribute {format:VertexFormat::Float32x2,offset:16,shader_location:2}]}],compilation_options:Default::default()},primitive:PrimitiveState {topology:PrimitiveTopology::TriangleStrip,strip_index_format:Some(IndexFormat::Uint16),..Default::default()},depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some("fragment"),targets:&[Some(ColorTargetState {format:grass_pass_state::mask_target_format(),blend:None,write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
    let vertex_bytes:Vec<u8>=grass_buffers::VERTEX_WORDS.iter().flat_map(|v|v.to_le_bytes()).collect();
    let index_bytes:Vec<u8>=grass_buffers::INDICES.iter().flat_map(|v|v.to_le_bytes()).collect();
    let vertices=device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&vertex_bytes,usage:BufferUsages::VERTEX});
    let indices=device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&index_bytes,usage:BufferUsages::INDEX});
    let mut viewport_state=grass_target_viewport::State {dimensions:[0,0],matrix:[0.;16]};
    let viewport=viewport_state.apply(true,0,[width,height],0).unwrap();
    let mut quads = Vec::new();
    for (x, api) in [(16,0),(304,1),(592,2)] {
        quads.push(grass_quad::OffsetCache::default().prepare([x,16,x+256,272],[0,0,256,256],Some([256,256]),api).unwrap());
    }
    quads.push(grass_quad::OffsetCache::default().prepare([100,100,228,228],[0,0,256,256],Some([256,256]),2).unwrap());
    if linear {quads.push(grass_quad::OffsetCache::default().prepare([16,304,401,497],[9,13,233,251],Some([256,256]),2).unwrap());}
    let bindings: Vec<_> = quads.iter().map(|quad| {
        // Native API0 matrix; API0 clip convention selected explicitly for this Vulkan probe.
        let matrix = viewport_state.matrix;
        let bytes = grass_constants::encode(matrix,quad.destination_xywh,quad.source_uv_origin_span,[1.;4]);
        let uniform = device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&bytes,usage:BufferUsages::UNIFORM});
        device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:BindingResource::TextureView(&texture_view)},BindGroupEntry {binding:1,resource:BindingResource::Sampler(&sampler)},BindGroupEntry {binding:2,resource:uniform.as_entire_binding()}]})
    }).collect();
    let size = Extent3d {width,height,depth_or_array_layers:1};
    let target = device.create_texture(&TextureDescriptor {label:None,size,mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:grass_pass_state::mask_target_format(),usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});
    let target_view = target.create_view(&TextureViewDescriptor::default());
    let read = device.create_buffer(&BufferDescriptor {label:None,size:(width*height*4) as u64,usage:BufferUsages::MAP_READ|BufferUsages::COPY_DST,mapped_at_creation:false});
    let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor::default());
    { let mut pass = encoder.begin_render_pass(&RenderPassDescriptor {label:None,color_attachments:&[Some(RenderPassColorAttachment {view:&target_view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear({let c=grass_pass_state::mask_clear_rgba();Color {r:c[0],g:c[1],b:c[2],a:c[3]}}),store:StoreOp::Store}})],..Default::default()});
      pass.set_pipeline(&pipeline); pass.set_viewport(viewport[0],viewport[1],viewport[2],viewport[3],viewport[4],viewport[5]); pass.set_vertex_buffer(0,vertices.slice(..)); pass.set_index_buffer(indices.slice(..),IndexFormat::Uint16); for binding in &bindings { pass.set_bind_group(0,binding,&[]); pass.draw_indexed(0..4,0,0..1); }
    }
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(width*4),rows_per_image:Some(height)}},size);
    queue.submit([encoder.finish()]); let (tx,rx)=mpsc::channel(); read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap()); device.poll(PollType::wait_indefinitely()).unwrap(); rx.recv().unwrap().unwrap();
    let data = read.slice(..).get_mapped_range(); let mut covered=0; let mut overwritten=0; let mut max_error=0u8; let mut channel_errors=[0u64;2];
    for y in 0..height { for x in 0..width {
        let mut expected=[255u8;4]; let mut hits=0;
        for quad in &quads {
            let p=[x as f64+0.5,y as f64+0.5]; let d=quad.destination_xywh;
            if p[0] < d[0] as f64 || p[0] >= (d[0]+d[2]) as f64 || p[1] < d[1] as f64 || p[1] >= (d[1]+d[3]) as f64 {continue;}
            hits+=1; let uv=quad.source_uv_origin_span;
            let sx=(uv[0] as f64+(p[0]-d[0] as f64)/d[2] as f64*uv[2] as f64)*256.;
            let sy=(uv[1] as f64+(p[1]-d[1] as f64)/d[3] as f64*uv[3] as f64)*256.;
            if linear {
                // Independent bilinear reference at texel centers, with clamp-to-edge addressing.
                let fx=sx-0.5;let fy=sy-0.5;let ix=fx.floor();let iy=fy.floor();let tx=fx-ix;let ty=fy-iy;
                let sample=|x:f64,y:f64,c:usize|brush[(y.clamp(0.,255.) as usize*256+x.clamp(0.,255.) as usize)*4+c] as f64;
                expected=std::array::from_fn(|c|((sample(ix,iy,c)*(1.-tx)+sample(ix+1.,iy,c)*tx)*(1.-ty)+(sample(ix,iy+1.,c)*(1.-tx)+sample(ix+1.,iy+1.,c)*tx)*ty).round().clamp(0.,255.) as u8);
            } else {
                let sx=sx.floor().clamp(0.,255.) as usize;let sy=sy.floor().clamp(0.,255.) as usize;
                expected.copy_from_slice(&brush[(sy*256+sx)*4..(sy*256+sx)*4+4]);
            }
        }
        if hits>0 {covered+=1;} if hits>1 {overwritten+=1;}
        let at=((y*width+x)*4) as usize;
        for channel in 0..4 {let error=data[at+channel].abs_diff(expected[channel]);assert!(error<=if linear {1} else {0},"pixel{x},{y},channel{channel}:actual{}expected{}",data[at+channel],expected[channel]);max_error=max_error.max(error);channel_errors[error as usize]+=1;}
    }}
    std::fs::write(format!("{output}.rgba"),&*data).unwrap();drop(data);read.unmap();
    let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"width":width,"height":height,"pixels_checked":width*height,"channels_checked":width*height*4,"covered_pixels":covered,"overwritten_pixels":overwritten,"quad_draws":quads.len(),"target_format":format!("{:?}",grass_pass_state::mask_target_format()),"native_d3d_format":grass_pass_state::MASK_D3D_FORMAT,"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,"inherited_d3d_filters":inherited_filters,"filter_profile":profile,"max_channel_error":max_error,"allowed_channel_error":if linear {1} else {0},"channel_errors":channel_errors,"native_screen_matrix_api":0,"native_vertex_stride":grass_buffers::STRIDE,"native_quad_indices":grass_buffers::INDICES,"native_viewport_applied":true,"native_constant_bytes":112,"production_shader":"assets/shaders/native_grass_mask.wgsl","production_parameters":"crates/client/src/grass_quad.rs","limits":["Actual Vulkan raster uses recovered decoded original brush, native quad parameter helper and ported native vertex/pixel shader expressions.","Point/linear no-mip filter profile supplied explicitly; quad clamp addressing, BGRA8 target and clear color have native API evidence. Native API0 screen-matrix arithmetic shared. Native2D viewport helper and recovered24byte vertices/4index triangle strip shared. Native constant register encoding c0..c6 shared. Later scene filter inheritance, API selection/clip bridge and declaration API creation remain qualification adapters.","CPU expected pixels cover copied alpha, preserved outside clear and overlapping last-write order; no original D3D framebuffer comparison or full historical filtered precision acceptance.","Not connected to live actors/camera or normal grass pass; all game domains remain unfinished."]});
    std::fs::write(format!("{output}.json"),serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Grass mask GPU{}pixels {}overlap pixels verified",width*height,overwritten);println!("Filter profile:{profile}; maximum8bit channelerror:{max_error}");
}
