//! Native 93EE30 dispatch policy. Playback and owner producers are backend contracts.
pub trait Backend {
    fn owner_eligible(&mut self) -> u8;
    fn owner_id(&mut self) -> u32;
    fn play_primary(&mut self, descriptor: &[u8; 24], position: [u32; 3], elapsed: u32);
    fn play_secondary(&mut self, descriptor: &[u8; 24], owner_id: u32, position: [u32; 3], elapsed: u32);
}
pub struct Input {
    pub time: u32,
    pub start: u32,
    pub descriptors: [[u8; 24]; 2],
    pub position: [u32; 3],
    pub owner_present: bool,
}
fn subtract(a: u32, b: u32) -> u32 {
    let x = f32::from_bits(a); let y = f32::from_bits(b);
    if x.is_nan() { return a | 0x00400000; }
    if y.is_nan() { return b | 0x00400000; }
    let value = x - y;
    if value.is_nan() { 0xffc00000 } else { value.to_bits() }
}
pub fn emit(flags: &mut u8, input: &Input, backend: &mut impl Backend) {
    if *flags & 0x20 != 0 { return; }
    let elapsed = subtract(input.time, input.start);
    // COMISS/JBE skips unordered and elapsed >= 1, including positive infinity.
    if f32::from_bits(elapsed) < 1.0 {
        let present = |d: &[u8; 24]| u32::from_le_bytes(d[16..20].try_into().unwrap()) != 0;
        if present(&input.descriptors[0]) {
            backend.play_primary(&input.descriptors[0], input.position, elapsed);
        }
        if present(&input.descriptors[1]) {
            let owner_id = if input.owner_present && backend.owner_eligible() != 0 { backend.owner_id() } else { 0 };
            backend.play_secondary(&input.descriptors[1], owner_id, input.position, elapsed);
        }
    }
    *flags |= 0x20;
}
/// Compose the real dispatch policy with the qualified tail. It reads the OLD
/// time before the tail replaces it; supplied backend must fulfill its producers.
pub fn finish(state: &mut crate::native_troy_frame_finish::State, tail: &crate::native_troy_frame_finish::Input, start: u32, descriptors: [[u8; 24]; 2], position: [u32; 3], owner_present: bool, backend: &mut impl Backend) -> bool {
    crate::native_troy_frame_finish::finish_with(state, tail, |state| {
        emit(&mut state.flags, &Input { time: state.last_input_time, start, descriptors, position, owner_present }, backend);
    })
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value, json};
    struct Adapter { events: Vec<Value>, eligibility: u8 }
    impl Adapter {
        fn record(&mut self, kind: &str, d: &[u8; 24], id: Option<u32>, p: [u32; 3], e: u32) {
            self.events.push(json!({"event":"audio_create","kind":kind,"owner_id":id,"elapsed":format!("0x{e:x}"),"descriptor":d.iter().map(|b|format!("{b:02x}")).collect::<String>(),"position":p.map(|b|format!("0x{b:x}"))}));
        }
    }
    impl Backend for Adapter {
        fn owner_eligible(&mut self)->u8 {self.events.push(json!({"event":"eligible"}));self.eligibility}
        fn owner_id(&mut self)->u32 {self.events.push(json!({"event":"owner_id"}));1234}
        fn play_primary(&mut self,d:&[u8;24],p:[u32;3],e:u32){self.record("primary",d,None,p,e)}
        fn play_secondary(&mut self,d:&[u8;24],id:u32,p:[u32;3],e:u32){self.record("secondary",d,Some(id),p,e)}
    }
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn dispatch_matches960_native_captures_with_active_descriptors() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_oneshot_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),960);
        for (i,row) in cases.iter().enumerate() {
            let descriptors=std::array::from_fn(|n| {let mut d=[0x41+n as u8;24];d[16..20].copy_from_slice(&(row["descriptors"][n].as_u64().unwrap() as u32).to_le_bytes());d});
            let mut flags=row["flags"].as_u64().unwrap() as u8;
            let mut b=Adapter {events:vec![],eligibility:row["eligibility"].as_u64().unwrap() as u8};
            emit(&mut flags,&Input {time:bits(&row["time"]),start:bits(&row["start"]),descriptors,position:std::array::from_fn(|n|bits(&row["position"][n])),owner_present:row["owner_present"].as_bool().unwrap()},&mut b);
            assert_eq!(flags,row["cpu"]["flags"].as_u64().unwrap() as u8,"case{i}");
            assert_eq!(b.events,row["cpu"]["events"].as_array().unwrap().clone(),"case{i}");
        }
    }
    #[test]
    fn composed_tail_dispatches_before_time_replacement_and_stopped_tail_skips() {
        use crate::native_troy_frame_finish::{State,Input as Tail};
        let mut d=[[0;24];2];d[0][16]=1;
        let mut state=State {last_input_time:0x3f000000,flags:0,counter:0};
        let mut b=Adapter {events:vec![],eligibility:0};
        let mut tail=Tail {time:0x40000000,visible:1,emit:true,stopped:false,one_shot_descriptors_enabled:[true,false]};
        assert!(finish(&mut state,&tail,0,d,[0;3],false,&mut b));
        assert_eq!(b.events[0]["elapsed"],"0x3f000000");
        assert_eq!(state,State {last_input_time:0x40000000,flags:0x24,counter:1});
        b.events.clear();tail.stopped=true;
        assert!(!finish(&mut state,&tail,0,d,[0;3],false,&mut b));assert!(b.events.is_empty());assert_eq!(state.counter,2);
    }
}
