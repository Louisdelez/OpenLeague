//! Native 4.20 listener position, direction rotation/cache and projected up.
pub const DEFAULT_LISTENER_HEIGHT: f32 = 500.0;
pub const DEFAULT_LISTENER_ANGLE: f32 = 0.0;
/// Original normal-mode view extraction: normalize focus minus render eye.
/// Camera shake/finalization and construction of the render eye are separate.
pub fn direction_from_positions(eye:[f32;3],focus:[f32;3])->Result<[f32;3],&'static str> {
    if eye.iter().chain(focus.iter()).any(|v| !v.is_finite()) {
        return Err("invalid camera position");
    }
    native_normalize([focus[0]-eye[0],focus[1]-eye[1],focus[2]-eye[2]])
}


/// Original cross products project world up onto the plane perpendicular to
/// the cached forward. Parallel/zero directions keep the native zero result.
/// This does not reproduce the camera rotation or its orientation cache.
pub fn projected_up(forward: [f32; 3]) -> Result<[f32; 3], &'static str> {
    if forward.iter().any(|v| !v.is_finite()) { return Err("invalid cached forward"); }
    let cross = |a:[f32;3],b:[f32;3]| [
        a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0],
    ];
    native_normalize(cross(cross(forward,[0.0,1.0,0.0]),forward))
}

fn native_normalize(mut up:[f32;3]) -> Result<[f32;3], &'static str> {
    let squared=(up[0]*up[0]+up[1]*up[1])+up[2]*up[2];
    if !squared.is_finite() { return Err("listener normalization overflow"); }
    if squared > 1e-9 {
        // SSE is baseline on x86_64. Native 66d6e0 refines its reciprocal
        // square-root estimate with the same single-precision operations.
        #[cfg(target_arch="x86_64")]
        let estimate=unsafe {std::arch::x86_64::_mm_cvtss_f32(std::arch::x86_64::_mm_rsqrt_ss(std::arch::x86_64::_mm_set_ss(squared)))};
        #[cfg(target_arch="x86")]
        let estimate=unsafe {std::arch::x86::_mm_cvtss_f32(std::arch::x86::_mm_rsqrt_ss(std::arch::x86::_mm_set_ss(squared)))};
        #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
        return Err("native reciprocal square root unsupported on this architecture");
        #[cfg(any(target_arch="x86",target_arch="x86_64"))]
        {
            let factor=(3.0-(estimate*squared)*estimate)*(estimate*0.5);
            for component in &mut up {*component *= factor;}
        }
    }
    Ok(up)
}

#[derive(Debug,Clone,Copy)]
pub struct DirectionCache {
    previous_input:[f32;3],
    previous_forward:[f32;3],
}
impl DirectionCache {
    /// Restore the native previous-input and computed-forward cache state.
    pub fn new(previous_input:[f32;3],previous_forward:[f32;3]) -> Result<Self,&'static str> {
        if previous_input.iter().chain(previous_forward.iter()).any(|v|!v.is_finite()) {
            return Err("invalid listener direction cache");
        }
        Ok(Self {previous_input,previous_forward})
    }
    pub fn previous_input(&self)->[f32;3] {self.previous_input}
    /// Native cache comparison ignores angle-only changes. Table indices use
    /// separate f32 truncation for angle*10 and (90-angle)*10, wrapping at3600.
    pub fn update(&mut self,input:[f32;3],angle_degrees:f32)->Result<[f32;3],&'static str> {
        if input.iter().any(|v|!v.is_finite()) {return Err("invalid listener direction");}
        if input.iter().zip(self.previous_input).all(|(a,b)|(*a-b).abs()<=1e-5) {
            return Ok(self.previous_forward);
        }
        if !angle_degrees.is_finite() || angle_degrees.abs()>1_000_000.0 {
            return Err("unsupported listener angle");
        }
        static TABLE:std::sync::OnceLock<Vec<f32>>=std::sync::OnceLock::new();
        let table=TABLE.get_or_init(|| {
            #[derive(serde::Deserialize)] struct Contract {sin_table:Vec<f32>}
            let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_contract.json")).expect("native listener table");
            assert_eq!(c.sin_table.len(),3600);
            c.sin_table
        });
        let index=|scaled:f32| (scaled.trunc() as i32).rem_euclid(3600) as usize;
        let sine=table[index(angle_degrees*10.0)];
        let cosine=table[index((90.0-angle_degrees)*10.0)];
        let forward=native_normalize([
            input[0],cosine*input[1]-sine*input[2],sine*input[1]+cosine*input[2],
        ])?;
        self.previous_input=input;
        self.previous_forward=forward;
        Ok(forward)
    }
}

#[derive(Debug, Default, Clone, Copy, PartialEq)]
pub struct ListenerPosition {
    pub current: Option<[f32; 3]>,
}
impl ListenerPosition {
    /// Source coordinates are the original camera-related position fields,
    /// in native units. The listener replaces only their vertical component.
    /// Frozen updates retain the last position and issue no backend command.
    pub fn update(&mut self, source: [f32; 3], height: f32, frozen: bool)
        -> Result<Option<[f32; 3]>, &'static str> {
        if frozen { return Ok(None); }
        if !height.is_finite() || source.iter().any(|v| !v.is_finite()) {
            return Err("invalid native listener position");
        }
        let position=[source[0],height,source[2]];
        self.current=Some(position);
        Ok(Some(position))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde::Deserialize;

    #[test]
    fn camera_view_direction_matches_original_extraction() {
        #[derive(Deserialize)] struct Sample {eye:[f32;3],focus:[f32;3],native_direction:[f32;3]}
        #[derive(Deserialize)] struct Contract {cases:Vec<Sample>,native_default_audio_angle:f32}
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_direction_contract.json")).unwrap();
        assert_eq!(c.cases.len(),8);
        assert_eq!(c.native_default_audio_angle,DEFAULT_LISTENER_ANGLE);
        for sample in c.cases {
            let actual=direction_from_positions(sample.eye,sample.focus).unwrap();
            for i in 0..3 {assert!((actual[i]-sample.native_direction[i]).abs()<=1e-6);}
        }
    }
    #[test]
    fn camera_direction_rejects_nonfinite_and_overflow() {
        assert!(direction_from_positions([f32::NAN;3],[0.;3]).is_err());
        assert!(direction_from_positions([f32::MAX;3],[-f32::MAX;3]).is_err());
    }
    #[test]
    fn camera_rotation_and_cache_match_all_original_sequences() {
        #[derive(Deserialize)] struct Step {input:[f32;3],angle_degrees:f32,native_forward:[f32;3],native_up:[f32;3],cache_input:[f32;3]}
        #[derive(Deserialize)] struct Case {initial_input:[f32;3],initial_forward:[f32;3],steps:Vec<Step>}
        #[derive(Deserialize)] struct Contract {rotation_cases:Vec<Case>}
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_contract.json")).unwrap();
        assert_eq!(c.rotation_cases.len(),36);
        let mut steps=0;
        for case in c.rotation_cases {
            let mut cache=DirectionCache::new(case.initial_input,case.initial_forward).unwrap();
            for sample in case.steps {
                steps+=1;
                let forward=cache.update(sample.input,sample.angle_degrees).unwrap();
                let up=projected_up(forward).unwrap();
                for i in 0..3 {
                    assert!((forward[i]-sample.native_forward[i]).abs()<=1e-6,"{:?}/{} forward {:?} != {:?}",sample.input,sample.angle_degrees,forward,sample.native_forward);
                    assert!((up[i]-sample.native_up[i]).abs()<=1e-6,"up {:?} != {:?}",up,sample.native_up);
                }
                assert_eq!(cache.previous_input(),sample.cache_input);
            }
        }
        assert_eq!(steps,144);
    }

    #[test]
    fn cache_keeps_angle_only_changes_and_failed_update_is_atomic() {
        let mut c=DirectionCache::new([0.0;3],[0.0;3]).unwrap();
        let first=c.update([0.0,0.0,1.0],0.0).unwrap();
        assert_eq!(c.update([0.0,0.0,1.0],90.0).unwrap(),first);
        assert_eq!(c.update([0.0,0.0,1.0],f32::NAN).unwrap(),first);
        assert!(c.update([1.0,0.0,1.0],f32::NAN).is_err());
        assert_eq!(c.previous_input(),[0.0,0.0,1.0]);
        assert!(c.update([f32::MAX,0.0,1.0],0.0).is_err());
        assert_eq!(c.previous_input(),[0.0,0.0,1.0]);
    }

    #[test]
    fn projected_up_matches_original_cached_forward_execution() {
        #[derive(Deserialize)] struct Case {cached_forward:[f32;3],native_up:[f32;3]}
        #[derive(Deserialize)] struct Contract {orientation_cases:Vec<Case>}
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_contract.json")).unwrap();
        assert_eq!(c.orientation_cases.len(),11);
        for sample in c.orientation_cases {
            let actual=projected_up(sample.cached_forward).unwrap();
            for i in 0..3 {assert!((actual[i]-sample.native_up[i]).abs()<=1e-6,"{:?}: {:?} != {:?}",sample.cached_forward,actual,sample.native_up);}
        }
    }

    #[test]
    fn degenerate_forward_keeps_native_zero_up_and_invalid_input_is_rejected() {
        assert_eq!(projected_up([0.0,1.0,0.0]).unwrap(),[0.0;3]);
        assert_eq!(projected_up([0.0;3]).unwrap(),[0.0;3]);
        assert!(projected_up([f32::NAN,0.0,1.0]).is_err());
        assert!(projected_up([f32::MAX,1.0,1.0]).is_err());
    }

    #[test]
    fn matches_original_stable_orientation_listener_positions() {
        #[derive(Deserialize)] struct Call {position:[f32;3],listener_index:u32}
        #[derive(Deserialize)] struct Case {source_position:[f32;3],listener_height:f32,frozen:bool,calls:Vec<Call>}
        #[derive(Deserialize)] struct Contract {default_listener_height:f32,cases:Vec<Case>}
        let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_listener_contract.json")).unwrap();
        assert_eq!(c.default_listener_height,DEFAULT_LISTENER_HEIGHT);
        assert_eq!(c.cases.len(),24);
        let mut updates=0;
        for sample in c.cases {
            let mut state=ListenerPosition::default();
            let actual=state.update(sample.source_position,sample.listener_height,sample.frozen).unwrap();
            assert_eq!(actual.into_iter().collect::<Vec<_>>(),sample.calls.iter().map(|c|c.position).collect::<Vec<_>>());
            assert_eq!(state.current,actual);
            updates+=sample.calls.len();
            for call in sample.calls {assert_eq!(call.listener_index,0);}
        }
        assert_eq!(updates,12);
    }

    #[test]
    fn freezing_retains_last_position_then_unfreezing_updates_horizontal_coordinates() {
        let mut s=ListenerPosition::default();
        s.update([100.0,2400.0,500.0],DEFAULT_LISTENER_HEIGHT,false).unwrap();
        assert_eq!(s.current,Some([100.0,500.0,500.0]));
        assert!(s.update([200.0,3200.0,900.0],1000.0,true).unwrap().is_none());
        assert_eq!(s.current,Some([100.0,500.0,500.0]));
        assert_eq!(s.update([200.0,3200.0,900.0],1000.0,false).unwrap(),Some([200.0,1000.0,900.0]));
    }

    #[test]
    fn invalid_position_is_atomic_and_frozen_updates_do_not_inspect_inputs() {
        let mut s=ListenerPosition {current:Some([1.0,500.0,2.0])};
        assert!(s.update([f32::NAN,0.0,0.0],500.0,false).is_err());
        assert!(s.update([0.0,0.0,0.0],f32::INFINITY,false).is_err());
        assert_eq!(s.current,Some([1.0,500.0,2.0]));
        assert!(s.update([f32::NAN;3],f32::INFINITY,true).unwrap().is_none());
        assert_eq!(s.current,Some([1.0,500.0,2.0]));
    }
}
