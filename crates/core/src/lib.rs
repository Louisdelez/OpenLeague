//! New deterministic simulation. Coordinates are native LoL units; ticks are 30 Hz.
pub mod camera_pan;
pub mod native_projected_receivers;
pub mod native_scalar_curve;
pub mod native_probability_curve;
pub mod native_scalar_parameter;
pub mod native_vector_curve;
pub mod native_vector_parameter;
pub mod native_integrated_vector;
pub mod native_complex_vectors;
pub mod native_crown_birth;
pub mod native_complex_mesh_pose;
pub mod native_complex_surface_prepare;
pub mod native_complex_movement;
pub mod native_complex_factory_admission;
pub mod native_complex_flex_selection;
#[cfg(test)] mod native_complex_factory_tests;
pub mod native_complex_kinematics;
pub mod native_particle_euler_matrix;
#[cfg(test)] mod native_complex_movement_tests;
pub mod native_complex_surface_rotation;
pub mod native_complex_surface_tail;
#[cfg(test)] mod native_complex_surface_tests;
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, HashMap, VecDeque};
pub const TICK_RATE: u64 = 30;
pub mod altars;
pub mod annie;
pub mod missile_lifecycle;
pub mod welcome_history;
pub mod session_transport;
pub mod session_wire;
pub mod session_random;
pub mod annie_passive;
pub mod annie_w;
pub mod annie_r;
pub mod animation_events;
pub mod audio_curves;
pub mod audio_mix;
pub mod audio_distance;
pub mod audio_gain;
pub mod audio_pitch;
pub mod audio_filter;
pub mod audio_pcm;
pub mod audio_filter_transition;
pub mod audio_requests;
pub mod audio_listener;
pub mod audio_listener_backend;
pub mod audio_release;
pub mod audio_routing;
pub mod audio_emitter_position;
pub mod audio_selection;
pub mod attacks;
pub mod attack_presentation;
pub mod vilemaw_attacks;
pub mod garen_q_resource;
#[cfg(test)]
mod garen_q_resource_tests;
#[cfg(test)]
mod attack_presentation_server_tests;
pub mod collision;
pub mod combat;
pub mod cooldown;
#[cfg(test)] mod cooldown_totals_tests;
pub mod champion_kills;
pub mod critical;
pub mod damage;
pub mod garen_passive;
pub mod healing;
pub mod interactions;
pub mod nexus_phase;
pub mod lifecycle;
pub mod lifesteal;
pub mod movement;
pub mod progression;
pub mod consumables;
pub mod penetration;
pub mod passive_gold;
pub mod regeneration;
pub mod shields;
pub mod shop;
pub mod slows;
pub mod stuns;
pub mod spells;
pub mod summoner_exhaust;
pub mod summoner_heal;
pub mod summoner_ignite;
pub mod summoner_smite;
pub mod summoners;
pub mod vision;
pub mod wire;
pub mod world;
pub mod match_results;

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct Point {
    pub x: f32,
    pub z: f32,
}
impl Point {
    pub fn distance(self, other: Self) -> f32 {
        ((self.x - other.x).powi(2) + (self.z - other.z).powi(2)).sqrt()
    }
    pub fn finite(self) -> bool {
        self.x.is_finite() && self.z.is_finite()
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ChampionDefinition {
    pub id: String,
    pub name: String,
    pub health: f32,
    pub mana: f32,
    pub attack_damage: f32,
    pub armor: f32,
    pub magic_resist: f32,
    pub move_speed: f32,
    pub attack_range: f32,
    pub attack_cooldown_ticks: u64,
}
pub fn champion_catalog() -> Result<BTreeMap<String, ChampionDefinition>, serde_json::Error> {
    let rows: Vec<ChampionDefinition> =
        serde_json::from_str(include_str!("../../../data/4.20/champions.json"))?;
    Ok(rows.into_iter().map(|r| (r.id.clone(), r)).collect())
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Champion {
    pub id: u32,
    pub champion: String,
    pub team: u8,
    pub position: Point,
    /// Public physical heading. Reconstructed Garen producer; absent means unknown.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub facing: Option<entity_facing::Facing>,
    pub height: f32,
    pub health: f32,
    pub max_health: f32,
    pub mana: f32,
    /// Snapshot-only authoritative capacity; absence in older packets means unknown.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub max_mana: Option<f32>,
    pub level: u8,
    pub experience: f32,
    #[serde(default)]
    pub score: champion_kills::Score,
    pub gold: f32,
    #[serde(default)]
    pub inventory: [Option<u32>; 6],
    #[serde(default)]
    pub inventory_counts: [u8; 6],
    pub respawn_at: Option<u64>,
    pub ranks: [u8; 4],
    pub cooldowns: [u64; 4],
    /// Duration committed by an accepted cast; absent in older snapshots is unknown.
    #[serde(default)]
    pub cooldown_totals: [Option<u64>; 4],
    pub effects: spells::Effects,
    pub shields: Vec<shields::Shield>,
    #[serde(default)]
    pub slows: Vec<slows::Slow>,
    #[serde(default)]
    pub stuns: Vec<stuns::Stun>,
    #[serde(default)]
    pub perseverance_interrupted_at: Option<u64>,
    #[serde(default)]
    pub vision_radius_modifiers: vision::RadiusModifiers,
    pub summoners: summoners::Loadout,
    pub destination: Option<Point>,
    pub target: Option<u32>,
    pub next_attack: u64,
    #[serde(default)]
    pub windup: Option<attacks::Windup>,
    #[serde(skip)]
    pub(crate) attack_roll: Option<bool>,
    #[serde(skip)]
    pub path: VecDeque<Point>,
    #[serde(skip)]
    pub next_repath: u64,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Snapshot {
    pub roster: Vec<vision::RosterEntry>,
    pub session: u64,
    pub tick: u64,
    pub players: Vec<Champion>,
    pub units: Vec<world::Unit>,
    pub winner: Option<u8>,
    #[serde(default)]
    pub result:Option<match_results::MatchResult>,
    #[serde(default)]
    pub kill_events: Vec<champion_kills::Event>,
    #[serde(default)]
    pub attack_events: Vec<attack_presentation::Event>,
    #[serde(default)]
    pub attack_presentation_error: Option<String>,
    #[serde(default)]
    pub vilemaw_attack_events: Vec<attack_presentation::Event>,
    #[serde(default)]
    pub vilemaw_attack_presentation_error: Option<String>,
    #[serde(default)]
    pub projectiles: Vec<attacks::Projectile>,
    #[serde(default)]
    pub spell_projectiles: Vec<annie::Missile>,
    pub map10: Option<interactions::MapState>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Action {
    Move { point: Point },
    Attack { target: u32 },
    Stop,
    Buy { item: u32 },
    Sell { slot: u8 },
    UseItem { slot: u8 },
    SwapItems { from: u8, to: u8 },
    /// Local drag intent: compare all captured slots/counts before changing either.
    /// The legacy unconditioned command remains available to existing clients.
    SwapItemsChecked {
        from: u8,
        to: u8,
        expected_inventory: [Option<u32>; 6],
        expected_counts: [u8; 6],
    },
    Summoner { slot: u8 },
    SummonerTarget { slot: u8, target: Option<u32> },
    Learn { slot: u8 },
    Cast { slot: u8, target: Option<u32> },
    CastAt { slot: u8, point: Point },
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ClientPacket {
    /// Explicit departure for the local transport, not the historical wire protocol.
    Leave { session: u64, player: u32, sequence: u64 },
    /// Local server request; permissions are configured by the match host.
    PauseRequest { sequence:u64, paused:bool },
    /// Acknowledgment for the local ordered clock adapter, not native wire.
    ClockAck { session:u64, ordinal:u64 },
    Join {
        champion: String,
        #[serde(default)]
        summoners: [Option<summoners::Spell>; 2],
    },
    Command {
        sequence: u64,
        action: Action,
    },
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ServerPacket {
    Welcome { player: u32, session: u64 },
    State(Snapshot),
    /// Local transport adapter for verified native A1/0A payloads. Ordinals
    /// begin at1 per Welcome identity; delivery/retransmission is server-owned.
    ClockControl { session:u64, ordinal:u64, opcode:u16, payload:Vec<u8> },
    Rejected { reason: String },
}
#[derive(Clone, Deserialize)]
pub struct NavigationMetadata {
    pub min: [f32; 3],
    #[serde(rename = "cellSize")]
    pub cell_size: f32,
    pub width: usize,
    pub height: usize,
}
#[derive(Clone)]
pub struct Navigation {
    pub metadata: NavigationMetadata,
    cells: Vec<(f32, bool, u16)>,
}
impl Navigation {
    pub fn load(metadata: &str, bytes: &[u8]) -> Result<Self, String> {
        let m: NavigationMetadata = serde_json::from_str(metadata).map_err(|e| e.to_string())?;
        if m.width == 0
            || m.height == 0
            || !m.cell_size.is_finite()
            || m.cell_size <= 0.
            || bytes.len()
                != m.width
                    .checked_mul(m.height)
                    .and_then(|n| n.checked_mul(11))
                    .ok_or("grid too large")?
        {
            return Err("invalid native navigation dimensions".into());
        }
        let cells = bytes
            .chunks_exact(11)
            .map(|c| {
                let h = f32::from_le_bytes(c[0..4].try_into().unwrap());
                let flags = u16::from_le_bytes([c[4], c[5]]);
                (h, h.is_finite() && flags & 2 == 0, flags)
            })
            .collect();
        Ok(Self { metadata: m, cells })
    }
    fn index(&self, p: Point) -> Option<usize> {
        if !p.finite() {
            return None;
        }
        let x = ((p.x - self.metadata.min[0]) / self.metadata.cell_size).floor();
        let z = ((p.z - self.metadata.min[2]) / self.metadata.cell_size).floor();
        if x < 0. || z < 0. || x >= self.metadata.width as f32 || z >= self.metadata.height as f32 {
            return None;
        }
        Some(z as usize * self.metadata.width + x as usize)
    }
    fn center(&self, i: usize) -> Point {
        Point {
            x: self.metadata.min[0]
                + (i % self.metadata.width) as f32 * self.metadata.cell_size
                + self.metadata.cell_size / 2.,
            z: self.metadata.min[2]
                + (i / self.metadata.width) as f32 * self.metadata.cell_size
                + self.metadata.cell_size / 2.,
        }
    }
    pub fn ground(&self, p: Point) -> Option<f32> {
        let i = self.index(p)?;
        self.cells[i].1.then_some(self.cells[i].0)
    }
    pub fn path(&self, start: Point, end: Point) -> Option<VecDeque<Point>> {
        let s = self.index(start)?;
        let g = self.index(end)?;
        if !self.cells[s].1 || !self.cells[g].1 {
            return None;
        }
        let mut queue = VecDeque::from([s]);
        let mut parent = HashMap::from([(s, s)]);
        while let Some(i) = queue.pop_front() {
            if i == g {
                let mut path = VecDeque::new();
                let mut n = g;
                while n != s {
                    path.push_front(self.center(n));
                    n = parent[&n]
                }
                path.push_back(end);
                return Some(path);
            }
            let x = i % self.metadata.width;
            let z = i / self.metadata.width;
            for (dx, dz) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
                let nx = x as isize + dx;
                let nz = z as isize + dz;
                if nx < 0
                    || nz < 0
                    || nx >= self.metadata.width as isize
                    || nz >= self.metadata.height as isize
                {
                    continue;
                }
                let n = nz as usize * self.metadata.width + nx as usize;
                if self.cells[n].1 && !parent.contains_key(&n) {
                    parent.insert(n, i);
                    queue.push_back(n)
                }
            }
        }
        None
    }
    pub fn nearest_walkable(&self, p: Point) -> Option<Point> {
        self.cells
            .iter()
            .enumerate()
            .filter(|(_, c)| c.1)
            .min_by(|(a, _), (b, _)| {
                self.center(*a)
                    .distance(p)
                    .total_cmp(&self.center(*b).distance(p))
            })
            .map(|(i, _)| self.center(i))
    }
}
pub struct Simulation {
    pub session: u64,
    pub tick: u64,
    pub players: BTreeMap<u32, Champion>,
    pub definitions: BTreeMap<String, ChampionDefinition>,
    pub navigation: Navigation,
    next_id: u32,
    pub units: BTreeMap<u32, world::Unit>,
    pub winner: Option<u8>,
    final_result:Option<match_results::MatchResult>,
    world: Option<world::World>,
    interactions: Option<interactions::Interactions>,
    growth: BTreeMap<String, progression::Growth>,
    pub(crate) projectiles: Vec<attacks::Projectile>,
    pub(crate) spell_projectiles: Vec<annie::Missile>,
    pub(crate) next_projectile: u64,
    pub(crate) critical_rng: u64,
    pub(crate) kill_rewards: champion_kills::State,
    pub(crate) attack_presentation: attack_presentation::State,
    pub(crate) attack_presentation_error: Option<String>,
    pub(crate) vilemaw_attacks: vilemaw_attacks::State,
    // Validated data binding; mechanics remain their explicitly existing policy.
    pub(crate) garen_q_resource: &'static garen_q_resource::Binding,
}
impl Simulation {
    pub fn new(navigation: Navigation) -> Result<Self, String> {
        Ok(Self {
            projectiles: Vec::new(),
            spell_projectiles: Vec::new(),
            next_projectile: 1,
            critical_rng: 0,
            kill_rewards: Default::default(),
            // Local session limit, matching join's six-player policy.
            attack_presentation: attack_presentation::State::new(
                attack_presentation::Limits::new(6).map_err(|e| format!("attack presentation capacity: {e:?}"))?),
            attack_presentation_error: None,
            vilemaw_attacks: vilemaw_attacks::State::default(),
            garen_q_resource: garen_q_resource::binding().map_err(str::to_owned)?,
            session: 0,
            tick: 0,
            players: BTreeMap::new(),
            definitions: champion_catalog().map_err(|e| e.to_string())?,
            navigation,
            next_id: 1,
            units: BTreeMap::new(),
            winner: None,
            final_result:None,
            world: None,
            interactions: None,
            growth: serde_json::from_str(include_str!(
                "../../../data/4.20/champion_growth_420.json"
            ))
            .map_err(|e| e.to_string())?,
        })
    }
    pub fn join(&mut self, name: &str) -> Result<u32, String> {
        if self.winner.is_some() {return Err("match finished".into());}
        let def = self.definitions.get(name).ok_or("unknown champion")?;
        if self.players.len() >= 6 {
            return Err("3v3 lobby full".into());
        }
        let blue = self.players.values().filter(|p| p.team == 0).count();
        let purple = self.players.values().filter(|p| p.team == 1).count();
        let team = if blue <= purple { 0 } else { 1 };
        let spawns: Vec<serde_json::Value> = serde_json::from_str(include_str!(
            "../../../data/4.20/champion_spawns_map10.json"
        ))
        .map_err(|e| e.to_string())?;
        let seed: Point = serde_json::from_value(spawns[team as usize]["point"].clone())
            .map_err(|e| e.to_string())?;
        let position = if self.navigation.ground(seed).is_some() {
            seed
        } else {
            self.navigation
                .nearest_walkable(seed)
                .ok_or("no walkable spawn")?
        };
        let id = self.next_id;
        self.next_id += 1;
        self.players.insert(
            id,
            Champion {
                id,
                champion: name.into(),
                team,
                position,
                facing: None,
                height: self.navigation.ground(position).unwrap(),
                health: def.health,
                max_health: def.health,
                mana: def.mana,
                max_mana: None,
                level: 1,
                experience: 0.,
                score: Default::default(),
                gold: shop::starting_gold(),
                inventory: [None; 6],
                inventory_counts: [0; 6],
                respawn_at: None,
                ranks: [0; 4],
                cooldowns: [0; 4],
                cooldown_totals: [None; 4],
                effects: spells::Effects::default(),
                shields: Vec::new(),
                slows: Vec::new(),
                stuns: Vec::new(),
                perseverance_interrupted_at: None,
                vision_radius_modifiers: Default::default(),
                summoners: summoners::Loadout::default(),
                destination: None,
                target: None,
                next_attack: 0,
                windup: None,
                attack_roll: None,
                path: VecDeque::new(),
                next_repath: 0,
            },
        );
        Ok(id)
    }
    pub fn command(&mut self, id: u32, action: Action) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        let player = self.players.get(&id).ok_or("unknown player")?;
        if player.health <= 0. {
            return Err("champion dead".into());
        }
        if stuns::active(player,self.tick) && matches!(&action,Action::Move{..}|Action::Attack{..}) {return Err("champion stunned".into());}
        match action {
            Action::Buy { item } => self.buy_item(id, item)?,
            Action::Sell { slot } => self.sell_item(id, slot)?,
            Action::UseItem { slot } => self.use_item(id, slot)?,
            Action::SwapItems { from, to } => self.swap_items(id, from, to)?,
            Action::SwapItemsChecked { from, to, expected_inventory, expected_counts } =>
                self.swap_items_checked(id, from, to, expected_inventory, expected_counts)?,
            Action::Summoner { slot } => self.cast_summoner(id, slot)?,
            Action::SummonerTarget { slot, target } => self.cast_summoner_on(id, slot, target)?,
            Action::Learn { slot } => self.learn(id, slot)?,
            Action::Cast { slot, target } => self.cast(id, slot, target)?,
            Action::CastAt {slot,point} => self.cast_at(id,slot,point)?,
            Action::Move { point } => {
                if player.effects.ultimate.is_some() {
                    return Err("casting ultimate".into());
                }
                let path = self
                    .navigation
                    .path(player.position, point)
                    .ok_or("destination unreachable")?;
                self.cancel_windup(id)?;
                let p = self.players.get_mut(&id).unwrap();
                p.destination = Some(point);
                p.path = path;
                p.target = None;
            }
            Action::Attack { target } => {
                if player.effects.ultimate.is_some() || self.tick < player.effects.spin_until {
                    return Err("attacks disabled during cast".into());
                }
                let enemy = self.target_info(target).ok_or("unknown target")?;
                if self.protected(target) {
                    return Err("target protected".into());
                }
                if enemy.team == player.team || enemy.health <= 0. {
                    return Err("invalid enemy target".into());
                }
                if !self.visible_to(player.team, target) {
                    return Err("target not visible".into());
                }
                let p = self.players.get_mut(&id).unwrap();
                if p.windup.as_ref().is_some_and(|w| w.target != target) {
                    self.cancel_windup(id)?;
                }
                let p = self.players.get_mut(&id).unwrap();
                p.target = Some(target);
                p.path.clear();
                p.destination = None;
                p.next_repath = 0;
            }
            Action::Stop => {
                if player.effects.ultimate.is_some() {
                    return Err("ultimate cannot be cancelled".into());
                }
                self.cancel_windup(id)?;
                let p = self.players.get_mut(&id).unwrap();
                p.path.clear();
                p.destination = None;
                p.target = None;
            }
        }
        Ok(())
    }
    pub fn advance(&mut self) {
        if self.winner.is_some() {
            self.capture_final_results();
            return;
        }
        self.tick += 1;
        // Visual phase follows the authoritative tick even when advance_world
        // ends the match before the remaining interaction systems run.
        if let Some(i) = &mut self.interactions { i.state.nexus_crystal.advance(self.tick); }
        self.advance_shields();
        self.advance_slows();
        self.advance_stuns();
        self.advance_pet_orders();
        self.advance_world();
        if self.winner.is_some() {
            self.capture_final_results();
            return;
        }
        self.advance_passive_gold();
        self.advance_respawns();
        self.advance_ignite();
        self.advance_consumables();
        self.advance_interactions();
        self.advance_spells();
        self.advance_annie();
        self.advance_annie_w();
        self.advance_annie_r();
        self.advance_pet_aura();
        self.advance_regeneration();
        self.advance_pursuit();
        let movement_speeds: HashMap<u32, f32> = self
            .players
            .keys()
            .map(|id| (*id, self.movement_speed(*id)))
            .collect();
        for p in self.players.values_mut() {
            if p.health <= 0. || stuns::active(p,self.tick) {
                continue;
            }
            if p.effects.ultimate.is_some() || p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.effects.annie_r.is_some() || p.windup.is_some() {
                continue;
            }
            let before = p.position;
            let mut remaining = movement_speeds[&p.id] / TICK_RATE as f32;
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
            p.capture_facing([p.position.x - before.x, 0., p.position.z - before.z]);
            if p.path.is_empty() {
                p.destination = None;
            }
            if let Some(h) = self.navigation.ground(p.position) {
                p.height = h;
            }
        }
        self.advance_attacks();
    }
    pub fn snapshot(&self) -> Snapshot {
        Snapshot {
            projectiles: self.projectiles.clone(),
            spell_projectiles: self.spell_projectiles.clone(),
            roster: self
                .players
                .values()
                .map(|p| vision::RosterEntry {
                    id: p.id,
                    champion: p.champion.clone(),
                    team: p.team,
                    score: p.score,
                })
                .collect(),
            session: self.session,
            tick: self.tick,
            players: self.players.values().map(|p| {let mut state=p.clone();state.max_mana=Some(self.stats(p.id).max_mana);state}).collect(),
            units: self.units.values().map(|unit| {
                let mut unit = unit.clone();
                unit.attack_presentation = if vilemaw_attacks::is_vilemaw(&unit) { self.vilemaw_attacks.active(unit.id) } else { None };
                unit
            }).collect(),
            winner: self.winner,
            result:self.final_result.clone(),
            kill_events: self.kill_rewards.events.iter().cloned().collect(),
            // Omniscient/debug snapshot; network callers must use snapshot_for.
            attack_events: self.attack_presentation.events(),
            attack_presentation_error: self.attack_presentation_error.clone(),
            vilemaw_attack_events: self.vilemaw_attacks.events(),
            vilemaw_attack_presentation_error: self.vilemaw_attacks.error().map(str::to_owned),
            map10: self.interactions.as_ref().map(|i| i.state.clone()),
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn grid() -> Navigation {
        let m = r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":3}"#;
        let mut b = Vec::new();
        for i in 0..12 {
            b.extend(0f32.to_le_bytes());
            b.extend(if i == 5 { 2u16 } else { 0 }.to_le_bytes());
            b.extend(0u32.to_le_bytes());
            b.push(1)
        }
        Navigation::load(m, &b).unwrap()
    }
    #[test]
    fn catalog_contains_native_roster() {
        let c = champion_catalog().unwrap();
        assert_eq!(c.len(), 122);
        assert!(c
            .values()
            .all(|d| d.health > 0. && d.move_speed > 0. && d.attack_cooldown_ticks > 0));
    }
    #[test]
    fn movement_routes_around_blocked_cells() {
        let n = grid();
        let p = n
            .path(Point { x: 25., z: 75. }, Point { x: 175., z: 75. })
            .unwrap();
        assert!(p.iter().all(|p| n.ground(*p).is_some()));
        assert!(p.len() > 3);
    }
    #[test]
    fn rejects_nonfinite_and_wall_destinations() {
        let n = grid();
        assert!(n
            .path(
                Point { x: 25., z: 25. },
                Point {
                    x: f32::NAN,
                    z: 25.
                }
            )
            .is_none());
        assert!(n
            .path(Point { x: 25., z: 25. }, Point { x: 75., z: 75. })
            .is_none());
    }
    #[test]
    fn simulation_limits_lobby_and_forbids_friendly_fire() {
        let mut s = Simulation::new(grid()).unwrap();
        let a = s.join("garen").unwrap();
        let _b = s.join("ahri").unwrap();
        let c = s.join("annie").unwrap();
        assert!(s.command(a, Action::Attack { target: c }).is_err());
        for _ in 0..3 {
            s.join("garen").unwrap();
        }
        assert!(s.join("garen").is_err());
    }
    #[test]
    fn attack_damage_is_authoritative_and_respects_cooldown() {
        let mut s = Simulation::new(grid()).unwrap();
        let a = s.join("garen").unwrap();
        let b = s.join("ahri").unwrap();
        let start = s.players[&b].health;
        s.players.get_mut(&a).unwrap().position = Point { x: 25., z: 25. };
        s.players.get_mut(&b).unwrap().position = Point { x: 30., z: 25. };
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        let release = s.players[&a].windup.as_ref().unwrap().release;
        assert_eq!(s.players[&b].health, start);
        while s.tick < release {
            s.advance();
        }
        assert!(s.players[&b].health < start);
        let after = s.players[&b].health;
        s.advance();
        assert!(
            (s.players[&b].health
                - after
                - s.regeneration_rates(b).unwrap().health_per_second / 30.)
                .abs()
                < 0.001
        );
    }
    #[test]
    fn reconnect_fills_the_team_with_a_free_slot() {
        let mut simulation = Simulation::new(grid()).unwrap();
        let mut ids = Vec::new();
        for _ in 0..6 {
            ids.push(simulation.join("garen").unwrap());
        }
        assert_eq!(simulation.players[&ids[0]].team, 0);
        simulation.players.remove(&ids[0]);
        let replacement = simulation.join("ahri").unwrap();
        assert_eq!(simulation.players[&replacement].team, 0);
        assert_eq!(
            simulation.players.values().filter(|p| p.team == 0).count(),
            3
        );
        assert_eq!(
            simulation.players.values().filter(|p| p.team == 1).count(),
            3
        );
    }
}

#[cfg(test)]
mod spell_tests;
pub mod audio_source_storage;
pub mod audio_voice_refresh;
pub mod audio_object_registration;

pub mod audio_logical_registration;

pub mod audio_backend_references;

pub mod audio_voice_position;

pub mod audio_event_post;

pub mod audio_object_callbacks;

pub mod audio_deferred_pool;

pub mod audio_unbound_post;

pub mod audio_voice_constructor;

pub mod audio_voice_factory;

pub mod audio_object_association;

pub mod audio_managed_voice;

pub mod audio_engine_objects;

pub mod audio_launch_dispatcher;

pub mod audio_legacy_paths;

pub mod audio_voice_wrapper;

pub mod audio_announcer_names;
pub mod audio_announcer_team_tokens;
pub mod audio_announcer_actor_tokens;
pub mod audio_announcer_object_lookup;
pub mod audio_announcer_actor_wrapper;
pub mod audio_announcer_actor_name;
pub mod audio_announcer_champion_name;
pub mod audio_announcer_relations;
pub mod audio_announcer_team_colors;
pub mod audio_announcer_name_provider;
pub mod audio_announcer_name_encoding;

pub mod audio_announcer_catalog;

pub mod audio_emitter_end;

pub mod audio_inactive_queue;

pub mod entity_deactivation;

pub mod entity_removal_queue;

pub mod entity_target_removal;

pub mod audio_emitter_stop;

pub mod audio_emitter_drain;

pub mod audio_emitter_finish;

pub mod audio_emitter_bounds;

pub mod audio_emitter_planes;

pub mod audio_emitter_camera_volume;

pub mod camera_parameters;

pub mod camera_aspect;

pub mod camera_view;

pub mod camera_projection;

pub mod matrix_inverse;

pub mod camera_culling;

pub mod camera_prepare;

pub mod camera_zoom;

pub mod camera_rotation;

pub mod camera_normal;

pub mod camera_focus;

pub mod camera_defaults;

pub mod camera_sequence;

pub mod camera_target;

pub mod native_random;

pub mod camera_shake;

pub mod camera_alternate;

pub mod camera_angles;

pub mod entity_camera_matrix;

pub mod entity_position_cache;

pub mod entity_yaw;
pub mod entity_facing;

pub mod camera_fps_settings;

pub mod camera_wheel;

mod native_resource_snapshot;

pub mod native_color_curve;

pub mod native_complex_color;

pub mod native_color_consumers;

pub mod native_complex_age;

pub mod native_complex_timing;

pub mod native_complex_instance_life;

pub mod native_complex_linger;

pub mod native_complex_life_scale;

pub mod native_complex_emission_gate;

pub mod native_complex_emission_count;

pub mod native_complex_birth;

pub mod native_complex_particle_age;

pub mod native_complex_frame_dispatch;
pub mod native_complex_lifetime_scale;
pub mod native_complex_uv_scroll;
pub mod native_complex_uv_parameters;
pub mod native_complex_particle_storage;
pub mod native_complex_trail_resources;
pub mod native_troy_stop_consumer;
pub mod native_troy_position_bounds;

pub mod native_troy_scalar;

pub mod native_troy_properties;

pub mod native_troy_owner_pose;

pub mod native_troy_target_pose;

pub mod native_troy_copyback;

pub mod native_troy_attachments;
pub mod native_troy_reset;
pub mod native_troy_prewarm;
pub mod native_troy_resume;
pub mod native_troy_scratch;
pub mod native_troy_frame_gate;
pub mod native_troy_frame_timing;
pub mod native_troy_substeps;

pub mod native_troy_frame_finish;

pub mod native_troy_oneshot;

pub mod native_troy_frame;

pub mod native_simple_control;

pub mod native_simple_auxiliary;

pub mod native_simple_animation_clock;

pub mod native_simple_animation_policy;
pub mod native_simple_type11_pose;

pub mod native_simple_finish;
pub mod native_simple_frame;
pub mod native_simple_particle_age;
pub mod native_simple_forces;
pub mod native_particle_force_body;
pub mod native_particle_random_force;
pub mod native_particle_axis_force;
pub mod native_particle_force_graph;
pub mod native_simple_concrete_forces;
pub mod native_simple_motion_axis;
pub mod native_simple_circular_motion;
pub mod native_simple_movement;
pub mod native_simple_scalar_phase;
pub mod native_simple_scalar_integration;
pub mod native_simple_scaled_scalar;
pub mod native_simple_attribute_policy;
pub mod native_simple_particle_tail;
pub mod native_simple_terrain_follow;
pub mod native_simple_particle_bounds;
pub mod native_simple_bounds_policy;
pub mod native_simple_attachment;
pub mod native_simple_particle_update;

pub mod native_simple_pose;
pub mod native_simple_concrete_frame;

pub mod native_simple_birth_insert;

pub mod native_simple_emission_count;

pub mod native_simple_emission_lifecycle;

pub mod native_simple_storage;

pub mod native_simple_birth_parameters;

pub mod native_particle_attributes;
pub mod native_simple_rotation_list;

pub mod native_simple_birth_factors;

pub mod native_simple_emission_sources;

pub mod native_actor_effect_owner;

pub mod native_missile_effect_owner;

pub mod native_missile_owner_pose;

pub mod native_missile_initial_direction;

pub mod native_missile_motion;

pub mod native_missile_impact;

pub mod native_effect_pending_creation;

pub mod native_effect_live_creation;

pub mod native_effect_resource_skin_alias;

pub mod native_missile_position_sync;

pub mod native_actor_target_validity;

pub mod native_missile_resource_selection;

pub mod native_troy_resource_initial;

pub mod native_troy_clock;
pub mod native_game_clock;
pub mod native_pause_packet;

pub mod native_projectile_stop_dispatch;

pub mod native_projectile_factory_pose;

pub mod native_projectile_owner_properties;

pub mod entity_visibility_merge;

pub mod spatial_visibility_query;

pub mod spatial_visibility_root;

pub mod spatial_visibility_grid;

pub mod spatial_visibility;

pub mod entity_visibility_frame;

pub mod projectile_spatial_bounds;

pub mod native_troy_simulation_flags;

pub mod audio_media;

pub mod audio_random;

pub mod audio_playlist;

pub mod audio_schedule;

pub mod audio_action_dispatch;

pub mod audio_emitter_flags;

pub mod audio_logical_worker;

pub mod audio_seek_dispatch;

pub mod audio_parameter_inheritance;

pub mod audio_parameter_getters;

pub mod audio_rtpc_manager;

pub mod audio_rtpc_bank;

pub mod audio_rtpc_subscriptions;

pub mod audio_active_voice_cache;

pub mod audio_control_refresh;

pub mod audio_actor_controls;

pub mod audio_spatial_controls;

pub mod audio_actor_flag;

pub mod audio_pair_controls;
pub mod audio_priority_transition;

pub mod audio_source_controls;

pub mod audio_routing_context;

pub mod audio_bus_controls;

pub mod audio_gain_entries;

pub mod audio_bus_registry;

pub mod audio_bus_bank;

pub mod audio_bus_properties_bank;

pub mod audio_bus_parent;

pub mod audio_bus_active_groups;

pub mod audio_bus_parameter_notification;

pub mod audio_bus_control_application;

pub mod audio_bus_effects_bank;

pub mod audio_bus_source_mask;

pub mod audio_bus_effect_slot_dispatch;
pub mod audio_bus_effects_changed;

#[cfg(test)] mod audio_bus_effect_callbacks_composition_test;

pub mod audio_bus_gain_aggregation;

pub mod audio_bus_gain_application;
pub mod audio_bus_effect_consumers;

pub mod audio_bus_effect_instance;

#[cfg(test)]mod audio_bus_effect_instance_composition_test;

pub mod audio_plugin_factory;

pub mod audio_meter_lifecycle;

pub mod audio_meter_dsp;

pub mod audio_meter_instance;

#[cfg(test)]mod audio_meter_effect_reader_test;

pub mod audio_plugin_registration;

pub mod audio_effect_resource_parameter;

pub mod audio_effect_resource_bank;

pub mod audio_effect_resource_registry;

pub mod audio_effect_bank_loader;

#[cfg(test)]mod audio_effect_bank_voice_test;

pub mod audio_bank_header;

pub mod audio_bank_memory_reader;

pub mod audio_bank_notification;

pub mod audio_bank_command_queue;

pub mod audio_bank_command_worker;

pub mod audio_common_queue;

pub mod audio_bank_deferred_consumer;

pub mod audio_bank_media_lookup;
pub mod audio_plugin_context;
pub mod audio_bank_voice_effects;
pub mod audio_rtpc_subscriber_release;
pub mod audio_rtpc_output_setter;

pub mod audio_rtpc_registration;

pub mod audio_callback_registry;

pub mod audio_frame_quota;

pub mod audio_device_factory;

pub mod audio_fallback_device;

pub mod audio_factory_fallback;

pub mod audio_due_actions;

pub mod audio_normal_frame;

pub mod audio_frame_node_update;

pub mod audio_timed_node_update;

pub mod audio_timed_node_segment;

pub mod audio_timed_node_restart;

pub mod audio_timed_node_selection;

pub mod audio_path_configuration;

pub mod audio_path_activation;

pub mod audio_path_lifecycle;

pub mod audio_path_binding_registration;

pub mod audio_path_manager;

pub mod audio_path_memory;
pub mod audio_path_resource;

pub mod audio_path_resource_reader;

pub mod audio_path_resource_acquisition;

pub mod audio_path_resource_owner;

pub mod audio_path_source_state;
pub mod audio_path_listener_orientation;

pub mod audio_path_voice_configuration;

pub mod audio_path_voice_activation;

pub mod audio_path_source_value;

pub mod audio_path_voice_retirement;

pub mod audio_path_voice_owner_release;

pub mod audio_path_voice_notification;

pub mod audio_path_voice_control_publication;

pub mod audio_path_voice_control_drain;

pub mod audio_path_voice_destructor;

pub mod audio_path_voice_cleanup;

pub mod audio_path_voice_registration;
pub mod audio_path_voice_source_removal;

pub mod audio_path_voice_empty_source_release;

pub mod audio_path_source_virtual_cleanup;

pub mod audio_path_source_terminal_cleanup;

pub mod audio_path_source_action_list_cleanup;

pub mod audio_path_source_property_query;

/// Native comparison data remains byte-identical on disk; large fixture
/// strings are loaded only by tests instead of occupying the Windows PE image.
#[cfg(test)]
pub(crate) fn audio_test_fixture(relative:&str)->String{
 let path=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..").join(relative);
 std::fs::read_to_string(&path).unwrap_or_else(|error|panic!("native audio fixture {} could not be read: {}",path.display(),error))
}

pub mod audio_path_property_owner_update;

pub mod audio_path_source_factory;

pub mod audio_path_source_action_factory;

pub mod audio_action_registry_initialization;

pub mod audio_action_registry_key_publication;

pub mod audio_action_registry_value_update;

pub mod audio_property_owner_creation;

pub mod audio_property_owner_progression;

pub mod audio_path_source_input_acquisition;
pub mod audio_path_action_property_callback;

pub mod audio_dynamic_input_owner_selector;

pub mod audio_action_registry_transition_admission;

pub mod audio_registry_resource_admission;

pub mod audio_global_voice_limit;

pub mod audio_resource_curve_admission;

pub mod audio_global_float_configuration;

pub mod audio_global_float_default_power;

pub mod audio_curve_subscriber_unlink;

pub mod audio_crt_thread_context;

pub mod audio_crt_static_lock_startup;

pub mod audio_crt_windows_dispatch_resolver;

pub mod audio_crt_global_dispatch_initialization;
pub mod audio_crt_tls_slot_wrappers;

pub mod audio_crt_tls_value_wrappers;

pub mod audio_crt_thread_system_startup;

pub mod audio_crt_encoded_thread_provider;

pub mod audio_crt_thread_destructor;

pub mod audio_crt_custom_locale_destructor;

pub mod audio_crt_fls_callback;

#[cfg(windows)]
pub mod audio_crt_windows_fls_slot;

#[cfg(windows)]
pub mod audio_crt_windows_shared_fls;

#[cfg(windows)]
pub mod audio_crt_windows_critical_sections;

pub mod audio_crt_heap;

#[cfg(windows)]
pub mod audio_crt_windows_process_heap;

#[cfg(windows)]
pub mod audio_crt_windows_global_services;

#[cfg(windows)]
pub mod audio_crt_windows_root_startup;

pub mod audio_security_cookie;

pub mod audio_crt_worker_exit;

pub mod audio_crt_worker_com_startup;

pub mod audio_crt_worker_entry;

pub mod audio_crt_worker_body;

pub mod audio_crt_worker_packet;

#[cfg(windows)]pub mod audio_crt_windows_worker_thread;
pub mod audio_announcer_labels;
pub mod audio_announcer_kill_roles;
pub mod audio_announcer_icons;
pub mod audio_announcer_palettes;
pub mod audio_announcer_styles;
pub mod audio_announcer_color_streams;
pub mod audio_announcer_rendered_styles;
pub mod audio_announcer_integer_formats;
pub mod audio_announcer_plain_color_streams;

pub mod audio_announcer_num_put_writer;

pub mod audio_announcer_ostream_integer;

pub mod audio_announcer_bounty;
pub mod audio_announcer_value_fields;

pub mod audio_announcer_ordered_formatter;

pub mod audio_announcer_outer_callbacks;

pub mod audio_announcer_registry_init;

pub mod audio_announcer_registry_remove;

pub mod audio_announcer_registry_insert;

pub mod audio_announcer_actor_admission;

pub mod audio_announcer_actor_registration;

pub mod audio_announcer_secondary_registries;

pub mod audio_announcer_registry_shutdown;

pub mod audio_announcer_actor_registry_composition;

pub mod audio_announcer_secondary_unregister;

pub mod audio_announcer_owner_component_destructor;

pub mod audio_announcer_owner_control;
pub mod audio_announcer_owner_metadata;
pub mod audio_announcer_metadata_callbacks;
pub mod audio_announcer_pending_service;
pub mod audio_announcer_active_service;
pub mod audio_announcer_descriptor_insert;
pub mod audio_announcer_service_activation;
pub mod audio_announcer_service_teardown;
pub mod audio_game_service_buffers;

pub mod audio_game_service_lifecycle;

pub mod audio_replay_events;

pub mod audio_replay_shared_pair;

pub mod audio_replay_object_manager;

pub mod audio_replay_object_commands;

pub mod audio_replay_manager_control;

pub mod audio_replay_stream;
pub mod audio_replay_stream_running;
pub mod audio_replay_recording_resource;

pub mod audio_replay_transport_startup;

pub mod audio_replay_transport_thread;

pub mod audio_replay_engine_thread;
#[cfg(windows)] pub mod audio_crt_windows_engine_worker;

#[cfg(windows)] pub mod audio_windows_engine_thread_name;
#[cfg(windows)] pub mod audio_replay_windows_transport;

pub mod audio_replay_logger;

pub mod audio_replay_runtime_image;
#[cfg(windows)] pub mod audio_replay_windows_application;

pub mod audio_replay_address;

pub mod audio_replay_transport_configuration;

pub mod audio_replay_key;
pub mod audio_replay_stream_transport;

pub mod audio_replay_opening;

pub mod audio_replay_path_registry;

pub mod audio_replay_callbacks;

pub mod audio_replay_metadata;

pub mod audio_replay_game_manager;

pub mod audio_replay_service_manager;

pub mod audio_replay_metadata_state;
pub mod audio_replay_metadata_text;
pub mod audio_replay_service_events;

pub mod audio_replay_service_receive;
pub mod audio_replay_packet95;

pub mod audio_loading_record_tree;

pub mod audio_loading_screen_packet;

pub mod audio_replay_loading_owner;

pub mod audio_loading_metadata;

pub mod audio_native_process_clock;
pub mod audio_clock_once;
#[cfg(windows)] pub mod audio_windows_fifo_mutex;

pub mod audio_loading_owned_string;

pub mod audio_loading_standard_prefix;

pub mod audio_loading_resource_manager;

pub mod audio_loading_resource_cache;

pub mod native_simple_type11_draw;

pub mod garen_w_shimmer_profile;

#[cfg(test)] mod native_simple_type11_frame_turns_tests;

pub mod native_complex_type0_quad;
pub mod native_simple_type0_quad;
pub mod native_complex_quad_binding;

pub mod audio_bus_rtpc_delta;
pub mod audio_mixed_rtpc_notification;

pub mod audio_main_sfx_mixed_transport;
pub mod audio_init_rtpc_owner;

pub mod audio_rtpc_first_global_value;


pub mod audio_rtpc_values_retirement;


pub mod audio_rtpc_remaining_retirement;
