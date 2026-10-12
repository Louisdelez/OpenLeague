from pathlib import Path
r=Path('E:/OpenLeague');b=r/'crates/core/src'
s='''//! Owned actual CreateThread handle, independent of the PE32 canonical label.
use std::{ffi::c_void,sync::{Arc,Mutex,atomic::{AtomicUsize,Ordering}}};
use crate::audio_crt_worker_packet::ThreadRequest;
#[link(name="kernel32")]unsafe extern "system"{fn CreateThread(security:*mut c_void,stack:usize,start:Option<unsafe extern "system" fn(*mut c_void)->u32>,parameter:*mut c_void,flags:u32,id:*mut u32)->*mut c_void;fn ResumeThread(handle:*mut c_void)->u32;fn WaitForSingleObject(handle:*mut c_void,milliseconds:u32)->u32;fn GetExitCodeThread(handle:*mut c_void,code:*mut u32)->i32;fn CloseHandle(handle:*mut c_void)->i32;fn GetLastError()->u32;fn SetLastError(code:u32);}
struct LastError(u32);impl Drop for LastError{fn drop(&mut self){unsafe{SetLastError(self.0)}}}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{InvalidLabel,InvalidEntry,UnsupportedSecurity,Windows{operation:&'static str,code:u32},UnexpectedWait(u32)}
#[derive(Default)]pub struct Report{created:AtomicUsize,closed:AtomicUsize,failures:Mutex<Vec<Failure>>}
impl Report{pub fn created(&self)->usize{self.created.load(Ordering::Acquire)}pub fn closed(&self)->usize{self.closed.load(Ordering::Acquire)}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}fn fail(&self,f:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(f);}}
#[derive(Debug,PartialEq,Eq)]pub enum Wait{Timeout,Exited(u32)}
pub struct Thread{label:u32,handle:usize,id:u32,report:Arc<Report>}
impl Thread{
 /// # Safety
 /// Start and capsule must remain valid through OS thread completion. Start must
 /// not unwind across its system ABI. Caller reclaims capsule on creation failure.
 pub unsafe fn spawn(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>)->Result<Self,Failure>{
  if label==0{return Err(Failure::InvalidLabel);}if request.entry!=0xc9c3dc{return Err(Failure::InvalidEntry);}if request.security!=0{return Err(Failure::UnsupportedSecurity);}
  let mut id=0;let handle=unsafe{CreateThread(std::ptr::null_mut(),request.stack_size as usize,Some(start),parameter,request.flags,&mut id)}as usize;let code=unsafe{GetLastError()};let _last=LastError(code);
  if handle==0{let error=Failure::Windows{operation:"CreateThread",code};report.fail(error.clone());return Err(error);}report.created.fetch_add(1,Ordering::AcqRel);Ok(Self{label,handle,id,report})
 }
 pub fn label(&self)->u32{self.label}pub fn id(&self)->u32{self.id}
 pub fn resume(&self)->Result<u32,Failure>{let result=unsafe{ResumeThread(self.handle as*mut c_void)};let _last=LastError(unsafe{GetLastError()});if result==u32::MAX{Err(Failure::Windows{operation:"ResumeThread",code:_last.0})}else{Ok(result)}}
 pub fn wait(&self,milliseconds:u32)->Result<Wait,Failure>{let result=unsafe{WaitForSingleObject(self.handle as*mut c_void,milliseconds)};let _last=LastError(unsafe{GetLastError()});match result{0=>{let mut code=0;if unsafe{GetExitCodeThread(self.handle as*mut c_void,&mut code)}==0{return Err(Failure::Windows{operation:"GetExitCodeThread",code:unsafe{GetLastError()}});}Ok(Wait::Exited(code))},258=>Ok(Wait::Timeout),u32::MAX=>Err(Failure::Windows{operation:"WaitForSingleObject",code:_last.0}),other=>Err(Failure::UnexpectedWait(other))}}
}
impl Drop for Thread{fn drop(&mut self){let _last=LastError(unsafe{GetLastError()});if unsafe{CloseHandle(self.handle as*mut c_void)}==0{self.report.fail(Failure::Windows{operation:"CloseHandle",code:unsafe{GetLastError()}});}else{self.report.closed.fetch_add(1,Ordering::AcqRel);}}}
#[cfg(test)]mod tests{
 use super::*;
 unsafe extern "system" fn start(_:*mut c_void)->u32{97}
 #[test]fn audio_windows_worker_thread_owns_full_width_handle_suspended_start_timeout_resume_exit_code_and_exactly_one_close(){let report=Arc::new(Report::default());let request=ThreadRequest{security:0,stack_size:0,entry:0xc9c3dc,packet:0,flags:4,thread_id_output:0};let thread=unsafe{Thread::spawn(0x73000000,request,start,std::ptr::null_mut(),report.clone())}.unwrap();assert_eq!(thread.label(),0x73000000);assert_ne!(thread.id(),0);assert_eq!(thread.wait(0).unwrap(),Wait::Timeout);assert_eq!(thread.resume().unwrap(),1);assert_eq!(thread.wait(5000).unwrap(),Wait::Exited(97));assert_eq!(thread.wait(0).unwrap(),Wait::Exited(97));assert_eq!((report.created(),report.closed()),(1,0));unsafe{SetLastError(73)};drop(thread);assert_eq!(unsafe{GetLastError()},73);assert_eq!((report.created(),report.closed()),(1,1));assert!(report.failures().is_empty());}
}
'''
(b/'audio_crt_windows_worker_thread.rs').write_text(s,encoding='utf-8');p=b/'lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_windows_worker_thread;'not in s;p.write_text(s+'\n#[cfg(windows)]pub mod audio_crt_windows_worker_thread;\n',encoding='utf-8');(r/'tools/install_audio_windows_worker_thread.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Installed owned typed Windows thread handle/wait/resume/close adapter')
