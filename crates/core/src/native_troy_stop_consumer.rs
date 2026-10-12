//! Original9406DB..94071E request dispatch. Remaining frame requests/reset separate.
use crate::audio_emitter_stop::StopState;
pub trait Backend {
    fn detach(&mut self,key:u32);
    fn owner_eligible(&mut self)->bool;
    fn owner_key(&mut self)->u32;
    fn owner_cleanup(&mut self,identity:u32,key:u32);
    fn clock(&mut self)->f32;
    fn audio_release(&mut self,handle:i32);
}
pub struct Consumer {pub attachments:Vec<u32>,pub owner_threshold:Option<f32>}
impl Consumer {
    /// The linked emitter identity/state come from the wrapper's114 link.
    /// Requests remain unchanged here; final reset belongs to the full frame.
    pub fn consume(&mut self,requests:u32,linked:bool,identity:u32,state:&mut StopState,config_flags:u8,pending:&mut Vec<u32>,backend:&mut impl Backend)->Result<bool,&'static str> {
        if !linked || requests&0x400==0 {return Ok(false);}
        if state.flags&0x40==0 && pending.windows(2).any(|w|w[0]>w[1]) {return Err("unsorted emitter stop queue");}
        for key in self.attachments.drain(..) {backend.detach(key);}
        if let Some(threshold)=self.owner_threshold {
            // Original asks eligibility before testing threshold. NaN is unordered.
            if backend.owner_eligible() && threshold>=0. {
                let key=backend.owner_key();backend.owner_cleanup(identity,key);
            }
        }
        let clock=backend.clock();
        state.request(clock,config_flags,identity,pending,|handle|backend.audio_release(handle))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value,json};
    struct Recorder {events:Vec<Value>,eligible:bool,clock:f32}
    impl Backend for Recorder {
        fn detach(&mut self,key:u32) {self.events.push(json!({"event":"detach","key":key}));}
        fn owner_eligible(&mut self)->bool {self.events.push(json!({"event":"owner_eligible"}));self.eligible}
        fn owner_key(&mut self)->u32 {self.events.push(json!({"event":"owner_key"}));77}
        fn owner_cleanup(&mut self,identity:u32,key:u32) {self.events.push(json!({"event":"owner_cleanup","actor":identity,"key":key}));}
        fn clock(&mut self)->f32 {self.events.push(json!({"event":"clock"}));self.clock}
        fn audio_release(&mut self,key:i32) {self.events.push(json!({"event":"audio_release","key":key}));}
    }
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn original_dispatch_helpers_stop_audio_queue_and_repeated_requests_match320cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_stop_consumer_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),320);
        for case in proof["cases"].as_array().unwrap() {
            let mut consumer=Consumer {attachments:(0..case["attachment_count"].as_u64().unwrap()).map(|i|100+i as u32).collect(),owner_threshold:case["owner_present"].as_bool().unwrap().then(||case["owner_threshold"].as_f64().unwrap() as f32)};
            let mut state=StopState {flags:case["flags"].as_u64().unwrap() as u8,stop_time:999.,handles:[0,42]};let mut pending=vec![];
            let requests=case["requests"].as_u64().unwrap() as u32;
            let mut backend=Recorder {events:vec![],eligible:case["owner_eligible"].as_bool().unwrap(),clock:f32::from_bits(bits(&case["clock_bits"]))};
            for row in case["snapshots"].as_array().unwrap() {
                consumer.consume(requests,case["linked"].as_bool().unwrap(),case["actor"].as_u64().unwrap() as u32,&mut state,case["config_flags"].as_u64().unwrap() as u8,&mut pending,&mut backend).unwrap();
                assert_eq!(json!(backend.events),row["events"],"{case}");assert_eq!(json!(pending),row["pending"]);
                assert_eq!(state.flags,row["flags"].as_u64().unwrap() as u8);assert_eq!(state.stop_time.to_bits(),bits(&row["stop_time"]));assert_eq!(json!(state.handles),row["handles"]);
                assert_eq!(consumer.attachments.len(),row["attachment_count"].as_u64().unwrap() as usize);assert_eq!(requests,row["requests"].as_u64().unwrap() as u32);
            }
        }
    }
}
