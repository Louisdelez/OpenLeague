//! Native Simple system stop state (93FA10); manager/audio callbacks are separate.
use crate::simple_cycle::OwnerEnd;

pub struct SimpleSystemState {
    pub flags: u8,
    pub start_time: f32,
    pub stop_time: f32,
}
impl SimpleSystemState {
    pub fn stop(&mut self, now: f32) -> Result<bool, &'static str> {
        if !now.is_finite() || !self.start_time.is_finite() || now < self.start_time {
            return Err("unsupported native particle system stop time");
        }
        //93FA1F: an already-stopped system preserves all fields.
        if self.flags & 0x40 != 0 { return Ok(false); }
        //93FA2C/34: clear persistent bit0, set owner-end bit4 and stopped bit6.
        self.flags = (self.flags & 0xfe) | 0x50;
        self.stop_time = now;
        Ok(true)
    }
    pub fn owner_end(&self, emitter_linger:f32, particle_linger:f32)->Option<OwnerEnd> {
        (self.flags & 0x10 != 0).then_some(OwnerEnd {
            system_start:self.start_time, emitter_linger, particle_linger,
        })
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn all_native_stop_flags_preserve_start_and_repeat_stop_timestamp() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particle_stop_contract.json")).unwrap();
        for case in proof["cases"].as_array().unwrap() {
            let flags=case["initial_flags"].as_u64().unwrap() as u8;
            let mut system=SimpleSystemState {flags,start_time:10.,stop_time:9.};
            let now=case["now"].as_f64().unwrap() as f32;
            assert_eq!(system.stop(now).unwrap(),!case["returned"].as_bool().unwrap());
            assert_eq!(system.flags,case["flags"].as_u64().unwrap() as u8);
            assert_eq!(system.start_time,case["system_start"].as_f64().unwrap() as f32);
            assert_eq!(system.stop_time,case["stop_time"].as_f64().unwrap() as f32);
            let stop_time=system.stop_time;
            assert!(!system.stop(now+1.).unwrap());
            assert_eq!(system.stop_time,stop_time);
            assert_eq!(system.owner_end(0.,0.).is_some(),system.flags&0x10!=0);
        }
    }
    #[test]
    fn native_stop_state_drives_original_fifty_emitter_frames() {
        use crate::simple_cycle::SingleParticleCycle;
        use bevy::prelude::*;
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_end_contract.json")).unwrap();
        let floats=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect::<Vec<_>>();
        for case in proof["cases"].as_array().unwrap() {
            let frames=case["frames"].as_array().unwrap();
            let pose=Mat4::from_cols_array(&floats(&frames[0]["previous_matrix"]).try_into().unwrap());
            let mut cycle=SingleParticleCycle::new(10.,2.,1.,Vec3::new(100.,200.,300.),pose,Vec2::ZERO,true,false).unwrap();
            let mut system=SimpleSystemState {flags:1,start_time:10.,stop_time:0.};
            for frame in frames {
                let now=10.+frame["age"].as_f64().unwrap() as f32;
                if frame["owner_end_flag"].as_bool().unwrap() {system.stop(now).unwrap();}
                let end=system.owner_end(case["emitter_linger"].as_f64().unwrap() as f32,case["particle_linger"].as_f64().unwrap() as f32);
                let pose=Mat4::from_cols_array(&floats(&frame["previous_matrix"]).try_into().unwrap());
                cycle.step_with_owner_end(now,pose,end.as_ref()).unwrap();
                assert_eq!(cycle.normalized_age.to_bits(),frame["normalized_age_bits"][0].as_u64().unwrap() as u32);
                assert_eq!(cycle.position,Vec3::from_slice(&floats(&frame["position"])));
                assert_eq!(cycle.active_count,frame["active_count"].as_u64().unwrap() as u32);
                assert_eq!(cycle.finished,frame["emitter_finished"]==1);
            }
            assert_eq!(system.stop_time,10.5);
        }
    }
}
