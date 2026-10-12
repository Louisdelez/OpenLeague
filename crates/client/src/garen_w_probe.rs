//! Opt-in, read-only ECS observation. No synthetic material/animation/game state.
use bevy::prelude::*;
use std::{fs::File,io::Write,path::PathBuf};
use crate::{actor_fow::{Bound,BaselineLease},garen_w_material_host as host,map_fog::FogMaterial};

#[derive(Resource,Default)]
pub struct Probe {
    initialized:bool,
    file:Option<File>,
    path:Option<PathBuf>,
    failed:bool,
    previous:Option<f64>,
    records:u64,
}
fn root(world:&World,mut entity:Entity)->Option<Entity> {
    for _ in 0..128 {
        if world.get::<crate::actor_fow::Root>(entity).is_some() {return Some(entity);}
        entity=world.get::<ChildOf>(entity)?.parent();
    }
    None
}
fn image(world:&World,handle:Option<&Handle<Image>>)->serde_json::Value {
    match handle {
        None=>serde_json::Value::Null,
        Some(handle)=>serde_json::json!({"id":format!("{:?}",handle.id()),
            "path":world.resource::<AssetServer>().get_path(handle.id()).map(|p|p.to_string()),
            "loaded":world.resource::<Assets<Image>>().get(handle).is_some()}),
    }
}
fn fog(world:&World,handle:&Handle<FogMaterial>)->serde_json::Value {
    let value=world.resource::<Assets<FogMaterial>>().get(handle);
    serde_json::json!({"id":format!("{:?}",handle.id()),"loaded":value.is_some(),
        "base_color_texture":value.map(|m|image(world,m.base.base_color_texture.as_ref())),
        "unlit":value.map(|m|m.base.unlit),
        "alpha_mode":value.map(|m|format!("{:?}",m.base.alpha_mode)),
        "visibility_ready":value.map(|m|m.extension.visibility_ready),
        "visibility_map":value.map(|m|format!("{:?}",m.extension.visibility_map.id()))})
}

/// Kept public within the crate for a headless observation test. It holds no
/// strong asset/entity owners after returning: the report contains values only.
pub fn snapshot(world:&mut World)->serde_json::Value {
    let state=world.resource::<crate::Match>();
    let clock=world.resource::<crate::native_effect_clock::EffectClock>();
    let time=world.resource::<Time>().elapsed_secs_f64();
    let session=state.snapshot.as_ref().map(|s|s.session);
    let tick=state.snapshot.as_ref().map(|s|s.tick);
    let roots:std::collections::HashMap<_,_>=state.snapshot.as_ref().into_iter()
        .flat_map(|s|s.players.iter()).filter(|p|p.champion=="garen")
        .filter_map(|p|state.visuals.get(&p.id).map(|root|(*root,p.id))).collect();
    let actors:Vec<_>=state.snapshot.as_ref().into_iter().flat_map(|s|s.players.iter())
        .filter(|p|p.champion=="garen").map(|p| {
            let sustained=state.w_visuals.0.sustained(p.id,clock.now);
            serde_json::json!({"source":p.id,"health":p.health,"courage_until":p.effects.courage_until,
                "root":state.visuals.get(&p.id).map(|e|format!("{e:?}")),
                "sustained":sustained.map(|s|serde_json::json!({"session":s.identity.session,"source":s.identity.source,
                    "started":s.identity.started,"end":s.identity.end,"age_seconds":s.age_seconds}))})
        }).collect();
    let clock_json=clock.diagnostic();
    let bindings=world.resource::<crate::garen_w_live::Bindings>();
    let requested:Vec<_>=bindings.active.values().map(|b|serde_json::json!({"root":format!("{:?}",b.root),
        "owner":b.owner,"identity":{"session":b.identity.session,"source":b.identity.source,
            "started":b.identity.started,"end":b.identity.end}})).collect();
    let request_error=bindings.failure.clone();
    let mut query=world.query::<(Entity,&Bound,&MeshMaterial3d<FogMaterial>,Option<&host::Guard>,Option<&BaselineLease>,
        Option<&Mesh3d>,Option<&bevy::mesh::skinning::SkinnedMesh>)>();
    let meshes:Vec<_>=query.iter(world).filter_map(|(entity,bound,current,guard,lease,mesh,skin)| {
        let root=root(world,entity)?;
        let source=roots.get(&root)?;
        Some(serde_json::json!({"entity":format!("{entity:?}"),"root":format!("{root:?}"),"source":source,
            "standard":format!("{:?}",bound.source.id()),"current":fog(world,&current.0),
            "mesh":mesh.map(|m|format!("{:?}",m.0.id())),"skinned_joints":skin.map(|s|s.joints.len()),
            "baseline_lease":lease.map(|l|serde_json::json!({"standard":format!("{:?}",l.source.id()),
                "previous":format!("{:?}",l.previous.id())})),
            "guard":guard.map(|g|serde_json::json!({"session":g.session,"source":g.source,"root":format!("{:?}",g.root),
                "owner":g.owner,"previous":fog(world,&g.previous),"private":fog(world,&g.owned),
                "current_is_private":current.0==g.owned}))}))
    }).collect();
    let diagnostics=world.resource::<host::Diagnostics>();
    let issues:Vec<_>=diagnostics.issues.iter().map(|(e,message)|serde_json::json!({"entity":format!("{e:?}"),"message":message})).collect();
    serde_json::json!({"schema":"garen_w_material_observation_v1","session":session,"tick":tick,"wall_time":time,
        "clock":clock_json,"actors":actors,"requests":requested,"request_error":request_error,"meshes":meshes,
        "diagnostics":{"installed":diagnostics.installed,"restored":diagnostics.restored,"superseded":diagnostics.superseded,
            "refreshed":diagnostics.refreshed,"issues":issues},
        "limits":{"local_sustained_policy":true,"native_activation_caller":false,"shader_equivalence":false,
            "native_particle_families":false,"pixels_qualified":false,"game_complete":false}})
}

pub fn observe(world:&mut World) {
    if !world.resource::<Probe>().initialized {
        let path=std::env::var_os("OPENLEAGUE_GAREN_W_PROBE").map(PathBuf::from);
        let opened=path.as_ref().map(|path|std::fs::OpenOptions::new().create_new(true).write(true).open(path));
        let mut probe=world.resource_mut::<Probe>();probe.initialized=true;probe.path=path;
        match opened {
            Some(Ok(file))=>probe.file=Some(file),
            Some(Err(error))=>{probe.failed=true;eprintln!("GAREN_W_PROBE_ERROR create_new: {error}");},
            None=>{},
        }
    }
    let now=world.resource::<Time>().elapsed_secs_f64();
    {let probe=world.resource::<Probe>();
        if probe.failed || probe.file.is_none() || probe.previous.is_some_and(|last|now-last<0.025) {return;}}
    let record=snapshot(world);
    let mut probe=world.resource_mut::<Probe>();
    let result=writeln!(probe.file.as_mut().unwrap(),"{record}").and_then(|_|probe.file.as_mut().unwrap().flush());
    match result {
        Ok(())=>{probe.records+=1;probe.previous=Some(now);},
        Err(error)=>{probe.failed=true;eprintln!("GAREN_W_PROBE_ERROR write/flush records={}: {error}",probe.records);},
    }
}
