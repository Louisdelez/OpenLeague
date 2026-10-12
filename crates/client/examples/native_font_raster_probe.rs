use wgpu::*;
use std::sync::mpsc;
fn main() {
    let backend=std::env::args().nth(1).unwrap_or("vulkan".into());
    let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=match backend.as_str() {"vulkan"=>Backends::VULKAN,"dx12"=>Backends::DX12,_=>panic!("unknown backend")};
    let instance=Instance::new(descriptor);let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
    let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
    let size=Extent3d {width:64,height:64,depth_or_array_layers:1};
    let font=device.create_texture(&TextureDescriptor {label:Some("native font BGRA bytes"),size,mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Bgra8Unorm,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST,view_formats:&[]});
    let mut bytes=Vec::new();for y in 0..64u8 {for x in 0..64u8 {let fill=x*4;let outline=(y*4).min(255-fill);bytes.extend([outline,0,fill,255]);}}
    queue.write_texture(TexelCopyTextureInfo {texture:&font,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},&bytes,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(256),rows_per_image:Some(64)},size);
    let font_view=font.create_view(&TextureViewDescriptor::default());
    let layout=device.create_bind_group_layout(&BindGroupLayoutDescriptor {label:None,entries:&[BindGroupLayoutEntry {binding:0,visibility:ShaderStages::FRAGMENT,ty:BindingType::Texture {sample_type:TextureSampleType::Float {filterable:false},view_dimension:TextureViewDimension::D2,multisampled:false},count:None}]});
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&layout,entries:&[BindGroupEntry {binding:0,resource:BindingResource::TextureView(&font_view)}]});
    let pipeline_layout=device.create_pipeline_layout(&PipelineLayoutDescriptor {label:None,bind_group_layouts:&[Some(&layout)],immediate_size:0});
    let code=format!("{}{}",include_str!("../../../assets/shaders/native_font_functions.wgsl"),r#"
@group(0) @binding(0) var font:texture_2d<f32>;
@vertex fn vertex(@builtin(vertex_index) index:u32)->@builtin(position) vec4<f32> {
 let points=array<vec2<f32>,3>(vec2<f32>(-1.0,-1.0),vec2<f32>(3.0,-1.0),vec2<f32>(-1.0,3.0));return vec4<f32>(points[index],0.0,1.0);
}
@fragment fn fill_outline(@builtin(position) p:vec4<f32>)->@location(0) vec4<f32> {
 return native_font_fill_outline(textureLoad(font,vec2<i32>(p.xy),0),vec4<f32>(64.0,128.0,192.0,128.0)/255.0,vec4<f32>(0.75,0.5,0.25,0.8),vec4<f32>(0.25,0.75,0.5,0.6));
}
@fragment fn glow(@builtin(position) p:vec4<f32>)->@location(0) vec4<f32> {return native_font_glow(textureLoad(font,vec2<i32>(p.xy),0),vec4<f32>(0.75,0.5,0.25,0.8));}
"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native font fill outline glow"),source:ShaderSource::Wgsl(code.into())});
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_raster_reference.json")).unwrap();let mut passes=Vec::new();
    for name in ["fill_outline","glow"] {
        let blend=if name=="fill_outline" {BlendComponent {src_factor:BlendFactor::One,dst_factor:BlendFactor::SrcAlpha,operation:BlendOperation::Add}}else {BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add}};
        let pipeline=device.create_render_pipeline(&RenderPipelineDescriptor {label:Some(name),layout:Some(&pipeline_layout),vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[],compilation_options:Default::default()},primitive:PrimitiveState::default(),depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some(name),targets:&[Some(ColorTargetState {format:TextureFormat::Rgba8Unorm,blend:Some(BlendState {color:blend,alpha:blend}),write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
        let target=device.create_texture(&TextureDescriptor {label:None,size,mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba8Unorm,usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});let view=target.create_view(&TextureViewDescriptor::default());
        let read=device.create_buffer(&BufferDescriptor {label:None,size:16384,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());
        {let mut pass=encoder.begin_render_pass(&RenderPassDescriptor {label:Some(name),color_attachments:&[Some(RenderPassColorAttachment {view:&view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear(Color {r:32.0/255.0,g:64.0/255.0,b:96.0/255.0,a:128.0/255.0}),store:StoreOp::Store}})],..Default::default()});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.draw(0..3,0..1);}
        encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(256),rows_per_image:Some(64)}},size);queue.submit([encoder.finish()]);
        let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let mut maximum_error=0i32;
        let expected=proof[name].as_array().unwrap();assert_eq!(expected.len(),4096);
        for (index,pixel) in expected.iter().enumerate() {for channel in 0..4 {let reference=pixel[channel].as_u64().unwrap() as i32;let actual=data[index*4+channel] as i32;let error=(actual-reference).abs();assert!(error<=1,"{name} pixel{index} channel{channel} actual{actual} reference{reference}");maximum_error=maximum_error.max(error);}}
        std::fs::write(format!("logs/native-font-raster-{backend}-{name}.rgba"),&*data).unwrap();drop(data);read.unmap();passes.push(serde_json::json!({"pass":name,"pixels":4096,"channels":16384,"maximum_byte_error":maximum_error}));
    }
    let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"passes":passes,"source_texture_format":"Bgra8Unorm","target_texture_format":"Rgba8Unorm","tolerance_bytes":1,"limits":["Actual raster and fixed-function blending use literal source HLSL math and native qualified blend settings against independent rational reference. No original D3D framebuffer comparison.","Explicit textureLoad test, known uniform fill-texture values and chosen already-swizzled colors; native filtered sampling, vertex transform/swizzle, glyph layout, secondary atlas/glow production and HUD callers remain open."]});std::fs::write(format!("logs/native-font-raster-{backend}-gpu.json"),serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Native font raster {backend}: two passes,8192pixels verified");
}
