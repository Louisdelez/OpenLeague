//! Partially reconstructed sustain; map10_interactions.json records sources and unknown rules.
use crate::*;
use std::sync::OnceLock;
#[derive(Clone, Deserialize)]
struct Config {
    relic_position: Point,
    relic_height: f32,
    relic_initial_seconds: f32,
    relic_respawn_seconds: f32,
    relic_pickup_radius: f32,
    relic_health_base: f32,
    relic_health_per_level: f32,
    relic_mana_base: f32,
    relic_mana_per_level: f32,
    relic_haste_seconds: f32,
    relic_haste_percent: f32,
    fountain_radius: f32,
    fountain_interval_seconds: f32,
    fountain_heal_fraction: f32,
}
static CONFIG: OnceLock<Config> = OnceLock::new();
fn config() -> &'static Config {
    CONFIG.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/map10_interactions.json"))
            .expect("Map10 interactions")
    })
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MapState {
    /// Persistent authoritative presentation state, also sent to late joiners.
    /// The 75s producer is declared local reconstruction in nexus_phase.
    #[serde(default)]
    pub nexus_crystal: crate::nexus_phase::State,
    pub altars: Vec<crate::altars::Altar>,
    pub revealed_by_altar: Vec<u32>,
    pub relic_visible: bool,
    pub relic_position: Point,
    pub relic_height: f32,
    pub relic_available: bool,
    pub relic_ready_tick: u64,
    pub relic_last_picker: Option<u32>,
    pub relic_pickup_tick: Option<u64>,
}
pub(crate) struct Interactions {
    pub state: MapState,
    next_fountain: u64,
}
pub fn relic_haste(p: &Champion, tick: u64) -> f32 {
    if p.health <= 0. || tick >= p.effects.relic_haste_until {
        return 0.;
    }
    let duration = p
        .effects
        .relic_haste_until
        .saturating_sub(p.effects.relic_haste_started)
        .max(1);
    config().relic_haste_percent
        * (p.effects.relic_haste_until.saturating_sub(tick) as f32 / duration as f32).clamp(0., 1.)
}
impl Simulation {
    pub(crate) fn enable_interactions(&mut self) {
        let c = config();
        self.interactions = Some(Interactions {
            state: MapState {
                nexus_crystal: crate::nexus_phase::State::default(),
                altars: crate::altars::initial(&mut self.next_id),
                revealed_by_altar: Vec::new(),
                relic_visible: true,
                relic_position: c.relic_position,
                relic_height: c.relic_height,
                relic_available: false,
                relic_ready_tick: spells::seconds(c.relic_initial_seconds),
                relic_last_picker: None,
                relic_pickup_tick: None,
            },
            next_fountain: spells::seconds(c.fountain_interval_seconds),
        });
    }
    pub(crate) fn advance_interactions(&mut self) {
        let Some(mut i) = self.interactions.take() else {
            return;
        };
        let c = config();
        if self.tick >= i.next_fountain {
            i.next_fountain = self.tick + spells::seconds(c.fountain_interval_seconds);
            let spawns: Vec<serde_json::Value> = serde_json::from_str(include_str!(
                "../../../data/4.20/champion_spawns_map10.json"
            ))
            .unwrap();
            let ids: Vec<_> = self
                .players
                .values()
                .filter(|p| p.health > 0.)
                .map(|p| p.id)
                .collect();
            for id in ids {
                let p = &self.players[&id];
                let home: Point =
                    serde_json::from_value(spawns[p.team as usize]["point"].clone()).unwrap();
                if p.position.distance(home) > c.fountain_radius {
                    continue;
                }
                let max_mana = self.stats(id).max_mana;
                let can_restore = lifecycle::restores_resource(&p.champion);
                let p = self.players.get_mut(&id).unwrap();
                p.health = (p.health + p.max_health * c.fountain_heal_fraction * healing::received_multiplier(p,self.tick)).min(p.max_health);
                if can_restore {
                    p.mana = (p.mana + max_mana * c.fountain_heal_fraction).min(max_mana);
                }
            }
        }
        i.state.relic_available = self.tick >= i.state.relic_ready_tick;
        if i.state.relic_available {
            let picker = self
                .players
                .values()
                .filter(|p| {
                    p.health > 0. && p.position.distance(c.relic_position) <= c.relic_pickup_radius
                })
                .min_by(|a, b| {
                    a.position
                        .distance(c.relic_position)
                        .total_cmp(&b.position.distance(c.relic_position))
                        .then(a.id.cmp(&b.id))
                })
                .map(|p| p.id);
            if let Some(id) = picker {
                let max_mana = self.stats(id).max_mana;
                let p = self.players.get_mut(&id).unwrap();
                let level = p.level.saturating_sub(1) as f32;
                p.health = (p.health + (c.relic_health_base + c.relic_health_per_level * level) * healing::received_multiplier(p,self.tick))
                    .min(p.max_health);
                if lifecycle::restores_resource(&p.champion) {
                    p.mana =
                        (p.mana + c.relic_mana_base + c.relic_mana_per_level * level).min(max_mana);
                }
                p.effects.relic_haste_started = self.tick;
                p.effects.relic_haste_until = self.tick + spells::seconds(c.relic_haste_seconds);
                i.state.relic_available = false;
                i.state.relic_ready_tick = self.tick + spells::seconds(c.relic_respawn_seconds);
                i.state.relic_last_picker = Some(id);
                i.state.relic_pickup_tick = Some(self.tick);
            }
        }
        crate::altars::advance(self.tick, &self.players, &mut i.state.altars);
        i.state.revealed_by_altar = self
            .players
            .values()
            .filter(|p| {
                p.health > 0.
                    && i.state.altars.iter().any(|a| {
                        a.owner.is_some_and(|owner| owner != p.team)
                            && p.position.distance(a.position) <= a.radius
                    })
            })
            .map(|p| p.id)
            .collect();
        self.interactions = Some(i);
    }
}
#[cfg(test)]
mod tests;
