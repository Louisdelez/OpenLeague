//! Shared ordinary CameraLock setting. Original HUD/LockCamera=0 and Y binding
//! are source data; ownership, background follow and lease policy are local.
//! The public consumer never reads or mutates ButtonInput, Window or CameraFocus.
use bevy::prelude::*;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Owner {
    pub pid: u32,
    pub session: u64,
    pub player: u32,
    pub epoch: Option<u64>,
    pub primary_window: Entity,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Origin { Ui, Hotkey, Minimap, Observer(u64) }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Request {
    pub owner: Owner,
    pub serial: u64,
    pub expected_revision: u64,
    pub expected_locked: bool,
    pub locked: bool,
    pub origin: Origin,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Rejection {
    Unavailable, ForeignOwner, NotReady, Terminal, HumanGate,
    StaleSerial, StaleRevision, StaleState, InvalidLease, Exhausted,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Accepted { pub owner: Owner, pub serial: u64, pub revision: u64, pub locked: bool, pub origin: Origin }

#[derive(Clone, Copy, Debug)]
pub(crate) struct Admission {
    pub owner: Option<Owner>,
    pub ready: bool,
    pub terminal: bool,
    pub human_enabled: bool,
}

/// Restoration is conditional ownership, not an unconditional original value.
#[derive(Clone, Copy, Debug)]
pub struct Lease {
    owner: Owner,
    id: u64,
    original_locked: bool,
    owned_revision: u64,
    owned_locked: bool,
}

#[derive(Resource, Debug)]
pub struct Setting {
    owner: Option<Owner>,
    locked: bool,
    default_locked: bool,
    revision: u64,
    last_serial: u64,
    last_origin: Option<Origin>,
    ready: bool,
    terminal: bool,
    human_enabled: bool,
    configuration_error: Option<String>,
}
impl Default for Setting {
    fn default() -> Self {
        Self { owner: None, locked: false, default_locked: false, revision: 0,
            last_serial: 0, last_origin: None, ready: false, terminal: false,
            human_enabled: false, configuration_error: None }
    }
}

impl Setting {
    pub fn owner(&self) -> Option<Owner> { self.owner }
    pub fn locked(&self) -> bool { self.locked }
    pub fn revision(&self) -> u64 { self.revision }
    pub fn last_serial(&self) -> u64 { self.last_serial }
    pub fn last_origin(&self) -> Option<Origin> { self.last_origin }
    pub fn available(&self) -> bool { self.owner.is_some() && self.ready && !self.terminal && self.configuration_error.is_none() }
    pub fn human_enabled(&self) -> bool { self.available() && self.human_enabled }
    pub fn follows_authoritative_target(&self) -> bool { self.available() && self.locked }

    /// Revision barriers invalidate requests/leases on identity, epoch,
    /// readiness and terminal changes. Real focus alone does not stop a lock.
    pub(crate) fn reconcile(&mut self, admission: Admission) -> bool {
        let owner_changed = self.owner != admission.owner;
        let barrier = owner_changed || self.ready != admission.ready || self.terminal != admission.terminal;
        if barrier {
            let Some(revision) = self.revision.checked_add(1) else {
                self.configuration_error = Some("CameraLock revision exhausted".into());
                self.ready = false; self.human_enabled = false; return true;
            };
            self.revision = revision;
            self.last_origin = None;
        }
        if owner_changed {
            self.owner = admission.owner;
            self.locked = self.default_locked;
            self.last_serial = 0;
        }
        self.ready = admission.ready;
        self.terminal = admission.terminal;
        self.human_enabled = admission.human_enabled;
        barrier
    }

    pub fn request(&self, locked: bool, origin: Origin) -> Result<Request, Rejection> {
        let owner = self.owner.ok_or(Rejection::Unavailable)?;
        let serial = self.last_serial.checked_add(1).ok_or(Rejection::Exhausted)?;
        Ok(Request { owner, serial, expected_revision: self.revision,
            expected_locked: self.locked, locked, origin })
    }

    /// UI, physical Y, minimap and observers all use this single consumer.
    /// Even an accepted human no-op advances revision, invalidating a lease.
    pub fn consume(&mut self, request: Request) -> Result<Accepted, Rejection> {
        if self.configuration_error.is_some() { return Err(Rejection::Unavailable); }
        if self.owner != Some(request.owner) || request.owner.pid != std::process::id() { return Err(Rejection::ForeignOwner); }
        if self.terminal { return Err(Rejection::Terminal); }
        if !self.ready { return Err(Rejection::NotReady); }
        if matches!(request.origin, Origin::Observer(0)) { return Err(Rejection::InvalidLease); }
        if !matches!(request.origin, Origin::Observer(_)) && !self.human_enabled { return Err(Rejection::HumanGate); }
        if request.serial <= self.last_serial { return Err(Rejection::StaleSerial); }
        if request.expected_revision != self.revision { return Err(Rejection::StaleRevision); }
        if request.expected_locked != self.locked { return Err(Rejection::StaleState); }
        let revision = self.revision.checked_add(1).ok_or(Rejection::Exhausted)?;
        self.last_serial = request.serial; self.revision = revision;
        self.locked = request.locked; self.last_origin = Some(request.origin);
        Ok(Accepted { owner: request.owner, serial: request.serial, revision,
            locked: request.locked, origin: request.origin })
    }

    pub fn acquire_observer(&mut self, request: Request) -> Result<Lease, Rejection> {
        let Origin::Observer(id) = request.origin else { return Err(Rejection::InvalidLease); };
        if id == 0 { return Err(Rejection::InvalidLease); }
        let original_locked = self.locked;
        let accepted = self.consume(request)?;
        Ok(Lease { owner: accepted.owner, id, original_locked,
            owned_revision: accepted.revision, owned_locked: accepted.locked })
    }

    /// Refusal preserves a human or newer observer change. No keyboard release,
    /// state rollback or direct camera assignment is performed by restoration.
    pub fn restore_observer(&mut self, lease: &Lease, serial: u64) -> Result<Accepted, Rejection> {
        if self.owner != Some(lease.owner) { return Err(Rejection::ForeignOwner); }
        if self.revision != lease.owned_revision { return Err(Rejection::StaleRevision); }
        if self.locked != lease.owned_locked { return Err(Rejection::StaleState); }
        if self.last_origin != Some(Origin::Observer(lease.id)) { return Err(Rejection::InvalidLease); }
        self.consume(Request { owner: lease.owner, serial,
            expected_revision: lease.owned_revision, expected_locked: lease.owned_locked,
            locked: lease.original_locked, origin: Origin::Observer(lease.id) })
    }
}

fn configured(value: Option<&[u8]>) -> Result<bool, &'static str> {
    match value { Some(b"0") => Ok(false), Some(b"1") => Ok(true),
        Some(_) => Err("Unsupported HUD/LockCamera setting; expected 0 or 1"),
        None => Err("Original HUD/LockCamera default unavailable") }
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) { app.init_resource::<Setting>().add_systems(Startup, setup); }
}
fn setup(settings: Res<crate::native_user_settings::Loaded>, mut lock: ResMut<Setting>) {
    match configured(settings.text.value(b"HUD", b"LockCamera")) {
        Ok(value) => { lock.default_locked = value; lock.locked = value; },
        Err(error) => { lock.configuration_error = Some(error.into()); eprintln!("CameraLock unavailable: {error}"); }
    }
}

#[cfg(test)]
#[path = "camera_lock_tests.rs"]
mod tests;
