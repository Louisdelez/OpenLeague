//! Optional, bounded CPU observation. No command, playback, pose or clock writes.
//! This child module can inspect Actor without making its fields public.
use super::{Actor, Catalog};
use crate::{native_effect_clock::EffectClock, Match};
use bevy::prelude::*;
use serde_json::{json, Value};
use std::{collections::VecDeque, path::PathBuf};

const FRAME_LIMIT: usize = 512;
const ACTOR_LIMIT: usize = 4;
const CLIP_LIMIT: usize = 16;
const EVENT_LIMIT: usize = 129; // common history128 + one pinned Vilemaw Started
const BYTE_LIMIT: usize = 16 * 1024 * 1024;
const INTERVAL: f64 = 0.1;

#[derive(Default)]
pub(crate) struct Recorder {
    configured: bool,
    path: Option<PathBuf>,
    last_wall: Option<f64>,
    sequence: u64,
    dropped_frames: u64,
    frames: VecDeque<Value>,
    stopped: bool,
}
impl Recorder {
    fn push(&mut self, mut frame: Value) -> Result<(), &'static str> {
        self.sequence = self.sequence.checked_add(1).ok_or("observation sequence exhausted")?;
        frame["sample"] = json!(self.sequence);
        if self.frames.len() == FRAME_LIMIT {
            self.frames.pop_front();
            self.dropped_frames += 1;
        }
        self.frames.push_back(frame);
        Ok(())
    }
    fn stop(&mut self, reason: &str) {
        self.stopped = true;
        // A failed writer cannot reliably publish its own error in the file.
        // Runtime qualification must also inspect this fixed-prefix stderr line.
        error!("VILEMAW_ANIMATION_PROBE_FAILED: {reason}");
    }
}

fn actor_row(entity: Entity, player: &AnimationPlayer, actor: &Actor,
    clips: &Assets<AnimationClip>, catalog: &Catalog) -> Value {
    let definition = &catalog.0[&actor.playback.model_name];
    let mapped_duration = |role: &str| actor.playback.clips.get(role)
        .and_then(|handle| clips.get(handle)).map(AnimationClip::duration);
    let active_count = player.playing_animations().count();
    let active: Vec<_> = player.playing_animations().take(CLIP_LIMIT).map(|(index, animation)| {
        let mut roles: Vec<_> = actor.playback.roles.iter()
            .filter(|(_, node)| **node == *index).map(|(role, _)| role.as_str()).collect();
        roles.sort_unstable();
        let bindings: Vec<_> = roles.into_iter().map(|role| {
            let clip_index = definition["roles"][role].as_u64();
            let clip_name = clip_index.and_then(|i| definition["clips"].get(i as usize));
            json!({"role":role,"catalog_clip_index":clip_index,"catalog_clip_name":clip_name,
                "loaded_duration_seconds":mapped_duration(role)})
        }).collect();
        json!({"graph_node":index.index(),"bindings":bindings,
            "seek_time":animation.seek_time(),"elapsed":animation.elapsed(),
            "speed":animation.speed(),"weight":animation.weight(),
            "completions":animation.completions(),"finished":animation.is_finished(),
            "paused":animation.is_paused()})
    }).collect();
    json!({"source":actor.playback.id,"actor_entity":format!("{entity:?}"),
        "model":actor.playback.model_name,"role":actor.role,
        "role_graph_node":actor.playback.roles.get(&actor.role).map(|node|node.index()),
        "role_loaded_duration_seconds":mapped_duration(&actor.role),
        "attack_loaded_duration_seconds":mapped_duration("attack"),
        "presentation":actor.presentation.map(|(id,kind)|json!({"attack":id,"kind":kind})),
        "active_clip_count":active_count,"active_clips_truncated":active_count>CLIP_LIMIT,
        "active_clips":active})
}

/// Runs after the real AnimationSystems set. Only Local recorder/file state mutates.
pub(crate) fn observe(time: Res<Time<Real>>, clock: Res<EffectClock>, state: Res<Match>,
    connection: Option<Res<crate::Connection>>,
    catalog: Res<Catalog>, clips: Res<Assets<AnimationClip>>,
    actors: Query<(Entity, &AnimationPlayer, &Actor)>, roots: Query<&Transform>,
    mut recorder: Local<Recorder>) {
    if !recorder.configured {
        recorder.configured = true;
        recorder.path = std::env::var_os("OPENLEAGUE_VILEMAW_ATTACK_PROBE")
            .filter(|value| !value.is_empty()).map(PathBuf::from);
    }
    if recorder.stopped || recorder.path.is_none() { return; }
    let wall = time.elapsed_secs_f64();
    if !wall.is_finite() { recorder.stop("non-finite host sample time"); return; }
    if recorder.last_wall.is_some_and(|last| wall >= last && wall-last < INTERVAL) { return; }
    recorder.last_wall = Some(wall);
    let snapshot = state.snapshot.as_ref();
    // This is the GUI's accepted state, not an additional network observation.
    // Never infer its player from roster order or expose connection credentials.
    let gui_player = snapshot.and_then(|snapshot| {
        let connection = connection.as_ref()?;
        if connection.session != Some(snapshot.session) { return None; }
        let id = connection.id?;
        let mut matching = snapshot.players.iter().filter(|player| player.id == id);
        let player = matching.next()?;
        if matching.next().is_some() { return None; }
        Some(json!({"id":player.id,"position":player.position,"health":player.health}))
    });
    let actor_count = actors.iter().filter(|(_,_,actor)|
        actor.playback.model_name == openleague_core::vilemaw_attacks::DEFINITION).count();
    let rows: Vec<_> = actors.iter().filter(|(_,_,actor)|
        actor.playback.model_name == openleague_core::vilemaw_attacks::DEFINITION)
        .take(ACTOR_LIMIT).map(|(entity, player, actor)| {
            let mut row = actor_row(entity, player, actor, &clips, &catalog);
            let root_entity = state.visuals.get(&actor.playback.id);
            let root = root_entity.and_then(|root| roots.get(*root).ok());
            row["root_entity"] = json!(root_entity.map(|root|format!("{root:?}")));
            row["root_transform"] = json!(root.map(|root| json!({
                "translation":root.translation.to_array(),"rotation":root.rotation.to_array(),
                "scale":root.scale.to_array(),"forward":(root.rotation*Vec3::Z).to_array()})));
            row
        }).collect();
    let unit_count = snapshot.map_or(0, |s| s.units.iter()
        .filter(|unit| openleague_core::vilemaw_attacks::is_vilemaw(unit)).count());
    let units: Vec<_> = snapshot.into_iter().flat_map(|s|s.units.iter())
        .filter(|unit|openleague_core::vilemaw_attacks::is_vilemaw(unit)).take(ACTOR_LIMIT)
        .map(|unit|json!({"source":unit.id,"health":unit.health,"position":unit.position,
            "facing":unit.facing,"destination":unit.destination,"target":unit.target,"next_attack":unit.next_attack,
            "stunned":snapshot.is_some_and(|s|openleague_core::stuns::unit_active(unit,s.tick)),
            "active_attack":unit.attack_presentation})).collect();
    let event_count = snapshot.map_or(0, |s|s.vilemaw_attack_events.len());
    let events: Vec<_> = snapshot.into_iter().flat_map(|s|s.vilemaw_attack_events.iter())
        .take(EVENT_LIMIT).collect();
    let frame = json!({"wall_time":wall,"session":snapshot.map(|s|s.session),
        "tick":snapshot.map(|s|s.tick),"clock":clock.diagnostic(),"gui_player":gui_player,
        "consumer_error":state.vilemaw_visuals.error(),
        "server_error":snapshot.and_then(|s|s.vilemaw_attack_presentation_error.as_ref()),
        "unit_count":unit_count,"units_truncated":unit_count>ACTOR_LIMIT,"units":units,
        "actor_count":actor_count,"actors_truncated":actor_count>ACTOR_LIMIT,"actors":rows,
        "event_count":event_count,"events_truncated":event_count>EVENT_LIMIT,"events":events});
    if let Err(error) = recorder.push(frame) { recorder.stop(error); return; }
    let output = json!({"schema":1,"kind":"vilemaw_animation_cpu_observation",
        "pixels_observed":false,"state_injection":false,"sample_interval_seconds":INTERVAL,
        "frame_capacity":FRAME_LIMIT,"dropped_frames":recorder.dropped_frames,
        "frames":recorder.frames});
    let bytes = match serde_json::to_vec(&output) {
        Ok(bytes) if bytes.len() <= BYTE_LIMIT => bytes,
        _ => {recorder.stop("observation serialization or size limit failed"); return;}
    };
    if std::fs::write(recorder.path.as_ref().unwrap(), bytes).is_err() {
        recorder.stop("output write failed");
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn recorder_retains_exact_last_512_samples_without_a_success_claim() {
        let mut recorder = Recorder::default();
        for value in 0..519 {recorder.push(json!({"value":value})).unwrap();}
        assert_eq!(recorder.frames.len(), 512);
        assert_eq!(recorder.dropped_frames, 7);
        assert_eq!(recorder.frames.front().unwrap()["sample"], 8);
        assert_eq!(recorder.frames.back().unwrap()["sample"], 519);
        assert!(recorder.frames.iter().all(|value|value.get("passed").is_none()));
    }
    #[test]
    fn row_reads_actual_player_seek_separately_from_elapsed_without_mutating_it() {
        use super::super::Playback;
        use std::collections::HashMap;
        let mut assets = Assets::<AnimationClip>::default();
        let mut clip = AnimationClip::default(); clip.set_duration(1.8);
        let handle = assets.add(clip);
        let node = AnimationNodeIndex::new(1);
        let actor = Actor {playback:Playback {id:700,model_name:"TT_Spiderboss".into(),
            graph:Handle::default(),_model:Handle::default(),
            roles:HashMap::from([("attack".into(),node)]),
            clips:HashMap::from([("attack".into(),handle)]),durations:HashMap::new()},
            role:"attack".into(),previous_attack:0,attack_until:0,critical:false,
            presentation:Some((11,openleague_core::attack_presentation::Kind::Basic))};
        let mut player = AnimationPlayer::default();
        player.play(node).set_seek_time(0.75);
        let catalog = Catalog::default();
        let entity = World::new().spawn_empty().id();
        let before = (player.animation(node).unwrap().seek_time(),player.animation(node).unwrap().elapsed());
        let row = actor_row(entity,&player,&actor,&assets,&catalog);
        assert_eq!(row["presentation"]["attack"],11);
        assert_eq!(row["role"],"attack");
        assert_eq!(row["active_clips"][0]["graph_node"],1);
        assert_eq!(row["active_clips"][0]["bindings"][0]["catalog_clip_index"],3);
        assert_eq!(row["active_clips"][0]["bindings"][0]["catalog_clip_name"],"TT_Spiderboss_attack1");
        assert_eq!(row["active_clips"][0]["seek_time"],0.75);
        assert_eq!(row["active_clips"][0]["elapsed"],0.0);
        assert!((row["role_loaded_duration_seconds"].as_f64().unwrap()-1.8).abs()<1e-6);
        assert_eq!(before,(player.animation(node).unwrap().seek_time(),player.animation(node).unwrap().elapsed()));
        assert_eq!(actor.presentation.unwrap().0,11);
    }
}
