//! Actual B1B680 trajectory segment advancement; B1B510 restart stays mandatory.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_frame_node_update as nodes,audio_random::NativeRandom};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn owned(map:&BTreeMap<u32,Memory>,reference:u32,size:usize)->Result<&Memory,Error>{let m=map.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||m.reference!=reference||m.raw.len()<size{return Err(Error::InvalidAllocation);}Ok(m)}
// Exact nearest-even f32 of a ratio of unsigned32-bit integers. For this input
// range qualification currently covers the recorded native input profiles; broad
// x87 reciprocal/product midpoint behavior remains an explicit qualification task.
pub(crate) fn ratio(n:u32,d:u32)->Result<f32,Error>{if d==0{return Err(Error::Backend("zero segment duration requires native arithmetic qualification"));}if n==0{return Ok(0.);}let mut exponent=(31-n.leading_zeros())as i32-(31-d.leading_zeros())as i32;let below=if exponent>=0{(n as u128)<((d as u128)<<exponent)}else{((n as u128)<<(-exponent))<(d as u128)};if below{exponent-=1;}let shift=23-exponent;let(a,b)=if shift>=0{((n as u128)<<shift,d as u128)}else{(n as u128,(d as u128)<<(-shift))};let mut mant=a/b;let remainder=a%b;if remainder*2>b||(remainder*2==b&&mant&1!=0){mant+=1;}if mant==1<<24{mant>>=1;exponent+=1;}Ok(f32::from_bits((((exponent+127)as u32)<<23)|(mant as u32&0x7fffff)))}
pub struct Runtime{pub descriptors:BTreeMap<u32,Memory>,pub points:BTreeMap<u32,Memory>,pub random:NativeRandom,pub interval:u32}
pub trait Services{
 fn restart_path(&mut self,nodes:&mut nodes::Runtime,paths:&mut Runtime,reference:u32)->Result<u32,Error>;
 fn observe_random(&mut self,_value:u16){}
 fn observe_node_update(&mut self,_reference:u32,_frame:u32){}
 fn observe_segment_advance(&mut self,_reference:u32){}
}
impl Runtime{
 fn node_word(&self,nodes:&nodes::Runtime,reference:u32,offset:usize)->Result<u32,Error>{Ok(word(&owned(&nodes.nodes,reference,96)?.raw,offset))}
 fn index(&self,nodes:&nodes::Runtime,reference:u32)->Result<u16,Error>{let n=owned(&nodes.nodes,reference,96)?;Ok(u16::from_le_bytes(n.raw[20..22].try_into().unwrap()))}
 fn descriptor(&self,nodes:&nodes::Runtime,reference:u32)->Result<&[u8],Error>{crate::audio_path_memory::read(&self.descriptors,self.node_word(nodes,reference,12)?,16)}
 fn point(&self,nodes:&nodes::Runtime,reference:u32)->Result<[u32;4],Error>{let d=self.descriptor(nodes,reference)?;let offset=self.index(nodes,reference)?as usize*16;let p=crate::audio_path_memory::read(&self.points,word(d,0),offset+16)?;Ok(std::array::from_fn(|i|word(p,offset+i*4)))}
 fn jitter(&mut self,amplitude:f32,services:&mut impl Services)->f32{let value=self.random.draw();services.observe_random(value);let normalized=value as f32*f32::from_bits(0x38800200);let centered=normalized-1.;centered*amplitude}
 pub fn advance(&mut self,nodes:&mut nodes::Runtime,reference:u32,services:&mut impl Services)->Result<(),Error>{
  let count=word(self.descriptor(nodes,reference)?,4)as i32;let index=self.index(nodes,reference)?;
  if (index as i32)<count{let point=self.point(nodes,reference)?;let n=nodes.nodes.get_mut(&reference).unwrap();n.raw[20..22].copy_from_slice(&index.wrapping_add(1).to_le_bytes());for(i,bits)in point[..3].iter().enumerate(){set(&mut n.raw,72+i*4,*bits);}
   let amp=f32::from_bits(word(self.descriptor(nodes,reference)?,8));let jitter=self.jitter(amp,services);let n=nodes.nodes.get_mut(&reference).unwrap();let value=f32::from_bits(word(&n.raw,72))+jitter;set(&mut n.raw,72,value.to_bits());let amp=f32::from_bits(word(self.descriptor(nodes,reference)?,12));let jitter=self.jitter(amp,services);let n=nodes.nodes.get_mut(&reference).unwrap();let value=f32::from_bits(word(&n.raw,80))+jitter;set(&mut n.raw,80,value.to_bits());
   let numerator=point[3].wrapping_sub(1).wrapping_add(self.interval)as i32;let quotient=numerator.checked_div(self.interval as i32).ok_or(Error::Backend("native segment IDIV fault"))?;let duration=if quotient==0{1}else{quotient as u32};set(&mut nodes.nodes.get_mut(&reference).unwrap().raw,56,duration);
  }
  let count=word(self.descriptor(nodes,reference)?,4)as i32;if self.index(nodes,reference)?as i32>=count&&services.restart_path(nodes,self,reference)?!=1{set(&mut nodes.nodes.get_mut(&reference).unwrap().raw,0,0);return Ok(());}
  let point=self.point(nodes,reference)?;let amp=f32::from_bits(word(self.descriptor(nodes,reference)?,8));let x=self.jitter(amp,services)+f32::from_bits(point[0]);let amp=f32::from_bits(word(self.descriptor(nodes,reference)?,12));let z=self.jitter(amp,services)+f32::from_bits(point[2]);let n=nodes.nodes.get_mut(&reference).unwrap();let delta=[x-f32::from_bits(word(&n.raw,72)),f32::from_bits(point[1])-f32::from_bits(word(&n.raw,76)),z-f32::from_bits(word(&n.raw,80))];let start=word(&n.raw,52);let duration=word(&n.raw,56);set(&mut n.raw,48,start);set(&mut n.raw,52,start.wrapping_add(duration));for(i,value)in delta.iter().enumerate(){set(&mut n.raw,84+i*4,value.to_bits());}set(&mut n.raw,60,ratio(1,duration)?.to_bits());set(&mut n.raw,64,ratio(start,duration)?.to_bits()|0x80000000);Ok(())
 }
}
pub struct Backend<'a,S>{pub paths:&'a mut Runtime,pub backend:&'a mut S}
impl<S:Services> crate::audio_timed_node_update::Services for Backend<'_,S>{
 fn finish_node(&mut self,nodes:&mut nodes::Runtime,_:&mut crate::audio_timed_node_update::Runtime,reference:u32)->Result<(),Error>{self.backend.observe_segment_advance(reference);self.paths.advance(nodes,reference,self.backend)}
 fn observe_node_update(&mut self,reference:u32,frame:u32){self.backend.observe_node_update(reference,frame);}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{restart:bool,calls:Vec<Value>}
 impl Services for Backend{fn restart_path(&mut self,nodes:&mut nodes::Runtime,_:&mut Runtime,reference:u32)->Result<u32,Error>{let n=nodes.nodes.get_mut(&reference).unwrap();let index=u16::from_le_bytes(n.raw[20..22].try_into().unwrap());if self.restart{n.raw[20..22].fill(0);}let status=if self.restart{1}else{52};self.calls.push(json!({"kind":"restart_path","reference":reference,"index_before":index,"status":status}));Ok(status)}fn observe_random(&mut self,value:u16){self.calls.push(json!({"kind":"rand","value":value}));}}
 #[test]fn audio_timed_node_segment_matches2592_native_points_jitter_cursor_signed_duration_restart_and_wrapping_sequences(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_timed_node_segment_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],2592);assert_eq!(proof["random_scale_bits"],0x38800200u32);for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut nodes=nodes::Runtime{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())})])};let mut paths=Runtime{descriptors:BTreeMap::from([(0x40007000,Memory{reference:0x40007000,raw:bytes(b["descriptor"].as_str().unwrap())})]),points:BTreeMap::from([(0x40008000,Memory{reference:0x40008000,raw:bytes(b["points"].as_str().unwrap())})]),random:NativeRandom::seeded(b["rng_state"].as_u64().unwrap()as u32),interval:row["interval"].as_u64().unwrap()as u32};let mut backend=Backend{restart:row["restart"]==1,calls:vec![]};paths.advance(&mut nodes,0x40006000,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"ordered draws/restart {i}");assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"descriptor":hex(&paths.descriptors[&0x40007000].raw),"points":hex(&paths.points[&0x40008000].raw),"rng_state":paths.random.state()}),row["after"],"all path state {i}");}}
}
