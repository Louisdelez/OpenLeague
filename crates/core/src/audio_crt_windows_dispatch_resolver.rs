//! Original CABDE8 ordered Windows export resolution and XOR-cookie publication.
use std::collections::{BTreeMap,BTreeSet};use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use crate::audio_path_source_virtual_cleanup::{get,put};
pub const EXPORTS:[&str;33]=[
"FlsAlloc",
"FlsFree",
"FlsGetValue",
"FlsSetValue",
"InitializeCriticalSectionEx",
"CreateEventExW",
"CreateSemaphoreExW",
"SetThreadStackGuarantee",
"CreateThreadpoolTimer",
"SetThreadpoolTimer",
"WaitForThreadpoolTimerCallbacks",
"CloseThreadpoolTimer",
"CreateThreadpoolWait",
"SetThreadpoolWait",
"CloseThreadpoolWait",
"FlushProcessWriteBuffers",
"FreeLibraryWhenCallbackReturns",
"GetCurrentProcessorNumber",
"GetLogicalProcessorInformation",
"CreateSymbolicLinkW",
"SetDefaultDllDirectories",
"EnumSystemLocalesEx",
"CompareStringEx",
"GetDateFormatEx",
"GetLocaleInfoEx",
"GetTimeFormatEx",
"GetUserDefaultLocaleName",
"IsValidLocaleName",
"LCMapStringEx",
"GetCurrentPackageId",
"GetTickCount64",
"GetFileInformationByHandleExW",
"SetFileInformationByHandleW"];
pub trait Services{fn module_handle(&mut self,name:&str,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;fn procedure_address(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;}
/// The returned word is native EAX residue, not an availability/success status.
pub fn resolve(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<u32,Error>{let module=s.module_handle("kernel32.dll",m,d)?;let mut last=0;for(i,name)in EXPORTS.iter().enumerate(){let r=s.procedure_address(module,name,m,d)?;last=r^get(m,d,0x1222ed0,4)?;let slot=match i{21=>22,22=>21,_=>i};/* Original query order stores EnumSystemLocalesEx at5358 and CompareStringEx at5354. */put(m,d,0x2da5300+slot as u32*4,4,last)?;}Ok(last)}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,module:u32,layout:String,index:u32}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!((0..*z).map(|j|format!("{:02x}",crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0])).collect::<String>());}out}}
 impl Services for Api{fn module_handle(&mut self,name:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"kind":"GetModuleHandleW","name":name,"result":self.module,"at_call":self.snapshot(m)}));Ok(self.module)}fn procedure_address(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let available=self.module!=0&&(self.layout=="all"||(self.layout=="alternating"&&self.index%2==0)||(self.layout=="fls"&&name.starts_with("Fls")));let r=if available{0x40004000+self.index*16}else{0};self.calls.push(json!({"kind":"GetProcAddress","module":module,"name":name,"result":r,"at_call":self.snapshot(m)}));self.index+=1;Ok(r)}}
 #[test]fn audio_crt_windows_dispatch_resolver_matches48_original33_export_order_null_module_partial_availability_xor_cookie_publication_and_all_entry_banks(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_windows_dispatch_resolver_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);assert_eq!(json!(&EXPORTS[..]),p["export_names"]);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],module:row["module"].as_u64().unwrap()as u32,layout:row["layout"].as_str().unwrap().into(),index:0};let result=resolve(&mut m,&mut d,&mut api).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native register residue {i}");assert_eq!(json!(api.calls),row["calls"],"original names/order/each intermediate global bank {i}");assert_eq!(api.snapshot(&m),row["after"],"all dispatch and cookie bytes {i}");assert_eq!(api.index,33);assert!(d.is_empty());}}
}

/// Qualified full-width host export lookup for OS adapter ownership checks.
pub trait Lookup{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>;fn fls_functions(&self,_references:[u32;4])->Result<FlsFunctions,Error>{Err(Error::Backend("qualified typed FLS exports required"))}}

/// Typed full-width Windows FLS entry points. Construction accepts callable
/// function pointers, never unchecked integers or source-image addresses.
pub type FlsAllocFn=unsafe extern "system" fn(Option<unsafe extern "system" fn(*mut std::ffi::c_void)>)->u32;
pub type FlsFreeFn=unsafe extern "system" fn(u32)->i32;
pub type FlsGetFn=unsafe extern "system" fn(u32)->*mut std::ffi::c_void;
pub type FlsSetFn=unsafe extern "system" fn(u32,*mut std::ffi::c_void)->i32;
#[derive(Clone,Copy)]pub struct FlsFunctions{pub(crate) alloc:FlsAllocFn,pub(crate) free:FlsFreeFn,pub(crate) get:FlsGetFn,pub(crate) set:FlsSetFn}
/// Safety: pointers must implement the exact Windows FLS ownership, callback,
/// thread-local storage and LastError contracts for their entire lifetime.
impl FlsFunctions{pub unsafe fn new(alloc:FlsAllocFn,free:FlsFreeFn,get:FlsGetFn,set:FlsSetFn)->Self{Self{alloc,free,get,set}}}

