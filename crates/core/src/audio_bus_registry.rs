//! Verified FF1380 Bus B03530 initialization and AFE420/AF6430 registration.
//! Reference tokens preserve native links; this does not allocate or load a bank.
#[derive(Debug,Clone)] pub struct Bus {pub reference:u32,pub raw:[u8;200]}
impl Bus {
 pub fn word(&self,o:usize)->u32{u32::from_le_bytes(self.raw[o..o+4].try_into().unwrap())}
 pub fn set_word(&mut self,o:usize,v:u32){self.raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
}
#[derive(Debug,Clone)] pub struct Registry {pub heads:[u32;193],pub count:u32}
impl Default for Registry{fn default()->Self{Self{heads:[0;193],count:0}}}
#[derive(Debug,Default)] pub struct Registries {pub banks:[Registry;2]}
#[derive(Debug,PartialEq,Eq)] pub enum Error {UnresolvedReference,WrongClass}
/// Mandatory native synchronization interface; implementation owns lock policy.
/// Native lock/unlock calls are void. Exclusive store access alone does not claim
/// that runtime synchronization and resource lifetime are integrated.
pub trait Synchronization {fn lock(&mut self,selector:u8);fn unlock(&mut self,selector:u8);}
pub fn initialize(bus:&mut Bus,store:&mut Registries,sync:&mut impl Synchronization)->Result<(),Error>{
 if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}
 // Verified Bus virtual38=574170 returns0, selecting flagbit1 and registry1.
 bus.raw[0x2f]|=2;let selector=(bus.raw[0x2f]>>1)&1;
 sync.lock(selector);let registry=&mut store.banks[usize::from(selector)];let bucket=(bus.word(8)%193) as usize;
 bus.set_word(4,registry.heads[bucket]);registry.heads[bucket]=bus.reference;registry.count=registry.count.wrapping_add(1);sync.unlock(selector);
 for o in [0x7c,0x70,0x80,0x68,0x6c,0x98,0x8c,0x9c,0x84,0x88,0xb4,0xa8,0xb8,0xa0,0xa4]{bus.set_word(o,0);}
 for o in [0x78,0x94,0xb0]{bus.set_word(o,100);}
 Ok(())
}
#[cfg(test)] mod tests {
 use super::*;
 #[derive(Default)] struct Trace{calls:Vec<serde_json::Value>}
 impl Synchronization for Trace{fn lock(&mut self,s:u8){self.calls.push(serde_json::json!({"kind":"lock","registry":0x30002000u32+u32::from(s)*0x320}));}fn unlock(&mut self,s:u8){self.calls.push(serde_json::json!({"kind":"unlock","registry":0x30002000u32+u32::from(s)*0x320}));}}
 #[test] fn audio_actual_bus_initializer_and_registration_match432_native_cases(){let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_initializer_contract.json")).unwrap();assert_eq!(p["case_count"],432);for (case,row) in p["cases"].as_array().unwrap().iter().enumerate(){let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let bucket=(bus.word(8)%193) as usize;let mut store=Registries::default();store.banks[0].heads[bucket]=0x30004300;store.banks[0].count=7;store.banks[1].heads[bucket]=row["head"].as_u64().unwrap() as u32;store.banks[1].count=row["count"].as_u64().unwrap() as u32;let mut sync=Trace::default();initialize(&mut bus,&mut store,&mut sync).unwrap();assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"node {case}");assert_eq!(serde_json::json!(sync.calls),row["calls"],"calls {case}");for (i,(head,count)) in [("other_bucket","other_count"),("registry_bucket","registry_count")].into_iter().enumerate(){assert_eq!(u64::from(store.banks[i].heads[bucket]),row[head].as_u64().unwrap(),"bucket {case}");assert_eq!(u64::from(store.banks[i].count),row[count].as_u64().unwrap(),"count {case}");}}}
 #[test] fn audio_unresolved_bus_identity_and_wrong_class_fail_before_registration(){let mut bus=Bus{reference:0,raw:[0xa5;200]};let before=bus.raw;let mut store=Registries::default();let mut sync=Trace::default();assert_eq!(initialize(&mut bus,&mut store,&mut sync),Err(Error::UnresolvedReference));bus.reference=1;assert_eq!(initialize(&mut bus,&mut store,&mut sync),Err(Error::WrongClass));assert_eq!(bus.raw,before);assert!(sync.calls.is_empty());assert_eq!(store.banks[1].count,0);}
}
