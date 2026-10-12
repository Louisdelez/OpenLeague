//! Native B254C0 effect resource bank reader and its ordered table/curve helpers.
//! Actual HIRC dispatch/construction, subscriptions and device scheduling remain separate.
use crate::{audio_bus_bank::Error,audio_bus_effect_instance::Resource,
    audio_meter_lifecycle::{Runtime,Lifetime},audio_plugin_factory::{Memory,Registry}};
pub const POOL:u32=u32::MAX;
pub trait Services:Lifetime {
    fn free_pool(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>;
}
#[derive(Debug)]pub struct BankResource {
    pub resource:Resource,
    /// Pointer,count,capacity. Storage is owned by the same Runtime as parameters.
    pub pairs:[u32;3],
    pub rtpc:[u32;3],
}
#[derive(Debug,PartialEq,Eq)]pub struct Loaded{pub status:u32,pub consumed:usize}
struct Reader<'a>{bytes:&'a[u8],offset:usize}
impl Reader<'_>{
    fn take(&mut self,size:usize)->Result<&[u8],Error>{let end=self.offset.checked_add(size).ok_or(Error::Truncated)?;let out=self.bytes.get(self.offset..end).ok_or(Error::Truncated)?;self.offset=end;Ok(out)}
    fn u8(&mut self)->Result<u8,Error>{Ok(self.take(1)?[0])}
    fn u16(&mut self)->Result<u16,Error>{Ok(u16::from_le_bytes(self.take(2)?.try_into().unwrap()))}
    fn u32(&mut self)->Result<u32,Error>{Ok(u32::from_le_bytes(self.take(4)?.try_into().unwrap()))}
}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn allocate(runtime:&mut Runtime,size:u32,backend:&mut impl Services)->Result<u32,Error>{
    let Some(memory)=backend.allocate(POOL,size)?else{return Ok(0);};
    if memory.reference==0 || memory.raw.len()!=size as usize || runtime.objects.contains_key(&memory.reference){return Err(Error::InvalidAllocation);}
    let reference=memory.reference;runtime.objects.insert(reference,memory);Ok(reference)
}
fn free(runtime:&mut Runtime,reference:u32,backend:&mut impl Services)->Result<(),Error>{
    let memory=runtime.objects.get(&reference).ok_or(Error::UnresolvedReference)?;
    backend.free_pool(POOL,memory)?;runtime.objects.remove(&reference);Ok(())
}
fn validate(runtime:&Runtime,head:[u32;3],size:u32)->Result<(),Error>{
    if head[1]>head[2]{return Err(Error::InvalidAllocation);}
    if head[0]==0{return if head[1]==0{Ok(())}else{Err(Error::UnresolvedReference)};}
    let memory=runtime.objects.get(&head[0]).ok_or(Error::UnresolvedReference)?;
    let needed=head[2].checked_mul(size).ok_or(Error::InvalidAllocation)?;
    if memory.reference!=head[0] || memory.raw.len()<needed as usize{return Err(Error::InvalidAllocation);}Ok(())
}
fn grow(runtime:&mut Runtime,head:&mut[u32;3],size:u32,increment:u32,backend:&mut impl Services)->Result<bool,Error>{
    validate(runtime,*head,size)?;
    let capacity=head[2].checked_add(increment).ok_or(Error::InvalidAllocation)?;
    let reference=allocate(runtime,capacity.checked_mul(size).ok_or(Error::InvalidAllocation)?,backend)?;
    if reference==0{return Ok(false);}
    if head[0]!=0 {
        let used=head[1] as usize*size as usize;
        let raw=runtime.objects[&head[0]].raw[..used].to_vec();
        runtime.objects.get_mut(&reference).unwrap().raw[..used].copy_from_slice(&raw);
        free(runtime,head[0],backend)?;
    }
    head[0]=reference;head[2]=capacity;Ok(true)
}
fn pair(runtime:&mut Runtime,head:&mut[u32;3],key:u32,value:u32,backend:&mut impl Services)->Result<(),Error>{
    validate(runtime,*head,8)?;
    if head[1]!=0 {
        let raw=&runtime.objects[&head[0]].raw;
        if let Some(i)=(0..head[1] as usize).find(|i|word(raw,i*8)==key){set(&mut runtime.objects.get_mut(&head[0]).unwrap().raw,i*8+4,value);return Ok(());}
    }
    if head[1]>=head[2] && !grow(runtime,head,8,8,backend)?{return Ok(());}
    validate(runtime,*head,8)?;
    let offset=head[1] as usize*8;head[1]+=1;
    let raw=&mut runtime.objects.get_mut(&head[0]).ok_or(Error::UnresolvedReference)?.raw;
    set(raw,offset,key);set(raw,offset+4,value);Ok(())
}
fn remove(runtime:&mut Runtime,head:&mut[u32;3],parameter:u32,curve_id:u32,backend:&mut impl Services)->Result<(),Error>{
    validate(runtime,*head,24)?;let mut i=0;
    while i<head[1] as usize {
        let offset=i*24;let raw=&runtime.objects[&head[0]].raw;
        if word(raw,offset+8)!=parameter || word(raw,offset+4)!=curve_id{i+=1;continue;}
        let curve=word(raw,offset+12);if curve!=0{free(runtime,curve,backend)?;}
        let raw=&mut runtime.objects.get_mut(&head[0]).unwrap().raw;
        for j in [12,16,20]{set(raw,offset+j,0);}
        let end=head[1] as usize*24;
        if offset+24<end{raw.copy_within(offset+24..end,offset);}
        head[1]-=1;
    }
    Ok(())
}
impl BankResource {
    pub fn load(&mut self,runtime:&mut Runtime,registry:&Registry,bytes:&[u8],backend:&mut impl Services)->Result<Loaded,Error>{
        let mut reader=Reader{bytes,offset:0};reader.u32()?;let plugin=reader.u32()?;let length=reader.u32()?;
        if plugin!=u32::MAX {
            let status=crate::audio_effect_resource_parameter::install(&mut self.resource,registry,runtime,plugin,&bytes[reader.offset..],length,backend)?;
            if status!=1{return Ok(Loaded{status,consumed:reader.offset});}
        }
        reader.take(length as usize)?;
        let count=u32::from(reader.u8()?);
        if count!=0 {
            let reference=allocate(runtime,count*8,backend)?;
            self.pairs[0]=reference;
            if reference!=0{self.pairs[2]=count;}
        }
        for _ in 0..count{let key=u32::from(reader.u8()?);let value=reader.u32()?;pair(runtime,&mut self.pairs,key,value,backend)?;}
        let count=reader.u16()?;
        for _ in 0..count{
            let rtpc=reader.u32()?;let parameter=reader.u32()?;let curve_id=reader.u32()?;let scaling=u32::from(reader.u8()?);let points=u32::from(reader.u16()?);
            remove(runtime,&mut self.rtpc,parameter,curve_id,backend)?;
            let can_append=if self.rtpc[1]>=self.rtpc[2]{grow(runtime,&mut self.rtpc,24,2,backend)?}else{true};
            let point_data=reader.take(points as usize*12)?;
            if !can_append{continue;}
            validate(runtime,self.rtpc,24)?;
            let offset=self.rtpc[1] as usize*24;self.rtpc[1]+=1;
            let raw=&mut runtime.objects.get_mut(&self.rtpc[0]).ok_or(Error::UnresolvedReference)?.raw;
            for (i,value)in [rtpc,curve_id,parameter,0,0,0].into_iter().enumerate(){set(raw,offset+i*4,value);}
            if points!=0 {
                let reference=allocate(runtime,points*12,backend)?;
                if reference!=0 {
                    runtime.objects.get_mut(&reference).unwrap().raw.copy_from_slice(point_data);
                    let raw=&mut runtime.objects.get_mut(&self.rtpc[0]).unwrap().raw;
                    set(raw,offset+12,reference);set(raw,offset+16,points);set(raw,offset+20,scaling);
                }
            }
        }
        validate(runtime,self.rtpc,24)?;
        self.resource.bindings=(0..self.rtpc[1] as usize).map(|i|{
            let raw=&runtime.objects[&self.rtpc[0]].raw;
            std::array::from_fn(|j|word(raw,i*24+j*4))
        }).collect();
        Ok(Loaded{status:1,consumed:reader.offset})
    }
}
#[cfg(test)]pub(crate)mod tests {
    use super::*;
    use crate::audio_plugin_factory::{Allocator,Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR};
    use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    pub(crate)struct Heap{pub(crate) pattern:u8,pub(crate) next:u32,pub(crate) nth:u32,pub(crate) failure:u32,pub(crate) calls:Vec<Value>,pub(crate) allocations:Vec<(u32,u32)>,pub(crate) freed:std::collections::BTreeMap<u32,Memory>,pub(crate) methods:bool}
    impl Allocator for Heap{
        fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{
            self.nth+=1;let reference=if self.failure==self.nth{0}else{let p=self.next;self.next+=0x200;self.allocations.push((p,size));p};
            let mut event=json!({"kind":"allocate","allocator":allocator,"size":size,"reference":reference});
            if self.methods{event["method"]=json!(if allocator==POOL{"pool"}else{"virtual"});}
            self.calls.push(event);Ok(if reference==0{None}else{Some(Memory{reference,raw:vec![self.pattern;size as usize]})})
        }
    }
    impl Heap{
        fn release(&mut self,allocator:u32,memory:&Memory,method:&str)->Result<(),Error>{
            assert!(self.freed.insert(memory.reference,memory.clone()).is_none());
            let mut event=json!({"kind":"free","allocator":allocator,"reference":memory.reference});if self.methods{event["method"]=json!(method);}self.calls.push(event);Ok(())
        }
        pub(crate)fn snapshot(&self,runtime:&Runtime)->Value{json!(self.allocations.iter().map(|&(reference,size)|{
            let memory=self.freed.get(&reference).or_else(||runtime.objects.get(&reference)).unwrap();let raw:String=memory.raw.iter().map(|b|format!("{b:02x}")).collect();
            json!({"reference":reference,"size":size,"freed":self.freed.contains_key(&reference),"raw":raw})
        }).collect::<Vec<_>>())}
    }
    impl Lifetime for Heap{
        fn free(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{self.release(allocator,memory,"virtual")}
        fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("bank parameter loading must not schedule DSP"))}
    }
    impl Services for Heap{fn free_pool(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{self.release(allocator,memory,"pool")}}
    fn resource(raw:&[u8])->BankResource{BankResource{resource:Resource{reference:0x30001000,id:word(raw,8),references:word(raw,12),plugin_id:word(raw,16),parameter:word(raw,20),bindings:vec![]},pairs:std::array::from_fn(|i|word(raw,24+i*4)),rtpc:std::array::from_fn(|i|word(raw,36+i*4))}}
    fn raw_after(before:&[u8],bank:&BankResource)->Vec<u8>{let mut raw=before.to_vec();set(&mut raw,16,bank.resource.plugin_id);set(&mut raw,20,bank.resource.parameter);for i in 0..3{set(&mut raw,24+i*4,bank.pairs[i]);set(&mut raw,36+i*4,bank.rtpc[i]);}raw}
    fn registry(profile:&str)->Registry{Registry{entries:if profile=="missing"{vec![]}else{vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:if profile=="null_parameter"{0}else{METER_PARAMETER_CREATOR}}]}}}
    #[test]fn audio_effect_bank_reader_matches384_native_nonempty_tables_and_actual_init_banks_growth_replacement_and_curve_failure_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_resource_tables_contract.json")).unwrap();assert_eq!(proof["case_count"],360);
        let actual:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_actual_bank_contract.json")).unwrap();assert_eq!(actual["case_count"],24);assert!(actual["sources"].as_array().unwrap().iter().all(|s|s["hirc_type"]==19));
        let mut cases=proof["cases"].as_array().unwrap().clone();cases.extend(actual["cases"].as_array().unwrap().clone());
        for(i,row)in cases.iter().enumerate(){
            let before=bytes(row["before"].as_str().unwrap());let mut bank=resource(&before);let mut runtime=Runtime::default();
            let mut heap=Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true};
            for v in row["initial_allocations"].as_array().unwrap(){let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());heap.allocations.push((reference,raw.len()as u32));runtime.objects.insert(reference,Memory{reference,raw});}
            let loaded=bank.load(&mut runtime,&registry("success"),&bytes(row["bank_payload"].as_str().unwrap()),&mut heap).unwrap();
            assert_eq!(u64::from(loaded.status),row["result"].as_u64().unwrap(),"status {i}");assert_eq!(loaded.consumed as u64,row["consumed"].as_u64().unwrap(),"consumption {i}");
            assert_eq!(raw_after(&before,&bank),bytes(row["resource"].as_str().unwrap()),"resource {i}");assert_eq!(heap.snapshot(&runtime),row["allocations"],"allocation lifetime/bytes {i}");assert_eq!(json!(heap.calls),row["calls"],"call order {i}");
            assert_eq!(bank.resource.bindings.len(),bank.rtpc[1]as usize);for(j,fields)in bank.resource.bindings.iter().enumerate(){for k in 0..6{assert_eq!(fields[k],word(&runtime.objects[&bank.rtpc[0]].raw,j*24+k*4));}}
        }
    }
    #[test]fn audio_effect_bank_reader_matches60_native_empty_tables_skip_and_missing_factory_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_resource_reader_contract.json")).unwrap();assert_eq!(proof["case_count"],60);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let before=bytes(row["before"].as_str().unwrap());let mut bank=resource(&before);let mut runtime=Runtime::default();let pattern=row["pattern"].as_u64().unwrap()as u8;
            let mut heap=Heap{pattern,next:0x30005000,nth:0,failure:if row["profile"]=="failure"{1}else{0},calls:vec![],allocations:vec![],freed:Default::default(),methods:false};
            if bank.resource.parameter!=0{let reference=bank.resource.parameter;let mut raw=vec![pattern;32];set(&mut raw,0,0xff36a4);runtime.objects.insert(reference,Memory{reference,raw});heap.allocations.push((reference,32));}
            let data=bytes(row["bank_payload"].as_str().unwrap());let loaded=bank.load(&mut runtime,&registry(row["profile"].as_str().unwrap()),&data,&mut heap).unwrap();
            assert_eq!(loaded.consumed,data.len());assert_eq!(u64::from(loaded.status),row["result"].as_u64().unwrap());assert_eq!(raw_after(&before,&bank),bytes(row["resource"].as_str().unwrap()),"resource {i}");assert_eq!(heap.snapshot(&runtime),row["allocations"],"allocation {i}");assert_eq!(json!(heap.calls),row["calls"],"call order {i}");
        }
    }
}
