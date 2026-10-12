//! Original949550 RGBA birth multipliers and949420 sampled table probabilities.
//! These are distinct native entrypoints, not interchangeable frame updates.
use crate::native_probability_curve::{ProbabilityCurve,apply_probability};
use crate::native_random::Rng55;
use crate::native_scalar_parameter::{Error,baked_scalar_index};
/// RGBA order; null and constant channels consume no random draw.
pub fn birth_multiplier(channels:[Option<&ProbabilityCurve>;4],input:[f32;4],rng:&mut Rng55)->[f32;4] {
    let mut result=input;
    for channel in 0..4 {result[channel]=apply_probability(channels[channel],result[channel],rng);}
    result
}
///949420 selects the table first, then applies RGBA probabilities on each call.
/// Do not use this for a lifecycle path that stores birth multipliers instead.
pub fn sample_with_probabilities(table:&[[f32;4]],channels:[Option<&ProbabilityCurve>;4],age:f32,rng:&mut Rng55)->Result<[f32;4],Error> {
    let index=baked_scalar_index(table.len(),age)?;
    Ok(birth_multiplier(channels,table[index],rng))
}
/// Complex934860 caller: evaluate emitter age, select e-rgba, then apply
///949550 once for a newly born particle. Other birth fields/RNG calls separate.
pub fn create_birth_color_at_emitter_age(table:&[[f32;4]],channels:[Option<&ProbabilityCurve>;4],input:crate::native_complex_age::EmitterAgeInput,rng:&mut Rng55)->Result<([f32;4],crate::native_complex_age::EmitterAge),Error> {
    let age=input.evaluate();
    let index=baked_scalar_index(table.len(),age.normalized)?;
    Ok((birth_multiplier(channels,table[index],rng),age))
}
/// Original939B94..939C47: sample the lifetime color at individual particle age,
/// then multiply by stored birth RGBA. Variable lifetime channels draw each call;
/// stored birth factors stay unchanged. Distance modulation is a later stage.
pub fn update_particle_color(birth_color:[f32;4],table:&[[f32;4]],channels:[Option<&ProbabilityCurve>;4],time:f32,birth_time:f32,life:f32,rng:&mut Rng55)->Result<([f32;4],crate::native_complex_particle_age::ParticleAge),Error> {
    let age=crate::native_complex_particle_age::evaluate(time,birth_time,life);
    let sampled=sample_with_probabilities(table,channels,age.normalized,rng)?;
    let color=std::array::from_fn(|i|crate::native_complex_age::sse_result(birth_color[i],sampled[i],|a,b|a*b));
    Ok((color,age))
}
impl crate::native_complex_color::ComplexColor {
    pub fn create_birth_color_at_emitter_age(&self,input:crate::native_complex_age::EmitterAgeInput,rng:&mut Rng55)->Result<([f32;4],crate::native_complex_age::EmitterAge),Error> {
        create_birth_color_at_emitter_age(&self.table,std::array::from_fn(|i|self.probabilities[i].as_ref()),input,rng)
    }
    pub fn create_birth_multiplier(&self,input:[f32;4],rng:&mut Rng55)->[f32;4] {
        birth_multiplier(std::array::from_fn(|i|self.probabilities[i].as_ref()),input,rng)
    }
    pub fn sample_with_probabilities(&self,age:f32,rng:&mut Rng55)->Result<[f32;4],Error> {
        sample_with_probabilities(&self.table,std::array::from_fn(|i|self.probabilities[i].as_ref()),age,rng)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/color_consumer_contract.json")).unwrap()}
    #[test]
    fn lifetime_color_update_preserves_birth_and_matches_native_rng_and_pixels_input() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_color_update_contract.json")).unwrap();
        assert_eq!(proof["profiles"],6);
        assert_eq!(proof["cases"].as_array().unwrap().len(),768);
        for row in proof["cases"].as_array().unwrap() {
            let probabilities=channels(row);
            let table:Vec<[f32;4]>=row["colors"].as_array().unwrap().iter().map(|v|std::array::from_fn(|i|v[i].as_f64().unwrap() as f32)).collect();
            let birth: [f32;4]=std::array::from_fn(|i|row["birth_color"][i].as_f64().unwrap() as f32);
            let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let (color,_)=update_particle_color(birth,&table,std::array::from_fn(|i|probabilities[i].as_ref()),f32::from_bits(bits(&row["time_bits"])),0.,1.,&mut rng).unwrap();
            assert_eq!(color.map(f32::to_bits).to_vec(),row["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
            assert_eq!(birth.map(f32::to_bits).to_vec(),row["birth_after_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
            check_state(&rng,&row["rng"]);
        }
    }
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn floats(v:&Value)->Vec<f32> {v.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect()}
    fn channels(row:&Value)->[Option<ProbabilityCurve>;4] {
        std::array::from_fn(|i| {
            let p=&row["channels"][i];if p.is_null() {return None;}
            Some(ProbabilityCurve {present:true,constant:p["constant"].as_bool().unwrap(),constant_value:f32::from_bits(bits(&p["constant_bits"])),fast:p["fast"].as_bool().unwrap(),begin:f32::from_bits(bits(&p["begin_bits"])),difference:f32::from_bits(bits(&p["difference_bits"])),times:floats(&p["times"]),values:floats(&p["values"])})
        })
    }
    fn check_state(rng:&Rng55,expected:&Value) {
        assert_eq!(rng.first,expected["first"].as_u64().unwrap() as u32);
        assert_eq!(rng.second,expected["second"].as_u64().unwrap() as u32);
        assert_eq!(rng.words.to_vec(),expected["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
    }
    fn check_output(actual:[f32;4],step:&Value,row:&Value) {
        assert_eq!(actual.map(f32::to_bits).to_vec(),step["output_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>(),"{}",row["name"]);
    }
    #[test]
    fn birth_rgba_matches_all_native_values_and_rng_transitions() {
        let proof=proof();let mut steps=0;
        for row in proof["cases"].as_array().unwrap() {
            let curves=channels(row);let input=floats(&row["base"]).try_into().unwrap();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            check_state(&rng,&row["initial_rng"]);
            for step in row["steps"].as_array().unwrap() {
                check_output(birth_multiplier(std::array::from_fn(|i|curves[i].as_ref()),input,&mut rng),step,row);check_state(&rng,&step["rng"]);steps+=1;
            }
        }
        assert_eq!(steps,384);
    }
    #[test]
    fn sampled_rgba_matches_native_selection_and_rng_for_repeated_calls() {
        let proof=proof();let mut steps=0;
        for row in proof["samples"].as_array().unwrap() {
            let curves=channels(row);let table:Vec<[f32;4]>=row["colors"].as_array().unwrap().iter().map(|v|floats(v).try_into().unwrap()).collect();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            check_state(&rng,&row["initial_rng"]);
            for step in row["steps"].as_array().unwrap() {
                let value=sample_with_probabilities(&table,std::array::from_fn(|i|curves[i].as_ref()),f32::from_bits(bits(&row["age_bits"])),&mut rng).unwrap();
                check_output(value,step,row);check_state(&rng,&step["rng"]);steps+=1;
            }
        }
        assert_eq!(steps,1248);
    }
    #[test]
    fn complex_emitter_age_to_birth_rgba_matches_original_fragments() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_birth_color_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),312);
        for row in proof["cases"].as_array().unwrap() {
            let get=|key:&str|f32::from_bits(bits(&row[key]));
            let input=crate::native_complex_age::EmitterAgeInput {config_308:get("config_308_bits"),config_30c:get("config_30c_bits"),instance_7c:get("instance_7c_bits"),time:get("time_bits"),owner_a8:get("owner_a8_bits"),offset_2ec:get("offset_bits")};
            let curves=channels(row);let table:Vec<[f32;4]>=row["colors"].as_array().unwrap().iter().map(|v|floats(v).try_into().unwrap()).collect();let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            check_state(&rng,&row["initial_rng"]);
            let (color,age)=create_birth_color_at_emitter_age(&table,std::array::from_fn(|i|curves[i].as_ref()),input,&mut rng).unwrap();
            assert_eq!(age.selected_duration.to_bits(),bits(&row["selected_duration_bits"]));
            assert_eq!(age.normalized.to_bits(),bits(&row["normalized_age_bits"]));
            let selected=table[baked_scalar_index(table.len(),age.normalized).unwrap()];
            assert_eq!(selected.map(f32::to_bits).to_vec(),row["selected_color_bits"].as_array().unwrap().iter().map(bits).collect::<Vec<_>>());
            check_output(color,row,row);check_state(&rng,&row["rng"]);
        }
    }
}
