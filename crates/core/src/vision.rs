//! Server-owned shared team vision. Native flags retained; complete fog/stealth/reveal remains work.
use crate::*;
use std::sync::OnceLock;
/// Native stat names from609A95/609AC0, initialized/reset by6086D0/6088D0.
#[derive(Debug, Clone, Copy, Default, Serialize, Deserialize, PartialEq)]
pub struct RadiusModifiers {
    pub flat_bubble_radius_mod:f32,
    pub percent_bubble_radius_mod:f32,
}
impl RadiusModifiers {
    pub fn parameters(self)->[f32;2] {[self.percent_bubble_radius_mod+1.,self.flat_bubble_radius_mod]}
    pub fn radius(self,base:f32)->f32 {let [scale,bias]=self.parameters();base*scale+bias}
    pub fn reset(&mut self) {*self=Self::default();}
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RosterEntry {
    pub id: u32,
    pub champion: String,
    pub team: u8,
    #[serde(default)]
    pub score: champion_kills::Score,
}
#[derive(Deserialize)] struct RadiusProfile {explicit_radius:Option<f32>}
#[derive(Deserialize)] struct RadiusCatalog {default_radius:f32,profiles:BTreeMap<String,RadiusProfile>}
fn radius_catalog()->&'static RadiusCatalog {
    static C:OnceLock<RadiusCatalog>=OnceLock::new();
    C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_vision_radii.json")).unwrap())
}
pub fn select_base_radius(candidate:f32,global:f32)->f32 {if candidate>0. {candidate}else{global}}
pub fn native_base_radius(definition:&str)->Option<f32> {
    let c=radius_catalog();let profile=c.profiles.get(&definition.to_ascii_lowercase())?;
    Some(select_base_radius(profile.explicit_radius.unwrap_or(0.),c.default_radius))
}
#[derive(Deserialize)]
struct Rules {
    building_radius: f32,
}
fn rules() -> &'static Rules {
    static R: OnceLock<Rules> = OnceLock::new();
    R.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/vision_rules.json")).unwrap()
    })
}
impl Navigation {
    pub fn flags(&self, p: Point) -> Option<u16> {
        self.index(p).map(|i| self.cells[i].2)
    }
    pub fn line_of_sight(&self, origin: Point, target: Point) -> bool {
        let (Some(start), Some(end)) = (self.flags(origin), self.flags(target)) else {
            return false;
        };
        let bush = end & 1 != 0;
        if bush && start & 1 == 0 {
            return false;
        }
        let steps = (origin.distance(target) / (self.metadata.cell_size * 0.25))
            .ceil()
            .max(1.) as usize;
        for n in 1..=steps {
            let t = n as f32 / steps as f32;
            let p = Point {
                x: origin.x + (target.x - origin.x) * t,
                z: origin.z + (target.z - origin.z) * t,
            };
            let Some(flags) = self.flags(p) else {
                return false;
            };
            if n < steps && flags & 2 != 0 && flags & (0x40 | 0x100) == 0 {
                return false;
            }
            if bush && flags & 1 == 0 {
                return false;
            }
        }
        true
    }
}
impl Simulation {
    pub fn visible_to(&self, team: u8, target: u32) -> bool {
        let Some(enemy) = self.target_info(target) else {
            return false;
        };
        if self.interactions.is_none() {
            return true;
        }
        if team > 1 {
            return false;
        }
        if enemy.team == team {
            return true;
        }
        if self.players.get(&target).and_then(|p|p.effects.ignite.as_ref()).is_some_and(|b|b.source_team==team && self.tick<b.expires_at) {return true;}
        self.visible_point_to(team, enemy.position)
    }
    pub fn visible_point_to(&self, team: u8, position: Point) -> bool {
        if self.interactions.is_none() {
            return true;
        }
        if team > 1 || !position.finite() {
            return false;
        }
        if self.interactions.as_ref().is_some_and(|i| {
            i.state
                .altars
                .iter()
                .any(|a| a.owner == Some(team) && position.distance(a.position) <= a.radius)
        }) {
            return true;
        }
        let r = rules();
        self.players
            .values()
            .filter(|p| p.team == team && p.health > 0.)
            .any(|p| {
                p.position.distance(position) <= p.vision_radius_modifiers.radius(native_base_radius(&p.champion).unwrap_or(0.))
                    && self.navigation.line_of_sight(p.position, position)
            })
            || self
                .units
                .values()
                .filter(|u| u.team == team && u.health > 0.)
                .any(|u| {
                    let radius = if u.kind.lane() || u.kind==world::Kind::Pet {
                        native_base_radius(&u.definition).unwrap_or(0.)
                    } else if matches!(u.kind, world::Kind::Turret | world::Kind::Fountain) {
                        native_base_radius(&u.definition).unwrap_or(0.)
                    } else {
                        r.building_radius
                    };
                    if radius<=0. {return false;}
                    let radius=u.vision_radius_modifiers.radius(radius);
                    radius > 0.
                        && u.position.distance(position) <= radius
                        && self.navigation.line_of_sight(u.position, position)
                })
    }
    pub fn snapshot_for(&self, viewer: u32) -> Option<Snapshot> {
        let team = self.players.get(&viewer)?.team;
        let mut snapshot = self.snapshot();
        snapshot.accepted_casts = Some(self.accepted_casts.project(self.session,team,self.tick,|owner|self.visible_to(team,owner)));
        snapshot.trundle_e_pillars = self.trundle_e_projection(Some(team));
        snapshot.ezreal_q_projectiles = self.ezreal_q_projection(Some(team));
        snapshot.ezreal_r_projectiles = self.ezreal_r_projection(viewer);
        snapshot.ezreal_r_casts = self.ezreal_r_cast_projection(viewer);
        snapshot.ezreal_w_casts = self.ezreal_w_cast_projection(viewer);
        snapshot.ezreal_e_casts = self.ezreal_e_cast_projection(viewer);
        snapshot.ezreal_passive_self = self.ezreal_passive_self_projection(viewer);
        snapshot.ezreal_q_accepted_impacts = Some(self.ezreal_q_accepted_impact_projection(team));
        snapshot.spell_projectiles.retain(|m|self.visible_to(team,m.source)&&self.visible_to(team,m.target));
        snapshot.players.retain(|p| self.visible_to(team, p.id));
        snapshot.attack_events = match self.attack_presentation.events_for(team, |source| self.visible_to(team, source)) {
            Ok(events) => events,
            Err(error) => {
                snapshot.attack_presentation_error.get_or_insert_with(|| format!("attack presentation export unavailable: {error:?}"));
                Vec::new()
            }
        };
        // Windup identity must not bypass the historical source+target audience.
        for player in &mut snapshot.players {
            if let Some(windup) = &mut player.windup {
                if windup.presentation.is_some_and(|attack| !snapshot.attack_events.iter().any(|event|
                    event.attack == attack && matches!(event.phase, attack_presentation::Phase::Started { .. }))) {
                    windup.presentation = None;
                }
            }
        }
        snapshot.units.retain(|u| self.visible_to(team, u.id));
        snapshot.vilemaw_attack_events = match self.vilemaw_attacks.events_for(team, |source|
            self.units.get(&source).is_some_and(vilemaw_attacks::is_vilemaw) && self.visible_to(team, source)) {
            Ok(events) => events,
            Err(error) => {
                snapshot.vilemaw_attack_presentation_error.get_or_insert_with(|| format!("Vilemaw attack export unavailable: {error:?}"));
                Vec::new()
            }
        };
        for unit in &mut snapshot.units {
            if unit.attack_presentation.is_some_and(|attack| !snapshot.vilemaw_attack_events.iter().any(|event|
                event.attack == attack && matches!(event.phase, attack_presentation::Phase::Started { .. }))) {
                unit.attack_presentation = None;
            }
        }
        snapshot
            .projectiles
            .retain(|m| self.visible_to(team, m.source) && self.visible_to(team, m.target));
        if let Some(map) = &mut snapshot.map10 {
            map.relic_visible = self.visible_point_to(team, map.relic_position);
            if !map.relic_visible {
                map.relic_available = false;
                map.relic_ready_tick = 0;
                map.relic_last_picker = None;
                map.relic_pickup_tick = None;
            }
            map.revealed_by_altar
                .retain(|id| self.visible_to(team, *id));
            if map
                .relic_last_picker
                .is_some_and(|id| !self.visible_to(team, id))
            {
                map.relic_last_picker = None;
                map.relic_pickup_tick = None;
            }
        }
        Some(snapshot)
    }
    /// Only the resumed OLSR route may transport these complete current samples.
    /// Legacy snapshot_for remains unchanged. Both projections borrow this same
    /// immutable Simulation; no advancement occurs between XZ and current Y.
    pub fn snapshot_for_atomic(&self, viewer: u32) -> Option<Snapshot> {
        let mut snapshot = self.snapshot_for(viewer)?;
        snapshot.ezreal_r_current_heights = self.ezreal_r_current_height_projection(viewer, &snapshot.ezreal_r_projectiles);
        snapshot.ezreal_w_current_missiles = self.ezreal_w_current_projection(viewer);
        snapshot.ezreal_e_current_bolts = self.ezreal_e_current_projection(viewer);
        snapshot.ezreal_e_accepted_releases = Some(self.ezreal_e_accepted_release_projection(self.players.get(&viewer)?.team));
        // Dedicated accepted contacts are an optional OLSR channel. OLST stays unchanged.
        snapshot.ezreal_r_accepted_impacts = Some(self.ezreal_r_accepted_impact_projection(self.players.get(&viewer)?.team));
        snapshot.ezreal_r_accepted_casts = Some(self.ezreal_r_accepted_cast_projection(self.players.get(&viewer)?.team));
        snapshot.death_recap = self.death_recap_projection(viewer);
        Some(snapshot)
    }
}
#[cfg(test)]
mod tests;
