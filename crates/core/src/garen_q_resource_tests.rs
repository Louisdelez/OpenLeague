//! Registry integration regression; existing combat policy, not native Q timing.
use crate::*;
use attack_presentation::{Kind, Phase};

fn game() -> (Simulation, u32, u32) {
    let mut cells = Vec::new();
    for _ in 0..400 {
        cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes());
        cells.extend(0u32.to_le_bytes()); cells.push(1);
    }
    let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#, &cells).unwrap();
    let mut s = Simulation::new(nav).unwrap();
    let a = s.join("garen").unwrap(); let b = s.join("garen").unwrap();
    s.players.get_mut(&a).unwrap().position = Point { x:100., z:100. };
    s.players.get_mut(&b).unwrap().position = Point { x:150., z:100. };
    s.players.get_mut(&a).unwrap().ranks[0] = 1;
    (s, a, b)
}

#[test]
fn q_registry_server_binding_preserves_current_release_and_hit_consumption() {
    let (mut s, a, b) = game();
    assert!(std::ptr::eq(s.garen_q_resource, garen_q_resource::binding().unwrap()));
    s.cast(a, 0, None).unwrap();
    s.command(a, Action::Attack { target:b }).unwrap();
    s.tick += 1; s.advance_attacks();
    let w = s.players[&a].windup.clone().unwrap();
    let attack = w.presentation.unwrap();
    assert_eq!(w.release-w.started, attacks::windup_ticks("garen", s.stats(a).attack_cooldown_ticks));
    assert!(w.cancelable); // Authored Q flag true does not rewrite global order policy.
    let start = s.snapshot().attack_events.into_iter().find(|e| e.attack==attack).unwrap();
    assert_eq!(start.phase, Phase::Started { kind:s.garen_q_resource.kind_at_observation(true, false) });
    let hp = s.players[&b].health;
    let expected = damage::mitigate(1.4*s.stats(a).damage+spells::garen_value(0,"Effect1",1),
        damage::DamageKind::Physical,s.stats(b).armor,s.stats(b).magic_resist,1.).unwrap();
    s.tick = w.release-1; s.advance_attacks(); assert_eq!(s.players[&b].health,hp);
    s.tick = w.release; s.advance_attacks();
    assert!((hp-s.players[&b].health-expected).abs()<0.001);
    assert_eq!(s.players[&a].effects.empowered_until,0);
    assert_eq!(s.players[&b].effects.silence_until,s.tick+45);
    assert!(s.snapshot().attack_events.iter().any(|e| e.attack==attack &&
        matches!(e.phase,Phase::Resolved{kind:Kind::GarenQ,hit_succeeded:true})));
}

#[test]
fn q_registry_authored_flag_does_not_change_current_move_stop_policy() {
    for moving in [false,true] {
        let (mut s, a, b) = game();
        assert!(s.garen_q_resource.authored().cant_cancel_while_winding_up);
        s.cast(a,0,None).unwrap(); s.command(a,Action::Attack{target:b}).unwrap();
        s.tick += 1; s.advance_attacks();
        let w=s.players[&a].windup.clone().unwrap(); let hp=s.players[&b].health;
        assert!(s.command(a,Action::Move{point:Point{x:f32::NAN,z:100.}}).is_err());
        assert_eq!(s.players[&a].windup.as_ref().unwrap().release,w.release);
        s.command(a,if moving {Action::Move{point:Point{x:300.,z:100.}}} else {Action::Stop}).unwrap();
        assert!(s.players[&a].windup.is_none());
        assert_eq!(s.players[&b].health,hp);
        assert!(s.players[&a].effects.empowered_until>s.tick);
    }
}
