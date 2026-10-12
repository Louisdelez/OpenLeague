//! Original file fallback caller and8AFC30 binary boolean/8AE530 typed reader.
//! Global Hacks overrides, textual-file provider and cache population separate.
use serde_json::Value;
#[derive(Debug,Copy,Clone)]
pub struct LifeScale {pub raw_byte:u8}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,UnsupportedValue}
impl LifeScale {
    /// A disabled binary provider returns the caller default zero. Native typed
    /// bool bytes remain raw. Text fallback compares only its first byte to '1'.
    pub fn from_binary_sources(provider_ready:bool,boolean:Option<u8>,text:Option<&[u8]>)->Self {
        let raw_byte=if !provider_ready {0} else if let Some(value)=boolean {value} else {u8::from(text.and_then(|v|v.first()).copied()==Some(b'1'))};
        Self {raw_byte}
    }
    /// Values decoded from binary INIBIN storage. Do not use textual-file rules.
    pub fn from_binary_group(group:&Value)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        let Some(value)=group.get("e-life-scale") else {return Ok(Self {raw_byte:0});};
        if let Some(value)=value.as_bool() {return Ok(Self::from_binary_sources(true,Some(u8::from(value)),None));}
        if let Some(value)=value.as_str() {return Ok(Self::from_binary_sources(true,None,Some(value.as_bytes())));}
        Err(Error::UnsupportedValue)
    }
    pub fn enabled(self)->bool {self.raw_byte!=0}
    pub fn initial_duration(self,timing:&crate::native_complex_timing::Timing,owner_scale:f32)->f32 {
        timing.initial_instance_duration(self.enabled(),owner_scale)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_life_scale_contract.json")).unwrap()}
    #[test]
    fn binary_reader_matches_original_raw_bytes_priority_and_text_conversion() {
        let proof=proof();assert_eq!(proof["cases"].as_array().unwrap().len(),127);
        for row in proof["cases"].as_array().unwrap() {
            assert_eq!(row["arguments"]["default_byte"],0);
            let actual=LifeScale::from_binary_sources(row["provider_ready"].as_bool().unwrap(),row["boolean"].as_u64().map(|v|v as u8),row["text"].as_str().map(str::as_bytes));
            assert_eq!(actual.raw_byte,row["enabled_byte"].as_u64().unwrap() as u8,"{row}");
        }
    }
    #[test]
    fn actual_map10_life_scale_matches_native_and_binds_duration() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");let proof=proof();let mut count=0;
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap().iter().filter(|g|g["declared_type"]!="Simple") {
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|r|r["name"]==name).unwrap();
                let fields=&document["sections"][group["name"].as_str().unwrap()];let actual=LifeScale::from_binary_group(fields).unwrap();
                assert_eq!(actual.raw_byte,row["enabled_byte"].as_u64().unwrap() as u8);
                // Current27Map10sections all take the native missing-field zero.
                assert!(!actual.enabled());
                let timing=crate::native_complex_timing::Timing::from_group(fields,None).unwrap();
                for owner_scale in [0.,0.5,2.,f32::NAN] {assert_eq!(actual.initial_duration(&timing,owner_scale).to_bits(),timing.life.to_bits());}
                count+=1;
            }
        }
        assert_eq!(count,27);
    }
}
