//! Native AEC160 voice destructor and AEAF40 secondary-reference release.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub struct Runtime{pub pool:u32,pub references:BTreeMap<u32,Memory>,pub retired:BTreeSet<u32>}
pub trait Services{fn free(&mut self,pool:u32,reference:u32)->Result<(),Error>;fn operator_delete(&mut self,voice:&Memory)->Result<(),Error>;}
impl Runtime{
 pub fn release(&mut self,reference:u32,services:&mut impl Services)->Result<(),Error>{
 if self.retired.contains(&reference){return Err(Error::UnresolvedReference);}let m=self.references.get_mut(&reference).filter(|m|m.raw.len()>=8).ok_or(Error::UnresolvedReference)?;let count=word(&m.raw,0).wrapping_sub(1);set(&mut m.raw,0,count);if count!=0{return Ok(());}let entries=word(&m.raw,4)as usize;
 let required=entries.checked_mul(24).and_then(|n|n.checked_add(16)).ok_or(Error::Truncated)?;if entries!=0&&required>m.raw.len(){return Err(Error::Truncated);}
 for i in 0..entries{let item=word(&m.raw,16+i*24);if item!=0{services.free(self.pool,item)?;}}
 services.free(self.pool,reference)?;self.retired.insert(reference);Ok(())
 }
 pub fn destroy(&mut self,voice:&mut Memory,argument:u32,services:&mut impl Services)->Result<u32,Error>{
 if voice.reference==0||voice.raw.len()<350{return Err(Error::InvalidAllocation);}set(&mut voice.raw,0,0xff0cdc);set(&mut voice.raw,8,0xff0d20);
 let allocation=word(&voice.raw,344);if allocation!=0{services.free(self.pool,allocation)?;set(&mut voice.raw,344,0);voice.raw[348..350].copy_from_slice(&0u16.to_le_bytes());}
 let reference=word(&voice.raw,68);if reference!=0{self.release(reference,services)?;}
 set(&mut voice.raw,0,0xfeff50);if argument&1!=0{services.operator_delete(voice)?;}Ok(voice.reference)
 }
}
