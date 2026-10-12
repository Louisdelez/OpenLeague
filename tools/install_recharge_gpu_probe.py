from pathlib import Path
from datetime import datetime,timezone
import shutil
root=Path('E:/OpenLeague'); stage=Path('E:/mapslol3v3')
backup=root/'docs/plan_history'/('recharge-gpu-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
main=root/'crates/client/src/main.rs';shutil.copy2(main,backup/'main.rs');s=main.read_text(encoding='utf-8')
assert 'mod native_hud_recharge_gpu_probe;' not in s
s='mod native_hud_recharge_material;\nmod native_hud_recharge_gpu_probe;\n'+s
needle='    if std::env::args().any(|a|a=="--native-hud-text-gpu-probe")'
assert needle in s
s=s.replace(needle,'    if std::env::args().any(|a|a=="--native-hud-recharge-gpu-probe") {native_hud_recharge_gpu_probe::run();return}\n'+needle,1)
main.write_text(s,encoding='utf-8')
for name in ('native_hud_recharge_material.rs','native_hud_recharge_gpu_probe.rs'):shutil.copy2(stage/name,root/'crates/client/src'/name)
shutil.copy2(stage/'native_hud_recharge.wgsl',root/'assets/shaders/native_hud_recharge.wgsl')
shutil.copy2(stage/'install_recharge_gpu_probe.py',root/'tools/install_recharge_gpu_probe.py')
print('Native shader GPU probe installed; ordinary HUD and LineStrip pending.')
