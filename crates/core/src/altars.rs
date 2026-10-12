//! Partially reconstructed capture state; sources and unknown rules are recorded in altars_map10.json.
use crate::*;
use std::sync::OnceLock;
#[derive(Clone, Deserialize)]
struct Config {
    altars: Vec<Seed>,
    unlock_seconds: f32,
    lock_seconds: f32,
    capture_seconds: f32,
    capture_radius: f32,
    unit_kill_bonus_gold: f32,
    two_altar_damage_percent: f32,
}
#[derive(Clone, Deserialize)]
struct Seed {
    name: String,
    position: Point,
    height: f32,
    asset: String,
}
static CONFIG: OnceLock<Config> = OnceLock::new();
fn config() -> &'static Config {
    CONFIG.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/altars_map10.json"))
            .expect("Map10 altars")
    })
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Altar {
    pub id: u32,
    pub name: String,
    pub position: Point,
    pub height: f32,
    pub asset: String,
    pub radius: f32,
    pub owner: Option<u8>,
    pub capturing: Option<u8>,
    pub progress_ticks: u64,
    pub required_ticks: u64,
    pub locked_until: u64,
    pub contested: bool,
    pub captured_tick: Option<u64>,
}
pub(crate) fn initial(next_id: &mut u32) -> Vec<Altar> {
    let c = config();
    c.altars
        .iter()
        .map(|s| {
            let id = *next_id;
            *next_id += 1;
            Altar {
                id,
                name: s.name.clone(),
                position: s.position,
                height: s.height,
                asset: s.asset.clone(),
                radius: c.capture_radius,
                owner: None,
                capturing: None,
                progress_ticks: 0,
                required_ticks: spells::seconds(c.capture_seconds),
                locked_until: spells::seconds(c.unlock_seconds),
                contested: false,
                captured_tick: None,
            }
        })
        .collect()
}
pub(crate) fn advance(tick: u64, players: &BTreeMap<u32, Champion>, altars: &mut [Altar]) {
    for altar in altars {
        altar.contested = false;
        if tick < altar.locked_until {
            continue;
        }
        let mut present = [false; 2];
        for p in players.values() {
            if p.team < 2 && p.health > 0. && p.position.distance(altar.position) <= altar.radius {
                present[p.team as usize] = true;
            }
        }
        if present[0] && present[1] {
            altar.contested = true;
            continue;
        }
        let active = if present[0] {
            Some(0)
        } else if present[1] {
            Some(1)
        } else {
            None
        };
        if active.is_none() || active == altar.owner {
            altar.capturing = None;
            altar.progress_ticks = 0;
            continue;
        }
        if altar.capturing != active {
            altar.capturing = active;
            altar.progress_ticks = 0;
            continue;
        }
        altar.progress_ticks += 1;
        if altar.progress_ticks >= altar.required_ticks {
            altar.owner = active;
            altar.capturing = None;
            altar.progress_ticks = 0;
            altar.captured_tick = Some(tick);
            altar.locked_until = tick + spells::seconds(config().lock_seconds);
        }
    }
}
impl Simulation {
    pub fn owned_altars(&self, team: u8) -> usize {
        self.interactions
            .as_ref()
            .map(|i| {
                i.state
                    .altars
                    .iter()
                    .filter(|a| a.owner == Some(team))
                    .count()
            })
            .unwrap_or(0)
    }
    pub(crate) fn altar_kill_bonus(&self, team: u8) -> f32 {
        if self.owned_altars(team) > 0 {
            config().unit_kill_bonus_gold
        } else {
            0.
        }
    }
    pub(crate) fn altar_damage_multiplier(&self, team: u8) -> f32 {
        if self.owned_altars(team) == 2 {
            1. + config().two_altar_damage_percent
        } else {
            1.
        }
    }
}
#[cfg(test)]
mod tests;
