//! Native 905CA0 valid unique namespace-table lookup. Mount data and optional
//! parent output are external; this is not a fabricated native VFS mount.
use std::ffi::{CStr,CString};
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Origin {Table,Parent,Empty}
pub struct Selected<'a> {pub value:&'a CStr,pub origin:Origin}
pub struct Namespace {entries:Vec<(CString,CString)>}
fn compare(a:&CStr,b:&CStr)->std::cmp::Ordering {
    a.to_bytes().iter().map(|v|v.to_ascii_lowercase() as i8)
        .cmp(b.to_bytes().iter().map(|v|v.to_ascii_lowercase() as i8))
}
impl Namespace {
    pub fn empty()->Self {Self {entries:Vec::new()}}
    /// Native 905010: preserve any existing entry, including an empty value.
    /// Rust owns its storage; native allocator/tree balancing is not reproduced.
    pub fn register_if_absent(&mut self,key:&CStr,value:&CStr)->bool {
        let index=self.entries.partition_point(|entry|compare(&entry.0,key).is_lt());
        if self.entries.get(index).is_some_and(|entry|compare(key,&entry.0).is_eq()) {return false;}
        self.entries.insert(index,(key.to_owned(),value.to_owned()));true
    }
    /// Prepared native TGA branch: an existing DDS target is replaced; other
    /// existing targets, including empty ones, are retained.
    pub fn register_tga(&mut self,key:&CStr,value:&CStr)->bool {
        if self.register_if_absent(key,value) {return true;}
        let index=self.entries.partition_point(|entry|compare(&entry.0,key).is_lt());
        let entry=&mut self.entries[index];
        let parts=crate::native_config_path_parts::split(entry.1.to_bytes(),b"tga");
        if parts.extension.eq_ignore_ascii_case(b"dds") {entry.1=value.to_owned();true}else{false}
    }
    /// Original prepared SCB branch replaces the SCO alias unconditionally,
    /// then replaces the physical SCB filename value too.
    /// Stem and filename are supplied by the original path splitting caller.
    pub fn register_scb(&mut self, stem:&CStr, filename:&CStr, full_path:&CStr) {
        let mut alias=stem.to_bytes().to_vec();alias.extend_from_slice(b".sco");
        let alias=CString::new(alias).expect("CStr stem has no interior nul");
        if !self.register_if_absent(&alias,full_path) {
            let index=self.entries.partition_point(|entry|compare(&entry.0,&alias).is_lt());
            self.entries[index].1=full_path.to_owned();
        }
        if !self.register_if_absent(filename,full_path) {
            let index=self.entries.partition_point(|entry|compare(&entry.0,filename).is_lt());
            self.entries[index].1=full_path.to_owned();
        }
    }
    pub fn len(&self)->usize {self.entries.len()}

    /// Duplicate native registration/replacement policy is separate. This
    /// adapter admits only the same valid unique-table scope as the native probe.
    pub fn new(mut entries:Vec<(CString,CString)>)->Result<Self,&'static str> {
        entries.sort_by(|a,b|compare(&a.0,&b.0));
        if entries.windows(2).any(|w|compare(&w[0].0,&w[1].0).is_eq()) {return Err("duplicate native namespace key");}
        Ok(Self {entries})
    }
    pub fn lookup<'a>(&'a self,requested:&CStr,parent:Option<&'a CStr>)->Selected<'a> {
        // Original string::find slash indices are discarded; no basename or
        // slash normalization may be inferred from those two calls.
        let index=self.entries.partition_point(|entry|compare(&entry.0,requested).is_lt());
        if let Some((key,value))=self.entries.get(index).filter(|entry|compare(requested,&entry.0).is_eq()) {
            let _=key;return Selected {value,origin:Origin::Table};
        }
        if let Some(value)=parent {return Selected {value,origin:Origin::Parent};}
        Selected {value:CStr::from_bytes_with_nul(b"\0").unwrap(),origin:Origin::Empty}
    }
}

#[cfg(test)]
#[path="relic_namespace_tests.rs"]
mod tests;
