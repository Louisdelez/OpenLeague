//! Private LOCAL restored R release policy, not native animation/server parity.
//!
//! The actor root uses captured Champion.height, separately from dense cast Y.
//! R_foot is the restored GLB node43 (skin joint42), clip41 at local time1s;
//! the fixed model-space sample comes from DATA audit a16538f44a203994... .
//! Native ordering basis: 75e36e..75e414, 75c505..75c765. The original endpoint
//! out-of-domain branch is explicit; missing or invalid terrain is never zero.
use crate::{dense_height_grid::{DenseHeightGrid, Error as GridError},
    entity_facing::Facing, linear_skillshot::Identity, line_missile_height,
    line_missile_height::NormalLineHeightInputs, Point};
use std::fmt;

pub(crate) const POLICY: &str = "map10_restored_r_release_local_v1";
pub(crate) const POSE_GLB_SHA256: &str =
    "74827b456ff82b96474715df2d314da26907e8b0dc256b46d822ca7276a2b7b5";
pub(crate) const POSE_AUDIT_SHA256: &str =
    "a16538f44a2039946480600d16f73cd8a76daa310500869e4946edbd5d44921e";
const MODEL_R_FOOT_AT_ONE_SECOND: [f32; 3] =
    [10.326360440872612, 60.07355187241438, -9.017964545309718];
const CATALOG_SCALE: f32 = 1.1;
// Explicit resource policy: original-only EzrealTrueshotBarrage4.20, no VFS
// overlay. ParticleStartOffset, line augmentation and gravity are proven0;
// MissileFollowsTerrainHeight is absent and its loader default is false.
const LINE_AUGMENTATION: f32 = 0.0;
const FOLLOW_TERRAIN: bool = false;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum TerrainRole { Cast, Bone, Endpoint }
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum Error {
    InvalidIdentity,
    NonFiniteInput { field: &'static str, component: usize },
    NonFiniteCalculation(&'static str),
    InvalidRange,
    UndefinedAim,
    Heading(&'static str),
    CastGroundMismatch,
    Terrain { role: TerrainRole, error: GridError },
    IdentityMismatch,
    UnexpectedTick,
    Update(line_missile_height::Error),
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidIdentity => write!(f, "invalid vertical R identity"),
            Self::NonFiniteInput { field, component } => write!(f, "nonfinite {field}[{component}]"),
            Self::NonFiniteCalculation(stage) => write!(f, "nonfinite vertical R calculation: {stage}"),
            Self::InvalidRange => write!(f, "vertical R range must be positive and finite"),
            Self::UndefinedAim => write!(f, "vertical R aim has no direction"),
            Self::Heading(error) => write!(f, "vertical R heading: {error}"),
            Self::CastGroundMismatch => write!(f, "captured cast Y differs from this immutable dense grid"),
            Self::Terrain { role, error } => write!(f, "{role:?} terrain: {error}"),
            Self::IdentityMismatch => write!(f, "vertical R identity changed"),
            Self::UnexpectedTick => write!(f, "vertical R requires one consecutive tick"),
            Self::Update(error) => write!(f, "vertical R update: {error}"),
        }
    }
}
impl std::error::Error for Error {}

/// Mathematically follows entity_orientation::from_facing: native yaw matrix
/// columns -> quaternion -> normalize -> rotate. This specializes the same
/// glam0.32.1 from_rotation_axes branches to a Y-only matrix, without Bevy.
/// Scalar f32 rounding can differ from the client SIMD path; no bit parity.
/// All coordinates are native units. Client divides origin by20 and scales the
/// model by0.05*1.1; converting back gives origin + rotation*(1.1*model).
pub(crate) fn restored_release_bone(
    actor_origin: [f32; 3], facing: Facing,
) -> Result<[f32; 3], Error> {
    validate("actor_origin", &actor_origin)?;
    let mut frame = [0u32; 19];
    crate::entity_yaw::apply_angle(&mut frame, facing.yaw_degrees()).map_err(Error::Heading)?;
    let c = f32::from_bits(frame[0]);
    let s = f32::from_bits(frame[8]);
    let (mut qy, mut qw) = if c <= 0.0 {
        let four_y_squared = (1.0 - c) + (1.0 - c);
        let inv4y = 0.5 / four_y_squared.sqrt();
        (four_y_squared * inv4y, (s - f32::from_bits(frame[2])) * inv4y)
    } else {
        let four_w_squared = (1.0 + c) + (1.0 + c);
        let inv4w = 0.5 / four_w_squared.sqrt();
        ((s - f32::from_bits(frame[2])) * inv4w, four_w_squared * inv4w)
    };
    let inverse = finite(1.0 / (qy * qy + qw * qw).sqrt(), "yaw normalization")?;
    qy *= inverse; qw *= inverse;
    let [x, y, z] = MODEL_R_FOOT_AT_ONE_SECOND.map(|v| v * CATALOG_SCALE);
    // Same normalized quaternion vector identity used by glam mul_vec3a.
    let common = qw * qw - qy * qy;
    let twice_w = 2.0 * qw;
    let rotated = [x * common + (qy * z) * twice_w,
        y * common + qy * ((y * qy) * 2.0),
        z * common + (-qy * x) * twice_w];
    let result = std::array::from_fn(|i| actor_origin[i] + rotated[i]);
    validate_calculation("restored bone placement", &result)?;
    Ok(result)
}

/// An explicit branch, NOT a claimed height sample of0 outside the map.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum EndpointBranch { DenseTerrain, OutsideDenseDomain }

/// Private owned state. No serde, public origins, endpoint or pose history.
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct FlightHeight {
    identity: Identity,
    tick: u64,
    input: NormalLineHeightInputs,
    endpoint: [f32; 3],
    endpoint_branch: EndpointBranch,
}
impl FlightHeight {
    /// Prepares the release pose once at accepted cast time, for a local1s
    /// windup. It must remain private while Pending; its first current tick is
    /// release_tick. No actor resampling or scene/animation lookup occurs later.
    pub(crate) fn prepare(
        identity: Identity, release_tick: u64, cast_ground: [f32; 3],
        actor_root_y: f32, facing: Facing, aim: Point, range: f32,
        grid: &DenseHeightGrid<'_>,
    ) -> Result<Self, Error> {
        if identity.owner == 0 || identity.team > 1 || identity.ordinal == 0 {
            return Err(Error::InvalidIdentity);
        }
        validate("cast_ground", &cast_ground)?;
        validate("actor_root_y", &[actor_root_y])?;
        validate("aim", &[aim.x, aim.z])?;
        if !range.is_finite() || range <= 0.0 { return Err(Error::InvalidRange); }
        let start_xz = [cast_ground[0], cast_ground[2]];
        let sampled_cast = sample(grid, start_xz, TerrainRole::Cast)?;
        if sampled_cast.to_bits() != cast_ground[1].to_bits() { return Err(Error::CastGroundMismatch); }
        let bone = restored_release_bone([cast_ground[0], actor_root_y, cast_ground[2]], facing)?;
        let bone_terrain = sample(grid, [bone[0], bone[2]], TerrainRole::Bone)?;
        let delta = finite(bone[1] - bone_terrain, "initial height delta")?;
        // Match the local Shot's range endpoint arithmetic; clicked aim supplies
        // direction only. The endpoint stays at full RANGE, even outside Map10.
        let dx = f64::from(aim.x) - f64::from(cast_ground[0]);
        let dz = f64::from(aim.z) - f64::from(cast_ground[2]);
        let length = dx.hypot(dz);
        if length == 0.0 { return Err(Error::UndefinedAim); }
        let end_xz = [
            finite((f64::from(cast_ground[0]) + dx / length * f64::from(range)) as f32, "endpoint X")?,
            finite((f64::from(cast_ground[2]) + dz / length * f64::from(range)) as f32, "endpoint Z")?,
        ];
        // 75e36e..75e414 ordering: horizontal aim's pre-height endpointY is
        // CastInfoY. Direction is captured relative to the OLD factory bone.
        // Later spawn/endY replacement does not recompute it; gravity0 keeps Y.
        let direction_before_height = [
            finite(end_xz[0] - bone[0], "direction X")?,
            finite(cast_ground[1] - bone[1], "direction Y")?,
            finite(end_xz[1] - bone[2], "direction Z")?,
        ];
        let direction = normalize(direction_before_height)?;
        let spawn = [cast_ground[0], finite(cast_ground[1] + delta, "spawn Y")?, cast_ground[2]];
        let (endpoint_y, endpoint_branch) = if inside(grid, end_xz) {
            let height = sample(grid, end_xz, TerrainRole::Endpoint)?;
            (finite(finite(height + delta, "endpoint delta")? + LINE_AUGMENTATION, "endpoint augmentation")?,
                EndpointBranch::DenseTerrain)
        } else {
            // Native75c661..75c66d explicit branch: endpointY=delta+augment.
            // Cast/bone errors are never redirected here, and no grid is fake.
            (finite(delta + LINE_AUGMENTATION, "outside endpoint Y")?, EndpointBranch::OutsideDenseDomain)
        };
        // End XYZ is deliberately validated although the existing updater
        // accepts XZ+delta. It re-derives the same Y only in its inside gate.
        validate_calculation("endpoint XYZ", &[end_xz[0], endpoint_y, end_xz[1]])?;
        Ok(Self { identity, tick: release_tick, endpoint_branch,
            endpoint: [end_xz[0], endpoint_y, end_xz[1]],
            input: NormalLineHeightInputs { position: spawn, direction, start_xz, end_xz,
                initial_height_delta: delta, line_height_augmentation: LINE_AUGMENTATION,
                follow_terrain: FOLLOW_TERRAIN } })
    }

    /// Called only after the matching 2D shot advanced successfully. Does not
    /// move XZ, hit, change damage or shorten range. Every Err leaves self intact;
    /// the owning Flight must retire vertical availability on error.
    pub(crate) fn advance(
        &mut self, identity: Identity, tick: u64, position: Point, grid: &DenseHeightGrid<'_>,
    ) -> Result<(), Error> {
        if identity != self.identity { return Err(Error::IdentityMismatch); }
        if self.tick.checked_add(1) != Some(tick) { return Err(Error::UnexpectedTick); }
        validate("current_xz", &[position.x, position.z])?;
        let mut next = self.input;
        next.position[0] = position.x; next.position[2] = position.z;
        next.position[1] = line_missile_height::local_line_missile_height(&next, grid).map_err(Error::Update)?;
        self.input = next; self.tick = tick;
        Ok(())
    }

    /// Query for a separately authorized visible row, never an authorization
    /// or history query itself. Identity, tick and exact f32 XZ must all match.
    pub(crate) fn current_y(&self, identity: Identity, tick: u64, position: Point) -> Option<f32> {
        (identity == self.identity && tick == self.tick
            && position.x.to_bits() == self.input.position[0].to_bits()
            && position.z.to_bits() == self.input.position[2].to_bits()
            && self.input.position[1].is_finite()).then_some(self.input.position[1])
    }
}

fn validate(field: &'static str, values: &[f32]) -> Result<(), Error> {
    for (component, value) in values.iter().enumerate() {
        if !value.is_finite() { return Err(Error::NonFiniteInput { field, component }); }
    }
    Ok(())
}
fn validate_calculation(stage: &'static str, values: &[f32]) -> Result<(), Error> {
    if values.iter().all(|v| v.is_finite()) { Ok(()) } else { Err(Error::NonFiniteCalculation(stage)) }
}
fn finite(value: f32, stage: &'static str) -> Result<f32, Error> {
    if value.is_finite() { Ok(value) } else { Err(Error::NonFiniteCalculation(stage)) }
}
fn sample(grid: &DenseHeightGrid<'_>, xz: [f32; 2], role: TerrainRole) -> Result<f32, Error> {
    grid.sample_local_f32(xz).map_err(|error| Error::Terrain { role, error })
}
fn inside(grid: &DenseHeightGrid<'_>, xz: [f32; 2]) -> bool {
    let spec = grid.spec();
    (0..2).all(|i| xz[i] >= spec.min_xz[i] && xz[i] <= spec.max_xz[i])
}
fn normalize(direction: [f32; 3]) -> Result<[f32; 3], Error> {
    let [x, y, z] = direction;
    let length_squared = finite((x * x + y * y) + z * z, "direction squared")?;
    if length_squared <= f32::from_bits(0x3089_705f) { return Err(Error::UndefinedAim); }
    let inverse = finite(1.0 / length_squared.sqrt(), "direction normalization")?;
    let result = direction.map(|value| value * inverse);
    validate_calculation("normalized direction", &result)?;
    Ok(result)
}

#[cfg(test)]
#[path = "ezreal_r_vertical_local_tests.rs"]
mod tests;
