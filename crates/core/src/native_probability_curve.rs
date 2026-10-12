//! Original91B410 reader after numeric conversion, and91B770 SSE evaluator.
//! Knot order is authored order, including descending keys in Map10 ghosts.
#[derive(Debug,Clone)]
pub struct ProbabilityCurve {
    pub present: bool,
    pub constant: bool,
    pub constant_value: f32,
    pub fast: bool,
    pub begin: f32,
    pub difference: f32,
    pub times: Vec<f32>,
    pub values: Vec<f32>,
}
#[derive(Debug,PartialEq,Eq)]
pub enum Error { NonFinite, FieldLimit }
/// Original93C37A..93C3C5: constants/null consume no random draw; other curves
/// consume one fraction, stored as f32 before either fast or generic arithmetic.
pub fn apply_probability(curve:Option<&ProbabilityCurve>,base:f32,rng:&mut crate::native_random::Rng55)->f32 {
    let Some(curve)=curve else {return base;};
    let factor=if curve.constant {curve.constant_value} else {
        let parameter=rng.fraction();
        if curve.fast {
            let scaled=curve.difference*parameter;
            scaled+curve.begin
        } else {curve.sample_parameter(parameter)}
    };
    factor*base
}
impl ProbabilityCurve {
    /// Lookup returns already converted native numeric fields; CRT/cache behavior
    /// is not reproduced here. MAX finite is the original missing-value sentinel.
    pub fn read_numeric(key:&str, mut lookup:impl FnMut(&str)->Option<Vec<f32>>) -> Result<Self,Error> {
        let mut result=Self {present:false,constant:true,constant_value:1.,fast:false,begin:0.,difference:0.,times:vec![],values:vec![]};
        if let Some(value)=lookup(key).and_then(|v|v.first().copied()) {
            if !value.is_finite() {return Err(Error::NonFinite);}
            if value!=f32::MAX {result.present=true;result.constant_value=value;return Ok(result);}
        }
        for index in 1..=4096 {
            let pair=lookup(&format!("{key}{index}"));
            let Some(pair)=pair.filter(|p|p.len()>=2 && p[0]!=f32::MAX) else {
                result.present=!result.times.is_empty();
                result.constant=!result.present;
                if result.times.len()==2
                    && (-f32::from_bits(0x358637bd)..=f32::from_bits(0x358637bd)).contains(&result.times[0])
                    && (f32::from_bits(0x3f7fffef)..=f32::from_bits(0x3f800008)).contains(&result.times[1]) {
                    result.fast=true;result.begin=result.values[0];result.difference=result.values[1]-result.values[0];
                }
                return Ok(result);
            };
            if !pair[0].is_finite() || !pair[1].is_finite() {return Err(Error::NonFinite);}
            result.times.push(pair[0]);result.values.push(pair[1]);
        }
        Err(Error::FieldLimit)
    }
    /// Explicit parameter; RNG draw and fast-mode sampling are separate consumers.
    pub fn sample_parameter(&self,parameter:f32)->f32 {
        if self.constant {return self.constant_value;}
        // Native linear scan looks for the first key strictly greater than input;
        // duplicate exact keys select the last duplicate, unlike94EC10.
        let upper=self.times.iter().position(|t|*t>parameter).unwrap_or(self.times.len());
        if upper==0 {return self.values[0];}
        if upper==self.times.len() {return *self.values.last().unwrap();}
        let lower=upper-1;
        let distance=parameter-self.times[lower];
        let width=self.times[upper]-self.times[lower];
        let weight=distance/width;
        let span=self.values[upper]-self.values[lower];
        let scaled=weight*span;
        scaled+self.values[lower]
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn contract()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/probability_curve_contract.json")).unwrap()}
    fn curve(row:&serde_json::Value)->ProbabilityCurve {
        ProbabilityCurve::read_numeric(row["key"].as_str().unwrap(),|key|row["fields"][key].as_array().map(|v|v.iter().map(|n|n.as_f64().unwrap() as f32).collect())).unwrap()
    }
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn reader_matches_original_flags_values_and_authored_knot_order() {
        let data=contract();
        for row in data["cases"].as_array().unwrap() {
            let actual=curve(row);
            assert_eq!((actual.present,actual.constant,actual.fast),(row["returned"].as_bool().unwrap(),row["constant"].as_bool().unwrap(),row["fast"].as_bool().unwrap()),"{}",row["name"]);
            assert_eq!((actual.constant_value.to_bits(),actual.begin.to_bits(),actual.difference.to_bits()),(bits(&row["constant_bits"]),bits(&row["begin_bits"]),bits(&row["difference_bits"])),"{}",row["name"]);
            for (actual,key) in [(&actual.times,"times"),(&actual.values,"values")] {
                assert_eq!(actual.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),row[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>(),"{} {key}",row["name"]);
            }
        }
    }
    #[test]
    fn sse_parameter_sampling_matches_original_output_bits() {
        let data=contract();
        for sample in data["samples"].as_array().unwrap() {
            let row=data["cases"].as_array().unwrap().iter().find(|r|r["name"]==sample["case"]).unwrap();
            assert_eq!(curve(row).sample_parameter(sample["time"].as_f64().unwrap() as f32).to_bits(),bits(&sample["output_bits"]),"{sample}");
        }
    }
    #[test]
    fn consumer_preserves_original_random_draw_order_and_scaled_output() {
        let data=contract();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/probability_random_consumer_contract.json")).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let cfg=data["cases"].as_array().unwrap().iter().find(|v|v["name"]==row["name"]).map(curve);
            let mut rng=crate::native_random::Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let check=|rng:&crate::native_random::Rng55,state:&serde_json::Value| {
                assert_eq!((rng.first,rng.second),(state["first"].as_u64().unwrap() as u32,state["second"].as_u64().unwrap() as u32));
                for (index,word) in rng.words.iter().enumerate() {assert_eq!(*word,state["words"][index].as_u64().unwrap() as u32);}
            };
            check(&rng,&row["initial_rng"]);
            for step in row["steps"].as_array().unwrap() {
                assert_eq!(apply_probability(cfg.as_ref(),row["scale"].as_f64().unwrap() as f32,&mut rng).to_bits(),bits(&step["output_bits"]),"{} seed{} scale{}",row["name"],row["seed"],row["scale"]);
                check(&rng,&step["rng"]);
            }
        }
    }
}
