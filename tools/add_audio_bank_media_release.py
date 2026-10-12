from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_bank_media_lookup.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub struct MediaRegistry{pub nodes:BTreeMap<u32,Node>}', 'pub struct MediaRegistry{pub nodes:BTreeMap<u32,Node>,pub buffers:BTreeMap<u32,Memory>}')
pos=s.index('    /// Caller-owned output')
s=s[:pos]+r"""    /// AFC0D0/B09970/AF9230 exact release and owned hash-node cleanup.
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
"""+s[pos:]
# Shared physical backend still forbids all allocation; release allows concrete pool frees only.
s=s.replace('struct Physical{calls:Vec<Value>}', 'struct Physical{calls:Vec<Value>,freed:BTreeMap<u32,Memory>}')
s=s.replace('fn free_pool(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no pool free during media lookup"))}', 'fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{if self.freed.insert(m.reference,m.clone()).is_some(){return Err(Error::Backend("double media free"));}self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}')
s=s.replace('Physical{calls:vec![]}', 'Physical{calls:vec![],freed:BTreeMap::new()}')
pos=s.rfind('\n}')
s=s[:pos]+r"""
    #[test]fn audio_bank_media_release_matches864_native_unlink_owned_storage_pool_and_wrapping_counter_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_media_release_contract.json")).unwrap();assert_eq!(proof["case_count"],864);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut manager=Manager{raw:bytes(row["before"]["manager"].as_str().unwrap()).try_into().unwrap(),banks:BTreeMap::new()};let mut storage:BTreeMap<u32,Memory>=row["before"]["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut registry=MediaRegistry::default();let node=storage.remove(&0x30006800).unwrap();let owners_ref=word(&node.raw,16);let owners=if owners_ref!=0{storage.remove(&owners_ref).unwrap()}else{Memory{reference:0,raw:vec![]}};registry.nodes.insert(node.reference,Node{memory:node,owners});let head=storage.remove(&0x30006a00).unwrap();registry.nodes.insert(head.reference,Node{memory:head,owners:Memory{reference:0,raw:vec![]}});registry.buffers=storage;
            let mut services=Physical{calls:vec![],freed:BTreeMap::new()};registry.release(&mut manager,row["key"].as_u64().unwrap()as u32,row["buffer_pool"].as_u64().unwrap()as u32,u32::MAX,&mut services).unwrap();
            assert_eq!(hex(&manager.raw),row["manager"].as_str().unwrap(),"whole manager {i}");let allocations:Vec<Value>=row["before"]["allocations"].as_array().unwrap().iter().map(|a|{let r=a["reference"].as_u64().unwrap()as u32;let m=services.freed.get(&r).or_else(||registry.nodes.get(&r).map(|n|&n.memory)).or_else(||registry.nodes.values().find(|n|n.owners.reference==r).map(|n|&n.owners)).or_else(||registry.buffers.get(&r)).unwrap();json!({"reference":r,"size":m.raw.len(),"freed":services.freed.contains_key(&r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all owned bytes/free flags {i}");assert_eq!(json!(services.calls),row["calls"],"physical order and pools {i}");
        }
    }
"""+s[pos:];p.write_text(s,encoding='utf-8');print('Applied actual media release/unlink/destruction and864 native replay')
