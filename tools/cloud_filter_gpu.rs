use wgpu::*;
use wgpu::util::{DeviceExt,TextureDataOrder};
use std::sync::mpsc;
fn main() {
 let mut desc=InstanceDescriptor::new_without_display_handle();desc.backends=Backends::VULKAN;let instance=Instance::new(desc);
 let adapter=bevy_tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();assert!(adapter.features().contains(Features::TEXTURE_COMPRESSION_BC));let info=adapter.get_info();
 let(device,queue)=bevy_tasks::block_on(adapter.request_device(&DeviceDescriptor {required_features:Features::TEXTURE_COMPRESSION_BC,required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
 let proof:serde_json::Value=serde_json::from_str(&std::fs::read_to_string("data/4.20/native_cloud_filter_gpu_cases.json").unwrap()).unwrap();let cases=proof["cases"].as_array().unwrap();
 let mut image=bevy_image::ktx2_buffer_to_image(&std::fs::read(proof["asset"].as_str().unwrap()).unwrap(),bevy_image::CompressedImageFormats::BC,false).unwrap();assert_eq!(image.texture_descriptor.mip_level_count,11);image.texture_descriptor.usage=TextureUsages::TEXTURE_BINDING;
 let texture=device.create_texture_with_data(&queue,&image.texture_descriptor,TextureDataOrder::MipMajor,image.data.as_ref().unwrap());let view=texture.create_view(&TextureViewDescriptor::default());
 let sampler=device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::Repeat,address_mode_v:AddressMode::Repeat,mag_filter:FilterMode::Linear,min_filter:FilterMode::Linear,mipmap_filter:MipmapFilterMode::Linear,..Default::default()});
 let module=device.create_shader_module(ShaderModuleDescriptor {label:Some("Cloud2 native BC1 mip filtering"),source:ShaderSource::Wgsl(r#"
 @group(0) @binding(0) var<storage,read> inputs:array<vec4<f32>>;
 @group(0) @binding(1) var<storage,read_write> output:array<vec4<f32>>;
 @group(0) @binding(2) var clouds:texture_2d<f32>;
 @group(0) @binding(3) var clouds_sampler:sampler;
 @compute @workgroup_size(1) fn main(@builtin(global_invocation_id) i:vec3<u32>) {let p=inputs[i.x];output[i.x]=textureSampleLevel(clouds,clouds_sampler,p.xy,p.z);}
 "#.into())});let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&module,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
 let bytes:Vec<u8>=cases.iter().flat_map(|c|c["input"].as_array().unwrap().iter().flat_map(|x|(x.as_f64().unwrap() as f32).to_le_bytes())).collect();let size=cases.len() as u64*16;
 let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
 let output=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
 let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:output.as_entire_binding()},BindGroupEntry {binding:2,resource:BindingResource::TextureView(&view)},BindGroupEntry {binding:3,resource:BindingResource::Sampler(&sampler)}]});
 let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(cases.len() as u32,1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
 let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
 let tolerance=proof["tolerance"].as_f64().unwrap() as f32;let mut maximum=0f32;
 for (i,c) in cases.iter().enumerate() {for ch in 0..4 {let error=(actual[i*4+ch]-c["expected"][ch].as_f64().unwrap() as f32).abs();assert!(error<=tolerance,"sample{i} channel{ch} error{error}");maximum=maximum.max(error);}}
 let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":cases.len(),"mip_count":11,"channels_checked":actual.len(),"maximum_error":maximum,"tolerance":tolerance,"format":"Bc1RgbaUnorm","address_u":"repeat","address_v":"repeat","mag":"linear","min":"linear","mip":"linear","limits":proof["limits"]});
 std::fs::write("logs/native-cloud-filter-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan Cloud2 BC1 filtering cases{} max error{maximum}",cases.len());
}
