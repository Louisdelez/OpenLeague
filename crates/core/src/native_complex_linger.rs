//! Original9132C5..91339B p-linger/e-linger defaults and clamp behavior.
use crate::native_complex_age::sse_result;
use serde_json::Value;
#[derive(Debug,Copy,Clone)]
pub struct Linger {pub particle:f32,pub emitter:f32}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,InvalidScalar(String)}
fn scalar(group:&Value,key:&str)->Result<Option<f32>,Error> {
    group.get(key).map(|v|v.as_f64().map(|v|v as f32).ok_or_else(||Error::InvalidScalar(key.into()))).transpose()
}
fn clamp(value:f32,bound:f32)->f32 {
    let value=if value<0. {bound} else {value};
    if value>bound {bound} else {value}
}
impl Linger {
    pub fn from_scalars(particle_life_max:f32,emitter_life:f32,particle_authored:Option<f32>,emitter_authored:Option<f32>)->Self {
        let particle_bound=sse_result(particle_life_max,10.,|a,b|a+b);
        let emitter_bound=sse_result(emitter_life,10.,|a,b|a+b);
        Self {particle:clamp(particle_authored.unwrap_or(particle_bound),particle_bound),emitter:clamp(emitter_authored.unwrap_or(0.),emitter_bound)}
    }
    pub fn from_group(group:&Value,timing:&crate::native_complex_timing::Timing,particle_life_max:f32)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        Ok(Self::from_scalars(particle_life_max,timing.life,scalar(group,"p-linger")?,scalar(group,"e-linger")?))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_linger_contract.json")).unwrap()}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn compare(actual:Linger,row:&Value) {
        assert_eq!(actual.particle.to_bits(),bits(&row["particle_linger_bits"]),"{row}");
        assert_eq!(actual.emitter.to_bits(),bits(&row["emitter_linger_bits"]),"{row}");
    }
    #[test]
    fn linger_defaults_and_clamps_match_original_x87_sse_cases() {
        let proof=proof();assert_eq!(proof["cases"].as_array().unwrap().len(),3052);
        for row in proof["cases"].as_array().unwrap() {
            let authored=|key:&str|if row[key].is_null() {None} else {Some(f32::from_bits(bits(&row[key])))};
            compare(Linger::from_scalars(f32::from_bits(bits(&row["particle_life_max_bits"])),f32::from_bits(bits(&row["emitter_life_bits"])),authored("particle_authored_bits"),authored("emitter_authored_bits")),row);
        }
    }
    #[test]
    fn actual_map_linger_uses_qualified_scalar_maximum_and_timing() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");let proof=proof();let mut count=0;
        let scalar:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_scalar_parameter_contract.json")).unwrap();
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap().iter().filter(|g|g["declared_type"]!="Simple") {
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|r|r["name"]==name).unwrap();
                let scalar_row=scalar["cases"].as_array().unwrap().iter().find(|r|r["name"]==format!("{name}:p-life")).unwrap();
                let fields=&document["sections"][group["name"].as_str().unwrap()];
                let timing=crate::native_complex_timing::Timing::from_group(fields,None).unwrap();
                let life=crate::native_scalar_parameter::ScalarParameter::read_numeric("p-life",scalar_row["default"].as_f64().unwrap() as f32,|key|fields.get(key).map(|v|if let Some(v)=v.as_f64() {vec![v as f32]} else {v.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect()})).unwrap().unwrap();
                assert_eq!(life.maximum.to_bits(),bits(&row["particle_life_max_bits"]));
                compare(Linger::from_group(fields,&timing,life.maximum).unwrap(),row);count+=1;
            }
        }
        assert_eq!(count,27);
    }
}
