//! Source FontMappings adapter and strong engine font assets.
//! Native mapping parser/path search, font sizing and GPU glyph fidelity remain separate.
use std::{io,path::Path,collections::BTreeMap};
use bevy::prelude::*;
pub struct Typeface {pub family:String,pub path:String,pub bytes:Vec<u8>}
pub struct Mapping {pub family:String,pub file:String,pub bold:bool}
fn quoted(text:&str)->io::Result<(&str,&str)> {
    let text=text.trim_start().strip_prefix('"').ok_or_else(||io::Error::other("font mapping quoted field missing"))?;
    let end=text.find('"').ok_or_else(||io::Error::other("font mapping unterminated"))?;
    Ok((&text[..end],&text[end+1..]))
}
pub fn parse(bytes:&[u8])->io::Result<Vec<Mapping>> {
    let text=std::str::from_utf8(bytes).map_err(io::Error::other)?;let mut rows=Vec::new();
    for line in text.lines().map(str::trim).filter(|l|!l.is_empty()) {
        let (family,tail)=quoted(line)?;let (file,tail)=quoted(tail)?;
        let bold=match tail.trim() {""=>false,"bold"=>true,_=>return Err(io::Error::other("unqualified font mapping modifier"))};
        if family.is_empty() || file.is_empty() {return Err(io::Error::other("empty font mapping"));}
        if rows.iter().any(|r:&Mapping|r.family==family && r.bold==bold) {return Err(io::Error::other("ambiguous font mapping"));}
        rows.push(Mapping {family:family.to_owned(),file:file.to_owned(),bold});
    }
    Ok(rows)
}
pub fn resolve(root:&Path,family:&str,bold:bool)->io::Result<Typeface> {
    let mappings=parse(&std::fs::read(root.join("assets/fonts/native4.20/FontMappings.txt"))?)?;
    let row=mappings.iter().find(|r|r.family==family && r.bold==bold).ok_or_else(||io::Error::other(format!("source font mapping missing: {family}, bold={bold}")))?;
    let requested=row.file.replace('\\',"/");
    let requested=requested.strip_prefix("DATA/Fonts/").unwrap_or(&requested);
    if requested.split('/').any(|p|p==".." || p.is_empty()) {return Err(io::Error::other("invalid mapped font path"));}
    let catalog:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_hud_fonts_manifest.json"))?).map_err(io::Error::other)?;
    // Imported files have a unique basename. This adapter relocates declared files;
    // it does not infer missing fonts or claim the original directory-search algorithm.
    let matches=catalog["files"].as_array().ok_or_else(||io::Error::other("font inventory missing"))?.iter().filter(|r|r["path"].as_str().is_some_and(|p|p.rsplit('/').next().is_some_and(|n|n.eq_ignore_ascii_case(requested.rsplit('/').next().unwrap())))).collect::<Vec<_>>();
    if matches.len()!=1 {return Err(io::Error::other("mapped font missing or ambiguous in imported inventory"));}
    let path=matches[0]["path"].as_str().unwrap();
    if !path.starts_with("assets/fonts/native4.20/") || path.contains("..") || path.contains('\\') {return Err(io::Error::other("invalid imported font path"));}
    let bytes=std::fs::read(root.join(path))?;
    if Some(bytes.len() as u64)!=matches[0]["bytes"].as_u64() {return Err(io::Error::other("imported font size differs from inventory"));}
    Ok(Typeface {family:family.to_owned(),path:path.to_owned(),bytes})
}
pub fn selected(root:&Path,maps:&[Option<crate::native_hud_normal_font::Entry>])->io::Result<Vec<Typeface>> {
    let family=crate::native_hud_normal_font::normal_font(maps).map_err(io::Error::other)?.ok_or_else(||io::Error::other("NormalFont unavailable"))?;
    let family=std::str::from_utf8(family).map_err(io::Error::other)?;
    Ok(vec![resolve(root,family,false)?])
}
#[derive(Resource,Default)]
pub struct Fonts {pub handles:BTreeMap<String,Handle<Font>>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Fonts>().add_systems(Startup,register);}
}
fn register(hud:Res<crate::native_zip_provider::StartupHud>,mut fonts:ResMut<Assets<Font>>,mut registered:ResMut<Fonts>) {
    for face in &hud.shadow_isles_typefaces {
        let handle=fonts.add(Font::from_bytes(face.bytes.clone()));
        registered.handles.insert(face.family.clone(),handle);
        eprintln!("Native HUD font asset family={} path={} bytes={} glyphs_verified=false widgets=false",face.family,face.path,face.bytes.len());
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn source_mapping_fonts_for_all_locale_profiles_are_accepted_by_engine() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_font_configuration_manifest.json")).unwrap()).unwrap();
        let mut families=std::collections::BTreeSet::new();
        for row in catalog["configurations"].as_array().unwrap() {
            let config=crate::native_hud_font_configuration::parse(&std::fs::read(root.join(row["path"].as_str().unwrap())).unwrap()).unwrap();
            let face=selected(&root,&config.maps).unwrap().remove(0);families.insert(face.family.clone());
            let font=Font::from_bytes(face.bytes);let mut context=bevy::text::FontCx::default();
            assert!(!context.collection.register_fonts(font.data.clone(),None).is_empty(),"{}",face.path);
        }
        assert_eq!(families.len(),5);
        for row in parse(&std::fs::read(root.join("assets/fonts/native4.20/FontMappings.txt")).unwrap()).unwrap() {
            let face=resolve(&root,&row.family,row.bold).unwrap();let font=Font::from_bytes(face.bytes);let mut context=bevy::text::FontCx::default();
            assert!(!context.collection.register_fonts(font.data,None).is_empty(),"{}",face.path);
        }
        assert!(resolve(&root,"missing family",false).is_err());
        assert!(parse(b"\"A\" \"a.ttf\"\n\"A\" \"b.ttf\"").is_err());
    }
    #[test] fn startup_registers_real_source_font_and_keeps_handle_alive() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();
        let hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.shadow_isles_typefaces.len(),1);
        let expected=hud.shadow_isles_typefaces[0].bytes.len();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Assets::<Font>::default()).add_plugins(Plugin);app.update();
        let handles=&app.world().resource::<Fonts>().handles;assert_eq!(handles.len(),1);
        let font=app.world().resource::<Assets<Font>>().get(&handles["Gill Sans MT Pro Medium"]).unwrap();
        assert_eq!(font.data.as_ref().len(),expected);
        let mut context=bevy::text::FontCx::default();assert!(!context.collection.register_fonts(font.data.clone(),None).is_empty());
    }
}
