//! Source-timed ambient event dispatch. Audio/particle consumers remain incomplete.
use crate::map_ambient::AmbientPlayer;
use bevy::prelude::*;
use openleague_core::animation_events::{Cue, Event};
use std::{collections::HashMap, sync::OnceLock};

fn data() -> &'static serde_json::Value {
    static DATA: OnceLock<serde_json::Value> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/ambient_events.json"))
            .expect("native event contracts")
    })
}
pub fn native_period(native: &str) -> f32 {
    data()["models"][native]["period"].as_f64().unwrap() as f32
}
#[derive(Clone)]
struct Slot {
    name: String,
    particle: String,
    bone: String,
    attachment: Option<Entity>,
    offset: u64,
    start: f32,
    end: f32,
    flags: u32,
    controller: Event,
}
#[derive(Component)]
pub struct Timeline {
    slots: Vec<Slot>,
    period: f32,
    step: f32,
    cycle: u64,
}
/// Per-frame outputs are separate from render/audio backends. No fake playback.
#[derive(Clone)]
pub struct EmitterCue {
    pub start: bool,
    pub instance: String,
    pub native_asset: String,
    pub name: String,
    pub particle: String,
    pub bone: String,
    pub attachment: Option<Entity>,
    pub record_offset: u64,
    pub flags: u32,
    pub cycle: u64,
    pub elapsed_seconds: f32,
    pub evaluated_frame: f32,
    pub source_start_frame: f32,
    pub source_end_frame: f32,
    pub loop_reset: bool,
}
#[derive(Resource, Default)]
pub struct Queue(pub Vec<EmitterCue>);
#[derive(Resource, Default)]
pub struct Trace {
    started: Option<f64>,
    rows: Vec<serde_json::Value>,
    bindings: HashMap<String, serde_json::Value>,
    done: bool,
}
fn advance(
    timeline: &mut Timeline,
    active: &bevy::animation::ActiveAnimation,
    player: &AmbientPlayer,
    delta: f32,
    queue: &mut Queue,
) {
    if active.is_paused() || active.is_finished() {
        return;
    }
    assert_eq!(
        active.speed(),
        1.0,
        "ambient graph speed/seek changes require native qualification"
    );
    // Runs before Bevy's advance_animations. This is exactly its forthcoming
    // seek increment, retaining native evaluation-before-loop-reset ordering.
    let seconds = active.seek_time() + delta * active.speed();
    let frame = seconds / timeline.step;
    let elapsed = active.elapsed() + delta;
    let mut emit = |slot: &Slot, cue: Cue, reset: bool| {
        if cue == Cue::Update {
            return;
        }
        queue.0.push(EmitterCue {
            start: cue == Cue::Start,
            instance: player.0.id.clone(),
            native_asset: player.0.native.clone(),
            name: slot.name.clone(),
            particle: slot.particle.clone(),
            bone: slot.bone.clone(),
            attachment: slot.attachment,
            record_offset: slot.offset,
            flags: slot.flags,
            cycle: timeline.cycle,
            elapsed_seconds: elapsed,
            evaluated_frame: frame,
            source_start_frame: slot.start,
            source_end_frame: slot.end,
            loop_reset: reset,
        });
    };
    for slot in &mut timeline.slots {
        let cues = slot.controller.evaluate(frame).expect("valid native frame");
        for cue in cues {
            emit(slot, cue, false);
        }
    }
    if seconds >= timeline.period {
        for slot in &mut timeline.slots {
            for cue in slot.controller.reset_loop() {
                emit(slot, cue, true);
            }
        }
        timeline.cycle += 1;
    }
}
pub fn dispatch(
    mut commands: Commands,
    time: Res<Time>,
    animation_delta: Res<bevy::animation::AnimationDelta>,
    mut queue: ResMut<Queue>,
    mut trace: ResMut<Trace>,
    mut players: Query<(
        Entity,
        &AnimationPlayer,
        &AmbientPlayer,
        Option<&mut Timeline>,
    )>,
    children: Query<&Children>,
    names: Query<&Name>,
) {
    queue.0.clear();
    let path = std::env::var("OPENLEAGUE_EVENT_PROBE")
        .ok()
        .filter(|s| !s.is_empty());
    let enabled = path.as_ref().is_some_and(|s| {
        let p = std::path::Path::new(s);
        p.is_absolute() && p.parent() == Some(std::path::Path::new(r"E:\OpenLeague\logs"))
    });
    if enabled && trace.started.is_none() && players.iter().count() == 17 {
        trace.started = Some(time.elapsed_secs_f64());
    }
    for (entity, player, ambient, timeline) in &mut players {
        let Some(active) = player.animation(ambient.0.clip) else {
            continue;
        };
        if let Some(mut timeline) = timeline {
            advance(
                &mut timeline,
                active,
                ambient,
                animation_delta.0,
                &mut queue,
            );
        } else {
            let entry = &data()["models"][&ambient.0.native];
            let mut timeline = Timeline {
                slots: Vec::new(),
                period: entry["period"].as_f64().unwrap() as f32,
                step: entry["time_step"].as_f64().unwrap() as f32,
                cycle: 0,
            };
            for record in entry["events"].as_array().unwrap() {
                let bone = record["bone"].as_str().unwrap();
                let attachment = children.iter_descendants(ambient.1).find(|&e| {
                    names
                        .get(e)
                        .is_ok_and(|name| name.as_str().eq_ignore_ascii_case(bone))
                });
                let expected = record["attachment_source_resolved"].as_bool().unwrap();
                assert_eq!(
                    attachment.is_some(),
                    expected,
                    "native skeleton attachment {bone}"
                );
                let start = record["start_frame"].as_f64().unwrap() as f32;
                let end = record["end_frame"].as_f64().unwrap() as f32;
                let flags = record["flags"].as_u64().unwrap() as u32;
                timeline.slots.push(Slot {
                    name: record["name"].as_str().unwrap().into(),
                    particle: record["particle"].as_str().unwrap().into(),
                    bone: bone.into(),
                    attachment,
                    offset: record["record_offset"].as_u64().unwrap(),
                    start,
                    end,
                    flags,
                    controller: Event::new(start, end, flags).expect("native event range"),
                });
            }
            if enabled {
                trace.bindings.insert(ambient.0.id.clone(), serde_json::json!({
                    "native_asset":ambient.0.native,"primary_clip":entry["primary_name"],
                    "period":timeline.period,"time_step":timeline.step,
                    "events":timeline.slots.iter().map(|s| serde_json::json!({"record_offset":s.offset,"name":s.name,"bone":s.bone,"attachment_resolved":s.attachment.is_some()})).collect::<Vec<_>>()
                }));
            }
            advance(
                &mut timeline,
                active,
                ambient,
                animation_delta.0,
                &mut queue,
            );
            commands.entity(entity).insert(timeline);
        }
        if enabled {
            if let Some(binding) = trace.bindings.get_mut(&ambient.0.id) {
                binding["last_animation_elapsed"] =
                    serde_json::json!(active.elapsed() + animation_delta.0);
                binding["last_evaluated_frame"] = serde_json::json!(
                    (active.seek_time() + animation_delta.0)
                        / data()["models"][&ambient.0.native]["time_step"]
                            .as_f64()
                            .unwrap() as f32
                );
            }
        }
    }
    if enabled && !trace.done {
        for cue in &queue.0 {
            trace.rows.push(serde_json::json!({
                "kind":if cue.start {"start"} else {"stop"}, "instance":cue.instance,
                "native_asset":cue.native_asset,"name":cue.name,"particle":cue.particle,
                "bone":cue.bone,"attachment_resolved":cue.attachment.is_some(),
                "record_offset":cue.record_offset,"flags":cue.flags,"cycle":cue.cycle,
                "elapsed_seconds":cue.elapsed_seconds,"evaluated_frame":cue.evaluated_frame,
                "source_start_frame":cue.source_start_frame,"source_end_frame":cue.source_end_frame,
                "loop_reset":cue.loop_reset,
            }));
        }
        if trace
            .started
            .is_some_and(|start| time.elapsed_secs_f64() - start >= 32.0)
        {
            let report = serde_json::json!({"bindings":trace.bindings,"cues":trace.rows,
                "sample_seconds":time.elapsed_secs_f64()-trace.started.unwrap(),"complete":false,
                "scope":"Actual native primary-clip event dispatch only; particle/audio consumers remain incomplete"});
            std::fs::write(path.unwrap(), serde_json::to_vec_pretty(&report).unwrap())
                .expect("write event trace");
            trace.done = true;
        }
    }
}

#[cfg(test)]
mod animation_event_clock_tests {
 use super::*;
 use bevy::animation::{AnimationDelta,advance_animations};
 use std::time::Duration;
 #[test]
 fn pause_does_not_repeat_cues_and_resume_preserves_clip_event_loop_order(){
  let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
  app.init_resource::<Time>().init_resource::<AnimationDelta>().init_resource::<Queue>().init_resource::<Trace>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>();
  app.add_systems(Update,(dispatch,advance_animations).chain());
  let mut clip=AnimationClip::default();clip.set_duration(1.);
  let handle=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
  let mut graph=AnimationGraph::new();let index=graph.add_clip(handle,1.,graph.root);
  let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
  let mut player=AnimationPlayer::default();player.start(index).repeat();
  let root=app.world_mut().spawn_empty().id();
  let timeline=Timeline{period:1.,step:1.,cycle:0,slots:vec![Slot{name:"synthetic-clock-window".into(),particle:String::new(),bone:String::new(),attachment:None,offset:0,start:0.25,end:0.75,flags:1,controller:Event::new(0.25,0.75,1).unwrap()}]};
  let entity=app.world_mut().spawn((player,AnimationGraphHandle(graph),AmbientPlayer::clock_test_fixture(index,root),timeline)).id();
  let step=|app:&mut App,delta:f32|{
   app.world_mut().resource_mut::<Time>().advance_by(Duration::from_secs(2));
   app.world_mut().resource_mut::<AnimationDelta>().0=delta;app.update();
   app.world().resource::<Queue>().0.iter().map(|cue|(cue.start,cue.cycle,cue.loop_reset)).collect::<Vec<_>>()
  };
  assert!(step(&mut app,0.).is_empty());
  assert_eq!(step(&mut app,0.25),vec![(true,0,false)]);
  for _ in 0..3 {assert!(step(&mut app,0.).is_empty());assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.25);}
  assert_eq!(step(&mut app,0.5),vec![(false,0,false)]);
  for _ in 0..3 {assert!(step(&mut app,0.).is_empty());}
  assert!(step(&mut app,0.25).is_empty());assert_eq!(app.world().get::<Timeline>(entity).unwrap().cycle,1);
  for _ in 0..3 {assert!(step(&mut app,0.).is_empty());assert_eq!(app.world().get::<Timeline>(entity).unwrap().cycle,1);}
  assert_eq!(step(&mut app,0.25),vec![(true,1,false)]);
  assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.25);
  assert_eq!(app.world().resource::<Time>().elapsed_secs(),28.);
 }
}
