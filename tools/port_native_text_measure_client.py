from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/native_font_metrics.rs');s=p.read_text()
if 'pub fn measure_for_text(' not in s:
 s=s.replace('impl Faces {','''impl Faces {
    pub fn measure_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,contents:Option<&[u16]>)->Result<openleague_font_raster::native_text_measure::Measurement,String> {
        use openleague_font_raster::native_text_measure::{measure,node};
        if self.height!=sizes.height {return Err("text metric sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let extra=descriptor.extra;let flags=descriptor.flags;
        if contents.is_none_or(|v|v.first().is_none_or(|c|*c==0)) {return Ok(measure(contents,32,0,0,|_|None))}
        let height=self.prepared.get(face).ok_or("source font metrics missing")?.metrics.height_26_6>>6;
        let space=self.glyph_for_text(sizes,text,32)?.metrics.advance;let mut error=None;
        let result=measure(contents,32,space,height,|character| match self.glyph_for_text(sizes,text,character) {
            Ok(glyph)=>Some(node(character,&glyph.metrics,extra,flags).advance),
            Err(value)=>{error=Some(value);None}
        });
        if let Some(error)=error {Err(error)}else{Ok(result)}
    }
''',1)
if 'source_text_measurement_preserves_native_space_and_nul_rules' not in s:
 s+='''
#[cfg(test)] mod source_measure_tests {
    use super::*;
    use openleague_font_raster::native_text_measure::{node,Measurement};
    #[test] fn source_text_measurement_preserves_native_space_and_nul_rules() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
        let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
        for text in 0..154 {
            for empty in [None,Some(&[][..]),Some(&[0,65][..])] {assert_eq!(faces.measure_for_text(&sizes,text,empty).unwrap(),Measurement {success:true,width:0,height:0});}
            let face=sizes.descriptor_bindings[text];let descriptor=&sizes.descriptors.entries[face].descriptor;
            let space=faces.glyph_for_text(&sizes,text,32).unwrap().metrics.advance;
            let mut width=space;
            for character in [65,86,233] {let g=faces.glyph_for_text(&sizes,text,character).unwrap();width=width.wrapping_add(node(character,&g.metrics,descriptor.extra,descriptor.flags).advance);}
            let actual=faces.measure_for_text(&sizes,text,Some(&[65,32,86,233,0,0x4e2d])).unwrap();assert_eq!(actual,Measurement {success:true,width,height:faces.prepared[face].metrics.height_26_6>>6});
            assert!(!faces.glyphs[face].contains_key(&0) && !faces.glyphs[face].contains_key(&0x4e2d));
            assert_eq!(faces.measure_for_text(&sizes,text,Some(&[32,32])).unwrap().width,space.wrapping_mul(2));
        }
        assert!(faces.measure_for_text(&sizes,154,Some(&[65])).is_err());
    }
}
'''
p.write_text(s);print('Native simple measurement integrated for154source Text bindings')
