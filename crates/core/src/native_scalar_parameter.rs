//! Native94A7F0 scalar configuration and93C2E4 baked-table consumer.
use crate::native_scalar_curve::{self,read_scalar_fields};
use crate::native_probability_curve::{self,ProbabilityCurve,apply_probability};
use crate::native_random::Rng55;
#[derive(Debug,Clone)]
pub struct ScalarParameter {
    pub table:Vec<f32>,
    pub maximum:f32,
    pub probability:ProbabilityCurve,
}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Curve(native_scalar_curve::Error),Probability(native_probability_curve::Error),EmptyTable,TableTooLarge}
/// Native cvttss2si is different from Rust saturating float-to-int casts on
/// NaN/infinity/overflow: SSE returns INT_MIN, and native lower clamp chooses0.
pub fn baked_scalar_index(count:usize,age:f32)->Result<usize,Error> {
    if count==0 {return Err(Error::EmptyTable);}
    if count>i32::MAX as usize {return Err(Error::TableTooLarge);}
    let scaled=count as f32*age;
    let raw=if !scaled.is_finite() || scaled>=2147483648. || scaled< -2147483648. {i32::MIN} else {scaled.trunc() as i32};
    Ok(raw.clamp(0,count as i32-1) as usize)
}
impl ScalarParameter {
    /// Supplied numeric lookup. Native raw cache/getter/CRT conversion not claimed.
    /// Missing base-and-numbered data returns None; caller fallback is separate.
    pub fn read_numeric(key:&str,default:f32,mut lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Option<Self>,Error> {
        let Some(knots)=read_scalar_fields(key,default,&mut lookup).map_err(Error::Curve)? else {return Ok(None);};
        // Original94C060 caches maximum from authored scaled knots, before baking.
        let maximum=knots.maximum();
        let table=knots.bake(256);
        //94A7F0 reads XP then P into the same probability object. P resets it;
        // preserve read order but retain the final P result, even when absent.
        let _=ProbabilityCurve::read_numeric(&format!("{key}XP"),&mut lookup).map_err(Error::Probability)?;
        let probability=ProbabilityCurve::read_numeric(&format!("{key}P"),&mut lookup).map_err(Error::Probability)?;
        Ok(Some(Self {table,maximum,probability}))
    }
    pub fn sample_age(&self,normalized_age:f32,rng:&mut Rng55)->Result<f32,Error> {
        let index=baked_scalar_index(self.table.len(),normalized_age)?;
        Ok(apply_probability(Some(&self.probability),self.table[index],rng))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn table_lookup_matches_original_cvttss2si_and_clamps() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/baked_scalar_lookup_contract.json")).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let index=baked_scalar_index(row["count"].as_u64().unwrap() as usize,f32::from_bits(bits(&row["time_bits"]))).unwrap();
            assert_eq!(index,row["index"].as_u64().unwrap() as usize);
            assert_eq!((row["values"][index].as_f64().unwrap() as f32).to_bits(),bits(&row["output_bits"]));
        }
        assert_eq!(baked_scalar_index(0,0.),Err(Error::EmptyTable));
    }
    #[test]
    fn full_scalar_reader_matches_native_tables_maximum_and_probability_overwrite() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_scalar_parameter_contract.json")).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let parameter=ScalarParameter::read_numeric(row["key"].as_str().unwrap(),row["default"].as_f64().unwrap() as f32,|key|row["fields"][key].as_array().map(|v|v.iter().map(|n|n.as_f64().unwrap() as f32).collect())).unwrap();
            assert_eq!(parameter.is_some(),row["returned"].as_bool().unwrap(),"{}",row["name"]);
            if let Some(parameter)=parameter {
                assert_eq!(parameter.maximum.to_bits(),bits(&row["maximum_bits"]),"{}",row["name"]);
                assert_eq!(parameter.table.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
                let p=&parameter.probability;let expected=&row["probability"];
                assert_eq!((p.constant,p.fast),(expected["constant"].as_bool().unwrap(),expected["fast"].as_bool().unwrap()),"{}",row["name"]);
                assert_eq!((p.constant_value.to_bits(),p.begin.to_bits(),p.difference.to_bits()),(bits(&expected["constant_bits"]),bits(&expected["begin_bits"]),bits(&expected["difference_bits"])),"{}",row["name"]);
                for (values,key) in [(&p.times,"times"),(&p.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>(),"{} {key}",row["name"]);}
            }
        }
    }
}
