from pathlib import Path
import subprocess,json,hashlib,datetime
r=Path('E:/OpenLeague');out=r/'tools/hardware/windows_shared_fls_component';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/fls_rust_destructor/probe.rs').read_text()
a=s.index('mod audio_crt_thread_context{');b=s.index('#[path=',a)
s=s[:a]+'#[path="E:/OpenLeague/crates/core/src/audio_crt_thread_context.rs"] mod audio_crt_thread_context;\n'+s[b:]
s=s[:s.index('fn main(){')]
s+='\n#[path="E:/OpenLeague/crates/core/src/audio_crt_windows_fls_slot.rs"] mod audio_crt_windows_fls_slot;\n#[path="E:/OpenLeague/crates/core/src/audio_crt_windows_shared_fls.rs"] mod audio_crt_windows_shared_fls;\n'
s+=r'''
struct SharedApi{events:Vec<(String,u32,u32)>}
impl audio_global_float_default_power::Windows for SharedApi{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,e:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(e)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("unexpected lookup"))}
 fn thread_lock(&mut self,r:u32,enter:bool,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.events.push((if enter{"E"}else{"L"}.into(),r,unsafe{GetCurrentThreadId()}));Ok(())}
 fn free_thread(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.events.push(("F".into(),r,unsafe{GetCurrentThreadId()}));Ok(())}
}
impl audio_crt_thread_destructor::Services for SharedApi{}
#[link(name="kernel32")]unsafe extern "system"{fn GetCurrentThreadId()->u32;}
fn main(){
 use audio_crt_windows_fls_slot::Context;use audio_crt_windows_shared_fls::{SharedContext,SharedSlot};
 let directory=std::env::args().nth(1).unwrap();let mut total=0;
 for i in 0..12{
  let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut initial=Bank::new();let mut final_bank=Bank::new();let mut expected=vec![];
  for line in text.lines(){let f=line.split('\t').collect::<Vec<_>>();match f[0]{"I"=>{initial.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"F"=>{final_bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"S"=>expected.push((f[1].to_string(),u32::from_str_radix(f[2],16).unwrap())),_=>{}}}
  if expected.is_empty(){continue;}
  for natural in [false,true]{
   let mut m:BTreeMap<u32,Memory>=initial.into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect();
   let second=0x50000000; m.insert(second,Memory{reference:second,raw:vec![0;0x3bc]});let mut dead=BTreeSet::new();let mut api=SharedApi{events:vec![]};
   // The second context is initialized by the production CA9218 reconstruction,
   // incrementing the SAME captured global counts. No independent global bank copy.
   audio_crt_thread_context::initialize(&mut m,&mut dead,second,&mut api).unwrap();api.events.clear();
   let context=Arc::new(SharedContext::new(Context{memory:m,dead,services:api}));let slot=SharedSlot::<SharedApi>::new().unwrap();let report=slot.report();
   let (ready_tx,ready_rx)=std::sync::mpsc::channel();let mut exits=vec![];let mut workers=vec![];
   for record in [0x40012000,second]{let (tx,rx)=std::sync::mpsc::channel();exits.push(tx);let ready=ready_tx.clone();let slot=slot.clone();let context=context.clone();workers.push(std::thread::spawn(move||{
    assert_eq!(slot.value().unwrap(),0);slot.bind_current(context.clone(),record).unwrap();assert_eq!(slot.value().unwrap(),record);
    assert_eq!(slot.bind_current(context,record),Err(audio_crt_windows_fls_slot::Failure::Occupied));
    ready.send((record,unsafe{GetCurrentThreadId()})).unwrap();rx.recv().unwrap();
   }));}
   let ready=[ready_rx.recv().unwrap(),ready_rx.recv().unwrap()];assert_eq!(slot.value().unwrap(),0);
   if !natural{slot.close().unwrap();assert_eq!(report.completed(),2);}
   // Natural mode: release both concurrently, exercising shared count synchronization.
   for tx in exits{tx.send(()).unwrap();}for worker in workers{worker.join().unwrap();}
   slot.close().unwrap();slot.close().unwrap();assert_eq!(report.completed(),2);assert_eq!(report.attempts(),2);assert_eq!(report.failure(),None);
   assert_eq!(slot.value(),Err(audio_crt_windows_fls_slot::Failure::Closed));
   context.with(|state|{
    check(&state.memory,&final_bank);assert_eq!(state.dead,BTreeSet::from([0x40012000,second]));
    let events=&state.services.events;assert_eq!(events.len(),expected.len()*2);
    let mut freed=vec![];for chunk in events.chunks(expected.len()){
     let record=chunk.last().unwrap().1;freed.push(record);let callback_thread=if natural{ready.iter().find(|(r,_)|*r==record).unwrap().1}else{unsafe{GetCurrentThreadId()}};
     for ((kind,reference,thread),(ek,er)) in chunk.iter().zip(&expected){assert_eq!(kind,ek);assert_eq!(*reference,if *er==0x40012000{record}else{*er});assert_eq!(*thread,callback_thread);}
    }freed.sort();assert_eq!(freed,vec![0x40012000,second]);
   }).unwrap();total+=1;
  }
 }
 // Same-thread held context failure must return rather than deadlock/release falsely.
 let context=Arc::new(SharedContext::new(Context{memory:BTreeMap::new(),dead:BTreeSet::new(),services:SharedApi{events:vec![]}}));
 context.with(|_|assert_eq!(context.with(|_|()),Err(audio_crt_windows_fls_slot::Failure::StateBusy))).unwrap();
 println!("PASS {total} shared production Windows FLS cases; paired production initialization/destruction, same global counts, callback affinity, exact native final bank, two records freed once; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
# input bank must be cloned once per independently executed scenario.
s=s.replace('initial.into_iter().map','initial.clone().into_iter().map')

for module in ['audio_crt_windows_dispatch_resolver', 'audio_crt_global_dispatch_initialization', 'audio_crt_static_lock_startup', 'audio_crt_tls_slot_wrappers', 'audio_crt_thread_system_startup']:
 s+='\n#[path="E:/OpenLeague/crates/core/src/'+module+'.rs"] mod '+module+';\n'
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');results=[];files=[probe]
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr
 run=subprocess.run([str(exe),str(r/'tools/hardware/fls_rust_destructor')],capture_output=True,text=True,timeout=40);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;assert f'pointer_width={width}'in run.stdout;print(run.stdout.strip());results.append({'target':target,'pointer_width':width,'cases':12,'passed':True});files.extend([exe,log])
files.extend(r/'crates/core/src'/f for f in ['audio_crt_windows_fls_slot.rs','audio_crt_windows_shared_fls.rs','audio_crt_thread_context.rs','audio_crt_thread_destructor.rs','audio_crt_fls_callback.rs'])
files.extend((r/'tools/hardware/fls_rust_destructor').glob('case_*.tsv'))
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'actual_windows_shared_fls_component_cases':24,'runs':results,'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest()for p in files},'limits':['Production shared component, constructor and destructor executed in actual x86/x64 Windows processes. Same captured native globals are retained by second constructor and released by both real callbacks; final original single-context native bank matches after paired retirement.','Per-callback intermediate bank is not yet captured from original two-worker native execution. Supplied critical-section/heap service boundaries and isolated type facades remain; full core compile and normal audio integration pending.','Actual natural worker exit and global close both checked, callback thread identity, exact service order/free references and no duplicate callbacks after worker exit. Fiber migration and native SEH unqualified.']}
(r/'docs/audio_windows_shared_fls_component_hardware_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_windows_shared_fls_component.py').write_text(Path(__file__).read_text(),encoding='utf-8')
