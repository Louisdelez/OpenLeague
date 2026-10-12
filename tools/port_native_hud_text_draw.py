from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
module=r/'crates/font-raster/src/native_hud_text_draw.rs'
assert not module.exists(), 'Preserve existing work: module already exists'
module.write_text('''//! Original 4.20 HUD Text draw wrapper 9A5CF0; rectangle supplied in pixels.
//! Batch/group transforms, UTF16 conversion and framebuffer projection are separate.
use crate::Error;
#[derive(Clone,Debug)]
pub struct Draw {pub position:[f32;2],pub horizontal:u32,pub vertical:u32,pub font_scale:[f32;2],pub opacity:f32,pub owner_scale:f32,pub colors:[u32;2]}
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
    Ok(Draw {position,horizontal,vertical:0,font_scale:[1.0,1.0],opacity:1.0,owner_scale:1.0,colors:[color,0]})
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
            assert_eq!(actual.as_slice(),expected.as_slice(),"{c}");assert_eq!(d.owner_scale,1.0);
        }
    }
    #[test] fn unqualified_coordinates_are_explicit_errors() {
        for rect in [[f32::NAN,0.0,0.0,0.0],[0.0,0.0,f32::INFINITY,0.0],[0.0,1e30,0.0,1e30],[1e30,0.0,1e30,0.0]] {assert!(draw(rect,0,0,0).is_err())}
    }
}
''',encoding='utf-8')
lib=r/'crates/font-raster/src/lib.rs';s=lib.read_text(encoding='utf-8');s+='\npub mod native_hud_text_draw;\n';lib.write_text(s,encoding='utf-8')
client=r/'crates/client/src/native_font_metrics.rs';s=client.read_text(encoding='utf-8');marker='impl Faces {\n';assert s.count(marker)==1
bridge='''    /// Original HUD wrapper parameters -> source face -> native glyph geometry.
    /// Caller owns pixel rectangle transforms, UTF16 content and widget lifecycle.
    pub fn hud_text_geometry(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,contents:&[u16],rect:[f32;4],alignment:u32,color:u32)->Result<TextGeometry,String> {
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let flags=sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor.flags;
        let draw=openleague_font_raster::native_hud_text_draw::draw(rect,alignment,flags,color).map_err(|e|e.to_string())?;
        let args=TextGeometryArgs {position:draw.position,horizontal:draw.horizontal,vertical:draw.vertical,font_scale:draw.font_scale,owner_scale:draw.owner_scale,opacity:draw.opacity,colors:draw.colors};
        self.text_geometry(sizes,text,contents,&args)
    }

'''
s=s.replace(marker,marker+bridge);client.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_native_hud_text_draw.py'),r/'tools/qualify_native_hud_text_draw.py')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native HUD text wrapper ported; full widget dispatch remains open.')
