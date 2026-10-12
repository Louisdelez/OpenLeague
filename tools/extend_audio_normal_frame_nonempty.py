from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_normal_frame.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub processed:u32,pub rate:u32','pub processed:u32,pub command_pool:u32,pub rate:u32').replace('self.scheduler.pool,services)?;','self.command_pool,services)?;')
s=s.replace('fn lock_queue(&mut self)->Result<(),Error>{Err(Error::Backend("unexpected empty consumer lock"))}', 'fn lock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"audio_common_queue"}));Ok(())}')
s=s.replace('fn unlock_queue(&mut self)->Result<(),Error>{Err(Error::Backend("unexpected empty consumer unlock"))}', 'fn unlock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"audio_common_queue"}));Ok(())}')
s=s.replace('fn set_event(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unexpected empty event set"))}', 'fn set_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}')
a=s.index(' impl DueServices for Backend{');z=s.index(' impl Services for Backend{',a)
s=s[:a]+r""" impl DueServices for Backend{
  fn query(&mut self,_:&mut audio_due_actions::Runtime,action:u32,out:&mut[u8;68])->Result<(),Error>{assert_eq!(&out[..4],&[0;4]);out.fill(0x5a);self.calls.push(json!({"kind":"due_query","reference":action}));Ok(())}
  fn execute(&mut self,_:&mut audio_due_actions::Runtime,_:&mut[u8;0x98],action:u32,command:u32)->Result<(),Error>{self.calls.push(json!({"kind":"due_execute","reference":action,"command":command}));Ok(())}
  fn release_playing(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unexpected playing release"))}
  fn release_action(&mut self,_:&mut audio_due_actions::Runtime,action:u32)->Result<(),Error>{self.calls.push(json!({"kind":"due_release","reference":action}));Ok(())}
  fn destroy_command(&mut self,_:&mut audio_due_actions::Runtime,command:u32,flags:u32)->Result<(),Error>{self.calls.push(json!({"kind":"due_destroy","reference":command,"flags":flags}));Ok(())}
  fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.free(pool,memory)}
 }
"""+s[z:]
s=s.replace('audio_normal_frame_matches64_native_full_caller_empty_queue_and_real_fallback_compositions','audio_normal_frame_matches128_native_full_caller_empty_nonempty_queues_and_real_fallback_compositions')
s=s.replace('for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate()', 'let nonempty:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_normal_frame_nonempty_preparation.json")).unwrap();assert_eq!(nonempty["passed"],true);assert_eq!(nonempty["case_count"],64);for(i,row)in proof["cases"].as_array().unwrap().iter().chain(nonempty["cases"].as_array().unwrap().iter()).enumerate()')
s=s.replace('let mut fallback=fallback::Runtime::default();for a in initial', 'let mut fallback=fallback::Runtime::default();let mut pages=BTreeMap::new();let mut table=Memory{reference:0,raw:vec![]};let mut due=audio_due_actions::Runtime::default();for field in ["due_nodes","due_actions"]{if let Some(entries)=b[field].as_array(){for e in entries{let reference=e["reference"].as_u64().unwrap()as u32;let m=Memory{reference,raw:bytes(e["raw"].as_str().unwrap())};if field=="due_nodes"{due.nodes.insert(reference,m);}else{due.actions.insert(reference,m);}}}}for a in initial')
s=s.replace('else{factory.objects.insert(reference,memory);}', 'else if reference==0x30039000{table=memory;}else if [0x3003a000,0x3003a100].contains(&reference){pages.insert(reference,memory);}else if (0x3003d000..0x3003d100).contains(&reference){due.commands.insert(reference,memory);}else{factory.objects.insert(reference,memory);}')
s=s.replace('table:Memory{reference:0,raw:vec![]},pages:BTreeMap::new(),page_size:2048},due:audio_due_actions::Runtime::default()', 'table,pages,page_size:64},due')
s=s.replace('processed:0,rate:48000','processed:b["processed"].as_u64().unwrap_or(0)as u32,command_pool:row["command_pool"].as_u64().unwrap_or(u32::MAX as u64)as u32,rate:48000')
s=s.replace('.or_else(||runtime.fallback.buffers.get(r)).unwrap()', '.or_else(||runtime.fallback.buffers.get(r)).or_else(||runtime.common.pages.get(r)).or_else(||runtime.due.commands.get(r)).or_else(||if *r==runtime.common.table.reference{Some(&runtime.common.table)}else{None}).unwrap()')
s=s.replace('assert_eq!(json!({"common":', 'let mut actual=json!({"common":')
s=s.replace('"allocations":allocations}),row["after"],"shared caller state {i}");assert!(runtime.due.commands.is_empty());assert_eq!(runtime.processed,0);', '"allocations":allocations});if b["processed"].is_number(){actual["processed"]=json!(runtime.processed);actual["due_nodes"]=json!(runtime.due.nodes.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>());actual["due_actions"]=json!(runtime.due.actions.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>());}assert_eq!(actual,row["after"],"shared caller state {i}");')
p.write_text(s,encoding='utf-8');print('Applied128 empty/nonempty native-frame replay and distinct command pool')
