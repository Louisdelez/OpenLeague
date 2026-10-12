from pathlib import Path
from datetime import datetime,timezone
import shutil
r=Path('E:/OpenLeague');backup=r/'docs/plan_history'/('recharge-capture-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
p=r/'crates/client/src/native_hud_live_probe.rs';shutil.copy2(p,backup/p.name);s=p.read_text(encoding='utf-8');needle='    probe.records.push(serde_json::json!({"kind":"capture_requested"';assert needle in s
s=s.replace(needle,'''
    let recharge=if std::env::var("OPENLEAGUE_NATIVE_HUD_RECHARGE_TRACE").is_ok() {
        let value=trace("OPENLEAGUE_NATIVE_HUD_RECHARGE_TRACE")?;
        let expected=crate::native_hud_recharge::player_params(player,snapshot.tick).map_err(str::to_owned)?;
        if value["tick"]!=snapshot.tick || value["elements"].as_array().map(Vec::len)!=Some(4) {return Err("recharge trace snapshot or widget count mismatch".into());}
        for slot in 0..4 {if value["elements"][slot]["active"]!=expected[slot].is_some() || value["elements"][slot]["params"]!=serde_json::json!(expected[slot].map(|p|p.to_array())) {return Err("recharge trace differs from authoritative capture state".into());}}
        Some(value)
    }else {None};
'''+needle,1)
s=s.replace('"learning_draw_trace":learning}', '"learning_draw_trace":learning,"recharge_draw_trace":recharge}',1);p.write_text(s,encoding='utf-8')
p=r/'tools/run_native_hud_learning_live.ps1';s=p.read_text(encoding='utf-8').replace("$tag='native-hud-learning-live-'", "$tag='native-hud-recharge-live-'")
needle="$env:OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE=$prefix+'-learning-trace.json'";assert needle in s;s=s.replace(needle,needle+"\n$env:OPENLEAGUE_NATIVE_HUD_RECHARGE_TRACE=$prefix+'-recharge-trace.json'",1)
needle=' [pscustomobject]@{backend=';assert needle in s;s=s.replace(needle,'''
 $activeRecharges=@($captures[3].recharge_draw_trace.elements | Where-Object {$_.active})
 if ($activeRecharges.Count -ne 1 -or $activeRecharges[0].slot -ne 2) {throw 'Expected only Annie E recharge in actual cast frame'}
 if ($captures[3].player.cooldown_totals[2] -ne 300) {throw 'Authoritative initial cooldown total missing or unexpected'}
 if (@($captures[5].recharge_draw_trace.elements | Where-Object {$_.active}).Count -ne 0) {throw 'Recharge did not expire in ready frame'}
'''+needle,1)
p=r/'tools/run_native_hud_recharge_live.ps1';assert not p.exists();p.write_text(s,encoding='utf-8');print('Native recharge trace added to actual capture phases; fresh runner prepared.')
