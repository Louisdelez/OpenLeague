from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent;shutil.copy2(s/'native_hud_font_requests.rs',r/'crates/client/src/native_hud_font_requests.rs')
p=r/'crates/client/src/main.rs';t=p.read_text(encoding='utf-8')
if 'mod native_hud_font_requests;' not in t:t='mod native_hud_font_requests;\n'+t
p.write_text(t,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8')
if 'pub fn font_requests(' not in t:
 t=t.replace('impl StartupHud {','''impl StartupHud {
    // Explicit manager default context; no locale/font default is invented here.
    pub fn font_requests(&self,manager_default:Option<&[u8]>)->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).filter(|r|r.element.storage.kind()==3).map(|r|crate::native_hud_font_requests::request(&r.element.storage,manager_default).map_err(io::Error::other)).collect()
    }''')
 t=t.replace('assert_eq!(hud.shadow_isles_textures.entries.len(),84);','''assert_eq!(hud.shadow_isles_textures.entries.len(),84);
        let requests=hud.font_requests(Some(b"FontA")).unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"FontA"));
        let requests=hud.font_requests(None).unwrap();assert_eq!(requests.len(),154);
        for (request,record) in requests.iter().zip(hud.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).filter(|r|r.element.storage.kind()==3)) {
            let raw=&record.element.storage.bytes()[0x1e0..0x200];let end=raw.iter().position(|v|*v==0).unwrap_or(32);
            assert_eq!(request.name,&raw[..end]);assert_eq!(request.size,record.element.storage.word(0x204));
        }''')
p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('Font request API integrated with explicit manager context; runtime font loading remains open')
