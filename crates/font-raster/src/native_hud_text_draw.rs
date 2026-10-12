//! Original 4.20 HUD Text draw wrapper 9A5CF0; rectangle supplied in pixels.
//! Batch/group transforms, UTF16 conversion and framebuffer projection are separate.
use crate::Error;
#[derive(Clone,Debug)]
pub struct Draw {pub position:[f32;2],pub horizontal:u32,pub vertical:u32,pub font_scale:[f32;2],pub opacity:f32,pub colors:[u32;2]}
fn anchor(value:f64)->Result<i32,Error> {
    if !value.is_finite() || value.trunc()<i32::MIN as f64 || value.trunc()>i32::MAX as f64 {return Err(Error("HUD text anchor outside qualified signed32 range".into()))}
    Ok(value.trunc() as i32)
}
pub fn draw(rect:[f32;4],horizontal:u32,font_flags:u32,color:u32)->Result<Draw,Error> {
    if rect.iter().any(|v|!v.is_finite()) {return Err(Error("HUD text rectangle nonfinite".into()))}
    let x=match horizontal {0=>anchor(rect[0] as f64)?,1=>anchor((rect[0] as f64+rect[2] as f64)*0.5)?,2=>anchor(rect[2] as f64)?,_=>0};
    let y=anchor((rect[1] as f64+rect[3] as f64)*0.5)?;
    let offset=if font_flags&4!=0 {8}else{0};
    // Native retains low signed32 anchor, then converts as unsigned32 to f32.
    let position=[x.wrapping_sub(offset) as u32 as f32,y.wrapping_sub(offset) as u32 as f32];
    Ok(Draw {position,horizontal,vertical:0,font_scale:[1.0,1.0],opacity:1.0,colors:[color,0]})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn arguments_match1350_original_hud_text_draws() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_draw_contract.json")).unwrap();
        assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1350);
        for c in p["cases"].as_array().unwrap() {
            let rect=std::array::from_fn(|i|c["rect"][i].as_f64().unwrap() as f32);
            let d=draw(rect,c["alignment"].as_u64().unwrap() as u32,c["font_flags"].as_u64().unwrap() as u32,c["color"].as_u64().unwrap() as u32).unwrap();
            let actual=[d.opacity.to_bits(),d.position[0].to_bits(),d.position[1].to_bits(),d.colors[0],d.colors[1],0,0,d.horizontal,d.vertical,d.font_scale[0].to_bits(),d.font_scale[1].to_bits(),0];
            let expected:Vec<u32>=c["draw_argument_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            assert_eq!(actual.as_slice(),expected.as_slice(),"{c}");
        }
    }
    #[test] fn unqualified_coordinates_are_explicit_errors() {
        for rect in [[f32::NAN,0.0,0.0,0.0],[0.0,0.0,f32::INFINITY,0.0],[0.0,1e30,0.0,1e30],[1e30,0.0,1e30,0.0]] {assert!(draw(rect,0,0,0).is_err())}
    }
}

/// Original99FA40 normalized-to-pixel packet stage; source owner state supplied.
pub fn pixel_rect(rect:[f32;4],viewport:[u32;2],owner_scalar:f32,fixed_scale:bool)->Result<([f32;4],f32),Error> {
    if rect.iter().any(|v|!v.is_finite()) || !owner_scalar.is_finite() || viewport.iter().any(|v|*v==0 || *v>32768) {return Err(Error("unqualified HUD text packet input".into()))}
    let scale=if fixed_scale {f32::from_bits(1066611507)}else {((owner_scalar*f32::from_bits(1063164884))*f32::from_bits(1059481190))+0.5};
    if !scale.is_finite() || scale<=0.0 {return Err(Error("unqualified HUD text scale".into()))}
    let reciprocal=1.0/scale;let pixels=std::array::from_fn(|i|((rect[i]*reciprocal)*(viewport[i%2] as f32)).floor());
    if pixels.iter().any(|v|!v.is_finite() || v.abs()>8388608.0) {return Err(Error("HUD pixel rectangle outside qualified rounding range".into()))}
    Ok((pixels,scale))
}
#[cfg(test)] mod pixel_tests {
    use super::*;
    #[test] fn pixel_rectangles_and_scales_match270_original_packet_draws() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_pixels_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],270);
        for c in p["cases"].as_array().unwrap() {
            let rect=std::array::from_fn(|i|c["normalized_rect"][i].as_f64().unwrap() as f32);
            let (actual,scale)=pixel_rect(rect,[c["width"].as_u64().unwrap() as u32,c["height"].as_u64().unwrap() as u32],c["owner_scalar"].as_f64().unwrap() as f32,c["fixed_scale"].as_bool().unwrap()).unwrap();
            let expected:Vec<u32>=c["pixel_rect_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual.map(f32::to_bits).as_slice(),expected.as_slice());assert_eq!(scale.to_bits(),c["scale_bits"].as_u64().unwrap() as u32);
        }
        assert!(pixel_rect([0.0;4],[0,768],0.0,false).is_err());assert!(pixel_rect([0.0;4],[1024,768],-100.0,false).is_err());
    }
}
