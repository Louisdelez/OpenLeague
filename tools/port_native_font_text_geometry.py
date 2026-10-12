from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/font-raster/src/native_font_sequence.rs';s=p.read_text(encoding='utf-8');assert 'pub fn face_pixels(' not in s
s+=r"""
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct FacePixels {pub ascender:i32,pub descent:i32,pub height:i32,pub space_advance:i32}
pub fn face_pixels(ascender:i32,descender:i32,height:i32,space_advance:i32)->FacePixels {
    FacePixels {ascender:ascender>>6,descent:descender.wrapping_neg()>>6,height:height>>6,space_advance:space_advance>>6}
}
#[cfg(test)] mod face_tests {
    use super::*;
    #[test] fn face_metric_pixels_match108_native_suffix_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_face_metrics_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],108);
        for c in p["cases"].as_array().unwrap() {let v=c["metrics_26_6"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>();let m=face_pixels(v[0],v[1],v[2],v[3]);assert_eq!([m.ascender,m.descent,m.height,m.space_advance],c["pixels"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>().as_slice());}
    }
}
"""
p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_native_font_face_metrics.py'),r/'tools/qualify_native_font_face_metrics.py')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8');assert 'pub fn text_geometry(' not in s
pos=s.index('impl Faces {')
s=s[:pos]+r"""
/// Caller-supplied native Text parameters; original HUD producers remain separate.
pub struct TextGeometryArgs {pub position:[f32;2],pub horizontal:u32,pub vertical:u32,pub font_scale:[f32;2],pub owner_scale:f32,pub opacity:f32,pub colors:[u32;2]}
pub struct TextGeometry {pub raw_dimensions:[i32;2],pub dimensions:[i32;2],pub glyphs:Vec<(u16,openleague_font_raster::native_font_quad::Quad)>}
"""+s[pos:]
needle='impl Faces {'
method=r"""
    /// Source FreeType -> native prepared cells -> sequence -> UV-bound glyph quads.
    /// Rich markup/wrapping, viewport conversion and widget/GPU drawing remain separate.
    pub fn text_geometry(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,contents:&[u16],args:&TextGeometryArgs)->Result<TextGeometry,String> {
        use openleague_font_raster::{native_font_sequence as sequence,native_font_quad as quad};
        if self.height!=sizes.height {return Err("text geometry sizes stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let descriptor=sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor.clone();
        let metrics=&self.prepared.get(face).ok_or("source face metrics missing")?.metrics;
        let (ascender,descent,height)=(metrics.ascender_26_6>>6,metrics.descender_26_6.wrapping_neg()>>6,metrics.height_26_6>>6);
        let space=self.glyph_for_text(sizes,text,32)?.metrics.advance;
        let contents=&contents[..contents.iter().position(|c|*c==0).unwrap_or(contents.len())];let mut error=None;
        let prepared=sequence::prepare(contents,32,space,height,args.font_scale,|character| {
            if let Err(value)=self.atlas_cell_for_text(sizes,text,character) {error=Some(value);return None}
            match self.glyph_for_text(sizes,text,character) {Ok(glyph)=>{let node=openleague_font_raster::native_text_measure::node(character,&glyph.metrics,descriptor.extra,descriptor.flags);Some(sequence::Glyph {id:character as u32,bearing_x:glyph.metrics.bearing_x,advance:node.advance as u32})},Err(value)=>{error=Some(value);None}}
        }).map_err(|e|e.to_string())?;
        if let Some(error)=error.take() {return Err(error)}
        let layout=sequence::Layout {position:args.position,dimensions:prepared.dimensions,font_vertical_add:ascender,font_vertical_subtract:descent,horizontal:args.horizontal,vertical:args.vertical,font_scale_x:args.font_scale[0],owner_scale:args.owner_scale,space_advance:space};
        let draws=sequence::sequence(&layout,&prepared.cells,|left,right|match self.kerning_for_text(sizes,text,left as u16,right as u16) {Ok(value)=>value,Err(value)=>{error=Some(value);0}}).map_err(|e|e.to_string())?;
        if let Some(error)=error {return Err(error)}
        let mut glyphs=Vec::with_capacity(draws.len());
        for draw in draws {let character=draw.glyph_id as u16;let binding=self.atlas_cell_for_text(sizes,text,character)?;let glyph=self.glyph_for_text(sizes,text,character)?;let node=openleague_font_raster::native_text_measure::node(character,&glyph.metrics,descriptor.extra,descriptor.flags);
            let input=quad::Input {position:draw.position,dimensions:[node.width,node.height],font_scale:args.font_scale,owner_scale:args.owner_scale,opacity:args.opacity,colors:args.colors,atlas_uv:binding.placement.uv,base_index:0};glyphs.push((character,quad::build(&input).map_err(|e|e.to_string())?));}
        Ok(TextGeometry {raw_dimensions:prepared.raw_dimensions,dimensions:prepared.dimensions,glyphs})
    }
"""
s=s.replace(needle,needle+method,1)
s+=r"""
#[cfg(test)] mod source_geometry_tests {
    use super::*;
    #[test] fn all154_source_text_bindings_produce_uv_bound_glyph_quads_without_space_or_nul_draws() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
        let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
        let args=TextGeometryArgs {position:[11.75,40.25],horizontal:0,vertical:1,font_scale:[1.,1.],owner_scale:1.,opacity:1.,colors:[0xffffffff,0xff000000]};
        for text in 0..154 {
            let geometry=faces.text_geometry(&sizes,text,&[65,32,86,233,0,0x4e2d],&args).unwrap();assert_eq!(geometry.glyphs.iter().map(|g|g.0).collect::<Vec<_>>(),vec![65,86,233]);
            let measured=faces.measure_for_text(&sizes,text,Some(&[65,32,86,233])).unwrap();assert_eq!(geometry.raw_dimensions,[measured.width,measured.height]);assert_eq!(geometry.dimensions,geometry.raw_dimensions);
            let face=sizes.descriptor_bindings[text];assert!(!faces.glyphs[face].contains_key(&0x4e2d));
            for (character,quad) in geometry.glyphs {let binding=&faces.atlases[face].bindings[&character];assert_eq!(quad.vertices[0].atlas_uv,[binding.placement.uv[0],binding.placement.uv[1]]);assert_eq!(quad.vertices[2].atlas_uv,[binding.placement.uv[2],binding.placement.uv[3]]);assert_eq!(quad.indices,[0,1,2,0,2,3]);assert_eq!(quad.vertices[0].position[1],39.5);assert!(quad.vertices.iter().all(|v|v.position.iter().all(|v|v.is_finite())));}
        }
        assert!(faces.text_geometry(&sizes,154,&[65],&args).is_err());
    }
}
"""
p.write_text(s,encoding='utf-8')
