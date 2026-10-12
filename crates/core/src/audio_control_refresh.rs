//! Whole AEE790 refresh orchestration and native float accumulation.
//! Backend methods are mandatory qualified dependencies, never invented controls.
#[derive(Debug,Clone)] pub struct Entry {pub id:u32,pub flags:u32,pub gain:f32}
#[derive(Debug,Clone)] pub struct State {
 pub block:[u8;84],pub flags:[u8;5],pub entries:Vec<Entry>,pub extras:[f32;3],
 pub d4:f32,pub d8:f32,pub dc:f32,pub cc:f32,pub d0:f32,
 pub pair:[f32;2],pub spatial:crate::audio_spatial_controls::Spatial,pub pose:Option<crate::audio_spatial_controls::Pose>,pub range_limit:f32,pub context:Option<f32>,
 pub optional:bool,pub owner:u32,
}
#[derive(Debug,PartialEq,Eq)] pub enum Error {InvalidValue,Backend(&'static str)}
#[derive(Debug,Clone,Copy)] pub struct Request {pub mask:u32,pub first:u32,pub owner:u32,pub last:u32}
pub trait Backend {
 fn spatial(&mut self,state:&mut State)->Result<(),Error>;
 fn optional(&mut self)->Result<(),Error>;
 fn flag(&mut self,owner:u32)->Result<u8,Error>;
 fn source(&mut self)->Result<f32,Error>;
 fn routing(&mut self,state:&mut State)->Result<(),Error>;
 fn parameters(&mut self,state:&mut State,request:Request)->Result<(),Error>;
 fn pair(&mut self,owner:u32)->Result<[f32;2],Error>;
 fn transition(&mut self,value:f32)->Result<(),Error>;
}
impl State {
 pub fn value(&self,offset:usize)->f32 {f32::from_le_bytes(self.block[offset..offset+4].try_into().unwrap())}
 pub fn set_value(&mut self,offset:usize,value:f32){self.block[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
 fn reset(&mut self){
  for offset in (0..80).step_by(4){match offset {0x18=>self.block[offset]&=0xfc,0x20=>self.block[offset]&=0xfe,_=>self.block[offset..offset+4].fill(0)}}
  self.set_value(4,1.);self.block[80..83].fill(0);
 }
 fn prune(&mut self){let mut index=0;while index<self.entries.len(){if self.entries[index].flags&2==0{self.entries.swap_remove(index);}else{index+=1;}}}
 /// Return raw control slots; downstream semantic conversion/admission is separate.
 pub fn refresh(&mut self,backend:&mut impl Backend)->Result<(),Error>{
  if [self.d4,self.d8,self.dc,self.pair[0],self.pair[1]].into_iter().chain(self.context).chain(self.entries.iter().map(|entry|entry.gain)).any(|value|!value.is_finite()){return Err(Error::InvalidValue);}
  self.reset();self.prune();backend.spatial(self)?;
  if self.optional {backend.optional()?;}
  self.flags[3]=(self.flags[3]&!1)|(backend.flag(self.owner)?&1);
  if self.flags[2]&0x80!=0 {let source=backend.source()?;if !source.is_finite(){return Err(Error::InvalidValue);}self.set_value(0,source);if self.flags[2]&0x40==0 {backend.routing(self)?;}}
  self.range_limit=101.;let request=Request {mask:if self.flags[4]&1==0 {0xffffffef}else{u32::MAX},first:u32::from(self.flags[0]&0x80==0),owner:self.owner,last:1};backend.parameters(self,request)?;
  let combined_c=self.extras[2]+self.value(12);let combined_8=self.extras[1]+self.value(8);let main=self.value(0);
  self.flags[0]|=0x80;self.d0=combined_c;self.set_value(8,combined_8);self.set_value(12,self.d4+combined_c);self.cc=main;
  let mut product=1f32;for entry in &self.entries {product=entry.gain*product;}
  let product=(self.d8*product)*self.dc;self.set_value(4,if product>0. {product}else{0.});self.set_value(0,main+self.extras[0]);
  if self.flags[2]&0x80!=0 {if let Some(context)=self.context {self.set_value(8,context+combined_8);}}
  let pair=backend.pair(self.owner)?;
  if !pair.iter().chain(self.spatial.values().iter()).chain([self.value(0),self.value(4),self.value(8),self.value(12),self.cc,self.d0].iter()).all(|value|value.is_finite()){return Err(Error::InvalidValue);}
  if pair!=self.pair {self.pair=pair;backend.transition(pair[0])?;}
  self.flags[0]|=0x20;Ok(())
 }
}
/// Connect actual refresh to the active-voice cache gate; flags become valid only
/// after all required dependency methods complete successfully.
pub fn refresh_cached(store:&mut crate::audio_active_voice_cache::Store,id:u32,state:&mut State,backend:&mut impl Backend)->Result<bool,crate::audio_active_voice_cache::Error>{
 store.refresh_if_needed(id,|voice|{state.flags[..4].copy_from_slice(&voice.flags.raw);state.refresh(backend).map_err(|_|crate::audio_active_voice_cache::Error::Backend("control refresh failed"))?;voice.flags.raw.copy_from_slice(&state.flags[..4]);Ok(())})
}
#[cfg(test)] mod tests {
 use super::*;
 struct Probe {row:serde_json::Value,calls:Vec<serde_json::Value>}
 impl Probe {fn f(&self,key:&str)->f32{self.row[key].as_f64().unwrap() as f32}fn array<const N:usize>(&self,key:&str)->[f32;N]{self.row[key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>().try_into().unwrap()}}
 impl Backend for Probe {
  fn spatial(&mut self,s:&mut State)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"spatial","owner":s.owner}));s.spatial.raw[..8].copy_from_slice(&[1.25f32.to_le_bytes(),2.5f32.to_le_bytes()].concat());Ok(())}
  fn optional(&mut self)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"optional"}));Ok(())}
  fn flag(&mut self,owner:u32)->Result<u8,Error>{self.calls.push(serde_json::json!({"kind":"flag","owner":owner}));Ok(self.row["flag"].as_u64().unwrap() as u8)}
  fn source(&mut self)->Result<f32,Error>{self.calls.push(serde_json::json!({"kind":"source"}));Ok(self.f("source"))}
  fn routing(&mut self,_:&mut State)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"routing"}));Ok(())}
  fn parameters(&mut self,state:&mut State,request:Request)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"parameters","mask":request.mask,"first":request.first,"prefix_bits":state.value(0).to_bits(),"entries_before":state.entries.len()}));assert_eq!(request.owner,77);assert_eq!(request.last,1);let controls=self.array::<3>("controls");state.set_value(0,state.value(0)+controls[0]);state.set_value(8,controls[1]);state.set_value(12,controls[2]);state.extras=self.array("extras");Ok(())}
  fn pair(&mut self,owner:u32)->Result<[f32;2],Error>{self.calls.push(serde_json::json!({"kind":"pair","owner":owner}));Ok(self.array("pair"))}
  fn transition(&mut self,value:f32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"transition","value_bits":value.to_bits()}));Ok(())}
 }
 fn state(row:&serde_json::Value)->State {
  let f=|key:&str|row[key].as_f64().unwrap() as f32;
  State {block:[0xa5;84],flags:[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8],entries:row["entries"].as_array().unwrap().iter().map(|e|Entry {id:e["id"].as_u64().unwrap() as u32,flags:e["flags"].as_u64().unwrap() as u32,gain:e["gain"].as_f64().unwrap() as f32}).collect(),extras:[0.;3],d4:f("d4"),d8:f("d8"),dc:f("dc"),cc:0.,d0:0.,pair:row["old_pair"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>().try_into().unwrap(),spatial:crate::audio_spatial_controls::Spatial::default(),pose:None,range_limit:0.,context:Some(f("context")),optional:row["optional"].as_bool().unwrap(),owner:77}
 }
 #[test] fn whole_original_refresh_matches2592_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_control_refresh_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),2592);
  for row in rows {let mut state=state(row);let mut backend=Probe {row:row.clone(),calls:Vec::new()};state.refresh(&mut backend).unwrap();
   let hex:String=state.block.iter().map(|byte|format!("{byte:02x}")).collect();assert_eq!(hex,row["output_block"].as_str().unwrap());assert_eq!(serde_json::json!(state.flags),row["output_flags"]);assert_eq!(serde_json::json!([state.cc.to_bits(),state.d0.to_bits()]),row["output_cc_d0"]);assert_eq!(serde_json::json!(state.pair.map(f32::to_bits)),row["output_pair_bits"]);assert_eq!(serde_json::json!(state.spatial.values()[..2].iter().map(|v|v.to_bits()).collect::<Vec<_>>()),row["output_spatial_bits"]);assert_eq!(u64::from(state.range_limit.to_bits()),row["range_limit_bits"].as_u64().unwrap());let entries:Vec<_>=state.entries.iter().map(|entry|serde_json::json!({"id":entry.id,"flags":entry.flags,"gain_bits":entry.gain.to_bits()})).collect();assert_eq!(serde_json::json!(entries),row["output_entries"]);assert_eq!(serde_json::json!(backend.calls),row["calls"]);
  }
 }
 #[test] fn full_refresh_establishes_cache_validity_and_skips_repeated_work(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_control_refresh_contract.json")).unwrap();let row=&proof["cases"][0];let mut state=state(row);let mut backend=Probe {row:row.clone(),calls:Vec::new()};let mut store=crate::audio_active_voice_cache::Store {voices:std::collections::BTreeMap::from([(1,crate::audio_active_voice_cache::Voice {next:None,flags:crate::audio_active_voice_cache::Flags {raw:[0,0x5a,0,0xa4]}})])};
  assert_eq!(refresh_cached(&mut store,1,&mut state,&mut backend),Ok(true));assert!(!store.voices[&1].flags.needs_refresh());let count=backend.calls.len();assert_eq!(refresh_cached(&mut store,1,&mut state,&mut backend),Ok(false));assert_eq!(backend.calls.len(),count);
  store.invalidate(Some(1)).unwrap();state.d4=f32::NAN;assert!(refresh_cached(&mut store,1,&mut state,&mut backend).is_err());assert!(store.voices[&1].flags.needs_refresh());assert_eq!(backend.calls.len(),count);
 }
}
