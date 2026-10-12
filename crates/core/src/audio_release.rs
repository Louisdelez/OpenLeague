//! Original 4.20 voice release control flow (706f90), separate from routing.
use serde::{Deserialize, Serialize};

/// Native ASCII case-folded FNV-1, bounded to the verified string buffer.
pub fn event_id(name: &str) -> Result<u32, &'static str> {
    if !name.is_ascii() || name.len() > 258 || name.as_bytes().contains(&0) {
        return Err("unqualified native event name");
    }
    Ok(name.bytes().fold(0x811c_9dc5u32, |hash, byte| {
        hash.wrapping_mul(0x0100_0193) ^ u32::from(byte.to_ascii_lowercase())
    }))
}

/// Native string replacement changes the first five bytes to Stop_, then
/// queries the bank registry. A generated hash alone does not prove existence.
pub fn candidate_stop_name(play: &str) -> Result<String, &'static str> {
    event_id(play)?;
    Ok(format!("Stop_{}", &play[play.len().min(5)..]))
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum ReleaseCommand {
    PostStopEvent { event_id: u32, object_id: u32 },
    StopPlayingId { playing_id: u32, duration_ms: u32, curve: u32 },
}

#[derive(Debug, Clone)]
pub struct Voice {
    pub playing_id: u32,
    pub object_id: i32,
    /// Zero when the queried Stop event is unavailable.
    pub stop_event_id: u32,
    pub released: bool,
}
impl Voice {
    /// Backend callback returns the playing ID of the posted Stop event.
    /// A zero response requests immediate fallback for the original playing ID.
    /// An unavailable engine leaves release pending; a second release after
    /// successful processing emits no additional commands.
    pub fn release(&mut self, engine_available: bool, mut post: impl FnMut(u32, u32) -> u32)
        -> Vec<ReleaseCommand> {
        if self.released || !engine_available { return vec![]; }
        let mut commands=vec![];
        let mut stop_posted=false;
        if self.stop_event_id != 0 && self.object_id != -1 {
            commands.push(ReleaseCommand::PostStopEvent {
                event_id:self.stop_event_id, object_id:self.object_id as u32,
            });
            stop_posted=post(self.stop_event_id,self.object_id as u32)!=0;
        }
        if !stop_posted && self.playing_id != 0 {
            commands.push(ReleaseCommand::StopPlayingId {
                playing_id:self.playing_id, duration_ms:0, curve:4,
            });
        }
        self.released=true;
        commands
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_release_sequences_match_including_duplicate_requests() {
        #[derive(Deserialize)] struct Case {
            released:bool,engine_available:bool,stop_event_id:u32,object_id:i32,
            playing_id:u32,post_result:u32,calls:Vec<ReleaseCommand>,final_released:bool,
        }
        #[derive(Deserialize)] struct Contract {release_cases:Vec<Case>}
        let contract:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_release_contract.json")).unwrap();
        assert_eq!(contract.release_cases.len(),64);
        for c in contract.release_cases {
            let mut voice=Voice {playing_id:c.playing_id,object_id:c.object_id,stop_event_id:c.stop_event_id,released:c.released};
            let mut commands=vec![];
            for _ in 0..2 {commands.extend(voice.release(c.engine_available,|_,_|c.post_result));}
            assert_eq!(commands,c.calls);
            assert_eq!(voice.released,c.final_released);
        }
    }

    #[test]
    fn native_event_hashes_and_stop_event_bank_values_match() {
        #[derive(Deserialize)] struct HashCase {name:String,native_id:u32}
        #[derive(Deserialize)] struct Action {transition_ms:u32,curve:u32,action_type:u32}
        #[derive(Deserialize)] struct Event {play_name:String,stop_name:String,candidate_stop_id:u32,stop_id:u32,found_in_source_banks:bool,actions:Vec<Action>}
        #[derive(Deserialize)] struct Contract {hash_cases:Vec<HashCase>,events:Vec<Event>}
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_release_contract.json")).unwrap();
        assert_eq!(c.hash_cases.len(),10);
        for h in c.hash_cases {assert_eq!(event_id(&h.name).unwrap(),h.native_id);}
        let mut action_count=0;
        for e in c.events {
            assert_eq!(candidate_stop_name(&e.play_name).unwrap(),e.stop_name);
            assert_eq!(event_id(&e.stop_name).unwrap(),e.candidate_stop_id);
            assert_eq!(e.stop_id,if e.found_in_source_banks {e.candidate_stop_id}else{0});
            for a in e.actions {
                action_count+=1;assert_eq!(a.curve,4);assert_eq!(a.action_type,259);
                assert_eq!(a.transition_ms,if e.play_name.contains("Shopkeeper") {500}else{300});
            }
        }
        assert_eq!(action_count,6);
    }

    #[test]
    fn unavailable_engine_keeps_release_pending_then_retries_once() {
        let mut v=Voice {playing_id:42,object_id:123,stop_event_id:9,released:false};
        assert!(v.release(false,|_,_|panic!("engine unavailable")).is_empty());
        assert!(!v.released);
        let mut posts=0;
        assert_eq!(v.release(true,|_,_|{posts+=1;7}).len(),1);
        assert!(v.release(true,|_,_|panic!("duplicate release")).is_empty());
        assert_eq!(posts,1);
    }

    #[test]
    fn invalid_object_uses_playing_id_fallback_without_posting() {
        let mut v=Voice {playing_id:42,object_id:-1,stop_event_id:9,released:false};
        assert_eq!(v.release(true,|_,_|panic!("invalid object")),vec![ReleaseCommand::StopPlayingId {playing_id:42,duration_ms:0,curve:4}]);
    }

    #[test]
    fn unsupported_event_names_are_explicit_errors() {
        for name in ["évent".to_owned(),"a\0b".to_owned(),"x".repeat(259)] {
            assert!(event_id(&name).is_err());assert!(candidate_stop_name(&name).is_err());
        }
    }
}
