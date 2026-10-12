from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/worker_entry';out.mkdir(parents=True,exist_ok=True)
p=json.loads((r/'data/4.20/audio_crt_worker_entry_preparation.json').read_text());assert p['case_count']==162;files=[]
for i,row in enumerate(p['cases']):
 lines=['K\t'+str(int(row['layout']=='all'))+'\t'+row['state']+'\t'+str(row['tls_value'])+'\t'+str(row['last_error'])]
 for region in p['regions']:lines.append(f"B\t{region['reference']:x}\t{row['before'][region['name']]}")
 for call in row['calls']:
  lines.append('C\t'+call['kind']+'\t'+'|'.join(map(str,call['arguments']))+'\t'+str(call['result']))
  for region in p['regions']:lines.append(f"A\t{region['reference']:x}\t{call['at_call'][region['name']]}")
 for region in p['regions']:lines.append(f"F\t{region['reference']:x}\t{row['after'][region['name']]}")
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
base=(r/'tools/hardware/actual_com_startup/probe.rs').read_text().split('fn main(){')[0]
s=(r/'crates/core/src/audio_crt_worker_entry.rs').read_text();a=s.index(' impl audio_crt_tls_value_wrappers::Services for Api');b=s.index(' #[test]',a);methods=s[a:b]
for a,b in {'self.row["layout"]=="all"':'self.row.fls','self.row["state"]!="publication_failure"':'self.row.state!="publication_failure"','self.row["state"]=="null_failure"':'self.row.state=="null_failure"','self.allocations.push(json!({"reference":value,"size":z}));':'','json!([])':'String::new()','json!([index])':'index.to_string()','json!([index,v])':'format!("{index}|{v}")','json!([v])':'v.to_string()','json!([n,z])':'format!("{n}|{z}")'}.items():methods=methods.replace(a,b)
assert 'json!'not in methods
extra='''
#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_entry.rs"]mod audio_crt_worker_entry;
struct Config{fls:bool,state:String,tls:u32,last:u32}
struct Call{name:String,args:String,result:u32,bank:Vec<(u32,Vec<u8>)>}
struct Api{row:Config,calls:Vec<Call>,next:usize,tls:u32,last:u32,freed:Vec<u32>}
impl Api{fn emit(&mut self,name:&str,args:String,result:u32,m:&BTreeMap<u32,Memory>){let call=&self.calls[self.next];assert_eq!((name,args.as_str(),result),(call.name.as_str(),call.args.as_str(),call.result),"service {}",self.next);for(a,raw)in &call.bank{assert_eq!(audio_path_memory::read(m,*a,raw.len()).unwrap(),raw.as_slice(),"service bank {a:x} index {}",self.next);}self.next+=1;}}
'''+methods+'''
fn main(){let dir=std::env::args().nth(1).unwrap();for i in 0..162{let text=std::fs::read_to_string(format!("{dir}/case_{i}.tsv")).unwrap();let mut memory=BTreeMap::new();let mut calls:Vec<Call>=vec![];let mut expected=vec![];let mut config=None;for line in text.lines(){let f=line.split('\\t').collect::<Vec<_>>();match f[0]{"K"=>config=Some(Config{fls:f[1]=="1",state:f[2].into(),tls:f[3].parse().unwrap(),last:f[4].parse().unwrap()}),"B"=>{let a=u32::from_str_radix(f[1],16).unwrap();memory.insert(a,Memory{reference:a,raw:bytes(f[2])});},"C"=>calls.push(Call{name:f[1].into(),args:f[2].into(),result:f[3].parse().unwrap(),bank:vec![]}),"A"=>calls.last_mut().unwrap().bank.push((u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]))),"F"=>expected.push((u32::from_str_radix(f[1],16).unwrap(),bytes(f[2]))),_=>panic!("fixture")}}let config=config.unwrap();let tls=if config.state=="existing"{0x40012000}else{0};let mut api=Api{row:config,calls,next:0,tls,last:97,freed:vec![]};let mut dead=BTreeSet::new();let result=audio_crt_worker_entry::prepare_entry(&mut memory,&mut dead,0x40014000,&mut api).unwrap();if let audio_crt_worker_entry::Entry::Exit{code}=result{assert_eq!(api.row.state,"publication_failure");api.emit("ExitThread",code.to_string(),0,&memory);}else{assert_eq!(result,audio_crt_worker_entry::Entry::Ready{record:api.row.tls});}assert_eq!(api.next,api.calls.len());assert_eq!(api.tls,api.row.tls);assert_eq!(api.last,api.row.last);assert_eq!(dead,if api.row.state=="existing"{BTreeSet::from([0x40014000])}else{BTreeSet::new()});for(a,raw)in expected{assert_eq!(audio_path_memory::read(&memory,a,raw.len()).unwrap(),raw.as_slice(),"final bank {i} {a:x}");}}
println!("PASS162 original worker-entry cases/all service and final banks; pointer_width={}",std::mem::size_of::<usize>()*8);}
'''
probe=out/'probe.rs';probe.write_text(base+extra.replace('Api','EntryApi'));files.append(probe)
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(out)],capture_output=True,text=True,timeout=30);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_worker_entry.py';tool.write_text(Path(__file__).read_text());files.extend([tool,r/'crates/core/src/audio_crt_worker_entry.rs',r/'data/4.20/audio_crt_worker_entry_preparation.json'])
receipt={'passed':True,'complete':False,'cases':324,'native_cases':162,'architectures':[32,64],'limits':p['limits'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_worker_entry_component_validation.json').write_text(json.dumps(receipt,indent=2)+'\n')
