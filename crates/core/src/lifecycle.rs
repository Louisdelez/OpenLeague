//! Map10 baseline respawn. Native late-match scaling and special revival passives remain unqualified.
use crate::*;
use std::sync::OnceLock;
static DEATHS: OnceLock<serde_json::Value> = OnceLock::new();
static RESOURCES: OnceLock<serde_json::Value> = OnceLock::new();
pub fn base_death_ticks(level: u8) -> u64 {
    let data = DEATHS.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/death_times_map10.json")).unwrap()
    });
    let v = &data["Values"]["TimeDeadPerLevel"][format!("Level{:02}", level.clamp(1, 18))];
    let seconds = v
        .as_f64()
        .unwrap_or_else(|| v.as_str().unwrap().parse().unwrap());
    (seconds * TICK_RATE as f64).ceil() as u64
}
pub(crate) fn uses_mana(champion: &str) -> bool {
    let resources = RESOURCES.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/champion_resources.json")).unwrap()
    });
    resources[champion]["type"]
        .as_str()
        .is_some_and(|s| s.eq_ignore_ascii_case("Mana"))
}
pub(crate) fn restores_resource(champion: &str) -> bool {
    let resources = RESOURCES.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/champion_resources.json")).unwrap()
    });
    resources[champion]["type"]
        .as_str()
        .is_some_and(|s| s.eq_ignore_ascii_case("Mana") || s.eq_ignore_ascii_case("Energy"))
}
impl Simulation {
    pub(crate) fn advance_respawns(&mut self) {
        let due: Vec<_> = self
            .players
            .values()
            .filter(|p| p.health <= 0. && p.respawn_at.is_some_and(|tick| tick <= self.tick))
            .map(|p| p.id)
            .collect();
        let spawns: Vec<serde_json::Value> = serde_json::from_str(include_str!(
            "../../../data/4.20/champion_spawns_map10.json"
        ))
        .unwrap();
        let resources = RESOURCES.get_or_init(|| {
            serde_json::from_str(include_str!("../../../data/4.20/champion_resources.json"))
                .unwrap()
        });
        for id in due {
            let max_mana = self.stats(id).max_mana;
            let p = &self.players[&id];
            let seed: Point =
                serde_json::from_value(spawns[p.team as usize]["point"].clone()).unwrap();
            let Some(position) = self
                .navigation
                .ground(seed)
                .map(|_| seed)
                .or_else(|| self.navigation.nearest_walkable(seed))
            else {
                continue;
            };
            let full = resources[&p.champion]["type"].as_str().is_some_and(|s| {
                s.eq_ignore_ascii_case("Mana")
                    || s.eq_ignore_ascii_case("Energy")
                    || s.eq_ignore_ascii_case("Wind")
            });
            self.cancel_attack_presentation(id, attack_presentation::CancelReason::Respawn);
            let p = self.players.get_mut(&id).unwrap();
            p.position = position;
            p.facing = None; // Native initial spawn direction is not qualified.
            p.height = self.navigation.ground(position).unwrap();
            p.health = p.max_health;
            p.mana = if full { max_mana } else { 0. };
            p.respawn_at = None;
            p.windup = None;
            p.attack_roll = None;
            p.path.clear();
            p.target = None;
            p.destination = None;
            p.effects = Default::default();
            p.slows.clear();
            p.stuns.clear();
            p.next_repath = 0;
            p.next_attack = self.tick;
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_baseline_death_table_matches_all_playable_levels() {
        let expected = [
            16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 29, 31, 32, 33, 34, 35, 36, 37,
        ];
        for (i, seconds) in expected.iter().enumerate() {
            assert_eq!(base_death_ticks(i as u8 + 1), seconds * TICK_RATE);
        }
    }
    #[test]
    fn death_blocks_commands_and_respawns_at_own_fountain_without_resetting_progress() {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        let id = s.join("ahri").unwrap();
        let spawn = s.players[&id].position;
        let p = s.players.get_mut(&id).unwrap();
        p.position = Point { x: 7700., z: 7000. };
        p.gold = 33.;
        p.cooldowns[0] = 900;
        s.damage(id, 100000., false);
        let due = s.players[&id].respawn_at.unwrap();
        assert_eq!(due, 480);
        assert!(s.command(id, Action::Stop).is_err());
        s.tick = due - 2;
        s.advance();
        assert_eq!(s.players[&id].health, 0.);
        s.advance();
        let p = &s.players[&id];
        assert_eq!(p.position, spawn);
        assert_eq!(p.health, p.max_health);
        assert_eq!(p.mana, s.stats(id).max_mana);
        assert_eq!(p.gold, 33.);
        assert_eq!(p.cooldowns[0], 900);
        assert!(p.respawn_at.is_none());
    }
    #[test]
    fn fury_is_cleared_on_respawn_instead_of_restored_as_mana() {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        let id = s.join("tryndamere").unwrap();
        s.damage(id, 100000., false);
        s.tick = 479;
        s.advance();
        assert_eq!(s.players[&id].mana, 0.);
    }
}
