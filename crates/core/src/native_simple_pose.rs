//! Actual943300 owner matrix production; optional93BBD0 remains explicit.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct State {pub current:[u32;16],pub previous:[u32;16],pub initial_inverse:[u32;16]}
pub struct Input {pub emitter_local:u8,pub warm:u8,pub system_matrix:[u32;16],pub position:[u32;3],pub inverse_fallback:[u32;16],pub modifier:u32}
pub fn update(state:&mut State,input:&Input,time:u32,progress:u32,modifier:&mut impl FnMut(u32,u32,u32,&mut [u32;16])->Result<(),&'static str>)->Result<(),&'static str> {
    let mut next=state.clone();
    next.current=if input.emitter_local!=0 {input.system_matrix}else{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0})};
    next.current[12..15].copy_from_slice(&input.position);
    if input.warm==0 {
        next.previous=next.current;
        next.initial_inverse=crate::matrix_inverse::inverse(&next.previous.map(f32::from_bits),&input.inverse_fallback.map(f32::from_bits)).matrix.map(f32::to_bits);
    }
    if input.modifier!=0 {modifier(input.modifier,time,progress,&mut next.current)?;}
    *state=next;Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn floats<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|(v[i].as_f64().unwrap() as f32).to_bits())}
    #[test]
    fn cold_and_warm_pose_matches112_actual_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_attachment_cpu_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),112);
        let identity=std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0});
        for (i,row) in rows.iter().enumerate() {
            let r=&row["cpu"];let mut s=State {current:[0;16],previous:[0;16],initial_inverse:[0;16]};
            let mut input=Input {emitter_local:r["emitter_local"].as_u64().unwrap() as u8,warm:0,system_matrix:identity,position:[100f32,200.,300.].map(f32::to_bits),inverse_fallback:identity,modifier:0};
            update(&mut s,&input,10f32.to_bits(),0.5f32.to_bits(),&mut |_,_,_,_|panic!("native fixture has no modifier")).unwrap();
            assert_eq!(s.previous,floats(&r["initial"]),"initial case{i}");assert_eq!(s.initial_inverse,floats(&r["inverse"]),"inverse case{i}");
            let previous=s.previous;let inverse=s.initial_inverse;
            input.warm=1;input.system_matrix=floats(&r["system_matrix"]);input.position=floats(&r["current_position"]);
            update(&mut s,&input,10.125f32.to_bits(),0.5f32.to_bits(),&mut |_,_,_,_|panic!("native fixture has no modifier")).unwrap();
            assert_eq!(s.current,floats(&r["current"]),"current case{i}");assert_eq!(s.previous,previous);assert_eq!(s.initial_inverse,inverse);
        }
    }
    #[test]
    fn missing_modifier_preserves_owner_state() {
        let mut s=State {current:[7;16],previous:[8;16],initial_inverse:[9;16]};let before=s.clone();
        let input=Input {emitter_local:0,warm:0,system_matrix:[0;16],position:[0;3],inverse_fallback:[0;16],modifier:123};
        assert_eq!(update(&mut s,&input,11,12,&mut |r,t,p,_|{assert_eq!((r,t,p),(123,11,12));Err("unqualified93BBD0")}),Err("unqualified93BBD0"));assert_eq!(s,before);
    }
}
