//! Original 706D70 voice refresh and seconds RTPC request.
//! Playing-record values remain raw: their meaning is not inferred here.
use crate::audio_release::Voice;
pub const SECONDS_PARAMETER_ID:u32=745018932;
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct RefreshState {pub started_at:f32,pub expected_record_raw:u32}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct SecondsCommand {pub parameter_id:u32,pub value:f32,pub object_id:u32}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct RefreshResult {
    pub matches_expected_record:bool,
    pub command:Option<SecondsCommand>,
    pub setter_success:bool,
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub enum Error {InvalidClock}
/// Refresh still compares the playing record when the engine is unavailable.
/// A matching record does not clear a prior released flag. RTPC setter failure
/// does not affect the comparison result. A missing manager/record yields raw0.
pub fn refresh(voice:&mut Voice,state:RefreshState,now:f32,engine_available:bool,
    observed_record:Option<u32>,mut enqueue:impl FnMut(SecondsCommand)->u32)->Result<RefreshResult,Error> {
    let value=(now as f64-state.started_at as f64) as f32;
    if !now.is_finite() || !state.started_at.is_finite() || !value.is_finite() {return Err(Error::InvalidClock);}
    let command=(voice.object_id!=-1 && engine_available).then_some(SecondsCommand {
        parameter_id:SECONDS_PARAMETER_ID,value,object_id:voice.object_id as u32,
    });
    let setter_success=command.is_some_and(|c|enqueue(c)==1);
    let matches_expected_record=observed_record.unwrap_or(0)==state.expected_record_raw;
    if !matches_expected_record {voice.released=true;}
    Ok(RefreshResult {matches_expected_record,command,setter_success})
}
#[cfg(test)]
mod tests {
    use super::*;
    #[derive(serde::Deserialize)]
    struct Packet {parameter_id:u32,value_bits:u32,object_id:u32}
    #[derive(serde::Deserialize)]
    struct Case {
        start:f32,now:f32,manager_exists:bool,found:bool,observed_raw:u32,expected_raw:u32,
        prior_released:u8,object_id:i32,engine_available:bool,queue_result:u32,elapsed_bits:u32,
        packets:Vec<Packet>,native_return:bool,native_released:u8,
    }
    #[derive(serde::Deserialize)]
    struct Contract {cases:Vec<Case>,parameter_name:String,parameter_id:u32}
    #[test]
    fn native_seconds_packets_lookup_comparison_and_flags_match_all_cases() {
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_refresh_contract.json")).unwrap();
        assert_eq!(c.cases.len(),1440);assert_eq!(c.parameter_name,"seconds");
        assert_eq!(crate::audio_release::event_id(&c.parameter_name).unwrap(),c.parameter_id);
        assert_eq!(c.parameter_id,SECONDS_PARAMETER_ID);
        for c in c.cases {
            let mut voice=Voice {playing_id:62,object_id:c.object_id,stop_event_id:1234,released:c.prior_released!=0};
            let mut commands=Vec::new();
            let result=refresh(&mut voice,RefreshState {started_at:c.start,expected_record_raw:c.expected_raw},c.now,c.engine_available,
                (c.manager_exists && c.found).then_some(c.observed_raw),|command| {commands.push(command);c.queue_result}).unwrap();
            assert_eq!(result.matches_expected_record,c.native_return);
            assert_eq!(voice.released,c.native_released!=0);assert_eq!(voice.playing_id,62);assert_eq!(voice.stop_event_id,1234);
            assert_eq!(commands.len(),c.packets.len());assert_eq!(result.command,commands.first().copied());
            assert_eq!(result.setter_success,!commands.is_empty() && c.queue_result==1);
            for (command,p) in commands.iter().zip(&c.packets) {
                assert_eq!(command.parameter_id,p.parameter_id);assert_eq!(command.object_id,p.object_id);
                assert_eq!(command.value.to_bits(),p.value_bits);assert_eq!(command.value.to_bits(),c.elapsed_bits);
            }
        }
    }
    #[test]
    fn mismatch_release_gate_and_invalid_clock_preserve_native_order() {
        let mut voice=Voice {playing_id:62,object_id:123,stop_event_id:0,released:false};
        let state=RefreshState {started_at:10.,expected_record_raw:2};
        let mut commands=Vec::new();
        let result=refresh(&mut voice,state,11.,false,None,|c| {commands.push(c);1}).unwrap();
        assert!(!result.matches_expected_record);assert!(voice.released);assert!(commands.is_empty());
        assert!(voice.release(true,|_,_|panic!("already flagged")).is_empty());
        let matched=refresh(&mut voice,state,12.,true,Some(2),|c| {commands.push(c);2}).unwrap();
        assert!(matched.matches_expected_record && !matched.setter_success);assert!(voice.released);
        assert_eq!(commands[0].value,2.);
        let invalid=refresh(&mut voice,state,f32::NAN,true,Some(2),|_|panic!("invalid clock"));
        assert_eq!(invalid,Err(Error::InvalidClock));assert!(voice.released);
    }
}