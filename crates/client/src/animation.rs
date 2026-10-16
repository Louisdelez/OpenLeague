//! Only bind clip indices whose native names were checked against the actual GLBs.
use crate::Match;
use bevy::{
    prelude::*,
    world_serialization::{WorldAssetRoot, WorldInstanceReady},
};
use std::collections::HashMap;
#[derive(Resource)]
pub struct Catalog(serde_json::Value);
impl Default for Catalog {
    fn default() -> Self {
        let mut catalog: serde_json::Value =
            serde_json::from_str(include_str!("../../../data/4.20/animation_manifest.json"))
                .expect("verified champion animations");
        let world: serde_json::Value = serde_json::from_str(include_str!(
            "../../../data/4.20/world_animation_manifest.json"
        ))
        .expect("verified world animations");
        for (name, entry) in world.as_object().unwrap() {
            catalog
                .as_object_mut()
                .unwrap()
                .insert(name.clone(), entry.clone());
        }
        Self(catalog)
    }
}
#[derive(Component, Clone)]
pub struct Playback {
    id: u32,
    model_name: String,
    graph: Handle<AnimationGraph>,
    _model: Handle<Gltf>,
    roles: HashMap<String, AnimationNodeIndex>,
    clips: HashMap<String, Handle<AnimationClip>>,
    durations: HashMap<String, u64>,
}
impl Playback {
    pub fn model_asset_id(&self)->bevy::asset::AssetId<Gltf> {self._model.id()}
    pub fn network_id(&self)->u32 {self.id}
    pub fn model_name(&self)->&str {&self.model_name}
}
#[derive(Component)]
pub struct Actor {
    playback: Playback,
    role: String,
    previous_attack: u64,
    attack_until: u64,
    critical: bool,
    presentation: Option<(u64, openleague_core::attack_presentation::Kind)>,
}
#[derive(Component)]
pub struct ModelRequest {
    id: u32,
    name: String,
    model: Handle<Gltf>,
}
pub fn request(
    id: u32,
    name: &str,
    catalog: &Catalog,
    assets: &AssetServer,
) -> (ModelRequest, f32) {
    (
        ModelRequest {
            id,
            name: name.into(),
            model: assets.load(
                catalog.0[name]["asset"]
                    .as_str()
                    .map(str::to_owned)
                    .unwrap_or_else(|| format!("champions/{name}.glb")),
            ),
        },
        catalog.0[name]["scale"].as_f64().unwrap_or(1.) as f32,
    )
}
pub fn load_models(
    mut commands: Commands,
    models: Res<Assets<Gltf>>,
    catalog: Res<Catalog>,
    mut graphs: ResMut<Assets<AnimationGraph>>,
    requests: Query<(Entity, &ModelRequest)>,
) {
    for (entity, request) in &requests {
        let Some(model) = models.get(&request.model) else {
            continue;
        };
        let Some(scene) = model.scenes.first() else {
            continue;
        };
        // Build from handles supplied by the loaded parent GLTF. Loading each
        // labeled clip separately can repeatedly respawn the scene during loading.
        let (graph, indices) = AnimationGraph::from_clips(model.animations.clone());
        let roles = catalog.0[&request.name]["roles"]
            .as_object()
            .unwrap()
            .iter()
            .filter_map(|(name, index)| {
                Some((name.clone(), *indices.get(index.as_u64()? as usize)?))
            })
            .collect();
        let playback = Playback {
            id: request.id,
            model_name: request.name.clone(),
            graph: graphs.add(graph),
            _model: request.model.clone(),
            roles,
            clips: catalog.0[&request.name]["roles"].as_object().unwrap().iter()
                .filter_map(|(role,index)|Some((role.clone(),model.animations.get(index.as_u64()? as usize)?.clone())))
                .collect(),
            durations: catalog.0[&request.name]["duration_ticks"]
                .as_object()
                .map(|m| {
                    m.iter()
                        .filter_map(|(name, value)| Some((name.clone(), value.as_u64()?)))
                        .collect()
                })
                .unwrap_or_default(),
        };
        let visibility = if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
            && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1")
        {
            Visibility::Hidden
        } else {
            Visibility::Inherited
        };
        commands
            .entity(entity)
            .insert((WorldAssetRoot(scene.clone()), playback, visibility, crate::actor_fow::Root))
            .remove::<ModelRequest>()
            .observe(ready);
    }
}
pub fn ready(
    event: On<WorldInstanceReady>,
    mut commands: Commands,
    children: Query<&Children>,
    roots: Query<&Playback>,
    mut players: Query<&mut AnimationPlayer>,
) {
    let Ok(playback) = roots.get(event.entity) else {
        return;
    };
    if crate::nexus_idle_particles::supports_model(playback.model_name()) {
        commands.entity(event.entity).insert(crate::nexus_idle_particles::ModelReady);
    }
    for child in children.iter_descendants(event.entity) {
        if let Ok(mut player) = players.get_mut(child) {
            println!(
                "OpenLeague animation graph attached: player {} / {} verified roles",
                playback.id,
                playback.roles.len()
            );
            let mut transitions = AnimationTransitions::new();
            let mut role = String::new();
            if let Some(index) = playback.roles.get("idle") {
                let active=transitions.play(&mut player,*index,std::time::Duration::ZERO);
                if !crate::structure_animation_clock::configure(&playback.model_name,"idle",active) {active.repeat();}
                role = "idle".into();
            }
            commands.entity(child).insert((
                AnimationGraphHandle(playback.graph.clone()),
                transitions,
                Actor {
                    playback: playback.clone(),
                    role,
                    previous_attack: 0,
                    attack_until: 0,
                    critical: false,
                    presentation: None,
                },
            ));
        }
    }
}
pub fn animate(
    mut state: ResMut<Match>,
    clock: Res<crate::native_effect_clock::EffectClock>,
    clips: Res<Assets<AnimationClip>>,
    mut actors: Query<(Entity, &mut AnimationPlayer, &mut AnimationTransitions, &mut Actor)>,
) {
    // Explicit field borrows keep the new W state independent of attack journals.
    let state=&mut *state;
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    for (entity, mut player, mut transitions, mut actor) in &mut actors {
        if let Some(altar) = snapshot
            .map10
            .as_ref()
            .and_then(|m| m.altars.iter().find(|a| a.id == actor.playback.id))
        {
            let captured = altar.captured_tick.is_some_and(|tick| {
                snapshot.tick
                    < tick
                        + actor
                            .playback
                            .durations
                            .get("capture")
                            .copied()
                            .unwrap_or(1)
            });
            let role = if captured {
                "capture"
            } else if altar.capturing.is_some() {
                "idle"
            } else if snapshot.tick < altar.locked_until {
                "locked"
            } else if snapshot.tick
                < altar.locked_until + actor.playback.durations.get("unlock").copied().unwrap_or(1)
            {
                "unlock"
            } else {
                "idle"
            };
            if actor.role != role {
                if let Some(index) = actor.playback.roles.get(role).copied() {
                    let active =
                        transitions.play(&mut player, index, std::time::Duration::from_millis(80));
                    if role == "idle" || role == "locked" {
                        active.repeat();
                    }
                    actor.role = role.to_string();
                }
            }
            continue;
        }
        let actor_state =
            if let Some(champion) = snapshot.players.iter().find(|p| p.id == actor.playback.id) {
                Some((
                    champion.health,
                    champion.next_attack,
                    openleague_core::trundle_e::champion_forced(champion,snapshot.tick),
                    champion.destination.is_some() && champion.effects.annie_q.is_none() && champion.effects.annie_w.is_none() && champion.effects.annie_r.is_none() && !openleague_core::stuns::active(champion,snapshot.tick),
                    champion.effects.ultimate.is_some(),
                    snapshot.tick < champion.effects.spin_until,
                    champion.windup.as_ref().map(|w| w.critical),
                    true,
                    openleague_core::stuns::active(champion,snapshot.tick),
                    if champion.effects.annie_q.is_some() {Some("spell1")} else if champion.effects.annie_w.is_some() {Some("spell2")} else if champion.effects.annie_r.is_some() {Some("spell4")} else {None},
                ))
            } else {
                snapshot
                    .units
                    .iter()
                    .find(|u| u.id == actor.playback.id)
                    .map(|u| {
                        (
                            u.health,
                            u.next_attack,
                            openleague_core::trundle_e::unit_forced(u,snapshot.tick),
                            u.destination.is_some() && !openleague_core::stuns::unit_active(u,snapshot.tick),
                            false,
                            false,
                            None,
                            false,
                            openleague_core::stuns::unit_active(u,snapshot.tick),
                            if !openleague_core::stuns::unit_active(u,snapshot.tick) && u.pet.as_ref().is_some_and(|pet|snapshot.tick<pet.spawned+actor.playback.durations.get("spawn").copied().unwrap_or(0)) {Some("spawn")} else {None},
                        )
                    })
            };
        let Some((health, next_attack, forced, moving, ultimate, spin, critical, champion, stunned, cast_role)) = actor_state else {
            continue;
        };
        let identity_champion = champion && openleague_core::attacks::supports_champion_presentation(&actor.playback.model_name);
        // A canonical model stays identity-driven even on a mismatched fixture:
        // never manufacture an attack from that source's cooldown deadline.
        let matching_champion = identity_champion && snapshot.players.iter().any(|source|
            source.id == actor.playback.id && source.champion == actor.playback.model_name);
        let garen = matching_champion && actor.playback.model_name == "garen";
        let vilemaw = !champion && actor.playback.model_name == openleague_core::vilemaw_attacks::DEFINITION
            && snapshot.units.iter().any(|unit| unit.id == actor.playback.id && openleague_core::vilemaw_attacks::is_vilemaw(unit));
        let identity_driven = identity_champion || vilemaw;
        let mut presentation = if matching_champion {
            let duration = if garen { openleague_core::garen_q_resource::binding().ok()
                .and_then(|binding| actor.playback.clips.get(binding.presentation_role()))
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration) }
                else if actor.playback.model_name=="trundle" {
                    actor.playback.clips.get("spell1").and_then(|handle|clips.get(handle)).map(AnimationClip::duration)
                } else { None };
            state.attack_visuals.selection(actor.playback.id, clock.now, duration)
        } else if vilemaw {
            let duration = actor.playback.clips.get("attack")
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration);
            state.vilemaw_visuals.selection(actor.playback.id, clock.now, duration)
                .map(|selected| crate::attack_animation::Selection { attack:selected.attack, kind:selected.kind,
                    role:selected.role, started:selected.started, age_seconds:selected.age_seconds })
        } else { None };
        // Missing champion crit roles use the existing attack clip while keeping
        // the exact critical identity and age. The boss channel is independent.
        if identity_champion && !actor.playback.roles.contains_key("crit") {
            if let Some(selected) = presentation.as_mut().filter(|selected| selected.role == "crit") { selected.role = "attack"; }
        }
        let presentation_key = presentation.as_ref().map(|p|(p.attack,p.kind));
        let new_attack = if identity_driven { presentation_key.is_some() && presentation_key != actor.presentation }
            else { next_attack > actor.previous_attack };
        if !identity_driven && new_attack {
            actor.previous_attack = next_attack;
            actor.attack_until = snapshot.tick + 12;
            actor.critical = critical.unwrap_or(false);
        }
        if !identity_driven { if let Some(value) = critical {
            actor.critical = value;
        } }
        if champion && critical.is_none() && next_attack <= snapshot.tick {
            actor.attack_until = 0;
        }
        if forced || stunned || identity_driven { actor.attack_until = 0; }
        let trundle=matching_champion && actor.playback.model_name=="trundle";
        let windup=snapshot.players.iter().find(|source|source.id==actor.playback.id)
            .is_some_and(|source|source.windup.is_some());
        // R preserves gameplay movement: its one-shot may glide while the
        // accepted destination remains unchanged. Only W needs the idle gate.
        let r_eligible=health.is_finite() && health>0. && !forced && !stunned && !ultimate && !spin && cast_role.is_none();
        let ordinary=r_eligible && !moving;
        let w_idle=ordinary && !windup && presentation.is_none();
        let duration_for=|role:&str|actor.playback.clips.get(role).and_then(|handle|clips.get(handle))
            .filter(|_|actor.playback.roles.contains_key(role)).map(AnimationClip::duration);
        let journal_supported=trundle && state.trundle_cast_visuals.supported();
        let cast_selection=if journal_supported {
            // Legacy Zone state cannot recreate a W pose after journal mode.
            state.trundle_w_visuals.retire(actor.playback.id);
            state.trundle_cast_visuals.select(actor.playback.id,entity.to_bits(),clock.now,
                [duration_for("spell2"),duration_for("spell4")],[w_idle,r_eligible],clock.presentation_ready())
        } else {None};
        let legacy_w=if trundle && !journal_supported {
            state.trundle_w_visuals.select(actor.playback.id,entity.to_bits(),clock.now,duration_for("spell2"),w_idle,clock.presentation_ready())
        } else {None};
        let w_selection=cast_selection.filter(|selected|selected.kind==openleague_core::accepted_cast_presentation::Kind::W)
            .map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first})
            .or_else(||legacy_w.map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first}));
        let r_selection=cast_selection.filter(|selected|selected.kind==openleague_core::accepted_cast_presentation::Kind::R)
            .map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first});
        let role = if crate::nexus_ceremony::holds_default_idle(actor.playback.id,snapshot.result.as_ref()) {
            "idle"
        } else if health <= 0. {
            "death"
        } else if forced {
            // Authoritative CANCEL_ORDER leaves destination empty during a push.
            // Use its real received motion state; never manufacture a move or stun.
            "run"
        } else if ultimate {
            "spell4"
        } else if spin {
            "spell3"
        } else if let Some(role)=cast_role {role
        } else if stunned {
            if actor.playback.roles.contains_key("stun") { "stun" } else { "idle" }
        } else if vilemaw && moving {
            // The verified boss catalog has no run role today. Do not retain
            // an attack merely because that missing role cannot be played.
            if actor.playback.roles.contains_key("run") { "run" } else { "idle" }
        } else if r_selection.is_some() {
            "spell4"
        } else if w_selection.is_some() {
            "spell2"
        } else if identity_driven {
            presentation.as_ref().map(|p|p.role).unwrap_or(if moving { "run" } else { "idle" })
        } else if critical.is_some() || snapshot.tick < actor.attack_until {
            if actor.critical && actor.playback.roles.contains_key("crit") {
                "crit"
            } else {
                "attack"
            }
        } else if moving {
            "run"
        } else {
            "idle"
        };
        stop_trundle_w_on_exit(&mut player,&actor.playback.model_name,&actor.role,
            w_selection.is_some(),actor.playback.roles.get("spell2").copied());
        stop_trundle_r_on_exit(&mut player,&actor.playback.model_name,&actor.role,
            r_selection.is_some(),actor.playback.roles.get("spell4").copied());
        let Some(index) = actor.playback.roles.get(role).copied() else {
            continue;
        };
        actor.presentation = if presentation.as_ref().is_some_and(|p|p.role==role) {presentation_key} else {None};
        let starts_selected_attack = new_attack && (!identity_driven || presentation.as_ref().is_some_and(|p|p.role==role));
        let starts_selected_w=role=="spell2" && w_selection.as_ref().is_some_and(|selected|selected.first);
        let starts_selected_r=role=="spell4" && r_selection.as_ref().is_some_and(|selected|selected.first);
        if actor.role == role && !starts_selected_attack && !starts_selected_w && !starts_selected_r {
            if role=="spell2" {
                if let Some(selected)=w_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {
                        state.trundle_w_visuals.retire(actor.playback.id);
                        state.trundle_cast_visuals.retire(actor.playback.id);
                    }
                }
            } else if role=="spell4" {
                if let Some(selected)=r_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {state.trundle_cast_visuals.retire(actor.playback.id);}
                }
            }
            continue;
        }
        let active = transitions.play(&mut player, index, std::time::Duration::from_millis(80));
        if let Some(presentation) = presentation.as_ref().filter(|p|p.role==role) {
            // Start at the already-observed age without retroactively firing
            // clip events. Loaded Q/Vilemaw durations are not gameplay impact times.
            active.set_seek_time(presentation.age_seconds);
        } else if role=="spell2" {
            if let Some(selected)=w_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        } else if role=="spell4" {
            if let Some(selected)=r_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        }
        if !crate::structure_animation_clock::configure(&actor.playback.model_name,role,active)
            && ["idle", "run", "spell3"].contains(&role) {active.repeat();}
        actor.role = role.into();
    }
}

#[derive(Clone,Copy)]
struct CastSeek {age_seconds:f32,first:bool}

fn stop_trundle_r_on_exit(player:&mut AnimationPlayer,model:&str,previous_role:&str,
    r_selected:bool,r_index:Option<AnimationNodeIndex>) {
    if model=="trundle" && previous_role=="spell4" && !r_selected {
        if let Some(index)=r_index {player.stop(index);}
    }
}

/// Paused clips are deliberately not faded by AnimationTransitions::play.
/// Remove exactly the outgoing W clip before any other role is selected, even
/// if that role is absent. Never stop/resume another actor, role or attack.
fn stop_trundle_w_on_exit(player:&mut AnimationPlayer,model:&str,previous_role:&str,
    w_selected:bool,w_index:Option<AnimationNodeIndex>) {
    if model=="trundle" && previous_role=="spell2" && !w_selected {
        if let Some(index)=w_index {player.stop(index);}
    }
}

/// Only the W pose is held at its EffectClock-derived age. This applies newer
/// received tick corrections too; no global clock or other role is paused.
fn hold_trundle_w_pose(player:&mut AnimationPlayer,index:AnimationNodeIndex,age:f32)->bool {
    let Some(active)=player.animation_mut(index) else {return false;};
    active.set_seek_time(age);active.pause();true
}

/// Optional observation of actual AnimationPlayers; never alters gameplay or playback.
pub fn destruction_probe(time: Res<Time>, state: Res<Match>, actors: Query<(Entity, &AnimationPlayer, &Actor)>, children: Query<&Children>, joints: Query<(&Name,&Transform)>, mut last: Local<f32>) {
    let Ok(path)=std::env::var("OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE") else {return;};
    if time.elapsed_secs()-*last<0.2 {return;}
    *last=time.elapsed_secs();
    let rows:Vec<_>=actors.iter().filter(|(_,_,a)|a.playback.model_name.contains("Turret")||a.playback.model_name.contains("Inhibitor")||a.playback.model_name.contains("Nexus")).map(|(entity,player,actor)| {
        let clips:Vec<_>=player.playing_animations().map(|(_,a)|serde_json::json!({"elapsed":a.elapsed(),"seek_time":a.seek_time(),"completions":a.completions(),"finished":a.is_finished()})).collect();
        let pose:Vec<_>=children.iter_descendants(entity).filter_map(|e|joints.get(e).ok()).map(|(name,t)|serde_json::json!({"name":name.as_str(),"translation":t.translation.to_array(),"rotation":t.rotation.to_array(),"scale":t.scale.to_array()})).collect();
        serde_json::json!({"id":actor.playback.id,"model":actor.playback.model_name,"role":actor.role,"active_clips":clips,"joint_pose":pose})
    }).collect();
    if rows.is_empty() {return;}
    let record=serde_json::json!({"time":time.elapsed_secs(),"tick":state.snapshot.as_ref().map(|s|s.tick),"actors":rows});
    use std::io::Write;
    if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path) {let _=writeln!(file,"{record}");}
}

pub fn synchronize_finished_structure_clocks(mut actors:Query<(&mut AnimationPlayer,&Actor)>) {
 for (mut player,actor) in &mut actors {
  for (_,active) in player.playing_animations_mut() {
   crate::structure_animation_clock::clamp_finished(&actor.playback.model_name,&actor.role,active);
  }
 }
}

/// Opt-in observation of actual Garen AnimationPlayers; never changes input or playback.
pub fn garen_attack_probe(time:Res<Time>,clock:Res<crate::native_effect_clock::EffectClock>,state:Res<Match>,catalog:Res<Catalog>,actors:Query<(&AnimationPlayer,&Actor)>,roots:Query<&Transform,With<crate::actor_fow::Root>>,mut previous:Local<f64>) {
    let Ok(path)=std::env::var("OPENLEAGUE_GAREN_ATTACK_PROBE") else{return;};
    let now=time.elapsed_secs_f64();if now-*previous<0.025{return;}*previous=now;
    let Some(snapshot)=&state.snapshot else{return;};
    let rows:Vec<_>=actors.iter().filter(|(_,a)|a.playback.model_name=="garen").map(|(player,actor)| {
        let root=state.visuals.get(&actor.playback.id).and_then(|entity|roots.get(*entity).ok());
        let state=snapshot.players.iter().find(|p|p.id==actor.playback.id);
        let clips:Vec<_>=player.playing_animations().map(|(index,active)|serde_json::json!({"graph_node":index.index(),"seek_time":active.seek_time(),"elapsed":active.elapsed(),"finished":active.is_finished()})).collect();
        serde_json::json!({"source":actor.playback.id,"role":actor.role,"clip":catalog.0["garen"]["roles"][&actor.role],"presentation":actor.presentation.map(|(id,kind)|serde_json::json!({"attack":id,"kind":kind})),"windup":state.and_then(|p|p.windup.as_ref()),"empowered_until":state.map(|p|p.effects.empowered_until),"position_native":state.map(|p|p.position),"facing_native":state.and_then(|p|p.facing),"root_rotation":root.map(|t|t.rotation.to_array()),"render_forward":root.map(|t|(t.rotation*Vec3::Z).to_array()),"clips":clips})
    }).collect();
    if rows.is_empty(){return;}
    let record=serde_json::json!({"session":snapshot.session,"tick":snapshot.tick,"wall_time":now,"presentation_clock":clock.diagnostic(),"error":state.attack_visuals.error(),"q_resource_contract":openleague_core::garen_q_resource::binding().map(|binding|binding.diagnostic()).map_err(str::to_owned),"actors":rows});
    use std::io::Write;
    if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path){let _=writeln!(file,"{record}");}
}

#[cfg(test)] mod attack_binding_tests {
    use super::*;
    use openleague_core::{attack_presentation::{State as Events,Kind,Audience,CancelReason},attacks::Windup};

    fn fixture()->(App,openleague_core::Simulation,u32,u32,Entity) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;
        let id=game.join("garen").unwrap();let target=game.join("garen").unwrap();
        let mut assets=Assets::<AnimationClip>::default();let mut q=AnimationClip::default();q.set_duration(1.);let q=assets.add(q);
        let roles=HashMap::from([("idle".into(),AnimationNodeIndex::new(0)),("spell1".into(),AnimationNodeIndex::new(1)),("attack".into(),AnimationNodeIndex::new(2)),("crit".into(),AnimationNodeIndex::new(3))]);
        let playback=Playback{id,model_name:"garen".into(),graph:Handle::default(),_model:Handle::default(),roles,clips:HashMap::from([("spell1".into(),q)]),durations:HashMap::new()};
        let mut state=Match::default();state.attack_visuals.reset(7);let snapshot=game.snapshot();state.attack_visuals.observe(&snapshot,0.).unwrap();state.snapshot=Some(snapshot);
        let mut app=App::new();app.init_resource::<Time>().init_resource::<crate::native_effect_clock::EffectClock>().insert_resource(assets).insert_resource(state).add_systems(Update,animate);
        let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
        (app,game,id,target,entity)
    }
    fn publish(app:&mut App,game:&openleague_core::Simulation,events:&Events,now:f64) {
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=now;
        let mut snapshot=game.snapshot();snapshot.attack_events=events.events();
        let mut state=app.world_mut().resource_mut::<Match>();state.attack_visuals.observe(&snapshot,now).unwrap();state.snapshot=Some(snapshot);
        app.update();
    }
    #[test] fn actual_player_does_not_restart_at_resolution_and_new_same_role_attack_restarts_at_age() {
        let (mut app,mut game,id,target,entity)=fixture();let mut events=Events::default();let audience=Audience::from_visibility(true,true);
        let attack=events.begin(id,1,4,Kind::GarenQ,audience).unwrap();game.tick=2;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:4,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&events,0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
        let index=AnimationNodeIndex::new(1);
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.15);
        events.resolve(attack,4,Kind::GarenQ,true,audience).unwrap();game.tick=4;game.players.get_mut(&id).unwrap().windup=None;
        publish(&mut app,&game,&events,0.2);
        assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.15);
        let next=events.begin(id,50,54,Kind::GarenQ,audience).unwrap();game.tick=51;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:50,release:54,cancelable:true,critical:false,presentation:Some(next)});
        publish(&mut app,&game,&events,1.7);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,Some((next.id,Kind::GarenQ)));
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        events.cancel(next,52,CancelReason::Order,audience).unwrap();game.tick=52;
        let player=game.players.get_mut(&id).unwrap();player.windup=None;player.next_attack=99;
        publish(&mut app,&game,&events,1.74);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
        assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,None);
    }
    #[test] fn catalog_garen_roles_reference_the_audited_native_clips() {
        let q = openleague_core::garen_q_resource::binding().unwrap();
        assert_eq!((q.resource_name(),q.animation_name(),q.presentation_role()),("GarenQAttack","Spell1","spell1"));
        let catalog=Catalog::default();let garen=&catalog.0["garen"];
        for (role,index,name) in [("spell1",23,"Garen_2013_spell1"),("attack",0,"Garen_2013_Attack_01"),("crit",4,"Garen_2013_Crit")] {
            assert_eq!(garen["roles"][role].as_u64(),Some(index));assert_eq!(garen["clips"][index as usize].as_str(),Some(name));
        }
    }
    #[test] fn host_time_does_not_expire_an_attack_while_presentation_clock_is_held() {
        let (mut app,mut game,id,target,entity)=fixture();let mut events=Events::default();
        let attack=events.begin(id,1,4,Kind::GarenQ,Audience::from_visibility(true,true)).unwrap();game.tick=2;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:4,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&events,0.1);
        app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(20));
        app.update();
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.2;
        app.update();
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }


    fn scoped_fixture(name:&str)->(App,openleague_core::Simulation,u32,u32,Entity) {
        let(mut app,mut game,id,target,entity)=fixture();
        game.players.get_mut(&id).unwrap().champion=name.into();
        app.world_mut().get_mut::<Actor>(entity).unwrap().playback.model_name=name.into();
        // The production Annie/Ashe catalogues supply death; add it to this small ECS fixture too.
        app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.insert("death".into(),AnimationNodeIndex::new(4));
        app.world_mut().resource_mut::<Match>().attack_visuals.reset(7);
        (app,game,id,target,entity)
    }
    #[test]
    fn annie_ashe_animation_seeks_delayed_start_ignores_duplicate_and_restarts_new_identity() {
        for name in ["annie","ashe"] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            let attack=facts.begin(id,10,30,Kind::Basic,audience).unwrap();game.tick=18;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:false,presentation:Some(attack)});
            publish(&mut app,&game,&facts,10.);let index=AnimationNodeIndex::new(2);
            assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-8./30.).abs()<0.0001);
            app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.35);
            publish(&mut app,&game,&facts,10.);
            assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.35);
            facts.cancel(attack,19,CancelReason::Order,audience).unwrap();let next=facts.begin(id,20,35,Kind::Basic,audience).unwrap();game.tick=21;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:20,release:35,cancelable:true,critical:false,presentation:Some(next)});
            publish(&mut app,&game,&facts,10.1);
            assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,Some((next.id,Kind::Basic)));
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        }
    }
    #[test]
    fn annie_ashe_critical_without_catalog_role_falls_back_with_same_identity_and_seek() {
        for name in ["annie","ashe"] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.remove("crit");
            let attack=facts.begin(id,1,20,Kind::Critical,audience).unwrap();game.tick=3;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:20,cancelable:true,critical:true,presentation:Some(attack)});
            publish(&mut app,&game,&facts,1.);let index=AnimationNodeIndex::new(2);
            let actor=app.world().get::<Actor>(entity).unwrap();assert_eq!(actor.role,"attack");assert_eq!(actor.presentation,Some((attack.id,Kind::Critical)));
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-2./30.).abs()<0.0001);
            game.players.get_mut(&id).unwrap().health=0.;publish(&mut app,&game,&facts,1.);
            assert!(app.world().get::<Actor>(entity).unwrap().presentation.is_none());
        }
    }

    #[test]
    fn all_canonical_basic_and_critical_animation_bindings_preserve_identity_age() {
        let catalog=Catalog::default();let canonical=openleague_core::champion_catalog().unwrap();
        assert_eq!(canonical.len(),122);let mut missing=0;
        for name in canonical.keys() { for kind in [Kind::Basic,Kind::Critical] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);
            let has_crit=catalog.0[name]["roles"].get("crit").is_some();
            assert!(catalog.0[name]["roles"].get("attack").is_some());
            if !has_crit {app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.remove("crit");}
            if kind==Kind::Critical && !has_crit {missing+=1;}
            let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            let attack=facts.begin(id,10,30,kind,audience).unwrap();game.tick=18;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:kind==Kind::Critical,presentation:Some(attack)});
            publish(&mut app,&game,&facts,10.);
            let role=if kind==Kind::Critical && has_crit {"crit"} else {"attack"};
            let index=AnimationNodeIndex::new(if role=="crit" {3} else {2});
            let actor=app.world().get::<Actor>(entity).unwrap();
            assert_eq!(actor.role,role,"{name}");assert_eq!(actor.presentation,Some((attack.id,kind)),"{name}");
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-8./30.).abs()<0.0001,"{name}");
            app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.35);
            publish(&mut app,&game,&facts,10.);
            assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.35,"{name}");
        }}
        // Synthetic ECS nodes exercise selection/seek; this does not load the GLBs.
        assert_eq!(missing,34);
    }
    #[test]
    fn all_canonical_models_without_attack_facts_ignore_future_cooldown_deadlines() {
        for name in openleague_core::champion_catalog().unwrap().keys() {
            let(mut app,mut game,id,_,entity)=scoped_fixture(name);game.tick=100;
            let source=game.players.get_mut(&id).unwrap();source.windup=None;source.next_attack=120;
            publish(&mut app,&game,&Events::default(),10.);
            let actor=app.world().get::<Actor>(entity).unwrap();
            assert_eq!(actor.role,"idle","{name}");assert_eq!(actor.presentation,None,"{name}");assert_eq!(actor.attack_until,0,"{name}");
        }
    }
    #[test]
    fn canonical_model_mismatch_does_not_consume_another_champions_identity() {
        let(mut app,mut game,id,target,entity)=scoped_fixture("ahri");
        game.players.get_mut(&id).unwrap().champion="garen".into();
        let mut facts=Events::default();let attack=facts.begin(id,10,30,Kind::GarenQ,Audience::from_visibility(true,true)).unwrap();game.tick=18;
        let source=game.players.get_mut(&id).unwrap();source.next_attack=120;
        source.windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&facts,10.);
        let actor=app.world().get::<Actor>(entity).unwrap();
        assert_eq!(actor.role,"idle");assert_eq!(actor.presentation,None);assert_eq!(actor.attack_until,0);
    }
}

// Test-only constructor for explicit ECS fixtures, not a production model path.
#[cfg(test)]
pub(crate) fn material_test_playback(id:u32,model:Handle<Gltf>)->Playback {
    Playback {id,model_name:"Garen".into(),graph:Handle::default(),_model:model,
        roles:HashMap::new(),clips:HashMap::new(),durations:HashMap::new()}
}

#[cfg(test)]
#[path = "vilemaw_animation_binding_tests.rs"]
mod vilemaw_binding_tests;

#[path = "vilemaw_animation_probe.rs"]
pub(crate) mod vilemaw_probe;

// Append inside crate::animation for controlled actor identity fixtures only.
#[cfg(test)]
pub(crate) fn endgame_test_playback(id:u32,name:&str,model:Handle<Gltf>)->Playback {
    let mut playback=material_test_playback(id,model);
    playback.model_name=name.into();
    playback
}

#[cfg(test)]
mod gnar_ashe_source_asset_binding_tests {
    use super::*;
// SOURCE PROPOSAL ONLY: insert into animation::attack_binding_tests after review.
// One new test definition; no production playback/dispatch change, no new module.
#[test]
fn catalog_gnar_spell4_and_ashe_E_bind_existing_installed_glb_clips() {
    let catalog = Catalog::default();
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    for (name, role, index, clip, count) in [
        ("gnar", "spell4", 64usize, "Gnar_Idle1_NATIVE_SPELL4_SOURCE", 65usize),
        ("ashe", "spell3", 18usize, "ashe_spell2", 20usize),
    ] {
        assert_eq!(catalog.0[name]["roles"][role].as_u64(), Some(index as u64));
        assert_eq!(catalog.0[name]["clips"][index].as_str(), Some(clip));
        let path = root.join("assets/champions").join(format!("{name}.glb"));
        let data = std::fs::read(path).unwrap();
        assert!(data.len() >= 20 && data.len() <= 64 * 1024 * 1024);
        assert_eq!(&data[..4], b"glTF");
        let word = |at| u32::from_le_bytes(data[at..at+4].try_into().unwrap()) as usize;
        assert_eq!(word(4), 2);
        assert_eq!(word(8), data.len());
        assert_eq!(word(16), 0x4e4f534a);
        let end = 20usize.checked_add(word(12)).unwrap();
        assert!(end <= data.len());
        let glb: serde_json::Value = serde_json::from_slice(&data[20..end]).unwrap();
        let animations = glb["animations"].as_array().unwrap();
        assert_eq!(animations.len(), count);
        assert_eq!(animations[index]["name"].as_str(), Some(clip));
        assert!(!animations[index]["channels"].as_array().unwrap().is_empty());
        for role_index in catalog.0[name]["roles"].as_object().unwrap().values() {
            assert!((role_index.as_u64().unwrap() as usize) < animations.len());
        }
    }
}
}


#[cfg(test)]
mod trundle_w_clock_binding_tests {
    use super::*;
    use bevy::animation::{AnimationDelta,advance_animations,
        transition::{advance_transitions,expire_completed_transitions}};
    #[test]
    fn actual_w_pose_uses_explicit_age_while_non_w_clip_and_wall_time_continue() {
        let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>()
            .add_systems(Update,(advance_transitions,advance_animations,expire_completed_transitions).chain());
        let mut w=AnimationClip::default();w.set_duration(0.73333335);
        let w=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(w);
        let mut attack=AnimationClip::default();attack.set_duration(100.);
        let attack=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(attack);
        let mut graph=AnimationGraph::new();let w_index=graph.add_clip(w,1.,graph.root);
        let attack_index=graph.add_clip(attack.clone(),1.,graph.root);
        let run_index=graph.add_clip(attack.clone(),1.,graph.root);
        let death_index=graph.add_clip(attack,1.,graph.root);
        let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        let mut player=AnimationPlayer::default();player.play(w_index);player.play(attack_index).repeat();
        assert!(hold_trundle_w_pose(&mut player,w_index,0.2));
        let entity=app.world_mut().spawn((player,AnimationGraphHandle(graph.clone()))).id();
        for age in [0.2,0.2,0.3] {
            assert!(hold_trundle_w_pose(&mut app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap(),w_index,age));
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(2));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert_eq!(player.animation(w_index).unwrap().seek_time(),age);
            assert!(player.animation(w_index).unwrap().is_paused());
            assert!(!player.animation(attack_index).unwrap().is_paused());
        }
        let player=app.world().get::<AnimationPlayer>(entity).unwrap();
        assert_eq!(player.animation(attack_index).unwrap().seek_time(),0.375);
        assert_eq!(app.world().resource::<Time>().elapsed_secs(),6.);
        let mut recreated=AnimationPlayer::default();
        assert!(!hold_trundle_w_pose(&mut recreated,w_index,0.3),"missing/recreated player must not silently start the old clip");
        for (role,index) in [("attack",attack_index),("run",run_index),("death",death_index)] {
            let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();
            transitions.play(&mut player,w_index,std::time::Duration::ZERO);
            assert!(hold_trundle_w_pose(&mut player,w_index,0.2));
            assert!(player.animation(w_index).unwrap().is_paused());
            stop_trundle_w_on_exit(&mut player,"trundle","spell2",false,Some(w_index));
            assert!(player.animation(w_index).is_none(),"outgoing paused W must be removed before {role}");
            transitions.play(&mut player,index,std::time::Duration::from_millis(80));
            assert!(!player.animation(index).unwrap().is_paused());
            let entity=app.world_mut().spawn((player,transitions,AnimationGraphHandle(graph.clone()))).id();
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert!(player.animation(w_index).is_none(),"W cannot remain as an untracked paused contributor");
            let active=player.animation(index).unwrap();assert!(!active.is_paused());
            assert_eq!(active.seek_time(),0.125);assert_eq!(active.weight(),1.);
        }
        let mut missing=AnimationPlayer::default();missing.play(w_index);
        assert!(hold_trundle_w_pose(&mut missing,w_index,0.2));
        stop_trundle_w_on_exit(&mut missing,"trundle","spell2",false,Some(w_index));
        assert!(missing.animation(w_index).is_none(),"cleanup also precedes a missing next role");
        let mut foreign=AnimationPlayer::default();foreign.play(w_index);
        stop_trundle_w_on_exit(&mut foreign,"annie","spell2",false,Some(w_index));
        assert!(foreign.animation(w_index).is_some(),"another champion's spell2 is never removed");
    }
}


#[cfg(test)]
mod trundle_e_forced_binding_tests {
    use super::*;
    use openleague_core::{Point, attack_presentation::{State as Events, Kind, Audience}, attacks::Windup};

    fn fixture()->(App,openleague_core::Simulation,u32,u32,Entity) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;game.tick=101;
        let id=game.join("trundle").unwrap();let target=game.join("garen").unwrap();
        game.players.get_mut(&id).unwrap().position=Point{x:100.,z:100.};
        let mut clips=Assets::<AnimationClip>::default();let mut clip=AnimationClip::default();clip.set_duration(1.);let clip=clips.add(clip);
        let roles=HashMap::from([("idle".into(),AnimationNodeIndex::new(0)),("spell1".into(),AnimationNodeIndex::new(1)),
            ("attack".into(),AnimationNodeIndex::new(2)),("crit".into(),AnimationNodeIndex::new(3)),("spell2".into(),AnimationNodeIndex::new(4)),
            ("run".into(),AnimationNodeIndex::new(5)),("death".into(),AnimationNodeIndex::new(6)),("spell3".into(),AnimationNodeIndex::new(7))]);
        let playback=Playback{id,model_name:"trundle".into(),graph:Handle::default(),_model:Handle::default(),roles,
            clips:HashMap::from([("spell1".into(),clip.clone()),("spell2".into(),clip)]),durations:HashMap::new()};
        let mut state=Match::default();state.attack_visuals.reset(7);state.trundle_w_visuals.reset(7);
        let mut app=App::new();app.init_resource::<crate::native_effect_clock::EffectClock>()
            .insert_resource(clips).insert_resource(state).add_systems(Update,animate);
        let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
        (app,game,id,target,entity)
    }
    fn push(_owner:u32,started:u64)->openleague_core::trundle_e::ForcedMovement {
        openleague_core::trundle_e::ForcedMovement{started,until:started+5}
    }
    fn publish(app:&mut App,snapshot:openleague_core::Snapshot,now:f64) {
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=now;
        let mut state=app.world_mut().resource_mut::<Match>();
        state.attack_visuals.observe(&snapshot,now).unwrap();state.trundle_w_visuals.observe_accepted(&snapshot,now).unwrap();state.snapshot=Some(snapshot);
        app.update();
    }
    #[test]
    fn received_forced_champion_runs_before_w_windup_and_cast_without_fake_order() {
        let(mut app,mut game,id,target,entity)=fixture();
        let mut facts=Events::default();let attack=facts.begin(id,100,110,Kind::Basic,Audience::from_visibility(true,true)).unwrap();
        let p=game.players.get_mut(&id).unwrap();p.ranks[1]=1;
        p.effects.trundle_w=Some(openleague_core::trundle_w::Zone{owner:id,center:p.position,rank:1,starts:100,until:340});
        p.effects.trundle_e_push=Some(push(id,101));
        p.windup=Some(Windup{target,started:100,release:110,cancelable:true,critical:false,presentation:Some(attack)});
        assert!(p.destination.is_none() && p.stuns.is_empty());
        let w_index=AnimationNodeIndex::new(4);app.world_mut().get_mut::<Actor>(entity).unwrap().role="spell2".into();
        app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().play(w_index).pause();
        let mut snapshot=game.snapshot();snapshot.attack_events=facts.events();let original=serde_json::to_value(&snapshot).unwrap();
        publish(&mut app,snapshot.clone(),0.);
        let actor=app.world().get::<Actor>(entity).unwrap();assert_eq!(actor.role,"run");assert!(actor.presentation.is_none());
        assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(w_index).is_none());
        assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(),original);
        assert!(game.players[&id].destination.is_none() && game.players[&id].stuns.is_empty());
        // A received expired push cannot suppress an otherwise valid existing attack.
        game.tick=106;game.players.get_mut(&id).unwrap().effects.spin_until=0;
        let mut expired=game.snapshot();expired.attack_events=facts.events();publish(&mut app,expired,0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
        game.tick=107;game.players.get_mut(&id).unwrap().effects.spin_until=110;game.players.get_mut(&id).unwrap().effects.trundle_e_push=Some(push(id,107));
        let mut casting=game.snapshot();casting.attack_events=facts.events();publish(&mut app,casting,0.15);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"run","forced motion also wins over a received cast role");
        game.players.get_mut(&id).unwrap().health=0.;
        let mut dead=game.snapshot();dead.attack_events=facts.events();publish(&mut app,dead,0.2);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"death");
    }
    #[test]
    fn received_forced_unit_with_no_destination_beats_legacy_attack_and_expires_to_idle() {
        let(mut app,game,id,_,entity)=fixture();let unit_id=1000;
        let mut unit:openleague_core::world::Unit=serde_json::from_value(serde_json::json!({
            "id":unit_id,"name":"fixture","definition":"Blue_Minion_Basic","kind":"Melee","team":1,
            "position":{"x":100.,"z":100.},"height":0.,"facing":0.,"health":100.,"max_health":100.,
            "damage":1.,"armor":0.,"magic_resist":0.,"gold":0.,"experience":0.,"target":null,"destination":null,
            "next_attack":120,"silence_until":0,"respawn_at":null})).unwrap();
        {let mut actor=app.world_mut().get_mut::<Actor>(entity).unwrap();actor.playback.id=unit_id;actor.playback.model_name="Blue_Minion_Basic".into();}
        let mut ordinary=game.snapshot();ordinary.units.push(unit.clone());publish(&mut app,ordinary,0.);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack","no push preserves existing NPC attack selection");
        unit.trundle_e_push=Some(push(id,102));let mut forced=game.snapshot();forced.tick=102;forced.units.push(unit.clone());
        publish(&mut app,forced,0.1);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"run");
        assert_eq!(app.world().get::<Actor>(entity).unwrap().attack_until,0);
        assert!(unit.destination.is_none() && unit.stuns.is_empty());
        let mut expired=game.snapshot();expired.tick=107;expired.units.push(unit);publish(&mut app,expired,0.2);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }
}


#[cfg(test)]
mod trundle_r_clock_binding_tests {
    use super::*;
    use bevy::animation::{AnimationDelta,advance_animations,
        transition::{advance_transitions,expire_completed_transitions}};
    #[test]
    fn actual_r_replaces_paused_w_and_exits_to_current_attack_run_death_without_global_stop() {
        let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>()
            .add_systems(Update,(advance_transitions,advance_animations,expire_completed_transitions).chain());
        let mut clip=AnimationClip::default();clip.set_duration(100.);
        let clip=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
        let mut graph=AnimationGraph::new();let w=graph.add_clip(clip.clone(),1.,graph.root);
        let r=graph.add_clip(clip.clone(),1.,graph.root);let foreign=graph.add_clip(clip.clone(),1.,graph.root);
        let nexts=[graph.add_clip(clip.clone(),1.,graph.root),graph.add_clip(clip.clone(),1.,graph.root),graph.add_clip(clip,1.,graph.root)];
        let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        for (role,next) in ["attack","run","death"].into_iter().zip(nexts) {
            let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();
            transitions.play(&mut player,w,std::time::Duration::ZERO);
            assert!(hold_trundle_w_pose(&mut player,w,0.2));player.play(foreign).repeat();
            stop_trundle_w_on_exit(&mut player,"trundle","spell2",false,Some(w));
            assert!(player.animation(w).is_none());
            transitions.play(&mut player,r,std::time::Duration::from_millis(80));
            assert!(hold_trundle_w_pose(&mut player,r,0.1));
            assert!(hold_trundle_w_pose(&mut player,r,0.3));
            assert_eq!(player.animation(r).unwrap().seek_time(),0.3);
            stop_trundle_r_on_exit(&mut player,"trundle","spell4",false,Some(r));
            assert!(player.animation(r).is_none(),"paused R removed before {role} lookup");
            assert!(player.animation(foreign).is_some(),"only outgoing R may be stopped");
            transitions.play(&mut player,next,std::time::Duration::from_millis(80));
            let entity=app.world_mut().spawn((player,transitions,AnimationGraphHandle(graph.clone()))).id();
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert!(player.animation(w).is_none() && player.animation(r).is_none());
            let next=player.animation(next).unwrap();assert!(!next.is_paused());assert_eq!(next.seek_time(),0.125);assert_eq!(next.weight(),1.);
            assert!(player.animation(foreign).is_some());
        }
        let mut player=AnimationPlayer::default();player.play(r).pause();player.play(foreign).repeat();
        stop_trundle_r_on_exit(&mut player,"trundle","spell4",false,Some(r));
        assert!(player.animation(r).is_none(),"also removed before a missing next role");assert!(player.animation(foreign).is_some());
        player.play(r).pause();stop_trundle_r_on_exit(&mut player,"annie","spell4",false,Some(r));
        assert!(player.animation(r).is_some(),"foreign model role cannot be stopped");
        stop_trundle_r_on_exit(&mut player,"trundle","spell4",true,Some(r));assert!(player.animation(r).is_some());
    }
}
