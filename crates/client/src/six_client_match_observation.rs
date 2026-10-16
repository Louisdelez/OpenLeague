//! SOURCE CANDIDATE ONLY: bounded, opt-in ordinary GUI connection automation.
//! No Simulation, synthetic state, privileged command, clock, companion UDP socket,
//! OS input or automatic close is used. Existing client consumers own game/render/UI.
use bevy::{prelude::*, render::view::screenshot::{ScreenshotCaptured}};
use openleague_core::{Action, Point, Snapshot};
use std::{io::{Read, Write, Seek, SeekFrom}, path::{Path, PathBuf},fs::{File,OpenOptions,Metadata}};

#[path="six_gui_capture_copy_join.rs"]
pub(crate) mod copy_join;

const ENV: &str = "OPENLEAGUE_SIX_GUI_OBSERVATION";
const REQUEST_LIMIT: u64 = 4096;
const STATE_LIMIT: usize = 2 * 1024 * 1024;
const MAX_SOURCE_AGE: u64 = 90;
const LOG_ROOT:&str="E:/OpenLeague/logs";

#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
struct Owner { session: u64, player: u32, epoch: Option<u64> }
#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Deserialize, serde::Serialize)]
#[serde(rename_all = "snake_case")]
enum Label { Baseline, Combat, Splash, Results, SpellW, SpellE, SpellR }
impl Label {
    fn name(self) -> &'static str { match self {
        Self::Baseline => "baseline", Self::Combat => "combat",
        Self::Splash => "splash", Self::Results => "results",
        Self::SpellW=>"spell_w",Self::SpellE=>"spell_e",Self::SpellR=>"spell_r",
    }}
    fn spell(self)->bool{matches!(self,Self::SpellW|Self::SpellE|Self::SpellR)}
    fn scene(self)->bool{matches!(self,Self::Baseline|Self::Combat|Self::SpellW|Self::SpellE|Self::SpellR)}
}
#[derive(Clone, Copy, Debug, serde::Deserialize, serde::Serialize)]
#[serde(tag = "kind", rename_all = "snake_case", deny_unknown_fields)]
enum Operation {
    Move { x: f32, z: f32 }, Attack { target: u32 }, Stop,
    Buy { item: u32 }, Learn { slot: u8 }, Cast { slot: u8, target: Option<u32> },
    CastAt { slot: u8, x: f32, z: f32 },
    Capture { label: Label }, CameraLock { expected_revision: u64, expected_locked: bool }, CameraRestore, Continue, Return,
}
#[derive(Debug, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
    schema: u32, client_pid: u32, ordinal: u64, owner: Owner,
    source_tick: u64, operation: Operation,
}
#[derive(Debug, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Close { schema: u32, client_pid: u32 }

#[derive(Resource)]
struct Host {
    directory: PathBuf, next_request: u64, owner: Option<Owner>,
    last_tick: Option<u64>, next_state: f64, state_bytes: Vec<u8>,
    failed: Option<String>, close_bytes: Option<Vec<u8>>, close_error: Option<String>, close_requested: bool,
    gesture: Option<Gesture>, captures: std::collections::HashSet<&'static str>,
    pending_capture: Option<Label>, state_serial: u64,
    camera_lease: Option<crate::camera_lock::Lease>, camera_revision: Option<u64>, camera_acquisition_ordinal: Option<u64>, camera_attempted: bool,
}
#[derive(Component,Clone,Copy,PartialEq,Eq)]
struct OwnedGesture { owner: Owner, result: (u64,u8), ordinal: u64 }
struct Gesture { entity: Entity, previous: Interaction, was_pressed: bool, phase: u8, ordinal: u64, role: &'static str, guard: OwnedGesture }
#[derive(Component,Clone)]
struct Capture { owner: Owner, tick: u64, result: Option<(u64, u8)>, label: Label, path: PathBuf, ordinal: u64,
    resource_token: Option<serde_json::Value>, follow_revision: Option<u64>, combat_evidence:Option<CombatEvidence>, spell_evidence:Option<SpellEvidence> }
#[derive(Component)]
struct CapturedImage { image: Image, callback_tick: Option<u64> }
#[derive(Resource,Default)]
struct FollowSample { serial:u64, owner:Option<crate::camera_lock::Owner>, revision:Option<u64>,
    source_tick:Option<u64>, followed:bool, target:Option<Vec3>, focus:Option<Vec3> }
#[derive(SystemSet,Debug,Clone,Copy,PartialEq,Eq,Hash)]
struct FollowObserved;

fn reparse(metadata:&Metadata)->bool {
    if metadata.file_type().is_symlink(){return true;}
    #[cfg(windows)]{use std::os::windows::fs::MetadataExt;if metadata.file_attributes()&0x400!=0{return true;}}
    false
}
fn no_follow(options:&mut OpenOptions){
    #[cfg(windows)]{use std::os::windows::fs::OpenOptionsExt;options.custom_flags(0x0020_0000);}
    #[cfg(not(windows))]{let _=options;}
}
fn validate_directory(directory:&Path)->Result<(),String>{
    let root=Path::new(LOG_ROOT);
    for path in [root,directory]{let metadata=std::fs::symlink_metadata(path).map_err(|e|e.to_string())?;
        if !metadata.is_dir()||reparse(&metadata){return Err("observation directory/root must remain ordinary directories".into());}}
    let root=root.canonicalize().map_err(|e|e.to_string())?;let actual=directory.canonicalize().map_err(|e|e.to_string())?;
    if actual.parent()!=Some(root.as_path()){return Err("observation directory must remain a direct child of OpenLeague/logs".into());}Ok(())
}
fn open_existing(path:&Path,append:bool,write:bool)->Result<File,String>{
    validate_directory(path.parent().ok_or("evidence file has no parent")?)?;
    let metadata=std::fs::symlink_metadata(path).map_err(|e|e.to_string())?;
    if !metadata.is_file()||reparse(&metadata){return Err("ordinary non-reparse evidence file required".into());}
    let mut options=OpenOptions::new();options.read(!append).append(append).write(write);no_follow(&mut options);
    let file=options.open(path).map_err(|e|e.to_string())?;let opened=file.metadata().map_err(|e|e.to_string())?;
    if !opened.is_file()||reparse(&opened){return Err("opened evidence file must be ordinary/non-reparse".into());}Ok(file)
}
fn create_new(path:&Path)->Result<File,String>{
    validate_directory(path.parent().ok_or("new evidence file has no parent")?)?;
    let mut options=OpenOptions::new();options.write(true).create_new(true);no_follow(&mut options);
    let file=options.open(path).map_err(|e|e.to_string())?;let opened=file.metadata().map_err(|e|e.to_string())?;
    if !opened.is_file()||reparse(&opened){return Err("new evidence file is not ordinary".into());}Ok(file)
}
fn ordinary_file(path: &Path, maximum: u64) -> Result<Option<Vec<u8>>, String> {
    validate_directory(path.parent().ok_or("evidence file has no parent")?)?;
    let metadata = match std::fs::symlink_metadata(path) {
        Ok(metadata) => metadata,
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => return Ok(None),
        Err(error) => return Err(format!("metadata: {error}")),
    };
    if !metadata.is_file() || reparse(&metadata) { return Err("ordinary non-reparse file required".into()); }
    if metadata.len() > maximum { return Err("bounded evidence file too large".into()); }
    let mut bytes = Vec::new();
    let file=open_existing(path,false,false)?;
    if file.metadata().map_err(|e|e.to_string())?.len()>maximum{return Err("opened evidence file exceeds bounded size".into());}
    file.take(maximum + 1)
        .read_to_end(&mut bytes).map_err(|e| e.to_string())?;
    if bytes.len() as u64 > maximum { return Err("bounded read exceeded limit".into()); }
    Ok(Some(bytes))
}
fn reserve(raw: &std::ffi::OsStr) -> Result<Host, String> {
    let path = PathBuf::from(raw);
    let logs = PathBuf::from(LOG_ROOT);
    if !path.is_absolute() || path.components().any(|p| matches!(p, std::path::Component::ParentDir|std::path::Component::CurDir)) {
        return Err("fresh absolute observation directory required".into());
    }
    let parent = path.parent().ok_or("observation directory has no parent")?;
    let root_metadata=std::fs::symlink_metadata(&logs).map_err(|e|e.to_string())?;
    if !root_metadata.is_dir()||reparse(&root_metadata){return Err("OpenLeague/logs must be an ordinary root".into());}
    let canonical_logs = logs.canonicalize().map_err(|e| e.to_string())?;
    if parent.canonicalize().map_err(|e| e.to_string())? != canonical_logs {
        return Err("observation directory must be a direct child of OpenLeague/logs".into());
    }
    match std::fs::symlink_metadata(&path) {
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => {},
        _ => return Err("preserve existing observation directory".into()),
    }
    std::fs::create_dir(&path).map_err(|e| e.to_string())?;
    validate_directory(&path)?;
    let directory = path.canonicalize().map_err(|e| e.to_string())?;
    create_new(&directory.join("events.jsonl"))?.sync_all().map_err(|e|e.to_string())?;
    let state_bytes = b"{\"schema\":1,\"ready\":false,\"complete\":false}\n".to_vec();
    let mut state = create_new(&directory.join("state.json"))?;
    state.write_all(&state_bytes).and_then(|_| state.sync_all()).map_err(|e| e.to_string())?;
    Ok(Host { directory, next_request: 1, owner: None, last_tick: None, next_state: 0., state_bytes,
        failed: None, close_bytes: None, close_error: None, close_requested: false, gesture: None,
        captures: Default::default(), pending_capture: None, state_serial: 0,
        camera_lease: None, camera_revision: None, camera_acquisition_ordinal: None, camera_attempted: false })
}
fn row(host: &mut Host, event: &str, value: serde_json::Value) {
    let document = serde_json::json!({"schema":1,"client_pid":std::process::id(),"event":event,
        "owner":host.owner,"last_received_tick":host.last_tick,"next_request":host.next_request,"details":value,
        "physical_input":false,"complete":false});
    let result = (|| -> Result<(),String> {
        validate_directory(&host.directory)?;
        let mut stream = open_existing(&host.directory.join("events.jsonl"),true,false)?;
        if stream.metadata().map_err(|e|e.to_string())?.len()>64*1024*1024{return Err("journal exceeds64MiB".into());}
        writeln!(stream, "{document}").map_err(|e|e.to_string())?; stream.flush().map_err(|e|e.to_string())
    })();
    if let Err(error) = result { host.failed = Some(format!("observation journal: {error}")); }
}
fn fail(host: &mut Host, message: String) {
    if host.failed.is_none() { host.failed = Some(message.clone()); row(host, "failed", serde_json::json!({"reason":message})); }
}
fn owner(connection: &crate::Connection) -> Option<Owner> {
    connection.inventory_input_identity().map(|(session, player, epoch)| Owner { session, player, epoch })
}
fn validate_typed(bytes: &[u8], pid: u32, ordinal: u64, accepted: Owner, tick: u64) -> Result<Request, String> {
    if bytes.len() as u64 > REQUEST_LIMIT { return Err("request exceeds4096 bytes".into()); }
    if bytes.iter().find(|b|!b.is_ascii_whitespace())!=Some(&b'{'){return Err("request must be a JSON object".into());}
    let request: Request = serde_json::from_slice(bytes).map_err(|e| format!("typed request: {e}"))?;
    let shape:serde_json::Value=serde_json::from_slice(bytes).map_err(|e|e.to_string())?;
    if !shape["owner"].is_object()||!shape["operation"].is_object(){return Err("owner and operation must be JSON objects".into());}
    if request.schema != 1 || request.client_pid != pid || request.ordinal != ordinal || ordinal == 0
        || request.owner != accepted { return Err("request schema/PID/ordinal/accepted owner differs".into()); }
    if request.source_tick > tick { return Err("source tick is future".into()); }
    Ok(request)
}
fn validate(bytes:&[u8],pid:u32,ordinal:u64,accepted:Owner,tick:u64)->Result<Request,String> {
    let request=validate_typed(bytes,pid,ordinal,accepted,tick)?;
    if tick-request.source_tick>MAX_SOURCE_AGE{return Err("source tick is older than90 ticks".into());}
    Ok(request)
}
// Dynamic ordinary races are outcomes; typed/owner/protocol errors stay fatal.
enum GameplayAdmission { NotGameplay, Send(Action), Rejected(&'static str), Expired{age:u64} }
fn next_consumed_ordinal(ordinal:u64)->Result<u64,String> {
    ordinal.checked_add(1).ok_or_else(||"request ordinal overflow".into())
}
fn target_available(local:u32,team:u8,target:u32,opponent:Option<(u8,f32)>)
    ->Result<Option<&'static str>,String> {
    if target==local {return Err("ordinary enemy target cannot be the local owner".into());}
    let Some((other_team,health))=opponent else{return Ok(Some("target_not_visible"));};
    if other_team==team {return Err("ordinary enemy target belongs to the local team".into());}
    if !health.is_finite(){return Err("ordinary target health is not finite".into());}
    if health<=0. {return Ok(Some("target_not_alive"));} Ok(None)
}
fn enemy(snapshot:&Snapshot,local:u32,target:u32)->Result<Option<&'static str>,String> {
    let player=snapshot.players.iter().find(|p|p.id==local)
        .ok_or("local actor absent from received owner snapshot")?;
    let opponent=snapshot.players.iter().find(|p|p.id==target).map(|p|(p.team,p.health))
        .or_else(||snapshot.units.iter().find(|u|u.id==target).map(|u|(u.team,u.health)));
    target_available(local,player.team,target,opponent)
}
fn action_shape(operation:&Operation)->Result<Option<Action>,String> {
    let action=match *operation {
        Operation::Move{x,z}=>{if !x.is_finite()||!z.is_finite(){return Err("finite movement point required".into());}Action::Move{point:Point{x,z}}},
        Operation::Attack{target}=>Action::Attack{target}, Operation::Stop=>Action::Stop,
        Operation::Buy{item}=>{if item==0{return Err("nonzero item required".into());}Action::Buy{item}},
        Operation::Learn{slot}=>{if slot>3{return Err("skill slot exceeds3".into());}Action::Learn{slot}},
        Operation::Cast{slot,target}=>{
            if slot>3||(slot<3&&target.is_some())||(slot==3&&target.is_none()) {
                return Err("unsupported cast target/slot".into());
            }Action::Cast{slot,target}
        },
        Operation::CastAt{slot,x,z}=>{
            if !matches!(slot,1|2)||!x.is_finite()||!z.is_finite(){return Err("finite W/E ground point and slot1/2 required".into());}
            Action::CastAt{slot,point:Point{x,z}}
        }, _=>return Ok(None),
    }; Ok(Some(action))
}
fn dynamic_phase(terminal:bool,health:f32)->Result<Option<&'static str>,String> {
    if !health.is_finite(){return Err("local owner health is not finite".into());}
    if terminal{return Ok(Some("match_became_terminal"));}
    if health<=0. {return Ok(Some("local_champion_not_alive"));} Ok(None)
}
fn gameplay(operation:&Operation,snapshot:&Snapshot,id:u32)->Result<GameplayAdmission,String> {
    let Some(action)=action_shape(operation)? else{return Ok(GameplayAdmission::NotGameplay);};
    let local=snapshot.players.iter().find(|p|p.id==id).ok_or("local actor unavailable from accepted owner snapshot")?;
    if let Operation::Cast{slot,target}=*operation {
        let supported=local.champion=="garen"||(local.champion=="trundle"&&((slot==0&&target.is_none())||(slot==3&&target.is_some())));
        if !supported {
            return Err("only Garen casts and Trundle targetless Q or targeted R are admitted; other champion casts remain unsupported".into());
        }
    }
    if matches!(operation,Operation::CastAt{..}) && local.champion!="trundle" {
        return Err("only canonical Trundle W/E ground casts are admitted".into());
    }
    if let Some(reason)=dynamic_phase(snapshot.winner.is_some()||snapshot.result.is_some(),local.health)? {
        return Ok(GameplayAdmission::Rejected(reason));
    }
    let target=match *operation {Operation::Attack{target}|Operation::Cast{target:Some(target),..}=>Some(target),_=>None};
    if let Some(target)=target {if let Some(reason)=enemy(snapshot,id,target)? {return Ok(GameplayAdmission::Rejected(reason));}}
    // Range, navigation, dependencies, gold, rank, cooldown and damage remain
    // ordinary server validation. Send metadata cannot qualify server acceptance.
    Ok(GameplayAdmission::Send(action))
}
// Past source expiration is an explicit owned no-send outcome, never a new tick
// attached to an old operation. Invalid shape/owner/future input remains fatal.
fn gameplay_at_source(operation:&Operation,snapshot:&Snapshot,id:u32,source_tick:u64)->Result<GameplayAdmission,String> {
    if source_tick>snapshot.tick{return Err("source tick is future".into());}
    // Pure validation first: includes finite geometry, slots, supported Garen
    // casts, Trundle Q/R or W/E ground, current local membership/health and fatal own/friendly targets.
    let admission=gameplay(operation,snapshot,id)?;
    let age=snapshot.tick-source_tick;
    if age>MAX_SOURCE_AGE {
        return match admission {
            GameplayAdmission::NotGameplay=>Err("non-gameplay source is older than90 ticks".into()),
            _=>Ok(GameplayAdmission::Expired{age}),
        };
    }
    Ok(admission)
}
enum GameplayDispatch {NotGameplay,Sent(serde_json::Value),Rejected(&'static str),Expired{age:u64}}
fn dispatch_gameplay(admission:GameplayAdmission,send:impl FnOnce(Action)->Result<serde_json::Value,String>)
    ->Result<GameplayDispatch,String> {
    Ok(match admission {
        GameplayAdmission::NotGameplay=>GameplayDispatch::NotGameplay,
        GameplayAdmission::Send(action)=>GameplayDispatch::Sent(send(action)?),
        GameplayAdmission::Rejected(reason)=>GameplayDispatch::Rejected(reason),
        GameplayAdmission::Expired{age}=>GameplayDispatch::Expired{age},
    })
}

fn one<T: Component>(world: &mut World) -> Option<Entity> {
    let mut query = world.query_filtered::<Entity, With<T>>(); let mut rows = query.iter(world);
    let entity = rows.next()?; rows.next().is_none().then_some(entity)
}
fn visible_under<T: Component>(world: &World, entity: Entity) -> bool {
    if !world.get::<Node>(entity).is_some_and(|n| n.display != Display::None) { return false; }
    let mut parent = world.get::<ChildOf>(entity).map(|p| p.parent()); let mut seen = std::collections::HashSet::new();
    while let Some(entity) = parent {
        if !seen.insert(entity) || seen.len() > 32 { return false; }
        if !world.get::<Node>(entity).is_some_and(|n| n.display != Display::None) { return false; }
        if world.get::<T>(entity).is_some() { return true; }
        parent = world.get::<ChildOf>(entity).map(|p| p.parent());
    }
    false
}
fn terminal(snapshot: &Snapshot, accepted: Owner) -> Result<(u64, u8), String> {
    let result = snapshot.result.as_ref().ok_or("no actual terminal result")?;
    if snapshot.session != accepted.session || result.session != accepted.session || result.winner > 1
        || snapshot.winner != Some(result.winner) || !result.players.iter().any(|p| p.id == accepted.player) {
        return Err("terminal result does not bind this accepted owner".into());
    }
    Ok((result.ended_tick, result.winner))
}
fn begin_gesture(world: &mut World, host: &mut Host, entity: Entity, ordinal: u64, role: &'static str, accepted: Owner, result: (u64,u8)) -> Result<(), String> {
    if host.gesture.is_some() { return Err("another owned gesture is pending".into()); }
    if world.get::<OwnedGesture>(entity).is_some() { return Err("preserve a foreign pending button owner".into()); }
    let previous = *world.get::<Interaction>(entity).ok_or("normal button has no Interaction")?;
    let was_pressed = world.resource::<ButtonInput<MouseButton>>().pressed(MouseButton::Left);
    if was_pressed || previous == Interaction::Pressed { return Err("preserve an already pressed human input".into()); }
    *world.get_mut::<Interaction>(entity).ok_or("button retired")? = Interaction::Pressed;
    world.resource_mut::<ButtonInput<MouseButton>>().press(MouseButton::Left);
    let guard=OwnedGesture{owner:accepted,result,ordinal};world.entity_mut(entity).insert(guard);
    host.gesture = Some(Gesture { entity, previous, was_pressed, phase: 0, ordinal, role, guard });
    row(host, "normal_button_press", serde_json::json!({"ordinal":ordinal,"role":role,"entity":format!("{entity:?}"),"programmatic":true}));
    Ok(())
}
fn step_gesture(world: &mut World, host: &mut Host) {
    let Some(mut gesture) = host.gesture.take() else { return; };
    let current=owner(world.resource::<crate::Connection>());
    let result=world.resource::<crate::Match>().snapshot.as_ref().and_then(|s|terminal(s,gesture.guard.owner).ok());
    let owned=world.get::<OwnedGesture>(gesture.entity)==Some(&gesture.guard);
    if !gesture_owner_matches(gesture.guard,current,result,world.get::<OwnedGesture>(gesture.entity).copied()) {
        // Removing only our marker is safe across an owner replacement. Never
        // release ButtonInput or change a new owner's normal button interaction.
        if owned {world.entity_mut(gesture.entity).remove::<OwnedGesture>();}
        fail(host,"button owner/result/marker changed before its next gesture frame".into());return;
    }
    if gesture.phase == 0 {
        if let Some(mut interaction) = world.get_mut::<Interaction>(gesture.entity) { *interaction = Interaction::Hovered; }
        else { fail(host, "owned normal button retired before release".into()); }
        world.resource_mut::<ButtonInput<MouseButton>>().release(MouseButton::Left);
        row(host, "normal_button_release_inside", serde_json::json!({"ordinal":gesture.ordinal,"role":gesture.role,"entity":format!("{:?}",gesture.entity),"programmatic":true}));
        gesture.phase = 1; host.gesture = Some(gesture);
    } else {
        if let Some(mut interaction) = world.get_mut::<Interaction>(gesture.entity) {
            if *interaction == Interaction::Hovered || *interaction == Interaction::Pressed { *interaction = gesture.previous; }
        }
        if !gesture.was_pressed { world.resource_mut::<ButtonInput<MouseButton>>().release(MouseButton::Left); }
        world.entity_mut(gesture.entity).remove::<OwnedGesture>();
        row(host, "normal_button_gesture_retired", serde_json::json!({"ordinal":gesture.ordinal,"role":gesture.role}));
    }
}
fn gesture_owner_matches(expected:OwnedGesture,current:Option<Owner>,result:Option<(u64,u8)>,marker:Option<OwnedGesture>)->bool{
    current==Some(expected.owner)&&result==Some(expected.result)&&marker==Some(expected)
}
fn poll_close(world: &mut World, host: &mut Host) {
    if host.close_requested { return; }
    let bytes = match ordinary_file(&host.directory.join("close.json"), 1024) {
        Ok(Some(bytes)) => bytes, Ok(None) => return,
        Err(error) => { if host.close_error.as_ref() != Some(&error) { host.close_error=Some(error.clone()); row(host, "invalid_close", serde_json::json!({"reason":error})); } return; },
    };
    if host.close_bytes.as_deref() == Some(&bytes) { return; } host.close_bytes = Some(bytes.clone());
    let parsed = parse_close(&bytes,std::process::id());
    if parsed.is_err() {
        row(host, "invalid_close", serde_json::json!({"reason":"typed schema1/current-PID close required"})); return;
    }
    host.close_error = None;
    host.close_requested = true;
    restore_camera(world,host,"explicit_owned_cleanup");
    let failure=host.failed.clone();row(host, "cleanup_AppExit_requested", serde_json::json!({"failed":failure,"AppExit":"Success","normal_results_return":false}));
    world.write_message(bevy::app::AppExit::Success);
}
fn parse_close(bytes:&[u8],pid:u32)->Result<Close,String>{
    if bytes.len()>1024||bytes.iter().find(|b|!b.is_ascii_whitespace())!=Some(&b'{'){return Err("bounded JSON close object required".into());}
    let close:Close=serde_json::from_slice(bytes).map_err(|e|e.to_string())?;
    if close.schema!=1||close.client_pid!=pid{return Err("schema1/current PID close required".into());}Ok(close)
}
fn camera_owner(world:&mut World,accepted:Owner)->Result<crate::camera_lock::Owner,String> {
    let window=one::<bevy::window::PrimaryWindow>(world).filter(|e|world.get::<Window>(*e).is_some()).ok_or("unique ordinary primary Window absent")?;
    let expected=crate::camera_lock::Owner{pid:std::process::id(),session:accepted.session,player:accepted.player,epoch:accepted.epoch,primary_window:window};
    if world.get_resource::<crate::camera_lock::Setting>().and_then(|s|s.owner())!=Some(expected){return Err("normal CameraLock has foreign owner/window/epoch".into());}
    Ok(expected)
}
fn human_camera_busy(world:&World)->bool {
    let keys=world.get_resource::<ButtonInput<KeyCode>>();
    let keys_busy=keys.is_some_and(|keys|[KeyCode::Space,KeyCode::KeyY,KeyCode::ArrowLeft,KeyCode::ArrowRight,KeyCode::ArrowUp,KeyCode::ArrowDown]
        .iter().any(|key|keys.pressed(*key)||keys.just_pressed(*key)||keys.just_released(*key)));
    let mouse_busy=world.get_resource::<ButtonInput<MouseButton>>().is_some_and(|mouse|[MouseButton::Left,MouseButton::Right,MouseButton::Middle]
        .iter().any(|button|mouse.pressed(*button)||mouse.just_pressed(*button)||mouse.just_released(*button)));
    keys_busy||mouse_busy||world.get_resource::<crate::camera_lock_ui::Capture>().is_some_and(|c|c.blocks_world_pointer())
}
fn camera_recoverable(error:crate::camera_lock::Rejection)->bool {
    use crate::camera_lock::Rejection::*;
    matches!(error,Unavailable|NotReady|Terminal|HumanGate|StaleSerial|StaleRevision|StaleState)
}
fn acquire_camera(world:&mut World,host:&mut Host,request:&Request,accepted:Owner,expected_revision:u64,expected_locked:bool,disposition:&mut &str)->Result<(),String>{
    if host.camera_attempted||host.camera_lease.is_some(){return Err("only one observer camera acquisition is allowed; preserve later human changes".into());}
    let camera_owner=camera_owner(world,accepted)?;
    if human_camera_busy(world){
        *disposition="camera_deferred";row(host,"normal_camera_lock_deferred",serde_json::json!({"ordinal":request.ordinal,"reason":"preserve current human camera/pointer gesture","recoverable":true}));return Ok(());
    }
    let setting=world.get_resource::<crate::camera_lock::Setting>().ok_or("normal CameraLock setting absent")?;
    let serial=setting.last_serial().checked_add(1).ok_or("normal CameraLock serial exhausted")?;
    let command=crate::camera_lock::Request{owner:camera_owner,serial,expected_revision,expected_locked,locked:true,origin:crate::camera_lock::Origin::Observer(request.ordinal)};
    let result=world.resource_mut::<crate::camera_lock::Setting>().acquire_observer(command);
    match result {
        Ok(lease)=>{host.camera_attempted=true;host.camera_lease=Some(lease);host.camera_revision=Some(world.resource::<crate::camera_lock::Setting>().revision());host.camera_acquisition_ordinal=Some(request.ordinal);
            *disposition="camera_setting_accepted";
            row(host,"normal_camera_lock_accepted",serde_json::json!({"ordinal":request.ordinal,"source_tick":request.source_tick,"serial":serial,"revision":host.camera_revision,
                "public_consumer":"camera_lock::Setting::acquire_observer -> consume","normal_drive_follow_observed":false,"physical_input":false}));Ok(())},
        Err(error) if camera_recoverable(error)=>{*disposition="camera_deferred";row(host,"normal_camera_lock_deferred",serde_json::json!({"ordinal":request.ordinal,"reason":format!("{error:?}"),"recoverable":true,"newer_human_state_preserved":true}));Ok(())},
        Err(error)=>Err(format!("normal CameraLock owner/lease/exhaustion violation: {error:?}")),
    }
}
fn restore_camera(world:&mut World,host:&mut Host,reason:&str) {
    let Some(lease)=host.camera_lease.take()else{return;};
    if human_camera_busy(world){
        row(host,"normal_camera_lock_restoration",serde_json::json!({"reason":reason,"acquisition_ordinal":host.camera_acquisition_ordinal,"owned_revision":host.camera_revision,
            "outcome":"refused_current_human_camera_or_pointer_gesture","restored":false,"conditional_only":true,"human_or_new_owner_changes_preserved":true,"physical_input":false}));
        host.camera_revision=None;return;
    }
    let serial=world.get_resource::<crate::camera_lock::Setting>().and_then(|s|s.last_serial().checked_add(1));
    let result=match serial {Some(serial)=>world.get_resource_mut::<crate::camera_lock::Setting>().map(|mut s|s.restore_observer(&lease,serial)),None=>None};
    row(host,"normal_camera_lock_restoration",serde_json::json!({"reason":reason,"acquisition_ordinal":host.camera_acquisition_ordinal,"owned_revision":host.camera_revision,
        "serial":serial,"outcome":format!("{result:?}"),"restored":result.as_ref().is_some_and(|r|r.is_ok()),
        "conditional_only":true,"human_or_new_owner_changes_preserved":true,"physical_input":false}));
    host.camera_revision=None;
}
fn follow_matches(expected:crate::camera_lock::Owner,revision:u64,sample:&FollowSample)->bool {
    sample.serial>0&&sample.owner==Some(expected)&&sample.revision==Some(revision)&&sample.followed
        &&sample.target.is_some_and(|t|t.is_finite())&&sample.focus==sample.target
}
fn observe_normal_follow(world:&mut World) {
    let mut sample=world.remove_resource::<FollowSample>().unwrap_or_default();
    let Some(serial)=sample.serial.checked_add(1)else{sample.followed=false;world.insert_resource(sample);return;};
    sample=FollowSample{serial,..default()};
    if let Some(setting)=world.get_resource::<crate::camera_lock::Setting>() {
        sample.owner=setting.owner();sample.revision=Some(setting.revision());
        if setting.follows_authoritative_target(){
            if let Some(owner)=sample.owner {
                if world.get_resource::<crate::Connection>().and_then(|connection|crate::six_client_match_observation::owner(connection))==Some(Owner{session:owner.session,player:owner.player,epoch:owner.epoch}) {
                    if let Some(snapshot)=world.get_resource::<crate::Match>().and_then(|m|m.snapshot.as_ref()).filter(|s|s.session==owner.session&&s.winner.is_none()&&s.result.is_none()) {
                        sample.source_tick=Some(snapshot.tick);
                        sample.target=snapshot.players.iter().find(|p|p.id==owner.player).map(|p|Vec3::new(p.position.x,p.height,p.position.z)/20.);
                        sample.focus=world.get_resource::<crate::CameraFocus>().map(|f|f.0);
                        sample.followed=sample.target.is_some_and(|t|t.is_finite())&&sample.focus==sample.target;
                    }
                }
            }
        }
    }
    world.insert_resource(sample);
}
fn camera_follow_ready(world:&mut World,host:&Host,accepted:Owner)->bool {
    let Ok(expected)=camera_owner(world,accepted)else{return false;};
    let Some(revision)=host.camera_revision else{return false;};
    let setting=world.resource::<crate::camera_lock::Setting>();
    setting.available()&&setting.locked()&&setting.revision()==revision
        &&setting.last_origin()==host.camera_acquisition_ordinal.map(crate::camera_lock::Origin::Observer)
        &&world.get_resource::<FollowSample>().is_some_and(|sample|follow_matches(expected,revision,sample))
}
fn camera_status(world:&World,host:&Host)->serde_json::Value {
    let setting=world.get_resource::<crate::camera_lock::Setting>();let sample=world.get_resource::<FollowSample>();
    let actual_owner=setting.and_then(|s|s.owner());
    let followed=actual_owner.zip(host.camera_revision).is_some_and(|(owner,revision)|
        setting.is_some_and(|s|s.available()&&s.locked()&&s.revision()==revision&&s.last_origin()==host.camera_acquisition_ordinal.map(crate::camera_lock::Origin::Observer))
        &&sample.is_some_and(|s|follow_matches(owner,revision,s)));
    serde_json::json!({"owner":actual_owner.map(|o|serde_json::json!({"pid":o.pid,"session":o.session,"player":o.player,"epoch":o.epoch,"window":o.primary_window.to_bits()})),
        "available":setting.is_some_and(|s|s.available()),"revision":setting.map(|s|s.revision()),"locked":setting.map(|s|s.locked()),"last_serial":setting.map(|s|s.last_serial()),
        "last_origin":setting.map(|s|format!("{:?}",s.last_origin())),"observer_acquired":host.camera_lease.is_some(),"acquisition_attempted":host.camera_attempted,
        "observer_owned_revision":host.camera_revision,"acquisition_ordinal":host.camera_acquisition_ordinal,"normal_follow_observed":followed,
        "normal_follow_sample_serial":sample.map(|s|s.serial),"normal_follow_source_tick":sample.and_then(|s|s.source_tick),
        "follow_scope":"after ordinary_camera_input::drive, before native pose/clamp; actual hero model primary visibility is a separate capture barrier",
        "physical_input":false,"CameraFocus_modified_by_observer":false})
}

pub fn drive(world: &mut World) {
    let Some(mut host) = world.remove_resource::<Host>() else { return; };
    step_gesture(world, &mut host); poll_close(world, &mut host);
    if host.failed.is_some() || host.close_requested || host.gesture.is_some() || host.pending_capture.is_some() { world.insert_resource(host); return; }
    let selected = {
        let connection = world.resource::<crate::Connection>();
        owner(connection).zip(world.resource::<crate::Match>().snapshot.as_ref().cloned())
    };
    let Some((accepted, snapshot)) = selected else {
        if host.owner.is_some() { fail(&mut host, "accepted GUI connection lost readiness".into()); }
        world.insert_resource(host); return;
    };
    if snapshot.session != accepted.session { fail(&mut host, "snapshot session differs from accepted GUI owner".into()); world.insert_resource(host); return; }
    if let Some(previous) = host.owner { if previous != accepted { fail(&mut host, "GUI owner/epoch changed during observation".into()); world.insert_resource(host); return; } }
    else { host.owner = Some(accepted); row(&mut host, "accepted_GUI_owner", serde_json::json!({"tick":snapshot.tick,"champion":world.resource::<crate::Connection>().champion,"own_socket":true,"logic_companion":false})); }
    host.last_tick = Some(snapshot.tick);
    let path = host.directory.join(format!("request-{:08}.json", host.next_request));
    let request = match ordinary_file(&path, REQUEST_LIMIT) {
        Ok(None) => { world.insert_resource(host); return; },
        Ok(Some(bytes)) => validate_typed(&bytes, std::process::id(), host.next_request, accepted, snapshot.tick),
        Err(error) => Err(error),
    };
    let request = match request { Ok(request) => request, Err(error) => {
        let ordinal=host.next_request;fail(&mut host, format!("request {ordinal}: {error}")); world.insert_resource(host); return;
    }};
    let mut disposition="ordinary_UI";
    let result = (|| -> Result<(), String> {
        // Overflow must be fatal before any effect or network send.
        next_consumed_ordinal(host.next_request)?;
        match dispatch_gameplay(gameplay_at_source(&request.operation,&snapshot,accepted.player,request.source_tick)?,|action|world.resource_mut::<crate::Connection>().send_action(action))? {
            GameplayDispatch::Sent(public)=>{
                disposition="sent";
                row(&mut host,"ordinary_GUI_action_sent",serde_json::json!({"ordinal":request.ordinal,"source_tick":request.source_tick,"accepted_tick":snapshot.tick,"operation":request.operation,"public_metadata":public,"server_acceptance_inferred":false}));
                return Ok(());
            },
            GameplayDispatch::Rejected(reason)=>{
                disposition="rejected";
                row(&mut host,"ordinary_GUI_action_rejected",serde_json::json!({"ordinal":request.ordinal,"source_tick":request.source_tick,"consumption_tick":snapshot.tick,"operation":request.operation,"reason":reason,"network_sent":false,"server_acceptance_inferred":false,"recoverable":true}));
                return Ok(());
            },
            GameplayDispatch::Expired{age}=>{
                disposition="expired";
                row(&mut host,"ordinary_GUI_action_rejected",serde_json::json!({"ordinal":request.ordinal,"source_tick":request.source_tick,
                    "consumption_tick":snapshot.tick,"source_age_ticks":age,"operation":request.operation,"reason":"source_snapshot_expired",
                    "network_sent":false,"server_acceptance_inferred":false,"recoverable":true,"new_received_decision_required":true}));
                return Ok(());
            }, GameplayDispatch::NotGameplay=>{},
        }
        match request.operation {
            Operation::CameraLock { expected_revision,expected_locked } => {
                acquire_camera(world,&mut host,&request,accepted,expected_revision,expected_locked,&mut disposition)
            },
            Operation::CameraRestore => { restore_camera(world,&mut host,"explicit_observer_restore"); Ok(()) },
            Operation::Capture { label } => {
                if host.captures.contains(label.name()) { return Err("capture role already requested; preserve original pixels".into()); }
                let result = if matches!(label, Label::Splash | Label::Results) { Some(terminal(&snapshot, accepted)?) } else { None };
                let request_combat_evidence=if label==Label::Combat{combat_evidence(&snapshot,accepted,owner(world.resource::<crate::Connection>()))}else{None};
                let request_spell_evidence=spell_evidence(label,&snapshot,accepted,owner(world.resource::<crate::Connection>()));
                let ready = match label {
                    Label::Splash => one::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None),
                    Label::Results => one::<crate::match_results_ui::ResultsPanel>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None),
                    Label::Combat => request_combat_evidence.is_some(),
                    Label::SpellW|Label::SpellE|Label::SpellR=>request_spell_evidence.is_some(),
                    Label::Baseline => snapshot.winner.is_none()&&snapshot.result.is_none(),
                };
                let scene_role=label.scene();
                let resource_token=if scene_role {crate::six_gui_capture_readiness::token(world)} else {None};
                let follow_ready=!scene_role||camera_follow_ready(world,&host,accepted);
                if !ready||(scene_role&&(resource_token.is_none()||!follow_ready)) {
                    disposition="capture_deferred";
                    row(&mut host,"framebuffer_deferred",serde_json::json!({"ordinal":request.ordinal,"label":label,
                        "reason":"actual consumer/resources/normal camera follow unavailable","recoverable":true,
                        "camera_follow_ready":follow_ready,"resource_status":crate::six_gui_capture_readiness::status(world),
                        "image_saved":false,"visible_pixels_qualified":false}));return Ok(());
                }
                let Some(entity)=crate::native_minion_fade_observation::try_primary_capture(world)else{
                    disposition="capture_deferred";
                    row(&mut host,"framebuffer_deferred",serde_json::json!({"ordinal":request.ordinal,"label":label,
                        "reason":"normal primary screenshot target busy/unavailable","recoverable":true,"image_saved":false}));return Ok(());
                };
                let path = host.directory.join(format!("{}.png", label.name()));
                if std::fs::symlink_metadata(&path).is_ok() { world.despawn(entity); return Err("preserve existing capture path".into()); }
                let capture=Capture { owner: accepted, tick: snapshot.tick, result, label, path: path.clone(), ordinal: request.ordinal, resource_token:resource_token.clone(), follow_revision:host.camera_revision, combat_evidence:request_combat_evidence,spell_evidence:request_spell_evidence };
                if let Err(error)=copy_join::reserve(world,entity,&capture) {world.despawn(entity);return Err(error);}
                world.entity_mut(entity).insert((capture,bevy::render::view::screenshot::ScreenshotCopyRequest {request_id:request.ordinal})).observe(saved);
                host.captures.insert(label.name());host.pending_capture=Some(label);
                let normal_follow_revision=host.camera_revision;
                row(&mut host, "framebuffer_requested", serde_json::json!({"ordinal":request.ordinal,"label":label,"path":path,"request_tick":snapshot.tick,"result_key":result,"exact_GPU_exposure_tick":null,"resource_token":resource_token,"normal_follow_revision":normal_follow_revision,"combat_evidence":request_combat_evidence,"request_spell_evidence":request_spell_evidence,"spell_state_only_not_pose_or_model_proof":true,"combat_proof_scope":"received attack phase only; no damage/hit/native presentation/pixel inference","visible_pixels_qualified":false}));
                Ok(())
            },
            Operation::Continue | Operation::Return => {
                if matches!(request.operation,Operation::Return){restore_camera(world,&mut host,"normal_results_return");}
                let result=terminal(&snapshot, accepted)?;
                let (entity, role) = match request.operation {
                    Operation::Continue => (one::<crate::native_endgame_ui::Continue>(world).filter(|e|visible_under::<crate::native_endgame_ui::Splash>(world,*e)).ok_or("unique visible normal Continue absent")?, "continue"),
                    Operation::Return => {
                        if !world.resource::<crate::native_endgame_ui::View>().dismissed { return Err("native splash is not yet dismissed".into()); }
                        (one::<crate::session_departure::ReturnButton>(world).filter(|e|visible_under::<crate::match_results_ui::ResultsPanel>(world,*e)).ok_or("unique visible normal Return absent")?, "return")
                    }, _ => unreachable!(),
                };
                begin_gesture(world, &mut host, entity, request.ordinal, role, accepted, result)
            },
            _ => Err("unsupported observer operation".into()),
        }
    })();
    match result {
        Ok(()) => { row(&mut host,"request_consumed",serde_json::json!({"ordinal":request.ordinal,"source_tick":request.source_tick,"current_tick":snapshot.tick,"disposition":disposition}));
            host.next_request=next_consumed_ordinal(host.next_request).expect("ordinal checked before side effects");
        },
        Err(error) => fail(&mut host, format!("request {} unavailable: {error}", request.ordinal)),
    }
    world.insert_resource(host);
}
// Observation facts only. No native presentation, hit, damage, accepted command
// sequence or exact GPU exposure is inferred from an authoritative windup.
#[derive(Clone,Copy,Debug,PartialEq,Eq,serde::Serialize)]
#[serde(tag="kind",rename_all="snake_case")]
enum CombatEvidence {
    AuthoritativeWindup {source:u32,target:u32,started:u64,release:u64,snapshot_tick:u64},
    RecentGarenPresentation {source:u32,current_visible_target:u32,attack_id:u64,event_sequence:u64,event_tick:u64,snapshot_tick:u64},
}

// Received authoritative spell state only. Not damage/hit, pose/model or pixels.
#[derive(Clone,Copy,Debug,PartialEq,serde::Serialize)]
#[serde(tag="kind",rename_all="snake_case")]
enum SpellEvidence {
    FrozenDomain{source:u32,rank:u8,starts:u64,until:u64,center:Point,snapshot_tick:u64},
    Pillar{source:u32,starts:u64,until:u64,center:Point,snapshot_tick:u64},
    Subjugate{source:u32,target:u32,rank:u8,starts:u64,until:u64,pulses:u8,snapshot_tick:u64},
}
impl SpellEvidence {
    fn label(self)->Label{match self{Self::FrozenDomain{..}=>Label::SpellW,Self::Pillar{..}=>Label::SpellE,Self::Subjugate{..}=>Label::SpellR}}
    fn tick(self)->u64 {match self {Self::FrozenDomain{snapshot_tick,..}|Self::Pillar{snapshot_tick,..}|Self::Subjugate{snapshot_tick,..}=>snapshot_tick}}
    fn same_effect(self,other:Self)->bool {
        match (self,other) {
            (Self::FrozenDomain{source:a,rank:b,starts:c,until:d,center:e,..},Self::FrozenDomain{source:f,rank:g,starts:h,until:i,center:j,..})=>
                (a,b,c,d,e.x.to_bits(),e.z.to_bits())==(f,g,h,i,j.x.to_bits(),j.z.to_bits()),
            (Self::Pillar{source:a,starts:b,until:c,center:d,..},Self::Pillar{source:e,starts:f,until:g,center:h,..})=>
                (a,b,c,d.x.to_bits(),d.z.to_bits())==(e,f,g,h.x.to_bits(),h.z.to_bits()),
            (Self::Subjugate{source:a,target:b,rank:c,starts:d,until:e,..},Self::Subjugate{source:f,target:g,rank:h,starts:i,until:j,..})=>
                (a,b,c,d,e)==(f,g,h,i,j),
            _=>false,
        }
    }
}
fn spell_selection_matches(label:Label,request:Option<SpellEvidence>,selected:Option<SpellEvidence>,tick:u64)->bool {
    !label.spell() || request.zip(selected).is_some_and(|(a,b)|a.label()==label&&b.label()==label
        &&a.same_effect(b)&&b.tick()==tick&&a.tick()<=tick
        &&(match(a,b){(SpellEvidence::Subjugate{pulses:old,..},SpellEvidence::Subjugate{pulses:new,..})=>new>=old,_=>true}))
}
fn spell_evidence(label:Label,snapshot:&Snapshot,accepted:Owner,current:Option<Owner>)->Option<SpellEvidence> {
    if !label.spell()||current!=Some(accepted)||snapshot.session!=accepted.session||snapshot.winner.is_some()||snapshot.result.is_some(){return None;}
    let local=snapshot.players.iter().find(|p|p.id==accepted.player&&p.champion=="trundle"&&p.health.is_finite()&&p.health>0.)?;
    let tick=snapshot.tick;
    match label {
        Label::SpellW=>{
            let z=local.effects.trundle_w.as_ref()?;let rules=openleague_core::trundle_w::rules(z.rank).ok()?;
            if z.owner!=local.id||(local.ranks[1]<z.rank||local.ranks[1]>5)||!z.center.finite()||z.starts>tick||tick>=z.until||z.starts.checked_add(rules.duration)!=Some(z.until){return None;}
            Some(SpellEvidence::FrozenDomain{source:local.id,rank:z.rank,starts:z.starts,until:z.until,center:z.center,snapshot_tick:tick})
        },
        Label::SpellE=>{
            let all=&snapshot.trundle_e_pillars;
            if all.len()>6||all.iter().any(|p|p.owner==0||!p.center.finite()||p.starts>tick||tick>=p.until||p.starts.checked_add(6*openleague_core::TICK_RATE)!=Some(p.until))
                ||all.iter().map(|p|p.owner).collect::<std::collections::BTreeSet<_>>().len()!=all.len(){return None;}
            // Exactly the local caster's already team/FoW-filtered projection.
            // No hidden server Pillar/trajectory, rank or enemy geometry is read.
            let p=all.iter().find(|p|p.owner==local.id)?;
            Some(SpellEvidence::Pillar{source:local.id,starts:p.starts,until:p.until,center:p.center,snapshot_tick:tick})
        },
        Label::SpellR=>{
            let d=local.effects.trundle_r.as_ref()?;
            let target=snapshot.players.iter().find(|p|p.id==d.target&&p.team!=local.team&&p.health.is_finite()&&p.health>0.)?;
            if d.owner!=local.id||target.id==local.id||!(1..=3).contains(&d.rank)||(local.ranks[3]<d.rank||local.ranks[3]>3)||d.pulses>4
                ||d.starts>tick||tick>=d.until||d.starts.checked_add(8*openleague_core::TICK_RATE)!=Some(d.until)
                ||![d.total_raw,d.raw_applied,d.armor,d.mr].iter().all(|v|v.is_finite()&&*v>=0.)||d.raw_applied>d.total_raw{return None;}
            Some(SpellEvidence::Subjugate{source:local.id,target:d.target,rank:d.rank,starts:d.starts,until:d.until,pulses:d.pulses,snapshot_tick:tick})
        },_=>None,
    }
}

fn combat_evidence(snapshot:&Snapshot,accepted:Owner,current:Option<Owner>)->Option<CombatEvidence> {
    if current!=Some(accepted)||snapshot.session!=accepted.session||snapshot.winner.is_some()||snapshot.result.is_some(){return None;}
    let local=snapshot.players.iter().find(|p|p.id==accepted.player&&p.health.is_finite()&&p.health>0.)?;
    let target=local.target?;
    if enemy(snapshot,accepted.player,target)!=Ok(None){return None;}
    if let Some(windup)=local.windup.as_ref().filter(|w|w.target==target&&w.started<=snapshot.tick&&snapshot.tick<w.release&&snapshot.tick-w.started<=30) {
        return Some(CombatEvidence::AuthoritativeWindup {source:accepted.player,target,
            started:windup.started,release:windup.release,snapshot_tick:snapshot.tick});
    }
    // Existing Garen-only presentation producer is intentionally unchanged.
    // Its event has no serialized target; do not invent that association.
    if local.champion!="garen"{return None;}
    let event=snapshot.attack_events.iter().filter(|event|event.attack.source==accepted.player&&event.tick<=snapshot.tick&&snapshot.tick-event.tick<=30
        &&matches!(event.phase,openleague_core::attack_presentation::Phase::Started{..}|openleague_core::attack_presentation::Phase::Resolved{..}))
        .max_by_key(|event|event.sequence)?;
    Some(CombatEvidence::RecentGarenPresentation {source:accepted.player,current_visible_target:target,
        attack_id:event.attack.id,event_sequence:event.sequence,event_tick:event.tick,snapshot_tick:snapshot.tick})
}

fn saved(event:On<ScreenshotCaptured>,world:&World,mut commands:Commands) {
    // Receipt was inserted by the opt-in Bevy Delivery before this unchanged
    // stock event. Keep that exact event's Image; never fetch a latest screenshot.
    if copy_join::delivered(world,event.entity,&event.image) {
        commands.entity(event.entity).insert(CapturedImage {image:event.image.clone(),
            callback_tick:world.resource::<crate::Match>().snapshot.as_ref().map(|s|s.tick)});
    }
}
fn same_capture_scope(request:Option<&serde_json::Value>,current:Option<&serde_json::Value>)->bool {
    match(request,current){(Some(request),Some(current))=>request["scope"].is_object()&&request["scope"]==current["scope"],_=>false}
}
fn preserve_original(host:&Host,request:&Capture,image:&Image,path:&Path)->Result<[u32;2],String> {
    validate_directory(&host.directory)?;
    if request.ordinal==0||request.path!=host.directory.join(format!("{}.png",request.label.name()))||path.parent()!=Some(host.directory.as_path()){
        return Err("capture path differs from exact reserved role/ordinal/ordinary directory".into());
    }
    let dimensions=[image.width(),image.height()];
    if dimensions.contains(&0)||image.data.as_ref().is_none_or(|data|data.len()>32*1024*1024){return Err("native capture image is absent or exceeds32MiB".into());}
    let dynamic=image.clone().try_into_dynamic().map_err(|e|e.to_string())?;
    let mut file=create_new(path)?;
    dynamic.write_to(&mut file,bevy::image::ImageFormat::Png.as_image_crate_format().ok_or("PNG format unavailable")?).map_err(|e|e.to_string())?;
    file.sync_all().map_err(|e|e.to_string())?;Ok(dimensions)
}
fn save_captures(world:&mut World) {
    if let Some(mut host)=world.remove_resource::<Host>() {
        copy_join::drain_skips(world,&mut host);world.insert_resource(host);
    }
    let pending={let mut q=world.query_filtered::<Entity,With<CapturedImage>>();q.iter(world).collect::<Vec<_>>()};
    for entity in pending {
        let Some(request)=world.get::<Capture>(entity).cloned()else{world.entity_mut(entity).remove::<CapturedImage>();continue;};
        let Some(pixel)=world.entity_mut(entity).take::<CapturedImage>()else{continue;};
        let Some(mut host)=world.remove_resource::<Host>()else{continue;};
        let role_current=match request.label {
            Label::Splash=>!world.resource::<crate::native_endgame_ui::View>().dismissed&&one::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None),
            Label::Results=>world.resource::<crate::native_endgame_ui::View>().dismissed&&one::<crate::match_results_ui::ResultsPanel>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display!=Display::None)
                &&one::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display==Display::None),
            _=>true,
        };
        let snapshot=world.resource::<crate::Match>().snapshot.as_ref();
        // Current lifecycle and terminal result/UI remain strict. A scene's
        // nonterminal condition is separate below, never mislabeled as owner loss.
        let owned=host.pending_capture==Some(request.label)&&role_current
            &&host.owner==Some(request.owner)
            &&owner(world.resource::<crate::Connection>())==Some(request.owner)
            &&snapshot.is_some_and(|s|s.session==request.owner.session&&s.tick>=request.tick
                &&request.result.map(|k|terminal(s,request.owner)==Ok(k)).unwrap_or(true));
        if !owned {
            let path=host.directory.join(format!("{}-invalid-owner-callback-{:08}.png",request.label.name(),request.ordinal));
            let original=preserve_original(&host,&request,&pixel.image,&path);
            row(&mut host,"framebuffer_invalid_callback",serde_json::json!({"ordinal":request.ordinal,"label":request.label,"path":path,
                "image_saved":original.is_ok(),"dimensions":original.as_ref().ok(),"encoder_error":original.err(),"callback_tick":pixel.callback_tick,
                "request_owner":request.owner,"current_connection_owner":owner(world.resource::<crate::Connection>()),
                "owner_or_result_or_role_guard_failed":true,"accepted_role":false,"recoverable":false,"Root_viewed":false,"visible_pixels_qualified":false}));
            fail(&mut host,"capture callback no longer belongs to its accepted owner/result/role".into());world.insert_resource(host);continue;
        }
        let scene_role=request.label.scene();
        let current_nonterminal=world.resource::<crate::Match>().snapshot.as_ref()
            .is_some_and(|s|s.winner.is_none()&&s.result.is_none());
        let current_follow_ready=!scene_role||(request.follow_revision==host.camera_revision&&camera_follow_ready(world,&host,request.owner));
        let callback_combat_evidence=if request.label==Label::Combat {
            world.resource::<crate::Match>().snapshot.as_ref().and_then(|s|combat_evidence(s,request.owner,owner(world.resource::<crate::Connection>())))
        }else{None};
        // No current/latest/fresh(<=2) GPU assessment authorizes this copy.
        let proof=copy_join::take(world,entity,&request);
        let verified=proof.as_ref().is_ok_and(|p|p.verified);
        let selected_tick=proof.as_ref().ok().and_then(|p|p.selected_tick);
        let selected_combat=proof.as_ref().ok().and_then(|p|p.selected_combat);
        let selected_spell=proof.as_ref().ok().and_then(|p|p.selected_spell);
        let callback_spell_evidence=world.resource::<crate::Match>().snapshot.as_ref().and_then(|s|spell_evidence(request.label,s,request.owner,owner(world.resource::<crate::Connection>())));
        let copied_phase_ready=(request.label!=Label::Combat||selected_combat.is_some())
            &&(!request.label.spell()||selected_spell.is_some());
        let dimensions=[pixel.image.width(),pixel.image.height()];
        let save_tick=world.resource::<crate::Match>().snapshot.as_ref().map(|s|s.tick);
        let actual_tick_order=selected_tick.is_some_and(|selected|
            pixel.callback_tick.is_some_and(|callback|callback>=selected
                &&save_tick.is_some_and(|save|save>=callback)));
        let qualified_role=verified&&copied_phase_ready&&actual_tick_order&&current_follow_ready&&(!scene_role||current_nonterminal)&&dimensions==[1280,800];
        let diagnostic=proof.as_ref().map(|p|p.diagnostic.clone()).unwrap_or_else(|error|serde_json::json!({"verified":false,"failure":error}));
        let path=if qualified_role{request.path.clone()}else{host.directory.join(format!("{}-unqualified-{:08}.png",request.label.name(),request.ordinal))};
        let encoded=preserve_original(&host,&request,&pixel.image,&path);
        match encoded {
            Ok(_)=>{
                host.pending_capture=None;
                if qualified_role {
                    // New protocol: old GUI controllers deliberately cannot
                    // accept this as their current-phase framebuffer_saved event.
                    row(&mut host,"framebuffer_copy_frame_saved",serde_json::json!({
                        "schema":"six_GUI_exact_copy_frame_capture/v1","ordinal":request.ordinal,"label":request.label,"path":path,"dimensions":dimensions,
                        "request_tick":request.tick,"selected_tick":selected_tick,"callback_tick":pixel.callback_tick,"save_tick":save_tick,
                        "phase_source":"frozen_actual_copy_frame","current_phase_used_as_copied_frame":false,
                        "selected_callback_save_tick_order_rechecked":true,
                        "owner_guard_rechecked":true,"current_lifecycle_guard_rechecked":true,
                        "current_terminal_consumer_guard_rechecked":!scene_role,"current_terminal_consumer_ready":role_current,
                        "current_nonterminal_guard_rechecked":scene_role,"current_nonterminal_guard_ready":current_nonterminal,
                        "current_normal_follow_guard_rechecked":scene_role,"current_normal_follow_ready":current_follow_ready,
                        "selected_combat_evidence":selected_combat,"callback_combat_evidence_observed":callback_combat_evidence,
                        "selected_spell_evidence":selected_spell,"request_spell_evidence":request.spell_evidence,"callback_spell_evidence_observed":callback_spell_evidence,
                        "spell_state_only_not_pose_or_model_proof":true,
                        "callback_current_combat_phase_valid":request.label!=Label::Combat||callback_combat_evidence.is_some(),
                        "request_combat_evidence":request.combat_evidence,"request_resource_token":request.resource_token,
                        "request_scope_rechecked_at_selection":scene_role,"request_legacy_GPU_freshness_not_used_for_copy_join":true,
                        "copy_frame_join":diagnostic,"result_key":request.result,"Root_viewed":false,
                        "DrawMaterial_or_uniform_content_success_qualified":false,"native_pixel_parity":false,"exact_GPU_exposure_tick":null,"visible_pixels_qualified":false}));
                } else {
                    host.captures.remove(request.label.name());
                    row(&mut host,"framebuffer_deferred",serde_json::json!({"ordinal":request.ordinal,"label":request.label,
                        "reason":if scene_role&&!current_nonterminal{"late_terminal_after_scene_copy"}else{"exact_copy_frame_or_current_lifecycle_guard_unavailable"},
                        "recoverable":true,"image_saved":true,"unqualified_original_path":path,"dimensions":dimensions,
                        "selected_tick":selected_tick,"callback_tick":pixel.callback_tick,"save_tick":save_tick,
                        "phase_source":"frozen_actual_copy_frame","copy_frame_join":diagnostic,
                        "copied_phase_ready":copied_phase_ready,"current_nonterminal_guard_ready":current_nonterminal,
                        "selected_callback_save_tick_order_ready":actual_tick_order,
                        "current_normal_follow_ready":current_follow_ready,"callback_combat_evidence_observed":callback_combat_evidence,
                        "visible_pixels_qualified":false}));
                }
            },
            Err(error)=>fail(&mut host,format!("capture encoder: {error}")),
        }
        world.insert_resource(host);
    }
}

fn state(world: &mut World) {
    let Some(mut host) = world.remove_resource::<Host>() else { return; };
    let now = world.resource::<Time>().elapsed_secs_f64();
    // Opt-in observation facts at most 10 Hz; request/save guards remain authoritative.
    if now < host.next_state { world.insert_resource(host); return; } host.next_state = now + 0.1;
    let accepted = owner(world.resource::<crate::Connection>());
    let window = { let mut query = world.query_filtered::<(Entity, &Window), With<bevy::window::PrimaryWindow>>();
        let mut rows = query.iter(world); let first = rows.next().map(|(e,w)|serde_json::json!({"entity":format!("{e:?}"),"title":w.title,"physical_dimensions":[w.physical_width(),w.physical_height()],"focused":w.focused}));
        if rows.next().is_some(){None}else{first} };
    // Keep only owned values across World query construction.
    let root = accepted.and_then(|o|world.resource::<crate::Match>().visuals.get(&o.player).copied());
    let loaded = root.and_then(|e|world.get::<crate::animation::Playback>(e)).map(|p|serde_json::json!({"network_id":p.network_id(),"loaded_model":p.model_name(),"model_asset_id":format!("{:?}",p.model_asset_id())}));
    let geometry = root.map(|root| {
        let mut queue=vec![root];let mut seen=std::collections::HashSet::new();let mut meshes=Vec::new();let mut overflow=false;
        while let Some(entity)=queue.pop(){
            if !seen.insert(entity){continue;}if seen.len()>2048{overflow=true;break;}
            if let Some(children)=world.get::<Children>(entity){queue.extend(children.iter());}
            if let Some(mesh)=world.get::<Mesh3d>(entity){meshes.push(serde_json::json!({"entity":format!("{entity:?}"),"mesh":format!("{:?}",mesh.0.id()),
                "inherited_visible":world.get::<InheritedVisibility>(entity).map(|v|v.get()),"view_visible":world.get::<ViewVisibility>(entity).map(|v|v.get())}));}
        }
        serde_json::json!({"root_owned":world.get::<crate::actor_fow::Root>(root).is_some()&&world.get::<ChildOf>(root).is_none(),"mesh_count":meshes.len(),"meshes":meshes,"traversal_overflow":overflow,"GPU_draw_submission_qualified":false})
    });
    let splash = { let mut query = world.query_filtered::<&Node, With<crate::native_endgame_ui::Splash>>(); query.iter(world).any(|n|n.display!=Display::None) };
    let results = { let mut query = world.query_filtered::<&Node, With<crate::match_results_ui::ResultsPanel>>(); query.iter(world).any(|n|n.display!=Display::None) };
    let text = { let mut query = world.query_filtered::<&Text, With<crate::match_results_ui::ResultsText>>(); query.iter(world).map(|t|t.0.clone()).collect::<Vec<_>>() };
    let connection = world.resource::<crate::Connection>(); let snapshot = world.resource::<crate::Match>().snapshot.as_ref();
    let local = accepted.and_then(|o|snapshot?.players.iter().find(|p|p.id==o.player));
    host.state_serial = host.state_serial.saturating_add(1);
    let camera_state=camera_status(world,&host);
    let resource_status=crate::six_gui_capture_readiness::status(world);
    let document = serde_json::json!({"schema":1,"client_pid":std::process::id(),"state_serial":host.state_serial,"local_time":now,
        "owner":accepted,"ready":connection.ready(),"snapshot":snapshot,"local_team":local.map(|p|p.team),"ordinary_GUI":true,"logic_companion":false,
        "camera_lock":camera_state,"capture_resources":resource_status,
        "window":window,"local_root":root.map(|e|format!("{e:?}")),"local_loaded_model":loaded,"local_geometry":geometry,
        "endgame":{"splash_visible":splash,"results_visible":results,"results_text":text,"dismissed":world.resource::<crate::native_endgame_ui::View>().dismissed,"ceremony_age":world.resource::<crate::endgame_timeline::Clock>().age(now)},
        "next_request":host.next_request,"pending_capture":host.pending_capture,"failed":host.failed,"rejection":connection.rejection,"complete":false,
        "physical_input":false,"six_GUI_qualified":false,"native_full_game":false});
    let result = (|| -> Result<(),String> {
        let bytes = serde_json::to_vec(&document).map_err(|e|e.to_string())?;
        if bytes.len() > STATE_LIMIT { return Err("received observation state exceeds2MiB".into()); }
        validate_directory(&host.directory)?;
        let mut file=open_existing(&host.directory.join("state.json"),false,true)?;
        let mut previous=Vec::new();(&mut file).take(STATE_LIMIT as u64+1).read_to_end(&mut previous).map_err(|e|e.to_string())?;
        if previous.len()>STATE_LIMIT||previous!=host.state_bytes {
            return Err("preserve foreign state report bytes".into());
        }
        file.seek(SeekFrom::Start(0)).and_then(|_|file.set_len(0)).map_err(|e|e.to_string())?;
        file.write_all(&bytes).map_err(|e|e.to_string())?; host.state_bytes=bytes; Ok(())
    })();
    if let Err(error)=result { fail(&mut host,error); } world.insert_resource(host);
}
fn exited(mut exits: MessageReader<bevy::app::AppExit>, connection: Res<crate::Connection>, mut host: ResMut<Host>) {
    for exit in exits.read() { row(&mut host,"stock_AppExit_observed",serde_json::json!({"success":matches!(exit,bevy::app::AppExit::Success),"connection_identity_after_departure":owner(&connection),"normal_client_process_exit_observed":false})); }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        let Some(raw) = std::env::var_os(ENV) else { return; };
        match reserve(&raw) {
            Ok(mut host) => {
                copy_join::install(app);
                let directory=host.directory.clone();row(&mut host,"configured",serde_json::json!({"environment":ENV,"directory":directory,"legal_actions_only":true,"no_auto_close":true}));
                app.insert_resource(host).init_resource::<FollowSample>()
                    .add_systems(Update,observe_normal_follow.in_set(FollowObserved).after(crate::ordinary_camera_input::drive).before(drive).before(crate::camera))
                    .add_systems(Update,drive.after(FollowObserved).after(crate::receive).after(crate::endgame_timeline::update).before(crate::camera).before(crate::native_endgame_ui::update).before(crate::session_departure::return_button))
                    .add_systems(PostUpdate,save_captures.after(crate::six_gui_capture_readiness::Collect).before(state))
                    .add_systems(PostUpdate,state.after(crate::six_gui_capture_readiness::Collect).after(save_captures))
                    .add_systems(Last,exited.after(crate::session_departure::on_exit));
            },
            Err(error) => {eprintln!("Six GUI observation refused before gameplay: {error}");app.add_systems(Startup,|mut exits:MessageWriter<bevy::app::AppExit>|{exits.write(bevy::app::AppExit::error());});},
        }
    }
}


#[cfg(test)]
mod combat_evidence_tests {
    use super::*;
    // Unit-test fixture only: never an observer runtime input or match proof.
    fn received(champion:&str)->(Snapshot,Owner,u32) {
        let mut cells=Vec::new();
        for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();
        let source=game.join(champion).unwrap();let target=game.join("garen").unwrap();
        game.players.get_mut(&source).unwrap().position=Point{x:100.,z:100.};
        game.players.get_mut(&target).unwrap().position=Point{x:150.,z:100.};
        game.command(source,Action::Attack{target}).unwrap();game.advance();
        let snapshot=game.snapshot_for(source).unwrap();
        let owner=Owner{session:snapshot.session,player:source,epoch:None};
        (snapshot,owner,target)
    }
    #[test]
    fn six_gui_authoritative_windup_selects_garen_annie_ashe_without_generic_presentation() {
        use openleague_core::attack_presentation::{Kind,Phase};
        for champion in ["garen","annie","ashe"] {
            let(snapshot,owner,target)=received(champion);
            let source=snapshot.players.iter().find(|player|player.id==owner.player).unwrap();
            let windup=source.windup.as_ref().unwrap();
            let attack=windup.presentation.expect("scoped server attack identity");
            let kind=if windup.critical {Kind::Critical} else {Kind::Basic};
            assert_eq!(windup.target,target);
            assert_eq!((attack.source,attack.started,attack.release),(owner.player,windup.started,windup.release));
            assert_eq!(snapshot.attack_events.len(),1);
            let event=&snapshot.attack_events[0];
            assert_eq!(event.attack,attack);
            assert_eq!((event.sequence,event.tick,event.phase),(attack.id,windup.started,Phase::Started{kind}));
            let expected=CombatEvidence::AuthoritativeWindup{source:owner.player,target,
                started:windup.started,release:windup.release,snapshot_tick:snapshot.tick};
            assert_eq!(combat_evidence(&snapshot,owner,Some(owner)),Some(expected.clone()));

            // Received identity/age is consumed independently of the combat capture gate.
            let mut delayed=snapshot.clone();delayed.tick+=1;
            assert!(delayed.tick<windup.release);
            let mut attack_visuals=crate::attack_animation::State::default();attack_visuals.reset(snapshot.session);
            assert!(attack_visuals.observe(&delayed,10.).unwrap());
            let selected=attack_visuals.selection(owner.player,10.,None).unwrap();
            assert_eq!((selected.attack,selected.kind,selected.started),(attack.id,kind,windup.started));
            assert_eq!(selected.role,if windup.critical {"crit"} else {"attack"});
            let expected_age=((delayed.tick-windup.started)as f64/openleague_core::TICK_RATE as f64)as f32;
            assert_eq!(selected.age_seconds.to_bits(),expected_age.to_bits());

            // AuthoritativeWindup must remain available without any presentation event.
            let mut eventless=snapshot.clone();eventless.attack_events.clear();
            assert_eq!(combat_evidence(&eventless,owner,Some(owner)),Some(expected));
            assert_eq!(eventless.players.iter().find(|player|player.id==owner.player).unwrap().windup.as_ref().unwrap().presentation,Some(attack));
            // Only Garen owns the existing recent-event fallback; no expansion here.
            if champion!="garen" {
                let mut no_windup=snapshot.clone();
                no_windup.players.iter_mut().find(|player|player.id==owner.player).unwrap().windup=None;
                assert!(combat_evidence(&no_windup,owner,Some(owner)).is_none());
            }
        }
    }
    #[test]
    fn six_gui_combat_evidence_rejects_missing_connection_foreign_owner_epoch_and_terminal() {
        let(snapshot,owner,_)=received("annie");
        assert!(combat_evidence(&snapshot,owner,None).is_none());
        assert!(combat_evidence(&snapshot,owner,Some(Owner{epoch:Some(1),..owner})).is_none());
        assert!(combat_evidence(&snapshot,owner,Some(Owner{player:owner.player+1,..owner})).is_none());
        let mut foreign=snapshot.clone();foreign.session=foreign.session.wrapping_add(1);
        assert!(combat_evidence(&foreign,owner,Some(owner)).is_none());
        let mut terminal=snapshot.clone();terminal.winner=Some(0);
        assert!(combat_evidence(&terminal,owner,Some(owner)).is_none());
    }
    #[test]
    fn six_gui_windup_rejects_send_only_hidden_dead_friendly_mismatched_and_expired_targets() {
        let(snapshot,owner,target)=received("ashe");
        let rejected=|s:&Snapshot|assert!(combat_evidence(s,owner,Some(owner)).is_none());
        let mut value=snapshot.clone();value.players.iter_mut().find(|p|p.id==owner.player).unwrap().windup=None;rejected(&value);
        let mut value=snapshot.clone();value.players.retain(|p|p.id!=target);rejected(&value);
        let mut value=snapshot.clone();value.players.iter_mut().find(|p|p.id==target).unwrap().health=0.;rejected(&value);
        let mut value=snapshot.clone();value.players.iter_mut().find(|p|p.id==owner.player).unwrap().health=0.;rejected(&value);
        let mut value=snapshot.clone();let team=value.players.iter().find(|p|p.id==owner.player).unwrap().team;
        value.players.iter_mut().find(|p|p.id==target).unwrap().team=team;rejected(&value);
        let mut value=snapshot.clone();value.players.iter_mut().find(|p|p.id==owner.player).unwrap().windup.as_mut().unwrap().target=owner.player;rejected(&value);
        let mut value=snapshot.clone();let tick=value.tick;
        value.players.iter_mut().find(|p|p.id==owner.player).unwrap().windup.as_mut().unwrap().started=tick+1;rejected(&value);
        let mut value=snapshot.clone();let release=value.players.iter().find(|p|p.id==owner.player).unwrap().windup.as_ref().unwrap().release;
        value.tick=release;rejected(&value);
        let mut value=snapshot.clone();value.tick=100;
        let w=value.players.iter_mut().find(|p|p.id==owner.player).unwrap().windup.as_mut().unwrap();w.started=69;w.release=101;rejected(&value);
    }
    #[test]
    fn six_gui_combat_evidence_roundtrips_existing_wire_and_keeps_garen_event_fallback() {
        for champion in ["garen","annie","ashe"] {
            let(snapshot,owner,_)=received(champion);
            let original=combat_evidence(&snapshot,owner,Some(owner));
            let mut assembler=openleague_core::wire::StateAssembler::default();let mut payload=None;
            for packet in openleague_core::wire::state_datagrams(&snapshot).unwrap().into_iter().rev() {
                if let Some(bytes)=assembler.push(&packet,Some(snapshot.session)){payload=Some(bytes);}
            }
            let openleague_core::ServerPacket::State(decoded)=serde_json::from_slice(&payload.unwrap()).unwrap()else{panic!("real State packet expected")};
            assert_eq!(combat_evidence(&decoded,owner,Some(owner)),original);
        }
        let(mut snapshot,owner,_)=received("garen");
        snapshot.players.iter_mut().find(|p|p.id==owner.player).unwrap().windup=None;
        assert!(matches!(combat_evidence(&snapshot,owner,Some(owner)),Some(CombatEvidence::RecentGarenPresentation{..})));
        snapshot.tick+=31;assert!(combat_evidence(&snapshot,owner,Some(owner)).is_none());
    }
}


#[cfg(test)]
mod expired_source_tests {
    use super::*;
    fn received(champion:&str)->(Snapshot,Owner) {
        let mut cells=Vec::new();for _ in 0..400{cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join(champion).unwrap();
        let mut snapshot=game.snapshot_for(id).unwrap();snapshot.tick=200;
        let owner=Owner{session:snapshot.session,player:id,epoch:None};(snapshot,owner)
    }
    fn bytes(owner:Owner,ordinal:u64,source:u64)->Vec<u8>{serde_json::to_vec(&serde_json::json!({"schema":1,"client_pid":42,"ordinal":ordinal,"owner":owner,"source_tick":source,"operation":{"kind":"move","x":1.,"z":2.}})).unwrap()}
    #[test]
    fn six_gui_past_expired_moves_91_105_110_never_send_but_90_keeps_normal_dispatch() {
        let(snapshot,owner)=received("ashe");let calls=std::cell::Cell::new(0);
        for age in [91,105,110] {
            let admission=gameplay_at_source(&Operation::Move{x:1.,z:2.},&snapshot,owner.player,snapshot.tick-age).unwrap();
            let result=dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Ok(serde_json::json!({"unexpected":true}))}).unwrap();
            assert!(matches!(result,GameplayDispatch::Expired{age:a} if a==age));assert_eq!(calls.get(),0);
        }
        let admission=gameplay_at_source(&Operation::Move{x:1.,z:2.},&snapshot,owner.player,snapshot.tick-90).unwrap();
        assert!(matches!(dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Ok(serde_json::json!({"sequence":7}))}).unwrap(),GameplayDispatch::Sent(_)));
        assert_eq!(calls.get(),1);
    }
    #[test]
    fn six_gui_expiration_never_bypasses_pid_owner_epoch_ordinal_or_future_validation() {
        let(snapshot,owner)=received("annie");let raw=bytes(owner,167,95);
        assert!(validate_typed(&raw,42,167,owner,200).is_ok());
        assert!(validate_typed(&raw,43,167,owner,200).is_err());
        assert!(validate_typed(&raw,42,168,owner,200).is_err());
        assert!(validate_typed(&raw,42,167,Owner{epoch:Some(1),..owner},200).is_err());
        assert!(validate_typed(&raw,42,167,Owner{player:owner.player+1,..owner},200).is_err());
        assert!(validate_typed(&bytes(owner,167,201),42,167,owner,200).is_err());
        assert!(gameplay_at_source(&Operation::Move{x:1.,z:2.},&snapshot,owner.player,201).is_err());
        // Legacy strict validator still explicitly refuses expired bytes.
        assert!(validate(&raw,42,167,owner,200).is_err());
    }
    #[test]
    fn six_gui_expired_invalid_geometry_slots_and_non_garen_casts_remain_fatal() {
        let(snapshot,owner)=received("annie");
        for operation in [Operation::Move{x:f32::NAN,z:0.},Operation::Move{x:0.,z:f32::INFINITY},
            Operation::Buy{item:0},Operation::Learn{slot:4},Operation::Cast{slot:4,target:None},
            Operation::Cast{slot:2,target:Some(22)},Operation::Cast{slot:0,target:None},Operation::Attack{target:owner.player}] {
            assert!(gameplay_at_source(&operation,&snapshot,owner.player,95).is_err());
        }
        assert!(gameplay_at_source(&Operation::Move{x:1.,z:2.},&snapshot,owner.player+1,95).is_err());
    }
    #[test]
    fn six_gui_expired_request_consumes_one_checked_ordinal_without_sending_or_replaying() {
        let(snapshot,owner)=received("ashe");let raw=bytes(owner,167,95);
        let request=validate_typed(&raw,42,167,owner,snapshot.tick).unwrap();
        let next=next_consumed_ordinal(request.ordinal).unwrap();
        let calls=std::cell::Cell::new(0);
        let result=dispatch_gameplay(gameplay_at_source(&request.operation,&snapshot,owner.player,request.source_tick).unwrap(),
            |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
        assert!(matches!(result,GameplayDispatch::Expired{age:105}));assert_eq!(calls.get(),0);
        assert_eq!(next,168);assert!(validate_typed(&raw,42,next,owner,snapshot.tick).is_err());
        assert!(next_consumed_ordinal(u64::MAX).is_err());
    }
    #[test]
    fn six_gui_stale_camera_capture_continue_return_are_fatal_not_gameplay_recovery() {
        let(snapshot,owner)=received("garen");
        for operation in [Operation::CameraLock{expected_revision:2,expected_locked:false},Operation::CameraRestore,
            Operation::Capture{label:Label::Baseline},Operation::Capture{label:Label::Combat},Operation::Continue,Operation::Return] {
            assert!(gameplay_at_source(&operation,&snapshot,owner.player,95).is_err());
        }
    }
    #[test]
    fn six_gui_trundle_q_uses_normal_cast_dispatch_and_keeps_garen_admission() {
        let(snapshot,owner)=received("trundle");
        let before=serde_json::to_value(&snapshot).unwrap();let calls=std::cell::Cell::new(0);
        for source_tick in [snapshot.tick,snapshot.tick-90] {
            let admission=gameplay_at_source(&Operation::Cast{slot:0,target:None},&snapshot,owner.player,source_tick).unwrap();
            let result=dispatch_gameplay(admission,|action|{
                assert!(matches!(action,Action::Cast{slot:0,target:None}));
                calls.set(calls.get()+1);Ok(serde_json::json!({"sequence":calls.get(),"server_acceptance_inferred":false}))
            }).unwrap();
            assert!(matches!(result,GameplayDispatch::Sent(_)));
        }
        assert_eq!(calls.get(),2);assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        // Host admission does not learn, spend, reset cooldowns or prove server acceptance.
        let(mut garen,garen_owner)=received("garen");
        let mut target=garen.players.iter().find(|p|p.id==garen_owner.player).unwrap().clone();
        target.id=garen_owner.player+100;target.team=1-target.team;let target_id=target.id;garen.players.push(target);
        for operation in [Operation::Cast{slot:0,target:None},Operation::Cast{slot:1,target:None},
            Operation::Cast{slot:2,target:None},Operation::Cast{slot:3,target:Some(target_id)}] {
            let admission=gameplay_at_source(&operation,&garen,garen_owner.player,garen.tick).unwrap();
            assert!(matches!(dispatch_gameplay(admission,|action|{
                assert!(matches!(action,Action::Cast{..}));Ok(serde_json::Value::Null)
            }).unwrap(),GameplayDispatch::Sent(_)));
        }
    }

    #[test]
    fn six_gui_trundle_cast_shapes_reject_wrong_targetless_slots_forms_and_champions_before_send() {
        let(snapshot,owner)=received("trundle");let calls=std::cell::Cell::new(0);
        for operation in [Operation::Cast{slot:1,target:None},Operation::Cast{slot:2,target:None},
            Operation::Cast{slot:3,target:Some(owner.player)},Operation::Cast{slot:3,target:None},
            Operation::Cast{slot:4,target:None},Operation::Cast{slot:0,target:Some(owner.player)},
            Operation::Cast{slot:0,target:Some(owner.player+1)}] {
            let result=gameplay_at_source(&operation,&snapshot,owner.player,snapshot.tick)
                .and_then(|admission|dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}));
            assert!(result.is_err());assert_eq!(calls.get(),0);
        }
        // Canonical id only. These are altered unit-test snapshots, never runtime inputs.
        for champion in ["annie","ashe","ahri","Trundle","trundle_base",""] {
            let mut foreign=snapshot.clone();foreign.players.iter_mut().find(|p|p.id==owner.player).unwrap().champion=champion.into();
            let result=gameplay_at_source(&Operation::Cast{slot:0,target:None},&foreign,owner.player,foreign.tick)
                .and_then(|admission|dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}));
            assert!(result.is_err());assert_eq!(calls.get(),0);
        }
        assert!(gameplay_at_source(&Operation::Cast{slot:0,target:None},&snapshot,owner.player+100,snapshot.tick).is_err());
    }

    #[test]
    fn six_gui_trundle_q_owner_time_death_and_terminal_guards_precede_any_send() {
        let(snapshot,owner)=received("trundle");let calls=std::cell::Cell::new(0);
        let raw=|source_tick:u64|serde_json::to_vec(&serde_json::json!({"schema":1,"client_pid":42,"ordinal":7,
            "owner":owner,"source_tick":source_tick,"operation":{"kind":"cast","slot":0,"target":null}})).unwrap();
        for (pid,ordinal,accepted,source) in [(43,7,owner,200),(42,8,owner,200),
            (42,7,Owner{player:owner.player+1,..owner},200),(42,7,Owner{session:owner.session+1,..owner},200),
            (42,7,Owner{epoch:Some(1),..owner},200),(42,7,owner,201)] {
            let result=validate_typed(&raw(source),pid,ordinal,accepted,snapshot.tick).and_then(|request|{
                next_consumed_ordinal(request.ordinal)?;
                let admission=gameplay_at_source(&request.operation,&snapshot,accepted.player,request.source_tick)?;
                dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)})
            });
            assert!(result.is_err());assert_eq!(calls.get(),0);
        }
        for age in [91,105,110] {
            let request=validate_typed(&raw(snapshot.tick-age),42,7,owner,snapshot.tick).unwrap();
            let result=dispatch_gameplay(gameplay_at_source(&request.operation,&snapshot,owner.player,request.source_tick).unwrap(),
                |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
            assert!(matches!(result,GameplayDispatch::Expired{age:value}if value==age));assert_eq!(calls.get(),0);
        }
        for terminal in [false,true] {
            let mut changed=snapshot.clone();
            if terminal{changed.winner=Some(0);}else{changed.players.iter_mut().find(|p|p.id==owner.player).unwrap().health=0.;}
            let result=dispatch_gameplay(gameplay_at_source(&Operation::Cast{slot:0,target:None},&changed,owner.player,changed.tick).unwrap(),
                |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
            assert!(matches!(result,GameplayDispatch::Rejected(_)));assert_eq!(calls.get(),0);
        }
        let admission=gameplay_at_source(&Operation::Cast{slot:0,target:None},&snapshot,owner.player,snapshot.tick).unwrap();
        let result=dispatch_gameplay(admission,|_|{calls.set(calls.get()+1);Err("ordinary send error fixture".into())});
        assert!(matches!(result,Err(error)if error=="ordinary send error fixture"));assert_eq!(calls.get(),1);
    }

    #[test]
    fn six_gui_trundle_w_e_ground_and_r_target_keep_ordinary_actions_and_received_state_immutable() {
        let(mut snapshot,owner)=received("trundle");
        let mut target=snapshot.players.iter().find(|p|p.id==owner.player).unwrap().clone();
        target.id=owner.player+100;target.team=1-target.team;let target_id=target.id;snapshot.players.push(target);
        let before=serde_json::to_value(&snapshot).unwrap();let calls=std::cell::Cell::new(0);
        for operation in [Operation::CastAt{slot:1,x:100.,z:100.},Operation::CastAt{slot:2,x:200.,z:100.},Operation::Cast{slot:3,target:Some(target_id)}] {
            for age in [0,90] {
                let raw=serde_json::to_vec(&serde_json::json!({"schema":1,"client_pid":42,"ordinal":7,"owner":owner,
                    "source_tick":snapshot.tick-age,"operation":operation})).unwrap();
                let request=validate_typed(&raw,42,7,owner,snapshot.tick).unwrap();
                let admission=gameplay_at_source(&request.operation,&snapshot,owner.player,request.source_tick).unwrap();
                let result=dispatch_gameplay(admission,|action|{
                    match operation {
                        Operation::CastAt{slot,x,z}=>assert!(matches!(action,Action::CastAt{slot:s,point}if s==slot&&point==(Point{x,z}))),
                        Operation::Cast{slot:3,target:Some(target)}=>assert!(matches!(action,Action::Cast{slot:3,target:Some(t)}if t==target)),
                        _=>panic!("source fixture contains only the three new ordinary routes"),
                    }
                    // Check the real ordinary packet enum, not a privileged protocol.
                    let packet=openleague_core::ClientPacket::Command{sequence:7,action};
                    let decoded:openleague_core::ClientPacket=serde_json::from_slice(&serde_json::to_vec(&packet).unwrap()).unwrap();
                    assert!(matches!(decoded,openleague_core::ClientPacket::Command{sequence:7,..}));
                    calls.set(calls.get()+1);Ok(serde_json::json!({"sequence":7,"server_acceptance_inferred":false}))
                }).unwrap();
                assert!(matches!(result,GameplayDispatch::Sent(_)));
            }
        }
        assert_eq!(calls.get(),6);assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        // Admission does not learn a rank, spend mana, reset a cooldown or mutate effects.
        assert_eq!(snapshot.players.iter().find(|p|p.id==owner.player).unwrap().ranks,[0;4]);
    }

    #[test]
    fn six_gui_trundle_w_e_r_invalid_shapes_canonical_ids_and_enemy_targets_never_send() {
        let(mut snapshot,owner)=received("trundle");let calls=std::cell::Cell::new(0);
        for operation in [Operation::CastAt{slot:0,x:1.,z:2.},Operation::CastAt{slot:3,x:1.,z:2.},
            Operation::CastAt{slot:4,x:1.,z:2.},Operation::CastAt{slot:1,x:f32::NAN,z:2.},
            Operation::CastAt{slot:2,x:1.,z:f32::INFINITY},Operation::Cast{slot:1,target:None},
            Operation::Cast{slot:2,target:None},Operation::Cast{slot:3,target:None},Operation::Cast{slot:3,target:Some(owner.player)}] {
            let result=gameplay_at_source(&operation,&snapshot,owner.player,95)
                .and_then(|a|dispatch_gameplay(a,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}));
            assert!(result.is_err());assert_eq!(calls.get(),0);
        }
        for champion in ["garen","annie","ashe","ahri","Trundle","trundle_base",""] {
            let mut foreign=snapshot.clone();foreign.players.iter_mut().find(|p|p.id==owner.player).unwrap().champion=champion.into();
            for operation in [Operation::CastAt{slot:1,x:1.,z:2.},Operation::CastAt{slot:2,x:1.,z:2.}] {
                let result=gameplay_at_source(&operation,&foreign,owner.player,foreign.tick)
                    .and_then(|a|dispatch_gameplay(a,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}));
                assert!(result.is_err());assert_eq!(calls.get(),0);
            }
        }
        let target_id=owner.player+100;
        let rejected=dispatch_gameplay(gameplay_at_source(&Operation::Cast{slot:3,target:Some(target_id)},&snapshot,owner.player,snapshot.tick).unwrap(),
            |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
        assert!(matches!(rejected,GameplayDispatch::Rejected("target_not_visible")));
        let mut target=snapshot.players.iter().find(|p|p.id==owner.player).unwrap().clone();target.id=target_id;
        snapshot.players.push(target);
        assert!(gameplay_at_source(&Operation::Cast{slot:3,target:Some(target_id)},&snapshot,owner.player,snapshot.tick).is_err());
        let p=snapshot.players.iter_mut().find(|p|p.id==target_id).unwrap();p.team=1-p.team;p.health=0.;
        let rejected=dispatch_gameplay(gameplay_at_source(&Operation::Cast{slot:3,target:Some(target_id)},&snapshot,owner.player,snapshot.tick).unwrap(),
            |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
        assert!(matches!(rejected,GameplayDispatch::Rejected("target_not_alive")));assert_eq!(calls.get(),0);
        assert!(gameplay_at_source(&Operation::CastAt{slot:1,x:1.,z:2.},&snapshot,owner.player+1000,snapshot.tick).is_err());
        // Extra target/point fields are not another spelling of the ground protocol.
        for body in [serde_json::json!({"kind":"cast_at","slot":1,"x":1.,"z":2.,"target":target_id}),
                     serde_json::json!({"kind":"cast_at","slot":2,"point":{"x":1.,"z":2.}})] {
            let raw=serde_json::to_vec(&serde_json::json!({"schema":1,"client_pid":42,"ordinal":7,"owner":owner,"source_tick":200,"operation":body})).unwrap();
            assert!(validate_typed(&raw,42,7,owner,200).is_err());
        }
    }

    #[test]
    fn six_gui_trundle_w_e_r_typed_owner_expiry_death_terminal_and_send_errors_keep_no_send_boundaries() {
        let(mut snapshot,owner)=received("trundle");let mut target=snapshot.players[0].clone();
        target.id=owner.player+100;target.team=1-target.team;let target_id=target.id;snapshot.players.push(target);
        let calls=std::cell::Cell::new(0);
        for operation in [Operation::CastAt{slot:1,x:1.,z:2.},Operation::CastAt{slot:2,x:1.,z:2.},Operation::Cast{slot:3,target:Some(target_id)}] {
            let raw=|source:u64|serde_json::to_vec(&serde_json::json!({"schema":1,"client_pid":42,"ordinal":7,"owner":owner,"source_tick":source,"operation":operation})).unwrap();
            for (pid,ordinal,accepted,source) in [(43,7,owner,200),(42,8,owner,200),
                (42,7,Owner{player:owner.player+1,..owner},200),(42,7,Owner{session:owner.session+1,..owner},200),
                (42,7,Owner{epoch:Some(1),..owner},200),(42,7,owner,201)] {
                let result=validate_typed(&raw(source),pid,ordinal,accepted,snapshot.tick).and_then(|r|{
                    next_consumed_ordinal(r.ordinal)?;
                    let a=gameplay_at_source(&r.operation,&snapshot,accepted.player,r.source_tick)?;
                    dispatch_gameplay(a,|_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)})
                });assert!(result.is_err());assert_eq!(calls.get(),0);
            }
            for age in [91,105,110] {
                let r=validate_typed(&raw(snapshot.tick-age),42,7,owner,snapshot.tick).unwrap();
                let result=dispatch_gameplay(gameplay_at_source(&r.operation,&snapshot,owner.player,r.source_tick).unwrap(),
                    |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
                assert!(matches!(result,GameplayDispatch::Expired{age:a}if a==age));assert_eq!(calls.get(),0);
                assert_eq!(next_consumed_ordinal(r.ordinal).unwrap(),8);
            }
            for terminal in [false,true] {
                let mut changed=snapshot.clone();
                if terminal{changed.winner=Some(0);}else{changed.players.iter_mut().find(|p|p.id==owner.player).unwrap().health=0.;}
                let result=dispatch_gameplay(gameplay_at_source(&operation,&changed,owner.player,changed.tick).unwrap(),
                    |_|{calls.set(calls.get()+1);Ok(serde_json::Value::Null)}).unwrap();
                assert!(matches!(result,GameplayDispatch::Rejected(_)));assert_eq!(calls.get(),0);
            }
        }
        let result=dispatch_gameplay(gameplay_at_source(&Operation::CastAt{slot:1,x:1.,z:2.},&snapshot,owner.player,200).unwrap(),
            |_|{calls.set(calls.get()+1);Err("ordinary send error fixture".into())});
        assert!(matches!(result,Err(e)if e=="ordinary send error fixture"));assert_eq!(calls.get(),1);
    }


    fn spell_fixture()->(Snapshot,Owner) {
        let(mut s,o)=received("trundle");let mut target=s.players[0].clone();target.id=o.player+100;target.team=1-target.team;
        let target_id=target.id;s.players.push(target);let p=s.players.iter_mut().find(|p|p.id==o.player).unwrap();
        p.ranks[1]=1;p.ranks[3]=1;
        p.effects.trundle_w=Some(openleague_core::trundle_w::Zone{owner:o.player,center:Point{x:100.,z:100.},rank:1,starts:100,until:340});
        p.effects.trundle_r=Some(openleague_core::trundle_r::Drain{owner:o.player,target:target_id,rank:1,starts:100,until:340,pulses:3,total_raw:100.,raw_applied:87.5,armor:10.,mr:10.});
        s.trundle_e_pillars=vec![openleague_core::trundle_e::VisiblePillar{owner:o.player,starts:100,until:280,center:Point{x:200.,z:100.}}];(s,o)
    }
    #[test]
    fn six_gui_spell_received_facts_require_owned_nonterminal_trundle_without_claiming_pose_or_damage() {
        let(s,o)=spell_fixture();
        for label in [Label::SpellW,Label::SpellE,Label::SpellR] {
            let evidence=spell_evidence(label,&s,o,Some(o)).unwrap();assert_eq!(evidence.tick(),200);
            assert!(spell_selection_matches(label,Some(evidence),Some(evidence),200));
            assert!(spell_evidence(label,&s,o,None).is_none());
            assert!(spell_evidence(label,&s,o,Some(Owner{epoch:Some(1),..o})).is_none());
            let mut wrong=s.clone();wrong.session+=1;assert!(spell_evidence(label,&wrong,o,Some(o)).is_none());
            let mut dead=s.clone();dead.players.iter_mut().find(|p|p.id==o.player).unwrap().health=0.;assert!(spell_evidence(label,&dead,o,Some(o)).is_none());
            let mut terminal=s.clone();terminal.winner=Some(0);assert!(spell_evidence(label,&terminal,o,Some(o)).is_none());
            let mut foreign=s.clone();foreign.players.iter_mut().find(|p|p.id==o.player).unwrap().champion="garen".into();assert!(spell_evidence(label,&foreign,o,Some(o)).is_none());
        }
        // An ordinary Learn may occur during a still-active cast-ranked effect.
        let mut upgraded=s.clone();let p=upgraded.players.iter_mut().find(|p|p.id==o.player).unwrap();p.ranks[1]=2;p.ranks[3]=2;
        for label in [Label::SpellW,Label::SpellR] {
            let request=spell_evidence(label,&s,o,Some(o)).unwrap();
            let selected=spell_evidence(label,&upgraded,o,Some(o)).unwrap();
            assert!(spell_selection_matches(label,Some(request),Some(selected),200));
        }
        assert!(spell_evidence(Label::Combat,&s,o,Some(o)).is_none());
        assert!(combat_evidence(&s,o,Some(o)).is_none(),"spell state never fabricates a BA windup");
    }
    #[test]
    fn six_gui_spell_facts_reject_expired_malformed_projection_foreign_effect_and_unseen_r_target() {
        let(s,o)=spell_fixture();
        for case in 0..4 {let mut bad=s.clone();let z=bad.players.iter_mut().find(|p|p.id==o.player).unwrap().effects.trundle_w.as_mut().unwrap();
            match case {0=>z.owner+=1,1=>z.center.x=f32::NAN,2=>z.until=200,_=>z.rank=0};assert!(spell_evidence(Label::SpellW,&bad,o,Some(o)).is_none());}
        for case in 0..5 {let mut bad=s.clone();match case {0=>bad.trundle_e_pillars.push(bad.trundle_e_pillars[0].clone()),
            1=>bad.trundle_e_pillars[0].owner+=1,2=>bad.trundle_e_pillars[0].center.z=f32::INFINITY,
            3=>bad.trundle_e_pillars[0].starts=201,_=>bad.trundle_e_pillars[0].until=200};assert!(spell_evidence(Label::SpellE,&bad,o,Some(o)).is_none());}
        for case in 0..6 {let mut bad=s.clone();if case==0 {bad.players.retain(|p|p.id==o.player);}else{
            let d=bad.players.iter_mut().find(|p|p.id==o.player).unwrap().effects.trundle_r.as_mut().unwrap();
            match case {1=>d.owner+=1,2=>d.target=o.player,3=>d.total_raw=f32::NAN,4=>d.pulses=5,_=>d.until=200};}
            assert!(spell_evidence(Label::SpellR,&bad,o,Some(o)).is_none());}
    }
    #[test]
    fn six_gui_spell_request_and_selected_identity_allow_elapsed_age_but_never_rebind_a_new_effect() {
        let(s,o)=spell_fixture();let mut later=s.clone();later.tick=230;
        {let d=later.players.iter_mut().find(|p|p.id==o.player).unwrap().effects.trundle_r.as_mut().unwrap();d.pulses=4;d.raw_applied=100.;}
        for label in [Label::SpellW,Label::SpellE,Label::SpellR] {
            let a=spell_evidence(label,&s,o,Some(o)).unwrap();let b=spell_evidence(label,&later,o,Some(o)).unwrap();
            assert!(spell_selection_matches(label,Some(a),Some(b),230));
            assert!(!spell_selection_matches(label,None,Some(b),230));assert!(!spell_selection_matches(label,Some(a),None,230));
            assert!(!spell_selection_matches(label,Some(a),Some(b),231));
            let foreign=match b {SpellEvidence::FrozenDomain{source,rank,starts,until,center,snapshot_tick}=>SpellEvidence::FrozenDomain{source,rank,starts:starts+1,until:until+1,center,snapshot_tick},
                SpellEvidence::Pillar{source,starts,until,mut center,snapshot_tick}=>{center.x+=1.;SpellEvidence::Pillar{source,starts,until,center,snapshot_tick}},
                SpellEvidence::Subjugate{source,target,rank,starts,until,pulses,snapshot_tick}=>SpellEvidence::Subjugate{source,target:target+1,rank,starts,until,pulses,snapshot_tick}};
            assert!(!spell_selection_matches(label,Some(a),Some(foreign),230));
            let wrong_label=if label==Label::SpellW{Label::SpellE}else{Label::SpellW};
            assert!(!spell_selection_matches(wrong_label,Some(a),Some(b),230));
            if let SpellEvidence::Subjugate{source,target,rank,starts,until,snapshot_tick,..}=b {
                let regressed=SpellEvidence::Subjugate{source,target,rank,starts,until,pulses:0,snapshot_tick};
                assert!(!spell_selection_matches(label,Some(a),Some(regressed),230));
            }
        }
    }

}

#[cfg(test)]
#[path="six_gui_repair_observer_tests.rs"]
mod repair_tests;

#[cfg(test)] mod tests {
    use super::*;
    fn request(operation:&str)->Vec<u8>{format!("{{\"schema\":1,\"client_pid\":42,\"ordinal\":1,\"owner\":{{\"session\":7,\"player\":21,\"epoch\":null}},\"source_tick\":300,\"operation\":{operation}}}").into_bytes()}
    fn accepted()->Owner{Owner{session:7,player:21,epoch:None}}
    #[test] fn six_gui_request_is_typed_exact_and_has_no_privileged_operation(){
        assert!(validate(&request("{\"kind\":\"move\",\"x\":1.0,\"z\":2.0}"),42,1,accepted(),300).is_ok());
        for operation in ["{\"kind\":\"damage\",\"value\":999}","{\"kind\":\"set_tick\",\"tick\":999}","{\"kind\":\"move\",\"x\":1,\"z\":2,\"player\":22}","{\"kind\":\"attack\",\"target\":21.5}","{\"kind\":\"capture\",\"label\":\"../foreign\"}"] {
            assert!(validate(&request(operation),42,1,accepted(),300).is_err());
        }
    }
    #[test] fn six_gui_request_rejects_foreign_pid_identity_epoch_ordinal_and_ticks(){
        let bytes=request("{\"kind\":\"stop\"}");assert!(validate(&bytes,43,1,accepted(),300).is_err());
        assert!(validate(&bytes,42,2,accepted(),300).is_err());assert!(validate(&bytes,42,1,Owner{player:22,..accepted()},300).is_err());
        assert!(validate(&bytes,42,1,Owner{epoch:Some(1),..accepted()},300).is_err());assert!(validate(&bytes,42,1,accepted(),299).is_err());
        assert!(validate(&bytes,42,1,accepted(),390).is_ok());assert!(validate(&bytes,42,1,accepted(),391).is_err());
    }
    #[test] fn six_gui_request_rejects_duplicate_fields_and_unbounded_bytes(){
        let text=String::from_utf8(request("{\"kind\":\"stop\"}")).unwrap();let duplicate=text.replacen("\"schema\":1","\"schema\":1,\"schema\":1",1);
        assert!(validate(duplicate.as_bytes(),42,1,accepted(),300).is_err());
        assert!(validate(&vec![b' ';4097],42,1,accepted(),300).is_err());
        assert!(validate(br#"[1,42,1,{"session":7,"player":21,"epoch":null},300,{"kind":"stop"}]"#,42,1,accepted(),300).is_err());
        let sequence_owner=text.replace("{\"session\":7,\"player\":21,\"epoch\":null}","[7,21,null]");
        assert!(validate(sequence_owner.as_bytes(),42,1,accepted(),300).is_err());
    }
    #[test] fn six_gui_close_is_only_a_current_process_success_request(){
        let close=parse_close(br#"{"schema":1,"client_pid":42}"#,42).unwrap();assert_eq!((close.schema,close.client_pid),(1,42));
        for invalid in [br#"{"schema":1,"client_pid":42,"server":true}"#.as_slice(),br#"{"schema":1,"client_pid":"42"}"#,br#"{"schema":1,"schema":1,"client_pid":42}"#,br#"[1,42]"#]{assert!(parse_close(invalid,42).is_err());}
    }
    #[test] fn six_gui_pending_button_cannot_release_after_owner_epoch_result_or_marker_changes(){
        let guard=OwnedGesture{owner:accepted(),result:(900,0),ordinal:1};
        assert!(gesture_owner_matches(guard,Some(accepted()),Some((900,0)),Some(guard)));
        assert!(!gesture_owner_matches(guard,None,Some((900,0)),Some(guard)));
        assert!(!gesture_owner_matches(guard,Some(Owner{epoch:Some(2),..accepted()}),Some((900,0)),Some(guard)));
        assert!(!gesture_owner_matches(guard,Some(accepted()),Some((901,0)),Some(guard)));
        assert!(!gesture_owner_matches(guard,Some(accepted()),Some((900,0)),Some(OwnedGesture{ordinal:2,..guard})));
        assert!(!gesture_owner_matches(guard,Some(accepted()),Some((900,0)),None));
    }

    #[test] fn six_gui_dynamic_target_loss_is_recoverable_but_owner_team_errors_are_fatal(){
        assert_eq!(target_available(21,0,28,None).unwrap(),Some("target_not_visible"));
        assert_eq!(target_available(21,0,28,Some((1,0.))).unwrap(),Some("target_not_alive"));
        assert_eq!(target_available(21,0,28,Some((1,60.))).unwrap(),None);
        assert!(target_available(21,0,21,Some((0,60.))).is_err());
        assert!(target_available(21,0,28,Some((0,60.))).is_err());
        assert!(target_available(21,0,28,Some((1,f32::NAN))).is_err());
    }
    #[test] fn six_gui_dynamic_death_terminal_and_consumed_ordinal_preserve_recovery_boundary(){
        assert_eq!(dynamic_phase(false,0.).unwrap(),Some("local_champion_not_alive"));
        assert_eq!(dynamic_phase(true,60.).unwrap(),Some("match_became_terminal"));
        assert_eq!(dynamic_phase(false,60.).unwrap(),None);
        assert!(dynamic_phase(false,f32::NAN).is_err());
        assert_eq!(next_consumed_ordinal(19).unwrap(),20);
        assert!(next_consumed_ordinal(u64::MAX).is_err());
    }
    #[test] fn six_gui_recoverable_action_policy_never_relaxes_typed_or_supported_shape(){
        for operation in [Operation::Move{x:f32::NAN,z:0.},Operation::Buy{item:0},Operation::Learn{slot:4},
            Operation::Cast{slot:2,target:Some(28)},Operation::Cast{slot:3,target:None}] {
            assert!(action_shape(&operation).is_err());
        }
        assert!(action_shape(&Operation::Attack{target:28}).unwrap().is_some());
        assert!(action_shape(&Operation::Capture{label:Label::Baseline}).unwrap().is_none());
        assert!(validate(&request("{\"kind\":\"attack\",\"target\":28.5}"),42,1,accepted(),300).is_err());
        assert!(validate(&request("{\"kind\":\"attack\",\"target\":28}"),43,1,accepted(),300).is_err());
    }
}
