//! Native attack numeric profiles; full per-champion semantics and VFX remain incomplete.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
pub(crate) struct Profile {
    pub melee: bool,
    pub base_period_seconds: f32,
    pub base_windup_seconds: f32,
    pub windup_speed_ratio: f32,
    pub missile_speed: Option<f32>,
    pub cant_cancel: bool,
}
/// Exact canonical attack-profile IDs; gameplay attack support is unchanged.
pub fn supports_champion_presentation(champion: &str) -> bool {
    profiles().contains_key(champion)
}
fn profiles() -> &'static BTreeMap<String, Profile> {
    static DATA: OnceLock<BTreeMap<String, Profile>> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/attack_contracts.json")).unwrap()
    })
}
fn profile(champion: &str) -> &'static Profile {
    &profiles()[champion]
}
pub fn windup_ticks(champion: &str, cadence: u64) -> u64 {
    profile_windup_ticks(profile(champion), cadence)
}
fn profile_windup_ticks(p: &Profile, cadence: u64) -> u64 {
    let speed_scale = cadence as f32 / TICK_RATE as f32 / p.base_period_seconds;
    let seconds =
        p.base_windup_seconds * ((1. - p.windup_speed_ratio) + p.windup_speed_ratio * speed_scale);
    (seconds * TICK_RATE as f32).ceil().max(1.) as u64
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Windup {
    pub target: u32,
    pub started: u64,
    pub release: u64,
    pub cancelable: bool,
    #[serde(default)]
    pub critical: bool,
    #[serde(default)]
    pub presentation: Option<attack_presentation::Attack>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Projectile {
    pub id: u64,
    pub source: u32,
    pub target: u32,
    pub position: Point,
    pub speed: f32,
    pub raw: f32,
    pub launched: u64,
    #[serde(default)]
    pub critical: bool,
}
impl Simulation {
    fn presentation_kind(&self, empowered: bool, critical: bool, trundle_q: bool) -> attack_presentation::Kind {
        if trundle_q { attack_presentation::Kind::TrundleQ }
        else { self.garen_q_resource.kind_at_observation(empowered, critical) }
    }
    fn presentation_result<T>(&mut self, result: Result<T, attack_presentation::Error>) -> Option<T> {
        match result {
            Ok(value) => Some(value),
            Err(error) => {
                if self.attack_presentation_error.is_none() {
                    let message = format!("attack presentation unavailable: {error:?}");
                    eprintln!("{message}");
                    self.attack_presentation_error = Some(message);
                }
                None
            }
        }
    }
    fn attack_audience(&self, source: u32, target: u32) -> attack_presentation::Audience {
        attack_presentation::Audience::from_visibility(
            self.visible_to(0, source) && self.visible_to(0, target),
            self.visible_to(1, source) && self.visible_to(1, target))
    }
    pub(crate) fn capture_attack_presentation(&self, id: u32)
        -> Option<(attack_presentation::Attack, attack_presentation::Audience)> {
        let windup = self.players.get(&id)?.windup.as_ref()?;
        Some((windup.presentation?, self.attack_audience(id, windup.target)))
    }
    pub(crate) fn cancel_captured_attack_presentation(&mut self,
        captured: Option<(attack_presentation::Attack, attack_presentation::Audience)>,
        reason: attack_presentation::CancelReason) {
        let Some((attack, audience)) = captured else { return; };
        // This field is presentation-only. Preserve the combat windup/cadence.
        if let Some(windup) = self.players.get_mut(&attack.source).and_then(|p| p.windup.as_mut()) {
            if windup.presentation == Some(attack) { windup.presentation = None; }
        }
        let result = self.attack_presentation.cancel(attack, self.tick, reason, audience);
        self.presentation_result(result);
    }
    pub(crate) fn cancel_attack_presentation(&mut self, id: u32, reason: attack_presentation::CancelReason) {
        let captured = self.capture_attack_presentation(id);
        self.cancel_captured_attack_presentation(captured, reason);
    }
    /// Authoritative departure API: keep terminal facts before either actor disappears.
    /// Existing combat cleanup remains unchanged; no projectile or damage is fabricated.
    pub fn remove_player(&mut self, id: u32) -> Option<Champion> {
        if !self.players.contains_key(&id) { return None; }
        let affected: Vec<_> = self.players.values()
            .filter(|p| p.id == id || p.windup.as_ref().is_some_and(|w| w.target == id))
            .filter_map(|p| self.capture_attack_presentation(p.id)).collect();
        for captured in affected {
            self.cancel_captured_attack_presentation(Some(captured), attack_presentation::CancelReason::Departure);
        }
        self.clear_trundle_r_for(id);
        self.remove_trundle_e_owner(id);
        self.accepted_casts.remove_owner(id);
        self.players.remove(&id)
    }
    pub(crate) fn finish_attack_presentations(&mut self) {
        // Capture all audiences before touching presentation state. Combat state is retained.
        let active: Vec<_> = self.players.keys().filter_map(|id| self.capture_attack_presentation(*id)).collect();
        for captured in active {
            self.cancel_captured_attack_presentation(Some(captured), attack_presentation::CancelReason::MatchEnded);
        }
    }
    pub(crate) fn cancel_windup(&mut self, id: u32) -> Result<(), String> {
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.windup.as_ref().is_some_and(|w| !w.cancelable) {
            return Err("attack windup cannot be cancelled".into());
        }
        self.cancel_attack_presentation(id, attack_presentation::CancelReason::Order);
        let p = self.players.get_mut(&id).unwrap();
        if p.windup.take().is_some() {
            p.next_attack = self.tick;
        }
        Ok(())
    }
    fn attack_target_valid(&self, id: u32, target: u32, range: bool) -> bool {
        let Some(p) = self.players.get(&id) else {
            return false;
        };
        let Some(e) = self.target_info(target) else {
            return false;
        };
        p.health > 0.
            && p.team != e.team
            && e.health > 0.
            && !self.protected(target)
            && self.visible_to(p.team, target)
            && (!range
                || p.position.distance(e.position)
                    <= self.definitions[&p.champion].attack_range + e.radius)
    }
    pub(crate) fn advance_attacks(&mut self) {
        // Released projectiles travel independently of new orders and shooter health.
        let flights = std::mem::take(&mut self.projectiles);
        for mut m in flights {
            let Some(enemy) = self.target_info(m.target).filter(|e| e.health > 0.) else {
                continue;
            };
            let distance = m.position.distance(enemy.position);
            let step = m.speed / TICK_RATE as f32;
            if distance <= step + enemy.radius {
                let _ = self.basic_attack_hit(m.source, m.target, m.raw);
            } else {
                m.position.x += (enemy.position.x - m.position.x) * step / distance;
                m.position.z += (enemy.position.z - m.position.z) * step / distance;
                self.projectiles.push(m);
            }
        }
        let ids: Vec<_> = self.players.keys().copied().collect();
        for id in ids {
            let p = &self.players[&id];
            if p.health <= 0. || stuns::active(p,self.tick) || trundle_e::champion_forced(p,self.tick) || p.effects.ultimate.is_some() || p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.effects.annie_r.is_some() || self.tick < p.effects.spin_until {
                let reason = if p.health <= 0. { attack_presentation::CancelReason::Death }
                    else if stuns::active(p, self.tick) || trundle_e::champion_forced(p,self.tick) { attack_presentation::CancelReason::Control }
                    else { attack_presentation::CancelReason::OtherCast };
                self.cancel_attack_presentation(id, reason);
                let p = self.players.get_mut(&id).unwrap();
                p.windup = None;
                if p.health <= 0. {
                    p.attack_roll = None;
                }
                continue;
            }
            if let Some(w) = p.windup.clone() {
                if !self.attack_target_valid(id, w.target, true) {
                    self.cancel_attack_presentation(id, attack_presentation::CancelReason::TargetInvalid);
                    let p = self.players.get_mut(&id).unwrap();
                    p.windup = None;
                    p.next_attack = self.tick;
                    continue;
                }
                // Reconstructed physical facing: update only after target validity.
                // Retained independently of the transient windup, including release.
                let target_position = self.target_info(w.target).expect("validated attack target").position;
                let source = self.players.get_mut(&id).unwrap();
                source.capture_facing([target_position.x-source.position.x,0.,target_position.z-source.position.z]);
                if self.tick < w.release {
                    continue;
                }
                // Audience precedes removal of windup, damage, death and Q consumption.
                let presentation_audience = w.presentation.map(|_| self.attack_audience(id, w.target));
                let p = self.players.get_mut(&id).unwrap();
                p.windup = None;
                p.attack_roll = None;
                let p = &self.players[&id];
                let empowered = p.champion == "garen" && self.tick < p.effects.empowered_until;
                let trundle_rank = trundle_q::attack_rank(p, self.tick);
                let rank = p.ranks[0];
                let stats = self.stats(id);
                let ad = stats.damage;
                // RECONSTRUCTION: Q replaces this ordinary raw hit and cannot crit.
                // AD is sampled before the resulting self buff is applied.
                let critical = w.critical && !empowered && trundle_rank.is_none();
                let raw = if let Some(rank) = trundle_rank {
                    let q = trundle_q::rules(rank).expect("armed Q rank validated at cast");
                    q.base + q.ad_coefficient * ad
                } else if empowered {
                    1.4 * ad + spells::garen_value(0, "Effect1", rank)
                } else {
                    ad * if critical {
                        stats.critical_multiplier
                    } else {
                        1.
                    }
                };
                let profile = if critical {
                    &critical::profile(&p.champion).attack
                } else {
                    profile(&p.champion)
                };
                let mut presentation_hit = false;
                if profile.melee {
                    let hit = if let Some(rank) = trundle_rank {
                        self.trundle_q_attack_hit(id, w.target, raw, rank)
                    } else if empowered {
                        self.empowered_attack_hit(id,w.target,raw)
                    } else {
                        self.basic_attack_hit(id, w.target, raw)
                    }
                    .is_ok();
                    presentation_hit = hit;
                    if hit && empowered {
                        self.players.get_mut(&id).unwrap().effects.empowered_until = 0;
                        self.apply_silence(
                            w.target,
                            self.tick + spells::seconds(spells::garen_value(0, "Effect3", rank)),
                        );
                    }
                } else if let Some(speed) =
                    profile.missile_speed.filter(|v| v.is_finite() && *v > 0.)
                {
                    self.projectiles.push(Projectile {
                        id: self.next_projectile,
                        source: id,
                        target: w.target,
                        position: self.players[&id].position,
                        speed,
                        raw,
                        launched: self.tick,
                        critical,
                    });
                    self.next_projectile += 1;
                }
                if let (Some(attack), Some(audience)) = (w.presentation, presentation_audience) {
                    // Resolution closes this windup using the decisions above. For ranged
                    // Annie/Ashe, false records no hit at launch, not a missed projectile.
                    let kind = self.presentation_kind(empowered, critical, trundle_rank.is_some());
                    let result = self.attack_presentation.resolve(attack, self.tick,
                        kind, presentation_hit, audience);
                    self.presentation_result(result);
                }
                continue;
            }
            let p = &self.players[&id];
            let Some(target) = p.target else { continue };
            if self.tick < p.next_attack || !self.attack_target_valid(id, target, true) {
                continue;
            }
            let stats = self.stats(id);
            let cadence = stats.attack_cooldown_ticks;
            let name = p.champion.clone();
            let empowered = name == "garen" && self.tick < p.effects.empowered_until;
            let trundle_armed = trundle_q::armed(p, self.tick);
            let can_crit =
                !empowered && !trundle_armed && !self.units.get(&target).is_some_and(|u| u.kind.structure());
            let critical = can_crit
                && match p.attack_roll {
                    Some(value) => value,
                    None => self.roll_critical(stats.critical_chance),
                };
            let attack_profile = if critical {
                &critical::profile(&name).attack
            } else {
                profile(&name)
            };
            // Q authored frame/flags are presentation data, not this server's
            // timing or global Move/Stop policy. Preserve the current base profile.
            let duration = profile_windup_ticks(attack_profile, cadence).min(cadence);
            let cancelable = !attack_profile.cant_cancel;
            let presentation = if supports_champion_presentation(&name) && self.attack_presentation_error.is_none() {
                let audience = self.attack_audience(id, target);
                let kind = self.presentation_kind(empowered, critical, trundle_armed);
                let result = self.attack_presentation.begin(id, self.tick, self.tick + duration,
                    kind, audience);
                self.presentation_result(result)
            } else { None };
            let target_position = self.target_info(target).expect("validated attack target").position;
            let p = self.players.get_mut(&id).unwrap();
            p.capture_facing([target_position.x-p.position.x,0.,target_position.z-p.position.z]);
            // Q never manufactures a cached false BA roll; its accepted cast
            // already discarded the pre-existing cache as explicit reconstruction.
            p.attack_roll = if trundle_armed { None } else { Some(critical) };
            p.windup = Some(Windup {
                target,
                started: self.tick,
                release: self.tick + duration,
                cancelable,
                critical,
                presentation,
            });
            p.next_attack = self.tick + cadence;
            p.path.clear();
            p.destination = None;
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game(name: &str) -> (Simulation, u32, u32) {
        let mut bytes = Vec::new();
        for _ in 0..400 {
            bytes.extend(0f32.to_le_bytes());
            bytes.extend(0u16.to_le_bytes());
            bytes.extend(0u32.to_le_bytes());
            bytes.push(1);
        }
        let mut s = Simulation::new(
            Navigation::load(
                r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,
                &bytes,
            )
            .unwrap(),
        )
        .unwrap();
        let a = s.join(name).unwrap();
        let b = s.join("garen").unwrap();
        s.players.get_mut(&a).unwrap().position = Point { x: 100., z: 100. };
        s.players.get_mut(&b).unwrap().position = Point { x: 500., z: 100. };
        (s, a, b)
    }
    #[test]
    fn melee_does_not_hit_until_native_windup_ends() {
        let (mut s, a, b) = game("garen");
        s.players.get_mut(&b).unwrap().position = Point { x: 150., z: 100. };
        let hp = s.players[&b].health;
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        let release = s.players[&a].windup.as_ref().unwrap().release;
        assert_eq!(windup_ticks("garen", 48), 10);
        assert_eq!(s.players[&b].health, hp);
        while s.tick < release - 1 {
            s.advance();
        }
        assert_eq!(s.players[&b].health, hp);
        s.advance();
        assert!(s.players[&b].health < hp);
        assert!(s.players[&a].windup.is_none());
    }
    #[test]
    fn stop_cancels_windup_without_damage_but_not_already_launched_missile() {
        let (mut s, a, b) = game("ashe");
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        s.command(a, Action::Stop).unwrap();
        for _ in 0..20 {
            s.advance();
        }
        assert!(s.projectiles.is_empty());
        assert_eq!(s.players[&b].health, s.players[&b].max_health);
        s.command(a, Action::Attack { target: b }).unwrap();
        while s.projectiles.is_empty() {
            s.advance();
        }
        s.command(a, Action::Stop).unwrap();
        let hp = s.players[&b].health;
        while !s.projectiles.is_empty() {
            s.advance();
        }
        assert!(s.players[&b].health < hp);
    }
    #[test]
    fn released_missile_survives_shooter_death_and_tracks_moving_target() {
        let (mut s, a, b) = game("ashe");
        s.command(a, Action::Attack { target: b }).unwrap();
        while s.projectiles.is_empty() {
            s.advance();
        }
        assert_eq!(s.projectiles[0].speed, 2000.);
        s.damage(a, 100000., false);
        s.players.get_mut(&b).unwrap().position = Point { x: 650., z: 150. };
        let hp = s.players[&b].health;
        for _ in 0..20 {
            s.advance();
        }
        assert!(s.players[&b].health < hp);
        assert!(s.projectiles.is_empty());
    }
    #[test]
    fn lost_vision_cancels_prelaunch_but_snapshot_never_leaks_hidden_projectiles() {
        let (mut s, a, b) = game("ashe");
        s.enable_map10().unwrap();
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        s.players.get_mut(&b).unwrap().position = Point { x: 5000., z: 100. };
        s.advance();
        assert!(s.players[&a].windup.is_none());
        assert!(s.projectiles.is_empty());
        s.projectiles.push(Projectile {
            id: 1,
            source: a,
            target: b,
            position: Point { x: 100., z: 100. },
            speed: 2000.,
            raw: 50.,
            launched: s.tick,
            critical: false,
        });
        assert!(s.snapshot_for(a).unwrap().projectiles.is_empty());
    }
    #[test]
    fn valid_move_cancels_windup_but_rejected_move_preserves_it() {
        let (mut s, a, b) = game("ashe");
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        let release = s.players[&a].windup.as_ref().unwrap().release;
        assert!(s
            .command(
                a,
                Action::Move {
                    point: Point {
                        x: f32::NAN,
                        z: 100.
                    }
                }
            )
            .is_err());
        assert_eq!(s.players[&a].windup.as_ref().unwrap().release, release);
        s.command(
            a,
            Action::Move {
                point: Point { x: 200., z: 100. },
            },
        )
        .unwrap();
        assert!(s.players[&a].windup.is_none());
        assert!(s.players[&a].target.is_none());
        for _ in 0..20 {
            s.advance();
        }
        assert!(s.projectiles.is_empty());
        assert_eq!(s.players[&b].health, s.players[&b].max_health);
    }
    #[test]
    fn uncancellable_windup_rejects_stop_move_and_target_change_atomically() {
        let (mut s, a, b) = game("ashe");
        let c = s.join("garen").unwrap();
        let d = s.join("garen").unwrap();
        assert_eq!(s.players[&c].team, s.players[&a].team);
        s.players.get_mut(&d).unwrap().position = Point { x: 550., z: 100. };
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        s.players
            .get_mut(&a)
            .unwrap()
            .windup
            .as_mut()
            .unwrap()
            .cancelable = false;
        let release = s.players[&a].windup.as_ref().unwrap().release;
        for action in [
            Action::Stop,
            Action::Move {
                point: Point { x: 200., z: 100. },
            },
            Action::Attack { target: d },
        ] {
            assert!(s.command(a, action).is_err());
            assert_eq!(s.players[&a].target, Some(b));
            assert_eq!(s.players[&a].windup.as_ref().unwrap().release, release);
            assert!(s.players[&a].destination.is_none());
        }
        s.command(a, Action::Attack { target: b }).unwrap();
        assert_eq!(s.players[&a].windup.as_ref().unwrap().release, release);
        while s.tick < release {
            s.advance();
        }
        assert_eq!(s.projectiles.len(), 1);
        assert_eq!(s.projectiles[0].target, b);
    }
    #[test]
    fn target_death_discards_projectile_and_attack_speed_changes_windup() {
        let (mut s, a, b) = game("ashe");
        s.command(a, Action::Attack { target: b }).unwrap();
        while s.projectiles.is_empty() {
            s.advance();
        }
        s.damage(b, 100000., false);
        s.advance();
        assert!(s.projectiles.is_empty());
        assert_eq!(s.players[&b].health, 0.);
        assert!(windup_ticks("ashe", 24) < windup_ticks("ashe", 48));
    }
}

#[cfg(test)]
mod canonical_presentation_membership_tests {
    use super::*;
    #[test]
    fn exact_canonical_membership_shares_the_cached_numeric_profiles() {
        let canonical=champion_catalog().unwrap();
        let critical:BTreeMap<String,serde_json::Value>=serde_json::from_str(include_str!("../../../data/4.20/critical_contracts.json")).unwrap();
        let animation:BTreeMap<String,serde_json::Value>=serde_json::from_str(include_str!("../../../data/4.20/animation_manifest.json")).unwrap();
        let expected:Vec<_>=canonical.keys().collect();
        assert_eq!(expected.len(),122);
        assert_eq!(profiles().keys().collect::<Vec<_>>(),expected);
        assert_eq!(critical.keys().collect::<Vec<_>>(),expected);
        assert_eq!(animation.keys().collect::<Vec<_>>(),expected);
        assert!(std::ptr::eq(profiles(),profiles()));
        for name in canonical.keys() {
            assert!(supports_champion_presentation(name));
            assert!(std::ptr::eq(profile(name),&profiles()[name]));
        }
        for alias in ["", "Annie", "Ahri", "wukong", "unknown_champion"] {
            assert!(!supports_champion_presentation(alias));
        }
    }
}
