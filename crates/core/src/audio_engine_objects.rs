//! Native7056A0 engine object index disposal. Entries are non-owning identities;
//! erasing another wrapper's matching ID does not destroy that wrapper.
use std::collections::BTreeMap;
#[derive(Debug,Default)]
pub struct ObjectIndex {entries:BTreeMap<u32,Vec<u64>>}
impl ObjectIndex {
    /// Stable identities supplied by the real object factory, not playing IDs.
    /// Native multimap permits repeated IDs and repeated values; no deduplication.
    pub fn insert(&mut self,object_id:u32,token:u64) {self.entries.entry(object_id).or_default().push(token);}
    pub fn tokens(&self,object_id:u32)->&[u64] {self.entries.get(&object_id).map_or(&[],Vec::as_slice)}
    /// Null object skips all work. A supplied object is destroyed even when its
    /// ID is absent. All matching non-owning index entries disappear beforehand.
    /// The erase callback reports removed identities; it must not destroy them.
    pub fn dispose<O>(&mut self,object:Option<O>,get_id:impl FnOnce(&O)->u32,
        erased:impl FnOnce(u32,&[u64]),destroy:impl FnOnce(O,u8))->bool {
        let Some(object)=object else {return false;};
        let id=get_id(&object);let removed=self.entries.remove(&id).unwrap_or_default();
        erased(id,&removed);destroy(object,1);true
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_1512_original_engine_disposal_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_engine_disposal_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),1512);
        for case in cases {
            let mut index=ObjectIndex::default();let keys:Vec<u32>=case["keys"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            for (token,key) in keys.iter().enumerate() {index.insert(*key,token as u64);}
            let request=case["request_raw"].as_u64().unwrap() as u32;let present=case["wrapper_present"].as_bool().unwrap();
            let mut erased_tokens=vec![];let mut destroyed=vec![];
            let result=index.dispose(present.then_some(request),|id|*id,
                |id,tokens| {assert_eq!(id,request);erased_tokens=tokens.to_vec();},
                |id,flags|destroyed.push((id,flags)));
            assert_eq!(result,present);assert_eq!(destroyed,if present {vec![(request,1)]} else {vec![]});
            let native_erased:Vec<u64>=case["calls"].as_array().unwrap().iter().filter(|x|x["kind"]=="free_map_node").map(|x|x["index"].as_u64().unwrap()).collect();
            let mut sorted=native_erased;sorted.sort();assert_eq!(erased_tokens,sorted);
            let mut remaining=vec![];for values in index.entries.values() {remaining.extend(values.iter().copied());}remaining.sort();
            assert_eq!(serde_json::json!(remaining),case["remaining_indices"]);
        }
    }
    #[test]
    fn scratch_cleanup_removes_object_index_before_invalidation_and_storage_free() {
        use std::cell::RefCell;
        use std::sync::{Arc,Mutex};
        use crate::{audio_deferred_pool::{Pool,Scratch,Cleanup},audio_object_association::Associations,audio_managed_voice::ManagedVoice,audio_voice_constructor::{construct,Clock}};
        let voice=Arc::new(ManagedVoice::new(Some(construct(62,123,2,"play",0,"",Clock::Ready(0.)).unwrap()),Arc::new(|v| {v.finalize(1,true,|_,_|0,|_|{});} )));
        let mut associations=Associations::default();associations.associate(50,true,Some(Arc::clone(&voice)));
        let associations=Mutex::new(Some(associations));let mut index=ObjectIndex::default();
        index.insert(123,10);index.insert(123,11);index.insert(124,12);
        let mut scratch=Pool::<u32,u32>::default();scratch.push(Scratch {token:50,object:123,linked:Some(70),retired:1});
        let order=RefCell::new(vec![]);
        scratch.cleanup(|command|match command {
            Cleanup::DisposeObject(object)=> {
                assert!(index.dispose(Some(*object),|id|*id,
                    |id,tokens| {assert_eq!((id,tokens),(123,&[10,11][..]));order.borrow_mut().push("erase_index");},
                    |_,flags| {
                        assert_eq!(flags,1);let list=associations.lock().unwrap().take().unwrap();
                        list.destroy(true,true,||order.borrow_mut().push("unregister"),
                            |v| {order.borrow_mut().push("invalidate");v.invalidate_object()},|_|{},||order.borrow_mut().push("free_associations")).unwrap_or_else(|_|panic!("invalidation failed"));
                        order.borrow_mut().push("free_object");
                    }));
            },
            Cleanup::DestroyLinked(linked)=> {assert_eq!(*linked,70);order.borrow_mut().push("destroy_linked");},
            Cleanup::RemoveScratch(token)=> {assert_eq!(token,50);order.borrow_mut().push("free_scratch");},
        });
        assert_eq!(*order.borrow(),vec!["erase_index","unregister","invalidate","free_associations","free_object","destroy_linked","free_scratch"]);
        assert!(index.tokens(123).is_empty());assert_eq!(index.tokens(124),&[12]);assert!(scratch.entries().is_empty());
        let state=voice.snapshot().unwrap().unwrap();assert_eq!(state.lifecycle.object_id,-1);assert_eq!(state.lifecycle.playing_id,62);assert!(!state.lifecycle.released);
    }
    #[test]
    fn missing_index_still_destroys_supplied_wrapper_and_duplicates_are_not_other_wrappers() {
        let mut index=ObjectIndex::default();index.insert(0,10);index.insert(0,11);index.insert(u32::MAX,12);
        let mut destroyed=vec![];
        index.dispose(Some((0,10)),|object|object.0,|_,tokens|assert_eq!(tokens,&[10,11]),|object,flags| {assert_eq!(flags,1);destroyed.push(object.1);});
        assert_eq!(destroyed,vec![10]);assert_eq!(index.tokens(u32::MAX),&[12]);
        index.dispose(Some((0,99)),|object|object.0,|_,tokens|assert!(tokens.is_empty()),|object,_|destroyed.push(object.1));
        assert_eq!(destroyed,vec![10,99]);
        assert!(!index.dispose::<()>(None,|_|panic!("null wrapper"),|_,_|panic!("null wrapper"),|_,_|panic!("null wrapper")));
    }
}
