//! Native Meter B3E100/B3E390/B3E080/B3E350/B3E2E0 and singleton B3EB60.
//! Queue delivery and DSP remain separate; allocator/free/callback have no defaults.
use crate::{audio_bus_bank::Error, audio_plugin_factory::{Allocator,Memory}};
use std::collections::BTreeMap;
pub trait Lifetime: Allocator {
    fn free(&mut self, allocator:u32, object:&Memory) -> Result<(),Error>;
    fn register_callback(&mut self, callback:u32) -> Result<(),Error>;
}
pub trait Update: Lifetime {
    fn set_rtpc(&mut self, manager:u32, id:u32, bits:u32, owner:u32,
                transition:[u32;2], mode:u32)->Result<(),Error>;
    /// Backends owning a separate subscriber graph retain the mandatory producer;
    /// the concrete shared-graph adapter overrides this entry to use live objects.
    fn set_rtpc_owned(&mut self,_runtime:&mut Runtime,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{self.set_rtpc(manager,id,bits,owner,transition,mode)}
    fn unregister_callback(&mut self, callback:u32)->Result<(),Error>;
    fn free_manager(&mut self, allocator:u32, object:&Memory)->Result<(),Error>;
}
#[derive(Debug,Default)]
pub struct Runtime {
    pub objects:BTreeMap<u32,Memory>,
    pub manager:u32,
    /// Native pool identifier at 1210228, explicitly supplied by the caller.
    pub manager_allocator:u32,
}
fn word(raw:&[u8],o:usize)->u32 {u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,value:u32){raw[o..o+4].copy_from_slice(&value.to_le_bytes());}
fn float_bits(bits:u32)->Result<u32,Error>{
    if f32::from_bits(bits).is_nan(){return Err(Error::Backend("unqualified Meter x87 NaN payload"));}
    Ok(bits)
}
fn validate(object:&Memory,size:usize,class:Option<u32>)->Result<(),Error>{
    if object.reference==0 || object.raw.len()!=size{return Err(Error::InvalidAllocation);}
    if class.is_some_and(|c|word(&object.raw,0)!=c){return Err(Error::Backend("unqualified Meter object class"));}
    Ok(())
}
/// Signed low16 parameter ID; declared length does not gate native four-byte loads.
pub fn set_parameter(object:&mut Memory,id:u32,backing:&[u8],_length:u32)->Result<u32,Error>{
    validate(object,32,Some(0xff36a4))?;
    let id=id as u16 as i16;
    let(offset,float)=match id{0=>(4,true),1=>(8,true),2=>(24,false),4=>(12,true),5=>(16,true),6=>(20,true),32767=>(28,false),_=>return Ok(31)};
    if backing.len()<4{return Err(Error::Truncated);}
    let bits=word(backing,0);let bits=if float{float_bits(bits)?}else{bits};set(&mut object.raw,offset,bits);Ok(1)
}
impl Runtime {
    fn get(&self,reference:u32,size:usize,class:Option<u32>)->Result<&Memory,Error>{
        let object=self.objects.get(&reference).ok_or(Error::UnresolvedReference)?;
        if object.reference!=reference{return Err(Error::UnresolvedReference);}
        validate(object,size,class)?;Ok(object)
    }
    fn write(&mut self,reference:u32,offset:usize,value:u32)->Result<(),Error>{
        let object=self.objects.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
        if offset+4>object.raw.len(){return Err(Error::InvalidAllocation);}set(&mut object.raw,offset,value);Ok(())
    }
    fn manager(&mut self,allocator:u32,backend:&mut impl Lifetime)->Result<u32,Error>{
        if self.manager!=0 {self.get(self.manager,16,None)?;return Ok(self.manager);}
        let Some(mut object)=backend.allocate(self.manager_allocator,16)? else{return Ok(0);};
        validate(&object,16,None)?;
        if self.objects.contains_key(&object.reference){return Err(Error::InvalidAllocation);}
        for(i,bits)in [allocator,0,0,0].into_iter().enumerate(){set(&mut object.raw,i*4,bits);}
        self.manager=object.reference;self.objects.insert(object.reference,object);
        backend.register_callback(0xb3ed30)?;Ok(self.manager)
    }
    /// Preserve partial writes before singleton allocation failure, then enqueue
    /// at the existing intrusive tail. DSP execution is not simulated here.
    pub fn init(&mut self,effect:u32,allocator:u32,context:u32,parameter:u32,
                format:[u8;8],backend:&mut impl Lifetime)->Result<u32,Error>{
        self.get(effect,84,Some(0xff36d4))?;
        self.write(effect,8,parameter)?;self.write(effect,12,context)?;
        self.write(effect,16,allocator)?;self.write(effect,24,word(&format,0))?;
        let manager=self.manager(allocator,backend)?;self.write(effect,20,manager)?;
        if manager==0{return Ok(2);}
        self.write(effect,4,0)?;
        let tail=word(&self.get(manager,16,None)?.raw,12);
        if tail==0{self.write(manager,8,effect)?;}else{self.get(tail,84,None)?;self.write(tail,4,effect)?;}
        let count=word(&self.get(manager,16,None)?.raw,4);self.write(manager,4,count.wrapping_add(1))?;
        self.write(manager,12,effect)?;
        let parameter=self.get(parameter,32,Some(0xff36a4))?;
        let bits=float_bits(word(&parameter.raw,12))?;let id=word(&parameter.raw,28);
        self.write(effect,72,bits)?;self.write(effect,76,id)?;Ok(1)
    }
    pub fn reset(&mut self,effect:u32)->Result<u32,Error>{
        let parameter=word(&self.get(effect,84,Some(0xff36d4))?.raw,8);
        self.write(effect,28,0)?;
        let bits=float_bits(word(&self.get(parameter,32,Some(0xff36a4))?.raw,12))?;
        for offset in (32..72).step_by(4){self.write(effect,offset,bits)?;}Ok(1)
    }
    fn destroy(&mut self,reference:u32,allocator:u32,class:u32,backend:&mut impl Lifetime)->Result<(),Error>{
        self.write(reference,0,class)?;
        backend.free(allocator,self.objects.get(&reference).ok_or(Error::UnresolvedReference)?)?;
        self.objects.remove(&reference);Ok(())
    }
    /// B3ED30/B3EBC0 drains deferred destruction, aggregates first-seen IDs
    /// and delivers actual measurements through a mandatory RTPC producer.
    pub fn update(&mut self,rtpc_manager:u32,backend:&mut impl Update)->Result<(),Error>{
        let manager=self.manager;self.get(manager,16,None)?;
        let allocator=word(&self.objects[&manager].raw,0);
        let mut current=word(&self.objects[&manager].raw,8);let mut previous=0;
        let mut visited=std::collections::BTreeSet::new();let mut values:Vec<(u32,u32)>=vec![];
        while current!=0{
            if !visited.insert(current){return Err(Error::CyclicList);}
            let object=self.get(current,84,Some(0xff36d4))?;
            let next=word(&object.raw,4);let id=word(&object.raw,76);
            let deferred=object.raw[80]!=0;
            let bits=word(&object.raw,if deferred{72}else{36});
            if id!=0{float_bits(bits)?;}
            if deferred{
                if current==word(&self.objects[&manager].raw,8){self.write(manager,8,next)?;}
                else{self.get(previous,84,None)?;self.write(previous,4,next)?;}
                if current==word(&self.objects[&manager].raw,12){self.write(manager,12,previous)?;}
                let count=word(&self.objects[&manager].raw,4);self.write(manager,4,count.wrapping_sub(1))?;
                self.destroy(current,allocator,0xff36bc,backend)?;
            }else{previous=current;}
            if id!=0{
                if let Some((_,old))=values.iter_mut().find(|(key,_)|*key==id){
                    if !(f32::from_bits(*old)>f32::from_bits(bits)){*old=bits;}
                }else{values.push((id,bits));}
            }
            current=next;
        }
        for(id,bits)in values{backend.set_rtpc_owned(self,rtpc_manager,id,bits,0,[0,4],1)?;}
        if word(&self.objects[&manager].raw,8)==0{
            backend.unregister_callback(0xb3ed30)?;
            for offset in [8,12,4]{self.write(manager,offset,0)?;}
            self.manager=0;
            backend.free_manager(self.manager_allocator,self.objects.get(&manager).ok_or(Error::UnresolvedReference)?)?;
            self.objects.remove(&manager);
        }
        Ok(())
    }
    pub fn terminate_parameter(&mut self,parameter:u32,allocator:u32,backend:&mut impl Lifetime)->Result<u32,Error>{
        if parameter==0{return Ok(1);}
        self.get(parameter,32,Some(0xff36a4))?;
        self.destroy(parameter,allocator,0xff369c,backend)?;Ok(1)
    }
    pub fn terminate_effect(&mut self,effect:u32,allocator:u32,backend:&mut impl Lifetime)->Result<u32,Error>{
        let manager=word(&self.get(effect,84,Some(0xff36d4))?.raw,20);
        if manager!=0{self.objects.get_mut(&effect).unwrap().raw[80]=1;return Ok(1);}
        self.destroy(effect,allocator,0xff36bc,backend)?;Ok(1)
    }
}

#[cfg(test)] mod tests {
    use super::*;use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn proof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_meter_lifecycle_contract.json")).unwrap()}
    fn object(reference:u32,raw:&str)->Memory{Memory{reference,raw:bytes(raw)}}
    struct Backend{update:bool,pattern:u8,failure:bool,calls:Vec<Value>,freed:Vec<Memory>}
    impl Allocator for Backend{fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{
        self.calls.push(json!({"kind":"allocate_manager","allocator":allocator,"size":size}));
        Ok(if self.failure{None}else{Some(Memory{reference:0x30005000,raw:vec![self.pattern;size as usize]})})
    }}
    impl Lifetime for Backend{
        fn free(&mut self,allocator:u32,object:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":if self.update{"free_effect"}else{"free"},"allocator":allocator,"object":object.reference}));self.freed.push(object.clone());Ok(())}
        fn register_callback(&mut self,callback:u32)->Result<(),Error>{self.calls.push(json!({"kind":"register_callback","callback":callback}));Ok(())}
    }
    impl Update for Backend {
        fn set_rtpc(&mut self,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{self.calls.push(json!({"kind":"set_rtpc","manager":manager,"id":id,"bits":bits,"owner":owner,"transition":transition,"mode":mode}));Ok(())}
        fn unregister_callback(&mut self,callback:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unregister_callback","callback":callback}));Ok(())}
        fn free_manager(&mut self,allocator:u32,object:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free_manager","allocator":allocator,"object":object.reference}));self.freed.push(object.clone());Ok(())}
    }
    #[test]fn audio_meter_update_matches837_native_callback_removal_measurement_and_release_cases(){
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_meter_update_contract.json")).unwrap();assert_eq!(p["case_count"],837);
        for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
            let mut runtime=Runtime{manager:0x30001000,manager_allocator:u32::MAX,..Runtime::default()};
            runtime.objects.insert(runtime.manager,object(runtime.manager,row["manager_before"].as_str().unwrap()));
            for member in row["members"].as_array().unwrap(){let r=member["reference"].as_u64().unwrap()as u32;runtime.objects.insert(r,object(r,member["before"].as_str().unwrap()));}
            let mut backend=Backend{update:true,pattern:0,failure:false,calls:vec![],freed:vec![]};
            runtime.update(0x30009000,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"all callbacks {i}");assert_eq!(u64::from(runtime.manager),row["global_manager"].as_u64().unwrap(),"global {i}");
            let snapshot=|r:u32|runtime.objects.get(&r).or_else(||backend.freed.iter().find(|o|o.reference==r)).unwrap();
            assert_eq!(snapshot(0x30001000).raw,bytes(row["manager_after"].as_str().unwrap()),"manager {i}");
            for(j,member)in row["members"].as_array().unwrap().iter().enumerate(){let r=member["reference"].as_u64().unwrap()as u32;assert_eq!(snapshot(r).raw,bytes(member["after"].as_str().unwrap()),"member {i}/{j}");assert_eq!(runtime.objects.contains_key(&r),row["deferred_mask"].as_u64().unwrap()&(1<<j)==0,"ownership {i}/{j}");}
        }
    }
    #[test]fn audio_meter_set_parameter_matches280_native_signed_id_length_and_raw_cases(){
        let p=proof();assert_eq!(p["counts"]["set"],280);
        for(i,row)in p["set_cases"].as_array().unwrap().iter().enumerate(){
            let mut o=object(0x30001000,row["before"].as_str().unwrap());
            let result=set_parameter(&mut o,row["id"].as_u64().unwrap()as u32,&(row["bits"].as_u64().unwrap()as u32).to_le_bytes(),row["length"].as_u64().unwrap()as u32).unwrap();
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {i}");assert_eq!(o.raw,bytes(row["after"].as_str().unwrap()),"memory {i}");
        }
    }
    #[test]fn audio_meter_reset_matches15_native_channel_word_cases(){
        let p=proof();assert_eq!(p["counts"]["reset"],15);
        for(i,row)in p["reset_cases"].as_array().unwrap().iter().enumerate(){
            let mut runtime=Runtime::default();runtime.objects.insert(0x30001000,object(0x30001000,row["before"].as_str().unwrap()));
            let mut param=Memory{reference:0x30002000,raw:vec![0;32]};set(&mut param.raw,0,0xff36a4);set(&mut param.raw,12,row["bits"].as_u64().unwrap()as u32);runtime.objects.insert(param.reference,param);
            assert_eq!(runtime.reset(0x30001000).unwrap(),1);assert_eq!(runtime.objects[&0x30001000].raw,bytes(row["after"].as_str().unwrap()),"memory {i}");
        }
    }
    #[test]fn audio_meter_termination_matches12_native_deferred_and_immediate_free_cases(){
        let p=proof();assert_eq!(p["counts"]["term"],12);
        for(i,row)in p["term_cases"].as_array().unwrap().iter().enumerate(){
            let mut runtime=Runtime::default();runtime.objects.insert(0x30001000,object(0x30001000,row["before"].as_str().unwrap()));let mut backend=Backend{update:false,pattern:0,failure:false,calls:vec![],freed:vec![]};
            let result=if row["kind"]=="effect"{runtime.terminate_effect(0x30001000,0x30004000,&mut backend)}else{runtime.terminate_parameter(0x30001000,0x30004000,&mut backend)}.unwrap();
            assert_eq!(result,1);assert_eq!(json!(backend.calls),row["calls"],"call order {i}");
            let remaining=runtime.objects.get(&0x30001000);let snapshot=remaining.or_else(||backend.freed.first()).unwrap();assert_eq!(snapshot.raw,bytes(row["after"].as_str().unwrap()),"memory {i}");
            assert_eq!(remaining.is_some(),row["kind"]=="effect" && row["deferred"].as_bool().unwrap(),"lifetime {i}");
        }
    }
    #[test]fn audio_meter_init_matches12_native_singleton_and_intrusive_queue_cases(){
        let p=proof();assert_eq!(p["counts"]["init"],12);
        for(i,row)in p["init_cases"].as_array().unwrap().iter().enumerate(){
            let profile=row["profile"].as_str().unwrap();let mut runtime=Runtime{manager_allocator:u32::MAX,..Runtime::default()};
            runtime.objects.insert(0x30001000,object(0x30001000,row["before"].as_str().unwrap()));
            runtime.objects.insert(0x30006000,object(0x30006000,row["previous_before"].as_str().unwrap()));
            if profile=="empty"||profile=="tail"{runtime.manager=0x30005000;runtime.objects.insert(runtime.manager,object(runtime.manager,row["manager_before"].as_str().unwrap()));}
            let mut param=Memory{reference:0x30002000,raw:vec![0;32]};set(&mut param.raw,0,0xff36a4);set(&mut param.raw,12,0xc2400000);set(&mut param.raw,28,0xdeadbeef);runtime.objects.insert(param.reference,param);
            let mut backend=Backend{update:false,pattern:row["pattern"].as_u64().unwrap()as u8,failure:profile=="allocation_failure",calls:vec![],freed:vec![]};
            let mut format=[0;8];set(&mut format,0,48000);set(&mut format,4,0x12345678);
            let result=runtime.init(0x30001000,0x30004000,0x30009900,0x30002000,format,&mut backend).unwrap();
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {i}");assert_eq!(u64::from(runtime.manager),row["global_manager"].as_u64().unwrap(),"global {i}");
            assert_eq!(runtime.objects[&0x30001000].raw,bytes(row["after"].as_str().unwrap()),"effect {i}");assert_eq!(runtime.objects[&0x30006000].raw,bytes(row["previous_after"].as_str().unwrap()),"tail {i}");
            let manager=runtime.objects.get(&0x30005000).map_or_else(||bytes(row["manager_before"].as_str().unwrap()),|v|v.raw.clone());assert_eq!(manager,bytes(row["manager_after"].as_str().unwrap()),"manager {i}");assert_eq!(json!(backend.calls),row["calls"],"call order {i}");
        }
    }
}
