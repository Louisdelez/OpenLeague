from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_spells;' not in s
history=r/'docs/plan_history'/('hud-spells-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True);shutil.copy2(p,history/p.name)
s=s.replace('mod native_hud_experience;','mod native_hud_experience;\nmod native_hud_spells;');assert 'native_hud_experience::Plugin' in s;s=s.replace('native_hud_experience::Plugin','(native_hud_experience::Plugin, native_hud_spells::Plugin)');p.write_text(s,encoding='utf-8')
shutil.copy2(stage/'native_hud_spells.rs',r/'crates/client/src/native_hud_spells.rs')
for name in ['install_native_hud_spells.py','qualify_native_hud_spell_states.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native QWER HUD installed; source tests/build/GPU qualification pending')
