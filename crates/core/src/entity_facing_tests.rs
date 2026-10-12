use super::*;
use crate::{Action, Navigation, Point, Simulation};

fn game() -> (Simulation,u32,u32) {
    let mut cells=Vec::new();
    for _ in 0..6400 {cells.extend(0_f32.to_le_bytes());cells.extend(0_u16.to_le_bytes());cells.extend(0_u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
    let mut game=Simulation::new(nav).unwrap(); game.session=11;
    let a=game.join("garen").unwrap();let b=game.join("garen").unwrap();
    game.players.get_mut(&a).unwrap().position=Point{x:200.,z:200.};
    game.players.get_mut(&b).unwrap().position=Point{x:250.,z:200.};
    (game,a,b)
}
fn facing(direction:[f32;3])->Facing {Facing::from_direction(direction).unwrap().unwrap()}

#[test]
fn facing_serialized_yaw_retains_all_111_native_matrices_and_rejects_bad_wire() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_yaw_contract.json")).unwrap();
    assert_eq!(proof["cases"].as_array().unwrap().len(),111);
    for case in proof["cases"].as_array().unwrap() {
        let direction=std::array::from_fn(|i|f32::from_bits(case["direction_bits"][i].as_u64().unwrap() as u32));
        let initial:[u32;19]=std::array::from_fn(|i|case["initial_frame_bits"][i].as_u64().unwrap() as u32);
        let mut direct=initial;crate::entity_yaw::update(&mut direct,direction).unwrap();
        let Some(facing)=Facing::from_direction(direction).unwrap() else {assert_eq!(direct,initial);continue;};
        let text=serde_json::to_string(&facing).unwrap();let restored:Facing=serde_json::from_str(&text).unwrap();
        assert_eq!(restored.yaw_degrees().to_bits(),facing.yaw_degrees().to_bits());
        let mut actual=initial;crate::entity_yaw::apply_angle(&mut actual,restored.yaw_degrees()).unwrap();
        assert_eq!(actual,direct);
        for i in 0..19 {assert_eq!(actual[i],case["output_frame_bits"][i].as_u64().unwrap() as u32);}
    }
    for value in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY,0.01,-360.01] {assert!(Facing::from_yaw(value).is_err());}
    for text in [r#"{"yaw_degrees":1}"#,r#"{"yaw_degrees":-361}"#,r#"{"yaw_degrees":null}"#,r#"{"yaw_degrees":1e100}"#,r#"{"yaw_degrees":-90,"target":42}"#] {assert!(serde_json::from_str::<Facing>(text).is_err());}
    let mut frame=[0xA5A5A5A5;19];assert!(crate::entity_yaw::apply_angle(&mut frame,f32::NAN).is_err());assert_eq!(frame,[0xA5A5A5A5;19]);
}

#[test]
fn stationary_attack_turns_at_start_tracks_valid_target_and_survives_hit_between_snapshots() {
    let (mut game,a,b)=game();let origin=game.players[&a].position;
    game.players.get_mut(&a).unwrap().facing=Some(facing([-1.,0.,0.]));
    let before_hp=game.players[&b].health;
    game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    assert_eq!(game.players[&a].position,origin);assert_eq!(game.players[&a].facing,Some(facing([50.,0.,0.])));
    let release=game.players[&a].windup.as_ref().unwrap().release;
    // Controlled unit test relocation, not a normal-runtime evidence claim.
    game.players.get_mut(&b).unwrap().position=Point{x:200.,z:150.};game.advance();
    let expected=facing([0.,0.,-50.]);assert_eq!(game.players[&a].facing,Some(expected));
    while game.tick<release {game.advance();}
    assert!(game.players[&a].windup.is_none());assert!(game.players[&b].health<before_hp);
    let snapshot=game.snapshot_for(a).unwrap();
    assert_eq!(snapshot.players.iter().find(|p|p.id==a).unwrap().facing,Some(expected));
    assert_eq!(game.players[&a].position,origin);
    assert!(snapshot.attack_events.iter().any(|e|matches!(e.phase,crate::attack_presentation::Phase::Resolved{hit_succeeded:true,..})));
}

#[test]
fn cancellation_disappearance_and_changed_target_keep_then_replace_physical_heading() {
    let (mut game,a,b)=game();game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    let first=game.players[&a].facing;game.command(a,Action::Stop).unwrap();assert_eq!(game.players[&a].facing,first);
    game.advance();assert_eq!(game.players[&a].facing,first);
    game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    game.remove_player(b);game.advance();assert!(game.players[&a].windup.is_none());assert_eq!(game.players[&a].facing,first);
    let c=game.join("garen").unwrap(); // Team alternation depends on current session population.
    game.players.get_mut(&c).unwrap().team=1;
    game.players.get_mut(&c).unwrap().position=Point{x:150.,z:200.};
    game.command(a,Action::Attack{target:c}).unwrap();assert_eq!(game.players[&a].facing,first);
    game.advance();assert_eq!(game.players[&a].facing,Some(facing([-50.,0.,0.])));
}

#[test]
fn actual_movement_replaces_heading_and_zero_or_invalid_delta_preserves_it() {
    let (mut game,a,b)=game();game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    game.command(a,Action::Move{point:Point{x:200.,z:350.}}).unwrap();
    let previous=game.players[&a].position;game.advance();let current=game.players[&a].position;
    assert_ne!(current,previous);assert_eq!(game.players[&a].facing,Some(facing([current.x-previous.x,0.,current.z-previous.z])));
    let saved=game.players[&a].facing;
    game.players.get_mut(&a).unwrap().capture_facing([0.,0.,0.]);assert_eq!(game.players[&a].facing,saved);
    game.players.get_mut(&a).unwrap().capture_facing([f32::NAN,0.,1.]);assert_eq!(game.players[&a].facing,saved);
}

#[test]
fn public_heading_has_no_target_distance_and_hidden_source_is_not_exported() {
    let (mut game,a,b)=game();game.enable_interactions();
    assert!(game.visible_to(1,a));
    game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    let value=serde_json::to_value(game.players[&a].facing.unwrap()).unwrap();
    assert_eq!(value.as_object().unwrap().len(),1);assert!(value.get("yaw_degrees").is_some());
    game.players.get_mut(&b).unwrap().position=Point{x:3700.,z:3700.};
    assert!(!game.visible_to(1,a));
    assert!(!game.snapshot_for(b).unwrap().players.iter().any(|p|p.id==a));
    assert_eq!(game.snapshot_for(a).unwrap().players.iter().find(|p|p.id==a).unwrap().facing,game.players[&a].facing);
}

#[test]
fn spawn_respawn_new_session_and_old_snapshot_start_with_unknown_heading() {
    let (mut game,a,_)=game();assert_eq!(game.players[&a].facing,None);
    game.players.get_mut(&a).unwrap().facing=Some(facing([1.,0.,0.]));
    game.players.get_mut(&a).unwrap().health=0.;game.players.get_mut(&a).unwrap().respawn_at=Some(1);
    game.advance();assert!(game.players[&a].health>0.);assert_eq!(game.players[&a].facing,None);
    let mut snapshot=serde_json::to_value(game.snapshot()).unwrap();
    for player in snapshot["players"].as_array_mut().unwrap() {player.as_object_mut().unwrap().remove("facing");}
    let old:crate::Snapshot=serde_json::from_value(snapshot).unwrap();assert!(old.players.iter().all(|p|p.facing.is_none()));
    let (fresh,_,_)=self::game();assert!(fresh.players.values().all(|p|p.facing.is_none()));
}

#[test]
fn q_consumption_and_control_cancellation_do_not_erase_heading_or_extend_producer_to_annie() {
    let (mut game,a,b)=game();
    // Explicit unit setup of the buff; the runtime harness uses ordinary Cast Q.
    game.players.get_mut(&a).unwrap().ranks[0]=1;
    game.players.get_mut(&a).unwrap().effects.empowered_until=100;
    game.command(a,Action::Attack{target:b}).unwrap();game.advance();
    let expected=game.players[&a].facing;let release=game.players[&a].windup.as_ref().unwrap().release;
    while game.tick<release {game.advance();}
    assert_eq!(game.players[&a].effects.empowered_until,0);assert_eq!(game.players[&a].facing,expected);
    assert!(game.snapshot().attack_events.iter().any(|e|matches!(e.phase,crate::attack_presentation::Phase::Resolved{kind:crate::attack_presentation::Kind::GarenQ,hit_succeeded:true})));
    game.tick=game.players[&a].next_attack;game.advance();assert!(game.players[&a].windup.is_some());
    game.players.get_mut(&a).unwrap().effects.spin_until=game.tick+20;game.advance();
    assert!(game.players[&a].windup.is_none());assert_eq!(game.players[&a].facing,expected);
    let c=game.join("annie").unwrap();game.players.get_mut(&c).unwrap().capture_facing([1.,0.,0.]);assert_eq!(game.players[&c].facing,None);
}
