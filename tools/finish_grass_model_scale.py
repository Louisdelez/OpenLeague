from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_model_bounds.rs';s=p.read_text(encoding='utf-8')
anchor='assert_eq!(model.local.map(f32::to_bits),local.map(f32::to_bits));'
assert anchor in s and 'c["skin_scale_bits"]' not in s
s=s.replace(anchor,anchor+'assert_eq!(model.skin_scale.to_bits(),c["skin_scale_bits"].as_u64().unwrap() as u32);');p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_model_scale.py','capture_grass_live_registry.py','finish_grass_model_scale.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
