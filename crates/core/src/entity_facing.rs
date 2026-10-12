//! Public physical yaw, without target identity or distance.
//! The yaw arithmetic is native; Garen's direction producer is explicitly a
//! reconstructed policy: real movement, attack start and each valid windup.
use serde::{Deserialize, Deserializer, Serialize};

#[derive(Debug, Clone, Copy, Serialize, PartialEq)]
pub struct Facing {
    yaw_degrees: f32,
}
impl Facing {
    pub fn from_yaw(yaw_degrees: f32) -> Result<Self, &'static str> {
        if !yaw_degrees.is_finite() || !(-360. ..=0.).contains(&yaw_degrees) {
            return Err("physical heading must be finite native yaw in [-360,0]");
        }
        Ok(Self { yaw_degrees })
    }
    pub fn from_direction(direction: [f32; 3]) -> Result<Option<Self>, &'static str> {
        crate::entity_yaw::angle(direction)?.map(Self::from_yaw).transpose()
    }
    pub fn yaw_degrees(self) -> f32 { self.yaw_degrees }
}
impl<'de> Deserialize<'de> for Facing {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        #[derive(Deserialize)]
        #[serde(deny_unknown_fields)]
        struct Wire { yaw_degrees: f32 }
        let wire = Wire::deserialize(deserializer)?;
        Self::from_yaw(wire.yaw_degrees).map_err(serde::de::Error::custom)
    }
}

impl crate::Champion {
    pub(crate) fn capture_facing(&mut self, direction: [f32; 3]) {
        // Deliberately do not generalize unqualified champion/cast policies.
        if self.champion != "garen" { return; }
        match Facing::from_direction(direction) {
            Ok(Some(facing)) => self.facing = Some(facing),
            Ok(None) => {}, // Zero displacement must retain the current heading.
            Err(error) => eprintln!("OpenLeague physical facing {}: {error}", self.id),
        }
    }
}
pub fn validate_snapshot(snapshot: &crate::Snapshot) -> Result<(), &'static str> {
    for player in &snapshot.players {
        if let Some(facing) = player.facing { Facing::from_yaw(facing.yaw_degrees)?; }
    }
    Ok(())
}

#[cfg(test)]
#[path = "entity_facing_tests.rs"]
mod tests;
