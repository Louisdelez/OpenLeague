//! Opt-in qualification using ordinary loopback UDP commands and actual rendered screenshots.
//! Never changes snapshots or grants client damage/stat authority. Disabled for ordinary play.
use bevy::{prelude::*,render::view::screenshot::{Screenshot,save_to_disk}};
use openleague_core::Action;
#[derive(Resource,Default)] struct Probe {prefix:Option<String>,configured:bool,stage:u8,since:f64,baseline_mana:f32,precast_mana:f32,cast_mana:f32,records:Vec<serde_json::Value>,failed:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Probe>().add_systems(PostUpdate,run);}}
fn trace(name:&str)->Result<serde_json::Value,String> {let path=std::env::var(name).map_err(|_|format!("missing {name}"))?;serde_json::from_slice(&std::fs::read(path).map_err(|e|e.to_string())?).map_err(|e|e.to_string())}
fn persist(probe:&Probe) {
    let Some(prefix)=&probe.prefix else{return};
    let report=serde_json::json!({"complete":false,"passed":probe.stage==9 && probe.failed.is_none(),"stage":probe.stage,"error":probe.failed,"client_pid":std::process::id(),"records":probe.records,"limits":["Ordinary loopback client commands: purchase, learning and casting Annie E; no injected snapshots or privileged simulation events.","Screenshots asynchronously capture actual render frames. Source records are collected when capture is requested; a later received snapshot can differ by a few ticks. Inspect pixels separately.","Captures include ordinary base regeneration and existing fountain sustain; original fountain-rule fidelity remains unqualified.","Does not qualify complete Annie kit, all spell effects, graphical health combat transitions or full HUD/game."]});
    if let Err(e)=std::fs::write(format!("{prefix}-probe.json"),serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native HUD live probe report failed: {e}");}
}
fn send(connection:&mut crate::Connection,probe:&mut Probe,action:Action,tick:u64)->Result<(),String> {
    let packet=connection.send_action(action)?;
    probe.records.push(serde_json::json!({"kind":"command","tick":tick,"packet":packet}));Ok(())
}
fn capture(commands:&mut Commands,probe:&mut Probe,label:&str,snapshot:&openleague_core::Snapshot,id:u32)->Result<(),String> {
    let draw_mode=trace("OPENLEAGUE_NATIVE_HUD_TRACE")?["cooldown_mode"].as_i64().ok_or("cooldown mode missing from trace")? as i32;
    let texts=crate::native_hud_widgets::snapshot_values_with_mode(snapshot,Some(id),draw_mode)?.ok_or("missing probe player")?;
    let bars=crate::native_hud_bars::values(snapshot,Some(id))?.ok_or("missing probe bars")?;
    let hud=trace("OPENLEAGUE_NATIVE_HUD_TRACE")?;let bar_trace=trace("OPENLEAGUE_NATIVE_HUD_BARS_TRACE")?;
    if hud["values"]!=serde_json::to_value(&texts).unwrap() {return Err("HUD draw trace does not match received authoritative values".into());}
    let path=format!("{}-{label}.png",probe.prefix.as_ref().unwrap());
    if std::path::Path::new(&path).exists() {return Err("preserve existing capture evidence".into());}
    let player=snapshot.players.iter().find(|p|p.id==id).ok_or("missing capture player")?;
    let spells=if std::env::var("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE").is_ok() {
        let draw=trace("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE")?;
        let expected=crate::native_hud_spells::player_states(player,snapshot.tick)?;
        if draw["states"]!=serde_json::to_value(expected).unwrap() || draw["entities"]!=8 || draw["champion"]!="annie" {return Err("native spell trace does not match authoritative capture state".into());}
        Some(draw)
    }else {None};
    let ranks=if std::env::var("OPENLEAGUE_NATIVE_HUD_RANKS_TRACE").is_ok() {let value=trace("OPENLEAGUE_NATIVE_HUD_RANKS_TRACE")?;if value["ranks"]!=serde_json::json!(player.ranks) {return Err("native rank trace differs from authoritative ranks".into());}Some(value)}else {None};
    let learning=if std::env::var("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE").is_ok() {let value=trace("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE")?;if value["eligible"]!=serde_json::json!(crate::native_hud_learning::eligible(player)?) {return Err("learning trace differs from authoritative eligibility".into());}Some(value)}else {None};

    let recharge=if std::env::var("OPENLEAGUE_NATIVE_HUD_RECHARGE_TRACE").is_ok() {
        let value=trace("OPENLEAGUE_NATIVE_HUD_RECHARGE_TRACE")?;
        let expected=crate::native_hud_recharge::player_params(player,snapshot.tick).map_err(str::to_owned)?;
        if value["tick"]!=snapshot.tick || value["elements"].as_array().map(Vec::len)!=Some(4) {return Err("recharge trace snapshot or widget count mismatch".into());}
        for slot in 0..4 {if value["elements"][slot]["active"]!=expected[slot].is_some() || value["elements"][slot]["params"]!=serde_json::json!(expected[slot].map(|p|p.to_array())) {return Err("recharge trace differs from authoritative capture state".into());}}
        Some(value)
    }else {None};
    probe.records.push(serde_json::json!({"kind":"capture_requested","label":label,"tick":snapshot.tick,"path":path,"player":player,"values":texts,"health_fraction":bars.health,"resource_fraction":bars.resource,"hud_draw_trace":hud,"bars_draw_trace":bar_trace,"spells_draw_trace":spells,"ranks_draw_trace":ranks,"learning_draw_trace":learning,"recharge_draw_trace":recharge}));
    commands.spawn(Screenshot::primary_window()).observe(save_to_disk(path));Ok(())
}
fn run(mut commands:Commands,time:Res<Time>,state:Res<crate::Match>,mut connection:ResMut<crate::Connection>,live:Res<crate::native_hud_widgets::Live>,mut learning:ResMut<crate::native_hud_learning::Live>,mut probe:ResMut<Probe>) {
    let now=time.elapsed_secs_f64();
    if !probe.configured {
        probe.configured=true;let Ok(prefix)=std::env::var("OPENLEAGUE_NATIVE_HUD_LIVE_PROBE") else{return};probe.prefix=Some(prefix.clone());probe.since=now;
        if !std::path::Path::new(&prefix).is_absolute() || connection.champion!="annie" || !connection.socket.peer_addr().is_ok_and(|p|p.ip().is_loopback()) {probe.failed=Some("probe requires absolute evidence prefix, Annie and a loopback server".into());persist(&probe);return;}
        if ["baseline.png","purchased.png","precast.png","cast.png","regenerated.png","probe.json"].iter().any(|suffix|std::path::Path::new(&format!("{prefix}-{suffix}")).exists()) {probe.failed=Some("existing evidence prefix; choose a fresh prefix".into());eprintln!("Native HUD live probe refused existing prefix");return;}
    }
    if probe.prefix.is_none() || probe.failed.is_some() || probe.stage==9 {return;}
    if now-probe.since>45.0 {probe.failed=Some(format!("stage {} timed out",probe.stage));persist(&probe);return;}
    let Some(snapshot)=&state.snapshot else{return};let Some(id)=connection.id else{return};let Some(player)=snapshot.players.iter().find(|p|p.id==id) else{return};
    if !connection.rejection.is_empty() {probe.failed=Some(format!("server rejected command: {}",connection.rejection));persist(&probe);return;}
    if !live.healthy() {return;}
    let result=(||->Result<bool,String> {
        match probe.stage {
            0=>{if now<25.0 {return Ok(false);}probe.baseline_mana=player.mana;capture(&mut commands,&mut probe,"baseline",snapshot,id)?;}
            1=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-baseline.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}send(&mut connection,&mut probe,Action::Buy{item:1027},snapshot.tick)?;}
            2=>{if !player.inventory.contains(&Some(1027)) {return Ok(false);}if player.max_mana.ok_or("missing mana capacity")?<=probe.baseline_mana {return Err("purchase did not increase authoritative capacity".into());}capture(&mut commands,&mut probe,"purchased",snapshot,id)?;}
            3=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-purchased.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}if std::env::var("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE").is_ok() {let point=crate::native_hud_learning::queue_probe_click(&mut learning,2)?;probe.records.push(serde_json::json!({"kind":"ui_click_requested","slot":2,"point":point.to_array(),"tick":snapshot.tick}));}else {send(&mut connection,&mut probe,Action::Learn{slot:2},snapshot.tick)?;}}
            4=>{if player.ranks[2]!=1 || player.mana<player.max_mana.ok_or("missing mana capacity")? {return Ok(false);}capture(&mut commands,&mut probe,"precast",snapshot,id)?;}
            5=>{
                if !std::path::Path::new(&format!("{}-precast.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}
                // Request just after the existing fountain interval, so the next ordinary snapshot can expose the cost before sustain restores it.
                let config:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_interactions.json")).map_err(|e|e.to_string())?;
                let period=(config["fountain_interval_seconds"].as_f64().ok_or("missing fountain interval")?*openleague_core::TICK_RATE as f64).round() as u64;
                if period<4 {return Err("unsupported fountain period for capture timing".into());}
                if snapshot.tick%period>period/4 || player.mana<player.max_mana.ok_or("missing mana capacity")? {return Ok(false);}
                probe.precast_mana=player.mana;probe.records.push(serde_json::json!({"kind":"cast_baseline","tick":snapshot.tick,"player":player,"capture_timing_fountain_period_ticks":period}));
                send(&mut connection,&mut probe,Action::Cast{slot:2,target:None},snapshot.tick)?;
            }
            6=>{if player.cooldowns[2]<=snapshot.tick || player.effects.molten_until<=snapshot.tick || player.mana>=probe.precast_mana {return Ok(false);}probe.cast_mana=player.mana;capture(&mut commands,&mut probe,"cast",snapshot,id)?;}
            7=>{if player.mana.floor()<probe.cast_mana.floor()+5.0 || !std::path::Path::new(&format!("{}-cast.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}capture(&mut commands,&mut probe,"regenerated",snapshot,id)?;}
            8=>{
                if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-regenerated.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}
                if std::env::var("OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE").is_ok() {
                    if player.cooldowns[2]>snapshot.tick {return Ok(false);}
                    let path=format!("{}-ready.png",probe.prefix.as_ref().unwrap());
                    if !std::path::Path::new(&path).exists() {
                        if !probe.records.iter().any(|r|r["label"]=="ready") {capture(&mut commands,&mut probe,"ready",snapshot,id)?;persist(&probe);}
                        return Ok(false);
                    }
                }
            }
            _=>return Err("invalid probe state".into()),
        }Ok(true)
    })();
    match result {Ok(true)=>{probe.stage+=1;probe.since=now;persist(&probe);},Ok(false)=>{},Err(e)=>{probe.failed=Some(e);persist(&probe);}}
}
