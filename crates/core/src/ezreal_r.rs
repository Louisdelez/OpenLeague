//! Partial LOCAL Trueshot Barrage4.20, not recovered native server callbacks.
//! Primary4.20.1:350/500/650 +1.0bonusAD +0.9AP magic,100mana,80s,range20000.
//! Root-approved policies:30paid interruptible ticks; speed2000, radius80 from
//! declared LineWidth160; private Pierce, damage decay10percentage points only
//! AFTER damageOk, floor30%. Cast stats freeze; defenses/Exhaust at contact.
//! Hidden targets may be hit. Released-missile projection is current-point-only.
//! Visible windup facts may drive a separate client animation consumer.
//! No rendered R animation,VFX,audio or native timing/parity is supplied here.
use crate::*;
use crate::linear_skillshot::{Circle, Identity, Limits, Mode, Params, Phase, Shot};
use std::sync::OnceLock;

pub const WINDUP_TICKS: u64 = 30;
pub const RANGE: f32 = 20000.;
pub const SPEED: f32 = 2000.;
pub const RADIUS: f32 = 80.;
pub const MAX_CASTS: usize = 64;
/// Named local reconstruction, not a native timing or server-value claim.
pub const CURRENT_HEIGHT_POLICY: &str = crate::ezreal_r_vertical_local::POLICY;
pub const MAX_TARGETS: usize = 2048;
const FLIGHT_TICKS: u64 = 301; // Exclusive TTL; movement starts at release+1.
const MAX_FAULTS: usize = 32;

#[derive(Debug, Clone, Copy)]
pub struct Rank { pub base: f32, pub cost: f32, pub cooldown: f32, pub ap: f32, pub bonus_ad: f32 }
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fault { pub tick: u64, pub ordinal: u64, pub stage: &'static str, pub reason: String }
/// Private local cast-start ground capture, not a bone pose or missile height.
/// No serialization: neither this history nor its failure enters a Snapshot.
#[derive(Debug, Clone, Copy, PartialEq)]
struct CastGroundSeed {
    position: [f32; 3],
    captured_tick: u64,
    facing: entity_facing::Facing,
}
#[derive(Debug, Clone, PartialEq)]
enum CastGroundUnavailable {
    ContextDisabled,
    Terrain(dense_height_grid::Error),
}
fn capture_cast_ground(
    context: Option<&map10_dense_height::Binding>, origin: Point,
    captured_tick: u64, facing: entity_facing::Facing,
) -> Result<CastGroundSeed, CastGroundUnavailable> {
    let context = context.ok_or(CastGroundUnavailable::ContextDisabled)?;
    let height = context.sample_local_f32([origin.x, origin.z])
        .map_err(CastGroundUnavailable::Terrain)?;
    Ok(CastGroundSeed { position: [origin.x, height, origin.z], captured_tick, facing })
}
#[derive(Debug, Clone, PartialEq)]
enum VerticalUnavailable {
    CastGround(CastGroundUnavailable),
    Calculation(ezreal_r_vertical_local::Error),
}
fn capture_vertical_release(
    seed: &Result<CastGroundSeed, CastGroundUnavailable>,
    context: Option<&map10_dense_height::Binding>, actor_root_y: f32,
    identity: Identity, releases: u64, aim: Point,
) -> Result<ezreal_r_vertical_local::FlightHeight, VerticalUnavailable> {
    let seed = seed.as_ref().map_err(|error| VerticalUnavailable::CastGround(error.clone()))?;
    let context = context.ok_or(VerticalUnavailable::CastGround(CastGroundUnavailable::ContextDisabled))?;
    ezreal_r_vertical_local::FlightHeight::prepare(identity, releases, seed.position,
        actor_root_y, seed.facing, aim, RANGE, context.grid()).map_err(VerticalUnavailable::Calculation)
}
#[derive(Debug)]
struct Flight {
    shot: Shot, raw: f32, accepted_hits: usize, direction: Point,
    cast_ground_seed: Result<CastGroundSeed, CastGroundUnavailable>,
    vertical: Result<ezreal_r_vertical_local::FlightHeight, VerticalUnavailable>,
}
#[derive(Debug)]
struct Pending { flight: Flight, origin: Point, releases: u64 }
#[derive(Debug)]
pub(crate) struct State {
    session: Option<u64>, next_ordinal: u64, last_advanced: Option<u64>,
    pending: BTreeMap<u32, Pending>, flights: Vec<Flight>, faults: VecDeque<Fault>,
    pub(crate) impacts: crate::ezreal_r_accepted_impacts::State,
    pub(crate) cast_audio: crate::ezreal_r_accepted_casts::State,
}
impl Default for State {
    fn default() -> Self { Self { session: None, next_ordinal: 1, last_advanced: None,
        pending: BTreeMap::new(), flights: Vec::new(), faults: VecDeque::new(),
        impacts: Default::default(), cast_audio: Default::default() } }
}
impl State {
    fn fault(&mut self, tick: u64, ordinal: u64, stage: &'static str, reason: String) {
        if self.faults.len() == MAX_FAULTS { self.faults.pop_front(); }
        self.faults.push_back(Fault { tick, ordinal, stage, reason });
    }
}
fn parse(text: &str) -> Result<[Rank; 3], String> {
    let rows: serde_json::Value = serde_json::from_str(text).map_err(|e| e.to_string())?;
    let rows = rows.as_array().ok_or("Ezreal R native table must be an array")?;
    let matches: Vec<_> = rows.iter().filter(|row| row["champion"].as_str()
        .is_some_and(|name| name.eq_ignore_ascii_case("ezreal")) && row["slot"].as_u64() == Some(3)).collect();
    if matches.len() != 1 || matches[0]["spell"] != "EzrealTrueshotBarrage" {
        return Err("unique primary Ezreal R resource required".into());
    }
    let values = &matches[0]["values"];
    let number = |key: &str| -> Result<f32, String> {
        let v = &values[key];
        v.as_f64().map(|n| n as f32).or_else(|| v.as_str().and_then(|n| n.parse().ok()))
            .filter(|n: &f32| n.is_finite()).ok_or_else(|| format!("Ezreal R numeric field invalid: {key}"))
    };
    if (number("Coefficient")? - 0.9).abs() > 0.000001 || number("CastRange")? != RANGE
        || number("MissileSpeed")? != SPEED || number("LineWidth")? != 160. {
        return Err("Ezreal R admitted coefficient/range/missile declarations changed".into());
    }
    let mut ranks = Vec::with_capacity(3);
    for i in 0..3 {
        let n = i + 1;
        // +1bonusAD and +0.9AP are primary DDragon4.20.1 vars, archived506aeafd.
        // Inherited Coefficient2=0 does not erase the primary bonusAD variable.
        let rank = Rank { base: number(&format!("Effect1Level{n}Amount"))?,
            cost: number(&format!("ManaCost{n}"))?, cooldown: number(&format!("Cooldown{n}"))?, ap: 0.9, bonus_ad: 1. };
        if rank.base != [350.,500.,650.][i] || rank.cost != 100. || rank.cooldown != 80.
            || number(&format!("Effect2Level{n}Amount"))? != 10.
            || number(&format!("Effect3Level{n}Amount"))? != 30. {
            return Err("Ezreal R primary ranks changed".into());
        }
        ranks.push(rank);
    }
    ranks.try_into().map_err(|_| "Ezreal R requires three ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=3).contains(&rank) { return Err("Ezreal R rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 3], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|ranks| ranks[rank as usize - 1]).map_err(Clone::clone)
}
fn attenuation(accepted_hits: usize) -> f32 { (1. - 0.10 * accepted_hits.min(7) as f32).max(0.30) }
impl Simulation {
    pub(crate) fn ezreal_r_casting(&self, owner: u32) -> bool {
        self.ezreal_r.session == Some(self.session) && self.ezreal_r.pending.contains_key(&owner)
    }
    fn ezreal_r_circles(&self, team: u8) -> Result<Vec<Circle>, String> {
        if self.players.len().checked_add(self.units.len()).is_none_or(|n| n > MAX_TARGETS) {
            return Err("Ezreal R target census exceeds budget".into());
        }
        let mut circles = Vec::new();
        for id in self.players.keys().chain(self.units.keys()).copied() {
            if self.players.get(&id).is_some_and(|p| p.id != id || p.team > 1)
                || self.units.get(&id).is_some_and(|u| u.id != id || u.team > 2)
                || self.players.contains_key(&id) && self.units.contains_key(&id) {
                return Err("Ezreal R target identity invalid".into());
            }
            let target = self.target_info(id).ok_or("Ezreal R target collision absent")?;
            if !target.health.is_finite() { return Err("Ezreal R target health invalid".into()); }
            if target.health <= 0. || target.team == team || self.protected(id)
                || self.units.get(&id).is_some_and(|u| u.kind.structure()) { continue; }
            if !target.position.finite() || !target.radius.is_finite() || target.radius <= 0. {
                return Err("Ezreal R target collision invalid".into());
            }
            // No visible_to check. Damage authority is independent of presentation FoW.
            circles.push(Circle { id, center: target.position, radius: target.radius });
        }
        Ok(circles)
    }
    pub(crate) fn cast_ezreal_r_at(&mut self, id: u32, point: Point) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.id != id || p.champion != "ezreal" || p.team > 1 { return Err("Ezreal R owner invalid".into()); }
        if !p.health.is_finite() || p.health <= 0. { return Err("champion dead".into()); }
        if stuns::active(p, self.tick) { return Err("champion stunned".into()); }
        if trundle_e::champion_forced(p, self.tick) { return Err("champion in forced movement".into()); }
        if self.tick < p.effects.silence_until { return Err("champion silenced".into()); }
        if p.effects.ezreal_q.is_some() || p.effects.ezreal_w.is_some()
            || self.ezreal_e_casting(id) || self.ezreal_r.pending.contains_key(&id) {
            return Err("skill blocked during cast".into());
        }
        let rank = rules(p.ranks[3])?;
        if self.tick < p.cooldowns[3] { return Err("skill on cooldown".into()); }
        if !p.mana.is_finite() || p.mana < rank.cost { return Err("insufficient mana".into()); }
        if p.windup.as_ref().is_some_and(|w| !w.cancelable) { return Err("attack windup cannot be cancelled".into()); }
        if self.ezreal_r.session.is_some_and(|s| s != self.session) { return Err("Ezreal R session transition pending".into()); }
        if self.ezreal_r.pending.len() + self.ezreal_r.flights.len() >= MAX_CASTS { return Err("Ezreal R active cast budget exhausted".into()); }
        let ordinal = self.ezreal_r.next_ordinal;
        if ordinal == 0 { return Err("Ezreal R ordinal exhausted".into()); }
        let next = ordinal.checked_add(1).ok_or("Ezreal R ordinal exhausted")?;
        let stats = self.stats(id); let ad = self.attack_damage_components(id)?;
        if !stats.ability_power.is_finite() || !stats.cooldown_reduction.is_finite()
            || !ad.total.is_finite() || !ad.level_base.is_finite() || !ad.bonus.is_finite() {
            return Err("invalid Ezreal R cast stats".into());
        }
        let sum = rank.base + rank.bonus_ad * ad.bonus + rank.ap * stats.ability_power;
        if !sum.is_finite() { return Err("invalid Ezreal R damage".into()); }
        let raw = sum.max(0.); // Signed bonus is retained until this final clamp.
        let cd = cooldown::ticks(rank.cooldown, stats.cooldown_reduction);
        let ready = self.tick.checked_add(cd).ok_or("Ezreal R cooldown clock overflow")?;
        let releases = self.tick.checked_add(WINDUP_TICKS).ok_or("Ezreal R release clock overflow")?;
        let expires = releases.checked_add(FLIGHT_TICKS).ok_or("Ezreal R flight clock overflow")?;
        let identity = Identity { session: self.session, owner: id, team: p.team, ordinal };
        let shot = Shot::new(identity, p.position, point, Params { speed_units_per_second: SPEED,
            tick_rate: TICK_RATE as u32, max_distance: RANGE, projectile_radius: RADIUS,
            launch_tick: releases, expires_at_tick: expires, mode: Mode::Pierce,
            limits: Limits { targets_per_step: MAX_TARGETS, unique_hits: MAX_TARGETS } })
            .map_err(|e| format!("Ezreal R geometry: {e:?}"))?;
        self.ezreal_r_circles(p.team)?;
        let dx = f64::from(point.x) - f64::from(p.position.x); let dz = f64::from(point.z) - f64::from(p.position.z);
        let length = dx.hypot(dz);
        let facing = entity_facing::Facing::from_direction([(dx/length) as f32,0.,(dz/length) as f32])
            .map_err(str::to_owned)?.ok_or("Ezreal R heading unavailable")?;
        // Optional presentation data cannot change acceptance or 2D gameplay.
        // Capture once before mutations; keep absence/error distinct from height0.
        let cast_ground_seed = capture_cast_ground(self.map10_cast_ground, p.position, self.tick, facing);
        let cast_ground_fault = match &cast_ground_seed {
            Err(CastGroundUnavailable::Terrain(error)) => Some(format!("Map10 cast-ground unavailable: {error}")),
            _ => None, // Disabled is the intentional generic-simulation policy.
        };
        // Root Y belongs to the rendered actor, NOT the dense cast-ground Y.
        // Freeze the explicit clip41@1s policy before accepted-cast mutations.
        let vertical = capture_vertical_release(&cast_ground_seed, self.map10_cast_ground,
            p.height, identity, releases, point);
        let vertical_fault = match &vertical {
            Err(VerticalUnavailable::Calculation(error)) => Some(error.to_string()),
            _ => None, // Seed failure is already diagnosed once above.
        };
        let pending = Pending { flight: Flight { shot, raw, accepted_hits: 0,
            direction: Point { x: (dx/length) as f32, z: (dz/length) as f32 },
            cast_ground_seed, vertical }, origin: p.position, releases };
        // Freeze each view before accepted gameplay mutations. No extra cue on release/hit.
        let cast_audio = self.prepare_ezreal_r_accepted_cast(id, identity.team, ordinal, pending.origin);
        // All fallible work above. Retain already released AA projectiles.
        self.cancel_attack_presentation(id, attack_presentation::CancelReason::OtherCast);
        let p = self.players.get_mut(&id).unwrap();
        p.mana -= rank.cost; p.cooldowns[3] = ready; p.cooldown_totals[3] = Some(cd);
        p.windup = None; p.attack_roll = None; p.target = None; p.destination = None; p.path.clear();
        p.facing = Some(facing); self.ally_occupancy.clear_order(id);
        self.ezreal_r.session = Some(self.session); self.ezreal_r.next_ordinal = next;
        self.ezreal_r.pending.insert(id, pending);
        self.ezreal_r.cast_audio.record(cast_audio); // after authoritative acceptance only
        if let Some(reason) = cast_ground_fault {
            self.ezreal_r.fault(self.tick, ordinal, "cast_ground_seed", reason);
        }
        if let Some(reason) = vertical_fault {
            self.ezreal_r.fault(self.tick, ordinal, "vertical_release", reason);
        }
        Ok(())
    }
    pub fn ezreal_r_faults(&self) -> Vec<Fault> { self.ezreal_r.faults.iter().cloned().collect() }
    pub(crate) fn clear_ezreal_r_pending(&mut self, owner: u32) { self.ezreal_r.pending.remove(&owner); }
    pub(crate) fn remove_ezreal_r_owner(&mut self, owner: u32) {
        self.remove_ezreal_r_impact_owner(owner);
        self.remove_ezreal_r_cast_audio_owner(owner);
        self.ezreal_r.pending.remove(&owner); self.ezreal_r.flights.retain(|f| f.shot.view().identity.owner != owner);
    }
    pub(crate) fn clear_ezreal_r(&mut self) {
        self.clear_ezreal_r_impact_context();
        self.clear_ezreal_r_cast_audio_context();
        self.ezreal_r.pending.clear(); self.ezreal_r.flights.clear();
        self.ezreal_r.session = Some(self.session); self.ezreal_r.last_advanced = None;
    }
    /// Once after Q/W/E, before pursuit/motion/AA. No catch-up or launch-tick step.
    pub(crate) fn advance_ezreal_r(&mut self) {
        if self.winner.is_some() || self.ezreal_r.session.is_some_and(|s| s != self.session)
            || self.ezreal_r.last_advanced.is_some_and(|t| self.tick < t) { self.clear_ezreal_r(); return; }
        if self.ezreal_r.last_advanced == Some(self.tick) { return; }
        self.ezreal_r.last_advanced = Some(self.tick);
        for mut flight in std::mem::take(&mut self.ezreal_r.flights) {
            let identity = flight.shot.view().identity;
            if identity.session != self.session || !self.players.get(&identity.owner)
                .is_some_and(|p| p.id == identity.owner && p.champion == "ezreal" && p.team == identity.team) { continue; }
            // Released R survives owner death; passive notification rejects a dead owner.
            let circles = match self.ezreal_r_circles(identity.team) {
                Ok(v) => v, Err(e) => { self.ezreal_r.fault(self.tick, identity.ordinal,"census",e); continue; }
            };
            let step = match flight.shot.advance(identity,self.tick,&circles) {
                Ok(v) => v, Err(e) => { self.ezreal_r.fault(self.tick,identity.ordinal,"advance",format!("{e:?}")); continue; }
            };
            for contact in &step.contacts {
                let raw = flight.raw * attenuation(flight.accepted_hits);
                // Freeze contact points and each view before damage can kill,
                // remove or reveal actors. This never changes damage acceptance.
                let accepted_impact = self.prepare_ezreal_r_accepted_impact(identity.owner, identity.team,
                    contact.id, contact.projectile_center, contact.target_center);
                match self.apply_damage(Some(identity.owner),contact.id,raw,damage::DamageKind::Magical) {
                    Ok(_) => {
                        flight.accepted_hits += 1; // <= unique contact budget2048.
                        self.accepted_ezreal_ability_contact(identity.owner,identity.team,identity.session);
                        self.record_ezreal_r_accepted_impact(accepted_impact);
                    }
                    Err(e) => self.ezreal_r.fault(self.tick,identity.ordinal,"impact",e),
                }
                // Geometry consumed this target even on Err. Do not retry it,
                // increment attenuation, grant passive or roll back earlier Ok.
            }
            if step.phase == Phase::Flying {
                // Independent presentation state: height failure retires only Y,
                // never the paid shot, its collision result or accepted damage.
                let vertical_error = if let Ok(height) = &mut flight.vertical {
                    match self.map10_cast_ground {
                        Some(context) => height.advance(identity, self.tick, step.to, context.grid())
                            .err().map(VerticalUnavailable::Calculation),
                        None => Some(VerticalUnavailable::CastGround(CastGroundUnavailable::ContextDisabled)),
                    }
                } else { None };
                if let Some(error) = vertical_error {
                    self.ezreal_r.fault(self.tick, identity.ordinal, "vertical_update", format!("{error:?}"));
                    flight.vertical = Err(error);
                }
                self.ezreal_r.flights.push(flight);
            }
        }
        for (id,pending) in std::mem::take(&mut self.ezreal_r.pending) {
            let identity = pending.flight.shot.view().identity;
            let reason = self.players.get(&id).map_or(Some("Ezreal R pending owner absent"),|p| {
                if identity.session != self.session || identity.owner != id || p.id != id
                    || p.champion != "ezreal" || p.team != identity.team { Some("Ezreal R pending identity changed") }
                else if !p.health.is_finite() || p.health <= 0. { Some("Ezreal R pending owner dead") }
                else if stuns::active(p,self.tick) || trundle_e::champion_forced(p,self.tick)
                    || self.tick < p.effects.silence_until { Some("Ezreal R pending interrupted by control") }
                else if p.position != pending.origin { Some("Ezreal R pending origin changed") }
                else { None }
            });
            if let Some(e) = reason { self.ezreal_r.fault(self.tick,identity.ordinal,"release",e.into()); continue; }
            if self.tick < pending.releases { self.ezreal_r.pending.insert(id,pending); continue; }
            if self.tick != pending.releases {
                self.ezreal_r.fault(self.tick,identity.ordinal,"release","Ezreal R release tick skipped".into()); continue;
            }
            self.ezreal_r.flights.push(pending.flight);
        }
    }
}
/// Partial LOCAL R presentation. This is a current visible sample, never a
/// launch event: no origin, age, travel/expiry, damage, contact or target data.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct VisibleMissile {
    pub session: u64,
    pub owner: u32,
    pub team: u8,
    pub ordinal: u64,
    pub position: Point,
    pub direction: Point,
}

/// Current visible caster windup, not a launch/replay event. No origin, target,
/// damage, contacts or private travel history crosses this separate channel.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct VisibleCast {
    pub session: u64,
    pub owner: u32,
    pub team: u8,
    pub ordinal: u64,
    pub releases: u64,
    pub direction: Point,
}

impl Simulation {
    /// Read-only audience of a currently pending cast. Body visibility is
    /// required even when a released missile could be visible elsewhere.
    pub(crate) fn ezreal_r_cast_projection(&self, viewer: u32) -> Vec<VisibleCast> {
        let Some(viewer) = self.players.get(&viewer).filter(|p| p.id == viewer && p.team <= 1)
            else { return Vec::new(); };
        if self.winner.is_some() || self.ezreal_r.session != Some(self.session)
            || self.ezreal_r.next_ordinal == 0
            || self.ezreal_r.last_advanced.is_some_and(|tick| self.tick < tick)
            || self.ezreal_r.pending.len().checked_add(self.ezreal_r.flights.len())
                .is_none_or(|count| count > MAX_CASTS) { return Vec::new(); }
        let mut rows = Vec::new();
        let mut seen = std::collections::BTreeSet::new();
        for (&owner, pending) in &self.ezreal_r.pending {
            let view = pending.flight.shot.view();
            let id = view.identity;
            let Some(started) = pending.releases.checked_sub(WINDUP_TICKS) else { return Vec::new(); };
            let Some(player) = self.players.get(&owner) else { return Vec::new(); };
            // Validate the complete bounded private census before disclosing
            // any rows. A corrupt/duplicate hidden entry cannot leave a prefix.
            if owner == 0 || id.owner != owner || id.session != self.session
                || id.team > 1 || player.id != owner || player.team != id.team
                || player.champion != "ezreal" || id.ordinal == 0
                || id.ordinal >= self.ezreal_r.next_ordinal || !seen.insert(id.ordinal)
                || pending.releases.checked_add(FLIGHT_TICKS).is_none()
                || view.phase != Phase::Flying || view.last_tick != pending.releases
                || view.traveled != 0. || view.unique_hits != 0
                || !pending.origin.finite() || view.position != pending.origin
                || !player.position.finite() || !player.health.is_finite()
                || !pending.flight.raw.is_finite() || pending.flight.raw < 0.
                || pending.flight.accepted_hits != 0 || !pending.flight.direction.finite()
                || (pending.flight.direction.x.hypot(pending.flight.direction.z) - 1.).abs() > 0.0001 {
                return Vec::new();
            }
            // Normal retirement/interruption is not corruption. Projection does
            // not perform the destructive retirement or advance the pending shot.
            if self.tick < started || self.tick >= pending.releases || player.health <= 0.
                || stuns::active(player, self.tick) || trundle_e::champion_forced(player, self.tick)
                || self.tick < player.effects.silence_until || player.position != pending.origin
                || !self.visible_to(viewer.team, owner) { continue; }
            rows.push(VisibleCast { session: id.session, owner, team: id.team,
                ordinal: id.ordinal, releases: pending.releases, direction: pending.flight.direction });
        }
        // BTreeMap iteration already orders owners; preserve that stable order.
        rows
    }

    /// Point-only LOCAL audience, identical for allied/enemy missiles. The
    /// owner is validated privately; its body need not be in the viewer's FoW.
    /// Querying this function never advances the shot or applies a contact.
    pub(crate) fn ezreal_r_projection(&self, viewer: u32) -> Vec<VisibleMissile> {
        let Some(viewer) = self.players.get(&viewer).filter(|p| p.id == viewer && p.team <= 1) else { return Vec::new(); };
        if self.winner.is_some() || self.ezreal_r.session != Some(self.session)
            || self.ezreal_r.flights.len() > MAX_CASTS { return Vec::new(); }
        let mut rows = Vec::new();
        let mut seen = std::collections::BTreeSet::new();
        for flight in &self.ezreal_r.flights {
            let view = flight.shot.view(); let id = view.identity;
            if id.session != self.session || id.ordinal == 0 || id.team > 1
                || view.phase != Phase::Flying || view.last_tick != self.tick
                || !self.players.get(&id.owner).is_some_and(|p|
                    p.id == id.owner && p.champion == "ezreal" && p.team == id.team)
                || !view.position.finite() || !flight.direction.finite()
                || (flight.direction.x.hypot(flight.direction.z) - 1.).abs() > 0.0001
                || !self.visible_point_to(viewer.team, view.position) { continue; }
            if !seen.insert((id.owner, id.ordinal)) { return Vec::new(); }
            rows.push(VisibleMissile { session: id.session, owner: id.owner, team: id.team,
                ordinal: id.ordinal, position: view.position, direction: flight.direction });
        }
        rows.sort_by_key(|row| (row.owner, row.ordinal));
        rows
    }
}

#[cfg(test)]
#[path = "ezreal_r_tests.rs"]
mod tests;

impl Simulation {
    /// Attach only finite current height to the already-authorized R rows.
    /// No origin, pose, delta, endpoint or cast/release history crosses this boundary.
    pub(crate) fn ezreal_r_current_height_projection(&self, viewer: u32, authorized: &[VisibleMissile]) -> Option<serde_json::Value> {
        let viewer = self.players.get(&viewer).filter(|p| p.id == viewer && p.team <= 1)?;
        if self.winner.is_some() || self.ezreal_r.session != Some(self.session)
            || self.ezreal_r.flights.len() > MAX_CASTS || authorized.len() > MAX_CASTS { return None; }
        let mut rows = Vec::new();
        let mut seen = std::collections::BTreeSet::new();
        for row in authorized {
            if row.session != self.session || row.team > 1 || row.ordinal == 0 || !row.position.finite()
                || !seen.insert((row.owner, row.ordinal)) { return None; }
            if !self.visible_point_to(viewer.team, row.position) { return None; }
            let mut matches = self.ezreal_r.flights.iter().filter(|f| {
                let id = f.shot.view().identity;
                id.session == row.session && id.owner == row.owner && id.team == row.team && id.ordinal == row.ordinal
            });
            let flight = matches.next()?;
            if matches.next().is_some() { return None; }
            let view = flight.shot.view();
            if view.phase != Phase::Flying || view.last_tick != self.tick || view.position != row.position
                || flight.direction != row.direction { return None; }
            let Some(y_native) = flight.vertical.as_ref().ok()
                .and_then(|v| v.current_y(view.identity, self.tick, row.position)) else { continue; };
            if !y_native.is_finite() { continue; }
            rows.push(serde_json::json!({"owner":row.owner,"team":row.team,"ordinal":row.ordinal,"y_native":y_native}));
        }
        if rows.is_empty() { None }
        else { Some(serde_json::json!({"policy":CURRENT_HEIGHT_POLICY,"rows":rows})) }
    }
}

#[cfg(test)]
#[path = "ezreal_r_current_height_tests.rs"]
mod current_height_tests;
