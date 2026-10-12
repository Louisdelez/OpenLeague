from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/native_font_metrics.rs');s=p.read_text()
if 'pub fn compose_for_text(' not in s:
 s=s.replace('impl Faces {','''impl Faces {
    pub fn compose_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16,target:&mut openleague_font_raster::native_glyph::Target<'_>,x:i32,y:i32)->Result<(),String> {
        let glyph=self.glyph_for_text(sizes,text,character)?;
        openleague_font_raster::native_glyph::compose(glyph,target,x,y).map_err(|e|e.to_string())
    }
    pub fn kerning_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,left:u16,right:u16)->Result<i32,String> {
        let left=self.glyph_for_text(sizes,text,left)?.index;let right=self.glyph_for_text(sizes,text,right)?.index;
        let face=sizes.descriptor_bindings[text];
        self.faces[face].native_kerning(left,right).map_err(|e|e.to_string())
    }
''',1)
if 'native_composition_and_kerning_use_all_source_text_bindings' not in s:
 s+='''
#[cfg(test)] mod native_composition_binding_tests {
    use super::*;
    use openleague_font_raster::native_glyph::Target;
    #[test] fn native_composition_and_kerning_use_all_source_text_bindings() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));
        app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
        let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
        for text in 0..154 {
            let mut pixels=vec![85;128*128*4];let mut target=Target {pixels:&mut pixels,width:128,height:128,channels:4,stride_bytes:512};
            faces.compose_for_text(&sizes,text,65,&mut target,0,0).unwrap();assert!(pixels.iter().any(|v|*v!=85));
            let mut outside=vec![85;128*128*4];faces.compose_for_text(&sizes,text,65,&mut Target {pixels:&mut outside,width:128,height:128,channels:4,stride_bytes:512},-1000,-1000).unwrap();assert!(outside.iter().all(|v|*v==85));
            let a=faces.kerning_for_text(&sizes,text,65,86).unwrap();let b=faces.kerning_for_text(&sizes,text,65,86).unwrap();assert_eq!(a,b);
        }
        assert!(faces.kerning_for_text(&sizes,154,65,86).is_err());
    }
}
'''
p.write_text(s)
print('Native clipping/composition and kerning APIs bind all154source Text descriptors')
