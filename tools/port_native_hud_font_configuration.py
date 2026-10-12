from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent;shutil.copy2(s/'native_hud_font_configuration.rs',r/'crates/client/src/native_hud_font_configuration.rs')
p=r/'crates/client/src/main.rs';t=p.read_text(encoding='utf-8')
if 'mod native_hud_font_configuration;' not in t:t='mod native_hud_font_configuration;\n'+t
if 'Native HUD font source locale=' not in t:t=t.replace('    eprintln!("Native HUD groups=', '    eprintln!("Native HUD font source locale={} path={} requests={} font_gpu=false widgets=false",native_hud.shadow_isles_font_configuration.locale,native_hud.shadow_isles_font_configuration.path,native_hud.source_font_requests().expect("source HUD font requests").len());\n    eprintln!("Native HUD groups=')
p.write_text(t,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8')
if 'pub shadow_isles_font_configuration:' not in t:
 t=t.replace('pub shadow_isles_textures:crate::native_hud_textures::Registry}', 'pub shadow_isles_textures:crate::native_hud_textures::Registry,pub shadow_isles_font_configuration:crate::native_hud_font_configuration::Loaded}')
 t=t.replace('impl StartupHud {','''impl StartupHud {
    pub fn source_font_requests(&self)->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.font_requests_from_maps(&self.shadow_isles_font_configuration.configuration.maps,b"")
    }''')
 t=t.replace('        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups,shadow_isles_textures})','''        let shadow_isles_font_configuration=crate::native_hud_font_configuration::load(root)?;
        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups,shadow_isles_textures,shadow_isles_font_configuration})''')
 t=t.replace('assert_eq!(hud.shadow_isles_textures.entries.len(),84);','''assert_eq!(hud.shadow_isles_textures.entries.len(),84);
        assert_eq!(hud.shadow_isles_font_configuration.locale,"en_GB");
        let requests=hud.source_font_requests().unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"Gill Sans MT Pro Medium"));''')
p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('19source fontconfig profiles supported; provided defaulten_GBselected; native full parser/locale overrides/GPU remain open')
