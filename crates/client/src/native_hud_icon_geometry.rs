//! Native Icon UV selection9A4F30 and quad emission99E8D0.
//! Buffer ownership, draw states and matrices remain separate.
pub fn uv(first:[f32;4],second:[f32;4],blend:f32,flags:u32,fraction:f32)->[f32;4] {
    let mut result=std::array::from_fn(|n|(second[n]-first[n])*blend+first[n]);
    if flags&0x40!=0 {result[2]=(result[2]-result[0])*fraction+result[0];}
    result
}
#[derive(Debug,PartialEq)]
pub struct Quad {pub vertices:[u8;96],pub indices:[u16;6],pub next_index:u32}
pub fn emit(rect:[f32;4],uv:[f32;4],color:u32,base_index:u32,vertex_buffer_present:bool,index_buffer_present:bool)->Option<Quad> {
    if !vertex_buffer_present || !index_buffer_present {return None;}
    let mut vertices=[0;96];
    for (n,(x,y)) in [(0,1),(2,1),(0,3),(2,3)].into_iter().enumerate() {
        let fields=[rect[x].to_bits(),rect[y].to_bits(),0,color,uv[x].to_bits(),uv[y].to_bits()];
        for (k,value) in fields.into_iter().enumerate() {vertices[n*24+k*4..n*24+k*4+4].copy_from_slice(&value.to_le_bytes());}
    }
    let base=base_index as u16;
    Some(Quad {vertices,indices:[0,2,1,1,2,3].map(|n|base.wrapping_add(n)),next_index:base_index.wrapping_add(4)})
}
#[cfg(test)] mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/native_hud_icon_geometry_contract.json")).unwrap()}
    fn quad(c:&serde_json::Value,key:&str)->[f32;4] {std::array::from_fn(|n|f32::from_bits(c[key][n].as_u64().unwrap() as u32))}
    fn hex(s:&str)->Vec<u8> {s.as_bytes().chunks_exact(2).map(|p|u8::from_str_radix(std::str::from_utf8(p).unwrap(),16).unwrap()).collect()}
    #[test] fn original_icon_uv_lerp_fraction_and_unused_argument_match_native_sse() {
        let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["uv_case_count"],576);
        for c in p["uv_cases"].as_array().unwrap() {
            let out=uv(quad(c,"first_bits"),quad(c,"second_bits"),f32::from_bits(c["blend_bits"].as_u64().unwrap() as u32),c["flags"].as_u64().unwrap() as u32,f32::from_bits(c["fraction_bits"].as_u64().unwrap() as u32));
            assert_eq!(out.map(f32::to_bits),std::array::from_fn(|n|c["output_bits"][n].as_u64().unwrap() as u32));
        }
    }
    #[test] fn original_icon_quad_bytes_null_guards_and_unsigned_index_wrap_match_native() {
        let p=proof();assert_eq!(p["quad_case_count"],720);
        for c in p["quad_cases"].as_array().unwrap() {
            let missing=c["missing"].as_str().unwrap();let result=emit(quad(c,"rect_bits"),quad(c,"uv_bits"),c["color"].as_u64().unwrap() as u32,c["base_index"].as_u64().unwrap() as u32,missing!="vertex",missing!="index");
            if missing!="none" {assert!(result.is_none());continue;}
            let result=result.unwrap();assert_eq!(result.vertices.to_vec(),hex(c["vertices_hex"].as_str().unwrap()));
            assert_eq!(result.indices.into_iter().flat_map(u16::to_le_bytes).collect::<Vec<_>>(),hex(c["indices_hex"].as_str().unwrap()));assert_eq!(result.next_index,c["next_index"].as_u64().unwrap() as u32);
        }
    }
}
