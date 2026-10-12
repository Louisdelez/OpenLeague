//! Qualified native integer option read and EnvironmentQuality identity/default.
//! Native text parser is separately qualified; cache, user file, UI and complete initialization remain open.
use std::collections::BTreeMap;
pub const ENVIRONMENT_ID:i32=16;
pub const ENVIRONMENT_SECTION:&str="Performance";
pub const ENVIRONMENT_KEY:&str="EnvironmentQuality";
#[derive(Debug,PartialEq,Eq)] pub struct Read {pub value:i32,pub assertion_required:bool}
// None overlay means no overlay object; Some(None) is an existing object with
// no matching value. Keeping this distinction preserves native read ordering.
#[derive(Clone,Copy,Default)] pub struct ConfigurationPair {pub primary:Option<i32>,pub overlay:Option<Option<i32>>}
#[derive(Debug,PartialEq,Eq)] pub struct LayerRead {pub layer:u32,pub default:i32,pub found:bool,pub result:i32}
pub fn resolve_configuration(default:i32,baseline:ConfigurationPair,user:ConfigurationPair,mut record:impl FnMut(LayerRead))->i32 {
 let mut result=default;
 for (offset,pair) in [(0,baseline),(2,user)] {
  if let Some(value)=pair.overlay {
   record(LayerRead {layer:offset+1,default:result,found:value.is_some(),result:value.unwrap_or(result)});
   if let Some(value)=value {result=value;continue;}
  }
  record(LayerRead {layer:offset,default:result,found:pair.primary.is_some(),result:pair.primary.unwrap_or(result)});
  if let Some(value)=pair.primary {result=value;}
 }
 result
}
// Original CRT C-locale decimal conversion. This numeric stage does not
// include the configuration reader's separate literal-true fallback.
#[derive(Debug,PartialEq,Eq)] pub struct NumericConversion {pub value:i32,pub range_error:bool}
pub fn parse_integer_prefix(bytes:&[u8])->NumericConversion {
 let mut cursor=0;
 while cursor<bytes.len() && matches!(bytes[cursor],9..=13|32) {cursor+=1;}
 let negative=bytes.get(cursor)==Some(&b'-');
 if matches!(bytes.get(cursor),Some(b'-'|b'+')) {cursor+=1;}
 let limit=if negative {2147483648u64}else{2147483647u64};
 let mut magnitude=0u64;let mut range_error=false;
 while let Some(&byte)=bytes.get(cursor) {
  if !byte.is_ascii_digit() {break;}
  let next=magnitude*10+u64::from(byte-b'0');
  if next>limit {magnitude=limit;range_error=true;}else {magnitude=next;}
  cursor+=1;
 }
 let signed=if negative {-(magnitude as i64)}else{magnitude as i64};
 NumericConversion {value:signed as i32,range_error}
}
#[derive(Clone,Copy)] pub struct ValueSources<'a> {pub binary_enabled:bool,pub typed_enabled:bool,pub text_enabled:bool,pub typed:Option<i32>,pub text:Option<&'a [u8]>}
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
// Original typed getter8AE340: integer, float, bool, then string.
// Storage lookups are separate from this qualified conversion contract.
#[derive(Clone,Copy,Default)] pub struct TypedSources<'a> {pub integer:Option<i32>,pub float:Option<f32>,pub boolean:Option<u8>,pub text:Option<&'a [u8]>}
#[derive(Debug,PartialEq,Eq)] pub enum TypedLayer {Integer,Float,Boolean,Text}
pub fn read_typed_integer(output:&mut i32,sources:TypedSources<'_>,mut record:impl FnMut(TypedLayer))->bool {
 record(TypedLayer::Integer);if let Some(value)=sources.integer {*output=value;return true;}
 record(TypedLayer::Float);if let Some(value)=sources.float {
  // Rust casts saturate; native CVTTSS2SI returns INT32_MIN for invalid input.
  *output=if value.is_finite() && (-2147483648.0..2147483648.0).contains(&value) {value.trunc() as i32}else{i32::MIN};return true;
 }
 record(TypedLayer::Boolean);if let Some(value)=sources.boolean {*output=i32::from(value!=0);return true;}
 record(TypedLayer::Text);if let Some(value)=sources.text {*output=parse_integer_prefix(value).value;return true;}
 false
}
pub struct IntegerOptions {values:BTreeMap<i32,i32>}
impl IntegerOptions {
 pub fn from_values(values:impl IntoIterator<Item=(i32,i32)>)->Self {Self {values:values.into_iter().collect()}}
 pub fn from_environment_configuration(baseline:ConfigurationPair,user:ConfigurationPair)->Self {
  Self::from_values([(ENVIRONMENT_ID,resolve_configuration(Self::environment_default(),baseline,user,|_|{}))])
 }
 pub fn read(&self,id:i32)->Read {match self.values.get(&id) {Some(&value)=>Read {value,assertion_required:false},None=>Read {value:0,assertion_required:true}}}
 pub fn environment_default()->i32 {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_graphics_options_contract.json")).expect("native graphics option evidence");
  assert_eq!(proof["environment"]["id"],ENVIRONMENT_ID);
  assert_eq!(proof["environment"]["section"],ENVIRONMENT_SECTION);
  assert_eq!(proof["environment"]["key"],ENVIRONMENT_KEY);
  proof["environment"]["default"].as_i64().expect("native integer default") as i32
 }
}
impl Default for IntegerOptions {fn default()->Self {
 let parsed=crate::native_game_cfg_text::parse(include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg"),0);
 assert!(parsed.error.is_none(),"native default Game.cfg parsing failed");
 let default=Self::environment_default();let fallback=default.to_string();
 let lookup=parsed.lookup(crate::native_game_cfg_text::key_hash(ENVIRONMENT_SECTION.as_bytes(),ENVIRONMENT_KEY.as_bytes()),Some(fallback.as_bytes()));
 let value=lookup.found.then(||read_integer_value(default,ValueSources {binary_enabled:false,typed_enabled:false,text_enabled:true,typed:None,text:Some(&lookup.value)},|_|{}).value);
 Self::from_environment_configuration(ConfigurationPair {primary:value,overlay:None},ConfigurationPair::default())
}}
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
 #[test] fn configuration_order_and_fallback_trace_match_every_original_getter_case() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_integer_config_routing_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1296);
  let overlay=|s:&str|match s {"absent"=>None,"missing"=>Some(None),"four"=>Some(Some(4)),_=>panic!("unsupported fixture")};
  for c in proof["cases"].as_array().unwrap() {
   let baseline=ConfigurationPair {primary:c["baseline"].as_i64().map(|v|v as i32),overlay:overlay(c["base_overlay"].as_str().unwrap())};
   let user=ConfigurationPair {primary:c["user_value"].as_i64().map(|v|v as i32),overlay:overlay(c["user_overlay"].as_str().unwrap())};
   let mut reads=Vec::new();let result=resolve_configuration(c["default"].as_i64().unwrap() as i32,baseline,user,|read|reads.push(read));
   assert_eq!(result,c["result"].as_i64().unwrap() as i32);let expected=c["reads"].as_array().unwrap();assert_eq!(reads.len(),expected.len());
   for (actual,expected) in reads.iter().zip(expected) {assert_eq!(actual.layer,expected["layer"].as_u64().unwrap() as u32);assert_eq!(actual.default,expected["default"].as_i64().unwrap() as i32);assert_eq!(actual.found,expected["found"].as_bool().unwrap());assert_eq!(actual.result,expected["result"].as_i64().unwrap() as i32);}
   let options=IntegerOptions::from_environment_configuration(baseline,user);let native_default_result=resolve_configuration(3,baseline,user,|_|{});assert_eq!(options.read(ENVIRONMENT_ID),Read {value:native_default_result,assertion_required:false});
  }
 }

 #[test] fn numeric_conversion_matches_original_crt_for_all_recorded_bytes_and_limits() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_atoi_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1962);
  for c in proof["cases"].as_array().unwrap() {
   let bytes:Vec<u8>=c["bytes"].as_array().unwrap().iter().map(|b|b.as_u64().unwrap() as u8).collect();let actual=parse_integer_prefix(&bytes);
   assert_eq!(actual.value,c["value"].as_i64().unwrap() as i32,"input bytes {bytes:?}");assert_eq!(actual.range_error,c["range_error"].as_bool().unwrap());
   let errno=if actual.range_error {34}else{c["initial_errno"].as_u64().unwrap()};assert_eq!(errno,c["errno_after"].as_u64().unwrap());
  }
 }

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

 #[test] fn typed_integer_priority_and_sse_conversion_match_original_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_typed_config_integer_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1260);
  for c in proof["cases"].as_array().unwrap() {
   let text=c["text"].as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let sources=TypedSources {integer:c["integer"].as_i64().map(|v|v as i32),float:c["float_bits"].as_u64().map(|v|f32::from_bits(v as u32)),boolean:c["boolean"].as_u64().map(|v|v as u8),text:text.as_deref()};
   let mut value=c["initial"].as_i64().unwrap() as i32;let mut trace=Vec::new();let found=read_typed_integer(&mut value,sources,|layer|trace.push(match layer {TypedLayer::Integer=>"integer",TypedLayer::Float=>"float",TypedLayer::Boolean=>"boolean",TypedLayer::Text=>"string"}));
   assert_eq!(found,c["found"].as_bool().unwrap());assert_eq!(value,c["value"].as_i64().unwrap() as i32);assert_eq!(trace,c["reads"].as_array().unwrap().iter().map(|v|v.as_str().unwrap()).collect::<Vec<_>>());
  }
 }

}
