//! Qualified default-language Game.cfg path/selection and text-file startup.
//! OpenLeague supplies its project root; layout classifier is qualified.
//! Configuration cache, INIBIN overlays and localized filenames remain open.
use std::path::{Path,PathBuf};
use crate::{native_game_cfg_text,native_graphics_options::{IntegerOptions,ConfigurationPair,ValueSources,read_integer_value,ENVIRONMENT_SECTION,ENVIRONMENT_KEY}};
fn legacy_base(root:&[u8])->Vec<u8> {
 let mut out=Vec::new();
 for &byte in root.iter().take(259) {let byte=if byte==b'\\' {b'/'}else{byte};if byte==b'/' && out.len()>1 && out.last()==Some(&b'/') {continue;}out.push(byte);}
 let needle=b"/RADS";
 if let Some(index)=out.windows(needle.len()).position(|w|w.eq_ignore_ascii_case(needle)) {
  if out.get(index+5).is_none() || out.get(index+5)==Some(&b'/') {out.truncate(index);}
 }
 out
}
pub fn directory(root:&[u8],mode:u32,access_result:i32)->Vec<u8> {
 if mode==2 || access_result!=0 {return b"DATA/CFG/".to_vec();}
 let mut out=root.to_vec();out.extend_from_slice(b"/Config/");out
}
pub fn user_path(root:&[u8],mode:u32,access_result:i32)->Vec<u8> {let base=if mode==0 {legacy_base(root)}else{root.to_vec()};let mut path=directory(&base,mode,access_result);path.extend_from_slice(b"Game.cfg");path}
pub fn should_migrate(source:&[u8],destination:&[u8],source_attributes:i32,destination_attributes:i32)->bool {
 source!=destination && (destination_attributes==-1 || destination_attributes&16!=0) && source_attributes!=-1 && source_attributes&16==0
}
#[cfg(windows)] fn write_access(path:&Path)->std::io::Result<i32> {
 unsafe extern "C" {fn _access(path:*const std::ffi::c_char,mode:i32)->i32;}
 let text=path.to_str().ok_or_else(||std::io::Error::other("configuration path is not UTF-8"))?;
 // Project root is ASCII; historical CRT path encoding for non-ASCII remains open.
 if !text.is_ascii() {return Err(std::io::Error::other("unqualified non-ASCII historical configuration path"));}
 let path=std::ffi::CString::new(text).map_err(std::io::Error::other)?;
 Ok(unsafe {_access(path.as_ptr(),2)})
}
#[cfg(not(windows))] fn write_access(path:&Path)->std::io::Result<i32> {Ok(if path.metadata().map(|m|!m.permissions().readonly()).unwrap_or(false) {0}else{-1})}
fn attributes(path:&Path)->i32 {match path.metadata() {Ok(m) if m.is_dir()=>16,Ok(_)=>0,Err(_)=>-1}}
#[derive(bevy::prelude::Resource)]
pub struct Loaded {pub options:IntegerOptions,pub default_path:PathBuf,pub user_path:PathBuf,pub user_loaded:bool,pub parse_warnings:usize,pub layout_mode:u32,pub layout_scores:[i32;3]}
fn environment(parsed:&native_game_cfg_text::Parsed)->Option<i32> {
 let hash=native_game_cfg_text::key_hash(ENVIRONMENT_SECTION.as_bytes(),ENVIRONMENT_KEY.as_bytes());
 parsed.value(ENVIRONMENT_SECTION.as_bytes(),ENVIRONMENT_KEY.as_bytes()).map(|value| {
  debug_assert_eq!(parsed.lookup(hash,None).value,value);
  read_integer_value(IntegerOptions::environment_default(),ValueSources {binary_enabled:false,typed_enabled:false,text_enabled:true,typed:None,text:Some(value)},|_|{}).value
 })
}
fn parse_file(path:&Path)->std::io::Result<native_game_cfg_text::Parsed> {
 let parsed=native_game_cfg_text::parse(&std::fs::read(path)?,0);
 if let Some(error)=parsed.error {return Err(std::io::Error::other(format!("Game.cfg parser failed: {error}")));}
 Ok(parsed)
}
pub fn load(root:&Path)->std::io::Result<Loaded> {
 let root=root.canonicalize()?;let raw=root.to_str().ok_or_else(||std::io::Error::other("invalid project root"))?;
 let raw=raw.strip_prefix("\\\\?\\").unwrap_or(raw);
 let layout=crate::native_config_layout::classify(raw.as_bytes(),|marker|attributes(&root.join(marker)));
 let base=if layout.mode==0 {legacy_base(raw.as_bytes())}else{raw.as_bytes().to_vec()};
 let candidate=directory(&base,layout.mode,0);let candidate=PathBuf::from(std::str::from_utf8(&candidate).map_err(std::io::Error::other)?);
 let config_directory=if candidate.is_absolute() {candidate}else{root.join(candidate)};
 let access_result=if layout.mode==2 {-1}else{let _=std::fs::create_dir(&config_directory);write_access(&config_directory)?};
 let selected=user_path(raw.as_bytes(),layout.mode,access_result);
 let selected=std::str::from_utf8(&selected).map_err(std::io::Error::other)?;let selected=PathBuf::from(selected);
 let user_path=if selected.is_absolute() {selected}else{root.join(selected)};
 let source=root.join("DATA/CFG/Game.cfg");
 if should_migrate(source.to_string_lossy().as_bytes(),user_path.to_string_lossy().as_bytes(),attributes(&source),attributes(&user_path)) {let _=std::fs::rename(&source,&user_path);}
 let default_path=root.join("data/4.20/configuration/defaults/Game.cfg");let baseline=parse_file(&default_path)?;
 let user=match parse_file(&user_path) {Ok(parsed)=>Some(parsed),Err(e) if e.kind()==std::io::ErrorKind::NotFound=>None,Err(e)=>return Err(e)};
 let warnings=baseline.warnings+user.as_ref().map(|p|p.warnings).unwrap_or(0);
 let options=IntegerOptions::from_environment_configuration(ConfigurationPair {primary:environment(&baseline),overlay:None},ConfigurationPair {primary:user.as_ref().and_then(environment),overlay:None});
 Ok(Loaded {options,default_path,user_path,user_loaded:user.is_some(),parse_warnings:warnings,layout_mode:layout.mode,layout_scores:layout.scores})
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_directory_choices_match_all_recorded_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_user_config_directory_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],45);
  for c in proof["cases"].as_array().unwrap() {assert_eq!(directory(c["base"].as_str().unwrap().as_bytes(),c["mode"].as_u64().unwrap() as u32,c["access_result"].as_i64().unwrap() as i32),c["directory"].as_str().unwrap().as_bytes());}
 }
 #[test] fn native_default_language_initialization_and_migration_match_all_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_user_config_initializer_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],648);
  for c in proof["cases"].as_array().unwrap() {
   let path=user_path(c["root"].as_str().unwrap().as_bytes(),c["mode"].as_u64().unwrap() as u32,c["access_result"].as_i64().unwrap() as i32);assert_eq!(path,c["path"].as_str().unwrap().as_bytes());
   let expected=c["calls"].as_array().unwrap().iter().any(|call|call["kind"]=="rename");assert_eq!(should_migrate(b"DATA/CFG/Game.cfg",&path,c["source_attributes"].as_i64().unwrap() as i32,c["destination_attributes"].as_i64().unwrap() as i32),expected);
  }
 }
 #[test] fn files_on_disk_override_defaults_migrate_and_report_invalid_input() {
  let root=std::env::temp_dir().join(format!("openleague-native-settings-{}-{}",std::process::id(),std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos()));
  std::fs::create_dir_all(root.join("data/4.20/configuration/defaults")).unwrap();std::fs::create_dir_all(root.join("DATA/CFG")).unwrap();
  std::fs::write(root.join("data/4.20/configuration/defaults/Game.cfg"),include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg")).unwrap();
  let initial=load(&root).unwrap();assert!(!initial.user_loaded);assert_eq!(initial.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,3);
  std::fs::write(&initial.user_path,b"[Performance]\nEnvironmentQuality=1\nEnvironmentQuality=4\n").unwrap();let user=load(&root).unwrap();assert!(user.user_loaded);assert_eq!(user.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,1);assert_eq!(user.parse_warnings,1);
  std::fs::remove_file(&initial.user_path).unwrap();std::fs::write(root.join("DATA/CFG/Game.cfg"),b"[Performance]\nEnvironmentQuality=2\n").unwrap();let migrated=load(&root).unwrap();assert!(migrated.user_loaded);assert_eq!(migrated.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,2);assert!(!root.join("DATA/CFG/Game.cfg").exists());
  std::fs::write(&initial.user_path,b"[Performance]\n\t\t=4\n").unwrap();assert!(load(&root).is_err());
  // Cleanup only the fixture directory created by this test.
  let cleanup=root.canonicalize().unwrap();let fixture_parent=std::env::temp_dir().canonicalize().unwrap();
  assert_eq!(cleanup.parent(),Some(fixture_parent.as_path()));assert!(cleanup.file_name().unwrap().to_string_lossy().starts_with("openleague-native-settings-"));
  std::fs::remove_dir_all(&cleanup).unwrap();
 }
}
