//! Real source-face metrics from the native-matching FreeType2.4.8 version.
//! Native compilation patches/load flags/glyph atlas/HUD drawing remain unqualified.
use bevy::{prelude::*,window::PrimaryWindow};
use openleague_font_raster::{Face,Metrics,native_glyph::NativeGlyph};
use std::collections::BTreeMap;
#[derive(Resource,Default)]
pub struct Dpi {pub explicit:Option<[u32;2]>}
pub fn select_dpi(context:bool,query:impl FnOnce()->Result<[u32;2],String>)->Result<[u32;2],String> {
    if context {query()}else{Ok([100,100])}
}
#[cfg(windows)]
fn desktop_dpi()->Result<[u32;2],String> {
    use std::ffi::c_void;
    #[link(name="user32")] extern "system" {fn GetDC(window:*mut c_void)->*mut c_void;fn ReleaseDC(window:*mut c_void,dc:*mut c_void)->i32;}
    #[link(name="gdi32")] extern "system" {fn GetDeviceCaps(dc:*mut c_void,index:i32)->i32;}
    // Same numerical supplier as native; borrowed GetDC lifetime uses ReleaseDC.
    let dc=unsafe {GetDC(std::ptr::null_mut())};if dc.is_null() {return Err("desktop font DPI context unavailable".into());}
    let x=unsafe {GetDeviceCaps(dc,88)};let y=unsafe {GetDeviceCaps(dc,90)};
    unsafe {ReleaseDC(std::ptr::null_mut(),dc);}
    if x<=0 || y<=0 {return Err("desktop font DPI invalid; native failure behavior unqualified".into());}
    Ok([x as u32,y as u32])
}
#[cfg(not(windows))] fn desktop_dpi()->Result<[u32;2],String> {Err("native desktop DPI supplier requires explicit platform context".into())}
pub struct Prepared {pub point_height_26_6:u32,pub adjustment_calls:usize,pub metrics:Metrics}
#[derive(Default)]
pub struct Faces {pub height:Option<u32>,pub dpi:Option<[u32;2]>,pub faces:Vec<Face>,pub prepared:Vec<Prepared>,pub glyphs:Vec<BTreeMap<u16,NativeGlyph>>,pub atlases:Vec<openleague_font_raster::native_font_atlas::Bank>}

/// Caller-supplied native Text parameters; original HUD producers remain separate.
pub struct TextGeometryArgs {pub position:[f32;2],pub horizontal:u32,pub vertical:u32,pub font_scale:[f32;2],pub owner_scale:f32,pub opacity:f32,pub colors:[u32;2]}
pub struct TextGeometry {pub raw_dimensions:[i32;2],pub dimensions:[i32;2],pub glyphs:Vec<(u16,openleague_font_raster::native_font_quad::Quad)>}
impl Faces {
    /// Original HUD wrapper parameters -> source face -> native glyph geometry.
    /// Caller owns pixel rectangle transforms, UTF16 content, owner draw scale and widget lifecycle.
    pub fn hud_text_geometry(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,contents:&[u16],rect:[f32;4],alignment:u32,color:u32,owner_scale:f32)->Result<TextGeometry,String> {
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let flags=sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor.flags;
        let draw=openleague_font_raster::native_hud_text_draw::draw(rect,alignment,flags,color).map_err(|e|e.to_string())?;
        let args=TextGeometryArgs {position:draw.position,horizontal:draw.horizontal,vertical:draw.vertical,font_scale:draw.font_scale,owner_scale,opacity:draw.opacity,colors:draw.colors};
        self.text_geometry(sizes,text,contents,&args)
    }

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

    /// Logical native layout only; pages do not yet own GPU texture handles.
    pub fn atlas_cell_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16)->Result<openleague_font_raster::native_font_atlas::Binding,String> {
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let glyph=self.glyph_for_text(sizes,text,character)?;
        let node=openleague_font_raster::native_text_measure::node(character,&glyph.metrics,descriptor.extra,descriptor.flags);
        self.atlases.get_mut(face).ok_or("source font atlas registry missing")?.request(&node).map_err(|e|e.to_string())
    }

    /// Full CPU page pixels with native expansion/offset; caller still owns GPU upload.
    pub fn update_atlas_for_text(&self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,page:usize)->Result<Vec<u8>,String> {
        if self.height!=sizes.height {return Err("atlas sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let bank=self.atlases.get(face).ok_or("source atlas missing")?;let cells=bank.page_cells(page).map_err(|e|e.to_string())?;
        let size=bank.pages.get(page).ok_or("source atlas page missing")?.size as u32;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let cache=self.glyphs.get(face).ok_or("source glyph cache missing")?;
        openleague_font_raster::native_font_atlas_pixels::update(&cells,size,descriptor.extra,descriptor.flags&4!=0,|id|cache.get(&id).map(|g|g.bitmap.clone()).ok_or_else(||openleague_font_raster::Error("atlas glyph cache missing".into()))).map_err(|e|e.to_string())
    }

    /// Raw page copy only. Shadow/outline update and GPU upload remain separate.
    pub fn copy_atlas_for_text(&self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,page:usize,destination:&mut [u8],stride_pixels:u32,x:u32,y:u32)->Result<(),String> {
        if self.height!=sizes.height {return Err("atlas sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let cells=self.atlases.get(face).ok_or("source atlas missing")?.page_cells(page).map_err(|e|e.to_string())?;
        let cache=self.glyphs.get(face).ok_or("source glyph cache missing")?;
        openleague_font_raster::native_font_atlas_pixels::copy_cells(&cells,destination,stride_pixels,x,y,|id|cache.get(&id).map(|g|g.bitmap.clone()).ok_or_else(||openleague_font_raster::Error("atlas glyph cache missing".into()))).map_err(|e|e.to_string())
    }

    pub fn measure_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,contents:Option<&[u16]>)->Result<openleague_font_raster::native_text_measure::Measurement,String> {
        use openleague_font_raster::native_text_measure::{measure,node};
        if self.height!=sizes.height {return Err("text metric sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let extra=descriptor.extra;let flags=descriptor.flags;
        if contents.is_none_or(|v|v.first().is_none_or(|c|*c==0)) {return Ok(measure(contents,32,0,0,|_|None))}
        let height=self.prepared.get(face).ok_or("source font metrics missing")?.metrics.height_26_6>>6;
        let space=self.glyph_for_text(sizes,text,32)?.metrics.advance;let mut error=None;
        let result=measure(contents,32,space,height,|character| {
            if let Err(value)=self.atlas_cell_for_text(sizes,text,character) {error=Some(value);return None}
            match self.glyph_for_text(sizes,text,character) {
            Ok(glyph)=>Some(node(character,&glyph.metrics,extra,flags).advance),
            Err(value)=>{error=Some(value);None}
        }});
        if let Some(error)=error {Err(error)}else{Ok(result)}
    }

    pub fn compose_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16,target:&mut openleague_font_raster::native_glyph::Target<'_>,x:i32,y:i32)->Result<(),String> {
        let glyph=self.glyph_for_text(sizes,text,character)?;
        openleague_font_raster::native_glyph::compose(glyph,target,x,y).map_err(|e|e.to_string())
    }
    pub fn kerning_for_text(&mut self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,left:u16,right:u16)->Result<i32,String> {
        let left=self.glyph_for_text(sizes,text,left)?.index;let right=self.glyph_for_text(sizes,text,right)?.index;
        let face=sizes.descriptor_bindings[text];
        self.faces[face].native_kerning(left,right).map_err(|e|e.to_string())
    }

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
pub fn prepare(hud:&crate::native_zip_provider::StartupHud,registry:&crate::native_font_descriptor::Registry,dpi:[u32;2])->Result<(Vec<Face>,Vec<Prepared>),String> {
    let mut faces=Vec::new();let mut prepared=Vec::new();
    for entry in &registry.entries {
        let name=String::from_utf16(&entry.descriptor.name).map_err(|_|"font descriptor UTF16 family invalid")?;
        let source=hud.shadow_isles_typefaces.iter().find(|f|f.family==name).ok_or_else(||format!("source face missing: {name}"))?;
        let mut face=Face::new(source.bytes.clone()).map_err(|e|e.to_string())?;
        if face.version()!=[2,4,8] {return Err("FreeType version differs from native contract".into());}
        let adjusted=face.fit(entry.descriptor.size,entry.descriptor.flags,dpi[0],dpi[1],10000).map_err(|e|e.to_string())?;
        let metrics=face.metrics().map_err(|e|e.to_string())?;
        prepared.push(Prepared {point_height_26_6:adjusted.height_26_6,adjustment_calls:adjusted.calls.len(),metrics});faces.push(face);
    }
    Ok((faces,prepared))
}
#[derive(SystemSet,Debug,Hash,PartialEq,Eq,Clone,Copy)]
pub struct MetricsSet;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Dpi>().init_non_send_resource::<Faces>().add_systems(Update,refresh.in_set(MetricsSet).after(crate::native_hud_font_creation::SizingSet));}
}
fn refresh(windows:Query<&Window,With<PrimaryWindow>>,hud:Res<crate::native_zip_provider::StartupHud>,sizes:Res<crate::native_hud_font_creation::Sizes>,dpi:Res<Dpi>,mut faces:NonSendMut<Faces>) {
    if windows.single().is_err() || sizes.height.is_none() || sizes.height==faces.height {return}
    let dpi=match dpi.explicit {Some(v)=>Ok(v),None=>select_dpi(true,desktop_dpi)};
    let result=dpi.and_then(|dpi|prepare(&hud,&sizes.descriptors,dpi).map(|(f,p)|(dpi,f,p)));
    match result {
        Ok((dpi,loaded,prepared))=> {faces.height=sizes.height;faces.dpi=Some(dpi);faces.glyphs=(0..loaded.len()).map(|_|BTreeMap::new()).collect();faces.atlases=(0..loaded.len()).map(|_|Default::default()).collect();faces.faces=loaded;faces.prepared=prepared;eprintln!("Native HUD FreeType version=2.4.8 dpi={}x{} faces={} source_texts={} metric_adjustment=true glyph_gpu=false widgets=false",dpi[0],dpi[1],faces.faces.len(),sizes.texts.len());}
        Err(error)=>eprintln!("Native HUD font metrics unavailable: {error}"),
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn dpi_policy_matches_all_32_original_branch_cases() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_dpi_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],32);
        for c in p["cases"].as_array().unwrap() {let mut called=false;let output=select_dpi(c["context"].as_bool().unwrap(),||{called=true;Ok([c["supplied_dpi"][0].as_u64().unwrap() as u32,c["supplied_dpi"][1].as_u64().unwrap() as u32])}).unwrap();assert_eq!(output.to_vec(),c["output_dpi"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());assert_eq!(called,c["context"].as_bool().unwrap());}
    }
    #[test] fn source_19_faces_retain_real_metrics_and_glyphs_across_window_resize() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));
        let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        for height in [800,1080,768] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1280,height);app.update();
            let sizes=app.world().resource::<crate::native_hud_font_creation::Sizes>();let prepared=app.world().non_send_resource::<Faces>();assert_eq!(prepared.height,Some(height));assert_eq!(prepared.dpi,Some([96,96]));assert_eq!(prepared.faces.len(),19);assert_eq!(prepared.prepared.len(),19);
            for (info,entry) in prepared.prepared.iter().zip(&sizes.descriptors.entries) {assert!(info.metrics.height_26_6>0 && (info.metrics.height_26_6>>6) as u32<=entry.descriptor.size);assert!(info.metrics.ascender_26_6>0 && info.metrics.descender_26_6<=0 && info.adjustment_calls>0 && info.point_height_26_6>0);}
            let mut prepared=app.world_mut().non_send_resource_mut::<Faces>();for face in &mut prepared.faces {let glyph=face.glyph('A',0,0).unwrap();assert!(glyph.pixels.iter().any(|v|*v>0));}
        }
    }
}

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

#[cfg(test)] mod source_atlas_tests {
    use super::*;
    #[test] fn source_font_atlases_bind_measurement_and_reset_on_resize() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        let mut gpu=crate::native_font_gpu::Pages::default();let mut assets=Assets::<Image>::default();let mut previous=Vec::new();
        for height in [800,1080,768] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1280,height);app.update();
            let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();assert_eq!(faces.atlases.len(),19);assert!(faces.atlases.iter().all(|bank|bank.pages.is_empty()));
            for text in 0..154 {
                faces.measure_for_text(&sizes,text,Some(&[65,32,86])).unwrap();
                let updated=faces.update_atlas_for_text(&sizes,text,0).unwrap();assert_eq!(updated.len(),256*256*4);assert!(updated.chunks_exact(4).all(|p|p[3]==255));assert!(updated.chunks_exact(4).any(|p|p[2]>0));
                let mut pixels=vec![0;256*256*4];faces.copy_atlas_for_text(&sizes,text,0,&mut pixels,256,0,0).unwrap();assert!(pixels.iter().any(|v|*v>0));
                let a=faces.atlas_cell_for_text(&sizes,text,65).unwrap();let repeated=faces.atlas_cell_for_text(&sizes,text,65).unwrap();assert_eq!(a,repeated);
                let face=sizes.descriptor_bindings[text];let bank=&faces.atlases[face];assert_eq!(bank.bindings.len(),2);assert!(!bank.bindings.contains_key(&32));assert_eq!(bank.pages.len(),1);assert_eq!(bank.pages[0].size,256);assert!(bank.pages[0].dirty);
                assert!(a.placement.uv.iter().all(|v|v.is_finite() && *v>=0. && *v<=1.));
            }
            assert!(faces.atlases.iter().all(|bank|bank.bindings.len()==2));
            assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),19);assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),0);
            for text in 0..154 {
                let material=gpu.material_for_text(&faces,&sizes,text,65,Handle::default(),Vec4::ONE,Vec4::ZERO,Vec4::new(0.,0.,1.,1.)).unwrap();
                let image=assets.get(&material.font).unwrap();assert_eq!(image.texture_descriptor.format,bevy::render::render_resource::TextureFormat::Bgra8Unorm);assert_eq!(image.data.as_ref().unwrap(),&faces.update_atlas_for_text(&sizes,text,0).unwrap());
                assert_eq!(material.parameters.uv.to_array(),faces.atlases[sizes.descriptor_bindings[text]].bindings[&65].placement.uv);
            }
            faces.atlas_cell_for_text(&sizes,0,233).unwrap();assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),1);assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),0);
            let current=gpu.banks.iter().flatten().map(Handle::id).collect::<Vec<_>>();assert_eq!(current.len(),19);assert!(current.iter().all(|id|!previous.contains(id)));previous=current;drop(faces);app.insert_resource(sizes);

        }
    }
}

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

#[cfg(test)] mod hud_wrapper_tests {
    use super::*;
    #[test] fn hud_wrapper_connects154_source_fonts_to_native_fixture_positions_and_colors() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
        let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
        let contract:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_draw_contract.json")).unwrap();
        for text in 0..154 {for alignment in 0..3 {
            let face=sizes.descriptor_bindings[text];let flags=sizes.descriptors.entries[face].descriptor.flags;
            let fixture=contract["cases"].as_array().unwrap().iter().find(|c|c["font_flags"].as_u64().unwrap()&4==(flags as u64)&4 && c["alignment"].as_u64()==Some(alignment) && c["rect"][0].as_f64()==Some(10.75) && c["color"].as_u64()==Some(0xffa1b2c3)).unwrap();
            let args=&fixture["draw_argument_bits"];let anchor=[f32::from_bits(args[1].as_u64().unwrap() as u32),f32::from_bits(args[2].as_u64().unwrap() as u32)];
            let geometry=faces.hud_text_geometry(&sizes,text,&[65,0,86],[10.75,7.25,91.5,46.5],alignment as u32,0xffa1b2c3,1.0).unwrap();
            assert_eq!(geometry.glyphs.len(),1);assert_eq!(geometry.glyphs[0].0,65);
            let width=geometry.dimensions[0];let adjustment=match alignment {0=>0,1=>width/2,_=>width};
            let bearing=faces.glyph_for_text(&sizes,text,65).unwrap().metrics.bearing_x;
            let ascender=faces.prepared[face].metrics.ascender_26_6>>6;
            let first=&geometry.glyphs[0].1.vertices[0];
            assert_eq!(first.position[0],(anchor[0]-adjustment as f32+bearing as f32).floor()-0.5);
            assert_eq!(first.position[1],(anchor[1]-ascender as f32).floor()-0.5);
            assert!(geometry.glyphs[0].1.vertices.iter().all(|v|v.colors==[0xffa1b2c3,0]));
        }}
        assert!(faces.hud_text_geometry(&sizes,154,&[65],[0.0;4],0,0,1.0).is_err());
    }
}
