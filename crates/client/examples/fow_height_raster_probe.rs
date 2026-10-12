#[allow(dead_code)] #[path="../src/native_game_cfg_text.rs"] mod native_game_cfg_text;
#[allow(dead_code)] #[path="../src/native_graphics_options.rs"] mod native_graphics_options;
#[allow(dead_code)] #[path="../src/fow_settings.rs"] mod fow_settings;
#[allow(dead_code)] #[path="../src/map10_native_config.rs"] mod map10_native_config;
#[allow(dead_code)] #[path="../src/native_fow.rs"] mod native_fow;
use wgpu::*;
use std::sync::mpsc;
fn main() {
    let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=Backends::VULKAN;
    let instance=Instance::new(descriptor);let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
    let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_height_raster_cases.json")).unwrap();let cases=proof["cases"].as_array().unwrap();let width=32u32;let height=(cases.len() as u32).div_ceil(width);
    let code=format!("{}\n{}",include_str!("../../../assets/shaders/fow_vertex_height_functions.wgsl"),r#"
struct Input {heights:vec4<f32>,clear:vec4<f32>,clip_w:vec4<f32>};
@group(0) @binding(0) var<storage,read> inputs:array<Input>;
@group(0) @binding(1) var<uniform> dimensions:vec4<f32>;
struct Out {@builtin(position) position:vec4<f32>,@location(0) fades:vec2<f32>};
@vertex fn vertex(@builtin(vertex_index) v:u32,@builtin(instance_index) i:u32)->Out {
 let p=inputs[i];let col=i%32u;let row=i/32u;
 let points=array<vec2<f32>,3>(vec2<f32>(-0.75,-0.75),vec2<f32>(0.75,-0.75),vec2<f32>(0.0,1.5));
 let center=vec2<f32>(2.0*(f32(col)+0.5)/dimensions.x-1.0,1.0-2.0*(f32(row)+0.5)/dimensions.y);
 var out:Out;let w=p.clip_w[v];out.position=vec4<f32>((center+points[v]/dimensions.xy)*w,0.0,w);
 let transported_y=p.heights[v]/p.heights.w;
 out.fades=native_fow_vertex_height(transported_y*p.heights.w,p.clear,vec4<f32>(0.0,-1000.0,0.01,10.0));return out;
}
@fragment fn fragment(in:Out)->@location(0) vec4<f32> {return vec4<f32>(in.fades,1.0,1.0);}
"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native-height-vertex-raster-interpolation"),source:ShaderSource::Wgsl(code.into())});
    let pipeline=device.create_render_pipeline(&RenderPipelineDescriptor {label:None,layout:None,vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[],compilation_options:Default::default()},primitive:PrimitiveState::default(),depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some("fragment"),targets:&[Some(ColorTargetState {format:TextureFormat::Rgba32Float,blend:None,write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
    let mut floats=Vec::<f32>::new();for c in cases {floats.extend(c["native_y"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(c["units"].as_f64().unwrap() as f32);floats.extend(c["clear"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.extend(c["clip_w"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(0.);}
    let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
    let uniform=device.create_buffer(&BufferDescriptor {label:None,size:16,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});let dimensions:Vec<u8>=[width as f32,height as f32,0.,0.].into_iter().flat_map(f32::to_le_bytes).collect();queue.write_buffer(&uniform,0,&dimensions);
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:uniform.as_entire_binding()}]});
    let target=device.create_texture(&TextureDescriptor {label:None,size:Extent3d {width,height,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba32Float,usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});let view=target.create_view(&TextureViewDescriptor::default());let size=(width*height*16) as u64;let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_render_pass(&RenderPassDescriptor {label:None,color_attachments:&[Some(RenderPassColorAttachment {view:&view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear(Color::TRANSPARENT),store:StoreOp::Store}})],..Default::default()});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.draw(0..3,0..cases.len() as u32);}
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(width*16),rows_per_image:Some(height)}},Extent3d {width,height,depth_or_array_layers:1});queue.submit([encoder.finish()]);
    let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
    let mut maximum_error=0f32;for(i,c) in cases.iter().enumerate() {assert_eq!(&actual[i*4+2..i*4+4],&[1.,1.],"raster coverage case{i}");for channel in 0..2 {let error=(actual[i*4+channel]-c["expected"][channel].as_f64().unwrap() as f32).abs();assert!(error<=0.00001,"raster interpolation case{i} channel{channel}: {error}, observed{} expected{}",actual[i*4+channel],c["expected"][channel]);maximum_error=maximum_error.max(error);}}
    let receipt=serde_json::json!({"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"rasterized_cases":cases.len(),"actual_map_triangles":proof["native_triangle_count"],"native_unit_profiles":[1,20],"fixture_cases":24,"perspective_fixture_cases":12,"height_channels_checked":cases.len()*2,"maximum_error":maximum_error,"tolerance":0.00001,"target_format":"Rgba32Float","limits":["Actual vertex/fragment raster interpolation with identical production native height helper; orthographic centroid fixtures from actual map triangles and explicit reciprocal-W perspective fixtures.","Original D3D, whole live geometry/morph/pose equivalence, full live perspective camera attribution and final color framebuffer attribution remain open."]});std::fs::write("logs/fow-height-raster-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan height raster cases{} actual triangles2214 maximum error{maximum_error}",cases.len());
}
