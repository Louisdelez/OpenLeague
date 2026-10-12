//! Native AF2C60 path-bank reader composed with the owned B1B220 builder.
//! Acquisition is mandatory; bounds errors are explicit, never invented success.
use crate::{audio_bus_bank::{Cursor,Error},audio_plugin_factory::Memory,audio_timed_node_segment::Runtime as Paths,audio_path_resource};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn bit(b:&mut[u8],o:usize,mask:u8,value:bool){b[o]=(b[o]&!mask)|if value{mask}else{0};}
pub trait Services:audio_path_resource::Services{
 /// AF0640 acquisition must publish the resource through owner word68.
 fn acquire_resource(&mut self,owner:&mut Memory,resource:&mut Memory)->Result<u32,Error>;
}
fn span(cursor:&mut Cursor<'_>,base:u32,count:u32,stride:u32)->Result<Memory,Error>{
 let size=count.checked_mul(stride).ok_or(Error::Truncated)?as usize;
 let reference=if count==0{0}else{base.checked_add(u32::try_from(cursor.offset).map_err(|_|Error::Truncated)?).ok_or(Error::Truncated)?};
 let end=cursor.offset.checked_add(size).ok_or(Error::Truncated)?;let raw=cursor.bytes.get(cursor.offset..end).ok_or(Error::Truncated)?.to_vec();cursor.offset=end;Ok(Memory{reference,raw})
}
pub fn read(owner:&mut Memory,resource:&mut Memory,paths:&mut Paths,cursor:&mut Cursor<'_>,stream_reference:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
 if owner.reference==0||owner.raw.len()<86{return Err(Error::InvalidAllocation);}
 bit(&mut owner.raw,47,0x10,cursor.u8()?!=0);if owner.raw[47]&0x10==0{return Ok(1);}
 let first=cursor.u8()?;let enabled=cursor.u8()?;
 if first!=0{bit(&mut owner.raw,47,0x20,cursor.u8()?!=0);owner.raw[85]&=0xfc;}
 if enabled==0{return Ok(1);}
 let status=services.acquire_resource(owner,resource)?;owner.raw[85]=(owner.raw[85]&!2)|1;if status!=1{return Ok(status);}
 if resource.reference==0||word(&owner.raw,68)!=resource.reference||resource.raw.len()<57{return Err(Error::UnresolvedReference);}
 let mode=cursor.u32()?;owner.raw[85]=(owner.raw[85]&!0x0c)|(((mode as u8)<<2)&0x0c);
 set(&mut resource.raw,8,cursor.u32()?);bit(&mut resource.raw,56,1,cursor.u8()?!=0);
 if owner.raw[85]&0x0c==4{bit(&mut resource.raw,56,8,cursor.u8()?!=0);return Ok(status);}
 set(&mut resource.raw,32,cursor.u32()?);bit(&mut resource.raw,56,0x20,cursor.u8()?!=0);set(&mut resource.raw,36,cursor.u32()?);bit(&mut resource.raw,56,0x10,cursor.u8()?!=0);
 let point_count=cursor.u32()?;let points=span(cursor,stream_reference,point_count,16)?;
 let descriptor_count=cursor.u32()?;let pairs=span(cursor,stream_reference,descriptor_count,8)?;
 let mut result=status;if point_count!=0&&descriptor_count!=0{result=audio_path_resource::build(resource,paths,&audio_path_resource::Input{points,point_count,pairs,descriptor_count},pool,services)?;}
 for i in 0..descriptor_count{let jitter=cursor.read::<8>()?;if i<word(&resource.raw,52){let reference=word(&resource.raw,48);let block=paths.descriptors.get_mut(&reference).ok_or(Error::UnresolvedReference)?;let offset=(i as usize).checked_mul(16).and_then(|v|v.checked_add(8)).ok_or(Error::InvalidAllocation)?;block.raw.get_mut(offset..offset+8).ok_or(Error::InvalidAllocation)?.copy_from_slice(&jitter);}}
 Ok(result)
}
struct Acquiring<'a,S>{services:&'a mut S,pool:u32,defaults:[u32;3]}
impl<S:audio_path_resource::Services>audio_path_resource::Services for Acquiring<'_,S>{
 fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.services.allocate(pool,size)}
 fn free(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.services.free(pool,m)}
 fn observe_copy(&mut self,source:u32,destination:u32,size:u32){self.services.observe_copy(source,destination,size);}
}
impl<S:audio_path_resource::Services>Services for Acquiring<'_,S>{fn acquire_resource(&mut self,owner:&mut Memory,resource:&mut Memory)->Result<u32,Error>{crate::audio_path_resource_acquisition::acquire(owner,resource,self.pool,self.defaults,self.services)}}
/// Read with real acquisition/constructor; only physical allocation remains a service.
pub fn read_acquiring(owner:&mut Memory,resource:&mut Memory,paths:&mut Paths,cursor:&mut Cursor<'_>,stream_reference:u32,pool:u32,defaults:[u32;3],services:&mut impl audio_path_resource::Services)->Result<u32,Error>{read(owner,resource,paths,cursor,stream_reference,pool,&mut Acquiring{services,pool,defaults})}
#[cfg(test)]mod tests{
 use super::*;use std::collections::BTreeMap;use serde_json::{json,Value};use crate::audio_random::NativeRandom;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{pattern:u8,failure:u32,nth:u32,status:u32,calls:Vec<Value>,allocated:Vec<u32>}
 impl audio_path_resource::Services for Backend{
 fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let reference=if self.nth==self.failure{0}else if self.nth==1{0x4000a000}else{0x4000b000};self.calls.push(json!({"kind":"allocate","pool":pool,"bytes":size,"reference":reference}));if reference==0{return Ok(None);}self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
 fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("unexpected previous allocation in reader fixture"))}
 fn observe_copy(&mut self,source:u32,destination:u32,size:u32){self.calls.push(json!({"kind":"copy","source":source,"destination":destination,"bytes":size}));}
 }
 impl Services for Backend{fn acquire_resource(&mut self,owner:&mut Memory,_:&mut Memory)->Result<u32,Error>{self.calls.push(json!({"kind":"acquire_resource","owner":owner.reference,"status":self.status}));Ok(self.status)}}
 #[test]fn audio_path_resource_reader_matches344_native_flags_optional_modes_acquisition_build_oom_and_jitter_cases(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_reader_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],344);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut owner=Memory{reference:0x40004000,raw:bytes(b["owner"].as_str().unwrap())};let mut resource=Memory{reference:0x40005000,raw:bytes(b["resource"].as_str().unwrap())};let stream=bytes(b["stream"].as_str().unwrap());let mut cursor=Cursor{bytes:&stream,offset:0,remaining:0xcafebabe};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(17),interval:1024};let mut services=Backend{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure"].as_u64().unwrap()as u32,nth:0,status:row["acquire_status"].as_u64().unwrap()as u32,calls:vec![],allocated:vec![]};let result=read(&mut owner,&mut resource,&mut paths,&mut cursor,0x40006000,17,&mut services).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"result {i}");assert_eq!(json!(services.calls),row["calls"],"all acquisition/allocation/copy calls {i}");let allocations:Vec<Value>=services.allocated.iter().map(|r|{let m=paths.points.get(r).or_else(||paths.descriptors.get(r)).unwrap();json!({"reference":r,"size":m.raw.len(),"raw":hex(&m.raw),"freed":false})}).collect();assert_eq!(json!({"owner":hex(&owner.raw),"resource":hex(&resource.raw),"stream":hex(&stream),"cursor":0x40006000u32+cursor.offset as u32,"allocations":allocations}),row["after"],"all bytes, cursor, partial ownership and jitter {i}");assert_eq!(cursor.remaining,0xcafebabe);assert_eq!(paths.random.state(),17);}
 }
 #[test]fn audio_path_resource_reader_truncated_stream_returns_error_after_last_consumed_field(){
 let mut owner=Memory{reference:1,raw:vec![0;96]};let mut resource=Memory{reference:2,raw:vec![0;64]};set(&mut owner.raw,68,2);let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(17),interval:1024};let mut services=Backend{pattern:0,failure:0,nth:0,status:1,calls:vec![],allocated:vec![]};let mut cursor=Cursor{bytes:&[1,1],offset:0,remaining:2};assert_eq!(read(&mut owner,&mut resource,&mut paths,&mut cursor,100,17,&mut services),Err(Error::Truncated));assert_eq!(cursor.offset,2);assert_eq!(owner.raw[47],0x10);assert!(services.calls.is_empty());assert!(paths.points.is_empty()&&paths.descriptors.is_empty());
 }
 struct AcquisitionBackend{pattern:u8,failure:u32,nth:u32,existing:bool,calls:Vec<Value>,allocated:Vec<u32>}
 impl audio_path_resource::Services for AcquisitionBackend{
 fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let stage=self.nth-if self.existing{0}else{1};let reference=if self.nth==self.failure{0}else if stage==0{0x40005000}else if stage==1{0x4000a000}else{0x4000b000};self.calls.push(json!({"kind":"allocate","pool":pool,"bytes":size,"reference":reference}));if reference==0{return Ok(None);}self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
 fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("unexpected free in fresh/cached reader composition"))}
 fn observe_copy(&mut self,source:u32,destination:u32,size:u32){self.calls.push(json!({"kind":"copy","source":source,"destination":destination,"bytes":size}));}
 }
 #[test]fn audio_path_resource_reader_acquiring_matches96_native_real_constructor_reader_shared_blocks_and_oom_compositions(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_reader_acquiring_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],96);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut owner=Memory{reference:0x40004000,raw:bytes(b["owner"].as_str().unwrap())};let mut resource=Memory{reference:0x40005000,raw:bytes(b["resource"].as_str().unwrap())};let stream=bytes(b["stream"].as_str().unwrap());let mut cursor=Cursor{bytes:&stream,offset:0,remaining:0};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(17),interval:1024};let mut services=AcquisitionBackend{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure"].as_u64().unwrap()as u32,nth:0,existing:row["existing"].as_bool().unwrap(),calls:vec![],allocated:vec![]};let defaults:[u32;3]=row["defaults"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();let result=read_acquiring(&mut owner,&mut resource,&mut paths,&mut cursor,0x40006000,17,defaults,&mut services).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"result {i}");assert_eq!(json!(services.calls),row["calls"],"actual acquisition and builder calls {i}");let allocations:Vec<Value>=services.allocated.iter().map(|r|{let m=if *r==resource.reference{&resource}else{paths.points.get(r).or_else(||paths.descriptors.get(r)).unwrap()};json!({"reference":r,"size":m.raw.len(),"raw":hex(&m.raw),"freed":false})}).collect();assert_eq!(json!({"owner":hex(&owner.raw),"resource":hex(&resource.raw),"stream":hex(&stream),"cursor":0x40006000u32+cursor.offset as u32,"allocations":allocations}),row["after"],"all acquiring-reader bytes and partial owned allocation states {i}");}
 }
}
