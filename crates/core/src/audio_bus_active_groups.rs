//! Original Bus active-cache modes B009B0/B00C20 and finite priority rebuilds.
use crate::{audio_bus_registry::Bus,audio_bus_properties_bank::{self as properties,GroupChange},audio_priority_transition::Voice};
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone)] pub struct Group{pub raw:[u8;16],pub voices:Vec<u32>}
impl Group{fn word(&self,o:usize)->u32{u32::from_le_bytes(self.raw[o..o+4].try_into().unwrap())}}
#[derive(Debug,Clone)] pub struct Cache{pub raw:[u8;16],pub children:Vec<u32>}
#[derive(Debug,Default)] pub struct Store{pub caches:BTreeMap<u32,Cache>,pub groups:BTreeMap<u32,Group>,pub voices:BTreeMap<u32,Voice>}
#[derive(Debug,PartialEq,Eq)] pub enum Error{WrongClass,UnresolvedReference,MissingCache(u32),MissingGroup(u32),MissingVoice(u32),MalformedArray,InvalidPriority,InvalidOrder,AliasedGroups}
#[derive(Debug,Clone,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call{Rebuild{group:u32,ascending:bool}}
fn before(a:&Voice,b:&Voice,ascending:bool)->bool{a.value>b.value || (a.value==b.value && if ascending{a.key<b.key}else{a.key>b.key})}
impl Store{
 fn targets(&self,bus:&Bus,ordering:bool)->Result<Vec<u32>,Error>{
  if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}let reference=bus.word(0x1c);if reference==0{return Ok(vec![]);}
  let cache=self.caches.get(&reference).ok_or(Error::MissingCache(reference))?;let word=|o|u32::from_le_bytes(cache.raw[o..o+4].try_into().unwrap());if word(4) as usize!=cache.children.len() || (word(0)==0 && !cache.children.is_empty()) || word(8)<word(4){return Err(Error::MalformedArray);}
  let ids:Vec<_>=std::iter::once(reference.checked_add(16).ok_or(Error::UnresolvedReference)?).chain(cache.children.iter().copied().filter(|v|*v!=0)).collect();
  if ordering && ids.iter().copied().collect::<BTreeSet<_>>().len()!=ids.len(){return Err(Error::AliasedGroups);}
  for id in &ids{let g=self.groups.get(id).ok_or(Error::MissingGroup(*id))?;if g.word(4) as usize!=g.voices.len() || g.word(8)<g.word(4) || (g.word(0)==0 && !g.voices.is_empty()){return Err(Error::MalformedArray);}
   if ordering{let mut keys=BTreeSet::new();for id in &g.voices{let v=self.voices.get(id).ok_or(Error::MissingVoice(*id))?;if !v.value.is_finite(){return Err(Error::InvalidPriority);}if !keys.insert(v.key){return Err(Error::InvalidOrder);}}
    if g.voices.windows(2).any(|v|before(&self.voices[&v[1]],&self.voices[&v[0]],g.raw[14]!=0)){return Err(Error::InvalidOrder);}
   }
  }Ok(ids)
 }
 fn update_targets(&mut self,ids:Vec<u32>,change:GroupChange)->Vec<Call>{let mut calls=Vec::new();for id in ids{let g=self.groups.get_mut(&id).unwrap();match change{GroupChange::Property(value)=>g.raw[15]=value,GroupChange::Ordering=>{
   g.raw[14]=u8::from(g.raw[14]==0);let ascending=g.raw[14]!=0;calls.push(Call::Rebuild{group:id,ascending});
   // Native rebuild resets the count, reads the same backing array and inserts
   // each voice into its rebuilt prefix using unsigned-key tie comparisons.
   for count in 0..g.voices.len(){let reference=g.voices[count];let voice=&self.voices[&reference];let mut lo=0usize;let mut hi=count;while lo<hi{let mid=lo+(hi-lo-1)/2;if before(voice,&self.voices[&g.voices[mid]],ascending){hi=mid;}else{lo=mid+1;}}g.voices.copy_within(lo..count,lo+1);g.voices[lo]=reference;}
  }}}calls}
 /// Called after the property reader has changed the Bus mode bit.
 pub fn changed(&mut self,bus:&Bus,change:GroupChange)->Result<Vec<Call>,Error>{if matches!(change,GroupChange::Property(v) if v>1){return Err(Error::InvalidPriority);}let ids=self.targets(bus,change==GroupChange::Ordering)?;Ok(self.update_targets(ids,change))}
 /// Direct native mode entry. Unchanged mode performs no cache lookup or rebuild.
 pub fn set(&mut self,bus:&mut Bus,ordering:bool,value:bool)->Result<Vec<Call>,Error>{if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}let mask=if ordering{1}else{2};let next=u8::from(value)*mask;if bus.raw[0x2e]&mask==next{return Ok(vec![]);}let ids=self.targets(bus,ordering)?;bus.raw[0x2e]=(bus.raw[0x2e]&!mask)|next;Ok(self.update_targets(ids,if ordering{GroupChange::Ordering}else{GroupChange::Property(u8::from(value))}))}
}
/// Bind the verified active-group consumer to the property-prefix allocator.
/// Cache/voice population and physical admission/lifecycle stay caller-owned.
pub struct PropertiesBackend<'a,A>{pub allocator:&'a mut A,pub store:&'a mut Store,pub calls:Vec<Call>}
impl<A:properties::Backend> properties::Backend for PropertiesBackend<'_,A>{
 fn allocate(&mut self,size:usize)->Result<Option<properties::Allocation>,crate::audio_bus_bank::Error>{self.allocator.allocate(size)}
 fn groups_changed(&mut self,b:&mut Bus,c:GroupChange)->Result<(),crate::audio_bus_bank::Error>{let calls=self.store.changed(b,c).map_err(crate::audio_bus_bank::Error::Groups)?;self.calls.extend(calls);Ok(())}
}
#[cfg(test)] mod tests{
 use super::*;
 fn fixture(row:&serde_json::Value)->Store{let mut store=Store::default();store.caches.insert(0x30002000,Cache{raw:crate::audio_spatial_controls::tests::hex(row["before_cache"].as_str().unwrap()),children:row["children"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()});for g in row["before_groups"].as_array().unwrap(){store.groups.insert(g["reference"].as_u64().unwrap() as u32,Group{raw:crate::audio_spatial_controls::tests::hex(g["raw"].as_str().unwrap()),voices:g["voices"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()});}for v in row["voices"].as_array().unwrap(){store.voices.insert(v["reference"].as_u64().unwrap() as u32,Voice{value:v["value"].as_f64().unwrap() as f32,key:v["key"].as_u64().unwrap() as u32});}store}
 fn compare(store:&Store,row:&serde_json::Value,case:usize){for g in row["after_groups"].as_array().unwrap(){let actual=&store.groups[&(g["reference"].as_u64().unwrap() as u32)];assert_eq!(actual.raw,crate::audio_spatial_controls::tests::hex::<16>(g["raw"].as_str().unwrap()),"group bytes {case}");assert_eq!(serde_json::json!(actual.voices),g["voices"],"order {case}");}assert_eq!(store.caches[&0x30002000].raw,crate::audio_spatial_controls::tests::hex::<16>(row["after_cache"].as_str().unwrap()),"cache {case}");}
 #[test] fn audio_bus_active_group_modes_and_rebuilds_match1536_native_cases(){let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_active_groups_contract.json")).unwrap();assert_eq!(p["case_count"],1536);for(case,row) in p["cases"].as_array().unwrap().iter().enumerate(){let mut store=fixture(row);let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let calls=store.set(&mut bus,row["operation"]=="ordering",row["requested"]==1).unwrap();assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls {case}");compare(&store,row,case);}}
 #[test] fn audio_bus_property_prefix_with_active_groups_matches3072_native_cases(){use crate::audio_bus_properties_bank::{Tables,tests::{bytes,SnapshotAllocator}};use crate::audio_bus_bank::Cursor;let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_properties_active_groups_contract.json")).unwrap();assert_eq!(p["case_count"],3072);for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut store=fixture(row);let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let raw=bytes(row["payload"].as_str().unwrap());let mut c=Cursor{bytes:&raw,offset:0,remaining:raw.len() as u32};let mut tables=Tables::default();let mut allocator=SnapshotAllocator{reference:0x3000b200,failure:row["allocation_failure"].as_bool().unwrap()};let mut backend=PropertiesBackend{allocator:&mut allocator,store:&mut store,calls:vec![]};let out=properties::read(&mut bus,&mut tables,&mut c,&mut backend).unwrap();let mut calls:Vec<_>=out.calls.iter().map(|v|serde_json::json!(v)).collect();calls.extend(backend.calls.iter().map(|v|serde_json::json!(v)));drop(backend);assert_eq!(serde_json::json!(calls),row["calls"],"call order {case}");assert_eq!(u64::from(out.result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");assert_eq!(c.offset as u64,row["consumed"].as_u64().unwrap());assert_eq!(u64::from(c.remaining),row["remaining"].as_u64().unwrap());assert_eq!(tables.values.get(&0x3000b200).map(|v|v.iter().map(|b|format!("{b:02x}")).collect::<String>()),row["allocated_bytes"].as_str().map(str::to_owned),"allocated table {case}");compare(&store,row,case);}}
 #[test] fn audio_bus_missing_active_cache_rejects_changed_mode_before_mutation(){let mut b=Bus{reference:1,raw:[0;200]};b.set_word(0,0xff1380);b.set_word(0x1c,123);let mut s=Store::default();assert!(s.set(&mut b,true,false).unwrap().is_empty());assert!(matches!(s.set(&mut b,true,true),Err(Error::MissingCache(123))));assert_eq!(b.raw[0x2e],0);}
}
