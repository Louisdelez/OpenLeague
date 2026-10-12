from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/native_font_metrics.rs');s=p.read_text()
s=s.replace('pub glyphs:Vec<BTreeMap<u16,NativeGlyph>>','pub glyphs:Vec<BTreeMap<u16,NativeGlyph>>,pub atlases:Vec<openleague_font_raster::native_font_atlas::Bank>')
s=s.replace('faces.glyphs=(0..loaded.len()).map(|_|BTreeMap::new()).collect();','faces.glyphs=(0..loaded.len()).map(|_|BTreeMap::new()).collect();faces.atlases=(0..loaded.len()).map(|_|Default::default()).collect();')
if 'pub fn atlas_cell_for_text(' not in s:
 s=s.replace('impl Faces {','''impl Faces {
    /// Logical native layout only; pages do not yet own GPU texture handles.
    pub fn atlas_cell_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16)->Result<openleague_font_raster::native_font_atlas::Binding,String> {
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let glyph=self.glyph_for_text(sizes,text,character)?;
        let node=openleague_font_raster::native_text_measure::node(character,&glyph.metrics,descriptor.extra,descriptor.flags);
        self.atlases.get_mut(face).ok_or("source font atlas registry missing")?.request(&node).map_err(|e|e.to_string())
    }
''',1)
s=s.replace('let result=measure(contents,32,space,height,|character| match self.glyph_for_text(sizes,text,character) {','''let result=measure(contents,32,space,height,|character| {
            if let Err(value)=self.atlas_cell_for_text(sizes,text,character) {error=Some(value);return None}
            match self.glyph_for_text(sizes,text,character) {''')
s=s.replace('Err(value)=>{error=Some(value);None}\n        });','Err(value)=>{error=Some(value);None}\n        }});')
if 'source_font_atlases_bind_measurement_and_reset_on_resize' not in s:
 s+='''
#[cfg(test)] mod source_atlas_tests {
    use super::*;
    #[test] fn source_font_atlases_bind_measurement_and_reset_on_resize() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        for height in [800,1080,768] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1280,height);app.update();
            let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();assert_eq!(faces.atlases.len(),19);assert!(faces.atlases.iter().all(|bank|bank.pages.is_empty()));
            for text in 0..154 {
                faces.measure_for_text(&sizes,text,Some(&[65,32,86])).unwrap();
                let a=faces.atlas_cell_for_text(&sizes,text,65).unwrap();let repeated=faces.atlas_cell_for_text(&sizes,text,65).unwrap();assert_eq!(a,repeated);
                let face=sizes.descriptor_bindings[text];let bank=&faces.atlases[face];assert_eq!(bank.bindings.len(),2);assert!(!bank.bindings.contains_key(&32));assert_eq!(bank.pages.len(),1);assert_eq!(bank.pages[0].size,256);assert!(bank.pages[0].dirty);
                assert!(a.placement.uv.iter().all(|v|v.is_finite() && *v>=0. && *v<=1.));
            }
            assert!(faces.atlases.iter().all(|bank|bank.bindings.len()==2));app.insert_resource(sizes);
        }
    }
}
'''
p.write_text(s);print('Native logical pages and cells bind154source Text measurements; GPU texture handles remain pending')
