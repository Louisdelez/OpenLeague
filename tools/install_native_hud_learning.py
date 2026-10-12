from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('hud-learning-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['main.rs','native_hud_live_probe.rs']:shutil.copy2(r/'crates/client/src'/name,history/name)
p=r/'crates/core/src/progression.rs';shutil.copy2(p,history/'progression.rs');s=p.read_text(encoding='utf-8');start=s.index('    pub fn learn(');assert s[start:].endswith('    }\n}\n');checks=s[s.index('        // Special ranking',start):s.index('        p.ranks[slot as usize] = next;',start)]
checks=checks.replace('let next = p.ranks[slot as usize] + 1;','let next = p.ranks[slot as usize].checked_add(1).ok_or("maximum skill rank")?;')
s=s[:start]+'''    pub fn learn(&mut self, id:u32, slot:u8)->Result<(),String> {
        if slot>3 {return Err("invalid skill slot".into());}
        let p=self.players.get(&id).ok_or("unknown player")?;
        let next=next_rank(p,slot)?;
        self.players.get_mut(&id).unwrap().ranks[slot as usize]=next;
        Ok(())
    }
}
// Shared authoritative eligibility, also used by the native learning HUD.
pub fn next_rank(p:&Champion,slot:u8)->Result<u8,String> {
    if slot>3 {return Err("invalid skill slot".into());}
'''+checks+'    Ok(next)\n}\n';p.write_text(s,encoding='utf-8')
(r/'crates/client/src/native_hud_learning.rs').write_text((stage/'native_hud_learning.rs').read_text(encoding='utf-8-sig').replace('a["states"][key]','a["states"][*key]'),encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_learning;' not in s;s=s.replace('mod native_hud_ranks;','mod native_hud_ranks;\nmod native_hud_learning;').replace('native_hud_ranks::Plugin))','native_hud_ranks::Plugin, native_hud_learning::Plugin))')
needle='    terrain: Res<picking::Terrain>,\n) {';assert s.count(needle)==1;s=s.replace(needle,'    terrain: Res<picking::Terrain>,\n    learning_hud: Res<native_hud_learning::Live>,\n) {')
needle='if shop.focused || connection.id.is_none()';assert s.count(needle)==1;s=s.replace(needle,'if (learning_hud.pointer_hover && buttons.just_pressed(MouseButton::Right)) || shop.focused || connection.id.is_none()');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_live_probe.rs';s=p.read_text(encoding='utf-8');s=s.replace('live:Res<crate::native_hud_widgets::Live>,mut probe:ResMut<Probe>)','live:Res<crate::native_hud_widgets::Live>,mut learning:ResMut<crate::native_hud_learning::Live>,mut probe:ResMut<Probe>)')
marker='    probe.records.push(serde_json::json!({"kind":"capture_requested"';assert marker in s;s=s.replace(marker,'    let learning=if std::env::var("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE").is_ok() {let value=trace("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE")?;if value["eligible"]!=serde_json::json!(crate::native_hud_learning::eligible(player)?) {return Err("learning trace differs from authoritative eligibility".into());}Some(value)}else {None};\n'+marker).replace('"ranks_draw_trace":ranks','"ranks_draw_trace":ranks,"learning_draw_trace":learning')
needle='send(&mut connection,&mut probe,Action::Learn{slot:2},snapshot.tick)?;';assert s.count(needle)==1;s=s.replace(needle,'if std::env::var("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE").is_ok() {let point=crate::native_hud_learning::queue_probe_click(&mut learning,2)?;probe.records.push(serde_json::json!({"kind":"ui_click_requested","slot":2,"point":point.to_array(),"tick":snapshot.tick}));}else {'+needle+'}')
p.write_text(s,encoding='utf-8')
for name in ['install_native_hud_learning.py','inspect_native_hud_learning_controller.py','inspect_native_hud_learning_fields.py','inspect_native_hud_learning_sources.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native learning arrows/frames, shared progression and ordinary cursor command path installed')
