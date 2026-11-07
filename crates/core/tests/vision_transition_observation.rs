//! Observations of current local vision transitions, not recovered Riot server policy.
use openleague_core::{Action, Navigation, Point, Simulation};

fn game(slot: u8) -> (Simulation, u32, u32) {
    let mut cells = Vec::new();
    for _ in 0..1600 {
        cells.extend(0f32.to_le_bytes());
        cells.extend(0u16.to_le_bytes());
        cells.extend(0u32.to_le_bytes());
        cells.push(1);
    }
    let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":40,"height":40}"#, &cells).unwrap();
    let mut simulation = Simulation::new(nav).unwrap();
    simulation.enable_map10().unwrap();
    simulation.units.clear();
    let owner = simulation.join("annie").unwrap();
    let target = simulation.join("garen").unwrap();
    simulation.players.get_mut(&owner).unwrap().position = Point { x:100., z:100. };
    simulation.players.get_mut(&target).unwrap().position = Point { x:300., z:100. };
    simulation.learn(owner, slot).unwrap();
    assert!(simulation.visible_to(simulation.players[&owner].team, target));
    (simulation, owner, target)
}

fn hide(simulation: &mut Simulation, owner: u32, target: u32) {
    simulation.players.get_mut(&owner).unwrap().vision_radius_modifiers.percent_bubble_radius_mod = -1.;
    assert!(!simulation.visible_to(simulation.players[&owner].team, target));
    assert!(!simulation.snapshot_for(owner).unwrap().players.iter().any(|p| p.id == target));
}

#[test]
fn hidden_target_before_commit_is_refused_without_spending() {
    let (mut simulation, owner, target) = game(0);
    hide(&mut simulation, owner, target);
    let before = (simulation.players[&owner].mana, simulation.players[&owner].cooldowns);
    let result = simulation.command(owner, Action::Cast { slot:0, target:Some(target) });
    assert!(result.unwrap_err().contains("visible"));
    assert_eq!((simulation.players[&owner].mana, simulation.players[&owner].cooldowns), before);
    assert!(simulation.snapshot().spell_projectiles.is_empty());
}

fn committed_projectile(hide_before_release: bool) {
    let (mut simulation, owner, target) = game(0);
    let health = simulation.players[&target].health;
    simulation.command(owner, Action::Cast { slot:0, target:Some(target) }).unwrap();
    if hide_before_release { hide(&mut simulation, owner, target); }
    while simulation.tick < 8 { simulation.advance(); }
    assert_eq!(simulation.snapshot().spell_projectiles.len(), 1);
    if !hide_before_release { hide(&mut simulation, owner, target); }
    assert!(simulation.snapshot_for(owner).unwrap().spell_projectiles.is_empty());
    while simulation.tick < 20 { simulation.advance(); }
    assert!(simulation.players[&target].health < health);
    assert!(simulation.snapshot().spell_projectiles.is_empty());
    assert!(!simulation.snapshot_for(owner).unwrap().players.iter().any(|p| p.id == target));
}

#[test]
fn loss_during_committed_cast_does_not_cancel_current_local_q() { committed_projectile(true); }

#[test]
fn released_current_local_q_hits_hidden_target_but_is_not_projected_to_owner() { committed_projectile(false); }

#[test]
fn current_local_cone_hits_hidden_enemy_without_publishing_its_state() {
    let (mut simulation, owner, target) = game(1);
    hide(&mut simulation, owner, target);
    let health = simulation.players[&target].health;
    simulation.command(owner, Action::CastAt { slot:1, point:Point { x:900., z:100. } }).unwrap();
    while simulation.tick < 10 { simulation.advance(); }
    assert!(simulation.players[&target].health < health);
    assert!(!simulation.snapshot_for(owner).unwrap().players.iter().any(|p| p.id == target));
}
