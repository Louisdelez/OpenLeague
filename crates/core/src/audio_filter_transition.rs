//! Native B2BE10/B2B4F0 control consumption and planar low-pass transitions.
use crate::{audio_filter,audio_pcm::Filter};
const THRESHOLD:f32=0.1;
const BLOCK:usize=128;
#[derive(Debug,Clone,Copy,PartialEq,serde::Deserialize)]
pub struct State {
 pub current:f32,pub target:f32,pub step:u16,pub mode_raw:u8,
 pub bypass:bool,pub dirty:bool,pub immediate:bool,
}
#[derive(Debug,Clone)]
pub struct Controller {state:State,filter:Filter,sample_rate:u32}
impl Controller {
 /// Native identity constructor B2B410 and initializer flags B2B7E0.
 pub fn new(channels:usize,mode_raw:u8,sample_rate:u32)->Result<Self,&'static str> {
  if channels==0 || channels>8 {return Err("unsupported filter channel count");}
  Self::from_parts(State {current:0.,target:0.,step:8,mode_raw,bypass:true,dirty:true,immediate:true},[1.,0.,0.,0.,0.],&vec![[0.;4];channels],sample_rate)
 }
 /// Restore a finite, supported consumer state without clearing its histories.
 pub fn from_parts(state:State,coefficients:[f32;5],history:&[[f32;4]],sample_rate:u32)->Result<Self,&'static str> {
  audio_filter::cutoff(state.current,state.mode_raw,sample_rate)?;
  audio_filter::cutoff(state.target,state.mode_raw,sample_rate)?;
  if state.step>8 {return Err("unsupported transition state");}
  let mut filter=Filter::new(coefficients,history.len())?;filter.restore_history(history)?;
  Ok(Self {state,filter,sample_rate})
 }
 pub fn state(&self)->State {self.state}
 pub fn history(&self)->&[[f32;4]] {self.filter.history()}
 /// Original B15086 writer clamps finite input and preserves pending flags.
 /// An identical target leaves dirty unchanged and cannot restart interpolation.
 pub fn update_target(&mut self,raw_control:f32)->Result<(),&'static str> {
  if !raw_control.is_finite() {return Err("invalid filter control");}
  let target=raw_control.clamp(0.,100.);
  self.state.dirty|=target!=self.state.target;
  self.state.target=target;Ok(())
 }
 /// Original B2BB00 reset sets immediate without dirtying or changing the target.
 pub fn reset(&mut self) {
  self.state.immediate=true;
  self.filter.restore_history(&vec![[0.;4];self.history().len()]).expect("same finite channel histories");
 }
 /// Allocated voice path B1505F: below-threshold control skips both target writer
 /// and PCM, retaining the entire filter state until this path is active again.
 /// Creation/allocator failures and upstream parameter aggregation are separate.
 pub fn process_voice(&mut self,raw_control:f32,samples:&mut [f32],capacity:usize,frames:usize)->Result<(),&'static str> {
  if !raw_control.is_finite() {return Err("invalid filter control");}
  if raw_control<=THRESHOLD {return Ok(());}
  self.update_target(raw_control)?;
  self.process_planar(samples,capacity,frames)
 }
 fn update_coefficients(&mut self)->Result<(),&'static str> {
  let freq=audio_filter::cutoff(self.state.current,self.state.mode_raw,self.sample_rate)?;
  self.filter.set_coefficients(audio_filter::coefficients(freq,self.sample_rate)?)
 }
 fn consume_control(&mut self)->Result<(),&'static str> {
  if !self.state.dirty {return Ok(());}
  self.state.dirty=false;
  if self.state.immediate {
   self.state.immediate=false;self.state.step=8;self.state.current=self.state.target;
   self.state.bypass=self.state.target<=THRESHOLD;
   if !self.state.bypass {self.update_coefficients()?;}
  } else {
   self.state.bypass=self.state.current<=THRESHOLD && self.state.target<=THRESHOLD;
   self.state.step=if self.state.bypass {8} else {0};
  }
  Ok(())
 }
 /// Planar layout: capacity is channel stride; padding is preserved.
 /// Valid-input arithmetic follows native order. DSP overflow can leave a partial
 /// transition; real-time allocation/performance and invalid native states differ.
 pub fn process_planar(&mut self,samples:&mut [f32],capacity:usize,frames:usize)->Result<(),&'static str> {
  let channels=self.history().len();
  let length=channels.checked_mul(capacity).ok_or("invalid PCM geometry")?;
  if frames>capacity || capacity>u16::MAX as usize || samples.len()<length {return Err("invalid PCM geometry");}
  for channel in 0..channels {
   if samples[channel*capacity..channel*capacity+frames].iter().any(|v|!v.is_finite()) {return Err("invalid PCM samples");}
  }
  self.consume_control()?;
  if self.state.bypass {return Ok(());}
  if self.state.step>=8 {
   for channel in 0..channels {self.filter.process(channel,&mut samples[channel*capacity..channel*capacity+frames])?;}
   return Ok(());
  }
  let start=self.state.current;let delta=self.state.target-start;let mut offset=0;
  if start<=THRESHOLD {
   if frames<2 {return Ok(());}
   let history:Vec<[f32;4]>=(0..channels).map(|ch| {
    let first=samples[ch*capacity];let second=samples[ch*capacity+1];[second,first,second,first]
   }).collect();self.filter.restore_history(&history)?;offset=2;
  }
  while offset<frames {
   let count=(frames-offset).min(BLOCK);
   if self.state.step<8 {
    self.state.step+=1;
    self.state.current=start+((self.state.step as f32*delta)*0.125);
    self.update_coefficients()?;
   }
   for ch in 0..channels {self.filter.process(ch,&mut samples[ch*capacity+offset..ch*capacity+offset+count])?;}
   offset+=count;
  }
  if self.state.step>=8 {self.state.bypass=self.state.target<=THRESHOLD;}
  Ok(())
 }
}
#[cfg(test)]mod tests {
 use super::*;
 #[test]fn original_planar_control_and_transition_sequences_match() {
  #[derive(serde::Deserialize)]struct Step {frames:usize,capacity:usize,input:Vec<f32>,output:Vec<f32>,state:State,history:Vec<f32>}
  #[derive(serde::Deserialize)]struct Case {initial:State,initial_coefficients:[f32;5],initial_history:Vec<[f32;4]>,sample_rate:u32,alignment_bytes:usize,steps:Vec<Step>}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  #[repr(align(16))]struct Aligned([f32;2100]);
  let contract:Contract=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_filter_transition_contract.json")).unwrap();assert_eq!(contract.cases.len(),80);let mut count=0;
  for (index,c) in contract.cases.into_iter().enumerate() {
   let mut controller=Controller::from_parts(c.initial,c.initial_coefficients,&c.initial_history,c.sample_rate).unwrap();
   for s in c.steps {
    count+=1;let mut storage=Aligned([0.;2100]);let offset=c.alignment_bytes/4;let buf=&mut storage.0[offset..offset+s.input.len()];buf.copy_from_slice(&s.input);
    controller.process_planar(buf,s.capacity,s.frames).unwrap();assert_eq!(controller.state(),s.state,"state case{index} frames{}",s.frames);
    for (i,(a,b)) in buf.iter().zip(s.output).enumerate() {assert_eq!(a.to_bits(),b.to_bits(),"PCM case{index} frames{} sample{i}",s.frames);}
    for (i,(a,b)) in controller.history().iter().flatten().zip(s.history).enumerate() {assert_eq!(a.to_bits(),b.to_bits(),"history case{index} frames{} index{i}",s.frames);}
   }
  }
  assert_eq!(count,560);
 }
 #[test]fn native_target_writer_preserves_flags_and_clamps_finite_controls() {
  #[derive(serde::Deserialize)]struct Sample {old_target:f32,raw_control:f32,dirty_before:bool,immediate_before:bool,target_after:f32,dirty_after:bool,immediate_after:bool}
  #[derive(serde::Deserialize)]struct Contract {writer_cases:Vec<Sample>}
  let contract:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_retarget_contract.json")).unwrap();assert_eq!(contract.writer_cases.len(),84);
  for s in contract.writer_cases {
   let state=State {current:40.,target:s.old_target,step:3,mode_raw:1,bypass:false,dirty:s.dirty_before,immediate:s.immediate_before};
   let mut c=Controller::from_parts(state,[1.,0.,0.,0.,0.],&[[0.;4];2],48000).unwrap();c.update_target(s.raw_control).unwrap();
   assert_eq!(c.state().target.to_bits(),s.target_after.to_bits());assert_eq!(c.state().dirty,s.dirty_after);assert_eq!(c.state().immediate,s.immediate_after);
   assert_eq!(c.state().current,state.current);assert_eq!(c.state().step,state.step);
  }
 }
 #[test]fn native_voice_retarget_reset_and_skipped_control_sequences_match() {
  #[derive(serde::Deserialize)]struct Step {raw_control:f32,reset:bool,frames:usize,capacity:usize,input:Vec<f32>,output:Vec<f32>,state:State,history:Vec<f32>}
  #[derive(serde::Deserialize)]struct Case {sample_rate:u32,alignment_bytes:usize,initial:State,initial_history:Vec<f32>,steps:Vec<Step>}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  #[repr(align(16))]struct Aligned([f32;2100]);
  let contract:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_filter_retarget_contract.json")).unwrap();assert_eq!(contract.cases.len(),12);let mut count=0;
  for (index,c) in contract.cases.into_iter().enumerate() {
   let mut controller=Controller::new(2,1,c.sample_rate).unwrap();assert_eq!(controller.state(),c.initial);
   for (a,b) in controller.history().iter().flatten().zip(c.initial_history) {assert_eq!(a.to_bits(),b.to_bits());}
   for s in c.steps {
    count+=1;if s.reset {controller.reset();}
    let mut storage=Aligned([0.;2100]);let offset=c.alignment_bytes/4;let buf=&mut storage.0[offset..offset+s.input.len()];buf.copy_from_slice(&s.input);
    controller.process_voice(s.raw_control,buf,s.capacity,s.frames).unwrap();assert_eq!(controller.state(),s.state,"state case{index} raw{} frames{}",s.raw_control,s.frames);
    for (i,(a,b)) in buf.iter().zip(s.output).enumerate() {assert_eq!(a.to_bits(),b.to_bits(),"PCM case{index} raw{} frames{} sample{i}",s.raw_control,s.frames);}
    for (i,(a,b)) in controller.history().iter().flatten().zip(s.history).enumerate() {assert_eq!(a.to_bits(),b.to_bits(),"history case{index} raw{} frames{} index{i}",s.raw_control,s.frames);}
   }
  }
  assert_eq!(count,216);
 }
 #[test]fn invalid_requests_and_geometry_leave_control_and_history_intact() {
  let mut c=Controller::new(2,0,48000).unwrap();let state=c.state();let history=c.history().to_vec();
  assert!(c.update_target(f32::NAN).is_err());assert!(c.update_target(f32::INFINITY).is_err());
  assert!(c.process_planar(&mut [0.;4],2,3).is_err());assert!(c.process_planar(&mut [0.;3],2,2).is_err());
  assert!(c.process_planar(&mut [f32::INFINITY;4],2,2).is_err());assert_eq!(c.state(),state);assert_eq!(c.history(),history);
  assert!(Controller::new(0,0,48000).is_err());assert!(Controller::new(2,0,22050).is_err());
 }
}
