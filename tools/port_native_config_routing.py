from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_graphics_options.rs';s=p.read_text(encoding='utf-8');archive=r/'docs/plan_history'/('native-config-routing-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True);shutil.copy2(p,archive/p.name)
block='''// None overlay means no overlay object; Some(None) is an existing object with
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
'''
s=s.replace('pub struct IntegerOptions {',block+'pub struct IntegerOptions {')
s=s.replace(' pub fn read(&self,id:i32)->Read', ''' pub fn from_environment_configuration(baseline:ConfigurationPair,user:ConfigurationPair)->Self {
  Self::from_values([(ENVIRONMENT_ID,resolve_configuration(Self::environment_default(),baseline,user,|_|{}))])
 }
 pub fn read(&self,id:i32)->Read''')
s=s.replace('Self::from_values([(ENVIRONMENT_ID,Self::environment_default())])','Self::from_environment_configuration(ConfigurationPair::default(),ConfigurationPair::default())')
test='''
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
'''
pos=s.rfind('\n}');s=s[:pos]+test+s[pos:];p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native config layering/fallback ported; configuration lookup/text parser still pending')
