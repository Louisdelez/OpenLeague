//! Original Complex scalar timing caller paths, after decoded scalar getters.
//! Period/active are not clamped; negative effective life maps to maximum finite.
use serde_json::Value;
#[derive(Debug,Copy,Clone)]
pub struct Timing {pub time_offset:f32,pub life:f32,pub active:f32,pub period:f32}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,InvalidScalar(String)}
fn scalar(group:&Value,key:&str)->Result<Option<f32>,Error> {
    group.get(key).map(|v|v.as_f64().map(|v|v as f32).ok_or_else(||Error::InvalidScalar(key.into()))).transpose()
}
impl Timing {
    /// Scalar values are already converted by the native getter/asset decoder.
    /// Retain NaN/infinity/signed zero as the captured caller does.
    pub fn from_scalars(time_offset:Option<f32>,life:Option<f32>,active:Option<f32>,period:Option<f32>,global_life:Option<f32>)->Self {
        let life=life.unwrap_or(global_life.unwrap_or(-1.));
        Self {time_offset:time_offset.unwrap_or(0.),life:if life<0. {f32::MAX} else {life},active:active.unwrap_or(f32::MAX),period:period.unwrap_or(f32::MAX)}
    }
    pub fn from_group(group:&Value,global_life:Option<f32>)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        Ok(Self::from_scalars(scalar(group,"e-timeoffset")?,scalar(group,"e-life")?,scalar(group,"e-active")?,scalar(group,"e-period")?,global_life))
    }
    /// Complex birth caller uses period/active and instance7C to select duration.
    /// Instance7C producer and full lifetime stop/loop logic remain separate.
    pub fn emitter_age_input(&self,time:f32,owner_start:f32,instance_7c:f32)->crate::native_complex_age::EmitterAgeInput {
        crate::native_complex_age::EmitterAgeInput {config_308:self.period,config_30c:self.active,instance_7c,time,owner_a8:owner_start,offset_2ec:self.time_offset}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_emitter_timing_contract.json")).unwrap()}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn compare(actual:Timing,row:&Value) {
        for (actual,key) in [(actual.time_offset,"time_offset_bits"),(actual.life,"life_bits"),(actual.active,"active_bits"),(actual.period,"period_bits")] {assert_eq!(actual.to_bits(),bits(&row[key]),"{} {key}",row["name"]);}
    }
    #[test]
    fn timing_matches_original_getter_defaults_overrides_and_sentinel() {
        let proof=proof();assert_eq!(proof["cases"].as_array().unwrap().len(),71);
        for row in proof["cases"].as_array().unwrap() {
            let field=|key|row["fields_bits"].get(key).map(|v|f32::from_bits(bits(v)));
            let global=if row["global_life_bits"].is_null() {None} else {Some(f32::from_bits(bits(&row["global_life_bits"])))};
            let actual=Timing::from_scalars(field("e-timeoffset"),field("e-life"),field("e-active"),field("e-period"),global);
            compare(actual,row);
        }
    }
    #[test]
    fn actual_map10_timing_fields_match_original_callers() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");let proof=proof();let mut count=0;
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap().iter().filter(|g|g["declared_type"]!="Simple") {
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|r|r["name"]==name).unwrap();
                compare(Timing::from_group(&document["sections"][group["name"].as_str().unwrap()],None).unwrap(),row);count+=1;
            }
        }
        assert_eq!(count,27);
    }
}
