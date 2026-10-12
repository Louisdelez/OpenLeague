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
    let code=format!("{}\n{}",include_str!("../../../assets/shaders/fow_factor_functions.wgsl"),r#"
struct Input {overlay:vec4<f32>,values:vec4<f32>};
@group(0) @binding(0) var<storage,read> inputs:array<Input>;
@group(0) @binding(1) var<storage,read_write> output:array<vec4<f32>>;
@compute @workgroup_size(1) fn main(@builtin(global_invocation_id) i:vec3<u32>) {
 let p=inputs[i.x];output[i.x]=native_fow_factors(p.overlay,p.values.x,p.values.y,u32(p.values.z),vec4<f32>(50.0,-49.0,p.values.w,0.0));
}"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native-fow-factor-modes"),source:ShaderSource::Wgsl(code.into())});
    let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_factor_shader_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),144);
    let mut floats=Vec::<f32>::new();
    for c in cases {floats.extend(c["overlay"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));for k in ["visibility","height","mode","tint_reciprocal"] {floats.push(c[k].as_f64().unwrap() as f32);}}
    let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();let size=(cases.len()*16) as u64;
    let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
    let output=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:output.as_entire_binding()}]});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor {label:None,timestamp_writes:None});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(cases.len() as u32,1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
    let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
    let mut maximum_error=0f32;for(i,c) in cases.iter().enumerate() {for channel in 0..4 {let error=(actual[i*4+channel]-c["expected"][channel].as_f64().unwrap() as f32).abs();assert!(error<=0.000001,"GPU case{i} channel{channel}: {error}");maximum_error=maximum_error.max(error);}}
    let receipt=serde_json::json!({"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":cases.len(),"channels_checked":actual.len(),"maximum_error":maximum_error,"tolerance":0.000001,"limits":["Actual Vulkan execution of literal production factor helper against independent rational HLSL reference; no original D3D comparison.","Texture sampling, material branch selection, c250 and animated overlay variants are separate contracts."]});
    std::fs::write("logs/fow-factor-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan factor cases144 channels576 maximum error {maximum_error}");
}
