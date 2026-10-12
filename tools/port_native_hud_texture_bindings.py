from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent;shutil.copy2(s/'native_hud_texture_bindings.rs',r/'crates/client/src/native_hud_texture_bindings.rs')
p=r/'crates/client/src/main.rs';t=p.read_text(encoding='utf-8')
if 'mod native_hud_texture_bindings;' not in t:t='mod native_hud_texture_bindings;\n'+t
p.write_text(t,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8')
if 'pub texture_bindings:' not in t:
 t=t.replace('pub bindings:Vec<crate::native_hud_groups::Binding>}', 'pub bindings:Vec<crate::native_hud_groups::Binding>,pub texture_bindings:Vec<crate::native_hud_texture_bindings::Bindings>}')
 t=t.replace('HudLayout {request,restoration,structure,effects,bindings}', 'HudLayout {request,restoration,structure,effects,bindings,texture_bindings:Vec::new()}')
 start=t.index('        for record in shadow_isles_layouts.iter().flat_map(');end=t.index('        Ok(StartupHud',start)
 t=t[:start]+'''        for layout in &mut shadow_isles_layouts {
            layout.texture_bindings=layout.structure.accepted.iter().map(|r|crate::native_hud_texture_bindings::bind(&r.element.storage,&mut shadow_isles_textures).map_err(io::Error::other)).collect::<io::Result<Vec<_>>>()?;
        }
'''+t[end:]
 t=t.replace('assert_eq!(hud.shadow_isles_textures.entries.len(),84);','''assert_eq!(hud.shadow_isles_textures.entries.len(),84);
        assert!(hud.shadow_isles_layouts.iter().all(|l|l.texture_bindings.len()==l.structure.accepted.len()));
        assert_eq!(hud.shadow_isles_layouts.iter().flat_map(|l|l.structure.accepted.iter().zip(&l.texture_bindings)).filter(|(r,_)|r.element.storage.kind()!=3).count(),549);
        for binding in hud.shadow_isles_layouts.iter().flat_map(|l|&l.texture_bindings) {
            for id in [binding.icon,binding.primary,binding.extra].into_iter().flatten() {assert!(hud.shadow_isles_textures.entries.contains_key(&id));}
        }''')
p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('HUD Icon/Effect owned texture refs integrated; GPU loading still pending')
