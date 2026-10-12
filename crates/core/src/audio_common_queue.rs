//! Native B05670 paged audio message ring/B11750 insertion/B153B0 table growth.
//! B05ED0/B06370 retry and B06C60 consumer; command bodies require concrete dispatch.
use crate::{audio_bus_bank::Error,audio_plugin_factory::{Allocator,Memory}};
use std::collections::BTreeMap;
pub const ORIGINAL_PAGE_SIZE:u32=2048;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:Allocator{
    fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
    fn lock_queue(&mut self)->Result<(),Error>;
    fn unlock_queue(&mut self)->Result<(),Error>;
}
/// Physical event services; a wait may schedule the concrete consumer on this context.
pub trait RetryServices:Services{
    fn reset_event(&mut self,handle:u32)->Result<(),Error>;
    fn set_event(&mut self,handle:u32)->Result<(),Error>;
    fn wait_event(&mut self,handle:u32,timeout:u32,context:&mut Context,processed:&mut u32)->Result<(),Error>;
    /// Required normal command bodies. Unsupported selectors must return an explicit error.
    fn dispatch_command(&mut self,packet:&[u8])->Result<(),Error>;
}
pub struct Context{pub raw:[u8;0x98],pub table:Memory,pub pages:BTreeMap<u32,Memory>,pub page_size:u32}
impl Context{
    fn table_count(&self)->Result<usize,Error>{
        let count=word(&self.raw,0x1c)as usize;
        if count>word(&self.raw,0x20)as usize||self.table.reference!=word(&self.raw,0x18)||count.checked_mul(8).filter(|n|*n<=self.table.raw.len()).is_none(){return Err(Error::InvalidAllocation);}Ok(count)
    }
    fn copy_page(&mut self,index:u32,offset:u32,packet:&[u8],size:u32)->Result<(),Error>{
        let count=self.table_count()?;if index as usize>=count{return Err(Error::InvalidAllocation);}
        let reference=word(&self.table.raw,index as usize*8);let page=self.pages.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
        let end=offset.checked_add(size).ok_or(Error::InvalidAllocation)?as usize;
        if page.reference!=reference||page.raw.len()!=self.page_size as usize||end>page.raw.len()||size as usize>packet.len(){return Err(Error::Truncated);}
        page.raw[offset as usize..end].copy_from_slice(&packet[..size as usize]);Ok(())
    }
    fn insert_page(&mut self,index:usize,page:Memory,services:&mut impl Services)->Result<bool,Error>{
        let count=self.table_count()?;if index>count{return Err(Error::InvalidAllocation);}
        if count>=word(&self.raw,0x20)as usize{
            let capacity=word(&self.raw,0x20).checked_add(8).ok_or(Error::InvalidAllocation)?;let size=capacity.checked_mul(8).ok_or(Error::InvalidAllocation)?;
            let Some(mut table)=services.allocate(u32::MAX,size)?else{return Ok(false);};
            if table.reference==0||table.raw.len()!=size as usize{return Err(Error::InvalidAllocation);}
            table.raw[..count*8].copy_from_slice(&self.table.raw[..count*8]);if self.table.reference!=0{services.free_pool(u32::MAX,&self.table)?;}
            set(&mut self.raw,0x18,table.reference);set(&mut self.raw,0x20,capacity);self.table=table;
        }
        if count*8+8>self.table.raw.len(){return Err(Error::InvalidAllocation);}
        self.table.raw.copy_within(index*8..count*8,(index+1)*8);set(&mut self.raw,0x1c,(count as u32).wrapping_add(1));set(&mut self.table.raw,index*8,page.reference);self.pages.insert(page.reference,page);Ok(true)
    }
    /// Exact owned-page copy and growth; explicit errors replace physical OOB.
    pub fn push(&mut self,packet:&[u8],size:u32,services:&mut impl Services)->Result<u32,Error>{
        let offset=word(&self.raw,0x34);let write=word(&self.raw,0x30);
        if self.page_size.wrapping_sub(offset)>=size{
            self.copy_page(write,offset,packet,size)?;set(&mut self.raw,0x34,offset.wrapping_add(size));
        }else{
            if self.raw[0x38]!=0{return Ok(52);}
            let count=self.table_count()?;let next=if write.wrapping_add(1)<count as u32{write.wrapping_add(1)}else{0};
            if next==word(&self.raw,0x28){
                if count>=word(&self.raw,0x24)as usize{self.raw[0x38]=1;return Ok(52);}
                let Some(page)=services.allocate(u32::MAX,self.page_size)?else{self.raw[0x38]=1;return Ok(52);};
                if page.reference==0||page.raw.len()!=self.page_size as usize||self.pages.contains_key(&page.reference){return Err(Error::InvalidAllocation);}
                // Temporary page remains owned until insertion succeeds.
                let temporary=page.clone();if !self.insert_page(next as usize,page,services)?{self.raw[0x38]=1;services.free_pool(u32::MAX,&temporary)?;return Ok(52);}
                let read=word(&self.raw,0x28).wrapping_add(1);set(&mut self.raw,0x28,read);
            }
            set(&mut self.raw,0x30,next);set(&mut self.raw,0x34,size);self.copy_page(next,0,packet,size)?;
        }
        let write=word(&self.raw,0x30)as usize;let used=word(&self.raw,0x34);set(&mut self.table.raw,write*8+4,used);Ok(1)
    }
    /// B054D0 exposes one contiguous used span, advancing only when exhausted.
    fn read_span(&mut self)->Result<Vec<u8>,Error>{
        let count=self.table_count()?;let mut read=word(&self.raw,0x28)as usize;let mut offset=word(&self.raw,0x2c)as usize;
        if read>=count{return Err(Error::InvalidAllocation);}
        if offset>=word(&self.table.raw,read*8+4)as usize{read=if read+1<count{read+1}else{0};offset=0;set(&mut self.raw,0x28,read as u32);set(&mut self.raw,0x2c,0);}
        let reference=word(&self.table.raw,read*8);let used=word(&self.table.raw,read*8+4)as usize;let page=self.pages.get(&reference).ok_or(Error::UnresolvedReference)?;
        if used>page.raw.len()||offset>used{return Err(Error::Truncated);}Ok(page.raw[offset..used].to_vec())
    }
    fn empty(&self)->bool{word(&self.raw,0x28)==word(&self.raw,0x30)&&word(&self.raw,0x2c)==word(&self.raw,0x34)&&self.raw[0x38]==0}
    /// B06C60 reader/commit and native unknown-opcode drop, plus frame marker0.
    /// Known command bodies remain mandatory concrete dispatch services.
    pub fn consume(&mut self,processed:&mut u32,services:&mut impl RetryServices)->Result<u32,Error>{
        self.consume_with_dispatch(processed,services,|packet,s|s.dispatch_command(packet))
    }
    pub fn consume_with_dispatch<S:RetryServices>(&mut self,processed:&mut u32,services:&mut S,mut dispatch:impl FnMut(&[u8],&mut S)->Result<(),Error>)->Result<u32,Error>{
        if self.raw[0x3c]==0&&word(&self.raw,0x80)==word(&self.raw,0x84){return Ok(1);}
        services.lock_queue()?;
        loop{
            if self.empty(){break;}
            let span=match self.read_span(){Ok(s)=>s,Err(e)=>{services.unlock_queue()?;return Err(e);}};
            services.unlock_queue()?;let mut consumed=0usize;let mut stop=false;
            while consumed<span.len(){
                if span.len()-consumed<4{return Err(Error::Truncated);}
                let size=u16::from_le_bytes(span[consumed..consumed+2].try_into().unwrap())as usize;
                let opcode=u16::from_le_bytes(span[consumed+2..consumed+4].try_into().unwrap());
                if size<4||size>span.len()-consumed{return Err(Error::Truncated);}
                if opcode==0{let frame=word(&self.raw,0x84).wrapping_add(1);set(&mut self.raw,0x84,frame);stop=frame==word(&self.raw,0x80)&&self.raw[0x3c]==0;}
                else if opcode<=0x27{dispatch(&span[consumed..consumed+size],services)?;}
                *processed=processed.wrapping_add(1);consumed+=size;if stop{break;}
            }
            services.lock_queue()?;let offset=word(&self.raw,0x2c).wrapping_add(consumed as u32);set(&mut self.raw,0x2c,offset);self.raw[0x38]=0;
            if stop{break;}
        }
        self.raw[0x3c]=0;services.unlock_queue()?;services.set_event(word(&self.raw,0x90))?;Ok(1)
    }
    fn push_locked(&mut self,packet:&mut[u8],size:u32,processed:&mut u32,services:&mut impl RetryServices,locked:&mut bool)->Result<u32,Error>{
        if packet.len()<2{return Err(Error::Truncated);}packet[..2].copy_from_slice(&(size as u16).to_le_bytes());
        loop{let status=self.push(packet,size,services)?;if status!=52{return Ok(status);}if size>self.page_size{return Ok(81);}
            services.reset_event(word(&self.raw,0x90))?;self.raw[0x3c]=1;services.unlock_queue()?;*locked=false;
            let event=word(&self.raw,0x88);if event!=0{services.set_event(event)?;}
            services.wait_event(word(&self.raw,0x90),u32::MAX,self,processed)?;services.lock_queue()?;*locked=true;
        }
    }
    /// B05ED0/B06370 full retry: signal consumer, release lock and wait, reacquire/retry.
    pub fn enqueue_with_wait(&mut self,packet:&mut[u8],size:u32,processed:&mut u32,services:&mut impl RetryServices)->Result<u32,Error>{
        services.lock_queue()?;let mut locked=true;let result=self.push_locked(packet,size,processed,services,&mut locked);if locked{services.unlock_queue()?;}result
    }
    /// B08440 publishes a frame only when the ring is nonempty, then signals the worker.
    /// Native uninitialized trailing scratch bytes have no command meaning; caller supplies safe padding.
    pub fn publish_frame(&mut self,frame:&mut[u8;8],processed:&mut u32,services:&mut impl RetryServices)->Result<u32,Error>{
        services.lock_queue()?;let mut locked=true;let nonempty=!self.empty();
        let result=(||{if nonempty{frame[..4].copy_from_slice(&8u32.to_le_bytes());self.push_locked(frame,8,processed,services,&mut locked)?;let count=word(&self.raw,0x80).wrapping_add(1);set(&mut self.raw,0x80,count);}Ok(1)})();
        if locked{services.unlock_queue()?;}result?;if nonempty{let event=word(&self.raw,0x88);if event!=0{services.set_event(event)?;}}Ok(1)
    }
    /// Full locked wrapper including input u16 length publication/oversize status81.
    /// Full valid-sized backpressure remains an explicit unsupported boundary.
    pub fn enqueue(&mut self,packet:&mut[u8],size:u32,services:&mut impl Services)->Result<u32,Error>{
        services.lock_queue()?;
        let result=(||{if packet.len()<2{return Err(Error::Truncated);}packet[..2].copy_from_slice(&(size as u16).to_le_bytes());let status=self.push(packet,size,services)?;
            if status==52{if size>self.page_size{Ok(81)}else{Err(Error::Backend("common queue full requires qualified consumer/backpressure"))}}else{Ok(status)}
        })();services.unlock_queue()?;result
    }
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(raw:&[u8])->String{raw.iter().map(|v|format!("{v:02x}")).collect()}
    struct Physical{pattern:u8,next:u32,nth:u32,failure:u32,original:bool,calls:Vec<Value>,allocations:Vec<(u32,u32)>,freed:BTreeMap<u32,Memory>}
    impl Allocator for Physical{
        fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let r=if self.nth==self.failure{0}else{self.next};if r!=0{self.next+=if self.original{((size+255)&!255)+256}else{512};self.allocations.push((r,size));}self.calls.push(json!({"kind":"allocate","method":"pool","allocator":allocator,"size":size,"reference":r}));Ok((r!=0).then(||Memory{reference:r,raw:vec![self.pattern;size as usize]}))}
    }
    impl Services for Physical{
        fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{assert!(self.freed.insert(m.reference,m.clone()).is_none());self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}
        fn lock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"audio_common_queue"}));Ok(())}
        fn unlock_queue(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"audio_common_queue"}));Ok(())}
    }
    fn replay(proof:&Value,original:bool){
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut services=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,original,calls:vec![],allocations:vec![],freed:BTreeMap::new()};let mut context=Context{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0,raw:vec![]},pages:BTreeMap::new(),page_size:if original{ORIGINAL_PAGE_SIZE}else{64}};
            for(j,v)in row["initial_allocations"].as_array().unwrap().iter().enumerate(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};services.allocations.push((m.reference,m.raw.len()as u32));if j==0{context.table=m;}else{context.pages.insert(m.reference,m);}}
            let mut packet=bytes(row["packet_before"].as_str().unwrap());let size=row["size"].as_u64().unwrap()as u32;let result=if row["mode"]=="direct"{context.push(&packet,size,&mut services).unwrap()}else{context.enqueue(&mut packet,size,&mut services).unwrap()};
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {i}/{original}");assert_eq!(hex(&context.raw),row["context"].as_str().unwrap(),"whole context {i}/{original}");assert_eq!(hex(&packet),row["packet_after"].as_str().unwrap(),"header/backing {i}/{original}");
            let allocations:Vec<Value>=services.allocations.iter().map(|&(r,s)|{let m=services.freed.get(&r).or_else(||(context.table.reference==r).then_some(&context.table)).or_else(||context.pages.get(&r)).unwrap();json!({"reference":r,"size":s,"freed":services.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all page/table bytes and free flags {i}/{original}");assert_eq!(json!(services.calls),row["calls"],"physical order {i}/{original}");
            services.free_pool(u32::MAX,&context.table).unwrap();for m in context.pages.values(){services.free_pool(u32::MAX,m).unwrap();}assert_eq!(services.allocations.len(),services.freed.len());
        }
    }
    #[test]fn audio_common_queue_matches5184_native_copy_growth_wrap_array_failure_and_locked_wrapper_cases(){let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_common_queue_contract.json")).unwrap();assert_eq!(proof["case_count"],5184);replay(&proof,false);}
    #[test]fn audio_common_queue_matches216_original2048_byte_page_copy_growth_failure_and_oversize_cases(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_common_queue_original_pages_contract.json")).unwrap();assert_eq!(proof["case_count"],216);assert_eq!(proof["page_size"],ORIGINAL_PAGE_SIZE);replay(&proof,true);}
    impl RetryServices for Physical{
        fn reset_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"reset_event","handle":handle}));Ok(())}
        fn set_event(&mut self,handle:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_event","handle":handle}));Ok(())}
        fn wait_event(&mut self,handle:u32,timeout:u32,context:&mut Context,processed:&mut u32)->Result<(),Error>{self.calls.push(json!({"kind":"wait_event","handle":handle,"timeout":timeout}));let result=context.consume(processed,self)?;self.calls.push(json!({"kind":"native_consumer_return","result":result}));Ok(())}
        fn dispatch_command(&mut self,_packet:&[u8])->Result<(),Error>{Err(Error::Backend("unqualified common audio command"))}
    }
    #[test]fn audio_common_queue_blocked_retry_matches48_native_actual_consumer_sequences(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_common_queue_backpressure_contract.json")).unwrap();assert_eq!(proof["case_count"],48);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut services=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,original:row["page_size"]==2048,calls:vec![],allocations:vec![],freed:BTreeMap::new()};
            let mut context=Context{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0,raw:vec![]},pages:BTreeMap::new(),page_size:row["page_size"].as_u64().unwrap()as u32};
            for(j,v)in row["initial_allocations"].as_array().unwrap().iter().enumerate(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};services.allocations.push((m.reference,m.raw.len()as u32));if j==0{context.table=m;}else{context.pages.insert(m.reference,m);}}
            let mut packet=bytes(row["packet"].as_str().unwrap());let mut processed=0;let result=context.enqueue_with_wait(&mut packet,row["size"].as_u64().unwrap()as u32,&mut processed,&mut services).unwrap();
            assert_eq!(result as u64,row["result"].as_u64().unwrap(),"status {i}");assert_eq!(processed as u64,row["processed"].as_u64().unwrap(),"processed {i}");assert_eq!(hex(&context.raw),row["context"].as_str().unwrap(),"whole context {i}");assert_eq!(hex(&packet),row["packet"].as_str().unwrap());assert_eq!(json!(services.calls),row["calls"],"physical order {i}");
            let allocations:Vec<Value>=services.allocations.iter().map(|&(r,s)|{let m=if context.table.reference==r{&context.table}else{context.pages.get(&r).unwrap()};json!({"reference":r,"size":s,"freed":false,"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all storage {i}");
        }
    }

    #[test]fn audio_common_consumer_frames_match160_native_stop_wrap_and_waiting_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_common_queue_consumer_frames_contract.json")).unwrap();assert_eq!(proof["case_count"],160);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut services=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,original:row["page_size"]==2048,calls:vec![],allocations:vec![],freed:BTreeMap::new()};
            let mut context=Context{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0,raw:vec![]},pages:BTreeMap::new(),page_size:row["page_size"].as_u64().unwrap()as u32};
            for(j,v)in row["initial_allocations"].as_array().unwrap().iter().enumerate(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};services.allocations.push((m.reference,m.raw.len()as u32));if j==0{context.table=m;}else{context.pages.insert(m.reference,m);}}
            let mut processed=row["processed_start"].as_u64().unwrap()as u32;assert_eq!(context.consume(&mut processed,&mut services).unwrap()as u64,row["result"].as_u64().unwrap(),"status {i}");
            assert_eq!(processed as u64,row["processed"].as_u64().unwrap(),"processed {i}");assert_eq!(hex(&context.raw),row["context"].as_str().unwrap(),"whole context {i}");assert_eq!(json!(services.calls),row["calls"],"physical order {i}");
            let allocations:Vec<Value>=services.allocations.iter().map(|&(r,s)|{let m=if context.table.reference==r{&context.table}else{context.pages.get(&r).unwrap()};json!({"reference":r,"size":s,"freed":false,"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all storage {i}");
        }
    }

}
