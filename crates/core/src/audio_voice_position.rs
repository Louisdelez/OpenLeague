//! Native6F61E0 initial voice position, distinct from later emitter XYZ updates.
pub const SENTINEL:f32=f32::MAX;
/// Query returns Some(global2D78BAC) when engine virtual70 enables height override,
/// None otherwise. The actual engine policy must be supplied, never guessed.
pub fn prepare(mut position:[f32;3],mode_raw:u8,mut height_policy:impl FnMut()->Option<f32>)
    ->Result<[f32;3],&'static str> {
    if position.iter().any(|x| !x.is_finite()) {return Err("invalid initial voice position");}
    if position==[SENTINEL;3] {return Ok(position);}
    if mode_raw==0 {position[1]=-2500.;}
    else if let Some(height)=height_policy() {
        if !height.is_finite() {return Err("invalid voice height policy");}
        position[1]=height;
    }
    Ok(position)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_72_original_voice_position_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_position_contract.json")).unwrap();
        assert_eq!(data["sentinel_bits"].as_u64().unwrap() as u32,SENTINEL.to_bits());
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),72);
        for case in cases {
            let input=std::array::from_fn(|i|f32::from_bits(case["input_bits"][i].as_u64().unwrap() as u32));
            let height=f32::from_bits(case["height_bits"].as_u64().unwrap() as u32);
            let enabled=case["engine_height_override"].as_bool().unwrap();let mut queries=0;
            let result=prepare(input,case["mode_raw"].as_u64().unwrap() as u8,|| {queries+=1;enabled.then_some(height)}).unwrap();
            let expected:Vec<u32>=case["output_bits"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(result.map(f32::to_bits).as_slice(),expected);assert_eq!(queries,case["engine_queries"].as_u64().unwrap());
        }
    }
    #[test]
    fn only_initial_preparation_applies_height_policy_and_unused_policy_is_not_queried() {
        let input=[7400.,1500.,7700.];let initial=prepare(input,1,||Some(500.)).unwrap();assert_eq!(initial,[7400.,500.,7700.]);
        let update=crate::audio_emitter_position::dispatch(Some(crate::audio_routing::VoiceRoute {object_id:123,actor_id:0}),true,input).unwrap();
        assert_eq!(update.position_update.unwrap().position,input);
        assert_eq!(prepare([SENTINEL;3],255,||panic!("sentinel must not query")).unwrap(),[SENTINEL;3]);
        assert_eq!(prepare(input,0,||panic!("mode0 must not query")).unwrap(),[7400.,-2500.,7700.]);
        assert!(prepare(input,1,||Some(f32::NAN)).is_err());assert!(prepare([f32::INFINITY,0.,0.],1,||None).is_err());
    }
}
