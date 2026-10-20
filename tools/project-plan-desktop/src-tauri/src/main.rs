#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
use openleague_plan::store::Store;
use serde_json::{json, Value};
use std::path::PathBuf;
use tauri::Manager;

fn initialize() -> Result<Store, String> {
    let dir = std::env::var_os("LOCALAPPDATA")
        .map(PathBuf::from)
        .ok_or("Dossier des données Windows indisponible.")?
        .join("OpenLeague Plan");
    std::fs::create_dir_all(&dir).map_err(|e| e.to_string())?;
    let settings = dir.join("connection.json");
    let path = if settings.exists() {
        let settings: Value =
            serde_json::from_slice(&std::fs::read(&settings).map_err(|e| e.to_string())?)
                .map_err(|e| e.to_string())?;
        PathBuf::from(
            settings["database_path"]
                .as_str()
                .ok_or("Emplacement de la base invalide.")?,
        )
    } else {
        dir.join("plan.sqlite3")
    };
    if !path.exists() {
        // An explicitly linked database must never be silently replaced by the seed.
        if settings.exists() {
            return Err(format!(
                "La base liée est introuvable : {}. Elle n’a pas été remplacée.",
                path.display()
            ));
        }
        let mut decoder =
            flate2::read::GzDecoder::new(&include_bytes!("../resources/plan.sqlite3.gz")[..]);
        let tmp = dir.join(format!("initial-{}.sqlite3", uuid::Uuid::new_v4()));
        let mut f = std::fs::OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&tmp)
            .map_err(|e| e.to_string())?;
        std::io::copy(&mut decoder, &mut f).map_err(|e| e.to_string())?;
        f.sync_all().map_err(|e| e.to_string())?;
        drop(f);
        Store::new(tmp.clone())?;
        // Another instance may have completed the same initialization.
        if path.exists() {
            std::fs::remove_file(tmp).map_err(|e| e.to_string())?;
        } else {
            std::fs::rename(tmp, &path).map_err(|e| e.to_string())?;
        }
    }
    Store::new(path)
}

#[tauri::command]
async fn plan_request(
    path: String,
    method: String,
    body: Option<Value>,
    state: tauri::State<'_, Store>,
) -> Result<Value, String> {
    let store = state.inner().clone();
    tauri::async_runtime::spawn_blocking(move || {
        store.request(&path, &method, body.unwrap_or(Value::Null))
    })
    .await
    .map_err(|e| e.to_string())?
}
#[tauri::command]
async fn copy_instructions(
    kind: String,
    id: String,
    state: tauri::State<'_, Store>,
) -> Result<(), String> {
    let store = state.inner().clone();
    tauri::async_runtime::spawn_blocking(move || {
        let data = store.copy_text(&kind, &id)?;
        let content = data["text"].as_str().ok_or("Consignes absentes.")?;
        arboard::Clipboard::new()
            .map_err(|e| e.to_string())?
            .set_text(content)
            .map_err(|e| e.to_string())
    })
    .await
    .map_err(|e| e.to_string())?
}
#[tauri::command]
async fn save_plan(
    kind: String,
    app: tauri::AppHandle,
    state: tauri::State<'_, Store>,
) -> Result<Value, String> {
    let store = state.inner().clone();
    let documents = app.path().document_dir().map_err(|e| e.to_string())?;
    tauri::async_runtime::spawn_blocking(move || {
        let (name, ext) = match kind.as_str() {
            "export" => ("OpenLeague_suivi.json", "json"),
            "backup" => ("OpenLeague_plan_sauvegarde.sqlite3", "sqlite3"),
            "audit" => ("OpenLeague_AUDIT_DU_PLAN.md", "md"),
            _ => return Err("Sauvegarde inconnue.".into()),
        };
        let chosen = rfd::FileDialog::new()
            .set_title("Enregistrer")
            .set_directory(documents)
            .set_file_name(name)
            .add_filter(ext, &[ext])
            .save_file();
        let Some(path) = chosen else {
            return Ok(json!({"saved":false}));
        };
        // Avoid destroying the working database, including its WAL/SHM companions.
        let db = store.path.canonicalize().map_err(|e| e.to_string())?;
        let same = path.canonicalize().is_ok_and(|p| p == db);
        let companion = path.parent().and_then(|p| p.canonicalize().ok())
            == db.parent().map(|p| p.to_path_buf())
            && path.file_name().is_some_and(|n| {
                n == format!("{}-wal", db.file_name().unwrap().to_string_lossy()).as_str()
                    || n == format!("{}-shm", db.file_name().unwrap().to_string_lossy()).as_str()
            });
        if same || companion {
            return Err("Choisis un autre emplacement que la base de travail.".into());
        }
        let parent = path.parent().ok_or("Dossier de sauvegarde invalide.")?;
        let tmp = parent.join(format!(".openleague-{}.tmp", uuid::Uuid::new_v4()));
        match kind.as_str() {
            "backup" => store.backup(&tmp)?,
            "export" => std::fs::write(
                &tmp,
                serde_json::to_vec_pretty(&store.export()?).map_err(|e| e.to_string())?,
            )
            .map_err(|e| e.to_string())?,
            "audit" => std::fs::write(&tmp, include_bytes!("../resources/audit.md"))
                .map_err(|e| e.to_string())?,
            _ => unreachable!(),
        };
        // The native dialog explicitly confirms replacing an existing destination.
        if path.exists() {
            std::fs::copy(&tmp, &path).map_err(|e| e.to_string())?;
            std::fs::remove_file(tmp).map_err(|e| e.to_string())?;
        } else {
            std::fs::rename(tmp, &path).map_err(|e| e.to_string())?;
        }
        Ok(json!({"saved":true}))
    })
    .await
    .map_err(|e| e.to_string())?
}
fn main() {
    let store = match initialize() {
        Ok(s) => s,
        Err(e) => {
            rfd::MessageDialog::new()
                .set_title("OpenLeague Plan")
                .set_description(&e)
                .set_level(rfd::MessageLevel::Error)
                .show();
            return;
        }
    };
    let app = tauri::Builder::default()
        .manage(store)
        .invoke_handler(tauri::generate_handler![
            plan_request,
            copy_instructions,
            save_plan
        ])
        .setup(|app| {
            if let Some(w) = app.get_webview_window("main") {
                w.set_icon(tauri::image::Image::from_bytes(include_bytes!(
                    "../icons/icon.png"
                ))?)?;
            }
            Ok(())
        })
        .build(tauri::generate_context!());
    match app {
        Ok(app) => app.run(|_, _| {}),
        Err(e) => {
            rfd::MessageDialog::new()
                .set_title("OpenLeague Plan")
                .set_description(format!("Impossible d’ouvrir l’application : {e}"))
                .set_level(rfd::MessageLevel::Error)
                .show();
        }
    }
}
