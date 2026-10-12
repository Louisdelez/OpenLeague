//! Fixed-coefficient native block/scalar filter with independent channel history.
include!("audio_filter_expand.rs");
#[derive(Debug,Clone)]
pub struct Filter {expanded:[f32;40],history:Vec<[f32;4]>}
impl Filter {
 pub fn new(coefficients:[f32;5],channels:usize)->Result<Self,&'static str> {
  if channels==0 || channels>8 {return Err("unsupported filter channel count");}
  let mut filter=Self {expanded:[0.;40],history:vec![[0.;4];channels]};
  filter.set_coefficients(coefficients)?;Ok(filter)
 }
 pub fn set_coefficients(&mut self,coefficients:[f32;5])->Result<(),&'static str> {
  if coefficients.iter().any(|v|!v.is_finite()) {return Err("invalid filter coefficients");}
  let expanded=expand(coefficients);
  if expanded.iter().any(|v|!v.is_finite()) {return Err("coefficient expansion overflow");}
  // Original setter writes coefficient storage without clearing channel history.
  self.expanded=expanded;Ok(())
 }
 pub fn history(&self)->&[[f32;4]] {&self.history}
 pub fn restore_history(&mut self,history:&[[f32;4]])->Result<(),&'static str> {
  if history.len()!=self.history.len() || history.iter().flatten().any(|v|!v.is_finite()) {return Err("invalid channel history");}
  self.history.copy_from_slice(history);Ok(())
 }
 /// Histories store last input, preceding input, last output, preceding output.
 /// Original pointer alignment chooses scalar prefix, four-lane blocks and tail.
 pub fn process(&mut self,channel:usize,samples:&mut [f32])->Result<(),&'static str> {
  let mut h=*self.history.get(channel).ok_or("invalid filter channel")?;
  if samples.iter().any(|v|!v.is_finite()) {return Err("invalid PCM samples");}
  let alignment=(samples.as_ptr() as usize)&15;
  let prefix=if alignment==0 {0} else {((16-alignment)/4).min(samples.len())};
  // Defensive atomicity on overflow; allocation/performance remains to profile
  // when the complete mixer is connected to the client audio callback.
  let mut next=samples.to_vec();let c=&self.expanded;
  let scalar=|x:f32,h:&mut [f32;4]| {
   let part=(c[32]*x)+(c[34]*h[1]);
   let part=(c[33]*h[0])+part;
   let part=(c[36]*h[3])+part;
   let y=(h[2]*c[35])+part;
   *h=[x,h[0],y,h[2]];y
  };
  for x in &mut next[..prefix] {*x=scalar(*x,&mut h);}
  let block_end=prefix+((next.len()-prefix)/4)*4;
  for start in (prefix..block_end).step_by(4) {
   let input:[f32;4]=next[start..start+4].try_into().unwrap();let mut output=[0.;4];
   for lane in 0..4 {
    let mut sum=(h[3]*c[28+lane])+(h[2]*c[24+lane]);
    sum=sum+(input[2]*c[4+lane]);
    let feed=(c[lane]*input[lane])+((c[20+lane]*h[1])+(c[16+lane]*h[0]));
    sum=sum+feed;
    sum=sum+((input[0]*c[12+lane])+(input[1]*c[8+lane]));
    output[lane]=sum;
   }
   next[start..start+4].copy_from_slice(&output);h=[input[3],input[2],output[3],output[2]];
  }
  for x in &mut next[block_end..] {*x=scalar(*x,&mut h);}
  if next.iter().chain(h.iter()).any(|v|!v.is_finite()) {return Err("PCM filter overflow");}
  samples.copy_from_slice(&next);self.history[channel]=h;Ok(())
 }
}
#[cfg(test)]mod tests {
 use super::*;
 #[test]fn all_original_block_and_scalar_sequences_match_exactly() {
  #[derive(serde::Deserialize)]struct Step {channel:usize,input:Vec<f32>,output:Vec<f32>,history:Vec<f32>}
  #[derive(serde::Deserialize)]struct Case {coefficients:[f32;5],alignment_bytes:usize,initial_history:Vec<[f32;4]>,expanded:Vec<f32>,steps:Vec<Step>}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  #[repr(align(16))]struct Aligned([f32;80]);
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_pcm_contract.json")).unwrap();assert_eq!(c.cases.len(),180);
  let mut blocks=0;
  for sample in c.cases {
   let mut filter=Filter::new(sample.coefficients,2).unwrap();filter.restore_history(&sample.initial_history).unwrap();
   for i in 0..40 {assert_eq!(filter.expanded[i].to_bits(),sample.expanded[i].to_bits(),"setter{}",i);}
   for step in sample.steps {
    blocks+=1;let mut storage=Aligned([0.;80]);let offset=sample.alignment_bytes/4;
    let buf=&mut storage.0[offset..offset+step.input.len()];buf.copy_from_slice(&step.input);filter.process(step.channel,buf).unwrap();
    for (i,(a,b)) in buf.iter().zip(step.output).enumerate() {assert_eq!(a.to_bits(),b.to_bits(),"align{} channel{} index{}",sample.alignment_bytes,step.channel,i);}
    for (a,b) in filter.history().iter().flatten().zip(step.history) {assert_eq!(a.to_bits(),b.to_bits(),"channel history");}
   }
  }
  assert_eq!(blocks,540);
 }
 #[test]fn coefficient_changes_preserve_channels_and_failed_updates_are_atomic() {
  let mut filter=Filter::new([1.,0.,0.,0.,0.],2).unwrap();let mut samples=[0.1,0.2,0.3,0.4,0.5];filter.process(0,&mut samples).unwrap();let h=filter.history().to_vec();
  filter.set_coefficients([0.5,0.,0.,0.,0.]).unwrap();assert_eq!(filter.history(),h);
  assert!(filter.set_coefficients([f32::NAN;5]).is_err());assert_eq!(filter.history(),h);
  let mut bad=[1.,f32::NAN];assert!(filter.process(0,&mut bad).is_err());assert_eq!(filter.history(),h);
  assert!(filter.process(2,&mut []).is_err());assert!(filter.restore_history(&[[0.;4]]).is_err());
 }
}
