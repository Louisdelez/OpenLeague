from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_graphics_options.rs';s=p.read_text(encoding='utf-8');archive=r/'docs/plan_history'/('native-value-reader-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True);shutil.copy2(p,archive/p.name)
block='''#[derive(Clone,Copy)] pub struct ValueSources<'a> {pub binary_enabled:bool,pub typed_enabled:bool,pub text_enabled:bool,pub typed:Option<i32>,pub text:Option<&'a [u8]>}
#[derive(Debug,PartialEq,Eq)] pub struct ValueRead {pub value:i32,pub found:bool}
#[derive(Debug,PartialEq,Eq)] pub enum ValueLayer {Typed,Text}
pub fn read_integer_value(default:i32,sources:ValueSources<'_>,mut record:impl FnMut(ValueLayer))->ValueRead {
 if !sources.text_enabled {
  if sources.binary_enabled {record(ValueLayer::Typed);if let Some(value)=sources.typed {return ValueRead {value,found:true};}}
  return ValueRead {value:default,found:false};
 }
 let mut fallback=default;let mut found=false;
 if sources.typed_enabled {record(ValueLayer::Typed);if let Some(value)=sources.typed {fallback=value;found=true;}}
 record(ValueLayer::Text);
 if let Some(text)=sources.text {
  let numeric=parse_integer_prefix(text).value;
  let value=if numeric==0 && text.eq_ignore_ascii_case(b"true") {1}else{numeric};
  ValueRead {value,found:true}
 } else {ValueRead {value:fallback,found}}
}
'''
s=s.replace('pub struct IntegerOptions {',block+'pub struct IntegerOptions {')
test='''
 #[test] fn typed_text_enabled_routes_and_literal_true_match_original_integer_reader() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_integer_value_reader_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1440);
  for c in proof["cases"].as_array().unwrap() {
   let text=c["text"].as_array().map(|a|a.iter().map(|b|b.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let sources=ValueSources {binary_enabled:c["binary_enabled"].as_bool().unwrap(),typed_enabled:c["typed_enabled"].as_bool().unwrap(),text_enabled:c["text_enabled"].as_bool().unwrap(),typed:c["typed"].as_i64().map(|v|v as i32),text:text.as_deref()};
   let mut trace=Vec::new();let actual=read_integer_value(c["default"].as_i64().unwrap() as i32,sources,|layer|trace.push(match layer {ValueLayer::Typed=>"typed",ValueLayer::Text=>"text"}));
   assert_eq!(actual.value,c["value"].as_i64().unwrap() as i32);assert_eq!(actual.found,c["found"].as_bool().unwrap());
   let expected:Vec<&str>=c["reads"].as_array().unwrap().iter().map(|v|v.as_str().unwrap()).collect();assert_eq!(trace,expected);
  }
 }
'''
pos=s.rfind('\n}');s=s[:pos]+test+s[pos:];p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native integer reader branches, success flag and literal-true fallback ported')
