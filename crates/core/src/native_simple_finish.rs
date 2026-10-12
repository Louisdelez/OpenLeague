//! Native943ADA..943B58, composed with the existing qualified8DEC10 inverse.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct State {pub previous:[u32;16],pub previous_inverse:[u32;16],pub last_time:u32,pub finished:u8}
pub struct Input {pub current_pose:[u32;16],pub inverse_fallback:[u32;16],pub time:u32,pub expired:u8,pub storage_present:bool,pub active_particles:u32}
/// The current pose is copied raw before inversion; raw time is written after
/// both copies. Expiration and active count are independent of allocated slots.
pub fn finish(state:&mut State,input:&Input) {
    state.previous=input.current_pose;
    state.previous_inverse=crate::matrix_inverse::inverse(&input.current_pose.map(f32::from_bits),&input.inverse_fallback.map(f32::from_bits)).matrix.map(f32::to_bits);
    state.last_time=input.time;
    state.finished=u8::from(input.expired!=0 && (!input.storage_present || input.active_particles==0));
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|v[i].as_u64().unwrap() as u32)}
    #[test]
    fn pose_inverse_and_tail_writes_match1152_native_cases_bit_exactly() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_finish_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),1152);
        for (i,r) in rows.iter().enumerate() {
            let n=|key:&str|r[key].as_u64().unwrap() as u32;
            let mut state=State {previous:[0xcccccccc;16],previous_inverse:[0xdddddddd;16],last_time:0xffa05678,finished:255};
            finish(&mut state,&Input {current_pose:words(&r["matrix"]),inverse_fallback:words(&r["fallback"]),time:n("time"),expired:n("expired") as u8,storage_present:r["present"].as_bool().unwrap(),active_particles:n("active")});
            let e=&r["native"];
            assert_eq!(state,State {previous:words(&e["previous"]),previous_inverse:words(&e["inverse"]),last_time:e["last_time"].as_u64().unwrap() as u32,finished:e["finished"].as_u64().unwrap() as u8},"case{i}");
        }
    }
}
