//! Native LH screen axes over Bevy's RH view and reverse-depth projection.
//! Only clip X is reflected. The camera position/direction and world basis stay direct.
use bevy::{camera::{CameraProjection, SubCameraView}, math::Vec3A, prelude::*};

#[derive(Clone, Debug)]
struct NativePerspective {
    inner: PerspectiveProjection,
}

fn screen_reflection() -> Mat4 {
    Mat4::from_scale(Vec3::new(-1., 1., 1.))
}

pub fn projection(fov: f32, near: f32, far: f32) -> Projection {
    Projection::custom(NativePerspective {
        inner: PerspectiveProjection {
            fov,
            near,
            far,
            near_clip_plane: Vec4::new(0., 0., -1., -near),
            ..default()
        },
    })
}

pub fn perspective(projection: &Projection) -> Option<&PerspectiveProjection> {
    match projection {
        Projection::Custom(custom) => custom.get::<NativePerspective>().map(|p| &p.inner),
        _ => None,
    }
}

/// Refresh native parameters without resetting the aspect maintained by camera_system.
/// Accept an ordinary perspective at initial attachment; reject unrelated custom cameras.
pub fn synchronize(
    camera: &mut Camera,
    current: &mut Projection,
    native: &Projection,
) -> Result<(), &'static str> {
    let source = perspective(native).ok_or("source is not a native perspective")?;
    match current {
        Projection::Perspective(p) => {
            let mut next = source.clone();
            next.aspect_ratio = p.aspect_ratio;
            *current = Projection::custom(NativePerspective { inner: next });
        }
        Projection::Custom(custom) => {
            let destination = &mut custom.get_mut::<NativePerspective>()
                .ok_or("unrelated custom camera projection")?.inner;
            let aspect = destination.aspect_ratio;
            *destination = source.clone();
            destination.aspect_ratio = aspect;
        }
        _ => return Err("native camera requires perspective projection"),
    }
    // Clip reflection reverses winding. Bevy's PBR view key switches Front/Back;
    // materials with culling disabled remain unchanged.
    camera.invert_culling = true;
    Ok(())
}

impl CameraProjection for NativePerspective {
    fn get_clip_from_view(&self) -> Mat4 {
        screen_reflection() * self.inner.get_clip_from_view()
    }

    fn get_clip_from_view_for_sub(&self, sub_view: &SubCameraView) -> Mat4 {
        // Crop the reflected FULL image: reflecting only the local tile would
        // select the opposite part of the scene for an asymmetric sub-view.
        let mut mirrored = *sub_view;
        mirrored.offset.x = sub_view.full_size.x as f32
            - sub_view.offset.x - sub_view.size.x as f32;
        screen_reflection() * self.inner.get_clip_from_view_for_sub(&mirrored)
    }

    fn update(&mut self, width: f32, height: f32) {
        self.inner.update(width, height);
    }

    fn far(&self) -> f32 {
        self.inner.far()
    }

    fn get_frustum_corners(&self, z_near: f32, z_far: f32) -> [Vec3A; 8] {
        // Keep the trait's screen order (BR, TR, TL, BL), including cascades.
        self.inner.get_frustum_corners(z_near, z_far).map(|p| Vec3A::new(-p.x, p.y, p.z))
    }
}

#[cfg(test)]
#[path = "camera_projection_bridge_tests.rs"]
mod tests;
