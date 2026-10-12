//! Mutable shared voice state and actual final-owner finalization hook.
use std::sync::{Arc,Mutex};
use crate::audio_voice_constructor::PhysicalVoice;
pub type Finalizer=Arc<dyn Fn(PhysicalVoice)+Send+Sync>;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum AccessError {Poisoned}
pub struct ManagedVoice {state:Mutex<Option<PhysicalVoice>>,finalizer:Finalizer}
impl std::fmt::Debug for ManagedVoice {
    fn fmt(&self,f:&mut std::fmt::Formatter<'_>)->std::fmt::Result {f.debug_struct("ManagedVoice").field("state",&self.state).finish_non_exhaustive()}
}
impl ManagedVoice {
    /// Backend finalizer is mandatory. It must route native finalization to the
    /// real stop/storage backend; this owner never supplies a silent no-op.
    pub fn new(voice:Option<PhysicalVoice>,finalizer:Finalizer)->Self {Self {state:Mutex::new(voice),finalizer}}
    pub fn with_mut<R>(&self,operation:impl FnOnce(Option<&mut PhysicalVoice>)->R)->Result<R,AccessError> {
        let mut state=self.state.lock().map_err(|_|AccessError::Poisoned)?;
        Ok(operation(state.as_mut()))
    }
    /// Original707070 invalidates only the object ID; playing/release state stay.
    pub fn invalidate_object(&self)->Result<(),AccessError> {
        self.with_mut(|voice| {if let Some(voice)=voice {voice.lifecycle.object_id=-1;}})
    }
    /// Snapshot copies state, not shared ownership or another physical voice.
    pub fn snapshot(&self)->Result<Option<PhysicalVoice>,AccessError> {
        self.with_mut(|state|state.cloned())
    }
}
impl Drop for ManagedVoice {
    fn drop(&mut self) {
        // A prior panicking mutation does not silently discard backend teardown.
        // Drop has exclusive access and can recover the stored voice once.
        let state=self.state.get_mut().unwrap_or_else(|poisoned|poisoned.into_inner());
        if let Some(voice)=state.take() {(self.finalizer)(voice);}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::audio_voice_constructor::{construct,Clock,Destruction};
    fn notice(command:Destruction)->serde_json::Value {match command {
        Destruction::Release(c)=>serde_json::to_value(c).unwrap(),
        Destruction::DestroyStopString=>serde_json::json!({"kind":"destroy_stop_string"}),
        Destruction::DestroyPlayString=>serde_json::json!({"kind":"destroy_play_string"}),
        Destruction::FreeVoiceStorage=>serde_json::json!({"kind":"free_voice"}),
    }}
    #[test]
    fn matches_144_native_final_owner_cases_with_retained_weak_references() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_managed_voice_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),144);
        for case in cases {
            let calls=Arc::new(Mutex::new(vec![]));let target=Arc::clone(&calls);
            let available=case["engine_available"].as_bool().unwrap();
            let finalizer:Finalizer=Arc::new(move |voice| {voice.finalize(1,available,|_,_|0,|c|target.lock().unwrap().push(notice(c)));});
            let voice=case["voice_present"].as_bool().unwrap().then(|| {
                let mut v=construct(42,123,0,"play",9,"stop",Clock::Ready(0.)).unwrap();
                v.flag49_raw=case["flag49_raw"].as_u64().unwrap() as u8;v.lifecycle.released=case["released"].as_bool().unwrap();v
            });
            let mut owners=vec![Arc::new(ManagedVoice::new(voice,finalizer))];
            for _ in 1..case["strong_before"].as_u64().unwrap() {owners.push(Arc::clone(&owners[0]));}
            let mut weak=vec![];
            for _ in 1..case["weak_before"].as_u64().unwrap() {weak.push(Arc::downgrade(&owners[0]));}
            for milestone in case["milestones"].as_array().unwrap() {
                drop(owners.pop().unwrap());
                assert_eq!(owners.len(),milestone["strong"].as_u64().unwrap() as usize);
                let expected:Vec<_>=milestone["calls"].as_array().unwrap().iter().filter(|x|x["kind"]!="free_control").cloned().collect();
                assert_eq!(*calls.lock().unwrap(),expected);
            }
            assert!(weak.iter().all(|w|w.upgrade().is_none()));
            let before=calls.lock().unwrap().clone();weak.clear();assert_eq!(*calls.lock().unwrap(),before);
        }
    }
    #[test]
    fn weak_tick_updates_shared_state_and_last_owner_finalizes_once() {
        use crate::{audio_object_association::Associations,audio_voice_refresh};
        let calls=Arc::new(Mutex::new(vec![]));let target=Arc::clone(&calls);
        let finalizer:Finalizer=Arc::new(move |voice| {voice.finalize(1,true,|_,_|0,|c|target.lock().unwrap().push(notice(c)));});
        let voice=construct(42,123,2,"play",9,"stop",Clock::Ready(1000.25)).unwrap();
        let owner=Arc::new(ManagedVoice::new(Some(voice),finalizer));let mut list=Associations::default();
        list.associate(10,true,Some(Arc::clone(&owner)));
        let packets=Mutex::new(vec![]);
        list.tick(||{},|state|state.snapshot().unwrap().unwrap().lifecycle.released,
            |state|state.with_mut(|voice| {
                let voice=voice.unwrap();audio_voice_refresh::refresh(&mut voice.lifecycle,voice.refresh,1001.75,true,Some(2),|p| {packets.lock().unwrap().push(p);1}).unwrap();
            }).unwrap(),|_|panic!("owned voice"));
        assert_eq!(packets.lock().unwrap()[0].value,1.5);assert!(calls.lock().unwrap().is_empty());
        drop(owner);assert_eq!(calls.lock().unwrap().len(),5);assert!(list.entries()[0].lock().is_none());
        list.tick(||{},|_|panic!("expired voice"),|_|panic!("expired voice"),|token|assert_eq!(token,10));
        assert!(list.entries().is_empty());assert_eq!(calls.lock().unwrap().len(),5);
    }
    #[test]
    fn poisoned_state_is_reported_and_does_not_skip_finalization() {
        let count=Arc::new(std::sync::atomic::AtomicUsize::new(0));let output=Arc::clone(&count);
        let owner=ManagedVoice::new(Some(construct(42,123,0,"play",0,"",Clock::Ready(0.)).unwrap()),Arc::new(move |_| {output.fetch_add(1,std::sync::atomic::Ordering::SeqCst);}));
        let result=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||owner.with_mut::<()>(|_|panic!("mutation failure"))));
        assert!(result.is_err());assert!(matches!(owner.snapshot(),Err(AccessError::Poisoned)));
        drop(owner);assert_eq!(count.load(std::sync::atomic::Ordering::SeqCst),1);
    }
}
