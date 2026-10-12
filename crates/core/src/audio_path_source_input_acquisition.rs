//! Original AFF730 Source input98 with AFEA80/AFDCF0 owner construction,
//! AFFE50/B00800 parent child-table publication and AFF610 growth.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services:crate::audio_path_voice_empty_source_release::Services{
 fn allocate_input(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
 /// Required B11040 retained-x87 result / towards-zero FISTP / low16 conversion.
 fn dynamic_owner_type(&mut self,source:u32,parameter:u32,zero:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u16,Error>;
 fn parent_virtual98(&mut self,parent:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn observe_parent_input98(&mut self,_parent:u32,_selector:u32,_m:&BTreeMap<u32,Memory>){}
}
fn allocate(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,pool:u32,size:u32,s:&mut impl Services)->Result<u32,Error>{let r=s.allocate_input(pool,size,m,d)?.unwrap_or(0);if r!=0{live(m,d,r,size as usize)?;}Ok(r)}
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{live(m,d,r,1)?;s.free(pool,r,m)?;d.insert(r);Ok(())}
fn grow(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,pool:u32,s:&mut impl Services)->Result<bool,Error>{
 let header=owner.wrapping_add(36);let capacity=get(m,d,header.wrapping_add(8),4)?.wrapping_add(1);let new=allocate(m,d,pool,capacity.wrapping_mul(4),s)?;if new==0{return Ok(false);}let old=get(m,d,header,4)?;let count=get(m,d,header.wrapping_add(4),4)?;
 if old!=0{for i in 0..count{let current=get(m,d,header,4)?;let value=get(m,d,current.wrapping_add(i.wrapping_mul(4)),4)?;put(m,d,new.wrapping_add(i.wrapping_mul(4)),4,value)?;}let current=get(m,d,header,4)?;free(m,d,pool,current,s)?;}
 put(m,d,header,4,new)?;put(m,d,header.wrapping_add(8),4,capacity)?;Ok(true)
}
fn construct(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,owner:u32,ty:u32,flags:u32)->Result<(),Error>{
 for off in[0,4,8,12,16,20,24]{put(m,d,owner.wrapping_add(off),4,0)?;}
 put(m,d,owner.wrapping_add(28),2,ty)?;put(m,d,owner.wrapping_add(30),1,flags&1)?;put(m,d,owner.wrapping_add(31),1,(flags>>1)&1)?;
 for off in[36,40,44,48,52]{put(m,d,owner.wrapping_add(off),4,0)?;}
 let current=get(m,d,owner.wrapping_add(56),1)?;put(m,d,owner.wrapping_add(56),1,(current&!1)|((flags>>4)&1))
}
/// Original B00800 ignores ensure_owner's return and rereads published owner28.
pub fn attach_parent(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,parent:u32,source:u32,pool:u32,s:&mut impl Services)->Result<u8,Error>{
 ensure_owner(m,d,parent,pool,s)?;let owner=get(m,d,parent.wrapping_add(28),4)?;if owner==0{return Ok(0);}let saved=get(m,d,owner.wrapping_add(40),4)?;if saved>=get(m,d,owner.wrapping_add(44),4)?{if !grow(m,d,owner,pool,s)?||saved>=get(m,d,owner.wrapping_add(44),4)?{return Ok(0);}}
 let count=get(m,d,owner.wrapping_add(40),4)?;let table=get(m,d,owner.wrapping_add(36),4)?;let at=table.wrapping_add(count.wrapping_mul(4));put(m,d,owner.wrapping_add(40),4,count.wrapping_add(1))?;if at==0{return Ok(0);}put(m,d,at,4,source)?;Ok(1)
}
fn initialize_source(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,pool:u32,s:&mut impl Services)->Result<u8,Error>{
 let vt=get(m,d,source,4)?;if vt!=0xff1cd8&&vt!=0xff10f0{return Err(Error::Backend("source138 class is unqualified"));}
 let mut result=1u8;for off in[32,36]{let parent=get(m,d,source.wrapping_add(off),4)?;if parent!=0{result&=attach_parent(m,d,parent,source,pool,s)?;}}
 let wrapper=get(m,d,source.wrapping_add(56),4)?;if wrapper!=0{let parent=get(m,d,wrapper,4)?;if parent!=0{result&=attach_parent(m,d,parent,source,pool,s)?;}}Ok(result)
}
/// Owner60 preserves word32, high flag56 and bytes57..59 exactly.
pub fn ensure_owner(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,pool:u32,s:&mut impl Services)->Result<u8,Error>{
 if get(m,d,source.wrapping_add(28),4)?!=0{return Ok(1);}let owner=allocate(m,d,pool,60,s)?;
 if owner!=0{let flags=get(m,d,source.wrapping_add(46),1)?;let mut ty=get(m,d,source.wrapping_add(44),2)?;if get(m,d,source.wrapping_add(48),4)?&0x200!=0&&ty!=0{ty=u32::from(s.dynamic_owner_type(source,9,0,m,d)?);}construct(m,d,owner,ty,flags)?;}
 put(m,d,source.wrapping_add(28),4,owner)?;if owner==0{Ok(0)}else{initialize_source(m,d,source,pool,s)}
}
fn parent(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,s:&mut impl Services,recursive:bool,active:&mut BTreeSet<u32>)->Result<u8,Error>{
 if recursive{s.observe_parent_input98(source,selector,m);acquire_impl(m,d,source,selector,pool,s,true,active)}else{Ok(s.parent_virtual98(source,selector,m,d)?as u8)}
}
/// Return is bitwise AL conjunction, not short-circuited boolean logic.
pub fn acquire(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,s:&mut impl Services)->Result<u8,Error>{acquire_impl(m,d,source,selector,pool,s,false,&mut BTreeSet::new())}
pub fn acquire_recursive(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,s:&mut impl Services)->Result<u8,Error>{acquire_impl(m,d,source,selector,pool,s,true,&mut BTreeSet::new())}
fn acquire_impl(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,mut selector:u32,pool:u32,s:&mut impl Services,recursive:bool,active:&mut BTreeSet<u32>)->Result<u8,Error>{
 let vt=get(m,d,source,4)?;if vt!=0xff1cd8&&vt!=0xff10f0{return Err(Error::Backend("source98 class is unqualified"));}if recursive&&!active.insert(source){return Err(Error::CyclicList);}let result=(||{
 let mut result=ensure_owner(m,d,source,pool,s)?;let owner=get(m,d,source.wrapping_add(28),4)?;if owner!=0{let counter=get(m,d,owner.wrapping_add(50),2)?.wrapping_add(1);put(m,d,owner.wrapping_add(50),2,counter)?;}
 if selector&1!=0{let secondary=get(m,d,source.wrapping_add(36),4)?;if secondary!=0{selector&=0xfffe;result&=parent(m,d,secondary,3,pool,s,recursive,active)?;}}
 if selector&2!=0{let wrapper=get(m,d,source.wrapping_add(56),4)?;if wrapper!=0{let secondary=get(m,d,wrapper,4)?;if secondary!=0{selector&=0xfffd;result&=parent(m,d,secondary,3,pool,s,recursive,active)?;}}}
 let primary=get(m,d,source.wrapping_add(32),4)?;if primary!=0{result&=parent(m,d,primary,selector,pool,s,recursive,active)?;}Ok(result)
 })();if recursive{active.remove(&source);}result
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32,usize);7]=[("source",0x40001000,120),("owner",0x40002000,60),("new_owner",0x40003000,60),("parents",0x40004000,360),("parent_owners",0x40006000,180),("parent_tables",0x40007000,48),("wrapper",0x40008000,4)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>,failure:bool,returns:[u32;3]}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("capacity4 excludes growth/free in this matrix"))}}
 impl Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!(size,60);let result=if self.failure{0}else{0x40003000};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("RTPC selector excluded from static matrix"))}
 fn parent_virtual98(&mut self,r:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let i=((r-0x40004000)/120)as usize;let result=self.returns[i];self.calls.push(json!({"kind":"parent_virtual98","receiver":r,"selector":selector,"result":result,"at_call":snapshot(m)}));Ok(result)}
 }
 #[test]fn audio_path_source_input98_matches9216_native_owner60_constructor_source138_parent_attachment_counter_wrap_selector_upper_bits_bitwise_low_byte_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_input98_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],9216);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"parents"=>120,"parent_owners"=>60,"parent_tables"=>16,_=>z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}let mut d=BTreeSet::new();let returns=match row["parent_return_kind"].as_str().unwrap(){"true"=>[1,1,1],"mixed"=>[1,0,1],"upper"=>[256,2,255],_=>unreachable!()};let mut s=Backend{calls:vec![],failure:row["owner_kind"]=="oom",returns};assert_eq!(acquire(&mut m,&mut d,0x40001000,row["selector"].as_u64().unwrap()as u32,19,&mut s).unwrap(),row["result_low_byte"].as_u64().unwrap()as u8,"native AL {i}");assert_eq!(json!(s.calls),row["calls"],"all allocation/parent callback snapshots {i}");assert_eq!(snapshot(&m),row["after"],"all source/new owner/parent tables and counter bytes {i}");assert!(d.is_empty());}
 }
}

#[cfg(test)]mod recursive_tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32,usize);6]=[("sources",0x40001000,480),("wrappers",0x40005000,16),("old_owners",0x40006000,256),("new_owners",0x40007000,256),("old_tables",0x40008000,128),("new_tables",0x4000a000,1024)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>,failure:String,owner_index:u32,table_index:u32}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}}
 impl Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let fail=self.failure=="owner"&&size==60||self.failure=="table"&&size!=60;let result=if fail{0}else if size==60{let r=0x40007000+self.owner_index*64;self.owner_index+=1;r}else{assert!(matches!(size,4|8|12|16));let r=0x4000a000+self.table_index*32;self.table_index+=1;r};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":snapshot(m)}));if result!=0&&size!=60{let raw=m.remove(&result).unwrap().raw;assert_eq!(raw.len(),32);m.insert(result,Memory{reference:result,raw:raw[..size as usize].to_vec()});m.insert(result+size,Memory{reference:result+size,raw:raw[size as usize..].to_vec()});}Ok((result!=0).then_some(result))}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("static selector matrix excludes RTPC"))}
 fn parent_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("recursive acquisition executes actual parent bodies"))}
 fn observe_parent_input98(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"parent_input98","receiver":r,"selector":selector,"at_call":snapshot(m)}));}
 }
 #[test]fn audio_path_source_input98_matches648_native_recursive_four_source_chains_shared_duplicate_parent_real_owner60_creation_capacity_plus1_growth_copy_free_before_publish_oom_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_input98_recursive_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],648);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"sources"=>120,"old_owners"|"new_owners"=>64,"old_tables"|"new_tables"=>32,_=>z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;if n=="old_owners"||n=="new_owners"{m.insert(reference,Memory{reference,raw:part[..60].to_vec()});m.insert(reference+60,Memory{reference:reference+60,raw:part[60..].to_vec()});}else{m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],failure:row["failure"].as_str().unwrap().to_owned(),owner_index:0,table_index:0};assert_eq!(acquire_recursive(&mut m,&mut d,0x40001000,row["selector"].as_u64().unwrap()as u32,19,&mut s).unwrap(),row["result_low_byte"].as_u64().unwrap()as u8,"native recursive AL {i}");assert_eq!(json!(s.calls),row["calls"],"each actual allocation/parent call/free snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all source/owner/table/physical padding bytes {i}");let mut expected:Vec<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();expected.sort();assert_eq!(d.iter().copied().collect::<Vec<_>>(),expected,"exact retired table allocations {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}}
 }
}
