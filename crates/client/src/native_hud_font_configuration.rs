//! Loader for the observed supplied4.20fontconfig source profile.
//! Full native parser/locale override/library alias behavior remains separate.
use std::{io,path::Path};
use crate::native_hud_normal_font::{Entry,FontMap};
pub struct Configuration {pub maps:Vec<Option<Entry>>,pub libraries:Vec<String>}
pub struct Loaded {pub locale:String,pub path:String,pub configuration:Configuration}
fn quoted(text:&str)->Result<(&str,&str),&'static str> {
    let text=text.trim_start().strip_prefix('"').ok_or("fontconfig quoted field missing")?;
    let end=text.find('"').ok_or("fontconfig quoted field unterminated")?;
    let value=&text[..end];if value.contains('\\') {return Err("unqualified escaped fontconfig field");}
    Ok((value,&text[end+1..]))
}
pub fn parse(bytes:&[u8])->Result<Configuration,&'static str> {
    let text=std::str::from_utf8(bytes).map_err(|_|"unqualified fontconfig encoding")?.trim_start_matches('\u{feff}');
    let mut map=FontMap::new();let mut libraries=Vec::new();let mut header=false;
    for line in text.lines().map(str::trim) {
        if line.is_empty() || line.starts_with(';') || line.starts_with('#') {continue;}
        if let Some(rest)=line.strip_prefix("[FontConfig ") {
            if header {return Err("unqualified multiple fontconfig sections");}
            let (_,tail)=quoted(rest)?;if tail.trim()!="]" {return Err("unqualified fontconfig header");}header=true;
        } else if let Some(rest)=line.strip_prefix("map ") {
            if !header {return Err("font map outside section");}
            let (alias,tail)=quoted(rest)?;let tail=tail.trim_start().strip_prefix('=').ok_or("font map assignment missing")?;let (name,tail)=quoted(tail)?;
            if !tail.trim().is_empty() || !alias.is_ascii() {return Err("unqualified font map flags/alias");}
            if map.keys().any(|k|k.eq_ignore_ascii_case(alias.as_bytes())) {return Err("unqualified repeated font alias");}
            map.insert(alias.as_bytes().to_vec(),name.as_bytes().to_vec());
        } else if let Some(rest)=line.strip_prefix("fontlib ") {
            let (library,tail)=quoted(rest)?;if !header || !tail.trim().is_empty() {return Err("unqualified font library directive");}libraries.push(library.to_owned());
        } else if line.starts_with("tr ") {
            // Translation records are preserved on disk; their parser is a separate domain.
            if !header {return Err("translation outside fontconfig section");}
        } else {return Err("unqualified fontconfig directive");}
    }
    if !header || map.len()!=4 || libraries.len()!=1 {return Err("unqualified supplied fontconfig profile");}
    Ok(Configuration {maps:vec![Some(Entry {font_map:Some(map)})],libraries})
}
pub fn load(root:&Path)->io::Result<Loaded> {
    let bytes=std::fs::read(root.join("data/4.20/font_configuration/locale.cfg"))?;
    let locale=crate::native_game_cfg_text::parse(&bytes,0);
    if locale.error.is_some() || locale.warnings!=0 {return Err(io::Error::other("source locale configuration invalid"));}
    let locale=locale.entries.iter().find(|e|e.section.eq_ignore_ascii_case(b"General") && e.key.eq_ignore_ascii_case(b"LanguageLocaleRegion")).ok_or_else(||io::Error::other("source language missing"))?;
    // The qualified INI byte storage can retain its terminal NUL on a final line.
    // Native consumers receive c_str(), so the locale name ends at that NUL.
    let value=locale.value.split(|&b|b==0).next().unwrap_or_default();
    let locale=std::str::from_utf8(value).map_err(io::Error::other)?.to_owned();
    let catalog:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_font_configuration_manifest.json"))?).map_err(io::Error::other)?;
    let row=catalog["configurations"].as_array().ok_or_else(||io::Error::other("font catalog missing"))?.iter().find(|c|c["locale"].as_str().is_some_and(|v|v.eq_ignore_ascii_case(&locale))).ok_or_else(||io::Error::other("source locale fontconfig unavailable"))?;
    let path=row["path"].as_str().ok_or_else(||io::Error::other("fontconfig path missing"))?.to_owned();
    if !path.starts_with("data/4.20/font_configuration/menu/fontconfig_") || path.contains("..") || path.contains('\\') {return Err(io::Error::other("invalid fontconfig path"));}
    let configuration=parse(&std::fs::read(root.join(&path))?).map_err(io::Error::other)?;
    Ok(Loaded {locale,path,configuration})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_nineteen_actual_source_font_tables_match_independent_inventory() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let catalog:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_font_configuration_manifest.json")).unwrap()).unwrap();assert_eq!(catalog["configuration_count"],19);
        for c in catalog["configurations"].as_array().unwrap() {
            let config=parse(&std::fs::read(root.join(c["path"].as_str().unwrap())).unwrap()).unwrap();
            let map=config.maps[0].as_ref().unwrap().font_map.as_ref().unwrap();assert_eq!(map.len(),4);
            for pair in c["maps"].as_array().unwrap(){assert_eq!(crate::native_hud_normal_font::lookup(map,pair["alias"].as_str().unwrap().as_bytes()).unwrap().unwrap(),pair["name"].as_str().unwrap().as_bytes());}
            assert_eq!(crate::native_hud_normal_font::normal_font(&config.maps).unwrap().unwrap(),c["normal_font"].as_str().unwrap().as_bytes());
            assert_eq!(config.libraries,c["fontlibs"].as_array().unwrap().iter().map(|v|v.as_str().unwrap().to_owned()).collect::<Vec<_>>());
        }
        let loaded=load(&root).unwrap();assert_eq!(loaded.locale,"en_GB");assert_eq!(crate::native_hud_normal_font::normal_font(&loaded.configuration.maps).unwrap().unwrap(),b"Gill Sans MT Pro Medium");
    }
}
