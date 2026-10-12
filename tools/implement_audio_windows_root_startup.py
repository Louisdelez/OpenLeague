from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/core/src/audio_crt_windows_dispatch_resolver.rs';s=p.read_text();s+='\n/// Qualified full-width host export lookup for OS adapter ownership checks.\npub trait Lookup{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>;}\n';p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_global_services.rs';s=p.read_text();s+='\nimpl crate::audio_crt_windows_dispatch_resolver::Lookup for NativeGlobal{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>{self.export_pointer(reference,name).map_err(|_|Error::Backend("native export identity mismatch"))}}\n';p.write_text(s,encoding='utf-8')
for module in ['audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:
 p=r/f'crates/core/src/{module}.rs';s=p.read_text();s+='\nimpl<S:crate::audio_crt_windows_dispatch_resolver::Lookup> crate::audio_crt_windows_dispatch_resolver::Lookup for Provider<S>{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>{self.inner.export_pointer(reference,name)}}\n';p.write_text(s,encoding='utf-8')
s=r'''
//! Original successful CA92CB ordering with callback-safe actual FLS startup.
//! Context owns initial native globals and an attached process heap, not a restored
//! thread record. Global initialization, static locks, FLS allocation, calloc,
//! publication and original constructor run in that order. Legacy TLS fallback
//! and original security-cookie production remain separate dependencies.
use std::sync::Arc;
use crate::{audio_bus_bank::Error,audio_crt_windows_fls_slot::{Context,Failure},audio_crt_windows_shared_fls::{SharedContext,SharedSlot,Retirement,ValueDispatch,LockCleanup}};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services:crate::audio_crt_thread_destructor::Services+crate::audio_crt_global_dispatch_initialization::Services+crate::audio_crt_static_lock_startup::Services+crate::audio_crt_windows_dispatch_resolver::Lookup+LockCleanup+Send+'static{}
impl<S> Services for S where S:crate::audio_crt_thread_destructor::Services+crate::audio_crt_global_dispatch_initialization::Services+crate::audio_crt_static_lock_startup::Services+crate::audio_crt_windows_dispatch_resolver::Lookup+LockCleanup+Send+'static{}
pub struct Startup<S:Services>{pub context:Arc<SharedContext<S>>,pub slot:Option<SharedSlot<S>>,pub initial_record:Option<u32>,pub status:u32,dispatch:Option<ValueDispatch>}
impl<S:Services> Startup<S>{
 pub fn current(&self)->Result<u32,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.get_or_create_current(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?)}
 pub fn shutdown(&self)->Result<(),Failure>{match &self.slot{Some(slot)=>slot.shutdown_crt(&self.context),None=>Ok(())}}
}
fn failure(e:Error)->Failure{Failure::InvalidContext(format!("original CRT startup dependency: {e:?}"))}
fn cleanup_without_slot<S:Services>(context:&Arc<SharedContext<S>>)->Result<(),Failure>{context.with(|c|{put(&mut c.memory,&c.dead,0x12230cc,4,u32::MAX)?;crate::audio_crt_thread_system_startup::cleanup_lock_table(&mut c.memory,&mut c.dead,&mut c.services,|s,r,m,d|s.delete_critical_section(r,m,d))}).map_err(|e|e)?.map_err(failure)}
fn cleanup_error(primary:Failure,result:Result<(),Failure>)->Failure{match result{Ok(())=>primary,Err(e)=>Failure::InvalidContext(format!("startup failed: {primary:?}; cleanup also failed: {e:?}"))}}
/// Successful production startup and native status0 failures. A publication
/// failure retains the allocated record exactly as CA92CB does; it is reported
/// in initial_record with status0, never presented as a running context.
pub fn initialize<S:Services>(context:Context<S>,retirement:Option<Retirement<S>>)->Result<Startup<S>,Failure>{initialize_with(context,retirement,|retirement|match retirement{Some(retire)=>SharedSlot::new_with_retirement(retire),None=>SharedSlot::new()},|slot,context,record|slot.bind_current(context.clone(),record).map(|_|true))}
fn initialize_with<S:Services>(context:Context<S>,retirement:Option<Retirement<S>>,allocate:impl FnOnce(Option<Retirement<S>>)->Result<SharedSlot<S>,Failure>,publish:impl FnOnce(&SharedSlot<S>,&Arc<SharedContext<S>>,u32)->Result<bool,Failure>)->Result<Startup<S>,Failure>{
 let context=Arc::new(SharedContext::new(context));
 // Ownership preflight avoids closing a slot that belongs to an existing root.
 context.with(|c|get(&c.memory,&c.dead,0x12230cc,4).map_err(failure).and_then(|i|if i==u32::MAX{Ok(())}else{Err(Failure::InvalidContext("CRT root already owns a slot".into()))}))??;
 let prepared=context.with(|c|->Result<Option<ValueDispatch>,Error>{crate::audio_crt_global_dispatch_initialization::initialize(&mut c.memory,&mut c.dead,&mut c.services)?;if crate::audio_crt_static_lock_startup::initialize(&mut c.memory,&mut c.dead,&mut c.services)?==0{return Ok(None);}let cookie=get(&c.memory,&c.dead,0x1222ed0,4)?;let mut tokens=[0;4];for(i,name)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){tokens[i]=get(&c.memory,&c.dead,0x2da5300+i as u32*4,4)?^cookie;if tokens[i]==0{return Err(Error::Backend("real CRT root requires FLS; legacy TLS root not supplied"));}c.services.export_pointer(tokens[i],name)?;}Ok(Some(ValueDispatch{get:tokens[2],set:tokens[3]}))}).and_then(|v|v.map_err(failure));
 let dispatch=match prepared{Ok(Some(dispatch))=>dispatch,Ok(None)=>{cleanup_without_slot(&context)?;return Ok(Startup{context,slot:None,initial_record:None,status:0,dispatch:None});},Err(e)=>return Err(cleanup_error(e,cleanup_without_slot(&context)))};
 let slot=match allocate(retirement){Ok(slot)=>slot,Err(e)=>{cleanup_without_slot(&context)?;if matches!(e,Failure::Windows{operation:"FlsAlloc",..}){return Ok(Startup{context,slot:None,initial_record:None,status:0,dispatch:Some(dispatch)});}return Err(e);}};
 if let Err(e)=slot.publish_index(&context){return Err(cleanup_error(e,slot.close().and_then(|_|cleanup_without_slot(&context))));}
 let record=match context.with(|c|c.services.calloc_thread(1,0x3bc,&mut c.memory,&mut c.dead)).and_then(|v|v.map_err(failure)){Ok(record)=>record.unwrap_or(0),Err(e)=>return Err(cleanup_error(e,slot.shutdown_crt(&context)))};
 if record==0{slot.shutdown_crt(&context)?;return Ok(Startup{context,slot:None,initial_record:None,status:0,dispatch:Some(dispatch)});}
 if let Err(e)=context.with(|c|live(&c.memory,&c.dead,record,0x3bc)).and_then(|v|v.map_err(failure)){return Err(cleanup_error(e,slot.shutdown_crt(&context)));}
 match publish(&slot,&context,record){Ok(true)=>{},Ok(false)=>{slot.shutdown_crt(&context)?;return Ok(Startup{context,slot:None,initial_record:Some(record),status:0,dispatch:Some(dispatch)});},Err(e@Failure::Windows{operation:"FlsSetValue",..})=>{let _cause=e;slot.shutdown_crt(&context)?;return Ok(Startup{context,slot:None,initial_record:Some(record),status:0,dispatch:Some(dispatch)});},Err(e)=>return Err(cleanup_error(e,slot.shutdown_crt(&context)))}
 let initialized=context.with(|c|->Result<(),Error>{crate::audio_crt_thread_context::initialize(&mut c.memory,&mut c.dead,record,&mut c.services)?;let thread=c.services.current_thread_id(&mut c.memory,&mut c.dead)?;put(&mut c.memory,&c.dead,record+4,4,u32::MAX)?;put(&mut c.memory,&c.dead,record,4,thread)?;Ok(())}).and_then(|v|v.map_err(failure));
 if let Err(e)=initialized{return Err(cleanup_error(e,slot.shutdown_crt(&context)));}
 Ok(Startup{context,slot:Some(slot),initial_record:Some(record),status:1,dispatch:Some(dispatch)})
}
'''
(r/'crates/core/src/audio_crt_windows_root_startup.rs').write_text(s,encoding='utf-8');p=r/'crates/core/src/lib.rs';s=p.read_text();s+='\n#[cfg(windows)]\npub mod audio_crt_windows_root_startup;\n';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_windows_root_startup.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Implemented production callback-safe CRT root orchestration and native status0 cleanup branches')
