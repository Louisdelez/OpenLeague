//! Original Bus B043F0 / B225A0 property table and flag prefix.
//! Allocated padding stays caller-owned; raw values and key order are preserved.
use crate::{audio_bus_registry::Bus,audio_bus_bank::{self as bank,Cursor,Error}};
use std::collections::BTreeMap;
#[derive(Debug)] pub struct Allocation {pub reference:u32,pub bytes:Vec<u8>}
#[derive(Debug,Default)] pub struct Tables {pub values:BTreeMap<u32,Vec<u8>>}
#[derive(Debug,Clone,Copy,PartialEq,Eq)] pub enum GroupChange {Ordering,Property(u8)}
pub trait Backend {
 fn allocate(&mut self,size:usize)->Result<Option<Allocation>,Error>;
 /// Mandatory active-group implementation, called only when its mode changes.
 /// Actual group reorder/update bodies remain separately qualified dependencies.
 fn groups_changed(&mut self,bus:&mut Bus,change:GroupChange)->Result<(),Error>;
}
#[derive(Debug,Clone,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Allocate{size:usize},Copy{length:usize}}
#[derive(Debug)] pub struct Read {pub result:u32,pub calls:Vec<Call>}
fn bit(byte:&mut u8,mask:u8,value:u8){*byte=(*byte&!mask)|(value&mask);}
pub fn read(bus:&mut Bus,tables:&mut Tables,cursor:&mut Cursor<'_>,backend:&mut impl Backend)->Result<Read,Error>{
 if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}
 let mut calls=Vec::new();let count=usize::from(cursor.u8()?);
 if count!=0{
  let header=(count+4)&!3;let size=header+count*4;calls.push(Call::Allocate{size});let Some(mut allocation)=backend.allocate(size)? else{return Ok(Read{result:52,calls});};
  if allocation.reference==0 || allocation.bytes.len()<size || tables.values.contains_key(&allocation.reference){return Err(Error::InvalidAllocation);}
  let key_end=cursor.offset.checked_add(count).ok_or(Error::Truncated)?;let end=key_end.checked_add(count*4).ok_or(Error::Truncated)?;let keys=cursor.bytes.get(cursor.offset..key_end).ok_or(Error::Truncated)?;let values=cursor.bytes.get(key_end..end).ok_or(Error::Truncated)?;
  allocation.bytes[0]=count as u8;allocation.bytes[1..1+count].copy_from_slice(keys);calls.push(Call::Copy{length:count});allocation.bytes[header..size].copy_from_slice(values);calls.push(Call::Copy{length:count*4});cursor.offset=end;
  bus.set_word(0x28,allocation.reference);tables.values.insert(allocation.reference,allocation.bytes);
 }
 let a=cursor.u8()?;bit(&mut bus.raw[0x2f],4,u8::from(a!=0)<<2);let b=cursor.u8()?;bit(&mut bus.raw[0x2f],0x20,u8::from(b!=0)<<5);
 let ordering=u8::from(cursor.u8()?!=0);if bus.raw[0x2e]&1!=ordering{bit(&mut bus.raw[0x2e],1,ordering);if bus.word(0x1c)!=0{backend.groups_changed(bus,GroupChange::Ordering)?;}}
 let property=u8::from(cursor.u8()?!=0);if (bus.raw[0x2e]>>1)&1!=property{bit(&mut bus.raw[0x2e],2,property<<1);if bus.word(0x1c)!=0{backend.groups_changed(bus,GroupChange::Property(property))?;}}
 let channels=u16::from_le_bytes(cursor.read()?);bus.raw[0x2c..0x2e].copy_from_slice(&channels.to_le_bytes());let flag=cursor.u8()?;bit(&mut bus.raw[0x2e],8,flag.wrapping_shl(3));let mask=u16::from_le_bytes(cursor.read()?);bus.raw[0x2e]|=0x80;bus.set_word(0x60,u32::from(mask&0x63f));cursor.read::<2>()?;
 let flag=cursor.u8()?;bit(&mut bus.raw[0x2f],8,flag.wrapping_shl(3));let flag=cursor.u8()?;bit(&mut bus.raw[0xc4],0x10,flag.wrapping_shl(4));Ok(Read{result:1,calls})
}
#[derive(Debug)] pub struct StageTrace{pub offset:usize,pub remaining:u32,pub calls:Vec<Call>}
/// Connect only the property dependency; parents and all later bank stages remain
/// mandatory. Actual group/allocator implementations belong to the caller.
pub struct PropertiesBackend<'a,B,A>{pub dependencies:&'a mut B,pub properties:&'a mut A,pub tables:&'a mut Tables,pub traces:Vec<StageTrace>}
impl<B:bank::Backend,A:Backend> bank::Backend for PropertiesBackend<'_,B,A>{
 fn lookup(&mut self,id:u32,s:u32)->Result<Option<u32>,Error>{self.dependencies.lookup(id,s)}
 fn retain(&mut self,n:u32)->Result<(),Error>{self.dependencies.retain(n)}
 fn attach(&mut self,p:u32,c:&mut Bus)->Result<u32,Error>{self.dependencies.attach(p,c)}
 fn release(&mut self,n:u32)->Result<(),Error>{self.dependencies.release(n)}
 fn allocate_control(&mut self,size:u32)->Result<Option<u32>,Error>{self.dependencies.allocate_control(size)}
 fn stage(&mut self,s:bank::Stage,b:&mut Bus,c:&mut Cursor<'_>)->Result<u32,Error>{if s!=bank::Stage::Properties{return self.dependencies.stage(s,b,c);}let offset=c.offset;let remaining=c.remaining;let out=read(b,self.tables,c,self.properties)?;self.traces.push(StageTrace{offset,remaining,calls:out.calls});Ok(out.result)}
}
#[cfg(test)] pub(crate) mod tests{
 use super::*;
 pub(crate) struct SnapshotAllocator{pub reference:u32,pub failure:bool}
 impl Backend for SnapshotAllocator{fn allocate(&mut self,size:usize)->Result<Option<Allocation>,Error>{Ok(if self.failure{None}else{Some(Allocation{reference:self.reference,bytes:vec![0xa5;size]})})}fn groups_changed(&mut self,_:&mut Bus,_:GroupChange)->Result<(),Error>{Err(Error::Backend("active bus groups unqualified"))}}
 pub(crate) fn bytes(hex:&str)->Vec<u8>{hex.as_bytes().chunks_exact(2).map(|v|u8::from_str_radix(std::str::from_utf8(v).unwrap(),16).unwrap()).collect()}
 #[test] fn audio_bus_properties_and_flag_prefix_match2304_native_cases(){let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_properties_bank_contract.json")).unwrap();assert_eq!(p["case_count"],2304);for (case,row) in p["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let raw=bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut tables=Tables::default();let mut backend=SnapshotAllocator{reference:0x30005000,failure:row["allocation_failure"].as_bool().unwrap()};let out=read(&mut bus,&mut tables,&mut c,&mut backend).unwrap();assert_eq!(u64::from(out.result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"node {case}");assert_eq!(c.offset as u64,row["consumed"].as_u64().unwrap(),"cursor {case}");assert_eq!(u64::from(c.remaining),row["remaining"].as_u64().unwrap(),"remaining {case}");assert_eq!(serde_json::json!(out.calls),row["calls"],"trace {case}");assert_eq!(tables.values.get(&0x30005000).map(|v|v.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["allocated_bytes"].as_str().map(str::to_owned),"table {case}");}}
}
