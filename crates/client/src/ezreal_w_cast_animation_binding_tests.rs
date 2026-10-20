//! CPU host checks of the actual player/graph path; no rendered-pixel claim.
use super::*;
use openleague_core::{Simulation, Snapshot};
use crate::ezreal_w_cast_animation::test_support::{game,cast};
use bevy::animation::{AnimationDelta,advance_animations,
    transition::{advance_transitions,expire_completed_transitions}};

fn fixture_with_clip(clip:AnimationClip)->(App,App,Simulation,u32,Entity,AnimationNodeIndex,AnimationNodeIndex) {
    let mut owner=App::new();crate::native_effect_clock::install_test_clock(&mut owner);
    owner.add_plugins(crate::native_effect_clock::Plugin);owner.update();
    let clock=owner.world_mut().remove_resource::<crate::native_effect_clock::EffectClock>().unwrap();assert!(clock.presentation_ready());
    let(game,id)=game();let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
    app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
        .init_resource::<AnimationDelta>().insert_resource(clock)
        .add_systems(Update,(animate,advance_transitions,advance_animations,expire_completed_transitions).chain());
    // Local legacy connection is an explicit readiness fixture, not real OLSR/GUI.
    app.insert_resource(crate::Connection{link:crate::session_connection::Link::legacy(),
        socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),id:Some(id),session:Some(7),sequence:0,
        last_join:std::time::Instant::now(),champion:"ezreal".into(),summoners:[None,None],rejection:String::new(),
        assembler:Default::default(),welcome_history:Default::default()});
    let clip=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
    let mut graph=AnimationGraph::new();let mut roles=HashMap::new();
    for role in ["idle","run","attack","death","spell1","spell2","spell4","stun","foreign"] {
        roles.insert(role.to_owned(),graph.add_clip(clip.clone(),1.,graph.root));
    }
    let w=roles["spell2"];let foreign=roles["foreign"];
    let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
    let playback=Playback{id,model_name:"ezreal".into(),graph:graph.clone(),_model:Handle::default(),roles,
        clips:HashMap::from([("spell1".into(),clip.clone()),("spell2".into(),clip.clone()),("spell4".into(),clip)]),durations:HashMap::new()};
    let mut player=AnimationPlayer::default();player.play(foreign).repeat();
    let entity=app.world_mut().spawn((player,AnimationTransitions::new(),AnimationGraphHandle(graph),
        EzrealRCastPose::default(),EzrealWCastPose::default(),Actor{playback,role:"idle".into(),previous_attack:0,
            attack_until:0,critical:false,presentation:None})).id();
    let mut state=Match::default();state.attack_visuals.reset(7);state.ezreal_q_cast_visuals.reset(7);
    state.ezreal_r_cast_visuals.reset(7);state.ezreal_w_cast_visuals.reset(7);
    let snapshot=game.snapshot_for(id).unwrap();state.ezreal_q_cast_visuals.observe_accepted(&snapshot,0.,true,false).unwrap();
    state.ezreal_r_cast_visuals.observe_accepted(&snapshot,0.,true,false).unwrap();
    state.ezreal_w_cast_visuals.observe_accepted(&snapshot,0.,true,false).unwrap();state.snapshot=Some(snapshot);app.insert_resource(state);
    (app,owner,game,id,entity,w,foreign)
}
fn fixture()->(App,App,Simulation,u32,Entity,AnimationNodeIndex,AnimationNodeIndex) {
    let mut clip=AnimationClip::default();clip.set_duration(1.0666667);fixture_with_clip(clip)
}
fn observe(app:&mut App,snapshot:Snapshot,now:f64) {
    let ready=app.world().resource::<crate::Connection>().ready();
    let (clock_ready,paused)={let mut clock=app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>();
        clock.now=now;(clock.presentation_ready(),clock.paused())};
    let mut state=app.world_mut().resource_mut::<Match>();state.attack_visuals.observe(&snapshot,now).unwrap();
    state.ezreal_q_cast_visuals.observe_accepted(&snapshot,now,clock_ready,paused).unwrap();
    let Match{ezreal_w_cast_visuals,ezreal_q_cast_visuals,ezreal_r_cast_visuals,..}=&mut *state;
    ezreal_r_cast_visuals.observe_with_q(&snapshot,now,clock_ready,paused,ezreal_q_cast_visuals).unwrap();
    ezreal_w_cast_visuals.observe_with_other_casts(&snapshot,now,ready&&clock_ready,paused,ezreal_q_cast_visuals,ezreal_r_cast_visuals).unwrap();
    state.snapshot=Some(snapshot);
}
fn publish(app:&mut App,snapshot:Snapshot,now:f64){observe(app,snapshot,now);app.update();}
fn retired_only_w(app:&App,entity:Entity,w:AnimationNodeIndex,foreign:AnimationNodeIndex){
    let player=app.world().get::<AnimationPlayer>(entity).unwrap();assert!(player.animation(w).is_none());
    assert!(player.animation(foreign).is_some());assert!(app.world().get::<EzrealWCastPose>(entity).unwrap().active.is_none());
}

#[test]
fn w_actual_player_uses1x_age_freezes_pause_survives_committed_control_and_stops_at_release() {
    let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);
    publish(&mut app,snapshot.clone(),0.1);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell2");
    publish(&mut app,snapshot.clone(),0.2);let player=app.world().get::<AnimationPlayer>(entity).unwrap();
    let active=player.animation(w).unwrap();assert!((active.seek_time()-0.1).abs()<0.000001);assert_eq!(active.speed(),1.);
    let mut pause=vec![0;14];pause[9..13].copy_from_slice(&30i32.to_le_bytes());pause[13]=1;
    app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(1,0xa1,&pause).unwrap();
    publish(&mut app,snapshot.clone(),0.2);
    for _ in 0..3 {app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));app.update();
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(w).unwrap().seek_time()-0.1).abs()<0.000001);}
    app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(2,0x0a,&[0;10]).unwrap();
    game.tick=104;let p=game.players.get_mut(&id).unwrap();p.effects.silence_until=120;
    p.stuns.push(openleague_core::stuns::Stun{tag:"W committed".into(),source:None,expires_at:120});
    p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:104,until:115});p.position.z+=10.;
    let controlled=game.snapshot_for(id).unwrap();assert_eq!(controlled.ezreal_w_casts.len(),1);
    publish(&mut app,controlled,0.22);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell2");
    game.tick=108;let released=game.snapshot_for(id).unwrap();assert!(released.ezreal_w_casts.is_empty());
    publish(&mut app,released,0.3);retired_only_w(&app,entity,w,foreign);
}

#[test]
fn w_same_frame_connection_loss_after_observation_removes_owned_pose_without_replay() {
    let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);
    publish(&mut app,snapshot.clone(),0.1);assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(w).is_some());
    // Fail readiness AFTER receive/observation, before the real animation system.
    observe(&mut app,snapshot.clone(),0.12);app.world_mut().resource_mut::<crate::Connection>().id=None;
    assert!(!app.world().resource::<crate::Connection>().ready());app.update();retired_only_w(&app,entity,w,foreign);
    app.world_mut().resource_mut::<crate::Connection>().id=Some(id);publish(&mut app,snapshot,0.14);retired_only_w(&app,entity,w,foreign);
    // Real Pending is observed, omitted, then restored before any animate call.
    // Coalescing to only the final Snapshot must not erase that retirement.
    let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);
    observe(&mut app,snapshot.clone(),0.1);let mut absent=snapshot.clone();absent.tick=101;absent.ezreal_w_casts.clear();
    observe(&mut app,absent,0.11);let mut restored=snapshot;restored.tick=102;observe(&mut app,restored,0.12);
    app.update();retired_only_w(&app,entity,w,foreign);
}

#[test]
fn w_clip_body_clock_and_model_loss_retire_without_stopping_foreign_q_or_r() {
    for mode in 0..6 {
        let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);publish(&mut app,snapshot.clone(),0.1);
        let(q,r)={let actor=app.world().get::<Actor>(entity).unwrap();(actor.playback.roles["spell1"],actor.playback.roles["spell4"])};
        {let mut player=app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap();player.play(q).pause();player.play(r).pause();}
        match mode {
            0=>{app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.remove("spell2");},
            1=>{let mut absent=snapshot.clone();absent.players.clear();absent.ezreal_w_casts.clear();observe(&mut app,absent,0.12);},
            2=>{app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=0.09;},
            3=>{app.world_mut().resource_mut::<Match>().snapshot=None;},
            4=>{let mut clip=AnimationClip::default();clip.set_duration(2.);let handle=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
                app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.insert("spell2".into(),handle);},
            _=>{let handle=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(AnimationGraph::new());
                app.world_mut().get_mut::<Actor>(entity).unwrap().playback.graph=handle;}
        }
        app.update();retired_only_w(&app,entity,w,foreign);
        let player=app.world().get::<AnimationPlayer>(entity).unwrap();assert!(player.animation(q).is_some());assert!(player.animation(r).is_some());
        // For the body/clock/empty-snapshot cases a restored packet still cannot replay W.
        if (1..=3).contains(&mode) {publish(&mut app,snapshot,0.14);retired_only_w(&app,entity,w,foreign);}
    }
}

#[test]
fn w_graph_reuse_keeps_foreign_node_until_exact_original_graph_returns() {
    let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);publish(&mut app,snapshot.clone(),0.1);
    let original=app.world().get::<AnimationGraphHandle>(entity).unwrap().0.clone();
    let mut clip=AnimationClip::default();clip.set_duration(5.);
    let clip=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
    let mut replacement=AnimationGraph::new();let mut indices=Vec::new();
    for _ in 0..9 {indices.push(replacement.add_clip(clip.clone(),1.,replacement.root));}
    assert_eq!(indices[5],w,"replacement graph really reuses the W node for another clip");
    let other=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(replacement);
    app.world_mut().entity_mut(entity).insert(AnimationGraphHandle(other));
    {let mut player=app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap();player.stop(w);player.play(w).set_seek_time(0.75).pause();}
    app.update();assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(w).unwrap().seek_time(),0.75);
    assert!(app.world().get::<EzrealWCastPose>(entity).unwrap().retiring);
    app.world_mut().entity_mut(entity).insert(AnimationGraphHandle(original));app.update();retired_only_w(&app,entity,w,foreign);
    publish(&mut app,snapshot,0.14);retired_only_w(&app,entity,w,foreign);
    // Missing graph similarly defers only the owned node, then retires on return.
    let(mut app,_owner,mut game,id,entity,w,foreign)=fixture();let snapshot=cast(&mut game,id);
    publish(&mut app,snapshot.clone(),0.1);let graph=app.world().get::<AnimationGraphHandle>(entity).unwrap().0.clone();
    app.world_mut().entity_mut(entity).remove::<AnimationGraphHandle>();app.update();
    assert!(app.world().get::<EzrealWCastPose>(entity).unwrap().retiring);
    assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(w).is_some());
    app.world_mut().entity_mut(entity).insert(AnimationGraphHandle(graph));app.update();retired_only_w(&app,entity,w,foreign);
    publish(&mut app,snapshot,0.14);retired_only_w(&app,entity,w,foreign);
}

#[test]
fn w_real_glb_canonical_spell2_drives_actual_player_without_native_rate_claim() {
    use bevy::{asset::AssetApp,animation::AnimationPlugin,gltf::GltfPlugin,
        mesh::{MeshPlugin,skinning::SkinnedMeshInverseBindposes},transform::TransformPlugin,
        world_serialization::WorldSerializationPlugin};
    let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");let mut loader=App::new();
    loader.add_plugins((MinimalPlugins,AssetPlugin{file_path:root.join("assets").to_str().unwrap().into(),..default()},
        WorldSerializationPlugin,MeshPlugin,TransformPlugin,AnimationPlugin,GltfPlugin::default()))
        .init_asset::<Image>().init_asset::<SkinnedMeshInverseBindposes>();loader.finish();loader.cleanup();
    let model:Handle<Gltf>=loader.world().resource::<AssetServer>().load(EZREAL_JOINT_IDENTITY_ASSET);
    let deadline=std::time::Instant::now()+std::time::Duration::from_secs(30);
    let handle=loop {loader.update();if let Some(model)=loader.world().resource::<Assets<Gltf>>().get(&model){
        assert!(canonical_ezreal_w_clip(&Catalog::default(),model));let handle=model.animations[39].clone();
        if loader.world().resource::<Assets<AnimationClip>>().contains(&handle){break handle;}}
        assert!(std::time::Instant::now()<deadline,"W real GLB CPU load deadline");std::thread::sleep(std::time::Duration::from_millis(5));};
    let clip=loader.world_mut().resource_mut::<Assets<AnimationClip>>().remove(handle.id()).unwrap();
    assert_eq!(clip.curves().values().map(Vec::len).sum::<usize>(),207);assert!((clip.duration()-1.0666667222976685).abs()<0.000001);
    let(mut app,_owner,mut game,id,entity,w,_)=fixture_with_clip(clip);let snapshot=cast(&mut game,id);
    publish(&mut app,snapshot.clone(),0.1);publish(&mut app,snapshot,0.3);
    let active=app.world().get::<AnimationPlayer>(entity).unwrap().animation(w).unwrap();assert!((active.seek_time()-0.2).abs()<0.000001);assert_eq!(active.speed(),1.);
}
