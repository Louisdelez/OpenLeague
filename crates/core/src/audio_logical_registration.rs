//! Native 920D50 pending logical registration. No playing ID or voice acceptance.
use std::collections::BTreeMap;
use crate::audio_requests::Request;
#[derive(Debug, Clone)]
pub struct Entry {
    pub backend_reference: i32,
    pub event: String,
    pub field1c_raw: u32,
    pub field20_raw: u32,
    pub position: [f32;3],
    pub flag30_raw: u8,
    pub age: f32,
}
#[derive(Debug, Clone)]
pub enum WorkerCommand {
    Create { logical_id: u32, entry: Entry },
    Position { backend_reference: i32, position: [f32;3] },
    Boolean { backend_reference: i32, value_raw: u8 },
    Release { backend_reference: i32 },
}
#[derive(Debug)]
pub struct Manager {
    next_id: u32,
    entries: BTreeMap<u32, Entry>,
    // Call sequence to the native pending-key container, not a claim about its implementation.
    pending_key_calls: Vec<u32>,
    release_keys: Vec<u32>,
    update_keys: Vec<u32>,
}
impl Manager {
    /// Restore an explicit counter state; Default uses the qualified native seed.
    pub fn new(next_id: u32) -> Self { Self { next_id, entries:BTreeMap::new(), pending_key_calls:vec![], release_keys:vec![], update_keys:vec![] } }
    /// Native921150 queues every position update, including unchanged positions.
    pub fn update_position(&mut self, id:u32, position:[f32;3]) -> Result<bool,&'static str> {
        let Some(entry)=self.entries.get_mut(&id) else {return Ok(false);};
        if position.iter().any(|x| !x.is_finite()) {return Err("invalid logical source position");}
        entry.field20_raw |= 1;entry.position=position;self.update_keys.push(id);Ok(true)
    }
    /// Native921390 compares raw bytes and queues only a changed byte.
    pub fn update_boolean(&mut self,id:u32,value_raw:u8) -> bool {
        let Some(entry)=self.entries.get_mut(&id) else {return false;};
        if entry.flag30_raw==value_raw {return false;}
        entry.field20_raw |= 2;entry.flag30_raw=value_raw;self.update_keys.push(id);true
    }
    /// Enqueue an already prepared native update key. Producers must set the
    /// entry's qualified dirty fields separately; this method invents no update.
    pub fn queue_update_key(&mut self, id:u32) { self.update_keys.push(id); }
    pub fn update_keys(&self) -> &[u32] { &self.update_keys }
    /// Persistent portion of original9214F0: creates, updates, releases, clearing
    /// each pending vector. Transient/secondary sound queues are separate work.
    pub fn process_pending(&mut self, mut backend: impl FnMut(WorkerCommand) -> i32) {
        for id in std::mem::take(&mut self.pending_key_calls) {
            self.create_pending(id,|entry|backend(WorkerCommand::Create {logical_id:id,entry:entry.clone()}));
        }
        for id in std::mem::take(&mut self.update_keys) {
            let Some(entry)=self.entries.get(&id).cloned() else {continue;};
            if entry.field20_raw & 1 != 0 {backend(WorkerCommand::Position {backend_reference:entry.backend_reference,position:entry.position});}
            if entry.field20_raw & 2 != 0 {backend(WorkerCommand::Boolean {backend_reference:entry.backend_reference,value_raw:entry.flag30_raw});}
        }
        for id in std::mem::take(&mut self.release_keys) {
            self.release_pending(id,|backend_reference| {backend(WorkerCommand::Release {backend_reference});});
        }
    }
    /// Native worker creates a backend reference and stores every raw return,
    /// including zero and -1. The callback owns actual voice creation.
    pub fn create_pending(&mut self, id: u32, mut post: impl FnMut(&Entry) -> i32) -> bool {
        let Some(entry)=self.entries.get_mut(&id) else { return false; };
        entry.backend_reference=post(entry); true
    }
    /// Native worker forwards the stored raw reference, then erases the entry.
    /// It does not guard zero/-1 here; backend release must implement its own rules.
    pub fn release_pending(&mut self, id: u32, mut post: impl FnMut(i32)) -> bool {
        let Some(entry)=self.entries.get(&id) else { return false; };
        post(entry.backend_reference); self.entries.remove(&id); true
    }
    /// Original virtual +0x20 enqueues raw keys, including duplicates/reserved IDs.
    /// Queueing alone does not remove the logical entry or release a voice.
    pub fn queue_release(&mut self, handle: i32) { self.release_keys.push(handle as u32); }
    pub fn release_keys(&self) -> &[u32] { &self.release_keys }
    pub fn next_id(&self) -> u32 { self.next_id }
    pub fn entry(&self,id:u32) -> Option<&Entry> { self.entries.get(&id) }
    pub fn pending_key_calls(&self) -> &[u32] { &self.pending_key_calls }
    /// This is logical registration, even when the backend is unavailable.
    /// -1 may be returned on counter wrap and still have been registered.
    pub fn register(&mut self, request: &Request) -> Result<i32, &'static str> {
        if request.slot!=0x10 { return Err("request is not native persistent registration"); }
        if !request.age.is_finite() || request.position.iter().any(|x| !x.is_finite()) {
            return Err("invalid logical registration context");
        }
        let id=self.next_id; self.next_id=self.next_id.wrapping_add(1);
        self.entries.insert(id,Entry {backend_reference:-1,event:request.event.clone(),
            field1c_raw:0,field20_raw:0,position:request.position,flag30_raw:0,age:request.age});
        self.pending_key_calls.push(id);
        Ok(id as i32)
    }
}
impl Default for Manager {
    fn default() -> Self { Self::new(1) } // Original 920810 writes +0x5c = 1.
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn position_and_raw_boolean_updates_match_180_original_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_logical_updates_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),180);
        for case in cases {
            let mut m=Manager::new(42);m.register(&Request {slot:0x10,event:"event".into(),position:[1.,2.,3.],age:-0.5}).unwrap();
            let entry=m.entries.get_mut(&42).unwrap();entry.field1c_raw=7;entry.field20_raw=case["flags"].as_u64().unwrap() as u32;
            entry.backend_reference=case["backend"].as_i64().unwrap() as i32;entry.flag30_raw=case["initial_boolean"].as_u64().unwrap() as u8;
            let id=case["key"].as_u64().unwrap() as u32;
            if case["method"]=="position" {
                let value=std::array::from_fn(|i|case["value"][i].as_f64().unwrap() as f32);m.update_position(id,value).unwrap();
            } else {m.update_boolean(id,case["value"].as_u64().unwrap() as u8);}
            let queued:Vec<u32>=case["queued"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(m.update_keys(),queued);let entry=m.entry(42).unwrap();
            assert_eq!(entry.field20_raw,case["final_flags"].as_u64().unwrap() as u32);
            assert_eq!(entry.flag30_raw,case["final_boolean"].as_u64().unwrap() as u8);
            let bits:Vec<u32>=case["final_position_bits"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(entry.position.map(f32::to_bits).as_slice(),bits);assert_eq!(entry.field1c_raw,7);assert_eq!(entry.event,"event");
            assert_eq!(entry.age,-0.5);assert_eq!(entry.backend_reference,case["backend"].as_i64().unwrap() as i32);
        }
    }
    #[test]
    fn repeated_position_updates_and_changed_boolean_flow_through_worker_in_order() {
        let mut m=Manager::default();m.register(&Request {slot:0x10,event:"native".into(),position:[1.,2.,3.],age:0.}).unwrap();
        m.process_pending(|command| {assert!(matches!(command,WorkerCommand::Create {logical_id:1,..}));123});
        assert!(m.update_position(1,[4.,5.,6.]).unwrap());assert!(m.update_position(1,[4.,5.,6.]).unwrap());
        assert!(m.update_boolean(1,255));assert!(!m.update_boolean(1,255));
        assert!(m.update_position(1,[f32::NAN,0.,0.]).is_err());assert_eq!(m.update_keys(),&[1,1,1]);
        let mut events=vec![];
        m.process_pending(|command| {match command {
            WorkerCommand::Position {backend_reference,position}=>{assert_eq!(backend_reference,123);assert_eq!(position,[4.,5.,6.]);events.push("position");},
            WorkerCommand::Boolean {backend_reference,value_raw}=>{assert_eq!(backend_reference,123);assert_eq!(value_raw,255);events.push("boolean");},
            _=>panic!("only updates expected")
        };0});
        assert_eq!(events,vec!["position","boolean","position","boolean","position","boolean"]);
        assert!(m.update_keys().is_empty());
    }
    #[test]
    fn whole_worker_matches_192_original_queue_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_worker_queues_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),192);
        for case in cases {
            let mut m=Manager::new(42);m.register(&Request {slot:0x10,event:"event".into(),position:[1.,2.,3.],age:0.}).unwrap();
            let entry=m.entries.get_mut(&42).unwrap();entry.backend_reference=-2;
            entry.field20_raw=case["dirty_flags"].as_u64().unwrap() as u32;entry.flag30_raw=1;
            let keys=|field:&str| -> Vec<u32> {case[field].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect()};
            m.pending_key_calls=keys("creates");m.update_keys=keys("updates");m.release_keys=keys("releases");
            let mut calls=vec![];let answer=case["backend_return"].as_i64().unwrap() as i32;
            m.process_pending(|command| {
                calls.push(match command {
                    WorkerCommand::Create {logical_id,entry}=>{assert_eq!(logical_id,42);assert_eq!(entry.event,"event");serde_json::json!({"kind":"create"})},
                    WorkerCommand::Position {backend_reference,position}=>{assert_eq!(position,[1.,2.,3.]);serde_json::json!({"kind":"position","backend_reference_raw":backend_reference as u32})},
                    WorkerCommand::Boolean {backend_reference,value_raw}=>serde_json::json!({"kind":"boolean","backend_reference_raw":backend_reference as u32,"value_raw":value_raw}),
                    WorkerCommand::Release {backend_reference}=>serde_json::json!({"kind":"release","backend_reference_raw":backend_reference as u32}),
                });answer
            });
            let expected:Vec<_>=case["calls"].as_array().unwrap().iter().filter(|x|x["kind"]!="erase").cloned().collect();
            assert_eq!(calls,expected);assert_eq!(m.entry(42).is_some(),case["entry_retained"].as_bool().unwrap());
            assert!(m.pending_key_calls().is_empty());assert!(m.update_keys().is_empty());assert!(m.release_keys().is_empty());
            m.process_pending(|_|panic!("cleared queues must not replay"));
        }
    }
    #[test]
    fn native_worker_72_create_store_release_erase_sequences() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_logical_worker_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),72);
        for case in cases {
            let id=case["logical_id"].as_u64().unwrap() as u32;
            let returned=case["backend_return"].as_i64().unwrap() as i32;
            let create=&case["calls"][0];let actor=create["actor_id"].as_u64().unwrap() as u32;
            let bits:Vec<u32>=create["position_bits"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            let position=std::array::from_fn(|i|f32::from_bits(bits[i]));
            let age=f32::from_bits(create["age_bits"].as_u64().unwrap() as u32);
            let mut m=Manager::new(id);m.register(&Request {slot:0x10,event:"event".into(),position,age}).unwrap();
            // Actor field is retained from caller state; native fixture tests actor and unbound variants.
            m.entries.get_mut(&id).unwrap().field1c_raw=actor;
            let mut events=vec![];
            assert!(m.create_pending(id,|entry| {
                assert_eq!(entry.backend_reference,-1);assert_eq!(entry.event,"event");assert_eq!(entry.field1c_raw,actor);
                assert_eq!(entry.position.map(f32::to_bits).as_slice(),bits);assert_eq!(entry.age.to_bits(),age.to_bits());
                events.push("create");returned
            }));
            assert_eq!(m.entry(id).unwrap().backend_reference,case["stored_backend"].as_i64().unwrap() as i32);
            assert!(m.release_pending(id,|backend| {assert_eq!(backend as u32,case["calls"][2]["backend_reference_raw"].as_u64().unwrap() as u32);events.push("release");}));
            assert_eq!(events,vec!["create","release"]);assert!(m.entry(id).is_none());
        }
    }
    #[test]
    fn absent_logical_entries_never_post_create_or_release_callbacks() {
        let mut m=Manager::default();assert!(!m.create_pending(42, |_|panic!("missing entry")));
        assert!(!m.release_pending(42, |_|panic!("missing entry")));
        m.register(&Request {slot:0x10,event:"native".into(),position:[0.;3],age:0.}).unwrap();
        let mut posted=vec![];assert!(m.release_pending(1,|reference|posted.push(reference)));
        assert_eq!(posted,vec![-1]);assert!(!m.release_pending(1, |_|panic!("already erased")));
    }
    #[test]
    fn original_constructor_counter_is_one_independent_of_backend_or_heap_seed() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_logical_lifecycle_contract.json")).unwrap();
        let cases=data["constructor_cases"].as_array().unwrap();assert_eq!(cases.len(),8);
        for case in cases {let m=Manager::default();assert_eq!(m.next_id(),case["counter"].as_u64().unwrap() as u32);
            assert!(m.pending_key_calls().is_empty());assert!(m.release_keys().is_empty());assert!(m.entry(1).is_none());}
    }
    #[test]
    fn release_preserves_native_queue_order_duplicates_and_pending_entries() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_logical_lifecycle_contract.json")).unwrap();
        let cases=data["release_sequences"].as_array().unwrap();assert_eq!(cases.len(),5);
        for case in cases {
            let mut m=Manager::default();let r=Request {slot:0x10,event:"native".into(),position:[1.,2.,3.],age:0.};
            let handle=m.register(&r).unwrap();assert_eq!(handle,1);
            for key in case["input_keys"].as_array().unwrap() {m.queue_release(key.as_u64().unwrap() as u32 as i32);}
            let expected:Vec<u32>=case["queued_keys"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(m.release_keys(),expected);assert!(m.entry(1).is_some());assert_eq!(m.next_id(),2);
        }
    }
    #[test]
    fn matches_45_original_logical_registration_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_logical_registration_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap(); assert_eq!(cases.len(),45);
        for case in cases {
            let counter=case["counter"].as_u64().unwrap() as u32;
            let bits=|key:&str| -> Vec<u32> {case[key].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect()};
            let position_bits=bits("position_bits");
            let position=std::array::from_fn(|i|f32::from_bits(position_bits[i]));
            let age_bits=case["age_bits"].as_u64().unwrap() as u32;
            let request=Request {slot:0x10,event:"event".into(),position,age:f32::from_bits(age_bits)};
            let mut manager=Manager::new(counter);let handle=manager.register(&request).unwrap();
            assert_eq!(handle as u32,case["returned_handle"].as_u64().unwrap() as u32);
            assert_eq!(manager.next_id(),case["next_counter"].as_u64().unwrap() as u32);
            let e=manager.entry(counter).unwrap();assert_eq!(e.backend_reference,-1);assert_eq!(e.event,"event");
            assert_eq!(e.position.map(f32::to_bits).as_slice(),position_bits);assert_eq!(e.age.to_bits(),age_bits);
            assert_eq!((e.field1c_raw,e.field20_raw,e.flag30_raw),(0,0,0));assert_eq!(manager.pending_key_calls(),&[counter]);
        }
    }
    #[test]
    fn particle_retains_zero_handle_and_retries_minus_one_on_wrap() {
        use crate::audio_requests::{Emitter,Context};
        for seed in [0,u32::MAX] {
            let mut m=Manager::new(seed);let mut e=Emitter::new(String::new(),"native".into());
            let c=Context {clock:0.,birth:0.,position:[1.,2.,3.]};
            e.ensure_persistent(c,|r|m.register(&r).unwrap()).unwrap();
            e.ensure_persistent(c,|r|m.register(&r).unwrap()).unwrap();
            assert_eq!(e.logical_handle(),0);
            assert_eq!(m.pending_key_calls(),if seed==0 {vec![0]} else {vec![u32::MAX,0]});
            assert!(m.entry(0).is_some());assert_eq!(m.entry(0).unwrap().backend_reference,-1);
        }
    }
    #[test]
    fn invalid_requests_do_not_allocate_or_advance_counter() {
        let mut m=Manager::new(42);
        for r in [Request{slot:0x18,event:"x".into(),age:0.,position:[0.;3]},
            Request{slot:0x10,event:"x".into(),age:f32::NAN,position:[0.;3]}] {
            assert!(m.register(&r).is_err());assert_eq!(m.next_id(),42);assert!(m.pending_key_calls().is_empty());
        }
    }
}
