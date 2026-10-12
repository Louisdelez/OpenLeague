//! AF94A0 media hash lookup and AF93E0 direct-buffer/active-bank retention.
//! Native descriptor construction,media registration and release remain separate.
use crate::{audio_bus_bank::Error,audio_bank_memory_reader::{Manager,Services as BankServices},audio_plugin_factory::Memory};
use std::collections::{BTreeMap,BTreeSet};
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:BankServices{
    fn lock_media(&mut self)->Result<(),Error>;
    fn unlock_media(&mut self)->Result<(),Error>;
    fn atomic_increment(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>;
}
pub struct Node{pub memory:Memory,pub owners:Memory}
#[derive(Default)]pub struct MediaRegistry{pub nodes:BTreeMap<u32,Node>,pub buffers:BTreeMap<u32,Memory>}
impl MediaRegistry{
    /// AFC0D0/B09970/AF9230 exact release and owned hash-node cleanup.
    /// Buffer/owner pool values come from the actual global allocator configuration.
    pub fn release(&mut self,manager:&mut Manager,key:u32,buffer_pool:u32,owner_pool:u32,services:&mut impl Services)->Result<(),Error>{
        services.lock_bank_registry()?;if let Err(e)=services.lock_media(){services.unlock_bank_registry()?;return Err(e);}
        let result=(||{
            let bucket=0x84+(key%193)as usize*4;let mut reference=word(&manager.raw,bucket);let mut previous=0;let mut visited=BTreeSet::new();
            while reference!=0{
                if !visited.insert(reference){return Err(Error::Backend("cyclic media hash chain"));}
                let node=self.nodes.get(&reference).ok_or(Error::UnresolvedReference)?;
                if node.memory.reference!=reference||node.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}
                if word(&node.memory.raw,4)!=key{previous=reference;reference=word(&node.memory.raw,0);continue;}
                let refs=word(&node.memory.raw,28).wrapping_sub(1);set(&mut self.nodes.get_mut(&reference).unwrap().memory.raw,28,refs);if refs!=0{return Ok(());}
                let buffer=word(&self.nodes[&reference].memory.raw,8);
                if buffer!=0{let memory=self.buffers.get(&buffer).ok_or(Error::UnresolvedReference)?;if memory.reference!=buffer{return Err(Error::InvalidAllocation);}services.free_pool(buffer_pool,memory)?;self.buffers.remove(&buffer);let node=self.nodes.get_mut(&reference).unwrap();set(&mut node.memory.raw,8,0);set(&mut node.memory.raw,12,0);}
                let next=word(&self.nodes[&reference].memory.raw,0);if previous==0{set(&mut manager.raw,bucket,next);}else{set(&mut self.nodes.get_mut(&previous).unwrap().memory.raw,0,next);}
                let node=self.nodes.get_mut(&reference).unwrap();let owners=word(&node.memory.raw,16);
                if owners!=0{if node.owners.reference!=owners{return Err(Error::UnresolvedReference);}set(&mut node.memory.raw,20,0);services.free_pool(owner_pool,&node.owners)?;node.owners=Memory{reference:0,raw:vec![]};set(&mut node.memory.raw,16,0);set(&mut node.memory.raw,24,0);}
                services.free_pool(word(&manager.raw,0x80),&node.memory)?;self.nodes.remove(&reference);let count=word(&manager.raw,0x388).wrapping_sub(1);set(&mut manager.raw,0x388,count);return Ok(());
            }Ok(())
        })();let inner=services.unlock_media();let outer=services.unlock_bank_registry();inner?;outer?;result
    }
    /// Caller-owned output pointer returned even on missing media; owner-out preserved unless selected.
    pub fn lookup(&mut self,manager:&mut Manager,key:u32,out:&mut Memory,owner:&mut u32,services:&mut impl Services)->Result<u32,Error>{
        if out.reference==0||out.raw.len()!=8{return Err(Error::InvalidAllocation);}set(&mut out.raw,0,0);set(&mut out.raw,4,0);
        services.lock_bank_registry()?;if let Err(e)=services.lock_media(){services.unlock_bank_registry()?;return Err(e);}
        let result=(||{
            let mut reference=word(&manager.raw,0x84+(key%193)as usize*4);let mut visited=BTreeSet::new();
            while reference!=0{
                if !visited.insert(reference){return Err(Error::Backend("cyclic media hash chain"));}
                let node=self.nodes.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
                if node.memory.reference!=reference||node.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}
                if word(&node.memory.raw,4)!=key{reference=word(&node.memory.raw,0);continue;}
                let refs=word(&node.memory.raw,28).wrapping_add(1);set(&mut node.memory.raw,28,refs);
                let buffer=word(&node.memory.raw,8);if buffer!=0{set(&mut out.raw,0,buffer);set(&mut out.raw,4,word(&node.memory.raw,12));return Ok(out.reference);}
                let count=word(&node.memory.raw,20)as usize;if count>word(&node.memory.raw,24)as usize||node.owners.reference!=word(&node.memory.raw,16)||count.checked_mul(12).filter(|n|*n<=node.owners.raw.len()).is_none(){return Err(Error::InvalidAllocation);}
                for i in 0..count{
                    let bank_ref=word(&node.owners.raw,i*12);let bank=manager.banks.get_mut(&bank_ref).ok_or(Error::UnresolvedReference)?;
                    if bank.memory.reference!=bank_ref||bank.memory.raw.len()!=80{return Err(Error::InvalidAllocation);}
                    if bank.memory.raw[72]&8==0{
                        *owner=bank_ref;set(&mut out.raw,0,word(&node.owners.raw,i*12+4));set(&mut out.raw,4,word(&node.owners.raw,i*12+8));services.atomic_increment(&mut bank.memory,64)?;return Ok(out.reference);
                    }
                }
                // Native failed selection rolls back its reference increment; no direct buffer exists on this branch.
                let refs=word(&node.memory.raw,28).wrapping_sub(1);set(&mut node.memory.raw,28,refs);return Ok(out.reference);
            }Ok(out.reference)
        })();let inner=services.unlock_media();let outer=services.unlock_bank_registry();inner?;outer?;result
    }
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::{Value,json};use crate::{audio_bank_memory_reader::Bank,audio_effect_bank_loader::{Holder,Services as EffectServices},audio_effect_resource_registry::Services as ResourceServices,audio_effect_resource_bank::Services as PoolServices,audio_plugin_factory::Allocator,audio_meter_lifecycle::Lifetime};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
    struct Physical{calls:Vec<Value>,freed:BTreeMap<u32,Memory>}
    impl Allocator for Physical{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("no allocation during media lookup"))}}
    impl Lifetime for Physical{fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no free during media lookup"))}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("no effect registration during media lookup"))}}
    impl PoolServices for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{if self.freed.insert(m.reference,m.clone()).is_some(){return Err(Error::Backend("double media free"));}self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}}
    impl ResourceServices for Physical{fn lock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect lock during media lookup"))}fn unlock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect unlock during media lookup"))}}
    impl EffectServices for Physical{fn lock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager lock during media lookup"))}fn unlock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager unlock during media lookup"))}}
    impl BankServices for Physical{
        fn atomic_decrement(&mut self,_:&mut Memory,_:usize)->Result<u32,Error>{Err(Error::Backend("no holder decrement during media lookup"))}
        fn notify_bank(&mut self,_:&mut[u8;40],_:[u32;6])->Result<(),Error>{Err(Error::Backend("no bank callback during media lookup"))}
        fn lock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_registry","category":null}));Ok(())}
        fn unlock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_registry","category":null}));Ok(())}
    }
    impl Services for Physical{
        fn lock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_media"}));Ok(())}
        fn unlock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_media"}));Ok(())}
        fn atomic_increment(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&holder.raw,offset);let after=before.wrapping_add(1);set(&mut holder.raw,offset,after);self.calls.push(json!({"kind":"atomic_increment","reference":holder.reference+offset as u32,"before":before,"after":after}));Ok(after)}
    }
    #[test]fn audio_bank_media_lookup_matches3888_native_hash_buffer_owner_selection_and_wrapping_counter_cases(){
        let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bank_media_lookup_contract.json")).unwrap();assert_eq!(proof["case_count"],3888);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let b=&row["before"];let mut manager=Manager{raw:bytes(b["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};for(j,v)in b["holders"].as_array().unwrap().iter().enumerate(){let raw=bytes(v.as_str().unwrap());let reference=0x30006000+j as u32*512;manager.banks.insert(reference,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference,raw}});}
            let mut registry=MediaRegistry::default();registry.nodes.insert(0x30006800,Node{memory:Memory{reference:0x30006800,raw:bytes(b["node"].as_str().unwrap())},owners:Memory{reference:0x30007000,raw:bytes(b["owners"].as_str().unwrap())}});registry.nodes.insert(0x30006a00,Node{memory:Memory{reference:0x30006a00,raw:bytes(b["head"].as_str().unwrap())},owners:Memory{reference:0,raw:vec![]}});
            let mut out=Memory{reference:0x30007200,raw:bytes(b["output"].as_str().unwrap())};let mut owner=b["owner_out"].as_u64().unwrap()as u32;let mut services=Physical{calls:vec![],freed:BTreeMap::new()};let result=registry.lookup(&mut manager,row["key"].as_u64().unwrap()as u32,&mut out,&mut owner,&mut services).unwrap();
            assert_eq!(result as u64,row["result"].as_u64().unwrap());assert_eq!(hex(&manager.raw),row["manager"].as_str().unwrap(),"manager {i}");assert_eq!(hex(&registry.nodes[&0x30006800].memory.raw),row["node"].as_str().unwrap(),"media counters {i}");assert_eq!(hex(&registry.nodes[&0x30006a00].memory.raw),row["head"].as_str().unwrap());assert_eq!(hex(&registry.nodes[&0x30006800].owners.raw),row["owners"].as_str().unwrap());for(j,bank)in manager.banks.values().enumerate(){assert_eq!(hex(&bank.memory.raw),row["holders"][j].as_str().unwrap(),"whole holder {i}/{j}");}assert_eq!(hex(&out.raw),row["output"].as_str().unwrap());assert_eq!(owner as u64,row["owner_out"].as_u64().unwrap());assert_eq!(json!(services.calls),row["calls"],"physical order {i}");
        }
    }
    #[test]fn audio_bank_media_release_matches864_native_unlink_owned_storage_pool_and_wrapping_counter_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_media_release_contract.json")).unwrap();assert_eq!(proof["case_count"],864);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:bytes(row["before"]["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let mut storage:BTreeMap<u32,Memory>=row["before"]["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut registry=MediaRegistry::default();let node=storage.remove(&0x30006800).unwrap();let owners_ref=word(&node.raw,16);let owners=if owners_ref!=0{storage.remove(&owners_ref).unwrap()}else{Memory{reference:0,raw:vec![]}};registry.nodes.insert(node.reference,Node{memory:node,owners});let head=storage.remove(&0x30006a00).unwrap();registry.nodes.insert(head.reference,Node{memory:head,owners:Memory{reference:0,raw:vec![]}});registry.buffers=storage;
            let mut services=Physical{calls:vec![],freed:BTreeMap::new()};registry.release(&mut manager,row["key"].as_u64().unwrap()as u32,row["buffer_pool"].as_u64().unwrap()as u32,u32::MAX,&mut services).unwrap();
            assert_eq!(hex(&manager.raw),row["manager"].as_str().unwrap(),"whole manager {i}");let allocations:Vec<Value>=row["before"]["allocations"].as_array().unwrap().iter().map(|a|{let r=a["reference"].as_u64().unwrap()as u32;let m=services.freed.get(&r).or_else(||registry.nodes.get(&r).map(|n|&n.memory)).or_else(||registry.nodes.values().find(|n|n.owners.reference==r).map(|n|&n.owners)).or_else(||registry.buffers.get(&r)).unwrap();json!({"reference":r,"size":m.raw.len(),"freed":services.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all owned bytes/free flags {i}");assert_eq!(json!(services.calls),row["calls"],"physical order and pools {i}");
        }
    }

}
