//! Native game-to-Wwise listener layout, projection, normalization and table writes.
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Frame {pub forward:[f32;3],pub up:[f32;3],pub position:[f32;3]}
#[derive(Debug,Clone,Copy,PartialEq)]
pub enum Error {InvalidVector,Overflow,InvalidIndex,InvalidScale}
fn normalize(v:[f32;3])->Result<[f32;3],Error> {
 let length=((v[0]*v[0]+v[1]*v[1])+v[2]*v[2]).sqrt();
 if !length.is_finite() {return Err(Error::Overflow);}
 if length==0. {return Ok(v);}
 let factor=1./length;let result=v.map(|x|x*factor);
 if result.iter().any(|v|!v.is_finite()) {return Err(Error::Overflow);}Ok(result)
}
/// 705E30 packs forward/up/position; AEB0E0 projects forward before normalizing.
/// When unavailable the original backend does not inspect its vector inputs.
pub fn prepare(enabled:bool,position:[f32;3],forward:[f32;3],up:[f32;3])->Result<Option<Frame>,Error> {
 if !enabled {return Ok(None);}
 if position.iter().chain(forward.iter()).chain(up.iter()).any(|v|!v.is_finite()) {return Err(Error::InvalidVector);}
 // Original dot helper and projection use x87 intermediates, then store f32.
 let dot=(up[1] as f64*forward[1] as f64+up[0] as f64*forward[0] as f64)+up[2] as f64*forward[2] as f64;
 let projected=std::array::from_fn(|i| (forward[i] as f64-dot*up[i] as f64) as f32);
 Ok(Some(Frame {forward:normalize(projected)?,up:normalize(up)?,position}))
}
impl Frame {
 pub fn packed(self)->[f32;9] {[self.forward[0],self.forward[1],self.forward[2],self.up[0],self.up[1],self.up[2],self.position[0],self.position[1],self.position[2]]}
 fn right(self)->[f32;3] {
  // B052B0: cross(up,forward) with separate SSE f32 products/subtractions.
  [self.up[1]*self.forward[2]-self.up[2]*self.forward[1],self.forward[0]*self.up[2]-self.up[0]*self.forward[2],self.up[0]*self.forward[1]-self.forward[0]*self.up[1]]
 }
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Slot {pub frame:Frame,pub right:[f32;3],pub distance_scale:f32,pub dirty:bool}
impl Slot {
 pub fn basis(self)->[f32;9] {[self.right[0],self.right[1],self.right[2],self.frame.up[0],self.frame.up[1],self.frame.up[2],self.frame.forward[0],self.frame.forward[1],self.frame.forward[2]]}
 pub fn distance_listener(self)->crate::audio_distance::Listener {crate::audio_distance::Listener {position:self.frame.position,distance_scale:self.distance_scale}}
}
#[derive(Debug,Clone)]
pub struct Table {slots:[Slot;8]}
impl Default for Table {fn default()->Self {Self::native()}}
impl Table {
 /// B19E30 initializes every raw frame, basis, scale and pending dirty byte.
 /// Other native slot fields (channel gains/routing) are separate from this table.
 pub fn native()->Self {
  Self {slots:[Slot {frame:Frame {forward:[0.,0.,1.],up:[0.,1.,0.],position:[0.;3]},right:[1.,0.,0.],distance_scale:1.,dirty:true};8]}
 }
 /// B19EC0 publishes a nonempty dirty mask once and clears all eight dirty bytes.
 /// Returned mask must be consumed by voice invalidation; scheduling is external.
 pub fn flush_changes(&mut self)->Option<u8> {
  let mut mask=0;for (i,slot) in self.slots.iter_mut().enumerate() {if slot.dirty {mask|=1<<i;}slot.dirty=false;}
  if mask==0 {None} else {Some(mask)}
 }

 /// Explicit restoration state; this does not infer the original global initializer.
 pub fn from_slots(slots:[Slot;8])->Result<Self,Error> {
  for s in slots {
   if s.frame.packed().iter().chain(s.right.iter()).any(|v|!v.is_finite()) {return Err(Error::InvalidVector);}
   if !s.distance_scale.is_finite() || s.distance_scale<=0. {return Err(Error::InvalidScale);}
  }
  Ok(Self {slots})
 }
 pub fn slots(&self)->&[Slot;8] {&self.slots}
 /// B1A0B0 stores nine floats, updates right/up/forward basis and dirty byte.
 /// Its invalid-index result is separate from the game's successful queue post.
 pub fn apply(&mut self,index:usize,frame:Frame)->Result<(),Error> {
  if index>=8 {return Err(Error::InvalidIndex);}
  if frame.packed().iter().any(|v|!v.is_finite()) {return Err(Error::InvalidVector);}
  let right=frame.right();if right.iter().any(|v|!v.is_finite()) {return Err(Error::Overflow);}
  self.slots[index].frame=frame;self.slots[index].right=right;self.slots[index].dirty=true;Ok(())
 }
 /// B1A690 scale table write/dirty notification; finite positive guard is defensive.
 pub fn set_distance_scale(&mut self,index:usize,scale:f32)->Result<(),Error> {
  if index>=8 {return Err(Error::InvalidIndex);}
  if !scale.is_finite() || scale<=0. {return Err(Error::InvalidScale);}
  self.slots[index].distance_scale=scale;self.slots[index].dirty=true;Ok(())
 }
 pub fn distance_listeners(&self)->[crate::audio_distance::Listener;8] {self.slots.map(Slot::distance_listener)}
}
#[cfg(test)]mod tests {
 use super::*;
 fn table()->Table {
  Table::from_slots([Slot {frame:Frame {forward:[0.,0.,1.],up:[0.,1.,0.],position:[100.,200.,300.]},right:[1.,0.,0.],distance_scale:2.,dirty:false};8]).unwrap()
 }
 #[test]fn native_global_initialization_and_all_dirty_publications_match() {
  #[derive(serde::Deserialize)]struct InitialSlot {frame:[f32;9],basis:[f32;9],distance_scale:f32,dirty:bool}
  #[derive(serde::Deserialize)]struct Case {dirty_mask:u8,first_notifications:Vec<u8>,second_notifications:Vec<u8>,dirty_after:[bool;8]}
  #[derive(serde::Deserialize)]struct Contract {initial_slots:Vec<InitialSlot>,cases:Vec<Case>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_init_contract.json")).unwrap();assert_eq!(c.initial_slots.len(),8);let initial=Table::native();
  for (actual,expected) in initial.slots().iter().zip(c.initial_slots) {
   assert_eq!(actual.frame.packed(),expected.frame);assert_eq!(actual.basis(),expected.basis);assert_eq!(actual.distance_scale,expected.distance_scale);assert_eq!(actual.dirty,expected.dirty);
  }
  assert_eq!(c.cases.len(),256);
  for c in c.cases {
   let mut t=initial.clone();for (i,s) in t.slots.iter_mut().enumerate() {s.dirty=c.dirty_mask&(1<<i)!=0;}
   let before=*t.slots();assert_eq!(t.flush_changes(),c.first_notifications.first().copied());assert_eq!(t.flush_changes(),c.second_notifications.first().copied());
   for i in 0..8 {assert_eq!(t.slots()[i].dirty,c.dirty_after[i]);assert_eq!(t.slots()[i].frame,before[i].frame);assert_eq!(t.slots()[i].right,before[i].right);assert_eq!(t.slots()[i].distance_scale,before[i].distance_scale);}
  }
 }
 #[test]fn original_game_message_and_backend_table_match_exactly() {
  #[derive(serde::Deserialize)]struct Message {index:usize,frame:[f32;9]}
  #[derive(serde::Deserialize)]struct NativeSlot {frame:[f32;9],basis:[f32;9],distance_scale:f32,dirty:bool}
  #[derive(serde::Deserialize)]struct Case {enabled:bool,index:usize,position:[f32;3],forward:[f32;3],up:[f32;3],api_result:bool,message:Option<Message>,table_result:Option<u32>,table_slot:Option<NativeSlot>}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_backend_contract.json")).unwrap();assert_eq!(c.cases.len(),48);
  for (i,c) in c.cases.into_iter().enumerate() {
   let mut table=table();let before=*table.slots();let prepared=prepare(c.enabled,c.position,c.forward,c.up).unwrap();assert_eq!(prepared.is_some(),c.api_result);
   if let Some(frame)=prepared {
    let message=c.message.unwrap();assert_eq!(message.index,c.index);
    for (a,b) in frame.packed().iter().zip(message.frame) {assert_eq!(a.to_bits(),b.to_bits(),"message case{i}");}
    let result=table.apply(c.index,frame);
    if let Some(slot)=c.table_slot {
     assert_eq!(c.table_result,Some(1));assert!(result.is_ok());let actual=table.slots()[c.index];
     for (a,b) in actual.frame.packed().iter().zip(slot.frame) {assert_eq!(a.to_bits(),b.to_bits(),"frame case{i}");}
     for (a,b) in actual.basis().iter().zip(slot.basis) {assert_eq!(a.to_bits(),b.to_bits(),"basis case{i}");}
     assert_eq!(actual.distance_scale,slot.distance_scale);assert_eq!(actual.dirty,slot.dirty);
     assert_eq!(actual.distance_listener().position,c.position);
     for j in 0..8 {if j!=c.index {assert_eq!(table.slots()[j],before[j]);}}
    } else {assert_eq!(c.table_result,Some(31));assert_eq!(result,Err(Error::InvalidIndex));assert_eq!(table.slots(),&before);}
   } else {assert!(c.message.is_none());assert!(c.table_result.is_none());assert_eq!(table.slots(),&before);}
  }
 }
 #[test]fn native_scale_setter_changes_only_scale_and_dirty_and_errors_are_atomic() {
  #[derive(serde::Deserialize)]struct Case {index:usize,scale:f32,dirty_after:bool}
  #[derive(serde::Deserialize)]struct Contract {scale_cases:Vec<Case>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_distance_contract.json")).unwrap();assert_eq!(c.scale_cases.len(),32);
  for c in c.scale_cases {
   let mut t=table();let before=*t.slots();t.set_distance_scale(c.index,c.scale).unwrap();
   assert_eq!(t.slots()[c.index].distance_scale,c.scale);assert_eq!(t.slots()[c.index].dirty,c.dirty_after);assert_eq!(t.slots()[c.index].frame,before[c.index].frame);assert_eq!(t.slots()[c.index].right,before[c.index].right);
   for j in 0..8 {if j!=c.index {assert_eq!(t.slots()[j],before[j]);}}
   let before=*t.slots();assert!(t.set_distance_scale(8,1.).is_err());assert!(t.set_distance_scale(c.index,0.).is_err());assert!(t.set_distance_scale(c.index,f32::NAN).is_err());assert_eq!(t.slots(),&before);
  }
  assert_eq!(prepare(false,[f32::NAN;3],[f32::NAN;3],[f32::NAN;3]),Ok(None));assert_eq!(prepare(true,[f32::NAN;3],[0.;3],[0.;3]),Err(Error::InvalidVector));
 }
}
