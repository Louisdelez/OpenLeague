//! Client texture-only adaptation, not the original GPU/material shader.
//! One private FogMaterial per primitive; exact previous handle is leased.
//! Requests must be refreshed from the snapshot/EffectClock consumer. This host
//! neither infers W from a clip nor creates bursts/extra effects.
use bevy::prelude::*;
use std::collections::{HashMap,HashSet};
use crate::actor_fow::{BaselineLease,Bound};
use crate::map_fog::FogMaterial;
use crate::material_selection::{self,Component as NativeOrder,Properties};
use crate::garen_w_profile::BASE_OVERRIDE;

pub const BASE_MODEL: &str = "champions/garen.glb";
pub const BASE_TEXTURE: &str = BASE_OVERRIDE.texture_asset;
/// Base.inibin: MeshSkin*MaterialOverridePriority (7B4BF1F7) absent;
/// loader 56706C/567078 supplies 80000000. See base_priority.json.
pub const BASE_MATERIAL_PRIORITY_FLOOR:i32 = i32::MIN;

#[derive(Resource)]
pub struct Profile {
    pub model: Handle<Gltf>,
    pub texture: Handle<Image>,
}
pub fn setup(mut commands:Commands, assets:Res<AssetServer>) {
    commands.insert_resource(Profile { model:assets.load(BASE_MODEL), texture:assets.load(BASE_TEXTURE) });
}

struct Layers {
    source:u32,
    order:NativeOrder,
}
#[derive(Resource,Default)]
pub struct Requests {
    session:Option<u64>,
    actors:HashMap<Entity,Layers>,
}
impl Requests {
    pub fn session(&self)->Option<u64> {self.session}
    pub fn root_count(&self)->usize {self.actors.len()}
    /// Clears the old session's requests. Existing guards retire in synchronize.
    pub fn reset(&mut self, session:u64) {self.session=Some(session);self.actors.clear();}
    pub fn clear(&mut self) {self.session=None;self.actors.clear();}
    /// The caller owns the nonzero token for a W activation. A refresh never
    /// changes equal-priority order. Base W has priority0/nameempty/flags1.
    pub fn insert_base(&mut self, root:Entity, source:u32, owner:u32)->Result<bool,String> {
        if self.session.is_none() || owner==0 {return Err("W material needs a session and nonzero owner".into());}
        if self.actors.get(&root).is_some_and(|l|l.source!=source) {
            return Err("W root was reused for a different network source; retire its requests first".into());
        }
        if let Some(layers)=self.actors.get_mut(&root) {
            return layers.order.insert(owner,BASE_OVERRIDE.priority).map_err(|e|format!("native material order: {e:?}"));
        }
        let mut order=NativeOrder::default();
        let inserted=order.insert(owner,BASE_OVERRIDE.priority).map_err(|e|format!("native material order: {e:?}"))?;
        self.actors.insert(root,Layers {source,order});
        Ok(inserted)
    }
    pub fn remove(&mut self,root:Entity,owner:u32)->Result<bool,String> {
        let Some(layers)=self.actors.get_mut(&root) else {return Ok(false);};
        let removed=layers.order.remove(owner,BASE_OVERRIDE.priority).map_err(|e|format!("native material order: {e:?}"))?;
        if layers.order.entries().is_empty() {self.actors.remove(&root);}
        Ok(removed)
    }
    pub fn remove_root(&mut self,root:Entity) {self.actors.remove(&root);}
    pub fn retain_roots(&mut self,mut retain:impl FnMut(Entity,u32)->bool) {
        self.actors.retain(|root,layers|retain(*root,layers.source));
    }
}

#[derive(Component,Clone)]
pub struct Guard {
    pub session:u64,
    pub root:Entity,
    pub source:u32,
    pub owner:u32,
    pub previous:Handle<FogMaterial>,
    pub standard:Handle<StandardMaterial>,
    pub owned:Handle<FogMaterial>,
}
#[derive(Resource,Default)]
pub struct Diagnostics {
    pub installed:u64,
    pub restored:u64,
    pub superseded:u64,
    pub refreshed:u64,
    /// Bounded by currently existing primitives; no per-frame append-only log.
    pub issues:HashMap<Entity,String>,
}

#[derive(Clone,Copy)]
struct Desired {session:u64,root:Entity,source:u32,owner:u32}

fn actor_root(world:&World, mut entity:Entity)->Option<Entity> {
    // Finite traversal is a host guard, not a recovered native depth constant.
    for _ in 0..128 {
        if world.get::<crate::actor_fow::Root>(entity).is_some() {return Some(entity);}
        entity=world.get::<ChildOf>(entity)?.parent();
    }
    None
}

fn selected(world:&World, root:Entity, profile:&Profile)->Result<Option<Desired>,String> {
    let requests=world.resource::<Requests>();
    let (Some(session),Some(layers))=(requests.session,requests.actors.get(&root)) else {return Ok(None);};
    let Some(playback)=world.get::<crate::animation::Playback>(root) else {return Ok(None);};
    if playback.network_id()!=layers.source {return Ok(None);}
    if !playback.model_name().eq_ignore_ascii_case("Garen") || playback.model_asset_id()!=profile.model.id() {
        return Err("W texture profile supports only the verified base Garen model asset".into());
    }
    if world.get::<Visibility>(root).is_some_and(|v|*v==Visibility::Hidden) {return Ok(None);}
    let owner=material_selection::select(Some(layers.order.priority_range(BASE_MATERIAL_PRIORITY_FLOOR)),None,0,
        |_|Some(Properties {submesh:BASE_OVERRIDE.submesh.as_bytes(),flags:BASE_OVERRIDE.owner_flags,shader44:u32::MAX,shader48:u32::MAX}),None)
        .map_err(|e|format!("native material selection: {e:?}"))?;
    Ok(owner.map(|owner|Desired {session,root,source:layers.source,owner}))
}

fn retire(world:&mut World, entity:Entity, guard:&Guard)->bool {
    if world.resource::<Assets<FogMaterial>>().get(&guard.previous).is_none() {
        world.resource_mut::<Diagnostics>().issues.insert(entity,"W baseline asset unavailable; retirement pending".into());
        return false;
    }
    world.entity_mut(entity).insert(MeshMaterial3d(guard.previous.clone())).remove::<(Guard,BaselineLease)>();
    world.resource_mut::<Diagnostics>().restored+=1;
    true
}

/// Exclusive access makes compare/replace atomic with respect to other ECS
/// systems. It is a local ownership adaptation, not native device-call parity.
pub fn synchronize(world:&mut World) {
    let Some(profile)=world.get_resource::<Profile>() else {return;};
    let profile=Profile {model:profile.model.clone(),texture:profile.texture.clone()};
    if !world.contains_resource::<Requests>() {return;}
    if !world.contains_resource::<Diagnostics>() {world.init_resource::<Diagnostics>();}
    // Remove stale root generations and rebound source IDs from the request map.
    let valid_roots:HashSet<_>={let requests=world.resource::<Requests>();requests.actors.iter()
        .filter_map(|(entity,layers)|world.get::<crate::animation::Playback>(*entity)
            .filter(|p|p.network_id()==layers.source)
            .filter(|_|world.get::<crate::actor_fow::Root>(*entity).is_some()).map(|_|*entity)).collect()};
    world.resource_mut::<Requests>().actors.retain(|root,_|valid_roots.contains(root));
    let primitives:Vec<_>={let mut q=world.query::<(Entity,&Bound,&MeshMaterial3d<FogMaterial>,Option<&Guard>)>();
        q.iter(world).map(|(entity,bound,material,guard)|(entity,bound.source.clone(),material.0.clone(),guard.cloned())).collect()};
    let alive:HashSet<_>=primitives.iter().map(|p|p.0).collect();
    world.resource_mut::<Diagnostics>().issues.retain(|e,_|alive.contains(e));
    for (entity,standard,current,existing) in primitives {
        let desired=actor_root(world,entity).map(|root|selected(world,root,&profile)).transpose();
        let desired=match desired {
            Ok(value)=>value.flatten(),
            Err(error)=>{world.resource_mut::<Diagnostics>().issues.insert(entity,error);None}
        };
        let owned=existing.as_ref().is_some_and(|g|g.standard==standard && g.owned==current);
        let same_scope=existing.as_ref().zip(desired).is_some_and(|(g,d)|g.session==d.session && g.root==d.root && g.source==d.source);
        if let Some(guard)=existing.as_ref() {
            if !owned {
                // An external writer owns the current binding/source. Never
                // overwrite it or turn its material into our next baseline.
                world.entity_mut(entity).remove::<(Guard,BaselineLease)>();
                let mut diagnostics=world.resource_mut::<Diagnostics>();diagnostics.superseded+=1;
                diagnostics.issues.insert(entity,"W material binding superseded externally".into());
                continue;
            }
            if desired.is_none() || !same_scope {
                // Keep the guard/lease on missing asset for exact-handle retry.
                retire(world,entity,guard);
                continue; // a new session/scope can acquire only on the next pass
            }
        }
        let Some(desired)=desired else {continue;};
        if world.resource::<Assets<Image>>().get(&profile.texture).is_none() {
            if let Some(guard)=existing.as_ref() {retire(world,entity,guard);}
            world.resource_mut::<Diagnostics>().issues.insert(entity,"W native DDS is not loaded".into());
            continue;
        }
        let Some(source)=world.resource::<Assets<StandardMaterial>>().get(&standard).cloned() else {
            if let Some(guard)=existing.as_ref() {retire(world,entity,guard);}
            world.resource_mut::<Diagnostics>().issues.insert(entity,"W StandardMaterial source is unavailable".into());
            continue;
        };
        let previous=existing.as_ref().map(|g|&g.previous).unwrap_or(&current);
        let baseline_texture=world.resource::<Assets<FogMaterial>>().get(previous)
            .and_then(|m|m.base.base_color_texture.as_ref());
        let valid_baseline=baseline_texture.is_some_and(|h|world.resource::<Assets<Image>>().get(h).is_some())
            && source.base_color_texture.as_ref().is_some_and(|h|world.resource::<Assets<Image>>().get(h).is_some());
        if !valid_baseline {
            // Native backup0 does not restore; this Bevy profile deliberately
            // excludes that domain. Retiring an earlier private override here
            // is a local adaptation to a hot-reloaded unsupported baseline.
            if let Some(guard)=existing.as_ref() {retire(world,entity,guard);}
            world.resource_mut::<Diagnostics>().issues.insert(entity,"W requires a loaded nonnull baseline texture; baseline retained".into());
            continue;
        }
        if let Some(mut guard)=existing {
            // Refresh base properties only; preserve live FoW/cloud extension.
            let mut materials=world.resource_mut::<Assets<FogMaterial>>();
            let Some(mut private)=materials.get_mut(&guard.owned) else {
                drop(materials);
                world.resource_mut::<Diagnostics>().issues.insert(entity,"W private material asset is unavailable".into());
                continue;
            };
            private.base=source;private.base.base_color_texture=Some(profile.texture.clone());
            drop(private);
            drop(materials);
            guard.owner=desired.owner;world.entity_mut(entity).insert(guard);
            let mut diagnostics=world.resource_mut::<Diagnostics>();diagnostics.refreshed+=1;diagnostics.issues.remove(&entity);
        } else {
            let baseline_is_bound=world.resource::<crate::actor_fow::Cache>().bindings.get(&standard.id()).is_some_and(|h|*h==current);
            if !baseline_is_bound {
                world.resource_mut::<Diagnostics>().issues.insert(entity,"W acquisition refused an untracked external FogMaterial".into());
                continue;
            }
            let Some(mut private)=world.resource::<Assets<FogMaterial>>().get(&current).cloned() else {
                world.resource_mut::<Diagnostics>().issues.insert(entity,"W baseline material is unavailable".into());continue;
            };
            private.base=source;private.base.base_color_texture=Some(profile.texture.clone());
            let installed=world.resource_mut::<Assets<FogMaterial>>().add(private);
            let guard=Guard {session:desired.session,root:desired.root,source:desired.source,owner:desired.owner,
                previous:current.clone(),standard:standard.clone(),owned:installed.clone()};
            world.entity_mut(entity).insert((MeshMaterial3d(installed),guard,BaselineLease {source:standard,previous:current}));
            let mut diagnostics=world.resource_mut::<Diagnostics>();diagnostics.installed+=1;diagnostics.issues.remove(&entity);
        }
    }
    // Removing Bound relinquishes the source contract: without its unchanged
    // source we must not restore a guessed baseline. Any current material is
    // retained by its component; only our ownership/lease is retired here.
    let orphans:Vec<_>={let mut q=world.query_filtered::<Entity,With<Guard>>();q.iter(world).filter(|e|!alive.contains(e)).collect()};
    for entity in orphans {
        world.entity_mut(entity).remove::<(Guard,BaselineLease)>();
        let mut diagnostics=world.resource_mut::<Diagnostics>();diagnostics.superseded+=1;
        diagnostics.issues.insert(entity,"W source/binding contract removed externally; current material retained".into());
    }
}
