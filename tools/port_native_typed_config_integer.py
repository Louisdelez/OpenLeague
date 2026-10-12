from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_graphics_options.rs';text=p.read_text(encoding='utf-8')
anchor='pub struct IntegerOptions {values:BTreeMap<i32,i32>}'
extra='''// Original typed getter8AE340: integer, float, bool, then string.
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
'''
assert anchor in text
if 'pub struct TypedSources' not in text:text=text.replace(anchor,extra+anchor,1)
test='''
 #[test] fn typed_integer_priority_and_sse_conversion_match_original_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_typed_config_integer_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1260);
  for c in proof["cases"].as_array().unwrap() {
   let text=c["text"].as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let sources=TypedSources {integer:c["integer"].as_i64().map(|v|v as i32),float:c["float_bits"].as_u64().map(|v|f32::from_bits(v as u32)),boolean:c["boolean"].as_u64().map(|v|v as u8),text:text.as_deref()};
   let mut value=c["initial"].as_i64().unwrap() as i32;let mut trace=Vec::new();let found=read_typed_integer(&mut value,sources,|layer|trace.push(match layer {TypedLayer::Integer=>"integer",TypedLayer::Float=>"float",TypedLayer::Boolean=>"boolean",TypedLayer::Text=>"string"}));
   assert_eq!(found,c["found"].as_bool().unwrap());assert_eq!(value,c["value"].as_i64().unwrap() as i32);assert_eq!(trace,c["reads"].as_array().unwrap().iter().map(|v|v.as_str().unwrap()).collect::<Vec<_>>());
  }
 }
'''
if 'fn typed_integer_priority_and_sse_conversion_match_original_cases' not in text:
 index=text.rfind('\n}');assert index!=-1;text=text[:index]+test+text[index:]
p.write_text(text,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Typed integer conversion ported; storage/cache/user path remain separate.')
