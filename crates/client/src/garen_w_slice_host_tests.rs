//! CPU/ECS fixtures plus real pinned DDS/SKL mapping bytes. No GPU or native animation run.
use super::*;
use bevy::{asset::{AssetApp,AssetPlugin,RenderAssetUsages},
    image::{CompressedImageFormats,ImageType,ImageSampler,ImageSamplerDescriptor},
    mesh::{PrimitiveTopology,VertexAttributeValues},gltf::GltfPrimitive};
use openleague_core::{Navigation,Simulation};

struct Fixture {
    app:App,model:Handle<Gltf>,mesh:Handle<Mesh>,bind:Handle<SkinnedMeshInverseBindposes>,
    mapping:Mapping,roots:Vec<Entity>,primitives:Vec<Entity>,source_joints:Vec<Vec<Entity>>,
}
fn local(words:[u32;10])->Transform {
    let v=words.map(f32::from_bits);
    Transform {translation:Vec3::from_slice(&v[..3]),scale:Vec3::from_slice(&v[3..6]),rotation:Quat::from_array(v[6..].try_into().unwrap())}
}
fn frame()->native::Frame {
    native::Frame {position:[60.,40.,80.].map(f32::to_bits),right:[1.,0.,0.].map(f32::to_bits),
        up:[0.,1.,0.].map(f32::to_bits),scale:1.03f32.to_bits(),matrix:Mat4::IDENTITY.to_cols_array().map(f32::to_bits)}
}
fn inputs()->slice::Inputs {
    slice::Inputs {uv_scale_offset:Vec4::new(1.,1.,0.,0.),color_lookup:Vec2::new(0.5,0.08),
        color_factor:Vec4::ONE,slice_range:Vec2::new(0.04,625.),fog_scale_offset:Vec4::new(0.1,0.1,0.,0.),
        output_encoding:slice::OutputEncoding::RawNumeric}
}
fn snapshot()->openleague_core::Snapshot {
    let mut cells=Vec::new();for _ in 0..16 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());
        cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,&cells).unwrap();
    let mut game=Simulation::new(nav).unwrap();game.session=7;game.join("garen").unwrap();game.join("garen").unwrap();game.snapshot()
}
impl Fixture {
    fn new()->Self {
        let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default(),bevy::camera::visibility::VisibilityPlugin))
            .init_asset::<Gltf>().init_asset::<GltfMesh>().init_asset::<GltfSkin>().init_asset::<Mesh>()
            .init_asset::<SkinnedMeshInverseBindposes>().init_asset::<Image>().init_asset::<StandardMaterial>()
            .init_asset::<slice::SliceMaterial>().init_resource::<Host>().init_resource::<Requests>().init_resource::<Readiness>();
        let mapping=Mapping::original().unwrap();
        let binds:Vec<_>=mapping.joints.iter().map(|s|Mat4::from_cols_array(&s.bind_words.map(f32::from_bits))).collect();
        let bind=app.world_mut().resource_mut::<Assets<SkinnedMeshInverseBindposes>>().add(binds);
        let mut geometry=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
        geometry.insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,0.,0.],[1.,0.,0.],[0.,1.,0.]]);
        geometry.insert_attribute(Mesh::ATTRIBUTE_NORMAL,vec![[0.,0.,1.];3]);
        geometry.insert_attribute(Mesh::ATTRIBUTE_UV_0,vec![[0.,0.],[1.,0.],[0.,1.]]);
        geometry.insert_attribute(Mesh::ATTRIBUTE_JOINT_INDEX,VertexAttributeValues::Uint16x4(vec![[0u16;4];3]));
        geometry.insert_attribute(Mesh::ATTRIBUTE_JOINT_WEIGHT,vec![[1.,0.,0.,0.];3]);
        geometry.generate_skinned_mesh_bounds().unwrap();
        let mesh=app.world_mut().resource_mut::<Assets<Mesh>>().add(geometry);
        let gltf_mesh=app.world_mut().resource_mut::<Assets<GltfMesh>>().add(GltfMesh {
            index:0,name:"CPU fixture".into(),primitives:vec![GltfPrimitive {index:0,parent_mesh_index:0,name:"CPU triangle".into(),
            mesh:mesh.clone(),material:None,extras:None,material_extras:None}],extras:None});
        let skin=app.world_mut().resource_mut::<Assets<GltfSkin>>().add(GltfSkin {index:0,name:"CPU fixture".into(),
            joints:vec![Handle::default();JOINTS],inverse_bind_matrices:bind.clone(),extras:None});
        let model=app.world_mut().resource_mut::<Assets<Gltf>>().add(Gltf {
            scenes:vec![],named_scenes:default(),meshes:vec![gltf_mesh],named_meshes:default(),materials:vec![],named_materials:default(),
            nodes:vec![],named_nodes:default(),skins:vec![skin],named_skins:default(),default_scene:None,
            animations:vec![],named_animations:default(),source:None});
        let sampler=ImageSamplerDescriptor::linear();
        let textures=slice::LinearTextures::load(app.world().resource::<AssetServer>(),sampler.clone(),sampler.clone()).unwrap();
        let original:[&[u8];2]=[
            include_bytes!("../../../assets/champions/garen/effects/slice_linear/Garen_Base_W_Scroll.dds"),
            include_bytes!("../../../assets/champions/garen/effects/slice_linear/alpha_20.dds")];
        for (handle,bytes) in textures.handles().into_iter().zip(original) {
            let image=Image::from_buffer(bytes,ImageType::Extension("dds"),CompressedImageFormats::BC,false,
                ImageSampler::Descriptor(sampler.clone()),RenderAssetUsages::default()).unwrap();
            app.world_mut().resource_mut::<Assets<Image>>().insert(handle.id(),image).unwrap();
        }
        let visibility=app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
        let overlay=app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
        // Explicit diagnostic budget, not a native precision guarantee or production tuning.
        let profile=Profile::new(model.clone(),textures,visibility,overlay,1,ResidualBudget {absolute:0.0002,relative:0.00002}).unwrap();
        app.insert_resource(profile);
        let mut state=crate::Match::default();state.snapshot=Some(snapshot());app.insert_resource(state);
        let mut f=Self {app,model,mesh,bind,mapping,roots:vec![],primitives:vec![],source_joints:vec![]};
        f.actor(1);f.actor(2);f
    }
    fn actor(&mut self,id:u32) {
        let t=Transform::from_xyz(3.+id as f32,2.,4.).with_scale(Vec3::splat(0.05)).with_rotation(Quat::from_rotation_y(0.7));
        let root=self.app.world_mut().spawn((crate::actor_fow::Root,Visibility::Visible,t,GlobalTransform::from(t),
            AnimationPlayer::default(),crate::animation::material_test_playback(id,self.model.clone()))).id();
        let wrapper=self.app.world_mut().spawn((ChildOf(root),Name::new("skinned_mesh"),Transform::IDENTITY,GlobalTransform::from(t))).id();
        let joints:Vec<_>=self.mapping.joints.iter().map(|j|self.app.world_mut().spawn((Name::new(j.name.clone()),
            local(j.local_words),GlobalTransform::IDENTITY)).id()).collect();
        for (i,spec) in self.mapping.joints.iter().enumerate() {
            let parent=if spec.parent<0 {wrapper}else{joints[spec.parent as usize]};
            self.app.world_mut().entity_mut(joints[i]).insert(ChildOf(parent));
        }
        let material=self.app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial::default());
        let primitive=self.app.world_mut().spawn((ChildOf(wrapper),Transform::IDENTITY,GlobalTransform::from(t),Visibility::Inherited,
            Mesh3d(self.mesh.clone()),MeshMaterial3d(material.clone()),crate::actor_fow::Bound {source:material},
            SkinnedMesh {inverse_bindposes:self.bind.clone(),joints:joints.clone()})).id();
        self.app.world_mut().resource_mut::<crate::Match>().visuals.insert(id,root);
        self.roots.push(root);self.primitives.push(primitive);self.source_joints.push(joints);
    }
    fn request(&self,index:usize,effect:u64)->Request {
        Request {key:Key {session:7,effect,source:index as u32+1,root:self.roots[index]},frame:frame(),inputs:inputs(),render_ready:false}
    }
    fn run(&mut self,rows:Vec<Request>) {
        self.app.world_mut().resource_mut::<Requests>().replace(Some(7),rows).unwrap();synchronize(self.app.world_mut());
    }
    fn host(&self)->&Host {self.app.world().resource::<Host>()}
    /// Injected acknowledgement for CPU ownership tests only; no GPU-readiness proof.
    fn ack_current(&mut self) {
        let gate=self.app.world().resource::<Readiness>();gate.publish_ready(gate.pending().unwrap()).unwrap();
    }
    fn assert_empty(&mut self) {
        assert_eq!(self.host().owners(),0);assert_eq!(self.host().private_joints(),0);
        let mut q=self.app.world_mut().query_filtered::<Entity,With<Draw>>();assert_eq!(q.iter(self.app.world()).count(),0);
        let mut q=self.app.world_mut().query_filtered::<Entity,With<PrivateJoint>>();assert_eq!(q.iter(self.app.world()).count(),0);
    }
}

#[test]
fn slice_private_68_palette_preserves_two_actor_sources_and_warms_up_without_pixels() {
    let mut f=Fixture::new();
    let before:Vec<_>=f.source_joints.iter().flatten().map(|e|(*e,*f.app.world().get::<Transform>(*e).unwrap(),
        *f.app.world().get::<GlobalTransform>(*e).unwrap())).collect();
    let material=f.app.world().get::<MeshMaterial3d<StandardMaterial>>(f.primitives[0]).unwrap().0.clone();
    f.run(vec![f.request(0,10)]);assert!(f.host().issues.is_empty(),"{:?}",f.host().issues);
    assert_eq!(f.host().owners(),1);assert_eq!(f.host().private_joints(),68);assert_eq!(f.host().published(),0);
    let e=f.host().entries.values().next().unwrap();
    assert_eq!(f.app.world().get::<Visibility>(e.draw),Some(&Visibility::Inherited));
    assert_eq!(f.app.world().get::<SkinnedMesh>(e.draw).unwrap().inverse_bindposes,f.bind);
    for j in &e.joints {assert!(f.app.world().get::<Transform>(*j).is_none());assert!(f.app.world().get::<ChildOf>(*j).is_none());}
    for (entity,t,g) in before {assert_eq!(*f.app.world().get::<Transform>(entity).unwrap(),t);assert_eq!(*f.app.world().get::<GlobalTransform>(entity).unwrap(),g);}
    assert_eq!(f.app.world().get::<MeshMaterial3d<StandardMaterial>>(f.primitives[0]).unwrap().0,material);
    assert!(f.app.world().get::<AnimationPlayer>(f.roots[0]).is_some());
    assert_eq!(f.app.world().get::<SkinnedMesh>(f.primitives[1]).unwrap().joints,f.source_joints[1]);
    f.run(vec![]);f.assert_empty();
}

#[test]
fn slice_two_effects_are_disjoint_and_request_removal_retires_only_its_owner() {
    let mut f=Fixture::new();let mut a=f.request(0,10);a.render_ready=true; // injected readiness; no GPU claim
    f.run(vec![a.clone(),f.request(1,20)]);assert_eq!(f.host().owners(),2);assert_eq!(f.host().published(),0);
    f.ack_current();f.run(vec![a,f.request(1,20)]);assert_eq!(f.host().published(),1);
    let entries:Vec<_>=f.host().entries.values().collect();assert_ne!(entries[0].material,entries[1].material);
    assert!(entries[0].joints.iter().all(|j|!entries[1].joints.contains(j)));
    let retained=f.host().entries[&(f.request(1,20).key,f.primitives[1])].draw;
    f.run(vec![f.request(1,20)]);assert_eq!(f.host().owners(),1);assert_eq!(f.host().entries.values().next().unwrap().draw,retained);
    clear(f.app.world_mut());f.assert_empty();
}

#[test]
fn slice_animated_local_nonuniform_scale_updates_private_palette_without_decomposing_globals() {
    let mut f=Fixture::new();let request=f.request(0,10);f.run(vec![request.clone()]);assert!(f.host().issues.is_empty());
    let entry=f.host().entries.values().next().unwrap().clone();
    let before:Vec<_>=entry.joints.iter().map(|e|f.app.world().get::<GlobalTransform>(*e).unwrap().to_matrix()).collect();
    let weapon=f.mapping.joints.iter().position(|j|j.name=="Weapon").unwrap();
    f.app.world_mut().get_mut::<Transform>(f.source_joints[0][weapon]).unwrap().scale=Vec3::new(2.2306952,1.,1.);
    // Globals are deliberately unrelated sentinel matrices: host must consume locals.
    let sentinel=GlobalTransform::from(Mat4::from_cols(Vec4::X,Vec4::new(0.7,1.,0.,0.),Vec4::Z,Vec4::W));
    f.app.world_mut().entity_mut(f.source_joints[0][weapon]).insert(sentinel);
    f.run(vec![request]);assert!(f.host().issues.is_empty(),"{:?}",f.host().issues);
    assert_ne!(f.app.world().get::<GlobalTransform>(entry.joints[weapon]).unwrap().to_matrix(),before[weapon]);
    assert_eq!(*f.app.world().get::<GlobalTransform>(f.source_joints[0][weapon]).unwrap(),sentinel);
    assert!(f.host().maximum_residual.is_finite());
}

#[test]
fn slice_hidden_death_session_and_no_refresh_all_retire_without_old_request_replay() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);
    f.app.world_mut().entity_mut(f.roots[0]).insert(Visibility::Hidden);f.run(vec![r.clone()]);f.assert_empty();
    f.app.world_mut().entity_mut(f.roots[0]).insert(Visibility::Visible);synchronize(f.app.world_mut());f.assert_empty();
    f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);
    f.app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().players[0].health=0.;
    f.run(vec![r.clone()]);f.assert_empty();
    f.app.world_mut().resource_mut::<crate::Match>().snapshot=Some(snapshot());f.run(vec![r.clone()]);
    f.app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().session=8;
    f.run(vec![r]);f.assert_empty();
}

#[test]
fn slice_source_despawn_and_missing_profile_retire_all_private_entities() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);
    f.app.world_mut().despawn(f.primitives[0]);f.run(vec![r]);f.assert_empty();
    f.run(vec![f.request(1,20)]);assert_eq!(f.host().owners(),1);
    let request=f.request(1,20);
    f.app.world_mut().resource_mut::<Requests>().replace(Some(7),vec![request]).unwrap();
    let profile=f.app.world_mut().remove_resource::<Profile>().unwrap();synchronize(f.app.world_mut());f.assert_empty();
    f.app.world_mut().insert_resource(profile);synchronize(f.app.world_mut());f.assert_empty();
    // Even a fresh request needs an externally revalidated generation after the gap.
    f.run(vec![f.request(1,20)]);f.assert_empty();
    f.app.world_mut().resource_mut::<Profile>().verified_generation=2;
    f.run(vec![f.request(1,20)]);assert_eq!(f.host().owners(),1);
}

#[test]
fn slice_reload_requires_new_verified_generation_and_rejects_old_generation() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);let old=f.host().entries.values().next().unwrap().draw;
    f.app.world_mut().write_message(AssetEvent::Modified {id:f.mesh.id()});f.run(vec![r.clone()]);f.assert_empty();
    f.run(vec![r.clone()]);f.assert_empty();
    f.app.world_mut().resource_mut::<Profile>().verified_generation=2;f.run(vec![r.clone()]);
    assert_eq!(f.host().owners(),1);assert_ne!(old,f.host().entries.values().next().unwrap().draw);
    f.app.world_mut().resource_mut::<Profile>().verified_generation=1;f.run(vec![r]);f.assert_empty();
}

#[test]
fn slice_bad_joint_order_parent_and_external_root_parent_fail_closed() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);
    let joints=f.source_joints[0].clone();f.app.world_mut().get_mut::<SkinnedMesh>(f.primitives[0]).unwrap().joints.swap(0,1);
    f.run(vec![r.clone()]);f.assert_empty();f.app.world_mut().get_mut::<SkinnedMesh>(f.primitives[0]).unwrap().joints=joints.clone();
    f.app.world_mut().entity_mut(joints[1]).insert(ChildOf(f.roots[0]));f.run(vec![r.clone()]);f.assert_empty();
    f.app.world_mut().entity_mut(joints[1]).insert(ChildOf(joints[f.mapping.joints[1].parent as usize]));
    let outside=f.app.world_mut().spawn(Transform::from_scale(Vec3::splat(2.))).id();
    f.app.world_mut().entity_mut(f.roots[0]).insert(ChildOf(outside));f.run(vec![r]);f.assert_empty();
}

#[test]
fn slice_nonfinite_late_joint_or_inputs_never_publish_partial_private_updates() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);
    f.app.world_mut().get_mut::<Transform>(f.source_joints[0][67]).unwrap().translation.x=f32::NAN;
    f.run(vec![r.clone()]);f.assert_empty();
    f.app.world_mut().entity_mut(f.source_joints[0][67]).insert(local(f.mapping.joints[67].local_words));
    let mut bad=r;bad.inputs.slice_range.x=f32::NAN;f.run(vec![bad]);f.assert_empty();
}

#[test]
fn slice_render_only_fog_uses_exact_gpu_ack_and_changed_inverse_bind_never_falls_back() {
    let mut f=Fixture::new();let mut r=f.request(0,10);r.render_ready=true;f.run(vec![r.clone()]);f.ack_current();
    f.run(vec![r.clone()]);assert_eq!(f.host().published(),1);
    let overlay=f.app.world().resource::<Profile>().overlay.clone();f.app.world_mut().resource_mut::<Assets<Image>>().remove(overlay.id());
    // CPU absence is valid for a RENDER_WORLD-only image; the injected GPU ack remains separate.
    f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);assert_eq!(f.host().published(),1);
    f.app.world().resource::<Readiness>().publish_ready(vec![]).unwrap();
    f.run(vec![r.clone()]);assert_eq!(f.host().published(),0);
    f.app.world_mut().resource_mut::<Assets<SkinnedMeshInverseBindposes>>().insert(f.bind.id(),vec![Mat4::IDENTITY;JOINTS].into()).unwrap();
    f.run(vec![r]);f.assert_empty();
}

#[test]
fn slice_inverse_bind_cancellation_rejects_singular_and_retains_affine_shear() {
    let mapping=Mapping::original().unwrap();let palette:Vec<_>=mapping.joints.iter().map(|j|native::Transform(j.local_words).to_joint()).collect();
    let mut bind:Vec<_>=mapping.joints.iter().map(|j|Mat4::from_cols_array(&j.bind_words.map(f32::from_bits))).collect();
    let budget=ResidualBudget {absolute:0.0002,relative:0.00002};
    bind[0]=Mat4::from_cols(Vec4::X,Vec4::new(0.7,1.,0.,0.),Vec4::Z,Vec4::W);
    let (globals,residual)=private_globals(&palette,&bind,budget).unwrap();assert!(residual.is_finite());
    let expected=Mat4::from_scale(Vec3::splat(0.05))*palette_matrix(native::Transform::from_joint(&palette[0])).unwrap();
    let reconstructed=globals[0].affine()*bind[0];
    assert!(reconstructed.to_cols_array().into_iter().zip(expected.to_cols_array()).all(|(a,b)|(a-b).abs()<0.0002));
    bind[67]=Mat4::ZERO;assert!(private_globals(&palette,&bind,budget).is_err());
}

#[test]
fn slice_duplicate_batch_and_source_model_change_remove_previous_draw() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);
    assert!(f.app.world_mut().resource_mut::<Requests>().replace(Some(7),vec![r.clone(),r.clone()]).is_err());
    synchronize(f.app.world_mut());f.assert_empty();f.run(vec![r.clone()]);
    let other=f.app.world().resource::<Assets<Gltf>>().reserve_handle();
    f.app.world_mut().entity_mut(f.roots[0]).insert(crate::animation::material_test_playback(1,other));
    f.run(vec![r]);f.assert_empty();
}

#[test]
fn slice_exact_readiness_does_not_survive_retirement_recreation_or_changed_fog() {
    let mut f=Fixture::new();let mut r=f.request(0,10);r.render_ready=true;
    f.run(vec![r.clone()]);let gate=f.app.world().resource::<Readiness>().clone();
    let old=gate.pending().unwrap();f.ack_current();f.run(vec![r.clone()]);assert_eq!(f.host().published(),1);
    f.run(vec![]);assert!(gate.pending().unwrap().is_empty());
    gate.publish_ready(old.clone()).unwrap();f.run(vec![r.clone()]);assert_eq!(f.host().published(),0);
    let fresh=gate.pending().unwrap();assert_ne!(old[0].draw,fresh[0].draw);assert_ne!(old[0].material,fresh[0].material);
    gate.publish_ready(old).unwrap();f.run(vec![r.clone()]);assert_eq!(f.host().published(),0);
    gate.publish_ready(fresh).unwrap();f.run(vec![r.clone()]);assert_eq!(f.host().published(),1);
    let image=f.app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
    f.app.world_mut().resource_mut::<Profile>().visibility=image;
    f.run(vec![r.clone()]);assert_eq!(f.host().published(),0);
    f.ack_current();f.run(vec![r.clone()]);assert_eq!(f.host().published(),1);
    f.app.world_mut().remove_resource::<Readiness>();f.run(vec![r]);assert_eq!(f.host().published(),0);
}

#[test]
fn slice_missing_dynamic_bounds_fails_closed_without_altering_shared_mesh() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);
    f.app.world_mut().resource_mut::<Assets<Mesh>>().get_mut(&f.mesh).unwrap().set_skinned_mesh_bounds(None);
    f.run(vec![r]);f.assert_empty();assert!(f.host().issues.values().any(|s|s.contains("dynamic skinned mesh bounds")));
    assert!(f.app.world().resource::<Assets<Mesh>>().get(&f.mesh).unwrap().skinned_mesh_bounds().is_none());
}

#[test]
fn slice_real_bevy_dynamic_bounds_consume_private_global_only_joints() {
    use bevy::{camera::{primitives::Aabb,visibility::NoFrustumCulling},math::Vec3A};
    let mut f=Fixture::new();f.run(vec![f.request(0,10)]);
    let entry=f.host().entries.values().next().unwrap().clone();
    // Execute Bevy's actual CalculateBounds/Visibility systems, no renderer or mock bounds.
    f.app.world_mut().run_schedule(PostUpdate);
    let bounds=*f.app.world().get::<Aabb>(entry.draw).unwrap();
    assert!(f.app.world().get::<NoFrustumCulling>(entry.draw).is_none());
    let draw=f.app.world().get::<GlobalTransform>(entry.draw).unwrap();
    let private=f.app.world().get::<GlobalTransform>(entry.joints[0]).unwrap();
    let bind=f.app.world().resource::<Assets<SkinnedMeshInverseBindposes>>().get(&f.bind).unwrap();
    let world_from_mesh=private.affine()*Affine3A::from_mat4(bind[0]);
    for v in [Vec3::ZERO,Vec3::X,Vec3::Y] {
        let local=draw.affine().inverse().transform_point3(world_from_mesh.transform_point3(v));
        let distance=(Vec3A::from(local)-bounds.center).abs();
        assert!(distance.cmple(bounds.half_extents+Vec3A::splat(0.0001)).all());
    }
    // The source identity sentinels remain untouched even after this real system schedule.
    for entity in &f.source_joints[0] {assert_eq!(*f.app.world().get::<GlobalTransform>(*entity).unwrap(),GlobalTransform::IDENTITY);}
}

#[test]
fn slice_waiting_for_primitive_consumes_request_and_uses_only_fresh_pose_and_inputs() {
    let mut f=Fixture::new();let old=f.request(0,10);let primitive=f.primitives[0];
    let bound=f.app.world_mut().entity_mut(primitive).take::<crate::actor_fow::Bound>().unwrap();
    f.run(vec![old.clone()]);f.assert_empty();assert!(f.host().issues.is_empty());
    assert_eq!(f.host().installed,0);
    assert!(f.app.world().resource::<Requests>().rows.is_empty());
    assert_eq!(f.app.world().resource::<Requests>().session,None);
    assert!(f.app.world().resource::<Readiness>().pending().unwrap().is_empty());
    assert!(f.app.world().resource::<Assets<slice::SliceMaterial>>().is_empty());
    f.app.world_mut().entity_mut(primitive).insert(bound);
    // Becoming loaded is insufficient: the producer must still submit this frame.
    synchronize(f.app.world_mut());f.assert_empty();assert!(f.host().issues.is_empty());
    let mut fresh=old.clone();fresh.frame.position[0]=160f32.to_bits();
    // A later age-derived lookup supplied by the producer, not a host-owned timer.
    fresh.inputs.color_lookup=Vec2::new(1.05,0.08);
    let profile=f.app.world().resource::<Profile>().clone();
    let expected=collect(f.app.world(),&profile,&fresh,primitive).unwrap();
    let stale=collect(f.app.world(),&profile,&old,primitive).unwrap();
    assert_ne!(expected.globals[0],stale.globals[0]);
    f.run(vec![fresh.clone()]);assert!(f.host().issues.is_empty());assert_eq!(f.host().owners(),1);
    let entry=f.host().entries.values().next().unwrap();
    for (&joint,global) in entry.joints.iter().zip(expected.globals) {
        assert_eq!(*f.app.world().get::<GlobalTransform>(joint).unwrap(),global);
    }
    let expected_material=slice::SliceMaterial::new(&profile.textures,profile.visibility,profile.overlay,fresh.inputs).unwrap();
    // Inspect all opaque uniform values via the material's derived Debug; no GPU claim.
    let actual=f.app.world().resource::<Assets<slice::SliceMaterial>>().get(&entry.material).unwrap();
    assert_eq!(format!("{actual:?}"),format!("{expected_material:?}"));
    f.run(vec![]);f.assert_empty();
}

#[test]
fn slice_primitive_gap_retires_ack_and_does_not_bypass_profile_revalidation() {
    let mut f=Fixture::new();let mut r=f.request(0,10);r.render_ready=true;
    f.run(vec![r.clone()]);let gate=f.app.world().resource::<Readiness>().clone();
    let old=gate.pending().unwrap();f.ack_current();f.run(vec![r.clone()]);assert_eq!(f.host().published(),1);
    let primitive=f.primitives[0];
    let bound=f.app.world_mut().entity_mut(primitive).take::<crate::actor_fow::Bound>().unwrap();
    f.run(vec![r.clone()]);f.assert_empty();assert!(f.host().issues.is_empty());
    assert!(gate.pending().unwrap().is_empty());assert!(!gate.accepts(&old[0]));
    assert!(f.app.world().resource::<Assets<slice::SliceMaterial>>().is_empty());
    gate.publish_ready(old.clone()).unwrap();
    f.app.world_mut().write_message(AssetEvent::Modified {id:f.mesh.id()});
    f.run(vec![r.clone()]);f.assert_empty();
    assert!(f.host().issues.values().any(|s|s.contains("new verified profile generation")));
    f.app.world_mut().entity_mut(primitive).insert(bound);
    f.run(vec![r.clone()]);f.assert_empty(); // Old generation remains blocked after attachment.
    f.app.world_mut().resource_mut::<Profile>().verified_generation=2;
    synchronize(f.app.world_mut());f.assert_empty(); // No retained request from waiting/error.
    f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);assert_eq!(f.host().published(),0);
    let current=gate.pending().unwrap();assert_eq!(current[0].generation,2);
    assert_ne!(old[0].draw,current[0].draw);assert_ne!(old[0].material,current[0].material);
    gate.publish_ready(old).unwrap();f.run(vec![r.clone()]);assert_eq!(f.host().published(),0);
    gate.publish_ready(current).unwrap();f.run(vec![r]);assert_eq!(f.host().published(),1);
    clear(f.app.world_mut());f.assert_empty();
}

#[test]
fn slice_multiple_loaded_primitives_remain_an_error_and_retire_previous_draw() {
    let mut f=Fixture::new();let r=f.request(0,10);f.run(vec![r.clone()]);assert_eq!(f.host().owners(),1);
    let primitive=f.primitives[0];let parent=f.app.world().get::<ChildOf>(primitive).unwrap().parent();
    let skin=f.app.world().get::<SkinnedMesh>(primitive).unwrap().clone();
    let source=f.app.world().get::<crate::actor_fow::Bound>(primitive).unwrap().source.clone();
    let duplicate=f.app.world_mut().spawn((ChildOf(parent),Transform::IDENTITY,GlobalTransform::IDENTITY,
        Mesh3d(f.mesh.clone()),skin,crate::actor_fow::Bound {source})).id();
    f.run(vec![r]);f.assert_empty();
    assert!(f.host().issues.values().any(|s|s=="Slice needs exactly one loaded source primitive"));
    assert!(f.app.world().get_entity(primitive).is_ok());assert!(f.app.world().get_entity(duplicate).is_ok());
    assert!(f.app.world().resource::<Readiness>().pending().unwrap().is_empty());
}

#[test]
fn slice_hierarchy_retirement_tolerates_gone_private_entities_and_preserves_other_owner() {
    let mut f=Fixture::new();let a=f.request(0,10);let b=f.request(1,20);f.run(vec![a.clone(),b.clone()]);
    let first=f.host().entries[&(a.key,f.primitives[0])].clone();
    let second=f.host().entries[&(b.key,f.primitives[1])].clone();
    assert!(f.app.world_mut().despawn(f.roots[0])); // Real Bevy ChildOf cascade removes first.draw.
    assert!(f.app.world().get_entity(first.draw).is_err());
    assert!(f.app.world_mut().despawn(first.joints[0]));
    let unrelated=f.app.world_mut().spawn(Name::new("must survive exact-entity retirement")).id();
    assert_ne!(unrelated,first.draw);assert_ne!(unrelated,first.joints[0]);
    f.run(vec![b.clone()]);assert_eq!(f.host().owners(),1);assert_eq!(f.host().retired,1);
    assert!(first.joints.iter().all(|j|f.app.world().get_entity(*j).is_err()));
    assert!(f.app.world().resource::<Assets<slice::SliceMaterial>>().get(&first.material).is_none());
    assert_eq!(f.host().entries[&(b.key,f.primitives[1])].draw,second.draw);
    assert!(second.joints.iter().all(|j|f.app.world().get_entity(*j).is_ok()));
    assert!(f.app.world().resource::<Assets<slice::SliceMaterial>>().get(&second.material).is_some());
    assert!(f.app.world().get_entity(unrelated).is_ok());
    clear(f.app.world_mut());f.assert_empty();assert_eq!(f.host().retired,2);
    clear(f.app.world_mut());assert_eq!(f.host().retired,2);
    assert!(f.app.world().get_entity(unrelated).is_ok());
    assert!(f.app.world().get::<AnimationPlayer>(f.roots[1]).is_some());
}

#[test]
fn slice_primitive_wait_does_not_hide_stale_actor_or_invalid_inputs() {
    let mut f=Fixture::new();let r=f.request(0,10);
    f.app.world_mut().entity_mut(f.primitives[0]).remove::<crate::actor_fow::Bound>();
    f.app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().session=8;
    f.run(vec![r.clone()]);f.assert_empty();
    assert!(f.host().issues.values().any(|s|s.contains("current session/root")));
    f.app.world_mut().resource_mut::<crate::Match>().snapshot=Some(snapshot());
    f.app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().players[0].health=0.;
    f.run(vec![r.clone()]);f.assert_empty();
    assert!(f.host().issues.values().any(|s|s.contains("dead or not base Garen")));
    f.app.world_mut().resource_mut::<crate::Match>().snapshot=Some(snapshot());
    let mut invalid=r;invalid.inputs.color_lookup.x=f32::NAN;
    f.run(vec![invalid]);f.assert_empty();assert!(!f.host().issues.is_empty());
}
