from pathlib import Path
import sys,json,hashlib,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');native=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Shaders\HLSL\Renderer\VS_SCREENVERTEX_SCALE_AND_BIAS.vs_2_0')
out=r/'data/4.20/shaders/Renderer'/native.name;out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(native,out)
image=Image.open(r/'assets/maps/grass_native/wall_of_grass_mask.png').convert('RGBA');assert image.size==(256,256);(r/'assets/maps/grass_native/wall_of_grass_mask.rgba').write_bytes(image.tobytes())
(r/'assets/shaders/native_grass_mask.wgsl').write_text('''// Port of Renderer/VS_SCREENVERTEX_SCALE_AND_BIAS and FILTERS/PS_COPY_FILTER.
// SCREEN_MATRIX is supplied by the renderer; native producer remains to qualify.
struct Parameters { screen_matrix: mat4x4<f32>, destination: vec4<f32>, source_uv: vec4<f32> }
@group(0) @binding(0) var image: texture_2d<f32>;
@group(0) @binding(1) var image_sampler: sampler;
@group(0) @binding(2) var<uniform> parameters: Parameters;
struct VertexOutput { @builtin(position) position: vec4<f32>, @location(0) uv: vec2<f32> }
@vertex fn vertex(@builtin(vertex_index) index: u32) -> VertexOutput {
    let corners = array<vec2<f32>,6>(vec2<f32>(0.,0.),vec2<f32>(1.,0.),vec2<f32>(0.,1.),vec2<f32>(0.,1.),vec2<f32>(1.,0.),vec2<f32>(1.,1.));
    let corner = corners[index];
    let position = corner * parameters.destination.zw + parameters.destination.xy;
    var result: VertexOutput;
    result.position = parameters.screen_matrix * vec4<f32>(position, 0., 1.);
    result.uv = corner * parameters.source_uv.zw + parameters.source_uv.xy;
    return result;
}
@fragment fn fragment(input: VertexOutput) -> @location(0) vec4<f32> {
    return textureSample(image, image_sampler, input.uv);
}
''',encoding='utf-8')
(r/'crates/client/examples/grass_mask_gpu_probe.rs').write_text('''#[path="../src/grass_quad.rs"] mod grass_quad;
use wgpu::*;
use wgpu::util::DeviceExt;
use std::sync::mpsc;
fn main() {
    let width = 1024u32; let height = 512u32;
    let brush = include_bytes!("../../../assets/maps/grass_native/wall_of_grass_mask.rgba");
    let mut descriptor = InstanceDescriptor::new_without_display_handle(); descriptor.backends = Backends::VULKAN;
    let instance = Instance::new(descriptor);
    let adapter = bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap(); let info = adapter.get_info();
    let (device, queue) = bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits: Limits::downlevel_defaults(), ..Default::default()})).unwrap();
    let texture = device.create_texture(&TextureDescriptor {label: None,size: Extent3d {width:256,height:256,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba8Unorm,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST,view_formats:&[]});
    queue.write_texture(TexelCopyTextureInfo {texture:&texture,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},brush,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(1024),rows_per_image:Some(256)},Extent3d {width:256,height:256,depth_or_array_layers:1});
    let texture_view = texture.create_view(&TextureViewDescriptor::default());
    // Explicit qualification adapter: nearest filtering and clamp-to-edge, not native sampler acceptance.
    let sampler = device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,mag_filter:FilterMode::Nearest,min_filter:FilterMode::Nearest,..Default::default()});
    let shader = device.create_shader_module(ShaderModuleDescriptor {label:None,source:ShaderSource::Wgsl(include_str!("../../../assets/shaders/native_grass_mask.wgsl").into())});
    let pipeline = device.create_render_pipeline(&RenderPipelineDescriptor {label:None,layout:None,vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[],compilation_options:Default::default()},primitive:PrimitiveState::default(),depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some("fragment"),targets:&[Some(ColorTargetState {format:TextureFormat::Rgba8Unorm,blend:None,write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
    let mut quads = Vec::new();
    for (x, api) in [(16,0),(304,1),(592,2)] {
        quads.push(grass_quad::OffsetCache::default().prepare([x,16,x+256,272],[0,0,256,256],Some([256,256]),api).unwrap());
    }
    quads.push(grass_quad::OffsetCache::default().prepare([100,100,228,228],[0,0,256,256],Some([256,256]),2).unwrap());
    let bindings: Vec<_> = quads.iter().map(|quad| {
        // Explicit screen-matrix adapter maps pixels to Vulkan clip space.
        let mut values = vec![2./width as f32,0.,0.,0.,0.,-2./height as f32,0.,0.,0.,0.,1.,0.,-1.,1.,0.,1.];
        values.extend(quad.destination_xywh); values.extend(quad.source_uv_origin_span);
        let bytes:Vec<_> = values.iter().flat_map(|value| value.to_le_bytes()).collect();
        let uniform = device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&bytes,usage:BufferUsages::UNIFORM});
        device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:BindingResource::TextureView(&texture_view)},BindGroupEntry {binding:1,resource:BindingResource::Sampler(&sampler)},BindGroupEntry {binding:2,resource:uniform.as_entire_binding()}]})
    }).collect();
    let size = Extent3d {width,height,depth_or_array_layers:1};
    let target = device.create_texture(&TextureDescriptor {label:None,size,mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba8Unorm,usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});
    let target_view = target.create_view(&TextureViewDescriptor::default());
    let read = device.create_buffer(&BufferDescriptor {label:None,size:(width*height*4) as u64,usage:BufferUsages::MAP_READ|BufferUsages::COPY_DST,mapped_at_creation:false});
    let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor::default());
    { let mut pass = encoder.begin_render_pass(&RenderPassDescriptor {label:None,color_attachments:&[Some(RenderPassColorAttachment {view:&target_view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear(Color::WHITE),store:StoreOp::Store}})],..Default::default()});
      pass.set_pipeline(&pipeline); for binding in &bindings { pass.set_bind_group(0,binding,&[]); pass.draw(0..6,0..1); }
    }
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(width*4),rows_per_image:Some(height)}},size);
    queue.submit([encoder.finish()]); let (tx,rx)=mpsc::channel(); read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap()); device.poll(PollType::wait_indefinitely()).unwrap(); rx.recv().unwrap().unwrap();
    let data = read.slice(..).get_mapped_range(); let mut covered=0; let mut overwritten=0;
    for y in 0..height { for x in 0..width {
        let mut expected=[255u8;4]; let mut hits=0;
        for quad in &quads {
            let p=[x as f64+0.5,y as f64+0.5]; let d=quad.destination_xywh;
            if p[0] < d[0] as f64 || p[0] >= (d[0]+d[2]) as f64 || p[1] < d[1] as f64 || p[1] >= (d[1]+d[3]) as f64 {continue;}
            hits+=1; let uv=quad.source_uv_origin_span;
            let sx=((uv[0] as f64+(p[0]-d[0] as f64)/d[2] as f64*uv[2] as f64)*256.).floor().clamp(0.,255.) as usize;
            let sy=((uv[1] as f64+(p[1]-d[1] as f64)/d[3] as f64*uv[3] as f64)*256.).floor().clamp(0.,255.) as usize;
            expected.copy_from_slice(&brush[(sy*256+sx)*4..(sy*256+sx)*4+4]);
        }
        if hits>0 {covered+=1;} if hits>1 {overwritten+=1;}
        let at=((y*width+x)*4) as usize; assert_eq!(&data[at..at+4],&expected,"pixel{x},{y}");
    }}
    std::fs::write("logs/grass-mask-gpu.rgba",&*data).unwrap();drop(data);read.unmap();
    let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"width":width,"height":height,"pixels_checked":width*height,"channels_checked":width*height*4,"covered_pixels":covered,"overwritten_pixels":overwritten,"quad_draws":quads.len(),"production_shader":"assets/shaders/native_grass_mask.wgsl","production_parameters":"crates/client/src/grass_quad.rs","limits":["Actual Vulkan raster uses recovered decoded original brush, native quad parameter helper and ported native vertex/pixel shader expressions.","Nearest/clamp sampling, Rgba8Unorm target, screen matrix and vertex topology are explicit qualification adapters; original driver target/clear/filter/buffers remain open.","CPU expected pixels cover copied alpha, preserved outside clear and overlapping last-write order; no original D3D framebuffer comparison or full historical filtered precision acceptance.","Not connected to live actors/camera or normal grass pass; all game domains remain unfinished."]});
    std::fs::write("logs/grass-mask-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Grass mask GPU{}pixels {}overlap pixels verified",width*height,overwritten);
}
''',encoding='utf-8')
print(json.dumps({'native_vertex_shader_recovered':str(out),'brush_bytes':len(image.tobytes()),'shader_port_written':True,'gpu_probe_written':True}))
