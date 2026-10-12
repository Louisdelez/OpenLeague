//! One native pickup cue per replicated event; joining a session does not replay old events.
use crate::Match;
use bevy::{
    audio::{AudioPlayer, PlaybackSettings},
    prelude::*,
};
pub fn update(
    mut commands: Commands,
    state: Res<Match>,
    assets: Res<AssetServer>,
    mut last: Local<Option<(u64, Option<u64>)>>,
) {
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    let Some(map) = &snapshot.map10 else {
        return;
    };
    let Some((session, previous)) = *last else {
        *last = Some((snapshot.session, map.relic_pickup_tick));
        return;
    };
    if session != snapshot.session {
        *last = Some((snapshot.session, map.relic_pickup_tick));
        return;
    }
    if map.relic_pickup_tick != previous
        && map
            .relic_pickup_tick
            .is_some_and(|tick| snapshot.tick.saturating_sub(tick) < 6)
    {
        commands.spawn((
            AudioPlayer::new(assets.load("audio/map10/relic_pickup.wav")),
            PlaybackSettings::DESPAWN,
        ));
    }
    *last = Some((snapshot.session, map.relic_pickup_tick));
}

/// Native altar event cues; initial connection establishes a baseline without replaying history.
pub fn altar_events(
    mut commands: Commands,
    state: Res<Match>,
    assets: Res<AssetServer>,
    mut last: Local<Option<(u64, u64, Vec<Option<u64>>)>>,
) {
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    let Some(map) = &snapshot.map10 else {
        return;
    };
    let current: Vec<_> = map.altars.iter().map(|a| a.captured_tick).collect();
    if let Some((session, tick, previous)) = &*last {
        if *session == snapshot.session {
            if *tick < 5400 && snapshot.tick >= 5400 {
                commands.spawn((
                    AudioPlayer::new(assets.load("audio/map10/altar_unlock.wav")),
                    PlaybackSettings::DESPAWN,
                ));
            }
            if current
                .iter()
                .zip(previous)
                .any(|(a, b)| a != b && a.is_some())
            {
                commands.spawn((
                    AudioPlayer::new(assets.load("audio/map10/altar_capture.wav")),
                    PlaybackSettings::DESPAWN,
                ));
            }
        }
    }
    *last = Some((snapshot.session, snapshot.tick, current));
}

/// Native audio position tracks the camera focus, not its elevated render eye.
/// Retained for the ambient mixer; this resource alone does not enable playback.
#[derive(Resource, Default)]
pub struct NativeListener {
    pub position: openleague_core::audio_listener::ListenerPosition,
    pub forward: Option<[f32;3]>,
    pub up: Option<[f32;3]>,
    pub prepared: Option<openleague_core::audio_listener_backend::Frame>,
    pub backend: openleague_core::audio_listener_backend::Table,
    direction_cache: Option<openleague_core::audio_listener::DirectionCache>,
}
fn native_focus(world: Vec3) -> [f32; 3] {
    // Render-world coordinates already include all scene transforms.
    // Match camera_native and game entities: native units are render units * 20.
    (world * 20.0).to_array()
}
pub fn listener_position(focus: Res<crate::CameraFocus>, mut listener: ResMut<NativeListener>,
    cameras: Query<&Transform,With<Camera3d>>) {
    listener.position.update(native_focus(focus.0),
        openleague_core::audio_listener::DEFAULT_LISTENER_HEIGHT, false)
        .expect("finite camera focus");
    let Ok(camera)=cameras.single() else {return;};
    use openleague_core::audio_listener::{direction_from_positions,DirectionCache,projected_up,DEFAULT_LISTENER_ANGLE};
    let input=direction_from_positions(native_focus(camera.translation),native_focus(focus.0))
        .expect("finite camera direction");
    let cache=listener.direction_cache.get_or_insert_with(|| DirectionCache::new([0.;3],[0.;3]).unwrap());
    let forward=cache.update(input,DEFAULT_LISTENER_ANGLE).expect("finite listener direction");
    listener.forward=Some(forward);
    let up=projected_up(forward).expect("finite listener up");
    listener.up=Some(up);
    let position=listener.position.current.expect("updated listener position");
    let prepared=openleague_core::audio_listener_backend::prepare(true,position,forward,up)
        .expect("finite native listener frame").expect("available local backend");
    listener.backend.apply(0,prepared).expect("listener zero exists");
    listener.prepared=Some(prepared);
}
/// Opt-in evidence from the actual client update chain; no audio playback claim.
pub fn listener_probe(time:Res<Time>,listener:Res<NativeListener>,focus:Res<crate::CameraFocus>,
    state:Res<Match>,connection:Res<crate::Connection>,cameras:Query<&Transform,With<Camera3d>>,
    mut samples:Local<Vec<serde_json::Value>>,mut previous:Local<f32>) {
    if std::env::var("OPENLEAGUE_AUDIO_LISTENER_PROBE").as_deref()!=Ok("1") || samples.len()>=16 || time.elapsed_secs()-*previous<2. {return;}
    let Some(frame)=listener.prepared else {return;};let Ok(camera)=cameras.single() else {return;};
    let slot=listener.backend.slots()[0];
    samples.push(serde_json::json!({"elapsed_seconds":time.elapsed_secs(),"focus_world":focus.0.to_array(),"eye_world":camera.translation.to_array(),"raw_forward":listener.forward,"raw_up":listener.up,"position":listener.position.current,"packed_frame":frame.packed(),"cached_basis":slot.basis(),"distance_scale":slot.distance_scale,"dirty":slot.dirty,"snapshot_tick":state.snapshot.as_ref().map(|s|s.tick),"session":state.snapshot.as_ref().map(|s|s.session),"player_id":connection.id,"champion":connection.champion,"summoners":connection.summoners,"ambient_playback_enabled":false}));
    *previous=time.elapsed_secs();
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let result=std::fs::write(root.join("logs/audio_listener_runtime_trace.json"),serde_json::to_vec_pretty(&*samples).expect("finite listener evidence"));
    if let Err(error)=result {warn!("Cannot save listener runtime evidence: {error}");}
}
#[cfg(test)]
mod listener_tests {
    use super::*;
    #[test]
    fn focus_position_updates_after_camera_pan_in_native_units() {
        let mut app=App::new();
        app.insert_resource(crate::CameraFocus(Vec3::new(370.0,5.0,385.0)))
            .init_resource::<NativeListener>()
            .add_systems(Update,listener_position);
        app.update();
        let first=app.world().resource::<NativeListener>().position.current.unwrap();
        assert_eq!(first,[7400.0,500.0,7700.0]);
        app.world_mut().resource_mut::<crate::CameraFocus>().0+=Vec3::new(10.0,300.0,-15.0);
        app.update();
        assert_eq!(app.world().resource::<NativeListener>().position.current.unwrap(),
            [7600.0,500.0,7400.0]);
    }
    #[test]
    fn camera_eye_direction_tracks_rotation_and_is_independent_of_listener_height() {
        let mut app=App::new();
        let focus=Vec3::new(370.,5.,385.);
        app.insert_resource(crate::CameraFocus(focus)).init_resource::<NativeListener>()
            .add_systems(Update,listener_position);
        let entity=app.world_mut().spawn((Camera3d::default(),Transform::from_translation(focus+Vec3::new(0.,340.,265.)))).id();
        app.update();
        let first=app.world().resource::<NativeListener>();
        let forward=first.forward.unwrap();let up=first.up.unwrap();
        assert!(forward[1]<0. && forward[2]<0.);
        assert!(up[1]>0. && up[2]<0.);
        assert!(Vec3::from_array(forward).dot(Vec3::from_array(up)).abs()<1e-6);
        assert!((Vec3::from_array(forward).length()-1.).abs()<1e-6);
        assert_eq!(first.position.current.unwrap()[1],500.);
        app.world_mut().entity_mut(entity).get_mut::<Transform>().unwrap().translation=focus+Vec3::new(100.,340.,265.);
        app.update();
        assert!(app.world().resource::<NativeListener>().forward.unwrap()[0]<0.);
        assert_eq!(app.world().resource::<NativeListener>().position.current,Some([7400.,500.,7700.0]));
    }
    #[test]
    fn backend_listener_frame_and_distance_follow_focus_pan_without_eye_height() {
        use openleague_core::audio_distance::{nearest,Sources};
        let mut app=App::new();let focus=Vec3::new(370.,5.,385.);
        app.insert_resource(crate::CameraFocus(focus)).init_resource::<NativeListener>().add_systems(Update,listener_position);
        app.world_mut().spawn((Camera3d::default(),Transform::from_translation(focus+Vec3::new(0.,340.,265.))));app.update();
        let first=app.world().resource::<NativeListener>();let frame=first.prepared.unwrap();
        assert_eq!(frame.position,[7400.,500.,7700.0]);assert_eq!(first.backend.slots()[0].frame,frame);assert_eq!(first.backend.slots()[0].distance_scale,1.);
        assert!(frame.forward[1]<0. && frame.forward[2]<0.);assert!(Vec3::from_array(first.backend.slots()[0].right).dot(Vec3::from_array(frame.up)).abs()<1e-6);
        let source=[frame.position];assert_eq!(nearest(Sources {positions:&source,mode_raw:1},&first.backend.distance_listeners(),1).unwrap(),0.);
        app.world_mut().resource_mut::<crate::CameraFocus>().0+=Vec3::new(10.,300.,-15.);app.update();
        let next=app.world().resource::<NativeListener>();assert_eq!(next.backend.slots()[0].frame.position,[7600.,500.,7400.0]);
        let distance=nearest(Sources {positions:&source,mode_raw:1},&next.backend.distance_listeners(),1).unwrap();assert!((distance-130000_f64.sqrt() as f32).abs()<0.002);
        assert!(next.backend.slots()[0].dirty);for i in 1..8 {assert_eq!(next.backend.slots()[i].frame.position,[0.;3]);}
    }
    #[test]
    fn listener_uses_the_actual_native_camera_coordinate_system() {
        let mut controller=crate::camera_native::NativeCamera::default();
        for requested in [Vec3::new(150.,0.,450.),Vec3::new(700.,0.,220.)] {
            let (eye,_,focus)=controller.pose(requested,0.016,0.016).unwrap();
            let native=controller.native_parameters().unwrap();
            let mut app=App::new();
            app.insert_resource(crate::CameraFocus(focus)).init_resource::<NativeListener>()
                .add_systems(Update,listener_position);
            app.world_mut().spawn((Camera3d::default(),eye));
            app.update();
            let listener=app.world().resource::<NativeListener>();
            let position=listener.position.current.unwrap();
            assert_eq!(position,[controller.native_focus()[0],500.,controller.native_focus()[2]]);
            let actual_eye=native_focus(eye.translation);
            for i in 0..3 {assert!((actual_eye[i]-native.position[i]).abs()<0.002);}
            // Audio adjusts pitch separately, but must preserve horizontal direction.
            let forward=listener.forward.unwrap();
            assert_eq!(forward[2].is_sign_positive(),native.direction[2].is_sign_positive());
        }
    }

}
// Tracks source positions from the animated skeleton after transform propagation.
// Unknown attachments stay unknown; no origin fallback or invented Wwise ID.
#[derive(Resource, Default)]
pub struct AmbientPositions(pub std::collections::BTreeMap<(String,u64), AmbientPosition>);
pub struct AmbientPosition {
    pub native_asset:String,
    pub particle:String,
    pub bone:String,
    pub attachment: Option<Entity>,
    pub native_position: Option<[f32;3]>,
}
pub fn ambient_cues(queue:Res<crate::map_events::Queue>, mut positions:ResMut<AmbientPositions>) {
    for cue in &queue.0 {
        if !cue.particle.starts_with("Audio-Emitter_") {continue;}
        let key=(cue.instance.clone(),cue.record_offset);
        if cue.start {
            positions.0.insert(key,AmbientPosition {native_asset:cue.native_asset.clone(),particle:cue.particle.clone(),bone:cue.bone.clone(),attachment:cue.attachment,native_position:None});
        } else {positions.0.remove(&key);}
    }
}
pub fn ambient_positions(mut positions:ResMut<AmbientPositions>, transforms:Query<&GlobalTransform>) {
    for source in positions.0.values_mut() {
        source.native_position=source.attachment.and_then(|e|transforms.get(e).ok())
            .map(|t|native_focus(t.translation())).filter(|p|p.iter().all(|v|v.is_finite()));
    }
}
#[cfg(test)]
mod emitter_position_tests {
    use super::*;
    fn cue(entity:Option<Entity>,start:bool,offset:u64)->crate::map_events::EmitterCue {
        crate::map_events::EmitterCue {start,instance:"brazier01".into(),native_asset:"TT_Brazier".into(),
            name:"Audio-Emitter_TT_BrazierChains".into(),particle:"Audio-Emitter_TT_BrazierChains.troy".into(),
            bone:"BUFFBONE_CSTM_FLAME".into(),attachment:entity,record_offset:offset,flags:1,cycle:0,
            elapsed_seconds:0.,evaluated_frame:0.,source_start_frame:0.,source_end_frame:5.,loop_reset:false}
    }
    #[test]
    fn active_sound_positions_follow_bones_and_stop_per_event_instance() {
        let mut app=App::new();
        app.init_resource::<AmbientPositions>().init_resource::<crate::map_events::Queue>()
            .add_systems(Update,(ambient_cues,ambient_positions).chain());
        let bone=app.world_mut().spawn(GlobalTransform::from_translation(Vec3::new(370.,75.,385.))).id();
        app.world_mut().resource_mut::<crate::map_events::Queue>().0=vec![cue(Some(bone),true,400),cue(Some(bone),true,528)];
        app.update();
        let key=("brazier01".to_string(),400);
        assert_eq!(app.world().resource::<AmbientPositions>().0[&key].native_position,Some([7400.,1500.,7700.0]));
        app.world_mut().resource_mut::<crate::map_events::Queue>().0.clear();
        *app.world_mut().entity_mut(bone).get_mut::<GlobalTransform>().unwrap()=
            GlobalTransform::from_translation(Vec3::new(380.,76.,390.));
        app.update();
        let p=app.world().resource::<AmbientPositions>().0[&key].native_position.unwrap();
        assert_eq!(p,[7600.,1520.,7800.0]);
        let output=openleague_core::audio_emitter_position::dispatch(
            Some(openleague_core::audio_routing::VoiceRoute {object_id:123,actor_id:0}),true,p).unwrap();
        assert_eq!(output.position_update.unwrap().position,p);
        app.world_mut().resource_mut::<crate::map_events::Queue>().0=vec![cue(Some(bone),false,400)];
        app.update();
        assert!(!app.world().resource::<AmbientPositions>().0.contains_key(&key));
        assert_eq!(app.world().resource::<AmbientPositions>().0.len(),1);
    }
    #[test]
    fn unresolved_removed_or_invalid_bones_never_fall_back_to_origin() {
        let mut app=App::new();
        app.init_resource::<AmbientPositions>().init_resource::<crate::map_events::Queue>()
            .add_systems(Update,(ambient_cues,ambient_positions).chain());
        let bone=app.world_mut().spawn(GlobalTransform::IDENTITY).id();
        app.world_mut().resource_mut::<crate::map_events::Queue>().0=vec![cue(None,true,400),cue(Some(bone),true,528)];
        app.update();
        let unknown=("brazier01".into(),400);let known=("brazier01".into(),528);
        assert!(app.world().resource::<AmbientPositions>().0[&unknown].native_position.is_none());
        app.world_mut().resource_mut::<crate::map_events::Queue>().0.clear();
        *app.world_mut().entity_mut(bone).get_mut::<GlobalTransform>().unwrap()=
            GlobalTransform::from_translation(Vec3::new(f32::NAN,0.,0.));
        app.update();assert!(app.world().resource::<AmbientPositions>().0[&known].native_position.is_none());
        app.world_mut().despawn(bone);app.update();
        assert!(app.world().resource::<AmbientPositions>().0[&known].native_position.is_none());
    }
}

#[cfg(test)]
mod emitter_schedule_tests {
    use super::*;
    #[test]
    fn position_system_observes_current_child_transform_after_propagation() {
        let mut app=App::new();
        app.add_plugins(bevy::transform::TransformPlugin);
        app.init_resource::<AmbientPositions>()
            .add_systems(PostUpdate,ambient_positions.after(bevy::transform::TransformSystems::Propagate));
        let root=app.world_mut().spawn(crate::map_coordinates::map_root_transform()).id();
        let bone=app.world_mut().spawn((Transform::from_xyz(7400.,1500.,7700.),ChildOf(root))).id();
        let key=("brazier01".into(),400);
        app.world_mut().resource_mut::<AmbientPositions>().0.insert(key.clone(),
            AmbientPosition {native_asset:"TT_Brazier".into(),particle:"Audio-Emitter_TT_BrazierChains.troy".into(),bone:"BUFFBONE_CSTM_FLAME".into(),attachment:Some(bone),native_position:None});
        app.update();
        let first=app.world().resource::<AmbientPositions>().0[&key].native_position.unwrap();
        for (a,b) in first.into_iter().zip([7400.,1500.,7700.]) {assert!((a-b).abs()<0.002);}
        app.world_mut().entity_mut(bone).get_mut::<Transform>().unwrap().translation=Vec3::new(7600.,1510.,7790.);
        app.update();
        let next=app.world().resource::<AmbientPositions>().0[&key].native_position.unwrap();
        for (a,b) in next.into_iter().zip([7600.,1510.,7790.]) {assert!((a-b).abs()<0.002);}
    }
}
/// Bounded opt-in capture from the actual animated scene, after propagation.
pub fn emitter_probe(time:Res<Time>,positions:Res<AmbientPositions>,
    queue:Res<crate::map_events::Queue>,state:Res<Match>,
    transforms:Query<&GlobalTransform>,players:Query<&crate::map_ambient::AmbientPlayer>,
    mut started:Local<Option<f32>>,mut previous:Local<f32>,
    mut samples:Local<Vec<serde_json::Value>>,mut events:Local<Vec<serde_json::Value>>) {
    if std::env::var("OPENLEAGUE_AUDIO_EMITTER_PROBE").as_deref()!=Ok("1") || samples.len()>=64 {return;}
    if started.is_none() {
        if players.iter().count()!=17 || positions.0.is_empty() || state.snapshot.is_none() {return;}
        *started=Some(time.elapsed_secs());*previous=time.elapsed_secs()-0.5;
    }
    let mut changed=false;
    for cue in &queue.0 {
        if !cue.particle.starts_with("Audio-Emitter_") {continue;}
        events.push(serde_json::json!({"elapsed_seconds":time.elapsed_secs(),"start":cue.start,"instance":cue.instance,"native_asset":cue.native_asset,"record_offset":cue.record_offset,"particle":cue.particle,"bone":cue.bone,"attachment":cue.attachment.map(Entity::to_bits),"cycle":cue.cycle,"evaluated_frame":cue.evaluated_frame,"source_start_frame":cue.source_start_frame,"source_end_frame":cue.source_end_frame,"loop_reset":cue.loop_reset}));
        changed=true;
    }
    if time.elapsed_secs()-*previous>=0.5 {
        let sources:Vec<_>=positions.0.iter().map(|((instance,offset),source)| {
            let world=source.attachment.and_then(|e|transforms.get(e).ok()).map(|t|t.translation().to_array());
            serde_json::json!({"instance":instance,"record_offset":offset,"native_asset":source.native_asset,"particle":source.particle,"bone":source.bone,"attachment":source.attachment.map(Entity::to_bits),"world_position":world,"native_position":source.native_position})
        }).collect();
        samples.push(serde_json::json!({"elapsed_seconds":time.elapsed_secs(),"snapshot_tick":state.snapshot.as_ref().map(|s|s.tick),"session":state.snapshot.as_ref().map(|s|s.session),"sources":sources}));
        *previous=time.elapsed_secs();changed=true;
    }
    if changed {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let receipt=serde_json::json!({"process_id":std::process::id(),"capture_start_seconds":*started,"complete_capture":samples.len()==64,"samples":*samples,"events":*events,"ambient_playback_enabled":false,"scope":"Actual source bones after animation/transform propagation; no voice registration or audible playback claim"});
        if let Err(error)=std::fs::write(root.join("logs/audio_emitter_runtime_trace.json"),serde_json::to_vec_pretty(&receipt).expect("finite emitter evidence")) {
            warn!("Cannot save emitter runtime evidence: {error}");
        }
    }
}
