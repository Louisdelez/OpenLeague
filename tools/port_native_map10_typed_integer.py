from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/map10_native_config.rs';text=p.read_text(encoding='utf-8');anchor='    pub fn float(&self,section:&str,name:&str)->Option<f32> {'
extra='''    pub fn integer_by_hash(&self,hash:u32)->Option<i32> {
        use crate::native_graphics_options::{TypedSources,read_typed_integer};
        let sources=match self.entries.get(&hash) {
            Some(Value::Byte(v))=>TypedSources {integer:Some(i32::from(*v)),..Default::default()},
            Some(Value::Float(v))=>TypedSources {float:Some(*v),..Default::default()},
            Some(Value::Boolean(v))=>TypedSources {boolean:Some(u8::from(*v)),..Default::default()},
            Some(Value::Text(v))=>TypedSources {text:Some(v.as_bytes()),..Default::default()},
            _=>TypedSources::default(),
        };
        let mut value=0;read_typed_integer(&mut value,sources,|_|{}).then_some(value)
    }
'''
assert anchor in text
if 'pub fn integer_by_hash' not in text:text=text.replace(anchor,extra+anchor,1)
test='''
    #[test] fn recovered_binary_integer_reads_match_original_loaded_storage_and_accessors() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_map10_typed_integer_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],58);
        let config=Config::map10().unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let result=config.integer_by_hash(c["key"].as_u64().unwrap() as u32);assert_eq!(result.is_some(),c["found"].as_bool().unwrap());
            if let Some(value)=result {assert_eq!(value,c["value"].as_i64().unwrap() as i32);}
        }
    }
'''
if 'fn recovered_binary_integer_reads_match_original' not in text:
 index=text.rfind('\n}');assert index!=-1;text=text[:index]+test+text[index:]
p.write_text(text,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Qualified native integer conversion connected to recovered Map10 INIBIN resource provider.')
