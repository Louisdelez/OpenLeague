from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent
shutil.copy2(s/'native_hud_textures.rs',r/'crates/client/src/native_hud_textures.rs')
p=r/'crates/client/src/main.rs';t=p.read_text(encoding='utf-8')
if 'mod native_hud_textures;' not in t:t='mod native_hud_textures;\n'+t
if 'Native HUD textures=' not in t:t=t.replace('    let native_hud=zip_resources.startup_hud','    let native_hud=zip_resources.startup_hud').replace('    eprintln!("Native HUD groups=', '    eprintln!("Native HUD textures={} descriptors_pending={} gpu_handles_resolved=false drawing=false",native_hud.shadow_isles_textures.entries.len(),native_hud.shadow_isles_textures.entries.len());\n    eprintln!("Native HUD groups=')
p.write_text(t,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8')
if 'pub shadow_isles_textures:' not in t:
 t=t.replace('pub shadow_isles_groups:crate::native_hud_groups::Registry}', 'pub shadow_isles_groups:crate::native_hud_groups::Registry,pub shadow_isles_textures:crate::native_hud_textures::Registry}')
 t=t.replace('        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups})','''        let mut shadow_isles_textures=crate::native_hud_textures::Registry::default();
        for record in shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted) {
            let bytes=record.element.storage.bytes();
            let offsets:&[usize]=match record.element.storage.kind() {1=>&[0x1e0],2=>&[0x21c,0x23c],_=>&[]};
            for &offset in offsets {
                let raw=&bytes[offset..offset+32];let end=raw.iter().position(|v|*v==0).unwrap_or(32);
                if end>0 {shadow_isles_textures.request(&raw[..end]).map_err(io::Error::other)?;}
            }
        }
        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups,shadow_isles_textures})''')
 t=t.replace('assert_eq!(hud.shadow_isles_groups.groups.len(),48);','assert_eq!(hud.shadow_isles_groups.groups.len(),48);\n        assert_eq!(hud.shadow_isles_textures.entries.len(),84);\n        assert!(hud.shadow_isles_textures.entries.values().all(|e|e.storage[0x20..0x24]==[0;4] && e.storage[0x34]==0));')
p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('HUD named texture registry integrated; GPU loading still pending')
