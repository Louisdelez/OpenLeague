//! Explicit-request Slice host. No emission, timer, clip selection or gameplay decision.
//! Schedule after TransformSystems::Propagate AND AssetEventSystems,
//! before CalculateBounds/VisibilityPropagate.
use bevy::{prelude::*, asset::{Asset, AssetEvent,AssetId}, ecs::message::MessageCursor,
    math::Affine3A,
    gltf::{GltfMesh,GltfSkin}, mesh::skinning::{SkinnedMesh,SkinnedMeshInverseBindposes},
    camera::visibility::{DynamicSkinnedMeshBounds,RenderLayers,VisibilityRange}};
use std::{collections::{BTreeMap,HashSet},sync::{Arc,Mutex}};
use openleague_core::{native_simple_type11_draw as native,native_simple_type11_pose as pose};
use crate::garen_w_slice_material as slice;

const JOINTS:usize=68;
#[derive(Clone,serde::Deserialize)]
struct JointSpec { name:String,parent:i16,inverse_words:[u32;10],bind_words:[u32;16],local_words:[u32;10] }
#[derive(Clone,serde::Deserialize)]
struct Mapping { skeleton:u64,joints:Vec<JointSpec> }
impl Mapping {
    fn original()->Result<Self,String> {
        let value:Self=serde_json::from_str(include_str!("../../../data/4.20/garen_slice_joint_mapping.json")).map_err(|e|e.to_string())?;
        if value.skeleton==0 || value.joints.len()!=JOINTS
            || value.joints.iter().map(|j|j.name.as_str()).collect::<HashSet<_>>().len()!=JOINTS
            || value.joints.iter().any(|j|j.parent < -1 || j.parent>=JOINTS as i16) {
            return Err("invalid pinned Garen joint mapping".into());
        }
        Ok(value)
    }
}

/// Numerical acceptance budget must be supplied from the integration qualification.
#[derive(Clone,Copy,Debug)]
pub struct ResidualBudget {pub absolute:f32,pub relative:f32}
#[derive(Resource,Clone)]
pub struct Profile {
    pub model:Handle<Gltf>,
    pub textures:slice::LinearTextures,
    pub visibility:Handle<Image>,
    pub overlay:Handle<Image>,
    /// Increase only after revalidating reloaded source assets against their provenance.
    pub verified_generation:u64,
    mapping:Mapping,
    budget:ResidualBudget,
}
impl Profile {
    pub fn new(model:Handle<Gltf>,textures:slice::LinearTextures,visibility:Handle<Image>,overlay:Handle<Image>,
        verified_generation:u64,budget:ResidualBudget)->Result<Self,String> {
        if verified_generation==0 || !budget.absolute.is_finite() || !budget.relative.is_finite()
            || budget.absolute<0. || budget.relative<0. {return Err("invalid Slice profile generation/budget".into())}
        Ok(Self {model,textures,visibility,overlay,verified_generation,mapping:Mapping::original()?,budget})
    }
}

#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord,Hash)]
pub struct Key {pub session:u64,pub effect:u64,pub source:u32,pub root:Entity}

/// Exact instance identity shared with RenderApp. Never acknowledge by Key alone.
#[derive(Component,Clone,Debug,PartialEq,Eq,Hash)]
pub struct Ticket {
    pub key:Key,pub draw:Entity,pub generation:u64,
    pub material:AssetId<slice::SliceMaterial>,pub images:[AssetId<Image>;4],
    pub mesh:AssetId<Mesh>,pub inverse_bind:AssetId<SkinnedMeshInverseBindposes>,
}
#[derive(Default)]
struct ReadinessState {pending:HashSet<Ticket>,ready:HashSet<Ticket>}
/// Install this same Arc clone in main world and RenderApp. A poisoned channel fails closed.
#[derive(Resource,Clone,Default)]
pub struct Readiness(Arc<Mutex<ReadinessState>>);
impl Readiness {
    pub fn pending(&self)->Result<Vec<Ticket>,&'static str> {
        let state=self.0.lock().map_err(|_|"Slice readiness channel poisoned")?;
        Ok(state.pending.iter().cloned().collect())
    }
    /// Replace, do not append: missing GPU assets/pipeline or FoW revoke old acknowledgements.
    /// Caller qualifies all ticket fields against the current render-world entities/assets.
    pub fn publish_ready(&self,tickets:Vec<Ticket>)->Result<(),&'static str> {
        let mut state=self.0.lock().map_err(|_|"Slice readiness channel poisoned")?;
        state.ready=tickets.into_iter().filter(|t|state.pending.contains(t)).collect();Ok(())
    }
    fn accepts(&self,ticket:&Ticket)->bool {
        self.0.lock().is_ok_and(|s|s.pending.contains(ticket)&&s.ready.contains(ticket))
    }
    fn retain(&self,tickets:Vec<Ticket>) {
        if let Ok(mut state)=self.0.lock() {
            let pending:HashSet<_>=tickets.into_iter().collect();
            state.ready.retain(|t|pending.contains(t));state.pending=pending;
        }
    }
}
#[derive(Clone,Debug)]
pub struct Request {
    pub key:Key,
    pub frame:native::Frame,
    pub inputs:slice::Inputs,
    /// False permits extraction warmup with shader discard; true needs the real
    /// pipeline/images/FoW completion observed by the producer's render readiness gate.
    pub render_ready:bool,
}
#[derive(Resource,Default)]
pub struct Requests {session:Option<u64>,rows:Vec<Request>}
impl Requests {
    /// Consumed once by synchronize. The producer must submit current requests every frame.
    /// Invalid replacement clears old requests so stale effects cannot keep drawing.
    pub fn replace(&mut self,session:Option<u64>,rows:Vec<Request>)->Result<(),String> {
        self.session=None;self.rows.clear();
        let mut keys=HashSet::new();
        for r in &rows {
            if Some(r.key.session)!=session || r.key.effect==0 || !keys.insert(r.key) {
                return Err("invalid or duplicate Slice request identity".into());
            }
        }
        if session.is_none() && !rows.is_empty() {return Err("Slice requests need a session".into())}
        self.session=session;self.rows=rows;Ok(())
    }
    pub fn clear(&mut self) {self.session=None;self.rows.clear();}
}

#[derive(Component)]
pub struct Draw;
#[derive(Component)]
struct PrivateJoint;
#[derive(Clone)]
struct Entry {
    draw:Entity,joints:Vec<Entity>,material:Handle<slice::SliceMaterial>,
    source_joints:Vec<Entity>,mesh:Handle<Mesh>,bind:Handle<SkinnedMeshInverseBindposes>,generation:u64,
    model:AssetId<Gltf>,textures:[AssetId<Image>;2],
    published:bool,
}
#[derive(Resource,Default)]
pub struct Host {
    entries:BTreeMap<(Key,Entity),Entry>,
    model_events:MessageCursor<AssetEvent<Gltf>>,
    gltf_mesh_events:MessageCursor<AssetEvent<GltfMesh>>,
    gltf_skin_events:MessageCursor<AssetEvent<GltfSkin>>,
    mesh_events:MessageCursor<AssetEvent<Mesh>>,
    bind_events:MessageCursor<AssetEvent<SkinnedMeshInverseBindposes>>,
    image_events:MessageCursor<AssetEvent<Image>>,
    blocked_generation:Option<u64>,highest_generation:u64,
    pub installed:u64,pub retired:u64,pub updated:u64,
    /// Replaced each synchronization; bounded by the current request list.
    pub issues:BTreeMap<Key,String>,
    pub maximum_residual:f32,
}
impl Host {
    pub fn owners(&self)->usize {self.entries.len()}
    pub fn private_joints(&self)->usize {self.entries.values().map(|e|e.joints.len()).sum()}
    pub fn published(&self)->usize {self.entries.values().filter(|e|e.published).count()}
}

fn changed<T:Asset>(world:&World,cursor:&mut MessageCursor<AssetEvent<T>>,ids:&HashSet<AssetId<T>>)->bool {
    let Some(events)=world.get_resource::<Messages<AssetEvent<T>>>() else{return false};
    cursor.read(events).fold(false,|seen,e|seen | match e {AssetEvent::Modified{id}|AssetEvent::Removed{id}=>ids.contains(id),_=>false})
}

fn retire(world:&mut World,entry:Entry) {
    // Only exact entities created by this registry are retired, never source primitives/joints.
    // ChildOf can already have retired the draw with its source hierarchy. Test
    // the complete Entity (including generation), not only its reusable index.
    if world.get_entity(entry.draw).is_ok() {let _=world.despawn(entry.draw);}
    for joint in entry.joints {
        if world.get_entity(joint).is_ok() {let _=world.despawn(joint);}
    }
    if let Some(mut materials)=world.get_resource_mut::<Assets<slice::SliceMaterial>>() {
        materials.remove(entry.material.id());
    }
}
fn retire_all(world:&mut World,host:&mut Host) {
    for (_,entry) in std::mem::take(&mut host.entries) {retire(world,entry);host.retired+=1;}
    if let Some(readiness)=world.get_resource::<Readiness>() {readiness.retain(Vec::new());}
}

/// Explicit shutdown hook; also runs automatically when Profile/Requests disappear.
pub fn clear(world:&mut World) {
    if let Some(mut requests)=world.get_resource_mut::<Requests>() {requests.clear();}
    let mut host=world.remove_resource::<Host>().unwrap_or_default();
    retire_all(world,&mut host);host.issues.clear();world.insert_resource(host);
}

fn identity_path(world:&World,mut child:Entity,root:Entity)->Result<(),String> {
    let mut seen=HashSet::new();
    while child!=root {
        if !seen.insert(child) || seen.len()>256 {return Err("cyclic/overlong Slice scene ancestry".into())}
        let t=world.get::<Transform>(child).ok_or("Slice wrapper has no local transform")?;
        if *t!=Transform::IDENTITY {return Err("Slice requires the verified identity model wrappers".into())}
        if world.get::<Visibility>(child)==Some(&Visibility::Hidden) {return Err("Slice primitive/wrapper hidden".into())}
        child=world.get::<ChildOf>(child).ok_or("Slice primitive is detached from actor")?.parent();
    }
    Ok(())
}

struct Source {
    primitive:Entity,mesh:Handle<Mesh>,bind:Handle<SkinnedMeshInverseBindposes>,joints:Vec<Entity>,
    globals:Vec<GlobalTransform>,draw_global:GlobalTransform,residual:f32,
}

fn joint_words(t:&Transform)->[u32;10] {
    [t.translation.x,t.translation.y,t.translation.z,t.scale.x,t.scale.y,t.scale.z,
     t.rotation.x,t.rotation.y,t.rotation.z,t.rotation.w].map(f32::to_bits)
}

/// Represent native T/S/Q as a column affine without normalization/decomposition.
/// This representation is not a bit-exact port of a native matrix-conversion routine.
fn palette_matrix(t:native::Transform)->Result<Mat4,String> {
    let v=t.0.map(f32::from_bits);
    if v.iter().any(|f|!f.is_finite()) {return Err("nonfinite native Slice palette".into())}
    let [x,y,z,w]=[v[6],v[7],v[8],v[9]];
    let [xx,yy,zz,xy,xz,yz,wx,wy,wz]=[x*(x+x),y*(y+y),z*(z+z),x*(y+y),x*(z+z),y*(z+z),w*(x+x),w*(y+y),w*(z+z)];
    let m=Mat4::from_cols(
        Vec4::new((1.-yy-zz)*v[3],(xy+wz)*v[3],(xz-wy)*v[3],0.),
        Vec4::new((xy-wz)*v[4],(1.-xx-zz)*v[4],(yz+wx)*v[4],0.),
        Vec4::new((xz+wy)*v[5],(yz-wx)*v[5],(1.-xx-yy)*v[5],0.),
        Vec4::new(v[0],v[1],v[2],1.));
    if !m.is_finite() {return Err("Slice matrix representation overflow".into())} Ok(m)
}

fn private_globals(palette:&[pose::Joint],bind:&[Mat4],budget:ResidualBudget)->Result<(Vec<GlobalTransform>,f32),String> {
    if palette.len()!=JOINTS || bind.len()!=JOINTS {return Err("Slice palette/bind count changed".into())}
    let units=Mat4::from_scale(Vec3::splat(0.05));let mut globals=Vec::with_capacity(JOINTS);let mut maximum=0f32;
    for (joint,b) in palette.iter().zip(bind) {
        if !b.is_finite() || b.row(3)!=Vec4::W || !b.determinant().is_finite() || b.determinant()==0. {
            return Err("Slice inverse-bind is nonaffine or singular".into())
        }
        let expected=units*palette_matrix(native::Transform::from_joint(joint))?;
        // Affine inversion keeps the homogeneous row exact; do not decompose shear.
        let g=Affine3A::from_mat4(expected)*Affine3A::from_mat4(*b).inverse();
        if !g.is_finite() {return Err("Slice private global is nonfinite".into())}
        let global=GlobalTransform::from(Mat4::from(g));let actual=global.affine()* *b;
        for (a,e) in actual.to_cols_array().into_iter().zip(expected.to_cols_array()) {
            let residual=(a-e).abs();maximum=maximum.max(residual);
            if !residual.is_finite() || residual>budget.absolute+budget.relative*a.abs().max(e.abs()) {
                return Err(format!("Slice inverse-bind cancellation residual exceeded budget: {residual}"));
            }
        }
        globals.push(global);
    }
    Ok((globals,maximum))
}

fn validate_actor(world:&World,profile:&Profile,request:&Request)->Result<(),String> {
    let key=request.key;
    let state=world.get_resource::<crate::Match>().ok_or("Slice needs current match state")?;
    let snapshot=state.snapshot.as_ref().ok_or("Slice match ended")?;
    if snapshot.session!=key.session || state.visuals.get(&key.source)!=Some(&key.root) {
        return Err("Slice request is not the current session/root".into())
    }
    let actor=snapshot.players.iter().find(|p|p.id==key.source).ok_or("Slice actor not visible in snapshot")?;
    if !actor.champion.eq_ignore_ascii_case("garen") || !actor.health.is_finite() || actor.health<=0. || actor.respawn_at.is_some() {
        return Err("Slice actor is dead or not base Garen".into())
    }
    let playback=world.get::<crate::animation::Playback>(key.root).ok_or("Slice root playback absent")?;
    if playback.network_id()!=key.source || !playback.model_name().eq_ignore_ascii_case("garen")
        || playback.model_asset_id()!=profile.model.id() || world.get::<crate::actor_fow::Root>(key.root).is_none() {
        return Err("Slice root/model identity mismatch".into())
    }
    if world.get::<ChildOf>(key.root).is_some() || world.get::<Visibility>(key.root)==Some(&Visibility::Hidden) {
        return Err("Slice root hidden or has an unqualified external ancestor".into())
    }
    Ok(())
}

fn collect(world:&World,profile:&Profile,request:&Request,primitive:Entity)->Result<Source,String> {
    let key=request.key;
    validate_actor(world,profile,request)?;
    identity_path(world,primitive,key.root)?;
    let model=world.resource::<Assets<Gltf>>().get(&profile.model).ok_or("Slice Gltf unavailable")?;
    if model.meshes.len()!=1 || model.skins.len()!=1 {return Err("Slice requires the verified single Garen mesh/skin".into())}
    let gltf_mesh=world.resource::<Assets<GltfMesh>>().get(&model.meshes[0]).ok_or("Slice GltfMesh unavailable")?;
    let gltf_skin=world.resource::<Assets<GltfSkin>>().get(&model.skins[0]).ok_or("Slice GltfSkin unavailable")?;
    if gltf_mesh.primitives.len()!=1 || gltf_skin.joints.len()!=JOINTS {return Err("Slice Gltf primitive/joint count changed".into())}
    let mesh=world.get::<Mesh3d>(primitive).ok_or("Slice primitive mesh absent")?.0.clone();
    let skin=world.get::<SkinnedMesh>(primitive).ok_or("Slice primitive skin absent")?;
    if mesh!=gltf_mesh.primitives[0].mesh || skin.inverse_bindposes!=gltf_skin.inverse_bind_matrices
        || skin.joints.len()!=JOINTS || skin.joints.iter().collect::<HashSet<_>>().len()!=JOINTS {
        return Err("Slice live mesh/skin differs from verified model".into())
    }
    let mesh_asset=world.resource::<Assets<Mesh>>().get(&mesh).ok_or("Slice Mesh unavailable")?;
    if !mesh_asset.contains_attribute(Mesh::ATTRIBUTE_JOINT_INDEX) || !mesh_asset.contains_attribute(Mesh::ATTRIBUTE_JOINT_WEIGHT)
        || !mesh_asset.contains_attribute(Mesh::ATTRIBUTE_POSITION) || !mesh_asset.contains_attribute(Mesh::ATTRIBUTE_UV_0)
        || !mesh_asset.contains_attribute(Mesh::ATTRIBUTE_NORMAL) {
        return Err("Slice skinned mesh attributes unavailable".into())
    }
    if mesh_asset.skinned_mesh_bounds().is_none() {return Err("Slice needs loaded dynamic skinned mesh bounds".into())}
    let bind=world.resource::<Assets<SkinnedMeshInverseBindposes>>().get(&skin.inverse_bindposes).ok_or("Slice inverse-bind unavailable")?;
    if bind.len()!=JOINTS {return Err("Slice inverse-bind length changed".into())}
    let mut local=Vec::with_capacity(JOINTS);let mut parents=Vec::with_capacity(JOINTS);let mut inverse=Vec::with_capacity(JOINTS);
    for (i,(entity,spec)) in skin.joints.iter().zip(&profile.mapping.joints).enumerate() {
        if world.get::<Name>(*entity).map(Name::as_str)!=Some(spec.name.as_str())
            || bind[i].to_cols_array().map(f32::to_bits)!=spec.bind_words {return Err("Slice joint order/name/inverse-bind changed".into())}
        let parent=world.get::<ChildOf>(*entity).ok_or("Slice joint detached")?.parent();
        if spec.parent>=0 {
            if parent!=skin.joints[spec.parent as usize] {return Err("Slice joint parent differs from native mapping".into())}
        } else {identity_path(world,parent,key.root)?;}
        let transform=world.get::<Transform>(*entity).ok_or("Slice local animation joint absent")?;
        local.push(native::Transform(joint_words(transform)).to_joint());parents.push(spec.parent);
        inverse.push(native::Transform(spec.inverse_words).to_joint());
    }
    let root=*world.get::<Transform>(key.root).ok_or("Slice root transform absent")?;
    let owner=Transform {translation:root.translation*20.,scale:root.scale*20.,rotation:root.rotation};
    let owner=native::Transform(joint_words(&owner));
    let source=native::build_palette(&local,&parents,&inverse,owner).map_err(|e|format!("Slice native hierarchy: {e:?}"))?;
    let source=pose::Pose::new(profile.mapping.skeleton,source).map_err(|e|format!("Slice pose: {e:?}"))?;
    let inverse_owner=pose::inverse_transform(owner.0).map_err(|e|format!("Slice native inverse-owner: {e:?}"))?;
    let prepared=native::prepare(request.frame,native::Transform(inverse_owner),&source).map_err(|e|format!("Slice native draw: {e:?}"))?;
    let (globals,residual)=private_globals(&prepared.palette,bind,profile.budget)?;
    let draw_global=*world.get::<GlobalTransform>(primitive).ok_or("Slice primitive world transform absent")?;
    if !draw_global.to_matrix().is_finite() {return Err("Slice primitive global nonfinite".into())}
    Ok(Source {primitive,mesh,bind:skin.inverse_bindposes.clone(),joints:skin.joints.clone(),globals,draw_global,residual})
}

fn resources_ready(world:&World)->bool {
    world.contains_resource::<Assets<Gltf>>() && world.contains_resource::<Assets<GltfMesh>>()
        && world.contains_resource::<Assets<GltfSkin>>() && world.contains_resource::<Assets<Mesh>>()
        && world.contains_resource::<Assets<SkinnedMeshInverseBindposes>>() && world.contains_resource::<Assets<Image>>()
        && world.contains_resource::<Assets<slice::SliceMaterial>>()
}

fn poll_reload(world:&World,host:&mut Host,profile:&Profile)->bool {
    let mut meshes:HashSet<_>=host.entries.values().map(|e|e.mesh.id()).collect();
    let mut binds:HashSet<_>=host.entries.values().map(|e|e.bind.id()).collect();
    let mut gltf_meshes=HashSet::new();let mut gltf_skins=HashSet::new();
    if let Some(model)=world.resource::<Assets<Gltf>>().get(&profile.model) {
        for handle in &model.meshes {gltf_meshes.insert(handle.id());
            if let Some(mesh)=world.resource::<Assets<GltfMesh>>().get(handle) {
                meshes.extend(mesh.primitives.iter().map(|p|p.mesh.id()));
            }
        }
        for handle in &model.skins {gltf_skins.insert(handle.id());
            if let Some(skin)=world.resource::<Assets<GltfSkin>>().get(handle) {binds.insert(skin.inverse_bind_matrices.id());}
        }
    }
    // Every cursor is drained, even if an earlier family has changed this frame.
    let flags=[changed(world,&mut host.model_events,&HashSet::from([profile.model.id()])),
        changed(world,&mut host.gltf_mesh_events,&gltf_meshes),changed(world,&mut host.gltf_skin_events,&gltf_skins),
        changed(world,&mut host.mesh_events,&meshes),changed(world,&mut host.bind_events,&binds),
        changed(world,&mut host.image_events,&profile.textures.handles().into_iter().map(|h|h.id()).collect())];
    flags.into_iter().any(|f|f)
}

fn copy_draw_layers(world:&mut World,source:Entity,draw:Entity) {
    let layers=world.get::<RenderLayers>(source).cloned();let range=world.get::<VisibilityRange>(source).cloned();
    let mut entity=world.entity_mut(draw);
    if let Some(value)=layers {entity.insert(value);} else {entity.remove::<RenderLayers>();}
    if let Some(value)=range {entity.insert(value);} else {entity.remove::<VisibilityRange>();}
}

/// Exclusive synchronization gives each entry a complete palette or no draw.
/// New draws receive the source primitive GlobalTransform immediately because this
/// runs after propagation; the same-frame bounds/visibility/extraction then sees it.
pub fn synchronize(world:&mut World) {
    let mut host=world.remove_resource::<Host>().unwrap_or_default();host.issues.clear();host.maximum_residual=0.;
    let (session,rows)=if let Some(mut requests)=world.get_resource_mut::<Requests>() {
        (requests.session.take(),std::mem::take(&mut requests.rows))
    } else {(None,Vec::new())};
    let Some(profile)=world.get_resource::<Profile>().cloned() else {
        // Asset messages may expire while there is no profile to observe. Do not
        // reuse the old generation after that gap, even if dimensions still match.
        if host.highest_generation>0 {host.blocked_generation=Some(host.highest_generation);}
        retire_all(world,&mut host);world.insert_resource(host);return;
    };
    if !resources_ready(world) {
        if host.highest_generation>0 {host.blocked_generation=Some(host.highest_generation);}
        for request in rows {host.issues.insert(request.key,"Slice asset resources absent".into());}
        retire_all(world,&mut host);world.insert_resource(host);return;
    }
    if poll_reload(world,&mut host,&profile) {host.blocked_generation=Some(profile.verified_generation);}
    let blocked=profile.verified_generation==0 || profile.verified_generation<host.highest_generation
        || host.blocked_generation.is_some_and(|g|profile.verified_generation<=g);
    if blocked {
        for request in rows {host.issues.insert(request.key,"Slice assets changed; new verified profile generation required".into());}
        retire_all(world,&mut host);world.insert_resource(host);return;
    }
    host.highest_generation=profile.verified_generation;
    let images=world.resource::<Assets<Image>>();
    // The FoW output is RENDER_WORLD-only and leaves Assets<Image> after extraction.
    // Its presence and current session are established by the exact RenderApp ack.
    let images_valid=profile.textures.validate_images(images).map_err(str::to_owned);
    let readiness=world.get_resource::<Readiness>().cloned();
    let mut sources=Vec::new();
    let primitives:Vec<_>={let mut query=world.query_filtered::<Entity,(With<Mesh3d>,With<SkinnedMesh>,With<crate::actor_fow::Bound>,Without<Draw>)>();
        query.iter(world).collect()};
    for request in rows {
        let result=(|| {
            if session!=Some(request.key.session) {return Err("Slice batch session mismatch".into())}
            images_valid.clone()?;
            // Match the actual model ancestry, not a basename or an arbitrary mesh.
            let matches:Vec<_>=primitives.iter().copied().filter(|entity| {
                let mut current=*entity;let mut seen=HashSet::new();
                while current!=request.key.root {
                    if !seen.insert(current) || seen.len()>256 {return false}
                    let Some(parent)=world.get::<ChildOf>(current) else{return false};current=parent.parent();
                } true
            }).collect();
            // Validate material inputs before any entity or palette publication.
            let _=slice::SliceMaterial::new(&profile.textures,profile.visibility.clone(),profile.overlay.clone(),request.inputs)?;
            if matches.is_empty() {
                validate_actor(world,&profile,&request)?;
                // Scene/FoW attachment may lag the current actor root. Waiting
                // produces no desired source, retains no request and revokes any
                // prior draw/ticket below. A later frame must supply fresh inputs.
                return Ok(None)
            }
            if matches.len()!=1 {return Err("Slice needs exactly one loaded source primitive".into())}
            collect(world,&profile,&request,matches[0]).map(Some)
        })();
        match result {Ok(Some(source))=>sources.push((request,source)),Ok(None)=>{},Err(error)=>{host.issues.insert(request.key,error);}}
    }
    let desired:HashSet<_>=sources.iter().map(|(r,s)|(r.key,s.primitive)).collect();
    let retired:Vec<_>=host.entries.keys().filter(|k|!desired.contains(k)).copied().collect();
    for key in retired {retire(world,host.entries.remove(&key).unwrap());host.retired+=1;}
    let mut tickets=Vec::new();
    for (request,source) in sources {
        let key=(request.key,source.primitive);
        let texture_ids=profile.textures.handles().map(|h|h.id());
        let replace=host.entries.get(&key).is_some_and(|e|e.generation!=profile.verified_generation
            || e.model!=profile.model.id() || e.textures!=texture_ids
            || e.mesh!=source.mesh || e.bind!=source.bind || e.source_joints!=source.joints
            || world.get::<Draw>(e.draw).is_none() || e.joints.iter().any(|j|world.get::<PrivateJoint>(*j).is_none())
            || world.resource::<Assets<slice::SliceMaterial>>().get(&e.material).is_none());
        if replace {retire(world,host.entries.remove(&key).unwrap());host.retired+=1;}
        let mut entry=if let Some(existing)=host.entries.remove(&key) {existing} else {
            let material=slice::SliceMaterial::new(&profile.textures,profile.visibility.clone(),profile.overlay.clone(),request.inputs)
                .expect("same inputs already validated before publication");
            let material=world.resource_mut::<Assets<slice::SliceMaterial>>().add(material);
            let joints:Vec<_>=source.globals.iter().map(|g|world.spawn((PrivateJoint,*g)).id()).collect();
            let draw=world.spawn((Draw,ChildOf(source.primitive),Transform::IDENTITY,source.draw_global,
                Visibility::Inherited,Mesh3d(source.mesh.clone()),MeshMaterial3d(material.clone()),
                SkinnedMesh {inverse_bindposes:source.bind.clone(),joints:joints.clone()},
                DynamicSkinnedMeshBounds,bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();
            host.installed+=1;
            Entry {draw,joints,material,source_joints:source.joints.clone(),mesh:source.mesh.clone(),bind:source.bind.clone(),
                generation:profile.verified_generation,model:profile.model.id(),textures:texture_ids,published:false}
        };
        // No fallible palette work remains. All writes target our exact private entities.
        for (&joint,global) in entry.joints.iter().zip(source.globals) {world.entity_mut(joint).insert(global);}
        world.entity_mut(entry.draw).insert((source.draw_global,Visibility::Inherited));
        copy_draw_layers(world,source.primitive,entry.draw);
        let ticket=Ticket {key:request.key,draw:entry.draw,generation:profile.verified_generation,
            material:entry.material.id(),images:[texture_ids[0],texture_ids[1],profile.visibility.id(),profile.overlay.id()],
            mesh:source.mesh.id(),inverse_bind:source.bind.id()};
        let ready=request.render_ready && readiness.as_ref().is_some_and(|gate|gate.accepts(&ticket));
        world.entity_mut(entry.draw).insert(ticket.clone());tickets.push(ticket);
        {
            let mut materials=world.resource_mut::<Assets<slice::SliceMaterial>>();
            let mut material=materials.get_mut(&entry.material).expect("owned material just validated");
            material.update_inputs(request.inputs).expect("same inputs already validated");
            material.bind_fog(profile.visibility.clone(),profile.overlay.clone());
            material.set_draw_ready(ready);
        }
        entry.published=ready;host.maximum_residual=host.maximum_residual.max(source.residual);
        host.updated+=1;host.entries.insert(key,entry);
    }
    if let Some(readiness)=readiness {readiness.retain(tickets);}
    world.insert_resource(host);
}

#[cfg(test)]
#[path="garen_w_slice_host_tests.rs"]
mod tests;
