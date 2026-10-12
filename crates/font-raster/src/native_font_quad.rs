//! Literal native8BF370 glyph vertices; viewport conversion and rich text layout remain separate.
use crate::Error;
#[derive(Clone,Debug)]
pub struct Input {pub position:[f32;2],pub dimensions:[i32;2],pub font_scale:[f32;2],pub owner_scale:f32,pub opacity:f32,pub colors:[u32;2],pub atlas_uv:[f32;4],pub base_index:u32}
#[derive(Clone,Debug,PartialEq)]
pub struct Vertex {pub position:[f32;3],pub colors:[u32;2],pub atlas_uv:[f32;2],pub fill_uv:[f32;2]}
impl Vertex {
    /// Original D3D vertex order/stride36; explicit serialization avoids Rust padding.
    pub fn bytes(&self)->[u8;36] {
        let mut bytes=[0;36];let words=[self.position[0].to_bits(),self.position[1].to_bits(),self.position[2].to_bits(),self.colors[0],self.colors[1],self.atlas_uv[0].to_bits(),self.atlas_uv[1].to_bits(),self.fill_uv[0].to_bits(),self.fill_uv[1].to_bits()];
        for (chunk,word) in bytes.chunks_exact_mut(4).zip(words) {chunk.copy_from_slice(&word.to_le_bytes())}bytes
    }
}
#[derive(Clone,Debug,PartialEq)]
pub struct Quad {pub vertices:[Vertex;4],pub indices:[u16;6]}
pub fn build(input:&Input)->Result<Quad,Error> {
    // Unknown/nonfinite native arithmetic remains explicit instead of silently substituting.
    if input.position.iter().any(|v|!v.is_finite()||v.abs()>=8388608.) || input.font_scale.iter().any(|v|!v.is_finite()) || !input.owner_scale.is_finite() || !input.opacity.is_finite() || !(0.0..=1.0).contains(&input.opacity) || input.atlas_uv.iter().any(|v|!v.is_finite()) {return Err(Error("native quad input outside qualified finite domain".into()))}
    let [x,y]=input.position;let left=x.floor()-0.5;let top=y.floor()-0.5;
    // Each native MULSS/ADDSS is separate; do not contract these into fused multiply-add.
    let width=input.dimensions[0] as f32*input.font_scale[0];let width=width*input.owner_scale;let right=width+left;
    let height=input.dimensions[1] as f32*input.font_scale[1];let height=height*input.owner_scale;let bottom=height+top;
    if !right.is_finite()||!bottom.is_finite() {return Err(Error("native quad extent outside qualified finite domain".into()))}
    let colors=input.colors.map(|c|(c&0x00ffffff)|((((c>>24) as f32*input.opacity).trunc() as u32&255)<<24));
    let [u0,v0,u1,v1]=input.atlas_uv;
    let vertices=[(left,top,u0,v0,0.,0.),(right,top,u1,v0,1.,0.),(right,bottom,u1,v1,1.,1.),(left,bottom,u0,v1,0.,1.)].map(|(x,y,u,v,fu,fv)|Vertex {position:[x,y,0.],colors,atlas_uv:[u,v],fill_uv:[fu,fv]});
    Ok(Quad {vertices,indices:[0u32,1,2,0,2,3].map(|offset|input.base_index.wrapping_add(offset) as u16)})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn vertex_bytes_and_indices_match216_original_quad_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_quad_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],216);
        for c in p["cases"].as_array().unwrap() {
            let f=|key:&str,index:usize|c[key][index].as_f64().unwrap() as f32;
            let input=Input {position:[f("position",0),f("position",1)],dimensions:[c["dimensions"][0].as_i64().unwrap() as i32,c["dimensions"][1].as_i64().unwrap() as i32],font_scale:[f("scale",0),f("scale",1)],owner_scale:f("scale",2),opacity:c["opacity"].as_f64().unwrap() as f32,colors:[c["colors"][0].as_u64().unwrap() as u32,c["colors"][1].as_u64().unwrap() as u32],atlas_uv:[f("uv",0),f("uv",1),f("uv",2),f("uv",3)],base_index:c["base_index"].as_u64().unwrap() as u32};
            let quad=build(&input).unwrap();let actual=quad.vertices.iter().flat_map(Vertex::bytes).map(|b|format!("{b:02x}")).collect::<String>();assert_eq!(actual,c["vertex_bytes_hex"].as_str().unwrap());assert_eq!(quad.indices,c["indices"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u16).collect::<Vec<_>>().as_slice());
        }
    }
}

/// Native8BE3C0, preserving integer half-width/height truncation before float conversion.
/// Metric fields are named by their operation; their original producers remain separate.
pub fn align(position:[f32;2],dimensions:[i32;2],vertical_add:i32,vertical_subtract:i32,horizontal:u32,vertical:u32)->[f32;2] {
    let [x,y]=position;
    let x=match horizontal {0=>x,1=>x-(dimensions[0]/2) as f32,_=>x-dimensions[0] as f32};
    let y=match vertical {0=>y,1=>y+vertical_add as f32,2=>{let y=y+vertical_add as f32;y-(dimensions[1]/2) as f32},_=>y-vertical_subtract as f32};
    [x,y]
}
#[cfg(test)] mod alignment_tests {
    use super::*;
    #[test] fn text_origin_bits_match3072_original_alignment_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_alignment_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],3072);
        for c in p["cases"].as_array().unwrap() {
            let position=[c["position"][0].as_f64().unwrap() as f32,c["position"][1].as_f64().unwrap() as f32];let dimensions=[c["dimensions"][0].as_i64().unwrap() as i32,c["dimensions"][1].as_i64().unwrap() as i32];
            let actual=align(position,dimensions,c["font_vertical_add"].as_i64().unwrap() as i32,c["font_vertical_subtract"].as_i64().unwrap() as i32,c["horizontal"].as_u64().unwrap() as u32,c["vertical"].as_u64().unwrap() as u32).map(f32::to_bits);
            assert_eq!(actual,[c["output_bits"][0].as_u64().unwrap() as u32,c["output_bits"][1].as_u64().unwrap() as u32]);
        }
    }
}
