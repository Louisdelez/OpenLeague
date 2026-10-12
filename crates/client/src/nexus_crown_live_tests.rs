use super::*;
use crate::nexus_idle_particles::{Request,Descriptor,CycleId};
use bevy::{asset::{AssetApp,AssetPlugin,AssetEventSystems},image::{CompressedImageFormats,ImageType}};
fn fixture()->App {
    let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<Image>()
        .init_asset::<Mesh>().init_asset::<NexusMaterial>().init_resource::<Backend>().init_resource::<Diagnostics>()
        .add_systems(PostUpdate,synchronize.after(AssetEventSystems));
    let world=app.world_mut();let colors=lifetime_colors().unwrap();let sampler=ImageSamplerDescriptor::default();
    let mut images=world.resource_mut::<Assets<Image>>();
    let texture=images.add(Image::from_buffer(include_bytes!("../../../assets/particles/nexus_crown_linear/cylinder06.dds"),
        ImageType::Extension("dds"),CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler.clone()),RenderAssetUsages::default()).unwrap());
    let lookup=[images.add(lookup_image(&colors[0])),images.add(lookup_image(&colors[1]))];
    // Controlled FoW fixture only. No RenderApp, GPU visibility or pixel claim.
    let overlay=images.add(Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
        vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let fog=crate::fow_gpu::Images::new(overlay.clone(),&mut images,1.);drop(images);
    world.insert_resource(Profile {births:vec![BirthProfile::load(Side::Order).unwrap(),BirthProfile::load(Side::Chaos).unwrap()],
        colors:colors.to_vec(),geometry:Geometry::crown(),texture,lookup:lookup.to_vec(),overlay,sampler,armed:false,invalidated:false,events:default()});
    world.insert_resource(fog);world.insert_resource(crate::map10_vision_view::Map10VisionView::native_map10().unwrap());
    world.insert_resource(crate::native_effect_clock::EffectClock::default());world.insert_resource(State::new(42));
    let mut requests=Vec::new();
    for (source,name) in [(20,"Order"),(21,"Chaos")] {
        let actor=world.spawn_empty().id();
        for slot in 8..=11 {let bone=world.spawn_empty().id();
            requests.push(Request {owner:Owner {session:7,actor,attachment_generation:1,effect_id:u64::from(source)*100+u64::from(slot)},
                cycle:CycleId {session:7,source,serial:u64::from(source)},descriptor:Descriptor {slot,key:format!("IdleParticles{slot}"),
                    authored:format!("{name}_Nexus_Base_Glow.troy base{}",slot-5),resource:format!("{name}_Nexus_Base_Glow_on.troy"),
                    bone:format!("base{}",slot-5),node:usize::from(slot)+10,skin_index:usize::from(slot)+9},bone,
                attachment_world:Mat4::from_scale_rotation_translation(Vec3::splat(0.05),Quat::IDENTITY,Vec3::new(source as f32,2.,3.)),
                started_at:0.,age_seconds:0.,native_idle_resource_flag:0x10});}
    }
    let mut host=Host::default();host.frame=Frame{ordinal:1,session:Some(7),requests,..default()};world.insert_resource(host);app
}
fn advance(app:&mut App,time:f64) {
    let world=app.world_mut();world.resource_mut::<crate::native_effect_clock::EffectClock>().now=time;
    let mut h=world.resource_mut::<Host>();h.frame.ordinal+=1;for r in &mut h.frame.requests {r.age_seconds=time;}
    app.update();
}
#[test]
fn actual_crown_geometry_colors_and_dds_are_used_by_both_nexus_profiles() {
    let mut app=fixture();app.update();let w=app.world();let d=w.resource::<Diagnostics>();
    assert_eq!(d.error,None);assert_eq!((d.emitters,d.particles,d.draws),(8,8,8));assert!(d.local_reconstruction);
    assert!(!d.native_complete);assert!(!d.gpu_draw_qualified);
    let p=w.resource::<Profile>();assert_eq!(p.geometry.corners.len(),480);
    assert_ne!(p.colors[0].table,p.colors[1].table);
    for ticket in w.resource::<Backend>().tickets() {
        assert_eq!(w.resource::<Assets<Mesh>>().get(ticket.mesh).unwrap().count_vertices(),480);
        assert_eq!(ticket.images[0],p.texture.id());
        assert_eq!(ticket.images[1],p.lookup[if ticket.particle.source==20{0}else{1}].id());
        assert!(w.resource::<Assets<NexusMaterial>>().get(ticket.material).unwrap().is_ready());
        assert_eq!(w.get::<Visibility>(ticket.draw),Some(&Visibility::Visible));
        assert!(w.get_entity(ticket.owner.actor).is_ok());
    }
    for time in [0.5,1.,1.5,2.] {advance(&mut app,time);}
    assert_eq!(app.world().resource::<Diagnostics>().draws,40);
    assert_eq!(app.world().resource::<State>().live_count(),40);
}
#[test]
fn real_asset_events_keep_draw_ids_between_frames_and_source_reload_retires_all() {
    let mut app=fixture();let mut events=MessageCursor::<AssetEvent<Mesh>>::default();app.update();
    let first=app.world().resource::<Backend>().tickets();
    assert_eq!(events.read(app.world().resource::<Messages<AssetEvent<Mesh>>>()).count(),0);
    advance(&mut app,0.1);
    let current=app.world().resource::<Backend>().tickets();assert_eq!(current.len(),8);
    for initial in &first {let now=current.iter().find(|t|t.particle==initial.particle).unwrap();
        assert_eq!((now.draw,now.mesh,now.material),(initial.draw,initial.mesh,initial.material));assert!(now.ordinal>initial.ordinal);}
    let delivered:Vec<_>=events.read(app.world().resource::<Messages<AssetEvent<Mesh>>>()).copied().collect();
    assert!(first.iter().all(|t|delivered.iter().any(|e|matches!(e,AssetEvent::Added{id}|AssetEvent::Modified{id} if *id==t.mesh))));
    let texture=app.world().resource::<Profile>().texture.clone();
    {let mut images=app.world_mut().resource_mut::<Assets<Image>>();let mut image=images.get_mut(&texture).unwrap();image.texture_descriptor.label=None;}
    advance(&mut app,0.2);
    assert!(app.world().resource::<Diagnostics>().error.is_some());assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert!(first.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    advance(&mut app,0.6);assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert_eq!(app.world().resource::<State>().slots[0].emitter.emitted,1);
}
#[test]
fn fog_retires_draws_not_particles_and_return_rebind_keeps_birth_ids_and_ages() {
    let mut app=fixture();app.update();let first=app.world().resource::<Backend>().tickets();
    let requests=app.world().resource::<Host>().frame.requests.clone();
    app.world_mut().resource_mut::<Host>().frame.requests.clear();advance(&mut app,0.2);
    assert_eq!(app.world().resource::<Diagnostics>().draws,0);assert_eq!(app.world().resource::<State>().live_count(),8);
    assert!(first.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    {let mut host=app.world_mut().resource_mut::<Host>();host.frame.requests=requests;
        for r in &mut host.frame.requests{r.owner.attachment_generation+=1;}}
    advance(&mut app,0.3);let again=app.world().resource::<Backend>().tickets();assert_eq!(again.len(),8);
    for old in &first {let new=again.iter().find(|t|t.particle==old.particle).unwrap();assert_ne!(old.draw,new.draw);assert_ne!(old.owner,new.owner);}
    assert!(app.world().resource::<State>().slots.iter().all(|s|s.emitter.emitted==1 && s.age>=0.3));
    app.world_mut().resource_mut::<Host>().frame.requests.clear();advance(&mut app,2.1);
    assert_eq!(app.world().resource::<State>().live_count(),0);assert_eq!(app.world().resource::<Diagnostics>().draws,0);
}
#[test]
fn bad_later_attachment_cannot_publish_partial_particles_or_advance_the_rng() {
    let mut app=fixture();app.update();let first=app.world().resource::<Backend>().tickets();
    let before=app.world().resource::<State>().rng.clone();
    app.world_mut().resource_mut::<Host>().frame.requests.last_mut().unwrap().attachment_world.x_axis.x=f32::NAN;
    advance(&mut app,0.5);let w=app.world();assert!(w.resource::<Diagnostics>().error.is_some());
    assert_eq!(w.resource::<State>().rng.words,before.words);assert_eq!(w.resource::<State>().rng.first,before.first);
    assert!(w.resource::<Backend>().tickets().is_empty());assert!(first.iter().all(|t|w.get_entity(t.draw).is_err()));
}

fn startup_fixture()->App {
    let mut app=fixture();let world=app.world_mut();let mut profile=world.remove_resource::<Profile>().unwrap();
    let colors=lifetime_colors_for(Phase::Startup).unwrap();
    for color in &colors {profile.lookup.push(world.resource_mut::<Assets<Image>>().add(lookup_image(color)));}
    profile.colors.extend(colors);profile.births.extend([BirthProfile::load_startup(Side::Order).unwrap(),BirthProfile::load_startup(Side::Chaos).unwrap()]);
    world.insert_resource(profile);
    for r in &mut world.resource_mut::<Host>().frame.requests {r.descriptor.resource=r.descriptor.resource.replace("_on.troy",".troy");}
    app
}
#[test]
fn startup_cpu_draws_keep_alpha_zero_packets_batch_ids_and_retire_into_on() {
    let mut app=startup_fixture();app.update();
    let first=app.world().resource::<Backend>().tickets();assert_eq!(first.len(),8);
    let state=app.world().resource::<State>();
    assert!(state.slots.iter().all(|s|s.phase==Phase::Startup && s.particles[0].birth.color[3]==0.));
    // ONE/ONE RGB does not multiply by result alpha: alpha0 is no visibility gate.
    advance(&mut app,0.5);let before=app.world().resource::<Backend>().tickets();assert_eq!(before.len(),20);
    let ids:std::collections::HashSet<_>=before.iter().map(|t|t.particle).collect();assert_eq!(ids.len(),20);
    for old in &first {let current=before.iter().find(|t|t.particle==old.particle).unwrap();assert_eq!((current.draw,current.mesh,current.material),(old.draw,old.mesh,old.material));}
    for ticket in &before {
        let phase_index=profile_index(if ticket.particle.source==20 {Side::Order}else{Side::Chaos},Phase::Startup);
        assert_eq!(ticket.images[1],app.world().resource::<Profile>().lookup[phase_index].id());
    }
    {let world=app.world_mut();world.resource_mut::<crate::native_effect_clock::EffectClock>().now=75.;
        let mut h=world.resource_mut::<Host>();h.frame.ordinal+=1;
        for r in &mut h.frame.requests {r.cycle.serial+=100;r.age_seconds=0.;r.started_at=75.;r.owner.effect_id+=1000;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}}
    app.update();let world=app.world();let after=world.resource::<Backend>().tickets();assert_eq!(after.len(),8);
    assert_eq!(world.resource::<Diagnostics>().error,None);assert!(!world.resource::<Diagnostics>().native_complete);
    assert!(before.iter().all(|t|world.get_entity(t.draw).is_err()));
    assert!(after.iter().all(|t|!ids.contains(&t.particle)));
}
#[test]
fn startup_lookup_reload_retires_both_sources_without_reauthorizing_or_rng_consumption() {
    let mut app=startup_fixture();app.update();let before=app.world().resource::<Backend>().tickets();
    let rng=app.world().resource::<State>().rng.clone();let lookup=app.world().resource::<Profile>().lookup[2].clone();
    {let mut images=app.world_mut().resource_mut::<Assets<Image>>();let mut image=images.get_mut(&lookup).unwrap();image.texture_descriptor.label=None;}
    advance(&mut app,0.5);assert!(app.world().resource::<Diagnostics>().error.is_some());
    assert!(app.world().resource::<Backend>().tickets().is_empty());
    assert!(before.iter().all(|t|app.world().get_entity(t.draw).is_err()));
    advance(&mut app,1.);assert!(app.world().resource::<Backend>().tickets().is_empty());
    let after=&app.world().resource::<State>().rng;assert_eq!(after.words,rng.words);assert_eq!((after.first,after.second),(rng.first,rng.second));
}
