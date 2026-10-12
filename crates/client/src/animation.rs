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
    state: Res<Match>,
    clock: Res<crate::native_effect_clock::EffectClock>,
    clips: Res<Assets<AnimationClip>>,
    mut actors: Query<(&mut AnimationPlayer, &mut AnimationTransitions, &mut Actor)>,
) {
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    for (mut player, mut transitions, mut actor) in &mut actors {
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
        let Some((health, next_attack, moving, ultimate, spin, critical, champion, stunned, cast_role)) = actor_state else {
            continue;
        };
        let garen = champion && actor.playback.model_name == "garen";
        let vilemaw = !champion && actor.playback.model_name == openleague_core::vilemaw_attacks::DEFINITION
            && snapshot.units.iter().any(|unit| unit.id == actor.playback.id && openleague_core::vilemaw_attacks::is_vilemaw(unit));
        let identity_driven = garen || vilemaw;
        let presentation = if garen {
            let duration = openleague_core::garen_q_resource::binding().ok()
                .and_then(|binding| actor.playback.clips.get(binding.presentation_role()))
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration);
            state.attack_visuals.selection(actor.playback.id, clock.now, duration)
        } else if vilemaw {
            let duration = actor.playback.clips.get("attack")
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration);
            state.vilemaw_visuals.selection(actor.playback.id, clock.now, duration)
                .map(|selected| crate::attack_animation::Selection { attack:selected.attack, kind:selected.kind,
                    role:selected.role, started:selected.started, age_seconds:selected.age_seconds })
        } else { None };
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
        if stunned || identity_driven { actor.attack_until = 0; }
        let role = if crate::nexus_ceremony::holds_default_idle(actor.playback.id,snapshot.result.as_ref()) {
            "idle"
        } else if health <= 0. {
            "death"
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
        let Some(index) = actor.playback.roles.get(role).copied() else {
            continue;
        };
        actor.presentation = if presentation.as_ref().is_some_and(|p|p.role==role) {presentation_key} else {None};
        let starts_selected_attack = new_attack && (!identity_driven || presentation.as_ref().is_some_and(|p|p.role==role));
        if actor.role == role && !starts_selected_attack {
            continue;
        }
        let active = transitions.play(&mut player, index, std::time::Duration::from_millis(80));
        if let Some(presentation) = presentation.as_ref().filter(|p|p.role==role) {
            // Start at the already-observed age without retroactively firing
            // clip events. Loaded Q/Vilemaw durations are not gameplay impact times.
            active.set_seek_time(presentation.age_seconds);
        }
        if !crate::structure_animation_clock::configure(&actor.playback.model_name,role,active)
            && ["idle", "run", "spell3"].contains(&role) {active.repeat();}
        actor.role = role.into();
    }
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
