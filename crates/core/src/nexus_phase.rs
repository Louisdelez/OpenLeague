//! Client-native OnNexusCrystalStart (0x7f) selects *_on.troy. The 75s Map10
//! producer below is an explicit local reconstruction from LeagueSandbox's
//! LevelScript, NOT verified Riot server timing. No combat rule depends on it.
use serde::{Deserialize, Serialize};

pub const EVENT_ID: u8 = 0x7f;
pub const LOCAL_MAP10_START_TICK: u64 = 75 * crate::TICK_RATE;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
pub enum State {
    #[default]
    Startup,
    On { started_tick: u64 },
}
impl State {
    /// Monotonic authoritative state: never re-emits or returns to Startup.
    pub(crate) fn advance(&mut self, tick: u64) {
        if *self == Self::Startup && tick >= LOCAL_MAP10_START_TICK {
            *self = Self::On { started_tick: LOCAL_MAP10_START_TICK };
        }
    }
    pub fn started_tick(self) -> u64 {
        match self { Self::Startup => 0, Self::On { started_tick } => started_tick }
    }
    pub fn validate(self, snapshot_tick: u64) -> Result<(), &'static str> {
        match self {
            Self::Startup if snapshot_tick < LOCAL_MAP10_START_TICK => Ok(()),
            Self::On { started_tick } if started_tick == LOCAL_MAP10_START_TICK && started_tick <= snapshot_tick => Ok(()),
            _ => Err("Nexus phase does not match this server's declared Map10 policy"),
        }
    }
    /// Exact original last-dot suffix rule, narrowed to the six original
    /// Order/Chaos Nexus IdleParticles resources accepted by this host.
    pub fn resource(self, original: &str) -> Result<String, &'static str> {
        if !matches!(original, "Order_Nexus.troy" | "Order_Nexus_Crystal_Glow.troy" | "Order_Nexus_Base_Glow.troy"
            | "Chaos_Nexus.troy" | "Chaos_Nexus_Crystal_Glow.troy" | "Chaos_Nexus_Base_Glow.troy") {
            return Err("Nexus idle resource is outside the pinned six-resource profile");
        }
        Ok(match self {
            Self::Startup => original.to_owned(),
            Self::On { .. } => format!("{}_on.troy", original.rsplit_once('.').unwrap().0),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> crate::Simulation {
        let navigation=crate::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut s=crate::Simulation::new(navigation).unwrap();s.enable_map10().unwrap();s
    }
    #[test]
    fn phase_is_latched_at_declared_server_tick_and_not_particle_lifetime() {
        let mut s=game();s.tick=LOCAL_MAP10_START_TICK-2;s.advance();
        assert_eq!(s.snapshot().map10.unwrap().nexus_crystal,State::Startup);
        s.advance();assert_eq!(s.snapshot().map10.unwrap().nexus_crystal,State::On {started_tick:2250});
        for tick in [89*crate::TICK_RATE,91*crate::TICK_RATE,600*crate::TICK_RATE] {
            s.tick=tick;s.advance();assert_eq!(s.snapshot().map10.unwrap().nexus_crystal,State::On {started_tick:2250});
        }
        let stopped=s.tick;s.winner=Some(0);s.advance();assert_eq!(s.tick,stopped);
        assert_eq!(s.snapshot().map10.unwrap().nexus_crystal,State::On {started_tick:2250});
        let mut ended=game();ended.tick=2249;ended.winner=Some(1);ended.advance();
        assert_eq!(ended.tick,2249);assert_eq!(ended.snapshot().map10.unwrap().nexus_crystal,State::Startup);
    }
    #[test]
    fn snapshot_and_filtered_late_join_carry_same_phase_without_event_replay() {
        let mut s=game();let player=s.join("garen").unwrap();s.tick=2999;s.advance();
        let expected=State::On {started_tick:2250};
        assert_eq!(s.snapshot().map10.unwrap().nexus_crystal,expected);
        let snapshot=s.snapshot_for(player).unwrap();assert_eq!(snapshot.map10.as_ref().unwrap().nexus_crystal,expected);
        let decoded:crate::Snapshot=serde_json::from_slice(&serde_json::to_vec(&snapshot).unwrap()).unwrap();
        assert_eq!(decoded.map10.unwrap().nexus_crystal,expected);
        // No simulation advance, including server pause, changes this state.
        assert_eq!(s.snapshot_for(player).unwrap().map10.unwrap().nexus_crystal,expected);
    }
    #[test]
    fn phase_defaults_preserve_decoding_but_stale_or_foreign_policy_is_rejected() {
        assert_eq!(serde_json::from_str::<State>("\"Startup\"").unwrap(),State::Startup);
        assert!(State::Startup.validate(2250).is_err());
        assert!(State::On {started_tick:2250}.validate(2249).is_err());
        assert!(State::On {started_tick:2670}.validate(3000).is_err());
        assert!(State::On {started_tick:2250}.validate(3000).is_ok());
    }
    #[test]
    fn native_suffix_applies_to_all_three_idle_families_without_skin_guess() {
        let on=State::On {started_tick:2250};
        for name in ["Order_Nexus","Order_Nexus_Crystal_Glow","Order_Nexus_Base_Glow"] {
            let original=format!("{name}.troy");assert_eq!(State::Startup.resource(&original).unwrap(),original);
            assert_eq!(on.resource(&original).unwrap(),format!("{name}_on.troy"));
        }
        assert!(on.resource("Order_Nexus_start.troy").is_err());assert!(on.resource("Other_Nexus.troy").is_err());
    }
}

#[cfg(test)]
mod chaos_tests {
    #[test]
    fn chaos_families_use_the_same_phase_without_cross_profile_aliases() {
        let on=super::State::On {started_tick:2250};
        for name in ["Chaos_Nexus","Chaos_Nexus_Crystal_Glow","Chaos_Nexus_Base_Glow"] {
            let resource=format!("{name}.troy");
            assert_eq!(super::State::Startup.resource(&resource).unwrap(),resource);
            assert_eq!(on.resource(&resource).unwrap(),format!("{name}_on.troy"));
        }
        for name in ["Chaos_Nexus_on.troy","chaos_nexus.troy","Chaos_Nexus_start.troy","Other_Nexus.troy"] {
            assert!(on.resource(name).is_err());
        }
    }
}
