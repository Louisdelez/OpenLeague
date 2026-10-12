from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'unitÃ©s' in s
fixed=s.encode('cp1252').decode('utf-8');assert 'unités' in fixed and 'déplacement / attaque' in fixed and 'Ã' not in fixed;p.write_text(fixed,encoding='utf-8')
p=Path('E:/mapslol3v3/integrate_native_environment_config.py');s=p.read_text(encoding='utf-8').replace('.read_text()',".read_text(encoding='utf-8')");p.write_text(s,encoding='utf-8');shutil.copy2(p,r/'tools'/p.name)
for source,name in [('E:/mapslol3v3/repair_environment_config_utf8.py','repair_environment_config_utf8.py')]:shutil.copy2(source,r/'tools'/name)
shutil.copy2(r/'docs/native_environment_config_runtime_capture.json',r/'docs/native_environment_config_encoding_failure_capture.json')
print('UTF-8 HUD repaired; first encoding-failure capture preserved separately.')
