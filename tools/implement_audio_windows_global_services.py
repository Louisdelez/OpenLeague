from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''
//! Real Windows export resolution and EncodePointer services for original CRT startup.
//! Canonical u32 values are registry labels, never truncated host pointers. Source
//! code references passed to EncodePointer remain opaque values, not callable host code.
use std::{collections::{BTreeMap,BTreeSet},ffi::{c_void,CString}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
#[link(name="kernel32")]unsafe extern "system"{fn GetModuleHandleW(name:*const u16)->*mut c_void;fn GetProcAddress(module:*mut c_void,name:*const u8)->*mut c_void;fn EncodePointer(pointer:*mut c_void)->*mut c_void;fn DecodePointer(pointer:*mut c_void)->*mut c_void;}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{InvalidName,InvalidReference,UnknownReference(u32),WrongKind,NameMismatch,AddressSpace,CodecMismatch}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Event{Encode{source:u32,result:u32},Module{name:String,result:u32},Procedure{module:u32,name:String,result:u32}}
#[derive(PartialEq,Eq)]enum Reference{Module{name:String,pointer:usize},Procedure{module:u32,name:String,pointer:usize},Encoded{source:u32,pointer:usize}}
pub struct NativeGlobal{next:u32,references:BTreeMap<u32,Reference>,events:Option<Vec<Event>>}
impl NativeGlobal{
 pub fn new(first_reference:u32)->Result<Self,Failure>{if first_reference==0||first_reference&15!=0{return Err(Failure::InvalidReference);}Ok(Self{next:first_reference,references:BTreeMap::new(),events:None})}
 /// Enable forensic tracing explicitly; normal startup keeps no accumulating trace.
 pub fn enable_trace(&mut self){self.events=Some(Vec::new());}
 pub fn events(&self)->&[Event]{self.events.as_deref().unwrap_or(&[])}
 fn event(&mut self,e:Event){if let Some(events)=&mut self.events{events.push(e);}}
 fn register(&mut self,value:Reference)->Result<u32,Failure>{if let Some((&r,_))=self.references.iter().find(|(_,v)|**v==value){return Ok(r);}let r=self.next;self.next=r.checked_add(16).ok_or(Failure::AddressSpace)?;self.references.insert(r,value);Ok(r)}
 pub fn module(&mut self,name:&str)->Result<u32,Failure>{if name.contains('\0'){return Err(Failure::InvalidName);}let wide=name.encode_utf16().chain(Some(0)).collect::<Vec<_>>();let pointer=unsafe{GetModuleHandleW(wide.as_ptr())}as usize;let result=if pointer==0{0}else{self.register(Reference::Module{name:name.into(),pointer})?};self.event(Event::Module{name:name.into(),result});Ok(result)}
 pub fn procedure(&mut self,module:u32,name:&str)->Result<u32,Failure>{let name_c=CString::new(name).map_err(|_|Failure::InvalidName)?;let host=if module==0{0}else{match self.references.get(&module){Some(Reference::Module{pointer,..})=>*pointer,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(module))}};let pointer=unsafe{GetProcAddress(host as*mut c_void,name_c.as_ptr().cast())}as usize;let result=if pointer==0{0}else{self.register(Reference::Procedure{module,name:name.into(),pointer})?};self.event(Event::Procedure{module,name:name.into(),result});Ok(result)}
 /// Full-width address with an explicit export-name/type ownership check.
 /// Calling or converting it to a function pointer requires a qualified ABI caller.
 pub fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Failure>{match self.references.get(&reference){Some(Reference::Procedure{name:actual,pointer,..})if actual==name=>Ok(*pointer),Some(Reference::Procedure{..})=>Err(Failure::NameMismatch),Some(_)=>Err(Failure::WrongKind),None=>Err(Failure::UnknownReference(reference))}}
 pub fn encode(&mut self,source:u32)->Result<u32,Failure>{let pointer=unsafe{EncodePointer(source as usize as*mut c_void)}as usize;let result=self.register(Reference::Encoded{source,pointer})?;self.event(Event::Encode{source,result});Ok(result)}
 pub fn decode(&self,reference:u32)->Result<u32,Failure>{match self.references.get(&reference){Some(Reference::Encoded{source,pointer})=>{let actual=unsafe{DecodePointer(*pointer as*mut c_void)}as usize;if actual!=*source as usize{return Err(Failure::CodecMismatch);}Ok(*source)},Some(_)=>Err(Failure::WrongKind),None=>Err(Failure::UnknownReference(reference))}}
}
impl crate::audio_crt_windows_dispatch_resolver::Services for NativeGlobal{
 fn module_handle(&mut self,name:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.module(name).map_err(|_|Error::Backend("native module registry failure"))}
 fn procedure_address(&mut self,module:u32,name:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.procedure(module,name).map_err(|_|Error::Backend("native export registry failure"))}
}
impl crate::audio_crt_global_dispatch_initialization::Services for NativeGlobal{fn encode_pointer(&mut self,value:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.encode(value).map_err(|_|Error::Backend("native pointer codec registry failure"))}}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test]fn audio_windows_global_services_resolve33_real_exports_encode_original_defaults_and_match6_native_global_flow_shapes(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_global_dispatch_initialization_preparation.json")).unwrap();let mut count=0;
  for row in p["cases"].as_array().unwrap().iter().filter(|v|v["module"]!=0&&v["layout"]=="all"&&v["encode_null"]==0){let mut m=p["regions"].as_array().unwrap().iter().map(|v|{let reference=v["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(row["before"][v["name"].as_str().unwrap()].as_str().unwrap())})}).collect();let mut d=BTreeSet::new();let mut native=NativeGlobal::new(0x72000000).unwrap();native.enable_trace();let result=crate::audio_crt_global_dispatch_initialization::initialize(&mut m,&mut d,&mut native).unwrap();assert_eq!(native.events().len(),36);
   let actual=native.events().iter().map(|e|match e{Event::Encode{source,..}=>json!({"kind":"EncodePointer","input":source}),Event::Module{name,..}=>json!({"kind":"GetModuleHandleW","name":name}),Event::Procedure{name,..}=>json!({"kind":"GetProcAddress","name":name})}).collect::<Vec<_>>();let expected=row["calls"].as_array().unwrap().iter().map(|v|{let mut item=json!({"kind":v["kind"]});for field in["input","name"]{if let Some(value)=v.get(field){item[field]=value.clone();}}item}).collect::<Vec<_>>();assert_eq!(actual,expected,"actual native startup service order and inputs");
   for a in[0x14ae620,0x14ae624,0x14ae86c,0x14ae60c,0x14ae610,0x14ae614,0x14ae618,0x14af108]{let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,a,4).unwrap();assert_eq!(native.decode(token).unwrap(),0);}let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,0x14ae5b0,4).unwrap();assert_eq!(native.decode(token).unwrap(),0xc98c0a);
   let cookie=row["cookie"].as_u64().unwrap()as u32;for(i,name)in crate::audio_crt_windows_dispatch_resolver::EXPORTS.iter().enumerate(){let j=match i{21=>22,22=>21,_=>i};let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,0x2da5300+j as u32*4,4).unwrap()^cookie;let Event::Procedure{result:expected,name:actual,..}=&native.events()[3+i]else{panic!("expected export event")};assert_eq!(actual,name);assert_eq!(token,*expected);if token!=0{assert_ne!(native.export_pointer(token,name).unwrap(),0);}if i==32{assert_eq!(result,token^cookie);}}
   assert!(d.is_empty());count+=1;
  }assert_eq!(count,6);
 }
 #[test]fn audio_windows_global_services_full_width_codec_identity_and_invalid_dispatch_rejection(){
  let mut native=NativeGlobal::new(0x72000000).unwrap();for source in[0,1,0xc98c0a,u32::MAX]{let encoded=native.encode(source).unwrap();assert_eq!(native.decode(encoded).unwrap(),source);assert_eq!(native.encode(source).unwrap(),encoded);}assert!(native.events().is_empty());let module=native.module("kernel32.dll").unwrap();let fls=native.procedure(module,"FlsAlloc").unwrap();assert_ne!(native.export_pointer(fls,"FlsAlloc").unwrap(),0);assert_eq!(native.export_pointer(fls,"FlsFree"),Err(Failure::NameMismatch));assert_eq!(native.decode(fls),Err(Failure::WrongKind));assert_eq!(native.procedure(fls,"FlsAlloc"),Err(Failure::WrongKind));assert!(native.procedure(0x12345678,"FlsAlloc").is_err());assert_eq!(native.procedure(module,"OpenLeagueDefinitelyMissingExport"),Ok(0));assert_eq!(native.procedure(0,"FlsAlloc"),Ok(0));assert_eq!(native.module("OpenLeagueDefinitelyMissingModule.dll"),Ok(0));assert_eq!(native.module("kernel32\0.dll"),Err(Failure::InvalidName));assert_eq!(native.procedure(module,"Fls\0Alloc"),Err(Failure::InvalidName));assert!(matches!(NativeGlobal::new(0),Err(Failure::InvalidReference)));assert!(matches!(NativeGlobal::new(1),Err(Failure::InvalidReference)));let mut exhausted=NativeGlobal::new(0xfffffff0).unwrap();assert_eq!(exhausted.encode(0),Err(Failure::AddressSpace));
 }
}
'''
(r/'crates/core/src/audio_crt_windows_global_services.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';t=p.read_text();t+='\n#[cfg(windows)]\npub mod audio_crt_windows_global_services;\n';p.write_text(t,encoding='utf-8')
(r/'tools/implement_audio_windows_global_services.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Implemented actual Windows modules/33-export registry and full-width EncodePointer/DecodePointer adapter')
