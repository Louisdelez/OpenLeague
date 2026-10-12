from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('hud-recharge-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
p=r/'crates/client/src/main.rs';shutil.copy2(p,history/'main.rs');s=p.read_text(encoding='utf-8');assert 'mod native_hud_recharge;' not in s;s=s.replace('mod native_hud_cooldown_text;','#[allow(dead_code)] // Native recharge math/shader port; GPU bridge pending.\nmod native_hud_recharge;\nmod native_hud_cooldown_text;');p.write_text(s,encoding='utf-8')
shutil.copy2(stage/'native_hud_recharge.rs',r/'crates/client/src/native_hud_recharge.rs');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Installed native recharge math and source shader port; no GPU completion claim.')
