from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/worker_body';out.mkdir(parents=True,exist_ok=True);p=json.loads((r/'data/4.20/audio_crt_worker_body_preparation.json').read_text(encoding='utf-8'));files=[]
for i,row in enumerate(p['cases']):
 lines=['K\t'+str(int(row['layout']=='all'))+'\t'+str(row['code'])+'\t'+str(row['argument'])+'\t'+str(row['last_error'])]
 for v in p['regions']:lines.append(f"B\t{v['reference']:x}\t{row['before'][v['name']]}")
 for c in row['calls']:
  lines.append('C\t'+c['kind']+'\t'+'|'.join(map(str,c['arguments']))+'\t'+str(c['result']))
  for v in p['regions']:lines.append(f"A\t{v['reference']:x}\t{c['at_call'][v['name']]}")
 for v in p['regions']:lines.append(f"F\t{v['reference']:x}\t{row['after'][v['name']]}")
 f=out/f'case_{i}.tsv';f.write_text('\n'.join(lines)+'\n',encoding='utf-8');files.append(f)
base=(r/'tools/hardware/actual_com_startup/probe.rs').read_text(encoding='utf-8').split('fn main(){')[0]
s=(r/'crates/core/src/audio_crt_worker_body.rs').read_text(encoding='utf-8');a=s.index(' impl audio_crt_tls_value_wrappers::Services for Api');b=s.index(' #[test]',a);methods=s[a:b]
for a,b in {'self.row["layout"]=="all"':'self.row.fls','self.row["state"]=="null_failure"':'false','self.row["module"].as_u64().unwrap()as u32':'0','self.row["available"]==true':'false','self.row["code"].as_u64().unwrap()as u32':'self.row.code','self.row["argument"].as_u64().unwrap()':'self.row.argument as u64','self.allocations.push(json!({"reference":value,"size":z}));':'','json!([])':'String::new()','json!([index])':'index.to_string()','json!([index,v])':'format!("{index}|{v}")','json!([v])':'v.to_string()','json!([n,z])':'format!("{n}|{z}")','json!([n,0,f])':'format!("{n}|0|{f}")','json!([module,n])':'format!("{module}|{n}")','json!([a])':'a.to_string()'}.items():methods=methods.replace(a,b)
assert 'json!'not in methods
extra='''
#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_body.rs"]mod audio_crt_worker_body;
use audio_crt_worker_exit::ComServices;use audio_crt_worker_body::CallbackServices;
struct Config{fls:bool,code:u32,argument:u32,last:u32}
struct Call{name:String,args:String,result:u32,bank:Vec<(u32,Vec<u8>)>}
struct Api{row:Config,calls:Vec<Call>,next:usize,tls:u32,last:u32,freed:Vec<u32>}
impl Api{fn emit(&mut self,name:&str,args:String,result:u32,m:&BTreeMap<u32,Memory>){let call=&self.calls[self.next];assert_eq!((name,args.as_str(),result),(call.name.as_str(),call.args.as_str(),call.result));for(a,raw)in &call.bank{assert_eq!(audio_path_memory::read(m,*a,raw.len()).unwrap(),raw.as_slice(),"service bank {a:x} index {}",self.next);}self.next+=1;}}
'''+methods+'''
fn main(){let dir=std::env::args().nth(1).unwrap();for i in 0..54{let text=std::fs::read_to_string(format!("{dir}/case_{i}.tsv")).unwrap();let mut memory=BTreeMap::new();let mut calls:Vec<Call>=vec![];let mut expected=vec![];let mut config=None;for line in text.lines(){let f=line.split('\\t').collect::<Vec<_>>();match f[0]{"K"=>config=Some(Config{fls:f[1]=="1",code:f[2].parse().unwrap(),argument:f[3].parse().unwrap(),last:f[4].parse().unwrap()}),"B"=>{let a=u32::from_str_radix(f[1],16).unwrap();memory.insert(a,Memory{reference:a,raw:bytes(f[2])});},"C"=>calls.push(Call{name:f[1].into(),args:f[2].into(),result:f[3].parse().unwrap(),bank:vec![]}),"A"=>calls.last_mut().unwrap().bank.push((u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]))),"F"=>expected.push((u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]))),_=>panic!("fixture")}}let mut api=Api{row:config.unwrap(),calls,next:0,tls:0x40012000,last:97,freed:vec![]};let mut dead=BTreeSet::new();let result=audio_crt_worker_body::prepare_normal_exit(&mut memory,&mut dead,&mut api).unwrap();assert_eq!(result.code,api.row.code);api.emit("ExitThread",result.code.to_string(),0,&memory);assert_eq!(api.next,api.calls.len());assert_eq!(api.tls,0);assert_eq!(api.last,api.row.last);assert_eq!(api.freed,vec![0x40012000]);assert_eq!(dead,BTreeSet::from([0x40012000]));for(a,raw)in expected{assert_eq!(audio_path_memory::read(&memory,a,raw.len()).unwrap(),raw.as_slice(),"final bank {i} {a:x}");}}
println!("PASS54 original normal worker bodies/all service and final banks; pointer_width={}",std::mem::size_of::<usize>()*8);}
'''
probe=out/'probe.rs';probe.write_text(base+extra.replace('Api','BodyApi'),encoding='utf-8');files.append(probe)
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=30);log.write_text(log.read_text(encoding='utf-8')+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_worker_body.py';tool.write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');files.extend([tool,r/'crates/core/src/audio_crt_worker_body.rs',r/'data/4.20/audio_crt_worker_body_preparation.json'])
receipt={'passed':True,'complete':False,'cases':108,'native_cases':54,'architectures':[32,64],'limits':p['limits'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_worker_body_component_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
