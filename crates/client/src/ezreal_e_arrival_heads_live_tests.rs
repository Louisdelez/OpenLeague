use super::*;
use bevy::{image::{CompressedImageFormats,ImageType},mesh::VertexAttributeValues};
use openleague_core::{Snapshot,session_transport::Context};
#[derive(Resource)]
struct Input {frame:Frame,events:Events,snapshot:Snapshot,context:Context,frame_ordinal:u64,
    paused:bool,ready:bool,base_model_selected:bool}
fn host(mut commands:Commands,mut live:ResMut<Live>,mut current:ResMut<Current>,
    mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<StrictMaterial>>,
    images:Res<Assets<Image>>,profile:Res<Profile>,mut input:ResMut<Input>,owned:OwnedQuery) {
    let (now,ready,paused)=(input.frame.clock,input.ready,input.paused);
    let requests=input.events.take(now,ready,paused);
    let result=if !ready {Err("flash connection unavailable")} else {
        profile.validate(&images).and_then(|_|synchronize(&mut commands,&mut live,&mut current,
            &mut meshes,&mut materials,&profile,&input.frame,&input.events,&requests,paused,&owned,input.base_model_selected))
    };
    if let Err(error)=result {clear(&mut live,&mut current,&mut commands,&mut meshes,&mut materials);live.last_error=Some(error);}
}
fn app()->App {
    let (mut snapshot,viewer,mut map,mut sources,_texture,mut images)=
        crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    snapshot.roster.iter_mut().find(|p|p.id==viewer).unwrap().champion="ezreal".into();
    snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().champion="ezreal".into();
    let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
    let context=Context {session:snapshot.session,epoch:7,player:viewer};let mut events=Events::default();
    events.begin_epoch(snapshot.session,7,viewer);snapshot.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":openleague_core::ezreal_e_accepted_releases::POLICY,"events":[]}));
    events.observe_accepted_frame(&snapshot,1.,true,false,Some((context,1))).unwrap();snapshot.tick+=1;
    // Explicit projected contact fixture: no runtime collision or native chronology claim.
    snapshot.ezreal_e_accepted_releases=Some(serde_json::json!({"policy":openleague_core::ezreal_e_accepted_releases::POLICY,"events":[{
        "owner":viewer,"phase":"arrival","order":(1u64<<53)+7,"tick":snapshot.tick,
        "position":{"x":7684.,"z":6934.}}]}));
    events.observe_accepted_frame(&snapshot,1.01,true,false,Some((context,2))).unwrap();
    crate::fow_champion_sources::mask_provenance_tests::cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
    let mut app=App::new();let camera=app.world_mut().spawn_empty().id();let samplers=samplers();
    let mut decode=|bytes:&[u8],sampler:ImageSamplerDescriptor|images.add(Image::from_buffer(bytes,
        ImageType::Extension("dds"),CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler),RenderAssetUsages::default()).unwrap());
    let textures=Textures {image:decode(IMAGE_BYTES,samplers[0].clone()),color:decode(COLOR_BYTES,samplers[1].clone()),samplers:samplers.clone()};
    let overlay=images.add(Image::default());let visibility=images.add(Image::default());
    let profile=Profile {authored:Authored::load().unwrap(),textures,overlay};profile.validate(&images).unwrap();
    app.insert_resource(profile).insert_resource(images).insert_resource(Input {frame:Frame {
        frontier:Frontier {source:sources.mask_stamp(&map,snapshot.session,team).unwrap(),accepted_epoch:7,camera},
        visibility,extent:map.geometry.extent,view:Mat4::IDENTITY.to_cols_array(),clock:1.01},events,snapshot,context,
        frame_ordinal:2,paused:false,ready:true,base_model_selected:true})
        .init_resource::<Live>().init_resource::<Current>().init_resource::<Assets<Mesh>>()
        .init_resource::<Assets<StrictMaterial>>().add_systems(Update,host);app
}
fn observe(input:&mut Input){
    input.frame_ordinal+=1;
    input.events.observe_accepted_frame(&input.snapshot,input.frame.clock,input.ready,input.paused,
        Some((input.context,input.frame_ordinal))).unwrap();
}
#[test]
fn arrival_image_and_palette_require_exact_dds_bytes_layout_and_sampler(){
    let mut app=app();let color=app.world().resource::<Profile>().textures.color.clone();
    app.update();assert_eq!(app.world().resource::<Current>().test_len(),2);
    let image=app.world().resource::<Profile>().textures.image.clone();
    assert_eq!(app.world().resource::<Assets<Image>>().get(&image).unwrap().texture_descriptor.mip_level_count,9);
    app.world_mut().resource_mut::<Assets<Image>>().get_mut(&color).unwrap().data.as_mut().unwrap()[0]^=1;
    app.update();assert_eq!(app.world().resource::<Current>().test_len(),0);assert!(app.world().resource::<Live>().rows.is_empty());
}
#[test]
fn paired_emission_generates_type0_quads_from_public_ground_without_actor(){
    let mut app=app();let mut actors=app.world_mut().query::<&crate::animation::Actor>();assert_eq!(actors.iter(app.world()).count(),0);
    app.update();app.world_mut().resource_mut::<Input>().frame.clock=1.135;app.update();
    let live=app.world().resource::<Live>();assert_eq!(live.rows.len(),2);let entry=live.state.rows.values().next().unwrap();
    assert_eq!(entry.center[1],simulation::map10_height([7684.,6934.]).unwrap());
    let count=entry.particles[0].live_indices().count();assert!(count>1);
    let draw=live.rows.values().next().unwrap();let mesh=app.world().resource::<Assets<Mesh>>().get(&draw.mesh).unwrap();
    assert_eq!(mesh.count_vertices(),count*4);assert!(app.world().get::<NoAutomaticBatching>(draw.entity).is_some());
    let Some(VertexAttributeValues::Float32x3(pos))=mesh.attribute(Mesh::ATTRIBUTE_POSITION)else{panic!("positions")};
    assert!(pos.iter().flatten().all(|v|v.is_finite()));
    let center=pos[..4].iter().map(|p|Vec3::from_array(*p)).sum::<Vec3>()/4.;
    let first=entry.particles[0].live_indices().next().unwrap();let expected=entry.particles[0].particles().positions[first].map(f32::from_bits);
    assert!((center-Vec3::from_array(expected)/20.).length()<0.0001);
}
#[test]
fn same_batch_permission_loss_and_epoch_change_retire_without_retry(){
    for epoch in [false,true] {let mut app=app();app.update();let entity=app.world().resource::<Live>().rows.values().next().unwrap().entity;
        {let mut input=app.world_mut().resource_mut::<Input>();if epoch{input.frame.frontier.accepted_epoch+=1;}else{
            let saved=input.snapshot.ezreal_e_accepted_releases.take();observe(&mut input);
            input.snapshot.ezreal_e_accepted_releases=saved;observe(&mut input);}}
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());assert_eq!(app.world().resource::<Current>().test_len(),0);
        assert!(app.world().get_entity(entity).is_err());app.update();assert!(app.world().resource::<Live>().rows.is_empty());
    }
}
#[test]
fn connection_or_asset_failure_clears_only_this_host_and_consumes_birth(){
    for mode in 0..2 {let mut app=app();let inner=material(app.world().resource::<Profile>(),&app.world().resource::<Input>().frame).unwrap();
        let foreign=app.world_mut().resource_mut::<Assets<StrictMaterial>>().add(inner);let entity=app.world_mut().spawn(MeshMaterial3d(foreign.clone())).id();
        let h=app.world().resource::<Profile>().textures.image.clone();let original=app.world().resource::<Assets<Image>>().get(&h).unwrap().clone();
        if mode==0{app.world_mut().resource_mut::<Input>().ready=false;}else{app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap().sampler=ImageSampler::Default;}
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());assert!(app.world().get_entity(entity).is_ok());
        app.world_mut().resource_mut::<Input>().ready=true;*app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap()=original;
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());assert!(app.world().resource::<Assets<StrictMaterial>>().contains(foreign.id()));
    }
}
#[test]
fn pause_keeps_mesh_but_changed_camera_rebuilds_only_geometry_before_strict_submission(){
    let mut app=app();app.update();app.world_mut().resource_mut::<Input>().frame.clock=1.135;app.update();
    let draw=app.world().resource::<Live>().rows.values().next().unwrap();let (entity,mesh)=(draw.entity,draw.mesh.id());
    {let mut input=app.world_mut().resource_mut::<Input>();input.paused=true;observe(&mut input);}app.update();
    let draw=app.world().resource::<Live>().rows.values().next().unwrap();assert_eq!((draw.entity,draw.mesh.id()),(entity,mesh));
    app.world_mut().resource_mut::<Input>().frame.view=Mat4::from_rotation_y(0.1).to_cols_array();app.update();
    let draw=app.world().resource::<Live>().rows.values().next().unwrap();assert_eq!(draw.entity,entity);assert_ne!(draw.mesh.id(),mesh);
}
