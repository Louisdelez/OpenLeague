//! Native replay dual-index manager8F8810/8F88A0/8F89D0/8F8B30/8F8CF0.
//! Original red-black nodes and owned shared pairs; no host pointer casts.
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free};
use crate::audio_replay_shared_pair::{self as pair,Boundary as References};
use std::collections::BTreeSet;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Read(read::Error),Write(init::Error),Free(removal::Error),Pair(pair::Error),Boundary(&'static str),InvalidTree,AddressOverflow,AllocationFailed,CapacityExceeded}
impl From<read::Error> for Error{fn from(e:read::Error)->Self{Self::Read(e)}}
impl From<init::Error> for Error{fn from(e:init::Error)->Self{Self::Write(e)}}
impl From<removal::Error> for Error{fn from(e:removal::Error)->Self{Self::Free(e)}}
impl From<pair::Error> for Error{fn from(e:pair::Error)->Self{Self::Pair(e)}}
pub trait Boundary: Storage+Free+References {
 fn read_byte(&mut self,address:u32)->Result<u8,read::Error>;
 fn initialize_lock(&mut self,manager:u32)->Result<(),&'static str>;
 fn enter_lock(&mut self,manager:u32)->Result<(),&'static str>;
 fn leave_lock(&mut self,manager:u32)->Result<(),&'static str>;
 fn destroy_lock(&mut self,manager:u32)->Result<(),&'static str>;
 fn object_id(&mut self,object:u32,callback:u32)->Result<u32,&'static str>;
 fn object_value(&mut self,object:u32,callback:u32)->Result<u64,&'static str>;
}
fn add(a:u32,b:u32)->Result<u32,Error>{a.checked_add(b).ok_or(Error::AddressOverflow)}
fn w(b:&mut impl Boundary,p:u32,o:u32)->Result<u32,Error>{Ok(b.word(add(p,o)?)?)}
fn put(b:&mut impl Boundary,p:u32,o:u32,v:u32)->Result<(),Error>{Storage::write_word(b,add(p,o)?,v)?;Ok(())}
fn byte(b:&mut impl Boundary,p:u32,o:u32)->Result<u8,Error>{Ok(b.read_byte(add(p,o)?)?)}
fn color(b:&mut impl Boundary,p:u32,c:u8)->Result<(),Error>{b.write_byte(add(p,12)?,c)?;Ok(())}
fn nil(b:&mut impl Boundary,p:u32)->Result<bool,Error>{Ok(byte(b,p,13)?!=0)}
fn free(b:&mut impl Boundary,p:u32)->Result<(),Error>{let route=b.deallocator()?;b.free(p,route)?;Ok(())}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
enum Kind{Id,Value}
impl Kind{fn size(self)->u32{if self==Self::Id{28}else{32}} fn limit(self)->u32{if self==Self::Id{0x9249248}else{0x7fffffe}}}
fn key(b:&mut impl Boundary,node:u32,kind:Kind)->Result<i128,Error>{let low=w(b,node,16)?;Ok(if kind==Kind::Id{low as i128}else{((w(b,node,20)? as i32 as i64)<<32 | low as i64) as i128})}
fn head(b:&mut impl Boundary,tree:u32)->Result<u32,Error>{w(b,tree,0)}
fn extreme(b:&mut impl Boundary,mut node:u32,right:bool)->Result<u32,Error>{
 let mut seen=BTreeSet::new();loop{if !seen.insert(node){return Err(Error::InvalidTree);}let next=w(b,node,if right{8}else{0})?;if nil(b,next)?{return Ok(node);}node=next;}
}
fn find(b:&mut impl Boundary,tree:u32,value:i128,kind:Kind)->Result<Option<u32>,Error>{
 let sentinel=head(b,tree)?;let mut node=w(b,sentinel,4)?;let mut found=sentinel;let mut seen=BTreeSet::new();
 while !nil(b,node)?{if !seen.insert(node){return Err(Error::InvalidTree);}if key(b,node,kind)?>=value{found=node;node=w(b,node,0)?;}else{node=w(b,node,8)?;}}
 Ok(if found!=sentinel && key(b,found,kind)?==value{Some(found)}else{None})
}
fn rotate(b:&mut impl Boundary,tree:u32,node:u32,left:bool)->Result<(),Error>{
 let side=if left{8}else{0};let opposite=8-side;let pivot=w(b,node,side)?;let child=w(b,pivot,opposite)?;
 put(b,node,side,child)?;if !nil(b,child)?{put(b,child,4,node)?;}
 let parent=w(b,node,4)?;put(b,pivot,4,parent)?;let sentinel=head(b,tree)?;
 if w(b,sentinel,4)?==node{put(b,sentinel,4,pivot)?;}else if w(b,parent,opposite)?==node{put(b,parent,opposite,pivot)?;}else{put(b,parent,side,pivot)?;}
 put(b,pivot,opposite,node)?;put(b,node,4,pivot)
}
fn create_node(b:&mut impl Boundary,tree:u32,kind:Kind)->Result<u32,Error>{
 let node=b.allocate(kind.size())?;if node==0{return Err(Error::AllocationFailed);}
 for offset in [0,4,8]{let sentinel=head(b,tree)?;put(b,node,offset,sentinel)?;}
 b.write_byte(add(node,12)?,0)?;b.write_byte(add(node,13)?,0)?;Ok(node)
}
fn dispose_node(b:&mut impl Boundary,node:u32,kind:Kind)->Result<(),Error>{if kind==Kind::Id{pair::destroy(b,add(node,20)?)?;}free(b,node)}
fn insert_node(b:&mut impl Boundary,tree:u32,node:u32,kind:Kind)->Result<bool,Error>{
 let sentinel=head(b,tree)?;let value=key(b,node,kind)?;let mut parent=sentinel;let mut current=w(b,sentinel,4)?;let mut left=true;let mut seen=BTreeSet::new();
 while !nil(b,current)?{
  if !seen.insert(current){return Err(Error::InvalidTree);}parent=current;let existing=key(b,current,kind)?;
  if existing==value{dispose_node(b,node,kind)?;return Ok(false);}
  left=value<existing;current=w(b,current,if left{0}else{8})?;
 }
 let count=w(b,tree,4)?;if count>=kind.limit(){dispose_node(b,node,kind)?;return Err(Error::CapacityExceeded);}
 put(b,tree,4,count+1)?;put(b,node,4,parent)?;
 if parent==sentinel{put(b,sentinel,4,node)?;put(b,sentinel,0,node)?;put(b,sentinel,8,node)?;}
 else{let side=if left{0}else{8};put(b,parent,side,node)?;if w(b,sentinel,side)?==parent{put(b,sentinel,side,node)?;}}
 let mut current=node;
 loop{
  let p=w(b,current,4)?;if byte(b,p,12)?!=0{break;}let g=w(b,p,4)?;let is_left=p==w(b,g,0)?;let uncle=w(b,g,if is_left{8}else{0})?;
  if byte(b,uncle,12)?==0{color(b,p,1)?;color(b,uncle,1)?;color(b,g,0)?;current=g;}
  else{
   if current==w(b,p,if is_left{8}else{0})?{current=p;rotate(b,tree,current,is_left)?;}
   let p=w(b,current,4)?;color(b,p,1)?;let g=w(b,p,4)?;color(b,g,0)?;rotate(b,tree,g,!is_left)?;
  }
 }
 let root=w(b,sentinel,4)?;color(b,root,1)?;Ok(true)
}
fn erase_node(b:&mut impl Boundary,tree:u32,node:u32,kind:Kind)->Result<(),Error>{
 let sentinel=head(b,tree)?;let left=w(b,node,0)?;let right=w(b,node,8)?;let mut fix;let mut parent;
 if nil(b,left)? || nil(b,right)?{
  fix=if nil(b,left)?{right}else{left};parent=w(b,node,4)?;
  if !nil(b,fix)?{put(b,fix,4,parent)?;}
  if w(b,sentinel,4)?==node{put(b,sentinel,4,fix)?;}else if w(b,parent,0)?==node{put(b,parent,0,fix)?;}else{put(b,parent,8,fix)?;}
  if w(b,sentinel,0)?==node{let value=if nil(b,fix)?{parent}else{extreme(b,fix,false)?};put(b,sentinel,0,value)?;}
  if w(b,sentinel,8)?==node{let value=if nil(b,fix)?{parent}else{extreme(b,fix,true)?};put(b,sentinel,8,value)?;}
 }else{
  let successor=extreme(b,right,false)?;fix=w(b,successor,8)?;
  put(b,left,4,successor)?;put(b,successor,0,left)?;
  if successor==right{parent=successor;}else{
   parent=w(b,successor,4)?;if !nil(b,fix)?{put(b,fix,4,parent)?;}put(b,parent,0,fix)?;put(b,successor,8,right)?;put(b,right,4,successor)?;
  }
  let old_parent=w(b,node,4)?;
  if w(b,sentinel,4)?==node{put(b,sentinel,4,successor)?;}else if w(b,old_parent,0)?==node{put(b,old_parent,0,successor)?;}else{put(b,old_parent,8,successor)?;}
  put(b,successor,4,old_parent)?;let old_color=byte(b,node,12)?;let new_color=byte(b,successor,12)?;color(b,successor,old_color)?;color(b,node,new_color)?;
 }
 if byte(b,node,12)?==1{
  while fix!=w(b,sentinel,4)? && byte(b,fix,12)?==1{
   let left=fix==w(b,parent,0)?;let far=if left{8}else{0};let near=8-far;let mut sibling=w(b,parent,far)?;
   if byte(b,sibling,12)?==0{color(b,sibling,1)?;color(b,parent,0)?;rotate(b,tree,parent,left)?;sibling=w(b,parent,far)?;}
   if !nil(b,sibling)?{
    let a=w(b,sibling,near)?;let z=w(b,sibling,far)?;
    if byte(b,a,12)?==1 && byte(b,z,12)?==1{color(b,sibling,0)?;}
    else{
     if byte(b,z,12)?==1{color(b,a,1)?;color(b,sibling,0)?;rotate(b,tree,sibling,!left)?;sibling=w(b,parent,far)?;}
     let parent_color=byte(b,parent,12)?;color(b,sibling,parent_color)?;color(b,parent,1)?;let z=w(b,sibling,far)?;color(b,z,1)?;rotate(b,tree,parent,left)?;break;
    }
   }
   fix=parent;parent=w(b,parent,4)?;
  }
  color(b,fix,1)?;
 }
 dispose_node(b,node,kind)?;let count=w(b,tree,4)?;if count!=0{put(b,tree,4,count-1)?;}Ok(())
}
fn clear_nodes(b:&mut impl Boundary,mut node:u32,kind:Kind)->Result<(),Error>{
 // Native5C1370/5C72F0 visits right subtree, current node, then left subtree.
 while !nil(b,node)?{let right=w(b,node,8)?;clear_nodes(b,right,kind)?;let left=w(b,node,0)?;dispose_node(b,node,kind)?;node=left;}Ok(())
}
fn object_id(b:&mut impl Boundary,object:u32)->Result<u32,Error>{let vt=w(b,object,0)?;let callback=w(b,vt,4)?;b.object_id(object,callback).map_err(Error::Boundary)}
fn object_value(b:&mut impl Boundary,object:u32)->Result<u64,Error>{let vt=w(b,object,0)?;let callback=w(b,vt,8)?;b.object_value(object,callback).map_err(Error::Boundary)}
fn unlock<T>(b:&mut impl Boundary,manager:u32,result:Result<T,Error>)->Result<T,Error>{let unlock=b.leave_lock(manager).map_err(Error::Boundary);match result{Err(e)=>Err(e),Ok(v)=>{unlock?;Ok(v)}}}
pub fn construct(b:&mut impl Boundary,manager:u32)->Result<(),Error>{
 b.write_byte(manager,0)?;put(b,manager,4,0)?;b.initialize_lock(manager).map_err(Error::Boundary)?;
 for (offset,kind) in [(0x20,Kind::Value),(0x28,Kind::Id)]{
  put(b,manager,offset,0)?;put(b,manager,offset+4,0)?;let node=b.allocate(kind.size())?;if node==0{return Err(Error::AllocationFailed);}
  for off in [0,4,8]{put(b,node,off,node)?;}b.write_byte(add(node,12)?,1)?;b.write_byte(add(node,13)?,1)?;put(b,manager,offset,node)?;
 }Ok(())
}
/// By-value incoming pair is consumed even when its ID or reverse value exists.
/// scratch is exclusive, disjoint caller-owned frame storage of at least8 bytes.
pub fn insert(b:&mut impl Boundary,manager:u32,incoming:u32,scratch:u32)->Result<bool,Error>{
 b.enter_lock(manager).map_err(Error::Boundary)?;
 put(b,scratch,0,0)?;put(b,scratch,4,0)?;
 let result=(||{
  let object=w(b,incoming,0)?;let id=object_id(b,object)?;
  put(b,scratch,0,0)?;put(b,scratch,4,0)?;pair::copy(b,scratch,incoming)?;
  let tree=add(manager,0x28)?;let node=create_node(b,tree,Kind::Id)?;put(b,node,16,id)?;
  let copied_object=w(b,scratch,0)?;let copied_control=w(b,scratch,4)?;put(b,node,20,copied_object)?;put(b,node,24,copied_control)?;put(b,scratch,0,0)?;put(b,scratch,4,0)?;
  let inserted=insert_node(b,tree,node,Kind::Id)?;pair::destroy(b,scratch)?;
  if !inserted{return Ok(false);}
  let object=w(b,incoming,0)?;let value=object_value(b,object)?;let object=w(b,incoming,0)?;let id=object_id(b,object)?;
  let tree=add(manager,0x20)?;let node=create_node(b,tree,Kind::Value)?;put(b,node,16,value as u32)?;put(b,node,20,(value>>32) as u32)?;put(b,node,24,id)?;
  insert_node(b,tree,node,Kind::Value)
 })();
 // The copied temporary must also be released if allocation/dispatch fails.
 let temporary=pair::destroy(b,scratch).map_err(Error::Pair);
 let result=match result{Err(e)=>Err(e),Ok(value)=>temporary.map(|_|value)};
 let result=unlock(b,manager,result);let released=pair::destroy(b,incoming).map_err(Error::Pair);
 match result{Err(e)=>Err(e),Ok(value)=>{released?;Ok(value)}}
}
fn retained_value(b:&mut impl Boundary,node:u32,scratch:u32)->Result<u64,Error>{
 put(b,scratch,0,0)?;put(b,scratch,4,0)?;pair::copy(b,scratch,add(node,20)?)?;
 let object=w(b,scratch,0)?;let result=object_value(b,object);let released=pair::destroy(b,scratch).map_err(Error::Pair);
 match result{Err(e)=>Err(e),Ok(value)=>{released?;Ok(value)}}
}
pub fn lookup(b:&mut impl Boundary,manager:u32,id:u32,scratch:u32)->Result<u64,Error>{
 b.enter_lock(manager).map_err(Error::Boundary)?;
 let result=(||{let tree=add(manager,0x28)?;match find(b,tree,id as i128,Kind::Id)?{Some(node)=>retained_value(b,node,scratch),None=>Ok(0)}})();unlock(b,manager,result)
}
pub fn remove(b:&mut impl Boundary,manager:u32,id:u32,scratch:u32)->Result<bool,Error>{
 b.enter_lock(manager).map_err(Error::Boundary)?;
 let result=(||{let tree=add(manager,0x28)?;let Some(node)=find(b,tree,id as i128,Kind::Id)? else{return Ok(false)};
  let value=retained_value(b,node,scratch)?;let reverse=add(manager,0x20)?;
  if let Some(node)=find(b,reverse,value as i64 as i128,Kind::Value)?{erase_node(b,reverse,node,Kind::Value)?;}
  erase_node(b,tree,node,Kind::Id)?;Ok(true)
 })();unlock(b,manager,result)
}
pub fn destroy(b:&mut impl Boundary,manager:u32)->Result<(),Error>{
 b.enter_lock(manager).map_err(Error::Boundary)?;
 let result=(||{for (offset,kind) in [(0x20,Kind::Value),(0x28,Kind::Id)]{let tree=add(manager,offset)?;let sentinel=head(b,tree)?;let root=w(b,sentinel,4)?;clear_nodes(b,root,kind)?;for off in [4,0,8]{put(b,sentinel,off,sentinel)?;}put(b,tree,4,0)?;}Ok(())})();unlock(b,manager,result)?;
 for offset in [0x28,0x20]{let sentinel=w(b,manager,offset)?;free(b,sentinel)?;}
 b.destroy_lock(manager).map_err(Error::Boundary)
}

#[cfg(test)]
#[path="audio_replay_object_manager_tests.rs"]mod tests;
