//! Conditional spatial adapter for reconstructed fogcircle, actual native mist surfaces.
//! Original missing mesh header/cache/geometry is not admitted by this module.
//! Native926907 placement and97EC60 matrices were compared on96frames/288surfaces.
use openleague_core::native_complex_mesh_pose::{self, Inputs};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct ReconstructedHeader {
    /// Native mesh AD/D1/A1 fields. The admitted policy is9C=2,A0=false,EC=0.
    pub centre: [f32; 3],
    pub post: [f32; 3],
    pub position: [f32; 3],
}
impl ReconstructedHeader {
    /// Explicit fogcircle-v2 reconstruction choice, not original loader output.
    pub fn neutral_fogcircle_v2() -> Self {
        Self { centre: [0.;3], post: [0.;3], position: [0.;3] }
    }
}

#[derive(Clone, Copy, Debug)]
pub struct Placement {
    pub scale: [f32;3],
    pub pose: [f32;16],
    pub world: [f32;16],
}

fn finite(mut values: impl Iterator<Item=f32>) -> bool { values.all(f32::is_finite) }

/// Actual surface56 from937120. Positions0..15 already include postoffset10.
/// Native caller clears pose translation, then8E8B70 updates reconstructed
/// header fields. The stored second matrix16..31 must not be applied again.
/// BC/C0 are supplied actor fields; source/header/cache ownership is caller work.
pub fn prepare(surface: [u32;56], header: &mut ReconstructedHeader,
    actor_bc: f32, actor_c0: f32) -> Result<Placement, &'static str>
{
    let source = surface.map(f32::from_bits);
    if !finite(header.centre.into_iter().chain(header.post).chain(header.position))
        || !finite(source[..16].iter().copied().chain(source[36..39].iter().copied()))
        || !actor_bc.is_finite() || !actor_c0.is_finite()
    { return Err("nonfinite mist mesh spatial input"); }
    // Mist source has equal axes. Earlier renderer flag8 can permute axes for
    // other types; this bounded adapter rejects them rather than guessing it.
    if surface[36] != surface[37] || surface[36] != surface[38] {
        return Err("unqualified unequal mist scale axes");
    }
    let mut pose: [f32;16] = source[..16].try_into().expect("surface width");
    if [pose[3],pose[7],pose[11],pose[15]] != [0.,0.,0.,1.] {
        return Err("mist surface pose is not finite affine");
    }
    let position: [f32;3] = pose[12..15].try_into().expect("surface position");
    pose[12..15].fill(0.);
    let actor_scale = actor_c0 * actor_bc;
    let scale = std::array::from_fn(|i| actor_scale * source[36+i]);
    let mut next = *header;
    for axis in 0..3 {
        // Original caller9269F6 forms displacement before8E8B70. That helper
        // adds separately to post/centre/current; no direct assignment shortcut.
        let displacement = position[axis] - header.position[axis];
        next.post[axis] += displacement;
        next.centre[axis] += displacement;
        next.position[axis] += displacement;
    }
    let world = native_complex_mesh_pose::compose(Inputs {
        centre: next.centre, post_offset: next.post, scale, pose,
    })?;
    if !finite(next.position.into_iter().chain(world)) { return Err("mist spatial overflow"); }
    *header = next;
    Ok(Placement { scale, pose, world })
}

#[derive(Clone, Debug)]
pub struct ReconstructedGeometry {
    pub native_positions: Vec<[f32;3]>,
    pub uv: Vec<[f32;2]>,
    pub triangles: Vec<[u32;3]>,
}
#[derive(Clone, Debug)]
pub struct BakedGeometry {
    /// Base world units=actual native XYZ/20, no reflection or extra parent pose.
    pub positions: Vec<[f32;3]>,
    pub uv: Vec<[f32;2]>,
    pub triangles: Vec<[u32;3]>,
}
impl ReconstructedGeometry {
    pub fn bake(&self, world: [f32;16]) -> Result<BakedGeometry, &'static str> {
        if self.native_positions.len()!=769 || self.uv.len()!=769 || self.triangles.len()!=1440 {
            return Err("geometry differs from the bounded fogcircle-v2 topology");
        }
        if !finite(world.into_iter()) || [world[3],world[7],world[11],world[15]] != [0.,0.,0.,1.]
            || self.native_positions.iter().flatten().chain(self.uv.iter().flatten()).any(|v|!v.is_finite())
            || self.triangles.iter().flatten().any(|i|*i>=769)
        { return Err("invalid reconstructed geometry/world inputs"); }
        // This host point arithmetic retains separate f32 operations. It is not
        // a native shader DP4/projection/raster oracle; those remain GPU work.
        let positions = self.native_positions.iter().map(|point| {
            std::array::from_fn(|axis| {
                (((point[0]*world[axis]+point[1]*world[4+axis])+point[2]*world[8+axis])+world[12+axis])/20.
            })
        }).collect::<Vec<[f32;3]>>();
        if positions.iter().flatten().any(|v|!v.is_finite()) { return Err("mist world vertex overflow"); }
        Ok(BakedGeometry { positions, uv: self.uv.clone(), triangles: self.triangles.clone() })
    }
}

#[cfg(test)]
#[path="spawn_mist_world_tests.rs"]mod tests;
