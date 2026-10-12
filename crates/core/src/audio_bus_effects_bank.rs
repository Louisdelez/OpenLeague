//! Native Bus effects B04350/B00770/AFFBD0/AFDDE0 bank/cache behavior.
use crate::{audio_bus_registry::Bus,audio_bus_bank::{self as bank,Cursor,Error}};
use std::collections::BTreeMap;
#[derive(Debug,Clone)] pub struct Cache{pub raw:[u8;36]}
impl Cache{fn word(&self,o:usize)->u32{u32::from_le_bytes(self.raw[o..o+4].try_into().unwrap())}pub fn notification(&self)->crate::audio_bus_parameter_notification::Cache{crate::audio_bus_parameter_notification::Cache{effect_ids:[self.word(4),self.word(12),self.word(20),self.word(28)],flags:self.raw[32]}}}
#[derive(Debug,Default)] pub struct Store{pub caches:BTreeMap<u32,Cache>}
pub struct Allocation{pub reference:u32,pub raw:[u8;36]}
pub trait Backend{
 fn allocate(&mut self,size:u32)->Result<Option<Allocation>,Error>;
 fn changed(&mut self,bus:&mut Bus,cache:&Cache)->Result<(),Error>;
 fn slot(&mut self,bus:&mut Bus,index:u32)->Result<(),Error>;
 fn mask(&mut self,bus:&mut Bus,value:u32,mask:u32)->Result<(),Error>;
 fn apply(&mut self,bus:&Bus,value:u32,mask:u32)->Result<(),Error>;
}
#[derive(Debug,Clone,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call{Allocate{size:u32},Changed,Slot{index:u32},Mask{args:[u32;2]}}
#[derive(Debug)] pub struct Read{pub result:u32,pub calls:Vec<Call>}
impl Store{
 fn ensure(&mut self,bus:&mut Bus,b:&mut impl Backend,calls:&mut Vec<Call>)->Result<bool,Error>{let reference=bus.word(0x18);if reference!=0{if !self.caches.contains_key(&reference){return Err(Error::MissingEffectsCache(reference));}return Ok(true);}calls.push(Call::Allocate{size:36});let Some(mut a)=b.allocate(36)? else{return Ok(false);};if a.reference==0 || self.caches.contains_key(&a.reference){return Err(Error::InvalidAllocation);}for o in [0,8,16,24]{a.raw[o..o+2].fill(0);a.raw[o+4..o+8].fill(0);}a.raw[32]=0;bus.set_word(0x18,a.reference);self.caches.insert(a.reference,Cache{raw:a.raw});Ok(true)}
 fn slot(&mut self,bus:&mut Bus,index:u32,id:u32,flag:u8,b:&mut impl Backend,calls:&mut Vec<Call>)->Result<u32,Error>{if index>=4{return Ok(31);}if !self.ensure(bus,b,calls)?{return Ok(52);}let cache=self.caches.get_mut(&bus.word(0x18)).unwrap();let o=index as usize*8;if cache.raw[o+1]==flag && cache.word(o+4)==id{return Ok(1);}cache.raw[o+4..o+8].copy_from_slice(&id.to_le_bytes());cache.raw[o+1]=flag;calls.push(Call::Changed);b.changed(bus,self.caches.get(&bus.word(0x18)).unwrap())?;calls.push(Call::Slot{index});b.slot(bus,index)?;Ok(1)}
 fn mask(&mut self,bus:&mut Bus,value:u32,mask:u32,b:&mut impl Backend,calls:&mut Vec<Call>)->Result<u32,Error>{if bus.word(0x18)==0 && value==0{return Ok(1);}if !self.ensure(bus,b,calls)?{return Ok(52);}let cache=self.caches.get_mut(&bus.word(0x18)).unwrap();cache.raw[32]=(cache.raw[32]&!(mask as u8))|((value as u8)&(mask as u8));calls.push(Call::Mask{args:[value,mask]});b.mask(bus,value,mask)?;b.apply(bus,value,mask)?;Ok(1)}
 pub fn read(&mut self,bus:&mut Bus,cursor:&mut Cursor<'_>,backend:&mut impl Backend)->Result<Read,Error>{if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}let mut calls=Vec::new();let count=cursor.u8()?;if count==0{return Ok(Read{result:1,calls});}let bypass=u32::from(cursor.u8()?);let mut result=1;for _ in 0..count{let index=u32::from(cursor.u8()?);let id=cursor.u32()?;let flag=u8::from(cursor.u8()?!=0);cursor.u8()?;if id!=0{result=self.slot(bus,index,id,flag,backend,&mut calls)?;if result!=1{break;}}}self.mask(bus,bypass,u32::MAX,backend,&mut calls)?;Ok(Read{result,calls})}
 /// Expose current raw effect IDs/flags to the verified notification consumer.
 /// This does not create normal bank bindings or lifetime ownership.
 pub fn sync_notifications(&self,bus:&Bus,out:&mut crate::audio_bus_parameter_notification::Store)->Result<(),Error>{let reference=bus.word(0x18);if reference!=0{let cache=self.caches.get(&reference).ok_or(Error::MissingEffectsCache(reference))?;out.caches.insert(reference,cache.notification());}Ok(())}
}
/// Bind verified target flag application while retaining mandatory resource
/// callbacks CC/84/DC and allocation from the caller.
pub struct TargetBackend<'a,B>{pub dependencies:&'a mut B,pub targets:&'a mut crate::audio_bus_control_application::Store,pub applied:Vec<crate::audio_bus_control_application::Call>}
impl<B:Backend> Backend for TargetBackend<'_,B>{
 fn allocate(&mut self,n:u32)->Result<Option<Allocation>,Error>{self.dependencies.allocate(n)}
 fn changed(&mut self,b:&mut Bus,c:&Cache)->Result<(),Error>{self.dependencies.changed(b,c)}
 fn slot(&mut self,b:&mut Bus,i:u32)->Result<(),Error>{self.dependencies.slot(b,i)}
 fn mask(&mut self,b:&mut Bus,v:u32,m:u32)->Result<(),Error>{self.dependencies.mask(b,v,m)}
 fn apply(&mut self,b:&Bus,v:u32,m:u32)->Result<(),Error>{let calls=if b.word(0x24)==0 && b.raw[0xc4]&0x80!=0{self.targets.root(v,m)}else{self.targets.bus(b.word(8),v,m)}.map_err(Error::Application)?;self.applied.extend(calls);Ok(())}
}
#[derive(Debug)] pub struct StageTrace{pub offset:usize,pub remaining:u32,pub calls:Vec<Call>}
pub struct BankBackend<'a,B,A>{pub dependencies:&'a mut B,pub effects:&'a mut A,pub store:&'a mut Store,pub traces:Vec<StageTrace>}
impl<B:bank::Backend,A:Backend> bank::Backend for BankBackend<'_,B,A>{
 fn lookup(&mut self,id:u32,s:u32)->Result<Option<u32>,Error>{self.dependencies.lookup(id,s)}fn retain(&mut self,n:u32)->Result<(),Error>{self.dependencies.retain(n)}fn release(&mut self,n:u32)->Result<(),Error>{self.dependencies.release(n)}fn attach(&mut self,p:u32,c:&mut Bus)->Result<u32,Error>{self.dependencies.attach(p,c)}fn allocate_control(&mut self,n:u32)->Result<Option<u32>,Error>{self.dependencies.allocate_control(n)}
 fn stage(&mut self,s:bank::Stage,b:&mut Bus,c:&mut Cursor<'_>)->Result<u32,Error>{if s!=bank::Stage::Effects{return self.dependencies.stage(s,b,c);}let offset=c.offset;let remaining=c.remaining;let out=self.store.read(b,c,self.effects)?;self.traces.push(StageTrace{offset,remaining,calls:out.calls});Ok(out.result)}
}
#[cfg(test)] pub(crate) mod tests{
 use super::*;
 pub(crate) struct Snapshot{pub reference:u32,pub failure:bool}
 impl Backend for Snapshot{fn allocate(&mut self,_:u32)->Result<Option<Allocation>,Error>{Ok(if self.failure{None}else{Some(Allocation{reference:self.reference,raw:[0xa5;36]})})}fn changed(&mut self,_:&mut Bus,_:&Cache)->Result<(),Error>{Ok(())}fn slot(&mut self,_:&mut Bus,_:u32)->Result<(),Error>{Ok(())}fn mask(&mut self,_:&mut Bus,_:u32,_:u32)->Result<(),Error>{Ok(())}fn apply(&mut self,_:&Bus,_:u32,_:u32)->Result<(),Error>{Err(Error::Backend("target application dependency absent"))}}
 #[test] fn audio_bus_effects_reader_and_cache_match720_native_cases(){let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_effects_bank_contract.json")).unwrap();assert_eq!(p["case_count"],720);for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let mut store=Store::default();if let Some(raw)=row["before_cache"].as_str(){store.caches.insert(0x30002000,Cache{raw:crate::audio_spatial_controls::tests::hex(raw)});}let raw=crate::audio_bus_properties_bank::tests::bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut dependencies=Snapshot{reference:0x30003000,failure:row["allocation_failure"].as_bool().unwrap()};let mut targets=crate::audio_bus_control_application::Store::default();let mut b=TargetBackend{dependencies:&mut dependencies,targets:&mut targets,applied:vec![]};let out=store.read(&mut bus,&mut c,&mut b).unwrap();assert!(b.applied.is_empty());assert_eq!(u64::from(out.result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(serde_json::json!(out.calls),row["calls"],"calls {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");assert_eq!(store.caches.get(&bus.word(0x18)).map(|v|v.raw.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["after_cache"].as_str().map(str::to_owned),"cache {case}");assert_eq!(c.offset as u64,row["consumed"].as_u64().unwrap());assert_eq!(u64::from(c.remaining),row["remaining"].as_u64().unwrap());let mut notifications=crate::audio_bus_parameter_notification::Store::default();store.sync_notifications(&bus,&mut notifications).unwrap();if bus.word(0x18)!=0{let a=&notifications.caches[&bus.word(0x18)];let expected=crate::audio_spatial_controls::tests::hex::<36>(row["after_cache"].as_str().unwrap());let ids=[4,12,20,28].map(|o|u32::from_le_bytes(expected[o..o+4].try_into().unwrap()));assert_eq!(a.effect_ids,ids,"native effect IDs {case}");assert_eq!(a.flags,expected[32],"native flags {case}");}}}
 #[test] fn audio_bus_effects_unknown_cache_and_short_record_fail_explicitly(){let mut b=Bus{reference:1,raw:[0;200]};b.set_word(0,0xff1380);b.set_word(0x18,2);let mut store=Store::default();let raw=[1,0,0,1,0,0,0,0,0];let mut c=Cursor{bytes:&raw,offset:0,remaining:9};let mut backend=Snapshot{reference:3,failure:false};assert_eq!(store.read(&mut b,&mut c,&mut backend).unwrap_err(),Error::MissingEffectsCache(2));let mut c=Cursor{bytes:&[1,0,0],offset:0,remaining:3};assert_eq!(store.read(&mut b,&mut c,&mut backend).unwrap_err(),Error::Truncated);}
}
