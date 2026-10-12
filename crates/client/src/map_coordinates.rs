//! Client basis D: native XYZ /20, shared by the map, gameplay, camera and picking.
//! This fixes an internal binding mismatch; it does not qualify native rendering.
use bevy::prelude::*;

pub const NATIVE_UNITS_PER_WORLD_UNIT: f32 = 20.;
#[derive(Component)]
pub struct MapRoot;

pub fn map_root_transform() -> Transform {
    Transform::from_scale(Vec3::splat(1. / NATIVE_UNITS_PER_WORLD_UNIT))
}
pub fn native_from_world(world: Vec3) -> Vec3 {
    world * NATIVE_UNITS_PER_WORLD_UNIT
}

/// The immutable ambient manifest contains reflected *world* placements, including
/// their linear basis. Undo that affine reflection on the left, once at setup.
/// Source model vertices, bones, clips and authored relative rotations are untouched.
pub fn ambient_transform(legacy: Mat4, extent: f32) -> Result<Transform, &'static str> {
    if !legacy.is_finite() || !extent.is_finite() || extent <= 0. {
        return Err("invalid legacy Map10 ambient placement");
    }
    let correction = Mat4::from_translation(Vec3::new(0., 0., extent / NATIVE_UNITS_PER_WORLD_UNIT))
        * Mat4::from_scale(Vec3::new(1., 1., -1.));
    let direct = correction * legacy;
    if !direct.is_finite() || direct.determinant() <= 0. {
        return Err("unsupported ambient placement determinant");
    }
    let transform = Transform::from_matrix(direct);
    let reconstructed = transform.to_matrix();
    if !reconstructed.is_finite() || direct.to_cols_array().iter()
        .zip(reconstructed.to_cols_array()).any(|(a,b)| (a-b).abs() > 0.0001) {
        return Err("ambient placement cannot be represented without shear");
    }
    Ok(transform)
}

#[cfg(test)]
#[path = "map_coordinates_tests.rs"]
mod tests;
