from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text()
s=s.replace('use openleague_font_raster::{Face,Metrics};','use openleague_font_raster::{Face,Metrics,native_glyph::NativeGlyph};\nuse std::collections::BTreeMap;')
s=s.replace('pub faces:Vec<Face>,pub prepared:Vec<Prepared>','pub faces:Vec<Face>,pub prepared:Vec<Prepared>,pub glyphs:Vec<BTreeMap<u16,NativeGlyph>>')
if 'pub fn glyph_for_text(' not in s:
 index=s.index('pub fn prepare(')
 s=s[:index]+'''impl Faces {
    /// Engine-owned cache, keyed by the native UTF16 code unit. Native ownership/refcounts remain open.
    pub fn glyph_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16)->Result<&NativeGlyph,String> {
        if self.height!=sizes.height {return Err("glyph face sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        if self.glyphs.len()!=self.faces.len() {return Err("glyph cache and face registry disagree".into())}
        let cache=self.glyphs.get_mut(face).ok_or("source glyph cache missing")?;
        if let std::collections::btree_map::Entry::Vacant(entry)=cache.entry(character) {
            let glyph=self.faces.get_mut(face).ok_or("source glyph face missing")?.native_glyph(character).map_err(|e|e.to_string())?;
            entry.insert(glyph);
        }
        Ok(cache.get(&character).unwrap())
    }
}
''' +s[index:]
s=s.replace('faces.faces=loaded;faces.prepared=prepared;','faces.glyphs=(0..loaded.len()).map(|_|BTreeMap::new()).collect();faces.faces=loaded;faces.prepared=prepared;')
if 'source_text_glyph_cache_preserves_utf16_and_resets_on_resize' not in s:
 s+='''
#[cfg(test)] mod glyph_cache_tests {
    use super::*;
    #[test] fn source_text_glyph_cache_preserves_utf16_and_resets_on_resize() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));
        let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        for height in [800,1080,768] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1280,height);app.update();
            let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();
            let mut faces=app.world_mut().non_send_resource_mut::<Faces>();assert_eq!(faces.glyphs.len(),19);assert!(faces.glyphs.iter().all(|cache|cache.is_empty()));
            for text in 0..154 {
                let first=faces.glyph_for_text(&sizes,text,65).unwrap() as *const NativeGlyph;
                let second=faces.glyph_for_text(&sizes,text,65).unwrap() as *const NativeGlyph;assert_eq!(first,second);
                let glyph=faces.glyph_for_text(&sizes,text,65).unwrap();assert_eq!(glyph.character_utf16,65);assert!(glyph.bitmap.coverage.iter().any(|v|*v>0));
                let space=faces.glyph_for_text(&sizes,text,32).unwrap();assert!(space.metrics.advance>0);assert!(space.bitmap.coverage.is_empty());
                assert_eq!(faces.glyph_for_text(&sizes,text,0).unwrap().character_utf16,0);
            }
            assert!(faces.glyphs.iter().all(|cache|cache.len()==3));assert!(faces.glyph_for_text(&sizes,154,65).is_err());
            app.insert_resource(sizes);
        }
    }
}
'''
p.write_text(s)
print('154 source Text bindings resolve lazily cached native glyphs; resize invalidates engine-owned cache')
