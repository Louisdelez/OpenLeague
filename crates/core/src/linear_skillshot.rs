//! SOURCE CANDIDATE: local authoritative geometric kernel, not an Ezreal kit.
//!
//! The trusted caller supplies parameters and already-admissible target circles.
//! This module applies no damage, cooldown, passive, team/visibility or immunity rule.
//! Circle centres are held fixed for one tick segment. Terrain, walls and actors'
//! continuous motion between samples are NOT evaluated. Arithmetic is finite f64
//! from the existing f32 Point inputs; native bit-for-bit geometry is not claimed.
use crate::Point;
use std::collections::BTreeSet;

/// Immutable association, not authentication. Session0 is allowed by Simulation::new.
/// The caller allocates a unique nonzero ordinal and never reuses actor IDs while
/// this shot can exist. Current Core uses a shared next_id for players and NPCs;
/// exhaustion/wrap protection and global shot uniqueness remain issuer obligations.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity {
    pub session: u64,
    pub owner: u32,
    pub team: u8,
    pub ordinal: u64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Mode { FirstContact, Pierce }

/// Resource limits, supplied by the caller; these are not native gameplay values.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Limits {
    pub targets_per_step: usize,
    pub unique_hits: usize,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Params {
    pub speed_units_per_second: f32,
    pub tick_rate: u32,
    pub max_distance: f32,
    pub projectile_radius: f32,
    pub launch_tick: u64,
    /// Exclusive: a step at or after this tick expires WITHOUT moving or hitting.
    pub expires_at_tick: u64,
    pub mode: Mode,
    pub limits: Limits,
}

/// A validated live actor identity in the caller's session, not a snapshot union.
/// Self/allied targets are allowed here: the caller decides the spell's eligibility.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Circle {
    pub id: u32,
    pub center: Point,
    pub radius: f32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum End { RangeExhausted, Expired, FirstContact, CancelledByCaller }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Phase { Flying, Ended(End) }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Error {
    InvalidIdentity, InvalidPoint, UndefinedDirection, InvalidParams,
    InvalidLimits, CoordinateOverflow, IdentityMismatch, AlreadyEnded,
    UnexpectedTick, InvalidCircle, DuplicateTarget, TargetCapacity, HitCapacity,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct View {
    pub identity: Identity,
    pub last_tick: u64,
    pub position: Point,
    pub traveled: f64,
    pub unique_hits: usize,
    pub phase: Phase,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Contact {
    pub id: u32,
    /// One-based among this shot's unique contacts. No damage/falloff is computed.
    pub ordinal: usize,
    pub tick: u64,
    pub step_distance: f64,
    pub total_distance: f64,
    pub projectile_center: Point,
    pub target_center: Point,
}

#[derive(Debug, PartialEq)]
pub struct Step {
    pub identity: Identity,
    pub tick: u64,
    pub from: Point,
    pub to: Point,
    pub moved_distance: f64,
    pub total_distance: f64,
    pub contacts: Vec<Contact>,
    pub phase: Phase,
}

/// Single owned shot. No Clone/serde or public mutable fields: integration is pending.
#[derive(Debug)]
pub struct Shot {
    identity: Identity,
    params: Params,
    origin: Point,
    delta: [f64; 2],
    direction_length: f64,
    unit: [f64; 2],
    last_tick: u64,
    traveled: f64,
    position: Point,
    hit: BTreeSet<u32>,
    phase: Phase,
}

impl Shot {
    /// Aim defines a direction; it is not a homing target or a range endpoint.
    /// No motion/contact occurs at construction or at the launch tick.
    pub fn new(identity: Identity, origin: Point, aim: Point, params: Params) -> Result<Self, Error> {
        if identity.owner == 0 || identity.team > 1 || identity.ordinal == 0 { return Err(Error::InvalidIdentity); }
        if !origin.finite() || !aim.finite() { return Err(Error::InvalidPoint); }
        if !params.speed_units_per_second.is_finite() || params.speed_units_per_second <= 0.
            || params.tick_rate == 0 || !params.max_distance.is_finite() || params.max_distance <= 0.
            || !params.projectile_radius.is_finite() || params.projectile_radius < 0.
            || params.expires_at_tick <= params.launch_tick { return Err(Error::InvalidParams); }
        if params.limits.targets_per_step == 0 || params.limits.unique_hits == 0 { return Err(Error::InvalidLimits); }
        let delta = [f64::from(aim.x) - f64::from(origin.x), f64::from(aim.z) - f64::from(origin.z)];
        let length = delta[0].hypot(delta[1]);
        if length == 0. { return Err(Error::UndefinedDirection); }
        let shot = Self { identity, params, origin, delta, direction_length: length, unit: [delta[0] / length, delta[1] / length],
            last_tick: params.launch_tick, traveled: 0., position: origin, hit: BTreeSet::new(), phase: Phase::Flying };
        // All intermediate points lie on this finite segment. Still check each export.
        shot.point_at(f64::from(params.max_distance))?;
        Ok(shot)
    }

    pub fn view(&self) -> View {
        View { identity: self.identity, last_tick: self.last_tick, position: self.position,
            traveled: self.traveled, unique_hits: self.hit.len(), phase: self.phase }
    }

    /// Caller decides death/departure/control/obstacle policies. Cancellation emits no hit.
    pub fn cancel(&mut self, identity: Identity) -> Result<(), Error> {
        self.check_identity(identity)?;
        if self.phase != Phase::Flying { return Err(Error::AlreadyEnded); }
        self.phase = Phase::Ended(End::CancelledByCaller);
        Ok(())
    }

    /// One consecutive tick only. Every error leaves all shot state unchanged.
    /// Repeated/skipped ticks cannot invent intermediate target positions. On an
    /// error the caller must cancel/discard, or retry the SAME tick with corrected
    /// trusted input before simulation advances; no silent catch-up is performed.
    pub fn advance(&mut self, identity: Identity, tick: u64, circles: &[Circle]) -> Result<Step, Error> {
        self.check_identity(identity)?;
        if self.phase != Phase::Flying { return Err(Error::AlreadyEnded); }
        if self.last_tick.checked_add(1) != Some(tick) { return Err(Error::UnexpectedTick); }
        self.validate_circles(circles)?;
        let from = self.position;
        if tick >= self.params.expires_at_tick {
            let phase = Phase::Ended(End::Expired);
            self.last_tick = tick; self.phase = phase;
            return Ok(Step { identity, tick, from, to: from, moved_distance: 0., total_distance: self.traveled,
                contacts: Vec::new(), phase });
        }
        let remaining = f64::from(self.params.max_distance) - self.traveled;
        let budget = (f64::from(self.params.speed_units_per_second) / f64::from(self.params.tick_rate)).min(remaining);
        let mut intersections = Vec::new();
        for circle in circles {
            if self.hit.contains(&circle.id) { continue; }
            if let Some(distance) = self.contact_distance(circle, budget) { intersections.push((distance, *circle)); }
        }
        intersections.sort_by(|a, b| a.0.total_cmp(&b.0).then(a.1.id.cmp(&b.1.id)));
        if self.params.mode == Mode::FirstContact { intersections.truncate(1); }
        let count = self.hit.len().checked_add(intersections.len()).ok_or(Error::HitCapacity)?;
        if count > self.params.limits.unique_hits { return Err(Error::HitCapacity); }
        let first = self.params.mode == Mode::FirstContact && !intersections.is_empty();
        let moved = if first { intersections[0].0 } else { budget };
        let total = (self.traveled + moved).min(f64::from(self.params.max_distance));
        let to = self.point_at(total)?;
        let mut contacts = Vec::with_capacity(intersections.len());
        for (index, (distance, circle)) in intersections.iter().enumerate() {
            let total_distance = (self.traveled + distance).min(f64::from(self.params.max_distance));
            contacts.push(Contact { id: circle.id, ordinal: self.hit.len() + index + 1, tick,
                step_distance: *distance, total_distance, projectile_center: self.point_at(total_distance)?, target_center: circle.center });
        }
        let phase = if first { Phase::Ended(End::FirstContact) }
            else if total >= f64::from(self.params.max_distance) { Phase::Ended(End::RangeExhausted) }
            else { Phase::Flying };
        // Commit only after every fallible validation/calculation has succeeded.
        for contact in &contacts { self.hit.insert(contact.id); }
        self.traveled = total; self.position = to; self.last_tick = tick; self.phase = phase;
        Ok(Step { identity, tick, from, to, moved_distance: moved, total_distance: total, contacts, phase })
    }

    fn check_identity(&self, identity: Identity) -> Result<(), Error> {
        if identity != self.identity { Err(Error::IdentityMismatch) } else { Ok(()) }
    }

    fn validate_circles(&self, circles: &[Circle]) -> Result<(), Error> {
        if circles.len() > self.params.limits.targets_per_step { return Err(Error::TargetCapacity); }
        let mut ids = BTreeSet::new();
        for circle in circles {
            if circle.id == 0 || !circle.center.finite() || !circle.radius.is_finite() || circle.radius < 0. { return Err(Error::InvalidCircle); }
            if !ids.insert(circle.id) { return Err(Error::DuplicateTarget); }
        }
        Ok(())
    }

    fn point_at(&self, distance: f64) -> Result<Point, Error> {
        let point = Point { x: (f64::from(self.origin.x) + self.unit[0] * distance) as f32,
            z: (f64::from(self.origin.z) + self.unit[1] * distance) as f32 };
        if point.finite() { Ok(point) } else { Err(Error::CoordinateOverflow) }
    }

    /// Earliest closed segment/circle contact. The target centre is fixed THIS step.
    /// Intersect the ORIGINAL unnormalised ray, then convert its parameter to
    /// distance and clip to this step. Normalising first can turn a diagonal
    /// tangent into a false negative discriminant. No epsilon is introduced.
    /// These remain f64 predicates, not exact-arithmetic/native boundary proofs.
    fn contact_distance(&self, circle: &Circle, budget: f64) -> Option<f64> {
        let x = f64::from(self.origin.x) - f64::from(circle.center.x);
        let z = f64::from(self.origin.z) - f64::from(circle.center.z);
        let radius = f64::from(self.params.projectile_radius) + f64::from(circle.radius);
        let a = self.delta[0] * self.delta[0] + self.delta[1] * self.delta[1];
        let b = x * self.delta[0] + z * self.delta[1];
        let cross = x * self.delta[1] - z * self.delta[0];
        let discriminant = radius * radius * a - cross * cross;
        if discriminant < 0. { return None; }
        let root = discriminant.sqrt();
        let exit = ((-b + root) / a) * self.direction_length;
        if exit < self.traveled { return None; }
        let entry = (((-b - root) / a) * self.direction_length - self.traveled).max(0.);
        (entry <= budget).then_some(entry)
    }
}

#[cfg(test)]
#[path = "linear_skillshot_tests.rs"]
mod tests;
