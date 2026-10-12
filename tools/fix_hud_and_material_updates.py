from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
replacements={'RÃ©apparition':'Réapparition','â€”':'—','alliÃ©':'allié','verrouillÃ©':'verrouillé','contestÃ©':'contesté','prÃªte':'prête','Ã‰tourdi':'Étourdi','ContrÃ´le':'Contrôle','unitÃ©s':'unités','ciblÃ©s':'ciblés','dÃ©placement':'déplacement','flÃ¨ches':'flèches','camÃ©ra':'caméra','arrÃªt':'arrêt','dÃ©truit':'détruit','DÃ©faite':'Défaite'}
counts={old:s.count(old) for old in replacements};assert all(counts.values()),counts
for old,new in replacements.items():s=s.replace(old,new)
assert all(marker not in s for marker in ['Ã','â€','Â'])
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_visibility_texture.rs';s=p.read_text(encoding='utf-8')
old='''    for (_,m) in terrain.iter_mut() {if m.visibility_map!=texture.image {m.visibility_map=texture.image.clone();m.visibility_params=params;m.visibility_diagnostic=u32::from(diagnostic_enabled());}}
    for (_,m) in environment.iter_mut() {if m.extension.visibility_map!=texture.image {m.extension.visibility_map=texture.image.clone();m.extension.visibility_params=params;}}'''
new='''    // Assets::iter_mut marks every visited asset modified. Inspect immutably first,
    // then mutate only missing bindings, including new assets added after startup.
    let terrain_ids:Vec<_>=terrain.iter().filter(|(_,m)|m.visibility_map!=texture.image || m.visibility_params!=params).map(|(id,_)|id).collect();
    for id in terrain_ids {let mut m=terrain.get_mut(id).expect("existing terrain material");m.visibility_map=texture.image.clone();m.visibility_params=params;m.visibility_diagnostic=u32::from(diagnostic_enabled());}
    let environment_ids:Vec<_>=environment.iter().filter(|(_,m)|m.extension.visibility_map!=texture.image || m.extension.visibility_params!=params).map(|(id,_)|id).collect();
    for id in environment_ids {let mut m=environment.get_mut(id).expect("existing environment material");m.extension.visibility_map=texture.image.clone();m.extension.visibility_params=params;}'''
assert old in s;s=s.replace(old,new);p.write_text(s,encoding='utf-8')
print({'hud_replacements':counts,'material_updates':'only new or changed visibility bindings'})
