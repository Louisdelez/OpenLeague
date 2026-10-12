use wgpu::*;
use std::sync::mpsc;
fn main() {
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/terrain_transform_contract.json")).unwrap();
 let bounds:Vec<f32>=proof["resource"]["authored_bounds"].as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect();let extent=bounds[3]-bounds[0];
 let terrain:[f32;4]=std::array::from_fn(|i|f32::from_bits(proof["cases"][0]["params_bits"][i].as_u64().unwrap() as u32));let fog=[1./extent,-1./extent,0.,1.];
 let production=include_str!("../../../assets/shaders/terrain_fow_vertex.wgsl");let env=include_str!("../../../assets/shaders/environment_fow_vertex.wgsl");
 let marker="// Native c230/c233 affine XZ mapping. Input recovered native world X/Z.";let helper=production.split(marker).nth(1).unwrap();assert_eq!(helper,env.split(marker).nth(1).unwrap());
 let code=format!("{}{}",helper,r#"
 struct Parameters {terrain:vec4<f32>,fog:vec4<f32>,root:vec4<f32>};
 @group(0) @binding(0) var<storage,read> input:array<vec4<f32>>;
 @group(0) @binding(1) var<uniform> params:Parameters;
 @group(0) @binding(2) var<storage,read_write> output:array<vec4<f32>>;
 @compute @workgroup_size(64) fn main(@builtin(global_invocation_id) id:vec3<u32>) {
  if id.x>=arrayLength(&input) {return;}
  let native_xz=vec2<f32>(input[id.x].x*params.root.x,params.root.y-input[id.x].y*params.root.x);
  output[id.x]=vec4<f32>(native_map_uv(native_xz,params.terrain),native_map_uv(native_xz,params.fog));
 }
 "#);
 let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=Backends::VULKAN;let instance=Instance::new(descriptor);let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions {power_preference:PowerPreference::HighPerformance,force_fallback_adapter:false,compatible_surface:None})).unwrap();let info=adapter.get_info();
 let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();let module=device.create_shader_module(ShaderModuleDescriptor {label:Some("production native c230/c233 UV helper"),source:ShaderSource::Wgsl(code.into())});let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&module,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
 let points=[-50.,0.,1.,500.,4009.24,7699.3359375,15360.,extent,16000.];let mut cases=Vec::new();let mut floats=Vec::new();
 for x in points {for z in points {cases.push([x,z]);let world=bevy::prelude::Transform::from_xyz(0.,0.,extent/20.).with_scale(bevy::prelude::Vec3::new(0.05,0.05,-0.05)).transform_point(bevy::prelude::Vec3::new(x,0.,z));floats.extend([world.x,world.z,x,z]);}}
 let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
 let parameters:Vec<u8>=terrain.into_iter().chain(fog).chain([20.,extent,0.,0.]).flat_map(f32::to_le_bytes).collect();let uniform=device.create_buffer(&BufferDescriptor {label:None,size:48,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&uniform,0,&parameters);
 let size=cases.len() as u64*16;let output=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::MAP_READ|BufferUsages::COPY_DST,mapped_at_creation:false});
 let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:uniform.as_entire_binding()},BindGroupEntry {binding:2,resource:output.as_entire_binding()}]});let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups((cases.len() as u32).div_ceil(64),1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
 let mut maximum=0f32;let mut prior_terrain_difference=0f32;
 for(i,[x,z]) in cases.iter().enumerate() {let expected=[x*terrain[0]+terrain[2],z*terrain[1]+terrain[3],x*fog[0]+fog[2],z*fog[1]+fog[3]];for c in 0..4 {let error=(actual[i*4+c]-expected[c]).abs();maximum=maximum.max(error);assert!(error<0.000001,"GPU map UV case{i} channel{c} error{error}");}prior_terrain_difference=prior_terrain_difference.max(((z-extent+15360.)*terrain[1]+terrain[3]-expected[1]).abs());}
 let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"gpu_cases":cases.len(),"uv_channels_checked":cases.len()*4,"maximum_uv_error":maximum,"prior_terrain_fixed_root_maximum_uv_difference":prior_terrain_difference,"extent":extent,"terrain_params":terrain,"fog_params":fog,"limits":["Actual Vulkan execution of production shared vertex helper and current Bevy root round-trip versus native c230/c233 expressions; native SCB extent and original constant bits used.","Point fixtures including corners and outside bounds; raster perspective interpolation, original D3D sampler/framebuffer, full animated geometry and gameplay visibility alignment remain open."]});std::fs::write("logs/native-map-texture-uv-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("GPU native map UV cases{} maximum error{maximum} previous terrain root difference{prior_terrain_difference}",cases.len());
}
