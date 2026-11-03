//! Server-owned discrete healing. General healing modifiers and special spell policies remain work.
use crate::*;
#[derive(Debug, Clone, Copy)]
pub struct Outcome {
    pub requested: f32,
    pub restored: f32,
}
/// Shared received-healing policy. Additional native debuffs/modifiers remain unimplemented.
pub fn received_multiplier(p: &Champion, tick: u64) -> f32 {
    let existing=summoner_ignite::healing_multiplier(p,tick);
    let domain=trundle_w::healing_multiplier(p,tick);
    // Preserve the existing non-W arithmetic exactly; amplify received healing once.
    if domain==1. {existing} else {existing*domain}
}
impl Simulation {
    pub fn heal(
        &mut self,
        source: Option<u32>,
        target: u32,
        amount: f32,
    ) -> Result<Outcome, String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        if !amount.is_finite() || amount < 0. {
            return Err("invalid heal".into());
        }
        if source.is_some_and(|s| self.target_info(s).is_none()) {
            return Err("unknown heal source".into());
        }
        let p = self
            .players
            .get_mut(&target)
            .ok_or("unknown champion heal target")?;
        if p.health <= 0. {
            return Err("heal target dead".into());
        }
        let before = p.health;
        p.health = (p.health + amount * received_multiplier(p,self.tick)).min(p.max_health);
        Ok(Outcome {
            requested: amount,
            restored: p.health - before,
        })
    }
}
