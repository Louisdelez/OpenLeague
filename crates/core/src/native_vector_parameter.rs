//!94AA60 nonrotation vector configuration, including X/Y/Z probability fields.
use crate::native_vector_curve::{self,VectorKnots};
use crate::native_probability_curve::{self,ProbabilityCurve};
use crate::native_random::Rng55;
use crate::native_probability_curve::apply_probability;
#[derive(Debug,Clone)]
pub struct VectorParameter {pub table:Vec<[f32;3]>,pub probabilities:[ProbabilityCurve;3]}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Curve(native_vector_curve::Error),Probability(native_probability_curve::Error)}
///9492F0 visits X/Y/Z in order, with no draw for null/constant axes.
pub fn instance_multiplier(probabilities:[Option<&ProbabilityCurve>;3],input:[f32;3],rng:&mut Rng55)->[f32;3] {
    let mut result=input;
    for axis in 0..3 {result[axis]=apply_probability(probabilities[axis],result[axis],rng);}
    result
}
///93C21F..93C2BA frame update consumes stored instance multipliers, never RNG.
pub fn sample_instance_table(table:&[[f32;3]],age:f32,multiplier:[f32;3])->Result<[f32;3],crate::native_scalar_parameter::Error> {
    let index=crate::native_scalar_parameter::baked_scalar_index(table.len(),age)?;
    Ok(std::array::from_fn(|axis|table[index][axis]*multiplier[axis]))
}
impl VectorParameter {
    pub fn create_instance_multiplier(&self,input:[f32;3],rng:&mut Rng55)->[f32;3] {
        instance_multiplier(std::array::from_fn(|axis|Some(&self.probabilities[axis])),input,rng)
    }
    pub fn sample_instance_age(&self,age:f32,multiplier:[f32;3])->Result<[f32;3],crate::native_scalar_parameter::Error> {
        sample_instance_table(&self.table,age,multiplier)
    }
    /// Native94C150 requests at least256 samples, but constant knots bake to one.
    /// Caller supplies its authored/default vector and requested count. Rotation
    /// mode, age/RNG consumers and raw getter lexical conversion are separate.
    pub fn read_nonrotation(key:&str,default:[f32;3],requested_count:i32,mut lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Option<Self>,Error> {
        Self::read_with_mode(key,default,requested_count,None,&mut lookup)
    }
    pub fn read_integrated(key:&str,default:[f32;3],requested_count:i32,mode:crate::native_integrated_vector::IntegrationMode,lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Option<Self>,Error> {
        Self::read_with_mode(key,default,requested_count,Some(mode),lookup)
    }
    fn read_with_mode(key:&str,default:[f32;3],requested_count:i32,mode:Option<crate::native_integrated_vector::IntegrationMode>,mut lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Option<Self>,Error> {
        let Some(knots)=VectorKnots::read_numeric(key,default,&mut lookup).map_err(Error::Curve)? else {return Ok(None);};
        let count=requested_count.max(256) as u32;
        let table=match mode {None=>knots.bake(count),Some(mode)=>knots.bake_integrated(count,mode).map_err(Error::Curve)?};
        let x=ProbabilityCurve::read_numeric(&format!("{key}XP"),&mut lookup).map_err(Error::Probability)?;
        let y=ProbabilityCurve::read_numeric(&format!("{key}YP"),&mut lookup).map_err(Error::Probability)?;
        let z=ProbabilityCurve::read_numeric(&format!("{key}ZP"),&mut lookup).map_err(Error::Probability)?;
        Ok(Some(Self {table,probabilities:[x,y,z]}))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn floats(v:&serde_json::Value)->Vec<f32> {v.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect()}
    fn assert_full_reader_contract(text:&str,mode:Option<crate::native_integrated_vector::IntegrationMode>) {
        let proof:serde_json::Value=serde_json::from_str(text).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let result=VectorParameter::read_with_mode(row["key"].as_str().unwrap(),floats(&row["default"]).try_into().unwrap(),row["requested_count"].as_i64().unwrap() as i32,mode,|key|row["fields"].get(key).map(floats)).unwrap();
            assert_eq!(result.is_some(),row["returned"].as_bool().unwrap(),"{}",row["name"]);
            if let Some(result)=result {
                assert_eq!(result.table.len(),row["actual_count"].as_u64().unwrap() as usize);
                assert_eq!(result.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
                for (axis,p) in result.probabilities.iter().enumerate() {
                    let expected=&row["probabilities"][axis];
                    assert_eq!((p.constant,p.fast),(expected["constant"].as_bool().unwrap(),expected["fast"].as_bool().unwrap()),"{} axis{axis}",row["name"]);
                    assert_eq!((p.constant_value.to_bits(),p.begin.to_bits(),p.difference.to_bits()),(bits(&expected["constant_bits"]),bits(&expected["begin_bits"]),bits(&expected["difference_bits"])),"{} axis{axis}",row["name"]);
                    for (values,key) in [(&p.times,"times"),(&p.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),floats(&expected[key]).iter().map(|v|v.to_bits()).collect::<Vec<_>>(),"{} axis{axis} {key}",row["name"]);}
                }
            }
        }
    }
    #[test]
    fn full_nonrotation_reader_matches_original_table_and_axis_probabilities() {
        assert_full_reader_contract(include_str!("../../../data/4.20/vector_parameter_contract.json"),None);
    }
    #[test]
    fn full_integrated_readers_match_original_tables_and_axis_probabilities() {
        use crate::native_integrated_vector::IntegrationMode;
        assert_full_reader_contract(include_str!("../../../data/4.20/integrated_vector_parameter_mode1_contract.json"),Some(IntegrationMode::Once));
        assert_full_reader_contract(include_str!("../../../data/4.20/integrated_vector_parameter_mode2_contract.json"),Some(IntegrationMode::Twice));
    }
    fn consumer_proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/vector_instance_consumer_contract.json")).unwrap()}
    #[test]
    fn birth_variations_match_original_axis_order_outputs_and_rng_states() {
        for row in consumer_proof()["cases"].as_array().unwrap() {
            let probabilities:[Option<ProbabilityCurve>;3]=std::array::from_fn(|axis| {
                let p=&row["axes"][axis];if p.is_null() {return None;}
                Some(ProbabilityCurve {present:true,constant:p["constant"].as_bool().unwrap(),constant_value:f32::from_bits(bits(&p["constant_bits"])),fast:p["fast"].as_bool().unwrap(),begin:f32::from_bits(bits(&p["begin_bits"])),difference:f32::from_bits(bits(&p["difference_bits"])),times:floats(&p["times"]),values:floats(&p["values"])})
            });
            let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let check=|rng:&Rng55,state:&serde_json::Value| {
                assert_eq!((rng.first,rng.second),(state["first"].as_u64().unwrap() as u32,state["second"].as_u64().unwrap() as u32));
                for (i,v) in rng.words.iter().enumerate() {assert_eq!(*v,state["words"][i].as_u64().unwrap() as u32);}
            };
            check(&rng,&row["initial_rng"]);
            for step in row["steps"].as_array().unwrap() {
                let actual=instance_multiplier(std::array::from_fn(|axis|probabilities[axis].as_ref()),floats(&row["base"]).try_into().unwrap(),&mut rng);
                assert_eq!(actual.map(f32::to_bits).to_vec(),step["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{} seed{}",row["name"],row["seed"]);
                check(&rng,&step["rng"]);
            }
        }
    }
    #[test]
    fn age_update_matches_original_vector_table_and_stored_birth_multiplier() {
        for row in consumer_proof()["updates"].as_array().unwrap() {
            let table:Vec<[f32;3]>=row["vectors"].as_array().unwrap().iter().map(|v|floats(v).try_into().unwrap()).collect();
            let result=sample_instance_table(&table,row["age"].as_f64().unwrap() as f32,floats(&row["multiplier"]).try_into().unwrap()).unwrap();
            assert_eq!(result.map(f32::to_bits).to_vec(),row["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"count{} age{}",row["count"],row["age"]);
        }
    }
}
