//! Order/Chaos Nexus IdleParticles bindings and collection lifetime, not a renderer.
//! Native Idle descriptors plus building OnNexusCrystalStart -> 876540 suffix
//! replacement. Server phase timing/late-join age are explicit local policy;
//! actual Troy children determine completion and draws.
use bevy::{prelude::*, asset::{AssetEvent, AssetId}, ecs::message::MessageCursor,
    gltf::GltfNode, mesh::skinning::SkinnedMesh,
    world_serialization::{WorldAsset, WorldAssetRoot}};
use std::collections::{HashMap, HashSet};
use openleague_core::nexus_phase::State as Phase;

pub const MODEL: &str = "OrderNexus";
pub const ASSET: &str = "structures/native_intact_ordernexus.glb";
pub const SLOTS: usize = 11;
pub const CHAOS_MODEL: &str = "ChaosNexus";
pub const CHAOS_ASSET: &str = "structures/native_intact_chaosnexus.glb";
pub fn supports_model(name: &str) -> bool { matches!(name, MODEL | CHAOS_MODEL) }

#[derive(Clone, Debug, serde::Deserialize)]
pub struct Descriptor {
    pub slot: u8, pub key: String, pub authored: String, pub resource: String,
    pub bone: String, pub node: usize, pub skin_index: usize,
}
#[derive(Clone, serde::Deserialize)]
struct NodeSpec { name: String, parent: Option<usize>, joint: bool }
#[derive(Clone, serde::Deserialize)]
struct Spec { schema: u32, model: String, asset: String, descriptors: Vec<Descriptor>, nodes: Vec<NodeSpec> }
impl Spec {
    fn original() -> Result<Self, String> { Self::for_model(MODEL) }
    fn for_model(model: &str) -> Result<Self, String> {
        let (text, asset, prefix) = match model {
            MODEL => (include_str!("../../../data/4.20/nexus_idle_particles.json"), ASSET, "Order"),
            CHAOS_MODEL => (include_str!("../../../data/4.20/chaosnexus_idle_particles.json"), CHAOS_ASSET, "Chaos"),
            _ => return Err("unsupported Nexus model".into()),
        };
        let s: Self = serde_json::from_str(text)
            .map_err(|e| e.to_string())?;
        if s.schema != 1 || s.model != model || s.asset != asset || s.descriptors.len() != SLOTS
            || s.nodes.len() != 22 || s.nodes.iter().filter(|n| n.joint).count() != 21 {
            return Err("Nexus idle profile shape changed".into());
        }
        let expected = [("Order_Nexus.troy", "center", 9),
            ("Order_Nexus_Crystal_Glow.troy", "gnome1", 8),
            ("Order_Nexus_Crystal_Glow.troy", "gnome2", 3),
            ("Order_Nexus_Crystal_Glow.troy", "gnome3", 4),
            ("Order_Nexus_Crystal_Glow.troy", "gnome4", 5),
            ("Order_Nexus_Crystal_Glow.troy", "gnome5", 6),
            ("Order_Nexus_Crystal_Glow.troy", "gnome6", 7),
            ("Order_Nexus_Base_Glow.troy", "base3", 18),
            ("Order_Nexus_Base_Glow.troy", "base4", 19),
            ("Order_Nexus_Base_Glow.troy", "base5", 20),
            ("Order_Nexus_Base_Glow.troy", "base6", 21)];
        let joints: Vec<_> = s.nodes.iter().enumerate().filter(|(_, n)| n.joint).map(|(i, _)| i).collect();
        for (i, (d, (resource, bone, node))) in s.descriptors.iter().zip(expected).enumerate() {
            let resource = resource.replacen("Order", prefix, 1);
            if d.slot as usize != i + 1 || d.resource != resource || d.bone != bone || d.node != node
                || d.authored != format!("{resource} {bone}") || s.nodes[node].name != bone
                || joints.get(d.skin_index) != Some(&node) {
                return Err("Nexus idle descriptor differs from the pinned original".into());
            }
        }
        Ok(s)
    }
}

/// Inserted by animation::ready, never inferred from a model request alone.
#[derive(Component)]
pub struct ModelReady;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CycleId { pub session: u64, pub source: u32, pub serial: u64 }
/// Exact renderer-owner boundary agreed with the Complex3 backend. A rebind
/// changes attachment_generation/actor, but preserves effect_id and age.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Owner {
    pub session: u64, pub actor: Entity, pub attachment_generation: u64, pub effect_id: u64,
}
#[derive(Clone, Debug)]
pub struct Request {
    pub owner: Owner, pub cycle: CycleId, pub descriptor: Descriptor, pub bone: Entity,
    /// Bevy world affine after animation/propagation. No native TRS conversion,
    /// scale adjustment, inverse bind multiplication or draw is claimed here.
    pub attachment_world: Mat4,
    pub started_at: f64, pub age_seconds: f64,
    pub native_idle_resource_flag: u32,
}
#[derive(Clone, Debug, Default)]
pub struct Frame {
    pub ordinal: u64, pub session: Option<u64>, pub requests: Vec<Request>,
    /// Exact former binding owners. Requests are also an authoritative full set:
    /// a consumer must retire an absent owner even if it missed this transition.
    pub retired: Vec<Owner>, pub error: Option<String>,
}
#[derive(Clone, Debug, PartialEq, Eq)]
struct Binding {
    root: Entity, model: AssetId<Gltf>, scene: AssetId<WorldAsset>,
    nodes: Vec<Entity>, bones: [Entity; SLOTS],
}
#[derive(Clone)]
struct Cycle {
    id: CycleId, started_at: f64, last_now: f64, completed: [bool; SLOTS],
    binding: Option<Binding>, binding_generation: u64,
}
#[derive(Clone, Copy)]
struct PhaseAnchor { phase: Phase, tick: u64, origin: f64, now: f64 }
#[derive(Default)]
struct SourceHost {
    session: Option<u64>, cycle: Option<Cycle>, next_cycle: u64, next_binding: u64,
    phase: Option<PhaseAnchor>,
    pub frame: Frame,
}
impl SourceHost {
    pub fn cycle(&self) -> Option<CycleId> { self.cycle.as_ref().map(|c| c.id) }
    pub fn created_at(&self) -> Option<f64> { self.cycle.as_ref().map(|c| c.started_at) }
    /// Only a completed real Troy resource may acknowledge this. No timer or
    /// renderer readiness implicitly completes a resource. Stale cycles fail.
    pub fn complete(&mut self, cycle: CycleId, slot: u8) -> Result<(), String> {
        let c = self.cycle.as_mut().filter(|c| c.id == cycle).ok_or("stale Nexus idle completion")?;
        let i = usize::from(slot).checked_sub(1).filter(|i| *i < SLOTS).ok_or("invalid Nexus slot")?;
        c.completed[i] = true;
        self.frame.requests.retain(|r| !(r.cycle == cycle && r.descriptor.slot == slot));
        Ok(())
    }
    pub fn retire(&mut self) {
        self.drop_binding(); self.cycle = None; self.frame.requests.clear();
    }
    fn owners(&self) -> Vec<Owner> {
        let Some(c) = &self.cycle else { return Vec::new() };
        let Some(b) = &c.binding else { return Vec::new() };
        (0..SLOTS).map(|i| Owner { session: c.id.session, actor: b.root,
            attachment_generation: c.binding_generation, effect_id: c.id.serial * SLOTS as u64 + i as u64 }).collect()
    }
    fn drop_binding(&mut self) {
        self.frame.retired.extend(self.owners());
        if let Some(c) = &mut self.cycle { c.binding = None; }
        self.frame.requests.clear();
    }
    fn begin_frame(&mut self, session: Option<u64>) -> Result<(), String> {
        let ordinal = self.frame.ordinal.checked_add(1).ok_or("Nexus idle frame ordinal exhausted")?;
        self.frame = Frame { ordinal, session, ..default() };
        if session != self.session { self.retire(); self.phase = None; self.session = session; }
        Ok(())
    }
    /// Authoritative phase, never a ModelReady/lifetime timer. The presentation
    /// anchor is local: initial age is the server tick difference; later samples
    /// can advance it but cannot rejuvenate it. EffectClock pause freezes the
    /// interpolation, and a new phase starts an independent age/identity.
    fn observe_phase(&mut self, phase: Phase, tick: u64, now: f64) -> Result<(), String> {
        phase.validate(tick).map_err(str::to_owned)?;
        if !now.is_finite() || now < 0. { return Err("invalid Nexus effect clock".into()); }
        let age=(tick-phase.started_tick()) as f64 / openleague_core::TICK_RATE as f64;
        let mut origin=now-age;
        if let Some(previous)=self.phase {
            if tick < previous.tick || now < previous.now { return Err("Nexus phase clock moved backwards".into()); }
            if phase == previous.phase { origin=origin.min(previous.origin); }
            else if matches!(previous.phase,Phase::On {..}) {
                return Err("Nexus authoritative phase cannot regress or restart".into());
            } else {
                // Native 876540 disables the old collection and creates `_on`.
                // Retiring our bounded private draws is a local adaptation;
                // native particle linger/collection cleanup is not ported here.
                self.retire();
            }
        }
        self.phase=Some(PhaseAnchor {phase,tick,origin,now});
        Ok(())
    }
    fn bind(&mut self, session: u64, source: u32, binding: Binding, now: f64) -> Result<(), String> {
        if !now.is_finite() || now < 0. { return Err("invalid Nexus effect clock".into()) }
        let phase=self.phase.ok_or("Nexus needs an authoritative phase before binding")?;
        if self.session != Some(session) || now < phase.now { return Err("Nexus phase session/clock differs from binding".into()); }
        if self.cycle.as_ref().is_some_and(|c| c.id.session != session || c.id.source != source) { self.retire(); }
        if self.cycle.is_none() {
            let serial = self.next_cycle.checked_add(1).filter(|s| s.checked_mul(SLOTS as u64)
                .and_then(|v| v.checked_add(SLOTS as u64 - 1)).is_some()).ok_or("Nexus cycle identity exhausted")?;
            self.next_cycle = serial;
            self.cycle = Some(Cycle { id: CycleId { session, source, serial }, started_at: phase.origin, last_now: now,
                completed: [false; SLOTS], binding: None, binding_generation: 0 });
        }
        let c = self.cycle.as_ref().unwrap();
        if now < c.last_now { return Err("Nexus effect clock moved backwards".into()) }
        if c.binding.as_ref() != Some(&binding) {
            let generation = self.next_binding.checked_add(1).ok_or("Nexus attachment generation exhausted")?;
            self.drop_binding(); self.next_binding = generation;
            let c = self.cycle.as_mut().unwrap(); c.binding_generation = generation; c.binding = Some(binding);
        }
        let c=self.cycle.as_mut().unwrap();c.last_now = now;c.started_at=c.started_at.min(phase.origin);
        Ok(())
    }
    fn publish(&mut self, spec: &Spec, matrices: [Mat4; SLOTS]) {
        let c = self.cycle.as_ref().unwrap(); let b = c.binding.as_ref().unwrap();
        let phase=self.phase.expect("bind requires phase").phase;
        self.frame.requests = spec.descriptors.iter().enumerate().filter(|(i, _)| !c.completed[*i]).map(|(i, d)| {
          let mut descriptor=d.clone();
          descriptor.resource=phase.resource(&d.resource).expect("validated original descriptor");
          Request {
            owner: Owner { session: c.id.session, actor: b.root, attachment_generation: c.binding_generation,
                effect_id: c.id.serial * SLOTS as u64 + i as u64 }, cycle: c.id, descriptor, bone: b.bones[i],
            attachment_world: matrices[i], started_at: c.started_at, age_seconds: c.last_now - c.started_at,
            native_idle_resource_flag: 0x10,
        }}).collect();
    }
}

#[derive(Resource)]
struct Profile {
    spec: Spec, model: Handle<Gltf>, invalidated: bool,
    models: MessageCursor<AssetEvent<Gltf>>, nodes: MessageCursor<AssetEvent<GltfNode>>,
    scenes: MessageCursor<AssetEvent<WorldAsset>>,
}
fn changed<A: bevy::asset::Asset>(world: &World, cursor: &mut MessageCursor<AssetEvent<A>>, ids: &[AssetId<A>]) -> bool {
    let Some(events) = world.get_resource::<Messages<AssetEvent<A>>>() else { return false };
    cursor.read(events).any(|event| match event {
        AssetEvent::Modified { id } | AssetEvent::Removed { id } => ids.contains(id), _ => false,
    })
}
impl Profile {
    fn poll(&mut self, world: &World) {
        let model = world.get_resource::<Assets<Gltf>>().and_then(|a| a.get(&self.model));
        let nodes = model.map(|m| m.nodes.iter().map(Handle::id).collect::<Vec<_>>()).unwrap_or_default();
        let scenes = model.map(|m| m.scenes.iter().map(Handle::id).collect::<Vec<_>>()).unwrap_or_default();
        self.invalidated |= changed(world, &mut self.models, &[self.model.id()]);
        self.invalidated |= changed(world, &mut self.nodes, &nodes);
        self.invalidated |= changed(world, &mut self.scenes, &scenes);
    }
}

fn descendants(world: &World, root: Entity) -> Result<Vec<Entity>, String> {
    let mut result = Vec::new(); let mut seen = HashSet::new(); let mut stack = vec![root];
    while let Some(parent) = stack.pop() {
        if let Some(children) = world.get::<Children>(parent) {
            for child in children.iter() {
                if !seen.insert(child) || child == root || seen.len() > 128
                    || world.get::<ChildOf>(child).map(ChildOf::parent) != Some(parent) {
                    return Err("invalid Nexus scene ancestry".into());
                }
                result.push(child); stack.push(child);
            }
        }
    }
    Ok(result)
}
fn resolve_nodes(world: &World, root: Entity, spec: &Spec) -> Result<(Vec<Entity>, [Entity; SLOTS]), String> {
    let descendants = descendants(world, root)?;
    let mut names: HashMap<&str, Vec<Entity>> = HashMap::new();
    for &e in &descendants { if let Some(name) = world.get::<Name>(e) { names.entry(name.as_str()).or_default().push(e); } }
    let nodes: Vec<Entity> = spec.nodes.iter().map(|n| {
        match names.get(n.name.as_str()).map(Vec::as_slice) {
            Some([e]) => Ok(*e), _ => Err(format!("Nexus node absent or ambiguous: {}", n.name)),
        }
    }).collect::<Result<_, _>>()?;
    for (i, n) in spec.nodes.iter().enumerate() {
        if let Some(parent) = n.parent {
            if parent >= nodes.len() || world.get::<ChildOf>(nodes[i]).map(ChildOf::parent) != Some(nodes[parent]) {
                return Err("Nexus original bone ancestry changed".into());
            }
        }
    }
    let expected: Vec<Entity> = spec.nodes.iter().enumerate().filter(|(_, n)| n.joint).map(|(i, _)| nodes[i]).collect();
    let skins: Vec<_> = descendants.iter().filter_map(|e| world.get::<SkinnedMesh>(*e)).collect();
    if skins.len() != 1 || skins[0].joints != expected { return Err("Nexus skin joint identity/order differs from source".into()) }
    let bones: [Entity; SLOTS] = spec.descriptors.iter().map(|d| nodes[d.node]).collect::<Vec<_>>().try_into().unwrap();
    Ok((nodes, bones))
}

fn collect(world: &World, profile: &Profile, root: Entity, source: u32) -> Result<Option<(Binding, [Mat4; SLOTS])>, String> {
    let Some(playback) = world.get::<crate::animation::Playback>(root) else { return Ok(None) };
    if playback.network_id() != source || playback.model_name() != profile.spec.model || playback.model_asset_id() != profile.model.id()
        || world.get::<crate::actor_fow::Root>(root).is_none() || world.get::<ChildOf>(root).is_some() {
        return Err("Nexus root/model identity changed".into());
    }
    if world.get::<ModelReady>(root).is_none() { return Ok(None) }
    let Some(model) = world.get_resource::<Assets<Gltf>>().and_then(|a| a.get(&profile.model)) else { return Ok(None) };
    let Some(scene) = model.scenes.first() else { return Err("Nexus source scene absent".into()) };
    if world.get::<WorldAssetRoot>(root).map(|s| s.0.id()) != Some(scene.id()) { return Err("Nexus loaded scene differs".into()) }
    let Some(node_assets) = world.get_resource::<Assets<GltfNode>>() else { return Ok(None) };
    if model.nodes.len() != profile.spec.nodes.len() { return Err("Nexus source node count changed".into()) }
    for (i, (handle, spec)) in model.nodes.iter().zip(&profile.spec.nodes).enumerate() {
        let Some(node) = node_assets.get(handle) else { return Ok(None) };
        if node.index != i || node.name != spec.name { return Err("Nexus source node identity changed".into()) }
    }
    let (nodes, bones) = resolve_nodes(world, root, &profile.spec)?;
    let mut matrices = [Mat4::IDENTITY; SLOTS];
    for (out, bone) in matrices.iter_mut().zip(bones) {
        *out = world.get::<GlobalTransform>(bone).ok_or("Nexus bone global missing after propagation")?.to_matrix();
        if !out.is_finite() { return Err("Nexus bone global is nonfinite".into()) }
    }
    Ok(Some((Binding { root, model: profile.model.id(), scene: scene.id(), nodes, bones }, matrices)))
}

/// After animation and GlobalTransform propagation; renderer consumes Frame in
/// the same PostUpdate after this set. This never changes a source entity.
#[derive(SystemSet, Clone, Debug, PartialEq, Eq, Hash)]
pub struct Published;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Host>().add_systems(Startup, setup)
            .add_systems(PostUpdate, synchronize.in_set(Published)
                .after(bevy::transform::TransformSystems::Propagate).after(bevy::asset::AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds));
    }
}
/// Per-source lifecycle engines share monotone allocation counters and the
/// authoritative phase anchor. Hidden sources retain age; their bindings do not.
struct SourceEntry { model: String, state: SourceHost }
#[derive(Resource, Default)]
pub struct Host {
    timeline: SourceHost, sources: HashMap<u32, SourceEntry>, next_cycle: u64, next_binding: u64,
    pub frame: Frame,
    /// Per-source failures are visible diagnostics and do not invalidate siblings.
    pub issues: Vec<(u32, String)>,
}
impl Host {
    pub fn complete(&mut self, cycle: CycleId, slot: u8) -> Result<(), String> {
        self.sources.get_mut(&cycle.source).ok_or("stale Nexus idle completion")?.state.complete(cycle,slot)?;
        self.frame.requests.retain(|r| !(r.cycle==cycle && r.descriptor.slot==slot));
        Ok(())
    }
    fn begin_frame(&mut self, session: Option<u64>) -> Result<(), String> {
        let ordinal=self.frame.ordinal.checked_add(1).ok_or("Nexus idle frame ordinal exhausted")?;
        self.frame=Frame {ordinal,session,..default()};self.issues.clear();
        if self.timeline.session!=session {
            for entry in self.sources.values_mut() {entry.state.retire();self.frame.retired.append(&mut entry.state.frame.retired);}
            self.sources.clear();
        }
        self.timeline.begin_frame(session)?;
        for entry in self.sources.values_mut() {entry.state.begin_frame(session)?;}
        Ok(())
    }
    fn observe_phase(&mut self, phase: Phase, tick: u64, now: f64) -> Result<(), String> {
        self.timeline.observe_phase(phase,tick,now)?;
        for entry in self.sources.values_mut() {
            entry.state.observe_phase(phase,tick,now)?;
            if let Some(c)=&mut entry.state.cycle {c.last_now=now;}
        }
        Ok(())
    }
    fn source(&mut self, source: u32, model: &str) -> Result<&mut SourceEntry,String> {
        if !supports_model(model) {return Err("unsupported Nexus source model".into());}
        if self.sources.get(&source).is_some_and(|e|e.model!=model) {
            return Err("Nexus source identity changed profile".into());
        }
        if !self.sources.contains_key(&source) {
            // One actor per native building definition in the bounded Map10 profile.
            let old:Vec<_>=self.sources.iter().filter(|(_,e)|e.model==model).map(|(id,_)|*id).collect();
            for id in old {self.retire_source(id);}
            if self.sources.len()>=2 {return Err("Nexus source capacity exceeded".into());}
            let state=SourceHost {session:self.timeline.session,phase:self.timeline.phase,..default()};
            self.sources.insert(source,SourceEntry {model:model.into(),state});
        }
        Ok(self.sources.get_mut(&source).unwrap())
    }
    fn retire_source(&mut self, source: u32) {
        if let Some(mut e)=self.sources.remove(&source) {e.state.retire();self.frame.retired.append(&mut e.state.frame.retired);}
        self.frame.requests.retain(|r|r.cycle.source!=source);
    }
    fn bind_source(&mut self, session:u64, source:u32, spec:&Spec, binding:Binding, matrices:[Mat4;SLOTS],now:f64)->Result<(),String> {
        let next_cycle=self.next_cycle;let next_binding=self.next_binding;
        let entry=self.source(source,&spec.model)?;
        entry.state.next_cycle=next_cycle;entry.state.next_binding=next_binding;
        let result=entry.state.bind(session,source,binding,now);
        let allocated_cycle=entry.state.next_cycle;let allocated_binding=entry.state.next_binding;
        if result.is_ok() {entry.state.publish(spec,matrices);}
        // Even a later failure must not reissue an identity already allocated.
        self.next_cycle=allocated_cycle;self.next_binding=allocated_binding;
        result
    }
    fn finish_frame(&mut self) {
        let mut ids:Vec<_>=self.sources.keys().copied().collect();ids.sort_unstable();
        self.frame.requests.clear();
        for id in ids {let e=self.sources.get_mut(&id).unwrap();
            self.frame.retired.append(&mut e.state.frame.retired);
            self.frame.requests.extend(e.state.frame.requests.iter().cloned());}
    }
    fn drop_all_bindings(&mut self) {for e in self.sources.values_mut(){e.state.drop_binding();}self.finish_frame();}
}
#[derive(Resource)]
struct Profiles(Vec<Profile>);
fn setup(mut commands: Commands, assets: Res<AssetServer>) {
    let result=(||->Result<Profiles,String>{
        let mut profiles=Vec::new();
        for model in [MODEL,CHAOS_MODEL] {
            let spec=Spec::for_model(model)?;let handle=assets.load(spec.asset.clone());
            profiles.push(Profile {spec,model:handle,invalidated:false,models:default(),nodes:default(),scenes:default()});
        }
        Ok(Profiles(profiles))
    })();
    match result {Ok(p)=>{commands.insert_resource(p);},Err(error)=>error!("Nexus IdleParticles profile: {error}")}
}
pub fn synchronize(world: &mut World) {
    let mut host=world.remove_resource::<Host>().unwrap_or_default();
    let previous=(host.frame.error.clone(),host.issues.clone());
    let session=world.get_resource::<crate::Match>().and_then(|m|m.snapshot.as_ref()).map(|s|s.session);
    let result=(||->Result<(),String>{
        host.begin_frame(session)?;
        let Some(session)=session else {return Ok(());};
        let state=world.resource::<crate::Match>();let snapshot=state.snapshot.as_ref().unwrap();
        let clock=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("Nexus effect clock absent")?;
        if clock.diagnostic()["failed"].as_bool()!=Some(false) {return Err("Nexus effect clock failed".into());}
        let phase=snapshot.map10.as_ref().ok_or("Nexus phase requires Map10 server state")?.nexus_crystal;
        host.observe_phase(phase,snapshot.tick,clock.now)?;
        let now=clock.now;
        let mut profiles=world.remove_resource::<Profiles>().ok_or("Nexus idle profiles unavailable")?;
        for profile in &mut profiles.0 {
            profile.poll(world);
            if let Err(error)=produce(world,profile,&mut host,session,now) {
                let ids:Vec<_>=host.sources.iter().filter(|(_,e)|e.model==profile.spec.model).map(|(id,_)|*id).collect();
                for id in ids {host.sources.get_mut(&id).unwrap().state.drop_binding();host.issues.push((id,error.clone()));}
                if !host.issues.iter().any(|(_,e)|e==&error) {host.issues.push((0,format!("{}: {error}",profile.spec.model)));}
            }
        }
        world.insert_resource(profiles);host.finish_frame();Ok(())
    })();
    if let Err(error)=result {host.drop_all_bindings();host.frame.error=Some(error);}
    if previous!=(host.frame.error.clone(),host.issues.clone()) {
        if let Some(e)=&host.frame.error {warn!("Nexus IdleParticles: {e}");}
        for (source,e) in &host.issues {warn!("Nexus IdleParticles source {source}: {e}");}
    }
    world.insert_resource(host);
}
fn produce(world:&World,profile:&Profile,host:&mut Host,session:u64,now:f64)->Result<(),String> {
    let state=world.resource::<crate::Match>();let snapshot=state.snapshot.as_ref().unwrap();
    let matches:Vec<_>=snapshot.units.iter().filter(|u|u.definition==profile.spec.model).collect();
    if matches.len()>1 {return Err("multiple actors for one Nexus profile".into());}
    let Some(unit)=matches.first() else {
        let ids:Vec<_>=host.sources.iter().filter(|(_,e)|e.model==profile.spec.model).map(|(id,_)|*id).collect();
        for id in ids {
            if snapshot.units.iter().any(|u|u.id==id) {host.retire_source(id);}
            else {host.sources.get_mut(&id).unwrap().state.drop_binding();}
        }
        return Ok(());
    };
    host.source(unit.id,&profile.spec.model)?;
    if profile.invalidated {return Err("Nexus assets changed: restart with verified profile".into());}
    if unit.kind!=openleague_core::world::Kind::Nexus {return Err("Nexus profile has a non-Nexus actor kind".into());}
    let Some(&root)=state.visuals.get(&unit.id) else {host.sources.get_mut(&unit.id).unwrap().state.drop_binding();return Ok(());};
    if world.get::<crate::animation::Playback>(root).is_some_and(|p|p.model_name()!=profile.spec.model) {
        host.retire_source(unit.id);return Ok(());
    }
    let Some((binding,matrices))=collect(world,profile,root,unit.id)? else {
        host.sources.get_mut(&unit.id).unwrap().state.drop_binding();return Ok(());
    };
    host.bind_source(session,unit.id,&profile.spec,binding,matrices,now)
}

#[cfg(test)]
#[path = "nexus_idle_particles_tests.rs"]
mod tests;
