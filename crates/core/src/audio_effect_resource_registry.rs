//! Native B25170/B25230 constructors, AF9530 retain, B252F0/B25370 release.
//! Resources populate the concrete Store used by live effect instances.
use crate::{audio_bus_bank::Error,audio_bus_effect_instance::{Resource,Store},
    audio_effect_resource_bank::{BankResource,Loaded,Services as BankServices,POOL},
    audio_meter_lifecycle::Runtime,audio_plugin_factory::{Memory,Registry as Plugins}};
use std::collections::BTreeMap;
pub trait Services:BankServices{
    fn lock(&mut self,category:bool)->Result<(),Error>;
    fn unlock(&mut self,category:bool)->Result<(),Error>;
}
#[derive(Debug,Clone)]pub struct Header{pub category:bool,pub pairs:[u32;3],pub rtpc:[u32;3]}
#[derive(Debug,Default)]pub struct Registry{
    pub instances:Store,
    pub headers:BTreeMap<u32,Header>,
    pub counts:[u32;2],
}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,value:u32){raw[o..o+4].copy_from_slice(&value.to_le_bytes());}
fn raw(runtime:&mut Runtime,reference:u32)->Result<&mut Vec<u8>,Error>{
    let object=runtime.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
    if object.reference!=reference || object.raw.len()!=48{return Err(Error::InvalidAllocation);}Ok(&mut object.raw)
}
fn free(runtime:&mut Runtime,reference:u32,backend:&mut impl Services)->Result<(),Error>{
    backend.free_pool(POOL,runtime.objects.get(&reference).ok_or(Error::UnresolvedReference)?)?;
    runtime.objects.remove(&reference);Ok(())
}
impl Registry{
    /// Update the raw native view from the authoritative resource consumed by instances.
    pub fn synchronize(&self,runtime:&mut Runtime,reference:u32)->Result<(),Error>{
        let resource=self.instances.resources.get(&reference).ok_or(Error::UnresolvedReference)?;
        let header=self.headers.get(&reference).ok_or(Error::UnresolvedReference)?;
        let raw=raw(runtime,reference)?;
        for(o,v)in [(8,resource.id),(12,resource.references),(16,resource.plugin_id),(20,resource.parameter)]{set(raw,o,v);}
        for i in 0..3{set(raw,24+i*4,header.pairs[i]);set(raw,36+i*4,header.rtpc[i]);}Ok(())
    }
    pub fn create(&mut self,runtime:&mut Runtime,id:u32,category:bool,backend:&mut impl Services)->Result<u32,Error>{
        let Some(mut memory)=backend.allocate(POOL,48)?else{return Ok(0);};
        let reference=memory.reference;
        if reference==0 || memory.raw.len()!=48 || runtime.objects.contains_key(&reference) || self.instances.resources.contains_key(&reference){return Err(Error::InvalidAllocation);}
        for(o,v)in [(0,if category{0xff2380}else{0xff2394}),(8,id),(12,1),(16,u32::MAX),(20,0),(24,0),(28,0),(32,0),(36,0),(40,0),(44,0)]{set(&mut memory.raw,o,v);}
        runtime.objects.insert(reference,memory);
        backend.lock(category)?;
        let key=(category,id%193);let bucket=self.instances.buckets.entry(key).or_default();let head=bucket.first().copied().unwrap_or(0);set(raw(runtime,reference)?,4,head);
        bucket.insert(0,reference);self.counts[usize::from(category)]=self.counts[usize::from(category)].wrapping_add(1);
        self.instances.resources.insert(reference,Resource{reference,id,references:1,plugin_id:u32::MAX,parameter:0,bindings:vec![]});
        self.headers.insert(reference,Header{category,pairs:[0;3],rtpc:[0;3]});backend.unlock(category)?;Ok(reference)
    }
    pub fn load(&mut self,runtime:&mut Runtime,reference:u32,plugins:&Plugins,bytes:&[u8],backend:&mut impl Services)->Result<Loaded,Error>{
        let header=self.headers.get(&reference).ok_or(Error::UnresolvedReference)?.clone();
        let resource=self.instances.resources.remove(&reference).ok_or(Error::UnresolvedReference)?;
        let mut bank=BankResource{resource,pairs:header.pairs,rtpc:header.rtpc};
        let result=bank.load(runtime,plugins,bytes,backend);
        self.instances.resources.insert(reference,bank.resource);
        self.headers.insert(reference,Header{category:header.category,pairs:bank.pairs,rtpc:bank.rtpc});
        self.synchronize(runtime,reference)?;result
    }
    pub fn acquire(&mut self,runtime:&mut Runtime,category:bool,id:u32,backend:&mut impl Services)->Result<Option<u32>,Error>{
        backend.lock(category)?;
        let result=(||{
            for reference in self.instances.buckets.get(&(category,id%193)).into_iter().flatten(){
                let resource=self.instances.resources.get_mut(reference).ok_or(Error::UnresolvedReference)?;
                if resource.id==id{resource.references=resource.references.wrapping_add(1);let reference=*reference;self.synchronize(runtime,reference)?;return Ok(Some(reference));}
            }
            Ok(None)
        })();backend.unlock(category)?;result
    }
    fn destroy(&mut self,runtime:&mut Runtime,reference:u32,backend:&mut impl Services)->Result<(),Error>{
        set(raw(runtime,reference)?,0,0xff236c);
        let header=self.headers.get(&reference).ok_or(Error::UnresolvedReference)?.clone();
        if header.rtpc[0]!=0{
            let memory=runtime.objects.get(&header.rtpc[0]).ok_or(Error::UnresolvedReference)?;
            if header.rtpc[1]>header.rtpc[2] || memory.raw.len()<header.rtpc[1]as usize*24{return Err(Error::InvalidAllocation);}
            for i in 0..header.rtpc[1]as usize{
                let curve=word(&runtime.objects[&header.rtpc[0]].raw,i*24+12);
                if curve!=0{free(runtime,curve,backend)?;}
                let raw=&mut runtime.objects.get_mut(&header.rtpc[0]).unwrap().raw;
                for o in [12,16,20]{set(raw,i*24+o,0);}
            }
            self.headers.get_mut(&reference).unwrap().rtpc[1]=0;self.synchronize(runtime,reference)?;
            free(runtime,header.rtpc[0],backend)?;
            self.headers.get_mut(&reference).unwrap().rtpc=[0;3];self.synchronize(runtime,reference)?;
        }
        if header.pairs[0]!=0{
            self.headers.get_mut(&reference).unwrap().pairs[1]=0;self.synchronize(runtime,reference)?;
            free(runtime,header.pairs[0],backend)?;
            self.headers.get_mut(&reference).unwrap().pairs=[0;3];self.synchronize(runtime,reference)?;
        }
        let parameter=self.instances.resources[&reference].parameter;
        if parameter!=0{runtime.terminate_parameter(parameter,crate::audio_effect_resource_parameter::PARAMETER_ALLOCATOR,backend)?;}
        // Native base destruction deliberately leaves the released parameter token.
        set(raw(runtime,reference)?,0,0xff0fe4);Ok(())
    }
    pub fn release(&mut self,runtime:&mut Runtime,reference:u32,backend:&mut impl Services)->Result<u32,Error>{
        let category=self.headers.get(&reference).ok_or(Error::UnresolvedReference)?.category;
        backend.lock(category)?;
        let result=(||{
            let resource=self.instances.resources.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
            resource.references=resource.references.wrapping_sub(1);let remaining=resource.references;let id=resource.id;self.synchronize(runtime,reference)?;
            if remaining!=0{return Ok(remaining);}
            backend.lock(category)?;
            let unlinked=(||{
                let bucket=self.instances.buckets.get(&(category,id%193)).ok_or(Error::UnresolvedReference)?;
                let index=bucket.iter().position(|r|self.instances.resources.get(r).is_some_and(|v|v.id==id)).ok_or(Error::UnresolvedReference)?;
                if bucket[index]!=reference{return Err(Error::Backend("unqualified release of shadowed duplicate effect resource"));}
                let next=bucket.get(index+1).copied().unwrap_or(0);let previous=index.checked_sub(1).map(|i|bucket[i]);
                if let Some(previous)=previous{set(raw(runtime,previous)?,4,next);}
                self.instances.buckets.get_mut(&(category,id%193)).unwrap().remove(index);
                self.counts[usize::from(category)]=self.counts[usize::from(category)].wrapping_sub(1);Ok(())
            })();backend.unlock(category)?;unlinked?;
            self.destroy(runtime,reference,backend)?;free(runtime,reference,backend)?;
            self.instances.resources.remove(&reference);self.headers.remove(&reference);Ok(remaining)
        })();backend.unlock(category)?;result
    }
}
#[cfg(test)]mod tests{
    use super::*;
    use crate::audio_effect_resource_bank::tests::Heap;
    use crate::audio_plugin_factory::{Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR};
    use serde_json::{Value,json};
    impl Services for Heap{
        fn lock(&mut self,category:bool)->Result<(),Error>{self.calls.push(json!({"kind":"lock","category":category}));Ok(())}
        fn unlock(&mut self,category:bool)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","category":category}));Ok(())}
    }
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test]fn audio_effect_resource_registry_matches324_native_creation_actual_banks_nonempty_destruction_and_lifetime_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_resource_lifetime_contract.json")).unwrap();assert_eq!(proof["case_count"],324);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let category=row["category"].as_bool().unwrap();let id=row["id"].as_u64().unwrap()as u32;let mut runtime=Runtime::default();let mut registry=Registry::default();registry.counts[usize::from(category)]=7;registry.counts[usize::from(!category)]=42;registry.instances.buckets.insert((!category,id%193),vec![0x30004400]);
            let mut heap=Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true};
            for v in row["initial_allocations"].as_array().unwrap(){
                let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());heap.allocations.push((reference,raw.len()as u32));
                registry.instances.resources.insert(reference,Resource{reference,id:word(&raw,8),references:word(&raw,12),plugin_id:word(&raw,16),parameter:word(&raw,20),bindings:vec![]});registry.headers.insert(reference,Header{category,pairs:[0;3],rtpc:[0;3]});registry.instances.buckets.insert((category,id%193),vec![reference]);runtime.objects.insert(reference,Memory{reference,raw});
            }
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};let mut reference=0;
            for(stage_index,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                let result=match stage["stage"].as_str().unwrap(){
                    "create"=>{reference=registry.create(&mut runtime,id,category,&mut heap).unwrap();reference},
                    "load"=>registry.load(&mut runtime,reference,&plugins,&bytes(row["bank_payload"].as_str().unwrap()),&mut heap).unwrap().status,
                    "acquire"=>registry.acquire(&mut runtime,category,id,&mut heap).unwrap().unwrap_or(0),
                    "release_retained"|"release_zero"=>registry.release(&mut runtime,reference,&mut heap).unwrap(),_=>unreachable!()
                };
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{stage_index}");
                let head=|category|registry.instances.buckets.get(&(category,id%193)).and_then(|b|b.first()).copied().unwrap_or(0);
                assert_eq!(u64::from(head(category)),stage["head"].as_u64().unwrap(),"head {i}/{stage_index}");assert_eq!(u64::from(head(!category)),stage["other_head"].as_u64().unwrap());assert_eq!(u64::from(registry.counts[usize::from(category)]),stage["count"].as_u64().unwrap());assert_eq!(u64::from(registry.counts[usize::from(!category)]),stage["other_count"].as_u64().unwrap());
                assert_eq!(heap.snapshot(&runtime),stage["allocations"],"owned bytes/lifetime {i}/{stage_index}");assert_eq!(json!(heap.calls),stage["calls"],"locks/physical calls {i}/{stage_index}");
            }
        }
    }
}
