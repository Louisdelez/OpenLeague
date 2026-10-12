//! Native Map10 waves, NPC entities, camps, basic combat and structure dependencies.
//! Complete native AI, tower item effects, relics and Vilemaw's special kit remain separate work.
use crate::*;
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Kind {
    Melee,
    Caster,
    Siege,
    Super,
    Monster,
    Pet,
    Boss,
    Turret,
    Fountain,
    Inhibitor,
    Nexus,
}
impl Kind {
    pub fn lane(self) -> bool {
        matches!(self, Self::Melee | Self::Caster | Self::Siege | Self::Super)
    }
    pub fn structure(self) -> bool {
        matches!(
            self,
            Self::Turret | Self::Fountain | Self::Inhibitor | Self::Nexus
        )
    }
}
#[derive(Clone, Deserialize)]
pub struct Definition {
    pub id: String,
    pub kind: Kind,
    pub asset: String,
    pub scale: f32,
    pub health: f32,
    pub damage: f32,
    pub armor: f32,
    pub magic_resist: f32,
    pub move_speed: f32,
    pub attack_range: f32,
    pub attack_cooldown: u64,
    pub attack_windup: u64,
    pub acquisition: f32,
    pub radius: f32,
    pub experience: f32,
    pub gold: f32,
    pub global_experience: f32,
    pub global_gold: f32,
    pub hp_upgrade: f32,
    pub damage_upgrade: f32,
    pub armor_upgrade: f32,
    pub mr_upgrade: f32,
    pub gold_upgrade: f32,
    pub gold_max_bonus: f32,
    pub projectile_speed: f32,
}
#[derive(Clone, Deserialize)]
pub struct Structure {
    pub name: String,
    pub definition: String,
    pub team: u8,
    pub position: Point,
    pub height: f32,
    pub lane: Option<usize>,
    pub depends_all: Vec<String>,
    pub depends_any: Vec<String>,
}
#[derive(Clone, Deserialize)]
pub struct Lane {
    pub points: Vec<Point>,
}
#[derive(Clone, Deserialize)]
pub struct Member {
    pub definition: String,
    pub position: Point,
    pub height: f32,
    pub facing: f32,
}
#[derive(Clone, Deserialize)]
pub struct Camp {
    pub index: u8,
    pub initial_seconds: f32,
    pub respawn_seconds: f32,
    pub members: Vec<Member>,
}
#[derive(Clone, Deserialize)]
pub struct Config {
    pub definitions: BTreeMap<String, Definition>,
    pub structures: Vec<Structure>,
    pub lanes: Vec<Lane>,
    pub camps: Vec<Camp>,
    pub initial_wave_seconds: f32,
    pub wave_seconds: f32,
    pub unit_spacing_seconds: f32,
    pub upgrade_seconds: f32,
    pub cannon_change_seconds: f32,
    pub experience_radius: f32,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Unit {
    pub id: u32,
    pub name: String,
    pub definition: String,
    pub kind: Kind,
    pub team: u8,
    pub position: Point,
    pub height: f32,
    pub facing: f32,
    pub health: f32,
    pub max_health: f32,
    pub damage: f32,
    pub armor: f32,
    pub magic_resist: f32,
    pub gold: f32,
    pub experience: f32,
    pub target: Option<u32>,
    pub destination: Option<Point>,
    pub next_attack: u64,
    /// Snapshot-only observation of the existing Vilemaw windup, never targeting authority.
    #[serde(default)]
    pub attack_presentation: Option<attack_presentation::Attack>,
    pub silence_until: u64,
    pub respawn_at: Option<u64>,
    #[serde(default)]
    pub pet: Option<annie_r::Pet>,
    #[serde(default)]
    pub stuns: Vec<stuns::Stun>,
    #[serde(default)]
    pub vision_radius_modifiers: vision::RadiusModifiers,
    #[serde(skip)]
    pub path: VecDeque<Point>,
    #[serde(skip)]
    pub route: VecDeque<Point>,
    #[serde(skip)]
    pub home: Option<Point>,
    #[serde(skip)]
    pub camp: Option<u8>,
    #[serde(skip)]
    pub lane: Option<usize>,
    #[serde(skip)]
    pub next_ai: u64,
    #[serde(skip)]
    pub remove_at: Option<u64>,
}
#[derive(Clone)]
struct CampState {
    config: Camp,
    members: Vec<u32>,
    spawn_at: Option<u64>,
}
#[derive(Clone)]
pub(crate) struct World {
    pub config: Config,
    camps: Vec<CampState>,
    wave: u64,
    slot: usize,
    next_slot: u64,
    plans: Vec<(u8, usize, Vec<Kind>)>,
    attacks: Vec<Pending>,
}
#[derive(Clone)]
struct Pending {
    source: u32,
    target: u32,
    damage: f32,
    resolves: u64,
    releases: u64,
    ranged: bool,
    launched: bool,
    presentation: Option<attack_presentation::Attack>,
}
#[derive(Clone, Copy)]
pub(crate) struct Target {
    pub position: Point,
    pub health: f32,
    pub team: u8,
    pub radius: f32,
}
impl Simulation {
    pub fn enable_map10(&mut self) -> Result<(), String> {
        if self.world.is_some() {
            return Err("Map10 already enabled".into());
        }
        let mut config: Config =
            serde_json::from_str(include_str!("../../../data/4.20/map10_world.json"))
                .map_err(|e| e.to_string())?;
        config.definitions.insert("annietibbers".into(),annie_r::definition());
        let camps = config
            .camps
            .iter()
            .map(|c| CampState {
                config: c.clone(),
                members: Vec::new(),
                spawn_at: Some(spells::seconds(c.initial_seconds)),
            })
            .collect();
        self.world = Some(World {
            next_slot: spells::seconds(config.initial_wave_seconds),
            config: config.clone(),
            camps,
            wave: 1,
            slot: 0,
            plans: Vec::new(),
            attacks: Vec::new(),
        });
        for s in config.structures {
            self.spawn_unit(
                &s.definition,
                &s.name,
                s.team,
                s.position,
                s.height,
                0.,
                None,
                s.lane,
            )?;
        }
        self.enable_interactions();
        Ok(())
    }
    pub(crate) fn target_info(&self, id: u32) -> Option<Target> {
        if let Some(p) = self.players.get(&id) {
            return Some(Target {
                position: p.position,
                health: p.health,
                team: p.team,
                radius: collision::body_radius(collision::profile(&p.champion).gameplay_radius),
            });
        }
        let p = self.units.get(&id)?;
        let definition = self.world.as_ref()?.config.definitions.get(&p.definition)?;
        Some(Target {
            position: p.position,
            health: p.health,
            team: p.team,
            radius: definition.radius,
        })
    }
    pub fn protected(&self, id: u32) -> bool {
        let Some(unit) = self.units.get(&id) else {
            return false;
        };
        if unit.kind == Kind::Fountain {
            return true;
        }
        let Some(world) = &self.world else {
            return false;
        };
        let Some(rule) = world.config.structures.iter().find(|s| s.name == unit.name) else {
            return false;
        };
        let alive = |name: &String| {
            self.units
                .values()
                .any(|u| u.name == *name && u.health > 0.)
        };
        rule.depends_all.iter().any(alive)
            || (!rule.depends_any.is_empty() && rule.depends_any.iter().all(alive))
    }
    pub(crate) fn spawn_unit(
        &mut self,
        definition: &str,
        name: &str,
        team: u8,
        position: Point,
        height: f32,
        facing: f32,
        camp: Option<u8>,
        lane: Option<usize>,
    ) -> Result<u32, String> {
        let def = self
            .world
            .as_ref()
            .ok_or("world disabled")?
            .config
            .definitions
            .get(definition)
            .ok_or("unknown NPC definition")?
            .clone();
        let id = self.next_id;
        self.next_id += 1;
        let level = self.players.values().map(|p| p.level as f32).sum::<f32>()
            / (self.players.len().max(1) as f32);
        let upgrades = if def.kind.lane() {
            self.tick as f32
                / (TICK_RATE as f32 * self.world.as_ref().unwrap().config.upgrade_seconds)
        } else {
            0.
        };
        let upgrades = upgrades.floor();
        // Native lane modifiers replace reward values from the character file.
        let health = def.health + def.hp_upgrade * upgrades;
        let mut unit = Unit {
            id,
            name: name.into(),
            definition: definition.into(),
            kind: def.kind,
            team,
            position,
            height: self.navigation.ground(position).unwrap_or(height),
            facing,
            health,
            max_health: health,
            damage: def.damage + def.damage_upgrade * upgrades,
            armor: def.armor + def.armor_upgrade * upgrades,
            magic_resist: def.magic_resist + def.mr_upgrade * upgrades,
            gold: def.gold + (def.gold_upgrade * upgrades).min(def.gold_max_bonus),
            experience: def.experience,
            target: None,
            destination: None,
            next_attack: 0,
            attack_presentation: None,
            silence_until: 0,
            respawn_at: None,
            pet: None,
            stuns: Vec::new(),
            vision_radius_modifiers: Default::default(),
            path: VecDeque::new(),
            route: VecDeque::new(),
            home: camp.map(|_| position),
            camp,
            lane,
            next_ai: 0,
            remove_at: None,
        };
        // Higher-level monster scaling is deliberately not fabricated from generic champion growth.
        let _spawn_level = level;
        if let Some(lane) = lane.filter(|_| def.kind.lane()) {
            let mut route = self.world.as_ref().unwrap().config.lanes[lane]
                .points
                .clone();
            if team == 1 {
                route.reverse();
            }
            unit.route = route.into_iter().skip(1).collect();
        }
        self.units.insert(id, unit);
        Ok(id)
    }
    pub(crate) fn hit(&mut self, source: u32, target: u32, raw: f32, magic: bool) {
        let _ = self.hit_result(source, target, raw, magic);
    }
    pub(crate) fn hit_result(&mut self, source: u32, target: u32, raw: f32, magic: bool)
        -> Result<damage::DamageOutcome, String> {
        if !magic { self.basic_attack_hit(source, target, raw) }
        else { self.apply_damage(Some(source), target, raw, damage::DamageKind::Magical) }
    }
    pub(crate) fn damage_unit(
        &mut self,
        source: u32,
        target: u32,
        reduced: f32,
    ) {
        if self.winner.is_some() {return;}
        if !reduced.is_finite() || reduced < 0. || self.protected(target) {
            return;
        }
        let Some(unit) = self.units.get(&target) else {
            return;
        };
        if unit.health <= 0. {
            return;
        }

        let camp = unit.camp;
        let kind = unit.kind;
        let position = unit.position;
        let team = unit.team;
        let gold = unit.gold;
        let experience = unit.experience;
        let def = self.world.as_ref().unwrap().config.definitions[&unit.definition].clone();
        // Capture before HP/target/vision changes, independently of a detached Pending Vec.
        let death_presentation = self.capture_vilemaw_attack(target);
        let match_presentation = if kind == Kind::Nexus { self.capture_active_vilemaw_attack() } else { None };
        let unit = self.units.get_mut(&target).unwrap();
        unit.health = (unit.health - reduced).max(0.);
        if let Some(camp) = camp {
            if self.combat_owner(source).is_some() {
                for u in self
                    .units
                    .values_mut()
                    .filter(|u| u.camp == Some(camp) && u.health > 0.)
                {
                    u.target = Some(source);
                    u.next_ai = 0;
                }
            }
        }
        if self.units[&target].health > 0. {
            return;
        }
        self.cancel_captured_vilemaw_attack(death_presentation, attack_presentation::CancelReason::Death);
        let unit = self.units.get_mut(&target).unwrap();
        unit.stuns.clear();
        unit.path.clear();
        unit.destination = None;
        unit.target = None;
        if kind == Kind::Inhibitor {
            unit.respawn_at = Some(self.tick + 240 * TICK_RATE);
        } else if !kind.structure() {
            unit.remove_at = Some(self.tick + 3 * TICK_RATE);
        }
        if kind == Kind::Nexus {
            self.winner = Some(1 - team);
            self.cancel_captured_vilemaw_attack(match_presentation, attack_presentation::CancelReason::MatchEnded);
        }
        self.interrupt_unit_windup(target);
        let killing_team = self.target_info(source).map(|s| s.team).filter(|t| *t < 2);
        let altar_bonus = if kind.lane() || matches!(kind, Kind::Monster | Kind::Boss) {
            killing_team
                .map(|team| self.altar_kill_bonus(team))
                .unwrap_or(0.)
        } else {
            0.
        };
        let credited=self.combat_owner(source);
        if let Some(killer) = credited.and_then(|id|self.players.get_mut(&id)) {
            killer.gold += gold + altar_bonus;
        }
        if let Some(killing_team) = killing_team {
            let radius = self.world.as_ref().unwrap().config.experience_radius;
            let eligible: Vec<_> = if kind == Kind::Monster || kind == Kind::Boss {
                credited
                    .into_iter()
                    .collect()
            } else {
                self.players
                    .values()
                    .filter(|p| {
                        p.team == killing_team
                            && p.health > 0.
                            && p.position.distance(position) <= radius
                    })
                    .map(|p| p.id)
                    .collect()
            };
            let share = experience / eligible.len().max(1) as f32;
            for player in eligible {
                if share > 0. {
                    let _ = self.award_experience(player, share);
                }
            }
            let global: Vec<_> = self
                .players
                .values()
                .filter(|p| p.team == killing_team)
                .map(|p| p.id)
                .collect();
            for id in global {
                self.players.get_mut(&id).unwrap().gold += def.global_gold;
                if def.global_experience > 0. {
                    let _ = self.award_experience(id, def.global_experience);
                }
            }
        }
        if kind==Kind::Nexus {self.capture_final_results();}
    }
    pub(crate) fn interrupt_unit_windup(&mut self,id:u32) {
        self.cancel_vilemaw_attack(id, if self.units.get(&id).is_some_and(|u| u.health <= 0.) {
            attack_presentation::CancelReason::Death
        } else { attack_presentation::CancelReason::Control });
        if let Some(world)=&mut self.world {world.attacks.retain(|a|a.source!=id || a.launched);}
    }
    pub(crate) fn cancel_pet_attack(&mut self,id:u32) {
        if let Some(world)=&mut self.world {world.attacks.retain(|a|a.source!=id);}
    }
    fn wave_sequence(&self, world: &World, team: u8, lane: usize) -> Vec<Kind> {
        let inhibitors: Vec<_> = self
            .units
            .values()
            .filter(|u| u.team != team && u.kind == Kind::Inhibitor)
            .collect();
        let super_count = if inhibitors.len() == 2 && inhibitors.iter().all(|u| u.health <= 0.) {
            2
        } else if inhibitors
            .iter()
            .any(|u| u.lane == Some(lane) && u.health <= 0.)
        {
            1
        } else {
            0
        };
        let frequency = if self.tick >= spells::seconds(world.config.cannon_change_seconds) {
            2
        } else {
            3
        };
        let mut sequence = vec![Kind::Super; super_count];
        sequence.extend([Kind::Melee; 3]);
        if super_count == 0 && world.wave.is_multiple_of(frequency) {
            sequence.push(Kind::Siege);
        }
        sequence.extend([Kind::Caster; 3]);
        sequence
    }
    pub(crate) fn advance_world(&mut self) {
        let Some(mut world) = self.world.take() else {
            return;
        };
        // Temporarily detach the scheduler to allow entity mutations without aliasing it.
        self.world = Some(world.clone());
        for camp in &mut world.camps {
            if camp.spawn_at.is_none()
                && !camp.members.is_empty()
                && camp
                    .members
                    .iter()
                    .all(|id| self.units.get(id).is_none_or(|u| u.health <= 0.))
            {
                camp.spawn_at = Some(self.tick + spells::seconds(camp.config.respawn_seconds));
            }
            if camp.spawn_at.is_some_and(|at| self.tick >= at) {
                camp.members.clear();
                for (index, member) in camp.config.members.iter().enumerate() {
                    if let Ok(id) = self.spawn_unit(
                        &member.definition,
                        &format!("camp_{}_{}", camp.config.index, index),
                        2,
                        member.position,
                        member.height,
                        member.facing,
                        Some(camp.config.index),
                        None,
                    ) {
                        camp.members.push(id);
                    }
                }
                camp.spawn_at = None;
            }
        }
        if self.tick >= world.next_slot {
            if world.slot == 0 {
                world.plans.clear();
                for team in 0..2 {
                    for lane in 0..world.config.lanes.len() {
                        world
                            .plans
                            .push((team, lane, self.wave_sequence(&world, team, lane)));
                    }
                }
            }
            let mut longest = 0;
            for team in 0..2 {
                for lane in 0..world.config.lanes.len() {
                    let sequence = world
                        .plans
                        .iter()
                        .find(|(t, l, _)| *t == team && *l == lane)
                        .unwrap()
                        .2
                        .clone();
                    longest = longest.max(sequence.len());
                    if let Some(kind) = sequence.get(world.slot) {
                        if self
                            .units
                            .values()
                            .filter(|u| u.team == team && u.kind.lane() && u.health > 0.)
                            .count()
                            >= 180
                        {
                            continue;
                        }
                        let suffix = match kind {
                            Kind::Melee => "Basic",
                            Kind::Caster => "Wizard",
                            Kind::Siege => "MechCannon",
                            Kind::Super => "MechMelee",
                            _ => unreachable!(),
                        };
                        let definition =
                            format!("{}_Minion_{suffix}", if team == 0 { "Blue" } else { "Red" });
                        let points = &world.config.lanes[lane].points;
                        let seed = if team == 0 {
                            points[0]
                        } else {
                            *points.last().unwrap()
                        };
                        let position = if self.navigation.ground(seed).is_some() {
                            seed
                        } else {
                            self.navigation.nearest_walkable(seed).unwrap_or(seed)
                        };
                        let _ = self.spawn_unit(
                            &definition,
                            &format!("wave_{}_{}_{}_{}", world.wave, team, lane, world.slot),
                            team,
                            position,
                            0.,
                            if team == 0 { 0. } else { std::f32::consts::PI },
                            None,
                            Some(lane),
                        );
                    }
                }
            }
            world.slot += 1;
            if world.slot >= longest {
                world.wave += 1;
                world.slot = 0;
                world.next_slot = spells::seconds(
                    world.config.initial_wave_seconds
                        + (world.wave - 1) as f32 * world.config.wave_seconds,
                );
            } else {
                world.next_slot += spells::seconds(world.config.unit_spacing_seconds);
            }
        }
        let removed: Vec<_> = self
            .units
            .values()
            .filter(|u| u.remove_at.is_some_and(|at| self.tick >= at))
            .map(|u| u.id)
            .collect();
        for id in removed {
            self.cancel_vilemaw_attack(id, attack_presentation::CancelReason::Departure);
            self.units.remove(&id);
        }
        for u in self.units.values_mut() {
            if u.respawn_at.is_some_and(|at| self.tick >= at) {
                u.health = u.max_health;
                u.respawn_at = None;
            }
        }
        self.world = Some(world);
        self.advance_npc_ai();
    }
    fn advance_npc_ai(&mut self) {
        let Some(world) = &self.world else {
            return;
        };
        let definitions = world.config.definitions.clone();
        let ids: Vec<_> = self.units.keys().copied().collect();
        let mut attacks = Vec::new();
        for id in ids {
            let Some(unit) = self.units.get(&id).filter(|u| u.health > 0.) else {
                continue;
            };
            if stuns::unit_active(unit,self.tick) {continue;}
            let def = &definitions[&unit.definition];
            if unit.kind!=Kind::Pet && self.tick >= unit.next_ai {
                // Local reconstruction for the immobile Map10 boss only. Native
                // Data supplies range/speed, not this server disengagement rule.
                let stationary_vilemaw = vilemaw_attacks::is_vilemaw(unit)
                    && unit.home.is_some() && def.move_speed == 0.;
                let mut target = unit.target.filter(|id| {
                    self.target_info(*id).is_some_and(|t| {
                        t.health > 0.
                            && t.team != unit.team
                            && (unit.team == 2 || self.visible_to(unit.team, *id))
                            && (!stationary_vilemaw
                                || unit.position.distance(t.position) <= def.attack_range + t.radius)
                    })
                });
                if unit.kind.lane() || matches!(unit.kind, Kind::Turret | Kind::Fountain) {
                    let candidates = self
                        .players
                        .keys()
                        .chain(self.units.keys())
                        .copied()
                        .filter(|other| *other != id && !self.protected(*other));
                    target = candidates
                        .filter_map(|other| {
                            let t = self.target_info(other)?;
                            let distance = t.position.distance(unit.position);
                            if t.team < 2
                                && t.team != unit.team
                                && t.health > 0.
                                && distance <= def.acquisition + t.radius
                                && self.visible_to(unit.team, other)
                            {
                                Some((other, distance))
                            } else {
                                None
                            }
                        })
                        .min_by(|a, b| a.1.total_cmp(&b.1))
                        .map(|t| t.0);
                }
                let home = unit.home;
                if let Some(home) = home {
                    if unit.position.distance(home) > 800. || target.is_none() {
                        if stationary_vilemaw && self.world.as_ref().unwrap().attacks.iter()
                            .any(|attack| attack.source == id) {
                            // A captured attack remains committed to its original target.
                            // Let the real Pending resolution run below before resetting;
                            // this also leaves an already-launched projectile untouched.
                            self.units.get_mut(&id).unwrap().next_ai = self.tick + 8;
                            continue;
                        }
                        let path = self.navigation.path(unit.position, home);
                        let p = self.units.get_mut(&id).unwrap();
                        p.target = None;
                        p.health = p.max_health;
                        if p.position.distance(home) > 5. {
                            p.path = path.unwrap_or_default();
                            p.destination = Some(home);
                        } else {
                            p.path.clear();
                            p.destination = None;
                        }
                        p.next_ai = self.tick + 8;
                        continue;
                    }
                }
                let goal = target.and_then(|id| self.target_info(id));
                let position = unit.position;
                let range = def.attack_range;
                let next = if let Some(t) = goal {
                    if position.distance(t.position) > range + t.radius {
                        Some(t.position)
                    } else {
                        None
                    }
                } else if unit.kind.lane() {
                    unit.route.front().copied()
                } else {
                    None
                };
                let path = next.and_then(|p| {
                    self.navigation.path(position, p).or_else(|| {
                        self.navigation
                            .nearest_walkable(p)
                            .and_then(|p| self.navigation.path(position, p))
                    })
                });
                let p = self.units.get_mut(&id).unwrap();
                p.target = target;
                p.next_ai = self.tick + 8;
                if let Some(path) = path {
                    p.path = path;
                    p.destination = next;
                } else {
                    p.path.clear();
                    p.destination = None;
                }
            }
            let p = self.units.get_mut(&id).unwrap();
            let mut remaining = def.move_speed / TICK_RATE as f32;
            while let Some(goal) = p.path.front().copied() {
                let distance = p.position.distance(goal);
                if distance <= remaining {
                    p.position = goal;
                    p.path.pop_front();
                    remaining -= distance;
                } else {
                    p.position.x += (goal.x - p.position.x) * remaining / distance;
                    p.position.z += (goal.z - p.position.z) * remaining / distance;
                    break;
                }
                if remaining <= 0. {
                    break;
                }
            }
            if let Some(goal) = p.route.front().copied() {
                if p.target.is_none() && p.position.distance(goal) < 30. {
                    p.route.pop_front();
                }
            }
            if p.path.is_empty() {
                p.destination = None;
            }
            if let Some(height) = self.navigation.ground(p.position) {
                p.height = height;
            }
            let ready = p.next_attack <= self.tick;
            let target = p.target;
            let position = p.position;
            let damage = p.damage;
            if ready {
                if let Some(target) = target {
                    if let Some(t) = self.target_info(target).filter(|t| {
                        t.health > 0.
                            && t.position.distance(position) <= def.attack_range + t.radius
                    }) {
                        let travel = if def.projectile_speed > 0. {
                            spells::seconds(position.distance(t.position) / def.projectile_speed)
                        } else {
                            0
                        };
                        let presentation = self.begin_vilemaw_attack(id, target, self.tick + def.attack_windup);
                        self.units.get_mut(&id).unwrap().next_attack =
                            self.tick + def.attack_cooldown;
                        attacks.push(Pending {
                            source: id,
                            target,
                            damage,
                            resolves: self.tick + def.attack_windup + travel,
                            releases: self.tick + def.attack_windup,
                            ranged: def.projectile_speed > 0.,
                            launched: false,
                            presentation,
                        });
                    }
                }
            }
        }
        let world = self.world.as_mut().unwrap();
        world.attacks.extend(attacks);
        let mut pending = std::mem::take(&mut world.attacks);
        let mut remaining = Vec::new();
        for mut attack in pending.drain(..) {
            if !attack.launched && !self.units.get(&attack.source).is_some_and(|u|u.health>0. && !stuns::unit_active(u,self.tick)) {
                self.cancel_vilemaw_attack(attack.source, self.vilemaw_discard_reason(attack.source));
                continue;
            }
            if attack.ranged && attack.releases<=self.tick {attack.launched=true;}
            if attack.resolves > self.tick {
                remaining.push(attack);
            } else if (attack.launched && self.units.contains_key(&attack.source)) || self
                .units
                .get(&attack.source)
                .is_some_and(|u| u.health > 0. && !stuns::unit_active(u,self.tick))
            {
                // Resolving is private: retaliation or match-end cannot replace an applied hit by cancellation.
                let presentation = self.begin_vilemaw_resolution(attack.presentation);
                let result = self.hit_result(attack.source, attack.target, attack.damage, false);
                self.resolve_vilemaw_attack(presentation, result.is_ok());
            } else {
                self.cancel_vilemaw_attack(attack.source, self.vilemaw_discard_reason(attack.source));
            }
        }
        self.world.as_mut().unwrap().attacks = remaining;
    }
}

#[cfg(test)]
#[path = "world_tests.rs"]
mod tests;
#[cfg(test)]
#[path = "vilemaw_attack_server_tests.rs"]
mod vilemaw_attack_tests;

#[cfg(test)]
#[path = "vilemaw_disengage_tests.rs"]
mod vilemaw_disengage_tests;
