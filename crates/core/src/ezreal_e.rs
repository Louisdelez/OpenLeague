//! Partial local Arcane Shift 4.20 gameplay, not recovered native server callbacks.
//! Primary slot data: magic75..275 +0.75AP, mana90, CD19/17/15/13/11, blink475.
//! LOCAL policies approved for this bounded implementation: eight interruptible
//! cast ticks, radial clamp then exact disk landing (no wall snap), nearest visible
//! enemy non-structure unit within750 of landing, speed2000, TTL60, no retarget.
//! AP/CDR freeze on cast; current defense/penetration/Exhaust apply at contact.
//! No root/suppression buffering, reveal, invulnerability or bolt/flash rendering;
//! damage notifies the local passive. Body-visible cast projection supports partial
//! local animation; audio/native parity stay open and gameplay State stays private.
use crate::*;
use std::sync::OnceLock;

pub const WINDUP_TICKS: u64 = 8;
pub const BLINK_RANGE: f32 = 475.;
pub const ACQUISITION_RANGE: f32 = 750.;
pub const SPEED: f32 = 2000.;
pub const FLIGHT_TICKS: u64 = 60;
pub const MAX_CASTS: usize = 64;
pub const MAX_TARGETS: usize = 2048;
const MAX_LANDING_CELLS: usize = 256;
const MAX_FAULTS: usize = 32;

#[derive(Debug, Clone, Copy)]
pub struct Rank { pub base: f32, pub cost: f32, pub cooldown: f32, pub ap: f32 }
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fault { pub tick: u64, pub ordinal: u64, pub stage: &'static str, pub reason: String }
#[derive(Debug)]
struct Pending {
    session: u64, owner: u32, team: u8, ordinal: u64, origin: Point,
    landing: Point, facing: entity_facing::Facing, releases: u64, expires: u64, raw: f32,
}
#[derive(Debug)]
struct Bolt {
    session: u64, owner: u32, team: u8, ordinal: u64, target: u32,
    position: Point, expires: u64, raw: f32,
    // Presentation only: frozen with the actual initial or movement segment.
    current: Option<CurrentSample>,
}
#[derive(Debug, Clone, Copy)]
struct CurrentSample { tick: u64, position: Point, direction: Point }
impl CurrentSample {
    fn segment(tick:u64,position:Point,dx:f64,dz:f64,distance:f64)->Option<Self> {
        if !position.finite() || !dx.is_finite() || !dz.is_finite()
            || !distance.is_finite() || distance<=0. {return None;}
        let direction=Point{x:(dx/distance) as f32,z:(dz/distance) as f32};
        if !direction.finite() || (direction.x.hypot(direction.z)-1.).abs()>0.0001 {return None;}
        Some(Self{tick,position,direction})
    }
}
#[derive(Debug)]
pub(crate) struct State {
    session: Option<u64>, next_ordinal: u64, last_advanced: Option<u64>,
    pending: BTreeMap<u32, Pending>, bolts: Vec<Bolt>, faults: VecDeque<Fault>,
    pub(crate) releases: crate::ezreal_e_accepted_releases::State,
}
impl Default for State {
    fn default() -> Self {
        Self { session: None, next_ordinal: 1, last_advanced: None,
            pending: BTreeMap::new(), bolts: Vec::new(), faults: VecDeque::new(),
            releases: crate::ezreal_e_accepted_releases::State::default() }
    }
}
impl State {
    fn fault(&mut self, tick: u64, ordinal: u64, stage: &'static str, reason: String) {
        if self.faults.len() == MAX_FAULTS { self.faults.pop_front(); }
        self.faults.push_back(Fault { tick, ordinal, stage, reason });
    }
}
fn parse(text: &str) -> Result<[Rank; 5], String> {
    let rows: serde_json::Value = serde_json::from_str(text).map_err(|e| e.to_string())?;
    let rows = rows.as_array().ok_or("Ezreal E native table must be an array")?;
    let matching: Vec<_> = rows.iter().filter(|row| row["champion"].as_str()
        .is_some_and(|name| name.eq_ignore_ascii_case("ezreal")) && row["slot"].as_u64() == Some(2)).collect();
    if matching.len() != 1 || matching[0]["spell"] != "EzrealArcaneShift" {
        return Err("unique primary Ezreal E resource required".into());
    }
    let values = &matching[0]["values"];
    let number = |key: &str| -> Result<f32, String> {
        let v = &values[key];
        v.as_f64().map(|n| n as f32).or_else(|| v.as_str().and_then(|n| n.parse().ok()))
            .filter(|n: &f32| n.is_finite()).ok_or_else(|| format!("Ezreal E numeric field invalid: {key}"))
    };
    if number("Coefficient")? != 0.75 || number("CastRangeDisplayOverride")? != BLINK_RANGE {
        return Err("Ezreal E primary coefficient/display range changed".into());
    }
    let mut ranks = Vec::with_capacity(5);
    for i in 0..5 {
        let n = i + 1;
        let rule = Rank { base: number(&format!("Effect1Level{n}Amount"))?,
            cost: number(&format!("ManaCost{n}"))?, cooldown: number(&format!("Cooldown{n}"))?, ap: 0.75 };
        if rule.base != [75.,125.,175.,225.,275.][i] || rule.cost != 90.
            || rule.cooldown != [19.,17.,15.,13.,11.][i] {
            return Err("Ezreal E admitted primary ranks changed".into());
        }
        ranks.push(rule);
    }
    ranks.try_into().map_err(|_| "Ezreal E requires five ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=5).contains(&rank) { return Err("Ezreal E rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 5], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|ranks| ranks[rank as usize - 1]).map_err(Clone::clone)
}
fn squared(a: Point, b: Point) -> f64 {
    (f64::from(a.x) - f64::from(b.x)).powi(2) + (f64::from(a.z) - f64::from(b.z)).powi(2)
}
fn clamp_landing(origin: Point, aim: Point) -> Result<(Point, Point), String> {
    if !origin.finite() || !aim.finite() { return Err("invalid spell point".into()); }
    let dx = f64::from(aim.x) - f64::from(origin.x);
    let dz = f64::from(aim.z) - f64::from(origin.z);
    let distance = dx.hypot(dz);
    if distance <= 0. { return Err("Ezreal E requires a different landing point".into()); }
    let direction = Point { x: (dx / distance) as f32, z: (dz / distance) as f32 };
    let limit = f64::from(BLINK_RANGE).powi(2);
    let landing = if squared(origin, aim) <= limit { aim } else {
        // f32 conversion may round outward. Select the furthest representable
        // radial point within475 rather than accepting an over-range endpoint.
        let mut lo = 0.; let mut hi = f64::from(BLINK_RANGE) / distance;
        let mut best = origin;
        for _ in 0..64 {
            let t = (lo + hi) / 2.;
            let p = Point { x: (f64::from(origin.x) + dx * t) as f32,
                z: (f64::from(origin.z) + dz * t) as f32 };
            if squared(origin, p) <= limit { lo = t; best = p; } else { hi = t; }
        }
        best
    };
    if landing == origin || !landing.finite() || !direction.finite() {
        return Err("Ezreal E landing cannot be represented".into());
    }
    Ok((landing, direction))
}

impl Simulation {
    /// Private lock; no authoritative damage, target or hidden point goes on wire.
    pub(crate) fn ezreal_e_casting(&self, owner: u32) -> bool {
        self.ezreal_e.session == Some(self.session) && self.ezreal_e.pending.contains_key(&owner)
    }
    fn ezreal_e_census(&self) -> Result<Vec<(u32, world::Target)>, String> {
        if self.players.len().checked_add(self.units.len()).is_none_or(|n| n > MAX_TARGETS) {
            return Err("Ezreal E target census exceeds budget".into());
        }
        let mut targets = Vec::new();
        for id in self.players.keys().chain(self.units.keys()).copied() {
            if self.players.get(&id).is_some_and(|p| p.id != id || p.team > 1)
                || self.units.get(&id).is_some_and(|u| u.id != id || u.team > 2)
                || (self.players.contains_key(&id) && self.units.contains_key(&id)) {
                return Err("Ezreal E target identity invalid".into());
            }
            let target = self.target_info(id).ok_or("Ezreal E target collision absent")?;
            if !target.health.is_finite() { return Err("Ezreal E target health invalid".into()); }
            if target.health <= 0. { continue; }
            // Native Map10 inhibitor/nexus definitions explicitly use radius0.
            // Keep those coherent units as zero-radius landing points; do not
            // borrow champion fallback radii or admit malformed mobile circles.
            let zero_radius_structure = target.radius == 0. && self.units.get(&id).is_some_and(|unit|
                matches!(unit.kind, world::Kind::Inhibitor | world::Kind::Nexus)
                && self.world.as_ref().and_then(|world| world.config.definitions.get(&unit.definition))
                    .is_some_and(|definition| definition.kind == unit.kind && definition.radius == 0.));
            if !target.position.finite() || !target.radius.is_finite()
                || (target.radius <= 0. && !zero_radius_structure) {
                return Err("Ezreal E target collision invalid".into());
            }
            targets.push((id, target));
        }
        Ok(targets)
    }
    fn ezreal_e_landing(&self, owner: u32, landing: Point,
        targets: &[(u32, world::Target)]) -> Result<f32, String>
    {
        let player = self.players.get(&owner).ok_or("Ezreal E owner absent")?;
        let radius = self.target_info(owner).ok_or("Ezreal E owner collision absent")?.radius;
        if !landing.finite() || !radius.is_finite() || radius <= 0. {
            return Err("Ezreal E landing geometry invalid".into());
        }
        let nav = &self.navigation; let m = &nav.metadata;
        if m.width == 0 || m.height == 0 || m.width.checked_mul(m.height) != Some(nav.cells.len())
            || !m.cell_size.is_finite() || m.cell_size <= 0. || !m.min.iter().all(|v| v.is_finite()) {
            return Err("Ezreal E navigation invalid".into());
        }
        let (x, z, r, cell) = (f64::from(landing.x), f64::from(landing.z), f64::from(radius), f64::from(m.cell_size));
        let (min_x, min_z) = (f64::from(m.min[0]), f64::from(m.min[2]));
        if x-r < min_x || z-r < min_z || x+r >= min_x + m.width as f64*cell
            || z+r >= min_z + m.height as f64*cell {
            return Err("Ezreal E landing outside navigation".into());
        }
        let (left, right) = (((x-r-min_x)/cell).floor() as usize, ((x+r-min_x)/cell).floor() as usize);
        let (top, bottom) = (((z-r-min_z)/cell).floor() as usize, ((z+r-min_z)/cell).floor() as usize);
        if (right-left+1).checked_mul(bottom-top+1).is_none_or(|n| n > MAX_LANDING_CELLS) {
            return Err("Ezreal E landing cell budget exhausted".into());
        }
        for row in top..=bottom { for column in left..=right {
            let cx = min_x + column as f64*cell; let cz = min_z + row as f64*cell;
            let dx = x - x.clamp(cx, cx+cell); let dz = z - z.clamp(cz, cz+cell);
            if dx*dx+dz*dz < r*r && !nav.cells[row*m.width+column].1 {
                return Err("Ezreal E landing terrain blocked".into());
            }
        }}
        for pillar in self.trundle_e_circles() {
            if !pillar.center.finite() || !pillar.radius.is_finite() || pillar.radius <= 0.
                || squared(landing, pillar.center) < (r+f64::from(pillar.radius)).powi(2) {
                return Err("Ezreal E landing pillar blocked".into());
            }
        }
        if targets.iter().any(|(id, target)| *id != owner
            && squared(landing, target.position) < (r+f64::from(target.radius)).powi(2)) {
            return Err("Ezreal E landing occupied".into());
        }
        if player.team > 1 { return Err("Ezreal E owner team invalid".into()); }
        nav.ground(landing).filter(|height| height.is_finite()).ok_or_else(|| "Ezreal E landing ground unavailable".into())
    }
    pub(crate) fn cast_ezreal_e_at(&mut self, id: u32, point: Point) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.champion != "ezreal" || p.id != id || p.team > 1 { return Err("Ezreal E owner invalid".into()); }
        if !p.health.is_finite() || p.health <= 0. { return Err("champion dead".into()); }
        if stuns::active(p, self.tick) { return Err("champion stunned".into()); }
        if trundle_e::champion_forced(p, self.tick) { return Err("champion in forced movement".into()); }
        if self.tick < p.effects.silence_until { return Err("champion silenced".into()); }
        if p.effects.ezreal_q.is_some() || p.effects.ezreal_w.is_some() || self.ezreal_e.pending.contains_key(&id) || self.ezreal_r_casting(id) {
            return Err("skill blocked during cast".into());
        }
        let rule = rules(p.ranks[2])?;
        if self.tick < p.cooldowns[2] { return Err("skill on cooldown".into()); }
        if !p.mana.is_finite() || p.mana < rule.cost { return Err("insufficient mana".into()); }
        if p.windup.as_ref().is_some_and(|windup| !windup.cancelable) {
            return Err("attack windup cannot be cancelled".into());
        }
        if self.ezreal_e.session.is_some_and(|session| session != self.session) {
            return Err("Ezreal E session transition pending".into());
        }
        if self.ezreal_e.pending.len() + self.ezreal_e.bolts.len() >= MAX_CASTS {
            return Err("Ezreal E active cast budget exhausted".into());
        }
        let ordinal = self.ezreal_e.next_ordinal;
        if ordinal == 0 { return Err("Ezreal E ordinal exhausted".into()); }
        let next = ordinal.checked_add(1).ok_or("Ezreal E ordinal exhausted")?;
        let (landing, direction) = clamp_landing(p.position, point)?;
        let facing = entity_facing::Facing::from_direction([direction.x, 0., direction.z])
            .map_err(str::to_owned)?.ok_or("Ezreal E heading unavailable")?;
        let census = self.ezreal_e_census()?;
        self.ezreal_e_landing(id, landing, &census)?;
        let stats = self.stats(id);
        if !stats.ability_power.is_finite() || stats.ability_power < 0. || !stats.cooldown_reduction.is_finite() {
            return Err("invalid Ezreal E cast stats".into());
        }
        let raw = rule.base + rule.ap * stats.ability_power;
        if !raw.is_finite() || raw < 0. { return Err("invalid Ezreal E damage".into()); }
        let cd = cooldown::ticks(rule.cooldown, stats.cooldown_reduction);
        let ready = self.tick.checked_add(cd).ok_or("Ezreal E cooldown clock overflow")?;
        let releases = self.tick.checked_add(WINDUP_TICKS).ok_or("Ezreal E release clock overflow")?;
        let expires = releases.checked_add(FLIGHT_TICKS).ok_or("Ezreal E flight clock overflow")?;
        let pending = Pending { session: self.session, owner: id, team: p.team, ordinal, origin: p.position,
            landing, facing, releases, expires, raw };
        // All fallible work above. Released AA projectiles are never modified.
        self.cancel_attack_presentation(id, attack_presentation::CancelReason::OtherCast);
        let p = self.players.get_mut(&id).unwrap();
        p.mana -= rule.cost; p.cooldowns[2] = ready; p.cooldown_totals[2] = Some(cd);
        p.windup = None; p.attack_roll = None;
        self.ezreal_e.session = Some(self.session); self.ezreal_e.next_ordinal = next;
        self.ezreal_e.pending.insert(id, pending);
        Ok(())
    }
    pub fn ezreal_e_faults(&self) -> Vec<Fault> { self.ezreal_e.faults.iter().cloned().collect() }
    pub(crate) fn clear_ezreal_e_pending(&mut self, owner: u32) { self.ezreal_e.pending.remove(&owner); }
    pub(crate) fn clear_ezreal_e_target(&mut self, target: u32) {
        self.ezreal_e.bolts.retain(|bolt| bolt.target != target);
    }
    pub(crate) fn remove_ezreal_e_owner(&mut self, owner: u32) {
        self.remove_ezreal_e_release_owner(owner);
        self.ezreal_e.pending.remove(&owner);
        self.ezreal_e.bolts.retain(|bolt| bolt.owner != owner && bolt.target != owner);
    }
    pub(crate) fn clear_ezreal_e(&mut self) {
        self.clear_ezreal_e_release_context();
        self.ezreal_e.pending.clear(); self.ezreal_e.bolts.clear();
        self.ezreal_e.session = Some(self.session); self.ezreal_e.last_advanced = None;
    }
    fn ezreal_e_bolt_target(&self, bolt: &Bolt) -> Result<world::Target, String> {
        if bolt.session != self.session || !self.players.get(&bolt.owner)
            .is_some_and(|p| p.id == bolt.owner && p.champion == "ezreal" && p.team == bolt.team) {
            return Err("Ezreal E bolt owner absent or changed".into());
        }
        let target = self.target_info(bolt.target).ok_or("Ezreal E bolt target absent")?;
        if !target.health.is_finite() || target.health <= 0. || target.team == bolt.team
            || target.team > 2 || self.protected(bolt.target)
            || self.units.get(&bolt.target).is_some_and(|u| u.kind.structure()) {
            return Err("Ezreal E bolt target no longer eligible".into());
        }
        if !target.position.finite() || !target.radius.is_finite() || target.radius <= 0.
            || !bolt.position.finite() || !bolt.raw.is_finite() || bolt.raw < 0. {
            return Err("Ezreal E bolt numeric state invalid".into());
        }
        if !self.visible_to(bolt.team, bolt.target) { return Err("Ezreal E bolt target no longer visible".into()); }
        Ok(target)
    }
    /// Once per authoritative tick, after Q/W and before pursuit/ordinary AA.
    /// No catch-up steps or movement on the release tick; skipped release fails.
    pub(crate) fn advance_ezreal_e(&mut self) {
        if self.winner.is_some() || self.ezreal_e.session.is_some_and(|session| session != self.session)
            || self.ezreal_e.last_advanced.is_some_and(|tick| self.tick < tick) {
            self.clear_ezreal_e(); return;
        }
        if self.ezreal_e.last_advanced == Some(self.tick) { return; }
        self.ezreal_e.session = Some(self.session); self.ezreal_e.last_advanced = Some(self.tick);
        self.ezreal_e.releases.prune(self.session,self.tick);
        for mut bolt in std::mem::take(&mut self.ezreal_e.bolts) {
            let result = if self.tick >= bolt.expires { Err("Ezreal E bolt expired".into()) }
                else { self.ezreal_e_bolt_target(&bolt) };
            let target = match result {
                Ok(target) => target,
                Err(reason) => { self.ezreal_e.fault(self.tick, bolt.ordinal, "flight", reason); continue; }
            };
            let dx = f64::from(target.position.x) - f64::from(bolt.position.x);
            let dz = f64::from(target.position.z) - f64::from(bolt.position.z);
            let distance = dx.hypot(dz); let step = f64::from(SPEED) / TICK_RATE as f64;
            if distance <= step + f64::from(target.radius) {
                // Terminal even on Err; only accepted damage notifies the local
                // passive. No on-hit/refund/fallback/retarget is fabricated.
                match self.apply_damage(Some(bolt.owner), bolt.target, bolt.raw, damage::DamageKind::Magical) {
                    Ok(_) => self.accepted_ezreal_ability_contact(bolt.owner,bolt.team,bolt.session),
                    Err(reason) => self.ezreal_e.fault(self.tick, bolt.ordinal, "impact", reason),
                }
            } else {
                bolt.position = Point { x: (f64::from(bolt.position.x) + dx * step / distance) as f32,
                    z: (f64::from(bolt.position.z) + dz * step / distance) as f32 };
                bolt.current=CurrentSample::segment(self.tick,bolt.position,dx,dz,distance);
                if bolt.position.finite() { self.ezreal_e.bolts.push(bolt); }
                else { self.ezreal_e.fault(self.tick, bolt.ordinal, "flight", "Ezreal E bolt step invalid".into()); }
            }
        }
        for (id, pending) in std::mem::take(&mut self.ezreal_e.pending) {
            let reason = self.players.get(&id).map_or(Some("Ezreal E pending owner absent"), |p| {
                if pending.session != self.session || pending.owner != id || p.id != id
                    || p.champion != "ezreal" || p.team != pending.team { Some("Ezreal E pending identity changed") }
                else if !p.health.is_finite() || p.health <= 0. { Some("Ezreal E pending owner dead") }
                else if stuns::active(p, self.tick) || trundle_e::champion_forced(p, self.tick)
                    || self.tick < p.effects.silence_until { Some("Ezreal E pending interrupted by control") }
                else if p.position != pending.origin { Some("Ezreal E pending origin changed") }
                else { None }
            });
            if let Some(reason) = reason {
                self.ezreal_e.fault(self.tick, pending.ordinal, "release", reason.into()); continue;
            }
            if self.tick < pending.releases { self.ezreal_e.pending.insert(id, pending); continue; }
            if self.tick != pending.releases {
                self.ezreal_e.fault(self.tick, pending.ordinal, "release", "Ezreal E release tick skipped".into()); continue;
            }
            let prepared = self.ezreal_e_census().and_then(|census|
                self.ezreal_e_landing(id, pending.landing, &census).map(|height| (census, height)));
            let (census, height) = match prepared {
                Ok(value) => value,
                Err(reason) => { self.ezreal_e.fault(self.tick, pending.ordinal, "release", reason); continue; }
            };
            // Separate frozen audience before the real position commit. No event
            // is published until that commit succeeds; presentation cannot fail it.
            let departure=self.prepare_ezreal_e_release(id,pending.team,pending.ordinal,
                crate::ezreal_e_accepted_releases::Phase::Departure,pending.origin);
            // No fallible landing work remains. Clear both ordinary intent and
            // its cache without resetting the cache's per-actor search budget.
            let p = self.players.get_mut(&id).unwrap();
            p.position = pending.landing; p.height = height;
            p.destination = None; p.target = None; p.path.clear(); p.next_repath = 0;
            p.windup = None; p.attack_roll = None;
            p.facing = Some(pending.facing);
            self.ally_occupancy.clear_order(id);
            let arrival=self.prepare_ezreal_e_release(id,pending.team,pending.ordinal,
                crate::ezreal_e_accepted_releases::Phase::Arrival,pending.landing);
            self.ezreal_e.releases.record(departure);
            self.ezreal_e.releases.record(arrival);
            // Existing team visibility now evaluates the actual landed actor.
            // The private census carries no newly exposed wire metadata.
            let target = census.iter().filter(|(target, info)| *target != id && info.team != pending.team
                && !self.units.get(target).is_some_and(|unit| unit.kind.structure()) && !self.protected(*target)
                && squared(pending.landing, info.position) <= f64::from(ACQUISITION_RANGE).powi(2)
                && self.visible_to(pending.team, *target))
                .min_by(|(a, ta), (b, tb)| squared(pending.landing, ta.position)
                    .total_cmp(&squared(pending.landing, tb.position)).then(a.cmp(b)))
                .map(|(id, info)| (*id,info.position));
            if let Some((target,target_position)) = target {
                let dx=f64::from(target_position.x)-f64::from(pending.landing.x);
                let dz=f64::from(target_position.z)-f64::from(pending.landing.z);
                let current=CurrentSample::segment(self.tick,pending.landing,dx,dz,dx.hypot(dz));
                self.ezreal_e.bolts.push(Bolt { session: pending.session, owner: id, team: pending.team,
                    ordinal: pending.ordinal, target, position: pending.landing, expires: pending.expires, raw: pending.raw, current });
            }
        }
    }
}

#[cfg(test)]
#[path = "ezreal_e_tests.rs"]
mod tests;

impl Simulation {
    /// LOCAL current Bolt sample. The private sample is stamped by the actual
    /// release/move; this read-only projection never looks up the homing target.
    pub(crate) fn ezreal_e_current_projection(&self,viewer:u32)->Option<serde_json::Value> {
        let viewer=self.players.get(&viewer).filter(|p|p.id==viewer && p.team<=1)?;
        let terrain=self.map10_cast_ground?;
        if self.winner.is_some() || self.ezreal_e.session!=Some(self.session)
            || self.ezreal_e.next_ordinal==0 || self.ezreal_e.last_advanced!=Some(self.tick)
            || self.ezreal_e.pending.len().checked_add(self.ezreal_e.bolts.len()).is_none_or(|n|n>MAX_CASTS){return None;}
        let canonical=|owner,team|self.players.get(&owner).is_some_and(|p|
            owner!=0 && team<=1 && p.id==owner && p.champion=="ezreal" && p.team==team);
        let mut seen=std::collections::BTreeSet::new();
        for (&owner,p) in &self.ezreal_e.pending {
            if p.session!=self.session || p.owner!=owner || !canonical(owner,p.team)
                || p.ordinal==0 || p.ordinal>=self.ezreal_e.next_ordinal || !seen.insert(p.ordinal)
                || !p.origin.finite() || !p.landing.finite() || !p.raw.is_finite() || p.raw<0.
                || squared(p.origin,p.landing)>f64::from(BLINK_RANGE).powi(2)
                || entity_facing::Facing::from_yaw(p.facing.yaw_degrees()).is_err()
                || p.releases.checked_sub(WINDUP_TICKS).is_none_or(|start|start>self.tick)
                || p.releases<=self.tick || p.releases.checked_add(FLIGHT_TICKS)!=Some(p.expires){return None;}
        }
        for b in &self.ezreal_e.bolts {
            if b.session!=self.session || !canonical(b.owner,b.team) || b.ordinal==0
                || b.ordinal>=self.ezreal_e.next_ordinal || !seen.insert(b.ordinal)
                || !b.position.finite() || !b.raw.is_finite() || b.raw<0. || b.expires<=self.tick
                || b.expires.checked_sub(FLIGHT_TICKS).is_none_or(|release|release>self.tick){return None;}
            if let Some(c)=b.current {
                if c.tick!=self.tick || c.position!=b.position || !c.direction.finite()
                    || (c.direction.x.hypot(c.direction.z)-1.).abs()>0.0001{return None;}
            }
        }
        let mut rows=Vec::new();
        for b in &self.ezreal_e.bolts {
            let Some(c)=b.current else{continue;};
            if !self.visible_point_to(viewer.team,c.position){continue;}
            let Ok(y_native)=terrain.sample_local_f32([c.position.x,c.position.z]) else{continue;};
            if !y_native.is_finite(){continue;}
            rows.push(crate::ezreal_e_projectile_view::Row{owner:b.owner,team:b.team,ordinal:b.ordinal,
                position:c.position,y_native,direction:c.direction});
        }
        rows.sort_by_key(|r|(r.owner,r.ordinal));
        crate::ezreal_e_projectile_view::encode(rows)
    }
}
#[cfg(test)]
#[path="ezreal_e_presentation_tests.rs"]
mod presentation_tests;

/// Current body-visible, interruptible E windup only. No landing, origin, target or bolt.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct VisibleCast {
    pub session: u64, pub owner: u32, pub team: u8, pub ordinal: u64,
    pub releases: u64, pub facing: entity_facing::Facing,
}
impl Simulation {
    pub(crate) fn ezreal_e_cast_projection(&self, viewer: u32) -> Vec<VisibleCast> {
        let Some(viewer) = self.players.get(&viewer).filter(|p| p.id == viewer && p.team <= 1)
            else { return Vec::new(); };
        if self.winner.is_some() || self.ezreal_e.session != Some(self.session)
            || self.ezreal_e.next_ordinal == 0
            || self.ezreal_e.last_advanced.is_some_and(|tick| self.tick < tick)
            || self.ezreal_e.pending.len().checked_add(self.ezreal_e.bolts.len())
                .is_none_or(|count| count > MAX_CASTS) { return Vec::new(); }
        let mut rows = Vec::new(); let mut seen = std::collections::BTreeSet::new();
        for (&owner, pending) in &self.ezreal_e.pending {
            let Some(started) = pending.releases.checked_sub(WINDUP_TICKS) else { return Vec::new(); };
            let Some(player) = self.players.get(&owner) else { return Vec::new(); };
            if owner == 0 || player.id != owner || pending.owner != owner || pending.session != self.session
                || pending.team > 1 || player.team != pending.team || player.champion != "ezreal"
                || pending.ordinal == 0 || pending.ordinal >= self.ezreal_e.next_ordinal || !seen.insert(pending.ordinal)
                || pending.releases.checked_add(FLIGHT_TICKS) != Some(pending.expires)
                || !pending.origin.finite() || !pending.landing.finite() || !player.position.finite()
                || !player.health.is_finite() || !pending.raw.is_finite() || pending.raw < 0.
                || entity_facing::Facing::from_yaw(pending.facing.yaw_degrees()).is_err()
                || squared(pending.origin, pending.landing) > f64::from(BLINK_RANGE).powi(2) {
                return Vec::new();
            }
            // Match the existing pending validity at advance_ezreal_e, even when
            // this snapshot precedes that phase. Projection never mutates it.
            if self.tick < started || self.tick >= pending.releases || player.health <= 0.
                || player.position != pending.origin || stuns::active(player, self.tick)
                || trundle_e::champion_forced(player, self.tick) || self.tick < player.effects.silence_until
                || !self.visible_to(viewer.team, owner) { continue; }
            rows.push(VisibleCast { session: pending.session, owner, team: pending.team,
                ordinal: pending.ordinal, releases: pending.releases, facing: pending.facing });
        }
        rows
    }
}
