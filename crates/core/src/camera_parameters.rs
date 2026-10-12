//! Native986150 defaults and9861D0/986485 projection dispatch. Final game settings external.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind {Perspective,Orthographic}
#[derive(Debug,Clone,Copy)]
pub struct Request {pub kind:Kind,pub parameters:[f32;4]}
#[derive(Debug,Clone,Copy)]
pub struct Parameters {
    pub position:[f32;3],pub near:f32,pub far:f32,pub direction:[f32;3],pub up:[f32;3],
    pub fov_degrees:f32,pub projection_raw:u32,pub width:f32,pub height:f32,pub auxiliary_raw:u32,
}
impl Parameters {
    pub fn original_initial(position:[f32;3])->Self {
        Self {position,near:50.,far:65000.,direction:[0.,0.,1.],up:[0.,1.,0.],fov_degrees:103.,projection_raw:0,width:1000.,height:1000.,auxiliary_raw:0}
    }
    pub fn render_request(&self,aspect:f32)->Request {
        if matches!(self.projection_raw,1|2) {
            Request{kind:Kind::Orthographic,parameters:[self.width,self.height,self.near,self.far]}
        } else {
            Request{kind:Kind::Perspective,parameters:[self.fov_degrees*f32::from_bits(RENDER_FACTOR),aspect,self.near,self.far]}
        }
    }
    pub fn culling_request(&self)->Result<Request,&'static str> {
        if self.projection_raw!=0 {
            return Ok(Request{kind:Kind::Orthographic,parameters:[self.width,self.height,self.near,self.far]});
        }
        let pi=f32::from_bits(CULL_PI);let factor=f32::from_bits(CULL_FACTOR);
        #[cfg(any(target_arch="x86",target_arch="x86_64"))]
        {
            let degrees=self.fov_degrees;let mut angle=0_f32;
            unsafe {std::arch::asm!("fld dword ptr [{degrees}]","fmul dword ptr [{pi}]","fmul dword ptr [{factor}]","fstp dword ptr [{angle}]",degrees=in(reg) &degrees,pi=in(reg) &pi,factor=in(reg) &factor,angle=in(reg) &mut angle,out("st(0)") _,options(nostack));}
            // The original culling caller forwards far before near; retain ordering.
            Ok(Request{kind:Kind::Perspective,parameters:[angle,angle,self.far,self.near]})
        }
        #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
        {let _=(pi,factor);Err("native x87 camera angle conversion unavailable")}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_parameters_contract.json")).unwrap()}
    #[test]
    fn matches_four_native_camera_initializers_without_claiming_final_game_configuration() {
        let p=proof();let cases=p["initializers"].as_array().unwrap();assert_eq!(cases.len(),4);
        for c in cases {
            let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);let camera=Parameters::original_initial(position);
            let floats=[camera.position[0],camera.position[1],camera.position[2],camera.near,camera.far,camera.direction[0],camera.direction[1],camera.direction[2],camera.up[0],camera.up[1],camera.up[2],camera.fov_degrees,0.,camera.width,camera.height,0.];
            let mut words=floats.map(f32::to_bits);words[12]=camera.projection_raw;words[15]=camera.auxiliary_raw;
            for i in 0..16 {assert_eq!(words[i],c["camera_words"][i].as_u64().unwrap() as u32);}
        }
    }
    #[test]
    fn matches_30_native_render_and_culling_dispatch_cases_bit_exactly() {
        let p=proof();assert_eq!(RENDER_FACTOR,p["render_degrees_factor_bits"].as_u64().unwrap() as u32);assert_eq!(CULL_PI,p["culling_pi_bits"].as_u64().unwrap() as u32);assert_eq!(CULL_FACTOR,p["culling_degrees_factor_bits"].as_u64().unwrap() as u32);let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),30);
        for c in cases {
            let mut camera=Parameters::original_initial([0.;3]);camera.projection_raw=c["mode"].as_u64().unwrap() as u32;camera.fov_degrees=c["fov_degrees"].as_f64().unwrap() as f32;
            for (key,request) in [("render",camera.render_request(f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32))),("culling",camera.culling_request().unwrap())] {
                assert_eq!(request.kind,if c[key]["kind"]=="perspective" {Kind::Perspective} else {Kind::Orthographic});
                for i in 0..4 {assert_eq!(request.parameters[i].to_bits(),c[key]["parameter_bits"][i].as_u64().unwrap() as u32,"{key}/{c}");}
            }
        }
    }
}

const RENDER_FACTOR:u32=1016003125;
const CULL_PI:u32=1078530011;
const CULL_FACTOR:u32=1001786209;
