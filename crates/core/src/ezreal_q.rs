//! PARTIAL local reconstruction of Ezreal Q; no native server parity claim.
//! Primary 4.20 client numbers select damage/cost/CD. EXTRA speed2000/range1200
//! and LineWidth60 AS RADIUS are an explicit local/community-consumer choice.
//! Eight ticks of committed windup, frozen cast origin/direction/raw damage,
//! fixed target centres per tick, no terrain collision, and FirstContact are
//! local policies. Item on-hit hooks remain open; consumed damageOk notifies the local passive.
use crate::*;
use crate::linear_skillshot::{Circle, Identity, Limits, Mode, Params, Phase, Shot};
use std::sync::OnceLock;

pub const WINDUP_TICKS: u64 = 8;
pub const RANGE: f32 = 1200.;
pub const SPEED: f32 = 2000.;
pub const RADIUS: f32 = 60.;
pub const REFUND_TICKS: u64 = TICK_RATE;
// Local safety budgets, not native gameplay constants. Never truncate targets.
pub const MAX_CASTS: usize = 64;
pub const MAX_TARGETS: usize = 2048;
const FLIGHT_TICKS: u64 = 18; //1200/(2000/30), then exclusive expiry at launch+19.
const MAX_FAULTS: usize = 32;

/// Presentation/lock only. Private State owns the prepared authoritative shot.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CastLock { pub releases: u64, pub direction: Point }

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct VisibleMissile {
    pub session: u64, pub owner: u32, pub team: u8, pub ordinal: u64,
    pub position: Point, pub direction: Point, pub launched: u64,
}

/// Bounded server diagnostic, not a client gameplay or native event.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fault { pub tick: u64, pub ordinal: u64, pub stage: &'static str, pub reason: String }

#[derive(Debug)]
struct Flight { shot: Shot, raw: f32, direction: Point, launched: u64 }
#[derive(Debug)]
struct Pending { flight: Flight, releases: u64 }
#[derive(Debug)]
pub(crate) struct State {
    session: Option<u64>, next_ordinal: u64, last_advanced: Option<u64>,
    pending: BTreeMap<u32, Pending>, flights: Vec<Flight>, faults: VecDeque<Fault>,
    pub(crate) impacts: crate::ezreal_q_accepted_impacts::State,
}
impl Default for State {
    fn default() -> Self {
        Self { session: None, next_ordinal: 1, last_advanced: None,
            pending: BTreeMap::new(), flights: Vec::new(), faults: VecDeque::new(),
            impacts: Default::default() }
    }
}
impl State {
    fn fault(&mut self, tick: u64, ordinal: u64, stage: &'static str, reason: String) {
        if self.faults.len() == MAX_FAULTS { self.faults.pop_front(); }
        self.faults.push_back(Fault { tick, ordinal, stage, reason });
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Rank { pub base: f32, pub cost: f32, pub cooldown: f32, pub ad: f32, pub ap: f32 }
fn parse(text: &str) -> Result<[Rank; 5], String> {
    let rows: serde_json::Value = serde_json::from_str(text).map_err(|e| e.to_string())?;
    let rows = rows.as_array().ok_or("Ezreal Q native table must be an array")?;
    let matches: Vec<_> = rows.iter().filter(|r| r["champion"].as_str()
        .is_some_and(|c| c.eq_ignore_ascii_case("ezreal")) && r["slot"].as_u64() == Some(0)).collect();
    if matches.len() != 1 || matches[0]["spell"] != "EzrealMysticShot" {
        return Err("unique primary Ezreal Q resource required".into());
    }
    let values = &matches[0]["values"];
    let number = |key: &str| -> Result<f32, String> {
        let n = &values[key];
        let n = n.as_f64().map(|v| v as f32).or_else(|| n.as_str().and_then(|v| v.parse().ok()))
            .filter(|n| n.is_finite()).ok_or_else(|| format!("Ezreal Q numeric field invalid: {key}"))?;
        Ok(n)
    };
    if number("Coefficient")? != 1.1 || number("Coefficient2")? != 0.4 {
        return Err("Ezreal Q admitted primary coefficients changed".into());
    }
    let mut result = Vec::new();
    for i in 0..5 {
        let rank = i + 1;
        let q = Rank { base: number(&format!("Effect1Level{rank}Amount"))?,
            cost: number(&format!("ManaCost{rank}"))?, cooldown: number(&format!("Cooldown{rank}"))?, ad: 1.1, ap: 0.4 };
        if q.base != [35.,55.,75.,95.,115.][i] || q.cost != [28.,31.,34.,37.,40.][i]
            || q.cooldown != [6.,5.5,5.,4.5,4.][i] {
            return Err("Ezreal Q admitted primary ranks changed".into());
        }
        result.push(q);
    }
    result.try_into().map_err(|_| "Ezreal Q requires five ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=5).contains(&rank) { return Err("Ezreal Q rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 5], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|r| r[rank as usize - 1]).map_err(Clone::clone)
}

impl Simulation {
    pub(crate) fn cast_ezreal_q_at(&mut self, id: u32, point: Point) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.champion != "ezreal" { return Err("Ezreal Q requires Ezreal".into()); }
        if !p.health.is_finite() || p.health <= 0. { return Err("champion dead".into()); }
        if !p.position.finite() || !point.finite() { return Err("invalid spell point".into()); }
        if stuns::active(p, self.tick) { return Err("champion stunned".into()); }
        if trundle_e::champion_forced(p, self.tick) { return Err("champion in forced movement".into()); }
        if self.tick < p.effects.silence_until { return Err("champion silenced".into()); }
        if p.effects.ezreal_q.is_some() || self.ezreal_q.pending.contains_key(&id) || self.ezreal_r_casting(id) {
            return Err("skill blocked during cast".into());
        }
        let q = rules(p.ranks[0])?;
        if self.tick < p.cooldowns[0] { return Err("skill on cooldown".into()); }
        if !p.mana.is_finite() || p.mana < q.cost { return Err("insufficient mana".into()); }
        if p.windup.as_ref().is_some_and(|w| !w.cancelable) {
            return Err("attack windup cannot be cancelled".into());
        }
        if self.ezreal_q.session.is_some_and(|session| session != self.session) {
            return Err("Ezreal Q session transition pending".into());
        }
        if self.ezreal_q.pending.len() + self.ezreal_q.flights.len() >= MAX_CASTS {
            return Err("Ezreal Q active cast budget exhausted".into());
        }
        let ordinal = self.ezreal_q.next_ordinal;
        if ordinal == 0 { return Err("Ezreal Q ordinal exhausted".into()); }
        let next = ordinal.checked_add(1).ok_or("Ezreal Q ordinal exhausted")?;
        let stats = self.stats(id);
        if !stats.damage.is_finite() || stats.damage < 0. || !stats.ability_power.is_finite()
            || stats.ability_power < 0. || !stats.cooldown_reduction.is_finite() {
            return Err("invalid Ezreal Q cast stats".into());
        }
        let raw = q.base + q.ad * stats.damage + q.ap * stats.ability_power;
        if !raw.is_finite() || raw < 0. { return Err("invalid Ezreal Q damage".into()); }
        let cooldown = cooldown::ticks(q.cooldown, stats.cooldown_reduction);
        let ready = self.tick.checked_add(cooldown).ok_or("Ezreal Q cooldown clock overflow")?;
        let releases = self.tick.checked_add(WINDUP_TICKS).ok_or("Ezreal Q release clock overflow")?;
        let expires = releases.checked_add(FLIGHT_TICKS + 1).ok_or("Ezreal Q flight clock overflow")?;
        let identity = Identity { session: self.session, owner: id, team: p.team, ordinal };
        // Prepare the actual owned Shot NOW; release cannot introduce new geometry errors.
        let shot = Shot::new(identity, p.position, point, Params { speed_units_per_second: SPEED,
            tick_rate: TICK_RATE as u32, max_distance: RANGE, projectile_radius: RADIUS,
            launch_tick: releases, expires_at_tick: expires, mode: Mode::FirstContact,
            limits: Limits { targets_per_step: MAX_TARGETS, unique_hits: 1 } })
            .map_err(|e| format!("invalid Ezreal Q trajectory: {e:?}"))?;
        // Derived with f64 so finite opposite f32 extremes do not overflow subtraction.
        let dx = f64::from(point.x) - f64::from(p.position.x);
        let dz = f64::from(point.z) - f64::from(p.position.z);
        let length = dx.hypot(dz);
        let direction = Point { x: (dx / length) as f32, z: (dz / length) as f32 };
        if !direction.finite() { return Err("invalid Ezreal Q direction".into()); }
        let pending = Pending { flight: Flight { shot, raw, direction, launched: releases }, releases };
        // All rejection paths precede mana/CD/ordinal/lock/presentation mutation.
        self.cancel_attack_presentation(id, attack_presentation::CancelReason::OtherCast);
        let p = self.players.get_mut(&id).unwrap();
        p.mana -= q.cost; p.cooldowns[0] = ready; p.cooldown_totals[0] = Some(cooldown);
        p.windup = None; p.attack_roll = None;
        p.effects.ezreal_q = Some(CastLock { releases, direction });
        self.ezreal_q.session = Some(self.session); self.ezreal_q.next_ordinal = next;
        self.ezreal_q.pending.insert(id, pending);
        Ok(())
    }

    /// Physical eligibility is independent of visibility. Unsupported kinds are
    /// excluded, with no claim that native Q makes those kinds immune.
    fn ezreal_q_circles(&self, team: u8) -> Result<Vec<Circle>, String> {
        let champions = self.players.values().filter(|p| p.team != team && p.health.is_finite() && p.health > 0.)
            .map(|p| p.id);
        let units = self.units.values().filter(|u| {
            if !u.health.is_finite() || u.health <= 0. || u.team == team { return false; }
            let Some(def) = self.world.as_ref().and_then(|w| w.config.definitions.get(&u.definition)) else { return false; };
            // Require a configured exact type; an arbitrary Pet is not Tibbers.
            (u.kind.lane() && def.kind == u.kind)
                || (u.kind == world::Kind::Monster && def.kind == world::Kind::Monster)
                || (u.kind == world::Kind::Pet && u.definition == "annietibbers" && def.kind == world::Kind::Pet
                    && u.pet.as_ref().is_some_and(|p| self.tick < p.expires
                        && self.players.get(&p.owner).is_some_and(|owner| owner.champion == "annie" && owner.team == u.team)))
        }).map(|u| u.id);
        let mut circles = Vec::new();
        for id in champions.chain(units) {
            if self.protected(id) { continue; }
            if circles.len() == MAX_TARGETS { return Err("Ezreal Q target census exceeds budget".into()); }
            let t = self.target_info(id).ok_or("Ezreal Q target census missing identity")?;
            // Shot validates every circle before advancing; never silently drop corrupt geometry.
            circles.push(Circle { id, center: t.position, radius: t.radius });
        }
        Ok(circles)
    }

    fn refund_ezreal_q_hit(&mut self, owner: u32) {
        if let Some(p) = self.players.get_mut(&owner) {
            for ready in &mut p.cooldowns {
                if *ready > self.tick { *ready = ready.saturating_sub(REFUND_TICKS).max(self.tick); }
            }
        }
    }

    pub fn ezreal_q_faults(&self) -> Vec<Fault> { self.ezreal_q.faults.iter().cloned().collect() }

    pub(crate) fn clear_ezreal_q(&mut self) {
        self.clear_ezreal_q_impact_context();
        self.ezreal_q.pending.clear(); self.ezreal_q.flights.clear();
        self.ezreal_q.session = Some(self.session); self.ezreal_q.last_advanced = None;
        for p in self.players.values_mut() { p.effects.ezreal_q = None; }
    }
    pub(crate) fn remove_ezreal_q_owner(&mut self, owner: u32) {
        self.remove_ezreal_q_impact_owner(owner);
        self.ezreal_q.pending.remove(&owner);
        self.ezreal_q.flights.retain(|f| f.shot.view().identity.owner != owner);
        if let Some(p) = self.players.get_mut(&owner) { p.effects.ezreal_q = None; }
    }

    /// Reconstructed phase: after other champion spells/NPC movement, before
    /// pursuit/allied motion/ordinary attacks. New launches move at release+1.
    pub(crate) fn advance_ezreal_q(&mut self) {
        if self.winner.is_some() || self.ezreal_q.session.is_some_and(|s| s != self.session) {
            self.clear_ezreal_q(); return;
        }
        if self.ezreal_q.last_advanced == Some(self.tick) { return; }
        self.ezreal_q.last_advanced = Some(self.tick);
        let flights = std::mem::take(&mut self.ezreal_q.flights);
        for mut f in flights {
            let identity = f.shot.view().identity;
            if identity.session != self.session || !self.players.get(&identity.owner)
                .is_some_and(|p| p.champion == "ezreal" && p.team == identity.team) { continue; }
            // Owner health deliberately does not gate a released flight.
            let circles = match self.ezreal_q_circles(identity.team) {
                Ok(circles) => circles,
                Err(error) => { self.ezreal_q.fault(self.tick, identity.ordinal, "census", error); continue; }
            };
            let step = match f.shot.advance(identity, self.tick, &circles) {
                Ok(step) => step,
                Err(error) => { self.ezreal_q.fault(self.tick, identity.ordinal, "advance", format!("{error:?}")); continue; }
            };
            if let Some(contact) = step.contacts.first() {
                // Explicit terminal-on-error policy: geometric FirstContact consumes
                // this flight even if common damage rejects. Never retry/skip to a
                // second target; no basic_attack_hit, lifesteal or fake on-hit bus.
                let accepted_impact = self.prepare_ezreal_q_accepted_impact(identity.owner, identity.team,
                    contact.id, contact.projectile_center, contact.target_center);
                match self.apply_damage(Some(identity.owner), contact.id, f.raw, damage::DamageKind::Physical) {
                    Ok(_) => {
                        self.refund_ezreal_q_hit(identity.owner);
                        self.accepted_ezreal_ability_contact(identity.owner,identity.team,identity.session);
                        self.record_ezreal_q_accepted_impact(accepted_impact);
                    },
                    Err(error) => self.ezreal_q.fault(self.tick, identity.ordinal, "impact", error),
                }
            } else if step.phase == Phase::Flying { self.ezreal_q.flights.push(f); }
        }
        // Process pending AFTER old flights; no step at the launch tick.
        let pending = std::mem::take(&mut self.ezreal_q.pending);
        for (owner, p) in pending {
            let identity = p.flight.shot.view().identity;
            let valid = identity.session == self.session && self.players.get(&owner).is_some_and(|owner|
                owner.champion == "ezreal" && owner.team == identity.team && owner.health.is_finite() && owner.health > 0.
                && owner.effects.ezreal_q.as_ref().is_some_and(|lock| lock.releases == p.releases));
            if !valid {
                if let Some(owner) = self.players.get_mut(&owner) { owner.effects.ezreal_q = None; }
                continue;
            }
            if self.tick < p.releases { self.ezreal_q.pending.insert(owner, p); continue; }
            self.players.get_mut(&owner).unwrap().effects.ezreal_q = None;
            if self.tick != p.releases {
                self.ezreal_q.fault(self.tick, identity.ordinal, "release", "skipped release tick".into()); continue;
            }
            self.ezreal_q.flights.push(p.flight);
        }
    }

    pub(crate) fn ezreal_q_projection(&self, team: Option<u8>) -> Vec<VisibleMissile> {
        if self.winner.is_some() { return Vec::new(); }
        self.ezreal_q.flights.iter().filter_map(|f| {
            let view = f.shot.view(); let i = view.identity;
            if i.session != self.session || view.phase != Phase::Flying
                || !self.players.get(&i.owner).is_some_and(|p| p.champion == "ezreal" && p.team == i.team) { return None; }
            // Conservative local FoW: source AND current projectile point must
            // be visible to this one viewing team. Never union both teams.
            if team.is_some_and(|team| !self.visible_to(team, i.owner) || !self.visible_point_to(team, view.position)) { return None; }
            Some(VisibleMissile { session: i.session, owner: i.owner, team: i.team, ordinal: i.ordinal,
                position: view.position, direction: f.direction, launched: f.launched })
        }).collect()
    }
}

#[cfg(test)]
#[path = "ezreal_q_tests.rs"]
mod tests;
