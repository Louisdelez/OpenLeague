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
    events.begin_epoch(snapshot.session,7,viewer);snapshot.ezreal_r_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
    events.observe_accepted_frame(&snapshot,1.,true,false,Some((context,1))).unwrap();snapshot.tick+=1;
    // Explicit projected contact fixture: no runtime collision or native chronology claim.
    snapshot.ezreal_r_accepted_impacts=Some(serde_json::json!({"version":1,"events":[{
        "owner":viewer,"target":900,"order":(1u64<<53)+7,"tick":snapshot.tick,
        "projectile_center":{"x":7683.,"z":6934.},"target_center":{"x":7684.,"z":6934.}}]}));
    events.observe_accepted_frame(&snapshot,1.01,true,false,Some((context,2))).unwrap();
    crate::fow_champion_sources::mask_provenance_tests::cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
    let mut app=App::new();let camera=app.world_mut().spawn_empty().id();let samplers=samplers();
    let mut decode=|bytes:&[u8],sampler:ImageSamplerDescriptor|images.add(Image::from_buffer(bytes,
        ImageType::Extension("dds"),CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler),RenderAssetUsages::default()).unwrap());
    let textures=Textures {image:decode(IMAGE_BYTES,samplers[0].clone()),color:decode(COLOR_BYTES,samplers[1].clone()),samplers};
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
fn exact_two_dds_formats_mips_bytes_and_local_sampler_are_required(){
    let mut app=app();let color=app.world().resource::<Profile>().textures.color.clone();
    let image=app.world().resource::<Profile>().textures.image.clone();let images=app.world().resource::<Assets<Image>>();
    assert_eq!(images.get(&image).unwrap().texture_descriptor.mip_level_count,9);
    assert_eq!(images.get(&color).unwrap().texture_descriptor.mip_level_count,1);
    assert_eq!(images.get(&color).unwrap().texture_descriptor.format,TextureFormat::Bc1RgbaUnorm);
    assert_eq!(images.get(&color).unwrap().data.as_deref(),Some(&COLOR_BYTES[128..]));
    app.update();assert_eq!(app.world().resource::<Current>().test_len(),1);
    app.world_mut().resource_mut::<Assets<Image>>().get_mut(&color).unwrap().data.as_mut().unwrap()[0]^=1;
    app.update();assert_eq!(app.world().resource::<Current>().test_len(),0);assert!(app.world().resource::<Live>().rows.is_empty());
}
#[test]
fn ground_quad_has_four_vertices_one_degree_and_one_native_unit_conversion_without_actor(){
    let mut app=app();let mut actors=app.world_mut().query::<&crate::animation::Actor>();assert_eq!(actors.iter(app.world()).count(),0);
    app.update();let live=app.world().resource::<Live>();assert_eq!(live.rows.len(),1);
    let entry=live.state.rows.values().next().unwrap();assert_eq!(entry.angle,1.);assert_eq!(entry.scale,150.);
    assert_eq!(entry.center[1],simulation::map10_height([7684.,6934.]).unwrap());
    let draw=live.rows.values().next().unwrap();let mesh=app.world().resource::<Assets<Mesh>>().get(&draw.mesh).unwrap();assert_eq!(mesh.count_vertices(),4);
    let Some(VertexAttributeValues::Float32x3(pos))=mesh.attribute(Mesh::ATTRIBUTE_POSITION)else{panic!("positions")};
    let center:Vec3=pos.iter().map(|p|Vec3::from_array(*p)).sum::<Vec3>()/4.;
    assert!((center-Vec3::from_array(entry.center)/20.).length()<0.0001);
    assert!((Vec3::from_array(pos[1]).distance(Vec3::from_array(pos[0]))-15.).abs()<0.0001);
    let Some(VertexAttributeValues::Float32x2(uv))=mesh.attribute(Mesh::ATTRIBUTE_UV_0)else{panic!("uv")};
    assert_eq!(*uv,vec![[0.,0.],[1.,0.],[1.,1.],[0.,1.]]);
    let Some(VertexAttributeValues::Float32x2(lut))=mesh.attribute(Mesh::ATTRIBUTE_UV_1)else{panic!("lut")};assert_eq!(*lut,vec![[0.,0.5];4]);
    assert_eq!(mesh.indices(),Some(&Indices::U32(vec![0,1,2,0,2,3])));assert!(app.world().get::<NoAutomaticBatching>(draw.entity).is_some());
}
#[test]
fn pause_freezes_current_geometry_but_expiry_and_revocation_do_not_resume(){
    let mut app=app();app.update();app.world_mut().resource_mut::<Input>().frame.clock=1.11;app.update();
    let draw=app.world().resource::<Live>().rows.values().next().unwrap();let (entity,mesh)=(draw.entity,draw.mesh.id());
    {let mut input=app.world_mut().resource_mut::<Input>();input.paused=true;observe(&mut input);}
    app.update();let draw=app.world().resource::<Live>().rows.values().next().unwrap();assert_eq!((draw.entity,draw.mesh.id()),(entity,mesh));
    {let mut input=app.world_mut().resource_mut::<Input>();input.paused=false;input.frame.clock=1.32;}
    app.update();assert!(app.world().resource::<Live>().rows.is_empty());app.update();assert!(app.world().resource::<Live>().rows.is_empty());
}
#[test]
fn same_batch_missing_and_reveal_with_visible_owner_retires_without_rebirth(){
    let mut app=app();app.update();let entity=app.world().resource::<Live>().rows.values().next().unwrap().entity;
    {let mut input=app.world_mut().resource_mut::<Input>();let original=input.snapshot.ezreal_r_accepted_impacts.clone();
        input.snapshot.tick+=1;input.snapshot.ezreal_r_accepted_impacts=None;observe(&mut input);
        input.snapshot.tick+=1;input.snapshot.ezreal_r_accepted_impacts=original;observe(&mut input);}
    app.update();assert!(app.world().resource::<Live>().rows.is_empty());assert!(app.world().get_entity(entity).is_err());
    assert_eq!(app.world().resource::<Current>().test_len(),0);
}
#[test]
fn connection_loss_or_changed_base_model_clears_only_owned_flash_and_never_retries(){
    for model in [false,true] {let mut app=app();let inner=material(app.world().resource::<Profile>(),&app.world().resource::<Input>().frame).unwrap();
        let foreign=app.world_mut().resource_mut::<Assets<StrictMaterial>>().add(inner);
        let entity=app.world_mut().spawn(MeshMaterial3d(foreign.clone())).id();app.update();
        {let mut input=app.world_mut().resource_mut::<Input>();if model{input.base_model_selected=false}else{input.ready=false}}
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());assert!(app.world().get_entity(entity).is_ok());
        assert!(app.world().resource::<Assets<StrictMaterial>>().contains(foreign.id()));
        {let mut input=app.world_mut().resource_mut::<Input>();input.ready=true;input.base_model_selected=true;}
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());
    }
}
#[test]
fn failed_first_resource_admission_consumes_birth_without_late_loading_retry(){
    let mut app=app();let h=app.world().resource::<Profile>().textures.image.clone();
    let original=app.world().resource::<Assets<Image>>().get(&h).unwrap().clone();
    app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap().sampler=ImageSampler::Default;
    app.update();assert!(app.world().resource::<Live>().rows.is_empty());
    *app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap()=original;
    app.update();assert!(app.world().resource::<Live>().rows.is_empty());
}
#[test]
fn independent_flash_queue_does_not_consume_audio_and_rejects_cross_epoch_frontier(){
    let mut app=app();let mut audio=crate::ezreal_r_hit_audio_state::State::default();
    {let input=app.world().resource::<Input>();let mut baseline=input.snapshot.clone();baseline.tick-=1;
        baseline.ezreal_r_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
        audio.begin_epoch(input.context.session,input.context.epoch,input.context.player);
        audio.observe_accepted_frame(&baseline,1.,true,false,Some((input.context,1))).unwrap();
        audio.observe_accepted_frame(&input.snapshot,1.01,true,false,Some((input.context,2))).unwrap();}
    assert_eq!(audio.take(1.01,true,false).len(),1);app.update();assert_eq!(app.world().resource::<Live>().rows.len(),1);
    app.world_mut().resource_mut::<Input>().frame.frontier.accepted_epoch+=1;app.update();
    assert!(app.world().resource::<Live>().rows.is_empty());assert_eq!(app.world().resource::<Current>().test_len(),0);
}
