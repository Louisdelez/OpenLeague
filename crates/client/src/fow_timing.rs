//! Native fade preparation and cadence at 6B5450 / 6B57A0.
//! Driver commits previous time and first-frame state only after a successful draw.
pub const FADE_INTERVAL:f32=f32::from_bits(1023960469);
pub struct FadeStep {pub elapsed:f32,pub next_previous:f32,pub parameters:[f32;4]}

pub fn fade_parameters(elapsed:f32,first_frame:bool)->Result<[f32;4],&'static str> {
    if !elapsed.is_finite() || elapsed<0. {return Err("invalid fog elapsed time");}
    Ok([elapsed*2.,elapsed*0.5,0.,if first_frame {0.} else {1.1}])
}
pub fn prepare_fade(now:f32,previous:f32,first_frame:bool)->Result<Option<FadeStep>,&'static str> {
    if !now.is_finite() || !previous.is_finite() || now<0. || previous<0. || now<previous {return Err("invalid fog frame clock");}
    let elapsed=now-previous;
    if elapsed<=FADE_INTERVAL {return Ok(None);}
    // Native elapsed is rounded by SUBSS, then x87 computes the remainder and
    // subtracts it from the original clock before storing the result as f32.
    let remainder=(elapsed as f64)%(FADE_INTERVAL as f64);
    Ok(Some(FadeStep {elapsed,next_previous:((now as f64)-remainder) as f32,parameters:fade_parameters(elapsed,first_frame)?}))
}

/// Native 6B5080 gate. Caller records current time after its upload attempt;
/// this predicate does not mutate either timestamp.
pub fn upload_due(now:f32,previous:f32)->Result<bool,&'static str> {
    if !now.is_finite() || !previous.is_finite() || now<0. || previous<0. || now<previous {return Err("invalid fog upload clock");}
    Ok(now-previous>0.2)
}


/// Qualified missing-texture/interface paths only. A valid interface reporting
/// LockRect failure is a separate native contract, not covered by this helper.
pub fn missing_interface_timestamp(now:f32,previous:f32,upscale:bool,target_present:bool)->Result<f32,&'static str> {
    let due=upload_due(now,previous)?;
    Ok(if due && upscale && target_present {now}else{previous})
}

#[cfg(test)]
mod tests {
    use super::*;


    #[test] fn missing_interface_time_matches_both_original_uploaders() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_missing_upload_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let actual=missing_interface_timestamp(c["now"].as_f64().unwrap() as f32,c["previous"].as_f64().unwrap() as f32,c["upscale"].as_bool().unwrap(),c["target_present"].as_bool().unwrap()).unwrap();
            assert_eq!(actual.to_bits(),(c["after"].as_f64().unwrap() as f32).to_bits());
        }
    }
    #[test] fn upload_gate_matches_native_strict_interval_and_clock_precision() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upload_cadence_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            assert_eq!(upload_due(c["now"].as_f64().unwrap() as f32,c["previous"].as_f64().unwrap() as f32).unwrap(),c["ready"].as_bool().unwrap());
        }
        assert!(upload_due(f32::INFINITY,0.).is_err());assert!(upload_due(0.,1.).is_err());
    }
    #[test] fn parameters_match_native_first_frame_and_fade_rates() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_fade_parameters_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let p=fade_parameters(c["delta"].as_f64().unwrap() as f32,c["first_frame"].as_bool().unwrap()).unwrap();
            for (i,actual) in p.iter().enumerate() {assert_eq!(actual.to_bits(),(c["parameters"][i].as_f64().unwrap() as f32).to_bits());}
        }
    }
    #[test] fn scheduling_boundary_and_remainder_match_original_x87_helper() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_cadence_contract.json")).unwrap();
        assert_eq!(FADE_INTERVAL.to_bits(),proof["interval_bits"].as_u64().unwrap() as u32);
        for c in proof["cases"].as_array().unwrap() {
            let step=prepare_fade(c["now"].as_f64().unwrap() as f32,c["previous"].as_f64().unwrap() as f32,false).unwrap();
            assert_eq!(step.is_some(),c["ready"].as_bool().unwrap());
            if let Some(step)=step {assert_eq!(step.elapsed.to_bits(),(c["elapsed"].as_f64().unwrap() as f32).to_bits());assert_eq!(step.next_previous.to_bits(),(c["new_previous"].as_f64().unwrap() as f32).to_bits());}
        }
    }
    #[test] fn invalid_clock_is_explicit_and_first_frame_snaps_visibility() {
        assert!(prepare_fade(f32::NAN,0.,true).is_err());assert!(prepare_fade(0.,1.,false).is_err());assert!(fade_parameters(f32::INFINITY,false).is_err());
        let first=fade_parameters(0.1,true).unwrap();let normal=fade_parameters(0.1,false).unwrap();
        assert_eq!(crate::fow_postprocess::fade(1.,0.,first),1.);
        assert_eq!(crate::fow_postprocess::fade(1.,0.,normal),0.2);
    }
}
