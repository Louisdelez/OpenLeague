//! Native B09590 registration, B09610 insertion and AF95A0 table growth.
//! Pool allocation/free remain mandatory interfaces; no built-in plugin is invented.
use crate::audio_bus_bank::Error;
use crate::audio_plugin_factory::{Allocator,Memory,Registration,Registry};
pub trait Pool: Allocator {
    fn free(&mut self, allocator:u32, memory:&Memory)->Result<(),Error>;
}
#[derive(Debug)]
pub struct Table {
    pub memory:Memory,
    pub count:u32,
    pub capacity:u32,
    pub allocator:u32,
}
fn word(raw:&[u8],offset:usize)->u32 {u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}
fn write(raw:&mut[u8],offset:usize,value:u32){raw[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
pub fn packed_id(kind:u32,company:u32,id:u32)->u32 {
    id.wrapping_shl(12).wrapping_add(company).wrapping_shl(4).wrapping_add(kind&15)
}
impl Table {
    fn validate(&self)->Result<(),Error> {
        let bytes=self.capacity.checked_mul(12).ok_or(Error::InvalidAllocation)?;
        if self.count>self.capacity || self.memory.raw.len()<bytes as usize
            || (self.capacity!=0 && self.memory.reference==0) {return Err(Error::InvalidAllocation);}
        Ok(())
    }
    /// Preserve native first-match ordering for the effect and parameter factories.
    pub fn registry(&self)->Result<Registry,Error> {
        self.validate()?;
        Ok(Registry {entries:(0..self.count as usize).map(|i| {
            let o=i*12;Registration {id:word(&self.memory.raw,o),effect:word(&self.memory.raw,o+4),parameter:word(&self.memory.raw,o+8)}
        }).collect()})
    }
    pub fn register(&mut self,kind:u32,company:u32,id:u32,effect:u32,parameter:u32,pool:&mut impl Pool)->Result<u32,Error> {
        self.validate()?;
        let id=packed_id(kind,company,id);
        if (0..self.count as usize).any(|i|word(&self.memory.raw,i*12)==id) {return Ok(2);}
        if effect==0 || parameter==0 {return Ok(31);}
        Ok(if self.insert(id,effect,parameter,pool)?==0 {2}else{1})
    }
    /// Internal insertion updates an existing pair; public registration rejects duplicates.
    pub fn insert(&mut self,id:u32,effect:u32,parameter:u32,pool:&mut impl Pool)->Result<u32,Error> {
        self.validate()?;
        if let Some(i)=(0..self.count as usize).find(|i|word(&self.memory.raw,i*12)==id) {
            let o=i*12;write(&mut self.memory.raw,o+4,effect);write(&mut self.memory.raw,o+8,parameter);
            return self.memory.reference.checked_add(o as u32+4).ok_or(Error::InvalidAllocation);
        }
        if self.count>=self.capacity {
            let capacity=self.capacity.checked_add(5).ok_or(Error::InvalidAllocation)?;
            let size=capacity.checked_mul(12).ok_or(Error::InvalidAllocation)?;
            let Some(mut memory)=pool.allocate(self.allocator,size)? else{return Ok(0);};
            if memory.reference==0 || memory.raw.len()!=size as usize || memory.reference==self.memory.reference {return Err(Error::InvalidAllocation);}
            let used=self.count as usize*12;
            memory.raw[..used].copy_from_slice(&self.memory.raw[..used]);
            if self.memory.reference!=0 {pool.free(self.allocator,&self.memory)?;}
            self.memory=memory;self.capacity=capacity;
        }
        let offset=self.count as usize*12;
        let reference=self.memory.reference.checked_add(offset as u32+4).ok_or(Error::InvalidAllocation)?;
        self.count+=1;
        write(&mut self.memory.raw,offset,id);write(&mut self.memory.raw,offset+4,effect);write(&mut self.memory.raw,offset+8,parameter);
        Ok(reference)
    }
}
#[cfg(test)]mod tests {
    use super::*;
    use crate::audio_plugin_factory::*;
    use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    struct Heap {failure:bool,calls:Vec<Value>,freed:Option<Memory>,next:u32}
    impl Allocator for Heap {
        fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{
            let reference=if self.failure {0}else{let reference=self.next;self.next+=0x100;reference};
            self.calls.push(json!({"kind":"allocate","allocator":allocator,"size":size,"reference":reference}));
            Ok(if self.failure {None}else{Some(Memory {reference,raw:vec![0xcc;size as usize]})})
        }
    }
    impl Pool for Heap {
        fn free(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{
            self.calls.push(json!({"kind":"free","allocator":allocator,"reference":memory.reference}));
            self.freed=Some(memory.clone());Ok(())
        }
    }
    #[test]fn audio_plugin_registration_matches1728_native_public_internal_growth_and_ownership_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_plugin_registration_growth_contract.json")).unwrap();
        assert_eq!(proof["case_count"],1728);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let n=|k:&str|row[k].as_u64().unwrap()as u32;
            let mut table=Table {memory:Memory {reference:0x30001000,raw:bytes(row["before"].as_str().unwrap())},count:n("count_before"),capacity:n("capacity_before"),allocator:u32::MAX};
            let mut heap=Heap {failure:row["failure"].as_bool().unwrap(),calls:vec![],freed:None,next:0x30002000};
            let e=row["creators"][0].as_u64().unwrap()as u32;let p=row["creators"][1].as_u64().unwrap()as u32;
            assert_eq!(packed_id(n("kind"),n("company"),n("id")),n("packed_id"));
            let result=if row["direct"].as_bool().unwrap(){table.insert(n("packed_id"),e,p,&mut heap)}else{table.register(n("kind"),n("company"),n("id"),e,p,&mut heap)}.unwrap();
            assert_eq!(result,n("result"),"result {i}");assert_eq!(table.count,n("count_after"),"count {i}");assert_eq!(table.capacity,n("capacity_after"),"capacity {i}");assert_eq!(table.memory.reference,n("pointer_after"),"pointer {i}");
            let old=heap.freed.as_ref().unwrap_or(&table.memory);
            assert_eq!(old.raw,bytes(row["old_after"].as_str().unwrap()),"old allocation {i}");
            let mut new=vec![0xcc;96];if table.memory.reference==0x30002000{new[..table.memory.raw.len()].copy_from_slice(&table.memory.raw);}
            assert_eq!(new,bytes(row["new_after"].as_str().unwrap()),"new allocation {i}");assert_eq!(json!(heap.calls),row["calls"],"ownership calls {i}");
            let registry=table.registry().unwrap();assert_eq!(registry.entries.len(),table.count as usize);
            for(j,entry)in registry.entries.iter().enumerate(){assert_eq!(entry.id,word(&table.memory.raw,j*12));assert_eq!(entry.effect,word(&table.memory.raw,j*12+4));assert_eq!(entry.parameter,word(&table.memory.raw,j*12+8));}
        }
    }
    #[test]fn audio_plugin_registered_meter_parameter_is_owned_and_used_by_actual_factory(){
        let mut heap=Heap {failure:false,calls:vec![],freed:None,next:0x30002000};
        let mut table=Table {memory:Memory {reference:0,raw:vec![]},count:0,capacity:0,allocator:u32::MAX};
        assert_eq!(table.register(3,0,129,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR,&mut heap).unwrap(),1);
        let registry=table.registry().unwrap();let mut objects=std::collections::BTreeMap::new();
        let created=registry.create(Kind::Parameter,METER_ID,7,&mut MeterCreators {allocator:&mut heap,objects:&mut objects}).unwrap();
        assert_eq!(created.status,1);let parameter=objects.get_mut(&created.reference).unwrap();
        assert_eq!(meter_init_parameter(parameter,&[],0).unwrap(),1);assert_eq!(word(&parameter.raw,12),0xc2400000);
        assert_eq!(table.count,1);assert!(heap.freed.is_none());
    }
}
