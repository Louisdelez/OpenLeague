from pathlib import Path
import subprocess
r=Path('E:/OpenLeague');out=r/'tools/hardware/security_failure';out.mkdir(parents=True,exist_ok=True)
s='''use std::{ffi::c_void,sync::Arc};
mod audio_crt_worker_packet{#[derive(Clone,Copy)]pub struct ThreadRequest{pub security:u32,pub stack_size:u32,pub entry:u32,pub packet:u32,pub flags:u32,pub thread_id_output:u32}}
#[path="E:/OpenLeague/crates/core/src/audio_crt_windows_worker_thread.rs"]mod worker;
unsafe extern "system" fn start(_:*mut c_void)->u32{0}
fn main(){let report=Arc::new(worker::Report::default());let mut descriptor=[0u8;40];let mut security=unsafe{worker::Security::from_descriptor(0x74000000,&mut descriptor,false)}.unwrap();let request=audio_crt_worker_packet::ThreadRequest{security:0x74000000,stack_size:0,entry:0xc9c3dc,packet:0,flags:4,thread_id_output:0};match unsafe{worker::Thread::spawn_with_security(0x73000000,request,start,std::ptr::null_mut(),report.clone(),&mut security)}{Ok(t)=>{println!("descriptor revision0 accepted");t.resume().unwrap();assert_eq!(t.wait(5000).unwrap(),worker::Wait::Exited(0));drop(t);},Err(e)=>println!("actual descriptor revision0 failure {e:?}")};println!("created={} closed={} report={:?}",report.created(),report.closed(),report.failures());}
''';probe=out/'probe.rs';probe.write_text(s,encoding='utf-8')
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';b=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(b.stdout+b.stderr,encoding='utf-8');assert b.returncode==0,b.stderr;b=subprocess.run([str(exe)],capture_output=True,text=True,timeout=20);log.write_text(log.read_text(encoding='utf-8')+b.stdout+b.stderr,encoding='utf-8');assert b.returncode==0,b.stderr;print(width,b.stdout)
(r/'tools/probe_audio_security_failure.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
