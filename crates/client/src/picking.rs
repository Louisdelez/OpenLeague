use bevy::prelude::*;
use openleague_core::{collision, Navigation, Snapshot};
#[derive(Resource)]
pub struct Terrain(pub Navigation);
impl Default for Terrain {
    fn default() -> Self {
        Self(
            Navigation::load(
                include_str!("../../../assets/maps/tt_navigation_grid.json"),
                include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
            )
            .expect("native click terrain"),
        )
    }
}
pub fn target(
    snapshot: &Snapshot,
    own_id: u32,
    origin: [f32; 3],
    direction: [f32; 3],
    champions_only: bool,
) -> Option<u32> {
    enemy_target(snapshot, own_id, origin, direction, champions_only, None)
}
pub fn ignite_target(snapshot:&Snapshot,own_id:u32,origin:[f32;3],direction:[f32;3])->Option<u32> {
 enemy_target(snapshot,own_id,origin,direction,true,Some(openleague_core::summoner_ignite::range()))
}
pub fn exhaust_target(
    snapshot: &Snapshot,
    own_id: u32,
    origin: [f32; 3],
    direction: [f32; 3],
) -> Option<u32> {
    enemy_target(
        snapshot,
        own_id,
        origin,
        direction,
        true,
        Some(openleague_core::summoner_exhaust::range()),
    )
}
fn enemy_target(
    snapshot: &Snapshot,
    own_id: u32,
    origin: [f32; 3],
    direction: [f32; 3],
    champions_only: bool,
    range: Option<f32>,
) -> Option<u32> {
    let own = snapshot.players.iter().find(|p| p.id == own_id)?;
    let mut candidates: Vec<(u32, f32)> = snapshot
        .players
        .iter()
        .filter(|p| {
            p.team != own.team
                && p.health > 0.
                && range.is_none_or(|r| p.position.distance(own.position) <= r)
        })
        .filter_map(|p| {
            let point = collision::horizontal_point(origin, direction, p.height)?;
            let distance = p.position.distance(point);
            (distance < collision::profile(&p.champion).selection_radius)
                .then_some((p.id, distance))
        })
        .collect();
    if !champions_only {
        candidates.extend(
            snapshot
                .units
                .iter()
                .filter(|u| u.team != own.team && u.health > 0.)
                .filter_map(|u| {
                    let point = collision::horizontal_point(origin, direction, u.height)?;
                    let distance = u.position.distance(point);
                    // Original fields absent on four structure types; retain the previous reconstruction explicitly.
                    let radius = collision::unit_selection_radius(&u.definition).unwrap_or(160.);
                    (distance < radius).then_some((u.id, distance))
                }),
        );
    }
    candidates
        .into_iter()
        .min_by(|a, b| a.1.total_cmp(&b.1))
        .map(|p| p.0)
}
pub fn allied_target(
    snapshot: &Snapshot,
    own_id: u32,
    origin: [f32; 3],
    direction: [f32; 3],
) -> Option<u32> {
    let own = snapshot.players.iter().find(|p| p.id == own_id)?;
    snapshot
        .players
        .iter()
        .filter(|p| {
            p.id != own_id
                && p.team == own.team
                && p.health > 0.
                && p.position.distance(own.position) <= openleague_core::summoner_heal::range()
        })
        .filter_map(|p| {
            let point = collision::horizontal_point(origin, direction, p.height)?;
            let distance = p.position.distance(point);
            (distance < collision::profile(&p.champion).selection_radius)
                .then_some((p.id, distance))
        })
        .min_by(|a, b| a.1.total_cmp(&b.1))
        .map(|p| p.0)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture() -> (Snapshot, u32, u32) {
        let mut s = openleague_core::Simulation::new(Terrain::default().0).unwrap();
        let a = s.join("garen").unwrap();
        let b = s.join("garen").unwrap();
        s.players.get_mut(&b).unwrap().position = openleague_core::Point { x: 100., z: 2100. };
        s.players.get_mut(&b).unwrap().height = -100.;
        (s.snapshot(), a, b)
    }
    #[test]
    fn target_uses_actor_height_and_native_radius_instead_of_fixed_plane() {
        let (mut s, a, b) = fixture();
        assert_eq!(
            target(&s, a, [100., 2000., 0.], [0., -1., 1.], true),
            Some(b)
        );
        // At the obsolete height 120, this ray misses Garen by 220 native units.
        s.players.iter_mut().find(|p| p.id == b).unwrap().position.x = 176.;
        assert_eq!(target(&s, a, [100., 2000., 0.], [0., -1., 1.], true), None);
    }
    #[test]
    fn dead_allied_and_behind_camera_targets_are_excluded() {
        let (mut s, a, b) = fixture();
        s.players.iter_mut().find(|p| p.id == b).unwrap().health = 0.;
        assert_eq!(target(&s, a, [100., 2000., 0.], [0., -1., 1.], true), None);
        let enemy = s.players.iter_mut().find(|p| p.id == b).unwrap();
        enemy.health = 100.;
        enemy.team = 0;
        assert_eq!(target(&s, a, [100., 2000., 0.], [0., -1., 1.], true), None);
        s.players.iter_mut().find(|p| p.id == b).unwrap().team = 1;
        assert_eq!(target(&s, a, [100., -2000., 0.], [0., -1., 1.], true), None);
    }
}

#[cfg(test)]
mod heal_target_tests {
    use super::*;
    #[test]
    fn heal_cursor_targets_living_ally_in_range_and_never_enemy_or_self() {
        let mut simulation = openleague_core::Simulation::new(Terrain::default().0).unwrap();
        let a = simulation.join("garen").unwrap();
        let b = simulation.join("garen").unwrap();
        let c = simulation.join("garen").unwrap();
        for id in [a, b, c] {
            let p = simulation.players.get_mut(&id).unwrap();
            p.position = openleague_core::Point { x: 100., z: 2100. };
            p.height = -100.;
        }
        let ray = ([100., 2000., 0.], [0., -1., 1.]);
        assert_eq!(
            allied_target(&simulation.snapshot(), a, ray.0, ray.1),
            Some(c)
        );
        simulation.players.get_mut(&c).unwrap().health = 0.;
        assert_eq!(allied_target(&simulation.snapshot(), a, ray.0, ray.1), None);
    }
}

#[cfg(test)]
mod exhaust_target_tests {
    use super::*;
    #[test]
    fn exhaust_cursor_selects_only_visible_living_enemy_champion_within_native_range() {
        let mut simulation = openleague_core::Simulation::new(Terrain::default().0).unwrap();
        let a = simulation.join("garen").unwrap();
        let b = simulation.join("garen").unwrap();
        let c = simulation.join("garen").unwrap();
        for id in [a, b, c] {
            let p = simulation.players.get_mut(&id).unwrap();
            p.position = openleague_core::Point { x: 100., z: 2100. };
            p.height = -100.;
        }
        simulation.players.get_mut(&b).unwrap().position.x = 750.;
        let origin = [750., 2000., 0.];
        let direction = [0., -1., 1.];
        assert_eq!(
            exhaust_target(&simulation.snapshot(), a, origin, direction),
            Some(b)
        );
        simulation.players.get_mut(&b).unwrap().position.x = 751.;
        assert_eq!(
            exhaust_target(&simulation.snapshot(), a, [751., 2000., 0.], direction),
            None
        );
        simulation.players.get_mut(&b).unwrap().position.x = 750.;
        simulation.players.get_mut(&b).unwrap().health = 0.;
        assert_eq!(
            exhaust_target(&simulation.snapshot(), a, origin, direction),
            None
        );
        simulation.players.get_mut(&b).unwrap().health = 100.;
        simulation.players.get_mut(&b).unwrap().team = simulation.players[&a].team;
        assert_eq!(
            exhaust_target(&simulation.snapshot(), a, origin, direction),
            None
        );
        let mut snapshot = simulation.snapshot();
        snapshot.players.retain(|p| p.id != b);
        assert_eq!(exhaust_target(&snapshot, a, origin, direction), None);
    }
}

#[cfg(test)]
mod ignite_target_tests {
 use super::*;
 #[test]
 fn ignite_uses600_native_range_and_only_living_enemy_champions() {
  let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=openleague_core::Simulation::new(nav).unwrap();let a=s.join("garen").unwrap();let b=s.join("garen").unwrap();let ally=s.join("garen").unwrap();
  for (id,x) in [(a,7700.),(b,8300.),(ally,8300.)] {let p=s.players.get_mut(&id).unwrap();p.position=openleague_core::Point{x,z:7000.};p.height=0.;}
  assert_eq!(ignite_target(&s.snapshot(),a,[8300.,1000.,7000.],[0.,-1.,0.]),Some(b));
  s.players.get_mut(&b).unwrap().position.x=8301.;assert_eq!(ignite_target(&s.snapshot(),a,[8301.,1000.,7000.],[0.,-1.,0.]),None);
  s.players.get_mut(&b).unwrap().position.x=8300.;s.players.get_mut(&b).unwrap().health=0.;assert_eq!(ignite_target(&s.snapshot(),a,[8300.,1000.,7000.],[0.,-1.,0.]),None);
 }
}

/// Base Smite has its own native-tag filter. Do not reuse broad enemy_target(false).
pub fn smite_target(snapshot: &Snapshot, own_id: u32, origin: [f32; 3], direction: [f32; 3]) -> Option<u32> {
    if snapshot.winner.is_some() { return None; }
    let own = snapshot.players.iter().find(|p| p.id == own_id)?;
    snapshot.units.iter()
        .filter(|unit| openleague_core::summoner_smite::validate_target(own, unit).is_ok())
        .filter_map(|unit| {
            let radius = collision::unit_selection_radius(&unit.definition)?;
            let point = collision::horizontal_point(origin, direction, unit.height)?;
            let distance = unit.position.distance(point);
            (distance.is_finite() && distance < radius).then_some((unit.id, distance))
        })
        .min_by(|a, b| a.1.total_cmp(&b.1).then(a.0.cmp(&b.0)))
        .map(|(id, _)| id)
}

#[cfg(test)]
mod smite_target_tests {
    use super::*;
    fn fixture() -> (Snapshot, u32, u32) {
        let mut simulation = openleague_core::Simulation::new(Terrain::default().0).unwrap();
        simulation.enable_map10().unwrap();
        let caster = simulation.join_with_summoners("garen", [Some(openleague_core::summoners::Spell::Smite), None]).unwrap();
        simulation.tick = 2999;
        simulation.advance();
        let target = *simulation.units.iter().find(|(_, unit)| unit.definition == "TT_NWraith").unwrap().0;
        simulation.players.get_mut(&caster).unwrap().position = openleague_core::Point { x: 7700., z: 7000. };
        let unit = simulation.units.get_mut(&target).unwrap();
        unit.position = openleague_core::Point { x: 8460., z: 7000. };
        unit.height = 0.;
        let mut snapshot = simulation.snapshot();
        snapshot.units.retain(|unit| unit.id == target);
        (snapshot, caster, target)
    }
    #[test]
    fn smite_cursor_obeys_native_tag_registry_range_and_visible_snapshot_membership() {
        let (mut snapshot, caster, target) = fixture();
        let origin = [8460., 1000., 7000.];
        let direction = [0., -1., 0.];
        assert_eq!(smite_target(&snapshot, caster, origin, direction), Some(target));
        snapshot.units[0].position.x = 8461.;
        assert_eq!(smite_target(&snapshot, caster, [8461., 1000., 7000.], direction), None);
        snapshot.units[0].position.x = 8460.;
        snapshot.units[0].definition = "TT_NWraith2".into();
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
        snapshot.units[0].definition = "TT_NWraith".into();
        snapshot.units[0].team = snapshot.players.iter().find(|p| p.id == caster).unwrap().team;
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
        snapshot.units[0].team = 2;
        snapshot.units[0].health = 0.;
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
        snapshot.units.clear();
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
    }
    #[test]
    fn smite_cursor_rejects_unknown_resource_champions_and_finished_match() {
        let (mut snapshot, caster, _) = fixture();
        let origin = [8460., 1000., 7000.];
        let direction = [0., -1., 0.];
        snapshot.winner = Some(0);
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
        snapshot.winner = None;
        snapshot.units[0].definition = "unqualified".into();
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
        let mut champion = snapshot.players[0].clone();
        champion.id += 10000; champion.team = 1; champion.position.x = 8460.; champion.height = 0.;
        snapshot.players.push(champion);
        snapshot.units.clear();
        assert_eq!(smite_target(&snapshot, caster, origin, direction), None);
    }
}
