from pathlib import Path
import json,struct
r=Path('E:/OpenLeague')
s=Path('E:/mapslol3v3/audit_fow_height_interpolation.py').read_text(encoding='utf-8').replace('if len(rows)<8:','if True:').replace('fow_height_interpolation_audit.json','fow_height_interpolation_reference.json').replace('current fragment reconstruction','previous fragment reconstruction').replace('Transmit native clamped height factors through vertex outputs rather than recomputing clamp in fragment shaders. Actor base factors do not consume height.','Compare fixed vertex shader raster interpolation against these original vertex-clamp references.')
ns={};exec(compile(s,'actual triangle references','exec'),ns);assert len(ns['rows'])==2214
cases=[];f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
for row in ns['rows']:
 for units in [1.,20.]:cases.append({'kind':'actual_map_triangle','native_y':row['native_vertex_y'],'clear':[f32(-1e-6),-1.,0.,0.],'units':units,'expected':[0.,row['centroid_original_vertex_fade']]})
for heights in [[-1200.,-800.,-800.],[-1100.,-1000.,-900.],[-950.,-950.,-950.],[-2000.,-1900.,-1800.],[0.,100.,200.],[-900.0001,-899.9999,-950.]]:
 heights=list(map(f32,heights));expected=sum(max(0.,min(1.,y*f32(.01)+10.)) for y in heights)/3
 for units in [1.,20.]:cases.append({'kind':'explicit_height_fixture','native_y':heights,'clear':[f32(.01),10.,0.,0.],'units':units,'expected':[expected,expected]})
(r/'data/4.20/fow_height_raster_cases.json').write_text(json.dumps({'complete':False,'native_triangle_count':2214,'cases':cases,'limits':['Native and Bevy20-unit adaptation fixtures; raster target exercises original centroid vertex-clamp formula, not the original D3D renderer.']},indent=2)+'\n',encoding='utf-8')
template=(r/'crates/client/examples/fow_factor_probe.rs').read_text(encoding='utf-8');head=template[:template.index('    let code=format!')]
body=r'''    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_height_raster_cases.json")).unwrap();let cases=proof["cases"].as_array().unwrap();let width=32u32;let height=(cases.len() as u32).div_ceil(width);
    let code=format!("{}\n{}",include_str!("../../../assets/shaders/fow_vertex_height_functions.wgsl"),r#"
struct Input {heights:vec4<f32>,clear:vec4<f32>};
@group(0) @binding(0) var<storage,read> inputs:array<Input>;
@group(0) @binding(1) var<uniform> dimensions:vec4<f32>;
struct Out {@builtin(position) position:vec4<f32>,@location(0) fades:vec2<f32>};
@vertex fn vertex(@builtin(vertex_index) v:u32,@builtin(instance_index) i:u32)->Out {
 let p=inputs[i];let col=i%32u;let row=i/32u;
 let points=array<vec2<f32>,3>(vec2<f32>(-0.75,-0.75),vec2<f32>(0.75,-0.75),vec2<f32>(0.0,1.5));
 let center=vec2<f32>(2.0*(f32(col)+0.5)/dimensions.x-1.0,1.0-2.0*(f32(row)+0.5)/dimensions.y);
 var out:Out;out.position=vec4<f32>(center+points[v]/dimensions.xy,0.0,1.0);
 let transported_y=p.heights[v]/p.heights.w;
 out.fades=native_fow_vertex_height(transported_y*p.heights.w,p.clear,vec4<f32>(0.0,-1000.0,0.01,10.0));return out;
}
@fragment fn fragment(in:Out)->@location(0) vec4<f32> {return vec4<f32>(in.fades,1.0,1.0);}
"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("native-height-vertex-raster-interpolation"),source:ShaderSource::Wgsl(code.into())});
    let pipeline=device.create_render_pipeline(&RenderPipelineDescriptor {label:None,layout:None,vertex:VertexState {module:&shader,entry_point:Some("vertex"),buffers:&[],compilation_options:Default::default()},primitive:PrimitiveState::default(),depth_stencil:None,multisample:MultisampleState::default(),fragment:Some(FragmentState {module:&shader,entry_point:Some("fragment"),targets:&[Some(ColorTargetState {format:TextureFormat::Rgba32Float,blend:None,write_mask:ColorWrites::ALL})],compilation_options:Default::default()}),multiview_mask:None,cache:None});
    let mut floats=Vec::<f32>::new();for c in cases {floats.extend(c["native_y"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(c["units"].as_f64().unwrap() as f32);floats.extend(c["clear"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));}
    let bytes:Vec<u8>=floats.into_iter().flat_map(f32::to_le_bytes).collect();let input=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::STORAGE|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&input,0,&bytes);
    let uniform=device.create_buffer(&BufferDescriptor {label:None,size:16,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});let dimensions:Vec<u8>=[width as f32,height as f32,0.,0.].into_iter().flat_map(f32::to_le_bytes).collect();queue.write_buffer(&uniform,0,&dimensions);
    let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:input.as_entire_binding()},BindGroupEntry {binding:1,resource:uniform.as_entire_binding()}]});
    let target=device.create_texture(&TextureDescriptor {label:None,size:Extent3d {width,height,depth_or_array_layers:1},mip_level_count:1,sample_count:1,dimension:TextureDimension::D2,format:TextureFormat::Rgba32Float,usage:TextureUsages::RENDER_ATTACHMENT|TextureUsages::COPY_SRC,view_formats:&[]});let view=target.create_view(&TextureViewDescriptor::default());let size=(width*height*16) as u64;let read=device.create_buffer(&BufferDescriptor {label:None,size,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
    let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_render_pass(&RenderPassDescriptor {label:None,color_attachments:&[Some(RenderPassColorAttachment {view:&view,depth_slice:None,resolve_target:None,ops:Operations {load:LoadOp::Clear(Color::TRANSPARENT),store:StoreOp::Store}})],..Default::default()});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.draw(0..3,0..cases.len() as u32);}
    encoder.copy_texture_to_buffer(TexelCopyTextureInfo {texture:&target,mip_level:0,origin:Origin3d::ZERO,aspect:TextureAspect::All},TexelCopyBufferInfo {buffer:&read,layout:TexelCopyBufferLayout {offset:0,bytes_per_row:Some(width*16),rows_per_image:Some(height)}},Extent3d {width,height,depth_or_array_layers:1});queue.submit([encoder.finish()]);
    let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let actual:Vec<f32>=data.chunks_exact(4).map(|b|f32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
    let mut maximum_error=0f32;for(i,c) in cases.iter().enumerate() {assert_eq!(&actual[i*4+2..i*4+4],&[1.,1.],"raster coverage case{i}");for channel in 0..2 {let error=(actual[i*4+channel]-c["expected"][channel].as_f64().unwrap() as f32).abs();assert!(error<=0.00001,"raster interpolation case{i} channel{channel}: {error}, observed{} expected{}",actual[i*4+channel],c["expected"][channel]);maximum_error=maximum_error.max(error);}}
    let receipt=serde_json::json!({"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"rasterized_cases":cases.len(),"actual_map_triangles":proof["native_triangle_count"],"native_unit_profiles":[1,20],"fixture_cases":12,"height_channels_checked":cases.len()*2,"maximum_error":maximum_error,"tolerance":0.00001,"target_format":"Rgba32Float","limits":["Actual vertex/fragment raster interpolation with identical production native height helper; orthographic centroid fixtures from actual map triangles.","Original D3D, whole live geometry/morph/pose equivalence, perspective cases and final color framebuffer attribution remain open."]});std::fs::write("logs/fow-height-raster-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan height raster cases{} actual triangles2214 maximum error{maximum_error}",cases.len());
}
'''
(r/'crates/client/examples/fow_height_raster_probe.rs').write_text(head+body,encoding='utf-8');print('Raster cases',len(cases))
