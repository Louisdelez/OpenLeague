//! Original 941F00 Simple emission gates/count, before particle birth.
//! Constant effective rate only; curve evaluation and latch mutation belong to the caller.
#[derive(Clone, Copy, Debug)]
pub struct EmissionInput {
    pub now: f32,
    pub system_start: f32,
    pub previous: f32,
    pub life: f32,
    pub delay: f32,
    pub period: f32,
    pub window: f32,
    pub rate: f32,
    pub single: bool,
    pub already_emitted: bool,
}
pub fn emission_count(v: EmissionInput) -> Result<u32, &'static str> {
    if ![v.now,v.system_start,v.previous,v.life,v.delay,v.period,v.window,v.rate].iter().all(|x| x.is_finite())
        || v.period <= 0. || v.rate < 0. || v.rate > 1_000_000. || v.now < v.previous || v.now < v.system_start {
        return Err("unsupported native emission input");
    }
    let age = v.now - v.system_start;
    if (v.single && v.already_emitted) || age < v.delay || age >= v.life || age % v.period >= v.window {return Ok(0);}
    let period_index = age / v.period;
    if period_index >= i32::MAX as f32 {return Err("native period index overflow");}
    let period_start = v.system_start + (period_index as i32 as f32) * v.period;
    let elapsed = v.now - v.previous.max(period_start);
    let raw = elapsed * v.rate;
    if raw >= i32::MAX as f32 {return Err("native emission count overflow");}
    // Original constant at11392D4, x86 truncation toward zero.
    let cap = 1 - (v.rate * f32::from_bits(0xbea8f5c3)) as i32;
    let mut count = (raw as i32).min(cap);
    if !v.already_emitted {
        if count == 0 {count = 1;}
        if v.single {count = (v.rate as i32).max(1);}
    }
    Ok(count as u32)
}
/// Native per-birth interpolation and emitter matrix application (943036..943194).
/// Matrix production, orientation and attachment remain separate prerequisites.
pub fn birth_position(previous: [f32;3], current: [f32;3], local: [f32;3], matrix: [f32;9], index: u32, count: u32) -> Result<[f32;3], &'static str> {
    if count==0 || count>1_000_000 || index==0 || index>count || !previous.iter().chain(current.iter()).chain(local.iter()).chain(matrix.iter()).all(|v|v.is_finite()) {return Err("unsupported native birth input");}
    let fraction=(index as f32)*(1./count as f32);
    let mut out=[0.;3];
    for j in 0..3 {
        let transformed=(local[0]*matrix[j]+local[1]*matrix[3+j])+local[2]*matrix[6+j];
        out[j]=transformed+(previous[j]+(current[j]-previous[j])*fraction);
    }
    Ok(out)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_original_executable_emission_gates_and_counts() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_emission_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),96);
        for c in proof["cases"].as_array().unwrap() {
            let f=|key:&str|c[key].as_f64().unwrap() as f32;
            let v=EmissionInput {now:10.+f("age"),system_start:10.,previous:f("previous"),life:f("life"),delay:f("delay"),period:f("period"),window:f("window"),rate:f("rate"),single:c["single"]==1,already_emitted:c["latch"]==1};
            assert_eq!(emission_count(v).unwrap(),c["count"].as_u64().unwrap() as u32,"{c}");
        }
    }
    #[test]
    fn birth_positions_match_original_particle_array_insertions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),48);
        for c in proof["cases"].as_array().unwrap() {
            let array=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let current:[f32;3]=array("position").try_into().unwrap();
            let local:[f32;3]=array("offset").try_into().unwrap();
            let matrix:[f32;9]=array("matrix").try_into().unwrap();
            let previous=current.map(|v|v-50.);
            let count=c["count"].as_u64().unwrap() as u32;
            let stored=c["stored"]["position"].as_array().unwrap();
            for i in 1..=count {
                let got=birth_position(previous,current,local,matrix,i,count).unwrap();
                for j in 0..3 {assert_eq!(got[j],stored[((i-1)*3) as usize+j].as_f64().unwrap() as f32,"{c}");}
            }
            assert_eq!(c["subsequent_births"],0);
            assert_eq!(c["stored"]["life"][0],c["life"]);
        }
    }
}
