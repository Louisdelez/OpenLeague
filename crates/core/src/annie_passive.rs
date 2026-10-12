//! Native four-charge contract with explicitly reconstructed historical event ordering.
use crate::*;
pub fn stun_ticks(level:u8)->u64 {
    spells::seconds(if level>=11 {1.75} else if level>=6 {1.5} else {1.25})
}
impl Simulation {
    // Q calls this on a successful impact; W/R once on release, E on acceptance.
    // E and guide commands never consume a prepared offensive stun.
    pub(crate) fn pyromania_spell(&mut self,owner:u32,offensive:bool)->u64 {
        let Some(p)=self.players.get_mut(&owner) else {return 0};
        if p.champion!="annie" || p.health<=0. {return 0;}
        if offensive && p.effects.pyromania>=4 {
            p.effects.pyromania=0;
            stun_ticks(p.level)
        } else {
            p.effects.pyromania=p.effects.pyromania.saturating_add(1).min(4);
            0
        }
    }
    pub(crate) fn pyromania_hit(&mut self,owner:u32,target:u32,duration:u64) {
        if duration==0 || !self.target_info(target).is_some_and(|t|t.health>0.) {return;}
        // Boss immunity policy and spell shields are still unqualified separately.
        let _=self.grant_stun(Some(owner),target,"Pyromania",duration);
    }
}
#[cfg(test)]
#[path="annie_passive_tests.rs"]
mod tests;
