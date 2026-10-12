from pathlib import Path
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
s=(stage/'native_hud_groups.rs').read_text(encoding='utf-8');s=s.replace('hash lookup/name copy','hash lookup and name comparison').replace('pub struct Group {','#[derive(Default)]\npub struct Group {').replace('pub name_storage:[u8;32],pub flags:u32,','pub name_storage:[u8;32],pub layer:u32,pub alpha_flags:u32,pub enabled_marker:u8,pub flags:u32,')
s=s.replace('members:Vec::new()}','members:Vec::new(),..Group::default()}').replace('last_frame:99,members}', 'last_frame:99,members,..Group::default()}').replace('members:vec![201,202]}','members:vec![201,202],..Group::default()}')
(stage/'native_hud_groups_scenes.rs').write_text(s,encoding='utf-8')
s=(r/'crates/client/src/native_zip_provider.rs').read_text(encoding='utf-8');s=s.replace('pub shadow_isles_layouts:Vec<HudLayout>}', 'pub shadow_isles_layouts:Vec<HudLayout>,pub shadow_isles_groups:crate::native_hud_groups::Registry}')
s=s.replace('pub effects:Vec<crate::native_hud_effect_uniforms::EffectUniforms>}', 'pub effects:Vec<crate::native_hud_effect_uniforms::EffectUniforms>,pub bindings:Vec<crate::native_hud_groups::Binding>}')
s=s.replace('        let mut shadow_isles_layouts=Vec::new();','''        let scenes=required(self.read_optional(root,Path::new("HUD/Scenes.ini"))?)?;
        let mut shadow_isles_groups=crate::native_hud_scenes::parse(&scenes,[0;32]).map_err(io::Error::other)?.registry;
        let mut next_element=1u32;
        let mut shadow_isles_layouts=Vec::new();''')
s=s.replace('            shadow_isles_layouts.push(HudLayout {request,restoration,structure,effects});','''            let mut bindings=Vec::new();
            for record in &structure.accepted {
                let bytes=record.element.storage.bytes();let name=&bytes[0x20..0x40];let end=name.iter().position(|v|*v==0).unwrap_or(name.len());
                let mut binding=crate::native_hud_groups::Binding {group:None,index:record.element.storage.word(0x4c)};
                shadow_isles_groups.rebind(&mut binding,next_element,&name[..end],crate::native_hud_groups::Clock {frame:0,invalid:true}).map_err(io::Error::other)?;
                bindings.push(binding);next_element+=1;
            }
            shadow_isles_layouts.push(HudLayout {request,restoration,structure,effects,bindings});''')
s=s.replace('Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts})','Ok(StartupHud {fast_hud,chat,shadow_isles_atlases,shadow_isles_layouts,shadow_isles_groups})')
s=s.replace('assert_eq!(hud.shadow_isles_layouts.len(),32);','''assert_eq!(hud.shadow_isles_layouts.len(),32);
        assert_eq!(hud.shadow_isles_groups.groups.len(),48);
        assert_eq!(hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_some()).count(),697);
        let unbound=hud.shadow_isles_layouts.iter().flat_map(|l|l.structure.accepted.iter().zip(&l.bindings)).filter(|(_,b)|b.group.is_none()).collect::<Vec<_>>();
        assert_eq!(unbound.len(),6);
        assert!(unbound.iter().all(|(r,_)|&r.element.storage.bytes()[0x20..0x20+17]==b"HUDCenterAbilitys"));
        assert_eq!(hud.shadow_isles_groups.groups.values().map(|g|g.members.len()).sum::<usize>(),697);''')
(stage/'native_zip_provider_scenes.rs').write_text(s,encoding='utf-8');print('Staged source scene loading and qualified membership; runtime unchanged.')
