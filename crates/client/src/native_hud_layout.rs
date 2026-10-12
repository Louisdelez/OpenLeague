//! Native9A4B30 normalized HUD rectangle transformation.
//! Supplied element/owner fields; constructors/settings, structural parsing and drawing remain separate.
pub struct Input {
    pub flags:u32,pub width:u32,pub height:u32,pub owner_scalar:f32,
    pub rect:[f32;4],pub anchors:[f32;4],pub motion_offset:[f32;2],pub include_motion:bool,
    pub group_offset:Option<[f32;2]>,pub fractions:[f32;2],pub aspect:f32,
}
pub fn transform(input:&Input)->Result<[f32;4],&'static str> {
    if input.width==0 || input.height==0 || input.width>32768 || input.height>32768 {return Err("unqualified HUD viewport dimensions");}
    if !input.rect.iter().chain(&input.anchors).chain(&input.motion_offset).chain(&input.fractions).all(|v|v.is_finite()) || !input.owner_scalar.is_finite() || !input.aspect.is_finite() || input.group_offset.is_some_and(|v|v.iter().any(|v|!v.is_finite())) {return Err("unqualified nonfinite HUD state");}
    let mut v=input.rect;let a=input.anchors;
    if input.include_motion {for k in 0..4 {v[k]+=input.motion_offset[k%2];}}
    if input.flags&0x22==0 {
        let scale=if input.flags&0x80!=0 {1.0}else {input.owner_scalar*0.5+0.5};
        for k in 0..4 {v[k]=(v[k]-a[k])*scale+a[k];}
    }
    if input.include_motion {if let Some(offset)=input.group_offset {for k in 0..4 {v[k]+=offset[k%2];}}}
    v[2]=(v[2]-v[0])*input.fractions[0]+v[0];v[3]=(v[3]-v[1])*input.fractions[1]+v[1];
    let w=input.width as f32;let h=input.height as f32;
    if input.flags&0x20==0 {
        let t=(h*f32::from_bits(0x3aaaaaab))*input.aspect;
        let sx=((t as f64*1024.0)/input.width as f64) as f32;
        let sy=(t*768.0)/h;
        for k in 0..4 {v[k]=(v[k]-a[k])*if k%2==0 {sx}else{sy}+a[k];}
    }
    if !v.iter().all(|v|v.is_finite()) {return Err("unqualified HUD arithmetic overflow");}
    if input.flags&0x1000==0 {v[0]=(w*v[0]).floor()/w;v[2]=((input.width as f64*v[2] as f64).ceil()/w as f64) as f32;}
    v[1]=(h*v[1]).floor()/h;v[3]=((input.height as f64*v[3] as f64).ceil()/h as f64) as f32;
    Ok(v)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn normalized_rectangles_match_every_native_scale_anchor_aspect_and_snap_case() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_layout_math_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
        for c in p["cases"].as_array().unwrap() {
            let values=|key:&str|c[key].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect::<Vec<_>>();
            let pair=|key:&str|{let v=values(key);[v[0],v[1]]};let quad=|key:&str|{let v=values(key);[v[0],v[1],v[2],v[3]]};
            let input=Input {flags:c["flags"].as_u64().unwrap() as u32,width:c["width"].as_u64().unwrap() as u32,height:c["height"].as_u64().unwrap() as u32,owner_scalar:f32::from_bits(c["owner_scalar_bits"].as_u64().unwrap() as u32),rect:quad("rect_bits"),anchors:quad("anchor_bits"),motion_offset:pair("offset_bits"),include_motion:c["include_motion"].as_bool().unwrap(),group_offset:if c["parent_offset_bits"].is_null() {None}else {Some(pair("parent_offset_bits"))},fractions:pair("fractions_bits"),aspect:f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32)};
            assert_eq!(transform(&input).unwrap().map(f32::to_bits).to_vec(),c["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>(),"flags{} size{}x{}",input.flags,input.width,input.height);
        }
    }
}
