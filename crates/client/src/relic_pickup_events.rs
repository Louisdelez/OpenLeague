//! Ordinary pickup event and actor ownership adapter. No GPU or native timing policy.
//! The current local snapshot carries only the most recent pickup, not an event journal.
use bevy::prelude::*;
use std::collections::BTreeMap;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Key { pub session: u64, pub pickup_tick: u64, pub picker: u32 }

/// Public accepted connection metadata. Epoch changes also establish a fresh baseline.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Identity { session: u64, player: u32, epoch: Option<u64> }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Binding { pub root: Entity, pub model: bevy::asset::AssetId<Gltf> }

/// Original actor orientation arithmetic, supplied by the propagated render actor.
/// World-to-native unit conversion is the existing local /20 scene adapter.
#[derive(Clone, Copy, Debug)]
pub struct OwnerFrame {
    pub binding: Binding,
    pub native_position: [u32; 3],
    pub native_matrix: [u32; 16],
}

#[derive(Clone, Debug)]
pub struct Request {
    pub key: Key,
    /// First authoritative snapshot at which this new event was observed.
    pub observed_snapshot_tick: u64,
    pub owner: Option<OwnerFrame>,
    binding: Option<Binding>,
    model_name: Option<String>,
}

#[derive(Clone, Debug)]
pub struct Retirement { pub key: Key, pub reason: &'static str }

/// Requests remain pending until the downstream lifetime owner calls complete().
/// No synthetic expiration interval is used; owner/session loss retires the request.
#[derive(Resource, Default)]
pub struct Host {
    identity: Option<Identity>,
    baseline: Option<(u64, Option<Key>)>,
    last_event: Option<Key>,
    pub requests: BTreeMap<Key, Request>,
    pub retired: Vec<Retirement>,
    pub issues: Vec<(Option<Key>, String)>,
}
impl Host {
    pub fn complete(&mut self, key: Key) -> Result<(), &'static str> {
        self.requests.remove(&key).ok_or("stale pickup completion")?;
        self.retired.push(Retirement { key, reason: "completed" });
        Ok(())
    }
    fn retire(&mut self, key: Key, reason: &'static str) {
        if self.requests.remove(&key).is_some() { self.retired.push(Retirement { key, reason }); }
    }
    fn replace_identity(&mut self, identity: Option<Identity>) {
        if self.identity == identity { return; }
        let keys: Vec<_> = self.requests.keys().copied().collect();
        for key in keys { self.retire(key, "accepted connection identity changed"); }
        self.identity = identity;
        self.baseline = None;
        self.last_event = None;
    }
    fn observe(&mut self, identity: Option<Identity>, snapshot: Option<(u64, u64, Option<Key>)>) {
        self.retired.clear();
        self.issues.clear();
        self.replace_identity(identity);
        let (Some(identity), Some((session, tick, event))) = (identity, snapshot) else {
            self.baseline = None;
            return;
        };
        if session != identity.session {
            self.issues.push((None, "pickup snapshot does not match accepted connection session".into()));
            return;
        }
        if event.is_some_and(|key|key.session!=session || key.pickup_tick>tick) {
            self.issues.push((event, "pickup event session/tick is invalid".into()));
            return;
        }
        let Some((previous_tick, previous)) = self.baseline else {
            // Joining/rejoining observes current presentation state without replaying history.
            self.baseline = Some((tick, event));
            self.last_event = event;
            return;
        };
        if tick < previous_tick {
            self.issues.push((event, "pickup snapshot tick regressed".into()));
            return;
        }
        if let Some(key) = event {
            if previous != Some(key) {
                // This bound derives from the last accepted snapshot, not an invented TTL.
                // Equal ticks permit a newly exposed event from that same authoritative tick.
                if key.pickup_tick >= previous_tick
                    && self.last_event.is_none_or(|p| key.pickup_tick > p.pickup_tick) {
                    self.requests.entry(key).or_insert(Request {
                        key, observed_snapshot_tick: tick, owner: None, binding: None, model_name: None,
                    });
                    self.last_event = Some(key);
                } else {
                    self.issues.push((Some(key), "historical or conflicting pickup event ignored".into()));
                }
            }
        }
        self.baseline = Some((tick, event));
    }
}

fn source(world: &World, picker: u32) -> Result<Option<(OwnerFrame, String)>, &'static str> {
    let state = world.get_resource::<crate::Match>().ok_or("pickup Match resource absent")?;
    let snapshot = state.snapshot.as_ref().ok_or("pickup snapshot absent")?;
    let mut actors = snapshot.players.iter().filter(|p| p.id == picker);
    let Some(actor) = actors.next() else { return Ok(None); };
    if actors.next().is_some() { return Err("pickup actor identity is ambiguous"); }
    let Some(&root) = state.visuals.get(&picker) else { return Ok(None); };
    let Some(playback) = world.get::<crate::animation::Playback>(root) else { return Ok(None); };
    if playback.network_id() != picker || !playback.model_name().eq_ignore_ascii_case(&actor.champion)
        || world.get::<ChildOf>(root).is_some() || world.get::<crate::actor_fow::Root>(root).is_none() {
        return Err("pickup actor root/model identity differs from accepted snapshot");
    }
    let Some(global) = world.get::<GlobalTransform>(root) else { return Ok(None); };
    let matrix = Mat4::from_scale(Vec3::splat(crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT)) * global.to_matrix();
    if !matrix.is_finite() { return Err("pickup actor transform is nonfinite"); }
    let native_position = matrix.w_axis.truncate().to_array().map(f32::to_bits);
    let orientation = openleague_core::native_actor_effect_owner::orientation(matrix.to_cols_array())?;
    let binding = Binding { root, model: playback.model_asset_id() };
    Ok(Some((OwnerFrame { binding, native_position, native_matrix: orientation.map(f32::to_bits) }, actor.champion.clone())))
}

/// Exclusive system keeps accepted state, root identity and propagated pose in one read.
pub fn synchronize(world: &mut World) {
    let mut host = world.remove_resource::<Host>().unwrap_or_default();
    let identity = world.get_resource::<crate::Connection>()
        .and_then(crate::Connection::inventory_input_identity)
        .map(|(session, player, epoch)| Identity { session, player, epoch });
    let observation = world.get_resource::<crate::Match>().and_then(|m| m.snapshot.as_ref()).and_then(|s| {
        let map = s.map10.as_ref()?;
        let event = match (map.relic_pickup_tick, map.relic_last_picker) {
            (Some(pickup_tick), Some(picker)) => Some(Key { session: s.session, pickup_tick, picker }),
            _ => None,
        };
        Some((s.session, s.tick, event))
    });
    host.observe(identity, observation);
    // A mismatched snapshot never refreshes owners from the wrong session.
    let matched = identity.is_some_and(|id| observation.is_some_and(|s| s.0 == id.session));
    let keys: Vec<_> = host.requests.keys().copied().collect();
    for key in keys {
        let result = if matched { source(world, key.picker) } else { Ok(None) };
        match result {
            Ok(Some((owner, model_name))) => {
                let request = host.requests.get_mut(&key).unwrap();
                if request.binding.is_some_and(|b| b != owner.binding)
                    || request.model_name.as_ref().is_some_and(|name| name != &model_name) {
                    host.retire(key, "pickup actor binding replaced");
                } else {
                    request.binding = Some(owner.binding);
                    request.model_name = Some(model_name);
                    request.owner = Some(owner);
                }
            }
            Ok(None) => {
                let request = host.requests.get_mut(&key).unwrap();
                request.owner = None;
                if request.binding.is_some() { host.retire(key, "pickup actor owner lost"); }
            }
            Err(error) => {
                host.issues.push((Some(key), error.into()));
                host.retire(key, "pickup actor owner rejected");
            }
        }
    }
    world.insert_resource(host);
}

#[derive(SystemSet, Clone, Debug, PartialEq, Eq, Hash)]
pub struct Published;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Host>().add_systems(PostUpdate, synchronize.in_set(Published)
            .after(bevy::transform::TransformSystems::Propagate)
            .after(bevy::asset::AssetEventSystems));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn identity(epoch: u64) -> Identity { Identity { session: 7, player: 1, epoch: Some(epoch) } }
    fn key(tick: u64, picker: u32) -> Key { Key { session: 7, pickup_tick: tick, picker } }
    #[test]
    fn new_connection_baselines_duplicates_do_not_reissue_and_rejoin_does_not_replay() {
        let mut h = Host::default();
        h.observe(Some(identity(1)), Some((7, 100, Some(key(99, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(1)), Some((7, 101, Some(key(101, 2)))));
        assert_eq!(h.requests.len(), 1);
        h.complete(key(101, 2)).unwrap();
        h.observe(Some(identity(1)), Some((7, 102, Some(key(101, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(1)), Some((7, 102, None)));
        h.observe(Some(identity(1)), Some((7, 102, Some(key(101, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(2)), Some((7, 103, Some(key(101, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(2)), Some((7, 104, Some(key(104, 2)))));
        assert_eq!(h.requests.len(), 1);
        h.observe(None, None);
        assert!(h.requests.is_empty());
        assert_eq!(h.retired.len(), 1);
        assert!(h.complete(key(104, 2)).is_err());
    }
    #[test]
    fn mismatched_regressed_historical_and_same_tick_conflicts_are_not_new_pickups() {
        let mut h = Host::default();
        h.observe(Some(identity(1)), Some((8, 100, None)));
        assert!(h.baseline.is_none());
        h.observe(Some(identity(1)), Some((7, 100, None)));
        h.observe(Some(identity(1)), Some((7, 99, Some(key(99, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(1)), Some((7, 101, Some(key(90, 2)))));
        assert!(h.requests.is_empty());
        h.observe(Some(identity(1)), Some((7, 102, Some(key(102, 2)))));
        h.observe(Some(identity(1)), Some((7, 102, Some(key(102, 3)))));
        assert_eq!(h.requests.len(), 1);
    }
    #[test]
    fn native_owner_pose_uses_propagated_actor_and_rejects_replaced_entity_or_model() {
        let mut world = World::new();
        let mut cells=Vec::new();
        for _ in 0..16 { cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes());
            cells.extend(0u32.to_le_bytes()); cells.push(1); }
        let navigation=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,&cells).unwrap();
        let mut simulation = openleague_core::Simulation::new(navigation).unwrap();
        let picker = simulation.join("garen").unwrap();
        let mut state = crate::Match::default();
        state.snapshot = Some(simulation.snapshot());
        let model = Handle::<Gltf>::default();
        let pose = Transform::from_translation(Vec3::new(3., 4., 5.)).with_scale(Vec3::splat(0.05));
        let root = world.spawn((crate::actor_fow::Root, crate::animation::material_test_playback(picker, model),
            GlobalTransform::from(pose))).id();
        state.visuals.insert(picker, root);
        world.insert_resource(state);
        let (owner, _) = source(&world, picker).unwrap().unwrap();
        assert_eq!(owner.native_position.map(f32::from_bits), [60., 80., 100.]);
        assert_eq!(owner.native_matrix[12..16].iter().map(|v|f32::from_bits(*v)).collect::<Vec<_>>(), vec![0.,0.,0.,1.]);
        world.entity_mut(root).insert(crate::animation::material_test_playback(picker + 1, Handle::default()));
        assert!(source(&world, picker).is_err());
        world.despawn(root);
        assert!(source(&world, picker).unwrap().is_none());
    }
}

/// Controlled accepted request/owner input for numeric host transactions.
/// Does not qualify authentication, network receipt or historical triggering.
#[cfg(test)]pub(crate) fn owned_order_fixture(key:Key,owner:OwnerFrame)->Host {let mut host=Host::default();host.requests.insert(key,Request {key,observed_snapshot_tick:key.pickup_tick,owner:Some(owner),binding:Some(owner.binding),model_name:Some("controlled accepted numeric owner".into())});host}
