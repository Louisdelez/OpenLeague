//! Original938A5A/93949A/939B94 particle age, separate from emitter age.
use crate::native_complex_age::sse_result as sse;
#[derive(Debug,Copy,Clone)]
pub struct ParticleAge {pub elapsed:f32,pub normalized:f32}
/// Nonpositive or unordered life produces0. Positive life clamps ordered age to
/// [0,1], while a NaN time/birth propagates its payload through SSE arithmetic.
pub fn evaluate(time:f32,birth:f32,life:f32)->ParticleAge {
    let elapsed=sse(time,birth,|a,b|a-b);
    let normalized=if life>0. {
        let age=sse(elapsed,life,|a,b|a/b);
        if age>1. {1.} else if age<0. {0.} else {age}
    } else {0.};
    ParticleAge {elapsed,normalized}
}
/// Original93AE90 selection/loop order. Skip only ordered-equal frame time;
/// remove strictly after life, retaining unordered comparisons. Whole records
/// swap together so the replacement particle is examined at the same index.
/// Caller owns release side effects and the separate frame-time update.
pub fn remove_expired<T>(time:f32,last_update:f32,particles:&mut Vec<T>,mut birth_life:impl FnMut(&T)->(f32,f32),mut on_remove:impl FnMut(usize,&T))->usize {
    if time==last_update {return 0;}
    let mut index=0;let mut removed=0;
    while index<particles.len() {
        let (birth,life)=birth_life(&particles[index]);
        if sse(time,birth,|a,b|a-b)>life {
            on_remove(index,&particles[index]);
            particles.swap_remove(index);removed+=1;
        } else {index+=1;}
    }
    removed
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn movement_surface_and_color_age_match_original_ieee_branches() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_particle_age_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),560);
        for row in proof["cases"].as_array().unwrap() {
            let f=|key|f32::from_bits(bits(&row[key]));
            let age=evaluate(f("time"),f("birth"),f("life"));
            for kind in ["movement","surface","color"] {
                let output=&row["outputs"][kind];
                assert_eq!(age.elapsed.to_bits(),bits(&output["elapsed_bits"]),"{kind}: {row}");
                assert_eq!(age.normalized.to_bits(),bits(&output["normalized_bits"]),"{kind}: {row}");
            }
        }
    }
    #[test]
    fn expiry_threshold_frame_skip_and_swap_retry_match_original_loop() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_particle_expiry_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),240);
        for row in proof["cases"].as_array().unwrap() {
            let f=|v:&serde_json::Value|f32::from_bits(bits(v));
            let mut particles:Vec<(u32,f32,f32)>=row["initial"].as_array().unwrap().iter().map(|v|(v["id"].as_u64().unwrap() as u32,f(&v["birth"]),f(&v["life"]))).collect();
            let mut removed=Vec::new();
            let count=remove_expired(f(&row["time"]),f(&row["last_update"]),&mut particles,|p|(p.1,p.2),|index,p|removed.push(serde_json::json!({"index":index,"id":p.0})));
            assert_eq!(removed,row["removed"].as_array().unwrap().to_vec(),"{row}");
            assert_eq!(count,removed.len());
            assert_eq!(particles.iter().map(|p|p.0).collect::<Vec<_>>(),row["remaining_ids"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>(),"{row}");
        }
    }
}
