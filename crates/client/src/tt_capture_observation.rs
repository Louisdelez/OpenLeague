//! Opt-in observation of actual ordinary TT Capture. No state or clock injection.
//! CPU publication, framebuffer files and normal exit have separate evidence.
use bevy::{prelude::*,app::AppExit,render::view::screenshot::{Screenshot,ScreenshotCaptured}};
use std::{path::PathBuf,io::{Read,Write},collections::BTreeSet};
#[derive(Resource,Default)]
struct Observation {directory:Option<PathBuf>,stage:u8,active_since:Option<f64>,
    captured:BTreeSet<u8>,key:Option<crate::relic_pickup_events::Key>,failed:bool,
    close_requested:bool,close_error:Option<String>,completed_key:bool}
#[derive(Component)]struct Capture {stage:u8,path:PathBuf}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Close {schema:u32,client_pid:u32}
fn journal(host:&mut Observation,row:serde_json::Value) {
    let Some(directory)=&host.directory else{return};
    let result=(||->std::io::Result<()>{let mut file=std::fs::OpenOptions::new().create(true)
        .append(true).open(directory.join("events.jsonl"))?;writeln!(file,"{row}")})();
    if let Err(error)=result {host.failed=true;warn!("TT Capture observation journal: {error}");}
}
fn setup(mut host:ResMut<Observation>) {
    let Some(raw)=std::env::var_os("OPENLEAGUE_TT_CAPTURE_OBSERVATION") else{return};
    let directory=PathBuf::from(raw);
    let root=PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../logs");
    // The caller owns a fresh one-level run directory. Existing paths are never reused.
    let valid=directory.is_absolute() && directory.components().all(|p|!matches!(p,std::path::Component::ParentDir))
        && directory.parent().and_then(|p|p.canonicalize().ok())==root.canonicalize().ok()
        && root.is_dir() && !directory.exists();
    if !valid {host.failed=true;warn!("TT Capture observation requires a fresh direct child of project logs");return;}
    if let Err(error)=std::fs::create_dir(&directory){host.failed=true;warn!("TT Capture observation: {error}");return;}
    host.directory=Some(directory);journal(&mut host,serde_json::json!({"stage":"started","pid":std::process::id(),
        "state_injected":false,"clock_override":false,"original_pixel_parity":false,"complete":false}));
}
fn poll_close(world:&mut World,host:&mut Observation) {
    if host.close_requested{return;}
    let Some(directory)=&host.directory else{return};let path=directory.join("close.json");
    let result=(||->Result<Option<Close>,String>{
        let metadata=match std::fs::symlink_metadata(&path){Ok(v)=>v,Err(e) if e.kind()==std::io::ErrorKind::NotFound=>return Ok(None),Err(e)=>return Err(e.to_string())};
        if !metadata.is_file()||metadata.file_type().is_symlink()||metadata.len()>1024{return Err("close control must be an ordinary file <=1024 bytes".into());}
        let mut bytes=Vec::new();std::fs::File::open(&path).map_err(|e|e.to_string())?
            .take(1025).read_to_end(&mut bytes).map_err(|e|e.to_string())?;
        if bytes.len()>1024{return Err("close control exceeds1024 bytes".into());}
        let request:Close=serde_json::from_slice(&bytes).map_err(|e|e.to_string())?;
        if request.schema!=1 || request.client_pid!=std::process::id(){return Err("close requires schema1 and this typed client PID".into());}
        Ok(Some(request))})();
    match result {
        Ok(Some(_))=>{host.close_requested=true;host.close_error=None;
            journal(host,serde_json::json!({"stage":"normal_exit_requested","pid":std::process::id(),"AppExit":"Success","automatic":false}));
            world.write_message(AppExit::Success);},
        Ok(None)=>{},
        Err(error)=>{if host.close_error.as_ref()!=Some(&error){host.close_error=Some(error.clone());
            journal(host,serde_json::json!({"stage":"invalid_close_control","error":error}));}}
    }
}
fn saved(event:On<ScreenshotCaptured>,query:Query<&Capture>,mut host:ResMut<Observation>) {
    let Ok(capture)=query.get(event.entity) else{return};
    let dimensions=[event.image.width(),event.image.height()];
    let result=event.image.clone().try_into_dynamic().map_err(|e|e.to_string())
        .and_then(|image|image.to_rgb8().save(&capture.path).map_err(|e|e.to_string()));
    match result {Ok(())=>{host.captured.insert(capture.stage);
        journal(&mut host,serde_json::json!({"stage":"framebuffer_saved","role":capture.stage,
            "path":capture.path,"dimensions":dimensions,"exact_GPU_exposure_time":null,"Root_viewed":false}));},
        Err(error)=>{host.failed=true;journal(&mut host,serde_json::json!({"stage":"framebuffer_failed","error":error}));}}
}
fn observe(world:&mut World) {
    let mut host=world.remove_resource::<Observation>().unwrap_or_default();
    if host.directory.is_none(){world.insert_resource(host);return;}
    poll_close(world,&mut host);
    if host.failed||host.close_requested {world.insert_resource(host);return;}
    let now=world.resource::<Time>().elapsed_secs_f64();
    let diagnostic=world.resource::<crate::tt_capture_live::Diagnostics>();
    let tickets=world.resource::<crate::tt_capture_live::Backend>().tickets();
    let error=diagnostic.error.clone();let completed=diagnostic.completed;
    let particles=diagnostic.particles;let draws=diagnostic.draws;
    let identity=world.resource::<crate::Connection>().inventory_input_identity();
    let snapshot=world.resource::<crate::Match>().snapshot.as_ref().map(|s|(s.session,s.tick));
    let active=tickets.first().map(|t|t.key);
    if host.key.is_some_and(|key|world.resource::<crate::relic_pickup_events::Host>().retired
        .iter().any(|r|r.key==key && r.reason=="completed")){host.completed_key=true;}
    let action=match host.stage {
        0 if now>=25. && tickets.is_empty() && identity.is_some() && snapshot.is_some()=>Some(("baseline",0)),
        1 if host.captured.contains(&0) && particles==70 && draws==70 && error.is_none()=>{
            if let Some(key)=active {if host.key.is_some_and(|old|old!=key){host.failed=true;None}
                else {host.key=Some(key);let since=*host.active_since.get_or_insert(now);
                    (now-since>=0.10).then_some(("active",1))}}else{None}},
        2 if host.captured.contains(&1) && host.completed_key && particles==0 && draws==0 && error.is_none()=>Some(("cleanup",2)),
        _=>None};
    if let Some((name,role))=action {
        let path=host.directory.as_ref().unwrap().join(format!("{name}.png"));
        if path.exists(){host.failed=true;journal(&mut host,serde_json::json!({"stage":"capture_path_exists","path":path}));}
        else {world.spawn((Screenshot::primary_window(),Capture{stage:role,path:path.clone()})).observe(saved);
            let key=host.key.map(|k|serde_json::json!({"session":k.session,"pickup_tick":k.pickup_tick,"picker":k.picker}));
            let observed_key_completed=host.completed_key;
            journal(&mut host,serde_json::json!({"stage":"framebuffer_requested","role":role,"path":path,
                "key":key,"accepted_identity":identity,"snapshot":snapshot,"particles":particles,"draws":draws,
                "completed":completed,"observed_key_completed":observed_key_completed,"request_host_time":now,"exact_GPU_exposure_time":null,
                "CPU_publication_is_not_draw_success":true}));host.stage+=1;}
    }
    world.insert_resource(host);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Observation>().add_systems(Startup,setup)
        .add_systems(PostUpdate,observe.after(crate::tt_capture_live::synchronize)
            .after(bevy::camera::visibility::VisibilitySystems::CheckVisibility))
        .add_systems(Last,shutdown.after(crate::tt_capture_live::shutdown));}
}
fn shutdown(mut host:ResMut<Observation>,diagnostic:Res<crate::tt_capture_live::Diagnostics>,
    backend:Res<crate::tt_capture_live::Backend>,exits:Res<Messages<AppExit>>) {
    if host.directory.is_none()||exits.is_empty(){return;}
    let key=host.key.map(|k|serde_json::json!({"session":k.session,"pickup_tick":k.pickup_tick,"picker":k.picker}));
    journal(&mut host,serde_json::json!({"stage":"TT_normal_cleanup_observed","key":key,
        "normal_cleanup":diagnostic.normal_cleanup,"retained_draws":backend.tickets().len(),
        "error":diagnostic.error,"successful_exit_still_requires_process_and_transport_observation":true}));
}
