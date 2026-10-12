//! Native replay metadata text setters 7285B0 and 728830.
//! Keys compare signed index first, then unsigned key. The source string is read
//! only after the previous node is erased. 728830 uses strlen; 7285B0 uses length.
use crate::audio_replay_metadata::{Boundary, Error};
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Deallocator;
use std::collections::BTreeSet;
pub const SCRATCH_BYTES: u32 = 64;
fn add(p:u32,n:u32)->Result<u32,Error>{p.checked_add(n).ok_or(Error::AddressOverflow)}
fn w(b:&mut impl Boundary,p:u32,n:u32)->Result<u32,Error>{Ok(b.word(add(p,n)?)?)}
fn put(b:&mut impl Boundary,p:u32,n:u32,v:u32)->Result<(),Error>{Ok(Storage::write_word(b,add(p,n)?,v)?)}
fn byte(b:&mut impl Boundary,p:u32,n:u32,v:u8)->Result<(),Error>{Ok(b.write_byte(add(p,n)?,v)?)}
fn rb(b:&mut impl Boundary,p:u32,n:u32)->Result<u8,Error>{Ok(b.read_byte(add(p,n)?)?)}
fn nil(b:&mut impl Boundary,p:u32)->Result<bool,Error>{Ok(rb(b,p,13)?!=0)}
fn free(b:&mut impl Boundary,p:u32)->Result<(),Error>{let r=b.deallocator()?;Ok(b.free(p,r)?)}
fn empty(b:&mut impl Boundary,p:u32)->Result<(),Error>{put(b,p,20,15)?;put(b,p,16,0)?;byte(b,p,0,0)}
fn destroy_string(b:&mut impl Boundary,p:u32)->Result<(),Error>{if w(b,p,20)?>=16{let raw=w(b,p,0)?;free(b,raw)?;}empty(b,p)}
fn chars(b:&mut impl Boundary,p:u32)->Result<u32,Error>{if w(b,p,20)?>=16{w(b,p,0)}else{Ok(p)}}
// Fresh 564AF0/564C20/564F30 destination; growth starts at capacity15.
fn grow_fresh(b:&mut impl Boundary,dest:u32,len:u32)->Result<(),Error>{
 if len==u32::MAX{return Err(Error::Boundary("native string length exception is not ported"));}
 if len>15{let rounded=len|15;let capacity=if rounded>u32::MAX-1{len}else{rounded};let size=capacity+1;let raw=b.allocate(size)?;if raw==0{return Err(Error::AllocationFailed(size));}byte(b,dest,0,0)?;put(b,dest,0,raw)?;put(b,dest,20,capacity)?;put(b,dest,16,0)?;byte(b,raw,0,0)?;}
 Ok(())
}
fn write_copy(b:&mut impl Boundary,dest:u32,source:u32,len:u32)->Result<(),Error>{let to=chars(b,dest)?;for i in 0..len{let v=rb(b,source,i)?;byte(b,to,i,v)?;}put(b,dest,16,len)?;let to=chars(b,dest)?;byte(b,to,len,0)}
fn copy_bytes(b:&mut impl Boundary,dest:u32,source:u32,len:u32)->Result<(),Error>{grow_fresh(b,dest,len)?;write_copy(b,dest,source,len)}
fn copy_string(b:&mut impl Boundary,dest:u32,source:u32)->Result<(),Error>{let len=w(b,source,16)?;grow_fresh(b,dest,len)?;let raw=if len==0{source}else{chars(b,source)?};write_copy(b,dest,raw,len)}
//5FE7F0 is a move constructor: inline bytes copy with terminator, long buffers
//transfer without another allocation, then the source becomes an empty SSO.
fn move_string(b:&mut impl Boundary,dest:u32,source:u32)->Result<(),Error>{
 empty(b,dest)?;if w(b,source,20)?<16{let count=w(b,source,16)?.wrapping_add(1);for i in 0..count{let v=rb(b,source,i)?;byte(b,dest,i,v)?;}}else{let raw=w(b,source,0)?;put(b,dest,0,raw)?;put(b,source,0,0)?;}
 let length=w(b,source,16)?;put(b,dest,16,length)?;let capacity=w(b,source,20)?;put(b,dest,20,capacity)?;empty(b,source)
}
fn key(b:&mut impl Boundary,p:u32)->Result<(i32,u32),Error>{Ok((w(b,p,20)? as i32,w(b,p,16)?))}
fn find(b:&mut impl Boundary,tree:u32,k:(i32,u32))->Result<u32,Error>{let head=w(b,tree,0)?;let mut n=w(b,head,4)?;let mut result=head;let mut seen=BTreeSet::new();while !nil(b,n)?{if !seen.insert(n){return Err(Error::InvalidTree);}if key(b,n)?>=k{result=n;n=w(b,n,0)?;}else{n=w(b,n,8)?;}}if result!=head&&k<key(b,result)?{Ok(head)}else{Ok(result)}}
fn extreme(b:&mut impl Boundary,mut n:u32,offset:u32)->Result<u32,Error>{let mut seen=BTreeSet::new();loop{if !seen.insert(n){return Err(Error::InvalidTree);}let next=w(b,n,offset)?;if nil(b,next)?{return Ok(n);}n=next;}}
fn rotate(b:&mut impl Boundary,tree:u32,node:u32,left:bool)->Result<(),Error>{
 let side=if left{8}else{0};let opposite=8-side;let pivot=w(b,node,side)?;let child=w(b,pivot,opposite)?;put(b,node,side,child)?;if !nil(b,child)?{put(b,child,4,node)?;}
 let parent=w(b,node,4)?;put(b,pivot,4,parent)?;let head=w(b,tree,0)?;if w(b,head,4)?==node{put(b,head,4,pivot)?;}else if w(b,parent,opposite)?==node{put(b,parent,opposite,pivot)?;}else{put(b,parent,side,pivot)?;}put(b,pivot,opposite,node)?;put(b,node,4,pivot)
}
// Shared native node disposal in5C4680: cache route before string free, reload
// after a custom callback, and only decrement map count after node release.
fn dispose_node(b:&mut impl Boundary,node:u32)->Result<(),Error>{let mut route=b.deallocator()?;if w(b,node,44)?>=16{let raw=w(b,node,24)?;b.free(raw,route)?;if matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}}empty(b,add(node,24)?)?;Ok(b.free(node,route)?)}
fn erase(b:&mut impl Boundary,tree:u32,z:u32)->Result<(),Error>{
 let left=w(b,z,0)?;let right=w(b,z,8)?;let x;let mut parent;
 if nil(b,left)?||nil(b,right)?{
  x=if nil(b,left)?{right}else{left};parent=w(b,z,4)?;if !nil(b,x)?{put(b,x,4,parent)?;}
  let head=w(b,tree,0)?;if w(b,head,4)?==z{put(b,head,4,x)?;}else if w(b,parent,0)?==z{put(b,parent,0,x)?;}else{put(b,parent,8,x)?;}
  let head=w(b,tree,0)?;if w(b,head,0)?==z{let n=if nil(b,x)?{parent}else{extreme(b,x,0)?};put(b,head,0,n)?;}
  let head=w(b,tree,0)?;if w(b,head,8)?==z{let n=if nil(b,x)?{parent}else{extreme(b,x,8)?};put(b,head,8,n)?;}
 }else{
  let y=extreme(b,right,0)?;x=w(b,y,8)?;put(b,left,4,y)?;put(b,y,0,left)?;
  if y==right{parent=y;}else{parent=w(b,y,4)?;if !nil(b,x)?{put(b,x,4,parent)?;}put(b,parent,0,x)?;put(b,y,8,right)?;put(b,right,4,y)?;}
  let head=w(b,tree,0)?;let zp=w(b,z,4)?;if w(b,head,4)?==z{put(b,head,4,y)?;}else if w(b,zp,0)?==z{put(b,zp,0,y)?;}else{put(b,zp,8,y)?;}put(b,y,4,zp)?;let zc=rb(b,z,12)?;let yc=rb(b,y,12)?;byte(b,y,12,zc)?;byte(b,z,12,yc)?;
 }
 if rb(b,z,12)?==1{
  let mut current=x;let mut seen=BTreeSet::new();loop{let head=w(b,tree,0)?;if current==w(b,head,4)?||rb(b,current,12)?!=1{break;}if !seen.insert((current,parent)){return Err(Error::InvalidTree);}
   let is_left=current==w(b,parent,0)?;let side=if is_left{8}else{0};let near=8-side;let mut sibling=w(b,parent,side)?;
   if rb(b,sibling,12)?==0{byte(b,sibling,12,1)?;byte(b,parent,12,0)?;rotate(b,tree,parent,is_left)?;sibling=w(b,parent,side)?;}
   if !nil(b,sibling)?{let a=w(b,sibling,near)?;let c=w(b,sibling,side)?;if rb(b,a,12)?==1&&rb(b,c,12)?==1{byte(b,sibling,12,0)?;}else{
    if rb(b,c,12)?==1{byte(b,a,12,1)?;byte(b,sibling,12,0)?;rotate(b,tree,sibling,!is_left)?;sibling=w(b,parent,side)?;}
    let color=rb(b,parent,12)?;byte(b,sibling,12,color)?;byte(b,parent,12,1)?;let c=w(b,sibling,side)?;byte(b,c,12,1)?;rotate(b,tree,parent,is_left)?;break;
   }}current=parent;parent=w(b,parent,4)?;
  }byte(b,current,12,1)?;
 }
 dispose_node(b,z)?;let count=w(b,tree,4)?;if count!=0{put(b,tree,4,count-1)?;}Ok(())
}
fn insert(b:&mut impl Boundary,tree:u32,node:u32,bytes:u32)->Result<(),Error>{
 let head=w(b,tree,0)?;let mut parent=head;let mut n=w(b,head,4)?;let k=key(b,node)?;let mut left=true;let mut seen=BTreeSet::new();while !nil(b,n)?{if !seen.insert(n){return Err(Error::InvalidTree);}parent=n;let other=key(b,n)?;if k==other{destroy_string(b,add(node,24)?)?;free(b,node)?;return Ok(());}left=k<other;n=w(b,n,if left{0}else{8})?;}
 let count=w(b,tree,4)?;let max=if bytes==56{0x04924923}else{0x05555554};if count>=max{destroy_string(b,add(node,24)?)?;free(b,node)?;return Err(Error::Boundary("native tree length exception is not ported"));}
 put(b,tree,4,count+1)?;put(b,node,4,parent)?;
 let head=w(b,tree,0)?;if parent==head{put(b,head,4,node)?;let head=w(b,tree,0)?;put(b,head,0,node)?;let head=w(b,tree,0)?;put(b,head,8,node)?;}else{let side=if left{0}else{8};put(b,parent,side,node)?;let head=w(b,tree,0)?;if w(b,head,side)?==parent{put(b,head,side,node)?;}}
 let mut current=node;loop{let parent=w(b,current,4)?;if rb(b,parent,12)?!=0{break;}let grand=w(b,parent,4)?;let is_left=parent==w(b,grand,0)?;let uncle=w(b,grand,if is_left{8}else{0})?;if rb(b,uncle,12)?==0{byte(b,parent,12,1)?;byte(b,uncle,12,1)?;byte(b,grand,12,0)?;current=grand;}else{if current==w(b,parent,if is_left{8}else{0})?{current=parent;rotate(b,tree,current,is_left)?;}let parent=w(b,current,4)?;byte(b,parent,12,1)?;let grand=w(b,parent,4)?;byte(b,grand,12,0)?;rotate(b,tree,grand,!is_left)?;}}
 let head=w(b,tree,0)?;let root=w(b,head,4)?;byte(b,root,12,1)
}
fn combine(result:Result<(),Error>,cleanup:Result<(),Error>)->Result<(),Error>{match(result,cleanup){(Ok(()),c)=>c,(Err(e),Ok(()))=>Err(e),(Err(e),Err(c))=>Err(Error::Cleanup{primary:Box::new(e),cleanup:Box::new(c)})}}
fn setter(b:&mut impl Boundary,p:u32,k:u32,index:u32,source:u32,extra:Option<u32>,scratch:u32)->Result<(),Error>{
 let lock=add(p,0x1c8)?;let tree=add(p,if extra.is_some(){8}else{16})?;let pair=add(scratch,28)?;let pair_string=add(pair,8)?;add(scratch,SCRATCH_BYTES-1)?;
 b.enter_lock(lock).map_err(Error::Boundary)?;
 let mut first_live=false;let mut pair_live=false;
 let result=(||{
  let found=find(b,tree,(index as i32,k))?;if found!=w(b,tree,0)?{erase(b,tree,found)?;}
  empty(b,scratch)?;first_live=true;
  if let Some(value)=extra{copy_string(b,scratch,source)?;put(b,scratch,24,value)?;}else{let raw=chars(b,source)?;let mut length=0;while rb(b,raw,length)?!=0{length=length.checked_add(1).ok_or(Error::AddressOverflow)?;}copy_bytes(b,scratch,raw,length)?;}
  put(b,pair,0,k)?;put(b,pair,4,index)?;empty(b,pair_string)?;pair_live=true;if extra.is_some(){copy_string(b,pair_string,scratch)?;}else{move_string(b,pair_string,scratch)?;}if let Some(value)=extra{put(b,pair,32,value)?;}
  let bytes=if extra.is_some(){56}else{48};let node=b.allocate(bytes)?;if node==0{return Err(Error::AllocationFailed(bytes));}
  for offset in [0,4,8]{let head=w(b,tree,0)?;put(b,node,offset,head)?;}byte(b,node,12,0)?;byte(b,node,13,0)?;put(b,node,16,k)?;put(b,node,20,index)?;let string=add(node,24)?;empty(b,string)?;
  let copied=if extra.is_some(){copy_string(b,string,pair_string)}else{move_string(b,string,pair_string)};
  if let Err(error)=copied{let cleanup=destroy_string(b,string);let cleanup=combine(cleanup,free(b,node));return combine(Err(error),cleanup);}
  if let Some(value)=extra{put(b,node,48,value)?;}
  insert(b,tree,node,bytes)
 })();
 let result=if pair_live{combine(result,destroy_string(b,pair_string))}else{result};
 let result=if first_live{combine(result,destroy_string(b,scratch))}else{result};
 combine(result,b.leave_lock(lock).map_err(Error::Boundary))
}
///7285B0. Source is a readable native24-byte string; index retains its signed
///bit representation. Caller supplies64 writable bytes disjoint from live data.
///Scratch is not part of the metadata and may retain unspecified temporary bytes.
pub fn put_string_extra(b:&mut impl Boundary,p:u32,key:u32,index:u32,source:u32,extra:u32,scratch:u32)->Result<(),Error>{setter(b,p,key,index,source,Some(extra),scratch)}
///728830. The native source descriptor selects inline/heap storage; strlen then
///ignores its stored length and stops at the first NUL, as the original does.
pub fn put_string(b:&mut impl Boundary,p:u32,key:u32,index:u32,source:u32,scratch:u32)->Result<(),Error>{setter(b,p,key,index,source,None,scratch)}

#[cfg(test)]
#[path="audio_replay_metadata_text_tests.rs"]
mod tests;
