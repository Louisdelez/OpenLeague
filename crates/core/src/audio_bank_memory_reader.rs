//! AF8A20 holder and AF9960 memory-mode outer bank reader.
//! Other chunk bodies,scope owners,file providers and registered-bank destruction remain explicit.
use crate::{audio_bus_bank::Error,audio_effect_bank_loader::{self as effects,Holder,Stream,UnknownHirc},audio_effect_resource_registry::Registry,audio_meter_lifecycle::Runtime,audio_plugin_factory::{Memory,Registry as Plugins},audio_effect_resource_bank::POOL};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:effects::Services{
    /// InterlockedDecrement on the owned holder field,including raw publication.
    fn atomic_decrement(&mut self,object:&mut Memory,offset:usize)->Result<u32,Error>;
    /// Full B14630 notification receiver interface,not a direct user-callback shim.
    fn notify_bank(&mut self,context:&mut[u8;40],fields:[u32;6])->Result<(),Error>;

    fn lock_bank_registry(&mut self)->Result<(),Error>;
    fn unlock_bank_registry(&mut self)->Result<(),Error>;
}
#[derive(Debug)]pub struct Bank{pub memory:Memory,pub effects:Holder}
impl Bank{
    pub fn construct(mut memory:Memory,args:[u32;5])->Result<Self,Error>{
        if memory.reference==0||memory.raw.len()!=80{return Err(Error::InvalidAllocation);}
        let[id,pool,flag,initial,owned]=args;
        for(o,v)in [(12,id),(16,0),(20,0),(24,pool),(32,0),(36,0),(40,0),(44,0),(48,0),(52,0),(56,0),(60,0),(64,flag),(68,initial.wrapping_add(owned)),(76,owned)]{set(&mut memory.raw,o,v);}
        memory.raw[28]=0;memory.raw[72]=(memory.raw[72]&0xf0)|u8::from(flag!=0);
        let effects=Holder{raw:memory.raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}};Ok(Self{memory,effects})
    }
    fn synchronize(&mut self){self.memory.raw[52..64].copy_from_slice(&self.effects.raw[52..64]);}
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum UnknownChunks{Reject,SkipNativeDefaults}
pub struct Read{pub status:u32,pub holder:u32}
pub struct Manager{pub raw:[u8;0x500],pub banks:BTreeMap<u32,Bank>}
impl Manager{
    /// AFA370/B14630 completion mutates the embedded notification context.
    /// Its owned table remains with the concrete notification service.
    pub fn notify_completion(&mut self,fields:[u32;6],backend:&mut impl Services)->Result<(),Error>{
        let mut context:[u8;40]=self.raw[0x494..0x4bc].try_into().unwrap();
        let result=backend.notify_bank(&mut context,fields);self.raw[0x494..0x4bc].copy_from_slice(&context);result
    }

    fn lookup_unlocked(&self,id:u32,memory:u32)->Result<Option<u32>,Error>{
        let mut reference=word(&self.raw,0x38c+(id.wrapping_add(memory)%31)as usize*4);let mut visited=std::collections::BTreeSet::new();
        while reference!=0{
            if !visited.insert(reference){return Err(Error::Backend("cyclic bank cache storage"));}
            let bank=self.banks.get(&reference).ok_or(Error::UnresolvedReference)?;
            if bank.memory.reference!=reference||bank.memory.raw.len()!=80{return Err(Error::InvalidAllocation);}
            if word(&bank.memory.raw,0)==id&&word(&bank.memory.raw,4)==memory{return Ok(Some(reference));}
            reference=word(&bank.memory.raw,8);
        }Ok(None)
    }
    /// AFCEC0 nullable holder notification; actual null path requires no service.
    fn notify_holder(&mut self,reference:u32,backend:&mut impl Services)->Result<(),Error>{
        let raw=&self.banks.get(&reference).ok_or(Error::UnresolvedReference)?.memory.raw;
        let callback=word(raw,44);if callback==0{return Ok(());}
        let fields=[callback,word(raw,12),word(raw,4),1,word(raw,24),word(raw,48)];self.notify_completion(fields,backend)?;
        set(&mut self.banks.get_mut(&reference).unwrap().memory.raw,44,0);Ok(())
    }
    /// AFBFD0 for unloaded holders with empty media/data. Retains storage if
    /// signed counters still have owners; other storage requires qualified readers.
    pub fn destroy_empty_holder(&mut self,reference:u32,quiet:bool,backend:&mut impl Services)->Result<bool,Error>{
        backend.lock_bank_registry()?;
        let result=(||{
            let bank=self.banks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
            let remaining=backend.atomic_decrement(&mut bank.memory,64)?;
            if remaining as i32>0{return Ok((false,false));}
            if [16,32,36,40,52,56,60].iter().any(|&o|word(&bank.memory.raw,o)!=0)||bank.memory.raw[72]&2!=0{return Err(Error::Backend("bank destructor media/data storage not qualified"));}
            Ok((true,(word(&bank.memory.raw,68)as i32)<=0))
        })();backend.unlock_bank_registry()?;
        let(process,free)=result?;if !process{return Ok(false);}
        if !quiet{self.notify_holder(reference,backend)?;}
        if free{let bank=self.banks.get_mut(&reference).unwrap();set(&mut bank.memory.raw,40,0);backend.free_pool(POOL,&bank.memory)?;self.banks.remove(&reference);}
        Ok(free)
    }
    /// AF9D40 memory command0 request. Successful registration and failed-prefix
    /// release use the concrete cache/holder/resource paths,including atomics.
    pub fn load_request(&mut self,request:[u32;9],bytes:Vec<u8>,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc_policy:UnknownHirc,chunk_policy:UnknownChunks,backend:&mut impl Services)->Result<u32,Error>{
        self.load_request_deferred(request,||Ok(bytes),resources,runtime,plugins,hirc_policy,chunk_policy,backend)
    }
    pub fn load_request_deferred(&mut self,request:[u32;9],backing:impl FnOnce()->Result<Vec<u8>,Error>,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc_policy:UnknownHirc,chunk_policy:UnknownChunks,backend:&mut impl Services)->Result<u32,Error>{
        if request[0]!=0||request[3]!=1{return Err(Error::Backend("bank request command/mode not qualified"));}

        let before:std::collections::BTreeSet<u32>=self.banks.keys().copied().collect();
        let read=self.read_memory_deferred(request[4],request[5],request[6],||{let bytes=backing()?;if u32::try_from(bytes.len()).ok()!=Some(request[7]){return Err(Error::Backend("bank request backing length mismatch"));}Ok(bytes)},resources,runtime,plugins,hirc_policy,chunk_policy,backend);
        let read=match read{Ok(read)=>read,Err(error)=>{
            let created=self.banks.keys().find(|r|!before.contains(r)).copied();
            if let Some(reference)=created{self.unload_effect_prefix(reference,resources,runtime,backend)?;self.destroy_empty_holder(reference,true,backend)?;}
            return Err(error);
        }};
        // AF9D40 completion keeps reader status69; only caller return normalizes it.
        let completion_status=read.status;
        let status=if read.status==69{1}else if read.status==1{
            self.banks.get_mut(&read.holder).ok_or(Error::UnresolvedReference)?.memory.raw[72]|=1;
            self.register_holder(request[4],request[6],read.holder,backend)?;1
        }else{
            if read.holder!=0{self.unload_effect_prefix(read.holder,resources,runtime,backend)?;self.destroy_empty_holder(read.holder,true,backend)?;}read.status
        };
        // AFA370 command0 selectors and B14630's genuine null-callback branch.
        if request[1]!=0{self.notify_completion([request[1],request[4],request[6],completion_status,request[5],request[2]],backend)?;}
        Ok(status)
    }
    /// AFCDE0/AF9900 memory-mode unload command1: unlink now, release at deferred consumption.
    pub fn unload_request<S:Services+crate::audio_common_queue::RetryServices>(&mut self,request:[u32;9],common:&mut crate::audio_common_queue::Context,processed:&mut u32,resources:&mut Registry,runtime:&mut Runtime,backend:&mut S)->Result<u32,Error>{
        if request[0]!=1||request[3]!=1{return Err(Error::Backend("unload command/mode not qualified"));}
        backend.lock_bank_registry()?;
        let result=(||{let found=self.lookup(request[4],request[6],backend)?;
            match found{Some(r)=>{let loaded=self.banks.get(&r).ok_or(Error::UnresolvedReference)?.memory.raw[72]&1!=0;if loaded{self.unlink_holder(request[4],request[6],backend)?;Ok((Some(r),1))}else{Ok((None,2))}},None=>Ok((None,54))}
        })();backend.unlock_bank_registry()?;let(reference,status)=result?;
        if let Some(reference)=reference{
            self.unload_effect_prefix(reference,resources,runtime,backend)?;let bank=self.banks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
            bank.memory.raw[72]|=8;set(&mut bank.memory.raw,44,request[1]);set(&mut bank.memory.raw,48,request[2]);
            let mut packet=[0u8;12];packet[2..4].copy_from_slice(&24u16.to_le_bytes());packet[8..12].copy_from_slice(&reference.to_le_bytes());
            common.enqueue_with_wait(&mut packet,12,processed,backend)?;common.publish_frame(&mut[0;8],processed,backend)
        }else{if request[1]!=0{self.notify_completion([request[1],request[4],request[6],status,request[5],request[2]],backend)?;}Ok(status)}
    }
    pub fn unload_effect_prefix(&mut self,reference:u32,resources:&mut Registry,runtime:&mut Runtime,backend:&mut impl Services)->Result<(),Error>{
        let bank=self.banks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
        bank.effects.unload_effects(resources,runtime,backend)?;bank.synchronize();Ok(())
    }
    /// B21A30 shares the native31-head table inside bank-manager storage.
    pub fn lookup(&self,id:u32,memory:u32,backend:&mut impl Services)->Result<Option<u32>,Error>{
        backend.lock_bank_registry()?;let result=self.lookup_unlocked(id,memory);backend.unlock_bank_registry()?;result
    }
    /// B21AD0 leaves duplicate keys and their candidate holder untouched.
    pub fn register_holder(&mut self,id:u32,memory:u32,reference:u32,backend:&mut impl Services)->Result<(),Error>{
        backend.lock_bank_registry()?;
        let result=(||{
            if self.lookup_unlocked(id,memory)?.is_some(){return Ok(());}
            let bucket=0x38c+(id.wrapping_add(memory)%31)as usize*4;let next=word(&self.raw,bucket);
            let bank=self.banks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
            if bank.memory.reference!=reference||bank.memory.raw.len()!=80{return Err(Error::InvalidAllocation);}
            set(&mut bank.memory.raw,0,id);set(&mut bank.memory.raw,4,memory);set(&mut bank.memory.raw,8,next);
            set(&mut self.raw,bucket,reference);let count=word(&self.raw,0x408).wrapping_add(1);set(&mut self.raw,0x408,count);Ok(())
        })();backend.unlock_bank_registry()?;result
    }
    /// B21AA0/B21B40 unlink by exact key,retaining the removed holder's next field.
    pub fn unlink_holder(&mut self,id:u32,memory:u32,backend:&mut impl Services)->Result<Option<u32>,Error>{
        backend.lock_bank_registry()?;
        let result=(||{
            let Some(reference)=self.lookup_unlocked(id,memory)?else{return Ok(None);};
            let bucket=0x38c+(id.wrapping_add(memory)%31)as usize*4;let mut current=word(&self.raw,bucket);let mut previous=0;
            while current!=reference{previous=current;current=word(&self.banks.get(&current).ok_or(Error::UnresolvedReference)?.memory.raw,8);}
            let next=word(&self.banks[&reference].memory.raw,8);
            if previous==0{set(&mut self.raw,bucket,next);}else{set(&mut self.banks.get_mut(&previous).unwrap().memory.raw,8,next);}
            let count=word(&self.raw,0x408).wrapping_sub(1);set(&mut self.raw,0x408,count);Ok(Some(reference))
        })();backend.unlock_bank_registry()?;result
    }
    /// Memory mode1,command0,without an external retained holder. Keeps the
    /// allocated holder and successfully loaded prefix available after failure.
    pub fn read_memory(&mut self,id:u32,pool:u32,base:u32,bytes:Vec<u8>,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc_policy:UnknownHirc,chunk_policy:UnknownChunks,backend:&mut impl Services)->Result<Read,Error>{
        self.read_memory_deferred(id,pool,base,||Ok(bytes),resources,runtime,plugins,hirc_policy,chunk_policy,backend)
    }
    pub fn read_memory_deferred(&mut self,id:u32,pool:u32,base:u32,backing:impl FnOnce()->Result<Vec<u8>,Error>,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc_policy:UnknownHirc,chunk_policy:UnknownChunks,backend:&mut impl Services)->Result<Read,Error>{
        backend.lock_bank_registry()?;let cached=self.lookup(id,base,backend);let closed=backend.unlock_bank_registry();closed?;
        let cached=cached?;
        // AF9960 loaded-bank exit precedes scope/provider/stream consumption.
        if let Some(reference)=cached{if self.banks[&reference].memory.raw[72]&1!=0{return Ok(Read{status:69,holder:0});}}
        if self.raw[0x7c]==0{return Err(Error::Backend("bank scope owner construction not qualified"));}
        if word(&self.raw,28)!=0{return Err(Error::Backend("bank provider mode not qualified"));}
        let reference=if let Some(reference)=cached{
            reference
        }else{
            match backend.allocate(POOL,80)?{
                None=>0,Some(memory)=>{
                    let reference=memory.reference;if self.banks.contains_key(&reference)||runtime.objects.contains_key(&reference){return Err(Error::InvalidAllocation);}
                    self.banks.insert(reference,Bank::construct(memory,[id,pool,1,0,0])?);reference
                }
            }
        };
        let mut stream=Stream{raw:self.raw[..40].try_into().unwrap(),base,bytes:vec![]};stream.reset_memory();
        let result=(||{
            if reference==0{return Ok(52);}
            let bytes=backing()?;stream.attach_memory(base,bytes)?;
            let mut header=[0;20];let mut status=crate::audio_bank_header::read(&mut stream,&mut header,&mut self.raw[0x490])?;
            while status==1{
                let(_,chunk)=stream.header(8)?;
                if chunk.is_empty(){break;}
                if chunk.len()!=8{return Ok(7);}
                let tag:&[u8]=&chunk[..4];let size=word(&chunk,4);
                status=if tag==b"HIRC"{
                    effects::load_section(&mut stream,&mut self.banks.get_mut(&reference).unwrap().effects,resources,runtime,plugins,hirc_policy,backend)?
                }else if [b"STID",b"DIDX",b"DATA",b"STMG",b"ENVS"].iter().any(|known|tag==*known){
                    return Err(Error::Backend("bank chunk reader not implemented"));
                }else if chunk_policy==UnknownChunks::SkipNativeDefaults{if stream.skip_count(size)?==size{1}else{7}}
                else{return Err(Error::Backend("unknown bank chunk needs explicit skip policy"));};
            }Ok(status)
        })();
        stream.close_memory()?;self.raw[..40].copy_from_slice(&stream.raw);
        if let Some(bank)=self.banks.get_mut(&reference){bank.synchronize();}
        result.map(|status|Read{status,holder:reference})
    }
    /// Effect-only,unregistered holder cleanup. The full native caller destructor
    /// additionally owns registration/media/callback state and is still required.
    pub fn release_effect_holder(&mut self,reference:u32,resources:&mut Registry,runtime:&mut Runtime,backend:&mut impl Services)->Result<(),Error>{
        for i in 0..31{let mut r=word(&self.raw,0x38c+i*4);let mut seen=std::collections::BTreeSet::new();while r!=0{
            if r==reference{return Err(Error::Backend("registered bank requires caller unlink/destruction"));}
            if !seen.insert(r){return Err(Error::UnresolvedReference);}r=word(&self.banks.get(&r).ok_or(Error::UnresolvedReference)?.memory.raw,8);
        }}
        let bank=self.banks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
        if [16,20,32,36,40,44,48].iter().any(|&o|word(&bank.effects.raw,o)!=0){return Err(Error::Backend("bank holder owns additional unqualified storage"));}
        bank.effects.unload_effects(resources,runtime,backend)?;bank.synchronize();backend.free_pool(POOL,&bank.memory)?;self.banks.remove(&reference);Ok(())
    }
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::{Value,json};use crate::{audio_effect_resource_bank::{Services as BankServices,tests::Heap},audio_effect_resource_registry::Services as ResourceServices,audio_plugin_factory::{Allocator,Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR},audio_meter_lifecycle::Lifetime};
    struct Native{heap:Heap,notifications:Option<Memory>,wait_index:usize}
    impl Allocator for Native{fn allocate(&mut self,a:u32,s:u32)->Result<Option<Memory>,Error>{self.heap.allocate(a,s)}}
    impl Lifetime for Native{fn free(&mut self,a:u32,m:&Memory)->Result<(),Error>{Lifetime::free(&mut self.heap,a,m)}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("callback not expected during bank read"))}}
    impl BankServices for Native{fn free_pool(&mut self,a:u32,m:&Memory)->Result<(),Error>{self.heap.free_pool(a,m)}}
    impl ResourceServices for Native{fn lock(&mut self,c:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"registry","category":c}));Ok(())}fn unlock(&mut self,c:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"registry","category":c}));Ok(())}}
    impl effects::Services for Native{fn lock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_manager","category":null}));Ok(())}fn unlock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_manager","category":null}));Ok(())}}
    impl Services for Native{
        fn atomic_decrement(&mut self,object:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&object.raw,offset);let after=before.wrapping_sub(1);set(&mut object.raw,offset,after);self.heap.calls.push(json!({"kind":"atomic_decrement","reference":object.reference+offset as u32,"before":before,"after":after}));Ok(after)}
        fn notify_bank(&mut self,raw:&mut[u8;40],fields:[u32;6])->Result<(),Error>{
            let mut table=self.notifications.take().ok_or(Error::Backend("notification table not owned"))?;
            let result=crate::audio_bank_notification::dispatch(raw,&mut table,fields,self);self.notifications=Some(table);result
        }
        fn lock_bank_registry(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_registry","category":null}));Ok(())}fn unlock_bank_registry(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_registry","category":null}));Ok(())}}
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(raw:&[u8])->String{raw.iter().map(|b|format!("{b:02x}")).collect()}
    impl crate::audio_bank_notification::Services for Native{
        fn lock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_notification"}));Ok(())}
        fn unlock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_notification"}));Ok(())}
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn bank_callback(&mut self,_:u32,fields:[u32;5])->Result<(),Error>{self.heap.calls.push(json!({"kind":"bank_callback","fields":fields}));Ok(())}
    }
    impl crate::audio_bank_notification::StorageServices for Native{
        fn free_pool(&mut self,p:u32,m:&Memory)->Result<(),Error>{BankServices::free_pool(&mut self.heap,p,m)}
        fn close_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"close_handle","handle":handle}));Ok(())}
        fn delete_notification_mutex(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"delete_critical_section","reference":0x300304a0u32}));Ok(())}
    }
    impl crate::audio_bank_notification::WaitServices for Native{
        fn current_thread_id(&mut self)->Result<u32,Error>{self.heap.calls.push(json!({"kind":"current_thread","id":100}));Ok(100)}
        fn wait_event(&mut self,handle:u32,timeout:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"wait_event","handle":handle,"timeout":timeout}));Ok(())}
    }
    impl crate::audio_bank_command_queue::Services for Native{
        fn lock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_command_queue"}));Ok(())}
        fn unlock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_command_queue"}));Ok(())}
    }
    impl crate::audio_bank_command_worker::Services for Native{
        fn wait_worker(&mut self,handle:u32,stop:&mut u8)->Result<(),Error>{self.wait_index+=1;let published=self.wait_index==2;if published{*stop=1;}self.heap.calls.push(json!({"kind":"wait_event","handle":handle,"timeout":u32::MAX,"stop_published":published}));Ok(())}
    }
    #[test]fn audio_bank_holder_matches96_native_constructor_padding_flags_and_wrapping_counts(){
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_holder_contract.json")).unwrap();assert_eq!(p["case_count"],96);
        for row in p["cases"].as_array().unwrap(){let args=["id","pool","flag","initial","owned"].map(|k|row[k].as_u64().unwrap()as u32);let bank=Bank::construct(Memory{reference:0x30006000,raw:bytes(row["before"].as_str().unwrap())},args).unwrap();assert_eq!(hex(&bank.memory.raw),row["raw"].as_str().unwrap());assert_eq!(u64::from(bank.memory.reference),row["result"].as_u64().unwrap());assert!(row["calls"].as_array().unwrap().is_empty());}
    }
    #[test]fn audio_bank_memory_reader_matches96_native_holder_chunks_hirc_failure_and_cleanup_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_outer_reader_contract.json")).unwrap();assert_eq!(proof["case_count"],96);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};manager.raw[0x7c]=1;let mut resources=Registry::default();let mut runtime=Runtime::default();let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let data=bytes(row["bank_payload"].as_str().unwrap());let id=word(&data,12);let mut holder=0;
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=if j==0{let read=manager.read_memory(id,u32::MAX,0x30008000,data.clone(),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap();holder=read.holder;assert_eq!(u64::from(holder),row["holder_reference"].as_u64().unwrap());read.status}else{if holder!=0{manager.release_effect_holder(holder,&mut resources,&mut runtime,&mut native).unwrap();}0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");let root=manager.banks.get(&holder).map(|b|&b.memory).or_else(||native.heap.freed.get(&holder));if holder!=0{assert_eq!(hex(&root.unwrap().raw),stage["holder"].as_str().unwrap(),"holder {i}/{j}");}else{assert!(stage["holder"].is_null());}
                assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let memory=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&memory.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"owned bytes and frees {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"all kernel/lifetime calls {i}/{j}");
            }assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
        }
    }
    #[test]fn audio_bank_cache_matches36_native10_stage_registration_duplicates_collision_and_unlink_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_cache_contract.json")).unwrap();assert_eq!(proof["case_count"],36);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};set(&mut manager.raw,0x408,row["initial_count"].as_u64().unwrap()as u32);let mut native=Native{heap:Heap{pattern:0,next:0,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};
            let id=row["id"].as_u64().unwrap()as u32;let key=row["memory"].as_u64().unwrap()as u32;let ids:Vec<u32>=row["initial_nodes"].as_array().unwrap().iter().map(|v|{let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());let effects=Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}};manager.banks.insert(reference,Bank{memory:Memory{reference,raw},effects});reference}).collect();
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let name=stage["stage"].as_str().unwrap();let current_id=if name.contains("collision"){id.wrapping_add(31)}else{id};
                let result=if name.starts_with("lookup"){manager.lookup(current_id,key,&mut native).unwrap().unwrap_or(0)}else if name.starts_with("register"){
                    let reference=if name.contains("duplicate"){ids[1]}else if name.contains("collision"){ids[2]}else{ids[0]};manager.register_holder(current_id,key,reference,&mut native).unwrap();0
                }else{manager.unlink_holder(current_id,key,&mut native).unwrap();0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(hex(&manager.raw[0x38c..0x40c]),stage["table"].as_str().unwrap(),"table/count {i}/{j}");
                for node in stage["nodes"].as_array().unwrap(){let r=node["reference"].as_u64().unwrap()as u32;assert_eq!(hex(&manager.banks[&r].memory.raw),node["raw"].as_str().unwrap(),"holder/link preservation {i}/{j}");}
                assert_eq!(json!(native.heap.calls),stage["calls"],"cache lock order {i}/{j}");
            }
        }
    }
    #[test]fn audio_bank_cached_reader_matches64_native_loaded_shortcut_inactive_reuse_and_failure_cleanup_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_cached_reader_contract.json")).unwrap();assert_eq!(proof["case_count"],64);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let raw=bytes(row["initial_holder"].as_str().unwrap());let effects=Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}};manager.banks.insert(0x30006000,Bank{memory:Memory{reference:0x30006000,raw},effects});
            let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![(0x30006000,80)],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};let mut resources=Registry::default();let mut runtime=Runtime::default();let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let data=bytes(row["bank_payload"].as_str().unwrap());let id=word(&data,12);
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=if j==0{let read=manager.read_memory(id,u32::MAX,0x30008000,data.clone(),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap();assert_eq!(u64::from(read.holder),row["holder_reference"].as_u64().unwrap());read.status}else{assert_eq!(manager.unlink_holder(id,0x30008000,&mut native).unwrap(),Some(0x30006000));manager.release_effect_holder(0x30006000,&mut resources,&mut runtime,&mut native).unwrap();0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");let root=manager.banks.get(&0x30006000).map(|b|&b.memory).or_else(||native.heap.freed.get(&0x30006000)).unwrap();assert_eq!(hex(&root.raw),stage["holder"].as_str().unwrap(),"registered keys/counters {i}/{j}");assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all owned bytes and frees {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"complete lock/lifetime order {i}/{j}");
            }assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
        }
    }

    #[test]fn audio_bank_caller_matches96_native_register_repeat_failed_prefix_atomic_destructor_and_null_completion_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_caller_contract.json")).unwrap();assert_eq!(proof["case_count"],96);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};manager.raw[0x7c]=1;let mut resources=Registry::default();let mut runtime=Runtime::default();let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let data=bytes(row["bank_payload"].as_str().unwrap());let request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=if stage["stage"]!="unlink_unload_release"{manager.load_request(request,data.clone(),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap()}else{let r=word(&manager.raw,0x38c+(request[4].wrapping_add(request[6])%31)as usize*4);if r!=0{manager.unlink_holder(request[4],request[6],&mut native).unwrap();manager.unload_effect_prefix(r,&mut resources,&mut runtime,&mut native).unwrap();assert!(manager.destroy_empty_holder(r,true,&mut native).unwrap());}0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all owned bytes/frees {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"complete cache/atomic/lifetime order {i}/{j}");
            }assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
        }
    }
    #[test]fn audio_bank_caller_explicit_unsupported_chunk_error_releases_new_effect_prefix_and_holder(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_caller_contract.json")).unwrap();let row=proof["cases"].as_array().unwrap().iter().find(|v|v["packet"]=="one").unwrap();let mut data=bytes(row["bank_payload"].as_str().unwrap());data.extend_from_slice(b"STID");data.extend_from_slice(&0u32.to_le_bytes());let mut request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();request[7]=data.len()as u32;
        let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};manager.raw[0x7c]=1;let mut resources=Registry::default();let mut runtime=Runtime::default();let mut native=Native{heap:Heap{pattern:0xa5,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
        assert!(matches!(manager.load_request(request,data,&mut resources,&mut runtime,&plugins,UnknownHirc::Reject,UnknownChunks::Reject,&mut native),Err(Error::Backend(_))));assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());assert_eq!(word(&manager.raw,0x408),0);
    }

    #[test]fn audio_bank_loaded_cache_matches12_native_provider_scope_and_stream_preservation_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_cached_shortcut_contract.json")).unwrap();assert_eq!(proof["case_count"],12);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let raw:[u8;0x500]=bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap();let holder=bytes(row["initial_holder"].as_str().unwrap());let reference=0x30006000;
            let mut manager=Manager{raw,banks:BTreeMap::new()};manager.banks.insert(reference,Bank{effects:Holder{raw:holder[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference,raw:holder.clone()}});
            let mut native=Native{heap:Heap{pattern:0,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:None,wait_index:0};let mut resources=Registry::default();let mut runtime=Runtime::default();let plugins=Plugins{entries:vec![]};
            let result=manager.read_memory(0x12345,POOL,0x30008000,vec![],&mut resources,&mut runtime,&plugins,UnknownHirc::Reject,UnknownChunks::Reject,&mut native).unwrap();
            assert_eq!(u64::from(result.status),row["result"].as_u64().unwrap(),"status {i}");assert_eq!(u64::from(result.holder),row["holder_reference"].as_u64().unwrap());assert_eq!(manager.raw,raw,"manager preserved {i}");assert_eq!(manager.banks[&reference].memory.raw,holder,"holder preserved {i}");assert_eq!(json!(native.heap.calls),row["calls"],"recursive locks only {i}");assert!(native.heap.allocations.is_empty());assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());
        }
    }

    #[test]fn audio_bank_caller_nonzero_completion_matches192_native_integrated_success_failure_cancellation_and_destructor_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_caller_notification_contract.json")).unwrap();assert_eq!(proof["case_count"],192);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let mut resources=Registry::default();let mut runtime=Runtime::default();let initial=&row["initial_allocations"][0];let table=Memory{reference:initial["reference"].as_u64().unwrap()as u32,raw:bytes(initial["raw"].as_str().unwrap())};
            let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![(table.reference,table.raw.len()as u32)],freed:BTreeMap::new(),methods:true},notifications:Some(table),wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let data=bytes(row["bank_payload"].as_str().unwrap());let request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=if stage["stage"]!="unlink_unload_release_and_notification_destructor"{manager.load_request(request,data.clone(),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap()}else{
                    let r=word(&manager.raw,0x38c+(request[4].wrapping_add(request[6])%31)as usize*4);if r!=0{manager.unlink_holder(request[4],request[6],&mut native).unwrap();manager.unload_effect_prefix(r,&mut resources,&mut runtime,&mut native).unwrap();assert!(manager.destroy_empty_holder(r,true,&mut native).unwrap());}
                    let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};context.destroy(&mut native).unwrap();manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);0
                };
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"whole manager/notification context {i}/{j}");assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).or_else(||native.notifications.as_ref().filter(|m|m.reference==r)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all owned bytes/free flags {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"full completion/cache/atomic/lifetime order {i}/{j}");
            }assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
        }
    }

    #[test]fn audio_bank_command_worker_matches512_native_admission_pop_load_completion_failure_arena_and_dynamic_lifetime_sequences(){
        let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bank_command_worker_contract.json")).unwrap();assert_eq!(proof["case_count"],512);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let mut queue=crate::audio_bank_command_queue::Queue::default();let mut worker=crate::audio_bank_command_worker::Worker{thread:100};let mut resources=Registry::default();let mut runtime=Runtime::default();let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:Some(Memory{reference:0,raw:vec![]}),wait_index:0};
            for v in row["initial_allocations"].as_array().unwrap(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};native.heap.allocations.push((m.reference,m.raw.len()as u32));queue.nodes.insert(m.reference,m);}
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let data=bytes(row["bank_payload"].as_str().unwrap());let request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){native.heap.calls.clear();let result=match stage["stage"].as_str().unwrap(){
                "admit"=>{let mut table=native.notifications.take().unwrap();let status=queue.admit(&mut manager.raw,&mut table,request,worker.thread,&mut native).unwrap();native.notifications=Some(table);status},
                "worker"=>{let mut backing=|base:u32,length:u32|{assert_eq!(base,request[6]);assert_eq!(length as usize,data.len());Ok(data.clone())};let status=worker.run(&mut manager,&mut queue,&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut backing,&mut native).unwrap();assert_eq!(native.wait_index,2);status},
                "final_fixture_cleanup"=>{let r=word(&manager.raw,0x38c+(request[4].wrapping_add(request[6])%31)as usize*4);if r!=0{manager.unlink_holder(request[4],request[6],&mut native).unwrap();manager.unload_effect_prefix(r,&mut resources,&mut runtime,&mut native).unwrap();assert!(manager.destroy_empty_holder(r,true,&mut native).unwrap());}let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};context.destroy(&mut native).unwrap();manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);for m in queue.nodes.values(){BankServices::free_pool(&mut native.heap,POOL,m).unwrap();}queue.nodes.clear();0},
                _=>panic!("unknown native stage"),
            };
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"whole manager {i}/{j}");assert_eq!(u64::from(worker.thread),stage["worker_thread"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||queue.nodes.get(&r)).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).or_else(||native.notifications.as_ref().filter(|m|m.reference==r)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all owned bytes/free flags {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"complete admission/pop/load/notification order {i}/{j}");
            }assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.freed.len(),native.heap.allocations.len());
        }
    }

    #[test]fn audio_bank_cached_backing_matches36_native_null_unmapped_and_arbitrary_length_cases_without_resolution(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_cached_backing_contract.json")).unwrap();assert_eq!(proof["case_count"],36);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){for deferred in [false,true]{
            let holder=bytes(row["initial_holder"].as_str().unwrap());let mut manager=Manager{raw:bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};manager.banks.insert(0x30006000,Bank{effects:Holder{raw:holder[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference:0x30006000,raw:holder}});
            let mut native=Native{heap:Heap{pattern:0,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:Some(Memory{reference:0x30006800,raw:bytes(row["initial_table"].as_str().unwrap())}),wait_index:0};let mut resources=Registry::default();let mut runtime=Runtime::default();let plugins=Plugins{entries:vec![]};let request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
            let result=if deferred{manager.load_request_deferred(request,||panic!("loaded bank must not resolve backing"),&mut resources,&mut runtime,&plugins,UnknownHirc::Reject,UnknownChunks::Reject,&mut native).unwrap()}else{manager.load_request(request,vec![],&mut resources,&mut runtime,&plugins,UnknownHirc::Reject,UnknownChunks::Reject,&mut native).unwrap()};
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap());assert_eq!(hex(&manager.raw),row["manager"].as_str().unwrap(),"manager {i}/{deferred}");assert_eq!(hex(&manager.banks[&0x30006000].memory.raw),row["holder"].as_str().unwrap());assert_eq!(hex(&native.notifications.as_ref().unwrap().raw),row["table"].as_str().unwrap());assert_eq!(json!(native.heap.calls),row["calls"],"locks/completion without backing {i}/{deferred}");assert!(native.heap.allocations.is_empty());assert!(runtime.objects.is_empty());
        }}
    }

    impl crate::audio_common_queue::Services for Native{
        fn free_pool(&mut self,p:u32,m:&Memory)->Result<(),Error>{BankServices::free_pool(&mut self.heap,p,m)}
        fn lock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"audio_common_queue"}));Ok(())}
        fn unlock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"audio_common_queue"}));Ok(())}
    }
    impl crate::audio_common_queue::RetryServices for Native{
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn wait_event(&mut self,_:u32,_:u32,_:&mut crate::audio_common_queue::Context,_:&mut u32)->Result<(),Error>{Err(Error::Backend("unexpected deferred queue wait in controlled empty queue"))}
        fn dispatch_command(&mut self,_:&[u8])->Result<(),Error>{Err(Error::Backend("bank commands require concrete manager ownership"))}
    }
    fn replay_deferred_unload(proof:&Value,retention:bool){
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};manager.raw[0x7c]=1;let mut resources=Registry::default();let mut runtime=Runtime::default();
            let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:Some(Memory{reference:0,raw:vec![]}),wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            let request:[u32;9]=row["request"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();let mut load=request;load[0]=0;load[1]=0;load[2]=0;assert_eq!(manager.load_request(load,bytes(row["bank_payload"].as_str().unwrap()),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap(),1);set(&mut manager.raw,0x494+36,123);if retention{let r=*manager.banks.keys().next().unwrap();let bank=manager.banks.get_mut(&r).unwrap();set(&mut bank.memory.raw,64,row["holder_refs"].as_u64().unwrap()as u32);set(&mut bank.memory.raw,68,row["holder_total"].as_u64().unwrap()as u32);}
            if request[1]!=0{let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};assert_eq!(context.register(100,&mut native).unwrap(),1);manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);}
            let before=&row["stages"][0];let page_size=row["page_size"].as_u64().unwrap()as u32;let mut common=crate::audio_common_queue::Context{raw:bytes(before["common"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30005800,raw:bytes(before["common_table"].as_str().unwrap())},pages:BTreeMap::new(),page_size};for(j,p)in before["pages"].as_array().unwrap().iter().enumerate(){let reference=0x3000a000+j as u32*0x1000;common.pages.insert(reference,Memory{reference,raw:bytes(p.as_str().unwrap())});}
            let mut processed=0;
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                native.heap.calls.clear();let result=match j{0=>1,1=>manager.unload_request(request,&mut common,&mut processed,&mut resources,&mut runtime,&mut native).unwrap(),2=>crate::audio_bank_deferred_consumer::consume(&mut common,&mut manager,&crate::audio_bank_deferred_consumer::VoiceOwners::default(),&mut processed,&mut native).unwrap(),3=>{if retention{if let Some(r)=manager.banks.keys().next().copied(){set(&mut manager.banks.get_mut(&r).unwrap().memory.raw,68,0);while manager.banks.contains_key(&r){manager.destroy_empty_holder(r,true,&mut native).unwrap();}}}let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};context.destroy(&mut native).unwrap();manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);0},_=>unreachable!()};
                assert_eq!(result as u64,stage["result"].as_u64().unwrap(),"result {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");assert_eq!(hex(&common.raw),stage["common"].as_str().unwrap(),"common {i}/{j}");assert_eq!(hex(&common.table.raw),stage["common_table"].as_str().unwrap());assert_eq!(processed as u64,stage["processed"].as_u64().unwrap());
                for(k,page)in common.pages.values().enumerate(){let mut expected=bytes(stage["pages"][k].as_str().unwrap());let mut actual=page.raw.clone();if j>0&&k==0{for o in [4,5,6,7,16,17,18,19]{expected[o]=0;actual[o]=0;}}assert_eq!(actual,expected,"page bytes excluding undefined native stack padding {i}/{j}/{k}");}
                assert_eq!(resources.counts[0]as u64,stage["custom_count"].as_u64().unwrap());assert_eq!(resources.counts[1]as u64,stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).or_else(||native.notifications.as_ref().filter(|t|t.reference==r)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all bank/notification storage {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"physical calls {i}/{j}");
            }
            assert!(manager.banks.is_empty());assert!(runtime.objects.is_empty());assert_eq!(native.heap.allocations.len(),native.heap.freed.len());
        }
    }


    #[test]fn audio_bank_deferred_unload_matches24_native_cache_effect_queue_frame_holder_callback_and_cleanup_sequences(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_deferred_unload_contract.json")).unwrap();assert_eq!(proof["case_count"],24);replay_deferred_unload(&proof,false);}
    #[test]fn audio_bank_deferred_retention_matches24_native_owned_counters_and_callback_timing_cases(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_deferred_unload_retention_contract.json")).unwrap();assert_eq!(proof["case_count"],24);replay_deferred_unload(&proof,true);}
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
                    0=>0,1=>{let mut table=native.notifications.take().unwrap();let result=queue.admit(&mut manager.raw,&mut table,request,100,&mut native).unwrap();native.notifications=Some(table);result},
                    2=>{let mut table=native.notifications.take().unwrap();let result=queue.admit(&mut manager.raw,&mut table,unload,100,&mut native).unwrap();native.notifications=Some(table);result},
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

    #[test]fn audio_bank_unload_shortcut_matches16_native_missing_inactive_pool_callback_and_storage_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_unload_shortcut_contract.json")).unwrap();assert_eq!(proof["case_count"],16);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:[0;0x500],banks:BTreeMap::new()};manager.raw[0x7c]=1;let mut resources=Registry::default();let mut runtime=Runtime::default();let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true},notifications:Some(Memory{reference:0,raw:vec![]}),wait_index:0};let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            let request:[u32;9]=row["request"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();if row["inactive"]==true{let load:[u32;9]=row["load_request"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();assert_eq!(manager.load_request(load,bytes(row["bank_payload"].as_str().unwrap()),&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,UnknownChunks::SkipNativeDefaults,&mut native).unwrap(),1);manager.banks.values_mut().next().unwrap().memory.raw[72]&=!1;}set(&mut manager.raw,0x494+36,123);
            if request[1]!=0{let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};assert_eq!(context.register(100,&mut native).unwrap(),1);manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);}
            let first=&row["stages"][0];let mut common=crate::audio_common_queue::Context{raw:bytes(first["common"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30005800,raw:bytes(first["common_table"].as_str().unwrap())},pages:BTreeMap::new(),page_size:64};for(j,p)in first["pages"].as_array().unwrap().iter().enumerate(){let reference=0x3000a000+j as u32*0x1000;common.pages.insert(reference,Memory{reference,raw:bytes(p.as_str().unwrap())});}let mut processed=0;
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){native.heap.calls.clear();let result=match j{
                0=>0,1=>manager.unload_request(request,&mut common,&mut processed,&mut resources,&mut runtime,&mut native).unwrap(),
                2=>{if row["inactive"]==true{let reference=manager.unlink_holder(request[4],request[6],&mut native).unwrap().unwrap();manager.unload_effect_prefix(reference,&mut resources,&mut runtime,&mut native).unwrap();manager.destroy_empty_holder(reference,true,&mut native).unwrap();}let mut context=crate::audio_bank_notification::Context{raw:manager.raw[0x494..0x4bc].try_into().unwrap(),table:native.notifications.take().unwrap()};context.destroy(&mut native).unwrap();manager.raw[0x494..0x4bc].copy_from_slice(&context.raw);native.notifications=Some(context.table);0},_=>unreachable!()};
                assert_eq!(result as u64,stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager.raw),stage["manager"].as_str().unwrap(),"manager {i}/{j}");assert_eq!(hex(&common.raw),stage["common"].as_str().unwrap(),"common {i}/{j}");assert_eq!(hex(&common.table.raw),stage["common_table"].as_str().unwrap());assert_eq!(processed as u64,stage["processed"].as_u64().unwrap());for(k,p)in common.pages.values().enumerate(){assert_eq!(hex(&p.raw),stage["pages"][k].as_str().unwrap());}
                assert_eq!(resources.counts[0]as u64,stage["custom_count"].as_u64().unwrap());assert_eq!(resources.counts[1]as u64,stage["shared_count"].as_u64().unwrap());let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||runtime.objects.get(&r)).or_else(||manager.banks.get(&r).map(|b|&b.memory)).or_else(||manager.banks.values().find(|b|b.effects.slots.reference==r).map(|b|&b.effects.slots)).or_else(||native.notifications.as_ref().filter(|t|t.reference==r)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"storage {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"physical order {i}/{j}");
            }
        }
    }

}
