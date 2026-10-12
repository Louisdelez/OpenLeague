from pathlib import Path
out=Path(__file__).resolve().parent
source=Path('E:/OpenLeague/crates/core/src/audio_replay_metadata_state.rs').read_text()
start=source.index('fn add(')
end=source.index('///661F80')
body=source[start:end]
body=body[0:body.index('///64D040 lower_bound')] + body[body.index('///5CCFE0/5C23E0'):]
body=body.replace('fn insert_at(\n    b: &mut impl Boundary,','fn insert_at(\n    b: &mut impl Boundary,\n    kind: Kind,')
body=body.replace('fn insert_unhinted(b: &mut impl Boundary, tree:', 'fn insert_unhinted(b: &mut impl Boundary, kind: Kind, tree:')
body=body.replace('fn insert_hint(b: &mut impl Boundary, tree:', 'fn insert_hint(b: &mut impl Boundary, kind: Kind, tree:')
body=body.replace('insert_at(b, tree,', 'insert_at(b, kind, tree,').replace('insert_unhinted(b, tree,', 'insert_unhinted(b, kind, tree,')
body=body.replace('count >= MAX_SIZE', 'count >= kind.max_size()')
body=body.replace('free(b, node)?;\n        return Err(Error::CapacityExceeded);','delete_pending_node(b, kind, node)?;\n        return Err(Error::Boundary("native loading record tree capacity exceeded"));')
body=body.replace('free(b, node)?;\n        Ok(previous)','delete_pending_node(b, kind, node)?;\n        Ok(previous)')
body=body.replace('///5DA5E0 owns', '///5DB270/5DB550 own').replace('///5DA8C0 fallback','///5DB440/5DB710 fallback').replace('///663240 accepts','///5D32E0/5D3530 accept').replace('in5DA5E0','in5DB270/5DB550')
header='''//! Native loading record maps:5BE170 (standard140) and5BE1F0 (tutorial96).
//! Source field writes, unsigned keys, hinted insertion and native RB rotations.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Deallocator;
pub use crate::audio_replay_metadata::{Boundary,Error};
use std::collections::BTreeSet;
pub const STANDARD_NODE_BYTES:u32=140;
pub const TUTORIAL_NODE_BYTES:u32=96;
pub const TUTORIAL_CONSTRUCTION_BYTE:u32=0x14c758b;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind {Standard,Tutorial}
impl Kind {
 pub fn node_bytes(self)->u32 {match self {Self::Standard=>140,Self::Tutorial=>96}}
 pub fn max_size(self)->u32 {match self {Self::Standard=>0x1d41d40,Self::Tutorial=>0x2aaaaa9}}
 fn strings(self)->&'static [u32] {match self {Self::Standard=>&[0x74,0x44],Self::Tutorial=>&[0x3c]}}
}
'''
tail='''
fn reset_string(b:&mut impl Boundary,p:u32)->Result<(),Error> {
 put(b,p,20,15)?;put(b,p,16,0)?;set_byte(b,p,0,0)
}
///564900, called separately for each string by pending-node deletion.
fn destroy_string(b:&mut impl Boundary,p:u32)->Result<(),Error> {
 if word(b,p,20)? >= 16 {let route=b.deallocator()?;let raw=word(b,p,0)?;b.free(raw,route)?;}
 reset_string(b,p)
}
///5D56F0/5D5770, also capacity failure5DB270/5DB550.
fn delete_pending_node(b:&mut impl Boundary,kind:Kind,node:u32)->Result<(),Error> {
 for &offset in kind.strings() {destroy_string(b,add(node,offset)?)?;}free(b,node)
}
///Constructor snippets57CE5C..57CE72 /5B2BF5..5B2C0B and native
///sentinels5C75C0/5C75F0. Caller owns the8-byte header storage.
pub fn construct(b:&mut impl Boundary,kind:Kind,tree:u32)->Result<(),Error> {
 put(b,tree,0,0)?;put(b,tree,4,0)?;
 let node=b.allocate(kind.node_bytes())?;
 if node==0 {return Err(Error::AllocationFailed(kind.node_bytes()));}
 for offset in [0,4,8] {put(b,node,offset,node)?;}
 set_byte(b,node,12,1)?;set_byte(b,node,13,1)?;put(b,tree,0,node)
}
fn standard_value(b:&mut impl Boundary,p:u32)->Result<(),Error> {
 put(b,p,0,0)?;let flags=byte(b,p,0x18)?;set_byte(b,p,0x18,flags&0xfe)?;
 for offset in [0x14,4,8,0xc,0x10,0x1c,0x20,0x24,0x28,0x2c,0x40] {put(b,p,offset,0)?;}
 put(b,p,0x44,15)?;set_byte(b,p,0x30,0)?;
 for offset in [0x48,0x4c,0x54,0x58,0x5c] {put(b,p,offset,0)?;}
 put(b,p,0x50,0x40a00000)?;put(b,p,0x70,0)?;put(b,p,0x74,15)?;set_byte(b,p,0x60,0)
}
fn tutorial_pair(b:&mut impl Boundary,p:u32,key_ref:u32)->Result<(),Error> {
 let key=b.word(key_ref)?;put(b,p,0,key)?;put(b,p,4,0)?;
 let flags=byte(b,p,0x1c)?;set_byte(b,p,0x1c,flags&0xfe)?;
 for offset in [0x18,8,0xc,0x10,0x14,0x20,0x24,0x28,0x3c] {put(b,p,offset,0)?;}
 put(b,p,0x40,15)?;set_byte(b,p,0x2c,0)?;
 put(b,p,0x44,0)?;put(b,p,0x4c,0)?;put(b,p,0x48,0x40a00000)
}
fn allocate_node(b:&mut impl Boundary,kind:Kind,tree:u32,key_ref:u32)->Result<u32,Error> {
 let node=b.allocate(kind.node_bytes())?;if node==0 {return Err(Error::AllocationFailed(kind.node_bytes()));}
 for offset in [0,4,8] {let head=word(b,tree,0)?;put(b,node,offset,head)?;}
 set_byte(b,node,12,0)?;set_byte(b,node,13,0)?;
 match kind {
  Kind::Standard=>{let key=b.word(key_ref)?;put(b,node,16,key)?;standard_value(b,add(node,20)?)?;}
  Kind::Tutorial=>{let _opaque=b.read_byte(TUTORIAL_CONSTRUCTION_BYTE)?;tutorial_pair(b,add(node,16)?,key_ref)?;}
 }Ok(node)
}
///5BE170/5BE1F0: preserve key reads before search, after search and after
///allocation. A custom allocator may change the referenced key before ctor.
pub fn record_slot(b:&mut impl Boundary,kind:Kind,tree:u32,key_ref:u32)->Result<u32,Error> {
 let head=word(b,tree,0)?;let mut hint=head;let mut current=word(b,head,4)?;
 if !nil(b,current)? {
  let key=b.word(key_ref)?;let mut seen=BTreeSet::new();
  loop {visit(&mut seen,current)?;
   if word(b,current,16)? < key {current=word(b,current,8)?;}else{hint=current;current=word(b,current,0)?;}
   if nil(b,current)? {break;}
  }
 }
 if hint!=head {let key=b.word(key_ref)?;if key>=word(b,hint,16)? {return add(hint,20);}}
 let node=allocate_node(b,kind,tree,key_ref)?;add(insert_hint(b,kind,tree,node,hint)?,20)
}
///5C6C10/5C6D00 traverse right,current,left. Native caches the free callback
///per node and reloads it only after a custom string free.
fn clear_nodes(b:&mut impl Boundary,kind:Kind,mut node:u32,seen:&mut BTreeSet<u32>)->Result<(),Error> {
 while !nil(b,node)? {
  visit(seen,node)?;let right=word(b,node,8)?;clear_nodes(b,kind,right,seen)?;
  let first=kind.strings()[0];let first_long=word(b,node,first+20)? >= 16;
  let left=word(b,node,0)?;let mut route=b.deallocator()?;
  for (i,&offset) in kind.strings().iter().enumerate() {
   let long=if i==0 {first_long}else{word(b,node,offset+20)? >= 16};
   if long {let raw=word(b,node,offset)?;b.free(raw,route)?;if matches!(route,Deallocator::Custom{..}) {route=b.deallocator()?;}}
   reset_string(b,add(node,offset)?)?;
  }
  b.free(node,route)?;node=left;
 }Ok(())
}
///Whole-range5C36B0/5C3770 branch; preserves the allocated sentinel.
pub fn clear(b:&mut impl Boundary,kind:Kind,tree:u32)->Result<(),Error> {
 let head=word(b,tree,0)?;let root=word(b,head,4)?;clear_nodes(b,kind,root,&mut BTreeSet::new())?;
 for offset in [4,0,8] {let head=word(b,tree,0)?;put(b,head,offset,head)?;}
 put(b,tree,4,0)
}
///Tree-only native destructors57D1E0/5B3090, also inlined by owners.
///The caller-owned header retains its now-retired pointer, exactly as native.
pub fn destroy(b:&mut impl Boundary,kind:Kind,tree:u32)->Result<(),Error> {
 clear(b,kind,tree)?;let route=b.deallocator()?;let head=word(b,tree,0)?;b.free(head,route)?;Ok(())
}
#[cfg(test)]
#[path="audio_loading_record_tree_tests.rs"]
mod tests;
'''
(out/'audio_loading_record_tree.rs').write_text(header+body+tail)
