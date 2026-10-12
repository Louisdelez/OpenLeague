from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_game_cfg_text.rs';text=p.read_text(encoding='utf-8')
marker='#[derive(Debug,PartialEq,Eq)]\npub struct TextLookup'
addition='''/// Native file-loader buffer is null for a zero-byte file; no parse occurs.
pub fn load_text_files(primary:Option<&[u8]>,baseline:Option<&[u8]>)->TextFiles {
 merge(primary.filter(|b|!b.is_empty()),baseline.filter(|b|!b.is_empty()))
}
'''
assert marker in text;text=text.replace(marker,addition+marker)
marker=' #[test] fn parser_matches_all_native_branch_fixtures()'
addition=''' #[test] fn native_complete_text_file_flow_matches_empty_missing_and_merge_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_text_file_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
  for c in proof["cases"].as_array().unwrap() {
   let bytes=|v:&serde_json::Value|v.as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let primary=bytes(&c["primary"]);let baseline=bytes(&c["baseline"]);let actual=load_text_files(primary.as_deref(),baseline.as_deref());
   assert_eq!(actual.loaded,c["loaded"].as_bool().unwrap());compare(&actual.parsed,&c["result"]);
  }
 }
'''
assert marker in text;text=text.replace(marker,addition+marker);p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_user_settings.rs';text=p.read_text(encoding='utf-8');text=text.replace('native_game_cfg_text::merge(user.as_deref(),baseline.as_deref())','native_game_cfg_text::load_text_files(user.as_deref(),baseline.as_deref())').replace('user_loaded:user.is_some()','user_loaded:user.as_ref().is_some_and(|b|!b.is_empty())').replace('default_loaded:baseline.is_some()','default_loaded:baseline.as_ref().is_some_and(|b|!b.is_empty())')
marker='  // Cleanup only the fixture directory created by this test.'
addition='''  std::fs::write(&initial.user_path,b"").unwrap();let empty=load(&root).unwrap();assert!(!empty.user_loaded && !empty.text_loaded);assert_eq!(empty.options.read(crate::native_graphics_options::ENVIRONMENT_ID).value,3);
'''
assert marker in text;text=text.replace(marker,addition+marker);p.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native zero-byte file load status connected; complete resource provider still open.')
