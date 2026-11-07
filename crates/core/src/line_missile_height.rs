//! Local f32 reconstruction of the normal LineMissile height update.
//!
//! Static basis: 0x75eb30 and 0x75c780..0x75ca99, normal +0x59c == 0.
//! Inputs are authoritative current state, not reconstructed actor/bone history.
//! `sqrt`/`powf` and DenseHeightGrid are local f32 operations: no native x87,
//! RSQRT approximation, instruction timing or pixel parity is claimed.

use crate::dense_height_grid::{DenseHeightGrid, Error as GridError};
use std::fmt;

const NORMALIZE_EPSILON_SQUARED: f32 = f32::from_bits(0x3089_705f);
const LOOKAHEAD: f32 = 150.0;
const TERRAIN_CLEARANCE: f32 = 4.0;

/// Normal endpoint mode only: the native alternate-endpoint flag +0x59c is zero.
/// All coordinates use native X/Y/Z units. No renderer coordinate conversion.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct NormalLineHeightInputs {
    /// Current missile position (+0x544/+0x548/+0x54c), including previous Y.
    pub position: [f32; 3],
    /// Current 3D direction (+0x6c/+0x70/+0x74); need not be normalized.
    pub direction: [f32; 3],
    /// Authoritative normal start (+0x538/+0x540), not the current owner's pose.
    pub start_xz: [f32; 2],
    /// Authoritative normal end (+0x584/+0x58c), also used by the domain gate.
    pub end_xz: [f32; 2],
    /// Already established initial offset (+0x5d4). This function cannot infer it.
    pub initial_height_delta: f32,
    /// Line-specific augmentation (resource +0x5ac), not generic +0x5a8.
    pub line_height_augmentation: f32,
    /// Explicit resource policy (bit 0x20 at +0x380); resolution is caller-owned.
    pub follow_terrain: bool,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SamplePoint { Current, Ahead, Start, End }

#[derive(Clone, Debug, PartialEq)]
pub enum Error {
    NonFiniteInput { field: &'static str, component: usize },
    NonFiniteCalculation(&'static str),
    Terrain { point: SamplePoint, error: GridError },
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::NonFiniteInput { field, component } =>
                write!(f, "nonfinite missile input {field}[{component}]"),
            Self::NonFiniteCalculation(stage) =>
                write!(f, "nonfinite local f32 missile calculation: {stage}"),
            Self::Terrain { point, error } => write!(f, "{point:?} height sample: {error}"),
        }
    }
}

impl std::error::Error for Error {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self { Self::Terrain { error, .. } => Some(error), _ => None }
    }
}

/// One pure normal-mode height update. Borrows a validated dense grid.
///
/// Outside current/ahead/destination bounds can preserve the previous Y, as in
/// the observed update. A missing/invalid start sample is an explicit error,
/// unlike the native getter's zero fallback. An absent grid cannot be supplied;
/// the caller must surface that failure instead of substituting a flat grid.
/// Every input must be finite, including those bypassed by the follow branch.
pub fn local_line_missile_height(
    input: &NormalLineHeightInputs,
    grid: &DenseHeightGrid<'_>,
) -> Result<f32, Error> {
    validate(input)?;
    let current = [input.position[0], input.position[2]];
    let current_inside = inside(grid, current);
    // 0x75eb30 samples current first. Only an outside current needs lookahead.
    let mut ahead = None;
    let terrain_floor = if current_inside {
        Some(augmented_sample(grid, current, SamplePoint::Current, input)?)
    } else {
        let point = lookahead(input)?;
        ahead = Some(point);
        if inside(grid, point) {
            Some(augmented_sample(grid, point, SamplePoint::Ahead, input)?)
        } else { None }
    };
    // 0x75c7df..0x75c802 returns immediately; no interpolation or +4 correction.
    if input.follow_terrain {
        if let Some(floor) = terrain_floor {
            return finite((input.position[1] + floor) * 0.5, "follow_terrain_mean");
        }
    }

    let ahead = match ahead { Some(point) => point, None => lookahead(input)? };
    let mut height = input.position[1];
    // These gates precede endpoint selection in the native routine. This API
    // represents ONLY the normal selection, where checked end == sampled end.
    if inside(grid, ahead) && current_inside && inside(grid, input.end_xz) {
        let dx = finite(current[0] - input.start_xz[0], "distance_x")?;
        let dz = finite(current[1] - input.start_xz[1], "distance_z")?;
        let ex = finite(input.end_xz[0] - input.start_xz[0], "end_distance_x")?;
        let ez = finite(input.end_xz[1] - input.start_xz[1], "end_distance_z")?;
        let distance_squared = finite(dz * dz + dx * dx, "distance_squared")?;
        let end_squared_plus_one = finite(ez * ez + ex * ex + 1.0, "end_squared_plus_one")?;
        let ratio = finite(distance_squared / end_squared_plus_one, "distance_ratio")?;
        // Deliberately no clamp. The native +1 denominator also permits zero
        // length paths and does not make progress exactly one at the endpoint.
        let progress = finite(ratio.sqrt().powf(1.5), "nonlinear_progress")?;
        let start_terrain = sample(grid, input.start_xz, SamplePoint::Start)?;
        let end_terrain = sample(grid, input.end_xz, SamplePoint::End)?;
        let start_height = finite(input.initial_height_delta + start_terrain, "start_height")?;
        let end_height = finite(input.initial_height_delta + end_terrain, "end_height_delta")?;
        let mut end_height = finite(end_height + input.line_height_augmentation, "end_height_augmentation")?;
        // 0x75ca4a: strict >; equality receives no clearance.
        if end_terrain > end_height {
            end_height = finite(end_terrain + TERRAIN_CLEARANCE, "end_clearance")?;
        }
        let change = finite(end_height - start_height, "height_change")?;
        let scaled = finite(change * progress, "scaled_height_change")?;
        height = finite(start_height + scaled, "interpolated_height")?;
    }
    // 0x75ca75..0x75ca93 also applies when the interpolation domain gate failed.
    if let Some(floor) = terrain_floor {
        if floor > height {
            height = finite(floor + TERRAIN_CLEARANCE, "current_clearance")?;
        }
    }
    Ok(height)
}

fn validate(input: &NormalLineHeightInputs) -> Result<(), Error> {
    for (field, values) in [
        ("position", input.position.as_slice()),
        ("direction", input.direction.as_slice()),
        ("start_xz", input.start_xz.as_slice()),
        ("end_xz", input.end_xz.as_slice()),
        ("initial_height_delta", std::slice::from_ref(&input.initial_height_delta)),
        ("line_height_augmentation", std::slice::from_ref(&input.line_height_augmentation)),
    ] {
        for (component, value) in values.iter().enumerate() {
            if !value.is_finite() { return Err(Error::NonFiniteInput { field, component }); }
        }
    }
    Ok(())
}

fn finite(value: f32, stage: &'static str) -> Result<f32, Error> {
    if value.is_finite() { Ok(value) } else { Err(Error::NonFiniteCalculation(stage)) }
}

fn inside(grid: &DenseHeightGrid<'_>, point: [f32; 2]) -> bool {
    let spec = grid.spec();
    (0..2).all(|i| point[i] >= spec.min_xz[i] && point[i] <= spec.max_xz[i])
}

fn sample(grid: &DenseHeightGrid<'_>, point: [f32; 2], role: SamplePoint) -> Result<f32, Error> {
    grid.sample_local_f32(point).map_err(|error| Error::Terrain { point: role, error })
}

fn augmented_sample(
    grid: &DenseHeightGrid<'_>, point: [f32; 2], role: SamplePoint,
    input: &NormalLineHeightInputs,
) -> Result<f32, Error> {
    finite(sample(grid, point, role)? + input.line_height_augmentation, "terrain_augmentation")
}

fn lookahead(input: &NormalLineHeightInputs) -> Result<[f32; 2], Error> {
    let [mut x, y, mut z] = input.direction;
    // Full 3D length is essential: normalizing XZ alone changes the sample.
    let squared = finite((x * x + y * y) + z * z, "direction_length_squared")?;
    if squared > NORMALIZE_EPSILON_SQUARED {
        let inverse = finite(1.0 / squared.sqrt(), "inverse_direction_length")?;
        x *= inverse;
        z *= inverse;
    }
    Ok([
        finite(input.position[0] + x * LOOKAHEAD, "ahead_x")?,
        finite(input.position[2] + z * LOOKAHEAD, "ahead_z")?,
    ])
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::dense_height_grid::GridSpec;

    fn spec() -> GridSpec {
        GridSpec { min_xz: [-1000.0; 2], max_xz: [1000.0; 2],
            dimensions: [3, 3], spacing_xz: [1000.0; 2] }
    }
    fn plane(x: f32, z: f32, base: f32) -> Vec<u8> {
        (0..3).flat_map(|row| (0..3).flat_map(move |col| {
            (base + x * (col as f32 * 1000.0 - 1000.0)
                  + z * (row as f32 * 1000.0 - 1000.0)).to_le_bytes()
        })).collect()
    }
    fn input() -> NormalLineHeightInputs {
        NormalLineHeightInputs { position: [0.75, 20.0, 0.0], direction: [1.0, 0.0, 0.0],
            start_xz: [0.0, 0.0], end_xz: [2.0, 2.0], initial_height_delta: 20.0,
            line_height_augmentation: 8.0, follow_terrain: false }
    }
    fn close(actual: f32, expected: f32) {
        assert!((actual - expected).abs() < 0.0001, "{actual} != {expected}");
    }

    #[test]
    fn nonlinear_one_eighth_on_flat_plane() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        // End length squared+1=9. Current distance=.75; sqrt(.5625/9)=.25.
        // .25^1.5=1/8, startY=30, endY=38: 30+8/8=31.
        close(local_line_missile_height(&input(), &grid).unwrap(), 31.0);
    }

    #[test]
    fn nonlinear_progress_is_not_clamped() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.position[0] = 12.0;
        // sqrt(144/9)^1.5=8, therefore 30+8*8=94, not the endpoint's38.
        close(local_line_missile_height(&i, &grid).unwrap(), 94.0);
    }

    #[test]
    fn samples_both_axes_of_sloping_plane_and_keeps_initial_delta() {
        let bytes = plane(2.0, 4.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        // Start terrain10, end terrain22: start30,end50; 1/8 gives32.5.
        close(local_line_missile_height(&input(), &grid).unwrap(), 32.5);
    }

    #[test]
    fn follow_mean_returns_before_floor_and_finite_outside_endpoints() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.follow_terrain = true; i.position[1] = -20.0;
        i.line_height_augmentation = 2.0; i.start_xz = [-2000.0; 2]; i.end_xz = [2000.0; 2];
        i.direction = [f32::MAX; 3]; // Not evaluated when current sample succeeds.
        close(local_line_missile_height(&i, &grid).unwrap(), -4.0);
    }

    #[test]
    fn outside_lookahead_uses_full_3d_direction() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.follow_terrain = true; i.line_height_augmentation = 0.0;
        i.position[0] = -1100.0; i.direction = [3.0, 4.0, 0.0];
        // Horizontal advance is90, not150: still outside, so previousY20.
        assert_eq!(local_line_missile_height(&i, &grid), Ok(20.0));
        i.position[0] = -1080.0; // Ahead=-990, inside: (20+10)/2=15.
        close(local_line_missile_height(&i, &grid).unwrap(), 15.0);
        i.direction = [30.0, 40.0, 0.0];
        close(local_line_missile_height(&i, &grid).unwrap(), 15.0);
    }

    #[test]
    fn zero_and_subthreshold_direction_are_not_normalized() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.follow_terrain = true; i.position[0] = -1000.01;
        for direction in [[0.0; 3], [1.0 / 65536.0, 0.0, 0.0]] {
            i.direction = direction; assert_eq!(local_line_missile_height(&i, &grid), Ok(20.0));
        }
        i.direction = [0.0001, 0.0, 0.0];
        close(local_line_missile_height(&i, &grid).unwrap(), 19.0);
    }

    #[test]
    fn inclusive_bounds_and_one_ulp_outside_all_four_sides() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.follow_terrain = true; i.position = [0.0, 6.0, 0.0];
        i.line_height_augmentation = 0.0; i.direction = [0.0; 3];
        for component in [0, 2] {
            for boundary in [-1000.0_f32, 1000.0] {
                i.position[component] = boundary;
                close(local_line_missile_height(&i, &grid).unwrap(), 8.0);
                i.position[component] = f32::from_bits(boundary.to_bits() + 1);
                assert_eq!(local_line_missile_height(&i, &grid), Ok(6.0));
                i.position[component] = 0.0;
            }
        }
    }

    #[test]
    fn failed_domain_gate_keeps_old_height_or_applies_available_floor() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.line_height_augmentation = 0.0;
        for (position, direction, end) in [
            ([950.0, 99.0, 0.0], [1.0, 0.0, 0.0], [2.0, 2.0]), // Ahead outside.
            ([-1080.0, 99.0, 0.0], [3.0, 4.0, 0.0], [2.0, 2.0]), // Current outside.
            ([0.0, 99.0, 0.0], [1.0, 0.0, 0.0], [2000.0, 0.0]), // End outside.
        ] {
            i.position = position; i.direction = direction; i.end_xz = end;
            assert_eq!(local_line_missile_height(&i, &grid), Ok(99.0));
            i.position[1] = -1.0;
            close(local_line_missile_height(&i, &grid).unwrap(), 14.0);
        }
    }

    #[test]
    fn endpoint_floor_is_strict_and_adds_four_only_when_below() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.position[0] = 3.0; // Progress exactly1.
        i.initial_height_delta = 0.0; i.line_height_augmentation = 0.0;
        close(local_line_missile_height(&i, &grid).unwrap(), 10.0);
        i.initial_height_delta = -20.0;
        close(local_line_missile_height(&i, &grid).unwrap(), 14.0);
    }

    #[test]
    fn final_floor_includes_augmentation_and_uses_strict_comparison() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.position[0] = 0.0; i.initial_height_delta = -20.0;
        i.line_height_augmentation = 5.0;
        close(local_line_missile_height(&i, &grid).unwrap(), 19.0);
        i.initial_height_delta = 5.0; // StartY15 equals floor15, so no+4.
        close(local_line_missile_height(&i, &grid).unwrap(), 15.0);
    }

    #[test]
    fn zero_length_path_has_defined_denominator_and_negative_height_is_preserved() {
        let bytes = plane(0.0, 0.0, -10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.position[0] = 0.25; i.end_xz = i.start_xz;
        i.initial_height_delta = 4.0; i.line_height_augmentation = 2.0;
        // sqrt(.0625/1)^1.5=1/8; start=-6,end=-4 => -5.75.
        close(local_line_missile_height(&i, &grid).unwrap(), -5.75);
    }

    #[test]
    fn invalid_start_sample_is_an_error_not_native_zero_fallback() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.start_xz = [-2000.0, 0.0];
        assert!(matches!(local_line_missile_height(&i, &grid),
            Err(Error::Terrain { point: SamplePoint::Start, error: GridError::OutsideBounds { .. } })));
    }

    #[test]
    fn all_nonfinite_inputs_are_rejected_even_in_follow_branch() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        for invalid in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY] {
            for slot in 0..12 {
                let mut i = input(); i.follow_terrain = true;
                match slot {
                    0..=2 => i.position[slot] = invalid,
                    3..=5 => i.direction[slot - 3] = invalid,
                    6..=7 => i.start_xz[slot - 6] = invalid,
                    8..=9 => i.end_xz[slot - 8] = invalid,
                    10 => i.initial_height_delta = invalid,
                    _ => i.line_height_augmentation = invalid,
                }
                assert!(matches!(local_line_missile_height(&i, &grid), Err(Error::NonFiniteInput { .. })));
            }
        }
    }

    #[test]
    fn nonfinite_intermediates_are_explicit_errors() {
        let bytes = plane(0.0, 0.0, 10.0); let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        let mut i = input(); i.direction = [f32::MAX; 3];
        assert_eq!(local_line_missile_height(&i, &grid), Err(Error::NonFiniteCalculation("direction_length_squared")));
        let huge_bytes = plane(0.0, 0.0, f32::MAX);
        let huge = DenseHeightGrid::parse(spec(), &huge_bytes).unwrap();
        i = input(); i.line_height_augmentation = f32::MAX;
        assert_eq!(local_line_missile_height(&i, &huge), Err(Error::NonFiniteCalculation("terrain_augmentation")));
        i.line_height_augmentation = 0.0; i.position[1] = f32::MAX; i.follow_terrain = true;
        assert_eq!(local_line_missile_height(&i, &huge), Err(Error::NonFiniteCalculation("follow_terrain_mean")));
    }
}
