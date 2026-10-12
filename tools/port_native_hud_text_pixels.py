from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/font-raster/src/native_hud_text_draw.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub opacity:f32,pub owner_scale:f32,pub colors','pub opacity:f32,pub colors').replace('opacity:1.0,owner_scale:1.0,colors','opacity:1.0,colors').replace(';assert_eq!(d.owner_scale,1.0);',';')
assert 'pub fn pixel_rect' not in s
s+='''
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
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8')
s=s.replace('rect:[f32;4],alignment:u32,color:u32)->Result<TextGeometry,String>','rect:[f32;4],alignment:u32,color:u32,owner_scale:f32)->Result<TextGeometry,String>')
s=s.replace('owner_scale:draw.owner_scale','owner_scale')
s=s.replace('c["font_flags"].as_u64()==Some(flags as u64)','c["font_flags"].as_u64().unwrap()&4==(flags as u64)&4')
s=s.replace('alignment as u32,0xffa1b2c3).unwrap()','alignment as u32,0xffa1b2c3,1.0).unwrap()').replace('[0.0;4],0,0).is_err()','[0.0;4],0,0,1.0).is_err()')
s=s.replace('Caller owns pixel rectangle transforms, UTF16 content and widget lifecycle.','Caller owns pixel rectangle transforms, UTF16 content, owner draw scale and widget lifecycle.')
p.write_text(s,encoding='utf-8')
for name in ['qualify_native_hud_text_pixels.py','test_native_hud_text_bridge.py','port_native_hud_text_pixels.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Packet scale/conversion ported; source font flags compared by native shadow mask; owner draw scale remains explicit caller input.')
