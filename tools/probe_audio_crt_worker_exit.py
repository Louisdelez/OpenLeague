from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/worker_exit';out.mkdir(parents=True,exist_ok=True);p=json.loads((r/'data/4.20/audio_crt_worker_exit_preparation.json').read_text());assert p['case_count']==124
files=[]
for i,row in enumerate(p['cases']):
 lines=['K\t'+ '\t'.join([str(int(row['layout']=='all')),row['state'],str(row['module']),str(int(row['available'])),str(row['exit_code'])])]
 for region in p['regions']:lines.append(f"B\t{region['reference']:x}\t{row['before'][region['name']]}")
 for call in row['calls']:
  lines.append('C\t'+call['kind']+'\t'+'|'.join(map(str,call['arguments']))+'\t'+str(call['result']))
  for region in p['regions']:lines.append(f"A\t{region['reference']:x}\t{call['at_call'][region['name']]}")
 for region in p['regions']:lines.append(f"F\t{region['reference']:x}\t{row['after'][region['name']]}")
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
base=(r/'tools/hardware/cookie_root_startup/probe.rs').read_text().split('fn main(){')[0]
source=(r/'crates/core/src/audio_crt_worker_exit.rs').read_text();a=source.index(' impl audio_crt_tls_value_wrappers::Services for Api');b=source.index(' #[test]fn',a);methods=source[a:b]
replacements={'self.row["layout"]=="all"':'self.row.fls','self.row["state"]=="null_failure"':'self.row.state=="null_failure"','self.row["module"].as_u64().unwrap()as u32':'self.row.module','self.row["available"]==true':'self.row.available','self.allocations.push(json!({"reference":value,"size":z}));':'','json!([])':'String::new()','json!([index])':'index.to_string()','json!([index,v])':'format!("{index}|{v}")','json!([v])':'v.to_string()','json!([n,z])':'format!("{n}|{z}")','json!([n,0,f])':'format!("{n}|0|{f}")','json!([module,n])':'format!("{module}|{n}")'}
for a,b in replacements.items():methods=methods.replace(a,b)
assert 'json!'not in methods and 'row['not in methods
extra='''
#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_exit.rs"]mod audio_crt_worker_exit;
use audio_crt_worker_exit::{Services,ComServices};
struct Config{fls:bool,state:String,module:u32,available:bool,code:u32}
struct Call{name:String,args:String,result:u32,bank:Vec<(u32,Vec<u8>)>}
struct Api{row:Config,calls:Vec<Call>,next:usize,tls:u32,last:u32,freed:Vec<u32>}
impl Api{fn emit(&mut self,name:&str,args:String,result:u32,m:&BTreeMap<u32,Memory>){let call=&self.calls[self.next];assert_eq!((name,args.as_str(),result),(call.name.as_str(),call.args.as_str(),call.result),"service {}",self.next);for(a,raw)in &call.bank{assert_eq!(audio_path_memory::read(m,*a,raw.len()).unwrap(),raw.as_slice(),"service bank {a:x} index {}",self.next);}self.next+=1;}}
'''+methods+'''
fn main(){let dir=std::env::args().nth(1).unwrap();for i in 0..124{let text=std::fs::read_to_string(format!("{dir}/case_{i}.tsv")).unwrap();let mut memory=BTreeMap::new();let mut calls:Vec<Call>=vec![];let mut expected=vec![];let mut config=None;for line in text.lines(){let fields=line.split('\\t').collect::<Vec<_>>();match fields[0]{"K"=>config=Some(Config{fls:fields[1]=="1",state:fields[2].into(),module:fields[3].parse().unwrap(),available:fields[4]=="1",code:fields[5].parse().unwrap()}),"B"=>{let a=u32::from_str_radix(fields[1],16).unwrap();memory.insert(a,Memory{reference:a,raw:bytes(fields[2])});},"C"=>calls.push(Call{name:fields[1].into(),args:fields[2].into(),result:fields[3].parse().unwrap(),bank:vec![]}),"A"=>calls.last_mut().unwrap().bank.push((u32::from_str_radix(fields[1],16).unwrap(),bytes(fields[2]))),"F"=>expected.push((u32::from_str_radix(fields[1],16).unwrap(),bytes(fields[2]))),_=>panic!("bad fixture")}}let config=config.unwrap();let code=config.code;let tls=if config.state=="existing"{0x40012000}else{0};let mut api=Api{row:config,calls,next:0,tls,last:97,freed:vec![]};let mut dead=BTreeSet::new();assert_eq!(audio_crt_worker_exit::prepare_exit(&mut memory,&mut dead,code,&mut api).unwrap(),audio_crt_worker_exit::PreparedExit{code});api.emit("ExitThread",code.to_string(),0,&memory);assert_eq!(api.next,api.calls.len());for(a,raw)in expected{assert_eq!(audio_path_memory::read(&memory,a,raw.len()).unwrap(),raw.as_slice(),"final bank case {i} {a:x}");}}
 println!("PASS124 original worker-exit preparation cases/all intermediate and final banks; explicit terminal boundary, not OS termination; pointer_width={}",std::mem::size_of::<usize>()*8);}
'''
extra=extra.replace('Api','WorkerApi')
probe=out/'probe.rs';probe.write_text(base+extra);files.append(probe)
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=30);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_crt_worker_exit.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8');files.extend([tool,r/'crates/core/src/audio_crt_worker_exit.rs',r/'data/4.20/audio_crt_worker_exit_preparation.json'])
receipt={'passed':True,'complete':False,'cases':248,'native_cases':124,'architectures':[32,64],'limits':['Unchanged Rust worker-exit preparation compared with original complete x86 routine through explicit imported ExitThread boundary, including every captured intermediate/final bank.','COM and TLS/FLS service outcomes supplied. No actual RoUninitialize or physical ExitThread invoked; no actual legacy worker ownership integration claimed.'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_crt_worker_exit_component_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
