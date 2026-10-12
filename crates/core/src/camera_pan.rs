//! Original default two-key camera pan (mode1), request565E00/update5663B0/curve565F50.
#[derive(Debug,Clone)] pub struct Pan {start:[f32;3],end:[f32;3],began:f32,ends:f32,pub current:[f32;3],pub finished:bool}
impl Pan {
 pub fn new(start:[f32;3],end:[f32;3],now:f32,duration:f32)->Self {let ends=now+duration;let finished=now>=ends;Self{start,end,began:now,ends,current:if finished{end}else{start},finished}}
 pub fn update(&mut self,now:f32)->[f32;3]{
  if self.finished{return self.current;}
  if now>=self.ends{self.current=self.end;self.finished=true;return self.current;}
  let t=((now-self.began)/(self.ends-self.began)).clamp(0.,1.);
  // Preserve native scalar instruction order and do not introduce fused multiply-add.
  let weight=(3.-t*2.)*(t*t);let complement=1.-weight;
  self.current=std::array::from_fn(|i|self.start[i]*complement+self.end[i]*weight);
  self.current[1]=0.;self.current
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn matches176_original_request_update_cleanup_sequences_bit_for_bit(){
  let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_camera_pan_contract.json")).unwrap();let cases=d["cases"].as_array().unwrap();assert_eq!(cases.len(),176);
  for c in cases{let vector=|name:&str|std::array::from_fn(|i|c[name][i].as_f64().unwrap() as f32);let mut pan=Pan::new(vector("start"),vector("end"),100.,c["duration"].as_f64().unwrap() as f32);let actual=pan.update(f32::from_bits(c["now_bits"].as_u64().unwrap() as u32));for (i,v) in actual.iter().enumerate(){assert_eq!(v.to_bits(),c["output_bits"][i].as_u64().unwrap() as u32,"{c}");}assert_eq!(pan.finished,c["finished"].as_bool().unwrap());}
 }
}
