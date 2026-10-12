#[allow(dead_code)]
#[path="../src/fow_postprocess.rs"] mod math;
use wgpu::*;
use std::sync::mpsc;
const N:u32=8;
fn texture(device:&Device,queue:&Queue,bytes:Option<&[u8]>,format:TextureFormat)->Texture {
    let tex=device.create_texture(&TextureDescriptor {label:Some("fow-quantized-texture"),size:Extent3d {width:N,height:N,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_SRC|TextureUsages::COPY_DST|if format==TextureFormat::R8Unorm {TextureUsages::empty()}else{TextureUsages::STORAGE_BINDING},view_formats:&[]});
    if let Some(bytes)=bytes {queue.write_texture(TexelCopyTextureInfo {texture:&tex,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},bytes,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(N*if format==TextureFormat::R8Unorm {1}else{4}),rows_per_image:Some(N)},Extent3d {width:N,height:N,depth_or_array_layers:1});}
    tex
}
fn stage(device:&Device,queue:&Queue,pipeline:&ComputePipeline,source:&Texture,current:&Texture,parameters:[f32;4],mode:f32)->Texture {
    let out=texture(device,queue,None,TextureFormat::Rgba8Unorm);
    let sv=source.create_view(&TextureViewDescriptor::default());let cv=current.create_view(&TextureViewDescriptor::default());let ov=out.create_view(&TextureViewDescriptor::default());
    let sampler=device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,min_filter:FilterMode::Linear,mag_filter:FilterMode::Linear,..Default::default()});
    let uniform=device.create_buffer(&BufferDescriptor {label:None,size:32,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});
    let bytes:Vec<u8>=parameters.into_iter().chain([mode,0.,0.,0.]).flat_map(f32::to_le_bytes).collect();queue.write_buffer(&uniform,0,&bytes);
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[
        BindGroupEntry {binding:0,resource:BindingResource::TextureView(&sv)},BindGroupEntry {binding:1,resource:BindingResource::Sampler(&sampler)},BindGroupEntry {binding:2,resource:uniform.as_entire_binding()},BindGroupEntry {binding:3,resource:BindingResource::TextureView(&ov)},BindGroupEntry {binding:4,resource:BindingResource::TextureView(&cv)}]});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());
    {let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor {label:None,timestamp_writes:None});pass.set_pipeline(pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(1,1,1);}
    queue.submit([encoder.finish()]);out
}
fn read(device:&Device,queue:&Queue,tex:&Texture)->Vec<u8> {
    let buffer=device.create_buffer(&BufferDescriptor {label:None,size:u64::from(256*N),usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:tex,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&buffer,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(256),rows_per_image:Some(N)}},Extent3d {width:N,height:N,depth_or_array_layers:1});queue.submit([encoder.finish()]);
    let(tx,rx)=mpsc::channel();buffer.slice(..).map_async(MapMode::Read,move|r|tx.send(r).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();
    let data=buffer.slice(..).get_mapped_range();let mut red=Vec::new();
    for y in 0..N as usize {for x in 0..N as usize {let p=&data[y*256+x*4..y*256+x*4+4];assert_eq!(p[0],p[1]);assert_eq!(p[0],p[2]);assert_eq!(p[3],255);red.push(p[0]);}}
    drop(data);buffer.unmap();red
}
fn rgba(red:&[u8])->Vec<u8> {red.iter().flat_map(|v|[*v,*v,*v,255]).collect()}
fn quantize(v:f32)->u8 {(v.clamp(0.,1.)*255.).round() as u8}
fn main() {
    let mut desc=InstanceDescriptor::new_without_display_handle();desc.backends=Backends::VULKAN;let instance=Instance::new(desc);
    let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
    let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("fow-native-8bit-stages"),source:ShaderSource::Wgsl(include_str!("../../../assets/shaders/fow_postprocess_texture.wgsl").into())});
    let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
    let mut cases=Vec::new();let mut maximum=0u8;
    for pattern in 0..4 {
        let source:Vec<u8>=(0..64).map(|i|match pattern {0=>if i==27 {255}else{0},1=>if i%8<4 {255}else{0},2=>((i*37)%256) as u8,_=>127}).collect();
        for first in [false,true] {for sigma in [-1.,0.5,1.,2.] {
            let current:Vec<u8>=(0..64).map(|i|if first {0}else{((i*19)%256) as u8}).collect();
            let input=texture(&device,&queue,Some(&source),TextureFormat::R8Unorm);let old=texture(&device,&queue,Some(&rgba(&current)),TextureFormat::Rgba8Unorm);
            let fade=[0.2,0.05,0.,if first {0.}else{1.1}];
            let faded=stage(&device,&queue,&pipeline,&input,&old,fade,0.);
            let mut reference:Vec<u8>=source.iter().zip(&current).map(|(t,c)|quantize(math::fade(*t as f32/255.,*c as f32/255.,fade))).collect();
            let kernel=math::GaussianKernel::native(sigma,true).unwrap();
            let horizontal=[kernel.offset/N as f32,0.,kernel.center,kernel.paired];let vertical=[0.,kernel.offset/N as f32,kernel.center,kernel.paired];
            let blurred_x=stage(&device,&queue,&pipeline,&faded,&old,horizontal,1.);let blurred_y=stage(&device,&queue,&pipeline,&blurred_x,&old,vertical,1.);
            for(tex,params,name) in [(&faded,fade,"fade"),(&blurred_x,horizontal,"horizontal"),(&blurred_y,vertical,"vertical")] {
                if name!="fade" {reference=(0..64).map(|i|quantize(math::blur(&reference,N as usize,N as usize,[(i%8) as f32/8.+0.0625,(i/8) as f32/8.+0.0625],params))).collect();}
                let actual=read(&device,&queue,tex);let error=actual.iter().zip(&reference).map(|(a,b)|a.abs_diff(*b)).max().unwrap();maximum=maximum.max(error);assert!(error<=1,"{pattern} first{first} sigma{sigma} stage{name} error{error}");
                cases.push(serde_json::json!({"pattern":pattern,"first_frame":first,"sigma":sigma,"stage":name,"pixels":64,"maximum_byte_error":error}));
            }
        }}
    }
    let receipt=serde_json::json!({"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":cases,"maximum_byte_error":maximum,"byte_tolerance":1,"intermediate_format":"RGBA8Unorm RGB equivalent of native X8R8G8B8; alpha forced1","gpu_resident_stage_chain":true,"diagnostic_only":true,"live_visibility_bound":false,"limits":["GPU input is a diagnostic R8Unorm mask matching native L8 red-channel semantics; live visibility remains unbound.","Original D3D rasterization/rounding not compared; CPU reference rounds each stage to8bits.","Extent/config/stencil providers and actual renderer binding remain open."]});
    std::fs::write("logs/fow-texture-gpu.json",serde_json::to_string_pretty(&receipt).unwrap()).unwrap();println!("Quantized GPU cases {} maximum byte error {maximum}",cases.len());
}
