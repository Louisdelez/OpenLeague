//! Opt-in ordinary GUI connection Buy/Sell1055, received snapshots and Bevy PNGs.
//! No privileged Simulation access, snapshot edits, fabricated GUI identity or mouse claim.
use bevy::{prelude::*,render::view::screenshot::{Screenshot,save_to_disk}};
use bevy::app::AppExit;
use openleague_core::{Action,Champion,Snapshot};
use std::{io::{Read,Write},path::{Path,PathBuf},time::Instant};

const ENV:&str="OPENLEAGUE_DORAN_GUI_PROBE";
const FIRST_INCOME:u64=2250;
const LATEST_BASELINE:u64=1800;
const MAX_PNG:u64=32*1024*1024;
const MAX_TRACE:u64=2*1024*1024;
const MAX_CLOSE_CONTROL:u64=1024;

#[derive(Clone,Copy)] struct Baseline {gold:f32,max_health:f32,level:u8,tick:u64}
#[derive(Resource)] struct Probe {
    prefix:String,hud:PathBuf,inventory:PathBuf,report:PathBuf,report_bytes:Vec<u8>,
    stage:u8,started:Instant,since:Instant,configured:bool,identity:Option<(u64,u32)>,
    last_tick:Option<u64>,baseline:Option<Baseline>,buy_tick:Option<u64>,sell_tick:Option<u64>,
    slot:Option<usize>,records:Vec<serde_json::Value>,failed:Option<String>,
    close_control:PathBuf,last_close_bytes:Option<Vec<u8>>,close_control_error:Option<String>,
    normal_exit_requested:bool,public_exit_request:Option<serde_json::Value>,
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        if std::env::var_os(ENV).is_none() {return;}
        match reserve() {Ok(probe)=>{app.insert_resource(probe).add_systems(PostUpdate,run);},
            Err(error)=>eprintln!("Doran GUI probe refused before gameplay: {error}")}
    }
}

fn reserve()->Result<Probe,String> {
    let prefix=std::env::var(ENV).map_err(|_|"probe prefix must be UTF-8")?;
    let p=Path::new(&prefix);
    if !p.is_absolute() || p.file_name().is_none() || !p.parent().is_some_and(Path::is_dir) {
        return Err("probe requires an absolute prefix inside an existing evidence directory".into());
    }
    let report=PathBuf::from(format!("{prefix}-report.json"));
    let close_control=PathBuf::from(format!("{prefix}-close.json"));
    let captures=["baseline","purchased","sold"].map(|label|PathBuf::from(format!("{prefix}-{label}.png")));
    if report.exists() || captures.iter().any(|path|path.exists()) {return Err("existing evidence prefix is preserved; choose a fresh prefix".into());}
    // Reserve absence, including a dangling symlink; the observer publishes
    // the completed control later. The hook never creates or deletes it.
    match std::fs::symlink_metadata(&close_control) {
        Err(error) if error.kind()==std::io::ErrorKind::NotFound=>{},
        Ok(_)=>return Err("existing close control is preserved; choose a fresh prefix".into()),
        Err(error)=>return Err(format!("cannot reserve close control absence: {error}")),
    }
    let mut paths=Vec::new();
    for env in ["OPENLEAGUE_NATIVE_HUD_TRACE","OPENLEAGUE_NATIVE_HUD_INVENTORY_TRACE"] {
        let path=PathBuf::from(std::env::var(env).map_err(|_|format!("missing {env}"))?);
        if !path.is_absolute() || path.parent()!=p.parent() || path==report || path==close_control || captures.contains(&path) || paths.contains(&path) {
            return Err(format!("{env} must use a distinct absolute trace path in the same fresh evidence directory"));
        }paths.push(path);
    }
    let initial=b"{\"configured\":false,\"passed\":false,\"complete\":false}\n".to_vec();
    std::fs::OpenOptions::new().write(true).create_new(true).open(&report)
        .and_then(|mut file|file.write_all(&initial)).map_err(|e|format!("cannot reserve report: {e}"))?;
    Ok(Probe {prefix,hud:paths.remove(0),inventory:paths.remove(0),report,report_bytes:initial,
        stage:0,started:Instant::now(),since:Instant::now(),configured:false,identity:None,last_tick:None,
        baseline:None,buy_tick:None,sell_tick:None,slot:None,records:Vec::new(),failed:None,
        close_control,last_close_bytes:None,close_control_error:None,normal_exit_requested:false,public_exit_request:None})
}

fn persist(probe:&mut Probe)->Result<(),String> {
    let value=serde_json::json!({"schema":"doran1055_ordinary_GUI_probe_v2","complete":false,
        "observation_complete":probe.stage==6 && probe.failed.is_none(),"passed":probe.stage==6 && probe.failed.is_none(),
        "stage":probe.stage,"error":probe.failed,"client_pid":std::process::id(),"identity":probe.identity,
        "last_received_tick":probe.last_tick,"records":probe.records,
        "close_control":probe.close_control,"close_control_error":probe.close_control_error,
        "normal_exit_requested":probe.normal_exit_requested,"public_exit_request":probe.public_exit_request,
        "logical_GUI_connection_commands":true,"physical_mouse_input_qualified":false,"actual_icon_pixels_qualified":false,
        "authoritative_AD_or_lifesteal_observed":false,"native_health_pool_policy_qualified":false,
        "limits":["The opt-in hook uses only this GUI client's legal Connection::send_action and received server snapshots; no stats/or/position mutation or other-player identity is used.",
            "All snapshots must precede the current first passive-income boundary2250; late start, command rejection, owner change, lost readiness, incomplete capture and timeout are preserved as failures. No clock acceleration or synthetic gold adjustment.",
            "Three actual primary-window PNGs must be structurally complete with valid CRCs before progression. Snapshot records are captured at request time, not an exact GPU exposure timestamp. Visual icon/text inspection remains separate.",
            "Gold, inventory/counts and maximum health are replicated authority. AD and life_steal are not replicated fields; their integration tests remain separate. Current health regeneration and native pool fidelity are not inferred.",
            "The shop is open, but commands are logical GUI-connection actions, not physical button presses. Only the observer's valid schema1/current-client PID control at the reserved fresh-prefix path requests AppExit::Success, once; passing never closes automatically. Existing Last/depart systems own normal departure; actual exit/drain must still be observed.",
            "Close control is a bounded typed JSON file in the observer-owned fresh directory. Invalid control is ignored and reported separately; a corrected changed request may be retried. PID targets this process, not an authenticated external author. No other-player/server/global shutdown action is sent.",
            "No complete item/kit/game, six clients, original-client rendering or100%acceptance is claimed."]});
    let bytes=serde_json::to_vec_pretty(&value).map_err(|e|e.to_string())?;
    if std::fs::read(&probe.report).map_err(|e|e.to_string())?!=probe.report_bytes {
        return Err("report path contains foreign bytes; preserve them".into());
    }
    std::fs::write(&probe.report,&bytes).map_err(|e|e.to_string())?;probe.report_bytes=bytes;Ok(())
}

fn bounded_read(path:&Path,limit:u64)->Result<Option<Vec<u8>>,String> {
    let file=match std::fs::File::open(path) {Ok(file)=>file,Err(e) if e.kind()==std::io::ErrorKind::NotFound=>return Ok(None),Err(e)=>return Err(e.to_string())};
    let mut bytes=Vec::new();file.take(limit+1).read_to_end(&mut bytes).map_err(|e|e.to_string())?;
    if bytes.len() as u64>limit {return Err(format!("evidence file exceeds bounded size: {}",path.display()));}Ok(Some(bytes))
}

#[derive(Debug,serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct CloseRequest {schema:u32,client_pid:u32}

fn validate_close_request(bytes:&[u8],expected_pid:u32)->Result<CloseRequest,String> {
    if bytes.len() as u64>MAX_CLOSE_CONTROL {return Err("close control exceeds1024 bytes".into());}
    // Typed deserialization rejects duplicate/missing/unknown fields, floats,
    // strings, booleans, negative values and integer overflow.
    let request:CloseRequest=serde_json::from_slice(bytes).map_err(|error|format!("invalid close control JSON: {error}"))?;
    if request.schema!=1 {return Err("close control requires schema1".into());}
    if request.client_pid!=expected_pid {return Err("close control PID does not match this client process".into());}
    Ok(request)
}

fn close_control_bytes(path:&Path)->Result<Option<Vec<u8>>,String> {
    let metadata=match std::fs::symlink_metadata(path) {
        Ok(metadata)=>metadata,
        Err(error) if error.kind()==std::io::ErrorKind::NotFound=>return Ok(None),
        Err(error)=>return Err(format!("cannot inspect close control: {error}")),
    };
    if !metadata.file_type().is_file() || metadata.file_type().is_symlink() {
        return Err("close control must be an ordinary file, not a directory or symlink".into());
    }
    if metadata.len()>MAX_CLOSE_CONTROL {return Err("close control exceeds1024 bytes".into());}
    bounded_read(path,MAX_CLOSE_CONTROL)
}

fn close_error(probe:&mut Probe,error:String) {
    if probe.close_control_error.as_ref()==Some(&error) {return;}
    probe.close_control_error=Some(error);
    // One latest error field, no unbounded30Hz error records and no change to
    // the Buy/Sell result. Foreign report bytes remain protected by persist.
    if let Err(error)=persist(probe) {eprintln!("Doran close error report unavailable: {error}");}
}

fn poll_close_control(probe:&mut Probe,exits:&mut MessageWriter<AppExit>) {
    if probe.normal_exit_requested {return;}
    let bytes=match close_control_bytes(&probe.close_control) {
        Ok(Some(bytes))=>bytes,
        Ok(None)=>return,
        Err(error)=>{close_error(probe,error);return;},
    };
    if probe.last_close_bytes.as_deref()==Some(bytes.as_slice()) {return;}
    probe.last_close_bytes=Some(bytes.clone());
    let request=match validate_close_request(&bytes,std::process::id()) {
        Ok(request)=>request,
        Err(error)=>{close_error(probe,error);return;},
    };
    probe.close_control_error=None;
    probe.normal_exit_requested=true;
    probe.public_exit_request=Some(serde_json::json!({"schema":request.schema,"client_pid":request.client_pid}));
    probe.records.push(serde_json::json!({"kind":"normal_exit_requested","control":probe.close_control,
        "request_bytes":bytes.len(),"exact_request_utf8":String::from_utf8_lossy(&bytes),
        "public_request":probe.public_exit_request,"requested_AppExit":"Success","stage":probe.stage,
        "observation_failed":probe.failed.is_some(),"physical_mouse_input":false}));
    if let Err(error)=persist(probe) {eprintln!("Doran normal close request report unavailable; foreign bytes preserved: {error}");}
    eprintln!("Doran own API requested normal exit for client PID{}",std::process::id());
    // Set the guard and record the public request before the sole exit message.
    // The normal Last/depart path performs session retirement; no extra Leave.
    exits.write(AppExit::Success);
}

fn trace(path:&Path)->Result<Option<serde_json::Value>,String> {
    let Some(bytes)=bounded_read(path,MAX_TRACE)? else{return Ok(None)};
    match serde_json::from_slice(&bytes) {Ok(value)=>Ok(Some(value)),Err(e) if e.is_eof()=>Ok(None),Err(e)=>Err(format!("invalid trace {}: {e}",path.display()))}
}
fn crc32(bytes:&[u8])->u32 {
    let mut crc=0xffffffffu32;
    for byte in bytes {crc^=u32::from(*byte);for _ in 0..8 {crc=(crc>>1)^(0xedb88320u32.wrapping_mul(crc&1));}}
    !crc
}
fn complete_png(path:&Path)->Result<Option<(u64,[u32;2])>,String> {
    let Some(bytes)=bounded_read(path,MAX_PNG)? else{return Ok(None)};
    if bytes.len()<8 {return Ok(None)}
    if &bytes[..8]!=b"\x89PNG\r\n\x1a\n" {return Err("capture is not PNG".into());}
    let mut at=8usize;let mut dimensions=None;let mut data_seen=false;
    loop {
        if bytes.len().saturating_sub(at)<12 {return Ok(None)}
        let len=u32::from_be_bytes(bytes[at..at+4].try_into().unwrap()) as usize;
        let end=at.checked_add(12).and_then(|v|v.checked_add(len)).ok_or("PNG chunk overflow")?;
        if end>bytes.len() {return Ok(None)}
        let kind=&bytes[at+4..at+8];let content=&bytes[at+8..at+8+len];
        if crc32(&bytes[at+4..end-4])!=u32::from_be_bytes(bytes[end-4..end].try_into().unwrap()) {return Err("PNG chunk CRC mismatch".into());}
        if at==8 && kind!=b"IHDR" {return Err("PNG must begin with IHDR".into());}
        match kind {
            b"IHDR"=>{if len!=13 || dimensions.is_some() {return Err("invalid PNG IHDR".into());}
                let size=[u32::from_be_bytes(content[..4].try_into().unwrap()),u32::from_be_bytes(content[4..8].try_into().unwrap())];
                if size.contains(&0) {return Err("zero-sized screenshot".into());}dimensions=Some(size);},
            b"IDAT"=>data_seen=true,
            b"IEND"=>{if len!=0 || !data_seen || end!=bytes.len() {return Err("invalid PNG completion".into());}
                return Ok(Some((bytes.len() as u64,dimensions.ok_or("missing PNG dimensions")?)));},
            _=>{},
        }at=end;
    }
}

fn capture(commands:&mut Commands,probe:&mut Probe,label:&str,snapshot:&Snapshot,player:&Champion)->Result<bool,String> {
    let Some(hud)=trace(&probe.hud)? else{return Ok(false)};let Some(inventory)=trace(&probe.inventory)? else{return Ok(false)};
    if hud["player"].as_u64()!=Some(u64::from(player.id)) || inventory["player"].as_u64()!=Some(u64::from(player.id))
        || inventory["session"].as_u64()!=Some(snapshot.session) {return Err("capture traces have a different GUI owner".into());}
    let hud_tick=hud["tick"].as_u64().ok_or("missing HUD trace tick")?;
    let inventory_tick=inventory["tick"].as_u64().ok_or("missing inventory trace tick")?;
    if hud_tick>snapshot.tick || inventory_tick>snapshot.tick {return Err("capture trace is ahead of received state".into());}
    let mode=i32::try_from(hud["cooldown_mode"].as_i64().ok_or("missing HUD mode")?).map_err(|_|"unsupported HUD mode")?;
    let values=crate::native_hud_widgets::snapshot_values_with_mode(snapshot,Some(player.id),mode)?.ok_or("missing GUI HUD values")?;
    if hud["values"]!=serde_json::to_value(&values).map_err(|e|e.to_string())? {return Ok(false)}
    let slots=inventory["slots"].as_array().ok_or("missing inventory trace slots")?;
    let actual_slot=player.inventory.iter().position(|id|*id==Some(1055));
    if let Some(slot)=actual_slot {
        if slots.len()!=1 || slots[0]["slot"].as_u64()!=Some(slot as u64) || slots[0]["item"]!=1055 || slots[0]["count"]!=1 {return Ok(false)}
        // A command may be accepted within the same server tick; the matching
        // inventory trace is immutable until the next inventory change.
        if inventory_tick<probe.buy_tick.ok_or("purchase trace without command")? {return Ok(false)}
    } else if !slots.is_empty() {return Ok(false)}
    if actual_slot.is_none() && label=="sold" && inventory_tick<probe.sell_tick.ok_or("sale trace without command")? {return Ok(false)}
    let expected=usize::from(actual_slot.is_some());
    if inventory["icon_entities"].as_u64()!=Some(expected as u64) || inventory["icon_materials"].as_u64()!=Some(expected as u64) {return Ok(false)}
    let path=PathBuf::from(format!("{}-{label}.png",probe.prefix));
    if path.exists() {return Err("preserve existing phase capture".into());}
    probe.records.push(serde_json::json!({"kind":"capture_requested","label":label,"session":snapshot.session,"player":player,
        "received_tick":snapshot.tick,"path":path,"HUD":hud,"inventory":inventory,"HUD_expected_values":values,
        "exact_GPU_exposure_tick":null,"physical_button_pressed":false}));
    commands.spawn(Screenshot::primary_window()).observe(save_to_disk(path));Ok(true)
}
fn wait_capture(probe:&mut Probe,label:&str)->Result<bool,String> {
    let path=PathBuf::from(format!("{}-{label}.png",probe.prefix));
    let Some((bytes,dimensions))=complete_png(&path)? else{return Ok(false)};
    probe.records.push(serde_json::json!({"kind":"capture_file_complete","label":label,"path":path,
        "bytes":bytes,"dimensions":dimensions,"PNG_CRCs_valid":true,"last_received_tick":probe.last_tick,
        "actual_icon_pixels_qualified":false}));Ok(true)
}
fn send(connection:&mut crate::Connection,probe:&mut Probe,action:Action,tick:u64)->Result<(),String> {
    let public=connection.send_action(action)?;
    probe.records.push(serde_json::json!({"kind":"logical_GUI_command","received_tick":tick,"public_metadata":public}));Ok(())
}
fn close(actual:f32,expected:f32)->bool {actual.is_finite() && expected.is_finite() && (actual-expected).abs()<=0.001}
fn require_baseline(player:&Champion,base:Baseline)->Result<(),String> {
    if player.inventory.iter().any(Option::is_some) || !close(player.gold,base.gold) || !close(player.max_health,base.max_health) {return Err("baseline changed before purchase or after sale".into());}Ok(())
}
fn purchased(player:&Champion,base:Baseline)->Result<Option<usize>,String> {
    let Some(slot)=player.inventory.iter().position(|id|*id==Some(1055)) else{return Ok(None)};
    if player.inventory.iter().filter(|id|id.is_some()).count()!=1 || openleague_core::shop::inventory_count(player,slot)!=1
        || !close(player.gold,base.gold-440.) || !close(player.max_health,base.max_health+70.) {
        return Err("received purchase differs from one1055/-440gold/+70maximum health".into());
    }Ok(Some(slot))
}

fn run(mut commands:Commands,time:Res<Time>,game:Res<crate::Match>,mut connection:ResMut<crate::Connection>,
    live:Res<crate::native_hud_widgets::Live>,shop:Res<crate::shop_ui::Filters>,mut probe:ResMut<Probe>,mut exits:MessageWriter<AppExit>) {
    // Close remains available after success, timeout or any observation failure.
    poll_close_control(&mut probe,&mut exits);
    if probe.normal_exit_requested {return;}
    if probe.failed.is_some() || probe.stage==6 {return;}
    let result=(||->Result<bool,String> {
        if !probe.configured {
            probe.configured=true;
            if connection.champion!="garen" || !connection.socket.peer_addr().is_ok_and(|p|p.ip().is_loopback()) {return Err("probe requires Garen and a loopback server".into());}
            if std::env::var_os("OPENLEAGUE_NATIVE_HUD_LIVE_PROBE").is_some() || std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() {
                return Err("disable Annie/generic screenshot probes for this ordinary camera observation".into());
            }
            let rules:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/passive_gold_rules.json")).map_err(|e|e.to_string())?;
            if openleague_core::TICK_RATE!=30 || rules["delay_seconds"].as_f64()!=Some(75.) {return Err("current pre-income2250 boundary no longer applies".into());}
            if !shop.open {return Err("open the actual shop with OPENLEAGUE_SHOP_OPEN before the observation".into());}
        }
        if probe.started.elapsed().as_secs_f64()>70. || (probe.stage!=0 && probe.since.elapsed().as_secs_f64()>15.) {return Err(format!("probe stage{} timed out",probe.stage));}
        if !connection.rejection.is_empty() {return Err(format!("server/connection rejected observation: {}",connection.rejection));}
        if !connection.ready() {if probe.identity.is_some() {return Err("GUI connection lost readiness after baseline".into());}return Ok(false)}
        let Some(snapshot)=&game.snapshot else{return Ok(false)};let Some(id)=connection.id else{return Ok(false)};
        if connection.session!=Some(snapshot.session) {return Err("received snapshot is not the GUI session".into());}
        if snapshot.tick>=FIRST_INCOME {return Err("first passive-gold boundary reached; refuse rather than adjust gold or clock".into());}
        if snapshot.winner.is_some() {return Err("match ended during shop observation".into());}
        if let Some(identity)=probe.identity {if identity!=(snapshot.session,id) {return Err("GUI session/player changed".into());}}
        if probe.last_tick.is_some_and(|tick|snapshot.tick<tick) {return Err("received tick rewound".into());}probe.last_tick=Some(snapshot.tick);
        let player=snapshot.players.iter().find(|p|p.id==id).ok_or("GUI player missing from received snapshot")?;
        if player.champion!="garen" || player.health<=0. || !shop.open {return Err("Garen must remain alive with the actual shop open".into());}
        if probe.baseline.is_some_and(|base|player.level!=base.level) {return Err("player level changed during maximum-health comparison".into());}
        if !live.healthy() {return Ok(false)}
        match probe.stage {
            0=>{if time.elapsed_secs_f64()<25. {return Ok(false)}
                if snapshot.tick>LATEST_BASELINE {return Err("baseline later than tick1800 leaves insufficient pre-income capture budget".into());}
                if player.inventory.iter().any(Option::is_some) || !player.gold.is_finite() || player.gold<440. || !player.max_health.is_finite() {return Err("baseline requires an empty inventory and enough real gold".into());}
                let base=Baseline {gold:player.gold,max_health:player.max_health,level:player.level,tick:snapshot.tick};
                if !capture(&mut commands,&mut probe,"baseline",snapshot,player)? {return Ok(false)}
                probe.baseline=Some(base);probe.identity=Some((snapshot.session,id));
            },
            1=>{let base=probe.baseline.ok_or("missing baseline")?;require_baseline(player,base)?;
                if !wait_capture(&mut probe,"baseline")? {return Ok(false)}
                send(&mut connection,&mut probe,Action::Buy{item:1055},snapshot.tick)?;probe.buy_tick=Some(snapshot.tick);
            },
            2=>{if snapshot.tick<=probe.buy_tick.ok_or("missing buy tick")? {return Ok(false)}
                let Some(slot)=purchased(player,probe.baseline.ok_or("missing baseline")?)? else{return Ok(false)};
                if !capture(&mut commands,&mut probe,"purchased",snapshot,player)? {return Ok(false)}probe.slot=Some(slot);
            },
            3=>{let slot=purchased(player,probe.baseline.ok_or("missing baseline")?)?.ok_or("1055 disappeared before sale")?;
                if probe.slot!=Some(slot) {return Err("received1055slot changed after purchase capture".into());}
                if !wait_capture(&mut probe,"purchased")? {return Ok(false)}
                // The slot is derived again from this received snapshot, never assumed0.
                let slot=u8::try_from(slot).map_err(|_|"received inventory slot cannot fit command")?;
                send(&mut connection,&mut probe,Action::Sell{slot},snapshot.tick)?;probe.sell_tick=Some(snapshot.tick);
            },
            4=>{if snapshot.tick<=probe.sell_tick.ok_or("missing sale tick")? || player.inventory.contains(&Some(1055)) {return Ok(false)}
                let base=probe.baseline.ok_or("missing baseline")?;
                let sold=Baseline {gold:base.gold-440.+176.,..base};require_baseline(player,sold)?;
                if !capture(&mut commands,&mut probe,"sold",snapshot,player)? {return Ok(false)}
            },
            5=>{let base=probe.baseline.ok_or("missing baseline")?;
                require_baseline(player,Baseline {gold:base.gold-440.+176.,..base})?;
                if !wait_capture(&mut probe,"sold")? {return Ok(false)}
                probe.records.push(serde_json::json!({"kind":"logical_flow_verified","session":snapshot.session,"player":id,
                    "baseline_tick":base.tick,"sold_tick":snapshot.tick,"first_income_tick":FIRST_INCOME,
                    "gold_after_sale":player.gold,"maximum_health_after_sale":player.max_health,"inventory_after_sale":player.inventory}));
            },
            _=>return Err("invalid observation stage".into()),
        }Ok(true)
    })();
    match result {
        Ok(true)=>{probe.stage+=1;probe.since=Instant::now();if let Err(error)=persist(&mut probe) {eprintln!("Doran report failed: {error}");probe.failed=Some(error);}},
        Ok(false)=>{},
        Err(error)=>{probe.failed=Some(error);if let Err(error)=persist(&mut probe) {eprintln!("Doran failure report unavailable: {error}");}},
    }
}

#[cfg(test)]
mod close_control_tests {
    use super::*;
    #[test]
    fn close_control_requires_schema1_and_this_typed_client_pid() {
        let request=validate_close_request(br#"{"schema":1,"client_pid":42}"#,42).unwrap();
        assert_eq!(request.schema,1);assert_eq!(request.client_pid,42);
        assert!(validate_close_request(b" { \"client_pid\": 42, \"schema\": 1 } \n",42).is_ok());
        assert!(validate_close_request(br#"{"schema":1,"client_pid":43}"#,42).is_err());
        assert!(validate_close_request(br#"{"schema":2,"client_pid":42}"#,42).is_err());
    }
    #[test]
    fn close_control_rejects_ambiguous_types_duplicate_and_extra_fields() {
        for invalid in [
            r#"{"schema":1.0,"client_pid":42}"#,r#"{"schema":"1","client_pid":42}"#,
            r#"{"schema":true,"client_pid":42}"#,r#"{"schema":-1,"client_pid":42}"#,
            r#"{"schema":1,"client_pid":42.0}"#,r#"{"schema":1,"client_pid":"42"}"#,
            r#"{"schema":1,"client_pid":true}"#,r#"{"schema":1,"client_pid":-1}"#,
            r#"{"schema":1,"client_pid":4294967296}"#,r#"{"schema":1}"#,
            r#"{"client_pid":42}"#,r#"{"schema":1,"schema":1,"client_pid":42}"#,
            r#"{"schema":1,"client_pid":42,"client_pid":42}"#,
            r#"{"schema":1,"client_pid":42,"player":1}"#,r#"{"schema":1,"client_pid":42,"global":true}"#,
            r#"{"schema":1,"client_pid":42} {}"#,r#"[]"#,r#"null"#,
        ] {assert!(validate_close_request(invalid.as_bytes(),42).is_err(),"accepted {invalid}");}
    }
    #[test]
    fn close_control_bytes_are_bounded_and_invalid_utf8_never_authorizes_exit() {
        let mut bytes=br#"{"schema":1,"client_pid":42}"#.to_vec();
        bytes.resize(MAX_CLOSE_CONTROL as usize,b' ');
        assert!(validate_close_request(&bytes,42).is_ok());
        bytes.push(b' ');assert!(validate_close_request(&bytes,42).is_err());
        assert!(validate_close_request(&[0xff],42).is_err());
    }
}
