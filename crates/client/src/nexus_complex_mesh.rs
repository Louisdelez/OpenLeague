//! Bounded Order_Nexus gem/gem_inside mesh preparation. No emitter, timer or pose guess.
//! Native 97EC60 must be represented by the supplied final row-vector world matrix.
pub const PICKUP_SOURCE:&[u8]=include_bytes!("../../../data/4.20/relic_pickup/Saucer8.SCB");
use bevy::{asset::RenderAssetUsages, mesh::PrimitiveTopology, prelude::*};

pub const SOURCE: &[u8] = include_bytes!("../../../data/4.20/nexus_complex/Nexus_Gem.scb");
pub const CROWN_SOURCE: &[u8] = include_bytes!("../../../data/4.20/nexus_crown/Saucer6.scb");
pub const SOURCE_SHA256: &str = "77aa58f215f93b3a77a0a543723b458ef30ddd23383b96c729bf1f5a58fd586e";
pub const SPARKLE_SOURCE: &[u8] = include_bytes!("../../../data/4.20/nexus_complex/Nexus_Gem_Sparkle.scb");
pub const SPARKLE_SHA256: &str = "69db522a185f36a8f6a8aa4de1cf4f01cec172c1ebb2ba7714cb16b397ab3b10";

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Group { GemInside, Gem, GemSparkle }
impl Group {
    pub fn authored_name(self) -> &'static str {
        match self { Self::GemInside => "gem_inside", Self::Gem => "gem", Self::GemSparkle => "gem_sparkle" }
    }
    pub fn texture_asset(self) -> &'static str {
        match self {
            Self::GemInside => "particles/nexus_complex_linear/Nexus_Gem_inside_mono.dds",
            Self::Gem => "particles/nexus_complex_linear/Nexus_Gem_mono.dds",
            Self::GemSparkle => "particles/nexus_complex_linear/Nexus_Gem_Sparkle.dds",
        }
    }
    pub fn dimensions(self) -> (u32, u32) {
        match self { Self::GemInside => (128, 8), Self::Gem | Self::GemSparkle => (256, 9) }
    }
}

/// D3D row-vector matrix as 16 native f32 words, including the final translation.
/// This is the result of the native mesh transform composition, not the 937120
/// surface packet by itself. The caller must account for mesh centre/scale once.
#[derive(Clone, Copy, Debug)]
pub struct NativeWorld(pub [f32; 16]);
impl NativeWorld {
    pub fn validate(self) -> Result<Self, &'static str> {
        if !self.0.iter().all(|v| v.is_finite())
            || [self.0[3], self.0[7], self.0[11], self.0[15]] != [0., 0., 0., 1.]
        { return Err("Nexus mesh requires a finite affine native world matrix"); }
        Ok(self)
    }
    pub fn point(self, p: [f32; 3]) -> Result<[f32; 3], &'static str> {
        self.validate()?;
        // Explicit non-fused order; this is a host adaptation, not an x87 oracle.
        let out = std::array::from_fn(|i| {
            ((p[0] * self.0[i] + p[1] * self.0[4+i]) + p[2] * self.0[8+i]) + self.0[12+i]
        });
        if !out.iter().all(|v| v.is_finite()) { return Err("Nexus world vertex overflow"); }
        Ok(out)
    }
}

#[derive(Clone, Debug)]
pub struct Corner { pub position: [f32; 3], pub uv: [f32; 2], pub rgb: [u8; 3] }
#[derive(Clone, Debug)]
pub struct Geometry { pub corners: Vec<Corner>, pub centre: [f32; 3] }
fn f32_at(bytes: &[u8], at: usize) -> f32 {
    f32::from_le_bytes(bytes[at..at+4].try_into().unwrap())
}
fn u32_at(bytes: &[u8], at: usize) -> u32 {
    u32::from_le_bytes(bytes[at..at+4].try_into().unwrap())
}
impl Geometry {
    /// Accept only the exact bounded original. No general SCB-format claim.
    pub fn decode(bytes: &[u8]) -> Result<Self, &'static str> {
        let (vertices, triangles) = if bytes == SOURCE { (20,36) }
            else if bytes == SPARKLE_SOURCE { (86,168) }
            else if bytes == CROWN_SOURCE { (120,160) }
            else if bytes==PICKUP_SOURCE {(80,80)}
            else { return Err("Nexus SCB differs from the three pinned originals"); };
        let positions = 176;
        let centre_at = positions + vertices * 12;
        let faces = centre_at + 12;
        let colors = faces + triangles * 100;
        let mut corners = Vec::with_capacity(triangles*3);
        for face in 0..triangles {
            let at = faces + face * 100;
            for corner in 0..3 {
                let index = u32_at(bytes, at + corner * 4) as usize;
                if index >= vertices { return Err("Nexus SCB vertex index outside pinned mesh"); }
                corners.push(Corner {
                    position: std::array::from_fn(|i| f32_at(bytes, positions + index * 12 + i*4)),
                    uv: [f32_at(bytes, at + 76 + corner*4), f32_at(bytes, at + 88 + corner*4)],
                    rgb: bytes[colors + face*9 + corner*3..colors + face*9 + corner*3 + 3].try_into().unwrap(),
                });
            }
        }
        Ok(Self { corners, centre: std::array::from_fn(|i| f32_at(bytes, centre_at+i*4)) })
    }
    pub fn original() -> Self { Self::decode(SOURCE).expect("compiled pinned Nexus geometry") }
    pub fn crown() -> Self { Self::decode(CROWN_SOURCE).expect("compiled pinned Crown geometry") }
    pub fn sparkle() -> Self { Self::decode(SPARKLE_SOURCE).expect("compiled pinned Nexus sparkle geometry") }

    /// Private triangle-list mesh in base D = native XYZ / 20, with original winding
    /// and UV seams. No root reflection, normal reconstruction, smoothing or pivot fix.
    pub fn bake(&self, world: NativeWorld) -> Result<Mesh, &'static str> {
        world.validate()?;
        let mut positions = Vec::with_capacity(self.corners.len());
        let mut uv = Vec::with_capacity(self.corners.len());
        let mut varying = Vec::with_capacity(self.corners.len());
        for corner in &self.corners {
            let p = world.point(corner.position)?;
            positions.push(p.map(|x| x/20.));
            uv.push(corner.uv);
            // A transport varying only, NOT native SCB colour. The bounded material
            // has no USE_VERTEX_COLORS and reads alpha only as native height fade.
            varying.push([0., 0., 0., crate::native_fow::fade_toward_fogged(p[1])]);
        }
        let mut mesh = Mesh::new(PrimitiveTopology::TriangleList, RenderAssetUsages::default());
        mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION, positions);
        mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0, uv);
        mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR, varying);
        Ok(mesh)
    }
}

#[cfg(test)]
#[path = "nexus_complex_mesh_tests.rs"]
mod tests;
