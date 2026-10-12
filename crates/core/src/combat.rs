//! Attack orders pursue an enemy through the native navigation graph until in range.
use crate::*;
impl Simulation {
    pub(crate) fn advance_pursuit(&mut self) {
        let orders: Vec<_> = self
            .players
            .values()
            .filter_map(|p| p.target.map(|target| (p.id, target)))
            .collect();
        for (id, target) in orders {
            let p = &self.players[&id];
            if p.health <= 0. || stuns::active(p,self.tick) || p.effects.ultimate.is_some() || p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.effects.annie_r.is_some() || p.windup.is_some() {
                continue;
            }
            let Some(enemy) = self.target_info(target).filter(|enemy| {
                enemy.health > 0. && enemy.team != p.team && self.visible_to(p.team, target)
            }) else {
                let p = self.players.get_mut(&id).unwrap();
                p.target = None;
                p.path.clear();
                p.destination = None;
                continue;
            };
            if p.position.distance(enemy.position)
                <= self.definitions[&p.champion].attack_range + enemy.radius
            {
                let p = self.players.get_mut(&id).unwrap();
                p.path.clear();
                p.destination = None;
                continue;
            }
            if self.tick < p.next_repath {
                continue;
            }
            let destination = enemy.position;
            let path = self.navigation.path(p.position, destination).or_else(|| {
                self.navigation
                    .nearest_walkable(destination)
                    .and_then(|goal| self.navigation.path(p.position, goal))
            });
            let p = self.players.get_mut(&id).unwrap();
            p.next_repath = self.tick + 10;
            if let Some(path) = path {
                p.path = path;
                p.destination = Some(destination);
            } else {
                p.path.clear();
                p.destination = None;
            }
        }
    }
}
