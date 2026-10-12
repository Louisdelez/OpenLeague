use wgpu::*;
use std::sync::mpsc;
fn main() {
 let mut descriptor=InstanceDescriptor::new_without_display_handle();descriptor.backends=Backends::VULKAN;
 let instance=Instance::new(descriptor);
 let adapter=bevy::tasks::block_on(instance.request_adapter(&RequestAdapterOptions {power_preference:PowerPreference::HighPerformance,force_fallback_adapter:false,compatible_surface:None})).expect("Vulkan adapter");let info=adapter.get_info();
 let (device,queue)=bevy::tasks::block_on(adapter.request_device(&DeviceDescriptor {required_limits:Limits::downlevel_defaults(),..Default::default()})).unwrap();
 let production=include_str!("../../../assets/shaders/native_environment_fog.wgsl");
 let helper=production.split("// Native MOD2X_COLORMAP + DECAL + DISABLE_SHADOWS, no emissive handle.").nth(1).expect("actual production helper");
 let code=format!("{}{}",helper,r#"
 struct Input {diffuse:vec4<f32>,uv:vec4<f32>};
 @group(0) @binding(0) var colormap:texture_2d<f32>;
 @group(0) @binding(1) var linear_clamp:sampler;
 @group(0) @binding(2) var<storage,read> inputs:array<Input>;
 @group(0) @binding(3) var<storage,read_write> output:array<vec4<f32>>;
 @compute @workgroup_size(64) fn main(@builtin(global_invocation_id) id:vec3<u32>) {
  if id.x>=arrayLength(&inputs) {return;}
  let p=inputs[id.x];let light=textureSampleLevel(colormap,linear_clamp,p.uv.xy,0.0).rgb;
  output[id.x*2u]=native_decal_lighting(p.diffuse,light,4.0);
  output[id.x*2u+1u]=vec4<f32>(light,1.0);
 }
 "#);
 let module=device.create_shader_module(ShaderModuleDescriptor {label:Some("actual production DECAL lighting helper"),source:ShaderSource::Wgsl(code.into())});
 let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&module,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
 let texels:Vec<u8>=(0..16).flat_map(|i|[ ((i*37)%256) as u8,((i*59+13)%256) as u8,((i*71+29)%256) as u8,((i*19)%256) as u8]).collect();
 let texture=device.create_texture(&TextureDescriptor {label:None,size:Extent3d {width:4,height:4,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba8Unorm,usage:TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST,view_formats:&[]});
 queue.write_texture(TexelCopyTextureInfo {texture:&texture,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},&texels,TexelCopyBufferLayout {offset:0,bytes_per_row:Some(16),rows_per_image:Some(4)},Extent3d {width:4,height:4,depth_or_array_layers:1});
 let view=texture.create_view(&TextureViewDescriptor::default());let sampler=device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,mag_filter:FilterMode::Linear,min_filter:FilterMode::Linear,..Default::default()});
 let uvs=[-0.1,0.,0.125,0.25,0.5,0.75,0.875,1.,1.1];
 let diffuse=[[0.,0.,0.,0.],[0.25,0.5,0.75,0.2],[1.,1.,1.,0.7],[0.1,0.2,0.3,1.]];
 let mut cases=Vec::new();for y in uvs {for x in uvs {for d in diffuse {cases.push((x,y,d));}}}
 let bytes:Vec<u8>=cases.iter().flat_map(|(x,y,d)|d.iter().copied().chain([*x,*y,0.,0.])).flat_map(f32::to_le_bytes).collect();
 let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
 let size=cases.len() as u64*32;let output=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::MAP_READ|BufferUsages::COPY_DST,mapped_at_creation:false});
 let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:BindingResource::TextureView(&view)},BindGroupEntry {binding:1,resource:BindingResource::Sampler(&sampler)},BindGroupEntry {binding:2,resource:input.as_entire_binding()},BindGroupEntry {binding:3,resource:output.as_entire_binding()}]});
 let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor::default());pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups((cases.len() as u32).div_ceil(64),1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,size);queue.submit([encoder.finish()]);
 let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
 let mut maximum=0f32;let mut formula_error=0f32;let mut sampling_error=0f32;
 for (i,(u,v,d)) in cases.iter().enumerate() {
  let x=u*4.-0.5;let y=v*4.-0.5;let ix=x.floor() as i32;let iy=y.floor() as i32;let fx=x-x.floor();let fy=y-y.floor();
  for channel in 0..3 {
   let fetch=|xx:i32,yy:i32|texels[((yy.clamp(0,3)*4+xx.clamp(0,3))*4) as usize+channel] as f32/255.;
   let top=fetch(ix,iy)*(1.-fx)+fetch(ix+1,iy)*fx;let bottom=fetch(ix,iy+1)*(1.-fx)+fetch(ix+1,iy+1)*fx;
   let expected=(d[channel]*((top*(1.-fy)+bottom*fy)*4.)).clamp(0.,1.);
   let error=(actual[i*8+channel]-expected).abs();maximum=maximum.max(error);
   let sampled=actual[i*8+4+channel];sampling_error=sampling_error.max((sampled-(top*(1.-fy)+bottom*fy)).abs());
   let gpu_reference=(d[channel]*(sampled*4.)).clamp(0.,1.);
   let arithmetic_error=(actual[i*8+channel]-gpu_reference).abs();formula_error=formula_error.max(arithmetic_error);assert!(arithmetic_error<=0.000001,"actual sampled HLSL formula case{i} channel{channel} error{arithmetic_error}");
  }
  assert_eq!(actual[i*8+3].to_bits(),d[3].to_bits(),"native texture alpha preserved");
 }
 let receipt=serde_json::json!({"complete":false,"passed":true,"adapter":info.name,"backend":format!("{:?}",info.backend),"gpu_cases":cases.len(),"rgb_channels_checked":cases.len()*3,"alpha_channels_checked":cases.len(),"maximum_ideal_bilinear_final_color_error":maximum,"maximum_sampled_formula_error":formula_error,"maximum_sampling_error":sampling_error,"original_sampler_equivalence_qualified":false,"profile":"MOD2X_COLORMAP DECAL DISABLE_SHADOWS no-emissive","limits":["Actual Vulkan production helper checked against HLSL formula using independently read-back actual samples; authored alpha checked exactly. Not original D3D execution.","Initial strict ideal-bilinear comparison failed at0.000022888184. Actual sampler precision differences measured separately; native sampler equivalence remains unqualified.","Synthetic colormap/diffuse fixtures cover clamp edges and saturation; whole-scene vertex interpolation, original framebuffer and all shadow/emissive variants remain open."]});std::fs::write("logs/native-decal-colormap-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("GPU DECAL cases{} formula error{formula_error} sampling error{sampling_error} ideal color error{maximum}",cases.len());
}
