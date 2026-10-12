//! Original6D37A0 championname body, shared by plain and localized dispatchers.
use crate::audio_announcer_actor_name::NameStorage;
pub const PATTERN:&[u8]=b" championname@";
pub trait Backend<A:Copy> {
    type Character:Copy;
    fn flags(&mut self,actor:A)->Result<u32,&'static str>;
    fn character(&mut self,actor:A)->Result<Option<Self::Character>,&'static str>;
    /// Single byte at pointer(character+9E4)+10, not a whole length/flag word.
    fn gate_byte(&mut self,character:Self::Character)->Result<u8,&'static str>;
    fn character_name(&mut self,character:Self::Character)->Result<NameStorage<'_>,&'static str>;
    fn fallback_name(&mut self,actor:A)->Result<NameStorage<'_>,&'static str>;
}
pub fn champion_name_bytes<A:Copy>(actor:Option<A>,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
    let Some(actor)=actor else {return Ok(vec![]);};
    if backend.flags(actor)?&0x1000==0 {return Ok(vec![]);}
    if backend.character(actor)?.is_some() {
        let second=backend.character(actor)?.ok_or("native second character object unavailable")?;
        if backend.gate_byte(second)?!=0 {
            let third=backend.character(actor)?.ok_or("native third character object unavailable")?;
            return Ok(backend.character_name(third)?.nul_bytes()?.to_vec());
        }
    }
    Ok(backend.fallback_name(actor)?.nul_bytes()?.to_vec())
}
pub fn bind_champion_name_bytes<A:Copy>(input:&[u8],actor:Option<A>,backend:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
    if !input.get(..PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(PATTERN)) {return Ok(None);}
    champion_name_bytes(actor,backend).map(Some)
}
pub const ALLIED_PATTERN:&[u8]=b" allychampionname@";
pub trait TeamBackend<A:Copy>:Backend<A> {fn team(&mut self,actor:A)->Result<u32,&'static str>;}
pub fn allied_champion_name_bytes<A:Copy>(actor:Option<A>,local:Option<A>,backend:&mut impl TeamBackend<A>)->Result<Vec<u8>,&'static str> {
    let (Some(actor),Some(local))=(actor,local) else {return Ok(vec![]);};
    let local_team=backend.team(local)?;
    if local_team!=backend.team(actor)? {return Ok(vec![]);}
    champion_name_bytes(Some(actor),backend)
}
pub fn bind_allied_champion_name_bytes<A:Copy>(input:&[u8],actor:Option<A>,local:Option<A>,backend:&mut impl TeamBackend<A>)->Result<Option<Vec<u8>>,&'static str> {
    if !input.get(..ALLIED_PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(ALLIED_PATTERN)) {return Ok(None);}
    allied_champion_name_bytes(actor,local,backend).map(Some)
}
#[cfg(test)] mod tests {
    use super::*;
    struct Storage {inline:[u8;16],heap:Vec<u8>,capacity:u32}
    impl Storage {
        fn new(s:&str)->Self {let mut inline=[0;16];if s.len()<16 {inline[..s.len()].copy_from_slice(s.as_bytes());}let mut heap=s.as_bytes().to_vec();heap.push(0);Self {inline,heap,capacity:if s.len()<16 {15} else {s.len() as u32}}}
        fn view(&self)->NameStorage<'_> {NameStorage {inline:&self.inline,capacity:self.capacity,heap:Some(&self.heap)}}
    }
    struct Provider {flags:u32,present:bool,gate:u32,fallback:Storage,provided:Storage,calls:Vec<usize>,flag_reads:u64,gate_reads:Vec<usize>}
    impl Backend<u32> for Provider {
        type Character=usize;
        fn flags(&mut self,actor:u32)->Result<u32,&'static str>{assert_eq!(actor,7);self.flag_reads+=1;Ok(self.flags)}
        fn character(&mut self,actor:u32)->Result<Option<usize>,&'static str>{assert_eq!(actor,7);let i=self.calls.len();assert!(i<3);self.calls.push(i);Ok(if i==0&&!self.present {None} else {Some(i)})}
        fn gate_byte(&mut self,character:usize)->Result<u8,&'static str>{assert_eq!(character,1);self.gate_reads.push(1);Ok(self.gate as u8)}
        fn character_name(&mut self,character:usize)->Result<NameStorage<'_>,&'static str>{assert_eq!(character,2);Ok(self.provided.view())}
        fn fallback_name(&mut self,actor:u32)->Result<NameStorage<'_>,&'static str>{assert_eq!(actor,7);Ok(self.fallback.view())}
    }
    #[test] fn audio_champion_name_matches6480_native_fresh_object_gate_byte_and_inline_heap_fallback_frames() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_champion_name_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),6480);
        for c in cases {
            let mut p=Provider {flags:c["flags"].as_u64().unwrap() as u32,present:c["first_character_present"].as_bool().unwrap(),gate:c["gate_word"].as_u64().unwrap() as u32,fallback:Storage::new(c["fallback_name"].as_str().unwrap()),provided:Storage::new(c["provided_character_name"].as_str().unwrap()),calls:vec![],flag_reads:0,gate_reads:vec![]};
            let output=bind_champion_name_bytes(c["input"].as_str().unwrap().as_bytes(),c["exists"].as_bool().unwrap().then_some(7),&mut p).unwrap().unwrap();
            assert_eq!(output.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.calls),c["getter_calls"]);assert_eq!(p.flag_reads,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(p.gate_reads),c["gate_read_sizes"]);
        }
    }
    struct AlliedProvider {inner:Provider,values:[u32;2],team_calls:Vec<serde_json::Value>}
    impl Backend<u32> for AlliedProvider {
        type Character=usize;
        fn flags(&mut self,a:u32)->Result<u32,&'static str>{self.inner.flags(a)}
        fn character(&mut self,a:u32)->Result<Option<usize>,&'static str>{self.inner.character(a)}
        fn gate_byte(&mut self,c:usize)->Result<u8,&'static str>{self.inner.gate_byte(c)}
        fn character_name(&mut self,c:usize)->Result<NameStorage<'_>,&'static str>{self.inner.character_name(c)}
        fn fallback_name(&mut self,a:u32)->Result<NameStorage<'_>,&'static str>{self.inner.fallback_name(a)}
    }
    impl TeamBackend<u32> for AlliedProvider {
        fn team(&mut self,actor:u32)->Result<u32,&'static str>{let index=self.team_calls.len();assert!(index<2);let value=self.values[index];self.team_calls.push(serde_json::json!({"owner":actor,"value":value}));Ok(value)}
    }
    #[test] fn audio_allied_champion_name_matches1536_native_team_and_actual_character_lookup_compositions() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_allied_champion_name_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1536);
        for c in cases {
            let inner=Provider {flags:c["flags"].as_u64().unwrap() as u32,present:c["first_character_present"].as_bool().unwrap(),gate:c["gate_word"].as_u64().unwrap() as u32,fallback:Storage::new(c["fallback_name"].as_str().unwrap()),provided:Storage::new(c["provided_character_name"].as_str().unwrap()),calls:vec![],flag_reads:0,gate_reads:vec![]};
            let mut p=AlliedProvider {inner,values:[c["first_team_value"].as_u64().unwrap() as u32,c["second_team_value"].as_u64().unwrap() as u32],team_calls:vec![]};
            let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(7),"other"=>Some(8),_=>panic!("native local fixture")};
            let output=bind_allied_champion_name_bytes(c["input"].as_str().unwrap().as_bytes(),actor,local,&mut p).unwrap().unwrap();
            assert_eq!(output.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.inner.calls),c["getter_calls"]);assert_eq!(p.inner.flag_reads,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(p.inner.gate_reads),c["gate_read_sizes"]);assert_eq!(serde_json::json!(p.team_calls),c["team_getter_calls"]);
        }
    }
}
