//! Dynamic910EB0 caller fragments:10vector fields, their defaults and fallbacks.
use crate::native_vector_parameter::{VectorParameter,instance_multiplier,sample_instance_table};
use crate::native_probability_curve::ProbabilityCurve;
use crate::native_random::Rng55;
use serde_json::Value;
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
#[repr(usize)]
pub enum Field {PostOffset,QuadRotation,Scale,Velocity,Acceleration,RotationVelocity,BirthRotationAcceleration,Drag,OrbitVelocity,Offset}
pub const FIELDS:[Field;10]=[Field::PostOffset,Field::QuadRotation,Field::Scale,Field::Velocity,Field::Acceleration,Field::RotationVelocity,Field::BirthRotationAcceleration,Field::Drag,Field::OrbitVelocity,Field::Offset];
impl Field {
    pub fn key(self)->&'static str {match self {
        Self::PostOffset=>"p-postoffset",Self::QuadRotation=>"p-quadrot",Self::Scale=>"p-scale",Self::Velocity=>"p-vel",Self::Acceleration=>"p-accel",Self::RotationVelocity=>"p-rotvel",Self::BirthRotationAcceleration=>"Emitter-BirthRotationalAcceleration",Self::Drag=>"p-drag",Self::OrbitVelocity=>"p-orbitvel",Self::Offset=>"p-offset",
    }}
    pub fn default(self)->[f32;3] {if self==Self::Scale {[1.;3]} else {[0.;3]}}
}
#[derive(Debug,Clone)]
pub struct FieldConfig {pub authored:bool,pub table:Vec<[f32;3]>,pub probabilities:[Option<ProbabilityCurve>;3]}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,InvalidNumericField(String),Parameter(crate::native_vector_parameter::Error)}
fn numeric(group:&Value,key:&str)->Result<Option<Vec<f32>>,Error> {
    let Some(value)=group.get(key) else {return Ok(None);};
    if let Some(value)=value.as_f64() {return Ok(Some(vec![value as f32]));}
    if let Some(array)=value.as_array() {
        let values=array.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>().ok_or_else(||Error::InvalidNumericField(key.into()))?;
        return Ok(Some(values));
    }
    Err(Error::InvalidNumericField(key.into()))
}
impl FieldConfig {
    pub fn from_group(field:Field,group:&Value)->Result<Self,Error> {
        Self::read_group(field.key(),field.default(),group)
    }
    /// Original915187..9151F6 field324, distinct from birth p-scale field148.
    pub fn from_lifetime_scale_group(group:&Value)->Result<Self,Error> {
        Self::read_group("p-xscale",[1.;3],group)
    }
    fn read_group(key:&str,default:[f32;3],group:&Value)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        let mut conversion_error=None;
        let parameter=VectorParameter::read_nonrotation(key,default,256,|key|match numeric(group,key) {
            Ok(value)=>value,Err(error)=>{conversion_error=Some(error);None}
        }).map_err(Error::Parameter)?;
        if let Some(error)=conversion_error {return Err(error);}
        Ok(match parameter {
            Some(parameter)=>Self {authored:true,table:parameter.table,probabilities:parameter.probabilities.map(Some)},
            // Missing-field branches overwrite one vector but leave constructor
            // probability pointers null. Do not substitute constant-one objects.
            None=>Self {authored:false,table:vec![default],probabilities:std::array::from_fn(|_|None)},
        })
    }
    pub fn create_multiplier(&self,input:[f32;3],rng:&mut Rng55)->[f32;3] {
        instance_multiplier(std::array::from_fn(|axis|self.probabilities[axis].as_ref()),input,rng)
    }
    pub fn sample_age(&self,age:f32,multiplier:[f32;3])->Result<[f32;3],crate::native_scalar_parameter::Error> {
        sample_instance_table(&self.table,age,multiplier)
    }
}
#[derive(Debug,Clone)]
pub struct ComplexVectors {pub fields:[FieldConfig;10]}
impl ComplexVectors {
    /// Group must already have been selected as Complex by the native type reader.
    /// This covers vector parameters; whole emitter activation/rendering is separate.
    pub fn from_group(group:&Value)->Result<Self,Error> {
        let fields=FIELDS.into_iter().map(|field|FieldConfig::from_group(field,group)).collect::<Result<Vec<_>,_>>()?;
        Ok(Self {fields:fields.try_into().expect("ten native vector fields")})
    }
    pub fn field(&self,field:Field)->&FieldConfig {&self.fields[field as usize]}
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn vector_configuration_matches_all_original_caller_arguments_and_fallbacks() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_vector_caller_contract.json")).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let field=FIELDS.into_iter().find(|f|f.key()==row["key"].as_str().unwrap()).unwrap();
            assert_eq!(row["arguments"]["mode"],0);assert_eq!(row["arguments"]["count"],256);
            assert_eq!(field.default().map(f32::to_bits).to_vec(),row["arguments"]["default"].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>());
            let actual=ComplexVectors::from_group(&row["fields"]).unwrap();let cfg=actual.field(field);
            assert_eq!(cfg.authored,row["reader_returned"].as_bool().unwrap(),"{} {}",row["key"],row["name"]);
            assert_eq!(cfg.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{} {}",row["key"],row["name"]);
            for axis in 0..3 {
                let expected=&row["probabilities"][axis];assert_eq!(cfg.probabilities[axis].is_none(),expected.is_null());
                if let Some(p)=&cfg.probabilities[axis] {
                    assert_eq!((p.constant,p.fast),(expected["constant"].as_bool().unwrap(),expected["fast"].as_bool().unwrap()));
                    assert_eq!((p.constant_value.to_bits(),p.begin.to_bits(),p.difference.to_bits()),(bits(&expected["constant_bits"]),bits(&expected["begin_bits"]),bits(&expected["difference_bits"])));
                    for (values,key) in [(&p.times,"times"),(&p.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>());}
                }
            }
        }
    }
    #[test]
    fn actual_map10_complex_sections_match_original_vector_caller_outputs() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        let native:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_vector_caller_contract.json")).unwrap();
        let mut checked=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap() {
                if group["declared_type"].as_str()==Some("Simple") {continue;}
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let cfg=ComplexVectors::from_group(&document["sections"][group["name"].as_str().unwrap()]).unwrap();
                for field in FIELDS {
                    let row=native["cases"].as_array().unwrap().iter().find(|row|row["name"].as_str()==Some(&name) && row["key"].as_str()==Some(field.key()) && row["prior_count"]==0).unwrap();
                    assert_eq!(cfg.field(field).table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{name} {}",field.key());
                    checked+=1;
                }
            }
        }
        assert_eq!(checked,270);
    }
}
