//! Original7CFBF1 normal camera geometry after caller-provided focus update, without active shake.
use crate::{camera_parameters::Parameters,camera_zoom::Zoom};
#[derive(Debug,Clone,Copy)]
pub struct Controls {pub focus_after_update:[f32;3],pub pitch_degrees:f32,pub yaw_degrees:f32,pub previous_yaw_degrees:f32,pub fov_degrees:f32,pub zoom:Zoom}
#[derive(Debug,Clone,Copy)]
pub struct Assembly {pub camera:Parameters,pub zoom:Zoom,pub distance:f32}
fn distance(current:f32,scale:f32)->Result<f32,&'static str> {
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let factor=f32::from_bits(DISTANCE_FACTOR);let mut result=0_f32;
        unsafe {std::arch::asm!("fld dword ptr [{current}]","fadd st(0), st(0)","fmul dword ptr [{factor}]","fmul dword ptr [{scale}]","fstp dword ptr [{result}]",current=in(reg) &current,factor=in(reg) &factor,scale=in(reg) &scale,result=in(reg) &mut result,out("st(0)") _,options(nostack));}
        Ok(result)
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {let _=(current,scale);Err("native x87 camera distance unavailable")}
}
fn normalized(mut vector:[f32;3],squared:f32)->Result<[f32;3],&'static str> {
    if squared>f32::from_bits(NORMALIZATION_THRESHOLD) {
        let factor=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;
        for value in &mut vector {*value=(*value as f64*factor as f64) as f32;}
    }
    Ok(vector)
}
/// Keeps native zoom state and camera output explicit. Focus/input/warning/shake producers are external.
pub fn assemble_after_focus(initial:&Parameters,controls:&Controls,frame_delta:f32)->Result<Assembly,&'static str> {
    let mut zoom=controls.zoom;zoom.update(frame_delta);let distance=distance(zoom.current,f32::from_bits(zoom.scale_raw))?;
    let pitch=crate::camera_rotation::rotate([0.,0.,1.],[0.;3],controls.pitch_degrees)?;let focus=controls.focus_after_update;let offset=f32::from_bits(OFFSET_SCALE);
    let mut eye=[distance*f32::from_bits(ZERO)+focus[0],(-pitch[1]*offset)*distance+focus[1],(-pitch[2]*offset)*distance+focus[2]];
    let yaw=controls.yaw_degrees-controls.previous_yaw_degrees;
    if yaw.abs()>f32::from_bits(YAW_THRESHOLD) {
        let relative=std::array::from_fn::<_,3,_>(|i|eye[i]-focus[i]);let squared=(relative[1]*relative[1]+relative[0]*relative[0])+relative[2]*relative[2];
        // Original5FA7C0 square root is refined RSQRT multiplied by its input, with a zero mask.
        let length=if squared==0. {0.} else {crate::audio_emitter_planes::reciprocal_sqrt(squared)?*squared};
        let mut relative=normalized(relative,squared)?;let [sin,cos]=crate::camera_rotation::coefficients(yaw);
        let z=relative[2]*cos-relative[0]*sin;let x=relative[0]*cos+relative[2]*sin;relative[0]=x;relative[2]=z;
        eye=std::array::from_fn(|i|relative[i]*length+focus[i]);
    }
    let direction=std::array::from_fn::<_,3,_>(|i|focus[i]-eye[i]);let squared=(direction[0]*direction[0]+direction[1]*direction[1])+direction[2]*direction[2];
    let mut camera=*initial;camera.position=eye;camera.direction=normalized(direction,squared)?;camera.fov_degrees=controls.fov_degrees;camera.projection_raw=0;
    Ok(Assembly{camera,zoom,distance})
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_640_original_normal_camera_assemblies_after_supplied_focus_update() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_normal_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),640);
        for (case_index,c) in cases.iter().enumerate() {
            let bits=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u32;
            let zoom=Zoom{smooth_time:f32::from_bits(bits("initial_zoom_bits",0)),epsilon:f32::from_bits(bits("initial_zoom_bits",1)),scale_raw:bits("initial_zoom_bits",2),velocity:f32::from_bits(bits("initial_zoom_bits",3)),current:f32::from_bits(bits("initial_zoom_bits",4)),target:f32::from_bits(bits("initial_zoom_bits",5))};
            let controls=Controls{focus_after_update:std::array::from_fn(|i|c["focus"][i].as_f64().unwrap() as f32),pitch_degrees:c["pitch"].as_f64().unwrap() as f32,yaw_degrees:c["yaw"].as_f64().unwrap() as f32,previous_yaw_degrees:c["previous_yaw"].as_f64().unwrap() as f32,fov_degrees:c["fov"].as_f64().unwrap() as f32,zoom};
            let mut initial=Parameters::original_initial([0.;3]);initial.projection_raw=2;
            let result=assemble_after_focus(&initial,&controls,f32::from_bits(c["delta_bits"].as_u64().unwrap() as u32)).unwrap();assert_eq!(result.distance.to_bits(),c["distance_bits"].as_u64().unwrap() as u32,"case{case_index}distance");
            let zoom=result.zoom;let zoom_words=[zoom.smooth_time.to_bits(),zoom.epsilon.to_bits(),zoom.scale_raw,zoom.velocity.to_bits(),zoom.current.to_bits(),zoom.target.to_bits()];for i in 0..6 {assert_eq!(zoom_words[i],bits("output_zoom_bits",i),"case{case_index}zoom{i}");}
            let camera=result.camera;let words=[camera.position[0].to_bits(),camera.position[1].to_bits(),camera.position[2].to_bits(),camera.near.to_bits(),camera.far.to_bits(),camera.direction[0].to_bits(),camera.direction[1].to_bits(),camera.direction[2].to_bits(),camera.up[0].to_bits(),camera.up[1].to_bits(),camera.up[2].to_bits(),camera.fov_degrees.to_bits(),camera.projection_raw,camera.width.to_bits(),camera.height.to_bits(),camera.auxiliary_raw];
            for i in 0..16 {
                if matches!(i,0|1|2|5|6|7) {let actual=f32::from_bits(words[i]);let original=f32::from_bits(bits("output_camera_bits",i));assert!((actual-original).abs()<=1e-5_f32.max(original.abs()*2e-6),"case{case_index}field{i}: {actual} vs{original}");}
                else {assert_eq!(words[i],bits("output_camera_bits",i),"case{case_index}field{i}");}
            }
        }
    }
}

const DISTANCE_FACTOR:u32=976143166;
const OFFSET_SCALE:u32=1142292480;
const ZERO:u32=0;
const YAW_THRESHOLD:u32=925353388;
const NORMALIZATION_THRESHOLD:u32=814313567;
