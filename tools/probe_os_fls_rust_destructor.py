from pathlib import Path
import json,hashlib,subprocess,datetime
r=Path('E:/OpenLeague');out=r/'tools/hardware/fls_rust_destructor';out.mkdir(parents=True,exist_ok=True)
src=r/'crates/core/src'
rows=json.loads((r/'data/4.20/audio_crt_fls_slot_lifetime_preparation.json').read_text(encoding='utf-8'));regions={v['name']:v['reference']for v in rows['regions']}
selected=[v for v in rows['cases']if v['layout']=='all'and v['state']in['live','cleared']]
def bank(tag,b):return [f'{tag}\t{regions[n]:x}\t{raw}'for n,raw in b.items()]
inputs=[]
for i,row in enumerate(selected):
 lines=bank('I',row['before_cleanup']);lines+=bank('F',row['callbacks'][0]['after']if row['callbacks']else row['before_cleanup'])
 if row['callbacks']:
  start=next(j for j,v in enumerate(row['calls'])if v['kind']=='FlsFree')+1
  for v in row['calls'][start:]:
   if v['kind']=='DeleteCriticalSection':break
   kind={'EnterCriticalSection':'E','LeaveCriticalSection':'L','free':'F'}[v['kind']]
   lines.append(f'S\t{kind}\t{v["arguments"][0]:x}');lines+=bank('B',v['at_call'])
 p=out/f'case_{i}.tsv';p.write_text('\n'.join(lines)+'\n',encoding='utf-8');inputs.append(p)
windows=(src/'audio_global_float_default_power.rs').read_text(encoding='utf-8').split('pub trait Windows{',1)[1].split('#[cfg(target_arch',1)[0];windows='pub trait Windows{'+windows
memory=(src/'audio_path_source_virtual_cleanup.rs').read_text(encoding='utf-8').split('\nfn pw(',1)[0].replace('use crate::audio_path_voice_empty_source_release as empty;','')
lock=next(v for v in(src/'audio_crt_thread_context.rs').read_text(encoding='utf-8').splitlines()if v.startswith('pub(crate) fn lock('))
modules='\n'.join(f'#[path="{(src/n).as_posix()}"] mod {n[:-3]};'for n in ['audio_path_memory.rs','audio_crt_tls_value_wrappers.rs','audio_crt_custom_locale_destructor.rs','audio_crt_thread_destructor.rs','audio_crt_fls_callback.rs'])
code=r'''#![allow(dead_code)]
use std::{collections::{BTreeMap,BTreeSet},sync::{Arc,Mutex},ffi::c_void};
// Isolated probe type facades. Production algorithm sources below are compiled unchanged.
mod audio_bus_bank{#[derive(Debug)]pub enum Error{Backend(&'static str),InvalidAllocation,UnresolvedReference,Truncated}}
mod audio_plugin_factory{pub struct Memory{pub reference:u32,pub raw:Vec<u8>}}
mod audio_path_source_virtual_cleanup{@@MEMORY@@}
mod audio_global_float_default_power{use std::collections::{BTreeMap,BTreeSet};use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};@@WINDOWS@@}
mod audio_crt_thread_context{use std::collections::{BTreeMap,BTreeSet};use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};use crate::audio_path_source_virtual_cleanup::get;@@LOCK@@}
@@MODULES@@
use audio_plugin_factory::Memory;use audio_bus_bank::Error;
type Bank=BTreeMap<u32,Vec<u8>>;
fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn check(m:&BTreeMap<u32,Memory>,bank:&Bank){for(a,b)in bank{for(j,v)in b.iter().enumerate(){assert_eq!(audio_path_memory::read(m,a+j as u32,1).unwrap()[0],*v,"canonical byte at {:x}",a+j as u32);}}}
struct Step{kind:String,reference:u32,bank:Bank}
struct Api{steps:Vec<Step>,index:usize,freed:Vec<u32>}
impl Api{fn event(&mut self,kind:&str,reference:u32,m:&BTreeMap<u32,Memory>){let expected=&self.steps[self.index];assert_eq!(kind,expected.kind);assert_eq!(reference,expected.reference);check(m,&expected.bank);self.index+=1;}}
#[link(name="kernel32")]extern "system"{
 fn FlsAlloc(callback:Option<unsafe extern "system" fn(*mut c_void)>)->u32;
 fn FlsSetValue(slot:u32,value:*mut c_void)->i32;
 fn FlsGetValue(slot:u32)->*mut c_void;
 fn FlsFree(slot:u32)->i32;
 fn GetLastError()->u32;fn SetLastError(error:u32);
}
impl audio_global_float_default_power::Windows for Api{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,e:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(e)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("unexpected callback TLS lookup"))}
 // Lock and CRT heap effects are explicit boundary services in this OS callback probe.
 fn thread_lock(&mut self,r:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event(if enter{"E"}else{"L"},r,m);Ok(())}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event("F",r,m);self.freed.push(r);Ok(())}
}
impl audio_crt_thread_destructor::Services for Api{}
struct State{m:BTreeMap<u32,Memory>,dead:BTreeSet<u32>,api:Api,count:u32,error:Option<String>}
struct Data{state:Arc<Mutex<State>>,slot:u32}
unsafe extern "system" fn callback(pointer:*mut c_void){
 if pointer.is_null(){return;}
 let data=unsafe{Box::from_raw(pointer.cast::<Data>())};let owner=Arc::clone(&data.state);
 let result=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||{
  let saved=unsafe{GetLastError()};assert!(unsafe{FlsGetValue(data.slot)}.is_null());assert_eq!(unsafe{GetLastError()},0);unsafe{SetLastError(saved)};
  let mut state=data.state.lock().unwrap();let State{m,dead,api,..}=&mut*state;
  audio_crt_fls_callback::dispatch(Some(audio_crt_fls_callback::THREAD_DESTRUCTOR),0x40012000,m,dead,api).unwrap();state.count+=1;
 }));
 if result.is_err(){let mut state=owner.lock().unwrap_or_else(|p|p.into_inner());state.error=Some("callback panic contained at native ABI".into());}
 // The native callback payload Box drops here; observer retains the canonical state.
}
struct Slot(u32);impl Drop for Slot{fn drop(&mut self){if self.0!=u32::MAX{unsafe{FlsFree(self.0)};}}}
fn main(){
 let directory=std::env::args().nth(1).expect("input directory");let mut total=0;
 for i in 0..12{
  let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut initial=Bank::new();let mut final_bank=Bank::new();let mut steps:Vec<Step>=vec![];
  for line in text.lines(){let fields=line.split('\t').collect::<Vec<_>>();let r=u32::from_str_radix(fields[1],16);
   match fields[0]{"I"=>{initial.insert(r.unwrap(),bytes(fields[2]));},"F"=>{final_bank.insert(r.unwrap(),bytes(fields[2]));},"S"=>steps.push(Step{kind:fields[1].into(),reference:u32::from_str_radix(fields[2],16).unwrap(),bank:Bank::new()}),"B"=>{steps.last_mut().unwrap().bank.insert(r.unwrap(),bytes(fields[2]));},_=>panic!("bad input")}
  }
  let live=!steps.is_empty();let state=Arc::new(Mutex::new(State{m:initial.into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect(),dead:BTreeSet::new(),api:Api{steps,index:0,freed:vec![]},count:0,error:None}));
  let mut slot=Slot(unsafe{FlsAlloc(Some(callback))});assert_ne!(slot.0,u32::MAX);
  if live{let data=Box::into_raw(Box::new(Data{state:Arc::clone(&state),slot:slot.0}));if unsafe{FlsSetValue(slot.0,data.cast())}==0{unsafe{drop(Box::from_raw(data))};panic!("FlsSetValue failed");}}
  assert_ne!(unsafe{FlsFree(slot.0)},0);slot.0=u32::MAX;
  let state=state.lock().unwrap_or_else(|p|p.into_inner());assert!(state.error.is_none(),"{:?}",state.error);assert_eq!(state.count,u32::from(live));assert_eq!(state.api.index,state.api.steps.len());check(&state.m,&final_bank);assert_eq!(state.dead,if live{BTreeSet::from([0x40012000])}else{BTreeSet::new()});assert_eq!(state.api.freed,if live{vec![0x40012000]}else{vec![]});total+=1;
 }
 println!("PASS {total} actual Windows FLS -> production Rust destructor cases; native entry banks/order/final storage/free identities match; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
for key,value in [('MEMORY',memory),('WINDOWS',windows),('LOCK',lock),('MODULES',modules)]:code=code.replace('@@'+key+'@@',value)
probe=out/'probe.rs';probe.write_text(code,encoding='utf-8');exe=out/'probe.exe';log=out/'probe.log'
command=[str(Path('C:/Users/loicd/.cargo/bin/rustc.exe')),'--edition=2021','-C','debuginfo=0',str(probe),'-o',str(exe)]
build=subprocess.run(command,capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr
run=subprocess.run([str(exe),str(out)],capture_output=True,text=True);log.write_text(log.read_text(encoding='utf-8')+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'actual_windows_fls_rust_destructor_cases':12,'host_pointer_width':64,'live_callback_cases':6,'empty_slot_cases':6,'limits':['Actual Windows native FLS allocation/set/free invokes an externsystem Rust callback; the unchanged production callback dispatcher/thread destructor/locale release code executes. Native6live/6cleared canonical contexts and every actual destructor service-entry bank/free identity/final bank compared. ABI shim maps its actual boxed payload to the32bit canonical record identity and contains panics.','Isolated probe uses explicit Memory/Error type facades and original foundation functions; it is not the full core crate or normal client provider. Critical section and CRT heap service effects supplied and checked; actual callback envelope allocated/freed by Rust. No normal thread/fiber teardown/concurrency or actual original heap/security-cookie/bootstrap proof.'],'files_sha256':{str(p.relative_to(r)):sha(p)for p in [probe,exe,log,*inputs,*[src/n for n in ['audio_crt_fls_callback.rs','audio_crt_thread_destructor.rs','audio_crt_custom_locale_destructor.rs','audio_crt_tls_value_wrappers.rs','audio_path_memory.rs','audio_path_source_virtual_cleanup.rs','audio_global_float_default_power.rs','audio_crt_thread_context.rs']]]}}
(r/'docs/audio_windows_fls_rust_destructor_hardware_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_os_fls_rust_destructor.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print(run.stdout.strip())
