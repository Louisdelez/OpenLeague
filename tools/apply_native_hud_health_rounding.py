from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');proof=json.loads((r/'docs/native_hud_health_rounding_progress.json').read_text());assert proof['passed'] and proof['case_count']==13
p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text()
needle='    let bars=crate::native_hud_bars::values(snapshot,id)?.ok_or("authoritative player disappeared")?;'
assert s.count(needle)==1
s=s.replace(needle,'    // Original health path 7d6df5/7d6dfd and 7d6e16/7d6e1e uses ceil, then signed integer conversion.\n    let health_counter=|v:f32|->Result<i32,String> {if !v.is_finite() || v<0.0 || v.ceil() as f64>i32::MAX as f64 {return Err("HUD health number outside native positive signed32 range".into());}Ok(v.ceil() as i32)};\n'+needle)
s=s.replace('counter(player.health)?,counter(player.max_health)?','health_counter(player.health)?,health_counter(player.max_health)?')
s=s.replace('assert_eq!(values["HPStat"],"123 / 456")','assert_eq!(values["HPStat"],"124 / 457")')
s=s.replace('p.health.floor() as u32,p.max_health.floor() as u32','p.health.ceil() as i32,p.max_health.ceil() as i32')
s=s.replace('HP/MP floor current / maximum is engine-owned','HP ceil qualified against original CRT positive fast path; MP floor current / maximum remains engine-owned')
history=r/'docs/plan_history'/('health-rounding-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True);shutil.copy2(p,history/p.name)
p.write_text(s,encoding='utf-8')
print('Native positive-health ceil conversion integrated; mana remains floor')
