//! Private draw ownership for a bounded Complex3 backend. No automatic particle
//! creation: the upstream idle frame admits an owner; a real Complex producer must
//! supply each draw packet. Retirement never completes an upstream Troy resource.
use bevy::{asset::AssetId, camera::primitives::MeshAabb, prelude::*};
use std::collections::{HashMap, HashSet};
pub use crate::nexus_idle_particles::Owner;
use crate::{nexus_idle_particles::Frame, nexus_complex_mesh::{Geometry, Group, NativeWorld},
    nexus_complex_material::{Bindings, Inputs, NexusMaterial}};

#[derive(Clone, Debug)]
pub struct DrawPacket { pub group: Group, pub world: NativeWorld, pub material: Inputs }
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Ticket {
    pub owner: Owner, pub ordinal: u64, pub group: Group, pub draw: Entity,
    pub mesh: AssetId<Mesh>, pub material: AssetId<NexusMaterial>, pub images: [AssetId<Image>; 4],
}
#[derive(Component, Clone, Debug)]
pub struct OwnedDraw(pub Ticket);
struct Draw { ticket: Ticket, mesh: Handle<Mesh>, material: Handle<NexusMaterial> }
struct Entry { ordinal: u64, draws: Vec<Draw> }

#[derive(Resource)]
pub struct Backend {
    capacity: usize, session: Option<u64>, ordinal: u64, admitted: HashSet<Owner>,
    entries: HashMap<Owner, Entry>, geometry: Geometry, sparkle_geometry: Geometry,
}
impl Backend {
    pub fn new(capacity: usize) -> Result<Self, &'static str> {
        if capacity == 0 || capacity > 32 { return Err("Nexus backend owner capacity outside 1..32"); }
        Ok(Self { capacity, session: None, ordinal: 0, admitted: HashSet::new(),
            entries: HashMap::new(), geometry: Geometry::original(), sparkle_geometry:Geometry::sparkle() })
    }
    pub fn owner_count(&self) -> usize { self.entries.len() }
    pub fn tickets(&self) -> Vec<Ticket> {
        self.entries.values().flat_map(|e| e.draws.iter().map(|d| d.ticket.clone())).collect()
    }
    fn hide(&self, world: &mut World, owner: Owner) {
        if let Some(entry) = self.entries.get(&owner) {
            for draw in &entry.draws {
                if let Some(mut assets) = world.get_resource_mut::<Assets<NexusMaterial>>() {
                    if let Some(mut material) = assets.get_mut(&draw.material) { material.set_ready(false); }
                }
                if let Some(mut v) = world.get_mut::<Visibility>(draw.ticket.draw) { *v = Visibility::Hidden; }
            }
        }
    }
    pub fn retire(&mut self, world: &mut World, owner: Owner) {
        let Some(entry) = self.entries.remove(&owner) else { return };
        for draw in entry.draws {
            // These entities are created and exclusively owned here. Actor/bone,
            // original mesh/material/skin and other IdleParticles are untouched.
            if world.get_entity(draw.ticket.draw).is_ok() { world.despawn(draw.ticket.draw); }
            if let Some(mut assets) = world.get_resource_mut::<Assets<Mesh>>() { assets.remove(draw.mesh.id()); }
            if let Some(mut assets) = world.get_resource_mut::<Assets<NexusMaterial>>() { assets.remove(draw.material.id()); }
        }
    }
    pub fn clear(&mut self, world: &mut World) {
        for owner in self.entries.keys().copied().collect::<Vec<_>>() { self.retire(world, owner); }
        self.admitted.clear();
    }

    /// Consume the entire authoritative upstream set each frame, including empty.
    /// A binding loss/reload/session change cannot leave an infinite old crystal.
    /// Every admitted draw is hidden until replace_frame + exact CPU ownership admission.
    pub fn reconcile(&mut self, world: &mut World, frame: &Frame) -> Result<bool, &'static str> {
        if self.session == frame.session && frame.ordinal <= self.ordinal { return Ok(false); }
        if frame.ordinal == 0 { return Err("Nexus idle ordinal is zero"); }
        if self.session != frame.session { self.clear(world); self.session = frame.session; self.ordinal = 0; }
        self.ordinal = frame.ordinal;
        if frame.error.is_some() { self.clear(world); return Err("Nexus idle producer unavailable"); }
        let mut next = HashSet::new();
        for r in &frame.requests {
            if r.descriptor.slot != 1 { continue; }
            if frame.session != Some(r.owner.session) || r.owner.session == 0
                || r.owner.attachment_generation == 0 || r.owner.effect_id == 0
                || !matches!(r.descriptor.resource.as_str(),"Order_Nexus.troy"|"Order_Nexus_on.troy"|"Chaos_Nexus.troy"|"Chaos_Nexus_on.troy") || r.descriptor.bone != "center"
                || r.native_idle_resource_flag != 0x10 || world.get_entity(r.owner.actor).is_err()
                || world.get_entity(r.bone).is_err() || !r.attachment_world.is_finite()
                || !r.age_seconds.is_finite() || r.age_seconds < 0. || !next.insert(r.owner)
            { self.clear(world); return Err("Nexus idle owner/binding is not the supported request"); }
        }
        if next.len() > self.capacity { self.clear(world); return Err("Nexus owner capacity exceeded"); }
        for owner in self.entries.keys().copied().collect::<Vec<_>>() {
            if !next.contains(&owner) { self.retire(world, owner); } else { self.hide(world, owner); }
        }
        self.admitted = next;
        Ok(true)
    }

    /// One full packet set per admitted owner/ordinal; empty means no live particle.
    /// All inputs/assets/meshes and retained ownership are validated before updates.
    /// A continuing owner/group keeps its entity and asset IDs: this system runs
    /// after AssetEventSystems, so extraction first sees Added on the next frame.
    /// Recreating the assets every frame would delete each ID before extraction.
    /// Failure hides its previous set but retains ownership for explicit retirement.
    pub fn replace_frame(&mut self, world: &mut World, owner: Owner, ordinal: u64,
        packets: Vec<DrawPacket>, bindings: &Bindings) -> Result<Vec<Ticket>, &'static str>
    {
        if !self.admitted.contains(&owner) || self.session != Some(owner.session)
            || ordinal != self.ordinal || world.get_entity(owner.actor).is_err()
        { return Err("Nexus packet owner is not admitted in this frame"); }
        if self.entries.get(&owner).is_some_and(|e| e.ordinal >= ordinal) {
            return Err("Nexus packet set was already submitted in this frame");
        }
        self.hide(world, owner);
        if packets.len() > 3 { return Err("Nexus backend only admits the three bounded groups once"); }
        let images = world.get_resource::<Assets<Image>>().ok_or("Nexus image assets missing")?;
        bindings.validate(images)?;
        if !world.contains_resource::<Assets<Mesh>>() || !world.contains_resource::<Assets<NexusMaterial>>() {
            return Err("Nexus mesh/material assets missing");
        }
        let mut groups = HashSet::new();
        let mut prepared = Vec::new();
        for packet in packets {
            if !groups.insert(packet.group) { return Err("duplicate Nexus group in one frame"); }
            let geometry=if packet.group==Group::GemSparkle {&self.sparkle_geometry} else {&self.geometry};
            let mesh = geometry.bake(packet.world)?;
            let bounds = mesh.compute_aabb().ok_or("Nexus transformed mesh has no bounds")?;
            let material = NexusMaterial::new(bindings, packet.group, packet.material)?;
            prepared.push((packet.group, mesh, bounds, material, bindings.images(packet.group)?.map(|h|h.id())));
        }
        if let Some(entry) = self.entries.get(&owner) {
            for draw in &entry.draws {
                if world.get::<Mesh3d>(draw.ticket.draw).map(|m| m.0.id()) != Some(draw.ticket.mesh)
                    || world.get::<MeshMaterial3d<NexusMaterial>>(draw.ticket.draw).map(|m| m.0.id()) != Some(draw.ticket.material)
                    || world.get::<OwnedDraw>(draw.ticket.draw).map(|d| &d.0) != Some(&draw.ticket)
                    || world.get::<Transform>(draw.ticket.draw) != Some(&Transform::IDENTITY)
                    || world.get::<GlobalTransform>(draw.ticket.draw) != Some(&GlobalTransform::IDENTITY)
                    || world.get::<ChildOf>(draw.ticket.draw).is_some()
                    || world.get::<Visibility>(draw.ticket.draw).is_none()
                    || world.resource::<Assets<Mesh>>().get(&draw.mesh).is_none()
                    || world.resource::<Assets<NexusMaterial>>().get(&draw.material).is_none()
                { return Err("Nexus retained draw ownership or resource changed"); }
            }
        }
        // Validation above covers the whole packet set. No sibling is updated
        // before a malformed later packet or changed private component is found.
        let mut retained = self.entries.remove(&owner).map(|e| e.draws).unwrap_or_default();
        let mut draws = Vec::new();
        for (group, mesh, bounds, material, images) in prepared {
            if let Some(index) = retained.iter().position(|d| d.ticket.group == group) {
                let mut draw = retained.remove(index);
                *world.resource_mut::<Assets<Mesh>>().get_mut(&draw.mesh).expect("validated private mesh") = mesh;
                *world.resource_mut::<Assets<NexusMaterial>>().get_mut(&draw.material).expect("validated private material") = material;
                draw.ticket.ordinal = ordinal;
                draw.ticket.images = images;
                world.entity_mut(draw.ticket.draw).insert((bounds, OwnedDraw(draw.ticket.clone())));
                draws.push(draw);
                continue;
            }
            let mesh = world.resource_mut::<Assets<Mesh>>().add(mesh);
            let material = world.resource_mut::<Assets<NexusMaterial>>().add(material);
            // Mesh already contains world D positions: no ChildOf or actor transform.
            let draw = world.spawn((Name::new(format!("Nexus Complex {}", group.authored_name())),
                Mesh3d(mesh.clone()), MeshMaterial3d(material.clone()), Transform::IDENTITY,
                GlobalTransform::IDENTITY, bounds, Visibility::Hidden)).id();
            let ticket = Ticket { owner, ordinal, group, draw, mesh: mesh.id(), material: material.id(),
                images };
            world.entity_mut(draw).insert(OwnedDraw(ticket.clone()));
            draws.push(Draw { ticket, mesh, material });
        }
        // Only groups absent from this validated full set are retired. A real
        // upstream rebind/session loss still retires the entire former owner.
        for draw in retained {
            world.despawn(draw.ticket.draw);
            world.resource_mut::<Assets<Mesh>>().remove(draw.mesh.id());
            world.resource_mut::<Assets<NexusMaterial>>().remove(draw.material.id());
        }
        let tickets = draws.iter().map(|d| d.ticket.clone()).collect();
        self.entries.insert(owner, Entry { ordinal, draws });
        Ok(tickets)
    }

    /// Ordinary Bevy rendering admission after CPU preparation. This does NOT
    /// attest RenderAssets/GpuImage, pipeline readiness, TextureIds or pixels.
    /// Bevy's material/mesh pipeline must still prepare and queue the real draw.
    pub fn admit_cpu_resources(&self, world: &mut World, ticket: &Ticket) -> Result<(), &'static str> {
        let live = self.entries.get(&ticket.owner).and_then(|e| e.draws.iter().find(|d| &d.ticket == ticket))
            .ok_or("stale Nexus renderer ticket")?;
        if self.ordinal != ticket.ordinal || !self.admitted.contains(&ticket.owner)
            || world.get_entity(ticket.owner.actor).is_err()
            || world.get::<Mesh3d>(ticket.draw).map(|m| m.0.id()) != Some(ticket.mesh)
            || world.get::<MeshMaterial3d<NexusMaterial>>(ticket.draw).map(|m| m.0.id()) != Some(ticket.material)
            || world.get::<OwnedDraw>(ticket.draw).map(|m| &m.0) != Some(ticket)
            || world.get::<Transform>(ticket.draw) != Some(&Transform::IDENTITY)
            || world.get::<ChildOf>(ticket.draw).is_some()
            || world.get::<Visibility>(ticket.draw).is_none()
        { return Err("Nexus draw ownership or transform changed"); }
        {
            let mut materials = world.get_resource_mut::<Assets<NexusMaterial>>().ok_or("Nexus material assets missing")?;
            let mut material = materials.get_mut(&live.material).ok_or("Nexus private material missing")?;
            material.set_ready(true);
        }
        *world.get_mut::<Visibility>(ticket.draw).ok_or("Nexus draw visibility missing")? = Visibility::Visible;
        Ok(())
    }
}

/// Registered by nexus_complex_live after the upstream IdleParticles plugin.
/// There is deliberately no Startup crystal, local lifetime or fake completion.
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self, app: &mut App) { app.add_plugins(MaterialPlugin::<NexusMaterial>::default()); }
}

#[cfg(test)]
#[path = "nexus_complex_host_tests.rs"]
mod tests;
