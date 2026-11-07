//! The native planner owns one database inside its application directory.
use crate::store::Store;
use serde_json::json;
use std::{fs, io::Write, path::{Path, PathBuf}};

struct Initializing(PathBuf);
impl Drop for Initializing {
    fn drop(&mut self) { let _ = fs::remove_file(&self.0); }
}

pub fn initialize(dir: &Path, seed: &[u8]) -> Result<Store, String> {
    fs::create_dir_all(dir).map_err(|e| format!("Stockage local inaccessible : {e}"))?;
    let database = dir.join("plan.sqlite3");
    if !database.exists() {
        let lock = dir.join("initializing.lock");
        let owner = fs::OpenOptions::new().write(true).create_new(true).open(&lock)
            .map_err(|e| format!("Initialisation locale déjà en cours ou impossible : {e}"))?;
        let _guard = Initializing(lock);
        drop(owner);
        // A second instance may have completed before this process acquired the lock.
        if !database.exists() {
            let tmp = dir.join(format!("initial-{}.sqlite3", uuid::Uuid::new_v4()));
            let result = (|| -> Result<(), String> {
                let mut decoder = flate2::read::GzDecoder::new(seed);
                let mut file = fs::OpenOptions::new().write(true).create_new(true).open(&tmp)
                    .map_err(|e| e.to_string())?;
                std::io::copy(&mut decoder, &mut file).map_err(|e| e.to_string())?;
                file.sync_all().map_err(|e| e.to_string())?;
                drop(file);
                Store::new(tmp.clone())?;
                // The seed is a complete DELETE-journal snapshot, without external WAL files.
                if database.exists() {
                    return Err("Une base a été créée pendant l’initialisation ; elle est conservée.".into());
                }
                fs::rename(&tmp, &database).map_err(|e| e.to_string())?;
                Ok(())
            })();
            if result.is_err() { let _ = fs::remove_file(&tmp); }
            result?;
        }
    }
    // Existing data, including an invalid database, is never overwritten by a seed.
    let store = Store::new(database.clone())?;
    let summary = store.summary()?;
    write_json(dir, "connection.json", &json!({
        "schema":"openleague-native-local-data/v1",
        "database_path":database.to_string_lossy(),
        "storage":"application_directory", "external_service_required":false
    }))?;
    write_json(dir, "startup.json", &json!({
        "version":env!("CARGO_PKG_VERSION"),
        "database_path":database.to_string_lossy(),
        "done":summary["done"],"total":summary["total"],
        "catalog_version":summary["catalog_version"],
        "external_service_required":false
    }))?;
    Ok(store)
}

fn write_json(dir: &Path, name: &str, value: &serde_json::Value) -> Result<(), String> {
    let path = dir.join(name);
    let bytes = serde_json::to_vec_pretty(value).map_err(|e| e.to_string())?;
    if fs::read(&path).ok().as_deref() == Some(bytes.as_slice()) { return Ok(()); }
    let tmp = dir.join(format!("{}.{}.tmp", name, uuid::Uuid::new_v4()));
    let mut f = fs::OpenOptions::new().write(true).create_new(true).open(&tmp)
        .map_err(|e| e.to_string())?;
    f.write_all(&bytes).map_err(|e| e.to_string())?;
    f.sync_all().map_err(|e| e.to_string())?;
    drop(f);
    fs::rename(tmp, path).map_err(|e| e.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    use flate2::{write::GzEncoder, Compression};
    use rusqlite::Connection;

    fn seed(done: i64) -> Vec<u8> {
        let d = tempfile::tempdir().unwrap();
        let p = d.path().join("seed.sqlite3");
        let c = Connection::open(&p).unwrap();
        c.execute_batch("CREATE TABLE meta(key TEXT PRIMARY KEY,value TEXT);
          INSERT INTO meta VALUES('catalog_version','test');
          CREATE TABLE phases(id TEXT PRIMARY KEY,ordinal INTEGER,data TEXT);
          INSERT INTO phases VALUES('D01',0,'{\"id\":\"D01\"}');
          CREATE TABLE packages(id TEXT PRIMARY KEY); INSERT INTO packages VALUES('P1');
          CREATE TABLE tasks(id TEXT PRIMARY KEY,phase TEXT,active INTEGER);
          INSERT INTO tasks VALUES('A','D01',1);
          CREATE TABLE task_state(task_id TEXT PRIMARY KEY,done INTEGER,notes TEXT,revision INTEGER,updated_at TEXT);").unwrap();
        c.execute("INSERT INTO task_state VALUES('A',?,'note preserved',7,'2026-10-22')",[done]).unwrap();
        drop(c);
        let mut encoder=GzEncoder::new(Vec::new(),Compression::fast());
        encoder.write_all(&fs::read(p).unwrap()).unwrap();
        encoder.finish().unwrap()
    }

    #[test]
    fn first_run_loads_complete_seed_and_progress_without_project() {
        let d=tempfile::tempdir().unwrap(); let s=initialize(d.path(),&seed(1)).unwrap();
        assert_eq!(s.summary().unwrap()["done"],1);
        assert_eq!(s.path,d.path().join("plan.sqlite3"));
        assert!(!d.path().join("initializing.lock").exists());
    }
    #[test]
    fn reopen_and_updated_seed_never_reset_existing_progress_or_notes() {
        let d=tempfile::tempdir().unwrap();
        initialize(d.path(),&seed(1)).unwrap();
        let before=fs::read(d.path().join("plan.sqlite3")).unwrap();
        let s=initialize(d.path(),&seed(0)).unwrap();
        assert_eq!(s.summary().unwrap()["done"],1);
        let c=Connection::open(s.path).unwrap();
        let row:(String,i64)=c.query_row("SELECT notes,revision FROM task_state WHERE task_id='A'",[],|r|Ok((r.get(0)?,r.get(1)?))).unwrap();
        assert_eq!(row,("note preserved".into(),7));drop(c);
        assert_eq!(fs::read(d.path().join("plan.sqlite3")).unwrap(),before);
    }
    #[test]
    fn damaged_existing_database_is_preserved_and_refused() {
        let d=tempfile::tempdir().unwrap();let p=d.path().join("plan.sqlite3");
        fs::write(&p,b"preserve damaged user data").unwrap();
        assert!(initialize(d.path(),&seed(1)).is_err());
        assert_eq!(fs::read(p).unwrap(),b"preserve damaged user data");
    }
    #[test]
    fn damaged_seed_is_refused_without_publishing_empty_database() {
        let d=tempfile::tempdir().unwrap();
        assert!(initialize(d.path(),b"invalid gzip").is_err());
        assert!(!d.path().join("plan.sqlite3").exists());
        assert!(!d.path().join("initializing.lock").exists());
    }
    #[test]
    fn legacy_external_configuration_cannot_switch_the_owned_database() {
        let d=tempfile::tempdir().unwrap();
        fs::write(d.path().join("connection.json"),br#"{"database_path":"Z:/missing-project/plan.sqlite3"}"#).unwrap();
        let s=initialize(d.path(),&seed(1)).unwrap();
        assert_eq!(s.summary().unwrap()["done"],1);
        let c:serde_json::Value=serde_json::from_slice(&fs::read(d.path().join("connection.json")).unwrap()).unwrap();
        assert_eq!(c["storage"],"application_directory");
        assert_eq!(c["database_path"],s.path.to_string_lossy().as_ref());
    }
    #[test]
    fn concurrent_first_run_does_not_overwrite_initialization() {
        let d=tempfile::tempdir().unwrap();fs::write(d.path().join("initializing.lock"),b"other instance").unwrap();
        assert!(initialize(d.path(),&seed(1)).is_err());
        assert_eq!(fs::read(d.path().join("initializing.lock")).unwrap(),b"other instance");
        assert!(!d.path().join("plan.sqlite3").exists());
    }
    #[test]
    fn moving_the_data_directory_retains_progress_and_updates_its_location() {
        let parent=tempfile::tempdir().unwrap();let first=parent.path().join("one");let second=parent.path().join("two");
        initialize(&first,&seed(1)).unwrap();fs::rename(&first,&second).unwrap();
        let s=initialize(&second,&seed(0)).unwrap();
        assert_eq!(s.summary().unwrap()["done"],1);
        let startup:serde_json::Value=serde_json::from_slice(&fs::read(second.join("startup.json")).unwrap()).unwrap();
        assert_eq!(startup["done"],1);assert_eq!(startup["database_path"],s.path.to_string_lossy().as_ref());
    }
}
