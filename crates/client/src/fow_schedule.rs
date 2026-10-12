//! Qualified source priority and per-frame work budget from native6B3FA0.
//! Caller entity eligibility, camera/clock production and registration remain open.
#[derive(Default)]
pub struct FrameBudget {pub smoothed_delta:f32}
impl FrameBudget {
    pub fn work_count(&mut self,delta:f32,pending:usize)->Result<usize,&'static str> {
        if !delta.is_finite() || delta<=0. || !self.smoothed_delta.is_finite() || self.smoothed_delta<0. {return Err("unqualified fog frame timing");}
        self.smoothed_delta=(self.smoothed_delta*9.+delta)*0.1;
        let periods=(f64::from(0.2_f32)/f64::from(self.smoothed_delta)).ceil() as usize;
        Ok(if periods==0 {pending}else{(pending/periods).max(1).min(pending)})
    }
}
pub fn needs_update(force:bool,refresh_frames:i32,dirty:bool,applied:bool,pending:bool)->bool {
    (force || refresh_frames>0 || dirty || !applied) && !pending
}
#[cfg(target_arch="x86_64")]
fn native_distance_squared_root(value:f32)->f32 {
    use std::arch::x86_64::*;
    // Original5FA7C0 uses RSQRTSS followed by one ordered Newton refinement.
    unsafe {
        let x=_mm_set_ss(value);let mut inverse=_mm_rsqrt_ss(x);
        let factor=_mm_sub_ss(_mm_set_ss(3.),_mm_mul_ss(_mm_mul_ss(inverse,x),inverse));
        inverse=_mm_mul_ss(inverse,_mm_set_ss(0.5));
        let result=_mm_mul_ss(_mm_mul_ss(factor,inverse),x);
        _mm_cvtss_f32(_mm_and_ps(result,_mm_cmpneq_ss(_mm_setzero_ps(),x)))
    }
}
pub fn priority(center:[f32;2],camera:[f32;2],effective_radius:f64,extent:f32,now:f32)->Result<f32,&'static str> {
    if !center.into_iter().chain(camera).all(f32::is_finite) || !effective_radius.is_finite() || !extent.is_finite() || extent<=0. || !now.is_finite() {return Err("unqualified fog source priority inputs");}
    #[cfg(not(target_arch="x86_64"))] {return Err("native fog distance requires qualified x86_64 implementation");}
    #[cfg(target_arch="x86_64")] {
        let dx=center[0]-camera[0];let dz=center[1]-camera[1];let distance=native_distance_squared_root(dx*dx+dz*dz);
        let edge_distance=(f64::from(distance)-(effective_radius-1500.)) as f32;
        let normalized=if edge_distance<0. {0.}else{edge_distance/extent};
        Ok(now.floor()+normalized)
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_priority_gates_and_frame_budget_match_original_full_update() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_frame_schedule_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),576);
        for c in proof["cases"].as_array().unwrap() {
            let should_enqueue=needs_update(c["force"].as_bool().unwrap(),0,c["dirty"].as_bool().unwrap(),c["initial_applied"].as_bool().unwrap(),false);
            let mut pending=crate::fow_pending::PendingSources::default();
            if should_enqueue {for (source,center) in [[0.,0.],[1000.,0.],[10000.,10000.]].into_iter().enumerate() {
                let value=priority(center,[0.,0.],c["radius"].as_f64().unwrap(),15398.671875,c["now"].as_f64().unwrap() as f32).unwrap();
                pending.push(crate::fow_pending::Entry {source,priority_bits:value.to_bits()});
            }}
            let compare=|actual:&[crate::fow_pending::Entry],expected:&serde_json::Value| {
                assert_eq!(actual.len(),expected.as_array().unwrap().len(),"queue length {c}");
                for (entry,expected) in actual.iter().zip(expected.as_array().unwrap()) {
                    assert_eq!(entry.source,expected["identity"].as_u64().unwrap() as usize,"order {c}");
                    let native=f32::from_bits(expected["priority_bits"].as_u64().unwrap() as u32);
                    assert!((f32::from_bits(entry.priority_bits)-native).abs()<=0.000001,"priority {entry:?} native {native} {c}");
                }
            };
            compare(pending.entries(),&c["before_processing"]["pending"]);
            let mut budget=FrameBudget {smoothed_delta:c["previous_delta"].as_f64().unwrap() as f32};
            let count=budget.work_count(c["delta"].as_f64().unwrap() as f32,pending.entries().len()).unwrap();
            assert_eq!(budget.smoothed_delta.to_bits(),c["smoothed_delta_bits"].as_u64().unwrap() as u32);
            let generated:Vec<usize>=(0..count).map(|_|pending.pop().unwrap().source).collect();
            let expected:Vec<usize>=c["generated"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();
            assert_eq!(generated,expected,"frame work {c}");compare(pending.entries(),&c["pending_after"]);
        }
    }
}
