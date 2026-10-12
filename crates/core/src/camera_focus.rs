//! Full original7D1A60 focus hold and two-pass spatial restriction, context supplied by caller.
#[derive(Debug,Clone,Copy)]
pub struct State {pub current:[f32;3],pub saved:[f32;3],pub held_raw:u8}
#[derive(Debug,Clone,Copy)]
pub struct Context {pub active_raw:u8,pub service_flag_raw:u8,pub special_flag_raw:u8}
#[derive(Debug,Clone,Copy)]
pub struct Restriction {pub min_x:f32,pub max_x:f32,pub min_z:f32,pub max_z:f32,pub center:[f32;3],pub radius:f32}
fn axis(value:f32,minimum:f32,maximum:f32)->f32 {if value>maximum {maximum} else if minimum>value {minimum} else {value}}
/// Required native service is assumed ready; its flags and current bounds are explicit inputs.
pub fn update(initial:&State,context:&Context,restriction:&Restriction)->Result<State,&'static str> {
    let mut state=*initial;
    if (context.active_raw!=0 && context.service_flag_raw!=0) || context.special_flag_raw!=0 {
        if state.held_raw!=0 {state.current=state.saved;}
        else {state.saved=state.current;state.held_raw=1;}
    } else {state.held_raw=0;}
    for _ in 0..2 {
        state.current[0]=axis(state.current[0],restriction.min_x,restriction.max_x);state.current[2]=axis(state.current[2],restriction.min_z,restriction.max_z);
        if restriction.radius>0. {
            let x=state.current[0]-restriction.center[0];let z=state.current[2]-restriction.center[2];
            if x*x+z*z>restriction.radius*restriction.radius {
                let mut relative=std::array::from_fn::<_,3,_>(|i|state.current[i]-restriction.center[i]);
                let squared=(relative[0]*relative[0]+relative[1]*relative[1])+relative[2]*relative[2];
                if squared>f32::from_bits(NORMALIZATION_THRESHOLD) {
                    let factor=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;
                    for value in &mut relative {*value=(*value as f64*factor as f64) as f32;}
                }
                state.current=std::array::from_fn(|i|relative[i]*restriction.radius+restriction.center[i]);
            }
        }
    }
    Ok(state)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_384_full_native_focus_hold_and_two_pass_restrictions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_focus_contract.json")).unwrap();assert_eq!(NORMALIZATION_THRESHOLD,proof["normalization_threshold_bits"].as_u64().unwrap() as u32);let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),384);
        for (case_index,c) in cases.iter().enumerate() {
            let vector=|key:&str|std::array::from_fn(|i|c[key][i].as_f64().unwrap() as f32);let state=State{current:vector("focus"),saved:vector("saved"),held_raw:c["held_raw"].as_u64().unwrap() as u8};let context=Context{active_raw:c["active_raw"].as_u64().unwrap() as u8,service_flag_raw:c["service_flag_raw"].as_u64().unwrap() as u8,special_flag_raw:c["special_flag_raw"].as_u64().unwrap() as u8};let restriction=Restriction{min_x:c["rectangle"][0].as_f64().unwrap() as f32,max_x:c["rectangle"][1].as_f64().unwrap() as f32,min_z:c["rectangle"][2].as_f64().unwrap() as f32,max_z:c["rectangle"][3].as_f64().unwrap() as f32,center:vector("center"),radius:c["radius"].as_f64().unwrap() as f32};
            let result=update(&state,&context,&restriction).unwrap();assert_eq!(result.held_raw,c["output_held_raw"].as_u64().unwrap() as u8,"case{case_index}held");
            for i in 0..3 {
                let original=f32::from_bits(c["output_bits"][i].as_u64().unwrap() as u32);
                if restriction.radius<=0. {assert_eq!(result.current[i].to_bits(),original.to_bits(),"case{case_index}focus{i}");}
                else {assert!((result.current[i]-original).abs()<=1e-5_f32.max(original.abs()*2e-6),"case{case_index}focus{i}: {} vs{original}",result.current[i]);}
                assert_eq!(result.saved[i].to_bits(),c["output_bits"][i+3].as_u64().unwrap() as u32,"case{case_index}saved{i}");
            }
        }
    }
}

const NORMALIZATION_THRESHOLD:u32=814313567;
