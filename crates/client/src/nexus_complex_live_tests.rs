use super::*;
use crate::nexus_idle_particles::{Owner,CycleId,Descriptor};
fn request(world:Mat4,age:f64)->Request {
    Request {owner:Owner {session:1,actor:Entity::PLACEHOLDER,attachment_generation:1,effect_id:11},
        cycle:CycleId {session:1,source:20,serial:1},descriptor:Descriptor {slot:1,key:"IdleParticles1".into(),
            authored:"Order_Nexus.troy center".into(),resource:"Order_Nexus.troy".into(),bone:"center".into(),node:9,skin_index:8},
        bone:Entity::PLACEHOLDER,attachment_world:world,started_at:5.,age_seconds:age,native_idle_resource_flag:0x10}
}
#[test]
fn authored_tables_are_real_distinct_curves_and_no_probability_is_synthesized() {
    let p=profiles().unwrap();assert_eq!(p[0].scale,Vec3::new(12.,8.,12.));assert_eq!(p[1].scale,Vec3::new(12.1,8.1,12.1));
    assert_eq!(p[0].color.table.len(),256);assert_eq!(p[1].color.table.len(),256);
    assert_eq!(p[0].color.table[0],[0.,0.,0.,1.]);assert_eq!(p[1].color.table[0],[1.;4]);
    assert_eq!(p[1].color.table[255],[0.,0.8,1.,0.4]);
    let image=lookup_image(&p[1]);assert_eq!(&image.data.as_ref().unwrap()[1020..],[0,204,255,102]);
    assert_eq!(image.texture_descriptor.format,TextureFormat::Rgba8Unorm);
}
#[test]
fn actual_attachment_unit_conversion_preserves_native_scale_and_position_once() {
    let world=Mat4::from_scale_rotation_translation(Vec3::splat(0.05),Quat::IDENTITY,Vec3::new(10.,3.,20.));
    let r=request(world,0.);let (orientation,position)=owner_pose(&r).unwrap();
    assert!(orientation.abs_diff_eq(Mat4::IDENTITY,0.000001));assert_eq!(position,Vec3::new(200.,60.,400.));
    let p=packet(&profiles().unwrap()[1],&r,15360.).unwrap().unwrap();
    assert_eq!(p.world.point([0.;3]).unwrap(),[200.,380.,400.]);
    let x=Vec3::from_array(p.world.point([1.,0.,0.]).unwrap())-Vec3::new(200.,380.,400.);
    assert!((x.length()-12.1).abs()<0.00002);
}
#[test]
fn age_survives_rebind_and_strict_life_boundary_never_restarts_or_completes_resource() {
    let profile=&profiles().unwrap()[1];let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),70.);
    let first=packet(profile,&r,15360.).unwrap().unwrap();r.owner.attachment_generation=2;
    let next=packet(profile,&r,15360.).unwrap().unwrap();assert_eq!(first.world.0,next.world.0);
    assert_eq!(first.material.lookup_uv,next.material.lookup_uv);
    r.age_seconds=89.;assert!(packet(profile,&r,15360.).unwrap().is_some());
    for t in [89.25,90.,600.] {r.age_seconds=t;assert!(packet(profile,&r,15360.).unwrap().is_none());}
    r.age_seconds=f64::NAN;assert!(packet(profile,&r,15360.).is_err());
}
#[test]
fn qualified_owner_transfer_clears_translation_and_keeps_current_bone_rotation() {
    let world=Mat4::from_scale_rotation_translation(Vec3::splat(0.05),Quat::from_rotation_y(0.7),Vec3::new(8.,4.,6.));
    let r=request(world,0.);let (o,p)=owner_pose(&r).unwrap();
    assert!(o.abs_diff_eq(Mat4::from_rotation_y(0.7),0.000001));assert_eq!(p,Vec3::new(160.,80.,120.));
    assert_eq!(o.w_axis,Vec4::W);
}
#[test]
fn ordinary_live_consumer_creates_two_private_draws_then_retires_on_missing_request() {
    let mut world=World::new();let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),2.);
    r.owner.actor=world.spawn_empty().id();r.bone=world.spawn_empty().id();
    let groups=profiles().unwrap();let mut images=Assets::<Image>::default();
    let textures=material::Textures::fixture(&mut images);
    let lookup=[images.add(lookup_image(&groups[0])),images.add(lookup_image(&groups[1]))];
    // Controlled FoW inputs; real ECS/geometry/table preparation, no GPU execution.
    let overlay=images.add(Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},
        TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let fog=crate::fow_gpu::Images::new(overlay.clone(),&mut images,1.);
    let bindings=Bindings {textures,lookup,sparkle_lookup:None,visibility:fog.output.clone(),overlay};
    let on_groups=on_all_profiles().unwrap();
    let on_bindings=Bindings {textures:material::Textures::fixture_set(&mut images,material::TextureSet::On),
        lookup:[images.add(lookup_image(&on_groups[0])),images.add(lookup_image(&on_groups[1]))],
        sparkle_lookup:Some(images.add(lookup_image(&on_groups[2]))),visibility:bindings.visibility.clone(),overlay:bindings.overlay.clone()};
    world.insert_resource(Profile {resources:vec![ResourceProfile {groups:Vec::from(groups),bindings,armed:false,invalidated:false},
        ResourceProfile {groups:on_groups,bindings:on_bindings,armed:false,invalidated:false}],events:default()});
    world.insert_resource(images);world.insert_resource(fog);world.insert_resource(Assets::<Mesh>::default());
    world.insert_resource(Assets::<material::NexusMaterial>::default());
    world.insert_resource(crate::map10_vision_view::Map10VisionView::native_map10().unwrap());
    world.insert_resource(Backend::new(1).unwrap());world.insert_resource(Diagnostics::default());
    let mut idle=Host::default();idle.frame=crate::nexus_idle_particles::Frame {ordinal:1,session:Some(1),
        requests:vec![r.clone()],retired:vec![],error:None};world.insert_resource(idle);
    synchronize(&mut world);
    let d=world.resource::<Diagnostics>();assert_eq!(d.error,None);assert_eq!(d.draws,2);
    assert!(d.local_reconstruction);assert!(!d.gpu_draw_qualified);
    let tickets=world.resource::<Backend>().tickets();assert_eq!(tickets.len(),2);
    for t in &tickets {assert_eq!(world.get::<Visibility>(t.draw),Some(&Visibility::Visible));
        assert!(world.resource::<Assets<material::NexusMaterial>>().get(t.material).unwrap().is_ready());}
    // Native resource phase changes the whole private owner; no startup texture
    // or old ticket survives. The on group is still present well beyond89s.
    r.owner.effect_id=22;r.cycle.serial=2;r.descriptor.resource="Order_Nexus_on.troy".into();r.age_seconds=300.;
    world.resource_mut::<Host>().frame=crate::nexus_idle_particles::Frame {ordinal:2,session:Some(1),requests:vec![r.clone()],..default()};
    synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().error,None);assert_eq!(world.resource::<Diagnostics>().draws,3);
    assert!(tickets.iter().all(|t|world.get_entity(t.draw).is_err()));
    let on_tickets=world.resource::<Backend>().tickets();
    for t in &on_tickets {
        if let Some(old)=tickets.iter().find(|old|old.group==t.group) {assert_ne!(t.images[0],old.images[0]);}
        else {assert_eq!(t.group,Group::GemSparkle);assert_eq!(world.resource::<Assets<Mesh>>().get(t.mesh).unwrap().count_vertices(),504);}
        assert!(world.resource::<Assets<material::NexusMaterial>>().get(t.material).unwrap().is_ready());
    }
    world.resource_mut::<Host>().frame.ordinal=3;synchronize(&mut world);
    let next=world.resource::<Backend>().tickets();assert!(next.iter().all(|n|on_tickets.iter().any(|o|o.draw==n.draw && o.mesh==n.mesh && o.material==n.material)));
    // A real asset message after the on profile was armed retires all its private
    // draws. A later request cannot silently accept the replaced sparkle bytes.
    let sparkle_image=on_tickets.iter().find(|t|t.group==Group::GemSparkle).unwrap().images[0];
    world.init_resource::<Messages<AssetEvent<Image>>>();
    world.resource_mut::<Messages<AssetEvent<Image>>>().write(AssetEvent::Modified {id:sparkle_image});
    world.resource_mut::<Host>().frame.ordinal=4;synchronize(&mut world);
    assert!(world.resource::<Diagnostics>().error.is_some());assert_eq!(world.resource::<Backend>().owner_count(),0);
    assert!(world.resource::<Profile>().resources[1].invalidated);
    world.resource_mut::<Host>().frame.ordinal=5;synchronize(&mut world);
    assert!(world.resource::<Diagnostics>().error.is_some());assert_eq!(world.resource::<Diagnostics>().draws,0);
    world.resource_mut::<Host>().frame=crate::nexus_idle_particles::Frame {ordinal:6,session:Some(1),..default()};
    synchronize(&mut world);assert_eq!(world.resource::<Backend>().owner_count(),0);
    assert!(on_tickets.iter().all(|t|world.get_entity(t.draw).is_err()));
    assert!(world.get_entity(r.owner.actor).is_ok());
}

#[test]
fn on_groups_use_exact_life_offset_birth_color_and_native_missing_field_defaults() {
    let groups=on_profiles().unwrap();
    for (i,p) in groups.iter().enumerate() {
        assert_eq!(p.life,1_000_000.);assert_eq!(p.offset,Vec3::new(0.,120.,0.));
        assert_eq!(p.on_rotation_velocity,Some(Vec3::new(0.,30.,0.)));
        assert_eq!(p.base_rotation,Vec3::ZERO);assert!(p.rotation.is_none());assert!(p.displacement.is_none());
        assert!(!p.color.reader_accepted);assert_eq!(p.color.table,vec![[1.;4]]);
        assert_eq!(&p.birth[..3],&[1.;3]);
        assert!((p.birth[3]-(if i==0 {100.} else {150.})/255.).abs()<1e-7);
        assert_eq!(p.render_mode,i as u32);
    }
}

#[test]
fn on_particles_keep_source_life_and_do_not_restart_or_fall_back_to_startup() {
    let groups=on_profiles().unwrap();let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),0.);
    assert!(packet(&groups[0],&r,15360.).is_err());r.descriptor.resource="Order_Nexus_on.troy".into();
    for t in [0.,89.,91.,600.,1_000_000.] {
        r.age_seconds=t;
        for p in &groups {
            let draw=packet(p,&r,15360.).unwrap().unwrap();
            assert_eq!(draw.world.point([0.;3]).unwrap(),[0.,120.,0.]);assert_eq!(draw.material.render_mode,p.render_mode);
        }
    }
    r.age_seconds=1_000_001.;assert!(packet(&groups[0],&r,15360.).unwrap().is_none());
    assert!(packet(&profiles().unwrap()[0],&r,15360.).is_err());
}

#[test]
fn on_dds_are_real_bc3_and_mode_zero_uses_distinct_qualified_additive_preset() {
    use bevy::render::render_resource::BlendFactor;
    let mut images=Assets::<Image>::default();let startup=material::Textures::fixture(&mut images);
    let on=material::Textures::fixture_set(&mut images,material::TextureSet::On);
    startup.validate(&images).unwrap();on.validate(&images).unwrap();
    for group in [Group::GemInside,Group::Gem] {
        let a=images.get(startup.handle(group).unwrap()).unwrap();let b=images.get(on.handle(group).unwrap()).unwrap();
        assert_ne!(a.data,b.data);assert_eq!(a.texture_descriptor.size,b.texture_descriptor.size);
    }
    let mode0=material::supported_blend(0).unwrap();let mode1=material::supported_blend(1).unwrap();
    assert_eq!(mode0.color.src_factor,BlendFactor::One);assert_eq!(mode0.color.dst_factor,BlendFactor::One);
    assert_eq!(mode0.alpha.src_factor,BlendFactor::One);assert_eq!(mode0.alpha.dst_factor,BlendFactor::One);
    assert_eq!(mode1,material::mode1_blend());assert_ne!(mode0,mode1);assert!(material::supported_blend(2).is_err());
    let bindings=Bindings {textures:on,lookup:[default(),default()],sparkle_lookup:Some(default()),visibility:default(),overlay:default()};
    let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),0.);r.descriptor.resource="Order_Nexus_on.troy".into();
    let input=packet(&on_profiles().unwrap()[0],&r,15360.).unwrap().unwrap().material;
    let additive=material::NexusMaterial::new(&bindings,Group::GemInside,input).unwrap();
    let alpha=material::NexusMaterial::new(&bindings,Group::GemInside,Inputs {render_mode:1,..input}).unwrap();
    assert_ne!(material::MaterialKey::from(&additive),material::MaterialKey::from(&alpha));
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_render_state_contract.json")).unwrap();
    let row=proof["cases"].as_array().unwrap().iter().find(|r|r["mode"]==0 && r["flags"]==0 && r["initial"]==0).unwrap();
    for pair in [[19,2],[20,2],[207,2],[208,2],[171,1],[206,1]] {assert!(row["calls"].as_array().unwrap().contains(&serde_json::json!(pair)));}
}

#[test]
fn sparkle_profile_keeps_authored_mesh_motion_pass_and_native_uv_scroll() {
    let p=sparkle_profile().unwrap();assert_eq!(p.group,Group::GemSparkle);
    assert_eq!(p.scale,Vec3::new(12.,8.,12.));assert_eq!(p.offset,Vec3::new(0.,120.,0.));
    assert_eq!(p.on_rotation_velocity,Some(Vec3::new(0.,30.,0.)));assert!(!p.backface);
    assert_eq!(p.render_mode,0);assert_eq!(p.authored_pass,Some(100));
    assert_eq!(p.life,1_000_000.);assert_eq!(&p.birth[..3],&[1.;3]);assert!((p.birth[3]-50./255.).abs()<1e-7);
    let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),0.);r.descriptor.resource="Order_Nexus_on.troy".into();
    // These elapsed-second samples discriminate from normalized life and from
    // keeping the UV static, without claiming a whole native emission run.
    for (age,uv) in [(0.,[0.,0.]),(0.25,[0.25,0.125]),(1.,[0.,0.5]),(2.5,[0.5,0.25]),(600.25,[0.25,0.125])] {
        r.age_seconds=age;let draw=packet(&p,&r,15360.).unwrap().unwrap();
        assert_eq!(draw.material.uv_scale_offset,Vec4::new(1.,1.,uv[0],uv[1]));
        assert_eq!(draw.material.cull,Cull::Back);assert_eq!(draw.material.render_mode,0);
        assert_eq!(draw.world.point([0.;3]).unwrap(),[0.,120.,0.]);
    }
    let at=packet(&p,&r,15360.).unwrap().unwrap();r.owner.attachment_generation+=1;
    let rebound=packet(&p,&r,15360.).unwrap().unwrap();assert_eq!(at.world.0,rebound.world.0);
    assert_eq!(at.material.uv_scale_offset,rebound.material.uv_scale_offset);
    r.age_seconds=1_000_000.;assert!(packet(&p,&r,15360.).unwrap().is_some());
    r.age_seconds=1_000_001.;assert!(packet(&p,&r,15360.).unwrap().is_none());
    r.descriptor.resource="Order_Nexus.troy".into();assert!(packet(&p,&r,15360.).is_err());
    assert_eq!(profiles().unwrap().len(),2);assert_eq!(on_all_profiles().unwrap().len(),3);
}

#[test]
fn sparkle_hot_reload_is_watched_and_does_not_invalidate_startup_bindings() {
    let mut images=Assets::<Image>::default();let groups=on_all_profiles().unwrap();
    let textures=material::Textures::fixture_set(&mut images,material::TextureSet::On);
    let sparkle=textures.handle(Group::GemSparkle).unwrap().id();
    let lookup=[images.add(lookup_image(&groups[0])),images.add(lookup_image(&groups[1]))];
    let table=images.add(lookup_image(&groups[2]));
    let b=Bindings {textures,lookup,sparkle_lookup:Some(table.clone()),visibility:default(),overlay:default()};
    assert!(b.watched_images().contains(&sparkle));assert!(b.watched_images().contains(&table.id()));b.validate(&images).unwrap();
    let old=Bindings {textures:material::Textures::fixture(&mut images),lookup:b.lookup.clone(),sparkle_lookup:None,visibility:default(),overlay:default()};
    assert!(!old.watched_images().contains(&sparkle));assert!(!old.watched_images().contains(&table.id()));
    images.remove(sparkle);assert!(b.validate(&images).is_err());old.validate(&images).unwrap();
    assert!(old.images(Group::GemSparkle).is_err());
}

#[test]
fn chaos_profiles_keep_purple_source_curves_alpha_scale_and_absent_emitter_life() {
    let startup=profiles_for(Side::Chaos).unwrap();let blue=profiles().unwrap();
    for (r,b) in startup.iter().zip(&blue) {
        assert_eq!(r.life,b.life);assert_eq!(r.scale,b.scale);assert_ne!(r.color.table,b.color.table);
    }
    let on=on_profiles_for(Side::Chaos).unwrap();assert_eq!(on[0].scale,Vec3::new(12.,8.,12.));
    assert_eq!(on[1].scale,Vec3::new(12.1,8.2,12.1));assert_eq!(on[1].birth,[1.;4]);
    assert!((on[0].birth[3]-100./255.).abs()<1e-7);assert_eq!(on[0].render_mode,0);assert_eq!(on[1].render_mode,1);
    let sparkle=sparkle_profile_for(Side::Chaos).unwrap();assert_eq!(sparkle.authored_emitter_life,None);
    assert_eq!(sparkle_profile().unwrap().authored_emitter_life,Some(-1.));
    assert_eq!(sparkle.life,1_000_000.);assert_eq!(sparkle.authored_pass,Some(100));
    let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),600.25);r.descriptor.resource="Chaos_Nexus_on.troy".into();
    assert_eq!(packet(&sparkle,&r,15360.).unwrap().unwrap().material.uv_scale_offset,Vec4::new(1.,1.,0.25,0.125));
    assert!(packet(&on_profiles().unwrap()[0],&r,15360.).is_err());
    let mut images=Assets::<Image>::default();
    let red=material::Textures::fixture_set(&mut images,material::TextureSet::ChaosOn);
    let blue=material::Textures::fixture_set(&mut images,material::TextureSet::On);
    red.validate(&images).unwrap();blue.validate(&images).unwrap();
    for g in [Group::GemInside,Group::Gem] {
        assert_ne!(images.get(red.handle(g).unwrap()).unwrap().data,images.get(blue.handle(g).unwrap()).unwrap().data);
    }
    assert_eq!(images.get(red.handle(Group::GemSparkle).unwrap()).unwrap().data,images.get(blue.handle(Group::GemSparkle).unwrap()).unwrap().data);
}

#[test]
fn simultaneous_nexus_draws_retain_handles_and_chaos_reload_or_disappearance_preserves_order() {
    let mut world=World::new();let mut blue=request(Mat4::from_scale(Vec3::splat(0.05)),200.);
    blue.descriptor.resource="Order_Nexus_on.troy".into();blue.owner.actor=world.spawn_empty().id();blue.bone=world.spawn_empty().id();
    let mut red=blue.clone();red.cycle.source=202;red.cycle.serial=2;red.owner.effect_id=22;
    red.descriptor.resource="Chaos_Nexus_on.troy".into();red.owner.actor=world.spawn_empty().id();red.bone=world.spawn_empty().id();
    red.attachment_world=Mat4::from_translation(Vec3::new(20.,0.,0.))*blue.attachment_world;
    let mut images=Assets::<Image>::default();
    let overlay=images.add(Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
        vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let fog=crate::fow_gpu::Images::new(overlay.clone(),&mut images,1.);
    let mut make=|side,set| {
        let groups=on_all_profiles_for(side).unwrap();let textures=material::Textures::fixture_set(&mut images,set);
        let bindings=Bindings {textures,lookup:[images.add(lookup_image(&groups[0])),images.add(lookup_image(&groups[1]))],
            sparkle_lookup:Some(images.add(lookup_image(&groups[2]))),visibility:fog.output.clone(),overlay:overlay.clone()};
        ResourceProfile {groups,bindings,armed:false,invalidated:false}
    };
    let resources=vec![make(Side::Order,material::TextureSet::On),make(Side::Chaos,material::TextureSet::ChaosOn)];
    world.insert_resource(Profile {resources,events:default()});world.insert_resource(images);world.insert_resource(fog);
    world.insert_resource(Assets::<Mesh>::default());world.insert_resource(Assets::<material::NexusMaterial>::default());
    world.insert_resource(crate::map10_vision_view::Map10VisionView::native_map10().unwrap());world.insert_resource(Backend::new(2).unwrap());
    let mut h=Host::default();h.frame=crate::nexus_idle_particles::Frame {ordinal:1,session:Some(1),requests:vec![blue.clone(),red.clone()],..default()};
    world.insert_resource(h);synchronize(&mut world);
    assert_eq!(world.resource::<Diagnostics>().error,None);assert_eq!(world.resource::<Diagnostics>().draws,6);
    let tickets=world.resource::<Backend>().tickets();let blue_tickets:Vec<_>=tickets.iter().filter(|t|t.owner==blue.owner).cloned().collect();
    let red_tickets:Vec<_>=tickets.iter().filter(|t|t.owner==red.owner).cloned().collect();
    assert_eq!(blue_tickets.len(),3);assert_eq!(red_tickets.len(),3);
    for b in &blue_tickets {assert!(red_tickets.iter().all(|r|r.draw!=b.draw && r.mesh!=b.mesh && r.material!=b.material));}
    world.resource_mut::<Host>().frame.ordinal=2;synchronize(&mut world);
    let next=world.resource::<Backend>().tickets();assert!(next.iter().all(|n|tickets.iter().any(|o|o.draw==n.draw && o.mesh==n.mesh && o.material==n.material)));
    // Loss of just the Chaos full-set request retires only those exact private draws.
    {let mut host=world.resource_mut::<Host>();host.frame.ordinal=3;host.frame.requests=vec![blue.clone()];}
    synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().draws,3);
    assert!(red_tickets.iter().all(|t|world.get_entity(t.draw).is_err()));
    assert!(blue_tickets.iter().all(|t|world.get_entity(t.draw).is_ok()));
    {let mut host=world.resource_mut::<Host>();host.frame.ordinal=4;host.frame.requests.push(red.clone());}
    synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().draws,6);
    let image=world.resource::<Profile>().resources[1].bindings.textures.handle(Group::Gem).unwrap().id();
    world.init_resource::<Messages<AssetEvent<Image>>>();world.resource_mut::<Messages<AssetEvent<Image>>>().write(AssetEvent::Modified {id:image});
    world.resource_mut::<Host>().frame.ordinal=5;synchronize(&mut world);
    let d=world.resource::<Diagnostics>();assert_eq!(d.draws,3);assert!(d.error.is_some());assert_eq!(d.issues.len(),1);assert_eq!(d.issues[0].0,202);
    assert_eq!(world.resource::<Backend>().owner_count(),1);
    assert!(world.resource::<Backend>().tickets().iter().all(|t|blue_tickets.iter().any(|b|b.draw==t.draw && b.mesh==t.mesh && b.material==t.material)));
    world.resource_mut::<Host>().frame.ordinal=6;synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().draws,3);
    {let mut host=world.resource_mut::<Host>();host.frame.ordinal=7;host.frame.session=None;host.frame.requests.clear();}
    synchronize(&mut world);assert_eq!(world.resource::<Backend>().owner_count(),0);
    assert!(world.get_entity(blue.owner.actor).is_ok());assert!(world.get_entity(red.owner.actor).is_ok());
}

#[test]
fn startup_sparkle_uses_original_curves_and_does_not_gate_additive_rgb_on_alpha() {
    for side in [Side::Order,Side::Chaos] {
        let p=startup_sparkle_profile_for(side).unwrap();
        assert_eq!(p.resource,side.resource(false));assert_eq!(p.group,Group::GemSparkle);
        assert_eq!(p.life,89.);assert_eq!(p.authored_emitter_life,Some(1.));assert_eq!(p.render_mode,0);
        assert_eq!(p.scale,Vec3::new(12.,8.,12.));assert_eq!(p.offset,Vec3::new(0.,320.,0.));
        assert_eq!(p.base_rotation,Vec3::new(0.,1.,0.));assert_eq!(p.authored_pass,Some(100));
        assert!(!p.backface);assert_eq!(p.birth,[1.;4]);assert_eq!(p.color.table.len(),256);
        assert!(p.color.table.iter().all(|c|c[..3]==[1.;3]));assert_eq!(p.color.table[0][3],0.);
        assert_eq!(p.color.table[127][3],0.);assert!(p.color.table[192][3]>0.4);
        // Native94DE30 samples i/count: index255 is255/256, not the endpoint1.
        // Authored alpha0 at .5 -> alpha1 at1 yields127/128, exactly0x3f7e0000.
        assert_eq!(p.color.table[255][3].to_bits(),0x3f7e0000);
        assert!(p.rotation.is_some());assert!(p.displacement.is_some());assert!(p.on_rotation_velocity.is_none());
        let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),0.);r.descriptor.resource=side.resource(false).into();
        // RGB remains authored white even at alpha0. ONE/ONE does not multiply
        // it by alpha, so no alpha-based packet suppression is permissible.
        let draw=packet(&p,&r,15360.).unwrap().unwrap();assert_eq!(draw.material.render_mode,0);
        assert_eq!(draw.world.point([0.;3]).unwrap(),[0.,320.,0.]);
        assert_eq!(material::supported_blend(0).unwrap().color.src_factor,bevy::render::render_resource::BlendFactor::One);
        let table=lookup_image(&p);assert_eq!(&table.data.as_ref().unwrap()[..4],&[255,255,255,0]);
        assert_eq!(startup_all_profiles_for(side).unwrap().len(),3);
    }
}

#[test]
fn startup_sparkle_scroll_age_expiry_and_resource_boundaries_survive_rebinding() {
    let p=startup_sparkle_profile_for(Side::Order).unwrap();
    let mut r=request(Mat4::from_scale(Vec3::splat(0.05)),0.);
    for (age,uv) in [(0.,[0.,0.]),(0.25,[0.125,0.0625]),(1.,[0.5,0.25]),(2.5,[0.25,0.625]),(60.25,[0.125,0.0625])] {
        r.age_seconds=age;let draw=packet(&p,&r,15360.).unwrap().unwrap();
        assert_eq!(draw.material.uv_scale_offset,Vec4::new(1.,1.,uv[0],uv[1]));
    }
    r.age_seconds=70.;let before=packet(&p,&r,15360.).unwrap().unwrap();r.owner.attachment_generation+=1;
    let after=packet(&p,&r,15360.).unwrap().unwrap();assert_eq!(before.world.0,after.world.0);
    assert_eq!(before.material.lookup_uv,after.material.lookup_uv);assert_eq!(before.material.uv_scale_offset,after.material.uv_scale_offset);
    assert!(before.world.point([0.;3]).unwrap()[1]<320.);
    r.age_seconds=89.;assert!(packet(&p,&r,15360.).unwrap().is_some());
    r.age_seconds=89.001;assert!(packet(&p,&r,15360.).unwrap().is_none());
    r.age_seconds=1.;r.descriptor.resource="Order_Nexus_on.troy".into();assert!(packet(&p,&r,15360.).is_err());
    r.descriptor.resource="Chaos_Nexus.troy".into();assert!(packet(&p,&r,15360.).is_err());
}

#[test]
fn two_startup_sparkles_bind_exact_meshes_keep_handles_and_retire_independently_at_phase_change() {
    let mut world=World::new();let mut blue=request(Mat4::from_scale(Vec3::splat(0.05)),60.25);
    blue.owner.actor=world.spawn_empty().id();blue.bone=world.spawn_empty().id();
    let mut red=blue.clone();red.owner.actor=world.spawn_empty().id();red.bone=world.spawn_empty().id();
    red.owner.effect_id=22;red.cycle.source=202;red.cycle.serial=2;red.descriptor.resource="Chaos_Nexus.troy".into();
    let mut images=Assets::<Image>::default();
    let overlay=images.add(Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
        vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
    let fog=crate::fow_gpu::Images::new(overlay.clone(),&mut images,1.);
    let mut make=|groups:Vec<GroupProfile>,set| {
        let bindings=Bindings {textures:material::Textures::fixture_set(&mut images,set),
            lookup:[images.add(lookup_image(&groups[0])),images.add(lookup_image(&groups[1]))],
            sparkle_lookup:Some(images.add(lookup_image(&groups[2]))),visibility:fog.output.clone(),overlay:overlay.clone()};
        bindings.validate(&images).unwrap();ResourceProfile {groups,bindings,armed:false,invalidated:false}
    };
    let mut resources=vec![make(startup_all_profiles_for(Side::Order).unwrap(),material::TextureSet::StartupWithSparkle),
        make(startup_all_profiles_for(Side::Chaos).unwrap(),material::TextureSet::StartupWithSparkle),
        make(on_all_profiles_for(Side::Order).unwrap(),material::TextureSet::On)];
    // AssetServer deduplicates the same dedicated DDS path. Model that sharing
    // here so a real reload cannot preserve another resource using stale bytes.
    let shared_sparkle=resources[0].bindings.textures.sparkle.clone();
    for resource in &mut resources {resource.bindings.textures.sparkle=shared_sparkle.clone();}
    world.insert_resource(Profile {resources,events:default()});world.insert_resource(images);world.insert_resource(fog);
    world.insert_resource(Assets::<Mesh>::default());world.insert_resource(Assets::<material::NexusMaterial>::default());
    world.insert_resource(crate::map10_vision_view::Map10VisionView::native_map10().unwrap());world.insert_resource(Backend::new(2).unwrap());
    let mut host=Host::default();host.frame=crate::nexus_idle_particles::Frame {ordinal:1,session:Some(1),requests:vec![blue.clone(),red.clone()],..default()};
    world.insert_resource(host);synchronize(&mut world);
    assert_eq!(world.resource::<Diagnostics>().error,None);assert_eq!(world.resource::<Diagnostics>().draws,6);
    let before=world.resource::<Backend>().tickets();
    for t in before.iter().filter(|t|t.group==Group::GemSparkle) {
        assert_eq!(world.resource::<Assets<Mesh>>().get(t.mesh).unwrap().count_vertices(),504);
        assert_eq!(world.resource::<Assets<Image>>().get(t.images[0]).unwrap().texture_descriptor.format,TextureFormat::Bc3RgbaUnorm);
        assert!(world.resource::<Assets<material::NexusMaterial>>().get(t.material).unwrap().is_ready());
    }
    world.resource_mut::<Host>().frame.ordinal=2;synchronize(&mut world);
    assert!(world.resource::<Backend>().tickets().iter().all(|n|before.iter().any(|o|o.draw==n.draw && o.mesh==n.mesh && o.material==n.material)));
    let old_blue=blue.owner;blue.owner.effect_id=33;blue.cycle.serial=3;blue.age_seconds=0.;blue.descriptor.resource="Order_Nexus_on.troy".into();
    {let mut h=world.resource_mut::<Host>();h.frame.ordinal=3;h.frame.requests=vec![blue.clone(),red.clone()];}
    synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().error,None);assert_eq!(world.resource::<Diagnostics>().draws,6);
    assert!(before.iter().filter(|t|t.owner==old_blue).all(|t|world.get_entity(t.draw).is_err()));
    assert!(before.iter().filter(|t|t.owner==red.owner).all(|t|world.get_entity(t.draw).is_ok()));
    // Reload of the shared DDS retires every armed resource which depends on
    // those bytes, with no fallback to base-only textures or reauthorization.
    let image=world.resource::<Profile>().resources[1].bindings.textures.handle(Group::GemSparkle).unwrap().id();
    world.init_resource::<Messages<AssetEvent<Image>>>();world.resource_mut::<Messages<AssetEvent<Image>>>().write(AssetEvent::Modified {id:image});
    world.resource_mut::<Host>().frame.ordinal=4;synchronize(&mut world);
    assert_eq!(world.resource::<Diagnostics>().draws,0);assert_eq!(world.resource::<Diagnostics>().issues.len(),2);
    assert!(world.resource::<Profile>().resources.iter().all(|r|r.invalidated));
    world.resource_mut::<Host>().frame.ordinal=5;synchronize(&mut world);assert_eq!(world.resource::<Diagnostics>().draws,0);
    {let mut h=world.resource_mut::<Host>();h.frame.ordinal=6;h.frame.requests.clear();}
    synchronize(&mut world);assert_eq!(world.resource::<Backend>().owner_count(),0);
}
