from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
source='''//! Original6D3030/6D3090 name family and exhausted-dispatch fallback.
//! Converted-name provider716CE0 is explicit; this module does not invent player names.
use crate::audio_announcer_actor_wrapper::Form;
pub const NAME_PATTERN:&str=" name@";
pub struct NameStorage<'a> {pub inline:&'a [u8;16],pub capacity:u32,pub heap:Option<&'a [u8]>}
impl NameStorage<'_> {
    /// Original unsigned capacity<16 chooses inline; length field is not consulted.
    /// Borrowed storage remains owned by the actor/provider and is copied before return.
    pub fn ascii_text(&self)->Result<String,&'static str> {
        let bytes=if self.capacity<16 {self.inline.as_slice()} else {self.heap.ok_or("converted name storage unavailable")?};
        let end=bytes.iter().position(|b|*b==0).ok_or("converted name storage lacks terminator")?;
        let bytes=&bytes[..end];if !bytes.is_ascii(){return Err("converted name encoding unqualified");}
        Ok(String::from_utf8(bytes.to_vec()).expect("validated ASCII"))
    }
}
pub trait Backend<A:Copy> {
    fn flags(&mut self,actor:A)->Result<u32,&'static str>;
    fn converted_name(&mut self,actor:A)->Result<NameStorage<'_>,&'static str>;
    fn localize(&mut self,key:&'static str)->Result<String,&'static str>;
}
pub fn name<A:Copy>(actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<String,&'static str> {
    let empty=if form==Form::Plain {"someone"} else {""};
    let Some(actor)=actor else {return Ok(empty.to_owned());};
    let flags=backend.flags(actor)?;
    if flags&0x1000!=0 {return backend.converted_name(actor)?.ascii_text();}
    if flags&0x2000!=0 {return if form==Form::Plain {Ok("a turret".to_owned())} else {backend.localize("game_announcement_replace_aturret")};}
    if flags&0x800!=0 {return if form==Form::Plain {Ok("a minion".to_owned())} else {backend.localize("game_announcement_replace_aminion")};}
    Ok(empty.to_owned())
}
/// Named-token family only; None means the caller must continue the ordered native dispatcher.
pub fn bind_name<A:Copy>(input:&str,actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Option<String>,&'static str> {
    if !input.as_bytes().get(..NAME_PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(NAME_PATTERN.as_bytes())) {return Ok(None);}
    name(actor,form,backend).map(Some)
}
/// Call only after all native family matchers are exhausted, not after an arbitrary mismatch.
/// Both original dispatchers use plain6D3030 here, including the localized dispatcher.
pub fn exhausted_fallback<A:Copy>(actor:Option<A>,backend:&mut impl Backend<A>)->Result<String,&'static str> {name(actor,Form::Plain,backend)}
#[cfg(test)] mod tests {
    use super::*;use std::collections::BTreeMap;
    struct Provider {flags:u32,inline:[u8;16],heap:Vec<u8>,capacity:u32,translations:BTreeMap<String,String>,flag_reads:u64,name_calls:Vec<&'static str>,localization_calls:Vec<&'static str>}
    impl Backend<u32> for Provider {
        fn flags(&mut self,_:u32)->Result<u32,&'static str>{self.flag_reads+=1;Ok(self.flags)}
        fn converted_name(&mut self,_:u32)->Result<NameStorage<'_>,&'static str>{self.name_calls.push("actor");Ok(NameStorage {inline:&self.inline,capacity:self.capacity,heap:Some(&self.heap)})}
        fn localize(&mut self,key:&'static str)->Result<String,&'static str>{self.localization_calls.push(key);self.translations.get(key).cloned().ok_or("translation unavailable")}
    }
    #[test] fn name_family_and_exhausted_fallback_match324_original_dispatch_frames() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_name_fallback_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),324);
        for c in cases {
            let value=c["provided_name"].as_str().unwrap();let mut inline=[0u8;16];if value.len()<16 {inline[..value.len()].copy_from_slice(value.as_bytes());}
            let mut heap=value.as_bytes().to_vec();heap.push(0);
            let translations=proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect();
            let mut provider=Provider {flags:c["flags"].as_u64().unwrap() as u32,inline,heap,capacity:if value.len()<16 {15} else {value.len() as u32},translations,flag_reads:0,name_calls:vec![],localization_calls:vec![]};
            let actor=c["exists"].as_bool().unwrap().then_some(1);let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};
            let input=c["input"].as_str().unwrap();let value=if input==" unknown field@" {exhausted_fallback(actor,&mut provider).unwrap()} else {bind_name(input,actor,form,&mut provider).unwrap().unwrap()};
            assert_eq!(value,c["output"].as_str().unwrap());assert_eq!(provider.flag_reads,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(provider.name_calls),c["name_calls"]);assert_eq!(serde_json::json!(provider.localization_calls),c["localization_calls"]);
            assert_eq!(provider.name_calls.len() as u64,c["capacity_reads"].as_u64().unwrap());
        }
    }
    #[test] fn unqualified_or_unavailable_storage_returns_error_not_a_fabricated_name() {
        let inline=[0u8;16];assert!(NameStorage {inline:&inline,capacity:16,heap:None}.ascii_text().is_err());
        let bytes=[1u8;16];assert!(NameStorage {inline:&bytes,capacity:15,heap:None}.ascii_text().is_err());
        let invalid=[255,0];assert!(NameStorage {inline:&inline,capacity:16,heap:Some(&invalid)}.ascii_text().is_err());
    }
}
'''
p=r/'crates/core/src/audio_announcer_actor_name.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub mod audio_announcer_actor_wrapper;','pub mod audio_announcer_actor_wrapper;\npub mod audio_announcer_actor_name;');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools/add_announcer_actor_name.py');print('Native name family and exhausted-dispatch fallback added with borrowed converted-name storage.')
