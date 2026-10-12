//! Original7D2ED0 camera zoom state transition; raw timing and state supplied by caller.
#[derive(Debug,Clone,Copy)]
pub struct Zoom {
    pub smooth_time:f32,pub epsilon:f32,pub scale_raw:u32,
    pub velocity:f32,pub current:f32,pub target:f32,
}
impl Zoom {
    /// Original7D2E70 config defaults, preserving explicit CameraSmoothing overrides.
    pub fn original_initial(ease_time:Option<f32>,minimum_speed:Option<f32>)->Self {
        Self {smooth_time:ease_time.unwrap_or(f32::from_bits(DEFAULT_EASE)),epsilon:minimum_speed.unwrap_or(3.),scale_raw:1_f32.to_bits(),velocity:0.,current:2250.,target:2250.}
    }
    pub fn update(&mut self,frame_delta:f32) {
        let old=self.current;
        // Ordered native comparisons intentionally preserve exceptional values.
        if !(f32::from_bits(TINY)>frame_delta) {
            if f32::from_bits(TINY)>self.smooth_time {self.current=self.target;self.velocity=0.;}
            else {
                let delta=if frame_delta>self.smooth_time {self.smooth_time} else {frame_delta};
                let omega=f32::from_bits(TWO)/self.smooth_time;let t=omega*delta;
                let polynomial=(((((t*f32::from_bits(COEFFICIENT_A))*t)*f32::from_bits(COEFFICIENT_B))*t)*t)*t;
                let decay=f32::from_bits(ONE)/(polynomial+(t+f32::from_bits(ONE)));
                let difference=self.current-self.target;let change=(difference*omega+self.velocity)*delta;
                self.velocity=(self.velocity-change*omega)*decay;
                self.current=(change+difference)*decay+self.target;
            }
        }
        if self.epsilon>(self.target-self.current).abs() {self.current=self.target;self.velocity=0.;}
        else if self.epsilon>(self.current-old).abs() {
            self.current=if self.target>old {old+self.epsilon} else {old-self.epsilon};
        }
        if self.current>f32::from_bits(MAXIMUM) {self.current=f32::from_bits(MAXIMUM);}
        else if f32::from_bits(MINIMUM)>self.current {self.current=f32::from_bits(MINIMUM);}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_12_native_zoom_initializers_with_config_defaults_and_overrides() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_zoom_contract.json")).unwrap();let cases=proof["initializers"].as_array().unwrap();assert_eq!(cases.len(),12);assert_eq!(DEFAULT_EASE,proof["constants_bits"]["0x1138b30"].as_u64().unwrap() as u32);
        for c in cases {
            let optional=|key:&str|c[key].as_u64().map(|value|f32::from_bits(value as u32));let state=Zoom::original_initial(optional("ease_bits"),optional("minimum_speed_bits"));let words=[state.smooth_time.to_bits(),state.epsilon.to_bits(),state.scale_raw,state.velocity.to_bits(),state.current.to_bits(),state.target.to_bits()];
            for i in 0..6 {assert_eq!(words[i],c["state_bits"][i].as_u64().unwrap() as u32,"{i}/{c}");}
            let calls=c["config_calls"].as_array().unwrap();assert_eq!(calls.len(),2);assert_eq!(calls[0]["section"],"CameraSmoothing");assert_eq!(calls[0]["key"],"CameraZoomEaseTime");assert_eq!(calls[0]["default_bits"].as_u64().unwrap() as u32,DEFAULT_EASE);assert_eq!(calls[1]["key"],"CameraZoomMinSpeed");assert_eq!(calls[1]["default_bits"].as_u64().unwrap() as u32,3_f32.to_bits());
        }
    }
    #[test]
    fn matches_132_native_zoom_sequences_and_822_state_updates_bit_exactly_except_nan_payloads() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_zoom_contract.json")).unwrap();
        for (address,value) in [("0x1138980",TINY),("0x1138df8",TWO),("0x1138c74",ONE),("0x1138b98",COEFFICIENT_A),("0x1138b3c",COEFFICIENT_B),("0x11391ec",MAXIMUM),("0x11391c4",MINIMUM)] {assert_eq!(proof["constants_bits"][address].as_u64().unwrap() as u32,value);}
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),132);let mut count=0;
        for (case_index,c) in cases.iter().enumerate() {
            let initial=|i:usize|c["initial_bits"][i].as_u64().unwrap() as u32;
            let mut state=Zoom{smooth_time:f32::from_bits(initial(0)),epsilon:f32::from_bits(initial(1)),scale_raw:initial(2),velocity:f32::from_bits(initial(3)),current:f32::from_bits(initial(4)),target:f32::from_bits(initial(5))};
            for (step_index,step) in c["steps"].as_array().unwrap().iter().enumerate() {
                count+=1;state.update(f32::from_bits(step["delta_bits"].as_u64().unwrap() as u32));
                let actual=[state.smooth_time.to_bits(),state.epsilon.to_bits(),state.scale_raw,state.velocity.to_bits(),state.current.to_bits(),state.target.to_bits()];
                for i in 0..6 {let original=step["state_bits"][i].as_u64().unwrap() as u32;if i!=2 && f32::from_bits(original).is_nan() {assert!(f32::from_bits(actual[i]).is_nan(),"case{case_index}step{step_index}field{i}");} else {assert_eq!(actual[i],original,"case{case_index}step{step_index}field{i}");}}
            }
        }
        assert_eq!(count,822);
    }
}

const TINY:u32=646978941;
const TWO:u32=1073741824;
const ONE:u32=1065353216;
const COEFFICIENT_A:u32=1056293519;
const COEFFICIENT_B:u32=1047569367;
const MAXIMUM:u32=1158455296;
const MINIMUM:u32=1148846080;

const DEFAULT_EASE:u32=1045220557;
