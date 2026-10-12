//! Original94D130 numeric fields,94ECB0 SSE interpolation,94D6B0 flag0 baking.
#[derive(Debug,Clone)]
pub struct VectorKnots {times:Vec<f32>,values:Vec<[f32;3]>}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Empty,LengthMismatch,NonFinite,Unsorted,FieldLimit}
impl VectorKnots {
    pub fn bake_integrated(&self,count:u32,mode:crate::native_integrated_vector::IntegrationMode)->Result<Vec<[f32;3]>,Error> {
        crate::native_integrated_vector::bake(&self.times,&self.values,count,mode)
    }
    pub fn new(times:Vec<f32>,values:Vec<[f32;3]>)->Result<Self,Error> {
        if times.is_empty() {return Err(Error::Empty);}
        if times.len()!=values.len() {return Err(Error::LengthMismatch);}
        if times.iter().chain(values.iter().flatten()).any(|v|!v.is_finite()) {return Err(Error::NonFinite);}
        if times.windows(2).any(|v|v[0]>v[1]) {return Err(Error::Unsorted);}
        Ok(Self {times,values})
    }
    pub fn sample_knots(&self,time:f32)->[f32;3] {
        let upper=self.times.partition_point(|v|*v<time);
        if upper==0 {return self.values[0];}
        if upper==self.times.len() {return *self.values.last().unwrap();}
        let lower=upper-1;
        let distance=time-self.times[lower];
        let width=self.times[upper]-self.times[lower];
        let weight=distance/width;
        std::array::from_fn(|axis| {
            let span=self.values[upper][axis]-self.values[lower][axis];
            let scaled=span*weight;
            scaled+self.values[lower][axis]
        })
    }
    /// Nonrotation94D6B0 only. Rotation-conversion mode is a distinct algorithm.
    pub fn bake(&self,requested_count:u32)->Vec<[f32;3]> {
        let count=if self.times.len()==1 {1} else {requested_count};
        if count==0 {return Vec::new();}
        let reciprocal=1.0f32/count as f32;
        (0..count).map(|i|self.sample_knots(i as f32*reciprocal)).collect()
    }
    /// Takes numeric fields after raw getter/CRT conversion. Native lexical and
    /// cache parity not claimed. Malformed/nonfinite/unsorted inputs unsupported.
    pub fn read_numeric(key:&str,default:[f32;3],mut lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Option<Self>,Error> {
        if default.iter().any(|v|!v.is_finite()) {return Err(Error::NonFinite);}
        let authored=lookup(key);let mut base=default;
        if let Some(numbers)=&authored {
            if numbers.len()<3 {return Ok(None);}
            base.copy_from_slice(&numbers[..3]);
            if key=="e-rgba" {for v in &mut base {*v*=f32::from_bits(0x3b808081);}}
        }
        if base.iter().any(|v|!v.is_finite()) {return Err(Error::NonFinite);}
        let mut times=vec![];let mut values=vec![];
        for index in 1..=4096 {
            let numbers=lookup(&format!("{key}{index}"));
            let Some(numbers)=numbers.filter(|v|v.len()>=4) else {
                if times.is_empty() {
                    if authored.is_none() {return Ok(None);}
                    times.push(0.);values.push(base);
                }
                return Self::new(times,values).map(Some);
            };
            times.push(numbers[0]);values.push(std::array::from_fn(|axis|numbers[axis+1]*base[axis]));
        }
        Err(Error::FieldLimit)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/vector_curve_contract.json")).unwrap()}
    fn floats(v:&serde_json::Value)->Vec<f32> {v.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect()}
    fn vectors(v:&serde_json::Value)->Vec<[f32;3]> {v.as_array().unwrap().iter().map(|v|floats(v).try_into().unwrap()).collect()}
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn reader_matches_original_scaled_components_and_missing_fields() {
        for row in proof()["field_cases"].as_array().unwrap() {
            let cfg=VectorKnots::read_numeric(row["key"].as_str().unwrap(),floats(&row["default"]).try_into().unwrap(),|key|row["fields"].get(key).map(floats)).unwrap();
            assert_eq!(cfg.is_some(),row["returned"].as_bool().unwrap(),"{}",row["name"]);
            if let Some(cfg)=cfg {
                assert_eq!(cfg.times.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),floats(&row["times"]).iter().map(|v|v.to_bits()).collect::<Vec<_>>(),"{}",row["name"]);
                assert_eq!(cfg.values.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),vectors(&row["values"]).iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),"{}",row["name"]);
            }
        }
    }
    #[test]
    fn sse_interpolation_matches_original_vector_bits() {
        for row in proof()["samples"].as_array().unwrap() {
            let cfg=VectorKnots::new(floats(&row["times"]),vectors(&row["values"])).unwrap();
            assert_eq!(cfg.sample_knots(row["time"].as_f64().unwrap() as f32).map(f32::to_bits).to_vec(),row["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{} time{}",row["name"],row["time"]);
        }
    }
    #[test]
    fn nonrotation_bake_matches_original_count_and_vector_bits() {
        for row in proof()["bake_cases"].as_array().unwrap() {
            let cfg=VectorKnots::new(floats(&row["times"]),vectors(&row["values"])).unwrap();
            let actual=cfg.bake(row["requested_count"].as_u64().unwrap() as u32);
            assert_eq!(actual.len(),row["actual_count"].as_u64().unwrap() as usize);
            assert_eq!(actual.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),row["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{} count{}",row["name"],row["requested_count"]);
        }
    }
}
