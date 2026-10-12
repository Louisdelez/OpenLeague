from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod fow_postprocess;' not in s;shutil.copy2(p,b/'main.rs');p.write_text('#[allow(dead_code)]\nmod fow_postprocess;\n'+s,encoding='utf-8')
shutil.copy2(w/'fow_postprocess.rs',r/'crates/client/src/fow_postprocess.rs');shutil.copy2(w/'fow_postprocess.wgsl',r/'assets/shaders/fow_postprocess.wgsl')
examples=r/'crates/client/examples';examples.mkdir(exist_ok=True);shutil.copy2(w/'fow_gpu_probe.rs',examples/'fow_gpu_probe.rs')
p=r/'crates/client/Cargo.toml';s=p.read_text(encoding='utf-8');shutil.copy2(p,b/'client-Cargo.toml');assert '[dev-dependencies]' not in s;p.write_text(s+'\n[dev-dependencies]\nwgpu = { version = "=29.0.4", default-features = false, features = ["vulkan", "wgsl"] }\n',encoding='utf-8')
for name in ['probe_fow_gaussian.py','install_fow_postprocess.py']:shutil.copy2(w/name,r/'tools'/name)
print('Native fade/blur math and WGSL port installed; Vulkan probe ready, live FOW inputs separate.')
