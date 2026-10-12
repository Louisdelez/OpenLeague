from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');source='''//! Qualified native integer option read and EnvironmentQuality identity/default.
//! Original INI parser, option UI and complete settings initialization remain open.
use std::collections::BTreeMap;
pub const ENVIRONMENT_ID:i32=16;
pub const ENVIRONMENT_SECTION:&str="Performance";
pub const ENVIRONMENT_KEY:&str="EnvironmentQuality";
#[derive(Debug,PartialEq,Eq)] pub struct Read {pub value:i32,pub assertion_required:bool}
pub struct IntegerOptions {values:BTreeMap<i32,i32>}
impl IntegerOptions {
 pub fn from_values(values:impl IntoIterator<Item=(i32,i32)>)->Self {Self {values:values.into_iter().collect()}}
 pub fn read(&self,id:i32)->Read {match self.values.get(&id) {Some(&value)=>Read {value,assertion_required:false},None=>Read {value:0,assertion_required:true}}}
 pub fn environment_default()->i32 {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_graphics_options_contract.json")).expect("native graphics option evidence");
  assert_eq!(proof["environment"]["id"],ENVIRONMENT_ID);
  assert_eq!(proof["environment"]["section"],ENVIRONMENT_SECTION);
  assert_eq!(proof["environment"]["key"],ENVIRONMENT_KEY);
  proof["environment"]["default"].as_i64().expect("native integer default") as i32
 }
}
impl Default for IntegerOptions {fn default()->Self {Self::from_values([(ENVIRONMENT_ID,Self::environment_default())])}}
#[cfg(test)] mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/native_graphics_options_contract.json")).unwrap()}
 #[test] fn signed_integer_option_reads_and_missing_assertion_match_original_tree_cases() {
  let proof=proof();assert_eq!(proof["passed"],true);assert_eq!(proof["getter_case_count"],126);
  for c in proof["getter_cases"].as_array().unwrap() {
   let values=c["entries"].as_array().unwrap().iter().map(|e|(e["id"].as_i64().unwrap() as i32,e["value"].as_i64().unwrap() as i32));
   let read=IntegerOptions::from_values(values).read(c["id"].as_i64().unwrap() as i32);
   assert_eq!(read.value,c["value"].as_i64().unwrap() as i32);assert_eq!(read.assertion_required,c["missing"].as_bool().unwrap());
  }
 }
 #[test] fn environment_identity_default_and_dispatch_match_original_cases() {
  let proof=proof();let actual=IntegerOptions::default().read(ENVIRONMENT_ID);assert_eq!(actual,Read {value:3,assertion_required:false});
  for c in proof["name_cases"].as_array().unwrap().iter().filter(|c|c["id"]==ENVIRONMENT_ID) {assert_eq!(c["name"],ENVIRONMENT_KEY);}
  for c in proof["default_cases"].as_array().unwrap() {assert_eq!(c["request"]["section"],ENVIRONMENT_SECTION);assert_eq!(c["request"]["key"],ENVIRONMENT_KEY);assert_eq!(c["request"]["default"],actual.value);assert_eq!(c["stored_id"],ENVIRONMENT_ID);}
  assert_eq!(proof["dispatch_cases"].as_array().unwrap().iter().find(|c|c["id"]==ENVIRONMENT_ID).unwrap()["target"],"0x837630");
 }
}
'''
archive=r/'docs/plan_history'/('native-graphics-options-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
p=r/'crates/client/src/native_graphics_options.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/client/src/main.rs';shutil.copy2(p,archive/'main.rs');s=p.read_text(encoding='utf-8');p.write_text('mod native_graphics_options;\n'+s,encoding='utf-8')
p=r/'crates/client/src/native_environment_draw.rs';shutil.copy2(p,archive/p.name);s=p.read_text(encoding='utf-8');start=s.index('impl Default for Quality {');end=s.index('\nimpl Quality',start)
s=s[:start]+'''impl Default for Quality {fn default()->Self {let option=crate::native_graphics_options::IntegerOptions::default().read(crate::native_graphics_options::ENVIRONMENT_ID);assert!(!option.assertion_required,"native environment default missing");Self {value:option.value,revision:0}}}'''+s[end:];p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native integer option reads and environment default integrated; original configuration parsing/UI remain open')
