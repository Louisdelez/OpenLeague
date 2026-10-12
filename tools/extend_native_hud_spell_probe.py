from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_live_probe.rs';s=p.read_text(encoding='utf-8');assert 'spells_draw_trace' not in s
history=r/'docs/plan_history'/('hud-spell-probe-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True);shutil.copy2(p,history/p.name)
anchor='    let player=snapshot.players.iter().find(|p|p.id==id).ok_or("missing capture player")?;'
insert='''
    let spells=if std::env::var("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE").is_ok() {
        let draw=trace("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE")?;
        let expected=crate::native_hud_spells::player_states(player,snapshot.tick)?;
        if draw["states"]!=serde_json::to_value(expected).unwrap() || draw["entities"]!=8 || draw["champion"]!="annie" {return Err("native spell trace does not match authoritative capture state".into());}
        Some(draw)
    }else {None};'''
assert anchor in s;s=s.replace(anchor,anchor+insert)
s=s.replace('"bars_draw_trace":bar_trace}', '"bars_draw_trace":bar_trace,"spells_draw_trace":spells}')
old='            8=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-regenerated.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}}'
new='''            8=>{
                if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-regenerated.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}
                if std::env::var("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE").is_ok() {
                    if player.cooldowns[2]>snapshot.tick {return Ok(false);}
                    let path=format!("{}-ready.png",probe.prefix.as_ref().unwrap());
                    if !std::path::Path::new(&path).exists() {
                        if !probe.records.iter().any(|r|r["label"]=="ready") {capture(&mut commands,&mut probe,"ready",snapshot,id)?;persist(&probe);}
                        return Ok(false);
                    }
                }
            }'''
assert old in s;s=s.replace(old,new);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_spells.rs';s=p.read_text(encoding='utf-8');assert 'fn player_states(' in s;s=s.replace('fn player_states(','pub(crate) fn player_states(');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/extend_native_hud_spell_probe.py'),r/'tools/extend_native_hud_spell_probe.py')
print('Opt-in ordinary spell HUD probe extended: locked, learned, cooldown and ready again')
