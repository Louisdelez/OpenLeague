//! Opt-in observation of the ordinary active Ring and its exact pickup retirement.
//! Bevy 0.19 supplies ScreenshotCaptured; SavedOK below means PNG encoding, a
//! create_new write and sync succeeded. Publication is separate from pixels.
//! This module issues no movement, state changes, clock override or automatic exit.
use bevy::{app::AppExit, prelude::*, render::view::screenshot::{Screenshot, ScreenshotCaptured}};
use std::{collections::BTreeMap, fs::{File, Metadata, OpenOptions}, io::{Read, Write}, path::{Path, PathBuf}};
use crate::{relic_pickup_events::Key as PickupKey, tt_well_ring_live::Key as RingKey};

const ENVIRONMENT: &str = "OPENLEAGUE_TT_WELL_RING_OBSERVATION";
const LOG_ROOT: &str = "E:/OpenLeague/logs";
const DIMENSIONS: [u32; 2] = [1280, 800];
const ROLES: [&str; 3] = ["baseline", "active", "cleanup"];
const PNGS: [&str; 3] = ["01_baseline.png", "02_active.png", "03_cleanup.png"];
type Identity = (u64, u32, Option<u64>);

#[derive(Resource, Default)]
struct Observation {
    directory: Option<PathBuf>, stage: u8, saved: BTreeMap<u8, serde_json::Value>,
    identity: Option<Identity>, last_snapshot_tick: Option<u64>,
    ring_key: Option<RingKey>, retired_ring_key: Option<RingKey>,
    pickup_key: Option<PickupKey>, prior_pickup_key: Option<PickupKey>,
    last_available_tick: Option<u64>, active_since: Option<f64>,
    pickup_completed: bool, failed: bool, close_requested: bool,
    close_error: Option<String>, report_written: bool, shutdown_journaled: bool,
}
#[derive(Component)]
struct Capture { role: u8, path: PathBuf, request: serde_json::Value }
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Close { schema: u32, client_pid: u32 }

#[derive(Clone, Copy)]
struct MapEvidence { visible: bool, available: bool, ready_tick: u64, pickup: Option<PickupKey> }
#[derive(Default)]
struct Current {
    identity: Option<Identity>, snapshot: Option<(u64, u64, bool)>, map: Option<MapEvidence>,
    ring_active: Option<RingKey>, ring_retired: Option<RingKey>,
    ring_particles: Option<usize>, ring_draws: Option<usize>, ring_error: Option<String>,
    ring_tickets: Option<Vec<RingKey>>, ring_normal_cleanup: Option<bool>,
    capture_particles: Option<usize>, capture_draws: Option<usize>, capture_error: Option<String>,
    capture_tickets: Option<Vec<PickupKey>>, capture_normal_cleanup: Option<bool>,
    completed_pickups: Vec<PickupKey>,
}
fn ring_key(key: Option<RingKey>) -> serde_json::Value {
    key.map(|k| serde_json::json!({"session":k.session,"ready_tick":k.ready_tick,"generation":k.generation}))
        .unwrap_or(serde_json::Value::Null)
}
fn pickup_key(key: Option<PickupKey>) -> serde_json::Value {
    key.map(|k| serde_json::json!({"session":k.session,"pickup_tick":k.pickup_tick,"picker":k.picker}))
        .unwrap_or(serde_json::Value::Null)
}
impl Current {
    fn accepted(&self) -> Option<(Identity, u64, MapEvidence)> {
        let identity = self.identity?; let (session, tick, winner) = self.snapshot?;
        if identity.0 != session || winner { return None; }
        Some((identity, tick, self.map?))
    }
    fn accepted_identity(&self) -> serde_json::Value {
        match self.identity.zip(self.snapshot) {
            Some(((session, player, epoch), (snapshot_session, tick, _))) if session == snapshot_session =>
                serde_json::json!({"session":session,"player":player,"epoch":epoch,"tick":tick}),
            _ => serde_json::Value::Null,
        }
    }
    fn evidence(&self) -> serde_json::Value {
        serde_json::json!({
            "current_accepted_identity":self.accepted_identity(),
            "snapshot":self.snapshot.map(|(session,tick,winner)|serde_json::json!({"session":session,"tick":tick,"winner_present":winner})),
            "relic":self.map.map(|m|serde_json::json!({"visible":m.visible,"available":m.available,"ready_tick":m.ready_tick,"pickup_key":pickup_key(m.pickup)})),
            "ring":{"active_key":ring_key(self.ring_active),"retired_key":ring_key(self.ring_retired),
                "particles":self.ring_particles,"draws":self.ring_draws,"error":self.ring_error,
                "tickets":self.ring_tickets.as_ref().map(|v|v.iter().map(|k|ring_key(Some(*k))).collect::<Vec<_>>()),
                "normal_cleanup":self.ring_normal_cleanup},
            "capture":{"particles":self.capture_particles,"draws":self.capture_draws,"error":self.capture_error,
                "tickets":self.capture_tickets.as_ref().map(|v|v.iter().map(|k|pickup_key(Some(*k))).collect::<Vec<_>>()),
                "normal_cleanup":self.capture_normal_cleanup},
            "completed_pickups_this_frame":self.completed_pickups.iter().map(|k|pickup_key(Some(*k))).collect::<Vec<_>>()})
    }
}
fn current_from(
    connection: Option<&crate::Connection>, state: Option<&crate::Match>,
    ring: Option<&crate::tt_well_ring_live::Diagnostics>, ring_backend: Option<&crate::tt_well_ring_live::Backend>,
    capture: Option<&crate::tt_capture_live::Diagnostics>, capture_backend: Option<&crate::tt_capture_live::Backend>,
    events: Option<&crate::relic_pickup_events::Host>,
) -> Current {
    let snapshot = state.and_then(|m|m.snapshot.as_ref());
    Current {
        identity: connection.and_then(crate::Connection::inventory_input_identity),
        snapshot: snapshot.map(|s|(s.session,s.tick,s.winner.is_some())),
        map: snapshot.and_then(|s|s.map10.as_ref().map(|m|MapEvidence {
            visible:m.relic_visible,available:m.relic_available,ready_tick:m.relic_ready_tick,
            pickup:m.relic_pickup_tick.zip(m.relic_last_picker).map(|(pickup_tick,picker)|PickupKey {session:s.session,pickup_tick,picker}),
        })),
        ring_active:ring.and_then(|d|d.active_key),ring_retired:ring.and_then(|d|d.retired_key),
        ring_particles:ring.map(|d|d.particles),ring_draws:ring.map(|d|d.draws),ring_error:ring.and_then(|d|d.error.clone()),
        ring_tickets:ring_backend.map(|b|b.tickets().into_iter().map(|t|t.key).collect()),
        ring_normal_cleanup:ring.and_then(|d|d.normal_cleanup),
        capture_particles:capture.map(|d|d.particles),capture_draws:capture.map(|d|d.draws),capture_error:capture.and_then(|d|d.error.clone()),
        capture_tickets:capture_backend.map(|b|b.tickets().into_iter().map(|t|t.key).collect()),
        capture_normal_cleanup:capture.and_then(|d|d.normal_cleanup),
        completed_pickups:events.map(|h|h.retired.iter().filter(|r|r.reason=="completed").map(|r|r.key).collect()).unwrap_or_default(),
    }
}
fn current(world: &World) -> Current {
    current_from(world.get_resource::<crate::Connection>(),world.get_resource::<crate::Match>(),
        world.get_resource::<crate::tt_well_ring_live::Diagnostics>(),world.get_resource::<crate::tt_well_ring_live::Backend>(),
        world.get_resource::<crate::tt_capture_live::Diagnostics>(),world.get_resource::<crate::tt_capture_live::Backend>(),
        world.get_resource::<crate::relic_pickup_events::Host>())
}

fn reparse(metadata: &Metadata) -> bool {
    if metadata.file_type().is_symlink() { return true; }
    #[cfg(windows)] {
        use std::os::windows::fs::MetadataExt;
        if metadata.file_attributes() & 0x400 != 0 { return true; }
    }
    false
}
fn no_follow(options: &mut OpenOptions) {
    #[cfg(windows)] {
        use std::os::windows::fs::OpenOptionsExt;
        options.custom_flags(0x0020_0000); // FILE_FLAG_OPEN_REPARSE_POINT
    }
    #[cfg(not(windows))] { let _ = options; }
}
fn validate_directory(directory: &Path) -> Result<(), String> {
    let root = Path::new(LOG_ROOT);
    for path in [root,directory] {
        let meta=std::fs::symlink_metadata(path).map_err(|e|e.to_string())?;
        if !meta.is_dir() || reparse(&meta) {return Err("observation directory/root must be ordinary directories".into());}
    }
    let root=root.canonicalize().map_err(|e|e.to_string())?;
    let resolved=directory.canonicalize().map_err(|e|e.to_string())?;
    if resolved.parent()!=Some(root.as_path()) {return Err("observation directory must remain a direct child of E:/OpenLeague/logs".into());}
    Ok(())
}
fn open_existing(path: &Path, append: bool) -> Result<File, String> {
    let metadata=std::fs::symlink_metadata(path).map_err(|e|e.to_string())?;
    if !metadata.is_file() || reparse(&metadata) {return Err("observation file must be ordinary, never a symlink/reparse point".into());}
    let mut options=OpenOptions::new(); options.read(!append).append(append); no_follow(&mut options);
    let file=options.open(path).map_err(|e|e.to_string())?;
    let opened=file.metadata().map_err(|e|e.to_string())?;
    if !opened.is_file() || reparse(&opened) {return Err("opened observation file is not ordinary".into());}
    Ok(file)
}
fn create_new(path: &Path) -> Result<File, String> {
    let mut options=OpenOptions::new();options.write(true).create_new(true);no_follow(&mut options);
    options.open(path).map_err(|e|e.to_string())
}
fn record(host: &mut Observation, now: &Current, event: &str, role: &str, path: Option<&Path>, extra: serde_json::Value) {
    let Some(directory)=host.directory.as_ref() else{return};
    let mut row=serde_json::json!({"schema":1,"pid":std::process::id(),"client_pid":std::process::id(),
        "event":event,"stage":event,"role":role,"path":path.unwrap_or(directory.as_path()),
        "ring_key":ring_key(host.ring_key),"retired_ring_key":ring_key(host.retired_ring_key),
        "pickup_key":pickup_key(host.pickup_key),"observed_pickup_completed":host.pickup_completed,
        "current_accepted_identity":now.accepted_identity(),"counts":{"ring_particles":now.ring_particles,"ring_draws":now.ring_draws,
            "ring_tickets":now.ring_tickets.as_ref().map(Vec::len),"capture_particles":now.capture_particles,
            "capture_draws":now.capture_draws,"capture_tickets":now.capture_tickets.as_ref().map(Vec::len)},
        "current":now.evidence(),"failed":host.failed,"saved_ok":false,"dimensions":null});
    if let Some(fields)=extra.as_object() {row.as_object_mut().unwrap().extend(fields.clone());}
    let result=(||->Result<(),String>{validate_directory(directory)?;
        let mut file=open_existing(&directory.join("events.jsonl"),true)?;
        writeln!(file,"{row}").map_err(|e|e.to_string())?;file.flush().map_err(|e|e.to_string())})();
    if let Err(error)=result {host.failed=true;warn!("TT Ring observation journal: {error}");}
}
fn fail(host: &mut Observation, now: &Current, message: &str) {
    host.failed=true;record(host,now,"observation_failed","observer",None,serde_json::json!({"error":message}));
}
fn setup(mut host: ResMut<Observation>) {
    let Some(raw)=std::env::var_os(ENVIRONMENT) else{return};
    let directory=PathBuf::from(raw);let root=Path::new(LOG_ROOT);
    let valid=directory.is_absolute() && directory.components().all(|c|!matches!(c,std::path::Component::ParentDir|std::path::Component::CurDir))
        && directory.file_name().is_some() && matches!(std::fs::symlink_metadata(&directory),Err(e) if e.kind()==std::io::ErrorKind::NotFound)
        && root.canonicalize().ok().is_some_and(|r|directory.parent().and_then(|p|p.canonicalize().ok())==Some(r));
    if !valid {host.failed=true;warn!("TT Ring observation requires a fresh direct child of E:/OpenLeague/logs");return;}
    let result=(||->Result<(),String>{
        let meta=std::fs::symlink_metadata(root).map_err(|e|e.to_string())?;
        if !meta.is_dir() || reparse(&meta) {return Err("observation logs root cannot be a symlink/reparse point".into());}
        std::fs::create_dir(&directory).map_err(|e|e.to_string())?;validate_directory(&directory)?;
        host.directory=Some(directory.canonicalize().map_err(|e|e.to_string())?);
        create_new(&host.directory.as_ref().unwrap().join("events.jsonl"))?.sync_all().map_err(|e|e.to_string())?;Ok(())})();
    if let Err(error)=result {host.failed=true;warn!("TT Ring observation setup: {error}");return;}
    record(&mut host,&Current::default(),"started","observer",None,serde_json::json!({
        "environment":ENVIRONMENT,"expected_dimensions":DIMENSIONS,"png_files":PNGS,"report_file":"capture_report.json",
        "state_injected":false,"clock_override":false,"moves_issued":false,"automatic_exit":false,
        "baseline_minimum_seconds":25,"active_minimum_particles_exclusive":32,"active_minimum_draws_exclusive":32,
        "active_persistence_seconds":1,"original_pixel_parity":false,"Root_viewed":false,"complete":false}));
}
fn parse_close(bytes: &[u8], pid: u32) -> Result<Close, String> {
    if bytes.len()>1024 {return Err("close control exceeds 1024 bytes".into());}
    // Derived struct deserializers also accept sequences. Controls require an
    // object; the typed parse still rejects duplicate fields and trailing data.
    if bytes.iter().find(|b|!b.is_ascii_whitespace())!=Some(&b'{') {return Err("close control must be a JSON object".into());}
    let request:Close=serde_json::from_slice(bytes).map_err(|e|e.to_string())?;
    if request.schema!=1 || request.client_pid!=pid {return Err("close requires schema 1 and this exact typed client PID".into());}
    Ok(request)
}
fn poll_close(world: &mut World, host: &mut Observation, now: &Current) {
    if host.close_requested {return;}
    let Some(directory)=host.directory.as_ref() else{return};let path=directory.join("close.json");
    let result=(||->Result<bool,String>{
        validate_directory(directory)?;
        let metadata=match std::fs::symlink_metadata(&path) {
            Ok(v)=>v,Err(e) if e.kind()==std::io::ErrorKind::NotFound=>return Ok(false),Err(e)=>return Err(e.to_string()),
        };
        if !metadata.is_file() || reparse(&metadata) || metadata.len()>1024 {return Err("close control must be an ordinary file <=1024 bytes".into());}
        let file=open_existing(&path,false)?;
        if file.metadata().map_err(|e|e.to_string())?.len()>1024 {return Err("opened close control exceeds 1024 bytes".into());}
        let mut bytes=Vec::new();file.take(1025).read_to_end(&mut bytes).map_err(|e|e.to_string())?;
        parse_close(&bytes,std::process::id())?;Ok(true)})();
    match result {
        Ok(true)=>{host.close_requested=true;host.close_error=None;
            record(host,now,"normal_exit_requested","control",Some(&path),serde_json::json!({"AppExit":"Success","automatic":false}));
            world.write_message(AppExit::Success);},
        Ok(false)=>{},
        Err(error)=>if host.close_error.as_ref()!=Some(&error) {host.close_error=Some(error.clone());
            record(host,now,"invalid_close_control","control",Some(&path),serde_json::json!({"error":error}));},
    }
}

fn baseline(now: &Current, elapsed: f64) -> bool {
    let Some((_,tick,map))=now.accepted() else{return false};
    elapsed>=25. && map.visible && !map.available && tick<map.ready_tick && now.ring_active.is_none()
        && now.ring_particles==Some(0) && now.ring_draws==Some(0) && now.ring_error.is_none()
        && now.ring_tickets.as_ref().is_some_and(Vec::is_empty) && now.capture_particles==Some(0)
        && now.capture_draws==Some(0) && now.capture_error.is_none() && now.capture_tickets.as_ref().is_some_and(Vec::is_empty)
}
fn active(now: &Current) -> Option<RingKey> {
    let (_,_,map)=now.accepted()?;let key=now.ring_active?;
    if !map.visible || !map.available || now.identity?.0!=key.session || map.ready_tick!=key.ready_tick
        || !now.ring_particles.is_some_and(|n|n>32) || !now.ring_draws.is_some_and(|n|n>32)
        || now.ring_error.is_some() || !now.ring_tickets.as_ref().is_some_and(|v|v.len()>32 && v.iter().all(|k|*k==key)) {return None;}
    Some(key)
}
fn pickup_retirement(host: &Observation, now: &Current) -> Option<PickupKey> {
    let key=host.ring_key?;let (identity,tick,map)=now.accepted()?;let pickup=map.pickup?;
    if Some(identity)!=host.identity || now.ring_retired!=Some(key) || now.ring_active.is_some()
        || !map.visible || map.available || map.ready_tick<=key.ready_tick || pickup.session!=key.session
        || pickup.pickup_tick<key.ready_tick || pickup.pickup_tick>tick
        || host.last_available_tick.is_none_or(|t|pickup.pickup_tick<t) || host.prior_pickup_key==Some(pickup) {return None;}
    Some(pickup)
}
fn cleanup(host: &Observation, now: &Current) -> bool {
    host.ring_key.is_some() && host.retired_ring_key==host.ring_key && host.pickup_key.is_some()
        && host.pickup_completed && pickup_retirement(host,now)==host.pickup_key
        && now.ring_particles==Some(0) && now.ring_draws==Some(0) && now.ring_error.is_none()
        && now.ring_tickets.as_ref().is_some_and(Vec::is_empty) && now.capture_particles==Some(0)
        && now.capture_draws==Some(0) && now.capture_error.is_none() && now.capture_tickets.as_ref().is_some_and(Vec::is_empty)
}
fn write_report(host: &mut Observation, now: &Current) {
    if host.report_written || host.failed || !(0..3).all(|r|host.saved.contains_key(&r)) {return;}
    let Some(directory)=host.directory.as_ref() else{return};let path=directory.join("capture_report.json");
    let report=serde_json::json!({"schema":1,"pid":std::process::id(),"client_pid":std::process::id(),"role":"report","path":path,
        "complete":true,"ring_key":ring_key(host.ring_key),"retired_ring_key":ring_key(host.retired_ring_key),
        "pickup_key":pickup_key(host.pickup_key),"observed_pickup_completed":host.pickup_completed,
        "current_accepted_identity":now.accepted_identity(),"saved_ok":true,"dimensions":DIMENSIONS,
        "frames":host.saved.values().collect::<Vec<_>>(),"state_injected":false,"clock_override":false,"moves_issued":false,
        "original_pixel_parity":false,"Root_viewed":false,"normal_cleanup_requires_last_shutdown_event":true,
        "exact_GPU_exposure_time":null,"CPU_publication_is_not_draw_success":true});
    let result=(||->Result<(),String>{validate_directory(directory)?;let mut file=create_new(&path)?;
        serde_json::to_writer_pretty(&mut file,&report).map_err(|e|e.to_string())?;
        file.write_all(b"\n").map_err(|e|e.to_string())?;file.sync_all().map_err(|e|e.to_string())})();
    match result {Ok(())=>{host.report_written=true;record(host,now,"report_written","report",Some(&path),serde_json::json!({"complete":true,"saved_ok":true,"dimensions":DIMENSIONS}));},
        Err(error)=>{host.failed=true;record(host,now,"report_failed","report",Some(&path),serde_json::json!({"error":error}));}}
}
fn saved(
    event: On<ScreenshotCaptured>, query: Query<&Capture>, mut host: ResMut<Observation>,
    connection: Option<Res<crate::Connection>>, state: Option<Res<crate::Match>>,
    ring: Option<Res<crate::tt_well_ring_live::Diagnostics>>, ring_backend: Option<Res<crate::tt_well_ring_live::Backend>>,
    capture: Option<Res<crate::tt_capture_live::Diagnostics>>, capture_backend: Option<Res<crate::tt_capture_live::Backend>>,
    events: Option<Res<crate::relic_pickup_events::Host>>,
) {
    let Ok(frame)=query.get(event.entity) else{return};
    if host.close_requested || host.shutdown_journaled {return;}
    let now=current_from(connection.as_deref(),state.as_deref(),ring.as_deref(),ring_backend.as_deref(),
        capture.as_deref(),capture_backend.as_deref(),events.as_deref());
    let dimensions=[event.image.width(),event.image.height()];
    let result=(||->Result<(),String>{
        let directory=host.directory.as_ref().ok_or("observation directory absent")?;validate_directory(directory)?;
        if frame.role>2 || frame.path!=directory.join(PNGS[frame.role as usize]) {return Err("capture path/role differs from reserved path".into());}
        if dimensions!=DIMENSIONS {return Err(format!("framebuffer dimensions {dimensions:?}, expected {DIMENSIONS:?}"));}
        let image=event.image.clone().try_into_dynamic().map_err(|e|e.to_string())?.to_rgb8();
        let format=bevy::image::ImageFormat::Png.as_image_crate_format().ok_or("PNG encoding unavailable")?;
        let mut file=create_new(&frame.path)?;image.write_to(&mut file,format).map_err(|e|e.to_string())?;
        file.sync_all().map_err(|e|e.to_string())})();
    match result {
        Ok(())=>{
            let row=serde_json::json!({"schema":1,"pid":std::process::id(),"client_pid":std::process::id(),"role":ROLES[frame.role as usize],
                "path":frame.path,"saved_ok":true,"dimensions":dimensions,"request":frame.request,
                "current_accepted_identity":now.accepted_identity(),"callback_current":now.evidence(),
                "exact_GPU_exposure_time":null,"Root_viewed":false});
            host.saved.insert(frame.role,row);
            record(&mut host,&now,"framebuffer_saved",ROLES[frame.role as usize],Some(&frame.path),serde_json::json!({
                "role_index":frame.role,"saved_ok":true,"dimensions":dimensions,"request":frame.request,
                "exact_GPU_exposure_time":null,"Root_viewed":false}));
            write_report(&mut host,&now);
        },
        Err(error)=>{host.failed=true;record(&mut host,&now,"framebuffer_failed",ROLES.get(frame.role as usize).copied().unwrap_or("invalid"),Some(&frame.path),
            serde_json::json!({"role_index":frame.role,"error":error,"dimensions":dimensions,"saved_ok":false}));},
    }
}
fn request(world: &mut World, host: &mut Observation, now: &Current, elapsed: f64, role: u8) {
    let path=host.directory.as_ref().unwrap().join(PNGS[role as usize]);
    if !matches!(std::fs::symlink_metadata(&path),Err(e) if e.kind()==std::io::ErrorKind::NotFound) {
        fail(host,now,"reserved framebuffer path already exists or cannot be inspected");return;
    }
    let row=serde_json::json!({"role":ROLES[role as usize],"role_index":role,"path":path,"host_elapsed_seconds":elapsed,
        "ring_key":ring_key(host.ring_key),"retired_ring_key":ring_key(host.retired_ring_key),"pickup_key":pickup_key(host.pickup_key),
        "observed_pickup_completed":host.pickup_completed,"current_accepted_identity":now.accepted_identity(),"current":now.evidence(),
        "active_since_seconds":host.active_since,"active_persistence_seconds":host.active_since.map(|s|elapsed-s),
        "expected_dimensions":DIMENSIONS,"exact_GPU_exposure_time":null,"CPU_publication_is_not_draw_success":true});
    record(host,now,"framebuffer_requested",ROLES[role as usize],Some(&path),row.clone());
    if host.failed {return;}
    world.spawn((Screenshot::primary_window(),Capture {role,path,request:row})).observe(saved);host.stage+=1;
}
fn observe(world: &mut World) {
    let mut host=world.remove_resource::<Observation>().unwrap_or_default();
    if host.directory.is_none() {world.insert_resource(host);return;}
    let now=current(world);
    // This control remains available after a source/capture/journal failure.
    poll_close(world,&mut host,&now);
    if host.failed || host.close_requested {world.insert_resource(host);return;}
    let elapsed=world.resource::<Time>().elapsed_secs_f64();
    if !elapsed.is_finite() || elapsed<0. {fail(&mut host,&now,"observation host elapsed time is invalid");world.insert_resource(host);return;}
    if let Some(identity)=host.identity {
        if now.accepted().is_none_or(|(current,tick,_)|current!=identity || host.last_snapshot_tick.is_some_and(|old|tick<old)) {
            fail(&mut host,&now,"accepted connection/session changed or snapshot tick regressed after baseline");world.insert_resource(host);return;
        }
    }
    if host.identity.is_some() {host.last_snapshot_tick=now.snapshot.map(|(_,tick,_)|tick);}
    if let Some(key)=host.ring_key {
        if let Some((_,tick,map))=now.accepted() {
            if now.ring_active==Some(key) && map.visible && map.available && map.ready_tick==key.ready_tick {host.last_available_tick=Some(tick);}
        }
        if now.ring_active!=Some(key) && host.retired_ring_key.is_none() {
            if let Some(pickup)=pickup_retirement(&host,&now) {
                host.retired_ring_key=Some(key);host.pickup_key=Some(pickup);
                record(&mut host,&now,"exact_ring_pickup_retired","cleanup",None,serde_json::json!({"true_pickup_source":true}));
                if host.stage<2 {fail(&mut host,&now,"Ring retired before the active persistence capture was requested");}
            } else {fail(&mut host,&now,"observed Ring key retired/replaced without the exact new visible pickup source");}
        }
    }
    if let Some(key)=host.pickup_key {
        if !host.pickup_completed && now.completed_pickups.contains(&key) {
            host.pickup_completed=true;record(&mut host,&now,"exact_capture_pickup_completed","cleanup",None,serde_json::json!({"completion_reason":"completed"}));
        }
    }
    if !host.failed {
        match host.stage {
            0 if baseline(&now,elapsed)=>{
                host.identity=now.identity;host.last_snapshot_tick=now.snapshot.map(|(_,tick,_)|tick);
                request(world,&mut host,&now,elapsed,0);
            },
            0 if elapsed>=25. && now.accepted().is_some_and(|(_,_,m)|m.visible && m.available)=>
                fail(&mut host,&now,"baseline cannot establish before-available state: relic already visibly available"),
            1 if host.saved.contains_key(&0)=>{
                if let Some(key)=active(&now) {
                    if host.ring_key.is_some_and(|old|old!=key) {fail(&mut host,&now,"Ring key changed during active persistence");}
                    else {
                        if host.ring_key.is_none() {host.ring_key=Some(key);host.prior_pickup_key=now.map.and_then(|m|m.pickup);
                            host.last_available_tick=now.snapshot.map(|(_,tick,_)|tick);
                            record(&mut host,&now,"active_threshold_observed","active",None,serde_json::json!({"threshold_exclusive":32}));}
                        let since=*host.active_since.get_or_insert(elapsed);
                        if elapsed-since>=1. {request(world,&mut host,&now,elapsed,1);}
                    }
                } else {host.active_since=None;}
            },
            2 if host.saved.contains_key(&1) && cleanup(&host,&now)=>request(world,&mut host,&now,elapsed,2),
            _=>{},
        }
    }
    world.insert_resource(host);
}
fn shutdown(world: &mut World) {
    if !world.get_resource::<Messages<AppExit>>().is_some_and(|m|!m.is_empty()) {return;}
    let mut host=world.remove_resource::<Observation>().unwrap_or_default();
    if host.directory.is_some() && !host.shutdown_journaled {
        let now=current(world);host.shutdown_journaled=true;
        record(&mut host,&now,"TT_Well_Ring_normal_cleanup_observed","shutdown",None,serde_json::json!({
            "normal_cleanup":now.ring_normal_cleanup,"retained_ring_draws":now.ring_tickets.as_ref().map(Vec::len),
            "capture_normal_cleanup":now.capture_normal_cleanup,"retained_capture_draws":now.capture_tickets.as_ref().map(Vec::len),
            "error":now.ring_error,"successful_exit_still_requires_process_and_transport_observation":true}));
    }
    world.insert_resource(host);
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Observation>().add_systems(Startup,setup)
            .add_systems(PostUpdate,observe.after(crate::tt_well_ring_live::synchronize)
                .after(crate::tt_capture_live::synchronize).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility))
            .add_systems(Last,shutdown.after(crate::tt_well_ring_live::shutdown).after(crate::tt_capture_live::shutdown));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn key() -> RingKey {RingKey {session:7,ready_tick:100,generation:2}}
    fn pickup(tick:u64,picker:u32) -> PickupKey {PickupKey {session:7,pickup_tick:tick,picker}}
    fn current_empty() -> Current {Current {identity:Some((7,1,Some(3))),snapshot:Some((7,30,false)),
        map:Some(MapEvidence {visible:true,available:false,ready_tick:100,pickup:None}),
        ring_particles:Some(0),ring_draws:Some(0),ring_tickets:Some(vec![]),
        capture_particles:Some(0),capture_draws:Some(0),capture_tickets:Some(vec![]),..Default::default()}}
    #[test]
    fn baseline_requires_visible_future_ready_tick_and_25_seconds() {
        let mut now=current_empty();assert!(baseline(&now,25.));assert!(!baseline(&now,24.999));
        now.map.as_mut().unwrap().visible=false;now.map.as_mut().unwrap().ready_tick=0;assert!(!baseline(&now,25.));
        now.map.as_mut().unwrap().visible=true;now.map.as_mut().unwrap().ready_tick=30;assert!(!baseline(&now,25.));
    }
    #[test]
    fn active_requires_ring_tickets_beyond_32_for_one_exact_key() {
        let mut now=current_empty();now.snapshot=Some((7,110,false));now.map.as_mut().unwrap().available=true;
        now.ring_active=Some(key());now.ring_particles=Some(33);now.ring_draws=Some(33);now.ring_tickets=Some(vec![key();33]);
        assert_eq!(active(&now),Some(key()));now.ring_draws=Some(32);assert!(active(&now).is_none());
        now.ring_draws=Some(33);now.ring_tickets.as_mut().unwrap()[32].generation+=1;assert!(active(&now).is_none());
    }
    #[test]
    fn cleanup_needs_the_new_pickup_exact_completion_and_all_capture_tickets_empty() {
        let mut host=Observation {identity:Some((7,1,Some(3))),ring_key:Some(key()),retired_ring_key:Some(key()),
            pickup_key:Some(pickup(120,1)),prior_pickup_key:Some(pickup(50,1)),last_available_tick:Some(119),..Default::default()};
        let mut now=current_empty();now.snapshot=Some((7,121,false));now.ring_retired=Some(key());
        now.map=Some(MapEvidence {visible:true,available:false,ready_tick:500,pickup:Some(pickup(120,1))});
        now.completed_pickups=vec![pickup(120,2)];assert!(!now.completed_pickups.contains(&host.pickup_key.unwrap()));assert!(!cleanup(&host,&now));
        host.pickup_completed=true;assert!(cleanup(&host,&now));
        now.capture_tickets=Some(vec![pickup(120,2)]);assert!(!cleanup(&host,&now));now.capture_tickets=Some(vec![]);
        now.map.as_mut().unwrap().visible=false;assert!(pickup_retirement(&host,&now).is_none());assert!(!cleanup(&host,&now));
        now.map.as_mut().unwrap().visible=true;now.ring_retired.as_mut().unwrap().generation+=1;assert!(pickup_retirement(&host,&now).is_none());
    }
    #[test]
    fn close_control_is_typed_exact_bounded_and_rejects_extra_or_duplicate_fields() {
        assert!(parse_close(br#"{"schema":1,"client_pid":42}"#,42).is_ok());
        for bad in [br#"{"schema":1,"client_pid":43}"#.as_slice(),br#"{"schema":1,"client_pid":"42"}"#,
            br#"{"schema":1.0,"client_pid":42}"#,br#"{"schema":1,"client_pid":42,"auto":true}"#,
            br#"{"schema":1,"schema":1,"client_pid":42}"#,br#"[1,42]"#] {assert!(parse_close(bad,42).is_err());}
        assert!(parse_close(&vec![b' ';1025],42).is_err());
    }
}
