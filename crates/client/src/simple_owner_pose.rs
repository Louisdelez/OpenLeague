//! Original921F20/921F60 owner pose inputs; provider identity remains separate.
use bevy::prelude::*;
pub struct SimpleOwnerPose {
    pub position:Vec3,
    pub orientation:Mat4,
    pub bounds_min:Vec3,
    pub bounds_max:Vec3,
}
impl SimpleOwnerPose {
    pub fn new(position:Vec3,mut orientation:Mat4,extent:f32)->Result<Self,&'static str> {
        if !position.is_finite() || !orientation.is_finite() || !extent.is_finite() || extent<0. {
            return Err("unsupported native owner pose inputs");
        }
        //921F20 preserves all matrix components except translationXYZ.
        orientation.w_axis=Vec4::new(0.,0.,0.,orientation.w_axis.w);
        //921F60 uses extent*sqrt(0.5), then min+2*radius, preserving native rounding.
        let radius=extent*f32::from_bits(0x3f3504f3);
        let bounds_min=position-Vec3::splat(radius);
        let bounds_max=bounds_min+Vec3::splat(radius*2.);
        if !bounds_min.is_finite() || !bounds_max.is_finite() {return Err("native owner bounds overflow");}
        Ok(Self {position,orientation,bounds_min,bounds_max})
    }
    pub fn emitter_matrix(&self,local:bool)->Result<Mat4,&'static str> {
        crate::simple_attachment::emitter_matrix(local,self.orientation,self.position)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/simple_owner_pose_contract.json")).unwrap()}
    fn floats(value:&serde_json::Value)->Vec<f32> {value.as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect()}
    #[test]
    fn pose_and_bounds_match_original_setters_with_translation_rotation_and_extents() {
        for case in proof()["cases"].as_array().unwrap() {
            let pose=SimpleOwnerPose::new(Vec3::from_slice(&floats(&case["position"])),Mat4::from_cols_array(&floats(&case["input_matrix"]).try_into().unwrap()),case["extent"].as_f64().unwrap() as f32).unwrap();
            assert_eq!(pose.position,Vec3::from_slice(&floats(&case["system_position"])));
            assert_eq!(pose.orientation,Mat4::from_cols_array(&floats(&case["system_orientation"]).try_into().unwrap()));
            let bounds=floats(&case["bounds"]);
            assert_eq!(pose.bounds_min,Vec3::from_slice(&bounds[..3]));
            assert_eq!(pose.bounds_max,Vec3::from_slice(&bounds[3..]));
        }
    }
    #[test]
    fn original_pose_setters_drive_complete_particle_frames() {
        use crate::simple_cycle::SingleParticleCycle;
        let proof=proof();let frames=proof["frames"].as_array().unwrap();
        let first=&frames[0];
        let initial=SimpleOwnerPose::new(Vec3::from_slice(&floats(&first["system_position"])),Mat4::from_cols_array(&floats(&first["system_orientation"]).try_into().unwrap()),500.).unwrap();
        let mut cycle=SingleParticleCycle::new(10.,2.,1.,initial.position,initial.emitter_matrix(true).unwrap(),Vec2::ZERO,true,false).unwrap();
        for frame in frames {
            let owner=SimpleOwnerPose::new(Vec3::from_slice(&floats(&frame["system_position"])),Mat4::from_cols_array(&floats(&frame["system_orientation"]).try_into().unwrap()),500.).unwrap();
            cycle.step(10.+frame["age"].as_f64().unwrap() as f32,owner.emitter_matrix(true).unwrap(),f32::MAX).unwrap();
            assert_eq!(cycle.position,Vec3::from_slice(&floats(&frame["position"])));
            assert_eq!(cycle.normalized_age,frame["normalized_age"][0].as_f64().unwrap() as f32);
            assert_eq!(cycle.active_count,frame["active_count"].as_u64().unwrap() as u32);
            assert_eq!(cycle.finished,frame["emitter_finished"]==1);
            assert_eq!(floats(&frame["current_scale"]),vec![500.]);
            assert_eq!(floats(&frame["current_rotation"]),vec![0.]);
        }
    }
}
