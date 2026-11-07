//! Partial local Essence Flux 4.20 reconstruction; native callbacks are not recovered.
//! Slot damage/cost/CD/buff ranks are primary data. The secondary missile supplies
//! speed1600/range1050. Radius40 interprets raw LineWidth80 as a diameter locally.
//! Eight committed windup ticks, fixed cast origin/AP, per-tick circles, no terrain
//! collision, Pierce, strongest-source AS and shared-source refresh are LOCAL policy.
//! Caster eligibility is armed only after the wave leaves its frozen initial disk;
//! a subsequent actual caster contact can buff it. No self buff occurs on casting.
//! Accepted real contacts notify the LOCAL caster passive; native callback parity and W presentation remain open.
use crate::*;
use crate::linear_skillshot::{Circle, Identity, Limits, Mode, Params, Phase, Shot};
use std::sync::OnceLock;

pub const WINDUP_TICKS: u64 = 8;
pub const SPEED: f32 = 1600.;
pub const RANGE: f32 = 1050.;
pub const RADIUS: f32 = 40.;
pub const BUFF_TICKS: u64 = 150;
pub const MAX_CASTS: usize = 64;
pub const MAX_TARGETS: usize = 2048;
pub const MAX_BUFF_SOURCES: usize = 6;
const FLIGHT_TICKS: u64 = 20;
const MAX_FAULTS: usize = 32;

/// Public cast lock contains no authoritative raw damage or buff-source identities.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CastLock { pub releases: u64, pub direction: Point }

#[derive(Debug, Clone, Copy)]
pub struct Rank { pub base: f32, pub cost: f32, pub cooldown: f32, pub ap: f32, pub attack_speed: f32 }

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fault { pub tick: u64, pub ordinal: u64, pub stage: &'static str, pub reason: String }

#[derive(Debug)]
struct Flight {
    shot: Shot, raw: f32, rank: u8, origin: Point, initial_owner_radius: f32,
    self_armed: bool,
    direction: Point, // frozen cast direction, presentation only
}
#[derive(Debug)]
struct Pending { flight: Flight, releases: u64 }
#[derive(Debug, Clone, Copy)]
struct Buff { session: u64, owner: u32, team: u8, rank: u8, starts: u64, until: u64 }

/// Buff source/identity is private server state, not a new Snapshot side channel.
#[derive(Debug)]
pub(crate) struct State {
    session: Option<u64>, next_ordinal: u64, last_advanced: Option<u64>,
    pending: BTreeMap<u32, Pending>, flights: Vec<Flight>,
    buffs: BTreeMap<u32, Vec<Buff>>, faults: VecDeque<Fault>,
}
impl Default for State {
    fn default() -> Self {
        Self { session: None, next_ordinal: 1, last_advanced: None,
            pending: BTreeMap::new(), flights: Vec::new(), buffs: BTreeMap::new(), faults: VecDeque::new() }
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
    let rows = rows.as_array().ok_or("Ezreal W native table must be an array")?;
    let matching: Vec<_> = rows.iter().filter(|row| row["champion"].as_str()
        .is_some_and(|name| name.eq_ignore_ascii_case("ezreal")) && row["slot"].as_u64() == Some(1)).collect();
    if matching.len() != 1 || matching[0]["spell"] != "EzrealEssenceFlux" {
        return Err("unique primary Ezreal W resource required".into());
    }
    let values = &matching[0]["values"];
    let number = |key: &str| -> Result<f32, String> {
        let value = &values[key];
        value.as_f64().map(|n| n as f32).or_else(|| value.as_str().and_then(|n| n.parse().ok()))
            .filter(|n: &f32| n.is_finite()).ok_or_else(|| format!("Ezreal W numeric field invalid: {key}"))
    };
    if number("Coefficient")? != 0.8 { return Err("Ezreal W AP coefficient changed".into()); }
    let mut ranks = Vec::with_capacity(5);
    for index in 0..5 {
        let rank = index + 1;
        let rule = Rank { base: number(&format!("Effect1Level{rank}Amount"))?,
            cost: number(&format!("ManaCost{rank}"))?, cooldown: number(&format!("Cooldown{rank}"))?,
            ap: 0.8, attack_speed: number(&format!("Effect2Level{rank}Amount"))? / 100. };
        if rule.base != [70.,115.,160.,205.,250.][index] || rule.cost != [50.,60.,70.,80.,90.][index]
            || rule.cooldown != 9. || rule.attack_speed != [0.2,0.25,0.3,0.35,0.4][index] {
            return Err("Ezreal W admitted primary ranks changed".into());
        }
        ranks.push(rule);
    }
    ranks.try_into().map_err(|_| "Ezreal W requires five ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=5).contains(&rank) { return Err("Ezreal W rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 5], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|ranks| ranks[rank as usize - 1]).map_err(Clone::clone)
}

impl Simulation {
    pub(crate) fn cast_ezreal_w_at(&mut self, id: u32, point: Point) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let player = self.players.get(&id).ok_or("unknown player")?;
        if player.champion != "ezreal" { return Err("Ezreal W requires Ezreal".into()); }
        if !player.health.is_finite() || player.health <= 0. { return Err("champion dead".into()); }
        if !player.position.finite() || !point.finite() { return Err("invalid spell point".into()); }
        if stuns::active(player, self.tick) { return Err("champion stunned".into()); }
        if trundle_e::champion_forced(player, self.tick) { return Err("champion in forced movement".into()); }
        if self.tick < player.effects.silence_until { return Err("champion silenced".into()); }
        if player.effects.ezreal_q.is_some() || player.effects.ezreal_w.is_some()
            || self.ezreal_w.pending.contains_key(&id) || self.ezreal_r_casting(id) { return Err("skill blocked during cast".into()); }
        let rule = rules(player.ranks[1])?;
        if self.tick < player.cooldowns[1] { return Err("skill on cooldown".into()); }
        if !player.mana.is_finite() || player.mana < rule.cost { return Err("insufficient mana".into()); }
        if player.windup.as_ref().is_some_and(|windup| !windup.cancelable) {
            return Err("attack windup cannot be cancelled".into());
        }
        if self.ezreal_w.session.is_some_and(|session| session != self.session) {
            return Err("Ezreal W session transition pending".into());
        }
        if self.ezreal_w.pending.len() + self.ezreal_w.flights.len() >= MAX_CASTS {
            return Err("Ezreal W active cast budget exhausted".into());
        }
        let ordinal = self.ezreal_w.next_ordinal;
        if ordinal == 0 { return Err("Ezreal W ordinal exhausted".into()); }
        let next = ordinal.checked_add(1).ok_or("Ezreal W ordinal exhausted")?;
        let stats = self.stats(id);
        if !stats.ability_power.is_finite() || stats.ability_power < 0. || !stats.cooldown_reduction.is_finite() {
            return Err("invalid Ezreal W cast stats".into());
        }
        let raw = rule.base + rule.ap * stats.ability_power;
        if !raw.is_finite() || raw < 0. { return Err("invalid Ezreal W damage".into()); }
        let cooldown = cooldown::ticks(rule.cooldown, stats.cooldown_reduction);
        let ready = self.tick.checked_add(cooldown).ok_or("Ezreal W cooldown clock overflow")?;
        let releases = self.tick.checked_add(WINDUP_TICKS).ok_or("Ezreal W release clock overflow")?;
        let expires = releases.checked_add(FLIGHT_TICKS + 1).ok_or("Ezreal W flight clock overflow")?;
        expires.checked_add(BUFF_TICKS).ok_or("Ezreal W buff clock overflow")?;
        let owner_radius = self.target_info(id).ok_or("Ezreal W owner collision absent")?.radius;
        if !owner_radius.is_finite() || owner_radius < 0. { return Err("invalid Ezreal W owner radius".into()); }
        let identity = Identity { session: self.session, owner: id, team: player.team, ordinal };
        let shot = Shot::new(identity, player.position, point, Params { speed_units_per_second: SPEED,
            tick_rate: TICK_RATE as u32, max_distance: RANGE, projectile_radius: RADIUS,
            launch_tick: releases, expires_at_tick: expires, mode: Mode::Pierce,
            limits: Limits { targets_per_step: MAX_TARGETS, unique_hits: MAX_TARGETS } })
            .map_err(|error| format!("invalid Ezreal W trajectory: {error:?}"))?;
        let dx = f64::from(point.x) - f64::from(player.position.x);
        let dz = f64::from(point.z) - f64::from(player.position.z);
        let length = dx.hypot(dz);
        let direction = Point { x: (dx / length) as f32, z: (dz / length) as f32 };
        if !direction.finite() { return Err("invalid Ezreal W direction".into()); }
        let pending = Pending { flight: Flight { shot, raw, rank: player.ranks[1], origin: player.position,
            initial_owner_radius: owner_radius, self_armed: false, direction }, releases };
        // All fallible work above; commit resources/identity/lock only once.
        self.cancel_attack_presentation(id, attack_presentation::CancelReason::OtherCast);
        let player = self.players.get_mut(&id).unwrap();
        player.mana -= rule.cost; player.cooldowns[1] = ready; player.cooldown_totals[1] = Some(cooldown);
        player.windup = None; player.attack_roll = None;
        player.effects.ezreal_w = Some(CastLock { releases, direction });
        self.ezreal_w.session = Some(self.session); self.ezreal_w.next_ordinal = next;
        self.ezreal_w.pending.insert(id, pending);
        Ok(())
    }

    fn ezreal_w_circles(&self, flight: &Flight) -> Result<Vec<Circle>, String> {
        let identity = flight.shot.view().identity;
        let mut circles = Vec::new();
        for (id, player) in &self.players {
            if !player.health.is_finite() || player.health <= 0. { continue; }
            if *id != player.id || player.team > 1 { return Err("Ezreal W target identity invalid".into()); }
            if *id == identity.owner && !flight.self_armed { continue; }
            if player.team != identity.team && self.protected(*id) { continue; }
            if circles.len() == MAX_TARGETS { return Err("Ezreal W target census exceeds budget".into()); }
            let target = self.target_info(*id).ok_or("Ezreal W target collision absent")?;
            circles.push(Circle { id: *id, center: target.position,
                radius: if *id == identity.owner { flight.initial_owner_radius } else { target.radius } });
        }
        // Champions only, irrespective of visibility. No lane/NPC/structure circle.
        Ok(circles)
    }

    fn grant_ezreal_w_buff(&mut self, target: u32, identity: Identity, rank: u8) -> Result<(), String> {
        if identity.session != self.session || !self.players.get(&identity.owner)
            .is_some_and(|owner| owner.champion == "ezreal" && owner.team == identity.team) {
            return Err("Ezreal W buff owner invalid".into());
        }
        let player = self.players.get(&target).ok_or("Ezreal W ally absent")?;
        if player.team != identity.team || !player.health.is_finite() || player.health <= 0. {
            return Err("Ezreal W ally invalid".into());
        }
        rules(rank)?;
        let until = self.tick.checked_add(BUFF_TICKS).ok_or("Ezreal W buff clock overflow")?;
        let mut buffs = self.ezreal_w.buffs.get(&target).cloned().unwrap_or_default();
        buffs.retain(|buff| buff.session == self.session && buff.until > self.tick && buff.owner != identity.owner);
        if buffs.len() >= MAX_BUFF_SOURCES { return Err("Ezreal W ally buff source budget exhausted".into()); }
        buffs.push(Buff { session: self.session, owner: identity.owner, team: identity.team, rank, starts: self.tick, until });
        self.ezreal_w.buffs.insert(target, buffs);
        Ok(())
    }

    pub(crate) fn ezreal_w_attack_speed_bonus(&self, target: u32) -> f32 {
        if self.winner.is_some() { return 0.; }
        let Some(player) = self.players.get(&target).filter(|p| p.health.is_finite() && p.health > 0.) else { return 0.; };
        let Some(buffs) = self.ezreal_w.buffs.get(&target).filter(|buffs| buffs.len() <= MAX_BUFF_SOURCES) else { return 0.; };
        buffs.iter().filter(|buff| buff.session == self.session && buff.team == player.team
            && buff.starts <= self.tick && self.tick < buff.until && buff.starts.checked_add(BUFF_TICKS) == Some(buff.until)
            && self.players.get(&buff.owner).is_some_and(|owner| owner.champion == "ezreal" && owner.team == buff.team))
            .filter_map(|buff| rules(buff.rank).ok().map(|rule| rule.attack_speed))
            .fold(0., f32::max)
    }

    pub fn ezreal_w_faults(&self) -> Vec<Fault> { self.ezreal_w.faults.iter().cloned().collect() }

    pub(crate) fn clear_ezreal_w_target(&mut self, target: u32) { self.ezreal_w.buffs.remove(&target); }
    pub(crate) fn clear_ezreal_w(&mut self) {
        self.ezreal_w.pending.clear(); self.ezreal_w.flights.clear(); self.ezreal_w.buffs.clear();
        self.ezreal_w.session = Some(self.session); self.ezreal_w.last_advanced = None;
        for player in self.players.values_mut() { player.effects.ezreal_w = None; }
    }
    pub(crate) fn remove_ezreal_w_owner(&mut self, owner: u32) {
        self.ezreal_w.pending.remove(&owner);
        self.ezreal_w.flights.retain(|flight| flight.shot.view().identity.owner != owner);
        self.ezreal_w.buffs.remove(&owner);
        for buffs in self.ezreal_w.buffs.values_mut() { buffs.retain(|buff| buff.owner != owner); }
        if let Some(player) = self.players.get_mut(&owner) { player.effects.ezreal_w = None; }
    }

    /// Local order: immediately after Q, before pursuit/allied motion/attacks.
    /// Old flights advance before new release; no movement on the release tick.
    pub(crate) fn advance_ezreal_w(&mut self) {
        if self.winner.is_some() || self.ezreal_w.session.is_some_and(|session| session != self.session)
            || self.ezreal_w.last_advanced.is_some_and(|last| self.tick < last) {
            self.clear_ezreal_w(); return;
        }
        if self.ezreal_w.last_advanced == Some(self.tick) { return; }
        self.ezreal_w.last_advanced = Some(self.tick);
        let players = &self.players; let session = self.session; let tick = self.tick;
        self.ezreal_w.buffs.retain(|target, buffs| {
            let Some(player) = players.get(target).filter(|p| p.health.is_finite() && p.health > 0.) else { return false; };
            buffs.retain(|buff| buff.session == session && buff.team == player.team && buff.until > tick
                && players.get(&buff.owner).is_some_and(|owner| owner.champion == "ezreal" && owner.team == buff.team));
            !buffs.is_empty()
        });
        let flights = std::mem::take(&mut self.ezreal_w.flights);
        for mut flight in flights {
            let identity = flight.shot.view().identity;
            if identity.session != self.session || !self.players.get(&identity.owner)
                .is_some_and(|owner| owner.champion == "ezreal" && owner.team == identity.team) { continue; }
            // Released waves survive owner death; departure/session are distinct.
            let circles = match self.ezreal_w_circles(&flight) {
                Ok(circles) => circles,
                Err(error) => { self.ezreal_w.fault(self.tick, identity.ordinal, "census", error); continue; }
            };
            let step = match flight.shot.advance(identity, self.tick, &circles) {
                Ok(step) => step,
                Err(error) => { self.ezreal_w.fault(self.tick, identity.ordinal, "advance", format!("{error:?}")); continue; }
            };
            let mut failed = false;
            for contact in &step.contacts {
                let result = match self.players.get(&contact.id).map(|p| p.team) {
                    Some(team) if team == identity.team => self.grant_ezreal_w_buff(contact.id, identity, flight.rank),
                    Some(_) => self.apply_damage(Some(identity.owner), contact.id, flight.raw, damage::DamageKind::Magical).map(|_| ()),
                    None => Err("Ezreal W contact identity disappeared".into()),
                };
                // LOCAL: enemy damageOk and real allied/self buffOk each grant
                // one stack to the CASTER only. Shot consumes each entity once.
                if result.is_ok() { self.accepted_ezreal_ability_contact(identity.owner,identity.team,identity.session); }
                if let Err(error) = result {
                    // Geometry already consumed this step's contacts. Stop this
                    // wave on the first application error, never retry/refund or
                    // replay earlier contacts; prior accepted contacts stay real.
                    self.ezreal_w.fault(self.tick, identity.ordinal, "contact", error); failed = true; break;
                }
            }
            // Conservative discrete gate: exiting a step arms self for the NEXT
            // segment only. The disk origin/radius never follow the moving owner.
            let dx = f64::from(step.to.x) - f64::from(flight.origin.x);
            let dz = f64::from(step.to.z) - f64::from(flight.origin.z);
            if dx.hypot(dz) > f64::from(flight.initial_owner_radius) + f64::from(RADIUS) { flight.self_armed = true; }
            if !failed && step.phase == Phase::Flying { self.ezreal_w.flights.push(flight); }
        }
        let pending = std::mem::take(&mut self.ezreal_w.pending);
        for (id, pending) in pending {
            let identity = pending.flight.shot.view().identity;
            let valid = identity.session == self.session && self.players.get(&id).is_some_and(|owner|
                owner.champion == "ezreal" && owner.team == identity.team && owner.health.is_finite() && owner.health > 0.
                && owner.effects.ezreal_w.as_ref().is_some_and(|lock| lock.releases == pending.releases));
            if !valid {
                if let Some(owner) = self.players.get_mut(&id) { owner.effects.ezreal_w = None; }
                continue;
            }
            if self.tick < pending.releases { self.ezreal_w.pending.insert(id, pending); continue; }
            self.players.get_mut(&id).unwrap().effects.ezreal_w = None;
            if self.tick != pending.releases {
                self.ezreal_w.fault(self.tick, identity.ordinal, "release", "skipped release tick".into()); continue;
            }
            self.ezreal_w.flights.push(pending.flight);
        }
    }
}

#[cfg(test)]
#[path = "ezreal_w_tests.rs"]
mod tests;

/// Current visible W windup only. No origin, damage, buff, target or history.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct VisibleCast {
    pub session: u64, pub owner: u32, pub team: u8, pub ordinal: u64,
    pub releases: u64, pub direction: Point,
}
impl Simulation {
    pub(crate) fn ezreal_w_cast_projection(&self, viewer: u32) -> Vec<VisibleCast> {
        let Some(viewer) = self.players.get(&viewer).filter(|p| p.id == viewer && p.team <= 1)
            else { return Vec::new(); };
        if self.winner.is_some() || self.ezreal_w.session != Some(self.session)
            || self.ezreal_w.next_ordinal == 0
            || self.ezreal_w.last_advanced.is_some_and(|tick| self.tick < tick)
            || self.ezreal_w.pending.len().checked_add(self.ezreal_w.flights.len())
                .is_none_or(|count| count > MAX_CASTS) { return Vec::new(); }
        let mut rows = Vec::new(); let mut seen = std::collections::BTreeSet::new();
        for (&owner, pending) in &self.ezreal_w.pending {
            let flight = &pending.flight; let shot = flight.shot.view(); let id = shot.identity;
            let Some(started) = pending.releases.checked_sub(WINDUP_TICKS) else { return Vec::new(); };
            let Some(player) = self.players.get(&owner) else { return Vec::new(); };
            if owner == 0 || player.id != owner || id.owner != owner || id.session != self.session
                || id.team > 1 || player.team != id.team || player.champion != "ezreal"
                || id.ordinal == 0 || id.ordinal >= self.ezreal_w.next_ordinal || !seen.insert(id.ordinal)
                || pending.releases.checked_add(FLIGHT_TICKS + 1 + BUFF_TICKS).is_none()
                || shot.phase != Phase::Flying || shot.last_tick != pending.releases
                || shot.traveled != 0. || shot.unique_hits != 0 || shot.position != flight.origin
                || !flight.origin.finite() || !player.position.finite() || !player.health.is_finite()
                || !flight.raw.is_finite() || flight.raw < 0. || !(1..=5).contains(&flight.rank)
                || !flight.initial_owner_radius.is_finite() || flight.initial_owner_radius < 0.
                || flight.self_armed || !flight.direction.finite()
                || (flight.direction.x.hypot(flight.direction.z) - 1.).abs() > 0.0001 {
                return Vec::new();
            }
            let Some(lock) = player.effects.ezreal_w.as_ref() else { continue; };
            if lock.releases != pending.releases || lock.direction != flight.direction { return Vec::new(); }
            // W is already committed: later stun/silence/forced motion does not
            // interrupt its actual pending. Do not import R's different rule.
            if self.tick < started || self.tick >= pending.releases || player.health <= 0.
                || !self.visible_to(viewer.team, owner) { continue; }
            rows.push(VisibleCast { session: id.session, owner, team: id.team,
                ordinal: id.ordinal, releases: pending.releases, direction: flight.direction });
        }
        rows
    }
}


impl Simulation {
    /// LOCAL point-only current W XYZ, emitted only in the accepted atomic path.
    /// No cast point, bone, launch tick, actor height or target history is exposed.
    pub(crate) fn ezreal_w_current_projection(&self, viewer: u32) -> Option<serde_json::Value> {
        let viewer=self.players.get(&viewer).filter(|p|p.id==viewer && p.team<=1)?;
        let terrain=self.map10_cast_ground?;
        if self.winner.is_some() || self.ezreal_w.session!=Some(self.session)
            || self.ezreal_w.flights.len()>MAX_CASTS {return None;}
        let mut seen=std::collections::BTreeSet::new();
        // Validate the whole private census before selecting any public row.
        for flight in &self.ezreal_w.flights {
            let view=flight.shot.view();let id=view.identity;
            if id.session!=self.session || id.owner==0 || id.team>1 || id.ordinal==0
                || id.ordinal>=self.ezreal_w.next_ordinal || !seen.insert(id.ordinal)
                || view.phase!=Phase::Flying || view.last_tick!=self.tick
                || !view.position.finite() || !flight.direction.finite()
                || (flight.direction.x.hypot(flight.direction.z)-1.).abs()>0.0001
                || !self.players.get(&id.owner).is_some_and(|p|p.id==id.owner
                    && p.champion=="ezreal" && p.team==id.team) {return None;}
        }
        let mut rows=Vec::new();
        for flight in &self.ezreal_w.flights {
            let view=flight.shot.view();let id=view.identity;
            if !self.visible_point_to(viewer.team,view.position) {continue;}
            // Missing dense context/cell is unavailable, never actor height or zero.
            let Ok(y_native)=terrain.sample_local_f32([view.position.x,view.position.z]) else {continue;};
            if !y_native.is_finite() {continue;}
            rows.push(crate::ezreal_w_projectile_view::Row {owner:id.owner,team:id.team,ordinal:id.ordinal,
                position:view.position,y_native,direction:flight.direction});
        }
        rows.sort_by_key(|r|(r.owner,r.ordinal));
        crate::ezreal_w_projectile_view::encode(rows)
    }
}
#[cfg(test)]
#[path="ezreal_w_current_missile_tests.rs"]
mod current_missile_tests;
