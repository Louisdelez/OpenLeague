use super::*;
fn grid(flags: &[u16]) -> Navigation {
    let m = format!(
        "{{\"min\":[0,0,0],\"cellSize\":50,\"width\":{},\"height\":1}}",
        flags.len()
    );
    let mut bytes = Vec::new();
    for f in flags {
        bytes.extend(0f32.to_le_bytes());
        bytes.extend(f.to_le_bytes());
        bytes.extend(0u32.to_le_bytes());
        bytes.push(1);
    }
    Navigation::load(&m, &bytes).unwrap()
}
#[test]
fn walls_block_while_native_transparent_flags_allow_sight() {
    let a = Point { x: 25., z: 25. };
    let b = Point { x: 125., z: 25. };
    assert!(!grid(&[0, 2, 0]).line_of_sight(a, b));
    assert!(grid(&[0, 0x42, 0]).line_of_sight(a, b));
    assert!(grid(&[0, 0x102, 0]).line_of_sight(a, b));
}
#[test]
fn brush_hides_target_from_outside_and_separate_brushes() {
    let a = Point { x: 25., z: 25. };
    let b = Point { x: 125., z: 25. };
    assert!(!grid(&[0, 0, 1]).line_of_sight(a, b));
    assert!(grid(&[1, 1, 1]).line_of_sight(a, b));
    assert!(!grid(&[1, 0, 1]).line_of_sight(a, b));
    assert!(grid(&[1, 0, 0]).line_of_sight(a, b));
}
fn game() -> Simulation {
    let nav = Navigation::load(
        include_str!("../../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../../assets/maps/tt_navigation_grid.cells.bin"),
    )
    .unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.enable_map10().unwrap();
    s
}
#[test]
fn private_snapshots_keep_roster_without_exposing_hidden_champion_state() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    let b = s.join("ahri").unwrap();
    let view = s.snapshot_for(a).unwrap();
    assert_eq!(view.roster.len(), 2);
    assert_eq!(view.players.len(), 1);
    assert!(!view.players.iter().any(|p| p.id == b));
    assert!(s
        .command(a, Action::Attack { target: b })
        .unwrap_err()
        .contains("visible"));
    assert!(s.snapshot_for(999).is_none());
}
#[test]
fn shared_allied_vision_reveals_then_lost_vision_cancels_pursuit() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    let b = s.join("ahri").unwrap();
    let ally = s.join("garen").unwrap();
    let pos = s.players[&a].position;
    s.players.get_mut(&b).unwrap().position = pos;
    s.players.get_mut(&ally).unwrap().position = pos;
    assert!(s.visible_to(0, b));
    s.command(a, Action::Attack { target: b }).unwrap();
    s.players.get_mut(&b).unwrap().position = Point {
        x: 14321.,
        z: 7235.,
    };
    s.advance_pursuit();
    assert!(s.players[&a].target.is_none());
    assert!(!s.visible_to(0, b));
}
#[test]
fn enemy_altar_presence_reveals_even_without_nearby_allied_champion() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    let b = s.join("ahri").unwrap();
    let pos = s.interactions.as_ref().unwrap().state.altars[0].position;
    s.interactions.as_mut().unwrap().state.altars[0].owner = Some(0);
    s.players.get_mut(&b).unwrap().position = pos;
    assert!(s.snapshot_for(a).unwrap().players.iter().any(|p| p.id == b));
    s.interactions.as_mut().unwrap().state.altars[0].owner = None;
    assert!(!s.visible_to(0, b));
}

#[test] fn native_radius_fields_initialize_and_reset_to_original_stat_bits() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../../data/4.20/fow_stat_fields_contract.json")).unwrap();
    for c in proof["cases"].as_array().unwrap() {
        let mut state=RadiusModifiers {flat_bubble_radius_mod:c["initial"][0].as_f64().unwrap() as f32,percent_bubble_radius_mod:c["initial"][1].as_f64().unwrap() as f32};
        state.reset();let actual=[state.flat_bubble_radius_mod.to_bits(),state.percent_bubble_radius_mod.to_bits()];
        for i in 0..2 {assert_eq!(actual[i],c["result_bits"][i].as_u64().unwrap() as u32);}
    }
}
#[test] fn actor_radius_state_controls_authoritative_visibility_and_survives_snapshot() {
    let mut s=game();let a=s.join("garen").unwrap();let b=s.join("ahri").unwrap();s.units.clear();
    let center=s.navigation.center(s.navigation.metadata.width*s.navigation.metadata.height/2);
    let origin=(0..s.navigation.cells.len()).filter(|&i|s.navigation.cells[i].1&&s.navigation.cells[i].2&1==0)
        .map(|i|s.navigation.center(i)).min_by(|a,b|a.distance(center).total_cmp(&b.distance(center))).unwrap();
    let target=(0..s.navigation.cells.len()).filter(|&i|s.navigation.cells[i].1&&s.navigation.cells[i].2&1==0).map(|i|s.navigation.center(i))
        .find(|p|p.distance(origin)>700.&&p.distance(origin)<1000.&&s.navigation.line_of_sight(origin,*p)).unwrap();
    s.players.get_mut(&a).unwrap().position=origin;s.players.get_mut(&b).unwrap().position=target;
    assert!(s.visible_to(0,b));
    s.players.get_mut(&a).unwrap().vision_radius_modifiers=RadiusModifiers {flat_bubble_radius_mod:0.,percent_bubble_radius_mod:-0.75};
    assert!(!s.visible_to(0,b));let snapshot=s.snapshot_for(a).unwrap();assert!(!snapshot.players.iter().any(|p|p.id==b));
    let encoded=serde_json::to_value(&snapshot).unwrap();let decoded:Snapshot=serde_json::from_value(encoded).unwrap();
    assert_eq!(decoded.players.iter().find(|p|p.id==a).unwrap().vision_radius_modifiers,s.players[&a].vision_radius_modifiers);
    let mut legacy=serde_json::to_value(&s.players[&a]).unwrap();legacy.as_object_mut().unwrap().remove("vision_radius_modifiers");
    let legacy:Champion=serde_json::from_value(legacy).unwrap();assert_eq!(legacy.vision_radius_modifiers,RadiusModifiers::default());
    s.players.get_mut(&a).unwrap().vision_radius_modifiers.reset();assert!(s.visible_to(0,b));
}

#[test] fn native_resource_radius_selection_matches_original_branch() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../../data/4.20/fow_radius_selection_contract.json")).unwrap();
    for c in p["cases"].as_array().unwrap() {assert_eq!(select_base_radius(c["candidate"].as_f64().unwrap() as f32,1350.).to_bits(),c["result_bits"].as_u64().unwrap() as u32);}
    let profiles:serde_json::Value=serde_json::from_str(include_str!("../../../../data/4.20/native_vision_radii.json")).unwrap();
    for (name,p) in profiles["profiles"].as_object().unwrap() {assert_eq!(native_base_radius(name).unwrap(),p["resolved_radius"].as_f64().unwrap() as f32);}
    assert_eq!(native_base_radius("Garen"),Some(1350.));assert_eq!(native_base_radius("Blue_Minion_Basic"),Some(1200.));assert_eq!(native_base_radius("unknown"),None);
}
#[test] fn native_unit_modifiers_drive_shared_visibility_and_snapshot_state() {
    let mut s=game();let a=s.join("garen").unwrap();let b=s.join("ahri").unwrap();s.units.clear();s.players.get_mut(&a).unwrap().health=0.;
    let center=s.navigation.center(s.navigation.metadata.width*s.navigation.metadata.height/2);
    let origin=(0..s.navigation.cells.len()).filter(|&i|s.navigation.cells[i].1&&s.navigation.cells[i].2&1==0).map(|i|s.navigation.center(i))
        .min_by(|a,b|a.distance(center).total_cmp(&b.distance(center))).unwrap();
    let target=(0..s.navigation.cells.len()).filter(|&i|s.navigation.cells[i].1&&s.navigation.cells[i].2&1==0).map(|i|s.navigation.center(i))
        .find(|p|p.distance(origin)>700.&&p.distance(origin)<1000.&&s.navigation.line_of_sight(origin,*p)).unwrap();
    s.players.get_mut(&b).unwrap().position=target;
    let unit=s.spawn_unit("Blue_Minion_Basic","vision test minion",0,origin,0.,0.,None,None).unwrap();assert!(s.visible_to(0,b));
    s.units.get_mut(&unit).unwrap().vision_radius_modifiers=RadiusModifiers {flat_bubble_radius_mod:0.,percent_bubble_radius_mod:-0.75};
    assert!(!s.visible_to(0,b));let snapshot=s.snapshot_for(a).unwrap();assert!(!snapshot.players.iter().any(|p|p.id==b));
    let snapshot:Snapshot=serde_json::from_value(serde_json::to_value(snapshot).unwrap()).unwrap();
    assert_eq!(snapshot.units.iter().find(|u|u.id==unit).unwrap().vision_radius_modifiers,s.units[&unit].vision_radius_modifiers);
    let mut legacy=serde_json::to_value(&s.units[&unit]).unwrap();legacy.as_object_mut().unwrap().remove("vision_radius_modifiers");
    let legacy:world::Unit=serde_json::from_value(legacy).unwrap();assert_eq!(legacy.vision_radius_modifiers,RadiusModifiers::default());
    s.units.get_mut(&unit).unwrap().vision_radius_modifiers.reset();assert!(s.visible_to(0,b));
    s.units.remove(&unit);
    let building=s.spawn_unit("TT_OrderInhibitor","non-sight eligibility guard",0,origin,0.,0.,None,None).unwrap();
    s.units.get_mut(&building).unwrap().vision_radius_modifiers=RadiusModifiers {flat_bubble_radius_mod:1350.,percent_bubble_radius_mod:0.};
    assert!(!s.visible_to(0,b),"radius modifiers must not implicitly enable an unqualified building source");

}
