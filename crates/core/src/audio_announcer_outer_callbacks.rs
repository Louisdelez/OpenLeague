//! Native actor callback contexts and the five actor bindings in 6CFB40's 167 maps.
//! Other callback families and physical native map ownership are separate contracts.
use crate::audio_announcer_actor_wrapper::Form;
use crate::audio_announcer_object_lookup::{Error as StorageError, Memory};
use crate::audio_announcer_ordered_formatter as formatter;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Callback { Source, Destination, Local, SourceLocalized, DestinationLocalized }
impl Callback {
    pub fn form(self) -> Form {
        match self { Self::SourceLocalized | Self::DestinationLocalized => Form::Localized, _ => Form::Plain }
    }
    pub fn native_address(self) -> u32 {
        match self { Self::Source => 0x6e7970, Self::Destination => 0x6e7990, Self::Local => 0x6e79c0, Self::SourceLocalized => 0x6e7a10, Self::DestinationLocalized => 0x6e7a30 }
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Binding { pub key: &'static [u8], pub callback: Callback }
pub const ACTOR_BINDINGS: [Binding; 5] = [
    Binding { key: b"src", callback: Callback::Source },
    Binding { key: b"dest", callback: Callback::Destination },
    Binding { key: b"you", callback: Callback::Local },
    Binding { key: b"srctr", callback: Callback::SourceLocalized },
    Binding { key: b"desttr", callback: Callback::DestinationLocalized },
];
#[derive(Debug, PartialEq, Eq)]
pub enum Error { Initialization(crate::audio_announcer_registry_init::Error), Storage(StorageError), LocalId(&'static str), MapIndex(u32), UnimplementedCallback(Vec<u8>), Formatter(formatter::RegisteredError) }
impl From<StorageError> for Error { fn from(value: StorageError) -> Self { Self::Storage(value) } }
pub fn registered_actor_callback(map_index: u32, key: &[u8]) -> Result<Callback, Error> {
    if map_index >= 167 { return Err(Error::MapIndex(map_index)); }
    ACTOR_BINDINGS.iter().find(|binding| binding.key == key).map(|binding| binding.callback).ok_or_else(|| Error::UnimplementedCallback(key.to_vec()))
}
pub trait ContextMemory: Memory {
    /// Virtual +4 getter of the original local actor's +128 ID object.
    fn local_actor_id(&mut self, actor: u32) -> Result<u32, &'static str>;
}
pub fn actor_id(callback: Callback, message: u32, memory: &mut impl ContextMemory) -> Result<u32, Error> {
    match callback {
        Callback::Source | Callback::SourceLocalized => Ok(memory.word(message.wrapping_add(4))?),
        Callback::Destination | Callback::DestinationLocalized => {
            let destination = memory.word(message.wrapping_add(8))?;
            Ok(memory.word(destination)?)
        }
        Callback::Local => {
            let local = memory.word(0x2d77f48)?;
            if local != 0 { memory.local_actor_id(local).map_err(Error::LocalId) }
            else { Ok(memory.word(0x2d5f4c8)?) }
        }
    }
}
pub fn format_callback_bytes<M: Copy, B: formatter::Backend<u32, M>, R: ContextMemory>(
    input: &[u8], callback: Callback, message: u32, context: formatter::RegistryContext<M>,
    caches: &mut formatter::Caches, memory: &mut R, backend: &mut B,
) -> Result<Vec<u8>, Error> {
    let id = actor_id(callback, message, memory)?;
    formatter::format_registered_bytes(input, id, callback.form(), context, caches, memory, backend).map_err(Error::Formatter)
}
/// Context ID selection precedes lazy registry initialization, as in the native callbacks.
pub fn format_live_callback_bytes<M: Copy, B: formatter::Backend<u32, M>, R: ContextMemory + crate::audio_announcer_registry_init::Storage>(
    input: &[u8], callback: Callback, message: u32, mut context: formatter::RegistryContext<M>,
    state: &mut crate::audio_announcer_registry_init::State, constructor_byte:u8,
    caches: &mut formatter::Caches, memory: &mut R, backend: &mut B,
) -> Result<Vec<u8>, Error> {
    let id=actor_id(callback,message,memory)?;
    crate::audio_announcer_registry_init::initialize(state,constructor_byte,memory).map_err(Error::Initialization)?;
    context.registry_manager=state.manager;
    formatter::format_registered_bytes(input,id,callback.form(),context,caches,memory,backend).map_err(Error::Formatter)
}
#[cfg(test)] mod tests {
    use super::*;
    use std::collections::BTreeMap;
    struct Words { words: BTreeMap<u32,u32>, local_id: Result<u32,&'static str>, getters: Vec<u32> }
    impl Memory for Words { fn word(&mut self, address:u32)->Result<u32,StorageError> { self.words.get(&address).copied().ok_or(StorageError::MissingWord(address)) } }
    impl ContextMemory for Words { fn local_actor_id(&mut self, actor:u32)->Result<u32,&'static str> { self.getters.push(actor); self.local_id } }
    #[test] fn audio_outer_callbacks_match40_original_context_form_and_local_getter_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_outer_callbacks_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),40);
        for case in cases {
            let entry=u32::from_str_radix(case["entry"].as_str().unwrap().trim_start_matches("0x"),16).unwrap();
            let callback=ACTOR_BINDINGS.iter().find(|b|b.callback.native_address()==entry).unwrap().callback;
            let key=case["source_key"].as_u64().unwrap() as u32;let has_local=case["has_local"].as_bool().unwrap();
            let mut memory=Words { words:BTreeMap::from([(0x1004,key),(0x1008,0x2000),(0x2000,key.wrapping_add(1)),(0x2d77f48,if has_local {0x3000} else {0}),(0x2d5f4c8,key.wrapping_add(3))]),local_id:Ok(key.wrapping_add(2)),getters:vec![] };
            assert_eq!(actor_id(callback,0x1000,&mut memory).unwrap(),case["calls"][0]["key"].as_u64().unwrap() as u32);
            assert_eq!(callback.form(),if case["calls"][0]["wrapper"]=="0x6e9da0" {Form::Plain} else {Form::Localized});
            assert_eq!(memory.getters.len(),case["getter_calls"].as_array().unwrap().len());
        }
    }
    #[test] fn audio_actor_bindings_match835_original_registrations_across167_maps() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_callback_registration_contract.json")).unwrap();
        let bindings=proof["bindings"].as_array().unwrap();assert_eq!(bindings.len(),835);
        for binding in bindings {
            let callback=registered_actor_callback(binding["map_index"].as_u64().unwrap() as u32,binding["key"].as_str().unwrap().as_bytes()).unwrap();
            assert_eq!(format!("{:#x}",callback.native_address()),binding["callback"].as_str().unwrap());
        }
        assert_eq!(registered_actor_callback(167,b"src"),Err(Error::MapIndex(167)));
        assert_eq!(registered_actor_callback(0,b"SRC"),Err(Error::UnimplementedCallback(b"SRC".to_vec())));
    }
    #[test] fn audio_callback_context_errors_preserve_missing_storage_and_failed_getter() {
        let mut memory=Words {words:BTreeMap::new(),local_id:Err("local ID unavailable"),getters:vec![]};
        assert_eq!(actor_id(Callback::Source,0x1000,&mut memory),Err(Error::Storage(StorageError::MissingWord(0x1004))));
        memory.words.insert(0x1008,0);
        assert_eq!(actor_id(Callback::Destination,0x1000,&mut memory),Err(Error::Storage(StorageError::MissingWord(0))));
        memory.words.insert(0x2d77f48,0x3000);
        assert_eq!(actor_id(Callback::Local,0x1000,&mut memory),Err(Error::LocalId("local ID unavailable")));
        assert_eq!(memory.getters,vec![0x3000]);
    }
}
