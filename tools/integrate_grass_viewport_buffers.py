from pathlib import Path
r=Path('E:/OpenLeague')
viewport='''//! Native2Dtarget viewport effects from988870/9889D0; surface handles remain external.
use crate::grass_screen_matrix;
pub struct State { pub dimensions: [u32;2], pub matrix: [f32;16] }
impl State {
    pub fn apply(&mut self, texture_present: bool, slot: u32, dimensions: [u32;2], api_flag: u32) -> Option<[f32;6]> {
        if !texture_present || slot != 0 { return None; }
        self.dimensions = dimensions;
        grass_screen_matrix::update(&mut self.matrix,dimensions,api_flag);
        Some([0.,0.,dimensions[0] as f32,dimensions[1] as f32,0.,1.])
    }
    /// Original restore obtains backbuffer dimensions, rather than a saved arbitrary target.
    pub fn restore(&mut self, texture_present: bool, saved_slot: u32, backbuffer: [u32;2], api_flag: u32) -> Option<[f32;6]> {
        self.apply(texture_present,saved_slot,backbuffer,api_flag)
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn viewport_state_matches_original_push_and_backbuffer_restore() {
        for (source,restore,count) in [(include_str!("../../../data/4.20/grass_target_viewport_contract.json"),false,180),(include_str!("../../../data/4.20/grass_restore_viewport_contract.json"),true,60)] {
            let p:serde_json::Value=serde_json::from_str(source).unwrap();assert_eq!(p["passed"],true);
            let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),count);
            for c in cases {
                let mut state=State { dimensions:[2000,1000],matrix:std::array::from_fn(|i|f32::from_bits(0x3e800000+i as u32)) };
                let sizes=&c[if restore {"backbuffer_size"} else {"size"}];let size=[sizes[0].as_u64().unwrap() as u32,sizes[1].as_u64().unwrap() as u32];
                let present=c["texture_present"].as_bool().unwrap();let slot=c[if restore {"saved_slot"} else {"slot"}].as_u64().unwrap() as u32;let flag=c["api_flag"].as_u64().unwrap() as u32;
                let viewport=if restore {state.restore(present,slot,size,flag)} else {state.apply(present,slot,size,flag)};
                let expected:[u32;16]=std::array::from_fn(|i|c["matrix_bits"][i].as_u64().unwrap() as u32);assert_eq!(state.matrix.map(f32::to_bits),expected);
                let dimensions:[u32;2]=std::array::from_fn(|i|c["renderer_dimensions"][i].as_u64().unwrap() as u32);assert_eq!(state.dimensions,dimensions);
                let api=c["events"].as_array().unwrap().iter().find_map(|event|event.get("device_viewport_bits"));
                assert_eq!(viewport.is_some(),api.is_some());
                if let (Some(actual),Some(api))=(viewport,api) {assert_eq!(actual,[api[0].as_u64().unwrap() as f32,api[1].as_u64().unwrap() as f32,api[2].as_u64().unwrap() as f32,api[3].as_u64().unwrap() as f32,f32::from_bits(api[4].as_u64().unwrap() as u32),f32::from_bits(api[5].as_u64().unwrap() as u32)]);}
            }
        }
    }
}
'''
buffers='''//! Native983040CPU buffer initializer,24byte vertices and16bit strip indices.
pub const VERTEX_WORDS: [u32;24]=[0,0,0,0xffffffff,0,0,0x3f800000,0,0,0xffffffff,0x3f800000,0,0,0x3f800000,0,0xffffffff,0,0x3f800000,0x3f800000,0x3f800000,0,0xffffffff,0x3f800000,0x3f800000];
pub const INDICES: [u16;4]=[0,1,2,3];
pub const STRIDE: u64=24;
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn gpu_buffer_data_matches_original_cpu_initializer() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_buffers_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["d3d_draw_primitive"],5);assert_eq!(p["vertex_stride"],STRIDE);
        for c in p["cases"].as_array().unwrap() {
            if c["disabled"]==true {continue;}
            if c["failure_adapter"]!=1 {let words:[u32;24]=std::array::from_fn(|i|c["vertex_words"][i].as_u64().unwrap() as u32);assert_eq!(VERTEX_WORDS,words);}
            if c["failure_adapter"]!=2 {let indices:[u16;4]=std::array::from_fn(|i|c["indices_u16"][i].as_u64().unwrap() as u16);assert_eq!(INDICES,indices);}
        }
    }
}
'''
for name,source in [('grass_target_viewport',viewport),('grass_buffers',buffers)]:
 p=r/f'crates/client/src/{name}.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8').replace('mod grass_screen_matrix;','mod grass_screen_matrix;\n#[allow(dead_code)]\nmod grass_target_viewport;\n#[allow(dead_code)]\nmod grass_buffers;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8');s='#[path="../src/grass_target_viewport.rs"] mod grass_target_viewport;\n#[path="../src/grass_buffers.rs"] mod grass_buffers;\n'+s
s=s.replace('    let mut quads = Vec::new();','''    let vertex_bytes:Vec<u8>=grass_buffers::VERTEX_WORDS.iter().flat_map(|v|v.to_le_bytes()).collect();
    let index_bytes:Vec<u8>=grass_buffers::INDICES.iter().flat_map(|v|v.to_le_bytes()).collect();
    let vertices=device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&vertex_bytes,usage:BufferUsages::VERTEX});
    let indices=device.create_buffer_init(&util::BufferInitDescriptor {label:None,contents:&index_bytes,usage:BufferUsages::INDEX});
    let mut viewport_state=grass_target_viewport::State {dimensions:[0,0],matrix:[0.;16]};
    let viewport=viewport_state.apply(true,0,[width,height],0).unwrap();
    let mut quads = Vec::new();''')
s=s.replace('buffers:&[],compilation_options:', 'buffers:&[VertexBufferLayout {array_stride:grass_buffers::STRIDE,step_mode:VertexStepMode::Vertex,attributes:&[VertexAttribute {format:VertexFormat::Float32x3,offset:0,shader_location:0},VertexAttribute {format:VertexFormat::Unorm8x4,offset:12,shader_location:1},VertexAttribute {format:VertexFormat::Float32x2,offset:16,shader_location:2}]}],compilation_options:')
s=s.replace('primitive:PrimitiveState::default(),','primitive:PrimitiveState {topology:PrimitiveTopology::TriangleStrip,strip_index_format:Some(IndexFormat::Uint16),..Default::default()},')
s=s.replace('let mut matrix = [0.;16]; grass_screen_matrix::update(&mut matrix,[width,height],0);','let matrix = viewport_state.matrix;')
s=s.replace('pass.set_pipeline(&pipeline); for binding in &bindings { pass.set_bind_group(0,binding,&[]); pass.draw(0..6,0..1); }','pass.set_pipeline(&pipeline); pass.set_viewport(viewport[0],viewport[1],viewport[2],viewport[3],viewport[4],viewport[5]); pass.set_vertex_buffer(0,vertices.slice(..)); pass.set_index_buffer(indices.slice(..),IndexFormat::Uint16); for binding in &bindings { pass.set_bind_group(0,binding,&[]); pass.draw_indexed(0..4,0,0..1); }')
s=s.replace('"native_screen_matrix_api":0,','"native_screen_matrix_api":0,"native_vertex_stride":grass_buffers::STRIDE,"native_quad_indices":grass_buffers::INDICES,"native_viewport_applied":true,')
s=s.replace('Later scene filter inheritance, API selection/clip bridge and vertex topology remain qualification adapters.','Native2D viewport helper and recovered24byte vertices/4index triangle strip shared. Later scene filter inheritance, API selection/clip bridge and declaration translation remain qualification adapters.')
p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_grass_mask.wgsl';s=p.read_text(encoding='utf-8')
a=s.index('@vertex fn vertex');b=s.index('@fragment fn fragment',a)
s=s[:a]+'''struct VertexInput { @location(0) position: vec3<f32>, @location(1) color: vec4<f32>, @location(2) uv: vec2<f32> }
@vertex fn vertex(input: VertexInput) -> VertexOutput {
    let position = input.position.xy * parameters.destination.zw + parameters.destination.xy;
    var result: VertexOutput;
    result.position = parameters.screen_matrix * vec4<f32>(position, input.position.z, 1.);
    result.uv = input.uv * parameters.source_uv.zw + parameters.source_uv.xy;
    return result;
}
'''+s[b:];p.write_text(s,encoding='utf-8')
print('Shared viewport and recovered indexed native quad installed.')
