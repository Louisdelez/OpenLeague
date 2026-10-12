//! AFBAE0 bank command admission and AF8AE0 owned40-byte-node queue.
//! Normal dequeue/processing/destructor and OS worker scheduling remain separate.
use crate::{audio_bus_bank::Error,audio_plugin_factory::{Memory,Allocator},audio_bank_notification::{Context,StorageServices,WaitServices}};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:StorageServices+WaitServices{
    fn lock_queue(&mut self)->Result<(),Error>;
    fn unlock_queue(&mut self)->Result<(),Error>;
}
#[derive(Default)]pub struct Queue{pub nodes:BTreeMap<u32,Memory>}
impl Queue{
    fn node(&self,r:u32)->Result<&Memory,Error>{let m=self.nodes.get(&r).ok_or(Error::UnresolvedReference)?;if m.reference!=r||m.raw.len()!=40{return Err(Error::InvalidAllocation);}Ok(m)}
    /// AF8AE0 appends using free nodes before considering count/capacity admission.
    pub fn push(&mut self,raw:&mut[u8;24],request:[u32;9],services:&mut impl Allocator)->Result<bool,Error>{
        let mut reference=word(raw,8);let tail=word(raw,4);
        if tail!=0{self.node(tail)?;}
        if reference==0{
            if word(raw,20)>=word(raw,16){return Ok(false);}
            let Some(mut memory)=services.allocate(u32::MAX,40)?else{return Ok(false);};
            reference=memory.reference;if reference==0||memory.raw.len()!=40||self.nodes.contains_key(&reference){return Err(Error::InvalidAllocation);}
            set(&mut memory.raw,0,word(raw,8));self.nodes.insert(reference,memory);set(raw,8,reference);
        }
        let next=word(&self.node(reference)?.raw,0);
        if tail==reference{return Err(Error::Backend("queue active/free node alias"));}
        if tail==0{set(raw,0,reference);}else{set(&mut self.nodes.get_mut(&tail).unwrap().raw,0,reference);}
        set(raw,4,reference);set(raw,8,next);let memory=&mut self.nodes.get_mut(&reference).unwrap().raw;set(memory,0,0);let count=word(raw,20).wrapping_add(1);set(raw,20,count);
        for(i,v)in request.into_iter().enumerate(){set(memory,4+i*4,v);}Ok(true)
    }
    /// AF8C80 queue-pop prefix; caller holds queue lock. Copy precedes release.
    pub fn pop(&mut self,manager:&mut[u8;0x500],services:&mut impl StorageServices)->Result<Option<[u32;9]>,Error>{
        if word(manager,0x74)==0{return Ok(None);}
        let reference=word(manager,0x60);let memory=self.node(reference)?;
        let request=std::array::from_fn(|i|word(&memory.raw,4+i*4));let next=word(&memory.raw,0);
        set(manager,0x60,next);if reference==word(manager,0x64){set(manager,0x64,0);}
        let arena=word(manager,0x78);let end=arena.wrapping_add(word(manager,0x6c).wrapping_mul(40));
        if reference>=arena&&reference<end{let free=word(manager,0x68);set(&mut self.nodes.get_mut(&reference).unwrap().raw,0,free);set(manager,0x68,reference);}
        else{services.free_pool(u32::MAX,&self.nodes[&reference])?;self.nodes.remove(&reference);}
        let count=word(manager,0x74).wrapping_sub(1);set(manager,0x74,count);Ok(Some(request))
    }
    /// AFBAE0 registers callback before enqueue and withdraws on enqueue failure.
    /// Actual manager bytes own both queue fields60..78 and notification494..4BC.
    pub fn admit(&mut self,manager:&mut[u8;0x500],table:&mut Memory,request:[u32;9],worker_thread:u32,services:&mut impl Services)->Result<u32,Error>{
        services.lock_queue()?;
        let mut queue:[u8;24]=manager[0x60..0x78].try_into().unwrap();
        let mut context=Context{raw:manager[0x494..0x4bc].try_into().unwrap(),table:std::mem::replace(table,Memory{reference:0,raw:vec![]})};
        let result=(||{
            if request[1]!=0{let status=context.register(request[2],services)?;if status!=1{return Ok(status);}}
            if !self.push(&mut queue,request,services)?{
                if request[1]!=0{context.withdraw(request[2],worker_thread,services)?;}return Ok(2);
            }
            crate::audio_bank_notification::Services::set_event(services,word(manager,0x28))?;Ok(1)
        })();
        manager[0x60..0x78].copy_from_slice(&queue);manager[0x494..0x4bc].copy_from_slice(&context.raw);*table=context.table;
        services.unlock_queue()?;result
    }
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::{Value,json};use crate::{audio_effect_resource_bank::{tests::Heap,Services as PoolServices},audio_bank_notification::{Services as NotificationServices}};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
    struct Native{heap:Heap}
    impl Allocator for Native{fn allocate(&mut self,a:u32,s:u32)->Result<Option<Memory>,Error>{self.heap.allocate(a,s)}}
    impl NotificationServices for Native{
        fn lock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_notification"}));Ok(())}
        fn unlock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_notification"}));Ok(())}
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn bank_callback(&mut self,_:u32,fields:[u32;5])->Result<(),Error>{self.heap.calls.push(json!({"kind":"bank_callback","fields":fields}));Ok(())}
    }
    impl StorageServices for Native{
        fn free_pool(&mut self,p:u32,m:&Memory)->Result<(),Error>{PoolServices::free_pool(&mut self.heap,p,m)}
        fn close_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"close_handle","handle":handle}));Ok(())}
        fn delete_notification_mutex(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"delete_critical_section","reference":0x300304a0u32}));Ok(())}
    }
    impl WaitServices for Native{
        fn current_thread_id(&mut self)->Result<u32,Error>{self.heap.calls.push(json!({"kind":"current_thread","id":100}));Ok(100)}
        fn wait_event(&mut self,handle:u32,timeout:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"wait_event","handle":handle,"timeout":timeout}));Ok(())}
    }
    impl Services for Native{
        fn lock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_command_queue"}));Ok(())}
        fn unlock_queue(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_command_queue"}));Ok(())}
    }
    #[test]fn audio_bank_command_queue_matches96_native_admission_registration_rollback_free_list_capacity_and_failure_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_command_queue_contract.json")).unwrap();assert_eq!(proof["case_count"],96);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager:[u8;0x500]=bytes(row["initial_manager"].as_str().unwrap()).try_into().unwrap();let mut queue=Queue::default();let mut table=Memory{reference:0,raw:vec![]};let mut native=Native{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:BTreeMap::new(),methods:true}};
            for v in row["initial_allocations"].as_array().unwrap(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};native.heap.allocations.push((m.reference,m.raw.len()as u32));queue.nodes.insert(m.reference,m);}
            let request:[u32;9]=row["request_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){native.heap.calls.clear();let result=queue.admit(&mut manager,&mut table,request,100,&mut native).unwrap();assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&manager),stage["manager"].as_str().unwrap(),"whole manager {i}/{j}");
                let allocations:Vec<Value>=native.heap.allocations.iter().map(|&(r,s)|{let m=native.heap.freed.get(&r).or_else(||queue.nodes.get(&r)).or_else(||(table.reference==r).then_some(&table)).unwrap();json!({"reference":r,"size":s,"freed":native.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all node/table bytes and free flags {i}/{j}");assert_eq!(json!(native.heap.calls),stage["calls"],"lock/register/enqueue/withdraw/signal order {i}/{j}");
            }
            let mut context=Context{raw:manager[0x494..0x4bc].try_into().unwrap(),table};context.destroy(&mut native).unwrap();for m in queue.nodes.values(){StorageServices::free_pool(&mut native,u32::MAX,m).unwrap();}assert_eq!(native.heap.allocations.len(),native.heap.freed.len());
        }
    }
}
