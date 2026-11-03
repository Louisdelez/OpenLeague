//! Partial King's Tribute reconstruction, not recovered native server callbacks.
//! Native 4.20 binds enemy nearby deaths, victim maximum HP and radius 1000.
//! Ratios below deliberately follow pinned Chronobreak 6dcac298, not the
//! contradictory TestGrounds linear 1.8..5.94% implementation. Native f2 is unknown.
//! This bounded receiver covers authoritative DAMAGE deaths only. Natural pet
//! expiry, no-render/illusion distinctions, native ordering, VFX and audio remain work.
use crate::*;

pub const DEATH_RADIUS: f32 = 1000.;
// COMMUNITY RECONSTRUCTION: explicit level table, not a modern-patch interpolation.
pub fn ratio(level: u8) -> Option<f32> {
    match level {
        1..=4 => Some(0.02),
        5..=8 => Some(0.03),
        9..=11 => Some(0.04),
        12..=14 => Some(0.05),
        15..=18 => Some(0.06),
        _ => None,
    }
}

impl Simulation {
    /// Called only after a guarded HP>0 -> 0 damage transition, before rewards/XP.
    /// No last-hit, assist, pet-owner or connection attribution is required.
    /// RECONSTRUCTION: centre distance <= radius, all non-structure enemy/neutral
    /// damage deaths (including pets), living Trundle's level at death, common heal.
    pub(crate) fn trundle_passive_damage_death(&mut self, victim: u32) {
        if self.winner.is_some() { return; }
        let (team, position, maximum) = if let Some(p) = self.players.get(&victim) {
            if p.health != 0. { return; }
            (p.team, p.position, p.max_health)
        } else if let Some(u) = self.units.get(&victim) {
            if u.health != 0. || u.kind.structure() { return; }
            (u.team, u.position, u.max_health)
        } else { return; };
        if team > 2 || !maximum.is_finite() || maximum <= 0.
            || !position.x.is_finite() || !position.z.is_finite() { return; }
        // join caps the session at six participants. No persistent event list,
        // random roll, fresh ownership inference or presentation event is added.
        let recipients: Vec<_> = self.players.values().filter_map(|p| {
            if p.id == victim || p.champion != "trundle" || p.team > 1 || p.team == team
                || !p.health.is_finite() || p.health <= 0.
                || !p.max_health.is_finite() || p.max_health <= 0. || p.health > p.max_health
                || !p.position.x.is_finite() || !p.position.z.is_finite()
                || p.position.distance(position) > DEATH_RADIUS { return None; }
            let amount = maximum * ratio(p.level)?;
            amount.is_finite().then_some((p.id, amount))
        }).collect();
        for (id, amount) in recipients {
            // Existing received-heal reduction and max-HP clamp; no bypass of
            // Ignite, revival, full-health or match-ended rules.
            self.heal(Some(id), id, amount).expect("validated Trundle passive recipient");
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32, u32) {
        let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut s = Simulation::new(nav).unwrap(); s.enable_map10().unwrap();
        let a = s.join("trundle").unwrap(); let b = s.join("garen").unwrap();
        let point = s.navigation.nearest_walkable(Point { x: 7700., z: 7000. }).unwrap();
        for id in [a, b] { let p=s.players.get_mut(&id).unwrap(); p.position=point; p.health=100.; }
        (s, a, b)
    }
    fn unit(s: &mut Simulation, a: u32, team: u8) -> u32 {
        let point = s.players[&a].position;
        let id = s.spawn_unit("TT_NGolem", "passive-fixture", team, point, 0., 0., None, None).unwrap();
        let u=s.units.get_mut(&id).unwrap(); u.health=50.; u.max_health=1000.; id
    }
    fn close(actual: f32, expected: f32) { assert!((actual-expected).abs()<0.001, "{actual} != {expected}"); }
    #[test]
    fn community_level_table_is_explicit_and_invalid_levels_are_not_clamped() {
        let expected=[2.,2.,2.,2.,3.,3.,3.,3.,4.,4.,4.,5.,5.,5.,6.,6.,6.,6.];
        for (index, percent) in expected.into_iter().enumerate() { close(ratio(index as u8+1).unwrap()*100., percent); }
        for level in [0,19,u8::MAX] { assert_eq!(ratio(level),None); }
    }
    #[test]
    fn enemy_and_neutral_damage_deaths_use_victim_maximum_not_damage_or_killer_credit() {
        for team in [1,2] { let (mut s,a,_)=game(); let u=unit(&mut s,a,team);
            let gold=s.players[&a].gold; let experience=s.players[&a].experience;
            s.apply_damage(None,u,100000.,damage::DamageKind::True).unwrap();
            close(s.players[&a].health,120.); assert_eq!(s.players[&a].gold,gold); assert_eq!(s.players[&a].experience,experience);
        }
    }
    #[test]
    fn nonlethal_zero_repeated_dead_and_unknown_damage_do_not_proc() {
        let (mut s,a,_)=game(); let u=unit(&mut s,a,1);
        s.apply_damage(None,u,0.,damage::DamageKind::True).unwrap();
        s.apply_damage(None,u,1.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,100.);
        s.apply_damage(None,u,100.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,120.);
        assert!(s.apply_damage(None,u,100.,damage::DamageKind::True).is_err());
        s.damage_unit(0,u,100.); assert!(s.apply_damage(None,u32::MAX,1.,damage::DamageKind::True).is_err());
        close(s.players[&a].health,120.);
    }
    #[test]
    fn exact_centre_radius_boundary_is_inclusive_and_outside_is_rejected() {
        for (distance, expected) in [(1000.,120.),(1000.25,100.)] {
            let (mut s,a,_)=game();
            // Integer coordinates keep the intended boundary exact in f32;
            // adding1000 to a native cell centre can round past the radius.
            let point=s.players[&a].position;
            s.players.get_mut(&a).unwrap().position=Point { x:point.x.floor(), z:point.z.floor() };
            let u=unit(&mut s,a,1);
            s.units.get_mut(&u).unwrap().position.x+=distance;
            assert_eq!(s.players[&a].position.distance(s.units[&u].position), distance);
            s.apply_damage(None,u,100.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,expected);
        }
    }
    #[test]
    fn allied_and_structure_deaths_are_excluded_without_changing_structure_rewards() {
        let (mut s,a,_)=game(); let u=unit(&mut s,a,0);
        s.apply_damage(None,u,100.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,100.);
        let u=unit(&mut s,a,1); s.units.get_mut(&u).unwrap().kind=world::Kind::Turret;
        let bounty=s.units[&u].gold; let gold=s.players[&a].gold;
        s.damage_unit(a,u,100.); close(s.players[&a].health,100.); close(s.players[&a].gold,gold+bounty);
    }
    #[test]
    fn only_living_valid_trundles_receive_and_terminal_damage_cannot_heal() {
        for case in 0..8 {
            let (mut s,a,b)=game(); let u=unit(&mut s,a,1);
            match case { 0=>s.players.get_mut(&a).unwrap().health=0., 1=>s.players.get_mut(&a).unwrap().level=0,
                2=>s.players.get_mut(&a).unwrap().level=19, 3=>s.players.get_mut(&a).unwrap().position.x=f32::NAN,
                4=>s.units.get_mut(&u).unwrap().max_health=f32::NAN,
                5=>s.players.get_mut(&a).unwrap().health=f32::INFINITY, 6=>s.winner=Some(0),
                _=>s.units.get_mut(&u).unwrap().health=f32::NAN }
            let before=s.players[&a].health;
            let _=s.apply_damage(None,u,100.,damage::DamageKind::True);
            assert_eq!(s.players[&a].health,before); close(s.players[&b].health,100.);
        }
    }
    #[test]
    fn common_heal_clamp_and_ignite_reduction_apply_to_the_passive() {
        let (mut s,a,_)=game(); let u=unit(&mut s,a,1);
        s.players.get_mut(&a).unwrap().effects.ignite=Some(summoner_ignite::Burn { source:a,source_team:0,
            expires_at:30,next_tick:30,remaining_ticks:1,damage_per_tick:1. });
        let multiplier=healing::received_multiplier(&s.players[&a],s.tick);
        s.apply_damage(None,u,100.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,100.+20.*multiplier);
        s.players.get_mut(&a).unwrap().effects.ignite=None;
        let u=unit(&mut s,a,1); let maximum=s.players[&a].max_health; s.players.get_mut(&a).unwrap().health=maximum-1.;
        s.apply_damage(None,u,100.,damage::DamageKind::True).unwrap(); close(s.players[&a].health,maximum);
    }
    #[test]
    fn all_six_participants_are_checked_independently_and_no_proc_is_reserved_to_last_hitter() {
        let (mut s,a,b)=game(); let c=s.join("trundle").unwrap(); let d=s.join("trundle").unwrap();
        let e=s.join("trundle").unwrap(); let f=s.join("ashe").unwrap(); let point=s.players[&a].position;
        for id in [a,b,c,d,e,f] { let p=s.players.get_mut(&id).unwrap();p.position=point;p.health=100.; }
        s.players.get_mut(&d).unwrap().team=0;
        let u=unit(&mut s,a,1); s.damage_unit(b,u,100.);
        for id in [a,c,d,e] { close(s.players[&id].health,120.); }
        for id in [b,f] { close(s.players[&id].health,100.); }
    }
    #[test]
    fn champion_death_procs_once_before_kill_experience_can_cross_a_ratio_tier() {
        let (mut s,a,b)=game(); { let p=s.players.get_mut(&a).unwrap();p.level=4;p.experience=progression::threshold(5)-1.; }
        let maximum=s.players[&b].max_health; let before_max=s.players[&a].max_health;
        s.apply_damage(Some(a),b,100000.,damage::DamageKind::True).unwrap();
        assert!(s.players[&a].level>=5); let growth=s.players[&a].max_health-before_max;
        close(s.players[&a].health,100.+maximum*0.02+growth);
        assert_eq!(s.players[&a].score.kills,1); let healed=s.players[&a].health;
        assert!(s.apply_damage(Some(a),b,100000.,damage::DamageKind::True).is_err()); close(s.players[&a].health,healed);
    }
}
