use super::*;
use bevy::{image::{CompressedImageFormats,ImageType},mesh::VertexAttributeValues};
use openleague_core::Point;
#[derive(Resource)]
struct Input {frame:Frame,samples:Vec<CurrentR3d>,base_model_selected:bool}
fn host(mut commands:Commands,mut live:ResMut<Live>,mut current:ResMut<Current>,
    mut meshes:ResMut<Assets<Mesh>>,mut materials:ResMut<Assets<StrictMaterial>>,
    images:Res<Assets<Image>>,profile:Res<Profile>,input:Res<Input>,owned:OwnedQuery) {
    let result=profile.validate(&images).and_then(|_|synchronize(&mut commands,&mut live,&mut current,
        &mut meshes,&mut materials,&profile,&input.frame,&input.samples,&owned,input.base_model_selected));
    if let Err(error)=result {
        clear(&mut live,&mut current,&mut commands,&mut meshes,&mut materials);live.last_error=Some(error);
    }
}
fn sample(session:u64,team:u8) -> CurrentR3d {
    CurrentR3d {key:Key{session,owner:17,team,ordinal:(1u64<<53)+5},incarnation:1,
        position:Point{x:7684.,z:6934.},y_native:149.5,direction:Point{x:1.,z:0.},
        sample_tick:50,frame_ordinal:9}
}
fn app() -> App {
    let (snapshot,viewer,map,sources,_texture,mut images)=
        crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
    let mut app=App::new();let camera=app.world_mut().spawn_empty().id();
    let samplers=samplers();
    let mut decode=|bytes:&[u8],sampler:ImageSamplerDescriptor|images.add(Image::from_buffer(bytes,
        ImageType::Extension("dds"),CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler),
        RenderAssetUsages::default()).unwrap());
    let textures=Textures {image:decode(IMAGE_BYTES,samplers[0].clone()),
        color:decode(COLOR_BYTES,samplers[1].clone()),samplers};
    let overlay=images.add(Image::default());let visibility=images.add(Image::default());
    let profile=Profile {authored:Authored::load().unwrap(),textures,overlay};profile.validate(&images).unwrap();
    let view=Mat4::IDENTITY.to_cols_array();
    app.insert_resource(profile).insert_resource(images).insert_resource(Input {
        frame:Frame {frontier:Frontier {source:sources.mask_stamp(&map,snapshot.session,team).unwrap(),
            accepted_epoch:7,camera},visibility,extent:map.geometry.extent,view,clock:1.},
        samples:vec![sample(snapshot.session,team)],base_model_selected:true})
        .init_resource::<Live>().init_resource::<Current>().init_resource::<Assets<Mesh>>()
        .init_resource::<Assets<StrictMaterial>>().add_systems(Update,host);
    app
}
#[test]
fn original_dds_mips_sampler_and_payload_mutation_are_checked() {
    let mut app=app();let image=app.world().resource::<Profile>().textures.image.clone();
    let color=app.world().resource::<Profile>().textures.color.clone();
    let images=app.world().resource::<Assets<Image>>();
    assert_eq!(images.get(&image).unwrap().texture_descriptor.mip_level_count,9);
    assert_eq!(images.get(&color).unwrap().texture_descriptor.mip_level_count,7);
    assert_eq!(images.get(&image).unwrap().data.as_deref(),Some(&IMAGE_BYTES[128..]));
    app.update();assert_eq!(app.world().resource::<Current>().test_len(),1);
    app.world_mut().resource_mut::<Assets<Image>>().get_mut(&image).unwrap().data.as_mut().unwrap()[0]^=1;
    app.update();assert!(app.world().resource::<Live>().state.rows.is_empty());
    assert_eq!(app.world().resource::<Current>().test_len(),0);
}
#[test]
fn hidden_actor_is_not_needed_and_one_mesh_contains_all_live_quads() {
    let mut app=app();let mut actors=app.world_mut().query::<&crate::animation::Actor>();
    assert_eq!(actors.iter(app.world()).count(),0);app.update();
    let old_mesh=app.world().resource::<Live>().rows.values().next().unwrap().mesh.id();
    app.world_mut().resource_mut::<Input>().frame.clock=1.1;app.update();
    let live=app.world().resource::<Live>();assert_eq!(live.rows.len(),1);
    let key=app.world().resource::<Input>().samples[0].key;
    let entry=&live.state.rows[&key];assert!(entry.live_indices().count()>100);
    let draw=&live.rows[&key];let mesh=app.world().resource::<Assets<Mesh>>().get(&draw.mesh).unwrap();
    assert_ne!(draw.mesh.id(),old_mesh,"changed geometry must not reuse an old GPU mesh identity");
    assert!(!app.world().resource::<Assets<Mesh>>().contains(old_mesh));
    assert_eq!(mesh.count_vertices(),entry.live_indices().count()*4);
    assert!(app.world().get::<NoAutomaticBatching>(draw.entity).is_some());
    assert_eq!(app.world().resource::<Current>().test_len(),1);
}
#[test]
fn quad_transport_keeps_winding_lut_and_exact_once_native_unit_conversion() {
    let s=sample(1,0);let mut state=State::default().plan(&[s],0.,(1,7),&Authored::load().unwrap()).unwrap().next;
    let e=state.rows.get_mut(&s.key).unwrap();
    e.storage.positions[0]=[100f32,200.,300.].map(f32::to_bits);
    e.storage.scales[0]=20f32.to_bits();e.storage.scalar[0]=0;
    e.storage.attribute_a[0]=0.25f32.to_bits();e.storage.attribute_b[0]=0.75f32.to_bits();
    let mesh=geometry(e,Mat4::IDENTITY.to_cols_array()).unwrap().unwrap();
    let Some(VertexAttributeValues::Float32x3(pos))=mesh.attribute(Mesh::ATTRIBUTE_POSITION) else {panic!("positions");};
    assert_eq!(*pos,vec![[4.,11.,15.],[6.,11.,15.],[6.,9.,15.],[4.,9.,15.]]);
    let Some(VertexAttributeValues::Float32x2(uv))=mesh.attribute(Mesh::ATTRIBUTE_UV_0) else {panic!("uv");};
    assert_eq!(*uv,vec![[0.,0.],[1.,0.],[1.,1.],[0.,1.]]);
    let Some(VertexAttributeValues::Float32x2(lut))=mesh.attribute(Mesh::ATTRIBUTE_UV_1) else {panic!("lut");};
    assert_eq!(*lut,vec![[0.25,0.75];4]);assert_eq!(mesh.indices(),Some(&Indices::U32(vec![0,1,2,0,2,3])));
}
#[test]
fn changed_or_absent_base_model_retires_without_touching_foreign_draws() {
    let mut app=app();let foreign=material(app.world().resource::<Profile>(),&app.world().resource::<Input>().frame).unwrap();
    let foreign=app.world_mut().resource_mut::<Assets<StrictMaterial>>().add(foreign);
    let entity=app.world_mut().spawn(MeshMaterial3d(foreign.clone())).id();app.update();
    let old=app.world().resource::<Live>().rows.values().next().unwrap().entity;
    app.world_mut().resource_mut::<Input>().base_model_selected=false;app.update();
    assert!(app.world().resource::<Live>().rows.is_empty());assert!(app.world().get_entity(old).is_err());
    assert!(app.world().get_entity(entity).is_ok());assert!(app.world().resource::<Assets<StrictMaterial>>().contains(foreign.id()));
    assert_eq!(app.world().resource::<Current>().test_len(),0);
}
#[test]
fn same_batch_height_loss_incarnation_replaces_population_and_owned_assets() {
    let mut app=app();app.update();app.world_mut().resource_mut::<Input>().frame.clock=1.1;app.update();
    let key=app.world().resource::<Input>().samples[0].key;
    let old=&app.world().resource::<Live>().rows[&key];let ids=(old.entity,old.mesh.id(),old.material.id());
    app.world_mut().resource_mut::<Current>().invalidate();
    {let mut input=app.world_mut().resource_mut::<Input>();input.samples[0].incarnation+=1;input.samples[0].frame_ordinal+=2;}
    app.update();let live=app.world().resource::<Live>();let new=&live.rows[&key];
    assert_ne!(new.entity,ids.0);assert_eq!(live.state.rows[&key].live_indices().count(),1);
    assert!(!app.world().resource::<Assets<Mesh>>().contains(ids.1));
    assert!(!app.world().resource::<Assets<StrictMaterial>>().contains(ids.2));
}
#[test]
fn invalid_pose_missing_sampler_or_large_clock_gap_withholds_entire_frame() {
    for case in 0..3 {
        let mut app=app();app.update();
        match case {
            0=>app.world_mut().resource_mut::<Input>().samples[0].y_native=f32::NAN,
            1=> {let h=app.world().resource::<Profile>().textures.image.clone();
                app.world_mut().resource_mut::<Assets<Image>>().get_mut(&h).unwrap().sampler=ImageSampler::Default;},
            _=>app.world_mut().resource_mut::<Input>().frame.clock=2.,
        }
        app.update();assert!(app.world().resource::<Live>().rows.is_empty());
        assert!(app.world().resource::<Live>().state.rows.is_empty());
        assert_eq!(app.world().resource::<Current>().test_len(),0);
    }
}
#[test]
fn new_epoch_while_clock_frozen_replaces_old_multi_quad_mesh_and_authority() {
    let mut app=app();app.update();app.world_mut().resource_mut::<Input>().frame.clock=1.1;app.update();
    let key=app.world().resource::<Input>().samples[0].key;
    let old=&app.world().resource::<Live>().rows[&key];let old_mesh=old.mesh.id();let entity=old.entity;
    assert!(app.world().resource::<Assets<Mesh>>().get(old_mesh).unwrap().count_vertices()>4);
    let old_admission=app.world().resource::<Current>().test_admission(entity).unwrap();
    // Same session, identity, incarnation, XYZ, clock and camera. Only epoch
    // changes. The restarted population must not reuse the old GPU geometry.
    app.world_mut().resource_mut::<Current>().invalidate();
    app.world_mut().resource_mut::<Input>().frame.frontier.accepted_epoch=8;app.update();
    let live=app.world().resource::<Live>();let draw=&live.rows[&key];
    assert_eq!(draw.entity,entity);assert_ne!(draw.mesh.id(),old_mesh);
    assert_eq!(live.state.rows[&key].live_indices().count(),1);
    let meshes=app.world().resource::<Assets<Mesh>>();assert!(!meshes.contains(old_mesh));
    assert_eq!(meshes.get(&draw.mesh).unwrap().count_vertices(),4);
    let new=app.world().resource::<Current>().test_admission(entity).unwrap();
    assert_eq!(new.frontier.accepted_epoch,8);assert!(new.token>old_admission.token);
}
#[test]
fn paused_atomic_sample_keeps_population_but_requires_current_fow_authorization() {
    let mut app=app();let (mut snapshot,viewer,mut map,mut sources,_,_)=
        crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team=snapshot.roster.iter().find(|r|r.id==viewer).unwrap().team;
    snapshot.roster.iter_mut().find(|r|r.id==viewer).unwrap().champion="ezreal".into();
    snapshot.players.iter_mut().find(|p|p.id==viewer).unwrap().champion="ezreal".into();
    snapshot.ezreal_r_projectiles=vec![openleague_core::ezreal_r::VisibleMissile {session:snapshot.session,
        owner:viewer,team,ordinal:5,position:Point{x:7684.,z:6934.},direction:Point{x:1.,z:0.}}];
    let height=|s:&mut openleague_core::Snapshot,y:f32|s.ezreal_r_current_heights=Some(serde_json::json!({
        "policy":openleague_core::ezreal_r::CURRENT_HEIGHT_POLICY,
        "rows":[{"owner":viewer,"team":team,"ordinal":5,"y_native":y}]}));
    height(&mut snapshot,149.5);
    let context=openleague_core::session_transport::Context {session:snapshot.session,player:viewer,epoch:7};
    let mut state=crate::ezreal_r_passive_presentation::State::default();state.reset_session(snapshot.session,viewer);state.begin_epoch(Some(7));
    state.observe_accepted_frame(&snapshot,viewer,2.,false,true,Some((context,9))).unwrap();
    {let mut input=app.world_mut().resource_mut::<Input>();input.frame.clock=2.;
        input.samples=state.r_samples_3d(&snapshot,viewer,snapshot.session,Some(7),2.,true);
        input.frame.frontier.source=sources.mask_stamp(&map,snapshot.session,team).unwrap();}
    app.update();let frozen=app.world().resource::<Input>().samples[0];
    let draw=&app.world().resource::<Live>().rows[&frozen.key];let entity=draw.entity;let frozen_mesh=draw.mesh.id();
    let before=app.world().resource::<Assets<Mesh>>().get(&draw.mesh).unwrap().clone();
    let old=app.world().resource::<Current>().test_admission(entity).unwrap();
    app.world_mut().resource_mut::<Current>().invalidate();snapshot.tick+=1;
    snapshot.ezreal_r_projectiles[0].position.x+=900.;height(&mut snapshot,-45.);
    state.observe_accepted_frame(&snapshot,viewer,2.,true,true,Some((context,10))).unwrap();
    crate::fow_champion_sources::mask_provenance_tests::cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
    {let mut input=app.world_mut().resource_mut::<Input>();
        input.samples=state.r_samples_3d(&snapshot,viewer,snapshot.session,Some(7),2.,true);
        assert_eq!(input.samples,vec![frozen]);
        input.frame.frontier.source=sources.mask_stamp(&map,snapshot.session,team).unwrap();}
    app.update();let live=app.world().resource::<Live>();let draw=&live.rows[&frozen.key];
    assert_eq!(draw.entity,entity);assert_eq!(draw.mesh.id(),frozen_mesh);
    assert_eq!(live.state.rows[&frozen.key].sample,frozen);
    let after=app.world().resource::<Assets<Mesh>>().get(&draw.mesh).unwrap();
    assert_eq!(before.attribute(Mesh::ATTRIBUTE_POSITION),after.attribute(Mesh::ATTRIBUTE_POSITION));
    let new=app.world().resource::<Current>().test_admission(entity).unwrap();
    assert!(new.token>old.token);assert_eq!(new.frontier.source.represented_tick,frozen.sample_tick+1);
    app.world_mut().resource_mut::<Current>().invalidate();snapshot.ezreal_r_current_heights=None;
    state.observe_accepted_frame(&snapshot,viewer,2.,true,true,Some((context,11))).unwrap();
    app.world_mut().resource_mut::<Input>().samples=state.r_samples_3d(&snapshot,viewer,snapshot.session,Some(7),2.,true);
    app.update();assert!(app.world().resource::<Live>().state.rows.is_empty());
    assert!(app.world().resource::<Current>().test_admission(entity).is_none());
}
