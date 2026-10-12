from pathlib import Path
from datetime import datetime,timezone
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('recharge-live-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True)
p=r/'crates/client/src/main.rs';shutil.copy2(p,history/'main.rs');s=p.read_text(encoding='utf-8');assert 'mod native_hud_recharge_live;' not in s;s='mod native_hud_recharge_live;\n'+s;needle='.add_plugins(native_hud_panels::Plugin)';assert needle in s;s=s.replace(needle,needle+'\n        .add_plugins(native_hud_recharge_live::Plugin)',1);p.write_text(s,encoding='utf-8');shutil.copy2(stage/'native_hud_recharge_live.rs',r/'crates/client/src/native_hud_recharge_live.rs');shutil.copy2(stage/'install_recharge_live.py',r/'tools/install_recharge_live.py')
print('Live native recharge HUD installed; verification pending.')
