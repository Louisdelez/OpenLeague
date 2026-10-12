#[allow(dead_code)] #[path="../src/projected_surface.rs"] mod projected_surface;
use wgpu::*;
use bevy::prelude::{Vec2,Vec3};
fn main(){
 let mut desc=InstanceDescriptor::new_without_display_handle();desc.backends=if std::env::var("WGPU_BACKEND").as_deref()==Ok("dx12"){Backends::DX12}else{Backends::VULKAN};
 let instance=Instance::new(desc);let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions::default())).unwrap();let info=adapter.get_info();
 let(device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor::default())).unwrap();
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particle_projection_contract.json")).unwrap();
 let mut floats=Vec::<f32>::new();let mut expected=Vec::<[f64;2]>::new();let mut bounds=Vec::<[f64;2]>::new();
 for c in proof["cases"].as_array().unwrap(){
  let pair=|key:&str|Vec2::new(c[key][0].as_f64().unwrap() as f32,c[key][1].as_f64().unwrap() as f32);
  let center=pair("center_xz");let size=pair("half_size_xz");
  let Some(p)=projected_surface::TerrainProjection::new(center,size,c["angle_degrees"].as_f64().unwrap() as f32) else{continue};
  let m:Vec<f64>=c["uv_matrix_bits"].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32) as f64).collect();
  for offset in [Vec2::ZERO,Vec2::ONE,Vec2::new(-1.,1.),Vec2::new(3.,-2.)]{
   let xz=center+size*offset;let world=Vec3::new(xz.x,105.,xz.y)/20.;
   floats.extend(p.world_to_uv.to_cols_array());floats.extend([world.x,world.y,world.z,1.]);
   let n=[(world.x*20.) as f64,(world.y*20.) as f64,(world.z*20.) as f64,1.];
   let actual_matrix=p.world_to_uv.to_cols_array();
   bounds.push([0usize,2].map(|row|{let sum:f64=(0..4).map(|col|(m[col*4+row]*n[col]).abs()).sum();let matrix_delta:f64=(0..4).map(|col|((actual_matrix[col*4+row] as f64-m[col*4+row])*n[col]).abs()).sum();matrix_delta+8.*f32::EPSILON as f64*sum+f32::EPSILON as f64}));
   expected.push([0usize,2].map(|row|(0..4).map(|col|m[col*4+row]*n[col]).sum()));
  }
 }
 let production=include_str!("../../../assets/shaders/projected_vertex.wgsl");
 let expression=production.split("out.uv=").nth(2).unwrap().split(';').next().unwrap().replace("world_to_projection","inputs[i].matrix").replace("out.world_position.xyz","inputs[i].world.xyz");
 let code=format!("struct Input {{matrix:mat4x4<f32>,world:vec4<f32>}}; @group(0) @binding(0) var<storage,read> inputs:array<Input>; @group(0) @binding(1) var<storage,read_write> outputs:array<vec4<f32>>; @compute @workgroup_size(1) fn main(@builtin(global_invocation_id) id:vec3<u32>){{let i=id.x;outputs[i]=vec4<f32>({expression},0.0,1.0);}}");
 let shader=device.create_shader_module(ShaderModuleDescriptor{label:Some("exact-production-UV-expression"),source:ShaderSource::Wgsl(code.into())});
 let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor{label:None,layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
 let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();
 let input=device.create_buffer(&BufferDescriptor{label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
 let size=(expected.len()*16) as u64;
 let output=device.create_buffer(&BufferDescriptor{label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});
 let read=device.create_buffer(&BufferDescriptor{label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
 let group=device.create_bind_group(&BindGroupDescriptor{label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry{binding:0,resource:input.as_entire_binding()},BindGroupEntry{binding:1,resource:output.as_entire_binding()}]});
 let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(expected.len() as u32,1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
 let(tx,rx)=std::sync::mpsc::channel();read.slice(..).map_async(MapMode::Read,move|r|tx.send(r).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();
 let data=read.slice(..).get_mapped_range();let values:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();let mut max_error=0f64;
 for(i,e) in expected.iter().enumerate(){assert_eq!(values[i*4+3],1.);for ch in 0..2{let error=(values[i*4+ch] as f64-e[ch]).abs();assert!(error<=bounds[i][ch],"case{i} channel{ch} error{error} expected{} actual{}",e[ch],values[i*4+ch]);max_error=max_error.max(error);}}
 let receipt=serde_json::json!({"passed":true,"complete":false,"backend":format!("{:?}",info.backend),"adapter":info.name,"cases":expected.len(),"maximum_absolute_error":max_error,"acceptance_bound":"native-to-production matrix delta plus8*f32_epsilon*sum(abs(native matrix terms))+f32_epsilon; cancellation-aware numerical bound","limits":["Exact production UV expression in compute stage using production matrices versus native recorded matrices multiplied on CPU in f64.","Does not validate vertex-stage bindings, perspective interpolation, original D3D rasterization or full game."]});std::fs::write(format!("logs/projected-gpu-uv-{:?}.json",info.backend),serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("PASS {} cases {:?} max_error{}",expected.len(),info.backend,max_error);
}
