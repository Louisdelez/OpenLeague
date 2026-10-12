use super::*;
use bevy::{
    camera::{primitives::Aabb, RenderTarget},
    render::{camera::camera_system, texture::ManualTextureViews},
    window::{WindowCreated, WindowRef, WindowResized, WindowScaleFactorChanged},
};

fn close(a: f32, b: f32, tolerance: f32) {
    assert!((a-b).abs() <= tolerance, "{a} != {b} (tolerance {tolerance})");
}

fn camera_app() -> App {
    let mut app = App::new();
    app.init_resource::<Assets<Image>>()
        .init_resource::<ManualTextureViews>()
        .add_message::<WindowResized>()
        .add_message::<WindowCreated>()
        .add_message::<WindowScaleFactorChanged>()
        .add_message::<AssetEvent<Image>>()
        .add_systems(PostUpdate, camera_system);
    app
}

fn spawn_camera(app: &mut App, size: UVec2, transform: Transform, sub: Option<SubCameraView>) -> Entity {
    app.world_mut().spawn((
        Camera3d::default(),
        Camera { invert_culling: true, sub_camera_view: sub, ..default() },
        RenderTarget::None { size },
        projection(50_f32.to_radians(), 2.5, 250.),
        transform,
        GlobalTransform::from(transform),
    )).id()
}

fn check_ray(camera: &Camera, transform: &GlobalTransform, point: Vec3) {
    let pixel = camera.world_to_viewport(transform, point).unwrap();
    let ray = camera.viewport_to_world(transform, pixel).unwrap();
    let distance = (point-ray.origin).dot(*ray.direction);
    assert!(distance > 0.);
    assert!((ray.get_point(distance)-point).length() < 0.002);
    // The caller's native-units conversion must not mirror the cursor a second time.
    let native = ray.origin*20. + *ray.direction*(distance*20.);
    assert!((native-point*20.).length() < 0.04);
}

#[test]
fn recorded_native_prepare_xy_matches_reflected_bevy_projection() {
    let contract: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/camera_prepare_contract.json"
    )).unwrap();
    assert_eq!(contract["native_sha256"].as_str().unwrap(),
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    assert_eq!(contract["passed"].as_bool(), Some(true));
    for index in [0, 2, 32, 34] {
        let c = &contract["cases"][index];
        assert_eq!(c["mode"].as_u64(), Some(0));
        assert_eq!(c["used_fallback"].as_bool(), Some(false));
        let vector = |name: &str| Vec3::from_array(std::array::from_fn(|i|
            c[name][i].as_f64().unwrap() as f32));
        assert_eq!(vector("position"), Vec3::ZERO);
        let forward = vector("direction").normalize();
        let right = vector("up").cross(forward).normalize();
        let up = forward.cross(right);
        let bits: [f32; 16] = std::array::from_fn(|i|
            f32::from_bits(c["product_bits"][i].as_u64().unwrap() as u32));
        // The original row-vector matrix's bytes are the transposed column-vector matrix.
        let native = Mat4::from_cols_array(&bits);
        let aspect = f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32);
        let mut bridged = projection(103_f32.to_radians(), 1./20., 2./20.);
        bridged.update(aspect, 1.);
        let view = Transform::IDENTITY.looking_to(forward, vector("up"));
        let product = bridged.get_clip_from_view()*view.to_matrix().inverse();
        for (x,y) in [(-0.2,-0.1), (0.,0.), (0.3,0.15)] {
            let point = forward*1.5+right*x+up*y;
            let expected = native.project_point3(point);
            let observed = product.project_point3(point/20.);
            // Native RSQRT normalization is approximate; depth intentionally differs.
            close(observed.x, expected.x, 0.0002);
            close(observed.y, expected.y, 0.0002);
        }
    }
}

#[test]
fn native_normal_pose_projects_world_positive_x_to_screen_right() {
    let mut native = crate::camera_native::NativeCamera::default();
    let (transform, projection, focus) = native.pose(Vec3::new(200., 0., 350.), 0.016, 0.).unwrap();
    let mut app = camera_app();
    let entity = spawn_camera(&mut app, UVec2::new(1280, 800), transform, None);
    app.world_mut().entity_mut(entity).insert(projection);
    app.update();
    let camera = app.world().get::<Camera>(entity).unwrap();
    let global = app.world().get::<GlobalTransform>(entity).unwrap();
    let left = camera.world_to_viewport(global, focus-Vec3::X*10.).unwrap();
    let middle = camera.world_to_viewport(global, focus).unwrap();
    let right = camera.world_to_viewport(global, focus+Vec3::X*10.).unwrap();
    assert!(left.x < middle.x && middle.x < right.x);
    close(left.y, right.y, 0.001);
    for point in [focus, focus+Vec3::X*10., focus+Vec3::Z*8.] {
        check_ray(camera, global, point);
    }
}

#[test]
fn real_camera_system_resizes_and_keeps_picking_round_trips() {
    let mut app = camera_app();
    let window = app.world_mut().spawn(Window { resolution: (1280,800).into(), ..default() }).id();
    let transform = Transform::from_xyz(4.,6.,-8.).looking_at(Vec3::ZERO, Vec3::Y);
    let entity = spawn_camera(&mut app, UVec2::new(1280,800), transform, None);
    app.world_mut().entity_mut(entity).insert(RenderTarget::Window(WindowRef::Entity(window)));
    for (w,h) in [(1280,800), (700,1200), (1920,1080)] {
        app.world_mut().get_mut::<Window>(window).unwrap().resolution.set_physical_resolution(w,h);
        app.world_mut().write_message(WindowResized { window, width:w as f32, height:h as f32 });
        app.update();
        let current = app.world().get::<Projection>(entity).unwrap();
        close(perspective(current).unwrap().aspect_ratio, w as f32/h as f32, 0.000001);
        let camera = app.world().get::<Camera>(entity).unwrap();
        assert_eq!(camera.physical_viewport_size(), Some(UVec2::new(w,h)));
        let global = app.world().get::<GlobalTransform>(entity).unwrap();
        for point in [Vec3::ZERO, Vec3::X, Vec3::new(-1.,0.,1.)] {
            check_ray(camera, global, point);
        }
    }
}

#[test]
fn native_parameter_refresh_preserves_aspect_and_reverse_depth() {
    let mut current = Projection::Perspective(PerspectiveProjection { aspect_ratio: 2., ..default() });
    let mut camera = Camera::default();
    for (fov,near,far) in [(50_f32,2.5,250.), (73.,1.25,400.)] {
        let native = projection(fov.to_radians(),near,far);
        synchronize(&mut camera, &mut current, &native).unwrap();
        let inner = perspective(&current).unwrap();
        assert_eq!((inner.fov,inner.near,inner.far,inner.aspect_ratio), (fov.to_radians(),near,far,2.));
        assert_eq!(inner.near_clip_plane, Vec4::new(0.,0.,-1.,-near));
        assert!(camera.invert_culling && current.is_perspective());
        assert_eq!(current.far(),far);
        let matrix = current.get_clip_from_view();
        close(matrix.project_point3(Vec3::new(0.,0.,-near)).z,1.,0.000001);
        close(matrix.project_point3(Vec3::new(0.,0.,-far)).z,near/far,0.000001);
        let base = inner.get_clip_from_view();
        for point in [Vec3::new(1.,2.,-10.),Vec3::new(-2.,1.,-20.)] {
            let a=matrix.project_point3(point); let b=base.project_point3(point);
            close(a.x,-b.x,0.000001);close(a.y,b.y,0.000001);close(a.z,b.z,0.000001);
        }
    }
}

#[test]
fn asymmetric_subviews_crop_the_reflected_full_image_and_preserve_rays() {
    let mut app = camera_app();
    let transform = Transform::IDENTITY.looking_to(Vec3::Z,Vec3::Y);
    let full_size=UVec2::new(1600,900);
    let full=spawn_camera(&mut app,full_size,transform,None);
    let sub=spawn_camera(&mut app,UVec2::new(700,600),transform,None);
    app.update();
    for offset in [Vec2::new(73.,111.),Vec2::new(800.25,137.5)] {
        let descriptor=SubCameraView {full_size,offset,size:UVec2::new(700,600)};
        app.world_mut().get_mut::<Camera>(sub).unwrap().sub_camera_view=Some(descriptor);
        app.update();
        let full_camera=app.world().get::<Camera>(full).unwrap();
        let sub_camera=app.world().get::<Camera>(sub).unwrap();
        let global=app.world().get::<GlobalTransform>(sub).unwrap();
        // A world point under the tile centre, generated through the full camera's real ray.
        let ray=full_camera.viewport_to_world(global,offset+descriptor.size.as_vec2()*0.5).unwrap();
        let point=ray.get_point(20.);
        let full_pixel=full_camera.world_to_viewport(global,point).unwrap();
        let sub_pixel=sub_camera.world_to_viewport(global,point).unwrap();
        assert!((sub_pixel-(full_pixel-offset)).length()<0.003);
        check_ray(sub_camera,global,point);
    }
}

#[test]
fn frustum_corner_screen_order_and_finite_far_culling_are_preserved() {
    let mut p=projection(50_f32.to_radians(),2.5,250.);p.update(1600.,900.);
    let matrix=p.get_clip_from_view();
    let expected=[Vec2::new(1.,-1.),Vec2::new(1.,1.),Vec2::new(-1.,1.),Vec2::new(-1.,-1.)];
    for (index,corner) in p.get_frustum_corners(-2.5,-250.).iter().enumerate() {
        let ndc=matrix.project_point3(Vec3::from(*corner));
        assert!((ndc.truncate()-expected[index%4]).length()<0.00001);
    }
    let global=GlobalTransform::IDENTITY;
    let reflected=p.compute_frustum(&global);
    let ordinary=perspective(&p).unwrap().compute_frustum(&global);
    for center in [Vec3::new(0.,0.,-10.),Vec3::new(500.,0.,-10.),Vec3::new(0.,0.,2.),Vec3::new(0.,0.,-300.)] {
        let aabb=Aabb {center:Vec3A::from(center),half_extents:Vec3A::splat(0.01)};
        assert_eq!(reflected.contains_aabb_identity(&aabb),ordinary.contains_aabb_identity(&aabb));
        assert_eq!(reflected.contains_aabb_identity(&aabb),center==Vec3::new(0.,0.,-10.));
    }
}

#[test]
fn clip_reflection_reverses_winding_and_camera_requests_matching_culling() {
    let native=projection(50_f32.to_radians(),2.5,250.);
    let mut current=Projection::default();let mut camera=Camera::default();
    synchronize(&mut camera,&mut current,&native).unwrap();
    let triangle=[Vec3::new(-1.,-1.,-10.),Vec3::new(1.,-1.,-10.),Vec3::new(0.,1.,-10.)];
    let area=|matrix:Mat4| {let p=triangle.map(|v|matrix.project_point3(v).truncate());(p[1]-p[0]).perp_dot(p[2]-p[0])};
    let before=area(perspective(&native).unwrap().get_clip_from_view());
    let after=area(current.get_clip_from_view());
    assert!(before>0. && after<0.);close(before,-after,0.000001);
    assert!(camera.invert_culling);
}

#[test]
fn unrelated_projection_is_rejected_without_mutating_camera_or_matrix() {
    let native=projection(50_f32.to_radians(),2.5,250.);
    let mut current=Projection::custom(PerspectiveProjection::default());
    let before=current.get_clip_from_view();let mut camera=Camera::default();
    assert_eq!(synchronize(&mut camera,&mut current,&native),Err("unrelated custom camera projection"));
    assert_eq!(current.get_clip_from_view(),before);assert!(!camera.invert_culling);
    let wrong_source=Projection::default();
    assert_eq!(synchronize(&mut camera,&mut current,&wrong_source),Err("source is not a native perspective"));
}
