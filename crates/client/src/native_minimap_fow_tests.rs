use super::*;
use super::super::geometry::{Projection,Rect};

#[test]
fn original_minimap_alpha_and_actual_map_landmarks_share_native_fow_uvs() {
    let original=include_str!("../../../data/4.20/native_minimap_fow.ps_2_0");
    assert!(original.contains("tex2D(fowTexture, texcoord).r"));
    assert!(original.contains("(1-factor)*0.64f"));
    let shader=include_str!("../../../assets/shaders/native_minimap_fow.wgsl");
    assert!(shader.contains("textureSample(fow_texture,fow_sampler,in.uv).r"));
    assert!(shader.contains("vec4<f32>(0.0,0.0,0.0,(1.0-factor)*0.64)"));
    let level=crate::fow_level_bounds::LevelBounds::from_scb(include_bytes!("../../../assets/maps/tt_level_size.scb")).unwrap();
    let params=crate::native_fow::FogParams::from_native_extent(level.view_geometry().extent).unwrap();
    let config:openleague_core::world::Config=serde_json::from_str(include_str!("../../../data/4.20/map10_world.json")).unwrap();
    let projection=Projection::map10().unwrap();
    for rect in [Rect{left:831.,top:573.,width:191.,height:191.},Rect{left:1040.,top:656.,width:238.,height:142.}] {
        for structure in &config.structures {
            let p=structure.position;let pixel=projection.project(rect,p).unwrap();
            let ui_uv=(pixel-Vec2::new(rect.left,rect.top))/Vec2::new(rect.width,rect.height);
            let fow_uv=params.texture_coordinates(Vec2::new(p.x,p.z));
            assert!(ui_uv.distance(fow_uv)<0.000001,"{}",structure.definition);
        }
    }
    // The native black source and 0.64 alpha dim known terrain; visibility red1
    // is transparent. Actor omission is separately tested against snapshot_for.
    for red in [0.,0.25,0.5,1.] {
        let alpha=(1.-red)*0.64;let background=Vec3::new(0.2,0.4,0.8);
        let result=Vec3::ZERO*alpha+background*(1.-alpha);
        assert!(result.is_finite());assert!(result.min_element()>=0.);
        if red==0. {assert!(result.distance(background*0.36)<0.000001);}
        if red==1. {assert_eq!(result,background);}
    }
}
#[test]
fn actual_overlay_system_tracks_rectangle_handle_team_and_retires_on_session_loss() {
    let (mut app,id)=super::super::tests::app();
    let fog={let mut images=app.world_mut().resource_mut::<Assets<Image>>();let source=images.add(Image::default());crate::fow_gpu::Images::new(source,&mut images,1.)};
    app.insert_resource(fog).init_resource::<Live>().init_resource::<Frame>().init_resource::<Assets<FogMaterial>>()
        .add_systems(Update,update.after(super::super::update));
    app.update();let first=app.world().resource::<Frame>().ticket.unwrap();
    let rect=app.world().resource::<super::super::Live>().rect.unwrap();
    let node=app.world().get::<Node>(first.node).unwrap();assert_eq!(node.left,Val::Px(rect.left));assert_eq!(node.width,Val::Px(rect.width));
    assert_eq!(app.world().get::<GlobalZIndex>(first.node).unwrap().0,81);
    let background=&app.world().resource::<super::super::Live>().owned[&super::super::Key::Panel(0)];
    assert_eq!(app.world().get::<GlobalZIndex>(background.entity).unwrap().0,80);
    app.update();assert_eq!(app.world().resource::<Frame>().ticket,Some(first));
    let image=app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
    app.world_mut().resource_mut::<crate::fow_gpu::Images>().output=image.clone();app.update();
    let second=app.world().resource::<Frame>().ticket.unwrap();assert_eq!(second.node,first.node);assert_eq!(second.material,first.material);assert_ne!(second.image,first.image);
    assert_eq!(app.world().resource::<Assets<FogMaterial>>().get(second.material).unwrap().texture,image);
    app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().roster.iter_mut().find(|p|p.id==id).unwrap().team=1-first.team;app.update();
    assert_eq!(app.world().resource::<Frame>().ticket.unwrap().team,1-first.team);
    // Main-world assets and tickets alone must never pass the render guard.
    assert!(current_key(app.world(),second).is_none());
    app.world_mut().resource_mut::<crate::Connection>().session=None;app.update();
    assert!(app.world().resource::<Frame>().ticket.is_none());assert!(app.world().get_entity(first.node).is_err());
    assert!(!app.world().resource::<Assets<FogMaterial>>().contains(first.material));
}
#[test]
fn draw_gate_rejects_stale_session_team_allocation_view_material_and_node() {
    // Controlled identifiers test the predicate called by the actual draw;
    // they are not GPU textures, readiness or render acceptance evidence.
    let mut world=World::new();let node=world.spawn_empty().id();let other=world.spawn_empty().id();
    let mut materials=Assets::<FogMaterial>::default();let material=materials.add(FogMaterial{texture:Handle::default()}).id();
    let other_material=materials.add(FogMaterial{texture:Handle::default()}).id();
    let mut images=Assets::<Image>::default();let image=images.add(Image::default()).id();let other_image=images.add(Image::default()).id();
    let ticket=Ticket{session:u64::MAX-17,team:0,node,material,image};
    let key=BindingKey{ticket,texture:TextureId::new(),view:TextureViewId::new()};
    assert!(accepts(Some(key),Some(key),node,material));
    assert!(!accepts(None,Some(key),node,material));assert!(!accepts(Some(key),None,node,material));
    assert!(!accepts(Some(key),Some(key),other,material));assert!(!accepts(Some(key),Some(key),node,other_material));
    let variants=[BindingKey{ticket:Ticket{session:1,..ticket},..key},BindingKey{ticket:Ticket{team:1,..ticket},..key},
        BindingKey{ticket:Ticket{image:other_image,..ticket},..key},BindingKey{texture:TextureId::new(),..key},BindingKey{view:TextureViewId::new(),..key}];
    for stale in variants {assert!(!accepts(Some(key),Some(stale),node,material));}
    assert!(current_key(&world,ticket).is_none());
}
