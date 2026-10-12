from pathlib import Path
import subprocess,json,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/actual_packet_pipeline';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/actual_worker_body/probe.rs').read_text(encoding='utf-8');a=s.index('struct Worker{');b=s.index('#[path=',a)
helper='''
struct Worker{root:Arc<audio_crt_windows_root_startup::Startup<Owned>>,ready:std::sync::mpsc::Sender<(u32,u32)>,incoming:u32,existing:bool,com:bool}
#[link(name="kernel32")]extern "system"{fn ExitThread(code:u32)->!;}
unsafe extern "system" fn native_worker(parameter:*mut c_void)->u32{
 let code={let data=unsafe{Box::from_raw(parameter.cast::<Worker>())};if data.existing{data.root.current().unwrap();}
  data.root.context.with(|c|{audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x122343c,4,if data.com{1}else{u32::MAX}).unwrap();}).unwrap();
  let entry=data.root.initialize_worker_packet(data.incoming).unwrap();let audio_crt_worker_entry::Entry::Ready{record}=entry else{panic!("entry publication failure")};
  let tid=data.root.context.with(|c|{let flag=audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,record+0x3b4,4).unwrap();assert!(flag<=1);if data.com{assert_eq!(flag,1);}assert_eq!(c.services.inner.inner.pending_ro_initializations(),flag as usize);if data.existing{assert_ne!(record,data.incoming);assert!(!c.memory.contains_key(&data.incoming));}else{assert_eq!(record,data.incoming);}audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,record,4).unwrap()}).unwrap();
  let exit=data.root.prepare_worker_body_exit().unwrap();assert_eq!(data.root.slot.as_ref().unwrap().value().unwrap(),0);data.root.context.with(|c|{assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&data.incoming));assert_eq!(c.services.inner.inner.pending_ro_initializations(),0);}).unwrap();data.ready.send((record,tid)).unwrap();exit.code
 };unsafe{ExitThread(code)}
}
'''
s=s[:a]+helper+s[b:]
s=s.replace('fn main(){use','''#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_entry.rs"]mod audio_crt_worker_entry;
#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_packet.rs"]mod audio_crt_worker_packet;
#[path="E:/OpenLeague/crates/core/src/audio_crt_windows_worker_thread.rs"]mod audio_crt_windows_worker_thread;
fn main(){use''')
s=s.replace('for i in 0..6{let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv"))','for i in 0..48{let source_case=i/8;let existing=i&4!=0;let com=i&2!=0;let suspended=i&1!=0;let text=std::fs::read_to_string(format!("{directory}/case_{source_case}.tsv"))')
needle='let(ready,wait)=std::sync::mpsc::channel();';a=s.index(needle);b=s.index('assert_eq!(slot.report().attempts(),0);',a)
creation='''let(ready,wait)=std::sync::mpsc::channel();let exit_code=[0,97,u32::MAX][i%3];
  let callback=context.with(|c|{c.memory.insert(0x40029600,Memory{reference:0x40029600,raw:vec![0xa5;8]});unsafe{c.services.inner.inner.register_worker_callback(body_callback)}.unwrap()}).unwrap();
  let request=audio_crt_worker_packet::Request{security:0,stack_size:0,callback,argument:exit_code,flags:if suspended{4}else{0},thread_id_output:if i%2==0{0x40029600}else{0},callback_slot:0x40029604};
  let thread_report=Arc::new(audio_crt_windows_worker_thread::Report::default());let mut owned=None;let parent=started.clone();let mut packet=0;
  let label=started.create_worker_packet(request,|q,services,m,d|{
   assert_eq!((q.security,q.stack_size,q.entry,q.flags),(0,0,0xc9c3dc,request.flags));packet=q.packet;
   assert_eq!(audio_path_source_virtual_cleanup::get(m,d,q.packet+4,4).unwrap(),u32::MAX);assert_eq!(audio_path_source_virtual_cleanup::get(m,d,q.packet+0x54,4).unwrap(),callback);assert_eq!(audio_path_source_virtual_cleanup::get(m,d,q.packet+0x58,4).unwrap(),exit_code);
   services.inner.heap.synchronize(q.packet,m).unwrap();assert_eq!(services.inner.heap.physical_bytes(q.packet).unwrap(),m[&q.packet].raw);
   let capsule=Box::into_raw(Box::new(Worker{root:parent.clone(),ready:ready.clone(),incoming:q.packet,existing,com}));
   match unsafe{audio_crt_windows_worker_thread::Thread::spawn(0x73000000,q,native_worker,capsule.cast(),thread_report.clone())}{Ok(thread)=>{audio_path_source_virtual_cleanup::put(m,d,q.thread_id_output,4,thread.id()).unwrap();let label=thread.label();owned=Some(thread);Ok(label)},Err(error)=>{unsafe{drop(Box::from_raw(capsule))};if let audio_crt_windows_worker_thread::Failure::Windows{code,..}=error{unsafe{SetLastError(code)};Ok(0)}else{Err(Error::Backend("actual worker creation bridge rejected request"))}}}
  }).unwrap();assert_eq!(label,0x73000000);let thread=owned.take().unwrap();if suspended{assert_eq!(thread.wait(0).unwrap(),audio_crt_windows_worker_thread::Wait::Timeout);assert_eq!(thread.resume().unwrap(),1);}
  let(second,tid)=wait.recv_timeout(std::time::Duration::from_secs(5)).unwrap();assert_ne!(record,second);assert_eq!(thread.id(),tid);assert_eq!(thread.wait(5000).unwrap(),audio_crt_windows_worker_thread::Wait::Exited(exit_code));drop(thread);assert_eq!((thread_report.created(),thread_report.closed()),(1,1));assert!(thread_report.failures().is_empty());assert_eq!(CALLBACKS.load(std::sync::atomic::Ordering::SeqCst),i+1);assert_eq!(report.allocations(),2+usize::from(existing));assert_eq!(report.frees(),1+usize::from(existing));
  '''
s=s[:a]+creation+s[b:]
s=s.replace('assert_eq!((report.allocations(),report.frees()),(2,2));','assert_eq!((report.allocations(),report.frees()),(2+usize::from(existing),2+usize::from(existing)));')
s=s.replace('PASS6 production original-cookie/native-global/lock/FLS startups with fresh first and getter-created worker records; exact relocated initial native banks, physical blocks and original package/COM flag producer, actual body callback/raw return, explicit worker retirement and one main callback; actual ExitThread codes0/97/MAX','PASS48 actual native packet producer/CreateThread handle/entry adoption-or-transfer/COM/body/ExitThread pipelines; physical packet bytes, distinct records, actual IDs, suspended timeout/resume, one callback/one handle close and full heap retirement; codes0/97/MAX')
s=s.replace('usize::from(existing)','u32::from(existing)')
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files=[probe]+list((r/'tools/hardware/fresh_native_contexts').glob('case_*.tsv'))
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(r/'tools/hardware/fresh_native_contexts')],capture_output=True,text=True,timeout=45);log.write_text(log.read_text(encoding='utf-8')+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_actual_packet_pipeline.py';tool.write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');files.append(tool)
for n in ['audio_crt_worker_packet','audio_crt_worker_entry','audio_crt_worker_body','audio_crt_worker_exit','audio_crt_thread_context','audio_crt_worker_com_startup','audio_crt_windows_worker_thread','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_global_services','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:files.append(r/f'crates/core/src/{n}.rs')
receipt={'passed':True,'complete':False,'cases':96,'architectures':[32,64],'entry_adoption_cases':48,'entry_existing_transfer_cases':48,'suspended_start_cases':48,'actual_callback_calls':96,'physical_handles_created_and_closed':96,'limits':['Actual source packet producer and original constructor feed typed CreateThread boundary with owned full-width handle; original entry adopts packet or transfers fields into separately getter-created current record, COM producer/body callback/exit and complete heap retirement execute. Initial source globals verified with relocated cookie/runtime labels; no restored thread records.','Scalar callback only; positive package cache remains supplied. NULL callback, allocation/API failures, foreign optional packet ownership, custom locale teardown, SEH/fatal context and S_FALSE terminal branches remain incomplete. Handle closure is owner adapter behavior. Combined lifecycle verified using composed source ports, not full native executable startup or audible client output.'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_actual_packet_pipeline_hardware_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
