from pathlib import Path
import json,subprocess,hashlib,datetime
r=Path('E:/OpenLeague');out=r/'tools/hardware/windows_shared_fls_native_pair';out.mkdir(parents=True,exist_ok=True)
p=json.loads((r/'data/4.20/audio_crt_paired_thread_lifetime_preparation.json').read_text());regions=p['regions'];files=[]
for i,row in enumerate(p['cases']):
 lines=[]
 for kind,bank in [('I',row['after_second_constructor']),('F',row['before_cleanup'])]:
  for region in regions:lines.append(f"{kind}\t{region['reference']:x}\t{bank[region['name']]}")
 for cb in row['callbacks']:
  lines.append(f"R\t{cb['record']:x}")
  for c in cb['calls']:
   kinds={'EnterCriticalSection':'E','LeaveCriticalSection':'L','free':'F'};assert c['kind']in kinds
   lines.append(f"S\t{kinds[c['kind']]}\t{c['arguments'][0]:x}")
   for region in regions:lines.append(f"B\t{region['reference']:x}\t{c['at_call'][region['name']]}")
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
s=(r/'tools/hardware/windows_shared_fls_component/probe.rs').read_text();s=s[:s.index('struct SharedApi{')]
s+=r'''
struct SharedApi{steps:Vec<Step>,index:usize,events:Vec<(u32,u32)>}
impl SharedApi{fn event(&mut self,kind:&str,reference:u32,m:&BTreeMap<u32,Memory>){let expected=&self.steps[self.index];assert_eq!(kind,expected.kind);assert_eq!(reference,expected.reference);check(m,&expected.bank);self.index+=1;if kind=="F"{self.events.push((reference,unsafe{GetCurrentThreadId()}));}}}
impl audio_global_float_default_power::Windows for SharedApi{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,e:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(e)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("unexpected lookup"))}
 fn thread_lock(&mut self,r:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event(if enter{"E"}else{"L"},r,m);Ok(())}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event("F",r,m);Ok(())}
}
impl audio_crt_thread_destructor::Services for SharedApi{}
#[link(name="kernel32")]unsafe extern "system"{fn GetCurrentThreadId()->u32;}
fn main(){
 use audio_crt_windows_fls_slot::Context;use audio_crt_windows_shared_fls::{SharedContext,SharedSlot};
 let directory=std::env::args().nth(1).unwrap();let mut total=0;
 for i in 0..24{for natural in [false,true]{
  let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut initial=Bank::new();let mut final_bank=Bank::new();let mut steps:Vec<Step>=vec![];let mut records=vec![];
  for line in text.lines(){let f=line.split('\t').collect::<Vec<_>>();match f[0]{"I"=>{initial.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"F"=>{final_bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"R"=>records.push(u32::from_str_radix(f[1],16).unwrap()),"S"=>steps.push(Step{kind:f[1].into(),reference:u32::from_str_radix(f[2],16).unwrap(),bank:Bank::new()}),"B"=>{steps.last_mut().unwrap().bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},_=>panic!("unknown row")}}
  let context=Arc::new(SharedContext::new(Context{memory:initial.into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect(),dead:BTreeSet::new(),services:SharedApi{steps,index:0,events:vec![]}}));
  let slot=SharedSlot::<SharedApi>::new().unwrap();let report=slot.report();let mut workers=vec![];let mut ready=vec![];
  // Sequential registration/exit makes the observed OS callback order reviewable.
  for &record in &records{
   let (tx,rx)=std::sync::mpsc::channel();let (ready_tx,ready_rx)=std::sync::mpsc::channel();let worker_slot=slot.clone();let worker_context=context.clone();
   let worker=std::thread::spawn(move||{assert_eq!(worker_slot.value().unwrap(),0);worker_slot.bind_current(worker_context,record).unwrap();assert_eq!(worker_slot.value().unwrap(),record);ready_tx.send(unsafe{GetCurrentThreadId()}).unwrap();rx.recv().unwrap();});
   ready.push(ready_rx.recv().unwrap());workers.push((tx,worker));
  }
  assert_eq!(slot.value().unwrap(),0);if !natural{slot.close().unwrap();assert_eq!(report.completed(),2);}
  for (tx,worker) in workers{tx.send(()).unwrap();worker.join().unwrap();}
  slot.close().unwrap();slot.close().unwrap();assert_eq!(report.attempts(),2);assert_eq!(report.completed(),2);assert_eq!(report.failure(),None);
  context.with(|state|{check(&state.memory,&final_bank);assert_eq!(state.dead,BTreeSet::from([0x40012000,0x40013000]));assert_eq!(state.services.index,state.services.steps.len());assert_eq!(state.services.events.len(),2);for (j,(record,thread))in state.services.events.iter().enumerate(){assert_eq!(*record,records[j]);assert_eq!(*thread,if natural{ready[j]}else{unsafe{GetCurrentThreadId()}});}}).unwrap();total+=1;
 }}
 println!("PASS {total} paired native-bank shared production FLS cases; all callback service entry bytes, exact order, final globals and record ownership match; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''

for module in ['audio_crt_windows_dispatch_resolver', 'audio_crt_global_dispatch_initialization', 'audio_crt_static_lock_startup', 'audio_crt_tls_slot_wrappers', 'audio_crt_thread_system_startup']:
 s+='\n#[path="E:/OpenLeague/crates/core/src/'+module+'.rs"] mod '+module+';\n'
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files.append(probe);results=[]
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr
 run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=40);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;assert f'pointer_width={width}'in run.stdout;print(run.stdout.strip());results.append({'target':target,'pointer_width':width,'cases':48,'passed':True});files.extend([exe,log])
files.extend(r/'crates/core/src'/f for f in ['audio_crt_windows_fls_slot.rs','audio_crt_windows_shared_fls.rs','audio_crt_thread_context.rs','audio_crt_thread_destructor.rs','audio_crt_fls_callback.rs','audio_crt_custom_locale_destructor.rs']);files.append(r/'data/4.20/audio_crt_paired_thread_lifetime_preparation.json')
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'actual_windows_shared_fls_native_pair_cases':96,'native_paired_context_cases':24,'runs':results,'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest()for p in files},'limits':['Real shared production FLS callback and destructor executes on x86/x64 Windows; 24 original paired captures replayed through natural worker exit and global close. All callback lock/free entry bytes, exact physical free identities, final canonical banks and callback thread identity match. Sequential registration/exits qualify both orders; order not treated as a portable OS guarantee.','Canonical contexts initialized by original native captures; constructor source independently exercised in companion probe. Isolated type facades and explicit lock/heap effects remain. Full core tests recorded separately; normal startup/client audio worker integration, arbitrary fiber migration and SEH remain open.']}
(r/'docs/audio_windows_shared_fls_native_pair_hardware_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_windows_shared_fls_native_pair.py').write_text(Path(__file__).read_text(),encoding='utf-8')
