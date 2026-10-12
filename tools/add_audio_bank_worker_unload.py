from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_bank_command_worker.rs';s=p.read_text(encoding='utf-8');start=s.index('        self.thread=WaitServices::current_thread_id')
end=s.index('                QueueServices::lock_queue(services)?;',s.index('                match request[0]',start))
match_start=s.index('                match request[0]',start)
loop=s[start:match_start]+'                dispatch(request,manager,services)?;\n'+s[end:]
# old loop includes the closing method/impl braces; retain them for the shared implementation.
head=s[:start]
head+=r"""
        self.run_dispatch(manager,queue,services,|request,m,s|match request[0]{
            0=>{m.load_request_deferred(request,||backing(request[6],request[7]),resources,runtime,plugins,hirc,chunks,s)?;Ok(())},
            _=>Err(Error::Backend("bank worker command selector not qualified")),
        })
    }
    pub fn run_with_common<S:Services+crate::audio_common_queue::RetryServices>(&mut self,manager:&mut Manager,queue:&mut Queue,common:&mut crate::audio_common_queue::Context,processed:&mut u32,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc:UnknownHirc,chunks:UnknownChunks,backing:&mut impl FnMut(u32,u32)->Result<Vec<u8>,Error>,services:&mut S)->Result<u32,Error>{
        self.run_dispatch(manager,queue,services,|request,m,s|match request[0]{
            0=>{m.load_request_deferred(request,||backing(request[6],request[7]),resources,runtime,plugins,hirc,chunks,s)?;Ok(())},
            1=>{m.unload_request(request,common,processed,resources,runtime,s)?;Ok(())},
            _=>Err(Error::Backend("bank worker command selector not qualified")),
        })
    }
    fn run_dispatch<S:Services>(&mut self,manager:&mut Manager,queue:&mut Queue,services:&mut S,mut dispatch:impl FnMut([u32;9],&mut Manager,&mut S)->Result<(),Error>)->Result<u32,Error>{
"""
p.write_text(head+loop,encoding='utf-8')
p=r/'crates/core/src/audio_bank_memory_reader.rs';s=p.read_text(encoding='utf-8');pos=s.rfind('\n}')
test=r"""
    #[test]fn audio_bank_normal_worker_unload_matches48_native_admission_load_deferred_consumer_callback_and_storage_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_worker_deferred_unload_contract.json")).unwrap();assert_eq!(proof["case_count"],48);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let first=&row["stages"][0];let mut manager=Manager{raw:bytes(first["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let mut resources=Registry::default();let mut runtime=Runtime::default();
            let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:Some(Memory{reference:0,raw:vec![]}),wait_index:0};
            let mut queue=crate::audio_bank_command_queue::Queue::default();for v in first["allocations"].as_array().unwrap(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};native.heap.allocations.push((m.reference,m.raw.len()as u32));queue.nodes.insert(m.reference,m);}
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let request:[u32;9]=row["request"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();let mut unload=request;unload[0]=1;let data=bytes(row["bank_payload"].as_str().unwrap());
            let page_size=row["page_size"].as_u64().unwrap()as u32;let mut common=crate::audio_common_queue::Context{raw:bytes(first["common"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30005800,raw:bytes(first["common_table"].as_str().unwrap())},pages:BTreeMap::new(),page_size};for(j,p)in first["pages"].as_array().unwrap().iter().enumerate(){let reference=0x3000a000+j as u32*0x1000;common.pages.insert(reference,Memory{reference,raw:bytes(p.as_str().unwrap())});}
            let mut processed=0;let mut worker=crate::audio_bank_command_worker::Worker{thread:100};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=match j{
                    0=>0,1=>queue.admit(&mut manager.raw,request,100,native.notifications.as_mut().unwrap(),&mut native).unwrap(),
                    2=>queue.admit(&mut manager.raw,unload,100,native.notifications.as_mut().unwrap(),&mut native).unwrap(),
                    3=>worker.run_with_common(&mut manager,&mut queue,&mut common,&mut processed,&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut|base,len|{assert_eq!(base,request[6]);assert_eq!(len,data.len()as u32);Ok(data.clone())},&mut native).unwrap(),
                    4=>crate::audio_bank_deferred_consumer::consume(&mut common,&mut manager,&crate::audio_bank_deferred_consumer::VoiceOwners::default(),&mut processed,&mut native).unwrap(),
                    5=>{let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};context.destroy(&mut native).unwrap();manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);for m in queue.nodes.values(){BankServices::free_pool(&mut native.heap,POOL,m).unwrap();}queue.nodes.clear();0},_=>unreachable!()};
                assert_eq!(result as u64,stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(worker.thread as u64,stage["worker_thread"].as_u64().unwrap());assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");assert_eq!(hex(&common.raw),stage["common"].as_str().unwrap(),"common {i}/{j}");assert_eq!(hex(&common.table.raw),stage["common_table"].as_str().unwrap());assert_eq!(processed as u64,stage["processed"].as_u64().unwrap());
                for(k,page)in common.pages.values().enumerate(){let mut expected=bytes(stage["pages"][k].as_str().unwrap());let mut actual=page.raw.clone();if j>=3&&k==0{for o in [4,5,6,7,16,17,18,19]{expected[o]=0;actual[o]=0;}}assert_eq!(actual,expected,"defined page bytes {i}/{j}/{k}");}
                assert_eq!(resources.counts[0]as u64,stage["custom_count"].as_u64().unwrap());assert_eq!(resources.counts[1]as u64,stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).or_else(||native.notifications.as_ref().filter(|t|t.reference==r)).or_else(||queue.nodes.get(&r)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"owned storage {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"physical order {i}/{j}");
            }
        }
    }
"""
# Admission owns the embedded notification table temporarily; avoid aliasing the backend.
test=test.replace('queue.admit(&mut manager.raw,request,100,native.notifications.as_mut().unwrap(),&mut native).unwrap()', '{let mut table=native.notifications.take().unwrap();let result=queue.admit(&mut manager.raw,&mut table,request,100,&mut native).unwrap();native.notifications=Some(table);result}').replace('queue.admit(&mut manager.raw,unload,100,native.notifications.as_mut().unwrap(),&mut native).unwrap()', '{let mut table=native.notifications.take().unwrap();let result=queue.admit(&mut manager.raw,&mut table,unload,100,&mut native).unwrap();native.notifications=Some(table);result}')
assert 'fn audio_bank_normal_worker_unload_matches48'not in s;p.write_text(s[:pos]+test+s[pos:],encoding='utf-8')
print('Applied normal worker unload and48 native replay')
