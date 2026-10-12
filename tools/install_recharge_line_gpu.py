from pathlib import Path
from datetime import datetime,timezone
import shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');backup=r/'docs/plan_history'/('recharge-line-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
p=r/'crates/client/src/main.rs';shutil.copy2(p,backup/'main.rs');text=p.read_text(encoding='utf-8');assert 'mod native_hud_recharge_line;' not in text;text='mod native_hud_recharge_line;\nmod native_hud_recharge_line_gpu_probe;\n'+text
needle='    if std::env::args().any(|a|a=="--native-hud-recharge-gpu-probe")';assert needle in text;text=text.replace(needle,'    if std::env::args().any(|a|a=="--native-hud-recharge-line-gpu-probe") {native_hud_recharge_line_gpu_probe::run();return}\n'+needle,1);p.write_text(text,encoding='utf-8')
for name in ('native_hud_recharge_line.rs','native_hud_recharge_line_gpu_probe.rs'):shutil.copy2(s/name,r/'crates/client/src'/name)
shutil.copy2(s/'native_hud_recharge_line.wgsl',r/'assets/shaders/native_hud_recharge_line.wgsl');shutil.copy2(s/'install_recharge_line_gpu.py',r/'tools/install_recharge_line_gpu.py')
print('Native indexed LineStrip probe installed.')
