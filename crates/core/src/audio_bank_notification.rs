//! B14630 bank notification receiver and B01300 ordered cookie removal.
//! Producer/growth/destructor/withdrawal follow native ownership; OS concurrency remains separate.
use crate::{audio_bus_bank::Error,audio_plugin_factory::{Memory,Allocator}};
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services{
    fn lock_notification(&mut self)->Result<(),Error>;
    fn unlock_notification(&mut self)->Result<(),Error>;
    fn reset_event(&mut self,handle:u32)->Result<(),Error>;
    fn set_event(&mut self,handle:u32)->Result<(),Error>;
    fn bank_callback(&mut self,callback:u32,fields:[u32;5])->Result<(),Error>;
}
pub trait StorageServices:Services+Allocator{
    fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
    fn close_event(&mut self,handle:u32)->Result<(),Error>;
    fn delete_notification_mutex(&mut self)->Result<(),Error>;
}
pub trait Initialization:StorageServices{
    fn initialize_notification_mutex(&mut self,raw:&mut[u8;24])->Result<(),Error>;
    fn create_event(&mut self,fields:[u32;4])->Result<u32,Error>;
}
pub trait WaitServices:Services{
    fn current_thread_id(&mut self)->Result<u32,Error>;
    fn wait_event(&mut self,handle:u32,timeout:u32)->Result<(),Error>;
}
/// Borrow the manager's actual40-byte notification fields while owning its table.
/// Publish mutations even when a physical service reports an explicit error.
pub fn dispatch(raw:&mut[u8;40],table:&mut Memory,fields:[u32;6],services:&mut impl Services)->Result<(),Error>{
    let mut context=Context{raw:*raw,table:std::mem::replace(table,Memory{reference:0,raw:vec![]})};
    let result=context.notify(fields,services);*raw=context.raw;*table=context.table;result
}
pub struct Context{pub raw:[u8;40],pub table:Memory}
impl Context{
    /// B14520 owns an initially unsignaled manual-reset completion event.
    pub fn construct(mut raw:[u8;40],services:&mut impl Initialization)->Result<Self,Error>{
        for o in [0,4,8]{set(&mut raw,o,0);}
        services.initialize_notification_mutex((&mut raw[12..36]).try_into().unwrap())?;
        set(&mut raw,36,0);let handle=services.create_event([0,1,0,0])?;set(&mut raw,36,handle);
        Ok(Self{raw,table:Memory{reference:0,raw:vec![]}})
    }
    fn active_count(&self)->Result<usize,Error>{
        let count=word(&self.raw,4)as usize;
        if count>word(&self.raw,8)as usize{return Err(Error::InvalidAllocation);}
        if count!=0&&(self.table.reference!=word(&self.raw,0)||self.table.reference==0||count.checked_mul(12).filter(|n|*n<=self.table.raw.len()).is_none()){return Err(Error::InvalidAllocation);}
        Ok(count)
    }
    fn remove(&mut self,i:usize,count:usize){self.table.raw.copy_within((i+1)*12..count*12,i*12);set(&mut self.raw,4,(count as u32).wrapping_sub(1));}
    /// B145B0 registration; B14810 inserts and B146F0 grows by5 records.
    pub fn register(&mut self,cookie:u32,services:&mut impl StorageServices)->Result<u32,Error>{
        services.lock_notification()?;
        let result=(||{
            let count=self.active_count()?;
            if let Some(i)=(0..count).find(|i|word(&self.table.raw,i*12)==cookie){let o=i*12+4;let refs=word(&self.table.raw,o);set(&mut self.table.raw,o,refs.wrapping_add(1));return Ok(1);}
            let capacity=word(&self.raw,8)as usize;
            if count>=capacity{
                let new_capacity=(capacity as u32).checked_add(5).ok_or(Error::InvalidAllocation)?;
                let size=new_capacity.checked_mul(12).ok_or(Error::InvalidAllocation)?;
                let Some(mut table)=services.allocate(u32::MAX,size)?else{return Ok(52);};
                if table.reference==0||table.raw.len()!=size as usize{return Err(Error::InvalidAllocation);}
                if word(&self.raw,0)!=0{
                    if self.table.reference!=word(&self.raw,0)||count*12>self.table.raw.len(){return Err(Error::InvalidAllocation);}
                    table.raw[..count*12].copy_from_slice(&self.table.raw[..count*12]);services.free_pool(u32::MAX,&self.table)?;
                }
                set(&mut self.raw,0,table.reference);set(&mut self.raw,8,new_capacity);self.table=table;
            }
            if self.table.reference!=word(&self.raw,0)||self.table.reference==0||count*12+12>self.table.raw.len(){return Err(Error::InvalidAllocation);}
            let o=count*12;set(&mut self.table.raw,o,cookie);set(&mut self.table.raw,o+4,1);set(&mut self.table.raw,o+8,0);set(&mut self.raw,4,(count as u32).wrapping_add(1));Ok(1)
        })();services.unlock_notification()?;result
    }
    /// B14560 teardown; handle field is deliberately retained after physical close.
    pub fn destroy(&mut self,services:&mut impl StorageServices)->Result<(),Error>{
        if word(&self.raw,0)!=0{
            if self.table.reference!=word(&self.raw,0)||self.table.reference==0{return Err(Error::InvalidAllocation);}
            set(&mut self.raw,4,0);services.free_pool(u32::MAX,&self.table)?;set(&mut self.raw,0,0);set(&mut self.raw,8,0);self.table=Memory{reference:0,raw:vec![]};
        }
        let event=word(&self.raw,36);if event!=0{services.close_event(event)?;}
        services.delete_notification_mutex()
    }
    /// B14790 withdrawal waits for completion only when called off the worker.
    pub fn withdraw(&mut self,cookie:u32,worker_thread:u32,services:&mut impl WaitServices)->Result<(),Error>{
        services.lock_notification()?;
        let result=(||{let count=self.active_count()?;if let Some(i)=(0..count).find(|i|word(&self.table.raw,i*12)==cookie){let o=i*12+4;let refs=word(&self.table.raw,o);if refs<=1{self.remove(i,count);}else{set(&mut self.table.raw,o,refs.wrapping_sub(1));}}Ok(())})();
        services.unlock_notification()?;result?;
        if services.current_thread_id()?!=worker_thread{services.wait_event(word(&self.raw,36),u32::MAX)?;}Ok(())
    }
    /// Callback cookie lookup consumes the first matching registration. Cancellation
    /// is captured before ref/count mutation; events bracket the external callback.
    pub fn notify(&mut self,fields:[u32;6],services:&mut impl Services)->Result<(),Error>{
        let[callback,id,memory,status,pool,cookie]=fields;
        if callback==0{return Ok(());}
        services.lock_notification()?;
        let result=(||{
            let count=word(&self.raw,4)as usize;
            if count==0{return Ok(None);}
            let capacity=word(&self.raw,8)as usize;
            if count>capacity||self.table.reference!=word(&self.raw,0)||self.table.reference==0||count.checked_mul(12).filter(|n|*n<=self.table.raw.len()).is_none(){return Err(Error::InvalidAllocation);}
            let Some(i)=(0..count).find(|i|word(&self.table.raw,i*12)==cookie)else{return Ok(None);};
            let o=i*12;let refs=word(&self.table.raw,o+4);let cancelled=word(&self.table.raw,o+8);let suppressed=cancelled!=0;
            if refs<=1{
                self.table.raw.copy_within(o+12..count*12,o);
                set(&mut self.raw,4,(count as u32).wrapping_sub(1));
            }else{
                set(&mut self.table.raw,o+4,refs.wrapping_sub(1));
                if suppressed{set(&mut self.table.raw,o+8,cancelled.wrapping_sub(1));}
            }
            let handle=word(&self.raw,36);services.reset_event(handle)?;
            Ok(Some((suppressed,handle)))
        })();
        services.unlock_notification()?;
        if let Some((suppressed,handle))=result?{
            if !suppressed{services.bank_callback(callback,[id,memory,status,pool,cookie])?;}
            services.set_event(handle)?;
        }Ok(())
    }
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
    struct Physical{calls:Vec<Value>}
    impl Services for Physical{
        fn lock_notification(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_notification"}));Ok(())}
        fn unlock_notification(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_notification"}));Ok(())}
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn bank_callback(&mut self,_callback:u32,fields:[u32;5])->Result<(),Error>{self.calls.push(json!({"kind":"bank_callback","fields":fields}));Ok(())}
    }
    #[test]fn audio_bank_notification_matches198_native_sequences594_dispatches_ordered_removal_and_cancellation(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_notification_contract.json")).unwrap();assert_eq!(proof["case_count"],198);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let raw:[u8;40]=bytes(row["initial_context"].as_str().unwrap()).try_into().unwrap();let mut context=Context{raw,table:Memory{reference:0x30006800,raw:bytes(row["initial_table"].as_str().unwrap())}};
            let fields:[u32;6]=row["fields"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();let mut services=Physical{calls:vec![]};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){services.calls.clear();context.notify(fields,&mut services).unwrap();assert_eq!(hex(&context.raw),stage["context"].as_str().unwrap(),"context {i}/{j}");assert_eq!(hex(&context.table.raw),stage["table"].as_str().unwrap(),"active/inactive table bytes {i}/{j}");assert_eq!(json!(services.calls),stage["calls"],"lock/event/callback order {i}/{j}");}
        }
    }
    use crate::audio_effect_resource_bank::{tests::Heap,Services as PoolServices};
    struct Storage{heap:Heap,mutex:[u8;24],event:u32}
    impl Services for Storage{
        fn lock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_notification"}));Ok(())}
        fn unlock_notification(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_notification"}));Ok(())}
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn bank_callback(&mut self,_:u32,fields:[u32;5])->Result<(),Error>{self.heap.calls.push(json!({"kind":"bank_callback","fields":fields}));Ok(())}
    }
    impl Allocator for Storage{fn allocate(&mut self,p:u32,s:u32)->Result<Option<Memory>,Error>{self.heap.allocate(p,s)}}
    impl StorageServices for Storage{
        fn free_pool(&mut self,p:u32,m:&Memory)->Result<(),Error>{PoolServices::free_pool(&mut self.heap,p,m)}
        fn close_event(&mut self,handle:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"close_handle","handle":handle}));Ok(())}
        fn delete_notification_mutex(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"delete_critical_section","reference":0x300304a0u32}));Ok(())}
    }
    impl Initialization for Storage{
        fn initialize_notification_mutex(&mut self,raw:&mut[u8;24])->Result<(),Error>{*raw=self.mutex;self.heap.calls.push(json!({"kind":"initialize_critical_section","reference":0x300304a0u32,"published":hex(raw)}));Ok(())}
        fn create_event(&mut self,fields:[u32;4])->Result<u32,Error>{self.heap.calls.push(json!({"kind":"create_event","fields":fields,"handle":self.event}));Ok(self.event)}
    }
    impl WaitServices for Storage{
        fn current_thread_id(&mut self)->Result<u32,Error>{self.heap.calls.push(json!({"kind":"current_thread","id":100}));Ok(100)}
        fn wait_event(&mut self,handle:u32,timeout:u32)->Result<(),Error>{self.heap.calls.push(json!({"kind":"wait_event","handle":handle,"timeout":timeout}));Ok(())}
    }
    fn storage(pattern:u8,failure:u32)->Storage{Storage{heap:Heap{pattern,next:0x3000c000,nth:0,failure,calls:vec![],allocations:vec![],freed:std::collections::BTreeMap::new(),methods:true},mutex:[0;24],event:0}}
    #[test]fn audio_bank_notification_register_matches36_native_growth_failure_wrapping_and_destructor_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_notification_registration_contract.json")).unwrap();assert_eq!(proof["case_count"],36);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let raw:[u8;40]=bytes(row["initial_context"].as_str().unwrap()).try_into().unwrap();let mut service=storage(row["pattern"].as_u64().unwrap()as u8,row["failure_nth"].as_u64().unwrap()as u32);let mut table=Memory{reference:0,raw:vec![]};
            for v in row["initial_allocations"].as_array().unwrap(){table=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};service.heap.allocations.push((table.reference,table.raw.len()as u32));}
            let mut context=Context{raw,table};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){service.heap.calls.clear();let result=if stage["stage"]=="register"{context.register(stage["cookie"].as_u64().unwrap()as u32,&mut service).unwrap()}else{context.destroy(&mut service).unwrap();0};assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(hex(&context.raw),stage["context"].as_str().unwrap(),"context {i}/{j}");
                let allocations:Vec<Value>=service.heap.allocations.iter().map(|&(r,s)|{let m=service.heap.freed.get(&r).unwrap_or(&context.table);assert_eq!(m.reference,r);json!({"reference":r,"size":s,"freed":service.heap.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),stage["allocations"],"all owned bytes/frees {i}/{j}");assert_eq!(json!(service.heap.calls),stage["calls"],"complete physical order {i}/{j}");
            }assert_eq!(service.heap.allocations.len(),service.heap.freed.len());
        }
    }
    #[test]fn audio_bank_notification_withdraw_matches198_native_cookie_worker_wait_and_cancellation_preservation_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_notification_withdraw_contract.json")).unwrap();assert_eq!(proof["case_count"],198);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let mut context=Context{raw:bytes(row["initial_context"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x30006800,raw:bytes(row["initial_table"].as_str().unwrap())}};let mut service=storage(0,0);let worker=if row["same_thread"].as_bool().unwrap(){100}else{200};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){service.heap.calls.clear();context.withdraw(row["cookie"].as_u64().unwrap()as u32,worker,&mut service).unwrap();assert_eq!(hex(&context.raw),stage["context"].as_str().unwrap(),"context {i}/{j}");assert_eq!(hex(&context.table.raw),stage["table"].as_str().unwrap(),"preserved cancellation/inactive tail {i}/{j}");assert_eq!(json!(service.heap.calls),stage["calls"],"wait after unlock {i}/{j}");}
        }
    }

    #[test]fn audio_bank_notification_constructor_matches18_native_fields_mutex_publication_and_event_failure_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_notification_constructor_contract.json")).unwrap();assert_eq!(proof["case_count"],18);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let mut service=storage(0,0);service.mutex=bytes(row["mutex_bytes"].as_str().unwrap()).try_into().unwrap();service.event=row["event_result"].as_u64().unwrap()as u32;let mut context=Context::construct(bytes(row["before"].as_str().unwrap()).try_into().unwrap(),&mut service).unwrap();
            assert_eq!(hex(&context.raw),row["stages"][0]["context"].as_str().unwrap(),"construction {i}");assert_eq!(json!(service.heap.calls),row["stages"][0]["calls"],"mutex/event args {i}");service.heap.calls.clear();context.destroy(&mut service).unwrap();assert_eq!(hex(&context.raw),row["stages"][1]["context"].as_str().unwrap(),"destruction preserves handle {i}");assert_eq!(json!(service.heap.calls),row["stages"][1]["calls"],"close/delete order {i}");assert!(service.heap.allocations.is_empty());
        }
    }

}
