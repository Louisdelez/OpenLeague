//! Native CPU texture cache/reference/resident ownership, for balanced valid loads.
//! Native file hashing and actual GPU upload/unbinding/destruction stay at the host.
use std::collections::HashMap;
pub type Id=u64;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Error {Missing,DuplicateId,ReferenceOverflow}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Release {Retained,Destroyed}
#[derive(Clone,Copy,Debug)]
struct Entry {key:u32,refs:i32}
#[derive(Default,Debug)]
pub struct Cache {
    keys:HashMap<u32,Id>,entries:HashMap<Id,Entry>,resident:Vec<Id>,created:Vec<Id>,
}
impl Cache {
    /// Successful new loader return or native hash-cache hit owns one reference.
    pub fn acquire(&mut self,key:u32,new_id:Id)->Result<Id,Error> {
        if let Some(&id)=self.keys.get(&key) {
            let e=self.entries.get_mut(&id).ok_or(Error::Missing)?;
            e.refs=e.refs.checked_add(1).ok_or(Error::ReferenceOverflow)?;return Ok(id);
        }
        if self.entries.contains_key(&new_id) {return Err(Error::DuplicateId);}
        self.keys.insert(key,new_id);self.entries.insert(new_id,Entry {key,refs:1});self.created.push(new_id);Ok(new_id)
    }
    /// Original 980AC0 increments only on the first resident registration.
    pub fn register_resident(&mut self,id:Id)->Result<bool,Error> {
        let e=self.entries.get_mut(&id).ok_or(Error::Missing)?;
        if self.resident.contains(&id) {return Ok(false);}
        e.refs=e.refs.checked_add(1).ok_or(Error::ReferenceOverflow)?;self.resident.push(id);Ok(true)
    }
    pub fn lookup(&self,key:u32)->Option<Id> {self.keys.get(&key).copied()}
    pub fn refs(&self,id:Id)->Option<i32> {self.entries.get(&id).map(|e|e.refs)}
    pub fn len(&self)->usize {self.keys.len()}
    pub fn resident_len(&self)->usize {self.resident.len()}
    pub fn live_linked_len(&self)->usize {self.created.len()}
    /// Reports destruction to the renderer; no GPU side effect is manufactured.
    pub fn release(&mut self,id:Id)->Result<Release,Error> {
        let e=self.entries.get_mut(&id).ok_or(Error::Missing)?;
        if e.refs<=0 {return Ok(Release::Retained);}
        e.refs-=1;
        if e.refs!=0 {return Ok(Release::Retained);}
        let key=e.key;self.entries.remove(&id);self.keys.remove(&key);
        // Native 98AD00 unlinks the destroyed resource from the renderer list.
        // Keep only live identities, rather than an ever-growing creation log.
        self.created.retain(|linked|*linked!=id);Ok(Release::Destroyed)
    }
    /// 9809E0 drops resident references, clears that vector, then forcibly closes
    /// any resources still linked to the renderer; outstanding IDs become invalid.
    pub fn cleanup_renderer(&mut self)->Result<Vec<Id>,Error> {
        let mut destroyed=Vec::new();
        for id in self.resident.clone() {
            if self.release(id)?==Release::Destroyed {destroyed.push(id);}
        }
        self.resident.clear();
        for id in self.created.iter().rev().copied().collect::<Vec<_>>() {
            if let Some(e)=self.entries.get_mut(&id) {
                e.refs=1;
                if self.release(id)?==Release::Destroyed {destroyed.push(id);}
            }
        }
        self.created.clear();Ok(destroyed)
    }
}

#[cfg(test)]
#[path="relic_texture_reference_cache_tests.rs"]
mod tests;
