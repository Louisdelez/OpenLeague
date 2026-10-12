use super::*;
use openleague_core::{Champion, Navigation, Point, Simulation, entity_facing::Facing};

fn champion(name:&str)->Champion {
    let mut cells=Vec::new();for _ in 0..400 {cells.extend(0_f32.to_le_bytes());cells.extend(0_u16.to_le_bytes());cells.extend(0_u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
    let mut game=Simulation::new(nav).unwrap();let id=game.join(name).unwrap();game.players.remove(&id).unwrap()
}
fn heading(direction:[f32;3])->Facing {Facing::from_direction(direction).unwrap().unwrap()}

#[test]
fn authoritative_yaw_renders_same_forward_as_all_native_nonzero_cases_after_wire_roundtrip() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_yaw_contract.json")).unwrap();
    let mut count=0;
    for case in proof["cases"].as_array().unwrap() {
        let direction=std::array::from_fn(|i|f32::from_bits(case["direction_bits"][i].as_u64().unwrap() as u32));
        let Some(facing)=Facing::from_direction(direction).unwrap() else {continue;};count+=1;
        let wire=serde_json::to_string(&facing).unwrap();let decoded:Facing=serde_json::from_str(&wire).unwrap();
        let rotation=from_facing(decoded).unwrap();let expected=from_native_delta(direction).unwrap().unwrap();
        assert_eq!(rotation,expected);
        let native=Vec3::new(f32::from_bits(case["output_frame_bits"][8].as_u64().unwrap() as u32),f32::from_bits(case["output_frame_bits"][9].as_u64().unwrap() as u32),f32::from_bits(case["output_frame_bits"][10].as_u64().unwrap() as u32)).normalize();
        assert!((rotation*Vec3::Z-native).length()<2e-6);
    }
    assert_eq!(count,108);
}

#[test]
fn stationary_backwards_root_and_first_seen_post_hit_use_heading_without_changing_position_scale() {
    let mut player=champion("garen");player.position=Point{x:100.,z:100.};
    for direction in [[1.,0.,0.],[-1.,0.,0.],[0.,0.,1.],[0.,0.,-1.],[50.,0.,-50.]] {
        let old=player.clone();player.facing=Some(heading(direction));
        let mut root=Transform::from_xyz(5.,3.,5.).with_scale(Vec3::splat(0.05));
        root.rotation=from_native_delta([-direction[0],0.,-direction[2]]).unwrap().unwrap();
        let before=root;apply_snapshot(&mut root,Some(&old),&player);
        assert_eq!(root.translation,before.translation);assert_eq!(root.scale,before.scale);
        assert!((root.rotation*Vec3::Z).dot(Vec3::from_array(direction).normalize())>0.999);
        // The transient windup is absent, including on first sight after the hit.
        assert!(player.windup.is_none());let mut first=Transform::default();apply_snapshot(&mut first,None,&player);
        assert_eq!(root.rotation,first.rotation);
        let saved=root.rotation;apply_snapshot(&mut root,Some(&player),&player);assert_eq!(root.rotation,saved);
    }
}

#[test]
fn legacy_displacement_respawn_and_new_root_keep_explicit_unknown_policy() {
    let mut player=champion("garen");player.position=Point{x:100.,z:100.};let mut old=player.clone();
    let mut root=Transform::from_rotation(Quat::from_rotation_y(0.7));apply_snapshot(&mut root,Some(&old),&player);assert_eq!(root.rotation,Quat::from_rotation_y(0.7));
    player.position.x+=20.;apply_snapshot(&mut root,Some(&old),&player);assert_eq!(root.rotation,from_native_delta([20.,0.,0.]).unwrap().unwrap());
    old=player.clone();old.facing=Some(heading([1.,0.,0.]));old.health=0.;old.respawn_at=Some(10);
    player.position=Point{x:500.,z:500.};player.facing=None;player.health=100.;player.respawn_at=None;
    apply_snapshot(&mut root,Some(&old),&player);assert_eq!(root.rotation,Quat::IDENTITY);
    // A replaced session root starts with the actual existing spawn default.
    let mut fresh=Transform::default();apply_snapshot(&mut fresh,None,&player);assert_eq!(fresh.rotation,Quat::IDENTITY);
}

#[test]
fn annie_w_priority_survives_end_of_cast_and_movement_resumes_without_garen_heading() {
    let mut player=champion("annie");player.position=Point{x:100.,z:100.};assert!(player.facing.is_none());
    let old=player.clone();player.position.x+=10.;
    player.effects.annie_w=Some(openleague_core::annie_w::Pending{direction:Point{x:0.,z:-1.},releases:10,raw:1.});
    let mut root=Transform::default();apply_snapshot(&mut root,Some(&old),&player);
    let cast_rotation=from_native_delta([0.,0.,-1.]).unwrap().unwrap();assert_eq!(root.rotation,cast_rotation);
    let casting=player.clone();player.effects.annie_w=None;apply_snapshot(&mut root,Some(&casting),&player);assert_eq!(root.rotation,cast_rotation);
    let stopped=player.clone();player.position.x+=10.;apply_snapshot(&mut root,Some(&stopped),&player);
    assert_eq!(root.rotation,from_native_delta([10.,0.,0.]).unwrap().unwrap());
}
