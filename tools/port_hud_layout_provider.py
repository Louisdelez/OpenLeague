from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
assert '292 passed; 0 failed' in (r/'logs/native-hud-file-structure-tests.log').read_text(encoding='utf-8')
shutil.copy2(stage/'native_zip_provider_layouts.rs',r/'crates/client/src/native_zip_provider.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
needle='    let settings=native_user_settings::load_using'
if 'Native HUD structural files=' not in s:
 pos=s.index(needle)
 s=s[:pos]+'''    eprintln!("Native HUD structural files={} accepted={} rejected={} repaired={} resource_binding=false drawing=false",native_hud.shadow_isles_layouts.len(),native_hud.shadow_isles_layouts.iter().map(|l|l.structure.accepted.len()).sum::<usize>(),native_hud.shadow_isles_layouts.iter().map(|l|l.structure.rejected.len()).sum::<usize>(),native_hud.shadow_isles_layouts.iter().filter(|l|l.restoration.is_some()).count());
    for layout in &native_hud.shadow_isles_layouts {if let Some(path)=&layout.restoration {eprintln!("Native HUD reconstructed overlay request={} selected={} provenance=reconstructed_from_source_patterns",layout.request,path);}}
'''+s[pos:]
 p.write_text(s,encoding='utf-8')
for name in ['stage_hud_layout_provider.py','port_hud_layout_provider.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(provider_integrated=True,restoration_selection='explicit native-qualified byte comparison',resource_binding=False,drawing=False)))
