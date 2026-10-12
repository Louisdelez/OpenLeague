//! Native B253F0 resource parameter factory/initialization/replacement.
//! Full HIRC payload reading and other plugin classes remain explicit requirements.
use crate::{audio_bus_bank::Error,audio_bus_effect_instance::Resource,
    audio_plugin_factory::{Registry,Kind,MeterCreators,meter_init_parameter},
    audio_meter_lifecycle::{Runtime,Lifetime}};
pub const PARAMETER_ALLOCATOR:u32=0x1210234;
/// Missing registration/null creator/allocation failure preserve the previous
/// resource and return native1. Successful initialization destroys its old owned
/// parameter before publishing the new parameter and plugin ID.
pub fn install(resource:&mut Resource,registry:&Registry,runtime:&mut Runtime,
    id:u32,backing:&[u8],length:u32,backend:&mut impl Lifetime)->Result<u32,Error>{
    let created=registry.create(Kind::Parameter,id,PARAMETER_ALLOCATOR,
        &mut MeterCreators {allocator:backend,objects:&mut runtime.objects})?;
    if created.status!=1 || created.reference==0{return Ok(1);}
    let result=meter_init_parameter(runtime.objects.get_mut(&created.reference)
        .ok_or(Error::UnresolvedReference)?,backing,length);
    let status=match result {
        Ok(status)=>status,
        Err(error)=>{runtime.terminate_parameter(created.reference,PARAMETER_ALLOCATOR,backend)?;return Err(error);}
    };
    if status!=1{runtime.terminate_parameter(created.reference,PARAMETER_ALLOCATOR,backend)?;return Ok(status);}
    if resource.parameter!=0{runtime.terminate_parameter(resource.parameter,PARAMETER_ALLOCATOR,backend)?;resource.parameter=0;}
    resource.parameter=created.reference;resource.plugin_id=id;Ok(1)
}
#[cfg(test)]mod tests {
    use super::*;
    use crate::audio_plugin_factory::{Allocator,Memory,Registration,METER_ID,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR};
    use serde_json::{Value,json};
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
    struct Heap{pattern:u8,failure:bool,next:u32,calls:Vec<Value>,allocations:Vec<(u32,u32)>,freed:std::collections::BTreeMap<u32,Memory>}
    impl Allocator for Heap {
        fn allocate(&mut self,allocator:u32,size:u32)->Result<Option<Memory>,Error>{
            let reference=if self.failure{0}else{let ref_=self.next;self.next+=0x100;self.allocations.push((ref_,size));ref_};
            self.calls.push(json!({"kind":"allocate","allocator":allocator,"size":size,"reference":reference}));
            Ok(if reference==0{None}else{Some(Memory{reference,raw:vec![self.pattern;size as usize]})})
        }
    }
    impl Lifetime for Heap {
        fn free(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{
            assert!(self.freed.insert(memory.reference,memory.clone()).is_none());
            self.calls.push(json!({"kind":"free","allocator":allocator,"reference":memory.reference}));Ok(())
        }
        fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("parameter creation must not schedule DSP"))}
    }
    impl crate::audio_plugin_registration::Pool for Heap{fn free(&mut self,allocator:u32,memory:&Memory)->Result<(),Error>{Lifetime::free(self,allocator,memory)}}
    #[test]fn audio_effect_resource_parameter_matches96_native_factory_initialization_and_replacement_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_effect_resource_parameter_contract.json")).unwrap();assert_eq!(proof["case_count"],96);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let before=bytes(row["before"].as_str().unwrap());
            let mut resource=Resource{reference:0x30001000,id:word(&before,8),references:word(&before,12),plugin_id:word(&before,16),parameter:word(&before,20),bindings:vec![]};
            let pattern=row["pattern"].as_u64().unwrap()as u8;
            let mut heap=Heap{pattern,failure:row["profile"]=="failure",next:0x30005000,calls:vec![],allocations:vec![],freed:Default::default()};let mut runtime=Runtime::default();
            if resource.parameter!=0{let mut raw=vec![pattern;32];raw[..4].copy_from_slice(&0xff36a4u32.to_le_bytes());runtime.objects.insert(resource.parameter,Memory{reference:resource.parameter,raw});heap.allocations.push((resource.parameter,32));}
            let registry=Registry{entries:if row["profile"]=="missing"{vec![]}else{vec![Registration{id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:if row["profile"]=="null_parameter"{0}else{METER_PARAMETER_CREATOR}}]}};
            for(stage_index,stage)in row["stages"].as_array().unwrap().iter().enumerate(){
                let result=install(&mut resource,&registry,&mut runtime,stage["id"].as_u64().unwrap()as u32,&bytes(row["payload"].as_str().unwrap()),row["length"].as_u64().unwrap()as u32,&mut heap).unwrap();
                assert_eq!(u64::from(result),stage["result"].as_u64().unwrap(),"status {i}/{stage_index}");
                let mut raw=before.clone();raw[16..20].copy_from_slice(&resource.plugin_id.to_le_bytes());raw[20..24].copy_from_slice(&resource.parameter.to_le_bytes());
                assert_eq!(raw,bytes(stage["resource"].as_str().unwrap()),"resource {i}/{stage_index}");
                let allocations:Vec<Value>=heap.allocations.iter().map(|&(reference,size)|{
                    let object=heap.freed.get(&reference).or_else(||runtime.objects.get(&reference)).unwrap();
                    let raw:String=object.raw.iter().map(|b|format!("{b:02x}")).collect();
                    json!({"reference":reference,"size":size,"freed":heap.freed.contains_key(&reference),"raw":raw})
                }).collect();
                assert_eq!(json!(allocations),stage["allocations"],"owned memory {i}/{stage_index}");assert_eq!(json!(heap.calls),stage["calls"],"allocation/termination order {i}/{stage_index}");
            }
        }
    }
    #[test]fn audio_effect_resource_registration_load_owns_initialized_source_for_instance_cloning(){
        use crate::audio_plugin_registration::Table;
        let mut heap=Heap{pattern:0xa5,failure:false,next:0x30005000,calls:vec![],allocations:vec![],freed:Default::default()};
        let mut table=Table{memory:Memory{reference:0,raw:vec![]},count:0,capacity:0,allocator:u32::MAX};
        assert_eq!(table.register(3,0,129,METER_EFFECT_CREATOR,METER_PARAMETER_CREATOR,&mut heap).unwrap(),1);
        let mut runtime=Runtime::default();let mut resource=Resource{reference:0x30001000,id:100,references:7,plugin_id:0,parameter:0,bindings:vec![]};
        assert_eq!(install(&mut resource,&table.registry().unwrap(),&mut runtime,METER_ID,&[],0,&mut heap).unwrap(),1);
        assert_ne!(resource.parameter,table.memory.reference);
        let original=runtime.objects[&resource.parameter].clone();
        let cloned=crate::audio_plugin_factory::meter_clone_parameter(&original,0x121023c,&mut heap).unwrap().unwrap();
        assert_ne!(cloned.reference,resource.parameter);assert_eq!(cloned.raw,original.raw);assert!(heap.freed.is_empty());assert_eq!(resource.references,7);
    }
}
