//! Summoner Barrier using native tooltip endpoints/duration and inibin cooldown.
//! Full summoner catalog, account unlocks, modifiers and visual/audio integration remain work.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Spell {
    Barrier,
    Heal,
    Exhaust,
    Ignite,
    Smite,
}
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct Loadout {
    pub spells: [Option<Spell>; 2],
    pub ready_at: [u64; 2],
}
#[derive(Deserialize)]
struct Rules {
    cooldown_seconds: f32,
    duration_seconds: f32,
    shield_level_1: f32,
    shield_per_level: f32,
}
fn rules() -> &'static Rules {
    static R: OnceLock<Rules> = OnceLock::new();
    R.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/barrier_rules.json")).unwrap()
    })
}
impl Simulation {
    pub fn join_with_summoners(
        &mut self,
        name: &str,
        spells: [Option<Spell>; 2],
    ) -> Result<u32, String> {
        if spells[0].is_some() && spells[0] == spells[1] {
            return Err("duplicate summoner spell".into());
        }
        let id = self.join(name)?;
        self.players.get_mut(&id).unwrap().summoners.spells = spells;
        Ok(id)
    }
    pub fn cast_summoner(&mut self, id: u32, slot: u8) -> Result<(), String> {
        self.cast_summoner_on(id, slot, None)
    }
    pub fn cast_summoner_on(
        &mut self,
        id: u32,
        slot: u8,
        target: Option<u32>,
    ) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        if slot > 1 {
            return Err("invalid summoner slot".into());
        }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if trundle_e::champion_forced(p,self.tick) {return Err("champion in forced movement".into());}
        if p.health <= 0. {
            return Err("champion dead".into());
        }
        let spell = p.summoners.spells[slot as usize].ok_or("summoner slot empty")?;
        let native_name=match spell {Spell::Barrier=>"SummonerBarrier",Spell::Heal=>"SummonerHeal",Spell::Exhaust=>"SummonerExhaust",Spell::Ignite=>"SummonerDot",Spell::Smite=>"SummonerSmite"};
        if stuns::active(p,self.tick) && !stuns::allows_disabled(native_name)? {return Err("summoner disabled while stunned".into());}
        if self.tick < p.summoners.ready_at[slot as usize] {
            return Err("summoner spell on cooldown".into());
        }
        match spell {
            Spell::Ignite => self.cast_ignite(id, slot, target)?,
            Spell::Smite => self.cast_smite(id, slot, target)?,
            Spell::Heal => self.cast_heal(id, slot, target)?,
            Spell::Exhaust => self.cast_exhaust(id, slot, target)?,
            Spell::Barrier => {
                let r = rules();
                let amount =
                    r.shield_level_1 + r.shield_per_level * (p.level.clamp(1, 18) - 1) as f32;
                self.grant_shield(
                    id,
                    "SummonerBarrier",
                    amount,
                    spells::seconds(r.duration_seconds),
                )?;
                self.players.get_mut(&id).unwrap().summoners.ready_at[slot as usize] =
                    self.tick + spells::seconds(r.cooldown_seconds);
            }
        }
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> Simulation {
        Simulation::new(
            Navigation::load(
                include_str!("../../../assets/maps/tt_navigation_grid.json"),
                include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
            )
            .unwrap(),
        )
        .unwrap()
    }
    #[test]
    fn barrier_has_native_duration_cooldown_and_level_endpoints() {
        let mut s = game();
        let id = s
            .join_with_summoners("garen", [Some(Spell::Barrier), None])
            .unwrap();
        s.players.get_mut(&id).unwrap().effects.silence_until = 100;
        s.cast_summoner(id, 0).unwrap();
        assert_eq!(s.players[&id].shields[0].remaining, 115.);
        assert_eq!(s.players[&id].shields[0].expires_at, 60);
        assert_eq!(s.players[&id].summoners.ready_at[0], 6300);
        assert!(s.cast_summoner(id, 0).is_err());
        assert!(s.cast_summoner(id, 1).is_err());
        assert!(s.cast_summoner(id, 2).is_err());
        for _ in 0..60 {
            s.advance();
        }
        assert!(s.players[&id].shields.is_empty());
        s.tick = 6300;
        s.players.get_mut(&id).unwrap().level = 18;
        s.cast_summoner(id, 0).unwrap();
        assert_eq!(s.players[&id].shields[0].remaining, 455.);
    }
    #[test]
    fn duplicate_loadout_is_rejected_without_allocating_player() {
        let mut s = game();
        assert!(s
            .join_with_summoners("garen", [Some(Spell::Barrier), Some(Spell::Barrier)])
            .is_err());
        assert!(s.players.is_empty());
    }
}
