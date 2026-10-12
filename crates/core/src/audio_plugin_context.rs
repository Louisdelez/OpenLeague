//! Native B29100/B29140/B29170 plugin contexts. Owned record lifetime is separate.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
#[derive(Clone,Copy)]pub enum Kind{Extended,Standard,Base}
fn set(raw:&mut[u8],offset:usize,value:u32){raw[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
/// Initialize a caller-owned allocation. Extended receives the dereferenced native third argument.
pub fn initialize(memory:&mut Memory,kind:Kind,a:u32,b:u32,indirect_value:u32)->Result<u32,Error>{
 let(size,vtable)=match kind{Kind::Extended=>(28,0xff273c),Kind::Standard=>(24,0xff26f0),Kind::Base=>(20,0xff2788)};
 if memory.reference==0||memory.raw.len()!=size{return Err(Error::InvalidAllocation);}
 set(&mut memory.raw,0,vtable);set(&mut memory.raw,4,match kind{Kind::Base=>a,_=>b});
 for offset in [8,12,16]{set(&mut memory.raw,offset,0);}
 if !matches!(kind,Kind::Base){set(&mut memory.raw,20,a);}
 if matches!(kind,Kind::Extended){set(&mut memory.raw,24,indirect_value);}
 Ok(memory.reference)
}

fn word(raw:&[u8],offset:usize)->u32{u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}
pub trait Services:crate::audio_bank_media_lookup::Services{
    fn free_game_heap(&mut self,memory:&Memory)->Result<(),Error>;
}
pub struct Context{pub memory:Memory,pub records:Memory}
impl Context{
 /// B29220/B29250/B291A0: release acquired media, then their bank owner,
 /// then the owned record array. The caller owns the context allocation unless flags bit0 is set.
 pub fn destroy(&mut self,kind:Kind,flags:u32,manager:&mut crate::audio_bank_memory_reader::Manager,media:&mut crate::audio_bank_media_lookup::MediaRegistry,buffer_pool:u32,owner_pool:u32,services:&mut impl Services)->Result<u32,Error>{
  let size=match kind{Kind::Extended=>28,Kind::Standard=>24,Kind::Base=>20};
  if self.memory.reference==0||self.memory.raw.len()!=size{return Err(Error::InvalidAllocation);}
  let reference=word(&self.memory.raw,8);let count=word(&self.memory.raw,12)as usize;let capacity=word(&self.memory.raw,16)as usize;
  if count>capacity||count.checked_mul(20).filter(|n|*n<=self.records.raw.len()).is_none()||(reference!=0&&reference!=self.records.reference)||(reference==0&&count!=0){return Err(Error::InvalidAllocation);}
  set(&mut self.memory.raw,0,if matches!(kind,Kind::Base){0xff2788}else{0xff26a4});
  for i in 0..count{
   let offset=i*20;let pointer=word(&self.records.raw,offset+4);let key=word(&self.records.raw,offset+12);let owner=word(&self.records.raw,offset+16);
   if pointer!=0&&key!=u32::MAX{
    media.release(manager,key,buffer_pool,owner_pool,services)?;
    if owner!=0{manager.destroy_empty_holder(owner,false,services)?;}
   }
  }
  if reference!=0{
   set(&mut self.memory.raw,12,0);services.free_pool(owner_pool,&self.records)?;
   self.records=Memory{reference:0,raw:vec![]};set(&mut self.memory.raw,8,0);set(&mut self.memory.raw,16,0);
  }
  set(&mut self.memory.raw,0,0xff265c);
  if flags&1!=0{services.free_game_heap(&self.memory)?;}
  Ok(self.memory.reference)
 }
}

#[cfg(test)]mod tests{
 use super::*;use serde_json::Value;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test]fn audio_plugin_context_constructors_match48_native_owned_allocations(){
 let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_plugin_context_constructor_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],48);
 for row in proof["cases"].as_array().unwrap(){
 let mut memory=Memory{reference:row["reference"].as_u64().unwrap()as u32,raw:bytes(row["before"].as_str().unwrap())};
 let kind=match row["kind"].as_str().unwrap(){"extended"=>Kind::Extended,"standard"=>Kind::Standard,"base"=>Kind::Base,_=>panic!("unknown native context")};
 let result=initialize(&mut memory,kind,row["a"].as_u64().unwrap()as u32,row["b"].as_u64().unwrap()as u32,row["indirect_value"].as_u64().unwrap()as u32).unwrap();
 assert_eq!(result,row["result"].as_u64().unwrap()as u32);assert_eq!(memory.raw,bytes(row["raw"].as_str().unwrap()),"{}",row["kind"]);
 }
 }

 use serde_json::json;use std::collections::BTreeMap;
 use crate::{audio_bank_memory_reader::{Manager,Bank,Services as BankServices},audio_bank_media_lookup::{MediaRegistry,Node,Services as MediaServices},audio_effect_bank_loader::{Holder,Services as EffectServices},audio_effect_resource_registry::Services as ResourceServices,audio_effect_resource_bank::Services as PoolServices,audio_plugin_factory::Allocator,audio_meter_lifecycle::Lifetime};
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
    struct Physical{calls:Vec<Value>,freed:BTreeMap<u32,Memory>}
    impl Allocator for Physical{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("no allocation during media lookup"))}}
    impl Lifetime for Physical{fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no free during media lookup"))}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("no effect registration during media lookup"))}}
    impl PoolServices for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{if self.freed.insert(m.reference,m.clone()).is_some(){return Err(Error::Backend("double media free"));}self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}}
    impl ResourceServices for Physical{fn lock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect lock during media lookup"))}fn unlock(&mut self,_:bool)->Result<(),Error>{Err(Error::Backend("no effect unlock during media lookup"))}}
    impl EffectServices for Physical{fn lock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager lock during media lookup"))}fn unlock_manager(&mut self)->Result<(),Error>{Err(Error::Backend("no effects manager unlock during media lookup"))}}
    impl BankServices for Physical{
        fn atomic_decrement(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&holder.raw,offset);let after=before.wrapping_sub(1);set(&mut holder.raw,offset,after);self.calls.push(json!({"kind":"atomic_decrement","reference":holder.reference+offset as u32,"before":before,"after":after}));Ok(after)}
        fn notify_bank(&mut self,_:&mut[u8;40],_:[u32;6])->Result<(),Error>{Err(Error::Backend("no bank callback during media lookup"))}
        fn lock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_registry","category":null}));Ok(())}
        fn unlock_bank_registry(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_registry","category":null}));Ok(())}
    }
    impl MediaServices for Physical{
        fn lock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"lock","scope":"bank_media"}));Ok(())}
        fn unlock_media(&mut self)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","scope":"bank_media"}));Ok(())}
        fn atomic_increment(&mut self,holder:&mut Memory,offset:usize)->Result<u32,Error>{let before=word(&holder.raw,offset);let after=before.wrapping_add(1);set(&mut holder.raw,offset,after);self.calls.push(json!({"kind":"atomic_increment","reference":holder.reference+offset as u32,"before":before,"after":after}));Ok(after)}
    }

 impl Services for Physical{fn free_game_heap(&mut self,_:&Memory)->Result<(),Error>{Err(Error::Backend("deleting context destructor not qualified"))}}
 #[test]fn audio_plugin_context_destructor_matches60_native_owned_record_and_acquired_media_cases(){
 for (text,expected) in [(include_str!("../../../data/4.20/audio_plugin_context_destructor_preparation.json"),36),(include_str!("../../../data/4.20/audio_plugin_context_acquired_destructor_preparation.json"),24)]{
  let proof:Value=serde_json::from_str(text).unwrap();assert_eq!(proof["case_count"],expected);assert_eq!(proof["passed"],true);
  for (i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
   let b=&row["before"];let acquired=b.get("manager").is_some();let mut manager=Manager{raw:if acquired{bytes(b["manager"].as_str().unwrap()).try_into().unwrap()}else{[0;0x500]},banks:BTreeMap::new()};
   let mut media=MediaRegistry::default();
   if acquired{
    let raw=bytes(b["holder"].as_str().unwrap());let reference=0x30006000;manager.banks.insert(reference,Bank{effects:Holder{raw:raw[..64].try_into().unwrap(),slots:Memory{reference:0,raw:vec![]}},memory:Memory{reference,raw}});
    let allocations=b["allocations"].as_array().unwrap();let node=&allocations[0];let owners=&allocations[1];media.nodes.insert(0x30006800,Node{memory:Memory{reference:0x30006800,raw:bytes(node["raw"].as_str().unwrap())},owners:Memory{reference:0x30007000,raw:bytes(owners["raw"].as_str().unwrap())}});
   }
   let kind=match row["kind"].as_str().unwrap(){"extended"=>Kind::Extended,"standard"=>Kind::Standard,"base"=>Kind::Base,_=>panic!("invalid context")};
   let mut context=Context{memory:Memory{reference:row["reference"].as_u64().unwrap()as u32,raw:bytes(b["context"].as_str().unwrap())},records:Memory{reference:0x30007600,raw:bytes(b["records"].as_str().unwrap())}};let mut physical=Physical{calls:vec![],freed:BTreeMap::new()};
   let result=context.destroy(kind,0,&mut manager,&mut media,u32::MAX,u32::MAX,&mut physical).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap());assert_eq!(hex(&context.memory.raw),row["context"].as_str().unwrap(),"whole context {i}");assert_eq!(json!(physical.calls),row["calls"],"exact calls {i}");
   let allocations:Vec<Value>=row["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).expect("native freed allocation remains owned");json!({"reference":reference,"size":m.raw.len(),"freed":true,"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"whole freed bytes {i}");assert_eq!(context.records.reference,0);assert!(media.nodes.is_empty());
   if acquired{assert_eq!(hex(&manager.raw),row["manager_after"].as_str().unwrap());assert_eq!(hex(&manager.banks[&0x30006000].memory.raw),row["holder_after"].as_str().unwrap(),"whole retained holder {i}");}
  }
 }
 }
}
