from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
shutil.copy2(stage/'native_cloud_phase.rs',r/'crates/client/src/native_cloud_phase.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_cloud_phase;' not in s
p.write_text('#[allow(dead_code)] // Native cloud phase qualified; full GPU fog binding pending.\nmod native_cloud_phase;\n'+s,encoding='utf-8')
for name in ['qualify_native_cloud_phase.py','install_cloud_phase.py']:shutil.copy2(stage/name,r/'tools'/name)
