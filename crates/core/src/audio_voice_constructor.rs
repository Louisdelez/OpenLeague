//! Original706C70 physical voice state, with explicit clock dependency.
use crate::{audio_release::Voice,audio_voice_refresh::RefreshState};
#[derive(Debug,Clone,Copy,PartialEq)]
pub enum Clock { Missing, NotReady, Ready(f32) }
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Error { ClockUnavailable, InvalidClock, InvalidEventName }
#[derive(Debug,Clone)]
pub struct PhysicalVoice {
    pub lifecycle:Voice,
    pub refresh:RefreshState,
    pub play_event:String,
    pub stop_event:String,
    /// Original constructor sets byte49 to1; semantics remain unqualified.
    pub flag49_raw:u8,
}
/// Playing/object IDs, record and stop resolution come from the actual backend.
/// The constructor does not validate registry existence or fabricate those IDs.
pub fn construct(playing_id:u32,object_id:u32,expected_record_raw:u32,
    play_event:&str,stop_event_id:u32,stop_event:&str,clock:Clock)->Result<PhysicalVoice,Error> {
    crate::audio_release::event_id(play_event).map_err(|_|Error::InvalidEventName)?;
    crate::audio_release::event_id(stop_event).map_err(|_|Error::InvalidEventName)?;
    let now=match clock {
        Clock::Missing|Clock::NotReady=>return Err(Error::ClockUnavailable),
        Clock::Ready(now) if now.is_finite()=>now,
        Clock::Ready(_)=>return Err(Error::InvalidClock),
    };
    Ok(PhysicalVoice {
        lifecycle:Voice {playing_id,object_id:object_id as i32,stop_event_id,released:false},
        refresh:RefreshState {started_at:now,expected_record_raw},
        play_event:play_event.into(),stop_event:stop_event.into(),flag49_raw:1,
    })
}
#[derive(Debug,Clone,PartialEq)]
pub enum Destruction {
    /// PostStopEvent is a notification of the supplied post callback. It must
    /// not be posted twice; StopPlayingId remains a backend action to consume.
    Release(crate::audio_release::ReleaseCommand),
    DestroyStopString, DestroyPlayString, FreeVoiceStorage,
}
impl PhysicalVoice {
    /// Explicit native706BC0 finalization. Consumes this state once; a real
    /// backend must call it at final ownership release, not every weak expiry.
    /// Storage flag controls external backend storage, not Rust allocation ABI.
    pub fn finalize(mut self,delete_flags:u8,engine_available:bool,
        post:impl FnMut(u32,u32)->u32,mut consume:impl FnMut(Destruction))->bool {
        if self.flag49_raw!=0 {
            for command in self.lifecycle.release(engine_available,post) {consume(Destruction::Release(command));}
        }
        consume(Destruction::DestroyStopString);
        consume(Destruction::DestroyPlayString);
        if delete_flags&1!=0 {consume(Destruction::FreeVoiceStorage);}
        self.lifecycle.released
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_540_original_constructor_cases_and_two_clock_failures() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_constructor_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),540);
        for case in cases {
            let voice=construct(case["playing_id"].as_u64().unwrap() as u32,case["object_id"].as_u64().unwrap() as u32,
                case["expected_record_raw"].as_u64().unwrap() as u32,case["play_event"].as_str().unwrap(),
                case["stop_event_id"].as_u64().unwrap() as u32,case["stop_event"].as_str().unwrap(),
                Clock::Ready(f32::from_bits(case["clock_bits"].as_u64().unwrap() as u32))).unwrap();
            assert_eq!(voice.lifecycle.playing_id,case["playing_id"].as_u64().unwrap() as u32);
            assert_eq!(voice.lifecycle.object_id as u32,case["object_id"].as_u64().unwrap() as u32);
            assert_eq!(voice.lifecycle.stop_event_id,case["stop_event_id"].as_u64().unwrap() as u32);
            assert_eq!(u8::from(voice.lifecycle.released),case["released_raw"].as_u64().unwrap() as u8);
            assert_eq!(voice.flag49_raw,case["flag49_raw"].as_u64().unwrap() as u8);
            assert_eq!(voice.refresh.started_at.to_bits(),case["clock_bits"].as_u64().unwrap() as u32);
            assert_eq!(voice.refresh.expected_record_raw,case["expected_record_raw"].as_u64().unwrap() as u32);
            assert_eq!(voice.play_event,case["play_event"].as_str().unwrap());assert_eq!(voice.stop_event,case["stop_event"].as_str().unwrap());
        }
        assert_eq!(data["fatal_cases"].as_array().unwrap().len(),2);
        for clock in [Clock::Missing,Clock::NotReady] {
            assert!(matches!(construct(7,123,2,"event",0,"",clock),Err(Error::ClockUnavailable)));
        }
        assert!(matches!(construct(7,123,2,"event",0,"",Clock::Ready(f32::NAN)),Err(Error::InvalidClock)));
    }
    #[test]
    fn posted_voice_constructor_refresh_and_stop_share_actual_identity() {
        use crate::{audio_event_post,audio_voice_refresh};
        let event="Play_sfx_TT_Shopkeeper_idle1";let object_id=123;
        let playing_id=audio_event_post::dispatch(event,object_id,42,0.,|p| {
            assert_eq!(p.object_id,object_id);assert_eq!(p.event,event);62
        },|_|panic!("zero age must not seek")).unwrap();
        let expected=crate::audio_release::event_id(event).unwrap();
        let stop_name=crate::audio_release::candidate_stop_name(event).unwrap();
        // Registry resolution is caller-supplied; hashing alone is not evidence
        // that an event exists. Here the bridge fixture supplies a resolved ID.
        let stop_id=crate::audio_release::event_id(&stop_name).unwrap();
        let mut voice=construct(playing_id,object_id,expected,event,stop_id,&stop_name,Clock::Ready(1000.25)).unwrap();
        let mut packets=vec![];
        let result=audio_voice_refresh::refresh(&mut voice.lifecycle,voice.refresh,1001.75,true,Some(expected),|p| {packets.push(p);1}).unwrap();
        assert!(result.matches_expected_record);assert_eq!(packets[0].object_id,123);assert_eq!(packets[0].value,1.5);
        let release=voice.lifecycle.release(true,|id,obj| {assert_eq!((id,obj),(stop_id,123));7});
        assert_eq!(release.len(),1);assert!(voice.lifecycle.released);
        assert!(voice.lifecycle.release(true,|_,_|panic!("already released")).is_empty());
    }
    #[test]
    fn matches_768_original_voice_destruction_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_destruction_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),768);
        for case in cases {
            let mut voice=construct(case["playing_id"].as_u64().unwrap() as u32,case["object_id"].as_i64().unwrap() as u32,0,"event",case["stop_event_id"].as_u64().unwrap() as u32,"stop",Clock::Ready(0.)).unwrap();
            voice.lifecycle.released=case["released"].as_bool().unwrap();voice.flag49_raw=case["flag49_raw"].as_u64().unwrap() as u8;
            let mut calls=vec![];
            let released=voice.finalize(case["delete_flags"].as_u64().unwrap() as u8,case["engine_available"].as_bool().unwrap(),
                |_,_|case["post_return"].as_u64().unwrap() as u32,
                |command|calls.push(match command {
                    Destruction::Release(c)=>serde_json::to_value(c).unwrap(),
                    Destruction::DestroyStopString=>serde_json::json!({"kind":"destroy_stop_string"}),
                    Destruction::DestroyPlayString=>serde_json::json!({"kind":"destroy_play_string"}),
                    Destruction::FreeVoiceStorage=>serde_json::json!({"kind":"free_voice"}),
                }));
            assert_eq!(calls,*case["calls"].as_array().unwrap());assert_eq!(released,case["final_released"].as_bool().unwrap());
        }
    }
    #[test]
    fn finalization_post_and_fallback_precede_resource_destruction() {
        use std::cell::RefCell;
        let order=RefCell::new(vec![]);
        let voice=construct(42,123,0,"play",9,"stop",Clock::Ready(0.)).unwrap();
        assert!(voice.finalize(1,true,|id,obj| {assert_eq!((id,obj),(9,123));order.borrow_mut().push("post");0},
            |c|order.borrow_mut().push(match c {
                Destruction::Release(crate::audio_release::ReleaseCommand::PostStopEvent {..})=>"post_notice",
                Destruction::Release(crate::audio_release::ReleaseCommand::StopPlayingId {..})=>"stop_fallback",
                Destruction::DestroyStopString=>"stop_string",Destruction::DestroyPlayString=>"play_string",Destruction::FreeVoiceStorage=>"free",
            })));
        assert_eq!(*order.borrow(),vec!["post","post_notice","stop_fallback","stop_string","play_string","free"]);
    }

}
