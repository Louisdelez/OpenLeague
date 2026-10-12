from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');history=r/'docs/plan_history'/('hud-live-probe-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for f in ['main.rs','native_hud_widgets.rs']:shutil.copy2(r/'crates/client/src'/f,history/f)
module=r'''//! Opt-in qualification using ordinary loopback UDP commands and actual rendered screenshots.
//! Never changes snapshots or grants client damage/stat authority. Disabled for ordinary play.
use bevy::{prelude::*,render::view::screenshot::{Screenshot,save_to_disk}};
use openleague_core::{Action,ClientPacket};
#[derive(Resource,Default)] struct Probe {prefix:Option<String>,configured:bool,stage:u8,since:f64,baseline_mana:f32,purchase_mana:f32,cast_mana:f32,records:Vec<serde_json::Value>,failed:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Probe>().add_systems(PostUpdate,run);}}
fn trace(name:&str)->Result<serde_json::Value,String> {let path=std::env::var(name).map_err(|_|format!("missing {name}"))?;serde_json::from_slice(&std::fs::read(path).map_err(|e|e.to_string())?).map_err(|e|e.to_string())}
fn persist(probe:&Probe) {
    let Some(prefix)=&probe.prefix else{return};
    let report=serde_json::json!({"complete":false,"passed":probe.stage==8 && probe.failed.is_none(),"stage":probe.stage,"error":probe.failed,"client_pid":std::process::id(),"records":probe.records,"limits":["Ordinary loopback client commands: purchase, learning and casting Annie E; no injected snapshots or privileged simulation events.","Screenshots asynchronously capture actual render frames. Source records are collected when capture is requested; a later received snapshot can differ by a few ticks. Inspect pixels separately.","Does not qualify complete Annie kit, all spell effects, graphical health combat transitions or full HUD/game."]});
    if let Err(e)=std::fs::write(format!("{prefix}-probe.json"),serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native HUD live probe report failed: {e}");}
}
fn send(connection:&mut crate::Connection,probe:&mut Probe,action:Action,tick:u64)->Result<(),String> {
    connection.sequence=connection.sequence.checked_add(1).ok_or("command sequence overflow")?;
    let packet=ClientPacket::Command{sequence:connection.sequence,action};let bytes=serde_json::to_vec(&packet).map_err(|e|e.to_string())?;
    let sent=connection.socket.send(&bytes).map_err(|e|e.to_string())?;if sent!=bytes.len() {return Err("incomplete command datagram".into());}
    probe.records.push(serde_json::json!({"kind":"command","tick":tick,"packet":packet}));Ok(())
}
fn capture(commands:&mut Commands,probe:&mut Probe,label:&str,snapshot:&openleague_core::Snapshot,id:u32)->Result<(),String> {
    let texts=crate::native_hud_widgets::snapshot_values(snapshot,Some(id))?.ok_or("missing probe player")?;
    let bars=crate::native_hud_bars::values(snapshot,Some(id))?.ok_or("missing probe bars")?;
    let hud=trace("OPENLEAGUE_NATIVE_HUD_TRACE")?;let bar_trace=trace("OPENLEAGUE_NATIVE_HUD_BARS_TRACE")?;
    if hud["values"]!=serde_json::to_value(&texts).unwrap() {return Err("HUD draw trace does not match received authoritative values".into());}
    let path=format!("{}-{label}.png",probe.prefix.as_ref().unwrap());
    if std::path::Path::new(&path).exists() {return Err("preserve existing capture evidence".into());}
    let player=snapshot.players.iter().find(|p|p.id==id).ok_or("missing capture player")?;
    probe.records.push(serde_json::json!({"kind":"capture_requested","label":label,"tick":snapshot.tick,"path":path,"player":player,"values":texts,"health_fraction":bars.health,"resource_fraction":bars.resource,"hud_draw_trace":hud,"bars_draw_trace":bar_trace}));
    commands.spawn(Screenshot::primary_window()).observe(save_to_disk(path));Ok(())
}
fn run(mut commands:Commands,time:Res<Time>,state:Res<crate::Match>,mut connection:ResMut<crate::Connection>,live:Res<crate::native_hud_widgets::Live>,mut probe:ResMut<Probe>) {
    let now=time.elapsed_secs_f64();
    if !probe.configured {
        probe.configured=true;let Ok(prefix)=std::env::var("OPENLEAGUE_NATIVE_HUD_LIVE_PROBE") else{return};probe.prefix=Some(prefix.clone());probe.since=now;
        if !std::path::Path::new(&prefix).is_absolute() || connection.champion!="annie" || !connection.socket.peer_addr().is_ok_and(|p|p.ip().is_loopback()) {probe.failed=Some("probe requires absolute evidence prefix, Annie and a loopback server".into());persist(&probe);return;}
        if ["baseline.png","purchased.png","cast.png","regenerated.png","probe.json"].iter().any(|suffix|std::path::Path::new(&format!("{prefix}-{suffix}")).exists()) {probe.failed=Some("existing evidence prefix; choose a fresh prefix".into());eprintln!("Native HUD live probe refused existing prefix");return;}
    }
    if probe.prefix.is_none() || probe.failed.is_some() || probe.stage==8 {return;}
    if now-probe.since>45.0 {probe.failed=Some(format!("stage {} timed out",probe.stage));persist(&probe);return;}
    let Some(snapshot)=&state.snapshot else{return};let Some(id)=connection.id else{return};let Some(player)=snapshot.players.iter().find(|p|p.id==id) else{return};
    if !connection.rejection.is_empty() {probe.failed=Some(format!("server rejected command: {}",connection.rejection));persist(&probe);return;}
    if !live.healthy() {return;}
    let result=(||->Result<bool,String> {
        match probe.stage {
            0=>{if now<25.0 {return Ok(false);}probe.baseline_mana=player.mana;capture(&mut commands,&mut probe,"baseline",snapshot,id)?;}
            1=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-baseline.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}send(&mut connection,&mut probe,Action::Buy{item:1027},snapshot.tick)?;}
            2=>{if !player.inventory.contains(&Some(1027)) {return Ok(false);}if player.max_mana.ok_or("missing mana capacity")?<=probe.baseline_mana {return Err("purchase did not increase authoritative capacity".into());}probe.purchase_mana=player.mana;capture(&mut commands,&mut probe,"purchased",snapshot,id)?;}
            3=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-purchased.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}send(&mut connection,&mut probe,Action::Learn{slot:2},snapshot.tick)?;}
            4=>{if player.ranks[2]!=1 {return Ok(false);}send(&mut connection,&mut probe,Action::Cast{slot:2,target:None},snapshot.tick)?;}
            5=>{if player.cooldowns[2]<=snapshot.tick || player.effects.molten_until<=snapshot.tick || player.mana>=probe.purchase_mana {return Ok(false);}probe.cast_mana=player.mana;capture(&mut commands,&mut probe,"cast",snapshot,id)?;}
            6=>{if player.mana.floor()<probe.cast_mana.floor()+5.0 || !std::path::Path::new(&format!("{}-cast.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}capture(&mut commands,&mut probe,"regenerated",snapshot,id)?;}
            7=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-regenerated.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}}
            _=>return Err("invalid probe state".into()),
        }Ok(true)
    })();
    match result {Ok(true)=>{probe.stage+=1;probe.since=now;persist(&probe);},Ok(false)=>{},Err(e)=>{probe.failed=Some(e);persist(&probe);}}
}
'''
p=r/'crates/client/src/native_hud_live_probe.rs';assert not p.exists();p.write_text(module,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s=s.replace('mod native_hud_pool_numbers;','mod native_hud_pool_numbers;\nmod native_hud_live_probe;');s=s.replace('.add_plugins(native_hud_widgets::Plugin)','.add_plugins(native_hud_widgets::Plugin)\n        .add_plugins(native_hud_live_probe::Plugin)');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text(encoding='utf-8');needle='pub struct Plugin;';assert s.count(needle)==1;s=s.replace(needle,'impl Live {pub fn healthy(&self)->bool {self.last_error.is_none() && !self.entities.is_empty()}}\n'+needle);p.write_text(s,encoding='utf-8')
print('Opt-in live HUD qualification installed; only ordinary UDP actions')
