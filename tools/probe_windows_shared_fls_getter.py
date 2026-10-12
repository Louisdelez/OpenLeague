from pathlib import Path
import json,subprocess,hashlib,datetime
r=Path('E:/OpenLeague');out=r/'tools/hardware/windows_shared_fls_getter';out.mkdir(parents=True,exist_ok=True);p=json.loads((r/'data/4.20/audio_crt_paired_thread_lifetime_preparation.json').read_text());rows=[v for v in p['cases']if v['layout']=='all'and not v['reverse']];assert len(rows)==6;files=[]
for i,row in enumerate(rows):
 lines=[]
 for kind,bank in [('I',row['after_startup']),('E',row['after_second_constructor']),('F',row['before_cleanup'])]:
  for region in p['regions']:lines.append(f"{kind}\t{region['reference']:x}\t{bank[region['name']]}")
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
s=(r/'tools/hardware/windows_shared_fls_component/probe.rs').read_text();s=s[:s.index('struct SharedApi{')]
s+=r'''
#[repr(C)]struct NativeCS{debug:*mut c_void,lock:i32,recursion:i32,owner:*mut c_void,semaphore:*mut c_void,spin:usize}
// Only moved as a Box before initialization; all use is serialized by SharedContext.
unsafe impl Send for NativeCS{}
#[link(name="kernel32")]unsafe extern "system"{fn GetCurrentThreadId()->u32;fn InitializeCriticalSectionEx(p:*mut NativeCS,spin:u32,flags:u32)->i32;fn EnterCriticalSection(p:*mut NativeCS);fn LeaveCriticalSection(p:*mut NativeCS);fn DeleteCriticalSection(p:*mut NativeCS);}
struct SharedApi{locks:BTreeMap<u32,Box<NativeCS>>,held:BTreeMap<u32,u32>,freed:Vec<u32>,allocation_failure:bool}
impl SharedApi{fn new(m:&BTreeMap<u32,Memory>)->Self{assert_eq!(std::mem::size_of::<NativeCS>(),if std::mem::size_of::<usize>()==4{24}else{40});let mut locks=BTreeMap::new();for j in [12,13]{let reference=u32::from_le_bytes(audio_path_memory::read(m,0x1223580+j*8,4).unwrap().try_into().unwrap());let mut raw=Box::new(NativeCS{debug:std::ptr::null_mut(),lock:0,recursion:0,owner:std::ptr::null_mut(),semaphore:std::ptr::null_mut(),spin:0});assert_ne!(unsafe{InitializeCriticalSectionEx(&mut*raw,4000,0)},0);locks.insert(reference,raw);}Self{locks,held:BTreeMap::new(),freed:vec![],allocation_failure:false}}}
impl Drop for SharedApi{fn drop(&mut self){assert!(self.held.values().all(|v|*v==0));for lock in self.locks.values_mut(){unsafe{DeleteCriticalSection(&mut**lock)};}}}
impl audio_global_float_default_power::Windows for SharedApi{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,e:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(e)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("must use actual FLS adapter"))}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!((n,z),(1,0x3bc));if self.allocation_failure{return Ok(None);}m.get_mut(&0x40013000).unwrap().raw.fill(0);Ok(Some(0x40013000))}
 fn current_thread_id(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetCurrentThreadId()})}
 fn thread_lock(&mut self,r:u32,enter:bool,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{let raw=&mut**self.locks.get_mut(&r).unwrap();if enter{unsafe{EnterCriticalSection(raw)};*self.held.entry(r).or_default()+=1;}else{let depth=self.held.get_mut(&r).unwrap();assert!(*depth>0);*depth-=1;unsafe{LeaveCriticalSection(raw)};}Ok(())}
 fn free_thread(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.freed.push(r);Ok(())}
}
impl audio_crt_thread_destructor::Services for SharedApi{}
fn normalized_check(m:&BTreeMap<u32,Memory>,bank:&Bank){for(a,raw)in bank{for(j,v)in raw.iter().enumerate(){let at=*a+j as u32;let byte=if (0x12230cc..0x12230d0).contains(&at){5u32.to_le_bytes()[(at-0x12230cc)as usize]}else if(0x40013000..0x40013004).contains(&at){456u32.to_le_bytes()[(at-0x40013000)as usize]}else{audio_path_memory::read(m,at,1).unwrap()[0]};assert_eq!(byte,*v,"native byte {at:x}");}}}
fn main(){use audio_crt_windows_fls_slot::Context;use audio_crt_windows_shared_fls::{SharedContext,SharedSlot,ValueDispatch};let directory=std::env::args().nth(1).unwrap();let mut total=0;
 for i in 0..6{
  let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut initial=Bank::new();let mut expected=Bank::new();let mut final_bank=Bank::new();for line in text.lines(){let f=line.split('\t').collect::<Vec<_>>();let bank=match f[0]{"I"=>&mut initial,"E"=>&mut expected,"F"=>&mut final_bank,_=>panic!("bad kind")};bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));}
  let memory=initial.into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect();let services=SharedApi::new(&memory);let context=Arc::new(SharedContext::new(Context{memory,dead:BTreeSet::new(),services}));let slot=SharedSlot::<SharedApi>::new().unwrap();slot.publish_index(&context).unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();let dispatch=ValueDispatch{get:0x40004020,set:0x40004030};unsafe{SetLastError(97)};assert_eq!(slot.get_or_create_current(context.clone(),dispatch).unwrap(),0x40012000);assert_eq!(unsafe{GetLastError()},97);
  let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{unsafe{SetLastError(97)};assert_eq!(s.get_or_create_current(c.clone(),dispatch).unwrap(),0x40013000);assert_eq!(unsafe{GetLastError()},97);assert_eq!(s.get_or_create_current(c,dispatch).unwrap(),0x40013000);assert_eq!(unsafe{GetLastError()},97);ready.send(unsafe{GetCurrentThreadId()}).unwrap();rx.recv().unwrap();});let worker_id=wait.recv().unwrap();context.with(|c|{normalized_check(&c.memory,&expected);assert_eq!(u32::from_le_bytes(audio_path_memory::read(&c.memory,0x40013000,4).unwrap().try_into().unwrap()),worker_id);assert_eq!(u32::from_le_bytes(audio_path_memory::read(&c.memory,0x12230cc,4).unwrap().try_into().unwrap()),0.max(unsafe{FlsGetValue(0)}as usize as u32));}).err();
  // Canonical index is checked by get_or_create_current; do not compare to a fixed OS index.
  context.with(|c|normalized_check(&c.memory,&expected)).unwrap();slot.close().unwrap();tx.send(()).unwrap();worker.join().unwrap();assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(2,2,None));context.with(|c|{normalized_check(&c.memory,&final_bank);assert_eq!(c.dead,BTreeSet::from([0x40012000,0x40013000]));assert_eq!(c.services.freed,vec![0x40012000,0x40013000]);}).unwrap();total+=1;
 }
 println!("PASS {total} shared production FLS getter/constructor cases with actual Windows critical sections; native banks normalize only OS index/thread ID; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
# Actual index is deliberately unconstrained by hardware; remove accidental fixed-index assertion.
s=s.replace('assert_eq!(u32::from_le_bytes(audio_path_memory::read(&c.memory,0x12230cc,4).unwrap().try_into().unwrap()),0.max(unsafe{FlsGetValue(0)}as usize as u32));','').replace('}).err();','}).unwrap();')

for module in ['audio_crt_windows_dispatch_resolver', 'audio_crt_global_dispatch_initialization', 'audio_crt_static_lock_startup', 'audio_crt_tls_slot_wrappers', 'audio_crt_thread_system_startup']:
 s+='\n#[path="E:/OpenLeague/crates/core/src/'+module+'.rs"] mod '+module+';\n'
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files.append(probe);results=[]
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr
 run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=40);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;assert f'pointer_width={width}'in run.stdout;print(run.stdout.strip());results.append({'target':target,'pointer_width':width,'cases':6,'passed':True});files.extend([exe,log])
files.extend(r/'crates/core/src'/f for f in ['audio_crt_windows_shared_fls.rs','audio_crt_windows_fls_slot.rs','audio_crt_thread_context.rs','audio_crt_thread_destructor.rs','audio_crt_tls_value_wrappers.rs']);files.append(r/'data/4.20/audio_crt_paired_thread_lifetime_preparation.json')
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'actual_windows_shared_fls_getter_cases':12,'actual_windows_critical_sections_used':True,'runs':results,'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest()for p in files},'limits':['Unchanged production shared slot/getter/constructor/destructor executed in x86/x64 processes. Native paired banks match after second-context creation and retirement; only actual OS slot index and second-thread ID normalized. Actual current thread ID separately checked. Existing getter returns original record without extra allocation and LastError97 is restored.','Actual Windows critical sections initialized with spin4000 flags0, enter/leave operations used by constructors/destructors and deleted after balanced release. Native canonical opaque bytes retain captures; real OS objects reside in separate host storage. This is an isolated explicit service provider, not yet production lock-bank/bootstrap integration.','Heap allocation/free boundary remains canonical memory adapter; normal client/worker connection, full root startup, static/dynamic lock lifecycle, security cookie and SEH not qualified.']}
(r/'docs/audio_windows_shared_fls_getter_hardware_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_windows_shared_fls_getter.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
