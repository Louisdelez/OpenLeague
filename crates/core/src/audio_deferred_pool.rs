//! Original706720 deferred scratch cleanup. Actual disposal/destruction supplied by caller.
#[derive(Debug)]
pub struct Scratch<O,L> {
    /// Stable caller identity for scratch storage; never an invented playing ID.
    pub token:u64, pub object:O, pub linked:Option<L>, pub retired:u8,
}
#[derive(Debug)]
pub enum Cleanup<'a,O,L> { DisposeObject(&'a O), DestroyLinked(&'a L), RemoveScratch(u64) }
/// Native706600 has no rollback when scratch allocation fails. Return the
/// created object to the caller so its registered ownership remains explicit.
#[derive(Debug)]
pub enum Allocation<O,L> {
    Registered { token:u64 },
    NoObject { linked:Option<L> },
    ScratchFailed { object:O, linked:Option<L> },
}
/// Explicit shared native subsystem state. The caller owns one state across
/// pools, matching global2D77B20; it is not implicitly reset by pool creation.
#[derive(Debug)]
pub struct ScratchSubsystem { pub initialized:bool }
#[derive(Debug)]
pub struct Pool<O,L> { entries:Vec<Scratch<O,L>> }
impl<O,L> Default for Pool<O,L> {fn default()->Self {Self {entries:vec![]}}}
impl<O,L> Pool<O,L> {
    /// Original706600 default allocator path; physical factory/storage adapters
    /// supply actual objects and caller identities. No invented playing IDs.
    pub fn allocate(
        &mut self, subsystem:&mut ScratchSubsystem, linked:Option<L>,
        mut create_object:impl FnMut()->Option<O>,
        mut initialize:impl FnMut(),
        mut allocate_storage:impl FnMut()->Option<u64>,
    )->Allocation<O,L> {
        let Some(object)=create_object() else {return Allocation::NoObject {linked};};
        if !subsystem.initialized {
            // The original marks initialized before invoking the initializer.
            subsystem.initialized=true;
            initialize();
        }
        let Some(token)=allocate_storage() else {
            return Allocation::ScratchFailed {object,linked};
        };
        self.push(Scratch {token,object,linked,retired:0});
        Allocation::Registered {token}
    }
    pub fn push(&mut self,entry:Scratch<O,L>) {self.entries.push(entry);}
    pub fn entries(&self)->&[Scratch<O,L>] {&self.entries}
    pub fn entries_mut(&mut self)->&mut [Scratch<O,L>] {&mut self.entries}
    /// Route a physical callback by its stable scratch cookie, never by the
    /// current vector index (retired cleanup uses swap-last). The consumer runs
    /// after the native retired flag changes; object disposal stays deferred.
    /// Missing cookies are reported, so adapters can diagnose stale delivery.
    pub fn deliver_callback(&mut self,token:u64,event_type:u32,
        mut consume:impl FnMut(&L,crate::audio_object_callbacks::InterfaceCall))->bool {
        let Some(entry)=self.entries.iter_mut().find(|entry|entry.token==token) else {return false;};
        let calls=crate::audio_object_callbacks::deliver(
            crate::audio_object_callbacks::Kind::Unbound,event_type,true,
            entry.linked.is_some(),&mut entry.retired);
        if let Some(linked)=&entry.linked {
            for call in calls {consume(linked,call);}
        }
        true
    }
    /// Original7066A0 shutdown cleanup, in original insertion order, including
    /// active entries. Unlike retired cleanup, no swap-last reordering occurs.
    pub fn clear(&mut self,mut consume:impl FnMut(Cleanup<'_,O,L>)) {
        for entry in &self.entries {
            consume(Cleanup::DisposeObject(&entry.object));
            if let Some(linked)=&entry.linked {consume(Cleanup::DestroyLinked(linked));}
            consume(Cleanup::RemoveScratch(entry.token));
        }
        self.entries.clear();
    }
    /// Nonzero retired byte triggers native dispose -> optional linked destroy ->
    /// storage removal. Swap-last means indices are not stable; use caller tokens.
    pub fn cleanup(&mut self,mut consume:impl FnMut(Cleanup<'_,O,L>)) {
        let mut index=0;
        while index<self.entries.len() {
            let entry=&self.entries[index];
            if entry.retired==0 {index+=1;continue;}
            consume(Cleanup::DisposeObject(&entry.object));
            if let Some(linked)=&entry.linked {consume(Cleanup::DestroyLinked(linked));}
            consume(Cleanup::RemoveScratch(entry.token));
            self.entries.swap_remove(index);
            // The moved entry is checked at the same index, as in706720.
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_378_original_retired_and_shutdown_cleanup_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_deferred_pool_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),378);
        for case in cases {
            let mut pool=Pool::default();
            for item in case["input"].as_array().unwrap() {
                let index=item["index"].as_u64().unwrap();
                pool.push(Scratch {token:index,object:index,linked:item["linked"].as_bool().unwrap().then_some(index),retired:item["retired"].as_u64().unwrap() as u8});
            }
            let mut calls=vec![];
            for _ in 0..case["repeat_runs"].as_u64().unwrap() {
                let consume=|command:Cleanup<'_,u64,u64>|calls.push(match command {
                    Cleanup::DisposeObject(index)=>serde_json::json!({"kind":"dispose_object","index":index}),
                    Cleanup::DestroyLinked(index)=>serde_json::json!({"kind":"destroy_linked","index":index,"argument":1}),
                    Cleanup::RemoveScratch(index)=>serde_json::json!({"kind":"free_scratch","index":index}),
                });
                if case["mode"]=="all" {pool.clear(consume);} else {pool.cleanup(consume);}
            }
            assert_eq!(calls,*case["calls"].as_array().unwrap());
            let remaining:Vec<u64>=pool.entries().iter().map(|e|e.token).collect();
            let expected:Vec<u64>=case["remaining_indices"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap()).collect();
            assert_eq!(remaining,expected);assert!(pool.entries().iter().all(|x|x.retired==0));
        }
    }
    #[test]
    fn shutdown_disposes_active_and_retired_sources_in_insertion_order_once() {
        let mut pool=Pool::<u32,u32>::default();
        for (token,retired) in [(10,0),(11,1),(12,0)] {pool.push(Scratch {token,object:token as u32,linked:None,retired});}
        let mut disposed=vec![];pool.clear(|command|if let Cleanup::DisposeObject(object)=command {disposed.push(*object)});
        assert_eq!(disposed,vec![10,11,12]);assert!(pool.entries().is_empty());pool.clear(|_|panic!("shutdown must not replay"));
    }
    #[test]
    fn native_end_callback_defers_disposal_and_keeps_active_sounds() {
        use crate::audio_object_callbacks::{deliver,Kind};
        let mut pool=Pool::default();
        pool.push(Scratch {token:10,object:123,linked:Some(42),retired:0});
        pool.push(Scratch {token:11,object:124,linked:None,retired:0});
        let calls=deliver(Kind::Unbound,1,true,true,&mut pool.entries_mut()[0].retired);
        assert_eq!(calls.len(),1);assert_eq!(pool.entries().len(),2);
        let mut order=vec![];
        pool.cleanup(|command|match command {
            Cleanup::DisposeObject(object)=>{assert_eq!(*object,123);order.push("dispose");},
            Cleanup::DestroyLinked(linked)=>{assert_eq!(*linked,42);order.push("linked");},
            Cleanup::RemoveScratch(token)=>{assert_eq!(token,10);order.push("remove");},
        });
        assert_eq!(order,vec!["dispose","linked","remove"]);assert_eq!(pool.entries().len(),1);
        assert_eq!(pool.entries()[0].object,124);assert_eq!(pool.entries()[0].token,11);
        pool.cleanup(|_|panic!("active source must remain"));
    }
    #[test]
    fn matches_16_original_allocation_and_failure_cases() {
        use std::cell::RefCell;
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_scratch_allocation_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),16);
        for case in cases {
            let mut pool=Pool::default();
            let mut subsystem=ScratchSubsystem {initialized:case["initialized_before"].as_bool().unwrap()};
            let linked=case["linked_present"].as_bool().unwrap().then_some(42u32);
            let calls=RefCell::new(Vec::new());
            // Include the owner in O so registration preserves its identity.
            let result=pool.allocate(&mut subsystem,linked,
                || {calls.borrow_mut().push("object_factory");case["object_created"].as_bool().unwrap().then_some((123u32,789u32))},
                || calls.borrow_mut().push("initialize_scratch_subsystem"),
                || {calls.borrow_mut().push("allocate_scratch16");case["scratch_allocated"].as_bool().unwrap().then_some(10)});
            assert_eq!(serde_json::json!(*calls.borrow()),case["calls"]);
            assert_eq!(subsystem.initialized,case["initialized_after"].as_bool().unwrap());
            assert_eq!(!pool.entries().is_empty(),case["registered"].as_bool().unwrap());
            match result {
                Allocation::Registered {token}=> {
                    assert_eq!(token,10);let entry=&pool.entries()[0];
                    assert_eq!(entry.object,(123,789));assert_eq!(entry.linked,linked);
                    assert_eq!(serde_json::json!({"object_present":true,"engine_preserved":true,"linked_present":entry.linked.is_some(),"retired":entry.retired}),case["fields"]);
                },
                Allocation::NoObject {linked:returned}=> {
                    assert!(!case["object_created"].as_bool().unwrap());assert_eq!(returned,linked);
                },
                Allocation::ScratchFailed {object,linked:returned}=> {
                    assert!(case["object_created"].as_bool().unwrap());
                    assert!(!case["scratch_allocated"].as_bool().unwrap());
                    // Do not dispose a factory-registered object on failure.
                    assert_eq!(object,(123,789));assert_eq!(returned,linked);
                },
            }
        }
    }
    #[test]
    fn allocation_shared_initialization_and_end_cleanup_bridge() {
        use std::cell::Cell;
        use crate::audio_object_callbacks::{deliver,Kind};
        let mut subsystem=ScratchSubsystem {initialized:false};
        let initializations=Cell::new(0);
        let mut first=Pool::<u32,u32>::default();
        let mut second=Pool::<u32,u32>::default();
        assert!(matches!(first.allocate(&mut subsystem,None,||None,||panic!("no object"),||panic!("no object")),Allocation::NoObject {..}));
        assert!(!subsystem.initialized);
        assert!(matches!(first.allocate(&mut subsystem,Some(42),||Some(123),||initializations.set(initializations.get()+1),||Some(10)),Allocation::Registered {token:10}));
        assert!(matches!(second.allocate(&mut subsystem,None,||Some(124),||panic!("shared initialization must run once"),||None),Allocation::ScratchFailed {object:124,linked:None}));
        assert_eq!(initializations.get(),1);
        assert!(second.entries().is_empty());
        deliver(Kind::Unbound,1,true,true,&mut first.entries_mut()[0].retired);
        let mut order=vec![];
        first.cleanup(|command|match command {
            Cleanup::DisposeObject(object)=> {assert_eq!(*object,123);order.push("dispose");},
            Cleanup::DestroyLinked(linked)=> {assert_eq!(*linked,42);order.push("linked");},
            Cleanup::RemoveScratch(token)=> {assert_eq!(token,10);order.push("remove");},
        });
        assert_eq!(order,vec!["dispose","linked","remove"]);
        assert!(first.entries().is_empty());
    }

}

#[cfg(test)] mod callback_routing_tests {
    use super::*;
    #[test] fn callback_cookie_survives_swap_last_and_defers_object_disposal() {
        let mut pool=Pool::default();
        for token in [10,20,30] {pool.push(Scratch {token,object:token+100,linked:Some(token+1000),retired:0});}
        let mut calls=Vec::new();
        assert!(pool.deliver_callback(10,1,|linked,call|calls.push((*linked,call.slot))));
        assert_eq!(pool.entries().len(),3);
        let mut disposed=Vec::new();
        pool.cleanup(|c|if let Cleanup::DisposeObject(o)=c {disposed.push(*o)});
        assert_eq!(disposed,[110]);assert_eq!(pool.entries()[0].token,30);
        assert!(pool.deliver_callback(30,4,|linked,call|calls.push((*linked,call.slot))));
        assert_eq!(pool.entries()[0].retired,0);
        for _ in 0..2 {assert!(pool.deliver_callback(30,1,|linked,call|calls.push((*linked,call.slot))));}
        assert_eq!(calls,[(1010,4),(1030,8),(1030,4),(1030,4)]);
        pool.cleanup(|c|if let Cleanup::DisposeObject(o)=c {disposed.push(*o)});
        assert_eq!(disposed,[110,130]);assert_eq!(pool.entries()[0].token,20);
        assert!(!pool.deliver_callback(30,1,|_,_|panic!("stale cookie must not target a different object")));
        assert_eq!(pool.entries()[0].retired,0);
    }
    #[test] fn routed_unbound_callbacks_match_original_contract() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_object_callbacks_contract.json")).unwrap();
        let mut count=0;
        for case in data["cases"].as_array().unwrap().iter().filter(|c|c["kind"]=="unbound") {
            count+=1;let present=case["cookie_present"].as_bool().unwrap();
            let mut pool=Pool::default();
            let retired=case["initial_retired"].as_u64().unwrap() as u8;
            if present {pool.push(Scratch {token:71,object:123,linked:case["linked_object_present"].as_bool().unwrap().then_some(99),retired});}
            let mut calls=Vec::new();
            assert_eq!(pool.deliver_callback(71,case["event_type"].as_u64().unwrap() as u32,|linked,c| {
                assert_eq!(*linked,99);calls.push(serde_json::json!({"slot":c.slot,"argument":c.argument}));
            }),present);
            assert_eq!(serde_json::json!(calls),case["calls"]);
            assert_eq!(u64::from(pool.entries().first().map_or(retired,|e|e.retired)),case["final_retired"].as_u64().unwrap());
        }
        assert_eq!(count,40);
    }
}
