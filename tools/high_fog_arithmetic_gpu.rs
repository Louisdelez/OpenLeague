use wgpu::*;
use std::sync::mpsc;
fn main() {
 let args:Vec<_>=std::env::args().collect();let shader_path=args.get(1).map(String::as_str).unwrap_or("logs/native-high-fog-arithmetic-probe.wgsl");let cases_path=args.get(2).map(String::as_str).unwrap_or("data/4.20/native_high_fog_gpu_cases.json");let receipt_path=args.get(3).map(String::as_str).unwrap_or("logs/native-high-fog-arithmetic-gpu.json");
 let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=Backends::VULKAN;
 let instance=Instance::new(descriptor);let adapter=bevy_tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
 let(device,queue)=bevy_tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
 let code=std::fs::read_to_string(shader_path).unwrap();
 let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("production-high-fog-arithmetic"),source:ShaderSource::Wgsl(code.into())});
 let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
 let proof:serde_json::Value=serde_json::from_str(&std::fs::read_to_string(cases_path).unwrap()).unwrap();let cases=proof["cases"].as_array().unwrap();
 let bytes:Vec<u8>=cases.iter().flat_map(|c|c["inputs"].as_array().unwrap().iter().flat_map(|x|(x.as_f64().unwrap() as f32).to_le_bytes())).collect();let size=(cases.len()*32) as u64;
 let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
 let output=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
 let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:output.as_entire_binding()}]});
 let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor {label:None,timestamp_writes:None});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(cases.len() as u32,1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
 let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
 let mut maximum_error=0f32;for(i,c) in cases.iter().enumerate() {for channel in 0..8 {let error=(actual[i*8+channel]-c["expected"][channel].as_f64().unwrap() as f32).abs();assert!(error<=0.000002,"GPU case{i} channel{channel}: {error}");maximum_error=maximum_error.max(error);}}
 let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":cases.len(),"production_blend_paths":2,"channels_checked":actual.len(),"maximum_error":maximum_error,"tolerance":0.000002,"limits":proof["limits"]});
 std::fs::write(receipt_path,serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan high fog cases{} channels{} maximum error {maximum_error}",cases.len(),actual.len());
}
