//! Original9344D1..934575 emission gates/phase reset with count callback separate.
#[derive(Debug,Copy,Clone)]
pub struct Inputs {
    pub time:f32,pub elapsed:f32,pub period:f32,pub active:f32,pub offset:f32,pub duration:f32,
    pub flag334:u32,pub flag74:u8,pub flag11c:u8,pub past_end:bool,
}
#[derive(Debug,Copy,Clone)]
pub struct State {pub field118:u32,pub field108:f32}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub enum Decision {Blocked,PhaseReset,Count {value:i32,birth_requested:bool}}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub enum Error {UnsupportedInput}
/// Positive finite period and finite time/elapsed/active/offset/duration currently
/// qualified. Unsupported inputs are explicit, not silently assigned a phase.
pub fn evaluate(input:Inputs,state:&mut State,mut count:impl FnMut(f32)->i32)->Result<Decision,Error> {
    if [input.time,input.elapsed,input.period,input.active,input.offset,input.duration].iter().any(|v|!v.is_finite()) || input.period<=0. {return Err(Error::UnsupportedInput);}
    if (input.flag334!=0 && input.flag74!=0) || input.flag11c!=0 {return Ok(Decision::Blocked);}
    // Exact-1 sentinel bypasses the time-offset gate.
    if input.offset!=-1. && input.elapsed<input.offset {return Ok(Decision::Blocked);}
    if !(input.duration<0. || input.duration>input.elapsed) {return Ok(Decision::Blocked);}
    // Original _CIfmod/FPREM consumes exact stored f32 inputs on x87. f64
    // remainder yields the same branch decisions on captured finite fixtures.
    let phase=f64::from(input.elapsed)%f64::from(input.period);
    if !(f64::from(input.active)>phase) {
        state.field118=0;state.field108=f32::MIN;
        return Ok(Decision::PhaseReset);
    }
    if input.past_end {return Ok(Decision::Blocked);}
    let value=count(input.time);
    Ok(Decision::Count {value,birth_requested:value>0})
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value,json};
    #[test]
    fn gates_period_resets_and_birth_arguments_match_original_branches() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_emission_gate_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),1173);
        let mut births=0;let mut resets=0;
        for row in proof["cases"].as_array().unwrap() {
            let f=|key:&str|row[key].as_f64().unwrap() as f32;
            let input=Inputs {time:f("time"),elapsed:f("elapsed"),period:f("period"),active:f("active"),offset:f("offset"),duration:f("duration"),flag334:row["flag334"].as_u64().unwrap() as u32,flag74:row["flag74"].as_u64().unwrap() as u8,flag11c:row["flag11c"].as_u64().unwrap() as u8,past_end:row["past_end"].as_bool().unwrap()};
            let mut state=State {field118:17,field108:8.};let mut events=Vec::new();
            let decision=evaluate(input,&mut state,|time| {events.push(json!({"kind":"count","time_bits":format!("{:#x}",time.to_bits())}));row["count_result"].as_i64().unwrap() as i32}).unwrap();
            if let Decision::Count {value,birth_requested:true}=decision {events.push(json!({"kind":"birth","time_bits":format!("{:#x}",input.time.to_bits()),"count":value}));births+=1;}
            if decision==Decision::PhaseReset {resets+=1;}
            assert_eq!(events,row["events"].as_array().unwrap().to_vec(),"{row}");
            assert_eq!(state.field118,row["state_118"].as_u64().unwrap() as u32,"{row}");
            assert_eq!(format!("{:#x}",state.field108.to_bits()),row["state_108_bits"].as_str().unwrap(),"{row}");
        }
        assert_eq!((births,resets),(162,246));
    }
}
