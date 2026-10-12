//! Native e-rgba and p-xrgba callers/defaults and94ACC0 RGBA configuration.
//! Runtime channel probability order and age producer require separate qualification.
use crate::native_color_curve::{ColorKnots,Error as CurveError};
use crate::native_probability_curve::{ProbabilityCurve,Error as ProbabilityError};
use serde_json::Value;
#[derive(Debug,Clone)]
pub struct ComplexColor {
    /// Whether the native curve reader accepted this field, not physical presence.
    pub reader_accepted:bool,
    pub table:Vec<[f32;4]>,
    pub probabilities:[Option<ProbabilityCurve>;4],
}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,InvalidNumericField(String),Curve(CurveError),Probability(ProbabilityError)}
fn numeric(group:&Value,key:&str)->Result<Option<Vec<f32>>,Error> {
    let Some(value)=group.get(key) else {return Ok(None);};
    if let Some(value)=value.as_f64() {return Ok(Some(vec![value as f32]));}
    if let Some(array)=value.as_array() {
        return array.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>().map(Some).ok_or_else(||Error::InvalidNumericField(key.into()));
    }
    Err(Error::InvalidNumericField(key.into()))
}
impl ComplexColor {
    pub fn from_group(group:&Value)->Result<Self,Error> {
        Self::read_group(group,"e-rgba")
    }
    /// Particle lifetime color, original9151F6caller and container field340.
    pub fn from_lifetime_group(group:&Value)->Result<Self,Error> {
        Self::read_group(group,"p-xrgba")
    }
    /// Call on a configuration read from p-xrgba. Stored birth RGBA is immutable.
    pub fn update_lifetime_color(&self,stored_birth:[f32;4],time:f32,birth_time:f32,life:f32,rng:&mut crate::native_random::Rng55)->Result<([f32;4],crate::native_complex_particle_age::ParticleAge),crate::native_scalar_parameter::Error> {
        crate::native_color_consumers::update_particle_color(stored_birth,&self.table,std::array::from_fn(|i|self.probabilities[i].as_ref()),time,birth_time,life,rng)
    }
    fn read_group(group:&Value,key:&str)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        let mut conversion_error=None;
        let mut lookup=|key:&str|match numeric(group,key) {Ok(value)=>value,Err(error)=>{conversion_error=Some(error);None}};
        let knots=ColorKnots::read_numeric(key,[1.;4],&mut lookup).map_err(Error::Curve)?;
        let result=if let Some(knots)=knots {
            let mut probabilities=Vec::new();
            for channel in ['R','G','B','A'] {probabilities.push(Some(ProbabilityCurve::read_numeric(&format!("{key}{channel}P"),&mut lookup).map_err(Error::Probability)?));}
            Self {reader_accepted:true,table:knots.bake(256),probabilities:probabilities.try_into().expect("four RGBA channels")}
        } else {
            // The original caller writes one opaque-white color and preserves
            // null probability pointers when94ACC0 rejects missing/short data.
            Self {reader_accepted:false,table:vec![[1.;4]],probabilities:std::array::from_fn(|_|None)}
        };
        if let Some(error)=conversion_error {return Err(error);}
        Ok(result)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_color_contract.json")).unwrap()}
    fn lifetime_proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_lifetime_color_contract.json")).unwrap()}
    #[test]
    fn lifetime_color_reader_matches_native_defaults_tables_and_probabilities() {
        let proof=lifetime_proof();assert_eq!(proof["cases"].as_array().unwrap().len(),66);
        for row in proof["cases"].as_array().unwrap() {
            assert_eq!(row["arguments"]["key"],"p-xrgba");
            assert_eq!(row["arguments"]["default"],serde_json::json!([1.,1.,1.,1.]));
            compare(&ComplexColor::from_lifetime_group(&row["fields"]).unwrap(),row);
        }
    }
    #[test]
    fn actual_map_lifetime_colors_match_original_reader() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        let proof=lifetime_proof();let mut count=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap().iter().filter(|g|g["declared_type"]!="Simple") {
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|r|r["name"]==name && r["prior_count"]==0).unwrap();
                compare(&ComplexColor::from_lifetime_group(&document["sections"][group["name"].as_str().unwrap()]).unwrap(),row);count+=1;
            }
        }
        assert_eq!(count,27);
    }
    #[test]
    fn map_lifetime_reader_to_color_update_matches_native_values_and_rng() {
        let proof:Value=serde_json::from_str({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/complex_lifetime_color_update_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 18006674, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),864);
        for row in proof["cases"].as_array().unwrap() {
            let config=ComplexColor::from_lifetime_group(&row["fields"]).unwrap();
            let stored:[f32;4]=std::array::from_fn(|i|row["birth_color"][i].as_f64().unwrap() as f32);
            let mut rng=crate::native_random::Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let (color,_)=config.update_lifetime_color(stored,f32::from_bits(bits(&row["time_bits"])),0.,1.,&mut rng).unwrap();
            assert_eq!(color.map(f32::to_bits).to_vec(),row["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
            assert_eq!(stored.map(f32::to_bits).to_vec(),row["birth_after_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>());
            assert_eq!(rng.first,row["rng"]["first"].as_u64().unwrap() as u32);
            assert_eq!(rng.second,row["rng"]["second"].as_u64().unwrap() as u32);
            for i in 0..55 {assert_eq!(rng.words[i],row["rng"]["words"][i].as_u64().unwrap() as u32,"{}",row["name"]);}
        }
    }
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn compare(actual:&ComplexColor,row:&Value) {
        assert_eq!(actual.reader_accepted,row["reader_returned"].as_bool().unwrap(),"{}",row["name"]);
        assert_eq!(actual.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["table_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
        for (channel,actual) in actual.probabilities.iter().enumerate() {
            let expected=&row["probabilities"][channel];
            assert_eq!(actual.is_none(),expected.is_null(),"{} channel{channel}",row["name"]);
            if let Some(p)=actual {
                assert_eq!((p.constant,p.fast),(expected["constant"].as_bool().unwrap(),expected["fast"].as_bool().unwrap()));
                assert_eq!((p.constant_value.to_bits(),p.begin.to_bits(),p.difference.to_bits()),(bits(&expected["constant_bits"]),bits(&expected["begin_bits"]),bits(&expected["difference_bits"])));
                for (values,key) in [(&p.times,"times"),(&p.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>());}
            }
        }
    }
    #[test]
    fn all_original_rgba_callers_match_tables_probabilities_and_fallback() {
        for row in proof()["cases"].as_array().unwrap() {
            assert_eq!(row["arguments"]["default"],serde_json::json!([1.,1.,1.,1.]));
            compare(&ComplexColor::from_group(&row["fields"]).unwrap(),row);
        }
    }
    #[test]
    fn actual_map10_complex_colors_match_original_outputs() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        let proof=proof();let mut count=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap().iter().filter(|g|g["declared_type"]!="Simple") {
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|r|r["name"]==name && r["prior_count"]==0).unwrap();
                compare(&ComplexColor::from_group(&document["sections"][group["name"].as_str().unwrap()]).unwrap(),row);count+=1;
            }
        }
        assert_eq!(count,27);
    }
}
