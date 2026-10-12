#[allow(dead_code)]
#[path="../src/fow_postprocess.rs"] mod math;
use wgpu::*;
use std::sync::mpsc;
const WIDTH:u32=8;
fn texture(device:&Device,queue:&Queue,bytes:&[u8])->Texture {
    let size=Extent3d {width:WIDTH,height:WIDTH,depth_or_array_layers:1};
    let texture=device.create_texture(&TextureDescriptor {label:Some("native-fow-input"),size,mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::R8Unorm,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST,view_formats:&[]});
    queue.write_texture(TexelCopyTextureInfo {texture:&texture,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},bytes,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(WIDTH),rows_per_image:Some(WIDTH)},size);texture
}
fn run(device:&Device,queue:&Queue,pipeline:&ComputePipeline,source:&[u8],old:&[u8],params:[f32;4],mode:f32)->Vec<f32> {
    let source=texture(device,queue,source);let old=texture(device,queue,old);
    let sv=source.create_view(&TextureViewDescriptor::default());let ov=old.create_view(&TextureViewDescriptor::default());
    let sampler=device.create_sampler(&SamplerDescriptor {label:Some("native-fow-linear-clamp"),address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,mag_filter:FilterMode::Linear,min_filter:FilterMode::Linear,..Default::default()});
    let uniform=device.create_buffer(&BufferDescriptor {label:Some("native-fow-params"),size:32,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});
    let bytes:Vec<u8>=params.into_iter().chain([mode,0.,0.,0.]).flat_map(f32::to_le_bytes).collect();queue.write_buffer(&uniform,0,&bytes);
    let size=u64::from(WIDTH*WIDTH)*16;
    let output=device.create_buffer(&BufferDescriptor {label:Some("native-fow-output"),size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});
    let read=device.create_buffer(&BufferDescriptor {label:Some("native-fow-readback"),size,usage:BufferUsages::MAP_READ|BufferUsages::COPY_DST,mapped_at_creation:false});
    let group=device.create_bind_group(&BindGroupDescriptor {label:Some("native-fow-probe"),layout:&pipeline.get_bind_group_layout(0),entries:&[
        BindGroupEntry {binding:0,resource:BindingResource::TextureView(&sv)},BindGroupEntry {binding:1,resource:BindingResource::Sampler(&sampler)},BindGroupEntry {binding:2,resource:uniform.as_entire_binding()},BindGroupEntry {binding:3,resource:output.as_entire_binding()},BindGroupEntry {binding:4,resource:BindingResource::TextureView(&ov)},]});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor {label:Some("native-fow-compute")});
    {let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor {label:Some("native-fow-dispatch"),timestamp_writes:None});pass.set_pipeline(pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(1,1,1);}
    encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
    let (tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|{tx.send(result).unwrap();});device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();
    let data=read.slice(..).get_mapped_range();let values=data.chunks_exact(4).map(|v|f32::from_le_bytes(v.try_into().unwrap())).collect();drop(data);read.unmap();values
}
fn main() {
    let mut descriptor=InstanceDescriptor::new_without_display_handle();
    descriptor.backends=Backends::VULKAN;
    let instance=Instance::new(descriptor);
    let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions {power_preference:PowerPreference::HighPerformance,force_fallback_adapter:false,compatible_surface:None})).expect("Vulkan adapter");let info=adapter.get_info();
    let (device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {label:Some("native-fow-gpu-probe"),required_features:Features::empty(),required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native-fow-port"),source:ShaderSource::Wgsl(include_str!("../../../assets/shaders/fow_postprocess.wgsl").into())});
    let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:Some("native-fow-pipeline"),layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
    let mut receipts=Vec::new();let mut maximum=0f32;
    for pattern in 0..4 {
        let source:Vec<u8>=(0..64).map(|i|match pattern {0=>if i==27 {255}else{0},1=>if i%8<4 {255}else{0},2=>((i*37)%256) as u8,_=>127}).collect();
        let current:Vec<u8>=(0..64).map(|i|((i*19)%256) as u8).collect();
        let mut cases=vec![("fade".to_string(),[0.07,0.09,0.8,0.95],0.)];
        for (sigma,upscale) in [(-1.,false),(-1.,true),(0.5,false),(1.,false),(2.,true)] {
            let k=math::GaussianKernel::native(sigma,upscale).unwrap();for vertical in [false,true] {cases.push((format!("blur-sigma{sigma}-up{upscale}-vertical{vertical}"),[if vertical {0.}else{k.offset/WIDTH as f32},if vertical {k.offset/WIDTH as f32}else{0.},k.center,k.paired],1.));}
        }
        for (label,p,mode) in cases {
            let values=run(&device,&queue,&pipeline,&source,&current,p,mode);let mut error=0f32;
            for i in 0..64 {
                let uv=[((i%8) as f32+0.5)/8.,((i/8) as f32+0.5)/8.];
                let expected=if mode==0. {math::fade(source[i] as f32/255.,current[i] as f32/255.,p)}else{math::blur(&source,8,8,uv,p)};
                for channel in 0..3 {error=error.max((values[i*4+channel]-expected).abs());}
                assert_eq!(values[i*4+3],1.);assert!(expected.is_finite());
            }
            assert!(error<=0.002,"GPU {label} pattern{pattern}: error{error}");maximum=maximum.max(error);
            receipts.push(serde_json::json!({"stage":label,"pattern":pattern,"pixels":64,"maximum_rgb_error":error}));
        }
    }
    let receipt=serde_json::json!({"complete":false,"diagnostic_only":true,"backend":format!("{:?}",info.backend),"adapter":info.name,"cases":receipts,"maximum_rgb_error":maximum,"tolerance":0.002,"live_team_visibility_bound":false,"limits":["Actual Vulkan execution of ported compute shaders with explicit fixture textures and parameters.","Reference kernel coefficients checked separately against original constructor; original D3D GPU shaders not executed.","Native config/extent/stencil providers, target quantization, fade timing and live renderer integration remain incomplete."]});
    let path=std::path::Path::new("E:/OpenLeague/logs/fow-postprocess-gpu.json");std::fs::write(path,serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("GPU cases {}, max error {}",receipt["cases"].as_array().unwrap().len(),maximum);
}
