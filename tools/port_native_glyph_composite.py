from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/font-raster/src/native_glyph.rs';s=p.read_text()
if 'pub struct Target<' not in s:
 s+='''
/// Original8C22C0 clipped coverage composition; color application is a separate path.
pub struct Target<'a> {pub pixels:&'a mut [u8],pub width:u32,pub height:u32,pub channels:u32,pub stride_bytes:usize}
pub fn compose(glyph:&NativeGlyph,target:&mut Target<'_>,x:i32,y:i32)->Result<(),Error> {
    let bitmap=&glyph.bitmap;let width=bitmap.width as usize;let rows=bitmap.rows as usize;
    if bitmap.coverage.len()!=width.checked_mul(rows).ok_or_else(||Error("glyph coverage overflow".into()))? {return Err(Error("glyph coverage length mismatch".into()))}
    if target.width>i32::MAX as u32 || target.height>i32::MAX as u32 || target.channels>i32::MAX as u32 || bitmap.width>i32::MAX as u32 || bitmap.rows>i32::MAX as u32 {return Err(Error("glyph composition dimensions exceed qualified signed range".into()))}
    let row_width=(target.width as usize).checked_mul(target.channels as usize).ok_or_else(||Error("glyph target row overflow".into()))?;
    let extent=(target.height as usize).checked_mul(target.stride_bytes).ok_or_else(||Error("glyph target extent overflow".into()))?;
    if target.stride_bytes<row_width || target.pixels.len()<extent {return Err(Error("glyph target bounds unavailable".into()))}
    if target.channels==0 {return Ok(())}
    let top=(bitmap.ascender_26_6>>6).wrapping_sub(bitmap.bearing_y_26_6>>6).wrapping_add(y);
    let left=glyph.metrics.bearing_x.wrapping_add(x);
    for row in 0..rows {
        let dy=top.wrapping_add(row as i32);if dy<0 || dy>=target.height as i32 {continue}
        for col in 0..width {
            let dx=left.wrapping_add(col as i32);if dx<0 || dx>=target.width as i32 {continue}
            let coverage=bitmap.coverage[row*width+col] as u32;
            let offset=(dy as usize)*target.stride_bytes+(dx as usize)*(target.channels as usize);
            for channel in 0..target.channels as usize {
                let old=target.pixels[offset+channel] as u32;
                target.pixels[offset+channel]=(coverage+old*(255-coverage)/255).min(255) as u8;
            }
        }
    }
    Ok(())
}
pub fn kerning_pixels(x_26_6:i32)->i32 {x_26_6>>6}
#[cfg(test)] mod composition_tests {
    use super::*;
    #[test] fn clipping_and_composition_match_1350_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_glyph_composite_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1350);
        for c in p["cases"].as_array().unwrap() {
            let glyph=NativeGlyph {character_utf16:65,index:34,metrics:NativeMetrics {advance:4,bearing_x:c["bearing_x_pixels"].as_i64().unwrap() as i32,width:3,bottom:2},bitmap:Bitmap {width:3,rows:2,ascender_26_6:c["ascender_26_6"].as_i64().unwrap() as i32,bearing_y_26_6:c["bearing_y_26_6"].as_i64().unwrap() as i32,coverage:vec![0,1,64,128,254,255]}};
            let stride=c["destination_stride_bytes"].as_u64().unwrap() as usize;let mut pixels=vec![c["fill"].as_u64().unwrap() as u8;stride*3];
            compose(&glyph,&mut Target {pixels:&mut pixels,width:4,height:3,channels:c["channels"].as_u64().unwrap() as u32,stride_bytes:stride},c["x"].as_i64().unwrap() as i32,c["y"].as_i64().unwrap() as i32).unwrap();
            let hex=c["destination_hex"].as_str().unwrap();let expected=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();assert_eq!(pixels,expected);
        }
    }
    #[test] fn invalid_target_has_no_partial_writes() {
        let glyph=NativeGlyph {character_utf16:65,index:34,metrics:metrics(64,0,64,64,64,64),bitmap:Bitmap {width:1,rows:1,ascender_26_6:64,bearing_y_26_6:64,coverage:vec![128]}};
        let mut pixels=vec![85;8];assert!(compose(&glyph,&mut Target {pixels:&mut pixels,width:3,height:1,channels:4,stride_bytes:8},0,0).is_err());assert_eq!(pixels,vec![85;8]);
    }
    #[test] fn kerning_mode0_and_shift_match_128_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_glyph_kerning_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],128);
        for c in p["cases"].as_array().unwrap() {assert_eq!(c["calls"][0]["mode"],0);assert_eq!(kerning_pixels(c["kerning_x_26_6"].as_i64().unwrap() as i32),c["pixels"].as_i64().unwrap() as i32);}
    }
}
'''
p.write_text(s)
bridge=r/'crates/font-raster/bridge.c';s=bridge.read_text()
if 'int ol_ft_native_kerning(' not in s:
 s+='''
int ol_ft_native_kerning(void *opaque,uint32_t left,uint32_t right,int32_t *out) {
    FT_Vector delta;int error=FT_Get_Kerning((FT_Face)opaque,left,right,0,&delta);if(error) return error;
    *out=(int32_t)delta.x;return 0;
}
'''
bridge.write_text(s)
lib=r/'crates/font-raster/src/lib.rs';s=lib.read_text()
if 'fn ol_ft_native_kerning(' not in s:s=s.replace('extern "C" {','extern "C" {\n    fn ol_ft_native_kerning(face:*mut c_void,left:u32,right:u32,out:*mut i32)->i32;',1)
if 'pub fn native_kerning(' not in s:s=s.replace('    pub fn version(&self)', '''    pub fn native_kerning(&mut self,left_index:u32,right_index:u32)->Result<i32,Error> {
        let mut delta=0;unsafe {checked(ol_ft_native_kerning(self.face.as_ptr(),left_index,right_index,&mut delta))?;}
        Ok(native_glyph::kerning_pixels(delta))
    }
    pub fn version(&self)''',1)
if 'actual_source_faces_support_native_kerning_mode0' not in s:
 s+='''
#[cfg(test)] mod source_kerning_tests {
    use super::*;
    #[test] fn actual_source_faces_support_native_kerning_mode0() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        for file in ["GillSansMTPro-Medium.otf","GillSansMTProCyr-Medium.otf","GillSansMTProGrk-Medium.otf","ARIALUNI.TTF","UttumDotum.ttf"] {
            let mut face=Face::new(std::fs::read(root.join("assets/fonts/native4.20").join(file)).unwrap()).unwrap();face.fit(17,0x10,96,96,10000).unwrap();
            let a=face.native_glyph(65).unwrap();let v=face.native_glyph(86).unwrap();
            let pair=face.native_kerning(a.index,v.index).unwrap();let repeated=face.native_kerning(a.index,v.index).unwrap();assert_eq!(pair,repeated);
            assert!(pair.unsigned_abs()<17); // Actual source-face probe, not native original pair-value comparison.
        }
    }
}
'''
lib.write_text(s)
print('Native composition1350 and kerning128 ported, source-face API integrated')
