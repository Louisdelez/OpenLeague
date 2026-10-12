//! Positive finite ordinary pools, qualified against original 4.20 CRT/SSE instructions.
//! Native death accessors, special resource policies and zero-capacity display remain open.
pub fn health_number(value:f32)->Result<i32,String> {number(value,true)}
pub fn mana_number(value:f32)->Result<i32,String> {number(value,false)}
fn number(value:f32,health:bool)->Result<i32,String> {
    let rounded=if health {value.ceil()} else {value.floor()};
    if !value.is_finite() || value<0.0 || rounded as f64>i32::MAX as f64 {return Err("HUD pool outside native positive signed32 range".into());}
    Ok(rounded as i32)
}
pub fn fraction(current:f32,maximum:f32,health:bool)->Result<f32,String> {
    let convert=if health {health_number}else {mana_number};
    let current=convert(current)?;let maximum=convert(maximum)?;
    if maximum<=0 {return Err("HUD rounded capacity is zero; native display branch not integrated".into());}
    // Ordinary authoritative pools stay within capacity; preserve bounded fill for stale over-cap snapshots.
    Ok((current as f32/maximum as f32).clamp(0.0,1.0))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn mana_integer_and_pool_fraction_match_executed_native_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_pool_ratios_contract.json")).unwrap();
        assert_eq!(proof["case_count"],110);assert_eq!(proof["passed"],true);
        for case in proof["conversions"].as_array().unwrap().iter().filter(|c|c["resource_type_matches"]==true) {
            assert_eq!(mana_number(case["current_f32"].as_f64().unwrap() as f32).unwrap(),case["current_integer"].as_i64().unwrap() as i32);
            assert_eq!(mana_number(case["maximum_f32"].as_f64().unwrap() as f32).unwrap(),case["maximum_integer"].as_i64().unwrap() as i32);
        }
        for case in proof["ratios"].as_array().unwrap() {
            let current=case["current_f32"].as_f64().unwrap() as f32;let maximum=case["maximum_f32"].as_f64().unwrap() as f32;
            assert_eq!(fraction(current,maximum,case["kind"]=="health").unwrap().to_bits(),case["fraction_bits"].as_u64().unwrap() as u32);
        }
        assert!(health_number(f32::NAN).is_err());assert!(mana_number(f32::INFINITY).is_err());assert!(health_number(-1.0).is_err());assert!(mana_number(2147483648.0).is_err());
        assert!(fraction(0.0,0.99,false).is_err());assert!(fraction(0.0,0.0,true).is_err());assert_eq!(fraction(12.0,10.0,true).unwrap(),1.0);
    }
}
