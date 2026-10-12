//! Terrain projection preparation from SIMPLE_PROJECTED_VS.vs_2_0.
//! The caller must supply recovered c235/c236 constants and actual map triangles.
//! This module does not select an emitter scale convention, sampler or fog state.
use bevy::prelude::*;

/// Matrix/bounds prepared by the native92E130 math prefix.
/// This is distinct from the SIMPLE_PROJECTED shader's c235/c236 contract.
#[derive(Clone, Copy, Debug)]
pub struct TerrainProjection {
    pub world_to_uv: Mat4,
    pub native_bounds_xz: Vec4,
    pub native_height: Option<Vec3>,
}
impl TerrainProjection {
    pub fn new(native_center: Vec2, native_half_size: Vec2, angle_degrees: f32) -> Option<Self> {
        if !native_center.is_finite() || !native_half_size.is_finite()
            || native_half_size.x == 0. || native_half_size.y == 0. || !angle_degrees.is_finite() {
            return None;
        }
        // Recovered native1138A68 float constant, rather than a double conversion.
        let rotation = Mat4::from_rotation_y(angle_degrees * f32::from_bits(0x3c8efa35));
        let world_to_uv = Mat4::from_translation(Vec3::new(0.5, 0., 0.5))
            * Mat4::from_scale(Vec3::new(1./(native_half_size.x*2.), 1., 1./(native_half_size.y*2.)))
            * rotation
            * Mat4::from_translation(Vec3::new(-native_center.x, 0., -native_center.y));
        let mut lo=Vec2::splat(f32::INFINITY);
        let mut hi=Vec2::splat(f32::NEG_INFINITY);
        for x in [-native_half_size.x, native_half_size.x] {
            for z in [-native_half_size.y, native_half_size.y] {
                let p=rotation.transform_point3(Vec3::new(x,0.,z)).xz()+native_center;
                lo=lo.min(p);hi=hi.max(p);
            }
        }
        let result=Self { native_height:None, world_to_uv, native_bounds_xz: Vec4::new(lo.x,lo.y,hi.x,hi.y) };
        (result.world_to_uv.is_finite() && result.native_bounds_xz.is_finite()).then_some(result)
    }
    pub fn with_native_height(mut self, center:f32, range:f32, fading:f32)->Option<Self> {
        let values=Vec3::new(center,range,fading);
        if !values.is_finite() || fading<=0. {return None;}
        self.native_height=Some(values);Some(self)
    }
    /// Environment_UNLIT_DECAL_VS: evaluate at ORIGINAL vertices, before clipping.
    /// Negative values survive interpolation; only the pixel shader clamps to zero.
    pub fn height_factor(self, world:Vec3)->f32 {
        let Some(v)=self.native_height else{return 1.;};
        let difference=(world.y*20.-v.x).abs();
        if difference<=v.y {1.}else{1.-(difference-v.y)/v.z}
    }
    pub fn uv(self, world: Vec3) -> Vec2 {
        self.world_to_uv.transform_point3(world*20.).xz()
    }
    pub fn clip_triangle(self, triangle: [Vec3; 3]) -> Vec<[SurfaceVertex; 3]> {
        if triangle.iter().any(|v| !v.is_finite()) { return Vec::new(); }
        let vertices:Vec<_>=triangle.into_iter().map(|world|SurfaceVertex { world, uv:self.uv(world), height_factor:self.height_factor(world) }).collect();
        if vertices.iter().any(|v| !v.uv.is_finite()) { return Vec::new(); }
        clip_vertices(vertices)
    }
}

#[derive(Clone, Copy, Debug)]
pub struct Projection {
    /// Native OFFSET_AND_SCALE: XZ offset followed by independent inverse scales.
    pub offset_and_scale: Vec4,
    /// Native SIN_AND_COS.xy; not inferred from a particle rotation field.
    pub sin_and_cos: Vec2,
}
impl Projection {
    pub fn valid(self) -> bool {
        self.offset_and_scale.is_finite()
            && self.sin_and_cos.is_finite()
            && self.offset_and_scale.z != 0.
            && self.offset_and_scale.w != 0.
            && (self.sin_and_cos.length_squared() - 1.).abs() < 0.0001
    }
    /// Port of native shader arithmetic, with OpenLeague world units converted back.
    pub fn uv(self, world: Vec3) -> Vec2 {
        let temp = (world.xz() * 20. - self.offset_and_scale.xy())
            * self.offset_and_scale.zw();
        Vec2::new(
            temp.x * self.sin_and_cos.y - temp.y * self.sin_and_cos.x,
            temp.x * self.sin_and_cos.x + temp.y * self.sin_and_cos.y,
        )
    }
}
#[derive(Clone, Copy, Debug)]
pub struct SurfaceVertex {
    pub world: Vec3,
    pub uv: Vec2,
    pub height_factor:f32,
}
impl SurfaceVertex {
    fn lerp(self, other: Self, t: f32) -> Self {
        Self { world: self.world.lerp(other.world, t), uv: self.uv.lerp(other.uv, t), height_factor:self.height_factor+(other.height_factor-self.height_factor)*t }
    }
}

/// Clip original terrain triangles to the projected texture footprint.
/// Interpolation retains sloped terrain heights; no navigation-grid plane is invented.
/// This footprint policy is a reconstruction: native clipping/sampler rules remain open.
pub fn clip_triangle(projection: Projection, triangle: [Vec3; 3]) -> Vec<[SurfaceVertex; 3]> {
    if !projection.valid() || triangle.iter().any(|v| !v.is_finite()) {
        return Vec::new();
    }
    let polygon: Vec<_> = triangle.into_iter()
        .map(|world| SurfaceVertex { world, uv: projection.uv(world), height_factor:1. }).collect();
    clip_vertices(polygon)
}
fn clip_vertices(mut polygon: Vec<SurfaceVertex>) -> Vec<[SurfaceVertex;3]> {
    for (axis, limit, keep_greater) in [(0, 0., true), (0, 1., false), (1, 0., true), (1, 1., false)] {
        if polygon.is_empty() { break; }
        let inside = |v: SurfaceVertex| {
            if keep_greater { v.uv[axis] >= limit } else { v.uv[axis] <= limit }
        };
        let input = std::mem::take(&mut polygon);
        let mut previous = *input.last().unwrap();
        for current in input {
            let a = inside(previous);
            let b = inside(current);
            if a != b {
                let t = ((limit - previous.uv[axis]) / (current.uv[axis] - previous.uv[axis])).clamp(0., 1.);
                let mut intersection=previous.lerp(current, t);
                // Keep the clipping coordinate exactly on the boundary despite f32 cancellation.
                intersection.uv[axis]=limit;
                polygon.push(intersection);
            }
            if b { polygon.push(current); }
            previous = current;
        }
    }
    (1..polygon.len().saturating_sub(1)).filter_map(|i| {
        let t = [polygon[0], polygon[i], polygon[i+1]];
        let normal = (t[1].world - t[0].world).cross(t[2].world - t[0].world);
        (normal.length_squared() > 1e-12).then_some(t)
    }).collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn legacy_height_is_evaluated_before_clipping_and_clamped_only_in_fragment() {
        let p=TerrainProjection::new(Vec2::ZERO,Vec2::splat(20.),0.).unwrap().with_native_height(0.,5.,200.).unwrap();
        for (native_y,expected) in [(0.,1.),(5.,1.),(-5.,1.),(105.,0.5),(205.,0.),(405.,-1.)] {
            assert!((p.height_factor(Vec3::new(0.,native_y/20.,0.))-expected).abs()<1e-6);
        }
        let triangles=p.clip_triangle([Vec3::new(-2.,-20.,0.),Vec3::new(2.,20.,0.),Vec3::new(0.,0.,2.)]);
        let edge=triangles.iter().flatten().find(|v|(v.world.x+1.).abs()<1e-6 && v.world.z.abs()<1e-6).unwrap();
        // Both original edge endpoints have the same negative fade. Re-evaluation
        // at the newly clipped midpoint would incorrectly produce another value.
        assert!((edge.height_factor-(-0.975)).abs()<1e-6);
        assert!((edge.height_factor-p.height_factor(edge.world)).abs()>0.5);
        assert!(p.with_native_height(0.,5.,0.).is_none());
    }
    fn unrotated() -> Projection {
        Projection { offset_and_scale: Vec4::new(100., 200., 0.002, 0.004), sin_and_cos: Vec2::new(0., 1.) }
    }
    #[test]
    fn native_matrix_and_bounds_match_original_executable_for_every_finite_oracle_case() {
        let data: serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particle_projection_contract.json")).unwrap();
        assert_eq!(data["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
        let pair=|v:&serde_json::Value| Vec2::new(v[0].as_f64().unwrap() as f32,v[1].as_f64().unwrap() as f32);
        let near=|a:f32,b:f32| (a-b).abs() <= 0.00001 * b.abs().max(1.);
        let mut finite=0;let mut rejected=0;
        for case in data["cases"].as_array().unwrap() {
            let center=pair(&case["center_xz"]);let size=pair(&case["half_size_xz"]);
            let Some(p)=TerrainProjection::new(center,size,case["angle_degrees"].as_f64().unwrap() as f32) else {
                assert!(size.x==0. || size.y==0.);rejected+=1;continue;
            };
            let native:Vec<f32>=case["uv_matrix_bits"].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect();
            for (actual,expected) in p.world_to_uv.to_cols_array().iter().zip(native.iter()) {
                assert!(near(*actual,*expected),"matrix {case}: {actual} != {expected}");
            }
            let bounds:Vec<f32>=case["world_bounds_bits"].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect();
            for (actual,expected) in p.native_bounds_xz.to_array().iter().zip(bounds.iter()) {
                assert!(near(*actual,*expected),"bounds {case}: {actual} != {expected}");
            }
            assert!((p.uv(Vec3::new(center.x,0.,center.y)/20.)-Vec2::splat(0.5)).length()<0.001);
            finite+=1;
        }
        assert_eq!((finite,rejected),(108,6));
    }
    #[test]
    fn native_rotated_anisotropic_projection_clips_sloped_geometry_without_flattening() {
        let p=TerrainProjection::new(Vec2::new(1000.,2000.),Vec2::new(500.,250.),45.).unwrap();
        let point=|x,z|Vec3::new(x,2.*x+3.*z+7.,z);
        let triangles=p.clip_triangle([point(-500.,-500.),point(1500.,-500.),point(-500.,1500.)]);
        assert_eq!(triangles.len(),2);
        let mut area=0.;
        for t in triangles {
            for v in t {
                assert!((v.world.y-(2.*v.world.x+3.*v.world.z+7.)).abs()<0.001);
                assert!((v.uv-p.uv(v.world)).length()<0.0001);
            }
            area+=(t[1].uv-t[0].uv).perp_dot(t[2].uv-t[0].uv).abs()*0.5;
        }
        assert!((area-1.).abs()<1e-6);
    }
    #[test]
    fn native_uv_handles_translation_anisotropic_scale_and_rotation_without_map_double_flip() {
        let p = unrotated();
        let world = Vec3::new(17.5, -8., 16.25); // Native XZ = 350,325.
        assert!((p.uv(world) - Vec2::splat(0.5)).length() < 1e-6);
        let rotated = Projection { sin_and_cos: Vec2::new(1., 0.), ..p };
        assert!((rotated.uv(world) - Vec2::new(-0.5, 0.5)).length() < 1e-6);
        assert_eq!(p.uv(Vec3::new(5., 999., 10.)), Vec2::ZERO);
        // Y has no influence in the original projected-UV arithmetic.
        assert_eq!(p.uv(world), p.uv(Vec3::new(world.x, 777., world.z)));
    }
    #[test]
    fn clipping_preserves_real_sloped_surface_and_winding_at_footprint_edges() {
        let p = Projection { offset_and_scale: Vec4::new(0., 0., 0.05, 0.05), sin_and_cos: Vec2::new(0., 1.) };
        // y = 2*x + 3*z + 7 on an actual triangle spanning all four UV edges.
        let point = |x, z| Vec3::new(x, 2.*x + 3.*z + 7., z);
        let input = [point(-2., -2.), point(5., -2.), point(-2., 5.)];
        let expected_normal = (input[1]-input[0]).cross(input[2]-input[0]);
        let output = clip_triangle(p, input);
        assert_eq!(output.len(), 2);
        let area: f32 = output.iter().map(|t| {
            assert!((t[1].world-t[0].world).cross(t[2].world-t[0].world).dot(expected_normal) > 0.);
            for v in t {
                assert!((v.world.y - (2.*v.world.x + 3.*v.world.z + 7.)).abs() < 1e-5);
                assert!(v.uv.cmpge(Vec2::splat(-1e-6)).all() && v.uv.cmple(Vec2::splat(1.000001)).all());
                assert!((p.uv(v.world) - v.uv).length() < 1e-6);
            }
            (t[1].uv-t[0].uv).perp_dot(t[2].uv-t[0].uv).abs()*0.5
        }).sum();
        assert!((area - 1.).abs() < 1e-6);
    }
    #[test]
    fn invalid_constants_nonfinite_vertices_outside_and_vertical_degenerate_surfaces_are_rejected() {
        let p = unrotated();
        let triangle = [Vec3::ZERO, Vec3::X, Vec3::Z];
        assert!(clip_triangle(p, triangle).is_empty());
        for value in [0., f32::NAN, f32::INFINITY] {
            let invalid = Projection { offset_and_scale: Vec4::new(0.,0.,value,1.), ..p };
            assert!(clip_triangle(invalid, triangle).is_empty());
        }
        assert!(clip_triangle(Projection { sin_and_cos: Vec2::ZERO, ..p }, triangle).is_empty());
        assert!(clip_triangle(p, [Vec3::splat(f32::NAN); 3]).is_empty());
        let v = Vec3::new(5., 0., 10.);
        assert!(clip_triangle(p, [v,v,v]).is_empty());
    }
}
