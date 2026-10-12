
//! Real Windows export resolution and EncodePointer services for original CRT startup.
//! Canonical u32 values are registry labels, never truncated host pointers. Source
//! code references passed to EncodePointer remain opaque values, not callable host code.
use std::{collections::{BTreeMap,BTreeSet},ffi::{c_void,CString}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
#[link(name="kernel32")]unsafe extern "system"{fn GetModuleHandleW(name:*const u16)->*mut c_void;fn GetProcAddress(module:*mut c_void,name:*const u8)->*mut c_void;fn EncodePointer(pointer:*mut c_void)->*mut c_void;fn DecodePointer(pointer:*mut c_void)->*mut c_void;fn GetLastError()->u32;fn SetLastError(value:u32);fn GetCurrentThreadId()->u32;fn Sleep(milliseconds:u32);fn LoadLibraryExW(name:*const u16,file:*mut c_void,flags:u32)->*mut c_void;fn FreeLibrary(module:*mut c_void)->i32;}
struct NativeError(u32);impl Drop for NativeError{fn drop(&mut self){unsafe{SetLastError(self.0)}}}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{InvalidName,InvalidReference,UnknownReference(u32),WrongKind,NameMismatch,AddressSpace,CodecMismatch,InvalidFlags,InitializationOwnership,ModuleRelease(u32)}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Event{Encode{source:u32,result:u32},Module{name:String,result:u32},Procedure{module:u32,name:String,result:u32}}
#[derive(PartialEq,Eq)]enum Reference{Module{name:String,pointer:usize},Procedure{module:u32,name:String,pointer:usize},Encoded{source:u32,pointer:usize},WorkerCallback{pointer:usize}}

#[derive(Default)]pub struct ComReport{loads:std::sync::atomic::AtomicUsize,releases:std::sync::atomic::AtomicUsize,initializations:std::sync::atomic::AtomicUsize,uninitializations:std::sync::atomic::AtomicUsize,failures:std::sync::Mutex<Vec<Failure>>}
impl ComReport{pub fn loads(&self)->usize{self.loads.load(std::sync::atomic::Ordering::Acquire)}pub fn releases(&self)->usize{self.releases.load(std::sync::atomic::Ordering::Acquire)}pub fn initializations(&self)->usize{self.initializations.load(std::sync::atomic::Ordering::Acquire)}pub fn uninitializations(&self)->usize{self.uninitializations.load(std::sync::atomic::Ordering::Acquire)}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}fn fail(&self,e:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(e);}}
pub struct NativeGlobal{next:u32,references:BTreeMap<u32,Reference>,events:Option<Vec<Event>>,owned_modules:Vec<usize>,ro_counts:BTreeMap<u32,u32>,com_report:std::sync::Arc<ComReport>}
impl NativeGlobal{
 pub fn new(first_reference:u32)->Result<Self,Failure>{if first_reference==0||first_reference&15!=0{return Err(Failure::InvalidReference);}Ok(Self{next:first_reference,references:BTreeMap::new(),events:None,owned_modules:vec![],ro_counts:BTreeMap::new(),com_report:std::sync::Arc::new(ComReport::default())})}
 /// Enable forensic tracing explicitly; normal startup keeps no accumulating trace.
 pub fn enable_trace(&mut self){self.events=Some(Vec::new());}
 pub fn events(&self)->&[Event]{self.events.as_deref().unwrap_or(&[])}
 fn event(&mut self,e:Event){if let Some(events)=&mut self.events{events.push(e);}}
 fn register(&mut self,value:Reference)->Result<u32,Failure>{if let Some((&r,_))=self.references.iter().find(|(_,v)|**v==value){return Ok(r);}let r=self.next;self.next=r.checked_add(16).ok_or(Failure::AddressSpace)?;self.references.insert(r,value);Ok(r)}
 pub fn module(&mut self,name:&str)->Result<u32,Failure>{if name.contains('\0'){return Err(Failure::InvalidName);}let wide=name.encode_utf16().chain(Some(0)).collect::<Vec<_>>();let pointer=unsafe{GetModuleHandleW(wide.as_ptr())}as usize;let _native_error=NativeError(unsafe{GetLastError()});let result=if pointer==0{0}else{self.register(Reference::Module{name:name.into(),pointer})?};self.event(Event::Module{name:name.into(),result});Ok(result)}
 pub fn procedure(&mut self,module:u32,name:&str)->Result<u32,Failure>{let name_c=CString::new(name).map_err(|_|Failure::InvalidName)?;let host=if module==0{0}else{match self.references.get(&module){Some(Reference::Module{pointer,..})=>*pointer,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(module))}};let pointer=unsafe{GetProcAddress(host as*mut c_void,name_c.as_ptr().cast())}as usize;let _native_error=NativeError(unsafe{GetLastError()});let result=if pointer==0{0}else{self.register(Reference::Procedure{module,name:name.into(),pointer})?};self.event(Event::Procedure{module,name:name.into(),result});Ok(result)}
 /// Full-width address with an explicit export-name/type ownership check.
 /// Calling or converting it to a function pointer requires a qualified ABI caller.
 pub fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Failure>{match self.references.get(&reference){Some(Reference::Procedure{name:actual,pointer,..})if actual==name=>Ok(*pointer),Some(Reference::Procedure{..})=>Err(Failure::NameMismatch),Some(_)=>Err(Failure::WrongKind),None=>Err(Failure::UnknownReference(reference))}}
 pub fn encode(&mut self,source:u32)->Result<u32,Failure>{let pointer=unsafe{EncodePointer(source as usize as*mut c_void)}as usize;let _native_error=NativeError(unsafe{GetLastError()});let result=self.register(Reference::Encoded{source,pointer})?;self.event(Event::Encode{source,result});Ok(result)}
 pub fn decode(&self,reference:u32)->Result<u32,Failure>{match self.references.get(&reference){Some(Reference::Encoded{source,pointer})=>{let actual=unsafe{DecodePointer(*pointer as*mut c_void)}as usize;let _native_error=NativeError(unsafe{GetLastError()});if actual!=*source as usize{return Err(Failure::CodecMismatch);}Ok(*source)},Some(_)=>Err(Failure::WrongKind),None=>Err(Failure::UnknownReference(reference))}}
}
impl crate::audio_crt_windows_dispatch_resolver::Services for NativeGlobal{
 fn module_handle(&mut self,name:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.module(name).map_err(|_|Error::Backend("native module registry failure"))}
 fn procedure_address(&mut self,module:u32,name:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.procedure(module,name).map_err(|_|Error::Backend("native export registry failure"))}
}
impl crate::audio_crt_global_dispatch_initialization::Services for NativeGlobal{fn encode_pointer(&mut self,value:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.encode(value).map_err(|_|Error::Backend("native pointer codec registry failure"))}}

// The heap/lock/FLS adapters override their own boundaries. Missing current-context
// and source-handler execution services fail explicitly instead of using a fake
// NULL errno context or executing a canonical source-code label as a host pointer.
impl crate::audio_global_float_default_power::Windows for NativeGlobal{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,value:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(value)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("encoded FLS current-thread provider required"))}
 fn current_thread_id(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetCurrentThreadId()})}
}
impl crate::audio_crt_heap::Services for NativeGlobal{
 fn heap_allocate(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("owned process heap provider required"))}
 fn heap_free(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("owned process heap provider required"))}
 fn thread_context(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("original errno current-context service required"))}
 fn last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn sleep(&mut self,milliseconds:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{Sleep(milliseconds)};Ok(())}
 fn decode_pointer(&mut self,reference:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.decode(reference).map_err(|_|Error::Backend("native pointer decoding registry failure"))}
 fn invoke_handler(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("original source new-handler executor required"))}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test]fn audio_windows_global_services_resolve33_real_exports_encode_original_defaults_and_match6_native_global_flow_shapes(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_global_dispatch_initialization_preparation.json")).unwrap();let mut count=0;
  for row in p["cases"].as_array().unwrap().iter().filter(|v|v["module"]!=0&&v["layout"]=="all"&&v["encode_null"]==0){let mut m=p["regions"].as_array().unwrap().iter().map(|v|{let reference=v["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(row["before"][v["name"].as_str().unwrap()].as_str().unwrap())})}).collect();let mut d=BTreeSet::new();let mut native=NativeGlobal::new(0x72000000).unwrap();native.enable_trace();let result=crate::audio_crt_global_dispatch_initialization::initialize(&mut m,&mut d,&mut native).unwrap();assert_eq!(native.events().len(),36);
   let actual=native.events().iter().map(|e|match e{Event::Encode{source,..}=>json!({"kind":"EncodePointer","input":source}),Event::Module{name,..}=>json!({"kind":"GetModuleHandleW","name":name}),Event::Procedure{name,..}=>json!({"kind":"GetProcAddress","name":name})}).collect::<Vec<_>>();let expected=row["calls"].as_array().unwrap().iter().map(|v|{let mut item=json!({"kind":v["kind"]});for field in["input","name"]{if let Some(value)=v.get(field){item[field]=value.clone();}}item}).collect::<Vec<_>>();assert_eq!(actual,expected,"actual native startup service order and inputs");
   for a in[0x14ae620,0x14ae624,0x14ae86c,0x14ae60c,0x14ae610,0x14ae614,0x14ae618,0x14af108]{let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,a,4).unwrap();assert_eq!(native.decode(token).unwrap(),0);}let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,0x14ae5b0,4).unwrap();assert_eq!(native.decode(token).unwrap(),0xc98c0a);
   let cookie=row["cookie"].as_u64().unwrap()as u32;for(i,name)in crate::audio_crt_windows_dispatch_resolver::EXPORTS.iter().enumerate(){let j=match i{21=>22,22=>21,_=>i};let token=crate::audio_path_source_virtual_cleanup::get(&m,&d,0x2da5300+j as u32*4,4).unwrap()^cookie;let Event::Procedure{result:expected,name:actual,..}=&native.events()[3+i]else{panic!("expected export event")};assert_eq!(actual,name);assert_eq!(token,*expected);if token!=0{assert_ne!(native.export_pointer(token,name).unwrap(),0);}if i==32{assert_eq!(result,token^cookie);}}

   let nil=match native.events()[0]{Event::Encode{result,..}=>result,_=>panic!("expected encoded NULL")};let terminate=match native.events()[1]{Event::Encode{result,..}=>result,_=>panic!("expected encoded terminate")};
   for v in p["regions"].as_array().unwrap(){let a=v["reference"].as_u64().unwrap()as u32;let mut expected=bytes(row["after"][v["name"].as_str().unwrap()].as_str().unwrap());for j in (0..expected.len()).step_by(4){let at=a+j as u32;let replacement=if[0x14ae620,0x14ae624,0x14ae86c,0x14ae60c,0x14ae610,0x14ae614,0x14ae618,0x14af108].contains(&at){Some(nil)}else if at==0x14ae5b0{Some(terminate)}else if (0x2da5300..0x2da5300+33*4).contains(&at){let slot=(at-0x2da5300)/4;let i=match slot{21=>22,22=>21,_=>slot}as usize;let Event::Procedure{result,..}=native.events()[3+i]else{panic!("expected resolved procedure")};Some(result^cookie)}else{None};if let Some(word)=replacement{expected[j..j+4].copy_from_slice(&word.to_le_bytes());}}assert_eq!(crate::audio_path_memory::read(&m,a,expected.len()).unwrap(),expected,"full native bank after explicit host-reference relocation {a:x}");}
   let mut heap=crate::audio_crt_windows_process_heap::Heap::new(0x71000000,0x50000000).unwrap();m.insert(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]});heap.initialize(&mut m,&d).unwrap();let report=heap.report();let mut services=crate::audio_crt_windows_critical_sections::Provider{inner:crate::audio_crt_windows_process_heap::Provider{inner:native,heap},locks:crate::audio_crt_windows_critical_sections::Bank::default()};assert_eq!(crate::audio_crt_global_dispatch_initialization::initialize(&mut m,&mut d,&mut services).unwrap(),result);let record=services.inner.heap.allocate(0x71000000,8,956,&mut m,&mut d).unwrap();services.inner.heap.free(0x71000000,0,record,&m,&mut d).unwrap();assert_eq!(services.inner.heap.retire_mirrors(&mut m,&mut d).unwrap(),1);assert_eq!((report.allocations(),report.frees()),(1,1));assert!(report.failures().is_empty());assert!(d.is_empty());count+=1;
  }assert_eq!(count,6);
 }
 #[test]fn audio_windows_global_services_full_width_codec_identity_and_invalid_dispatch_rejection(){
  let mut native=NativeGlobal::new(0x72000000).unwrap();for source in[0,1,0xc98c0a,u32::MAX]{let encoded=native.encode(source).unwrap();assert_eq!(native.decode(encoded).unwrap(),source);assert_eq!(native.encode(source).unwrap(),encoded);}assert!(native.events().is_empty());let module=native.module("kernel32.dll").unwrap();let fls=native.procedure(module,"FlsAlloc").unwrap();assert_ne!(native.export_pointer(fls,"FlsAlloc").unwrap(),0);assert_eq!(native.export_pointer(fls,"FlsFree"),Err(Failure::NameMismatch));assert_eq!(native.decode(fls),Err(Failure::WrongKind));assert_eq!(native.procedure(fls,"FlsAlloc"),Err(Failure::WrongKind));assert!(native.procedure(0x12345678,"FlsAlloc").is_err());let host=match native.references[&module]{Reference::Module{pointer,..}=>pointer,_=>panic!("module required")};let name=CString::new("OpenLeagueDefinitelyMissingExport").unwrap();unsafe{SetLastError(97)};assert!(unsafe{GetProcAddress(host as*mut c_void,name.as_ptr().cast())}.is_null());let original_error=unsafe{GetLastError()};unsafe{SetLastError(97)};native.enable_trace();assert_eq!(native.procedure(module,"OpenLeagueDefinitelyMissingExport"),Ok(0));assert_eq!(unsafe{GetLastError()},original_error);assert_eq!(native.procedure(0,"FlsAlloc"),Ok(0));assert_eq!(native.module("OpenLeagueDefinitelyMissingModule.dll"),Ok(0));assert_eq!(native.module("kernel32\0.dll"),Err(Failure::InvalidName));assert_eq!(native.procedure(module,"Fls\0Alloc"),Err(Failure::InvalidName));assert!(matches!(NativeGlobal::new(0),Err(Failure::InvalidReference)));assert!(matches!(NativeGlobal::new(1),Err(Failure::InvalidReference)));let mut exhausted=NativeGlobal::new(0xfffffff0).unwrap();assert_eq!(exhausted.encode(0),Err(Failure::AddressSpace));
 }
}

impl crate::audio_crt_windows_dispatch_resolver::Lookup for NativeGlobal{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>{self.export_pointer(reference,name).map_err(|_|Error::Backend("native export identity mismatch"))}
 fn fls_functions(&self,references:[u32;4])->Result<crate::audio_crt_windows_dispatch_resolver::FlsFunctions,Error>{
  use crate::audio_crt_windows_dispatch_resolver::{FlsFunctions,FlsAllocFn,FlsFreeFn,FlsGetFn,FlsSetFn};
  let mut addresses=[0usize;4];
  for(i,name)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){let module=match self.references.get(&references[i]){Some(Reference::Procedure{module,..})=>*module,_=>return Err(Error::Backend("native typed FLS export kind mismatch"))};match self.references.get(&module){Some(Reference::Module{name,..})if name.eq_ignore_ascii_case("kernel32.dll")=>{},_=>return Err(Error::Backend("native typed FLS export module mismatch"))}addresses[i]=self.export_pointer(references[i],name).map_err(|_|Error::Backend("native typed FLS export identity mismatch"))?;if addresses[i]==0{return Err(Error::Backend("native typed FLS export is missing"));}}
  // Registry entries are populated exclusively by GetProcAddress on a live
  // borrowed Windows module; exact export name/kind checked above. Addresses
  // remain full-width and these signatures match the Windows system ABI.
  Ok(unsafe{FlsFunctions::new(std::mem::transmute::<usize,FlsAllocFn>(addresses[0]),std::mem::transmute::<usize,FlsFreeFn>(addresses[1]),std::mem::transmute::<usize,FlsGetFn>(addresses[2]),std::mem::transmute::<usize,FlsSetFn>(addresses[3]))})
 }
}

#[cfg(test)]mod resolved_fls_tests{
 use super::*;use crate::audio_crt_windows_dispatch_resolver::Lookup;
 #[test]fn audio_windows_registered_fls_abi_invokes_full_width_alloc_get_set_free_and_rejects_wrong_null_foreign_encoded_and_permuted_references(){
  let mut native=NativeGlobal::new(0x72000000).unwrap();let module=native.module("kernel32.dll").unwrap();
  let mut refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){refs[i]=native.procedure(module,n).unwrap();}
  let api=native.fls_functions(refs).unwrap();let index=unsafe{(api.alloc)(None)};assert_ne!(index,u32::MAX);
  unsafe{SetLastError(97)};assert!(unsafe{(api.get)(index)}.is_null());assert_eq!(unsafe{GetLastError()},0);
  let mut marker=0x12345678u64;let pointer=(&mut marker as*mut u64).cast::<c_void>();
  assert_ne!(unsafe{(api.set)(index,pointer)},0);assert_eq!(unsafe{(api.get)(index)},pointer);
  assert_ne!(unsafe{(api.set)(index,std::ptr::null_mut())},0);assert!(unsafe{(api.get)(index)}.is_null());assert_ne!(unsafe{(api.free)(index)},0);
  let encoded=native.encode(0).unwrap();for bad in[0,0x11223344,module,encoded,refs[1]]{let mut v=refs;v[0]=bad;assert!(native.fls_functions(v).is_err());}
  let mut permuted=refs;permuted.swap(2,3);assert!(native.fls_functions(permuted).is_err());
  let other=native.module("KernelBase.dll").unwrap();assert_ne!(other,0);let mut other_refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){other_refs[i]=native.procedure(other,n).unwrap();}assert!(native.fls_functions(other_refs).is_err());
  let missing=native.procedure(module,"OpenLeagueDefinitelyMissingExport").unwrap();assert_eq!(missing,0);let mut v=refs;v[3]=missing;assert!(native.fls_functions(v).is_err());
 }
}

impl NativeGlobal{
 pub fn com_report(&self)->std::sync::Arc<ComReport>{self.com_report.clone()}
 pub fn loaded_module_count(&self)->usize{self.owned_modules.len()}
 pub fn pending_ro_initializations(&self)->usize{self.ro_counts.values().map(|v|*v as usize).sum()}
 pub fn load_combase(&mut self,name:&str,flags:u32)->Result<u32,Failure>{
  if !name.eq_ignore_ascii_case("combase.dll"){return Err(Failure::InvalidName);}if flags!=0x800{return Err(Failure::InvalidFlags);}
  let wide=name.encode_utf16().chain(Some(0)).collect::<Vec<_>>();let pointer=unsafe{LoadLibraryExW(wide.as_ptr(),std::ptr::null_mut(),flags)}as usize;let _error=NativeError(unsafe{GetLastError()});
  if pointer==0{return Ok(0);}self.owned_modules.push(pointer);self.com_report.loads.fetch_add(1,std::sync::atomic::Ordering::AcqRel);self.register(Reference::Module{name:name.into(),pointer})
 }
 fn ro_export(&self,reference:u32,name:&str)->Result<usize,Failure>{
  let module=match self.references.get(&reference){Some(Reference::Procedure{module,..})=>*module,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};
  match self.references.get(&module){Some(Reference::Module{name:module_name,pointer})if module_name.eq_ignore_ascii_case("combase.dll")&&self.owned_modules.contains(pointer)=>{},_=>return Err(Failure::InitializationOwnership)}
  self.export_pointer(reference,name)
 }
 /// Every nonnegative HRESULT creates an adapter-owned obligation on this
 /// exact OS thread; original strict-zero flag interpretation is a separate port.
 pub fn ro_initialize(&mut self,reference:u32,kind:u32)->Result<u32,Failure>{
  if kind>1{return Err(Failure::InvalidFlags);}let pointer=self.ro_export(reference,"RoInitialize")?;
  let thread=unsafe{GetCurrentThreadId()};let count=self.ro_counts.get(&thread).copied().unwrap_or(0);if count==u32::MAX{return Err(Failure::AddressSpace);}
  let function:unsafe extern "system" fn(u32)->i32=unsafe{std::mem::transmute(pointer)};let result=unsafe{function(kind)};let _error=NativeError(unsafe{GetLastError()});if result>=0{self.ro_counts.insert(thread,count+1);self.com_report.initializations.fetch_add(1,std::sync::atomic::Ordering::AcqRel);}Ok(result as u32)
 }
 pub fn ro_uninitialize(&mut self,reference:u32)->Result<(),Failure>{
  let pointer=self.ro_export(reference,"RoUninitialize")?;let thread=unsafe{GetCurrentThreadId()};let count=self.ro_counts.get(&thread).copied().unwrap_or(0);if count==0{return Err(Failure::InitializationOwnership);}
  let function:unsafe extern "system" fn()=unsafe{std::mem::transmute(pointer)};unsafe{function()};let _error=NativeError(unsafe{GetLastError()});self.com_report.uninitializations.fetch_add(1,std::sync::atomic::Ordering::AcqRel);if count==1{self.ro_counts.remove(&thread);}else{self.ro_counts.insert(thread,count-1);}Ok(())
 }
}
impl Drop for NativeGlobal{fn drop(&mut self){
 // Never uninitialize another thread's apartment. Outstanding obligations
 // retain their modules; callers must inspect/resolve them before adapter drop.
 if !self.ro_counts.is_empty(){self.com_report.fail(Failure::InitializationOwnership);return;}let saved=unsafe{GetLastError()};for pointer in self.owned_modules.drain(..).rev(){if unsafe{FreeLibrary(pointer as*mut c_void)}==0{self.com_report.fail(Failure::ModuleRelease(unsafe{GetLastError()}));}else{self.com_report.releases.fetch_add(1,std::sync::atomic::Ordering::AcqRel);}}unsafe{SetLastError(saved)};
}}
impl crate::audio_crt_worker_exit::ComServices for NativeGlobal{
 fn load_library(&mut self,n:&str,f:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.load_combase(n,f).map_err(|_|Error::Backend("owned combase module lookup failed"))}
 fn procedure(&mut self,r:u32,n:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.procedure(r,n).map_err(|_|Error::Backend("COM export lookup failed"))}
 fn encode(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.encode(r).map_err(|_|Error::Backend("COM pointer encode failed"))}
 fn decode(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{NativeGlobal::decode(self,r).map_err(|_|Error::Backend("COM pointer decode failed"))}
 fn invoke_ro_uninitialize(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.ro_uninitialize(r).map_err(|_|Error::Backend("owned current-thread COM release failed"))}
}

#[cfg(test)]mod actual_com_tests{
 use super::*;
 #[test]fn audio_windows_owned_com_exports_balance_actual_nested_ro_initialize_on_current_thread_and_reject_unowned_invalid_module_kind_and_codec_inputs(){
  let report=std::thread::spawn(||{let mut native=NativeGlobal::new(0x76000000).unwrap();let report=native.com_report();assert_eq!(native.load_combase("kernel32.dll",0x800),Err(Failure::InvalidName));assert_eq!(native.load_combase("combase.dll",0),Err(Failure::InvalidFlags));let module=native.load_combase("combase.dll",0x800).unwrap();assert_ne!(module,0);assert_eq!(native.loaded_module_count(),1);let init=native.procedure(module,"RoInitialize").unwrap();let finish=native.procedure(module,"RoUninitialize").unwrap();let encoded=native.encode(finish).unwrap();assert_eq!(native.decode(encoded).unwrap(),finish);
   assert_eq!(native.ro_uninitialize(finish),Err(Failure::InitializationOwnership));assert_eq!(native.ro_initialize(finish,1),Err(Failure::NameMismatch));assert_eq!(native.ro_initialize(init,7),Err(Failure::InvalidFlags));assert!(native.ro_uninitialize(encoded).is_err());assert!(native.ro_uninitialize(module).is_err());assert!(native.ro_uninitialize(0).is_err());let wrong_module=native.module("kernel32.dll").unwrap();let wrong=native.procedure(wrong_module,"GetCurrentThreadId").unwrap();assert!(native.ro_uninitialize(wrong).is_err());
   assert_eq!(native.ro_initialize(init,1).unwrap(),0);assert_eq!(native.ro_initialize(init,1).unwrap(),1);assert_eq!(native.pending_ro_initializations(),2);native.ro_uninitialize(finish).unwrap();assert_eq!(native.pending_ro_initializations(),1);native.ro_uninitialize(finish).unwrap();assert_eq!(native.pending_ro_initializations(),0);assert_eq!(native.ro_uninitialize(finish),Err(Failure::InitializationOwnership));
  report
  }).join().unwrap();assert_eq!((report.loads(),report.releases(),report.initializations(),report.uninitializations()),(1,1,2,2));assert!(report.failures().is_empty());
 }
}


impl NativeGlobal{
 pub fn package_query(&self,reference:u32,initial_length:u32)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Failure>{
  let module=match self.references.get(&reference){Some(Reference::Procedure{module,..})=>*module,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};match self.references.get(&module){Some(Reference::Module{name,..})if name.eq_ignore_ascii_case("kernel32.dll")=>{},_=>return Err(Failure::InitializationOwnership)}
  let pointer=self.export_pointer(reference,"GetCurrentPackageId")?;let function:unsafe extern "system" fn(*mut u32,*mut u8)->i32=unsafe{std::mem::transmute(pointer)};let mut length=initial_length;let result=unsafe{function(&mut length,std::ptr::null_mut())};let _error=NativeError(unsafe{GetLastError()});Ok(crate::audio_crt_worker_com_startup::PackageQuery{result:result as u32,length})
 }
}
impl crate::audio_crt_worker_com_startup::Services for NativeGlobal{
 fn current_package_id(&mut self,r:u32,l:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Error>{self.package_query(r,l).map_err(|_|Error::Backend("qualified package query failed"))}
 fn invoke_ro_initialize(&mut self,r:u32,k:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.ro_initialize(r,k).map_err(|_|Error::Backend("owned COM initialization failed"))}
}

#[cfg(test)]mod package_and_com_stage_tests{
 use super::*;
 #[test]fn audio_windows_package_query_checks_typed_export_provenance_and_real_com_initializer_preserves_source_s_false_flag_separate_from_two_owned_obligations(){
  std::thread::spawn(||{let mut native=NativeGlobal::new(0x76000000).unwrap();let module=native.module("kernel32.dll").unwrap();let package=native.procedure(module,"GetCurrentPackageId").unwrap();let query=native.package_query(package,0).unwrap();assert!(query.result==122||query.result==15700,"current actual package state");let wrong=native.procedure(module,"GetCurrentThreadId").unwrap();assert_eq!(native.package_query(wrong,0),Err(Failure::NameMismatch));assert!(native.package_query(0,0).is_err());assert!(native.package_query(module,0).is_err());let encoded=native.encode(package).unwrap();assert!(native.package_query(encoded,0).is_err());
   let mut memory=BTreeMap::new();let mut dead=BTreeSet::new();memory.insert(0x14ae5f8,Memory{reference:0x14ae5f8,raw:vec![0;8]});assert_eq!(crate::audio_crt_worker_com_startup::initialize_com(&mut memory,&mut dead,&mut native).unwrap(),1);assert_eq!(crate::audio_crt_worker_com_startup::initialize_com(&mut memory,&mut dead,&mut native).unwrap(),0);assert_eq!(native.pending_ro_initializations(),2);
   // Explicit test-owned balancing, separate from original strict-zero flag.
   let module=native.load_combase("combase.dll",0x800).unwrap();let release=native.procedure(module,"RoUninitialize").unwrap();native.ro_uninitialize(release).unwrap();native.ro_uninitialize(release).unwrap();assert_eq!(native.pending_ro_initializations(),0);
  }).join().unwrap();
 }
}

impl NativeGlobal{
 /// Register a host ABI callback without narrowing its address to the PE32 label.
 /// # Safety
 /// Callback code must remain live, not unwind, and accept canonical u32 input.
 /// It must not reenter the shared context guard held by the worker body caller.
 pub unsafe fn register_worker_callback(&mut self,function:unsafe extern "system" fn(u32)->u32)->Result<u32,Failure>{self.register(Reference::WorkerCallback{pointer:function as usize})}
 pub fn invoke_worker_callback(&self,reference:u32,argument:u32)->Result<u32,Failure>{let pointer=match self.references.get(&reference){Some(Reference::WorkerCallback{pointer})=>*pointer,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};let callback:unsafe extern "system" fn(u32)->u32=unsafe{std::mem::transmute(pointer)};Ok(unsafe{callback(argument)})}
}
impl crate::audio_crt_worker_body::CallbackServices for NativeGlobal{
 fn worker_callback(&mut self,r:u32,a:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.invoke_worker_callback(r,a).map_err(|_|Error::Backend("registered native worker callback required"))}
}

#[cfg(test)]mod worker_callback_tests{
 use super::*;
 unsafe extern "system" fn callback(argument:u32)->u32{unsafe{SetLastError(73)};argument}
 #[test]fn audio_windows_worker_callback_registry_preserves_full_width_system_abi_u32_results_last_error_and_rejects_unregistered_export_encoded_or_module_refs(){let mut native=NativeGlobal::new(0x76000000).unwrap();let reference=unsafe{native.register_worker_callback(callback)}.unwrap();assert_eq!(unsafe{native.register_worker_callback(callback)}.unwrap(),reference);for argument in [0,97,u32::MAX]{assert_eq!(native.invoke_worker_callback(reference,argument).unwrap(),argument);assert_eq!(unsafe{GetLastError()},73);}let module=native.module("kernel32.dll").unwrap();let export=native.procedure(module,"GetCurrentThreadId").unwrap();let encoded=native.encode(reference).unwrap();for r in [module,export,encoded]{assert_eq!(native.invoke_worker_callback(r,0),Err(Failure::WrongKind));}for r in [0,0xffffffff]{assert_eq!(native.invoke_worker_callback(r,0),Err(Failure::UnknownReference(r)));}}
}
