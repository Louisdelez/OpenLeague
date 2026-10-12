//! Native6CE0E0 backend-reference registration after an external voice factory.
//! V is an actual caller-owned voice; this module never fabricates a playing ID.
use std::collections::BTreeMap;
#[derive(Debug)]
pub struct Retained<V> { pub voice: V, pub actor_id: u32 }
#[derive(Debug)]
pub struct Registry<V> { next_id:u32, entries:BTreeMap<u32,Retained<V>> }
impl<V> Default for Registry<V> {fn default()->Self{Self::new(0)}}
impl<V> Registry<V> {
    /// Restore an explicit counter; Default follows original6CDC80 (offset0C=0).
    pub fn new(next_id:u32) -> Self {Self {next_id,entries:BTreeMap::new()}}
    pub fn next_id(&self)->u32 {self.next_id}
    pub fn get(&self,id:u32)->Option<&Retained<V>> {self.entries.get(&id)}
    /// Original6CE2D0 requests voice release before erasing the retained owner.
    /// Missing IDs are ignored, including duplicate requests. Extra Rust access
    /// failures remain explicit and keep the entry available for recovery.
    pub fn release<E>(&mut self,id:u32,before_remove:impl FnOnce(&mut V)->Result<(),E>)->Result<bool,E> {
        let Some(entry)=self.entries.get_mut(&id) else {return Ok(false);};
        before_remove(&mut entry.voice)?;
        self.entries.remove(&id);
        Ok(true)
    }
    /// Voice creation failure returns -1 without advancing the backend counter.
    /// Resolved actors retain their input ID; unresolved actors retain zero.
    /// Logical manager IDs and these backend references are separate namespaces.
    pub fn retain_created(&mut self,actor_id:u32,actor_resolved:bool,voice:Option<V>)->i32 {
        let Some(voice)=voice else {return -1;};
        let id=self.next_id;self.entries.insert(id,Retained {voice,actor_id:if actor_resolved {actor_id} else {0}});
        self.next_id=self.next_id.wrapping_add(1);id as i32
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_48_original_backend_reference_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_backend_reference_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
        for case in cases {
            let seed=case["counter"].as_u64().unwrap() as u32;
            let actor=case["actor_id"].as_u64().unwrap() as u32;
            let resolved=case["actor_resolved"].as_bool().unwrap();let success=case["voice_created"].as_bool().unwrap();
            let mut registry=Registry::new(seed);
            // Rc models caller-provided ownership; full native destructor is not claimed.
            let caller=std::rc::Rc::new("voice fixture");
            let handle=registry.retain_created(actor,resolved,success.then(||caller.clone()));
            assert_eq!(handle as u32,case["returned_raw"].as_u64().unwrap() as u32);
            assert_eq!(registry.next_id(),case["next_counter"].as_u64().unwrap() as u32);
            assert_eq!(registry.get(seed).is_some(),success);
            if let Some(entry)=registry.get(seed) {assert_eq!(entry.actor_id,case["retained_actor"].as_u64().unwrap() as u32);assert!(std::rc::Rc::ptr_eq(&entry.voice,&caller));}
            assert_eq!(std::rc::Rc::strong_count(&caller),if success {2} else {1});
        }
    }
    #[test]
    fn logical_reference_survives_physical_failure_without_counter_or_voice_invention() {
        use crate::{audio_logical_registration::{Manager,WorkerCommand},audio_requests::Request};
        let mut logical=Manager::default();let mut backend=Registry::<String>::new(42);
        let id=logical.register(&Request {slot:0x10,event:"native".into(),position:[1.,2.,3.],age:0.}).unwrap();assert_eq!(id,1);
        logical.process_pending(|command|match command {
            WorkerCommand::Create {..}=>backend.retain_created(0,false,None),
            _=>panic!("create only")
        });
        assert_eq!(logical.entry(1).unwrap().backend_reference,-1);assert_eq!(backend.next_id(),42);assert!(backend.get(42).is_none());
        logical.create_pending(1, |_|backend.retain_created(7,true,Some("caller-owned voice".into())));
        assert_eq!(logical.entry(1).unwrap().backend_reference,42);assert_eq!(backend.next_id(),43);
        assert_eq!(backend.get(42).unwrap().actor_id,7);
    }
    #[test]
    fn matches_192_original_registry_release_cases() {
        use crate::audio_release::Voice;
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_backend_release_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),192);
        for case in cases {
            let mut registry=Registry::new(123);
            for key in case["keys"].as_array().unwrap() {
                registry.entries.insert(key.as_u64().unwrap() as u32,Retained {actor_id:0,voice:Voice {playing_id:456,object_id:123,stop_event_id:if case["stop_found"].as_bool().unwrap() {9} else {0},released:case["released"].as_bool().unwrap()}});
            }
            let request=case["request_raw"].as_u64().unwrap() as u32;let mut calls=vec![];let mut released=None;
            for _ in 0..case["repeat_runs"].as_u64().unwrap() {
                let erased=registry.release(request,|voice| {
                    calls.extend(voice.release(case["engine_available"].as_bool().unwrap(),|_,_|if case["post_success"].as_bool().unwrap() {99} else {0}).into_iter().map(|c|serde_json::to_value(c).unwrap()));
                    released=Some(voice.released);Ok::<(),()>(())
                }).unwrap();
                if erased {calls.push(serde_json::json!({"kind":"erase","reference":request}));}
            }
            assert_eq!(calls,*case["calls"].as_array().unwrap());assert_eq!(serde_json::json!(released),case["final_released"]);
            assert_eq!(serde_json::json!(registry.entries.keys().copied().collect::<Vec<_>>()),case["remaining_keys"]);
            assert_eq!(registry.next_id(),123);
        }
    }
    #[test]
    fn logical_release_stops_then_drops_registry_owner_and_prunes_weak_entry() {
        use std::sync::{Arc,Mutex};
        use crate::{audio_managed_voice::{ManagedVoice,Finalizer},audio_voice_constructor::{construct,Clock,Destruction},audio_logical_registration::{Manager,WorkerCommand},audio_object_association::Associations,audio_requests::Request};
        for retain_external_owner in [false,true] {
            let order=Arc::new(Mutex::new(vec![]));let final_order=Arc::clone(&order);
            let finalizer:Finalizer=Arc::new(move |voice| {
                voice.finalize(1,true,|_,_|panic!("explicit release already posted stop"),|c|final_order.lock().unwrap().push(match c {
                    Destruction::DestroyStopString=>"stop_string",Destruction::DestroyPlayString=>"play_string",Destruction::FreeVoiceStorage=>"free",Destruction::Release(_)=>panic!("duplicate stop"),
                }));
            });
            let owner=Arc::new(ManagedVoice::new(Some(construct(62,123,2,"play",9,"stop",Clock::Ready(0.)).unwrap()),finalizer));
            let mut weak=Associations::default();weak.associate(10,true,Some(Arc::clone(&owner)));
            let mut backend=Registry::new(42);let mut logical=Manager::default();let mut pending=Some(Arc::clone(&owner));
            let logical_id=logical.register(&Request {slot:0x10,event:"play".into(),position:[1.,2.,3.],age:0.}).unwrap();
            logical.process_pending(|command|match command {WorkerCommand::Create {..}=>backend.retain_created(0,false,pending.take()),_=>panic!("creation phase")});
            let external=if retain_external_owner {Some(owner)} else {drop(owner);None};
            assert_eq!(logical.entry(logical_id as u32).unwrap().backend_reference,42);assert_eq!(backend.next_id(),43);
            logical.queue_release(logical_id);
            logical.process_pending(|command|match command {
                WorkerCommand::Release {backend_reference}=> {
                    assert_eq!(backend_reference,42);
                    assert!(backend.release(backend_reference as u32,|owner|owner.with_mut(|voice| {
                        let commands=voice.unwrap().lifecycle.release(true,|id,obj| {assert_eq!((id,obj),(9,123));order.lock().unwrap().push("post_stop");7});assert_eq!(commands.len(),1);
                    })).unwrap());0
                },_=>panic!("release phase"),
            });
            assert!(logical.entry(logical_id as u32).is_none());assert!(backend.get(42).is_none());assert_eq!(backend.next_id(),43);
            if retain_external_owner {
                assert_eq!(*order.lock().unwrap(),vec!["post_stop"]);assert!(weak.entries()[0].lock().is_some());
                assert!(external.as_ref().unwrap().snapshot().unwrap().unwrap().lifecycle.released);
            }
            drop(external);assert_eq!(*order.lock().unwrap(),vec!["post_stop","stop_string","play_string","free"]);
            assert!(weak.entries()[0].lock().is_none());weak.tick(||{},|_|panic!("expired"),|_|panic!("expired"),|token|assert_eq!(token,10));assert!(weak.entries().is_empty());
            assert!(!backend.release::<()>(42,|_|panic!("duplicate release")).unwrap_or(false));
        }
    }
    #[test]
    fn access_error_keeps_registered_owner_for_explicit_recovery() {
        let mut registry=Registry::new(42);registry.retain_created(0,false,Some(123));
        assert_eq!(registry.release(42,|_|Err::<(),_>("backend access failed")),Err("backend access failed"));
        assert_eq!(registry.get(42).unwrap().voice,123);assert_eq!(registry.next_id(),43);
    }

}

#[cfg(test)] mod startup_tests {
 use super::*;
 #[test] fn constructor_and_failed_then_successful_creation_match_original(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_backend_startup_contract.json")).unwrap();
  assert_eq!(proof["cases"].as_array().unwrap().len(),3);
  for row in proof["cases"].as_array().unwrap(){
   let mut registry=Registry::<String>::default();assert_eq!(u64::from(registry.next_id()),row["initial_counter"].as_u64().unwrap());
   for call in row["sequence"].as_array().unwrap(){
    let success=call["success"].as_bool().unwrap();let result=registry.retain_created(0,false,success.then(||"owned test voice".into()));
    assert_eq!(u64::from(result as u32),call["returned_raw"].as_u64().unwrap());assert_eq!(u64::from(registry.next_id()),call["next_counter"].as_u64().unwrap());
   }
   assert!(registry.get(0).is_some());assert!(registry.get(1).is_some());
   assert!(registry.release(0,|_|Ok::<(),()>(())).unwrap());assert!(registry.get(0).is_none());assert!(registry.get(1).is_some());
  }
 }
}
