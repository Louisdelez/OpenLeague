//! Four native UV callers and94AF20/94DF00/94E420 two-component configuration.
//! Native runtime UV probability consumers/birth storage and renderer are separate.
use crate::native_vector_curve::{VectorKnots,Error as CurveError};
use crate::native_probability_curve::{ProbabilityCurve,Error as ProbabilityError};
use serde_json::Value;
pub const KEYS:[&str;4]=["e-uvoffset","e-uvoffset-mult","p-uvscroll-rgb","p-uvscroll-rgb-mult"];
#[derive(Debug,Clone)]
pub struct Parameter {pub authored:bool,pub table:Vec<[f32;2]>,pub probabilities:[Option<ProbabilityCurve>;2]}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,UnsupportedKey,InvalidNumericField(String),Curve(CurveError),Probability(ProbabilityError)}
fn numeric(group:&Value,key:&str)->Result<Option<Vec<f32>>,Error> {
    let Some(value)=group.get(key) else {return Ok(None);};
    if let Some(v)=value.as_f64() {return Ok(Some(vec![v as f32]));}
    if let Some(v)=value.as_array() {return v.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>().map(Some).ok_or_else(||Error::InvalidNumericField(key.into()));}
    Err(Error::InvalidNumericField(key.into()))
}
impl Parameter {
    /// Original949680 with a nonnull caller-provided probability parameter.
    /// X/Y variable curves share that value and make no new random draws.
    pub fn sample_shared(&self,age:f32,shared:f32)->Result<[f32;2],crate::native_scalar_parameter::Error> {
        let index=crate::native_scalar_parameter::baked_scalar_index(self.table.len(),age)?;
        let mut value=self.table[index];
        for axis in 0..2 {
            if let Some(curve)=&self.probabilities[axis] {
                let factor=if curve.constant {curve.constant_value} else if curve.fast {
                    let scaled=curve.difference*shared;scaled+curve.begin
                } else {curve.sample_parameter(shared)};
                value[axis]*=factor;
            }
        }
        Ok(value)
    }
    pub fn from_group(key:&str,group:&Value)->Result<Self,Error> {
        if !KEYS.contains(&key) {return Err(Error::UnsupportedKey);}
        if !group.is_object() {return Err(Error::InvalidGroup);}
        let mut conversion_error=None;
        // These UV keys use the same component scaling/SSE interpolation as the
        // qualified vector curve. Pad a zero third axis only inside that helper;
        // the native UV table/probabilities always have exactly two components.
        let knots=VectorKnots::read_numeric(key,[0.;3],|lookup| {
            let values=match numeric(group,lookup) {Ok(v)=>v,Err(e)=>{conversion_error=Some(e);None}};
            values.map(|v| {
                if lookup==key {if v.len()>=2 {vec![v[0],v[1],0.]} else {v}}
                else if v.len()>=3 {vec![v[0],v[1],v[2],0.]} else {v}
            })
        }).map_err(Error::Curve)?;
        if let Some(error)=conversion_error {return Err(error);}
        let Some(knots)=knots else {return Ok(Self {authored:false,table:vec![[0.;2]],probabilities:[None,None]});};
        let table=knots.bake(256).into_iter().map(|v|[v[0],v[1]]).collect();
        let mut probabilities=[None,None];
        for (axis,suffix) in ["XP","YP"].into_iter().enumerate() {
            let curve=ProbabilityCurve::read_numeric(&format!("{key}{suffix}"),|lookup|match numeric(group,lookup) {Ok(v)=>v,Err(e)=>{conversion_error=Some(e);None}}).map_err(Error::Probability)?;
            if let Some(error)=conversion_error.take() {return Err(error);}
            probabilities[axis]=Some(curve);
        }
        Ok(Self {authored:true,table,probabilities})
    }
}
#[derive(Debug,Clone)]
pub struct UvParameters {pub parameters:[Parameter;4]}
impl UvParameters {
    ///936C95..936D6E four calls share the earlier9360D8..9361FA fraction.
    /// Caller owns that draw and other birth consumers using the same parameter.
    /// Returned origin/rate pairs have not yet been transferred to particle storage.
    pub fn sample_birth(&self,age:f32,shared:f32)->Result<crate::native_complex_uv_scroll::Scroll,crate::native_scalar_parameter::Error> {
        let origin=[self.parameters[0].sample_shared(age,shared)?,self.parameters[1].sample_shared(age,shared)?];
        let rate=[self.parameters[2].sample_shared(age,shared)?,self.parameters[3].sample_shared(age,shared)?];
        Ok(crate::native_complex_uv_scroll::Scroll {origin,rate})
    }
    pub fn from_group(group:&Value)->Result<Self,Error> {
        let parameters=KEYS.into_iter().map(|key|Parameter::from_group(key,group)).collect::<Result<Vec<_>,_>>()?;
        Ok(Self {parameters:parameters.try_into().expect("four UV fields")})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_uv_readers_contract.json")).unwrap()}
    fn check(parameter:&Parameter,row:&Value) {
        assert_eq!(parameter.authored,row["reader_returned"].as_bool().unwrap(),"{} {}",row["key"],row["name"]);
        assert_eq!(parameter.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{} {}",row["key"],row["name"]);
        for axis in 0..2 {
            let expected=&row["probabilities"][axis];assert_eq!(parameter.probabilities[axis].is_none(),expected.is_null());
            if let Some(actual)=&parameter.probabilities[axis] {
                assert_eq!((actual.constant,actual.fast),(expected["constant"].as_bool().unwrap(),expected["fast"].as_bool().unwrap()));
                assert_eq!([actual.constant_value,actual.begin,actual.difference].map(f32::to_bits),[bits(&expected["constant_bits"]),bits(&expected["begin_bits"]),bits(&expected["difference_bits"])]);
                for (values,key) in [(&actual.times,"times"),(&actual.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>());}
            }
        }
    }
    #[test]
    fn uv_readers_match_all_native_callers_bakes_probabilities_and_fallbacks() {
        let p=proof();assert_eq!(p["cases"].as_array().unwrap().len(),256);
        for row in p["cases"].as_array().unwrap() {
            assert_eq!(row["arguments"]["default"],serde_json::json!([0.,0.]));
            check(&Parameter::from_group(row["key"].as_str().unwrap(),&row["fields"]).unwrap(),row);
        }
    }
    #[test]
    fn actual_map10_uv_parameters_match_original_native_outputs() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();let native=proof();let mut count=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let doc:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap() {
                if group["declared_type"]=="Simple" {continue;}
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let parameters=UvParameters::from_group(&doc["sections"][group["name"].as_str().unwrap()]).unwrap();
                for (axis,key) in KEYS.into_iter().enumerate() {
                    let row=native["cases"].as_array().unwrap().iter().find(|row|row["name"].as_str()==Some(&name)&&row["key"].as_str()==Some(key)&&row["prior_count"]==0).unwrap();
                    check(&parameters.parameters[axis],row);count+=1;
                }
            }
        }
        assert_eq!(count,108);
    }
    #[test]
    fn shared_birth_uv_matches_original_values_and_rng_state() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_uv_birth_contract.json")).unwrap();
        assert_eq!(p["cases"].as_array().unwrap().len(),528);
        let check_rng=|rng:&crate::native_random::Rng55,state:&Value| {
            assert_eq!((rng.first,rng.second),(state["first"].as_u64().unwrap() as u32,state["second"].as_u64().unwrap() as u32));
            assert_eq!(rng.words.to_vec(),state["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        };
        for row in p["cases"].as_array().unwrap() {
            let profile=p["profiles"].as_array().unwrap().iter().find(|v|v["name"]==row["name"]).unwrap();
            let config=UvParameters::from_group(&profile["fields"]).unwrap();
            let mut rng=crate::native_random::Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            check_rng(&rng,&row["initial_rng"]);let shared=rng.fraction();
            assert_eq!(shared.to_bits(),bits(&row["shared_parameter_bits"]));check_rng(&rng,&row["post_fraction_rng"]);
            let sampled=config.sample_birth(f32::from_bits(bits(&row["age_bits"])),shared).unwrap();
            let actual=sampled.origin.into_iter().chain(sampled.rate).flatten().map(f32::to_bits).collect::<Vec<_>>();
            let expected=row["output_bits"].as_array().unwrap().iter().flat_map(|v|v.as_array().unwrap().iter().map(bits)).collect::<Vec<_>>();
            assert_eq!(actual,expected,"{} age{}",row["name"],row["age_bits"]);check_rng(&rng,&row["rng"]);
        }
    }
}
