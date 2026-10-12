from pathlib import Path
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
p=r/'crates/client/src/native_zip_provider.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub shadow_isles_atlases:Vec<HudAtlas>}','pub shadow_isles_atlases:Vec<HudAtlas>,pub shadow_isles_layouts:Vec<HudLayout>}')
s=s.replace('pub struct HudAtlas {', 'pub struct HudLayout {pub request:String,pub restoration:Option<String>,pub structure:crate::native_hud_file_structure::StructuredFile}\npub struct HudAtlas {')
s=s.replace('        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases})', '''        let list=parsed.value(b"ShadowIsles",b"ElementsListNormal").ok_or_else(||io::Error::other("native HUD element list missing"))?;
        let list=String::from_utf8(list.to_vec()).map_err(io::Error::other)?;
        let list=required(self.read_optional(root,Path::new(&format!("HUD/{list}")))?)?;
        let list=std::str::from_utf8(&list).map_err(io::Error::other)?;
        let mut shadow_isles_layouts=Vec::new();
        for name in list.lines().map(str::trim).filter(|name|!name.is_empty()) {
            if name.contains('/') || name.contains('\\\\') || name.contains("..") {return Err(io::Error::other("unqualified HUD list path"));}
            let request=format!("HUD/Elements/{name}");
            let original=required(self.read_optional(root,Path::new(&request))?)?;
            let (bytes,restoration)=qualified_hud_repair(root,&request,original)?;
            let structure=crate::native_hud_file_structure::parse(&bytes).map_err(io::Error::other)?;
            if structure.header_assignments!=2 || !structure.rejected.is_empty() {return Err(io::Error::other(format!("incomplete HUD structural file: {request}")));}
            shadow_isles_layouts.push(HudLayout {request,restoration,structure});
        }
        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts})''')
insert='''// Repairs are an explicit OpenLeague overlay, never silent archive replacement.
// Compare bytes to independently native-qualified inputs before selecting a repair.
fn qualified_hud_repair(root:&Path,request:&str,original:Vec<u8>)->io::Result<(Vec<u8>,Option<String>)> {
    let restored=match request {
        "HUD/Elements/TargetBar_Buffs.ini"=>"data/4.20/hud_restored/HUD/Elements/TargetBar_Buffs.ini",
        "HUD/Elements/LossOfControlUI.ini"=>"data/4.20/hud_restored/HUD/Elements/LossOfControlUI.ini",
        _=>return Ok((original,None)),
    };
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_file_loop_contract.json")).map_err(io::Error::other)?;
    let cases=proof["cases"].as_array().ok_or_else(||io::Error::other("HUD repair qualification missing"))?;
    let expected=|variant:&str|->io::Result<Vec<u8>> {
        let hex=cases.iter().find(|case|case["path"]==request && case["variant"]==variant).and_then(|case|case["input_hex"].as_str()).ok_or_else(||io::Error::other("HUD repair qualification missing input"))?;
        (0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).map_err(io::Error::other)).collect()
    };
    if original!=expected("original")? {return Err(io::Error::other(format!("HUD original differs from qualified repair source: {request}")));}
    let bytes=crate::native_filesystem_provider::read(&root.join(restored))?.ok_or_else(||io::Error::other("qualified HUD repair missing"))?;
    if bytes!=expected("restored")? {return Err(io::Error::other(format!("HUD repair differs from native-qualified bytes: {request}")));}
    Ok((bytes,Some(restored.to_owned())))
}
'''
s=s.replace('#[cfg(all(test,windows))] mod tests {',insert+'#[cfg(all(test,windows))] mod tests {')
s=s.replace('assert_eq!(hud.fast_hud.len(),1607);assert_eq!(hud.chat.len(),1773);','''assert_eq!(hud.fast_hud.len(),1607);assert_eq!(hud.chat.len(),1773);
        assert_eq!(hud.shadow_isles_layouts.len(),32);
        assert_eq!(hud.shadow_isles_layouts.iter().map(|l|l.structure.accepted.len()).sum::<usize>(),703);
        assert_eq!(hud.shadow_isles_layouts.iter().filter(|l|l.restoration.is_some()).count(),2);
        assert!(hud.shadow_isles_layouts.iter().all(|l|l.structure.rejected.is_empty()));
        for layout in &hud.shadow_isles_layouts {assert!(layout.request.starts_with("HUD/Elements/"));}
        let repair=hud.shadow_isles_layouts.iter().find(|l|l.request.ends_with("TargetBar_Buffs.ini")).unwrap();
        assert!(qualified_hud_repair(&root,&repair.request,b"incorrect archive source".to_vec()).is_err());''')
(stage/'native_zip_provider_layouts.rs').write_text(s,encoding='utf-8')
print('Staged native ZIP HUD layout integration; production sources not modified.')
