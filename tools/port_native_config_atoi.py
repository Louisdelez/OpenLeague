from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_graphics_options.rs';s=p.read_text(encoding='utf-8');archive=r/'docs/plan_history'/('native-config-atoi-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True);shutil.copy2(p,archive/p.name)
block='''// Original CRT C-locale decimal conversion. This numeric stage does not
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
'''
s=s.replace('pub struct IntegerOptions {',block+'pub struct IntegerOptions {')
test='''
 #[test] fn numeric_conversion_matches_original_crt_for_all_recorded_bytes_and_limits() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_atoi_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1962);
  for c in proof["cases"].as_array().unwrap() {
   let bytes:Vec<u8>=c["bytes"].as_array().unwrap().iter().map(|b|b.as_u64().unwrap() as u8).collect();let actual=parse_integer_prefix(&bytes);
   assert_eq!(actual.value,c["value"].as_i64().unwrap() as i32,"input bytes {bytes:?}");assert_eq!(actual.range_error,c["range_error"].as_bool().unwrap());
   let errno=if actual.range_error {34}else{c["initial_errno"].as_u64().unwrap()};assert_eq!(errno,c["errno_after"].as_u64().unwrap());
  }
 }
'''
pos=s.rfind('\n}');s=s[:pos]+test+s[pos:];p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native CRT numeric conversion ported; literal-true and actual configuration reader remain open')
