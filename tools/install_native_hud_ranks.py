from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
history=r/'docs/plan_history'/('hud-ranks-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['main.rs','native_hud_live_probe.rs']:shutil.copy2(r/'crates/client/src'/name,history/name)
(r/'crates/client/src/native_hud_ranks.rs').write_text((stage/'native_hud_ranks.rs').read_text(encoding='utf-8-sig'),encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_ranks;' not in s;s=s.replace('mod native_hud_spells;','mod native_hud_spells;\nmod native_hud_ranks;').replace('.add_plugins((native_hud_experience::Plugin, native_hud_spells::Plugin))','.add_plugins((native_hud_experience::Plugin, native_hud_spells::Plugin, native_hud_ranks::Plugin))');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_live_probe.rs';s=p.read_text(encoding='utf-8');marker='    probe.records.push(serde_json::json!({"kind":"capture_requested"';assert marker in s
s=s.replace(marker,'    let ranks=if std::env::var("OPENLEAGUE_NATIVE_HUD_RANKS_TRACE").is_ok() {let value=trace("OPENLEAGUE_NATIVE_HUD_RANKS_TRACE")?;if value["ranks"]!=serde_json::json!(player.ranks) {return Err("native rank trace differs from authoritative ranks".into());}Some(value)}else {None};\n'+marker).replace('"spells_draw_trace":spells','"spells_draw_trace":spells,"ranks_draw_trace":ranks');p.write_text(s,encoding='utf-8')
for name in ['install_native_hud_ranks.py','inspect_native_hud_rank_sources.py','inspect_native_hud_pips.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native rank widgets and ordinary capture instrumentation installed')
