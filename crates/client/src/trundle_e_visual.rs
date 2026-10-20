//! Reconstructed persistent pillar presentation from the server-filtered projection.
//! Idle-only native asset binding; no native spawn/death/VFX/audio dispatch claim.
use bevy::{prelude::*, world_serialization::WorldAssetRoot};
use openleague_core::{Point, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};
use crate::{Connection, Match};

const ASSET: &str = "forms/trundlewall.glb";
const IDLE: &str = "IceBlock_Idle1";
const IDLE_INDEX: usize = 1;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Identity { session: u64, owner: u32, starts: u64, until: u64 }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Stamp { identity: Identity, center: [u32; 2] }
#[derive(Debug, Clone, Copy, PartialEq)]
struct Anchor { stamp: Stamp, age: f64, clock: f64, visible: bool, appearance: u64 }
#[derive(Debug, Clone, Copy, PartialEq)]
struct Placement { identity: Identity, center: Point, age: f64, appearance: u64 }

#[derive(Debug, Clone, Default, PartialEq)]
pub(crate) struct State {
    session: Option<u64>, epoch: Option<u64>, tick: Option<u64>, clock: Option<f64>,
    anchors: BTreeMap<u32, Anchor>, serial: u64, admitted: bool,
    finished: bool, error: Option<String>,
}
impl State {
    pub(crate) fn reset(&mut self, session: u64) {
        if self.session == Some(session) {
            self.tick = None; self.clock = None; self.epoch = None; self.admitted = false;
        } else { *self = Self { session: Some(session), ..Self::default() }; }
    }
    pub(crate) fn begin_epoch(&mut self, session: u64, epoch: u64) {
        if self.session != Some(session) { self.reset(session); }
        if self.epoch != Some(epoch) {
            self.epoch = Some(epoch); self.tick = None; self.clock = None; self.admitted = false;
        }
    }
    pub(crate) fn observe_accepted(&mut self, snapshot: &Snapshot, now: f64) -> Result<bool, String> {
        if self.session != Some(snapshot.session) || self.tick.is_some_and(|t| snapshot.tick < t)
            || self.error.is_some() { return Ok(false); }
        let mut next = self.clone();
        match next.observe_inner(snapshot, now) {
            Ok(()) => { *self = next; Ok(true) }
            Err(error) => {
                self.admitted = false; self.error = Some(error.clone()); Err(error)
            }
        }
    }
    fn observe_inner(&mut self, snapshot: &Snapshot, now: f64) -> Result<(), String> {
        if !now.is_finite() || self.clock.is_some_and(|t| now < t) {
            return Err("pillar effect clock is nonfinite or backwards".into());
        }
        let mut roster = BTreeSet::new();
        for p in snapshot.roster.iter().filter(|p| p.champion == "trundle") {
            if !roster.insert(p.id) { return Err("duplicate pillar roster owner".into()); }
        }
        if roster.len() > openleague_core::attack_presentation::Limits::default().active_sources() {
            return Err("pillar roster exceeds existing six-player capacity".into());
        }
        self.anchors.retain(|owner, _| roster.contains(owner));
        self.tick = Some(snapshot.tick); self.clock = Some(now); self.admitted = true;
        self.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        if self.finished { for a in self.anchors.values_mut() { a.visible = false; } return Ok(()); }
        let was_visible: BTreeSet<_> = self.anchors.iter().filter_map(|(id,a)| a.visible.then_some(*id)).collect();
        for a in self.anchors.values_mut() {
            if now < a.clock { return Err("pillar anchor clock went backwards".into()); }
            a.age = (a.age + (now - a.clock)).max(snapshot.tick.saturating_sub(a.stamp.identity.starts) as f64 / TICK_RATE as f64);
            if !a.age.is_finite() { return Err("pillar age overflow".into()); }
            a.clock = now; a.visible = false;
        }
        let mut owners = BTreeSet::new();
        for p in &snapshot.trundle_e_pillars {
            if !roster.contains(&p.owner) || !owners.insert(p.owner) || !p.center.finite()
                || p.starts.checked_add(6 * TICK_RATE) != Some(p.until) || p.starts > snapshot.tick {
                return Err("invalid projected pillar identity".into());
            }
            let stamp = Stamp { identity: Identity { session: snapshot.session, owner: p.owner, starts: p.starts, until: p.until },
                center: [p.center.x.to_bits(), p.center.z.to_bits()] };
            let new = match self.anchors.get(&p.owner) {
                Some(old) if p.starts < old.stamp.identity.starts => return Err("pillar identity went backwards".into()),
                Some(old) if p.starts == old.stamp.identity.starts => {
                    if old.stamp != stamp { return Err("pillar center or deadline changed for the same identity".into()); }
                    false
                }
                _ => true,
            };
            let visible = snapshot.tick < p.until;
            if new || (visible && !was_visible.contains(&p.owner)) {
                self.serial = self.serial.checked_add(1).ok_or("pillar appearance serial overflow")?;
            }
            if new {
                self.anchors.insert(p.owner, Anchor { stamp, age: (snapshot.tick - p.starts) as f64 / TICK_RATE as f64,
                    clock: now, visible, appearance: self.serial });
            } else if let Some(a) = self.anchors.get_mut(&p.owner) {
                a.visible = visible;
                if visible && !was_visible.contains(&p.owner) { a.appearance = self.serial; }
            }
        }
        Ok(())
    }
    fn placements(&self, now: f64, ready: bool) -> Vec<Placement> {
        if !ready || !self.admitted || self.finished || self.error.is_some() || !now.is_finite() { return Vec::new(); }
        self.anchors.values().filter_map(|a| {
            let age = a.age + (now - a.clock);
            if !a.visible || now < a.clock || !age.is_finite() || age < 0.
                || age >= (a.stamp.identity.until - a.stamp.identity.starts) as f64 / TICK_RATE as f64 { return None; }
            Some(Placement { identity: a.stamp.identity, center: Point { x: f32::from_bits(a.stamp.center[0]), z: f32::from_bits(a.stamp.center[1]) }, age, appearance: a.appearance })
        }).collect()
    }
}

#[derive(Resource)] struct Terrain(Option<openleague_core::Navigation>);
impl Default for Terrain {
    fn default() -> Self {
        let nav = openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"));
        match nav { Ok(nav) => Self(Some(nav)), Err(error) => { error!("Pillar terrain unavailable: {error}"); Self(None) } }
    }
}
#[derive(Component, Clone, Copy)] struct Pillar { identity: Identity, appearance: u64 }
#[derive(Component)] struct Pending(Handle<Gltf>);
#[derive(Component)] struct Ready { _model: Handle<Gltf>, graph: Handle<AnimationGraph>, idle: AnimationNodeIndex, clip: Handle<AnimationClip> }
#[derive(Component)] struct Bound;
#[derive(Clone, Copy)] struct Root { identity: Identity, appearance: u64, entity: Entity }
#[derive(Resource, Default)] struct Live { roots: BTreeMap<u32, Root> }

pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Live>().init_resource::<Terrain>()
            .add_systems(Update, (synchronize, load, pose).chain().after(crate::receive)
                .before(crate::render_probe::capture));
    }
}

fn transform(nav: &openleague_core::Navigation, center: Point) -> Option<Transform> {
    let height = nav.ground(center)?;
    if !height.is_finite() { return None; }
    let units = crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT;
    let translation = Vec3::new(center.x, height, center.z) / units;
    translation.is_finite().then(|| Transform::from_translation(translation).with_scale(Vec3::splat(1. / units)))
}
fn synchronize(mut commands: Commands, state: Res<Match>, connection: Res<Connection>,
    clock: Res<crate::native_effect_clock::EffectClock>, terrain: Res<Terrain>, assets: Res<AssetServer>,
    mut live: ResMut<Live>, roots: Query<(), With<Pillar>>) {
    let desired = if connection.ready() && connection.session == state.trundle_e_visuals.session {
        state.trundle_e_visuals.placements(clock.now, clock.presentation_ready())
    } else { Vec::new() };
    let desired: BTreeMap<_, _> = desired.into_iter().filter_map(|p| {
        Some((p.identity.owner, (p, transform(terrain.0.as_ref()?, p.center)?)))
    }).collect();
    live.roots.retain(|owner, old| {
        let keep = desired.get(owner).is_some_and(|(p,_)| p.identity == old.identity && p.appearance == old.appearance)
            && roots.contains(old.entity);
        if !keep { if let Ok(mut entity) = commands.get_entity(old.entity) { entity.despawn(); } }
        keep
    });
    for (owner, (p, transform)) in desired {
        if live.roots.contains_key(&owner) { continue; }
        let entity = commands.spawn((Pillar { identity: p.identity, appearance: p.appearance },
            Name::new("OpenLeague::ReconstructedTrundlePillar"), transform, Visibility::Hidden,
            Pending(assets.load(ASSET)))).id();
        live.roots.insert(owner, Root { identity: p.identity, appearance: p.appearance, entity });
    }
}

fn binding(model: &Gltf, clips: &Assets<AnimationClip>) -> Option<(Handle<AnimationClip>, f32)> {
    let idle = model.named_animations.get(IDLE)?;
    if model.animations.get(IDLE_INDEX) != Some(idle) || model.scenes.is_empty() { return None; }
    let duration = clips.get(idle)?.duration();
    (duration.is_finite() && duration > 0.).then(|| (idle.clone(), duration))
}
fn load(mut commands: Commands, models: Res<Assets<Gltf>>, clips: Res<Assets<AnimationClip>>,
    mut graphs: ResMut<Assets<AnimationGraph>>, pending: Query<(Entity, &Pending), With<Pillar>>) {
    for (entity, pending) in &pending {
        let Some(model) = models.get(&pending.0) else { continue; };
        let Some((clip,_)) = binding(model, &clips) else { continue; };
        let (graph, indices) = AnimationGraph::from_clips(model.animations.clone());
        commands.entity(entity).insert((WorldAssetRoot(model.scenes[0].clone()), crate::actor_fow::Root,
            Ready { _model: pending.0.clone(), graph: graphs.add(graph), idle: indices[IDLE_INDEX], clip }))
            .remove::<Pending>();
    }
}
fn idle_phase(age: f64, duration: f32) -> Option<f32> {
    if !age.is_finite() || age < 0. || !duration.is_finite() || duration <= 0. { return None; }
    Some(age.rem_euclid(f64::from(duration)) as f32)
}
fn hold(player: &mut AnimationPlayer, index: AnimationNodeIndex, phase: f32, first: bool) -> bool {
    if first { player.play(index).repeat(); }
    let Some(active) = player.animation_mut(index) else { return false; };
    active.set_seek_time(phase); active.pause(); true
}
fn pose(mut commands: Commands, state: Res<Match>, clock: Res<crate::native_effect_clock::EffectClock>,
    models: Res<Assets<Gltf>>, clips: Res<Assets<AnimationClip>>, children: Query<&Children>,
    mut roots: Query<(Entity, &Pillar, &Ready, &mut Visibility)>,
    mut players: Query<(Entity, &mut AnimationPlayer, Option<&Bound>)>) {
    let placements = state.trundle_e_visuals.placements(clock.now, clock.presentation_ready());
    for (root, marker, ready, mut visibility) in &mut roots {
        *visibility = Visibility::Hidden;
        let Some(p) = placements.iter().find(|p| p.identity == marker.identity && p.appearance == marker.appearance) else { continue; };
        let Some(model) = models.get(&ready._model) else { continue; };
        let Some((clip, duration)) = binding(model, &clips) else { continue; };
        if clip != ready.clip { continue; }
        let Some(phase) = idle_phase(p.age, duration) else { continue; };
        let actual: Vec<_> = children.iter_descendants(root).filter(|e| players.contains(*e)).collect();
        if actual.len() != 1 { continue; }
        let Ok((entity, mut player, bound)) = players.get_mut(actual[0]) else { continue; };
        if hold(&mut player, ready.idle, phase, bound.is_none()) {
            if bound.is_none() { commands.entity(entity).insert((AnimationGraphHandle(ready.graph.clone()), Bound)); }
            *visibility = Visibility::Inherited;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture() -> (openleague_core::Simulation, u32, State) {
        let mut bytes = Vec::new();
        for _ in 0..400 { bytes.extend(0f32.to_le_bytes()); bytes.extend(0u16.to_le_bytes()); bytes.extend(0u32.to_le_bytes()); bytes.push(1); }
        let nav = openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#, &bytes).unwrap();
        let mut game = openleague_core::Simulation::new(nav).unwrap(); game.session=7; game.tick=100;
        let owner=game.join("trundle").unwrap(); let mut state=State::default(); state.reset(7); (game,owner,state)
    }
    fn packet(game: &openleague_core::Simulation, owner: u32) -> Snapshot {
        let mut s=game.snapshot(); s.trundle_e_pillars=vec![openleague_core::trundle_e::VisiblePillar {
            owner, starts:100, until:280, center:Point{x:225.,z:225.} }]; s
    }
    #[test]
    fn duplicates_and_epoch_keep_identity_age_and_stale_packets_cannot_replay() {
        let(game,owner,mut state)=fixture(); let mut s=packet(&game,owner); s.tick=130;
        assert!(state.observe_accepted(&s,5.).unwrap()); let first=state.placements(5.,true)[0];
        state.observe_accepted(&s,5.).unwrap(); assert_eq!(state.placements(5.,true)[0],first);
        state.begin_epoch(7,2); assert!(state.placements(5.,true).is_empty());
        state.observe_accepted(&s,5.1).unwrap(); let next=state.placements(5.1,true)[0];
        assert_eq!(first.identity,next.identity); assert_eq!(first.appearance,next.appearance); assert!(next.age>=first.age);
        let saved=state.clone(); s.tick=129; assert!(!state.observe_accepted(&s,5.2).unwrap()); assert_eq!(state,saved);
        s.session=8; s.tick=140; assert!(!state.observe_accepted(&s,5.2).unwrap()); assert_eq!(state,saved);
    }
    #[test]
    fn fog_batch_reappearance_expiry_terminal_and_session_have_bounded_lifetime() {
        let(mut game,owner,mut state)=fixture(); let mut s=packet(&game,owner); state.observe_accepted(&s,0.).unwrap(); let old=state.placements(0.,true)[0];
        s.tick=110; s.trundle_e_pillars.clear(); state.observe_accepted(&s,0.1).unwrap(); assert!(state.placements(0.1,true).is_empty());
        s=packet(&game,owner); s.tick=120; state.observe_accepted(&s,0.2).unwrap(); let again=state.placements(0.2,true)[0];
        assert_eq!(old.identity,again.identity); assert!(again.appearance>old.appearance && again.age>old.age);
        assert!(state.placements(6.2,true).is_empty()); s.tick=280; state.observe_accepted(&s,6.2).unwrap(); assert!(state.placements(6.2,true).is_empty());
        state.reset(9); game.session=9; s=packet(&game,owner); s.tick=110; state.observe_accepted(&s,7.).unwrap(); assert_eq!(state.placements(7.,true).len(),1);
        s.winner=Some(0); state.observe_accepted(&s,7.1).unwrap(); assert!(state.placements(7.1,true).is_empty());
        s.winner=None; state.observe_accepted(&s,7.2).unwrap(); assert!(state.placements(7.2,true).is_empty());
        state.reset(10); game.session=10; s=packet(&game,owner); s.roster.clear(); s.trundle_e_pillars.clear(); state.observe_accepted(&s,8.).unwrap(); assert!(state.anchors.is_empty());
    }
    #[test]
    fn immutable_center_bad_clock_future_expired_and_duplicate_projection_fail_closed() {
        let(game,owner,state)=fixture(); let base=packet(&game,owner);
        for failure in 0..5 {
            let mut state=state.clone(); let mut s=base.clone(); state.observe_accepted(&s,0.).unwrap();
            match failure {0=>s.trundle_e_pillars[0].center.x+=1.,1=>s.trundle_e_pillars[0].until+=1,
                2=>s.trundle_e_pillars.push(s.trundle_e_pillars[0].clone()),3=>s.trundle_e_pillars[0].center.x=f32::NAN,_=>{s.trundle_e_pillars[0].starts=101;s.trundle_e_pillars[0].until=281;}}
            assert!(state.observe_accepted(&s,0.1).is_err()); assert!(state.placements(0.1,true).is_empty());
        }
        let mut bad=state.clone(); assert!(bad.observe_accepted(&base,f64::NAN).is_err());
        let mut bad=state.clone(); bad.observe_accepted(&base,1.).unwrap(); assert!(bad.observe_accepted(&base,0.5).is_err());
        let mut expired=base; expired.tick=280; let mut late=state; late.observe_accepted(&expired,2.).unwrap(); assert!(late.placements(2.,true).is_empty());
    }
    #[test]
    fn late_loaded_clip_uses_current_effect_age_and_only_its_player_is_held() {
        let(game,owner,mut state)=fixture(); let mut s=packet(&game,owner); s.tick=160; state.observe_accepted(&s,10.).unwrap();
        assert!(state.placements(10.,false).is_empty()); let selected=state.placements(10.25,true)[0]; assert_eq!(selected.age,2.25);
        let index=AnimationNodeIndex::new(1); let other=AnimationNodeIndex::new(9);
        let mut player=AnimationPlayer::default(); player.play(other).set_seek_time(0.7);
        assert!(hold(&mut player,index,idle_phase(selected.age,0.5).unwrap(),true));
        assert_eq!(player.animation(index).unwrap().seek_time(),0.25); assert!(player.animation(index).unwrap().is_paused());
        assert_eq!(player.animation(other).unwrap().seek_time(),0.7); assert!(!player.animation(other).unwrap().is_paused());
        assert!(hold(&mut player,index,idle_phase(2.4,0.5).unwrap(),false)); assert!((player.animation(index).unwrap().seek_time()-0.4).abs()<1e-6);
        player.stop(index); assert!(!hold(&mut player,index,0.,false),"a previously bound player is never restarted after losing its clip");
        for duration in [0.,-1.,f32::NAN,f32::INFINITY] {assert!(idle_phase(2.,duration).is_none());}
        assert!(idle_phase(f64::INFINITY,1.).is_none());
    }
    #[test]
    fn loaded_graph_name_index_duration_and_native_ground_placement_are_required() {
        let mut clips=Assets::<AnimationClip>::default(); let death=clips.add(AnimationClip::default());
        let mut idle=AnimationClip::default(); idle.set_duration(0.020833334); let idle=clips.add(idle);
        let mut model=Gltf {scenes:vec![Handle::default()],named_scenes:default(),meshes:vec![],named_meshes:default(),materials:vec![],named_materials:default(),nodes:vec![],named_nodes:default(),skins:vec![],named_skins:default(),default_scene:None,animations:vec![death.clone(),idle.clone()],named_animations:[(IDLE.into(),idle.clone())].into_iter().collect(),source:None};
        assert!(binding(&model,&Assets::<AnimationClip>::default()).is_none(),"clip load can finish after the parent GLTF");
        assert_eq!(binding(&model,&clips).unwrap().0,idle);
        let(_graph,indices)=AnimationGraph::from_clips(model.animations.clone()); assert_eq!(indices.len(),2); assert_ne!(indices[0],indices[1]);
        let mut player=AnimationPlayer::default(); assert!(hold(&mut player,indices[IDLE_INDEX],0.01,true)); assert!(player.animation(indices[IDLE_INDEX]).unwrap().is_paused());
        clips.get_mut(&idle).unwrap().set_duration(0.); assert!(binding(&model,&clips).is_none()); clips.get_mut(&idle).unwrap().set_duration(0.020833334);
        model.animations.swap(0,1); assert!(binding(&model,&clips).is_none()); model.animations.swap(0,1);
        model.named_animations.clear(); assert!(binding(&model,&clips).is_none()); model.named_animations.insert(IDLE.into(),idle.clone());
        model.scenes.clear(); assert!(binding(&model,&clips).is_none());
        let(game,_,_)=fixture(); let t=transform(&game.navigation,Point{x:225.,z:225.}).unwrap();
        assert_eq!(t.translation,Vec3::new(11.25,0.,11.25)); assert_eq!(t.scale,Vec3::splat(0.05));
        assert!(transform(&game.navigation,Point{x:f32::NAN,z:225.}).is_none()); assert!(transform(&game.navigation,Point{x:-1.,z:225.}).is_none());
    }
}
