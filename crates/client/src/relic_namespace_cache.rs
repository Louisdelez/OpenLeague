//! Original90D9A0/90DA80 lazy empty namespace tables and ordered lookup.
//! Resource population is external; creating a cache entry does not mount files.
use std::ffi::{CStr,CString};
use crate::relic_namespace::Namespace;
pub struct NamespaceCache {entries:Vec<(CString,Namespace)>}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Origin {Namespace {order_index:usize},Empty}
pub struct Selected<'a> {pub value:&'a CStr,pub origin:Origin}
impl NamespaceCache {
    pub fn empty()->Self {Self {entries:Vec::new()}}
    pub fn from_unique(mut entries:Vec<(CString,Namespace)>)->Result<Self,&'static str> {
        entries.sort_by(|left,right|left.0.to_bytes().cmp(right.0.to_bytes()));
        if entries.windows(2).any(|pair|pair[0].0==pair[1].0) {
            return Err("duplicate prepared namespace cache key");
        }
        Ok(Self {entries})
    }
    pub fn len(&self)->usize {self.entries.len()}
    /// An absent exact namespace name creates one empty table when visited.
    /// Do not prepopulate later namespaces that a successful lookup never visits.
    pub fn lookup<'a>(&'a mut self,order:&[&CStr],requested:&CStr)->Selected<'a> {
        let mut winner=None;
        for (order_index,name) in order.iter().enumerate() {
            let index=self.entries.partition_point(|entry|entry.0.to_bytes()<name.to_bytes());
            if !self.entries.get(index).is_some_and(|entry|entry.0.as_c_str()==*name) {
                self.entries.insert(index,((*name).to_owned(),Namespace::empty()));
            }
            if !self.entries[index].1.lookup(requested,None).value.to_bytes().is_empty() {
                winner=Some((index,order_index));break;
            }
        }
        if let Some((index,order_index))=winner {
            return Selected {value:self.entries[index].1.lookup(requested,None).value,origin:Origin::Namespace {order_index}};
        }
        Selected {value:CStr::from_bytes_with_nul(b"\0").unwrap(),origin:Origin::Empty}
    }
}
