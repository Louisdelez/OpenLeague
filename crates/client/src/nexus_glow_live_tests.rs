use super::*;
use bevy::{asset::{AssetApp,AssetPlugin,RenderAssetUsages},image::{ImageSampler,CompressedImageFormats,ImageType},
    render::render_resource::{Extent3d,TextureDimension,TextureFormat},mesh::VertexAttributeValues};
pub(crate) fn fixture()->App {
    let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<Image>()
        .init_asset::<Mesh>().init_asset::<GlowMaterial>().init_resource::<Backend>().init_resource::<Diagnostics>().init_resource::<crate::nexus_glow_simple::State>()
        .add_systems(PostUpdate,synchronize.after(AssetEventSystems));
    let world=app.world_mut();let sampler=ImageSamplerDescriptor::default();let mut images=world.resource_mut::<Assets<Image>>();
    let mut decode=|bytes:&[u8]|images.add(Image::from_buffer(bytes,ImageType::Extension("dds"),CompressedImageFormats::BC,
        false,ImageSampler::Descriptor(sampler.clone()),RenderAssetUsages::default()).unwrap());
    let texture=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/glows.dds"));
    let color=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/DefaultColorOverlifetime.dds"));
    let order=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/color-nexus-gem-glow.dds"));
    let chaos=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/color-turretcrystal.dds"));
    let overlay=images.add(Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
        vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let fog=crate::fow_gpu::Images::new(overlay.clone(),&mut images,1.);drop(images);
    world.insert_resource(Profile {births:[BirthProfile::load(Side::Order).unwrap(),BirthProfile::load(Side::Chaos).unwrap()],
        simple:[crate::nexus_glow_simple::Profile::load(Side::Order).unwrap(),crate::nexus_glow_simple::Profile::load(Side::Chaos).unwrap()],
        textures:Textures {image:texture.clone(),color,samplers:[sampler.clone(),sampler.clone()]},
        on_textures:[Textures{image:texture.clone(),color:order,samplers:[sampler.clone(),sampler.clone()]},
            Textures{image:texture,color:chaos,samplers:[sampler.clone(),sampler]}],overlay,armed:false,invalidated:false,events:default()});
    world.insert_resource(fog);world.insert_resource(crate::map10_vision_view::Map10VisionView::native_map10().unwrap());
    let mut clock=crate::native_effect_clock::EffectClock::default();clock.now=60.;world.insert_resource(clock);
    world.insert_resource(State::new(42));let mut camera=crate::camera_native::NativeCamera::default();
    camera.pose(Vec3::new(200.,0.,200.),0.,60.).unwrap();world.insert_resource(camera);
    let requests=crate::nexus_glow_state::tests::requests(world,60.);
    let mut host=Host::default();host.frame=Frame{ordinal:1,session:Some(7),requests,..default()};world.insert_resource(host);app
}
pub(crate) fn advance(app:&mut App,time:f64) {
    let world=app.world_mut();world.resource_mut::<crate::native_effect_clock::EffectClock>().now=time;
    let mut host=world.resource_mut::<Host>();host.frame.ordinal+=1;for r in &mut host.frame.requests {r.age_seconds=time;}
    app.update();
}
#[test]
fn actual_dds_profiles_camera_and_private_quad_entities_are_used_by_all_twelve_bones() {
    let mut app=fixture();app.update();let world=app.world();let d=world.resource::<Diagnostics>();
    assert_eq!(d.error,None);assert_eq!((d.emitters,d.particles,d.draws),(12,12,12));assert!(d.local_reconstruction);
    assert!(!d.native_complete&&!d.gpu_draw_qualified);
    let p=world.resource::<Profile>();
    for ticket in world.resource::<Backend>().tickets() {
        let mesh=world.resource::<Assets<Mesh>>().get(ticket.mesh).unwrap();assert_eq!(mesh.count_vertices(),4);
        assert_eq!(ticket.images[..2],[p.textures.image.id(),p.textures.color.id()]);
        assert!(world.resource::<Assets<GlowMaterial>>().get(ticket.material).unwrap().is_admitted());
        assert_eq!(world.get::<Transform>(ticket.draw),Some(&Transform::IDENTITY));assert!(world.get::<ChildOf>(ticket.draw).is_none());
        let VertexAttributeValues::Float32x2(uv)=mesh.attribute(Mesh::ATTRIBUTE_UV_0).unwrap() else {panic!()};
        assert_eq!(uv,&vec![[0.5,0.5],[1.,0.5],[1.,1.],[0.5,1.]]);
        // Default mode0 packets keep alpha1 even while lifetime RGB is zero.
        let VertexAttributeValues::Float32x4(color)=mesh.attribute(Mesh::ATTRIBUTE_COLOR).unwrap() else {panic!()};
        assert!(color.iter().all(|v|*v==[0.,0.,0.,1.]));
        assert!(world.get_entity(ticket.owner.actor).is_ok());
    }
}
#[test]
fn same_particle_updates_actual_camera_and_bound_position_without_double_world_transform() {
    let mut app=fixture();app.update();let first=app.world().resource::<Backend>().tickets();
    {let mut host=app.world_mut().resource_mut::<Host>();for r in &mut host.frame.requests {r.attachment_world.w_axis.x+=5.;}}
    advance(&mut app,60.1);let world=app.world();let now=world.resource::<Backend>().tickets();
    for old in &first {let new=now.iter().find(|v|v.particle==old.particle).unwrap();
        assert_eq!((old.draw,old.mesh,old.material),(new.draw,new.mesh,new.material));
        let mesh=world.resource::<Assets<Mesh>>().get(new.mesh).unwrap();let bounds=mesh.compute_aabb().unwrap();
        assert!((bounds.center.x-(new.particle.source as f32+5.)).abs()<1e-3);
    }
    assert_eq!(world.resource::<State>().slots[0].particles[0].birth.time,60.);
}
#[test]
fn fog_and_on_retire_private_draws_while_rebind_preserves_surviving_births() {
    let mut app=fixture();app.update();let first=app.world().resource::<Backend>().tickets();
    let requests=app.world().resource::<Host>().frame.requests.clone();
    app.world_mut().resource_mut::<Host>().frame.requests.clear();advance(&mut app,60.1);
    assert!(app.world().resource::<Backend>().tickets().is_empty());assert_eq!(app.world().resource::<State>().live_count(),12);
    assert!(first.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    {let mut host=app.world_mut().resource_mut::<Host>();host.frame.requests=requests;
        for r in &mut host.frame.requests {r.owner.attachment_generation+=1;}}
    advance(&mut app,60.2);let again=app.world().resource::<Backend>().tickets();assert_eq!(again.len(),12);
    for old in &first {let new=again.iter().find(|t|t.particle==old.particle).unwrap();assert_ne!(old.draw,new.draw);}
    {let mut host=app.world_mut().resource_mut::<Host>();for r in &mut host.frame.requests {
        r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}}
    advance(&mut app,75.);assert!(app.world().resource::<State>().slots.is_empty());
    let on=app.world().resource::<Backend>().tickets();assert_eq!(on.len(),12);
    assert!(on.iter().all(|t|!again.iter().any(|old|old.particle==t.particle)));
    assert_eq!(app.world().resource::<crate::nexus_glow_simple::State>().live_count(),12);
    assert_eq!(app.world().resource::<Diagnostics>().error,None);
}
#[test]
fn modified_source_image_retires_draws_even_on_replayed_frame_and_does_not_readmit() {
    let mut app=fixture();app.update();let first=app.world().resource::<Backend>().tickets();
    let image=app.world().resource::<Profile>().textures.image.clone();
    {let mut images=app.world_mut().resource_mut::<Assets<Image>>();let mut image=images.get_mut(&image).unwrap();image.texture_descriptor.label=None;}
    app.update();assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert!(app.world().resource::<Diagnostics>().error.is_some());assert!(first.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    advance(&mut app,60.5);assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert_eq!(app.world().resource::<State>().slots[0].emitted,1);
}
#[test]
fn later_invalid_bone_or_camera_cannot_publish_a_partial_batch_or_commit_rng() {
    let mut app=fixture();app.update();let before=app.world().resource::<State>().rng.clone();
    let bone=app.world().resource::<Host>().frame.requests.last().unwrap().bone;app.world_mut().despawn(bone);
    advance(&mut app,60.5);assert!(app.world().resource::<Diagnostics>().error.is_some());
    assert!(app.world().resource::<Backend>().tickets().is_empty());assert_eq!(app.world().resource::<State>().rng.words,before.words);
    let mut app=fixture();app.world_mut().remove_resource::<crate::camera_native::NativeCamera>();let before=app.world().resource::<State>().rng.clone();
    app.update();assert!(app.world().resource::<Diagnostics>().error.is_some());assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert_eq!(app.world().resource::<State>().rng.words,before.words);assert_eq!(app.world().resource::<State>().live_count(),0);
}

#[test]
fn startup_to_simple_on_uses_actual_authored_palettes_and_current_lookup_without_startup_replay(){
    let mut app=fixture();app.update();let startup=app.world().resource::<Backend>().tickets();
    {let mut host=app.world_mut().resource_mut::<Host>();for r in &mut host.frame.requests{
        r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}}
    advance(&mut app,75.);let on=app.world().resource::<Backend>().tickets();assert_eq!(on.len(),12);
    assert!(startup.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    advance(&mut app,75.1);let world=app.world();let profile=world.resource::<Profile>();
    for old in on {
        let t=world.resource::<Backend>().tickets().into_iter().find(|t|t.particle==old.particle).unwrap();
        assert_eq!((t.draw,t.mesh,t.material),(old.draw,old.mesh,old.material));
        let index=usize::from(t.particle.source==21);assert_eq!(t.images[1],profile.on_textures[index].color.id());
        let mesh=world.resource::<Assets<Mesh>>().get(t.mesh).unwrap();
        let VertexAttributeValues::Float32x2(lookup)=mesh.attribute(Mesh::ATTRIBUTE_UV_1).unwrap() else{panic!()};
        assert!(lookup.iter().all(|v|(v[0]-0.1).abs()<0.00002&&v[1]==if index==0{1.}else{0.2}));
        let VertexAttributeValues::Float32x4(color)=mesh.attribute(Mesh::ATTRIBUTE_COLOR).unwrap() else{panic!()};
        assert!(color.iter().all(|v|*v==[1.;4]));
    }
    assert!(!world.resource::<Diagnostics>().gpu_draw_qualified);
}
#[test]
fn simple_palette_reload_on_same_ordinal_retires_all_owned_draws_without_rebirth(){
    let mut app=fixture();{let mut host=app.world_mut().resource_mut::<Host>();for r in &mut host.frame.requests{
        r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}}
    app.update();let old=app.world().resource::<Backend>().tickets();assert_eq!(old.len(),12);
    let before=app.world().resource::<State>().rng.clone();let handle=app.world().resource::<Profile>().on_textures[0].color.clone();
    {let mut images=app.world_mut().resource_mut::<Assets<Image>>();let mut image=images.get_mut(&handle).unwrap();image.texture_descriptor.label=None;}
    app.update();assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert!(old.iter().all(|t|app.world().get_entity(t.draw).is_err()));assert!(app.world().resource::<Diagnostics>().error.is_some());
    advance(&mut app,60.5);assert!(app.world().resource::<Backend>().tickets().is_empty());
    let state=app.world().resource::<State>();assert_eq!(state.rng.words,before.words);
    assert!(app.world().resource::<crate::nexus_glow_simple::State>().slots.iter().all(|s|s.emitted==1));
}
