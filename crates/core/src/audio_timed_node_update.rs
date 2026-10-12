//! Actual B1BD10 timed XYZ binding updates, composed with owned B14140 nodes.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_frame_node_update as nodes};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn float(raw:&[u8],o:usize)->f32{f32::from_bits(word(raw,o))}
fn owned(map:&BTreeMap<u32,Memory>,reference:u32,size:usize)->Result<&Memory,Error>{let m=map.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||m.reference!=reference||m.raw.len()<size{return Err(Error::InvalidAllocation);}Ok(m)}
// Fixed unsigned binary accumulator in units2^-149. Every finite f32 and its
// unsigned32-bit frame product fits310bits. Products fit the x87 mantissa exactly;
// rounding the sum to64bits before24bits preserves native double-rounding.
#[derive(Clone,Copy,PartialEq,Eq,PartialOrd,Ord)]struct Bits([u64;5]);
impl Bits{
 fn term(bits:u32,factor:u32)->Self{let exp=((bits>>23)&255)as usize;let mant=(bits&0x7fffff)|if exp==0{0}else{0x800000};let value=mant as u64*factor as u64;let shift=if exp==0{0}else{exp-1};let mut out=Self([0;5]);let limb=shift/64;let offset=shift%64;out.0[4-limb]|=value<<offset;if offset!=0&&limb+1<5{out.0[4-limb-1]|=value>>(64-offset);}out}
 fn bit(&self,n:usize)->bool{self.0[4-n/64]&(1u64<<(n%64))!=0}
 fn top(&self)->Option<usize>{for(i,v)in self.0.iter().enumerate(){if *v!=0{return Some((4-i)*64+63-v.leading_zeros()as usize);}}None}
 fn add(self,other:Self)->Self{let mut out=Self([0;5]);let mut carry=false;for i in(0..5).rev(){let(v,c)=self.0[i].overflowing_add(other.0[i]);let(v,d)=v.overflowing_add(u64::from(carry));out.0[i]=v;carry=c||d;}out}
 fn sub(self,other:Self)->Self{let mut out=Self([0;5]);let mut borrow=false;for i in(0..5).rev(){let(v,c)=self.0[i].overflowing_sub(other.0[i]);let(v,d)=v.overflowing_sub(u64::from(borrow));out.0[i]=v;borrow=c||d;}out}
 fn round(mut self,precision:usize)->Self{let Some(top)=self.top()else{return self;};let discard=(top+1).saturating_sub(precision);if discard==0{return self;}let up=self.bit(discard-1)&&((0..discard-1).any(|i|self.bit(i))||self.bit(discard));for i in 0..discard{self.0[4-i/64]&=!(1u64<<(i%64));}if up{let mut unit=Self([0;5]);unit.0[4-discard/64]=1u64<<(discard%64);self=self.add(unit);}self}
 fn rounded_float(self)->f32{let value=self.round(64).round(24);let Some(top)=value.top()else{return 0.;};if top<23{return f32::from_bits(value.0[4]as u32);}let shift=top-23;let mut mant=0u32;for i in 0..24{if value.bit(shift+i){mant|=1<<i;}}f32::from_bits(((top as u32-22)<<23)|(mant&0x7fffff))}
}
fn progress(frame:u32,scale:f32,bias:f32)->f32{
 if !scale.is_finite()||!bias.is_finite(){let p=frame as f64*scale as f64+bias as f64;return if p.is_nan()||p>=1.{1.}else{0.};}
 let a=Bits::term(scale.to_bits(),frame);let b=Bits::term(bias.to_bits(),1);let sa=scale.is_sign_negative();let sb=bias.is_sign_negative();let(value,negative)=if sa==sb{(a.add(b),sa)}else if a>=b{(a.sub(b),sa)}else{(b.sub(a),sb)};
 if negative{return 0.;}if value>=Bits::term(1f32.to_bits(),1){1.}else{value.rounded_float()}
}
#[derive(Default)]pub struct Runtime{pub tables:BTreeMap<u32,Memory>,pub links:BTreeMap<u32,Memory>,pub targets:BTreeMap<u32,Memory>}
pub trait Services{
 fn finish_node(&mut self,nodes:&mut nodes::Runtime,bindings:&mut Runtime,reference:u32)->Result<(),Error>;
 fn observe_node_update(&mut self,_reference:u32,_frame:u32){}
}
impl Runtime{
 pub fn update(&mut self,nodes:&mut nodes::Runtime,reference:u32,frame:u32,services:&mut impl Services)->Result<(),Error>{
  services.observe_node_update(reference,frame);let n=owned(&nodes.nodes,reference,96)?;let p=progress(frame,float(&n.raw,60),float(&n.raw,64));let mut xyz=[0u32;3];for(i,bits)in xyz.iter_mut().enumerate(){let product=float(&n.raw,84+i*4)*p;*bits=(product+float(&n.raw,72+i*4)).to_bits();}let base=word(&n.raw,32);let count=word(&n.raw,36)as usize;
  if count!=0{let table=owned(&self.tables,base,count.checked_mul(4).ok_or(Error::InvalidAllocation)?)?;let refs:Vec<u32>=(0..count).map(|i|word(&table.raw,i*4)).collect();for link in refs{let link=owned(&self.links,link,52)?;let target=word(&link.raw,48);let memory=owned(&self.targets,target,60)?;if memory.raw[56]&4==0{let memory=self.targets.get_mut(&target).unwrap();for(i,bits)in xyz.iter().enumerate(){memory.raw[20+i*4..24+i*4].copy_from_slice(&bits.to_le_bytes());}}}}
  let n=owned(&nodes.nodes,reference,96)?;if frame>=word(&n.raw,52){services.finish_node(nodes,self,reference)?;}Ok(())
 }
}
pub struct Backend<'a,S>{pub bindings:&'a mut Runtime,pub backend:&'a mut S}
impl<S:Services> nodes::Services for Backend<'_,S>{fn update_node(&mut self,nodes:&mut nodes::Runtime,reference:u32,frame:u32)->Result<(),Error>{self.bindings.update(nodes,reference,frame,self.backend)}}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn map(v:&Value)->BTreeMap<u32,Memory>{v.as_array().unwrap().iter().map(|e|{let reference=e["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(e["raw"].as_str().unwrap())})}).collect()}
 fn snapshot(map:&BTreeMap<u32,Memory>)->Vec<Value>{map.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect()}
 struct Finish{calls:Vec<Value>}
 impl Services for Finish{fn finish_node(&mut self,_:&mut nodes::Runtime,_:&mut Runtime,reference:u32)->Result<(),Error>{self.calls.push(json!({"kind":"finish_node","reference":reference}));Ok(())}}
 #[test]fn audio_timed_node_update_matches2160_native_unsigned_progress_xyz_gate_and_end_sequences(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_timed_node_update_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],2160);for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut nodes=nodes::Runtime{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())})])};let mut bindings=Runtime{tables:BTreeMap::from([(0x40007000,Memory{reference:0x40007000,raw:bytes(b["table"].as_str().unwrap())})]),links:map(&b["links"]),targets:map(&b["targets"])};let mut backend=Finish{calls:vec![]};bindings.update(&mut nodes,0x40006000,row["frame"].as_u64().unwrap()as u32,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"finish calls {i}");assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"table":hex(&bindings.tables[&0x40007000].raw),"links":snapshot(&bindings.links),"targets":snapshot(&bindings.targets)}),row["after"],"all raw node/binding bytes {i}");}}
}
