//! Original 8C2030 metrics and 8C2140 grayscale-to-RGBA copy.
//! Allocation, GPU packing, other bitmap paths and error behavior remain separate.
use crate::Error;
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct NativeMetrics {pub advance:i32,pub bearing_x:i32,pub width:i32,pub bottom:i32}
pub fn metrics(advance:i32,bearing_x:i32,width:i32,bearing_y:i32,height:i32,ascender:i32)->NativeMetrics {
    NativeMetrics {advance:advance>>6,bearing_x:bearing_x>>6,width:width>>6,bottom:(ascender>>6).wrapping_sub(bearing_y>>6).wrapping_add(height>>6)}
}
#[derive(Clone,Debug)]
pub struct Bitmap {pub width:u32,pub rows:u32,pub bearing_y_26_6:i32,pub ascender_26_6:i32,pub coverage:Vec<u8>}
#[derive(Clone,Debug)]
pub struct NativeGlyph {pub character_utf16:u16,pub index:u32,pub metrics:NativeMetrics,pub bitmap:Bitmap}
/// Normalize the row order without changing coverage; original supports signed pitch.
pub fn unpack(width:u32,rows:u32,pitch:i32,row_zero:usize,storage:&[u8])->Result<Vec<u8>,Error> {
    let width=width as usize;let rows=rows as usize;
    let length=width.checked_mul(rows).ok_or_else(||Error("glyph coverage size overflow".into()))?;
    if length>64*1024*1024 {return Err(Error("glyph exceeds allocation limit".into()))}
    let mut result=Vec::with_capacity(length);
    if width==0 || rows==0 {return Ok(result)}
    for row in 0..rows {
        let start=(row_zero as i128)+(row as i128)*(pitch as i128);
        let start=usize::try_from(start).map_err(|_|Error("glyph pitch precedes source buffer".into()))?;
        let end=start.checked_add(width).ok_or_else(||Error("glyph source bounds overflow".into()))?;
        result.extend_from_slice(storage.get(start..end).ok_or_else(||Error("glyph source bounds unavailable".into()))?);
    }
    Ok(result)
}
/// Whole-rectangle bounds validation is an engine safety boundary, not native clipping.
pub fn copy_rgba(bitmap:&Bitmap,destination:&mut [u8],stride_pixels:u32,x:u32,y:u32)->Result<(),Error> {
    let width=bitmap.width as usize;let rows=bitmap.rows as usize;
    let length=width.checked_mul(rows).ok_or_else(||Error("glyph coverage overflow".into()))?;
    if bitmap.coverage.len()!=length {return Err(Error("glyph coverage length mismatch".into()))}
    if width==0 || rows==0 {return Ok(())}
    let top=(bitmap.ascender_26_6>>6).wrapping_sub(bitmap.bearing_y_26_6>>6).max(0) as u32;
    let top=top.checked_add(y).ok_or_else(||Error("glyph destination top overflow".into()))? as usize;
    let stride=stride_pixels as usize;let x=x as usize;
    if x.checked_add(width).is_none_or(|end|end>stride) {return Err(Error("glyph exceeds destination row".into()))}
    let end=top.checked_add(rows).and_then(|n|n.checked_sub(1)).and_then(|n|n.checked_mul(stride)).and_then(|n|n.checked_add(x+width)).and_then(|n|n.checked_mul(4)).ok_or_else(||Error("glyph destination bounds overflow".into()))?;
    if end>destination.len() {return Err(Error("glyph exceeds destination buffer".into()))}
    for row in 0..rows {for col in 0..width {
        let offset=((top+row)*stride+x+col)*4;
        destination[offset..offset+4].fill(bitmap.coverage[row*width+col]);
    }}
    Ok(())
}
#[cfg(test)] mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/native_glyph_loading_contract.json")).unwrap()}
    #[test] fn metrics_match_54_original_constructor_executions() {
        let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["constructor_case_count"],54);
        for c in p["constructors"].as_array().unwrap() {
            let v=c["supplied_metrics_26_6"].as_array().unwrap().iter().map(|n|n.as_i64().unwrap() as i32).collect::<Vec<_>>();
            let out=metrics(v[0],v[1],v[2],v[3],v[4],v[5]);
            assert_eq!(vec![out.advance,out.bearing_x,out.width,out.bottom],c["output_pixels"].as_array().unwrap().iter().map(|n|n.as_i64().unwrap() as i32).collect::<Vec<_>>());
            assert_eq!(c["calls"][1]["flags"],0);
        }
    }
    #[test] fn copy_matches_36_original_bitmaps_including_negative_pitch() {
        let p=proof();assert_eq!(p["copy_case_count"],36);
        for c in p["copies"].as_array().unwrap() {
            let width=c["width"].as_u64().unwrap() as u32;let rows=c["rows"].as_u64().unwrap() as u32;let pitch=c["pitch"].as_i64().unwrap() as i32;
            let mut storage=vec![0;128];let row_zero=if pitch<0 && rows>0 {(rows as usize-1)*pitch.unsigned_abs() as usize}else{0};
            for (row,values) in c["source_pixels"].as_array().unwrap().iter().enumerate() {
                let start=(row_zero as i64+row as i64*pitch as i64) as usize;
                for (col,value) in values.as_array().unwrap().iter().enumerate() {storage[start+col]=value.as_u64().unwrap() as u8;}
            }
            let bitmap=Bitmap {width,rows,bearing_y_26_6:c["bearing_y_26_6"].as_i64().unwrap() as i32,ascender_26_6:c["ascender_26_6"].as_i64().unwrap() as i32,coverage:unpack(width,rows,pitch,row_zero,&storage).unwrap()};
            let mut destination=vec![0xa5;1024];copy_rgba(&bitmap,&mut destination,c["destination_stride_pixels"].as_u64().unwrap() as u32,c["x"].as_u64().unwrap() as u32,c["y"].as_u64().unwrap() as u32).unwrap();
            let expected=c["destination_rgba_hex"].as_str().unwrap();let expected=(0..expected.len()).step_by(2).map(|i|u8::from_str_radix(&expected[i..i+2],16).unwrap()).collect::<Vec<_>>();assert_eq!(destination,expected);assert_eq!(c["calls"][0]["flags"],4);
        }
    }
    #[test] fn invalid_rectangles_leave_the_destination_unchanged() {
        let bitmap=Bitmap {width:3,rows:1,bearing_y_26_6:0,ascender_26_6:0,coverage:vec![7;3]};let mut destination=vec![0xa5;16];
        assert!(copy_rgba(&bitmap,&mut destination,4,2,0).is_err());assert_eq!(destination,vec![0xa5;16]);
        assert!(copy_rgba(&bitmap,&mut destination,4,0,1).is_err());assert_eq!(destination,vec![0xa5;16]);
        assert!(unpack(3,2,-5,0,&[0;16]).is_err());
    }
}

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
