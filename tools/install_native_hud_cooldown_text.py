from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('hud-cooldown-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['main.rs','native_hud_widgets.rs','native_hud_live_probe.rs']:shutil.copy2(r/'crates/client/src'/name,history/name)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_cooldown_text;' not in s;s=s.replace('mod native_hud_spells;','mod native_hud_spells;\nmod native_hud_cooldown_text;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text(encoding='utf-8');s=s.replace('Five original map10 Text widgets','Nine original map10 Text widgets').replace('Five source Text widgets','Nine source Text widgets').replace('widgets.len()!=5','widgets.len()!=9').replace('widgets.len(),5','widgets.len(),9')
anchor='|| (layout.request.ends_with("CenterHUD_PARBar.ini") && name==b"MPStat")'
assert anchor in s;s=s.replace(anchor,anchor+' || (name.starts_with(b"SpellCooldown") && (0..4).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpell{slot}.ini")) && name==format!("SpellCooldown{slot}").as_bytes()))')
old='pub fn snapshot_values(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<std::collections::BTreeMap<String,String>>,String> {'
assert old in s;s=s.replace(old,old+' snapshot_values_with_mode(snapshot,id,1) }\npub fn snapshot_values_with_mode(snapshot:&openleague_core::Snapshot,id:Option<u32>,mode:i32)->Result<Option<std::collections::BTreeMap<String,String>>,String> {')
s=s.replace('    Ok(Some(values))','    for slot in 0..4 {let seconds=player.cooldowns[slot].saturating_sub(snapshot.tick) as f32/openleague_core::TICK_RATE as f32;if let Some(text)=crate::native_hud_cooldown_text::format(seconds,mode)? {values.insert(format!("SpellCooldown{slot}"),text);}}\n    Ok(Some(values))',1)
s=s.replace('sizes:Res<Sizes>,mut faces:', 'sizes:Res<Sizes>,settings:Res<crate::native_user_settings::Loaded>,mut faces:')
s=s.replace('let values=match snapshot_values(snapshot,connection.id)', 'let cooldown_mode=match crate::native_hud_cooldown_text::mode(&settings) {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);eprintln!("Cooldown setting unavailable: {e}");return;}};\n    let values=match snapshot_values_with_mode(snapshot,connection.id,cooldown_mode)')
s=s.replace('for widget in &mut live.widgets {let Some(text)', 'for widget in &mut live.widgets {if widget.name.starts_with("SpellCooldown") {widget.storage.set_word(0x48,if values.contains_key(&widget.name) {1}else {0});}let Some(text)')
s=s.replace('"tick":snapshot.tick,"player":connection.id,"values":values', '"tick":snapshot.tick,"player":connection.id,"cooldown_mode":cooldown_mode,"values":values')
s=s.replace('{0x11}else {1}', '{0x11}else if widget.name.starts_with("SpellCooldown") {0}else {1}')
s=s.replace('original GameTime/GoldStat/LevelStat/HPStat/MPStat definitions missing or duplicated','original nine numeric HUD Text definitions missing or duplicated')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_live_probe.rs';s=p.read_text(encoding='utf-8');old='    let texts=crate::native_hud_widgets::snapshot_values(snapshot,Some(id))?.ok_or("missing probe player")?;';assert old in s;s=s.replace(old,'    let draw_mode=trace("OPENLEAGUE_NATIVE_HUD_TRACE")?["cooldown_mode"].as_i64().ok_or("cooldown mode missing from trace")? as i32;\n    let texts=crate::native_hud_widgets::snapshot_values_with_mode(snapshot,Some(id),draw_mode)?.ok_or("missing probe player")?;');p.write_text(s,encoding='utf-8')
shutil.copy2(stage/'native_hud_cooldown_text.rs',r/'crates/client/src/native_hud_cooldown_text.rs')
for name in ['install_native_hud_cooldown_text.py','qualify_native_hud_cooldown_text.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Nine native text widgets integrated; source tests and GPU observation pending')
