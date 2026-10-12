//! Bounded native93F353/93F908/93F9EB finish conditions, not a whole particle tick.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Gate {pub flags:u8,pub suppressed:bool}
pub fn lifetime_gate(flags:u8,predicate_raw:u8,property_flags:u8,source_flags:u8,clock:f32,birth:f32,lifetime:f32)->Gate {
    let suppressed=(predicate_raw!=0 || property_flags&0x40!=0) && flags&8==0;
    let elapsed=clock-birth;
    let expired=flags&1==0 && property_flags&2==0 && source_flags&1==0 && elapsed>=lifetime;
    let flags=if flags&2==0 && !suppressed && (flags&0x10!=0 || expired) {flags|2} else {flags};
    Gate{flags,suppressed}
}
/// First group uses native child byteC, second group byte8. Only bit0 matters.
pub fn fold_children(flags:u8,first_raw:&[u8],second_raw:&[u8])->u8 {
    if first_raw.iter().chain(second_raw).all(|value|value&1!=0) {flags|2} else {flags&!2}
}
pub fn final_guard(flags:u8)->u8 {
    if flags&1!=0 && flags&0x10==0 {flags&!2} else {flags}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_2448_native_duration_cases_with_nan_and_active_guard() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_finish_contract.json")).unwrap();let cases=proof["gate_cases"].as_array().unwrap();assert_eq!(cases.len(),2448);
        for c in cases {
            let age=if c["age"].as_str()==Some("NaN") {f32::NAN} else {c["age"].as_f64().unwrap() as f32};
            let gate=lifetime_gate(c["flags"].as_u64().unwrap() as u8,c["predicate_raw"].as_u64().unwrap() as u8,c["property_flags"].as_u64().unwrap() as u8,c["source_flags"].as_u64().unwrap() as u8,age,0.,1.);
            assert_eq!(gate.flags,c["gate_flags"].as_u64().unwrap() as u8,"{c}");assert_eq!(gate.suppressed,c["suppressed_raw"].as_u64().unwrap()!=0,"{c}");assert_eq!(final_guard(gate.flags),c["final_flags"].as_u64().unwrap() as u8,"{c}");
        }
    }
    #[test]
    fn matches_343_native_child_status_folds_without_normalizing_raw_bytes() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_finish_contract.json")).unwrap();let cases=proof["children_cases"].as_array().unwrap();assert_eq!(cases.len(),343);
        let bytes=|v:&serde_json::Value|->Vec<u8>{v.as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u8).collect()};
        for c in cases {
            let flags=fold_children(c["flags"].as_u64().unwrap() as u8,&bytes(&c["first_raw"]),&bytes(&c["second_raw"]));assert_eq!(flags,c["folded_flags"].as_u64().unwrap() as u8,"{c}");assert_eq!(final_guard(flags),c["final_flags"].as_u64().unwrap() as u8,"{c}");
        }
    }
}
