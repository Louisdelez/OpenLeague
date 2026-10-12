//! Owned actual CreateThread handle, independent of the PE32 canonical label.
use std::{ffi::c_void,sync::{Arc,Mutex,atomic::{AtomicUsize,Ordering}}};
use crate::audio_crt_worker_packet::ThreadRequest;
#[link(name="kernel32")]unsafe extern "system"{fn CreateThread(security:*mut c_void,stack:usize,start:Option<unsafe extern "system" fn(*mut c_void)->u32>,parameter:*mut c_void,flags:u32,id:*mut u32)->*mut c_void;fn ResumeThread(handle:*mut c_void)->u32;fn WaitForSingleObject(handle:*mut c_void,milliseconds:u32)->u32;fn GetExitCodeThread(handle:*mut c_void,code:*mut u32)->i32;fn CloseHandle(handle:*mut c_void)->i32;fn GetLastError()->u32;fn SetLastError(code:u32);}
struct LastError(u32);impl Drop for LastError{fn drop(&mut self){unsafe{SetLastError(self.0)}}}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{InvalidLabel,InvalidEntry,UnsupportedSecurity,Windows{operation:&'static str,code:u32},UnexpectedWait(u32),InvalidSecurityBuffer,SecurityLabelMismatch}
#[derive(Default)]pub struct Report{created:AtomicUsize,closed:AtomicUsize,failures:Mutex<Vec<Failure>>}
impl Report{pub fn created(&self)->usize{self.created.load(Ordering::Acquire)}pub fn closed(&self)->usize{self.closed.load(Ordering::Acquire)}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}fn fail(&self,f:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(f);}}
#[derive(Debug,PartialEq,Eq)]pub enum Wait{Timeout,Exited(u32)}
#[repr(C)]struct Attributes{length:u32,descriptor:*mut c_void,inherit:i32}
/// A canonical security label owns a borrow of a full-width descriptor buffer.
pub struct Security<'a>{label:u32,attributes:Attributes,_descriptor:std::marker::PhantomData<&'a mut[u8]>}
impl<'a> Security<'a>{
 /// # Safety
 /// Buffer must remain a readable Windows SECURITY_DESCRIPTOR during the call.
 /// Any pointer-bearing fields must refer to live readable owned data. Malformed
 /// descriptor contents may be rejected by Windows; labels are never cast to pointers.
 pub unsafe fn from_descriptor(label:u32,buffer:&'a mut[u8],inherit:bool)->Result<Self,Failure>{if label==0{return Err(Failure::InvalidLabel);}if buffer.len()<if cfg!(target_pointer_width="64"){40}else{20}{return Err(Failure::InvalidSecurityBuffer);}Ok(Self{label,attributes:Attributes{length:std::mem::size_of::<Attributes>()as u32,descriptor:buffer.as_mut_ptr().cast(),inherit:i32::from(inherit)},_descriptor:std::marker::PhantomData})}
}
pub struct Thread{label:u32,handle:usize,id:u32,report:Arc<Report>}
impl Thread{
 /// # Safety
 /// Start and capsule must remain valid through OS thread completion. Start must
 /// not unwind across its system ABI. Caller reclaims capsule on creation failure.
 pub unsafe fn spawn(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>)->Result<Self,Failure>{
  if request.security!=0{return Err(Failure::UnsupportedSecurity);}unsafe{Self::spawn_inner(label,request,start,parameter,report,std::ptr::null_mut())}
 }
 /// # Safety
 /// Same start/capsule contract as spawn, plus the supplied descriptor contract.
 pub unsafe fn spawn_with_security(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>,security:&mut Security<'_>)->Result<Self,Failure>{if request.security!=security.label{return Err(Failure::SecurityLabelMismatch);}unsafe{Self::spawn_inner(label,request,start,parameter,report,(&mut security.attributes as*mut Attributes).cast())}}
 unsafe fn spawn_inner(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>,security:*mut c_void)->Result<Self,Failure>{
  if label==0{return Err(Failure::InvalidLabel);}if request.entry!=0xc9c3dc{return Err(Failure::InvalidEntry);}
  let mut id=0;let handle=unsafe{CreateThread(security,request.stack_size as usize,Some(start),parameter,request.flags,&mut id)}as usize;let code=unsafe{GetLastError()};let _last=LastError(code);
  if handle==0{let error=Failure::Windows{operation:"CreateThread",code};report.fail(error.clone());return Err(error);}report.created.fetch_add(1,Ordering::AcqRel);Ok(Self{label,handle,id,report})
 }
 pub fn label(&self)->u32{self.label}pub fn id(&self)->u32{self.id}
 pub fn is_closed(&self)->bool{self.handle==0}
 /// Wait without the additional GetExitCodeThread query used by wait().
 /// True means signalled; false means timeout. Last-error is preserved.
 pub fn wait_only(&self,milliseconds:u32)->Result<bool,Failure>{let result=unsafe{WaitForSingleObject(self.handle as*mut c_void,milliseconds)};let _last=LastError(unsafe{GetLastError()});match result{0=>Ok(true),258=>Ok(false),u32::MAX=>Err(Failure::Windows{operation:"WaitForSingleObject",code:_last.0}),other=>Err(Failure::UnexpectedWait(other))}}
 /// Explicit native close. Ownership is cleared only after Windows success.
 pub fn close(&mut self)->Result<(),Failure>{let result=unsafe{CloseHandle(self.handle as*mut c_void)};let code=unsafe{GetLastError()};let _last=LastError(code);if result==0{let error=Failure::Windows{operation:"CloseHandle",code};self.report.fail(error.clone());Err(error)}else{self.handle=0;self.report.closed.fetch_add(1,Ordering::AcqRel);Ok(())}}
 pub fn resume(&self)->Result<u32,Failure>{let result=unsafe{ResumeThread(self.handle as*mut c_void)};let _last=LastError(unsafe{GetLastError()});if result==u32::MAX{Err(Failure::Windows{operation:"ResumeThread",code:_last.0})}else{Ok(result)}}
 pub fn wait(&self,milliseconds:u32)->Result<Wait,Failure>{let result=unsafe{WaitForSingleObject(self.handle as*mut c_void,milliseconds)};let _last=LastError(unsafe{GetLastError()});match result{0=>{let mut code=0;if unsafe{GetExitCodeThread(self.handle as*mut c_void,&mut code)}==0{return Err(Failure::Windows{operation:"GetExitCodeThread",code:unsafe{GetLastError()}});}Ok(Wait::Exited(code))},258=>Ok(Wait::Timeout),u32::MAX=>Err(Failure::Windows{operation:"WaitForSingleObject",code:_last.0}),other=>Err(Failure::UnexpectedWait(other))}}
}
impl Drop for Thread{fn drop(&mut self){let _last=LastError(unsafe{GetLastError()});if self.handle!=0{let _=self.close();}}}
#[cfg(test)]mod tests{
 use super::*;
 unsafe extern "system" fn start(_:*mut c_void)->u32{97}
 #[test]fn audio_windows_worker_thread_owns_full_width_handle_suspended_start_timeout_resume_exit_code_and_exactly_one_close(){let report=Arc::new(Report::default());let request=ThreadRequest{security:0,stack_size:0,entry:0xc9c3dc,packet:0,flags:4,thread_id_output:0};let thread=unsafe{Thread::spawn(0x73000000,request,start,std::ptr::null_mut(),report.clone())}.unwrap();assert_eq!(thread.label(),0x73000000);assert_ne!(thread.id(),0);assert_eq!(thread.wait(0).unwrap(),Wait::Timeout);assert_eq!(thread.resume().unwrap(),1);assert_eq!(thread.wait(5000).unwrap(),Wait::Exited(97));assert_eq!(thread.wait(0).unwrap(),Wait::Exited(97));assert_eq!((report.created(),report.closed()),(1,0));unsafe{SetLastError(73)};drop(thread);assert_eq!(unsafe{GetLastError()},73);assert_eq!((report.created(),report.closed()),(1,1));assert!(report.failures().is_empty());}
}

#[cfg(test)]mod security_tests{
 use super::*;
 unsafe extern "system" fn start(_:*mut c_void)->u32{97}
 #[test]fn audio_windows_worker_security_borrow_checks_label_and_native_layout_then_accepts_revision1_descriptor_suspended_wait_resume_and_owned_close(){let mut descriptor=[0u8;40];descriptor[0]=1;let mut security=unsafe{Security::from_descriptor(0x74000000,&mut descriptor,false)}.unwrap();assert_eq!(security.attributes.length,if cfg!(target_pointer_width="64"){24}else{12});let report=Arc::new(Report::default());let request=ThreadRequest{security:0x74000000,stack_size:0,entry:0xc9c3dc,packet:0,flags:4,thread_id_output:0};let mut mismatch=request;mismatch.security=0x74000010;assert!(matches!(unsafe{Thread::spawn_with_security(0x73000000,mismatch,start,std::ptr::null_mut(),report.clone(),&mut security)},Err(Failure::SecurityLabelMismatch)));assert_eq!((report.created(),report.closed()),(0,0));let thread=unsafe{Thread::spawn_with_security(0x73000000,request,start,std::ptr::null_mut(),report.clone(),&mut security)}.unwrap();assert_eq!(thread.wait(0).unwrap(),Wait::Timeout);assert_eq!(thread.resume().unwrap(),1);assert_eq!(thread.wait(5000).unwrap(),Wait::Exited(97));drop(thread);assert_eq!((report.created(),report.closed()),(1,1));assert!(report.failures().is_empty());}
}
