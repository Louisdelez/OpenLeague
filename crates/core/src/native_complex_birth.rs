//! Original Complex batch birth timing and post-sampling particle lifetime.
use crate::native_complex_age::sse_result as sse;
#[derive(Debug,Copy,Clone)]
pub struct Birth {pub fraction:f32,pub time:f32,pub position:[f32;3]}
/// Original indices increment before sampling: the first birth is1/count and
/// the last is1. A stored-MAX start is unset and resolves to current time.
pub fn scheduled_birth(time:f32,previous:f32,count:i32,index:u32,previous_position:[f32;3],current_position:[f32;3])->Option<Birth> {
    if count<=0 || index>=count as u32 {return None;}
    let previous=if previous==f32::MIN {time} else {previous};
    let reciprocal=sse(1.,count as f32,|a,b|a/b);
    let fraction=sse((index+1) as f32,reciprocal,|a,b|a*b);
    let delta=sse(time,previous,|a,b|a-b);
    let time=sse(sse(delta,fraction,|a,b|a*b),previous,|a,b|a+b);
    let position=std::array::from_fn(|axis| {
        let delta=sse(current_position[axis],previous_position[axis],|a,b|a-b);
        let scaled=sse(fraction,delta,|a,b|a*b);
        if axis==0 {sse(scaled,previous_position[axis],|a,b|a+b)} else {sse(previous_position[axis],scaled,|a,b|a+b)}
    });
    Some(Birth {fraction,time,position})
}
#[derive(Debug,Copy,Clone)]
pub struct LifeInputs {
    pub sampled_life:f32,pub owner_scale:f32,pub scale_enabled:bool,
    pub velocity:[f32;3],pub coefficients:[f32;3],pub symmetry_flags:u32,
}
/// The first negative lifetime becomes MAX. After velocity-dependent offsets,
/// a negative result instead becomes0. These branches are not interchangeable.
pub fn finalized_life(input:LifeInputs)->f32 {
    let mut life=if input.scale_enabled {sse(input.owner_scale,input.sampled_life,|a,b|a*b)} else {input.sampled_life};
    if life<0. {life=f32::MAX;}
    if input.coefficients.iter().any(|v|*v!=0.) {
        let v:[f32;3]=std::array::from_fn(|axis|if input.symmetry_flags&(1<<axis)!=0 {f32::from_bits(input.velocity[axis].to_bits()&0x7fffffff)} else {input.velocity[axis]});
        let y=sse(input.coefficients[1],v[1],|a,b|a*b);
        let x=sse(input.coefficients[0],v[0],|a,b|a*b);
        let z=sse(input.coefficients[2],v[2],|a,b|a*b);
        life=sse(sse(sse(y,x,|a,b|a+b),z,|a,b|a+b),life,|a,b|a+b);
        if life<0. {life=0.;}
    }
    life
}
#[derive(Debug,Copy,Clone)]
pub struct LifeModifiers {
    pub owner_scale:f32,pub scale_enabled:bool,pub velocity:[f32;3],
    pub coefficients:[f32;3],pub symmetry_flags:u32,
}
#[derive(Debug,Copy,Clone)]
pub struct BirthLife {
    pub age:crate::native_complex_age::EmitterAge,pub base:f32,
    pub sampled:f32,pub final_life:f32,
}
/// Native birth samples p-life from emitter age, then performs its own probability
/// draw before final modifiers. The caller must preserve draws of other fields
/// that intervene in the full birth function; this helper does not replace them.
pub fn sample_birth_life(
    parameter:&crate::native_scalar_parameter::ScalarParameter,
    age_input:crate::native_complex_age::EmitterAgeInput,
    modifiers:LifeModifiers,rng:&mut crate::native_random::Rng55,
)->Result<BirthLife,crate::native_scalar_parameter::Error> {
    let age=age_input.evaluate();
    let index=crate::native_scalar_parameter::baked_scalar_index(parameter.table.len(),age.normalized)?;
    let base=parameter.table[index];
    let sampled=crate::native_probability_curve::apply_probability(Some(&parameter.probability),base,rng);
    let final_life=finalized_life(LifeInputs {sampled_life:sampled,owner_scale:modifiers.owner_scale,scale_enabled:modifiers.scale_enabled,velocity:modifiers.velocity,coefficients:modifiers.coefficients,symmetry_flags:modifiers.symmetry_flags});
    Ok(BirthLife {age,base,sampled,final_life})
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/complex_birth_timing_life_contract.json")).unwrap()}
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn f(v:&serde_json::Value)->f32 {f32::from_bits(bits(v))}
    #[test]
    fn batch_birth_times_and_positions_match_original_schedule() {
        let proof=proof();assert_eq!(proof["schedule_cases"].as_array().unwrap().len(),300);
        for row in proof["schedule_cases"].as_array().unwrap() {
            let position=|key:&str|std::array::from_fn(|i|row[key][i].as_f64().unwrap() as f32);
            let birth=scheduled_birth(f(&row["time"]),f(&row["previous"]),row["count"].as_i64().unwrap() as i32,row["index"].as_u64().unwrap() as u32,position("previous_position"),position("current_position")).unwrap();
            assert_eq!(birth.fraction.to_bits(),bits(&row["fraction"]),"{row}");
            assert_eq!(birth.time.to_bits(),bits(&row["birth_time"]),"{row}");
            for i in 0..3 {assert_eq!(birth.position[i].to_bits(),bits(&row["position"][i]),"{row}");}
        }
        assert!(scheduled_birth(1.,0.,0,0,[0.;3],[0.;3]).is_none());
        assert!(scheduled_birth(1.,0.,1,1,[0.;3],[0.;3]).is_none());
    }
    #[test]
    fn lifetime_scaling_negative_sentinels_and_velocity_offsets_match_original() {
        let proof=proof();assert_eq!(proof["life_cases"].as_array().unwrap().len(),495);
        for row in proof["life_cases"].as_array().unwrap() {
            let inputs=LifeInputs {sampled_life:f(&row["life"]),owner_scale:f(&row["scale"]),scale_enabled:row["enabled"].as_u64().unwrap()!=0,velocity:std::array::from_fn(|i|f(&row["velocity"][i])),coefficients:std::array::from_fn(|i|f(&row["coefficients"][i])),symmetry_flags:row["flags"].as_u64().unwrap() as u32};
            assert_eq!(finalized_life(inputs).to_bits(),bits(&row["output"]),"{row}");
        }
    }
    #[test]
    fn map_birth_life_matches_native_age_selection_probability_and_rng() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_birth_life_probability_contract.json")).unwrap();
        assert_eq!(proof["profiles"],27);
        assert_eq!(proof["cases"].as_array().unwrap().len(),1404);
        for row in proof["cases"].as_array().unwrap() {
            let parameter=crate::native_scalar_parameter::ScalarParameter::read_numeric("p-life",1.,|key|row["fields"][key].as_array().map(|v|v.iter().map(|n|n.as_f64().unwrap() as f32).collect())).unwrap().unwrap();
            let input=crate::native_complex_age::EmitterAgeInput {config_308:1.,config_30c:1.,instance_7c:1.,time:f(&row["time_bits"]),owner_a8:0.,offset_2ec:0.};
            let modifiers=LifeModifiers {owner_scale:2.,scale_enabled:row["with_modifiers"].as_bool().unwrap(),velocity:[-2.,3.,-4.],coefficients:std::array::from_fn(|i|row["coefficients"][i].as_f64().unwrap() as f32),symmetry_flags:7};
            let mut rng=crate::native_random::Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let result=sample_birth_life(&parameter,input,modifiers,&mut rng).unwrap();
            for (actual,key) in [(result.age.normalized,"age_bits"),(result.base,"base_life_bits"),(result.sampled,"sampled_life_bits"),(result.final_life,"final_life_bits")] {assert_eq!(actual.to_bits(),bits(&row[key]),"{} {key}",row["name"]);}
            assert_eq!(rng.first,row["rng"]["first"].as_u64().unwrap() as u32);
            assert_eq!(rng.second,row["rng"]["second"].as_u64().unwrap() as u32);
            for i in 0..55 {assert_eq!(rng.words[i],row["rng"]["words"][i].as_u64().unwrap() as u32,"{}",row["name"]);}
        }
    }
}
