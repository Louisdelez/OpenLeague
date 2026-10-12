//! Native radius fields stay distinct: selection and pathfinding are not gameplay body radii.
use serde::Deserialize;
use std::{collections::BTreeMap, sync::OnceLock};
#[derive(Debug, Deserialize)]
pub struct Profile {
    pub pathfinding_radius: f32,
    pub selection_radius: f32,
    pub gameplay_radius: Option<f32>,
}
pub fn profile(champion: &str) -> &'static Profile {
    static DATA: OnceLock<BTreeMap<String, Profile>> = OnceLock::new();
    &DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/collision_profiles.json"))
            .expect("native collision profiles")
    })[champion]
}

/// Community loader defaults; the original optional native field remains unchanged.
/// These are gameplay body radii, not selection or pathfinding radii.
pub(crate) fn body_radius(native: Option<f32>) -> f32 {
    let loaded = native.unwrap_or(65.);
    if loaded > 0. { loaded } else { 40. }
}

#[derive(Deserialize)]
struct UnitProfile {
    selection_radius: Option<f32>,
}
pub fn unit_selection_radius(definition: &str) -> Option<f32> {
    static DATA: OnceLock<BTreeMap<String, UnitProfile>> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!(
            "../../../data/4.20/npc_selection_profiles.json"
        ))
        .expect("native NPC selection profiles")
    })
    .get(definition)
    .and_then(|p| p.selection_radius)
}
pub fn horizontal_point(
    origin: [f32; 3],
    direction: [f32; 3],
    height: f32,
) -> Option<crate::Point> {
    if !height.is_finite()
        || origin
            .iter()
            .chain(direction.iter())
            .any(|v| !v.is_finite())
        || direction[1].abs() < 0.00001
    {
        return None;
    }
    let t = (height - origin[1]) / direction[1];
    if !t.is_finite() || t < 0. {
        return None;
    }
    let p = crate::Point {
        x: origin[0] + direction[0] * t,
        z: origin[2] + direction[2] * t,
    };
    p.finite().then_some(p)
}
impl crate::Navigation {
    /// Intersect the piecewise-flat native navigation-height grid, including blocked cells.
    /// This is not a triangle-level raycast against the restored render mesh.
    pub fn raycast_floor(&self, origin: [f32; 3], direction: [f32; 3]) -> Option<crate::Point> {
        let mut hit: Option<(f32, crate::Point)> = None;
        for (index, (height, _, _)) in self.cells.iter().enumerate() {
            let Some(point) = horizontal_point(origin, direction, *height) else {
                continue;
            };
            let x = self.metadata.min[0]
                + (index % self.metadata.width) as f32 * self.metadata.cell_size;
            let z = self.metadata.min[2]
                + (index / self.metadata.width) as f32 * self.metadata.cell_size;
            if point.x < x
                || point.x >= x + self.metadata.cell_size
                || point.z < z
                || point.z >= z + self.metadata.cell_size
            {
                continue;
            }
            let t = (*height - origin[1]) / direction[1];
            if hit.as_ref().is_none_or(|(nearest, _)| t < *nearest) {
                hit = Some((t, point));
            }
        }
        hit.map(|(_, point)| point)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn terrain(blocked: bool) -> crate::Navigation {
        let mut bytes = Vec::new();
        for (h, b) in [(0f32, false), (100f32, blocked)] {
            bytes.extend(h.to_le_bytes());
            bytes.extend(if b { 2u16 } else { 0 }.to_le_bytes());
            bytes.extend(0u32.to_le_bytes());
            bytes.push(1);
        }
        crate::Navigation::load(
            r#"{"min":[0,0,0],"cellSize":50,"width":2,"height":1}"#,
            &bytes,
        )
        .unwrap()
    }
    #[test]
    fn ray_hits_raised_cell_instead_of_invented_fixed_plane() {
        let nav = terrain(false);
        let p = nav.raycast_floor([25., 200., 25.], [0.5, -1., 0.]).unwrap();
        assert_eq!(p, crate::Point { x: 75., z: 25. });
        assert_eq!(nav.ground(p), Some(100.));
    }
    #[test]
    fn blocked_cell_can_be_clicked_without_redirecting_to_another_cell() {
        let nav = terrain(true);
        let p = nav.raycast_floor([25., 200., 25.], [0.5, -1., 0.]).unwrap();
        assert_eq!(p, crate::Point { x: 75., z: 25. });
        assert!(nav.ground(p).is_none());
    }
    #[test]
    fn misses_and_invalid_rays_do_not_generate_movement_points() {
        let nav = terrain(false);
        for (o, d) in [
            ([25., 200., 25.], [0., 1., 0.]),
            ([25., 200., 25.], [1., 0., 0.]),
            ([f32::NAN, 200., 25.], [0., -1., 0.]),
            ([1000., 200., 1000.], [0., -1., 0.]),
        ] {
            assert!(nav.raycast_floor(o, d).is_none());
        }
    }
}
