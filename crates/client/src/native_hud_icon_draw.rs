//! Native99F710 Icon draw guard and shader selection.
//! GPU state setup99F3A0, shader compilation and framebuffer remain separate.
#[derive(Clone,Copy,Debug,PartialEq)] pub enum PixelShader {Alpha,Opaque,Clear,Blit}
#[derive(Clone,Copy,Debug,PartialEq)] pub struct Route {pub bind_texture:bool,pub shader:PixelShader}
pub fn route(primitives:u32,texture_present:bool,texture_ready:bool,packet_flags:u32,mode:u32)->Option<Route> {
    if primitives==0 || texture_present && !texture_ready {return None;}
    Some(Route {bind_texture:texture_present,shader:if packet_flags&4!=0 {PixelShader::Blit}else if texture_present {if mode&1!=0 {PixelShader::Alpha}else {PixelShader::Opaque}}else {PixelShader::Clear}})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_icon_draw_guards_and_shader_branches_match_original_packets() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_icon_draw_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],128);
        for c in proof["cases"].as_array().unwrap() {
            let route=route(c["primitives"].as_u64().unwrap() as u32,c["texture_present"].as_bool().unwrap(),c["texture_ready"].as_bool().unwrap(),c["packet_flags"].as_u64().unwrap() as u32,c["mode"].as_u64().unwrap() as u32);
            let calls=c["calls"].as_array().unwrap();if calls.is_empty() {assert_eq!(route,None);continue;}
            let route=route.unwrap();assert_eq!(route.bind_texture,calls.iter().any(|v|v["kind"]=="texture_boundary"));
            let selected=calls.iter().find(|v|v["kind"]=="0x90").unwrap()["args"][0].as_u64().unwrap();assert_eq!(selected,match route.shader {PixelShader::Alpha=>201,PixelShader::Opaque=>202,PixelShader::Clear=>203,PixelShader::Blit=>204});
        }
    }
}
