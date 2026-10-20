use super::*;
use openleague_core::Point;
#[derive(Resource)]
struct Input {frame:Frame,samples:Vec<CurrentE>,base_model:bool}
fn host(mut commands:Commands,mut live:ResMut<Live>,mut sc:ResMut<simple_draw::Current>,mut cc:ResMut<complex_draw::Current>,
    mut meshes:ResMut<Assets<Mesh>>,mut simple:ResMut<Assets<SimpleMaterial>>,mut complex:ResMut<Assets<ComplexMaterial>>,
    images:Res<Assets<Image>>,profile:Res<Profile>,input:Res<Input>,owned:OwnedQuery){
    let result=profile.images.validate(&images).and_then(|_|synchronize(&mut commands,&mut live,&mut sc,&mut cc,
        &mut meshes,&mut simple,&mut complex,&profile,&input.frame,&input.samples,&owned,input.base_model));
    if let Err(error)=result{live.state.reject(&input.samples,input.frame.clock,
        (input.frame.frontier.source.session,input.frame.frontier.accepted_epoch));
        clear(&mut live,&mut sc,&mut cc,&mut commands,&mut meshes,&mut simple,&mut complex);live.last_error=Some(error);}
}
fn app()->App{
    let (snapshot,viewer,map,sources,_,_)=crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
    let mut app=App::new();let camera=app.world_mut().spawn_empty().id();
    let (image_profile,mut images)=ezreal_e_bolt_images::tests::fixture();let visibility=images.add(Image::default());
    app.insert_resource(Profile{simulation:Profiles::load().unwrap(),images:image_profile}).insert_resource(images)
        .insert_resource(Input{frame:Frame{frontier:simple_draw::Frontier{source:sources.mask_stamp(&map,snapshot.session,team).unwrap(),
            accepted_epoch:(1<<55)+7,camera},visibility,extent:map.geometry.extent,view:Mat4::IDENTITY.to_cols_array(),clock:1.,ready:true},
            samples:vec![CurrentE{key:crate::ezreal_e_bolt_presentation::Key{session:snapshot.session,owner:viewer,team,ordinal:(1<<60)+9},
                epoch:(1<<55)+7,incarnation:1,position:Point{x:7684.,z:6934.},y_native:149.5,direction:Point{x:1.,z:0.},
                sample_tick:snapshot.tick,sample_frame:9,authorization_frame:10}],base_model:true})
        .init_resource::<Live>().init_resource::<Assets<Mesh>>().init_resource::<Assets<SimpleMaterial>>()
        .init_resource::<Assets<ComplexMaterial>>().init_resource::<simple_draw::Current>().init_resource::<complex_draw::Current>()
        .add_systems(Update,host);app
}
fn grown()->App{let mut a=app();a.update();a.world_mut().resource_mut::<Input>().frame.clock=1.125;a.update();
    assert!(a.world().resource::<Live>().last_error.is_none(),"{:?}",a.world().resource::<Live>().last_error);a}
#[test]
fn three_original_groups_draw_without_any_visible_actor_and_keep_private_authority(){
    let mut app=grown();let world=app.world_mut();assert_eq!(world.query::<&crate::animation::Actor>().iter(world).count(),0);
    assert_eq!(world.resource::<Live>().rows.len(),3);assert_eq!(world.resource::<simple_draw::Current>().test_len(),2);
    assert_eq!(world.resource::<complex_draw::Current>().test_len(),1);
    for ((id,group),draw) in &world.resource::<Live>().rows{
        assert_eq!(id.key.ordinal,(1<<60)+9);assert!(world.resource::<Assets<Mesh>>().get(&draw.mesh).unwrap().count_vertices()>=4);
        match &draw.material{Material::Simple(_)=>assert!(*group==1||*group==2),Material::Complex(_)=>assert_eq!(*group,0)}
    }
}
#[test]
fn authorization_loss_retires_all_owned_geometry_but_keeps_foreign_entities(){
    let mut app=grown();let foreign=app.world_mut().spawn_empty().id();
    let old:Vec<_>=app.world().resource::<Live>().rows.values().map(|d|(d.entity,d.mesh.id())).collect();
    app.world_mut().resource_mut::<Input>().samples.clear();app.update();
    assert!(app.world().resource::<Live>().rows.is_empty());assert_eq!(app.world().resource::<simple_draw::Current>().test_len(),0);
    assert_eq!(app.world().resource::<complex_draw::Current>().test_len(),0);
    for (entity,mesh) in old{assert!(app.world().get_entity(entity).is_err());assert!(!app.world().resource::<Assets<Mesh>>().contains(mesh));}
    assert!(app.world().get_entity(foreign).is_ok());
}
#[test]
fn new_epoch_at_equal_clock_replaces_multi_particle_mesh_and_admission(){
    let mut app=grown();let sample=app.world().resource::<Input>().samples[0];let key=(Identity::from(&sample),1);
    let draw=&app.world().resource::<Live>().rows[&key];let (entity,mesh)=(draw.entity,draw.mesh.id());
    assert!(app.world().resource::<Assets<Mesh>>().get(mesh).unwrap().count_vertices()>4);
    {let mut i=app.world_mut().resource_mut::<Input>();i.samples[0].epoch+=1;i.frame.frontier.accepted_epoch+=1;}
    app.update();let sample=app.world().resource::<Input>().samples[0];let key=(Identity::from(&sample),1);
    let new=&app.world().resource::<Live>().rows[&key];assert_ne!(new.entity,entity);assert_ne!(new.mesh.id(),mesh);
    assert!(!app.world().resource::<Assets<Mesh>>().contains(mesh));
    let authority=app.world().resource::<simple_draw::Current>().test_admission(new.entity).unwrap();
    assert_eq!(authority.frontier.accepted_epoch,sample.epoch);
}
#[test]
fn camera_change_replaces_gpu_mesh_without_advancing_frozen_simulation(){
    let mut app=grown();let key=*app.world().resource::<Live>().rows.keys().find(|k|k.1==1).unwrap();
    let old=&app.world().resource::<Live>().rows[&key];let mesh=old.mesh.id();let entity=old.entity;
    let random=app.world().resource::<Live>().state.rows[&key.0].rng.words;
    let camera=app.world_mut().spawn_empty().id();
    {let mut input=app.world_mut().resource_mut::<Input>();input.frame.frontier.camera=camera;
        input.frame.view=Mat4::from_rotation_y(0.25).to_cols_array();}
    app.update();let new=&app.world().resource::<Live>().rows[&key];assert_eq!(new.entity,entity);assert_ne!(new.mesh.id(),mesh);
    assert_eq!(app.world().resource::<Live>().state.rows[&key.0].rng.words,random);
    assert_eq!(app.world().resource::<simple_draw::Current>().test_admission(entity).unwrap().frontier.camera,camera);
    assert!(!app.world().resource::<Assets<Mesh>>().contains(mesh));
}
#[test]
fn asset_pose_base_model_or_clock_failure_quarantines_the_same_incarnation(){
    for case in 0..4{let mut app=grown();let original=app.world().resource::<Input>().samples[0];
        match case{0=>{let h=app.world().resource::<Profile>().images.textures[1].image.clone();
            app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap().sampler=bevy::image::ImageSampler::Default;},
            1=>app.world_mut().resource_mut::<Input>().samples[0].y_native=f32::NAN,
            2=>app.world_mut().resource_mut::<Input>().base_model=false,
            _=>app.world_mut().resource_mut::<Input>().frame.clock=2.}
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());
        assert_eq!(app.world().resource::<simple_draw::Current>().test_len(),0);assert_eq!(app.world().resource::<complex_draw::Current>().test_len(),0);
        if case!=0{let mut i=app.world_mut().resource_mut::<Input>();i.samples[0]=original;i.base_model=true;drop(i);
            app.update();assert!(app.world().resource::<Live>().rows.is_empty());}
    }
}
#[test]
fn pause_and_resume_use_real_channel_baseline_and_never_replay_old_particles(){
    let mut app=app();let (mut snap,viewer,_,_,_,_)=crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team=snap.roster.iter().find(|p|p.id==viewer).unwrap().team;
    snap.roster.iter_mut().find(|p|p.id==viewer).unwrap().champion="ezreal".into();snap.players.clear();
    snap.ezreal_e_current_bolts=Some(serde_json::json!({"policy":openleague_core::ezreal_e_projectile_view::POLICY,
        "rows":[{"owner":viewer,"team":team,"ordinal":9,"x":7684,"z":6934,"y_native":149.5,"dx":1,"dz":0}]}));
    let epoch=app.world().resource::<Input>().frame.frontier.accepted_epoch;
    let context=openleague_core::session_transport::Context{session:snap.session,player:viewer,epoch};
    let mut channel=crate::ezreal_e_bolt_presentation::State::default();channel.reset_session(snap.session,viewer);channel.begin_epoch(Some(epoch));
    channel.observe_accepted_frame(&snap,viewer,1.,false,true,Some((context,1))).unwrap();snap.tick+=1;
    channel.observe_accepted_frame(&snap,viewer,1.01,false,true,Some((context,2))).unwrap();
    {let mut i=app.world_mut().resource_mut::<Input>();i.frame.clock=1.01;i.samples=channel.samples(&snap,viewer,snap.session,Some(epoch),1.01,false,true);}
    app.update();let old=app.world().resource::<Input>().samples[0];assert_eq!(app.world().resource::<Live>().rows.len(),3);
    channel.observe_accepted_frame(&snap,viewer,1.01,true,true,Some((context,3))).unwrap();
    app.world_mut().resource_mut::<Input>().samples=channel.samples(&snap,viewer,snap.session,Some(epoch),1.01,true,true);
    app.update();assert!(app.world().resource::<Live>().rows.is_empty());
    channel.observe_accepted_frame(&snap,viewer,1.01,false,true,Some((context,4))).unwrap();
    assert!(channel.samples(&snap,viewer,snap.session,Some(epoch),1.01,false,true).is_empty());snap.tick+=1;
    channel.observe_accepted_frame(&snap,viewer,1.02,false,true,Some((context,5))).unwrap();
    {let mut i=app.world_mut().resource_mut::<Input>();i.frame.clock=1.02;i.samples=channel.samples(&snap,viewer,snap.session,Some(epoch),1.02,false,true);
        assert!(i.samples[0].incarnation>old.incarnation);}
    app.update();assert_eq!(app.world().resource::<Live>().rows.len(),3);
}
