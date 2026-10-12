from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_worker_thread.rs';s=p.read_text(encoding='utf-8')
s=s.replace('UnexpectedWait(u32)}','UnexpectedWait(u32),InvalidSecurityBuffer,SecurityLabelMismatch}')
needle='pub struct Thread{';assert needle in s
s=s.replace(needle,'''#[repr(C)]struct Attributes{length:u32,descriptor:*mut c_void,inherit:i32}
/// A canonical security label owns a borrow of a full-width descriptor buffer.
pub struct Security<'a>{label:u32,attributes:Attributes,_descriptor:std::marker::PhantomData<&'a mut[u8]>}
impl<'a> Security<'a>{
 /// # Safety
 /// Buffer must remain a readable Windows SECURITY_DESCRIPTOR during the call.
 /// Any pointer-bearing fields must refer to live readable owned data. Malformed
 /// descriptor contents may be rejected by Windows; labels are never cast to pointers.
 pub unsafe fn from_descriptor(label:u32,buffer:&'a mut[u8],inherit:bool)->Result<Self,Failure>{if label==0{return Err(Failure::InvalidLabel);}if buffer.len()<if cfg!(target_pointer_width="64"){40}else{20}{return Err(Failure::InvalidSecurityBuffer);}Ok(Self{label,attributes:Attributes{length:std::mem::size_of::<Attributes>()as u32,descriptor:buffer.as_mut_ptr().cast(),inherit:i32::from(inherit)},_descriptor:std::marker::PhantomData})}
}
pub struct Thread{''')
needle='''  if label==0{return Err(Failure::InvalidLabel);}if request.entry!=0xc9c3dc{return Err(Failure::InvalidEntry);}if request.security!=0{return Err(Failure::UnsupportedSecurity);}
  let mut id=0;let handle=unsafe{CreateThread(std::ptr::null_mut(),request.stack_size as usize,Some(start),parameter,request.flags,&mut id)}as usize;'''
assert needle in s
s=s.replace(needle,'''  if request.security!=0{return Err(Failure::UnsupportedSecurity);}unsafe{Self::spawn_inner(label,request,start,parameter,report,std::ptr::null_mut())}
 }
 /// # Safety
 /// Same start/capsule contract as spawn, plus the supplied descriptor contract.
 pub unsafe fn spawn_with_security(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>,security:&mut Security<'_>)->Result<Self,Failure>{if request.security!=security.label{return Err(Failure::SecurityLabelMismatch);}unsafe{Self::spawn_inner(label,request,start,parameter,report,(&mut security.attributes as*mut Attributes).cast())}}
 unsafe fn spawn_inner(label:u32,request:ThreadRequest,start:unsafe extern "system" fn(*mut c_void)->u32,parameter:*mut c_void,report:Arc<Report>,security:*mut c_void)->Result<Self,Failure>{
  if label==0{return Err(Failure::InvalidLabel);}if request.entry!=0xc9c3dc{return Err(Failure::InvalidEntry);}
  let mut id=0;let handle=unsafe{CreateThread(security,request.stack_size as usize,Some(start),parameter,request.flags,&mut id)}as usize;''')
p.write_text(s,encoding='utf-8');(r/'tools/add_audio_thread_security_adapter.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Added typed borrowed security descriptor ABI without narrowing host pointers')
