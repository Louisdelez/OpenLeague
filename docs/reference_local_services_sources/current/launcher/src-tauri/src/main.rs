#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
mod sessions;
#[path="../../../crates/core/src/session_random.rs"]
mod session_random;
#[tauri::command]
fn resume_session(state:tauri::State<sessions::Sessions>)->Result<String,String>{state.resume()}
#[tauri::command]
fn abandon_session(state:tauri::State<sessions::Sessions>)->Result<String,String>{state.abandon()}
use std::path::PathBuf;
use tauri::Manager;
#[tauri::command]
fn session_status(state: tauri::State<sessions::Sessions>) -> Result<serde_json::Value, String> {
    state.status()
}
#[tauri::command]
fn roster() -> Result<serde_json::Value, String> {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    serde_json::from_str(
        &std::fs::read_to_string(root.join("data/4.20/champions.json"))
            .map_err(|e| e.to_string())?,
    )
    .map_err(|e| e.to_string())
}
#[tauri::command]
fn play(
    champion: String,
    summoners: [Option<String>; 2],
    state: tauri::State<sessions::Sessions>,
) -> Result<String, String> {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let catalog = roster()?;
    if !catalog
        .as_array()
        .is_some_and(|rows| rows.iter().any(|row| row["id"].as_str() == Some(&champion)))
    {
        return Err("Champion inconnu".into());
    }
    if summoners.iter().flatten().any(|s| s != "Barrier" && s != "Heal" && s != "Exhaust" && s != "Ignite" && s != "Smite")
        || (summoners[0].is_some() && summoners[0] == summoners[1])
    {
        return Err("Configuration de sorts invocateur invalide ou non implementee".into());
    }
    let summoner_json = serde_json::to_string(&summoners).map_err(|e| e.to_string())?;
    state.play(&root, &champion, &summoner_json)
}
#[tauri::command]
fn join_local(
    champion: String,
    summoners: [Option<String>; 2],
    state: tauri::State<sessions::Sessions>,
) -> Result<String, String> {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let catalog = roster()?;
    if !catalog
        .as_array()
        .is_some_and(|rows| rows.iter().any(|row| row["id"].as_str() == Some(&champion)))
    {
        return Err("Champion inconnu".into());
    }
    if summoners.iter().flatten().any(|s| s != "Barrier" && s != "Heal" && s != "Exhaust" && s != "Ignite" && s != "Smite")
        || (summoners[0].is_some() && summoners[0] == summoners[1])
    {
        return Err("Configuration de sorts invocateur invalide ou non implementee".into());
    }
    let summoner_json = serde_json::to_string(&summoners).map_err(|e| e.to_string())?;
    state.join_local(&root, &champion, &summoner_json)
}
fn main() {
    let sessions = sessions::Sessions::new().expect("OpenLeague session supervisor");
    tauri::Builder::default()
        .manage(sessions)
        .invoke_handler(tauri::generate_handler![roster, play, join_local, session_status, resume_session, abandon_session])
        .on_window_event(|window,event| {
            if let tauri::WindowEvent::CloseRequested{api,..}=event {
                if window.state::<sessions::Sessions>().block_joined_launcher_exit() {api.prevent_close();}
            }
        })
        .build(tauri::generate_context!())
        .expect("OpenLeague launcher")
        .run(|app,event| {
            if let tauri::RunEvent::ExitRequested{api,..}=event {
                if app.state::<sessions::Sessions>().block_joined_launcher_exit() {api.prevent_exit();}
            }
        });
}
