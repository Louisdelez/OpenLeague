//! AF85A0/AF8660 normal effect bank-loading wrappers with AF7940 memory stream.
//! Only supported effect bodies are dispatched; other HIRC readers fail explicitly.
use crate::{audio_bus_bank::Error,audio_plugin_factory::{Memory,Registry as Plugins},
    audio_meter_lifecycle::Runtime,audio_effect_resource_registry::{Registry,Services as ResourceServices},
    audio_effect_resource_bank::POOL};
pub trait Services:ResourceServices{
    fn lock_manager(&mut self)->Result<(),Error>;
    fn unlock_manager(&mut self)->Result<(),Error>;
}
#[derive(Debug,PartialEq,Eq)]pub struct Dispatch{pub index:u32,pub target:u32,pub category:Option<bool>}
/// Native CL-only selector. Addresses name retained historical handlers, not executable pointers.
pub fn classify(ecx:u32)->Dispatch{
    const TARGETS:[u32;20]=[0xafb77f,0xafb6e5,0xafb6bf,0xafb6d2,0xafb6fb,0xafb71c,0xafb75e,0xafb792,0xafb73d,0xafb861,0xafb861,0xafb861,0xafb861,0xafb7b8,0xafb7d6,0xafb7f4,0xafb815,0xafb82b,0xafb846,0xafb7a5];
    let tag=ecx&255;let index=tag.wrapping_sub(1);
    Dispatch{index,target:TARGETS.get(index as usize).copied().unwrap_or(0xafb861),category:match tag{18=>Some(true),19=>Some(false),_=>None}}
}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Debug)]pub struct Stream{pub raw:[u8;40],pub base:u32,pub bytes:Vec<u8>}
impl Stream{
    /// AF7A70 resets memory positioning; file/provider state remains untouched.
    pub(crate)fn reset_memory(&mut self){let source=word(&self.raw,0);set(&mut self.raw,4,source);set(&mut self.raw,8,0);set(&mut self.raw,24,0);}
    /// AF7720 memory-mode close. Provider destruction needs its qualified backend.
    pub(crate)fn close_memory(&mut self)->Result<u32,Error>{
        if word(&self.raw,28)!=0{return Err(Error::Backend("bank provider close not qualified"));}
        set(&mut self.raw,24,0);set(&mut self.raw,8,0);Ok(1)
    }

    /// AF7D70 attaches a memory bank without changing the other stream fields.
    pub fn attach_memory(&mut self,base:u32,bytes:Vec<u8>)->Result<u32,Error>{
        let length=u32::try_from(bytes.len()).map_err(|_|Error::InvalidAllocation)?;
        set(&mut self.raw,24,base);set(&mut self.raw,8,length);self.base=base;self.bytes=bytes;Ok(1)
    }

    /// AF7750/AF7900 copy only available bytes and return56 on a short header.
    pub(crate)fn header(&mut self,size:u32)->Result<(u32,Vec<u8>),Error>{
        if word(&self.raw,28)!=0{return Err(Error::Backend("buffered audio bank stream not qualified"));}
        let pointer=word(&self.raw,24);let remaining=word(&self.raw,8);let copied=size.min(remaining);
        let offset=pointer.checked_sub(self.base).ok_or(Error::UnresolvedReference)?as usize;
        let end=offset.checked_add(copied as usize).ok_or(Error::Truncated)?;
        let bytes=self.bytes.get(offset..end).ok_or(Error::Truncated)?.to_vec();
        set(&mut self.raw,8,remaining-copied);set(&mut self.raw,24,pointer.checked_add(copied).ok_or(Error::InvalidAllocation)?);
        Ok((if copied==size{1}else{56},bytes))
    }
    pub(crate)fn skip_count(&mut self,size:u32)->Result<u32,Error>{
        if word(&self.raw,28)!=0{return Err(Error::Backend("buffered audio bank stream not qualified"));}
        let remaining=word(&self.raw,8);let consumed=size.min(remaining);
        let pointer=word(&self.raw,24).checked_add(consumed).ok_or(Error::InvalidAllocation)?;
        set(&mut self.raw,8,remaining-consumed);set(&mut self.raw,24,pointer);Ok(consumed)
    }
    fn skip(&mut self,size:u32)->Result<u32,Error>{let consumed=self.skip_count(size)?;Ok(if size==consumed{1}else{7})}

    fn read(&mut self,size:u32)->Result<Option<Vec<u8>>,Error>{
        if word(&self.raw,28)!=0{return Err(Error::Backend("buffered audio bank stream not qualified"));}
        let pointer=word(&self.raw,24);let remaining=word(&self.raw,8);let consumed=size.min(remaining);
        let next=pointer.checked_add(consumed).ok_or(Error::InvalidAllocation)?;
        if pointer==0{set(&mut self.raw,8,remaining-consumed);set(&mut self.raw,24,next);return Ok(None);}
        let offset=pointer.checked_sub(self.base).ok_or(Error::UnresolvedReference)?as usize;
        let end=offset.checked_add(size as usize).ok_or(Error::Truncated)?;
        let bytes=self.bytes.get(offset..end).ok_or(Error::Truncated)?.to_vec();
        set(&mut self.raw,8,remaining-consumed);set(&mut self.raw,24,next);Ok(Some(bytes))
    }
    fn release(&mut self,runtime:&mut Runtime,backend:&mut impl Services)->Result<(),Error>{
        let pointer=word(&self.raw,20);
        if pointer!=0{backend.free_pool(POOL,runtime.objects.get(&pointer).ok_or(Error::UnresolvedReference)?)?;runtime.objects.remove(&pointer);set(&mut self.raw,20,0);}Ok(())
    }
}
#[derive(Debug)]pub struct Holder{pub raw:[u8;64],pub slots:Memory}
impl Holder{
    /// AFF610 grows capacity by the incoming section count, copies active refs,
    /// then frees old storage. Unused new bytes retain allocator contents.
    pub fn reserve_section(&mut self,additional:u32,backend:&mut impl Services)->Result<bool,Error>{
        let capacity=word(&self.raw,60).checked_add(additional).ok_or(Error::InvalidAllocation)?;
        let size=capacity.checked_mul(4).ok_or(Error::InvalidAllocation)?;
        let Some(mut memory)=backend.allocate(POOL,size)?else{return Ok(false);};
        if memory.reference==0||memory.raw.len()!=size as usize{return Err(Error::InvalidAllocation);}
        let pointer=word(&self.raw,52);let count=word(&self.raw,56);
        if pointer!=0{
            if pointer!=self.slots.reference||count as usize>self.slots.raw.len()/4||count>capacity{return Err(Error::InvalidAllocation);}
            memory.raw[..count as usize*4].copy_from_slice(&self.slots.raw[..count as usize*4]);
            backend.free_pool(POOL,&self.slots)?;
        }
        set(&mut self.raw,52,memory.reference);set(&mut self.raw,60,capacity);self.slots=memory;Ok(true)
    }

    /// AFC410 releases bank-held effect references in255-item critical sections.
    /// Other HIRC classes need their own release dispatch; never substitute an effect.
    pub fn unload_effects(&mut self,resources:&mut Registry,runtime:&mut Runtime,backend:&mut impl Services)->Result<(),Error>{
        let pointer=word(&self.raw,52);let count=word(&self.raw,56);
        if count!=0 && (pointer!=self.slots.reference || pointer==0 || count as usize>self.slots.raw.len()/4){return Err(Error::InvalidAllocation);}
        let mut index=0;
        while index<word(&self.raw,56){
            backend.lock_manager()?;
            let released=(||{
                for _ in 0..255{
                    if index>=word(&self.raw,56){break;}
                    let reference=word(&self.slots.raw,index as usize*4);
                    resources.release(runtime,reference,backend)?;index+=1;
                }
                Ok(())
            })();backend.unlock_manager()?;released?;
        }
        if pointer!=0{
            if pointer!=self.slots.reference{return Err(Error::InvalidAllocation);}
            set(&mut self.raw,56,0);backend.free_pool(POOL,&self.slots)?;
            set(&mut self.raw,52,0);set(&mut self.raw,60,0);self.slots.reference=0;self.slots.raw.clear();
        }
        Ok(())
    }
    fn append(&mut self,reference:u32)->Result<(),Error>{
        let count=word(&self.raw,56);let capacity=word(&self.raw,60);
        if count>=capacity{return Ok(());}
        let pointer=word(&self.raw,52);
        if pointer!=self.slots.reference || pointer==0 || count as usize*4+4>self.slots.raw.len(){return Err(Error::InvalidAllocation);}
        set(&mut self.raw,56,count+1);set(&mut self.slots.raw,count as usize*4,reference);Ok(())
    }
}
/// Native default dispatch may skip unhandled tags when its extension is absent.
/// Caller must select this policy explicitly; known reader bodies never silently skip.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum UnknownHirc{Reject,SkipNativeDefaults}
/// AFB630 section count, reference reservation, five-byte headers and ordered bodies.
/// Returns native status while preserving any loaded prefix for normal unload.
pub fn load_section(stream:&mut Stream,holder:&mut Holder,resources:&mut Registry,
    runtime:&mut Runtime,plugins:&Plugins,policy:UnknownHirc,backend:&mut impl Services)->Result<u32,Error>{
    let(status,bytes)=stream.header(4)?;if status!=1{return Ok(status);}
    let count=word(&bytes,0);if count!=0&&!holder.reserve_section(count,backend)?{return Ok(2);}
    let mut status=1;
    for _ in 0..count{
        let(result,bytes)=stream.header(5)?;if result!=1{return Ok(result);}
        let descriptor:[u8;5]=bytes.try_into().map_err(|_|Error::Truncated)?;
        let dispatch=classify(u32::from(descriptor[0]));
        status=if dispatch.category.is_some(){load_effect(stream,holder,resources,runtime,plugins,descriptor,backend)?}
        else if dispatch.target==0xafb861&&policy==UnknownHirc::SkipNativeDefaults{stream.skip(u32::from_le_bytes(descriptor[1..].try_into().unwrap()))?}
        else{return Err(Error::Backend("HIRC body reader or extension not implemented for this type"));};
        if status!=1{break;}
    }Ok(status)
}
pub fn load_effect(stream:&mut Stream,holder:&mut Holder,resources:&mut Registry,
    runtime:&mut Runtime,plugins:&Plugins,descriptor:[u8;5],backend:&mut impl Services)->Result<u32,Error>{
    let category=classify(u32::from(descriptor[0])).category.ok_or(Error::Backend("HIRC body reader not implemented for this type"))?;
    let size=u32::from_le_bytes(descriptor[1..].try_into().unwrap());
    let Some(bytes)=stream.read(size)?else{return Ok(2);};
    let result=(||{
        if bytes.len()<4{return Err(Error::Truncated);}
        let id=word(&bytes,0);let acquired=resources.acquire(runtime,category,id,backend)?;
        let(reference,status)=if let Some(reference)=acquired{(reference,1)}else{
            backend.lock_manager()?;
            let created=(||{
                let reference=resources.create(runtime,id,category,backend)?;
                if reference==0{return Ok((0,2));}
                match resources.load(runtime,reference,plugins,&bytes,backend){
                    Ok(loaded)=>{if loaded.status!=1{resources.release(runtime,reference,backend)?;}Ok((reference,loaded.status))},
                    Err(error)=>{resources.release(runtime,reference,backend)?;Err(error)}
                }
            })();backend.unlock_manager()?;created?
        };
        if status==1{holder.append(reference)?;}Ok(status)
    })();stream.release(runtime,backend)?;result
}
#[cfg(test)]mod tests{
    use super::*;
    use crate::{audio_plugin_factory::{Allocator,Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR},audio_meter_lifecycle::Lifetime,audio_bus_effect_instance::Resource,audio_effect_resource_registry::Header,audio_effect_resource_bank::Services as BankServices,audio_effect_resource_bank::tests::Heap};
    use serde_json::{Value,json};
    struct Scoped{heap:Heap}
    impl Allocator for Scoped{fn allocate(&mut self,a:u32,s:u32)->Result<Option<Memory>,Error>{self.heap.allocate(a,s)}}
    impl Lifetime for Scoped{
        fn free(&mut self,a:u32,m:&Memory)->Result<(),Error>{Lifetime::free(&mut self.heap,a,m)}
        fn register_callback(&mut self,c:u32)->Result<(),Error>{self.heap.register_callback(c)}
    }
    impl BankServices for Scoped{fn free_pool(&mut self,a:u32,m:&Memory)->Result<(),Error>{self.heap.free_pool(a,m)}}
    impl ResourceServices for Scoped{
        fn lock(&mut self,category:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"registry","category":category}));Ok(())}
        fn unlock(&mut self,category:bool)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"registry","category":category}));Ok(())}
    }
    impl Services for Scoped{
        fn lock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"lock","scope":"bank_manager","category":null}));Ok(())}
        fn unlock_manager(&mut self)->Result<(),Error>{self.heap.calls.push(json!({"kind":"unlock","scope":"bank_manager","category":null}));Ok(())}
    }
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test]fn audio_hirc_selector_matches512_native_low_byte_and_dispatch_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_hirc_dispatch_contract.json")).unwrap();assert_eq!(proof["case_count"],512);
        for row in proof["cases"].as_array().unwrap(){let result=classify(row["ecx"].as_u64().unwrap()as u32);assert_eq!(u64::from(result.index),row["index"].as_u64().unwrap());assert_eq!(u64::from(result.target),row["target"].as_u64().unwrap());}
    }
    #[test]fn audio_normal_effect_bank_loading_matches96_native_actual_stream_lookup_create_and_holder_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_bank_loader_contract.json")).unwrap();assert_eq!(proof["case_count"],96);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let data=bytes(row["bank_payload"].as_str().unwrap());let id=word(&data,0);let category=row["category"].as_bool().unwrap();let mut runtime=Runtime::default();let mut resources=Registry::default();resources.counts[usize::from(category)]=7;
            let mut backend=Scoped{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true}};
            for v in row["initial_allocations"].as_array().unwrap(){
                let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());backend.heap.allocations.push((reference,raw.len()as u32));
                if raw.len()==48{resources.instances.resources.insert(reference,Resource{reference,id:word(&raw,8),references:word(&raw,12),plugin_id:word(&raw,16),parameter:word(&raw,20),bindings:vec![]});resources.headers.insert(reference,Header{category,pairs:[0;3],rtpc:[0;3]});resources.instances.buckets.insert((category,id%193),vec![reference]);}
                runtime.objects.insert(reference,Memory{reference,raw});
            }
            let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);
            let mut holder=Holder{raw:[0xa5;64],slots:Memory{reference:0x30005400,raw:vec![0xa5;8]}};set(&mut holder.raw,52,holder.slots.reference);set(&mut holder.raw,56,0);set(&mut holder.raw,60,row["capacity"].as_u64().unwrap()as u32);
            let mut descriptor=[0;5];descriptor[0]=if category{18}else{19};descriptor[1..].copy_from_slice(&(data.len()as u32).to_le_bytes());
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            let result=load_effect(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,descriptor,&mut backend).unwrap();
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"result {i}");assert_eq!(stream.raw.to_vec(),bytes(row["stream"].as_str().unwrap()),"stream {i}");assert_eq!(holder.raw.to_vec(),bytes(row["holder"].as_str().unwrap()),"holder {i}");assert_eq!(holder.slots.raw,bytes(row["array"].as_str().unwrap()),"reference array {i}");
            let head=resources.instances.buckets.get(&(category,id%193)).and_then(|b|b.first()).copied().unwrap_or(0);assert_eq!(u64::from(head),row["head"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[usize::from(category)]),row["count"].as_u64().unwrap());
            assert_eq!(backend.heap.snapshot(&runtime),row["allocations"],"owned objects {i}");assert_eq!(json!(backend.heap.calls),row["calls"],"all lock/allocation calls {i}");
        }
    }
    #[test]fn audio_bank_load_unload_matches112_native_cleanup_and255_reference_batching_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_bank_unload_contract.json")).unwrap();assert_eq!(proof["case_count"],112);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let category=row["category"].as_bool().unwrap();let mut runtime=Runtime::default();let mut resources=Registry::default();resources.counts[usize::from(category)]=7;
            let mut backend=Scoped{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap_or(0)as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true}};
            let mut slots=None;let mut id=0;
            for v in row["initial_allocations"].as_array().unwrap(){
                let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());backend.heap.allocations.push((reference,raw.len()as u32));
                if reference==0x30005400{slots=Some(Memory{reference,raw});continue;}
                if raw.len()==48{id=word(&raw,8);resources.instances.resources.insert(reference,Resource{reference,id,references:word(&raw,12),plugin_id:word(&raw,16),parameter:word(&raw,20),bindings:vec![]});resources.headers.insert(reference,Header{category,pairs:[0;3],rtpc:[0;3]});resources.instances.buckets.insert((category,id%193),vec![reference]);}
                runtime.objects.insert(reference,Memory{reference,raw});
            }
            let data=row["bank_payload"].as_str().map(bytes).unwrap_or_default();if !data.is_empty(){id=word(&data,0);}
            let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};if !data.is_empty(){set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);}
            let mut holder=Holder{raw:if let Some(raw)=row["initial_holder"].as_str(){bytes(raw).try_into().unwrap()}else{[0xa5;64]},slots:slots.unwrap()};
            if row["initial_holder"].is_null(){set(&mut holder.raw,52,holder.slots.reference);set(&mut holder.raw,56,0);set(&mut holder.raw,60,row["capacity"].as_u64().unwrap()as u32);}
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            for(stage_index,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                let result=if stage["stage"]=="load"{let mut descriptor=[0;5];descriptor[0]=if category{18}else{19};descriptor[1..].copy_from_slice(&(data.len()as u32).to_le_bytes());load_effect(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,descriptor,&mut backend).unwrap()}else{holder.unload_effects(&mut resources,&mut runtime,&mut backend).unwrap();0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"result {i}/{stage_index}");assert_eq!(stream.raw.to_vec(),bytes(stage["stream"].as_str().unwrap()),"stream {i}/{stage_index}");assert_eq!(holder.raw.to_vec(),bytes(stage["holder"].as_str().unwrap()),"holder {i}/{stage_index}");
                let snapshot:Vec<Value>=backend.heap.allocations.iter().map(|&(reference,size)|{
                    let memory=backend.heap.freed.get(&reference).or_else(||runtime.objects.get(&reference)).or_else(||(holder.slots.reference==reference).then_some(&holder.slots)).unwrap();let raw:String=memory.raw.iter().map(|b|format!("{b:02x}")).collect();json!({"reference":reference,"size":size,"freed":backend.heap.freed.contains_key(&reference),"raw":raw})
                }).collect();
                let head=resources.instances.buckets.get(&(category,id%193)).and_then(|b|b.first()).copied().unwrap_or(0);
                assert_eq!(u64::from(head),stage["head"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[usize::from(category)]),stage["count"].as_u64().unwrap());assert_eq!(json!(snapshot),stage["allocations"],"all owned bytes/frees {i}/{stage_index}");assert_eq!(json!(backend.heap.calls),stage["calls"],"cleanup/batch lock order {i}/{stage_index}");
            }
        }
    }

    #[test]fn audio_hirc_section_loading_matches140_native_preallocation_loop_duplicate_and_failure_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_hirc_section_contract.json")).unwrap();assert_eq!(proof["case_count"],140);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let data=bytes(row["section_payload"].as_str().unwrap());let mut runtime=Runtime::default();let mut resources=Registry::default();
            let mut backend=Scoped{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true}};
            let preallocated=row["preallocated"].as_bool().unwrap();let mut holder=Holder{raw:[0xa5;64],slots:Memory{reference:if preallocated{0x30005400}else{0},raw:if preallocated{vec![0xa5;8]}else{vec![]}}};set(&mut holder.raw,52,holder.slots.reference);set(&mut holder.raw,56,0);set(&mut holder.raw,60,if preallocated{2}else{0});
            if preallocated{backend.heap.allocations.push((holder.slots.reference,8));}
            let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                backend.heap.calls.clear();let result=if j==0{load_section(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,&mut backend).unwrap()}else{holder.unload_effects(&mut resources,&mut runtime,&mut backend).unwrap();0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(stream.raw.to_vec(),bytes(stage["stream"].as_str().unwrap()),"stream {i}/{j}");assert_eq!(holder.raw.to_vec(),bytes(stage["holder"].as_str().unwrap()),"holder {i}/{j}");assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=backend.heap.allocations.iter().map(|&(reference,size)|{let m=backend.heap.freed.get(&reference).or_else(||runtime.objects.get(&reference)).or_else(||(holder.slots.reference==reference).then_some(&holder.slots)).unwrap();let raw:String=m.raw.iter().map(|b|format!("{b:02x}")).collect();json!({"reference":reference,"size":size,"freed":backend.heap.freed.contains_key(&reference),"raw":raw})}).collect();
                assert_eq!(json!(allocations),stage["allocations"],"owned reference/resource bytes and frees {i}/{j}");assert_eq!(json!(backend.heap.calls),stage["calls"],"physical call order {i}/{j}");
            }
            assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());assert_eq!(backend.heap.freed.len(),backend.heap.allocations.len());
        }
    }

    #[test]fn audio_hirc_sections_match168_native_live_prefix_short_headers_and_failure_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_hirc_extended_contract.json")).unwrap();assert_eq!(proof["case_count"],168);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let data=bytes(row["section_payload"].as_str().unwrap());let mut runtime=Runtime::default();let mut resources=Registry::default();
            let mut backend=Scoped{heap:Heap{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:row["failure_nth"].as_u64().unwrap()as u32,calls:vec![],allocations:vec![],freed:Default::default(),methods:true}};
            let preallocated=false;let mut holder=Holder{raw:[0xa5;64],slots:Memory{reference:if preallocated{0x30005400}else{0},raw:if preallocated{vec![0xa5;8]}else{vec![]}}};set(&mut holder.raw,52,holder.slots.reference);set(&mut holder.raw,56,0);set(&mut holder.raw,60,if preallocated{2}else{0});
            if preallocated{backend.heap.allocations.push((holder.slots.reference,8));}
            let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            for(j,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                backend.heap.calls.clear();let result=if stage["stage"].as_str().unwrap().starts_with("load"){load_section(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,UnknownHirc::SkipNativeDefaults,&mut backend).unwrap()}else{holder.unload_effects(&mut resources,&mut runtime,&mut backend).unwrap();0};
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{j}");assert_eq!(stream.raw.to_vec(),bytes(stage["stream"].as_str().unwrap()),"stream {i}/{j}");assert_eq!(holder.raw.to_vec(),bytes(stage["holder"].as_str().unwrap()),"holder {i}/{j}");assert_eq!(u64::from(resources.counts[0]),stage["custom_count"].as_u64().unwrap());assert_eq!(u64::from(resources.counts[1]),stage["shared_count"].as_u64().unwrap());
                let allocations:Vec<Value>=backend.heap.allocations.iter().map(|&(reference,size)|{let m=backend.heap.freed.get(&reference).or_else(||runtime.objects.get(&reference)).or_else(||(holder.slots.reference==reference).then_some(&holder.slots)).unwrap();let raw:String=m.raw.iter().map(|b|format!("{b:02x}")).collect();json!({"reference":reference,"size":size,"freed":backend.heap.freed.contains_key(&reference),"raw":raw})}).collect();
                assert_eq!(json!(allocations),stage["allocations"],"owned reference/resource bytes and frees {i}/{j}");assert_eq!(json!(backend.heap.calls),stage["calls"],"physical call order {i}/{j}");
            }
            assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());assert_eq!(backend.heap.freed.len(),backend.heap.allocations.len());
        }
    }
    #[test]fn audio_hirc_strict_unknown_or_unimplemented_reader_keeps_loaded_prefix_for_cleanup(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_actual_bank_contract.json")).unwrap();let payload=bytes(proof["sources"][0]["payload"].as_str().unwrap());
        for(policy,tag)in [(UnknownHirc::Reject,0),(UnknownHirc::Reject,3),(UnknownHirc::SkipNativeDefaults,3)]{
            let mut data=2u32.to_le_bytes().to_vec();data.push(19);data.extend_from_slice(&(payload.len()as u32).to_le_bytes());data.extend_from_slice(&payload);data.push(tag);data.extend_from_slice(&0u32.to_le_bytes());
            let mut runtime=Runtime::default();let mut resources=Registry::default();let mut backend=Scoped{heap:Heap{pattern:0xa5,next:0x3000c000,nth:0,failure:0,calls:vec![],allocations:vec![],freed:Default::default(),methods:true}};
            let mut holder=Holder{raw:[0xa5;64],slots:Memory{reference:0,raw:vec![]}};for o in [52,56,60]{set(&mut holder.raw,o,0);}
            let mut stream=Stream{raw:[0;40],base:0x30008000,bytes:data.clone()};set(&mut stream.raw,8,data.len()as u32);set(&mut stream.raw,24,stream.base);
            let plugins=Plugins{entries:vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            assert!(matches!(load_section(&mut stream,&mut holder,&mut resources,&mut runtime,&plugins,policy,&mut backend),Err(Error::Backend(_))));
            assert_eq!(word(&holder.raw,56),1);assert_eq!(resources.instances.resources.len(),1);assert_eq!(word(&stream.raw,8),0);
            let resource=resources.instances.resources.values().next().unwrap();assert_eq!(resource.id,word(&payload,0));assert_eq!(resource.references,1);assert_ne!(resource.parameter,0);
            holder.unload_effects(&mut resources,&mut runtime,&mut backend).unwrap();assert!(runtime.objects.is_empty());assert!(resources.instances.resources.is_empty());assert_eq!(backend.heap.freed.len(),backend.heap.allocations.len());assert_eq!(holder.slots.reference,0);
        }
    }

}
