from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
assert '295 passed; 0 failed' in (r/'logs/native-hud-groups-corrected-tests.log').read_text(encoding='utf-8')
p=json.loads((r/'data/4.20/native_hud_scenes_contract.json').read_text(encoding='utf-8'));assert p['passed'] and p['case_count']==19 and len(p['cases'][0]['groups'])==48
for source,target in [('native_hud_groups_scenes.rs','native_hud_groups.rs'),('native_hud_scenes.rs','native_hud_scenes.rs'),('native_zip_provider_scenes.rs','native_zip_provider.rs')]:shutil.copy2(stage/source,r/'crates/client/src'/target)
for name in ['qualify_native_hud_scenes.py','stage_hud_scenes_integration.py','port_hud_scenes_integration.py']:shutil.copy2(stage/name,r/'tools'/name)
file=r/'crates/client/src/main.rs';s=file.read_text(encoding='utf-8')
if 'mod native_hud_scenes;' not in s:s='mod native_hud_scenes;\n'+s
needle='    for layout in &native_hud.shadow_isles_layouts'
if 'Native HUD groups=' not in s:
 pos=s.index(needle);s=s[:pos]+'''    eprintln!("Native HUD groups={} bound={} unbound={} cache_clock_producer=false drawing=false",native_hud.shadow_isles_groups.groups.len(),native_hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_some()).count(),native_hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_none()).count());
'''+s[pos:]
file.write_text(s,encoding='utf-8');print(json.dumps(dict(scenes_source_integrated=True,groups=48,bound=697,unbound=6,drawing=False)))
