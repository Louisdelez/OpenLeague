from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');proof=json.loads((r/'data/4.20/native_hud_pool_ratios_contract.json').read_text());assert proof['passed'] and proof['case_count']==110
files=['crates/client/src/main.rs','crates/client/src/native_hud_bars.rs','crates/client/src/native_hud_widgets.rs']
history=r/'docs/plan_history'/('pool-ratios-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for f in files:shutil.copy2(r/f,history/Path(f).name)
module=r'''//! Positive finite ordinary pools, qualified against original 4.20 CRT/SSE instructions.
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
'''
p=r/'crates/client/src/native_hud_pool_numbers.rs';assert not p.exists();p.write_text(module,encoding='utf-8')
p=r/files[0];s=p.read_text(encoding='utf-8');assert 'mod native_hud_bars;' in s;s=s.replace('mod native_hud_bars;','mod native_hud_bars;\nmod native_hud_pool_numbers;');p.write_text(s,encoding='utf-8')
p=r/files[1];s=p.read_text(encoding='utf-8');start=s.index('fn ratio(');end=s.index('\npub fn values',start);s=s[:start]+s[end:];s=s.replace('let health=ratio(player.health,player.max_health)?','let health=crate::native_hud_pool_numbers::fraction(player.health,player.max_health,true)?').replace('Some(ratio(player.mana,player.max_mana.ok_or("authoritative resource capacity missing")?)?)','Some(crate::native_hud_pool_numbers::fraction(player.mana,player.max_mana.ok_or("authoritative resource capacity missing")?,false)?)')
s=s.replace('assert!(ratio(f32::NAN,1.0).is_err());assert!(ratio(1.0,0.0).is_err());assert_eq!(ratio(12.0,10.0).unwrap(),1.0);','assert!(crate::native_hud_pool_numbers::fraction(f32::NAN,1.0,true).is_err());assert!(crate::native_hud_pool_numbers::fraction(1.0,0.0,true).is_err());')
s=s.replace('Native ratio producer, tip/lost-health interpolation, highlights, shields and numeric text pending.','Native positive finite rounded-pool ratios integrated; tip/lost-health interpolation, highlights and shields pending.')
p.write_text(s,encoding='utf-8')
p=r/files[2];s=p.read_text(encoding='utf-8');start=s.index('    let counter=');end=s.index('    let bars=',start);s=s[:start]+'    let health_counter=crate::native_hud_pool_numbers::health_number;\n    let counter=crate::native_hud_pool_numbers::mana_number;\n'+s[end:]
s=s.replace('(p.health/p.max_health).clamp(0.0,1.0)','(p.health.ceil()/p.max_health.ceil()).clamp(0.0,1.0)').replace('(p.mana/cap).clamp(0.0,1.0)','(p.mana.floor()/cap.floor()).clamp(0.0,1.0)')
s=s.replace('MP floor current / maximum remains engine-owned','MP floor qualified against original SSE positive ordinary-pool conversion')
p.write_text(s,encoding='utf-8');print('Native health/mana counters and rounded ratios integrated')
