//! FreeType2.4.8 from the official source tag; native compile options/raster fidelity remain open.
pub mod native_glyph;
pub mod native_font_atlas;
pub mod native_text_measure;
use std::{ffi::c_void,marker::PhantomData,ptr::NonNull};
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Error(pub String);
impl std::fmt::Display for Error {fn fmt(&self,f:&mut std::fmt::Formatter<'_>)->std::fmt::Result {f.write_str(&self.0)}}
impl std::error::Error for Error {}
extern "C" {
    fn ol_ft_native_kerning(face:*mut c_void,left:u32,right:u32,out:*mut i32)->i32;
    fn ol_ft_native_metrics(face:*mut c_void,character:u16,out:*mut i32)->i32;
    fn ol_ft_native_bitmap(face:*mut c_void,index:u32,out:*mut i32)->i32;
    fn ol_ft_library_new(out:*mut *mut c_void)->i32;
    fn ol_ft_library_version(library:*mut c_void,out:*mut i32);
    fn ol_ft_library_done(library:*mut c_void);
    fn ol_ft_face_new(library:*mut c_void,data:*const u8,len:usize,out:*mut *mut c_void)->i32;
    fn ol_ft_face_done(face:*mut c_void);
    fn ol_ft_face_size(face:*mut c_void,height:i32,x:u32,y:u32,out:*mut i32)->i32;
    fn ol_ft_face_metrics(face:*mut c_void,out:*mut i32)->i32;
    fn ol_ft_glyph_load(face:*mut c_void,character:u32,flags:i32,mode:i32,out:*mut i32)->i32;
    fn ol_ft_glyph_copy(face:*mut c_void,out:*mut u8,len:usize)->i32;
}
fn checked(code:i32)->Result<(),Error> {if code==0 {Ok(())}else{Err(Error(format!("FreeType2.4.8 error {code}")))}}
pub struct Face {library:NonNull<c_void>,face:NonNull<c_void>,_data:Vec<u8>,_thread:PhantomData<*mut ()>}
impl Drop for Face {fn drop(&mut self) {unsafe {ol_ft_face_done(self.face.as_ptr());ol_ft_library_done(self.library.as_ptr());}}}
#[derive(Clone,Debug)]
pub struct Metrics {pub ascender_26_6:i32,pub descender_26_6:i32,pub height_26_6:i32,pub max_advance_26_6:i32}
#[derive(Debug)]
pub struct Glyph {pub index:u32,pub width:u32,pub height:u32,pub left:i32,pub top:i32,pub advance_x_26_6:i32,pub advance_y_26_6:i32,pub pixels:Vec<u8>}
impl Face {
    pub fn new(data:Vec<u8>)->Result<Self,Error> {
        let mut library=std::ptr::null_mut();unsafe {checked(ol_ft_library_new(&mut library))?;}
        let library=NonNull::new(library).ok_or_else(||Error("library handle unavailable".into()))?;
        let mut face=std::ptr::null_mut();let code=unsafe {ol_ft_face_new(library.as_ptr(),data.as_ptr(),data.len(),&mut face)};
        if code!=0 || face.is_null() {unsafe {ol_ft_library_done(library.as_ptr());}return Err(Error(format!("font face unavailable: {code}")));}
        Ok(Self {library,face:NonNull::new(face).unwrap(),_data:data,_thread:PhantomData})
    }
    /// Native two-phase loading; index0 is preserved, including unmapped UTF16 units.
    pub fn native_glyph(&mut self,character:u16)->Result<native_glyph::NativeGlyph,Error> {
        let mut values=[0;7];unsafe {checked(ol_ft_native_metrics(self.face.as_ptr(),character,values.as_mut_ptr()))?;}
        let index=values[0] as u32;
        let metrics=native_glyph::metrics(values[1],values[2],values[3],values[4],values[5],values[6]);
        let mut bitmap=[0;4];unsafe {checked(ol_ft_native_bitmap(self.face.as_ptr(),index,bitmap.as_mut_ptr()))?;}
        let width=bitmap[0] as u32;let rows=bitmap[1] as u32;
        let length=(width as usize).checked_mul(rows as usize).ok_or_else(||Error("glyph size overflow".into()))?;
        if length>64*1024*1024 {return Err(Error("glyph exceeds renderer allocation limit".into()));}
        let mut coverage=vec![0;length];unsafe {checked(ol_ft_glyph_copy(self.face.as_ptr(),coverage.as_mut_ptr(),coverage.len()))?;}
        Ok(native_glyph::NativeGlyph {character_utf16:character,index,metrics,bitmap:native_glyph::Bitmap {width,rows,bearing_y_26_6:bitmap[2],ascender_26_6:bitmap[3],coverage}})
    }
    pub fn native_kerning(&mut self,left_index:u32,right_index:u32)->Result<i32,Error> {
        let mut delta=0;unsafe {checked(ol_ft_native_kerning(self.face.as_ptr(),left_index,right_index,&mut delta))?;}
        Ok(native_glyph::kerning_pixels(delta))
    }
    pub fn version(&self)->[i32;3] {let mut out=[0;3];unsafe {ol_ft_library_version(self.library.as_ptr(),out.as_mut_ptr());}out}
    pub fn set_size(&mut self,height_26_6:u32,dpi_x:u32,dpi_y:u32)->Result<Metrics,Error> {
        let mut out=[0;4];unsafe {checked(ol_ft_face_size(self.face.as_ptr(),height_26_6 as i32,dpi_x,dpi_y,out.as_mut_ptr()))?;}
        Ok(Metrics {ascender_26_6:out[0],descender_26_6:out[1],height_26_6:out[2],max_advance_26_6:out[3]})
    }
    pub fn fit(&mut self,requested:u32,flags:u32,dpi_x:u32,dpi_y:u32,budget:usize)->Result<Adjusted,Error> {
        adjust(requested,flags,dpi_x,dpi_y,budget,|size,x,y|Ok(self.set_size(size,x,y)?.height_26_6>>6))
    }
    pub fn metrics(&self)->Result<Metrics,Error> {
        let mut out=[0;4];unsafe {checked(ol_ft_face_metrics(self.face.as_ptr(),out.as_mut_ptr()))?;}
        Ok(Metrics {ascender_26_6:out[0],descender_26_6:out[1],height_26_6:out[2],max_advance_26_6:out[3]})
    }
    /// Explicit load flags and render mode; original glyph load flags still require qualification.
    pub fn glyph(&mut self,character:char,flags:i32,mode:i32)->Result<Glyph,Error> {
        let mut out=[0;7];unsafe {checked(ol_ft_glyph_load(self.face.as_ptr(),character as u32,flags,mode,out.as_mut_ptr()))?;}
        let width=out[1] as u32;let height=out[2] as u32;
        let len=(width as usize).checked_mul(height as usize).ok_or_else(||Error("glyph size overflow".into()))?;
        if len>64*1024*1024 {return Err(Error("glyph exceeds renderer allocation limit".into()));}
        let mut pixels=vec![0;len];unsafe {checked(ol_ft_glyph_copy(self.face.as_ptr(),pixels.as_mut_ptr(),pixels.len()))?;}
        Ok(Glyph {index:out[0] as u32,width,height,left:out[3],top:out[4],advance_x_26_6:out[5],advance_y_26_6:out[6],pixels})
    }
}
#[derive(Debug)]
pub struct SizeCall {pub height_26_6:u32,pub metric_height:i32}
#[derive(Debug)]
pub struct Adjusted {pub height_26_6:u32,pub metric_height:i32,pub calls:Vec<SizeCall>}
pub fn adjust(requested:u32,flags:u32,dpi_x:u32,dpi_y:u32,budget:usize,mut supplier:impl FnMut(u32,u32,u32)->Result<i32,Error>)->Result<Adjusted,Error> {
    let mut calls=Vec::new();let mut size=requested.wrapping_shl(6);
    let mut call=|value:u32|->Result<i32,Error> {
        if calls.len()>=budget {return Err(Error("font metric adjustment budget exceeded".into()));}
        let metric=supplier(value,dpi_x,dpi_y)?;calls.push(SizeCall {height_26_6:value,metric_height:metric});Ok(metric)
    };
    let mut metric=call(size)?;
    if flags&0x10!=0 {
        if (metric as u32)<requested {
            loop {size=size.wrapping_add(1);metric=call(size)?;if (metric as u32)>=requested {break}}
            size=size.wrapping_sub(1);metric=call(size)?;
        } else if (metric as u32)>requested {
            loop {size=size.wrapping_sub(1);metric=call(size)?;if (metric as u32)<=requested {break}}
        }
    }
    Ok(Adjusted {height_26_6:size,metric_height:metric,calls})
}
#[cfg(test)] mod tests {
    use super::*;
    fn root()->std::path::PathBuf {std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..")}
    #[test] fn adjustment_matches_all_384_original_call_sequences() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_face_sizing_contract.json")).unwrap();assert_eq!(p["case_count"],384);
        for c in p["cases"].as_array().unwrap() {
            let x=c["dpi_x"].as_u64().unwrap() as u32;let y=c["dpi_y"].as_u64().unwrap() as u32;let offset=c["metric_offset"].as_i64().unwrap() as i32;
            let adjusted=adjust(c["requested_size"].as_u64().unwrap() as u32,c["flags"].as_u64().unwrap() as u32,x,y,10000,|height,dx,dy| {assert_eq!(dx,x);assert_eq!(dy,y);Ok(if c["metric_profile"]=="offset" {(height as i32/64+offset).max(0)}else{((u64::from(height)*u64::from(dy)+64*72/2)/(64*72)) as i32})}).unwrap();
            assert_eq!(adjusted.height_26_6,c["final_character_height_26_6"].as_u64().unwrap() as u32);assert_eq!(adjusted.metric_height,c["final_metric_height"].as_i64().unwrap() as i32);
            assert_eq!(adjusted.calls.len(),c["calls"].as_array().unwrap().len());for (actual,expected) in adjusted.calls.iter().zip(c["calls"].as_array().unwrap()) {assert_eq!(actual.height_26_6,expected["character_height_26_6"].as_u64().unwrap() as u32);assert_eq!(actual.metric_height,expected["metric_height"].as_i64().unwrap() as i32);}
        }
    }
    #[test] fn all_five_source_families_load_adjust_and_rasterize_real_glyphs() {
        let version:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_freetype_version_contract.json")).unwrap();assert_eq!(version["passed"],true);
        for (file,character) in [("GillSansMTPro-Medium.otf",'A'),("GillSansMTProCyr-Medium.otf",'Ж'),("GillSansMTProGrk-Medium.otf",'Ω'),("ARIALUNI.TTF",'中'),("UttumDotum.ttf",'가')] {
            let mut face=Face::new(std::fs::read(root().join("assets/fonts/native4.20").join(file)).unwrap()).unwrap();assert_eq!(face.version(),[2,4,8]);
            for dpi in [72,96,100] {
                let fit=face.fit(17,0x10,dpi,dpi,10000).unwrap();assert!(fit.metric_height>0 && fit.metric_height<=17);
                assert_eq!(face.metrics().unwrap().height_26_6>>6,fit.metric_height);
                let glyph=face.glyph(character,0,0).unwrap();assert!(glyph.index>0 && glyph.width>0 && glyph.height>0 && glyph.advance_x_26_6>0);assert_eq!(glyph.pixels.len(),(glyph.width*glyph.height) as usize);assert!(glyph.pixels.iter().any(|v|*v>0));
            }
        }
    }
    #[test] fn invalid_fonts_and_nonterminating_metric_suppliers_fail_explicitly() {
        assert!(Face::new(vec![0;64]).is_err());
        assert!(adjust(17,0x10,96,96,4,|_,_,_|Ok(18)).unwrap_err().0.contains("budget"));
        assert!(adjust(17,0x10,96,96,4,|_,_,_|Err(Error("provider unavailable".into()))).is_err());
    }
}

#[cfg(test)] mod native_loading_tests {
    use super::*;
    #[test] fn native_two_phase_loading_supports_five_families_and_space() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        for (file,character) in [("GillSansMTPro-Medium.otf",0x00e9),("GillSansMTProCyr-Medium.otf",0x0416),("GillSansMTProGrk-Medium.otf",0x03a9),("ARIALUNI.TTF",0x4e2d),("UttumDotum.ttf",0xac00)] {
            let mut face=Face::new(std::fs::read(root.join("assets/fonts/native4.20").join(file)).unwrap()).unwrap();face.fit(17,0x10,96,96,10000).unwrap();
            let glyph=face.native_glyph(character).unwrap();assert_eq!(glyph.character_utf16,character);assert!(glyph.index>0 && glyph.metrics.advance>0 && glyph.metrics.width>0);assert!(glyph.bitmap.coverage.iter().any(|v|*v>0));
            let direct=face.glyph(char::from_u32(character as u32).unwrap(),4,0).unwrap();assert_eq!(glyph.bitmap.coverage,direct.pixels);assert_eq!((glyph.bitmap.width,glyph.bitmap.rows),(direct.width,direct.height));
            let space=face.native_glyph(32).unwrap();assert!(space.metrics.advance>0);assert_eq!(space.bitmap.width*space.bitmap.rows,0);assert!(space.bitmap.coverage.is_empty());
            let unmapped=face.native_glyph(0).unwrap();assert_eq!(unmapped.character_utf16,0);
        }
    }
}

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

pub mod native_font_atlas_pixels;

pub mod native_font_quad;

pub mod native_font_sequence;

pub mod native_hud_text_draw;

pub mod native_hud_text_projection;
