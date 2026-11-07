//! Current local lifecycle/vision observations; not historical server equivalence.
use openleague_core::{damage::DamageKind, Navigation, Point, Simulation};
fn game() -> (Simulation,u32,u32) {
    let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s=Simulation::new(nav).unwrap(); s.enable_map10().unwrap(); s.units.clear();
    let a=s.join("annie").unwrap(); let b=s.join("garen").unwrap();
    (s,a,b)
}
#[test]
fn death_removes_champion_vision_and_due_respawn_restores_it() {
    let (mut s,a,b)=game(); let spawn=s.players[&a].position;
    s.players.get_mut(&b).unwrap().position=Point{x:spawn.x+10.,z:spawn.z};
    let team=s.players[&a].team;
    assert!(s.visible_to(team,b));
    s.apply_damage(None,a,1_000_000.,DamageKind::True).unwrap();
    assert!(s.players[&a].health<=0.);
    assert!(!s.visible_to(team,b));
    assert!(!s.snapshot_for(a).unwrap().players.iter().any(|p|p.id==b));
    // Exercise the actual due-respawn consumer, not the historical timer policy.
    s.players.get_mut(&a).unwrap().respawn_at=Some(s.tick+1);
    s.advance();
    assert!(s.players[&a].health>0.);
    assert!(s.visible_to(team,b));
    assert!(s.snapshot_for(a).unwrap().players.iter().any(|p|p.id==b));
}
#[test]
fn summoned_tibbers_supplies_vision_until_actual_expiration_consumer() {
    let (mut s,a,b)=game();
    let point=s.navigation.nearest_walkable(Point{x:7700.,z:7000.}).unwrap();
    s.players.get_mut(&a).unwrap().position=point;
    s.players.get_mut(&b).unwrap().position=Point{x:point.x+100.,z:point.z};
    let team=s.players[&a].team;
    assert!(s.visible_to(team,b));
    { let p=s.players.get_mut(&a).unwrap(); p.level=18;p.mana=1000.;p.vision_radius_modifiers.percent_bubble_radius_mod=-1.; }
    assert!(!s.visible_to(team,b)); s.learn(a,3).unwrap();s.cast_at(a,3,point).unwrap();
    for _ in 0..8 {s.advance();}
    let pet=s.units.values().find(|u|u.pet.is_some()).expect("actual R creates Tibbers");
    let id=pet.id; let expires=pet.pet.as_ref().unwrap().expires;
    assert!(s.visible_to(team,b));
    // Controlled clock jump isolates expiration; does not simulate all intervening ticks.
    s.tick=expires-1;s.advance();
    assert!(s.units.get(&id).is_none_or(|u|u.health<=0.));
    assert!(!s.visible_to(team,b));
    assert!(!s.snapshot_for(a).unwrap().players.iter().any(|p|p.id==b));
}
