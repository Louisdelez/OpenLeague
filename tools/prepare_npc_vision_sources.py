from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_character_geometry.py').read_text(encoding='utf-8')
s=s.replace("profiles=json.loads((r/'data/4.20/collision_profiles.json').read_text(encoding='utf-8'))", "champions=json.loads((r/'data/4.20/collision_profiles.json').read_text(encoding='utf-8'))\nall_profiles=json.loads((r/'data/4.20/native_vision_radii.json').read_text(encoding='utf-8'))['profiles']\nprofiles={name:dict(source=p['resource'],sha256=p['sha256']) for name,p in all_profiles.items() if name not in champions}")
s=s.replace('assert len(rows)==122','assert len(rows)==28').replace('fow_character_geometry_contract.json','fow_npc_geometry_contract.json').replace('native_character_geometry.json','native_npc_geometry.json').replace('122authored champion resources','28authored NPC resources').replace('122original verified champion files','28original verified NPC files').replace('champions=len(rows)','npc_profiles=len(rows)').replace("garen=rows['garen']","melee=rows['blue_minion_basic']")
(r/'tools/probe_fow_npc_geometry.py').write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_character_geometry.rs';s=p.read_text(encoding='utf-8')
old='    let profile=catalog.profiles.get(&definition.to_ascii_lowercase()).ok_or("missing native character geometry")?;\n    Ok(profile.authored.resolve(global_collision_override.unwrap_or(catalog.global_collision_default)))'
new='    static N:OnceLock<Catalog>=OnceLock::new();let npc=N.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_npc_geometry.json")).expect("native NPC geometry catalog"));\n    let name=definition.to_ascii_lowercase();\n    let (profile,default)=if let Some(profile)=catalog.profiles.get(&name) {(profile,catalog.global_collision_default)}else if let Some(profile)=npc.profiles.get(&name) {(profile,npc.global_collision_default)}else{return Err("missing native character geometry");};\n    Ok(profile.authored.resolve(global_collision_override.unwrap_or(default)))'
assert old in s;s=s.replace(old,new)
s+='''
#[cfg(test)] mod npc_tests {
    use super::*;
    #[test] fn original_28_npc_geometry_resources_match_native_field_reads() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_npc_geometry_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),31);
        for c in proof["cases"].as_array().unwrap().iter().take(28) {
            let loaded=native_character(c["name"].as_str().unwrap(),None).unwrap();
            for (i,v) in [loaded.shape,loaded.radius,loaded.secondary,loaded.geometry_factor].iter().enumerate() {assert_eq!(v.to_bits(),c["result_bits"][i].as_u64().unwrap() as u32,"NPC {c}");}
        }
    }
}
'''
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_champion_sources.rs';s=p.read_text(encoding='utf-8')
s=s.replace('//! Only living allied champions; server visibility remains authoritative.','//! Living allied champions, lane units, pets and sight buildings; server remains authoritative.')
s=s.replace('        let mut desired=BTreeMap::new();','        let mut desired=BTreeMap::new();\n        struct Observation {position:openleague_core::Point,modifiers:openleague_core::vision::RadiusModifiers,geometry:crate::fow_actor_metrics::CharacterGeometry,radius:f32}')
s=s.replace('            desired.insert(p.id,(p,geometry,radius));','            desired.insert(p.id,Observation {position:p.position,modifiers:p.vision_radius_modifiers,geometry,radius});')
needle='        let reset=self.session!=Some(state.session) || self.team!=Some(team);'
new='''        for unit in state.units.iter().filter(|u|u.team==team && u.health>0. && unit_gives_vision(u.kind)) {
            let geometry=crate::fow_character_geometry::native_character(&unit.definition,None)?;
            let radius=openleague_core::vision::native_base_radius(&unit.definition).ok_or("missing native unit perception radius")?;
            if !unit.position.finite() || !radius.is_finite() || radius<=0. {return Err("invalid unit vision input");}
            if desired.insert(unit.id,Observation {position:unit.position,modifiers:unit.vision_radius_modifiers,geometry,radius}).is_some() {return Err("duplicate network vision identity");}
        }
'''+needle
assert needle in s;s=s.replace(needle,new,1).replace('for (id,(p,geometry,radius)) in desired {','for (id,observation) in desired {\n            let Observation {position,modifiers,geometry,radius}=observation;').replace('[p.position.x,p.position.z]','[position.x,position.z]').replace('modifiers:p.vision_radius_modifiers','modifiers').replace('Living allied champions only; NPC, altar, ward, stealth and spectator vision missing.','Allied champions/lane/pet/turret/fountain sources only; altar, ward, stealth and spectator vision missing.')
# The broad replacement touched the champion Observation input; restore the real field.
s=s.replace('position:p.position,modifiers,geometry,radius','position:p.position,modifiers:p.vision_radius_modifiers,geometry,radius')
s+='''
/// Preserves current server eligibility; native full actor/filter producers remain open.
fn unit_gives_vision(kind:openleague_core::world::Kind)->bool {
    kind.lane() || matches!(kind,openleague_core::world::Kind::Pet|openleague_core::world::Kind::Turret|openleague_core::world::Kind::Fountain)
}
#[cfg(test)] mod unit_tests {
    use super::*;
    use openleague_core::world::Kind;
    #[test] fn unit_sources_follow_eligibility_overlap_death_modifiers_and_removal() {
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut simulation=openleague_core::Simulation::new(nav).unwrap();simulation.enable_map10().unwrap();let viewer=simulation.join("garen").unwrap();
        let mut snapshot=simulation.snapshot();snapshot.session=88;
        let template=snapshot.units.iter().find(|u|u.kind==Kind::Turret).unwrap().clone();snapshot.units.clear();
        let team=snapshot.players.iter().find(|p|p.id==viewer).unwrap().team;
        let definitions=[(Kind::Melee,"Blue_Minion_Basic"),(Kind::Caster,"Blue_Minion_Wizard"),(Kind::Siege,"Blue_Minion_MechCannon"),(Kind::Super,"Blue_Minion_MechMelee"),(Kind::Pet,"AnnieTibbers"),(Kind::Turret,"TT_OrderTurret1"),(Kind::Fountain,"TT_OrderTurret4"),(Kind::Monster,"TT_NWolf"),(Kind::Boss,"TT_Spiderboss"),(Kind::Inhibitor,"TT_OrderInhibitor"),(Kind::Nexus,"OrderNexus")];
        for (i,(kind,definition)) in definitions.iter().enumerate() {let mut u=template.clone();u.id=50000+i as u32;u.team=team;u.kind=*kind;u.definition=definition.to_string();u.health=100.;u.position=openleague_core::Point {x:7684.,z:6934.};snapshot.units.push(u);}
        let mut enemy=snapshot.units[0].clone();enemy.id=60000;enemy.team=1-team;snapshot.units.push(enemy);
        let mut map=Map10VisionView::native_map10().unwrap();let mut sources=Sources::default();sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert_eq!(sources.factory.source_count(),8);
        for i in 0..7 {assert!(sources.active.contains_key(&(50000+i)));}for i in 7..11 {assert!(!sources.active.contains_key(&(50000+i)));}assert!(!sources.active.contains_key(&60000));
        for _ in 0..20 {sources.process(&map,[7684.,6934.],0.,1./30.).unwrap();}assert!(map.view.lock().unwrap().circle.layer.counts.iter().any(|v|*v>1));
        let melee=sources.active[&50000].clone();snapshot.tick+=1;snapshot.units[0].vision_radius_modifiers.percent_bubble_radius_mod=-0.5;snapshot.units[0].position.x+=100.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();{let strong=melee.upgrade().unwrap();let s=strong.lock().unwrap();assert_eq!(s.parameters.radius,1200.);assert_eq!(s.parameters.scale,0.5);assert_eq!(s.position.center[0],7784.);}
        snapshot.tick+=1;snapshot.units[0].health=0.;sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert!(melee.upgrade().is_none());assert_eq!(sources.factory.source_count(),7);
        snapshot.tick+=1;snapshot.units.clear();sources.synchronize(&snapshot,viewer,&mut map).unwrap();assert_eq!(sources.factory.source_count(),1);assert!(map.view.lock().unwrap().circle.pending.entries().iter().all(|e|e.source==sources.active[&viewer].as_ptr() as usize));
    }
}
'''
p.write_text(s,encoding='utf-8')
print('NPC resource probe and unit source consumer installed')
