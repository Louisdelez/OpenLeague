from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/crt_heap_native';out.mkdir(parents=True,exist_ok=True);p=json.loads((r/'data/4.20/audio_crt_heap_preparation.json').read_text());files=[]
for i,row in enumerate(p['cases']):
 lines=[f"C\t{row['entry']:x}\t{row['result']:x}\t"+','.join(f'{v:x}'for v in row['arguments'])]
 for kind,bank in [('I',row['before']),('F',row['after'])]:
  for region in p['regions']:lines.append(f"{kind}\t{region['reference']:x}\t{bank[region['name']]}")
 for call in row['calls']:
  lines.append(f"S\t{call['kind']}\t{call['result']:x}\t"+','.join(f'{v:x}'for v in call['arguments']))
  for region in p['regions']:lines.append(f"B\t{region['reference']:x}\t{call['at_call'][region['name']]}")
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
s=(r/'tools/hardware/fls_rust_destructor/probe.rs').read_text();s=s[:s.index('struct Step{')];s+='\n#[path="E:/OpenLeague/crates/core/src/audio_crt_heap.rs"] mod audio_crt_heap;\n'
s+=r'''
struct Step{kind:String,args:Vec<u32>,result:u32,bank:Bank}
struct Api{steps:Vec<Step>,index:usize}
impl Api{fn event(&mut self,kind:&str,args:Vec<u32>,m:&BTreeMap<u32,Memory>)->u32{let expected=&self.steps[self.index];assert_eq!(kind,expected.kind);assert_eq!(args,expected.args);check(m,&expected.bank);self.index+=1;expected.result}}
impl audio_crt_heap::Services for Api{
 fn heap_allocate(&mut self,h:u32,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("HeapAlloc",vec![h,f,z],m))}
 fn heap_free(&mut self,h:u32,f:u32,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("HeapFree",vec![h,f,r],m))}
 fn thread_context(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("GetContext",vec![],m))}
 fn last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("GetLastError",vec![],m))}
 fn sleep(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event("Sleep",vec![v],m);Ok(())}
 fn decode_pointer(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("DecodePointer",vec![v],m))}
 fn invoke_handler(&mut self,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(self.event("Handler",vec![f,z],m))}
}
fn numbers(s:&str)->Vec<u32>{if s.is_empty(){vec![]}else{s.split(',').map(|v|u32::from_str_radix(v,16).unwrap()).collect()}}
fn main(){let directory=std::env::args().nth(1).unwrap();for i in 0..975{let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut initial=Bank::new();let mut final_bank=Bank::new();let mut entry=0;let mut expected_result=0;let mut args=vec![];let mut steps:Vec<Step>=vec![];for line in text.lines(){let f=line.split('\t').collect::<Vec<_>>();match f[0]{"C"=>{entry=u32::from_str_radix(f[1],16).unwrap();expected_result=u32::from_str_radix(f[2],16).unwrap();args=numbers(f[3]);},"I"=>{initial.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"F"=>{final_bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},"S"=>steps.push(Step{kind:f[1].into(),result:u32::from_str_radix(f[2],16).unwrap(),args:numbers(f[3]),bank:Bank::new()}),"B"=>{steps.last_mut().unwrap().bank.insert(u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]));},_=>panic!("bad row")}}
 let mut memory=initial.into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect();let mut dead=BTreeSet::new();let mut api=Api{steps,index:0};if entry==0xc98528{audio_crt_heap::free(&mut memory,&mut dead,args[0],&mut api).unwrap();}else{let result=if entry==0xca8673{audio_crt_heap::calloc(&mut memory,&mut dead,args[0],args[1],&mut api).unwrap()}else{audio_crt_heap::calloc_base(&mut memory,&mut dead,args[0],args[1],args[2],&mut api).unwrap()};assert_eq!(result,expected_result);}assert_eq!(api.index,api.steps.len());check(&memory,&final_bank);assert!(dead.is_empty());}
 println!("PASS975 original CRT heap control cases; all service arguments/results/order/entry bytes and final errno/global bytes match; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files.append(probe);results=[]
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr
 run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=40);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());results.append({'target':target,'pointer_width':width,'cases':975,'passed':True});files.extend([exe,log])
files.extend([r/'crates/core/src/audio_crt_heap.rs',r/'data/4.20/audio_crt_heap_preparation.json']);receipt={'passed':True,'complete':False,'cases':1950,'runs':results,'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files},'limits':['Unchanged production CRT heap algorithm executed in x86/x64 processes with canonical service adapters matching original native calls and entry/final banks. These are algorithm comparisons, not real Windows heap ownership or normal context/bootstrap integration.']};(r/'docs/audio_crt_heap_component_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_audio_crt_heap_component.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
