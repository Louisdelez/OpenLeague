//! Original6D3030/6D3090 name family and exhausted-dispatch fallback.
//! Converted-name provider716CE0 is explicit; this module does not invent player names.
use crate::audio_announcer_actor_wrapper::Form;
pub const NAME_PATTERN:&str=" name@";
pub struct NameStorage<'a> {pub inline:&'a [u8;16],pub capacity:u32,pub heap:Option<&'a [u8]>}
impl NameStorage<'_> {
    /// Original unsigned capacity<16 chooses inline; length field is not consulted.
    /// Borrowed storage remains owned by the actor/provider and is copied before return.
    pub fn nul_bytes(&self)->Result<&[u8],&'static str> {
        let bytes=if self.capacity<16 {self.inline.as_slice()} else {self.heap.ok_or("converted name storage unavailable")?};
        let end=bytes.iter().position(|b|*b==0).ok_or("converted name storage lacks terminator")?;
        Ok(&bytes[..end])
    }
    pub fn ascii_text(&self)->Result<String,&'static str> {
        let bytes=self.nul_bytes()?;if !bytes.is_ascii(){return Err("converted name encoding unqualified");}
        Ok(String::from_utf8(bytes.to_vec()).expect("validated ASCII"))
    }
}
pub trait Backend<A:Copy> {
    fn flags(&mut self,actor:A)->Result<u32,&'static str>;
    fn converted_name(&mut self,actor:A)->Result<NameStorage<'_>,&'static str>;
    fn localize(&mut self,key:&'static str)->Result<String,&'static str>;
}
pub fn name_bytes<A:Copy>(actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
    let empty=if form==Form::Plain {b"someone".as_slice()} else {b"".as_slice()};
    let Some(actor)=actor else {return Ok(empty.to_vec());};
    let flags=backend.flags(actor)?;
    if flags&0x1000!=0 {return Ok(backend.converted_name(actor)?.nul_bytes()?.to_vec());}
    if flags&0x2000!=0 {return if form==Form::Plain {Ok(b"a turret".to_vec())} else {backend.localize("game_announcement_replace_aturret").map(String::into_bytes)};}
    if flags&0x800!=0 {return if form==Form::Plain {Ok(b"a minion".to_vec())} else {backend.localize("game_announcement_replace_aminion").map(String::into_bytes)};}
    Ok(empty.to_vec())
}
fn text(bytes:Vec<u8>)->Result<String,&'static str> {String::from_utf8(bytes).map_err(|_|"native name cannot be represented as UTF-8")}
pub fn name<A:Copy>(actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<String,&'static str> {text(name_bytes(actor,form,backend)?)}
/// Named-token family only; None means continue the ordered native dispatcher.
pub fn bind_name_bytes<A:Copy>(input:&[u8],actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
    if !input.get(..NAME_PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(NAME_PATTERN.as_bytes())) {return Ok(None);}
    name_bytes(actor,form,backend).map(Some)
}
pub fn bind_name<A:Copy>(input:&str,actor:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Option<String>,&'static str> {bind_name_bytes(input.as_bytes(),actor,form,backend)?.map(text).transpose()}
/// Call only after all native family matchers are exhausted.
/// Both original dispatchers use plain6D3030 here, including the localized dispatcher.
pub fn exhausted_fallback_bytes<A:Copy>(actor:Option<A>,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {name_bytes(actor,Form::Plain,backend)}
pub fn exhausted_fallback<A:Copy>(actor:Option<A>,backend:&mut impl Backend<A>)->Result<String,&'static str> {text(exhausted_fallback_bytes(actor,backend)?)}
pub const YOU_OR_NAME_PATTERN:&str=" you | name@";
/// Original6D30F0/6D3160 checks a non-null local identity before class/name reads.
pub fn you_or_name_bytes<A:Copy+Eq>(actor:Option<A>,local:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
    if actor.is_some() && actor==local {
        return if form==Form::Plain {Ok(b"you".to_vec())} else {backend.localize("game_announcement_replace_you").map(String::into_bytes)};
    }
    name_bytes(actor,form,backend)
}
pub fn bind_you_or_name_bytes<A:Copy+Eq>(input:&[u8],actor:Option<A>,local:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
    if !input.get(..YOU_OR_NAME_PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(YOU_OR_NAME_PATTERN.as_bytes())) {return Ok(None);}
    you_or_name_bytes(actor,local,form,backend).map(Some)
}
pub fn bind_you_or_name<A:Copy+Eq>(input:&str,actor:Option<A>,local:Option<A>,form:Form,backend:&mut impl Backend<A>)->Result<Option<String>,&'static str> {
    bind_you_or_name_bytes(input.as_bytes(),actor,local,form,backend)?.map(text).transpose()
}
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
    #[test] fn audio_you_or_name_family_matches1296_native_null_local_priority_class_and_fallback_frames() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_you_or_name_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1296);
        for c in cases {
            let value=c["provided_name"].as_str().unwrap();let mut inline=[0;16];if value.len()<16 {inline[..value.len()].copy_from_slice(value.as_bytes());}
            let mut heap=value.as_bytes().to_vec();heap.push(0);let translations=proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect();
            let mut provider=Provider {flags:c["flags"].as_u64().unwrap() as u32,inline,heap,capacity:if value.len()<16 {15} else {value.len() as u32},translations,flag_reads:0,name_calls:vec![],localization_calls:vec![]};
            let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(7),"other"=>Some(8),_=>panic!("native fixture local identity")};
            let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let input=c["input"].as_str().unwrap();
            let bytes=if input==" unknown field@" {exhausted_fallback_bytes(actor,&mut provider).unwrap()} else {bind_you_or_name_bytes(input.as_bytes(),actor,local,form,&mut provider).unwrap().unwrap()};
            assert_eq!(bytes.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(provider.flag_reads,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(provider.name_calls),c["name_calls"]);assert_eq!(serde_json::json!(provider.localization_calls),c["localization_calls"]);assert_eq!(provider.name_calls.len() as u64,c["capacity_reads"].as_u64().unwrap());
        }
    }
    #[test] fn unqualified_or_unavailable_storage_returns_error_not_a_fabricated_name() {
        let inline=[0u8;16];assert!(NameStorage {inline:&inline,capacity:16,heap:None}.ascii_text().is_err());
        let bytes=[1u8;16];assert!(NameStorage {inline:&bytes,capacity:15,heap:None}.ascii_text().is_err());
        let invalid=[255,0];assert!(NameStorage {inline:&inline,capacity:16,heap:Some(&invalid)}.ascii_text().is_err());
    }
}

#[cfg(test)] mod byte_transport_tests {
    use super::*;
    struct Provider {inline:[u8;16],heap:Vec<u8>,capacity:u32,flag_reads:u64,name_calls:Vec<&'static str>}
    impl Provider {
        fn new(bytes:&[u8])->Self {let mut inline=[0;16];if bytes.len()<16 {inline[..bytes.len()].copy_from_slice(bytes);}let mut heap=bytes.to_vec();heap.push(0);Self {inline,heap,capacity:if bytes.len()<16 {15} else {bytes.len() as u32},flag_reads:0,name_calls:vec![]}}
    }
    impl Backend<u32> for Provider {
        fn flags(&mut self,_:u32)->Result<u32,&'static str> {self.flag_reads+=1;Ok(0x1000)}
        fn converted_name(&mut self,_:u32)->Result<NameStorage<'_>,&'static str> {self.name_calls.push("actor");Ok(NameStorage {inline:&self.inline,capacity:self.capacity,heap:Some(&self.heap)})}
        fn localize(&mut self,_:&'static str)->Result<String,&'static str> {Err("hero name must not localize")}
    }
    fn unhex(text:&str)->Vec<u8> {(0..text.len()).step_by(2).map(|i|u8::from_str_radix(&text[i..i+2],16).unwrap()).collect()}
    fn hex(bytes:&[u8])->String {bytes.iter().map(|b|format!("{b:02x}")).collect()}
    #[test] fn audio_name_byte_transport_and_valid_utf8_adapter_match1914_original_dispatch_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_name_bytes_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1914);
        for case in cases {
            let bytes=unhex(case["provided_name_hex"].as_str().unwrap());let mut provider=Provider::new(&bytes);
            let form=if case["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let input=case["input"].as_str().unwrap();
            let output=if input==" unknown field@" {exhausted_fallback_bytes(Some(7),&mut provider).unwrap()} else {bind_name_bytes(input.as_bytes(),Some(7),form,&mut provider).unwrap().unwrap()};
            assert_eq!(hex(&output),case["output_hex"].as_str().unwrap());assert_eq!(provider.flag_reads,case["flag_reads"].as_u64().unwrap());assert_eq!(provider.name_calls.len() as u64,case["capacity_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(provider.name_calls),case["name_calls"]);assert!(case["localization_calls"].as_array().unwrap().is_empty());
            let mut provider=Provider::new(&bytes);let text=if input==" unknown field@" {exhausted_fallback(Some(7),&mut provider)} else {bind_name(input,Some(7),form,&mut provider).map(Option::unwrap)};
            match String::from_utf8(output) {Ok(expected)=>assert_eq!(text.unwrap(),expected),Err(_)=>assert_eq!(text.unwrap_err(),"native name cannot be represented as UTF-8")}
        }
    }
}
