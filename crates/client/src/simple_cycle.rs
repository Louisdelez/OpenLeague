//! Native constant-life, zero-velocity Single particle frame sequence.
//! Upstream pose and owner-end flag/time producers remain prerequisites for activation.
use bevy::prelude::*;
use crate::simple_attachment;
/// Explicit native system fields supplied by the caller; not an inferred missile timer.
pub struct OwnerEnd {
    pub system_start:f32,
    pub emitter_linger:f32,
    pub particle_linger:f32,
}
pub struct SingleParticleCycle {
    pub position:Vec3,
    pub normalized_age:f32,
    pub particle_life:f32,
    pub active_count:u32,
    pub finished:bool,
    pub previous_pose:Mat4,
    pub previous_time:Option<f32>,
    birth:f32,
    emitter_life:f32,
    bind:Vec2,
    local:bool,
    locked:bool,
}
impl SingleParticleCycle {
    pub fn new(birth:f32,particle_life:f32,emitter_life:f32,position:Vec3,pose:Mat4,bind:Vec2,local:bool,locked:bool)->Result<Self,&'static str> {
        if ![birth,particle_life,emitter_life].iter().all(|x|x.is_finite()) || particle_life<=0. || emitter_life<=0. || !position.is_finite() || !pose.is_finite() || pose.determinant()==0. || !bind.is_finite() {return Err("unsupported native single cycle");}
        Ok(Self {position,normalized_age:0.,particle_life,active_count:0,finished:false,previous_pose:pose,previous_time:None,birth,emitter_life,bind,local,locked})
    }
    pub fn step(&mut self,now:f32,pose:Mat4,life_cap:f32)->Result<(),&'static str> {
        if !now.is_finite() || now<self.birth || self.previous_time.is_some_and(|t|now<t) || !pose.is_finite() || pose.determinant()==0. || !life_cap.is_finite() || life_cap<0. {return Err("unsupported native cycle update");}
        let previous_time=self.previous_time.unwrap_or(now);
        if (now-previous_time).abs()>f32::from_bits(953267991) {
            self.particle_life=self.particle_life.min(life_cap);
            self.normalized_age=(now-self.birth)/self.particle_life;
            self.active_count=u32::from(self.normalized_age<1.);
            // Native944600/944760 skip inactive ages, including +Infinity from a zero cap.
            if self.active_count!=0 {
                let p=simple_attachment::bind_position(self.position,self.normalized_age,self.bind,self.locked,self.previous_pose.w_axis.truncate(),pose.w_axis.truncate())?;
                self.position=simple_attachment::local_position(p,self.normalized_age,self.local,self.previous_pose.inverse(),pose)?;
            }
        }
        //943ADA refreshes the saved matrix/inverse every frame, after particle update.
        self.previous_pose=pose;
        self.previous_time=Some(now);
        self.finished=now-self.birth>self.emitter_life && self.active_count==0;
        Ok(())
    }
    pub fn step_with_owner_end(&mut self,now:f32,pose:Mat4,end:Option<&OwnerEnd>)->Result<(),&'static str> {
        let (expired,cap)=match end {
            None=>(now-self.birth>self.emitter_life,f32::MAX),
            Some(end)=>{
                if ![end.system_start,end.emitter_linger,end.particle_linger].iter().all(|x|x.is_finite()) || end.system_start>now || end.emitter_linger<0. || end.particle_linger<0. {
                    return Err("unsupported native owner-end fields");
                }
                //943814 uses age relative to the explicit system start, not time since flag change.
                let expired=now-end.system_start>end.emitter_linger;
                (expired,if expired {end.particle_linger} else {f32::MAX})
            }
        };
        self.step(now,pose,cap)?;
        self.finished=expired && self.active_count==0;
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn full_native_frame_sequence_matches_following_age_and_expiration() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_cycle_contract.json")).unwrap();
        assert_eq!(proof["birth_calls"],serde_json::json!([[10.,2.]]));
        let frames=proof["frames"].as_array().unwrap();
        let vec=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect::<Vec<_>>();
        let initial=Mat4::from_cols_array(&vec(&frames[0]["previous_matrix"]).try_into().unwrap());
        let mut cycle=SingleParticleCycle::new(10.,2.,1.,Vec3::new(100.,200.,300.),initial,Vec2::ZERO,true,false).unwrap();
        for frame in frames {
            let pose=Mat4::from_cols_array(&vec(&frame["previous_matrix"]).try_into().unwrap());
            cycle.step(10.+frame["age"].as_f64().unwrap() as f32,pose,f32::MAX).unwrap();
            assert_eq!(cycle.normalized_age,frame["normalized_age"][0].as_f64().unwrap() as f32);
            assert_eq!(cycle.position,Vec3::from_slice(&vec(&frame["position"])));
            assert_eq!(cycle.active_count,frame["active_count"].as_u64().unwrap() as u32);
            assert_eq!(cycle.finished,frame["emitter_finished"]==1);
            assert_eq!(cycle.previous_time.unwrap(),frame["last_update"].as_f64().unwrap() as f32);
            assert_eq!(cycle.particle_life,frame["life"][0].as_f64().unwrap() as f32);
        }
    }

    #[test]
    fn native_owner_end_caps_match_all_fifty_original_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_end_contract.json")).unwrap();
        let vec=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect::<Vec<_>>();
        for case in proof["cases"].as_array().unwrap() {
            let frames=case["frames"].as_array().unwrap();
            assert_eq!(case["birth_calls"],serde_json::json!([[10.,2.]]));
            let pose=Mat4::from_cols_array(&vec(&frames[0]["previous_matrix"]).try_into().unwrap());
            let mut cycle=SingleParticleCycle::new(10.,2.,1.,Vec3::new(100.,200.,300.),pose,Vec2::ZERO,true,false).unwrap();
            let end=OwnerEnd {system_start:10.,emitter_linger:case["emitter_linger"].as_f64().unwrap() as f32,particle_linger:case["particle_linger"].as_f64().unwrap() as f32};
            for frame in frames {
                let pose=Mat4::from_cols_array(&vec(&frame["previous_matrix"]).try_into().unwrap());
                cycle.step_with_owner_end(10.+frame["age"].as_f64().unwrap() as f32,pose,frame["owner_end_flag"].as_bool().unwrap().then_some(&end)).unwrap();
                assert_eq!(cycle.normalized_age.to_bits(),frame["normalized_age_bits"][0].as_u64().unwrap() as u32);
                assert_eq!(cycle.position,Vec3::from_slice(&vec(&frame["position"])));
                assert_eq!(cycle.active_count,frame["active_count"].as_u64().unwrap() as u32);
                assert_eq!(cycle.finished,frame["emitter_finished"]==1);
                assert_eq!(cycle.particle_life,frame["life"][0].as_f64().unwrap() as f32);
                assert_eq!(cycle.previous_time.unwrap(),frame["last_update"].as_f64().unwrap() as f32);
            }
        }
    }
}
