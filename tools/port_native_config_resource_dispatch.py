from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
for name in ['native_config_resource_dispatch','native_config_path_parts']:
 shutil.copy2(stage/(name+'.rs'),r/'crates/client/src'/(name+'.rs'))
 p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8');marker='mod '+name+';'
 if marker not in text:text=marker+'\n'+text
 p.write_text(text,encoding='utf-8');shutil.copy2(stage/(name+'.rs'),r/'tools'/(name+'.rs'))
p=r/'crates/client/src/native_config_cache_reload.rs';text=p.read_text(encoding='utf-8');marker='#[cfg(test)] mod tests {'
addition='''/// Resolve native metadata and resource status before building the call plan.
pub fn plan_with_resources(requested:&[u8],locale:Option<&[u8]>,mut status:impl FnMut(&[u8])->i32)->Result<ReloadPlan,&'static str> {
 let requested=cbytes(requested);let parts=crate::native_config_path_parts::split(&normalize(requested),b"");
 let mut predicates=[true,true];
 if let Some(locale)=locale.filter(|_|!parts.extension.is_empty()) {
  let cut=requested.len().checked_sub(parts.extension.len()+1).ok_or("unqualified locale suffix")?;
  let mut candidate=requested[..cut].to_vec();candidate.push(b'_');candidate.extend_from_slice(cbytes(locale));candidate.extend_from_slice(&requested[cut..]);
  predicates[0]=status(&candidate)!=0;
  if predicates[0] {candidate.extend_from_slice(b"bin");predicates[1]=status(&candidate)!=0;}
 }
 plan(requested,&parts.prefix,&parts.name,&parts.extension,locale,predicates)
}
'''
assert marker in text;text=text.replace(marker,addition+marker)
marker=' #[test] fn native_reload_constructor_arguments_and_locale_queries_match_all_cases()'
addition=''' #[test] fn connected_path_split_and_resource_status_match_native_reload_calls() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_cache_reload_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);
  for c in proof["cases"].as_array().unwrap().iter().filter(|c|c["reloaded"]==true) {
   let mut queries=Vec::new();let mut index=0;
   let actual=plan_with_resources(c["requested"].as_str().unwrap().as_bytes(),c["locale"].as_str().map(str::as_bytes),|path| {queries.push(path.to_vec());let value=c["locale_predicates"][index].as_bool().unwrap();index+=1;i32::from(value)}).unwrap();
   let mut args=vec![actual.primary];if let Some(overlay)=actual.overlay {args.push(overlay)}
   let expected:Vec<[Vec<u8>;3]>=c["constructors"].as_array().unwrap().iter().map(|a|std::array::from_fn(|i|a[i].as_str().unwrap().as_bytes().to_vec())).collect();assert_eq!(args,expected,"{c}");
   let expected_queries:Vec<Vec<u8>>=c["locale_queries"].as_array().unwrap().iter().map(|a|a.as_str().unwrap().as_bytes().to_vec()).collect();assert_eq!(queries,expected_queries,"{c}");assert_eq!(actual.localized_queries,expected_queries,"{c}");
  }
 }
'''
assert marker in text;text=text.replace(marker,addition+marker);p.write_text(text,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Resource dispatch/path split ported and connected to reload call planning; actual providers/cache ownership remain open.')
