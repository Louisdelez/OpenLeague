from pathlib import Path
import shutil
r=Path('E:/OpenLeague');crate=r/'crates/font-raster'
shutil.copy2('E:/mapslol3v3/native_glyph.rs',crate/'src/native_glyph.rs')
bridge=crate/'bridge.c';s=bridge.read_text()
s=s.replace('bitmap->pitch<0 || (size_t)bitmap->pitch<width ||','(size_t)(bitmap->pitch<0?-(int64_t)bitmap->pitch:bitmap->pitch)<width ||')
s=s.replace('bitmap->buffer+row*(size_t)bitmap->pitch','bitmap->buffer+(ptrdiff_t)row*bitmap->pitch')
if 'int ol_ft_native_metrics(' not in s:
 s+='''
/* Original glyph constructor: UTF16 code unit, flags0 and signed26.6 metrics. */
int ol_ft_native_metrics(void *opaque,uint16_t character,int32_t out[7]) {
    FT_Face face=(FT_Face)opaque;FT_UInt index=FT_Get_Char_Index(face,character);
    int error=FT_Load_Glyph(face,index,0);if(error) return error;
    if(!face->size || !face->glyph) return -1;
    out[0]=(int32_t)index;out[1]=(int32_t)face->glyph->advance.x;
    out[2]=(int32_t)face->glyph->metrics.horiBearingX;out[3]=(int32_t)face->glyph->metrics.width;
    out[4]=(int32_t)face->glyph->metrics.horiBearingY;out[5]=(int32_t)face->glyph->metrics.height;
    out[6]=(int32_t)face->size->metrics.ascender;return 0;
}
/* Original bitmap path uses FT_LOAD_RENDER4; do not render a second time. */
int ol_ft_native_bitmap(void *opaque,uint32_t index,int32_t out[4]) {
    FT_Face face=(FT_Face)opaque;int error=FT_Load_Glyph(face,index,4);if(error) return error;
    if(!face->size || !face->glyph || face->glyph->format!=FT_GLYPH_FORMAT_BITMAP) return -3;
    if(face->glyph->bitmap.width>INT32_MAX || face->glyph->bitmap.rows>INT32_MAX) return -4;
    if(face->glyph->bitmap.width && face->glyph->bitmap.rows && face->glyph->bitmap.pixel_mode!=FT_PIXEL_MODE_GRAY) return -3;
    out[0]=(int32_t)face->glyph->bitmap.width;out[1]=(int32_t)face->glyph->bitmap.rows;
    out[2]=(int32_t)face->glyph->metrics.horiBearingY;out[3]=(int32_t)face->size->metrics.ascender;return 0;
}
'''
bridge.write_text(s)
lib=crate/'src/lib.rs';s=lib.read_text()
if 'pub mod native_glyph;' not in s:s=s.replace('use std::{','pub mod native_glyph;\nuse std::{',1)
if 'fn ol_ft_native_metrics(' not in s:s=s.replace('extern "C" {','extern "C" {\n    fn ol_ft_native_metrics(face:*mut c_void,character:u16,out:*mut i32)->i32;\n    fn ol_ft_native_bitmap(face:*mut c_void,index:u32,out:*mut i32)->i32;',1)
if 'pub fn native_glyph(' not in s:
 s=s.replace('    pub fn version(&self)', '''    /// Native two-phase loading; index0 is preserved, including unmapped UTF16 units.
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
    pub fn version(&self)''',1)
if 'native_two_phase_loading_supports_five_families_and_space' not in s:
 s+='''
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
'''
lib.write_text(s)
print('Native metrics54/copy36 port and flags0/4 source-face loading implemented')
