//! Original73A710 phase arithmetic;73A850 publishes [1/tile,u,v,0].
//! Native GameClock delta provider qualified by cloud_game_clock_pause_contract.json.
#[derive(Clone, Copy, Debug, Default)]
pub struct Phase { pub u:f32, pub v:f32 }
impl Phase {
    pub fn advance(&mut self,delta_u:f32,delta_v:f32,speed_u:f32,speed_v:f32) {
        // Original x87 multiply/add rounds only on the final f32 store.
        fn axis(old:f32,delta:f32,speed:f32)->f32 {
            let mut value=(old as f64+delta as f64*speed as f64) as f32;
            if value>10. { value-=10.; }
            value
        }
        self.u=axis(self.u,delta_u,speed_u);
        self.v=axis(self.v,delta_v,speed_v);
    }
    pub fn constants(self,tile:f32)->[f32;4] { [1./tile,self.u,self.v,0.] }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn phase_and_constants_match_all_original_instruction_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_cloud_phase_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["wrap"],10.0);
        for case in proof["cases"].as_array().unwrap() {
            let number=|field:&str,i:usize|case[field][i].as_f64().unwrap() as f32;
            let mut phase=Phase {u:number("initial",0),v:number("initial",1)};
            phase.advance(number("delta",0),number("delta",1),number("speed",0),number("speed",1));
            assert_eq!(phase.u.to_bits(),case["phase_bits"][0].as_u64().unwrap() as u32);
            assert_eq!(phase.v.to_bits(),case["phase_bits"][1].as_u64().unwrap() as u32);
            for (i,x) in phase.constants(2000.).iter().enumerate() {assert_eq!(x.to_bits(),number("constants",i).to_bits());}
        }
    }
}

#[cfg(test)]
mod game_clock_tests {
 use super::*;
 #[test]
 fn cloud_pause_sequences_match_executed_native_clock(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/cloud_game_clock_pause_contract.json")).unwrap();
  assert_eq!(proof["passed"],true);
  for case in proof["cases"].as_array().unwrap(){
   let mut phase=Phase{u:0.25,v:0.5};let speed=case["speed"].as_f64().unwrap() as f32;
   for frame in case["frames"].as_array().unwrap(){
    let delta=f32::from_bits(frame["delta_bits"].as_u64().unwrap() as u32);phase.advance(delta,delta,speed,speed);
    assert_eq!(phase.u.to_bits(),(frame["phase"][0].as_f64().unwrap() as f32).to_bits());
    assert_eq!(phase.v.to_bits(),(frame["phase"][1].as_f64().unwrap() as f32).to_bits());
   }
  }
 }
}
