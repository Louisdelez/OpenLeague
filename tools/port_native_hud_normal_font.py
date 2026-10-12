from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent;shutil.copy2(s/'native_hud_normal_font.rs',r/'crates/client/src/native_hud_normal_font.rs')
p=r/'crates/client/src/main.rs';t=p.read_text(encoding='utf-8')
if 'mod native_hud_normal_font;' not in t:t='mod native_hud_normal_font;\n'+t
p.write_text(t,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8')
if 'pub fn font_requests_from_maps(' not in t:
 t=t.replace('impl StartupHud {','''impl StartupHud {
    // Native first-map supplier; previous manager default and loaded maps are explicit.
    pub fn font_requests_from_maps(&self,entries:&[Option<crate::native_hud_normal_font::Entry>],previous:&[u8])->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.font_requests(Some(crate::native_hud_normal_font::manager_default(entries,previous)))
    }''')
 t=t.replace('let requests=hud.font_requests(Some(b"FontA")).unwrap();','''let maps=[Some(crate::native_hud_normal_font::Entry {font_map:Some(crate::native_hud_normal_font::FontMap::from([(b"$NormalFont".to_vec(),b"Gill Sans MT Pro Medium".to_vec())]))})];
        let requests=hud.font_requests_from_maps(&maps,b"").unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"Gill Sans MT Pro Medium"));
        let requests=hud.font_requests_from_maps(&[],b"").unwrap();assert!(requests.iter().all(|r|r.name.is_empty()));
        let requests=hud.font_requests(Some(b"FontA")).unwrap();''')
p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('Native first-font-map supplier ported; active locale/fontconfig loader still explicit and open')
