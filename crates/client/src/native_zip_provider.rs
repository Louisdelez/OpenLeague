//! Read-only archive-first resource provider, native primary-name index.
//! Manifest mount order is explicit; native alias registration remains open.
use std::{io,path::Path,collections::HashMap};
use crate::{native_archive_index::{Entry,Index},native_zip_archive::Archive};
fn merged_rows(rows:Vec<Entry>)->Vec<Entry> {
    let mut positions:HashMap<Vec<u8>,usize>=HashMap::new();let mut merged:Vec<Entry>=Vec::new();
    for row in rows {
        let key:Vec<u8>=row.key.iter().take_while(|&&b|b!=0).map(|b|b.to_ascii_lowercase()).collect();
        if let Some(&i)=positions.get(&key) {merged[i].packed_id=row.packed_id;}
        else {positions.insert(key,merged.len());merged.push(row);}
    }
    merged
}
#[derive(bevy::prelude::Resource)]
pub struct Provider {archives:Vec<Archive>,index:Index,pub entry_count:usize,pub unique_names:usize}
#[derive(bevy::prelude::Resource)]
pub struct StartupHud {pub fast_hud:Vec<u8>,pub chat:Vec<u8>,pub shadow_isles_atlases:Vec<HudAtlas>,pub shadow_isles_layouts:Vec<HudLayout>,pub shadow_isles_groups:crate::native_hud_groups::Registry,pub shadow_isles_textures:crate::native_hud_textures::Registry,pub shadow_isles_font_configuration:crate::native_hud_font_configuration::Loaded,pub shadow_isles_typefaces:Vec<crate::native_hud_font_assets::Typeface>}
pub struct HudLayout {pub request:String,pub restoration:Option<String>,pub structure:crate::native_hud_file_structure::StructuredFile,pub effects:Vec<crate::native_hud_effect_uniforms::EffectUniforms>,pub bindings:Vec<crate::native_hud_groups::Binding>,pub texture_bindings:Vec<crate::native_hud_texture_bindings::Bindings>}
pub struct HudAtlas {pub request:String,pub normalized:String,pub bytes:Vec<u8>}
impl StartupHud {
    pub fn source_font_requests(&self)->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.font_requests_from_maps(&self.shadow_isles_font_configuration.configuration.maps,b"")
    }
    // Native first-map supplier; previous manager default and loaded maps are explicit.
    pub fn font_requests_from_maps(&self,entries:&[Option<crate::native_hud_normal_font::Entry>],previous:&[u8])->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.font_requests(Some(crate::native_hud_normal_font::manager_default(entries,previous).map_err(io::Error::other)?))
    }
    // Explicit manager default context; no locale/font default is invented here.
    pub fn font_requests(&self,manager_default:Option<&[u8]>)->io::Result<Vec<crate::native_hud_font_requests::Request>> {
        self.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).filter(|r|r.element.storage.kind()==3).map(|r|crate::native_hud_font_requests::request(&r.element.storage,manager_default).map_err(io::Error::other)).collect()
    }
    // Caller must supply qualified viewport and HUD owner scalar; no settings default is invented.
    pub fn refresh_bounds(&mut self,width:u32,height:u32,scalar:f32)->io::Result<usize> {
        let elements=self.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).enumerate().map(|(i,r)|((i+1) as u32,&r.element.storage)).collect::<std::collections::BTreeMap<_,_>>();
        self.shadow_isles_groups.refresh_bounds(width,height,scalar,|id|elements.get(&id).copied()).map_err(io::Error::other)
    }
}
impl Provider {
    pub fn from_catalog(root:&Path)->io::Result<Self> {
        let manifest:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_zip_catalog.json"))?).map_err(io::Error::other)?;
        let paths=manifest["archives"].as_array().ok_or_else(||io::Error::other("invalid native ZIP catalog"))?;
        let mut archives=Vec::new();let mut rows=Vec::new();let mut entry_count=0;
        for (i,p) in paths.iter().enumerate() {
            if i>65535 {return Err(io::Error::other("native archive index exceeds16-bit range"));}
            let path=p["path"].as_str().ok_or_else(||io::Error::other("native ZIP catalog path missing"))?;
            let archive=Archive::open(crate::native_filesystem_provider::read(&root.join(path))?)?
                .ok_or_else(||io::Error::other(format!("native archive unavailable: {path}")))?;
            if archive.entries.len()>65536 {return Err(io::Error::other("native archive entry count exceeds16-bit range"));}
            for (j,entry) in archive.entries.iter().enumerate() {rows.push(Entry {key:entry.name.clone(),packed_id:((i as u32)<<16)|(j as u32)});}
            entry_count+=archive.entries.len();archives.push(archive);
        }
        let rows=merged_rows(rows);let unique_names=rows.len();let capacity=unique_names.max(2).checked_next_power_of_two().ok_or_else(||io::Error::other("archive index capacity overflow"))?;
        let mask=u32::try_from(capacity-1).map_err(io::Error::other)?;
        let index=Index::from_rows(rows,mask,capacity).map_err(io::Error::other)?;
        Ok(Self {archives,index,entry_count,unique_names})
    }
    pub fn archive_count(&self)->usize {self.archives.len()}
    pub fn read_optional(&mut self,root:&Path,path:&Path)->io::Result<Option<Vec<u8>>> {
        let query=path.to_str().ok_or_else(||io::Error::other("invalid resource path"))?.as_bytes();
        let found=self.index.lookup(Some(query),true,|_|{}).map_err(io::Error::other)?;
        if found.is_some() {
            // Native dispatcher queries predicate, then archive open performs its own lookup.
            let id=self.index.lookup(Some(query),true,|_|{}).map_err(io::Error::other)?.ok_or_else(||io::Error::other("archive index changed during open"))?;
            let archive=self.archives.get_mut((id>>16) as usize).ok_or_else(||io::Error::other("invalid native archive ID"))?;
            let result=archive.read((id&65535) as usize)?;
            if result.returned_bytes as usize!=result.bytes.len() {return Err(io::Error::new(io::ErrorKind::Unsupported,"native incomplete ZIP file-wrapper behavior is unqualified"));}
            return Ok(Some(result.bytes));
        }
        crate::native_filesystem_provider::read(&root.join(path))
    }
    pub fn startup_hud(&mut self,root:&Path)->io::Result<StartupHud> {
        let required=|p:Option<Vec<u8>>|p.ok_or_else(||io::Error::other("native HUD archive resource missing"));
        let fast_hud=required(self.read_optional(root,Path::new("HUD/defaults/FastHUD.ini"))?)?;
        let chat=required(self.read_optional(root,Path::new("HUD/defaults/Chat.ini"))?)?;
        let parsed=crate::native_game_cfg_text::parse(&fast_hud,0);
        if let Some(e)=parsed.error {return Err(io::Error::other(e));}
        let count=parsed.value(b"ShadowIsles",b"NumAtlasTextures").ok_or_else(||io::Error::other("HUD atlas count missing"))?;
        let count=std::str::from_utf8(count).map_err(io::Error::other)?.parse::<usize>().map_err(io::Error::other)?;
        let mut shadow_isles_atlases=Vec::new();
        for index in 1..=count {
            let key=format!("AtlasTexture{index}");let name=parsed.value(b"ShadowIsles",key.as_bytes()).ok_or_else(||io::Error::other("HUD atlas filename missing"))?;
            let request=format!("Textures/{}",std::str::from_utf8(name).map_err(io::Error::other)?);
            let normalized=String::from_utf8(crate::native_texture_filename::normalize(request.as_bytes())).map_err(io::Error::other)?;
            let bytes=required(self.read_optional(root,Path::new(&normalized))?)?;
            shadow_isles_atlases.push(HudAtlas {request,normalized,bytes});
        }
        let list=parsed.value(b"ShadowIsles",b"ElementsListNormal").ok_or_else(||io::Error::other("native HUD element list missing"))?;
        let list=String::from_utf8(list.to_vec()).map_err(io::Error::other)?;
        let list=required(self.read_optional(root,Path::new(&format!("HUD/{list}")))?)?;
        let list=std::str::from_utf8(&list).map_err(io::Error::other)?;
        let scenes=required(self.read_optional(root,Path::new("HUD/Scenes.ini"))?)?;
        let mut shadow_isles_groups=crate::native_hud_scenes::parse(&scenes,[0;32]).map_err(io::Error::other)?.registry;
        let mut next_element=1u32;
        let mut shadow_isles_layouts=Vec::new();
        for name in list.lines().map(str::trim).filter(|name|!name.is_empty()) {
            if name.contains('/') || name.contains('\\') || name.contains("..") {return Err(io::Error::other("unqualified HUD list path"));}
            let request=format!("HUD/Elements/{name}");
            let original=required(self.read_optional(root,Path::new(&request))?)?;
            let (bytes,restoration)=qualified_hud_repair(root,&request,original)?;
            let structure=crate::native_hud_file_structure::parse(&bytes).map_err(io::Error::other)?;
            if structure.header_assignments!=2 || !structure.rejected.is_empty() {return Err(io::Error::other(format!("incomplete HUD structural file: {request}")));}
            let effects=structure.accepted.iter().filter(|r|r.element.storage.kind()==2).map(|r|crate::native_hud_effect_uniforms::from_storage(&r.element.storage).map_err(io::Error::other)).collect::<io::Result<Vec<_>>>()?;
            let mut bindings=Vec::new();
            for record in &structure.accepted {
                let bytes=record.element.storage.bytes();let name=&bytes[0x20..0x40];let end=name.iter().position(|v|*v==0).unwrap_or(name.len());
                let mut binding=crate::native_hud_groups::Binding {group:None,index:record.element.storage.word(0x4c)};
                shadow_isles_groups.rebind(&mut binding,next_element,&name[..end],crate::native_hud_groups::Clock {frame:0,invalid:true}).map_err(io::Error::other)?;
                bindings.push(binding);next_element+=1;
            }
            shadow_isles_layouts.push(HudLayout {request,restoration,structure,effects,bindings,texture_bindings:Vec::new()});
        }
        let mut shadow_isles_textures=crate::native_hud_textures::Registry::default();
        for layout in &mut shadow_isles_layouts {
            layout.texture_bindings=layout.structure.accepted.iter().map(|r|crate::native_hud_texture_bindings::bind(&r.element.storage,&mut shadow_isles_textures).map_err(io::Error::other)).collect::<io::Result<Vec<_>>>()?;
        }
        let shadow_isles_font_configuration=crate::native_hud_font_configuration::load(root)?;
        let shadow_isles_typefaces=crate::native_hud_font_assets::selected(root,&shadow_isles_font_configuration.configuration.maps)?;
        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups,shadow_isles_textures,shadow_isles_font_configuration,shadow_isles_typefaces})
    }
}
// Repairs are an explicit OpenLeague overlay, never silent archive replacement.
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
#[cfg(all(test,windows))] mod tests {
    use super::*;
    #[test] fn duplicate_primary_names_preserve_first_key_and_last_id_like_native_mount_prefix() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_duplicate_index_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
        for c in p["cases"].as_array().unwrap() {
            let bytes=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();
            let original=bytes("existing");let id=((c["archive_count"].as_u64().unwrap() as u32)<<16)|(c["entry_ordinal"].as_u64().unwrap() as u32);
            let rows=merged_rows(vec![Entry {key:original.clone(),packed_id:0x12345678},Entry {key:bytes("requested"),packed_id:id}]);
            assert_eq!(rows[0].key,original);assert_eq!(rows[0].packed_id,c["packed_id_after"].as_u64().unwrap() as u32);
            assert_eq!(rows.len(),if c["matched"].as_bool().unwrap() {1}else{2});
        }
    }
    #[test] fn mounted_provider_resolves_every_original_payload_and_filesystem_defaults() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=Provider::from_catalog(&root).unwrap();assert_eq!(provider.archive_count(),5);assert_eq!(provider.entry_count,1066);
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_payload_contract.json")).unwrap();let golden=std::fs::read(root.join(p["golden"]["path"].as_str().unwrap())).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let path=c["name"].as_str().unwrap();let start=c["golden_offset"].as_u64().unwrap() as usize;let len=c["uncompressed_size"].as_u64().unwrap() as usize;
            // The duplicate names in these archives are empty directory records.
            assert_eq!(provider.read_optional(&root,Path::new(path)).unwrap().unwrap(),golden[start..start+len],"{path}");
        }
        let mut hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.fast_hud.len(),1607);assert_eq!(hud.chat.len(),1773);
        assert_eq!(hud.shadow_isles_layouts.len(),32);
        assert_eq!(hud.shadow_isles_groups.groups.len(),48);
        assert_eq!(hud.shadow_isles_textures.entries.len(),84);
        assert_eq!(hud.shadow_isles_font_configuration.locale,"en_GB");
        let requests=hud.source_font_requests().unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"Gill Sans MT Pro Medium"));
        let maps=[Some(crate::native_hud_normal_font::Entry {font_map:Some(crate::native_hud_normal_font::FontMap::from([(b"$NormalFont".to_vec(),b"Gill Sans MT Pro Medium".to_vec())]))})];
        let requests=hud.font_requests_from_maps(&maps,b"").unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"Gill Sans MT Pro Medium"));
        let requests=hud.font_requests_from_maps(&[],b"").unwrap();assert!(requests.iter().all(|r|r.name.is_empty()));
        let requests=hud.font_requests(Some(b"FontA")).unwrap();assert_eq!(requests.len(),154);assert!(requests.iter().all(|r|r.name==b"FontA"));
        let requests=hud.font_requests(None).unwrap();assert_eq!(requests.len(),154);
        for (request,record) in requests.iter().zip(hud.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).filter(|r|r.element.storage.kind()==3)) {
            let raw=&record.element.storage.bytes()[0x1e0..0x200];let end=raw.iter().position(|v|*v==0).unwrap_or(32);
            assert_eq!(request.name,&raw[..end]);assert_eq!(request.size,record.element.storage.word(0x204));
        }
        assert!(hud.shadow_isles_layouts.iter().all(|l|l.texture_bindings.len()==l.structure.accepted.len()));
        assert_eq!(hud.shadow_isles_layouts.iter().flat_map(|l|l.structure.accepted.iter().zip(&l.texture_bindings)).filter(|(r,_)|r.element.storage.kind()!=3).count(),549);
        for binding in hud.shadow_isles_layouts.iter().flat_map(|l|&l.texture_bindings) {
            for id in [binding.icon,binding.primary,binding.extra].into_iter().flatten() {assert!(hud.shadow_isles_textures.entries.contains_key(&id));}
        }
        assert!(hud.shadow_isles_textures.entries.values().all(|e|e.storage[0x20..0x24]==[0;4] && e.storage[0x34]==0));
        assert_eq!(hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_some()).count(),697);
        let unbound=hud.shadow_isles_layouts.iter().flat_map(|l|l.structure.accepted.iter().zip(&l.bindings)).filter(|(_,b)|b.group.is_none()).collect::<Vec<_>>();
        assert_eq!(unbound.len(),6);
        assert!(unbound.iter().all(|(r,_)|&r.element.storage.bytes()[0x20..0x20+17]==b"HUDCenterAbilitys"));
        assert_eq!(hud.shadow_isles_groups.groups.values().map(|g|g.members.len()).sum::<usize>(),697);
        assert_eq!(hud.refresh_bounds(1280,800,1.0).unwrap(),41);
        assert_eq!(hud.refresh_bounds(1280,800,1.0).unwrap(),0);
        let bounds:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_group_bounds_contract.json")).unwrap();
        for case in bounds["cases"].as_array().unwrap().iter().filter(|c|c["width"]==1280 && c["height"]==800 && c["owner_scalar_bits"]==1f32.to_bits() && c["dirty"]==true && c["initial_bits"][0]==0x7f7fffffu32) {
            let id=hud.shadow_isles_groups.lookup(case["group"].as_str().unwrap().as_bytes()).unwrap().unwrap();let group=&hud.shadow_isles_groups.groups[&id];
            assert_eq!(group.bounds.to_vec(),case["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            assert_eq!(group.flags&2,0);
        }
        assert_eq!(hud.shadow_isles_layouts.iter().map(|l|l.structure.accepted.len()).sum::<usize>(),703);
        assert_eq!(hud.shadow_isles_layouts.iter().filter(|l|l.restoration.is_some()).count(),2);
        assert!(hud.shadow_isles_layouts.iter().all(|l|l.structure.rejected.is_empty()));
        assert_eq!(hud.shadow_isles_layouts.iter().map(|l|l.effects.len()).sum::<usize>(),118);
        for layout in &hud.shadow_isles_layouts {assert!(layout.request.starts_with("HUD/Elements/"));}
        let repair=hud.shadow_isles_layouts.iter().find(|l|l.request.ends_with("TargetBar_Buffs.ini")).unwrap();
        assert!(qualified_hud_repair(&root,&repair.request,b"incorrect archive source".to_vec()).is_err());
        assert_eq!(provider.read_optional(&root,Path::new("hud/defaults/FASTHUD.INI")).unwrap().unwrap(),hud.fast_hud);
        assert_eq!(provider.read_optional(&root,Path::new("data/4.20/configuration/defaults/Game.cfg")).unwrap().unwrap(),include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg"));
        assert!(provider.read_optional(&root,Path::new("missing-native-resource-test")).unwrap().is_none());
    }
}
