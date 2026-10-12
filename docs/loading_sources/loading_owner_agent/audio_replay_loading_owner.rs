//! Native loading-wrapper ownership. No screen factory or UI recipient is fabricated.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend,Deallocator};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_owner_control as control;
use crate::audio_replay_shared_pair as pair;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Read(lookup::Error),Write(init::Error),Free(remove::Error),Control(control::Error),Pair(pair::Error),Boundary(&'static str),AddressOverflow,AllocationFailed(u32),UnknownCallback(u32)}
impl From<lookup::Error> for Error{fn from(v:lookup::Error)->Self{Self::Read(v)}}
impl From<init::Error> for Error{fn from(v:init::Error)->Self{Self::Write(v)}}
impl From<remove::Error> for Error{fn from(v:remove::Error)->Self{Self::Free(v)}}
impl From<control::Error> for Error{fn from(v:control::Error)->Self{Self::Control(v)}}
impl From<pair::Error> for Error{fn from(v:pair::Error)->Self{Self::Pair(v)}}
pub const GLOBAL_PAIR:u32=0x14c761c;
pub const WRAPPER_BYTES:u32=128;
pub const WRAPPER_CONTROL:u32=0x1085e5c;
pub const RECIPIENT_CONTROL:u32=0x1085e6c;
pub const WRAPPER_DISPOSE:u32=0x5ddb80;
pub const RECIPIENT_DISPOSE:u32=0x5ddb70;
pub const LANGUAGE_GLOBAL:u32=0x2d78d08;
pub const ACTIVE_GLOBAL:u32=0x2d77e44;
pub const C_LOCALE_FLAG:u32=0x14ae870;
pub const ZH_CN:u32=0x1088ab0;
pub trait Boundary:Storage+RemovalBackend+ControlBoundary {
 fn read_byte(&mut self,address:u32)->Result<u8,lookup::Error>;
 fn initialize_lock(&mut self,address:u32)->Result<(),&'static str>;
 fn destroy_lock(&mut self,address:u32)->Result<(),&'static str>;
 /// Actual recipient virtual+0C or scalar-delete virtual+10. Unconnected UI must error.
 fn recipient_virtual(&mut self,object:u32,target:u32,slot:u32,flags:Option<u32>)->Result<(),&'static str>;
 /// Runtime adapters read the flag from their canonical CRT bank, not a copied global.
 fn locale_is_default(&mut self)->Result<bool,&'static str>{self.word(C_LOCALE_FLAG).map(|v|v==0).map_err(|_|"CRT locale flag unavailable")}
 /// Non-C locale branch of CRT C9CF31. Default is an explicit missing boundary.
 fn compare_locale_nocase(&mut self,_first:u32,_second:u32)->Result<i32,&'static str>{Err("locale-aware loading language comparison is not connected")}
}
fn add(p:u32,n:u32)->Result<u32,Error>{p.checked_add(n).ok_or(Error::AddressOverflow)}
fn word(b:&mut impl Boundary,p:u32,n:u32)->Result<u32,Error>{Ok(b.word(add(p,n)?)?)}
fn put(b:&mut impl Boundary,p:u32,n:u32,v:u32)->Result<(),Error>{Ok(Storage::write_word(b,add(p,n)?,v)?)}
fn rb(b:&mut impl Boundary,p:u32,n:u32)->Result<u8,Error>{Ok(b.read_byte(add(p,n)?)?)}
fn byte(b:&mut impl Boundary,p:u32,n:u32,v:u8)->Result<(),Error>{Ok(b.write_byte(add(p,n)?,v)?)}
fn free(b:&mut impl Boundary,p:u32)->Result<(),Error>{let r=b.deallocator()?;Ok(b.free(p,r)?)}
fn empty_string(b:&mut impl Boundary,p:u32)->Result<(),Error>{put(b,p,20,15)?;put(b,p,16,0)?;byte(b,p,0,0)}
fn string_chars(b:&mut impl Boundary,p:u32)->Result<u32,Error>{if word(b,p,20)?>=16{word(b,p,0)}else{Ok(p)}}
fn destroy_string(b:&mut impl Boundary,p:u32)->Result<(),Error>{if word(b,p,20)?>=16{let raw=word(b,p,0)?;free(b,raw)?;}empty_string(b,p)}
/// Fresh24-byte destination only: the exact564C20/564F30 no-alias branch.
fn copy_fresh(b:&mut impl Boundary,p:u32,src:u32,len:u32)->Result<(),Error>{
 if len==u32::MAX{return Err(Error::Boundary("native string length exception is not ported"));}
 if len>15{let rounded=len|15;let cap=if rounded>u32::MAX-1{len}else{rounded};let raw=b.allocate(cap+1)?;if raw==0{return Err(Error::AllocationFailed(cap+1));}byte(b,p,0,0)?;put(b,p,0,raw)?;put(b,p,20,cap)?;put(b,p,16,0)?;byte(b,raw,0,0)?;}
 let dst=string_chars(b,p)?;for i in 0..len{let value=rb(b,src,i)?;byte(b,dst,i,value)?;}put(b,p,16,len)?;let dst=string_chars(b,p)?;byte(b,dst,len,0)
}
fn compare_nocase(b:&mut impl Boundary,first:u32,second:u32)->Result<i32,Error>{
 if !b.locale_is_default().map_err(Error::Boundary)?{return b.compare_locale_nocase(first,second).map_err(Error::Boundary);}
 // Native C9CEF8 folds ASCII A-Z only; bytes >=128 are unsigned and unchanged.
 let mut i=0;loop{let a=rb(b,first,i)?;let c=rb(b,second,i)?;let a=if a.is_ascii_uppercase(){a+32}else{a};let c=if c.is_ascii_uppercase(){c+32}else{c};if a==0||a!=c{return Ok(a as i32-c as i32);}i=i.checked_add(1).ok_or(Error::AddressOverflow)?;}
}
fn sentinel(b:&mut impl Boundary)->Result<u32,Error>{let h=b.allocate(44)?;if h==0{return Err(Error::AllocationFailed(44));}for o in [0,4,8]{put(b,h,o,h)?;}byte(b,h,12,1)?;byte(b,h,13,1)?;Ok(h)}
/// Source576280; scratch is disjoint writable24-byte native temporary-string storage.
/// Opaque bytes in wrapper, sentinels and inline strings are preserved.
pub fn construct(b:&mut impl Boundary,p:u32,scratch:u32)->Result<u32,Error>{
 put(b,p,0,0)?;put(b,p,4,0)?;put(b,p,8,0)?;byte(b,p,12,0)?;
 for o in [0x18,0x1c,0x20,0x24]{put(b,p,o,0)?;}empty_string(b,add(p,0x2c)?)?;byte(b,p,0x44,0)?;
 for o in [0x48,0x50]{put(b,p,o,0)?;put(b,p,o+4,0)?;let h=sentinel(b)?;put(b,p,o,h)?;}
 put(b,p,0x58,0x3f800000)?;byte(b,p,0x5c,0)?;byte(b,p,0x5d,1)?;byte(b,p,0x60,0)?;put(b,p,0x64,0)?;
 b.initialize_lock(add(p,0x68)?).map_err(Error::Boundary)?;
 let language=b.word(LANGUAGE_GLOBAL)?;let chars=string_chars(b,language)?;empty_string(b,scratch)?;
 let mut len=0;while rb(b,chars,len)?!=0{len=len.checked_add(1).ok_or(Error::AddressOverflow)?;}
 copy_fresh(b,scratch,chars,len)?;let text=string_chars(b,scratch)?;let compared=compare_nocase(b,text,ZH_CN);
 if compared.as_ref().is_ok_and(|&v|v==0){byte(b,p,0x5c,1)?;}
 // Native temporary destructor only frees a long buffer; it does not reset stack bytes.
 if word(b,scratch,20)?>=16{let raw=word(b,scratch,0)?;free(b,raw)?;}compared?;Ok(p)
}
/// Native5C1ED0 right subtree first, then current node, then saved left subtree.
fn erase_subtree(b:&mut impl Boundary,mut node:u32)->Result<(),Error>{
 while rb(b,node,13)?==0{
  let right=word(b,node,8)?;erase_subtree(b,right)?;
  let long=word(b,node,0x24)?>=16;let left=word(b,node,0)?;let mut route=b.deallocator()?;
  if long{let raw=word(b,node,0x10)?;b.free(raw,route)?;if matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}}
  put(b,node,0x24,15)?;put(b,node,0x20,0)?;byte(b,node,0x10,0)?;b.free(node,route)?;node=left;
 }Ok(())
}
/// Exact whole-range5C2AB0 branch used by wrapper destruction, then head release.
fn destroy_tree(b:&mut impl Boundary,tree:u32)->Result<(),Error>{
 let head=b.word(tree)?;let root=word(b,head,4)?;erase_subtree(b,root)?;
 for o in [4,0,8]{let h=b.word(tree)?;put(b,h,o,h)?;}let h=b.word(tree)?;put(b,tree,4,0)?;let _returned=b.word(h)?;
 let route=b.deallocator()?;let head=b.word(tree)?;b.free(head,route)?;Ok(())
}
/// Source576410. The recipient pair remains nonzero after release, matching native.
pub fn destroy(b:&mut impl Boundary,p:u32)->Result<(),Error>{
 if rb(b,p,12)?!=0{let recipient=b.word(p)?;byte(b,p,12,0)?;Storage::write_word(b,ACTIVE_GLOBAL,0)?;let table=b.word(recipient)?;let target=word(b,table,12)?;b.recipient_virtual(recipient,target,12,None).map_err(Error::Boundary)?;}
 b.destroy_lock(add(p,0x68)?).map_err(Error::Boundary)?;
 destroy_tree(b,add(p,0x50)?)?;destroy_tree(b,add(p,0x48)?)?;destroy_string(b,add(p,0x2c)?)?;pair::destroy(b,p)?;Ok(())
}
/// Source5DDB80. Destruction callbacks can change the final wrapper free route.
pub fn dispose_wrapper(b:&mut impl Boundary,owner:u32)->Result<(),Error>{let p=word(b,owner,12)?;if p!=0{destroy(b,p)?;free(b,p)?;}Ok(())}
/// Source5DDB70 dispatches recipient virtual+10, never virtual slot0.
pub fn dispose_recipient(b:&mut impl Boundary,owner:u32)->Result<(),Error>{let p=word(b,owner,12)?;if p!=0{let table=b.word(p)?;let target=word(b,table,16)?;b.recipient_virtual(p,target,16,Some(1)).map_err(Error::Boundary)?;}Ok(())}
///5D7750/5D7680 share the existing exact replacement body. Old release precedes publication.
pub fn replace_control<B:Storage+ControlBoundary>(b:&mut B,p:u32,object:u32,recipient:bool)->Result<(),Error>{control::replace_pair_with_vtable(b,p,object,if recipient{RECIPIENT_CONTROL}else{WRAPPER_CONTROL})?;Ok(())}
///5C7E30/5C7D10 construct a fresh pair, publish it, then release the previous control.
///scratch is disjoint8-byte storage. Allocation-null follows source (object,0).
pub fn publish(b:&mut impl Boundary,destination:u32,object:u32,recipient:bool,scratch:u32)->Result<(),Error>{
 put(b,scratch,0,0)?;put(b,scratch,4,0)?;replace_control(b,scratch,object,recipient)?;
 // Global source5C7E30 reads the new control before old; nested5C7D10 reads old first.
 let (new,old)=if recipient{let old=word(b,destination,4)?;(word(b,scratch,4)?,old)}else{let new=word(b,scratch,4)?;(new,word(b,destination,4)?)};
 put(b,destination,4,new)?;let object=word(b,scratch,0)?;put(b,destination,0,object)?;pair::release_control(b,old)?;Ok(())
}
#[cfg(test)]
#[path="audio_replay_loading_owner_tests.rs"]
mod tests;
