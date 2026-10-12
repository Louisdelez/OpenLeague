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
    let code=format!("{}\n{}",include_str!("../../../assets/shaders/fow_shader_functions.wgsl"),r#"
struct Params {coordinates:vec4<f32>,height:vec4<f32>,edge:vec4<f32>,worlds:array<vec4<f32>,8>};
@group(0) @binding(0) var<uniform> p:Params;
@group(0) @binding(1) var<storage,read_write> output:array<vec4<f32>,11>;
@compute @workgroup_size(1) fn main() {
    output[0]=p.coordinates;output[1]=p.height;output[2]=p.edge;
    for(var i=0u;i<8u;i+=1u) {
        let w=p.worlds[i];let native=native_fow_coordinates(vec3<f32>(w.x,w.y*w.w,w.z),p.coordinates,p.height);
        output[i+3u]=vec4<f32>(native,1.0);
    }
}"#);
    let shader=device.create_shader_module(ShaderModuleDescriptor {label:Some("qualified-native-fow-uniforms"),source:ShaderSource::Wgsl(code.into())});
    let pipeline=device.create_compute_pipeline(&ComputePipelineDescriptor {label:None,layout:None,module:&shader,entry_point:Some("main"),compilation_options:Default::default(),cache:None});
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_shader_parameters_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    let mut rows=Vec::new();let mut maximum_error=0f32;
    for c in proof["cases"].as_array().unwrap() {
        let field=|key:&str|c[key].as_f64().unwrap() as f32;let extent=field("extent");let mut s=fow_settings::Settings::native_initial();s.fade_start=field("fade_start");s.fade_finish=field("fade_finish");s.edge_enhancement=field("edge_enhancement");s.one_over_tint_point=field("one_over_tint_point");let native=s.shader_parameters(extent).unwrap();
        let worlds=[[0.,0.,0.],[extent,0.25,extent],[extent/2.,0.5,extent/2.],[100.,0.75,200.],[100.,10.,200.],[100.,20.,200.],[100.,179.,200.],[100.,-114.,200.]];
        for units in [1f32,20f32] {
            let mut coords=native.coordinates;coords[0]*=units;coords[1]*=units;
            let positions:Vec<[f32;4]>=worlds.iter().map(|w|[w[0]/units,w[1]/units,w[2]/units,units]).collect();
            let bytes:Vec<u8>=coords.into_iter().chain(native.height).chain(native.edge).chain(positions.iter().flatten().copied()).flat_map(f32::to_le_bytes).collect();
            let uniform=device.create_buffer(&BufferDescriptor {label:None,size:bytes.len() as u64,usage:BufferUsages::UNIFORM|BufferUsages::COPY_DST,mapped_at_creation:false});queue.write_buffer(&uniform,0,&bytes);
            let output=device.create_buffer(&BufferDescriptor {label:None,size:176,usage:BufferUsages::STORAGE|BufferUsages::COPY_SRC,mapped_at_creation:false});let read=device.create_buffer(&BufferDescriptor {label:None,size:176,usage:BufferUsages::COPY_DST|BufferUsages::MAP_READ,mapped_at_creation:false});
            let group=device.create_bind_group(&BindGroupDescriptor {label:None,layout:&pipeline.get_bind_group_layout(0),entries:&[BindGroupEntry {binding:0,resource:uniform.as_entire_binding()},BindGroupEntry {binding:1,resource:output.as_entire_binding()}]});
            let mut encoder=device.create_command_encoder(&CommandEncoderDescriptor::default());{let mut pass=encoder.begin_compute_pass(&ComputePassDescriptor {label:None,timestamp_writes:None});pass.set_pipeline(&pipeline);pass.set_bind_group(0,&group,&[]);pass.dispatch_workgroups(1,1,1);}encoder.copy_buffer_to_buffer(&output,0,&read,0,176);queue.submit([encoder.finish()]);
            let(tx,rx)=mpsc::channel();read.slice(..).map_async(MapMode::Read,move|result|tx.send(result).unwrap());device.poll(PollType::wait_indefinitely()).unwrap();rx.recv().unwrap().unwrap();let data=read.slice(..).get_mapped_range();let bits:Vec<u32>=data.chunks_exact(4).map(|b|u32::from_le_bytes(b.try_into().unwrap())).collect();drop(data);read.unmap();
            let expected:Vec<u32>=coords.into_iter().chain(native.height).chain(native.edge).map(f32::to_bits).collect();assert_eq!(&bits[..12],expected.as_slice(),"GPU uniform transport {} units{units}",c["name"]);
            let mut error=0f32;
            for(i,w) in positions.iter().enumerate() {
                let expected=[w[0]*coords[0]+coords[2],w[2]*coords[1]+coords[3],((w[1]*units)*native.height[0]+native.height[1]).clamp(0.,1.)];
                for channel in 0..3 {error=error.max((f32::from_bits(bits[12+i*4+channel])-expected[channel]).abs());}
                assert_eq!(bits[12+i*4+3],1f32.to_bits());
            }
            assert!(error<=0.000001,"GPU coordinate/height error {error}");maximum_error=maximum_error.max(error);
            rows.push(serde_json::json!({"native_case":c["name"],"native_units_per_world_unit":units,"points":8,"maximum_coordinate_height_error":error,"uniform_bits_preserved":true,"gpu_uniform_bits":&bits[..12]}));
        }
    }
    let receipt=serde_json::json!({"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"cases":rows,"gpu_points":64,"maximum_coordinate_height_error":maximum_error,"tolerance":0.000001,"limits":["Actual Vulkan uniform transfer and shader coordinate/height arithmetic using the same function copied into production material shaders.","Explicit native and Bevy20-unit coordinate fixtures; no original D3D GPU or whole live geometry sampling/readback comparison.","Normal fade/blur/overlay consumers remain open; this is not complete fog rendering."]});
    std::fs::write("logs/fow-uniform-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan uniform cases8 points64 maximum error {maximum_error}");
}
