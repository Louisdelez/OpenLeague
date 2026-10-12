//! Native8C7430/585B50 history and8C7280/72A660 finite curve initialization/disposal.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::{Backend,Deallocator};
use crate::audio_announcer_owner_metadata::Error;
fn add(a:u32,b:u32)->Result<u32,Error>{a.checked_add(b).ok_or(Error::AddressOverflow)}
fn write<B:Storage>(b:&mut B,a:u32,v:u32)->Result<(),Error>{Storage::write_word(b,a,v)?;Ok(())}
fn vector<B:Storage>(b:&mut B,base:u32,bytes:u32,used:bool)->Result<u32,Error>{
 let p=b.allocate(bytes)?;if p==0{return Err(Error::Boundary("native service vector allocation failed"));}
 write(b,base,p)?;write(b,add(base,4)?,if used{add(p,bytes)?}else{p})?;write(b,add(base,8)?,add(p,bytes)?)?;Ok(p)
}
pub fn construct_history<B:Storage>(b:&mut B,object:u32,mode:u32)->Result<u32,Error>{
 for offset in (0..24).step_by(4){write(b,add(object,offset)?,0)?;}write(b,add(object,24)?,mode)?;
 if mode!=u32::MAX{vector(b,object,60*4,false)?;vector(b,add(object,12)?,3600*16,false)?;}Ok(object)
}
/// Native finite-control profile. Nonfinite controls remain explicitly unqualified.
pub fn construct_curve<B:Storage>(b:&mut B,object:u32,controls:u32)->Result<u32,Error>{
 for i in 0..8{if !f32::from_bits(b.word(add(controls,i*4)?)?).is_finite(){return Err(Error::Boundary("nonfinite native curve controls unqualified"));}}
 for offset in (0..36).step_by(4){write(b,add(object,offset)?,0)?;}
 let table=vector(b,add(object,12)?,801*4,true)?;
 let first=b.word(controls)?;write(b,add(object,36)?,first)?;let last=b.word(add(controls,28)?)?;write(b,add(object,40)?,last)?;
 for index in 0..801u32{
  let x=index as f32+f32::from_bits(b.word(add(object,36)?)?);let mut bin=u32::MAX;
  for candidate in (0..8u32).rev(){if x>=f32::from_bits(b.word(add(controls,candidate*4)?)?){bin=candidate;break;}}
  write(b,add(table,index*4)?,bin)?;
 }
 let values=vector(b,add(object,24)?,8*4,true)?;for i in 0..8{let value=b.word(add(controls,i*4)?)?;write(b,add(values,i*4)?,value)?;}
 let histogram=vector(b,object,8*4,true)?;for i in 0..8{write(b,add(histogram,i*4)?,0)?;}Ok(object)
}
fn dispose_vectors<B:Storage+Backend>(b:&mut B,object:u32,offsets:&[u32])->Result<(),Error>{
 let mut route=b.deallocator()?;
 for (index,&offset) in offsets.iter().enumerate(){let base=add(object,offset)?;let p=b.word(base)?;
  if p!=0{b.free(p,route)?;if index+1<offsets.len() && matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}for i in [0,4,8]{write(b,add(base,i)?,0)?;}}
 }Ok(())
}
pub fn destroy_history<B:Storage+Backend>(b:&mut B,object:u32)->Result<(),Error>{dispose_vectors(b,object,&[12,0])}
pub fn destroy_curve<B:Storage+Backend>(b:&mut B,object:u32)->Result<(),Error>{dispose_vectors(b,object,&[24,12,0])}
#[cfg(test)] mod tests{
 use super::*;use crate::audio_announcer_registry_init::OwnedMemory;use crate::audio_announcer_object_lookup::Memory;
 fn state(b:&mut OwnedMemory,s:&serde_json::Value){
  let allocations:Vec<_>=b.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),s["allocations"]);assert_eq!(serde_json::json!(b.released_labels),s["freed"]);
  for w in s["words"].as_array().unwrap(){assert_eq!(b.word(w[0].as_u64().unwrap()as u32).unwrap(),w[1].as_u64().unwrap()as u32,"{w}");}b.allocations.clear();b.released_labels.clear();
 }
 fn check(kind:&str){
  let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_game_service_history_curve_initialization_contract.json")).unwrap();let rows:Vec<_>=p["cases"].as_array().unwrap().iter().filter(|c|c["kind"]==kind).collect();assert_eq!(rows.len(),8);
  for c in rows{let mut b=OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap()as u8);let object=0x30009000;b.reserve_at(object,if kind=="history"{28}else{44}).unwrap();
   let result=if kind=="history"{construct_history(&mut b,object,c["mode"].as_u64().unwrap()as u32).unwrap()}else{
    let input=0x3000a100;b.reserve_at(input,32).unwrap();let hex=c["controls_hex"].as_str().unwrap();for i in 0..32{b.write_byte(input+i as u32,u8::from_str_radix(&hex[i*2..i*2+2],16).unwrap()).unwrap();}construct_curve(&mut b,object,input).unwrap()
   };assert_eq!(result,c["returned"].as_u64().unwrap()as u32);state(&mut b,&c["constructed"]);
   if kind=="history"{destroy_history(&mut b,object).unwrap();}else{destroy_curve(&mut b,object).unwrap();}state(&mut b,&c["destroyed"]);
  }
 }
 #[test]fn audio_service_history_initialization_and_disposal_match8_native_lifetimes(){check("history");}
 #[test]fn audio_service_curve_initialization_and_disposal_match8_native_lifetimes801_bins_each(){check("curve");}
}
