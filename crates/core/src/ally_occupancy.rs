//! Reconstructed allied-champion geometry, not recovered native body-block code.
//! Placement, cached ordinary orders and same-tick swept reservations.
//! Terrain admission, attack validity and priority spell movement stay separate.
use crate::{pillar_navigation::{self, Circle}, Navigation, Point, Simulation};
use std::collections::{BTreeMap, VecDeque};

const MAX_CELLS: usize = 39_474;
const MAX_VIRTUAL: usize = 450;
const NONE: u32 = u32::MAX;

#[derive(Clone, Copy, Debug)]
pub(crate) struct Body {
    pub id: u32,
    pub team: u8,
    pub position: Point,
    pub radius: f32,
    /// Real movement budget supplied by a future ordinary-motion consumer.
    /// Zero also pins a windup, stun, cast or Eforced actor in the batch.
    pub budget: f64,
}

impl Body {
    fn valid(self) -> bool {
        self.team < 2 && self.position.finite() && self.radius.is_finite()
            && self.radius > 0. && self.radius <= 50.
            && self.budget.is_finite() && self.budget >= 0.
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) enum Failure {
    InvalidInput,
    StartBlocked,
    SearchLimited,
    NoReachableArrival,
    InvalidMotion,
    TerrainBlocked,
    Conflict,
    DuplicateReservation,
}

fn squared(a: Point, b: Point) -> f64 {
    (f64::from(a.x) - f64::from(b.x)).powi(2)
        + (f64::from(a.z) - f64::from(b.z)).powi(2)
}
fn length(a: Point, b: Point) -> f64 { squared(a, b).sqrt() }

fn ulp(value: f32) -> f64 {
    let value = value.abs();
    if !value.is_finite() { return f64::INFINITY; }
    f64::from(f32::from_bits(value.to_bits() + 1)) - f64::from(value)
}
fn allowance(points: &[Point]) -> f64 {
    4. * 2f64.sqrt() * points.iter().flat_map(|p| [ulp(p.x), ulp(p.z)])
        .fold(0., f64::max)
}

/// Squared closest relative distance while two linear segments share an interval.
fn relative_minimum(a0: Point, a1: Point, b0: Point, b1: Point) -> f64 {
    let x = f64::from(a0.x) - f64::from(b0.x);
    let z = f64::from(a0.z) - f64::from(b0.z);
    let dx = (f64::from(a1.x) - f64::from(a0.x))
        - (f64::from(b1.x) - f64::from(b0.x));
    let dz = (f64::from(a1.z) - f64::from(a0.z))
        - (f64::from(b1.z) - f64::from(b0.z));
    let denominator = dx * dx + dz * dz;
    let t = if denominator == 0. { 0. } else {
        (-(x * dx + z * dz) / denominator).clamp(0., 1.)
    };
    (x + dx * t).powi(2) + (z + dz * t).powi(2)
}

fn valid_grid(nav: &Navigation) -> bool {
    let m = &nav.metadata;
    m.width > 0 && m.height > 0 && m.width.checked_mul(m.height) == Some(nav.cells.len())
        && nav.cells.len() <= MAX_CELLS && m.cell_size.is_finite() && m.cell_size > 0.
        && m.min.iter().all(|v| v.is_finite())
}
fn allies(mobile: Body, bodies: &[Body]) -> Result<Vec<Body>, Failure> {
    if !mobile.valid() || bodies.len() > 6 { return Err(Failure::InvalidInput); }
    let mut ids = std::collections::BTreeSet::new();
    let mut out = Vec::new();
    for b in bodies {
        if !b.valid() || !ids.insert(b.id) { return Err(Failure::InvalidInput); }
        if b.id != mobile.id && b.team == mobile.team { out.push(*b); }
    }
    out.sort_by_key(|b| b.id);
    if out.len() > 2 { return Err(Failure::InvalidInput); }
    Ok(out)
}
fn body_clear(point: Point, radius: f32, bodies: &[Body]) -> bool {
    bodies.iter().all(|b| squared(point, b.position)
        >= (f64::from(radius) + f64::from(b.radius)).powi(2))
}

fn living_bodies(sim: &Simulation, exclude: Option<u32>) -> Option<Vec<Body>> {
    sim.players.values().filter(|p| Some(p.id) != exclude
        && p.health.is_finite() && p.health > 0.)
        .map(|p| {
            if !p.position.finite() || p.team > 1 { return None; }
            Some(Body { id: p.id, team: p.team, position: p.position,
                radius: crate::collision::pathfinding_radius(&p.champion)?, budget: 0. })
        })
        .collect()
}

/// A new actor has no physical route from an already occupied seed. Reachability
/// here is the static-terrain component; occupancy/pillars filter the final point.
/// No body, target, attack, E push or world state is mutated by this query.
pub(crate) fn placement(sim: &Simulation, champion: &str, team: u8,
    seed: Point, exclude: Option<u32>) -> Option<Point>
{
    let radius = crate::collision::pathfinding_radius(champion)?;
    let nav = &sim.navigation;
    if team > 1 || !seed.finite() || !valid_grid(nav) { return None; }
    let all_bodies = living_bodies(sim, exclude)?;
    if all_bodies.len() > 6 { return None; }
    let bodies: Vec<_> = all_bodies.into_iter()
        .filter(|b| b.team == team).collect();
    let pillars = sim.trundle_e_circles();
    let free = |p| pillar_navigation::point_allowed(nav, p, &pillars)
        && body_clear(p, radius, &bodies);
    if free(seed) { return Some(seed); }
    let anchor = nav.ground(seed).map(|_| seed).or_else(|| nav.nearest_walkable(seed))?;
    let start = nav.index(anchor)?;
    let mut seen = vec![false; nav.cells.len()];
    let mut queue = VecDeque::with_capacity(nav.cells.len());
    queue.push_back(start); seen[start] = true;
    let mut best: Option<(f64, usize, Point)> = None;
    while let Some(i) = queue.pop_front() {
        let point = nav.center(i);
        if free(point) {
            let row = (squared(seed, point), i, point);
            if best.as_ref().is_none_or(|old| row.0.total_cmp(&old.0)
                .then(row.1.cmp(&old.1)).is_lt()) { best = Some(row); }
        }
        let x = (i % nav.metadata.width) as isize;
        let z = (i / nav.metadata.width) as isize;
        for (dx, dz) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let (nx, nz) = (x + dx, z + dz);
            if nx < 0 || nz < 0 || nx >= nav.metadata.width as isize
                || nz >= nav.metadata.height as isize { continue; }
            let n = nz as usize * nav.metadata.width + nx as usize;
            if nav.cells[n].1 && !seen[n] { seen[n] = true; queue.push_back(n); }
        }
    }
    best.map(|row| row.2)
}

#[derive(Debug)]
pub(crate) struct Route {
    pub path: VecDeque<Point>,
    pub endpoint: Point,
    pub visited: usize,
    pub virtual_nodes: usize,
}

struct Space<'a> {
    nav: &'a Navigation,
    pillars: &'a [Circle],
    mobile: Body,
    bodies: Vec<Body>,
}
impl Space<'_> {
    fn node_allowed(&self, p: Point) -> bool {
        pillar_navigation::point_allowed(self.nav, p, self.pillars)
            && self.bodies.iter().all(|b| {
                let radius = f64::from(self.mobile.radius) + f64::from(b.radius);
                let original = length(self.mobile.position, b.position);
                let d = length(p, b.position);
                d >= radius || (original < radius && d + allowance(&[p,
                    self.mobile.position, b.position]) >= original)
            })
    }
    fn edge(&self, a: Point, b: Point) -> bool {
        if !self.node_allowed(b)
            || !pillar_navigation::segment_allowed(self.nav, a, b, self.pillars) { return false; }
        self.bodies.iter().all(|other| {
            let radius = f64::from(self.mobile.radius) + f64::from(other.radius);
            let original = length(self.mobile.position, other.position);
            let minimum = relative_minimum(a, b, other.position, other.position).sqrt();
            if original >= radius { return minimum >= radius; }
            let start = length(a, other.position);
            if start >= radius { return minimum >= radius; }
            let eps = allowance(&[a, b, other.position]);
            let end = length(b, other.position);
            eps.is_finite() && minimum >= start - eps
                && (end >= radius || end > start + eps)
        })
    }
}

fn directions(anchor: Point, target: Point, mobile_radius: f32, bodies: &[Body]) -> Vec<f64> {
    let pi = std::f64::consts::PI; let tau = std::f64::consts::TAU;
    let mut angles = vec![0., pi / 2., pi, 3. * pi / 2.];
    if anchor != target {
        let a = (f64::from(target.z) - f64::from(anchor.z))
            .atan2(f64::from(target.x) - f64::from(anchor.x));
        angles.extend([a.rem_euclid(tau), (a + pi).rem_euclid(tau)]);
    }
    for b in bodies {
        let dx = f64::from(b.position.x) - f64::from(anchor.x);
        let dz = f64::from(b.position.z) - f64::from(anchor.z);
        let d = dx.hypot(dz); let radius = f64::from(mobile_radius) + f64::from(b.radius);
        if d > radius {
            let theta = dz.atan2(dx); let offset = (radius / d).asin();
            angles.extend([(theta - offset).rem_euclid(tau), (theta + offset).rem_euclid(tau)]);
        } else if d > 0. {
            let normal = (-dz).atan2(-dx);
            angles.extend([normal.rem_euclid(tau), (normal + pi / 2.).rem_euclid(tau),
                (normal - pi / 2.).rem_euclid(tau)]);
        }
    }
    angles.sort_by(f64::total_cmp); angles.dedup_by(|a, b| *a == *b);
    let original = angles.clone();
    for (i, a) in original.iter().enumerate() {
        let next = if i + 1 == original.len() { original[0] + tau } else { original[i + 1] };
        angles.push((a + (next - a) / 2.).rem_euclid(tau));
    }
    angles.sort_by(f64::total_cmp); angles.dedup_by(|a, b| *a == *b); angles
}

fn virtual_points(space: &Space<'_>, target: Point) -> Result<(Vec<Point>, f64), Failure> {
    let max_radius = space.bodies.iter().map(|b| f64::from(space.mobile.radius)
        + f64::from(b.radius)).fold(f64::from(space.mobile.radius), f64::max);
    let cell = f64::from(space.nav.metadata.cell_size);
    let range = 2. * max_radius + 2f64.sqrt() * cell;
    let levels = (range / cell).ceil() as usize;
    // Explicit Map10 workload cap. A finer custom grid reports SearchLimited,
    // not a false physical impossibility or an unbounded allocation.
    if levels > 6 { return Err(Failure::SearchLimited); }
    let mut points = Vec::with_capacity(MAX_VIRTUAL);
    points.extend([space.mobile.position, target]);
    for anchor in [space.mobile.position, target] {
        let angles = directions(anchor, target, space.mobile.radius, &space.bodies);
        if angles.len() > 32 { return Err(Failure::SearchLimited); }
        for theta in angles {
            let (x, z) = (theta.cos(), theta.sin());
            let mut distances: Vec<_> = (1..=levels).map(|i| (i as f64 * cell).min(range)).collect();
            let mut exit: f64 = 0.;
            for b in &space.bodies {
                let vx = f64::from(anchor.x) - f64::from(b.position.x);
                let vz = f64::from(anchor.z) - f64::from(b.position.z);
                let radius = f64::from(space.mobile.radius) + f64::from(b.radius);
                if vx * vx + vz * vz < radius * radius {
                    let dot = vx * x + vz * z;
                    exit = exit.max(-dot + (dot * dot + radius * radius - vx * vx - vz * vz).max(0.).sqrt());
                }
            }
            if exit > 0. && exit <= range { distances.push(exit); }
            for d in distances {
                let p = Point { x: (f64::from(anchor.x) + x * d) as f32,
                    z: (f64::from(anchor.z) + z * d) as f32 };
                if space.node_allowed(p) && !points.contains(&p) {
                    if points.len() == MAX_VIRTUAL { return Err(Failure::SearchLimited); }
                    points.push(p);
                }
            }
        }
    }
    Ok((points, range))
}

fn neighbors(nav: &Navigation, point: Point) -> Vec<usize> {
    let Some(i) = nav.index(point) else { return Vec::new(); };
    let (x, z) = ((i % nav.metadata.width) as isize, (i / nav.metadata.width) as isize);
    let mut out = Vec::with_capacity(9);
    for dz in -1..=1 { for dx in -1..=1 {
        let (nx, nz) = (x + dx, z + dz);
        if nx >= 0 && nz >= 0 && nx < nav.metadata.width as isize && nz < nav.metadata.height as isize {
            out.push(nz as usize * nav.metadata.width + nx as usize);
        }
    }}
    out
}

/// One shared reachability traversal, then a linear nearest-arrival selection.
/// `reserved` constrains endpoints only; it never places future goals as solid
/// obstacles along other actors' routes. No mutation and no successful-command
/// or continuous-space completeness inference is made by this kernel.
pub(crate) fn route(nav: &Navigation, pillars: &[Circle], mobile: Body,
    bodies: &[Body], reserved: &[Body], target: Point) -> Result<Route, Failure>
{
    if !valid_grid(nav) || !target.finite() || reserved.len() > 6 {
        return Err(Failure::InvalidInput);
    }
    let others = allies(mobile, bodies)?;
    let endpoints = allies(mobile, reserved)?;
    let space = Space { nav, pillars, mobile, bodies: others };
    if !pillar_navigation::point_allowed(nav, mobile.position, pillars) {
        return Err(Failure::StartBlocked);
    }
    let (points, range) = virtual_points(&space, target)?;
    let n = nav.cells.len(); let count = n + points.len(); let start = n;
    // Intrusive cell buckets: O(N + 9K), no N*K scan or N*N matrix.
    let mut heads = vec![NONE; n]; let mut links: Vec<(u32, u32)> = Vec::with_capacity(9 * points.len());
    for (v, p) in points.iter().enumerate() {
        for g in neighbors(nav, *p) {
            links.push(((n + v) as u32, heads[g])); heads[g] = (links.len() - 1) as u32;
        }
    }
    let point = |i: usize| if i < n { nav.center(i) } else { points[i - n] };
    let mut parent = vec![NONE; count]; parent[start] = start as u32;
    let mut queue = Vec::with_capacity(count); queue.push(start as u32); let mut cursor = 0;
    while cursor < queue.len() {
        let i = queue[cursor] as usize; cursor += 1;
        let mut candidates = Vec::with_capacity(points.len() + 9);
        if i < n {
            candidates.extend(neighbors(nav, point(i)).into_iter().filter(|j| *j != i));
            let mut link = heads[i];
            while link != NONE {
                let (v, next) = links[link as usize]; candidates.push(v as usize); link = next;
            }
        } else {
            candidates.extend(neighbors(nav, point(i)));
            candidates.extend((n..count).filter(|j| *j != i && squared(point(i), point(*j)) <= range * range));
        }
        candidates.sort_unstable(); candidates.dedup();
        for j in candidates {
            if parent[j] == NONE && space.edge(point(i), point(j)) {
                parent[j] = i as u32; queue.push(j as u32);
            }
        }
    }
    let rank = |i| if i == n + 1 { 0 } else if i == n { 1 } else { i + 2 };
    let mut best: Option<(f64, usize, usize)> = None;
    for i in 0..count {
        if parent[i] == NONE { continue; }
        let p = point(i);
        if !body_clear(p, mobile.radius, &space.bodies)
            || !body_clear(p, mobile.radius, &endpoints) { continue; }
        let row = (squared(p, target), rank(i), i);
        if best.as_ref().is_none_or(|old| row.0.total_cmp(&old.0).then(row.1.cmp(&old.1)).is_lt()) {
            best = Some(row);
        }
    }
    let end = best.ok_or(Failure::NoReachableArrival)?.2;
    let mut path = VecDeque::with_capacity(count); let mut i = end;
    while i != start {
        let previous = parent[i] as usize;
        if point(i) != point(previous) { path.push_front(point(i)); }
        i = previous;
    }
    Ok(Route { endpoint: point(end), path, visited: queue.len(), virtual_nodes: points.len() })
}

#[derive(Clone, Copy, Debug)]
struct Sample { time: f64, x: f64, z: f64 }
#[derive(Clone, Debug)]
pub(crate) struct Motion { samples: Vec<Sample>, start: Point, end: Point, distance: f64, budget: f64 }
impl Motion {
    pub(crate) fn stationary(point: Point) -> Self {
        Self { samples: vec![Sample { time: 0., x: point.x as f64, z: point.z as f64 },
            Sample { time: 1., x: point.x as f64, z: point.z as f64 }], start: point, end: point, distance: 0., budget: 0. }
    }
    /// Points already represented in f32, with total physical travel <= budget.
    /// The remaining part of the tick is a real stationary segment.
    pub(crate) fn from_points(start: Point, points: &[Point], budget: f64) -> Result<Self, Failure> {
        if !start.finite() || !budget.is_finite() || budget < 0. || points.len() > MAX_CELLS + MAX_VIRTUAL
            || points.iter().any(|p| !p.finite()) { return Err(Failure::InvalidMotion); }
        let mut motion = Self { samples: Vec::with_capacity(points.len() + 2), start,
            end: start, distance: 0., budget };
        motion.samples.push(Sample { time: 0., x: start.x as f64, z: start.z as f64 });
        let mut previous = start; let mut distance = 0.;
        for p in points {
            let step = length(previous, *p);
            if step == 0. { continue; }
            distance += step;
            if distance > budget || budget == 0. { return Err(Failure::InvalidMotion); }
            let time = distance / budget;
            if !time.is_finite() || time <= motion.samples.last().unwrap().time {
                return Err(Failure::InvalidMotion);
            }
            motion.samples.push(Sample { time, x: p.x as f64, z: p.z as f64 });
            previous = *p;
        }
        if motion.samples.last().unwrap().time < 1. {
            motion.samples.push(Sample { time: 1., x: previous.x as f64, z: previous.z as f64 });
        }
        motion.end = previous; motion.distance = distance; motion.budget = budget; Ok(motion)
    }
    fn at(a: Sample, b: Sample, time: f64) -> (f64, f64) {
        let t = if b.time == a.time { 0. } else { (time - a.time) / (b.time - a.time) };
        (a.x + (b.x - a.x) * t, a.z + (b.z - a.z) * t)
    }
    fn minimum(&self, other: &Self) -> f64 {
        let mut best = f64::INFINITY; let (mut ai, mut bi) = (0, 0);
        // Both sample lists have strictly increasing times and include 0/1.
        // Merge their intervals in O(A+B); never compare their Cartesian product.
        while ai + 1 < self.samples.len() && bi + 1 < other.samples.len() {
            let a = [self.samples[ai], self.samples[ai + 1]];
            let b = [other.samples[bi], other.samples[bi + 1]];
            let lo = a[0].time.max(b[0].time); let hi = a[1].time.min(b[1].time);
            let a0 = Self::at(a[0], a[1], lo); let a1 = Self::at(a[0], a[1], hi);
            let b0 = Self::at(b[0], b[1], lo); let b1 = Self::at(b[0], b[1], hi);
            let (x, z) = (a0.0 - b0.0, a0.1 - b0.1);
            let (dx, dz) = ((a1.0 - b1.0) - x, (a1.1 - b1.1) - z);
            let denominator = dx * dx + dz * dz;
            let t = if denominator == 0. { 0. } else { (-(x * dx + z * dz) / denominator).clamp(0., 1.) };
            best = best.min((x + t * dx).hypot(z + t * dz));
            if a[1].time <= b[1].time { ai += 1; }
            if b[1].time <= a[1].time { bi += 1; }
        }
        best
    }
}

/// Per-tick private reservation set. It cannot move an actor, mutate a path,
/// consume an attack/RNG, replace a prior reservation or rewrite Eforced.
pub(crate) struct Batch { bodies: BTreeMap<u32, Body>, accepted: BTreeMap<u32, Motion> }
impl Batch {
    pub(crate) fn new(team: u8, bodies: &[Body]) -> Result<Self, Failure> {
        if team > 1 || bodies.len() > 6 { return Err(Failure::InvalidInput); }
        let mut selected = BTreeMap::new(); let mut ids = std::collections::BTreeSet::new();
        for b in bodies {
            if !b.valid() || !ids.insert(b.id) { return Err(Failure::InvalidInput); }
            if b.team == team { selected.insert(b.id, *b); }
        }
        if selected.len() > 3 { return Err(Failure::InvalidInput); }
        Ok(Self { bodies: selected, accepted: BTreeMap::new() })
    }
    pub(crate) fn reserve(&mut self, id: u32, motion: Motion) -> Result<(), Failure> {
        let body = *self.bodies.get(&id).ok_or(Failure::InvalidInput)?;
        if self.accepted.contains_key(&id) { return Err(Failure::DuplicateReservation); }
        if motion.start != body.position || !motion.end.finite() || motion.distance > body.budget
            || (motion.distance > 0. && motion.budget != body.budget) {
            return Err(Failure::InvalidMotion);
        }
        for (other_id, other) in &self.bodies {
            if *other_id == id { continue; }
            let stationary = Motion::stationary(other.position);
            let other_motion = self.accepted.get(other_id).unwrap_or(&stationary);
            let radius = f64::from(body.radius) + f64::from(other.radius);
            let original = length(body.position, other.position);
            let minimum = motion.minimum(other_motion);
            if !minimum.is_finite() { return Err(Failure::InvalidMotion); }
            if original >= radius {
                if minimum < radius { return Err(Failure::Conflict); }
            } else if motion.distance > 0. || other_motion.distance > 0. {
                let eps = 4. * 2f64.sqrt() * motion.samples.iter().chain(&other_motion.samples)
                    .flat_map(|s| [ulp(s.x as f32), ulp(s.z as f32)]).fold(0., f64::max);
                let end = length(motion.end, other_motion.end);
                if !eps.is_finite() || minimum < original - eps
                    || (end < radius && end <= original + eps) {
                    return Err(Failure::Conflict);
                }
            }
        }
        self.accepted.insert(id, motion); Ok(())
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Intent { Move([u32; 2]), Attack(u32) }
fn bits(p: Point) -> [u32; 2] { [p.x.to_bits(), p.z.to_bits()] }
fn overlay(circles: &[Circle]) -> Vec<[u32; 3]> {
    let mut value: Vec<_> = circles.iter().map(|c|
        [c.center.x.to_bits(), c.center.z.to_bits(), c.radius.to_bits()]).collect();
    value.sort_unstable(); value
}
#[derive(Clone, Copy, Debug)]
struct Order {
    intent: Intent,
    requested: Point,
    arrival: Option<Point>,
    expected_position: Point,
    team: u8,
}
#[derive(Default)]
struct Slot {
    order: Option<Order>,
    next_search: u64,
    searches: u64,
    last_failure: Option<Failure>,
}
/// Private, non-serialized state. Rate limits belong to slots, not new orders.
#[derive(Default)]
pub(crate) struct State {
    session: Option<u64>,
    slots: BTreeMap<u32, Slot>,
    overlay: Vec<[u32; 3]>,
}
impl State {
    pub(crate) fn reconcile(&mut self, session: u64,
        players: &BTreeMap<u32, crate::Champion>)
    {
        if self.session != Some(session) {
            *self = Self { session: Some(session), ..Self::default() };
        }
        self.slots.retain(|id, _| players.get(id)
            .is_some_and(|p| p.health.is_finite() && p.health > 0.));
    }
    fn sync_overlay(&mut self, circles: &[Circle]) {
        let current = overlay(circles);
        if current != self.overlay {
            for slot in self.slots.values_mut() {
                if let Some(order) = &mut slot.order { order.arrival = None; }
            }
            self.overlay = current;
        }
    }
    fn note(&mut self, id: u32, team: u8, position: Point, intent: Intent, requested: Point) {
        if !self.slots.contains_key(&id) && self.slots.len() >= 6 { return; }
        let slot = self.slots.entry(id).or_default();
        slot.order = Some(Order { intent, requested, arrival: None,
            expected_position: position, team });
        slot.last_failure = None;
    }
    pub(crate) fn clear_order(&mut self, id: u32) {
        if let Some(slot) = self.slots.get_mut(&id) {
            slot.order = None; slot.last_failure = None;
        }
    }
    pub(crate) fn remove_actor(&mut self, id: u32) { self.slots.remove(&id); }
}

fn movable(p: &crate::Champion, tick: u64) -> bool {
    p.health.is_finite() && p.health > 0. && p.position.finite()
        && !crate::stuns::active(p, tick) && !crate::trundle_e::champion_forced(p, tick)
        && p.effects.ultimate.is_none() && p.effects.annie_q.is_none()
        && p.effects.annie_w.is_none() && p.effects.annie_r.is_none() && p.effects.ezreal_q.is_none() && p.effects.ezreal_w.is_none() && p.windup.is_none()
}

struct Prefix { motion: Motion, popped: usize }
/// Round only inward when the f32 representation would exceed the real budget.
fn fit_step(from: Point, to: Point, budget: f64) -> Point {
    let distance = length(from, to);
    if distance <= budget { return to; }
    if budget <= 0. || distance == 0. { return from; }
    let point = |t: f64| Point {
        x: (f64::from(from.x) + (f64::from(to.x) - f64::from(from.x)) * t) as f32,
        z: (f64::from(from.z) + (f64::from(to.z) - f64::from(from.z)) * t) as f32,
    };
    let mut hi = budget / distance;
    let first = point(hi);
    if length(from, first) <= budget { return first; }
    let (mut lo, mut best) = (0., from);
    for _ in 0..32 {
        let mid = (lo + hi) / 2.; let candidate = point(mid);
        if length(from, candidate) <= budget { lo = mid; best = candidate; } else { hi = mid; }
    }
    best
}
fn prefix(nav: &Navigation, pillars: &[Circle], body: Body,
    path: &VecDeque<Point>) -> Result<Prefix, Failure>
{
    if path.len() > MAX_CELLS + MAX_VIRTUAL { return Err(Failure::InvalidMotion); }
    let mut points = Vec::with_capacity(path.len().min(MAX_CELLS + MAX_VIRTUAL));
    let mut current = body.position; let mut used = 0.; let mut popped = 0;
    for goal in path {
        if !goal.finite() { return Err(Failure::InvalidMotion); }
        let next = fit_step(current, *goal, body.budget - used);
        if !pillar_navigation::segment_allowed(nav, current, next, pillars) {
            return Err(Failure::TerrainBlocked);
        }
        let distance = length(current, next);
        if distance > 0. { points.push(next); used += distance; current = next; }
        if next == *goal { popped += 1; } else { break; }
        if used >= body.budget { break; }
    }
    Ok(Prefix { motion: Motion::from_points(body.position, &points, body.budget)?, popped })
}

impl Simulation {
    pub(crate) fn ally_move_is_repeat(&self, id: u32, requested: Point) -> bool {
        let p = &self.players[&id];
        let state = &self.ally_occupancy;
        if state.session != Some(self.session) || state.overlay != overlay(&self.trundle_e_circles())
            || !requested.finite() || p.target.is_some() || p.windup.is_some() { return false; }
        let Some(order) = state.slots.get(&id).and_then(|s| s.order) else { return false; };
        if order.intent != Intent::Move(bits(requested)) || order.team != p.team
            || order.expected_position != p.position { return false; }
        if !pillar_navigation::point_allowed(&self.navigation, requested, &self.trundle_e_circles()) {
            return false;
        }
        match p.destination {
            Some(goal) => bits(goal) == bits(order.requested)
                || order.arrival.is_some_and(|a| bits(a) == bits(goal)),
            None => p.path.is_empty() && order.arrival == Some(p.position),
        }
    }
    pub(crate) fn note_ally_move(&mut self, id: u32, requested: Point) {
        let circles = self.trundle_e_circles();
        self.ally_occupancy.reconcile(self.session, &self.players);
        self.ally_occupancy.sync_overlay(&circles);
        let p = &self.players[&id];
        self.ally_occupancy.note(id, p.team, p.position, Intent::Move(bits(requested)), requested);
    }
    pub(crate) fn note_ally_pursuit(&mut self, id: u32, target: u32, requested: Point) {
        let circles = self.trundle_e_circles();
        self.ally_occupancy.reconcile(self.session, &self.players);
        self.ally_occupancy.sync_overlay(&circles);
        let p = &self.players[&id];
        self.ally_occupancy.note(id, p.team, p.position, Intent::Attack(target), requested);
    }
    /// Called only after the ordinary combat/FoW/cast guards and 10-tick deadline.
    pub(crate) fn ally_pursuit_path_current(&self, id: u32, target: u32,
        target_position: Point, range: f32) -> bool
    {
        let p = &self.players[&id];
        let state = &self.ally_occupancy;
        let Some(order) = state.slots.get(&id).and_then(|s| s.order) else { return false; };
        if state.session != Some(self.session) || order.intent != Intent::Attack(target)
            || order.expected_position != p.position || p.path.is_empty()
            || state.overlay != overlay(&self.trundle_e_circles()) { return false; }
        bits(order.requested) == bits(target_position)
            || (range.is_finite() && range >= 0. && order.arrival
                .is_some_and(|a| length(a, target_position) <= f64::from(range)))
    }
    fn occupancy_replan(&mut self, state: &mut State, id: u32, body: Body,
        bodies: &[Body], reserved: &[Body], circles: &[Circle]) -> bool
    {
        let Some(slot) = state.slots.get_mut(&id) else { return false; };
        let Some(order) = slot.order else { return false; };
        if self.tick < slot.next_search { return false; }
        slot.next_search = self.tick.saturating_add(10);
        slot.searches = slot.searches.saturating_add(1);
        let result = route(&self.navigation, circles, body, bodies, reserved, order.requested);
        let p = self.players.get_mut(&id).unwrap();
        match result {
            Ok(plan) if !plan.path.is_empty() || bits(plan.endpoint) == bits(order.requested) => {
                p.path = plan.path;
                p.destination = (!p.path.is_empty()).then_some(plan.endpoint);
                slot.order.as_mut().unwrap().arrival = Some(plan.endpoint);
                slot.last_failure = None; true
            }
            result => {
                p.path.clear(); p.destination = Some(order.requested);
                slot.order.as_mut().unwrap().arrival = None;
                slot.last_failure = Some(result.err().unwrap_or(Failure::NoReachableArrival));
                false
            }
        }
    }
    pub(crate) fn advance_allied_motion(&mut self) {
        let mut state = std::mem::take(&mut self.ally_occupancy);
        self.advance_allied_motion_inner(&mut state);
        self.ally_occupancy = state;
    }
    fn advance_allied_motion_inner(&mut self, state: &mut State) {
        state.reconcile(self.session, &self.players);
        let circles = self.trundle_e_circles(); state.sync_overlay(&circles);
        if self.players.len() > 6 { return; }
        let ids: Vec<_> = self.players.keys().copied().collect();
        // Invalidate private state after external position/order changes. No E
        // trajectory is rewritten: E already ran, and an active marker is fixed.
        for id in &ids {
            let p = &self.players[id];
            if !p.health.is_finite() || p.health <= 0. { continue; }
            let old = state.slots.get(id).and_then(|s| s.order);
            let displaced = old.is_some_and(|o| o.expected_position != p.position || o.team != p.team);
            let compatible = old.is_some_and(|o| match o.intent {
                Intent::Attack(target) => p.target == Some(target),
                Intent::Move(_) => p.target.is_none() && match p.destination {
                    Some(goal) => bits(goal) == bits(o.requested)
                        || o.arrival.is_some_and(|a| bits(a) == bits(goal)),
                    None => p.path.is_empty() && o.arrival == Some(p.position),
                },
            });
            if displaced || !compatible { state.clear_order(*id); }
            if displaced { self.players.get_mut(id).unwrap().path.clear(); }
            let p = &self.players[id];
            if crate::trundle_e::champion_forced(p, self.tick) { state.clear_order(*id); continue; }
            if state.slots.get(id).and_then(|s| s.order).is_none() {
                let intent = if let Some(target) = p.target {
                    self.target_info(target).map(|e| (Intent::Attack(target), e.position))
                } else { p.destination.or_else(|| p.path.back().copied())
                    .map(|goal| (Intent::Move(bits(goal)), goal)) };
                if let Some((intent, goal)) = intent { state.note(*id, p.team, p.position, intent, goal); }
            }
        }
        let mut bodies = Vec::with_capacity(6);
        for p in self.players.values() {
            if !p.health.is_finite() || p.health <= 0. { continue; }
            let Some(radius) = crate::collision::pathfinding_radius(&p.champion) else { return; };
            let budget = if movable(p, self.tick) && !self.ezreal_e_casting(p.id) && !self.ezreal_r_casting(p.id) {
                f64::from(self.movement_speed(p.id) / crate::TICK_RATE as f32)
            } else { 0. };
            let b = Body { id: p.id, team: p.team, position: p.position, radius, budget };
            if !b.valid() { return; } bodies.push(b);
        }
        let (Ok(blue), Ok(purple)) = (Batch::new(0, &bodies), Batch::new(1, &bodies)) else { return; };
        let mut batches = [blue, purple];
        for body in &bodies {
            let others = match allies(*body, &bodies) { Ok(v) => v, Err(_) => return };
            let Some(order) = state.slots.get_mut(&body.id).and_then(|s| s.order.as_mut()) else { continue; };
            if order.arrival.is_some_and(|a| !pillar_navigation::point_allowed(&self.navigation, a, &circles)
                || !body_clear(a, body.radius, &others)) { order.arrival = None; }
            // A completed alternate arrival may improve when the originally
            // requested goal becomes free; Stop/cast-cleared orders are absent.
            let p = &self.players[&body.id];
            if matches!(order.intent, Intent::Move(_)) && p.path.is_empty() && p.destination.is_none()
                && order.arrival.is_some_and(|a| bits(a) != bits(order.requested))
                && pillar_navigation::point_allowed(&self.navigation, order.requested, &circles)
                && body_clear(order.requested, body.radius, &others) {
                order.arrival = None;
                self.players.get_mut(&body.id).unwrap().destination = Some(order.requested);
            }
        }
        for body in &bodies {
            let id = body.id; let others = match allies(*body, &bodies) { Ok(v) => v, Err(_) => return };
            let reserved: Vec<_> = state.slots.iter().filter_map(|(other_id, slot)| {
                let order = slot.order?;
                if *other_id == id || order.team != body.team { return None; }
                let original = bodies.iter().find(|b| b.id == *other_id)?;
                Some(Body { position: order.arrival?, budget: 0., ..*original })
            }).collect();
            let active = !self.players[&id].path.is_empty() || self.players[&id].destination.is_some();
            let mut prepared = None;
            let mut terrain_blocked = false;
            if body.budget > 0. && active {
                let end = self.players[&id].path.back().copied();
                let geometric_end = end.or(self.players[&id].destination);
                // A new terrain/E obstruction cancels the old public path.
                // Only allied body/reservation conflicts may choose an alternate
                // arrival automatically; a new Move or normal pursuit replans E.
                let ready = if matches!(prefix(&self.navigation, &circles, *body,
                    &self.players[&id].path), Err(Failure::TerrainBlocked))
                    || geometric_end.is_some_and(|point|
                    !pillar_navigation::point_allowed(&self.navigation, point, &circles)) {
                    terrain_blocked = true;
                    false
                } else if let Some(end) = end.filter(|point|
                    body_clear(*point, body.radius, &others) && body_clear(*point, body.radius, &reserved)) {
                    if let Some(order) = state.slots.get_mut(&id).and_then(|s| s.order.as_mut()) {
                        order.arrival = Some(end);
                    }
                    true
                } else {
                    if let Some(order) = state.slots.get_mut(&id).and_then(|s| s.order.as_mut()) { order.arrival = None; }
                    self.occupancy_replan(state, id, *body, &bodies, &reserved, &circles)
                };
                if ready {
                    match prefix(&self.navigation, &circles, *body, &self.players[&id].path) {
                        Ok(candidate) => {
                            if batches[body.team as usize].reserve(id, candidate.motion.clone()).is_ok() {
                                prepared = Some(candidate);
                            }
                        }
                        Err(Failure::TerrainBlocked) => terrain_blocked = true,
                        Err(_) => {}
                    }
                }
                if !terrain_blocked && prepared.is_none()
                    && self.occupancy_replan(state, id, *body, &bodies, &reserved, &circles) {
                    match prefix(&self.navigation, &circles, *body, &self.players[&id].path) {
                        Ok(candidate) => {
                            if batches[body.team as usize].reserve(id, candidate.motion.clone()).is_ok() {
                                prepared = Some(candidate);
                            }
                        }
                        Err(Failure::TerrainBlocked) => terrain_blocked = true,
                        Err(_) => {}
                    }
                }
            }
            if terrain_blocked {
                let p = self.players.get_mut(&id).unwrap();
                p.path.clear(); p.destination = None;
                // Keep target and next_repath: public attack pursuit retains its
                // existing deadline. A stopped Move needs a new ordinary order.
                state.clear_order(id);
            }
            let accepted = if let Some(candidate) = prepared { candidate } else {
                // Previous accepted movers were checked against this actor's
                // stationary trajectory, so keeping it fixed cannot add a hit.
                let stationary = Motion::stationary(body.position);
                if batches[body.team as usize].reserve(id, stationary.clone()).is_err() { return; }
                Prefix { motion: stationary, popped: 0 }
            };
            let p = self.players.get_mut(&id).unwrap();
            if body.budget > 0. {
                p.position = accepted.motion.end;
                for _ in 0..accepted.popped { p.path.pop_front(); }
                p.capture_facing([p.position.x - body.position.x, 0., p.position.z - body.position.z]);
                if p.path.is_empty() && state.slots.get(&id).and_then(|s| s.order)
                    .is_some_and(|o| o.arrival == Some(p.position)) { p.destination = None; }
                if let Some(height) = self.navigation.ground(p.position) { p.height = height; }
            }
            if let Some(order) = state.slots.get_mut(&id).and_then(|s| s.order.as_mut()) {
                order.expected_position = p.position;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn grid(width: usize, height: usize, blocked: &[usize]) -> Navigation {
        let metadata = format!(r#"{{"min":[0,0,0],"cellSize":50,"width":{width},"height":{height}}}"#);
        let mut bytes = Vec::new();
        for i in 0..width * height {
            bytes.extend(0f32.to_le_bytes()); bytes.extend(if blocked.contains(&i) { 2u16 } else { 0u16 }.to_le_bytes());
            bytes.extend(0u32.to_le_bytes()); bytes.push(1);
        }
        Navigation::load(&metadata, &bytes).unwrap()
    }
    fn body(id: u32, x: f32, z: f32, budget: f64) -> Body {
        Body { id, team: 0, position: Point { x, z }, radius: 35., budget }
    }
    #[test]
    fn join_uses_native_radius_occupation_without_fixed_slots() {
        let mut sim = Simulation::new(grid(40, 40, &[])).unwrap();
        let a = sim.join("garen").unwrap(); sim.join("garen").unwrap();
        let c = sim.join("trundle").unwrap(); sim.join("garen").unwrap();
        let e = sim.join("annie").unwrap();
        for (left, right) in [(a, c), (a, e), (c, e)] {
            let p = &sim.players[&left]; let q = &sim.players[&right];
            let radius = f64::from(crate::collision::pathfinding_radius(&p.champion).unwrap())
                + f64::from(crate::collision::pathfinding_radius(&q.champion).unwrap());
            assert!(length(p.position, q.position) >= radius);
        }
    }
    #[test]
    fn no_placement_rejects_join_without_allocating_actor() {
        let mut sim = Simulation::new(grid(1, 1, &[])).unwrap();
        sim.join("garen").unwrap(); sim.join("garen").unwrap();
        let ids: Vec<_> = sim.players.keys().copied().collect();
        assert!(sim.join("annie").is_err());
        assert_eq!(sim.players.keys().copied().collect::<Vec<_>>(), ids);
        sim.players.get_mut(&ids[0]).unwrap().champion = "not_a_native_profile".into();
        assert!(placement(&sim, "annie", 0, Point { x: 25., z: 25. }, None).is_none());
        sim.players.remove(&ids[0]);
        assert_eq!(sim.join("annie").unwrap(), 3);
    }
    #[test]
    fn respawn_does_not_reuse_an_occupied_allied_center() {
        let mut sim = Simulation::new(grid(40, 40, &[])).unwrap();
        let a = sim.join("garen").unwrap(); sim.join("garen").unwrap(); let c = sim.join("annie").unwrap();
        let original = sim.players[&a].position;
        sim.players.get_mut(&c).unwrap().position = original;
        let p = sim.players.get_mut(&a).unwrap(); p.health = 0.; p.respawn_at = Some(0);
        sim.advance_respawns();
        assert!(sim.players[&a].health > 0.);
        assert!(length(sim.players[&a].position, sim.players[&c].position) >= 65.);
        sim.navigation = grid(1, 1, &[]);
        sim.players.get_mut(&c).unwrap().position = Point { x: 25., z: 25. };
        let p = sim.players.get_mut(&a).unwrap(); p.health = 0.; p.respawn_at = Some(0);
        sim.advance_respawns();
        assert_eq!(sim.players[&a].health, 0.);
        assert_eq!(sim.players[&a].respawn_at, Some(0));
    }
    #[test]
    fn nearest_arrival_does_not_prefer_a_far_current_position() {
        let nav = grid(30, 30, &[]); let a = body(1, 125., 125., 100.); let b = body(3, 925., 925., 0.);
        let plan = route(&nav, &[], a, &[a, b], &[], b.position).unwrap();
        assert!(length(plan.endpoint, b.position) < length(a.position, b.position));
        assert!(length(plan.endpoint, b.position) >= 70.);
    }
    #[test]
    fn same_goal_reservations_allocate_distinct_reachable_arrivals() {
        let nav = grid(30, 30, &[]); let a = body(1, 125., 125., 100.); let b = body(3, 125., 925., 100.);
        let target = Point { x: 925., z: 525. };
        let first = route(&nav, &[], a, &[a, b], &[], target).unwrap();
        let reserved = Body { position: first.endpoint, budget: 0., ..a };
        let second = route(&nav, &[], b, &[a, b], &[reserved], target).unwrap();
        assert_eq!(first.endpoint, target); assert!(length(first.endpoint, second.endpoint) >= 70.);
        assert!(!second.path.is_empty());
    }
    #[test]
    fn diagonal_connector_escapes_false_cardinal_blockage() {
        let nav = grid(20, 20, &[]); let a = body(1, 525., 525., 100.);
        let b = body(3, 575., 575., 0.); let c = body(5, 475., 475., 0.);
        let plan = route(&nav, &[], a, &[a, b, c], &[], Point { x: 225., z: 825. }).unwrap();
        assert_eq!(plan.endpoint, Point { x: 225., z: 825. }); assert!(!plan.path.is_empty());
        assert!(plan.visited <= nav.cells.len() + MAX_VIRTUAL && plan.virtual_nodes <= MAX_VIRTUAL);
    }
    #[test]
    fn route_never_cuts_a_blocked_terrain_corner_or_pillar() {
        let nav = grid(20, 20, &[10 * 20 + 10]); let a = body(1, 425., 425., 100.);
        let pillar = Circle { center: Point { x: 625., z: 475. }, radius: 90. };
        let plan = route(&nav, &[pillar], a, &[a], &[], Point { x: 825., z: 625. }).unwrap();
        let mut p = a.position;
        for next in plan.path { assert!(pillar_navigation::segment_allowed(&nav, p, next, &[pillar])); p = next; }
    }
    #[test]
    fn swept_crossing_is_rejected_even_when_endpoints_are_separate() {
        let a = body(1, 225., 425., 400.); let b = body(3, 425., 225., 400.);
        let mut batch = Batch::new(0, &[a, b]).unwrap();
        batch.reserve(a.id, Motion::from_points(a.position, &[Point { x: 625., z: 425. }], 400.).unwrap()).unwrap();
        assert_eq!(batch.reserve(b.id, Motion::from_points(b.position, &[Point { x: 425., z: 625. }], 400.).unwrap()), Err(Failure::Conflict));
        assert_eq!(batch.reserve(b.id, Motion::from_points(b.position, &[Point { x: 425., z: 625. }], 800.).unwrap()), Err(Failure::InvalidMotion));
    }
    #[test]
    fn polyline_wait_segment_is_compared_instead_of_endpoint_chord() {
        let a = body(1, 225., 225., 500.); let b = body(3, 325., 325., 0.);
        let motion = Motion::from_points(a.position, &[Point { x: 225., z: 425. }, Point { x: 425., z: 425. }], 500.).unwrap();
        assert_eq!(relative_minimum(a.position, motion.end, b.position, b.position), 0.);
        let mut batch = Batch::new(0, &[a, b]).unwrap(); batch.reserve(a.id, motion).unwrap();
        batch.reserve(b.id, Motion::stationary(b.position)).unwrap();
        let early = body(1, 225., 225., 800.); let late = body(3, 425., 625., 600.);
        let mut hold = Batch::new(0, &[early, late]).unwrap();
        hold.reserve(early.id, Motion::from_points(early.position, &[Point { x: 425., z: 225. }], 800.).unwrap()).unwrap();
        // The second actor crosses the first after its arrival at t=.25;
        // their final centers remain 200 apart, so an endpoint check misses it.
        assert_eq!(hold.reserve(late.id, Motion::from_points(late.position, &[Point { x: 425., z: 25. }], 600.).unwrap()), Err(Failure::Conflict));
    }
    #[test]
    fn initial_overlap_requires_relative_progress_not_cotranslation() {
        let a = body(1, 525., 525., 20.); let b = body(3, 525., 525., 20.);
        let mut batch = Batch::new(0, &[a, b]).unwrap();
        batch.reserve(a.id, Motion::from_points(a.position, &[Point { x: 545., z: 525. }], 20.).unwrap()).unwrap();
        assert_eq!(batch.reserve(b.id, Motion::from_points(b.position, &[Point { x: 545., z: 525. }], 20.).unwrap()), Err(Failure::Conflict));
        batch.reserve(b.id, Motion::stationary(b.position)).unwrap();
    }
    #[test]
    fn full_separation_is_allowed_when_quantized_progress_is_below_epsilon() {
        let nav = grid(205, 129, &[]);
        let a = body(1, 10_000., 6_000., 1.);
        let b = body(3, 10_069.999_023_437_5, 6_000., 1.);
        let end = Point { x: 9_999.999_023_437_5, z: 6_000. };
        assert_eq!(length(end, b.position), 70.);
        assert!(length(end, b.position) - length(a.position, b.position)
            < allowance(&[a.position, end, b.position]));
        let space = Space { nav: &nav, pillars: &[], mobile: a, bodies: vec![b] };
        assert!(space.edge(a.position, end));
        let mut batch = Batch::new(0, &[a, b]).unwrap();
        batch.reserve(a.id, Motion::from_points(a.position, &[end], 1.).unwrap()).unwrap();
        batch.reserve(b.id, Motion::stationary(b.position)).unwrap();
    }
    #[test]
    fn fixed_actor_budget_and_duplicate_reservations_fail_atomically() {
        let c = body(5, 225., 225., 100.); let mut timed = Batch::new(0, &[c]).unwrap();
        // A length-100 path timed using speed 200 is not the body's speed-100 motion.
        let too_fast = Motion::from_points(c.position, &[Point { x: 325., z: 225. }], 200.).unwrap();
        assert_eq!(timed.reserve(c.id, too_fast), Err(Failure::InvalidMotion));
        timed.reserve(c.id, Motion::from_points(c.position, &[Point { x: 325., z: 225. }], 100.).unwrap()).unwrap();
        let a = body(1, 225., 225., 0.); let mut batch = Batch::new(0, &[a]).unwrap();
        let moving = Motion::from_points(a.position, &[Point { x: 226., z: 225. }], 1.).unwrap();
        assert_eq!(batch.reserve(a.id, moving), Err(Failure::InvalidMotion));
        batch.reserve(a.id, Motion::stationary(a.position)).unwrap();
        assert_eq!(batch.reserve(a.id, Motion::stationary(a.position)), Err(Failure::DuplicateReservation));
    }
    #[test]
    fn other_team_does_not_become_an_allied_body_blocker() {
        let nav = grid(20, 20, &[]); let a = body(1, 225., 225., 100.);
        let b = Body { team: 1, position: Point { x: 525., z: 225. }, ..body(2, 0., 0., 0.) };
        let plan = route(&nav, &[], a, &[a, b], &[], b.position).unwrap(); assert_eq!(plan.endpoint, b.position);
        assert!(Motion::from_points(a.position, &[Point { x: 326., z: 225. }], 100.).is_err());
    }
}

#[cfg(test)]
mod ordinary_tests {
    use super::*;
    use crate::Action;
    fn game() -> (Simulation, [u32; 3]) {
        let mut bytes = Vec::new();
        for _ in 0..1600 {
            bytes.extend(0f32.to_le_bytes()); bytes.extend(0u16.to_le_bytes());
            bytes.extend(0u32.to_le_bytes()); bytes.push(1);
        }
        let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":40,"height":40}"#, &bytes).unwrap();
        let mut sim = Simulation::new(nav).unwrap();
        let mut ids = Vec::new();
        for name in ["garen", "garen", "trundle", "garen", "annie", "garen"] {
            ids.push(sim.join(name).unwrap());
        }
        for (id, (x, z)) in ids.iter().zip([(225.,225.),(1625.,1625.),(225.,625.),
            (1625.,1225.),(625.,225.),(1225.,1625.)]) {
            let p = sim.players.get_mut(id).unwrap(); p.position = Point { x, z };
            p.path.clear(); p.destination = None; p.target = None;
        }
        (sim, [ids[0], ids[2], ids[4]])
    }
    // Isolated real pursuit/movement phases; no world AI or damage fixture is
    // substituted for those APIs. The separate engine suites still need Root.
    fn step(sim: &mut Simulation) {
        sim.tick += 1; sim.advance_pursuit(); sim.advance_allied_motion();
    }
    fn separated(sim: &Simulation, ids: [u32; 3]) {
        for (a,b) in [(ids[0],ids[1]),(ids[0],ids[2]),(ids[1],ids[2])] {
            let p = &sim.players[&a]; let q = &sim.players[&b];
            let radius = f64::from(crate::collision::pathfinding_radius(&p.champion).unwrap())
                + f64::from(crate::collision::pathfinding_radius(&q.champion).unwrap());
            assert!(length(p.position,q.position) >= radius);
        }
    }
    #[test]
    fn shared_arrival_keeps_three_living_allies_separated() {
        let (mut sim, ids) = game(); let goal = Point { x:1225.,z:625. };
        for id in ids { sim.command(id,Action::Move {point:goal}).unwrap(); }
        for _ in 0..300 { step(&mut sim); separated(&sim,ids); }
        for id in ids { assert!(length(sim.players[&id].position,goal)<175.); }
    }
    #[test]
    fn ordinary_crossing_uses_common_swept_batch_before_commit() {
        let (mut sim,ids)=game();
        sim.players.get_mut(&ids[0]).unwrap().position=Point{x:225.,z:425.};
        sim.players.get_mut(&ids[1]).unwrap().position=Point{x:425.,z:225.};
        sim.players.get_mut(&ids[2]).unwrap().position=Point{x:1225.,z:1225.};
        let a=Point{x:625.,z:425.};let b=Point{x:425.,z:625.};
        sim.command(ids[0],Action::Move{point:a}).unwrap();
        sim.command(ids[1],Action::Move{point:b}).unwrap();
        for _ in 0..150 {step(&mut sim);separated(&sim,ids);}
        assert!(length(sim.players[&ids[0]].position,a)<80.);
        assert!(length(sim.players[&ids[1]].position,b)<80.);
    }
    #[test]
    fn repeated_move_keeps_path_progress_and_replan_slot_deadline() {
        let (mut sim,ids)=game();let id=ids[0];let goal=sim.players[&ids[1]].position;
        sim.command(id,Action::Move{point:goal}).unwrap();step(&mut sim);
        let path=sim.players[&id].path.clone();
        let searches=sim.ally_occupancy.slots[&id].searches;
        let deadline=sim.ally_occupancy.slots[&id].next_search;
        for _ in 0..8 {sim.command(id,Action::Move{point:goal}).unwrap();}
        assert_eq!(sim.players[&id].path,path);
        assert_eq!(sim.ally_occupancy.slots[&id].searches,searches);
        assert_eq!(sim.ally_occupancy.slots[&id].next_search,deadline);
        let before=sim.players[&id].position;step(&mut sim);
        assert_ne!(sim.players[&id].position,before);
    }
    #[test]
    fn changing_intent_cannot_reset_occupancy_search_rate_limit() {
        let (mut sim,ids)=game();let id=ids[0];let occupied=sim.players[&ids[1]].position;
        sim.command(id,Action::Move{point:occupied}).unwrap();step(&mut sim);
        let deadline=sim.ally_occupancy.slots[&id].next_search;
        let searches=sim.ally_occupancy.slots[&id].searches;
        let enemy=2;
        sim.command(id,Action::Attack{target:enemy}).unwrap();
        assert_eq!(sim.ally_occupancy.slots[&id].next_search,deadline);
        sim.command(id,Action::Stop).unwrap();
        sim.command(id,Action::Move{point:occupied}).unwrap();step(&mut sim);
        assert_eq!(sim.ally_occupancy.slots[&id].searches,searches);
        assert_eq!(sim.ally_occupancy.slots[&id].next_search,deadline);
    }
    #[test]
    fn repeated_attack_keeps_pursuit_but_still_rejects_invalid_target() {
        let (mut sim,ids)=game();let id=ids[0];let enemy=2;
        sim.command(id,Action::Attack{target:enemy}).unwrap();step(&mut sim);
        let path=sim.players[&id].path.clone();let next=sim.players[&id].next_repath;
        sim.command(id,Action::Attack{target:enemy}).unwrap();
        assert_eq!(sim.players[&id].path,path);assert_eq!(sim.players[&id].next_repath,next);
        sim.players.get_mut(&id).unwrap().windup=Some(crate::attacks::Windup{
            target:4,started:sim.tick,release:sim.tick+10,cancelable:false,critical:false,presentation:None});
        assert!(sim.command(id,Action::Attack{target:enemy}).is_err());
        assert_eq!(sim.players[&id].windup.as_ref().unwrap().target,4);
        sim.players.get_mut(&enemy).unwrap().health=0.;
        assert!(sim.command(id,Action::Attack{target:enemy}).is_err());
        assert_eq!(sim.players[&id].path,path);
    }
    #[test]
    fn mobile_target_replans_at_deadline_when_endpoint_is_no_longer_in_range() {
        let (mut sim,ids)=game();let id=ids[0];let enemy=2;
        sim.command(id,Action::Attack{target:enemy}).unwrap();step(&mut sim);
        let old=sim.players[&id].path.back().copied();let due=sim.players[&id].next_repath;
        sim.players.get_mut(&enemy).unwrap().position=Point{x:1225.,z:225.};
        sim.tick=due;sim.advance_pursuit();
        assert_ne!(sim.players[&id].path.back().copied(),old);
        assert_eq!(sim.ally_occupancy.slots[&id].order.unwrap().requested,sim.players[&enemy].position);
    }
    #[test]
    fn new_invalid_move_preserves_old_order_and_private_cache() {
        let (mut sim,ids)=game();let id=ids[0];let goal=Point{x:1225.,z:625.};
        sim.command(id,Action::Move{point:goal}).unwrap();step(&mut sim);
        let path=sim.players[&id].path.clone();let destination=sim.players[&id].destination;
        let request=sim.ally_occupancy.slots[&id].order.unwrap().requested;
        assert!(sim.command(id,Action::Move{point:Point{x:f32::NAN,z:0.}}).is_err());
        assert_eq!(sim.players[&id].path,path);assert_eq!(sim.players[&id].destination,destination);
        assert_eq!(sim.ally_occupancy.slots[&id].order.unwrap().requested,request);
        sim.players.get_mut(&id).unwrap().windup=Some(crate::attacks::Windup{
            target:2,started:sim.tick,release:sim.tick+10,cancelable:false,critical:false,presentation:None});
        assert!(sim.command(id,Action::Move{point:goal}).is_err());
        assert_eq!(sim.players[&id].path,path);
    }
    #[test]
    fn forced_marker_pins_motion_and_stop_clears_cache() {
        let (mut sim,ids)=game();let id=ids[0];let goal=Point{x:1225.,z:625.};
        sim.command(id,Action::Move{point:goal}).unwrap();step(&mut sim);
        sim.command(id,Action::Stop).unwrap();step(&mut sim);
        assert!(sim.ally_occupancy.slots[&id].order.is_none());
        sim.command(id,Action::Move{point:goal}).unwrap();
        sim.players.get_mut(&id).unwrap().effects.trundle_e_push=Some(crate::trundle_e::ForcedMovement{started:sim.tick,until:sim.tick+10});
        let before=sim.players[&id].position;step(&mut sim);
        assert_eq!(sim.players[&id].position,before);
        assert!(sim.ally_occupancy.slots[&id].order.is_none());
    }
    #[test]
    fn actual_f32_motion_never_spends_more_than_its_speed_budget() {
        let (mut sim,ids)=game();let id=ids[0];let goal=Point{x:1225.,z:1175.};
        sim.command(id,Action::Move{point:goal}).unwrap();
        for _ in 0..30 {
            let before=sim.players[&id].position;
            let budget=f64::from(sim.movement_speed(id)/crate::TICK_RATE as f32);
            step(&mut sim);
            assert!(length(before,sim.players[&id].position)<=budget);
        }
    }
}
