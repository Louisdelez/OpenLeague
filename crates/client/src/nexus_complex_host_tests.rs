use super::*;
use crate::{nexus_idle_particles::{Request, Descriptor, CycleId}, nexus_complex_live};
use bevy::{asset::RenderAssetUsages, render::render_resource::{Extent3d, TextureDimension,TextureFormat}};
fn request(world:&mut World,age:f64)->Request {
    let actor=world.spawn_empty().id();let bone=world.spawn_empty().id();
    Request {owner:Owner {session:7,actor,attachment_generation:1,effect_id:11},cycle:CycleId {session:7,source:20,serial:1},
        descriptor:Descriptor {slot:1,key:"IdleParticles1".into(),authored:"Order_Nexus.troy center".into(),
            resource:"Order_Nexus.troy".into(),bone:"center".into(),node:9,skin_index:8},bone,
        attachment_world:Mat4::from_scale(Vec3::splat(0.05)),started_at:1.,age_seconds:age,native_idle_resource_flag:0x10}
}
fn frame(r:&Request,ordinal:u64)->Frame {Frame {ordinal,session:Some(r.owner.session),requests:vec![r.clone()],retired:vec![],error:None}}
fn bindings(world:&mut World)->Bindings {
    let mut images=Assets::<Image>::default();let textures=crate::nexus_complex_material::Textures::fixture(&mut images);
    // Explicit tiny controlled lookup/FoW fixtures; no GPU or native-table claim.
    let mut make=||images.add(Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},
        TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let lookup=[make(),make()];let visibility=make();let overlay=make();
    world.insert_resource(images);world.init_resource::<Assets<Mesh>>();
    world.init_resource::<Assets<NexusMaterial>>();
    Bindings {textures,lookup,sparkle_lookup:None,visibility,overlay}
}
fn packets(r:&Request)->Vec<DrawPacket> {nexus_complex_live::profiles().unwrap().iter()
    .map(|p|nexus_complex_live::packet(p,r,15360.).unwrap()).flatten().collect()}
#[test]
fn private_draws_require_admission_then_retire_with_the_authoritative_set() {
    let mut world=World::new();let r=request(&mut world,1.);let b=bindings(&mut world);let mut host=Backend::new(1).unwrap();
    host.reconcile(&mut world,&frame(&r,1)).unwrap();
    let tickets=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();assert_eq!(tickets.len(),2);
    for t in &tickets {assert_eq!(world.get::<Visibility>(t.draw),Some(&Visibility::Hidden));
        host.admit_cpu_resources(&mut world,t).unwrap();assert_eq!(world.get::<Visibility>(t.draw),Some(&Visibility::Visible));}
    host.reconcile(&mut world,&Frame {ordinal:2,session:Some(7),..default()}).unwrap();
    assert_eq!(host.owner_count(),0);assert!(tickets.iter().all(|t|world.get_entity(t.draw).is_err()));
    assert_eq!(world.resource::<Assets<Mesh>>().len(),0);assert_eq!(world.resource::<Assets<NexusMaterial>>().len(),0);
    assert!(world.get_entity(r.owner.actor).is_ok());assert!(world.get_entity(r.bone).is_ok());
}
#[test]
fn malformed_packet_preserves_owned_hidden_previous_set_and_stale_ticket_cannot_enable_it() {
    let mut world=World::new();let r=request(&mut world,1.);let b=bindings(&mut world);let mut host=Backend::new(1).unwrap();
    host.reconcile(&mut world,&frame(&r,1)).unwrap();let old=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();
    host.reconcile(&mut world,&frame(&r,2)).unwrap();let mut bad=packets(&r);bad[1].material.shader_features=1;
    assert!(host.replace_frame(&mut world,r.owner,2,bad,&b).is_err());assert_eq!(host.owner_count(),1);
    assert_eq!(world.resource::<Assets<Mesh>>().len(),2);
    for t in &old {assert!(host.admit_cpu_resources(&mut world,t).is_err());assert_eq!(world.get::<Visibility>(t.draw),Some(&Visibility::Hidden));}
    host.clear(&mut world);assert_eq!(world.resource::<Assets<Mesh>>().len(),0);
}
#[test]
fn duplicate_group_rebind_and_session_transition_cannot_reuse_a_draw_ticket() {
    let mut world=World::new();let mut r=request(&mut world,1.);let b=bindings(&mut world);let mut host=Backend::new(1).unwrap();
    host.reconcile(&mut world,&frame(&r,1)).unwrap();let mut bad=packets(&r);bad[1]=bad[0].clone();
    assert!(host.replace_frame(&mut world,r.owner,1,bad,&b).is_err());assert_eq!(host.owner_count(),0);
    let old=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();r.owner.attachment_generation=2;
    host.reconcile(&mut world,&frame(&r,2)).unwrap();assert_eq!(host.owner_count(),0);
    assert!(host.admit_cpu_resources(&mut world,&old[0]).is_err());
    host.replace_frame(&mut world,r.owner,2,packets(&r),&b).unwrap();
    host.reconcile(&mut world,&Frame {ordinal:3,session:Some(8),..default()}).unwrap();assert_eq!(host.owner_count(),0);
}
#[test]
fn source_despawn_and_changed_private_transform_fail_closed() {
    let mut world=World::new();let r=request(&mut world,1.);let b=bindings(&mut world);let mut host=Backend::new(1).unwrap();
    host.reconcile(&mut world,&frame(&r,1)).unwrap();let tickets=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();
    world.get_mut::<Transform>(tickets[0].draw).unwrap().translation.x=1.;
    assert!(host.admit_cpu_resources(&mut world,&tickets[0]).is_err());
    world.despawn(r.owner.actor);assert!(host.reconcile(&mut world,&frame(&r,2)).is_err());assert_eq!(host.owner_count(),0);
}

#[test]
fn continuing_draw_ids_survive_real_asset_event_publication_on_the_next_frame() {
    use bevy::{asset::{AssetApp, AssetEvent, AssetEventSystems, AssetPlugin}, ecs::message::MessageCursor};
    #[derive(Resource)] struct Input { request:Request, bindings:Bindings, ordinal:u64 }
    fn publish(world:&mut World) {
        let input=world.resource::<Input>();
        let (r,b,ordinal)=(input.request.clone(),input.bindings.clone(),input.ordinal);
        let mut backend=world.remove_resource::<Backend>().unwrap();
        backend.reconcile(world,&frame(&r,ordinal)).unwrap();
        let tickets=backend.replace_frame(world,r.owner,ordinal,packets(&r),&b).unwrap();
        for t in &tickets { backend.admit_cpu_resources(world,t).unwrap(); }
        world.insert_resource(backend);
    }
    // The real AssetPlugin flushes Added/Modified in AssetEventSystems. No
    // renderer/device is installed: availability to extraction is the claim.
    let mut app=App::new();
    app.add_plugins((MinimalPlugins,AssetPlugin::default()))
        .init_asset::<Mesh>().init_asset::<NexusMaterial>()
        .add_systems(PostUpdate,publish.after(AssetEventSystems));
    let r=request(app.world_mut(),1.);let b=bindings(app.world_mut());
    app.insert_resource(Input {request:r.clone(),bindings:b,ordinal:1});
    app.insert_resource(Backend::new(1).unwrap());
    let mut mesh_events=MessageCursor::<AssetEvent<Mesh>>::default();
    let mut material_events=MessageCursor::<AssetEvent<NexusMaterial>>::default();
    app.update();
    let old=app.world().resource::<Backend>().tickets();assert_eq!(old.len(),2);
    assert_eq!(mesh_events.read(app.world().resource::<Messages<AssetEvent<Mesh>>>()).count(),0);
    assert_eq!(material_events.read(app.world().resource::<Messages<AssetEvent<NexusMaterial>>>()).count(),0);
    for ordinal in [2,3] {
        { let mut input=app.world_mut().resource_mut::<Input>();
            input.ordinal=ordinal;input.request.attachment_world.w_axis.x=ordinal as f32; }
        app.update();
        let current=app.world().resource::<Backend>().tickets();
        let expected=packets(&app.world().resource::<Input>().request);
        for initial in &old {
            let live=current.iter().find(|t|t.group==initial.group).unwrap();
            assert_eq!((live.draw,live.mesh,live.material),(initial.draw,initial.mesh,initial.material));
            assert_eq!(live.ordinal,ordinal);
            let mesh=app.world().resource::<Assets<Mesh>>().get(live.mesh).unwrap();
            let packet=expected.iter().find(|p|p.group==live.group).unwrap();
            let bounds=Geometry::original().bake(packet.world).unwrap().compute_aabb().unwrap();
            assert_eq!(mesh.compute_aabb(),Some(bounds));
            assert_eq!(app.world().get::<bevy::camera::primitives::Aabb>(live.draw),Some(&bounds));
            assert!(app.world().resource::<Assets<NexusMaterial>>().get(live.material).unwrap().is_ready());
        }
        let meshes:Vec<_>=mesh_events.read(app.world().resource::<Messages<AssetEvent<Mesh>>>()).copied().collect();
        let materials:Vec<_>=material_events.read(app.world().resource::<Messages<AssetEvent<NexusMaterial>>>()).copied().collect();
        for initial in &old {
            assert!(meshes.iter().any(|e|matches!(e,AssetEvent::Added{id}|AssetEvent::Modified{id} if *id==initial.mesh)));
            assert!(materials.iter().any(|e|matches!(e,AssetEvent::Added{id}|AssetEvent::Modified{id} if *id==initial.material)));
            assert!(app.world().resource::<Assets<Mesh>>().get(initial.mesh).is_some());
        }
        assert!(!meshes.iter().any(|e|matches!(e,AssetEvent::Removed{..}|AssetEvent::Unused{..})));
        assert!(!materials.iter().any(|e|matches!(e,AssetEvent::Removed{..}|AssetEvent::Unused{..})));
    }
}

#[test]
fn retained_draw_validation_precedes_updates_and_group_expiry_retires_only_that_group() {
    let mut world=World::new();let r=request(&mut world,1.);let b=bindings(&mut world);let mut host=Backend::new(1).unwrap();
    host.reconcile(&mut world,&frame(&r,1)).unwrap();let old=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();
    let gem=old.iter().find(|t|t.group==Group::Gem).unwrap();
    let inside=old.iter().find(|t|t.group==Group::GemInside).unwrap();
    let previous=world.resource::<Assets<Mesh>>().get(gem.mesh).unwrap().compute_aabb().unwrap();
    host.reconcile(&mut world,&frame(&r,2)).unwrap();
    *world.get_mut::<GlobalTransform>(inside.draw).unwrap()=GlobalTransform::from_translation(Vec3::X);
    let mut moved=r.clone();moved.attachment_world.w_axis.x=20.;
    assert!(host.replace_frame(&mut world,r.owner,2,packets(&moved),&b).is_err());
    assert_eq!(world.resource::<Assets<Mesh>>().get(gem.mesh).unwrap().compute_aabb().unwrap(),previous);
    assert_eq!(host.tickets(),old);
    *world.get_mut::<GlobalTransform>(inside.draw).unwrap()=GlobalTransform::IDENTITY;
    let one=packets(&r).into_iter().filter(|p|p.group==Group::Gem).collect();
    let current=host.replace_frame(&mut world,r.owner,2,one,&b).unwrap();assert_eq!(current.len(),1);
    assert_eq!((current[0].draw,current[0].mesh,current[0].material),(gem.draw,gem.mesh,gem.material));
    assert!(host.admit_cpu_resources(&mut world,gem).is_err());
    assert!(world.get_entity(inside.draw).is_err());
    assert!(world.resource::<Assets<Mesh>>().get(inside.mesh).is_none());
    host.reconcile(&mut world,&frame(&r,3)).unwrap();
    assert!(host.replace_frame(&mut world,r.owner,3,vec![],&b).unwrap().is_empty());
    assert!(world.get_entity(gem.draw).is_err());
    assert_eq!(world.resource::<Assets<NexusMaterial>>().len(),0);
}

#[test]
fn sparkle_third_packet_is_atomic_distinct_and_retired_without_its_siblings() {
    use crate::nexus_complex_material::{self as material,TextureSet};
    let mut world=World::new();let mut r=request(&mut world,0.25);let mut b=bindings(&mut world);
    r.descriptor.resource="Order_Nexus_on.troy".into();
    {
        let mut images=world.resource_mut::<Assets<Image>>();b.textures=material::Textures::fixture_set(&mut images,TextureSet::On);
        b.sparkle_lookup=Some(b.lookup[0].clone()); // Controlled table fixture, not a production substitute.
    }
    let packets=|r:&Request| {
        let mut profiles=Vec::from(nexus_complex_live::on_profiles().unwrap());profiles.push(nexus_complex_live::sparkle_profile().unwrap());
        profiles.iter().map(|p|nexus_complex_live::packet(p,r,15360.).unwrap().unwrap()).collect::<Vec<_>>()
    };
    let mut host=Backend::new(1).unwrap();host.reconcile(&mut world,&frame(&r,1)).unwrap();
    let first=host.replace_frame(&mut world,r.owner,1,packets(&r),&b).unwrap();assert_eq!(first.len(),3);
    let sparkle=first.iter().find(|t|t.group==Group::GemSparkle).unwrap();
    assert_eq!(world.resource::<Assets<Mesh>>().get(sparkle.mesh).unwrap().count_vertices(),504);
    assert!(first.iter().filter(|t|t.group!=Group::GemSparkle).all(|t|world.resource::<Assets<Mesh>>().get(t.mesh).unwrap().count_vertices()==108));
    host.reconcile(&mut world,&frame(&r,2)).unwrap();let mut invalid=packets(&r);invalid[2].material.shader_features=1;
    assert!(host.replace_frame(&mut world,r.owner,2,invalid,&b).is_err());assert_eq!(host.tickets(),first);
    for t in &first {assert!(host.admit_cpu_resources(&mut world,t).is_err());assert_eq!(world.get::<Visibility>(t.draw),Some(&Visibility::Hidden));}
    let mut missing=b.clone();missing.sparkle_lookup=None;
    assert!(host.replace_frame(&mut world,r.owner,2,packets(&r),&missing).is_err());assert_eq!(host.tickets(),first);
    let mut two=packets(&r);two.pop();let next=host.replace_frame(&mut world,r.owner,2,two,&b).unwrap();assert_eq!(next.len(),2);
    assert!(world.get_entity(sparkle.draw).is_err());assert!(world.resource::<Assets<Mesh>>().get(sparkle.mesh).is_none());
    assert!(next.iter().all(|t|first.iter().any(|old|t.group==old.group&&t.draw==old.draw&&t.material==old.material&&t.mesh==old.mesh)));
    host.reconcile(&mut world,&Frame {ordinal:3,session:Some(7),..default()}).unwrap();
    assert_eq!(host.owner_count(),0);assert_eq!(world.resource::<Assets<Mesh>>().len(),0);assert_eq!(world.resource::<Assets<NexusMaterial>>().len(),0);
}
