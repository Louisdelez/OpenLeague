//! Original7074E0 weak association and5BD6F0 lock; no strong ownership retained.
use std::sync::{Arc,Weak};
#[derive(Debug)]
pub struct Association<T> {pub token:u64,reference:Option<Weak<T>>}
impl<T> Association<T> {
    /// Native lock succeeds only while a shared owner remains. A raw voice with
    /// no control block is explicitly unresolvable rather than dereferenced.
    pub fn lock(&self)->Option<Arc<T>> {self.reference.as_ref().and_then(Weak::upgrade)}
}
#[derive(Debug)]
pub struct Associations<T> {entries:Vec<Association<T>>}
impl<T> Default for Associations<T> {fn default()->Self {Self {entries:vec![]}}}
impl<T> Associations<T> {
    /// Consumes the passed strong copy as7074E0 does. A non-null voice creates a
    /// weak entry; a null voice creates no entry even when control exists.
    pub fn associate(&mut self,token:u64,voice_present:bool,owner:Option<Arc<T>>)->bool {
        if !voice_present {return false;}
        self.entries.push(Association {token,reference:owner.as_ref().map(Arc::downgrade)});
        true
    }
    pub fn entries(&self)->&[Association<T>] {&self.entries}
    /// Original707170 unregisters the object, invalidates lockable voices, then
    /// drops all weak entries and frees vector storage. Failure preserves this
    /// collection for caller recovery; prior unregister/invalidation is not undone.
    /// Consumes the collection so successful destruction cannot be replayed.
    pub fn destroy<E>(mut self,engine_available:bool,storage_present:bool,
        unregister:impl FnOnce(),mut invalidate:impl FnMut(&T)->Result<(),E>,
        mut detached:impl FnMut(u64),free_storage:impl FnOnce())->Result<(),(Self,E)> {
        if engine_available {unregister();}
        let mut index=0;
        while index<self.entries.len() {
            if let Some(voice)=self.entries[index].lock() {
                if let Err(error)=invalidate(&voice) {drop(voice);return Err((self,error));}
            }
            index+=1;
        }
        for entry in self.entries.drain(..) {
            let token=entry.token;drop(entry);detached(token);
        }
        if storage_present {free_storage();}
        Ok(())
    }
    /// Original707300: update object height first, lock weak entries, skip
    /// refresh for released voices, and erase only entries that cannot lock.
    /// Ordered removal is intentionally distinct from scratch swap-last cleanup.
    pub fn tick(&mut self,mut update_object:impl FnMut(),
        mut released:impl FnMut(&T)->bool,mut refresh:impl FnMut(&T),
        mut expired:impl FnMut(u64))->bool {
        update_object();
        let mut index=0;
        while index<self.entries.len() {
            if let Some(voice)=self.entries[index].lock() {
                if !released(&voice) {refresh(&voice);}
                // Marking released during refresh does not remove this entry.
                index+=1;
            } else {
                let token=self.entries.remove(index).token;
                expired(token);
            }
        }
        true
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_48_original_association_and_lock_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_association_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
        for c in cases {
            let present=c["voice_present"].as_bool().unwrap();let controlled=c["control_present"].as_bool().unwrap();
            let strong=c["strong_before"].as_u64().unwrap() as usize;let weak=c["weak_before"].as_u64().unwrap() as usize;
            let mut list=Associations::default();
            for token in 0..c["prior_entries"].as_u64().unwrap() {list.associate(token,true,None);}
            let mut owners=vec![];let mut prior_weak=vec![];
            if controlled {
                owners.push(Arc::new(123));
                for _ in 1..strong {owners.push(Arc::clone(&owners[0]));}
                for _ in 1..weak {prior_weak.push(Arc::downgrade(&owners[0]));}
            }
            let inserted=list.associate(10,present,owners.pop());assert_eq!(inserted,present);
            assert_eq!(list.entries().len(),c["entries_after"].as_u64().unwrap() as usize);
            if present {
                let entry=list.entries().last().unwrap();let locked=entry.lock();assert_eq!(locked.is_some(),c["locked"].as_bool().unwrap());drop(locked);
            }
            if controlled {
                assert_eq!(owners.len(),c["strong_after"].as_u64().unwrap() as usize);
                if let Some(owner)=owners.first() {
                    assert_eq!(Arc::strong_count(owner),owners.len());
                    // Native includes the implicit weak count of the live control.
                    assert_eq!(Arc::weak_count(owner)+1,c["weak_after"].as_u64().unwrap() as usize);
                }
            }
            drop(prior_weak);
        }
    }
    #[test]
    fn last_owner_expiration_is_not_delayed_or_resurrected_by_association() {
        let owner=Arc::new(123);let mut list=Associations::default();
        list.associate(10,true,Some(Arc::clone(&owner)));
        assert_eq!(Arc::strong_count(&owner),1);assert_eq!(Arc::weak_count(&owner),1);
        let locked=list.entries()[0].lock().unwrap();drop(owner);assert_eq!(*locked,123);
        drop(locked);assert!(list.entries()[0].lock().is_none());
        assert_eq!(list.entries().len(),1); // pruning belongs to native object tick.
        list.associate(11,true,None);assert!(list.entries()[1].lock().is_none());
    }
    #[test]
    fn matches_682_original_ordered_tick_and_expiration_cases() {
        use std::cell::{Cell,RefCell};
        struct State {index:usize,released:Cell<u8>}
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_tick_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),682);
        for case in cases {
            let states=case["states"].as_array().unwrap();let retire=case["retire_on_refresh"].as_bool().unwrap();
            let mut list=Associations::default();let mut owners=vec![];
            for (index,state) in states.iter().enumerate() {
                let state=state.as_str().unwrap();
                if state=="unmanaged" {list.associate(index as u64,true,None);owners.push(None);continue;}
                let owner=Arc::new(State {index,released:Cell::new(if state=="released" {255} else {0})});
                list.associate(index as u64,true,Some(Arc::clone(&owner)));
                owners.push(if state=="expired" {None} else {Some(owner)});
            }
            let calls=RefCell::new(vec![]);let mut returns=vec![];
            for _ in 0..case["repeat_runs"].as_u64().unwrap() {
                returns.push(u8::from(list.tick(
                    ||calls.borrow_mut().push(serde_json::json!({"kind":"height_update"})),
                    |voice|voice.released.get()!=0,
                    |voice| {calls.borrow_mut().push(serde_json::json!({"kind":"refresh","index":voice.index}));if retire {voice.released.set(1);}},
                    |token| {if states[token as usize]=="expired" {calls.borrow_mut().push(serde_json::json!({"kind":"free_control","index":token}));}})));
            }
            assert_eq!(*calls.borrow(),*case["calls"].as_array().unwrap());
            assert_eq!(serde_json::json!(returns),case["returns"]);
            assert_eq!(serde_json::json!(list.entries().iter().map(|e|e.token).collect::<Vec<_>>()),case["remaining_indices"]);
            for (index,owner) in owners.iter().enumerate() {
                if let Some(owner)=owner {
                    assert_eq!(Arc::strong_count(owner),case["control_counts"][index]["strong"].as_u64().unwrap() as usize);
                    assert_eq!(Arc::weak_count(owner)+1,case["control_counts"][index]["weak"].as_u64().unwrap() as usize);
                }
            }
        }
    }
    #[test]
    fn released_owned_voice_stays_until_final_owner_expires() {
        use std::cell::Cell;
        let owner=Arc::new(Cell::new(false));let mut list=Associations::default();
        list.associate(10,true,Some(Arc::clone(&owner)));
        list.tick(||{},|v|v.get(),|v|v.set(true),|_|panic!("owned voice"));
        assert!(owner.get());assert_eq!(list.entries().len(),1);
        list.tick(||{},|v|v.get(),|_|panic!("released voice must not refresh"),|_|panic!("owned voice"));
        drop(owner);let mut expired=vec![];
        list.tick(||{},|_|panic!("expired voice"),|_|panic!("expired voice"),|token|expired.push(token));
        assert_eq!(expired,vec![10]);assert!(list.entries().is_empty());
    }

    #[test]
    fn matches_684_original_object_destruction_cases() {
        use std::cell::{Cell,RefCell};
        struct State {index:usize,object_id:Cell<u32>,playing_id:u32,released:u8}
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_destruction_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),684);
        for case in cases {
            let states=case["states"].as_array().unwrap();let mut list=Associations::default();let mut owners=vec![];
            for (index,state) in states.iter().enumerate() {
                let state=state.as_str().unwrap();let owner=Arc::new(State {index,object_id:Cell::new(123),playing_id:62+index as u32,released:if state=="released" {255} else {0}});
                list.associate(index as u64,true,if state=="unmanaged" {None} else {Some(Arc::clone(&owner))});
                owners.push(if state=="expired" {None} else {Some(owner)});
            }
            let calls=RefCell::new(vec![]);
            list.destroy(case["engine_available"].as_bool().unwrap(),case["storage_present"].as_bool().unwrap(),
                ||calls.borrow_mut().push(serde_json::json!({"kind":"unregister","object_id":123})),
                |voice| {calls.borrow_mut().push(serde_json::json!({"kind":"invalidate","index":voice.index}));voice.object_id.set(u32::MAX);Ok::<(),()>(())},
                |token| {if states[token as usize]=="expired" {calls.borrow_mut().push(serde_json::json!({"kind":"free_control","index":token}));}},
                ||calls.borrow_mut().push(serde_json::json!({"kind":"free_association_storage"}))).unwrap_or_else(|_|panic!("fixture invalidation failed"));
            assert_eq!(*calls.borrow(),*case["calls"].as_array().unwrap());
            for (index,owner) in owners.iter().enumerate() {
                if let Some(owner)=owner {
                    let f=&case["voice_fields"][index];assert_eq!(owner.object_id.get(),f["object_id"].as_u64().unwrap() as u32);assert_eq!(owner.playing_id,f["playing_id"].as_u64().unwrap() as u32);assert_eq!(owner.released,f["released_raw"].as_u64().unwrap() as u8);
                    if states[index]!="unmanaged" {assert_eq!(Arc::strong_count(owner),f["strong"].as_u64().unwrap() as usize);assert_eq!(Arc::weak_count(owner)+1,f["weak"].as_u64().unwrap() as usize);}
                }
            }
        }
    }
    #[test]
    fn destroying_object_invalidates_voice_without_stopping_it_then_release_uses_playing_id() {
        use std::sync::Mutex;
        use crate::{audio_managed_voice::{ManagedVoice,Finalizer},audio_voice_constructor::{construct,Clock,Destruction},audio_release::ReleaseCommand};
        let order=Arc::new(Mutex::new(vec![]));let target=Arc::clone(&order);
        let finalizer:Finalizer=Arc::new(move |voice| {voice.finalize(1,true,|_,_|panic!("already explicitly released"),|c|target.lock().unwrap().push(match c {Destruction::DestroyStopString=>"stop_string",Destruction::DestroyPlayString=>"play_string",Destruction::FreeVoiceStorage=>"free_voice",Destruction::Release(_)=>panic!("duplicate stop")}));});
        let owner=Arc::new(ManagedVoice::new(Some(construct(62,123,2,"play",9,"stop",Clock::Ready(0.)).unwrap()),finalizer));let mut list=Associations::default();list.associate(10,true,Some(Arc::clone(&owner)));
        list.destroy(true,true,||order.lock().unwrap().push("unregister"),
            |voice| {order.lock().unwrap().push("invalidate");voice.invalidate_object()},|_|{},||order.lock().unwrap().push("free_associations")).unwrap_or_else(|_|panic!("invalidation failed"));
        let snapshot=owner.snapshot().unwrap().unwrap();assert_eq!(snapshot.lifecycle.object_id,-1);assert_eq!(snapshot.lifecycle.playing_id,62);assert!(!snapshot.lifecycle.released);assert_eq!(snapshot.refresh.expected_record_raw,2);
        assert_eq!(*order.lock().unwrap(),vec!["unregister","invalidate","free_associations"]);
        owner.with_mut(|voice| {
            let commands=voice.unwrap().lifecycle.release(true,|_,_|panic!("invalid object must not post stop event"));
            assert_eq!(commands,vec![ReleaseCommand::StopPlayingId {playing_id:62,duration_ms:0,curve:4}]);order.lock().unwrap().push("stop_playing_id");
        }).unwrap();
        drop(owner);assert_eq!(*order.lock().unwrap(),vec!["unregister","invalidate","free_associations","stop_playing_id","stop_string","play_string","free_voice"]);
    }
    #[test]
    fn invalidation_error_returns_collection_without_freeing_its_storage() {
        let owner=Arc::new(123);let mut list=Associations::default();list.associate(10,true,Some(Arc::clone(&owner)));
        let result=list.destroy(false,true,||panic!("engine unavailable"),|_|Err("invalidation failed"),|_|panic!("must preserve entries"),||panic!("must preserve storage"));
        let (list,error)=result.unwrap_err();assert_eq!(error,"invalidation failed");assert_eq!(list.entries().len(),1);assert_eq!(*list.entries()[0].lock().unwrap(),123);
    }

}
