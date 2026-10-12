//! Actual Bevy AnimationPlayer/animate system tests. Controlled snapshots;
//! no renderer, server AI, window or native Riot animation caller is claimed.
use super::*;
use crate::vilemaw_attack_animation::tests::{all, facts, snapshot, SOURCE};
use openleague_core::attack_presentation::Kind;

fn state() -> Match {
    let mut state = Match::default(); state.attack_visuals.reset(7); state.w_visuals.reset(7);
    state.vilemaw_visuals.reset(7); state.missile_journal.reset(7); state
}
fn actor(playback: Playback) -> Actor {
    Actor { playback, role: "idle".into(), previous_attack:0, attack_until:0, critical:false, presentation:None }
}
fn publish(app: &mut App, snapshot: openleague_core::Snapshot, now: f64) {
    app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now = now;
    let mut state = app.world_mut().resource_mut::<Match>();
    crate::garen_w_live::accept_presentations(&mut state, &snapshot, now).unwrap();
    state.snapshot = Some(snapshot); app.update();
}
fn seek(app: &App, entity: Entity) -> f32 {
    let actor = app.world().get::<Actor>(entity).unwrap();
    app.world().get::<AnimationPlayer>(entity).unwrap().animation(actor.playback.roles["attack"]).unwrap().seek_time()
}
fn synthetic() -> (App, Entity) {
    let mut clips = Assets::<AnimationClip>::default(); let mut attack = AnimationClip::default(); attack.set_duration(55. / 30.);
    let handle = clips.add(attack);
    let playback = Playback { id:SOURCE, model_name:"TT_Spiderboss".into(), graph:Handle::default(), _model:Handle::default(),
        roles:HashMap::from([("idle".into(),AnimationNodeIndex::new(0)),("attack".into(),AnimationNodeIndex::new(1)),("death".into(),AnimationNodeIndex::new(2))]),
        clips:HashMap::from([("attack".into(),handle)]), durations:HashMap::new() };
    let mut app = App::new(); app.init_resource::<Time>().init_resource::<crate::native_effect_clock::EffectClock>()
        .insert_resource(clips).insert_resource(state()).add_systems(Update, animate);
    let entity = app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),actor(playback),
        Transform::from_rotation(Quat::from_rotation_y(1.5707964)))).id();
    (app, entity)
}

#[test]
fn real_catalog_gltf_clip_supplies_duration_and_actual_player_seeks_without_impact_restart() {
    use bevy::{asset::RenderAssetUsages, gltf::{GltfLoaderSettings, GltfPlugin}, ecs::system::RunSystemOnce};
    // Use the real loader and animation channels, but deliberately omit geometry
    // and materials in this CPU-only check. No synthetic duration substitutes.
    let asset_path = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../assets");
    let mut app = App::new();
    app.add_plugins((MinimalPlugins,AssetPlugin { file_path:asset_path.to_str().unwrap().into(), ..default() },GltfPlugin::default()))
        .init_asset::<bevy::world_serialization::WorldAsset>().init_asset::<AnimationClip>().init_asset::<AnimationGraph>()
        .init_asset::<Mesh>().init_asset::<Image>().init_asset::<bevy::mesh::skinning::SkinnedMeshInverseBindposes>()
        .init_resource::<Catalog>().init_resource::<crate::native_effect_clock::EffectClock>().insert_resource(state());
    app.finish(); app.cleanup();
    let catalog = Catalog::default(); let entry = &catalog.0["TT_Spiderboss"];
    assert_eq!(entry["roles"]["attack"].as_u64(),Some(3));
    assert_eq!(entry["clips"][3].as_str(),Some("TT_Spiderboss_attack1"));
    let model: Handle<Gltf> = app.world().resource::<AssetServer>().load_with_settings(entry["asset"].as_str().unwrap().to_owned(),
        |settings: &mut GltfLoaderSettings| { settings.load_meshes=RenderAssetUsages::empty(); settings.load_materials=RenderAssetUsages::empty(); });
    let deadline = std::time::Instant::now()+std::time::Duration::from_secs(30);
    loop {
        app.update();
        if let Some(gltf)=app.world().resource::<Assets<Gltf>>().get(&model) {
            if gltf.animations.get(3).is_some_and(|clip|app.world().resource::<Assets<AnimationClip>>().contains(clip)) { break; }
        }
        assert!(std::time::Instant::now()<deadline,"real Vilemaw GLTF animation load timed out");
        std::thread::sleep(std::time::Duration::from_millis(5));
    }
    let root = app.world_mut().spawn((ModelRequest { id:SOURCE,name:"TT_Spiderboss".into(),model },
        Transform::from_rotation(Quat::from_rotation_y(1.5707964)))).id();
    app.world_mut().run_system_once(load_models).unwrap();
    let playback=app.world().get::<Playback>(root).unwrap().clone();
    let duration=app.world().resource::<Assets<AnimationClip>>().get(&playback.clips["attack"]).unwrap().duration();
    assert!((duration-1.833333373).abs()<0.00001);
    let rotation=app.world().get::<Transform>(root).unwrap().rotation;
    let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),actor(playback))).id();
    app.add_systems(Update,animate);
    let mut facts=facts(); publish(&mut app,snapshot(0,&facts,None),0.);
    let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();
    publish(&mut app,snapshot(31,&facts,Some(attack)),0.7);
    assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
    assert!((seek(&app,entity)-0.7).abs()<0.00001,"the old twelve-tick window must not select idle");
    let index=app.world().get::<Actor>(entity).unwrap().playback.roles["attack"];
    app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.95);
    facts.resolve(attack,40,Kind::Basic,true,all()).unwrap(); publish(&mut app,snapshot(40,&facts,None),1.);
    assert_eq!(seek(&app,entity),0.95,"resolution must not call play/seek again for the same identity");
    let next=facts.begin(SOURCE,56,86,Kind::Basic,all()).unwrap(); publish(&mut app,snapshot(57,&facts,Some(next)),1.57);
    assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,Some((next.id,Kind::Basic)));
    assert!((seek(&app,entity)-1./30.).abs()<0.00001);
    assert_eq!(app.world().get::<Transform>(root).unwrap().rotation,rotation,"no root orientation change");
}

#[test]
fn actual_player_fog_return_resumes_age_and_missing_active_return_does_not_replay() {
    let (mut app,entity)=synthetic();let mut facts=facts();publish(&mut app,snapshot(0,&facts,None),0.);
    let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();publish(&mut app,snapshot(11,&facts,Some(attack)),0.);
    let mut hidden=snapshot(12,&facts,None);hidden.units.clear();hidden.vilemaw_attack_events.clear();
    // Receive observes both intermediate packets before one animate frame.
    {let mut state=app.world_mut().resource_mut::<Match>();crate::garen_w_live::accept_presentations(&mut state,&hidden,0.1).unwrap();}
    publish(&mut app,snapshot(20,&facts,Some(attack)),0.5);
    // Same existing Actor is not restarted just because a packet was hidden.
    assert!((seek(&app,entity)-1./30.).abs()<0.00001);
    // A real recreated AnimationPlayer after despawn must instead seek the
    // preserved age. This exercises binding, not zero-origin playback.
    let playback=app.world().get::<Actor>(entity).unwrap().playback.clone();
    app.world_mut().despawn(entity);
    let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),actor(playback))).id();
    app.update(); assert!(seek(&app,entity)>0.5);
    let mut hidden=snapshot(21,&facts,None);hidden.units.clear();hidden.vilemaw_attack_events.clear();
    {let mut state=app.world_mut().resource_mut::<Match>();crate::garen_w_live::accept_presentations(&mut state,&hidden,0.6).unwrap();}
    facts.resolve(attack,40,Kind::Basic,true,all()).unwrap();publish(&mut app,snapshot(40,&facts,None),1.);
    assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
}

#[test]
fn actual_player_death_stun_and_running_win_and_expiry_never_falls_back_to_next_attack() {
    for block in 0..4 {
        let (mut app,entity)=synthetic();let mut facts=facts();publish(&mut app,snapshot(0,&facts,None),0.);
        let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();publish(&mut app,snapshot(11,&facts,Some(attack)),0.);
        let mut blocked=snapshot(12,&facts,Some(attack));
        match block {
            0=>{blocked.units[0].health=0.;blocked.units[0].attack_presentation=None;},
            1=>blocked.units[0].stuns.push(openleague_core::stuns::Stun {tag:"fixture".into(),source:None,expires_at:13}),
            2=>blocked.units[0].destination=Some(openleague_core::Point{x:100.,z:75.}),
            _=>{},
        }
        let now=if block==3 {2.} else {0.1};publish(&mut app,blocked,now);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,if block==0 {"death"} else {"idle"});
        assert!(app.world().get::<Actor>(entity).unwrap().presentation.is_none());
        let mut next=snapshot(13,&facts,Some(attack));next.units[0].next_attack=9999;
        publish(&mut app,next,now);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }
}

#[test]
fn missing_clip_stays_idle_then_loading_it_seeks_current_age() {
    let (mut app,entity)=synthetic();let mut facts=facts();publish(&mut app,snapshot(0,&facts,None),0.);
    let handle=app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.remove("attack").unwrap();
    let attack=facts.begin(SOURCE,10,40,Kind::Basic,all()).unwrap();publish(&mut app,snapshot(31,&facts,Some(attack)),0.7);
    assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.insert("attack".into(),handle);
    app.update();assert!((seek(&app,entity)-0.7).abs()<0.00001);
}
