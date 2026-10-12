//! Native944E20..944EDD. Remaining attachment/curve/position producers separate.
pub struct State {pub last_time:u32,pub life:Vec<u32>,pub ages:Vec<u32>,pub active:u32}
fn arithmetic(a:u32,b:u32,divide:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);
    if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let result=if divide{x/y}else{x-y};if result.is_nan(){0xffc00000}else{result.to_bits()}
}
/// True means native age processing ran, and attachment/curve producers should
/// follow. False follows the epilogue path. This prefix does not write the final
/// last-time value; that belongs to the complete update's epilogue.
pub fn prepare(state:&mut State,time:u32,cap:u32,birth:&[u32])->Result<bool,&'static str> {
    if birth.len()!=state.life.len() || birth.len()!=state.ages.len() {return Err("mismatched native Simple arrays");}
    if 0.0>f32::from_bits(state.last_time){state.last_time=time;}
    let delta=arithmetic(time,state.last_time,false)&0x7fffffff;
    if birth.is_empty() || !(f32::from_bits(delta)>f32::from_bits(953267991)) {return Ok(false);}
    state.active=0;
    for (i,born) in birth.iter().enumerate() {
        if f32::from_bits(state.life[i])>f32::from_bits(cap){state.life[i]=cap;}
        state.ages[i]=arithmetic(arithmetic(time,*born,false),state.life[i],true);
        if 1.0>f32::from_bits(state.ages[i]){state.active=state.active.wrapping_add(1);}
    }
    Ok(true)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn multiple_particle_age_and_count_match2048_native_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_particle_age_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),2048);assert_eq!(p["emulator_cpu_case_disagreements"],0);
        for (i,r) in rows.iter().enumerate() {
            let n=|k:&str|r[k].as_u64().unwrap() as u32;let birth=words(&r["birth"]);
            let mut s=State {last_time:n("last_time"),life:words(&r["life"]),ages:vec![0xcccccccc;birth.len()],active:99};
            let ran=prepare(&mut s,n("time"),n("cap"),&birth).unwrap();let e=&r["cpu"];
            assert_eq!(ran,e["processed"].as_bool().unwrap(),"branch case{i}");assert_eq!(s.last_time,e["last_time"].as_u64().unwrap() as u32,"last case{i}");assert_eq!(s.active,e["active"].as_u64().unwrap() as u32,"active case{i}");assert_eq!(s.life,words(&e["life"]),"life case{i}");assert_eq!(s.ages,words(&e["ages"]),"age case{i}");
        }
    }
}
