from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
p=r/'crates/client/src/native_game_cfg_text.rs';text=p.read_text(encoding='utf-8')
old='''pub fn parse(bytes:&[u8],flag:u32)->Parsed {
 let mut data=bytes.to_vec();data.push(0);
 let mut parsed=Parsed::default();let mut section=Vec::new();let mut cursor=0;let mut hashes=BTreeMap::new();'''
new='''pub fn parse(bytes:&[u8],flag:u32)->Parsed {parse_into(bytes,flag,Parsed::default())}
fn parse_into(bytes:&[u8],flag:u32,mut parsed:Parsed)->Parsed {
 if parsed.error.is_some() {return parsed;}
 let mut data=bytes.to_vec();data.push(0);
 let mut section=Vec::new();let mut cursor=0;let mut hashes:BTreeMap<u32,usize>=parsed.entries.iter().enumerate().map(|(i,e)|(e.hash,i)).collect();'''
assert old in text;text=text.replace(old,new)
marker='#[derive(Debug,PartialEq,Eq)]\npub struct TextLookup'
addition='''#[derive(Debug,PartialEq,Eq)]
pub struct TextFiles {pub parsed:Parsed,pub loaded:bool}
pub fn merge(primary:Option<&[u8]>,baseline:Option<&[u8]>)->TextFiles {
 let mut parsed=Parsed::default();
 if let Some(bytes)=primary {parsed=parse_into(bytes,0,parsed);}
 if let Some(bytes)=baseline {parsed=parse_into(bytes,1,parsed);}
 TextFiles {parsed,loaded:primary.is_some() || baseline.is_some()}
}
'''
assert marker in text;text=text.replace(marker,addition+marker)
marker=' #[test] fn parser_matches_all_native_branch_fixtures()'
addition=''' #[test] fn native_two_file_merge_matches_all_original_wrapper_and_parser_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_text_merge_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
  for c in proof["cases"].as_array().unwrap() {
   let bytes=|v:&serde_json::Value|v.as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let primary=bytes(&c["primary"]);let baseline=bytes(&c["baseline"]);let actual=merge(primary.as_deref(),baseline.as_deref());
   assert_eq!(actual.loaded,c["opened"].as_bool().unwrap());compare(&actual.parsed,&c["result"]);
  }
 }
'''
assert marker in text;text=text.replace(marker,addition+marker);p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_user_settings.rs';text=p.read_text(encoding='utf-8')
text=text.replace('pub layout_mode:u32,pub layout_scores:[i32;3]}','pub layout_mode:u32,pub layout_scores:[i32;3],pub default_loaded:bool,pub text_loaded:bool,pub text:native_game_cfg_text::Parsed}')
start=text.index('fn parse_file(');end=text.index('pub fn load(',start)
text=text[:start]+'''fn read_optional(path:&Path)->std::io::Result<Option<Vec<u8>>> {
 match std::fs::read(path) {Ok(bytes)=>Ok(Some(bytes)),Err(e) if e.kind()==std::io::ErrorKind::NotFound=>Ok(None),Err(e)=>Err(e)}
}
'''+text[end:]
start=text.index(' let default_path=root.join(');end=text.index('\n}\n#[cfg(test)]',start)
text=text[:start]+''' let default_path=root.join("data/4.20/configuration/defaults/Game.cfg");
 let user=read_optional(&user_path)?;let baseline=read_optional(&default_path)?;
 let merged=native_game_cfg_text::merge(user.as_deref(),baseline.as_deref());
 if let Some(error)=merged.parsed.error {return Err(std::io::Error::other(format!("Game.cfg parser failed: {error}")));}
 let options=IntegerOptions::from_environment_configuration(ConfigurationPair {primary:None,overlay:None},ConfigurationPair {primary:environment(&merged.parsed),overlay:None});
 Ok(Loaded {options,default_path,user_path,user_loaded:user.is_some(),parse_warnings:merged.parsed.warnings,layout_mode:layout.mode,layout_scores:layout.scores,default_loaded:baseline.is_some(),text_loaded:merged.loaded,text:merged.parsed})'''+text[end:]
old='let initial=load(&root).unwrap();assert!(!initial.user_loaded);'
new='let initial=load(&root).unwrap();assert!(!initial.user_loaded);assert!(initial.default_loaded && initial.text_loaded);assert_eq!(initial.text.entries.len(),387);'
assert old in text;text=text.replace(old,new)
marker='  // Cleanup only the fixture directory created by this test.'
addition='''  std::fs::remove_file(&initial.user_path).unwrap();std::fs::remove_file(&initial.default_path).unwrap();
  let absent=load(&root).unwrap();assert!(!absent.text_loaded && !absent.default_loaded && !absent.user_loaded);assert_eq!(absent.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,3);
  std::fs::write(&initial.user_path,b"[Performance]\\nEnvironmentQuality=4\\n").unwrap();let user_only=load(&root).unwrap();assert!(user_only.text_loaded && user_only.user_loaded && !user_only.default_loaded);assert_eq!(user_only.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,4);
'''
assert marker in text;text=text.replace(marker,addition+marker);p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8');old='''eprintln!("Game.cfg defaults={} user={} loaded={} parser_warnings={} environment_quality={}",settings.default_path.display(),settings.user_path.display(),settings.user_loaded,settings.parse_warnings,quality.value);''';new='''eprintln!("Game.cfg defaults={} user={} loaded={} parser_warnings={} environment_quality={}",settings.default_path.display(),settings.user_path.display(),settings.user_loaded,settings.parse_warnings,quality.value);
    eprintln!("Game.cfg text_loaded={} defaults_loaded={} merged_entries={}",settings.text_loaded,settings.default_loaded,settings.text.entries.len());'''
assert old in text;text=text.replace(old,new);p.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native user-first/default-second merge connected to actual startup files.')
