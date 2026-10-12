//! Native Map10 INIBIN v2, compared against the original 8B0380 loader.
//! Only the five types present in this recovered file are qualified here.
use std::collections::BTreeMap;
pub const LOGICAL_PATH:&str="Levels/Map10/terrain.ini";
pub const PHYSICAL_PATH:&str="Levels/Map10/terrain.inibin";
const MAP10_BYTES:&[u8]=include_bytes!("../../../data/4.20/map10_terrain.inibin");
#[derive(Debug,PartialEq)]
pub enum Value {Float(f32),Byte(u8),Boolean(bool),Vector3([f32;3]),Text(String)}
pub struct Config {pub entries:BTreeMap<u32,Value>}
struct Reader<'a> {bytes:&'a[u8],cursor:usize}
impl<'a> Reader<'a> {
    fn take(&mut self,n:usize)->Result<&'a[u8],&'static str> {
        let end=self.cursor.checked_add(n).ok_or("INIBIN range overflow")?;
        let bytes=self.bytes.get(self.cursor..end).ok_or("truncated INIBIN")?;self.cursor=end;Ok(bytes)
    }
    fn u16(&mut self)->Result<u16,&'static str> {Ok(u16::from_le_bytes(self.take(2)?.try_into().unwrap()))}
    fn u32(&mut self)->Result<u32,&'static str> {Ok(u32::from_le_bytes(self.take(4)?.try_into().unwrap()))}
    fn float(&mut self)->Result<f32,&'static str> {Ok(f32::from_bits(self.u32()?))}
}
pub fn key(section:&str,name:&str)->u32 {
    section.bytes().chain(std::iter::once(b'*')).chain(name.bytes()).fold(0u32,|h,c|h.wrapping_mul(65599).wrapping_add(c.to_ascii_lowercase() as u32))
}
impl Config {
    pub fn map10()->Result<Self,&'static str> {Self::decode(MAP10_BYTES)}
    pub fn decode(bytes:&[u8])->Result<Self,&'static str> {
        let mut input=Reader {bytes,cursor:0};
        if input.take(1)?[0]!=2 {return Err("unsupported INIBIN version");}
        let string_len=input.u16()? as usize;let flags=input.u16()?;
        let supported=(1<<1)|(1<<4)|(1<<5)|(1<<7)|(1<<12);
        if flags & !supported !=0 {return Err("unqualified Map10 INIBIN type");}
        let string_start=bytes.len().checked_sub(string_len).ok_or("invalid INIBIN string table")?;
        let strings=&bytes[string_start..];let mut entries=BTreeMap::new();
        for bit in [1,4,5,7,12] {
            if flags & (1<<bit)==0 {continue;}
            let count=input.u16()? as usize;
            let keys=(0..count).map(|_|input.u32()).collect::<Result<Vec<_>,_>>()?;
            let mut values=Vec::with_capacity(count);
            if bit==5 {
                let packed=input.take(count.div_ceil(8))?;
                values.extend((0..count).map(|i|Value::Boolean(packed[i/8] & (1<<(i%8))!=0)));
            } else {
                for _ in 0..count {
                    values.push(match bit {
                        1=>Value::Float(input.float()?),
                        4=>Value::Byte(input.take(1)?[0]),
                        7=>Value::Vector3([input.float()?,input.float()?,input.float()?]),
                        12=> {
                            let offset=input.u16()? as usize;
                            let tail=strings.get(offset..).ok_or("INIBIN string offset outside table")?;
                            let end=tail.iter().position(|v|*v==0).ok_or("unterminated INIBIN string")?;
                            Value::Text(std::str::from_utf8(&tail[..end]).map_err(|_|"invalid INIBIN UTF-8")?.to_owned())
                        },
                        _=>unreachable!(),
                    });
                }
            }
            for (key,value) in keys.into_iter().zip(values) {
                if entries.insert(key,value).is_some() {return Err("ambiguous duplicate INIBIN key");}
            }
        }
        if input.cursor!=string_start {return Err("INIBIN tables/string boundary mismatch");}
        Ok(Self {entries})
    }
    pub fn integer_by_hash(&self,hash:u32)->Option<i32> {
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
    pub fn float(&self,section:&str,name:&str)->Option<f32> {
        match self.entries.get(&key(section,name)) {Some(Value::Float(v))=>Some(*v),_=>None}
    }
    pub fn boolean(&self,section:&str,name:&str)->Option<bool> {
        match self.entries.get(&key(section,name)) {Some(Value::Boolean(v))=>Some(*v),_=>None}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn map10_bytes_and_all_values_match_original_binary_loader_and_accessors() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_map10_inibin_loader_contract.json")).unwrap();assert_eq!(p["passed"],true);
        assert_eq!(p["opens"][0]["path"],PHYSICAL_PATH);assert_eq!(p["consumed"].as_u64().unwrap() as usize,MAP10_BYTES.len());
        let config=Config::map10().unwrap();let expected=p["native_decoded"].as_object().unwrap();assert_eq!(config.entries.len(),expected.len());
        for (key,value) in expected {
            let actual_value=config.entries.get(&key.parse().unwrap()).unwrap();
            // Compare original f32 memory bits; JSON's decimal-to-f64 parsing can round.
            match actual_value {
                Value::Float(v)=> {assert_eq!(v.to_bits(),p["native_float_bits"][key].as_u64().unwrap() as u32);continue;},
                Value::Vector3(v)=> {let bits:Vec<_>=p["native_float_bits"][key].as_array().unwrap().iter().map(|b|b.as_u64().unwrap() as u32).collect();assert_eq!(v.map(f32::to_bits).as_slice(),bits.as_slice());continue;},
                _=>{},
            }
            let actual=match config.entries.get(&key.parse().unwrap()).unwrap() {
                Value::Float(v)=>serde_json::json!(*v),Value::Byte(v)=>serde_json::json!(*v),Value::Boolean(v)=>serde_json::json!(*v),Value::Vector3(v)=>serde_json::json!(v),Value::Text(v)=>serde_json::json!(v),
            };assert_eq!(&actual,value,"native field {key}");
        }
        for query in p["typed_queries"].as_array().unwrap() {
            let key:u32=query["key"].as_str().unwrap().parse().unwrap();
            match config.entries.get(&key).unwrap() {
                Value::Float(v)=>assert_eq!(v.to_bits(),(query["result"].as_f64().unwrap() as f32).to_bits()),
                Value::Boolean(v)=>assert_eq!(*v,query["result"].as_bool().unwrap()),_=>panic!("unexpected query type"),
            }
        }
        for q in p["float_queries"].as_array().unwrap() {
            let value=config.float("FoW",q["key"].as_str().unwrap());assert_eq!(value.is_some(),q["found"].as_bool().unwrap());
            assert_eq!(value.unwrap_or(q["default"].as_f64().unwrap() as f32).to_bits(),q["result_bits"].as_u64().unwrap() as u32);
        }
        assert_eq!(config.boolean("FoW","upscale"),None);
    }
    #[test] fn damaged_source_is_rejected_without_panics_or_silent_defaults() {
        for end in 0..MAP10_BYTES.len() {assert!(Config::decode(&MAP10_BYTES[..end]).is_err(),"truncation {end}");}
        let mut data=MAP10_BYTES.to_vec();data[0]=1;assert!(Config::decode(&data).is_err());
        let mut data=MAP10_BYTES.to_vec();data[3]|=1;assert!(Config::decode(&data).is_err());
    }
    #[test] fn recovered_binary_integer_reads_match_original_loaded_storage_and_accessors() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_map10_typed_integer_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],58);
        let config=Config::map10().unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let result=config.integer_by_hash(c["key"].as_u64().unwrap() as u32);assert_eq!(result.is_some(),c["found"].as_bool().unwrap());
            if let Some(value)=result {assert_eq!(value,c["value"].as_i64().unwrap() as i32);}
        }
    }

}
