#[allow(dead_code)] #[path="../src/projected_surface.rs"] mod projected_surface;
use wgpu::*;
use std::sync::mpsc;
fn main() {
    let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=if std::env::var("WGPU_BACKEND").as_deref()==Ok("dx12"){Backends::DX12}else{Backends::VULKAN};
    let instance=Instance::new(descriptor);let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
    let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_height_raster_cases.json")).unwrap();let cases=proof["cases"].as_array().unwrap();let width=32u32;let height=(cases.len() as u32).div_ceil(width);
    let production=include_str!("../../../assets/shaders/projected_vertex.wgsl");
    let height_body=production.split("  let difference=").nth(1).unwrap().split("#ifdef VERTEX_COLORS").next().unwrap();
    let height_body=format!("let difference={height_body}").replace("out.world_position.y", "world_y");
    let code=format!("fn native_height(world_y:f32,projection_height:vec4<f32>)->f32 {{{height_body} return fade;}}\n{}",r#"
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
 out.fades=vec2<f32>(native_height(p.heights[v]/20.0,vec4<f32>(0.0,5.0,200.0,1.0)),1.0);return out;
}
@fragment fn fragment(in:Out)->@location(0) vec4<f32> {return vec4<f32>(in.fades.x,max(in.fades.x,0.0),1.0,1.0);}
"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native-height-vertex-raster-interpolation"),source:ShaderSource::Wgsl(code.into())});
    let pipeline=device.create_render_pipeline(&RenderPipelineDescriptor {label:None,layout:None,vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[],compilation_options:Default::default()},primitive:PrimitiveState::default(),depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some("fragment"),targets:&[Some(ColorTargetState {format:TextureFormat::Rgba32Float,blend:None,write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
    let mut floats=Vec::<f32>::new();for c in cases {let projection=projected_surface::TerrainProjection::new(bevy::prelude::Vec2::ZERO,bevy::prelude::Vec2::ONE,0.).unwrap().with_native_height(0.,5.,200.).unwrap();
    let _=projection;floats.extend(c["native_y"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(c["units"].as_f64().unwrap() as f32);floats.extend(c["clear"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.extend(c["clip_w"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(0.);}
    let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
    let uniform=device.create_buffer(&BufferDescriptor {label:None,size:16,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});let dimensions:Vec<u8>=[width as f32,height as f32,0.,0.].into_iter().flat_map(f32::to_le_bytes).collect();queue.write_buffer(&uniform,0,&dimensions);
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:uniform.as_entire_binding()}]});
    let target=device.create_texture(&TextureDescriptor {label:None,size:Extent3d {width,height,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba32Float,usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});let view=target.create_view(&TextureViewDescriptor::default());let size=(width*height*16) as u64;let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_render_pass(&RenderPassDescriptor {label:None,color_attachments:&[Some(RenderPassColorAttachment {view:&view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear(Color::TRANSPARENT),store:StoreOp::Store}})],..Default::default()});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.draw(0..3,0..cases.len() as u32);}
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(width*16),rows_per_image:Some(height)}},Extent3d {width,height,depth_or_array_layers:1});queue.submit([encoder.finish()]);
    let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
    let mut maximum_error=0f32;for(i,c) in cases.iter().enumerate() {assert_eq!(&actual[i*4+2..i*4+4],&[1.,1.],"raster coverage case{i}");for channel in 0..2 {let error=(actual[i*4+channel]-c["expected"][channel].as_f64().unwrap() as f32).abs();assert!(error<=0.00001,"raster interpolation case{i} channel{channel}: {error}, observed{} expected{}",actual[i*4+channel],c["expected"][channel]);maximum_error=maximum_error.max(error);}}
    let receipt=serde_json::json!({"complete":false,"passed":true,"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":cases.len(),"maximum_error":maximum_error,"limits":["Exact production vertex height expression extracted from projected_vertex.wgsl, GPU perspective interpolation and fragment clamp; analytic oracle, not original D3D.","Full production shader/material binding and native clipping remain separate checks."]});
    std::fs::write(format!("logs/projected-gpu-height-raster-{:?}.json",info.backend),serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("PASS {} cases {:?} error{}",cases.len(),info.backend,maximum_error);
}
