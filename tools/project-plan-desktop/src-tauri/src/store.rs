use chrono::Utc;
use rusqlite::{
    params, params_from_iter,
    types::{Value as SqlValue, ValueRef},
    Connection,
};
use serde_json::{json, Value};
use std::{
    collections::HashSet,
    path::{Path, PathBuf},
    time::Duration,
};
use unicode_normalization::{char::is_combining_mark, UnicodeNormalization};

type Result<T> = std::result::Result<T, String>;
pub fn stamp() -> String {
    Utc::now().to_rfc3339()
}
fn err(e: impl std::fmt::Display) -> String {
    e.to_string()
}
fn rows(c: &Connection, sql: &str, bindings: &[SqlValue]) -> Result<Vec<Value>> {
    let mut s = c.prepare(sql).map_err(err)?;
    let names = s
        .column_names()
        .iter()
        .map(|s| s.to_string())
        .collect::<Vec<_>>();
    let found = s
        .query_map(params_from_iter(bindings.iter()), |r| {
            let mut m = serde_json::Map::new();
            for (i, n) in names.iter().enumerate() {
                let v = match r.get_ref(i)? {
                    ValueRef::Null => Value::Null,
                    ValueRef::Integer(i) => json!(i),
                    ValueRef::Real(v) => json!(v),
                    ValueRef::Text(b) => json!(String::from_utf8_lossy(b)),
                    ValueRef::Blob(_) => Value::Null,
                };
                m.insert(n.clone(), v);
            }
            Ok(Value::Object(m))
        })
        .map_err(err)?;
    found
        .collect::<std::result::Result<Vec<_>, _>>()
        .map_err(err)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture() -> (tempfile::TempDir, Store) {
        let d = tempfile::tempdir().unwrap();
        let path = d.path().join("test.sqlite3");
        let c = Connection::open(&path).unwrap();
        c.execute_batch("CREATE TABLE meta(key TEXT PRIMARY KEY,value TEXT);
          INSERT INTO meta VALUES('catalog_version','test');
          CREATE TABLE phases(id TEXT PRIMARY KEY,ordinal INTEGER,data TEXT);
          CREATE TABLE packages(id TEXT PRIMARY KEY,phase TEXT,ordinal INTEGER,data TEXT);
          CREATE TABLE tasks(id TEXT PRIMARY KEY,package_id TEXT,phase TEXT,ordinal INTEGER,title TEXT,kind TEXT,source_status TEXT,scope_required INTEGER,search_text TEXT,data TEXT,instructions TEXT,active INTEGER);
          CREATE INDEX tasks_cards ON tasks(active,package_id,phase,ordinal,id,title,kind,source_status,scope_required,search_text);
          CREATE TABLE task_groups(task_id TEXT PRIMARY KEY,name TEXT);
          CREATE TABLE task_state(task_id TEXT PRIMARY KEY,done INTEGER,notes TEXT,revision INTEGER,updated_at TEXT);
          CREATE TABLE changes(id TEXT PRIMARY KEY,created_at TEXT,before_json TEXT,after_json TEXT,undone INTEGER);").unwrap();
        c.execute("INSERT INTO phases VALUES('D01',0,?)",[json!({"id":"D01","title":"Référence","deliverable":"Livrer","exit_criteria":"Vérifier","all_dependency_phases":[]}).to_string()]).unwrap();
        c.execute(
            "INSERT INTO packages VALUES('P1','D01',0,?)",
            [json!({"id":"P1","phase":"D01","title":"Élise","task_ids":["A","B"]}).to_string()],
        )
        .unwrap();
        c.execute(
            "INSERT INTO packages VALUES('P2','D01',1,?)",
            [json!({"id":"P2","phase":"D01","title":"Garen","task_ids":["C"]}).to_string()],
        )
        .unwrap();
        for (i, (id, pack, title, search, active)) in [
            ("A", "P1", "Élise Q", "elise q", 1),
            ("B", "P1", "Élise qualifier", "elise qualifier", 1),
            ("C", "P2", "Garen Q", "garen q", 1),
            ("ARCHIVE", "P2", "Archive", "archive", 0),
        ]
        .into_iter()
        .enumerate()
        {
            let data =
                json!({"id":id,"title":title,"depends_on":if id=="B"{vec!["A"]}else{vec![]}});
            c.execute(
                "INSERT INTO tasks VALUES(?,?,?, ?,?,'acceptance','open',1,?,?,?,?)",
                params![
                    id,
                    pack,
                    "D01",
                    i as i64,
                    title,
                    search,
                    data.to_string(),
                    format!("CONSIGNE COMPLETE {id}\nÉtapes et preuves"),
                    active
                ],
            )
            .unwrap();
            c.execute("INSERT INTO task_groups VALUES(?,'Compétence Q')", [id])
                .unwrap();
            c.execute("INSERT INTO task_state VALUES(?,0,'',0,NULL)", [id])
                .unwrap();
        }
        drop(c);
        let s = Store::new(path).unwrap();
        (d, s)
    }
    #[test]
    fn global_summary_excludes_archive_and_ignores_filter() {
        let (_d, s) = fixture();
        s.change(&json!([{"id":"A","revision":0,"done":true}]), false)
            .unwrap();
        assert_eq!(s.summary().unwrap()["total"], 3);
        assert_eq!(s.summary().unwrap()["done"], 1);
        assert_eq!(
            s.list("", "Garen", "all", 1, 16).unwrap()["matched_tasks"],
            1
        );
        assert_eq!(s.summary().unwrap()["done"], 1);
    }
    #[test]
    fn accent_search_exact_q_and_complete_pagination() {
        let (_d, s) = fixture();
        let r = s.list("", "ÉLISE Q", "all", 1, 16).unwrap();
        assert_eq!(r["matched_tasks"], 1);
        assert_eq!(r["packages"][0]["tasks"][0]["id"], "A");
        let a = s.list("", "", "all", 1, 1).unwrap();
        let b = s.list("", "", "all", 2, 1).unwrap();
        assert_eq!(a["matched_tasks"], 3);
        assert_eq!(a["pages"], 2);
        assert_ne!(a["packages"][0]["id"], b["packages"][0]["id"]);
    }
    #[test]
    fn notes_and_done_survive_reopening() {
        let (_d, s) = fixture();
        s.change(
            &json!([{"id":"A","revision":0,"done":true,"notes":"Note précise ✓"}]),
            false,
        )
        .unwrap();
        let reopened = Store::new(s.path.clone()).unwrap();
        assert_eq!(reopened.task("A").unwrap()["notes"], "Note précise ✓");
        assert_eq!(reopened.task("A").unwrap()["done"], 1);
    }
    #[test]
    fn concurrent_revision_conflict_rolls_back_entire_batch() {
        let (_d, s) = fixture();
        assert!(s
            .change(
                &json!([{"id":"A","revision":0,"done":true},{"id":"B","revision":8,"done":true}]),
                false
            )
            .is_err());
        assert_eq!(s.task("A").unwrap()["done"], 0);
        assert_eq!(s.task("A").unwrap()["revision"], 0);
        assert!(s
            .change(&json!([{"id":"A","revision":0,"done":1}]), false)
            .is_err());
    }
    #[test]
    fn duplicate_and_archive_edits_rejected() {
        let (_d, s) = fixture();
        assert!(s
            .change(
                &json!([{"id":"A","revision":0,"done":true},{"id":"A","revision":0,"done":true}]),
                false
            )
            .is_err());
        assert!(s
            .change(&json!([{"id":"ARCHIVE","revision":0,"done":true}]), false)
            .is_err());
    }
    #[test]
    fn undo_preserves_revision_and_protects_newer_edits() {
        let (_d, s) = fixture();
        let r = s
            .change(
                &json!([{"id":"A","revision":0,"done":true,"notes":"Avant annulation"}]),
                false,
            )
            .unwrap();
        s.undo(r["change_id"].as_str().unwrap()).unwrap();
        assert_eq!(s.task("A").unwrap()["done"], 0);
        assert_eq!(s.task("A").unwrap()["notes"], "");
        assert_eq!(s.task("A").unwrap()["revision"], 2);
        assert!(s.undo(r["change_id"].as_str().unwrap()).is_err());
        let r = s
            .change(&json!([{"id":"A","revision":2,"done":true}]), false)
            .unwrap();
        s.change(
            &json!([{"id":"A","revision":3,"notes":"Plus récent"}]),
            false,
        )
        .unwrap();
        assert!(s.undo(r["change_id"].as_str().unwrap()).is_err());
    }
    #[test]
    fn import_export_preserve_archives_and_rollback_invalid_import() {
        let (_d, s) = fixture();
        let mut data = s.export().unwrap();
        data["tasks"][0]["done"] = json!(1);
        data["archived_tasks"][0]["notes"] = json!("Archive préservée");
        let changed = s.import(&data).unwrap();
        assert_eq!(s.task("A").unwrap()["done"], 1);
        assert_eq!(
            s.export().unwrap()["archived_tasks"][0]["notes"],
            "Archive préservée"
        );
        s.undo(changed["change_id"].as_str().unwrap()).unwrap();
        data["tasks"][1]["task_id"] = json!("INCONNU");
        assert!(s.import(&data).is_err());
        assert_eq!(s.task("A").unwrap()["done"], 0);
    }
    #[test]
    fn coherent_backup_keeps_notes_and_catalog() {
        let (d, s) = fixture();
        s.change(
            &json!([{"id":"C","revision":0,"notes":"Sauvegarde"}]),
            false,
        )
        .unwrap();
        let path = d.path().join("backup.sqlite3");
        s.backup(&path).unwrap();
        let b = Store::new(path).unwrap();
        assert_eq!(b.task("C").unwrap()["notes"], "Sauvegarde");
        assert_eq!(b.summary().unwrap()["total"], 3);
    }
    #[test]
    fn instructions_and_dependencies_are_complete() {
        let (_d, s) = fixture();
        assert_eq!(s.task("B").unwrap()["dependencies"][0]["id"], "A");
        let v = s.copy_text("package", "P1").unwrap();
        let t = v["text"].as_str().unwrap();
        assert!(t.contains("CONSIGNE COMPLETE A"));
        assert!(t.contains("CONSIGNE COMPLETE B"));
        assert!(s.copy_text("phase", "D01").unwrap()["text"]
            .as_str()
            .unwrap()
            .contains("B : Élise qualifier"));
    }
    #[test]
    fn router_rejects_unknown_or_external_commands() {
        let (_d, s) = fixture();
        assert_eq!(
            s.request("/api/tasks?q=Elise%20Q", "GET", Value::Null)
                .unwrap()["matched_tasks"],
            1
        );
        for path in [
            "https://example.com/api/bootstrap",
            "//example.com/api/bootstrap",
            "/api/unknown",
        ] {
            assert!(s.request(path, "GET", Value::Null).is_err());
        }
        assert!(s.request("/api/bootstrap", "POST", Value::Null).is_err());
        assert!(s
            .request("/api/tasks?page=oops", "GET", Value::Null)
            .is_err());
    }
}
fn one(c: &Connection, sql: &str, bindings: &[SqlValue]) -> Result<Value> {
    rows(c, sql, bindings)?
        .into_iter()
        .next()
        .ok_or_else(|| "Élément inconnu.".into())
}
fn text(s: &str) -> SqlValue {
    SqlValue::Text(s.to_string())
}
fn parse(s: &Value) -> Result<Value> {
    serde_json::from_str(s.as_str().ok_or("Donnée locale invalide.")?).map_err(err)
}
fn normal(s: &str) -> String {
    s.to_lowercase()
        .replace('ß', "ss")
        .nfkd()
        .filter(|c| !is_combining_mark(*c))
        .collect()
}

#[derive(Clone)]
pub struct Store {
    pub path: PathBuf,
}
impl Store {
    pub fn new(path: PathBuf) -> Result<Self> {
        let s = Self { path };
        let c = s.db()?;
        let ok: String = c
            .query_row("PRAGMA quick_check", [], |r| r.get(0))
            .map_err(err)?;
        if ok != "ok" {
            return Err("La vérification SQLite a échoué. La base est conservée.".into());
        }
        let count: i64 = c
            .query_row("SELECT COUNT(*) FROM tasks WHERE active=1", [], |r| {
                r.get(0)
            })
            .map_err(err)?;
        if count == 0 {
            return Err("Le catalogue est vide.".into());
        }
        Ok(s)
    }
    pub fn db(&self) -> Result<Connection> {
        let c =
            Connection::open_with_flags(&self.path, rusqlite::OpenFlags::SQLITE_OPEN_READ_WRITE)
                .map_err(err)?;
        c.busy_timeout(Duration::from_secs(15)).map_err(err)?;
        c.execute_batch("PRAGMA foreign_keys=ON; PRAGMA synchronous=FULL;")
            .map_err(err)?;
        Ok(c)
    }
    pub fn summary(&self) -> Result<Value> {
        let c = self.db()?;
        let mut phases = Vec::new();
        let (mut total, mut done) = (0, 0);
        for r in rows(&c,"SELECT p.data,COUNT(t.id) total,COALESCE(SUM(s.done),0) done FROM phases p JOIN tasks t ON t.phase=p.id AND t.active=1 JOIN task_state s ON s.task_id=t.id GROUP BY p.id ORDER BY p.ordinal",&[])? {
            let mut p=parse(&r["data"])?;p["total"]=r["total"].clone();p["done"]=r["done"].clone();
            total+=r["total"].as_i64().unwrap_or(0);done+=r["done"].as_i64().unwrap_or(0);phases.push(p);
        }
        let version: String = c
            .query_row(
                "SELECT value FROM meta WHERE key='catalog_version'",
                [],
                |r| r.get(0),
            )
            .map_err(err)?;
        let last: Option<String> = c
            .query_row("SELECT MAX(updated_at) FROM task_state", [], |r| r.get(0))
            .map_err(err)?;
        let packages: i64 = c
            .query_row("SELECT COUNT(*) FROM packages", [], |r| r.get(0))
            .map_err(err)?;
        Ok(
            json!({"app":"openleague-plan-local/v1","phases":phases,"total":total,"done":done,"packages":packages,
          "last_saved":last,"catalog_version":version,"database_path":self.path.to_string_lossy()}),
        )
    }
    pub fn list(
        &self,
        phase: &str,
        query: &str,
        status: &str,
        page: i64,
        page_size: i64,
    ) -> Result<Value> {
        let c = self.db()?;
        if !phase.is_empty()
            && !c
                .query_row(
                    "SELECT EXISTS(SELECT 1 FROM phases WHERE id=?)",
                    [phase],
                    |r| r.get::<_, bool>(0),
                )
                .map_err(err)?
        {
            return Err("Partie inconnue.".into());
        }
        if !["all", "todo", "done"].contains(&status)
            || !(1..=30).contains(&page_size)
            || page < 1
            || query.chars().count() > 200
        {
            return Err("Filtres invalides.".into());
        }
        let mut w = vec!["t.active=1".to_string()];
        let mut p = Vec::new();
        if !phase.is_empty() {
            w.push("t.phase=?".into());
            p.push(text(phase));
        }
        if status != "all" {
            w.push("s.done=?".into());
            p.push(SqlValue::Integer(i64::from(status == "done")));
        }
        for term in normal(query).split_whitespace().take(12) {
            let v = term
                .replace('\\', "\\\\")
                .replace('%', "\\%")
                .replace('_', "\\_");
            if term.chars().count() == 1 {
                w.push("(' '||t.search_text||' ') LIKE ? ESCAPE '\\'".into());
                p.push(text(&format!("% {v} %")));
            } else {
                w.push("t.search_text LIKE ? ESCAPE '\\'".into());
                p.push(text(&format!("%{v}%")));
            }
        }
        let condition = w.join(" AND ");
        let join="FROM tasks t INDEXED BY tasks_cards JOIN task_state s ON s.task_id=t.id JOIN packages p ON p.id=t.package_id";
        let counts=one(&c,&format!("SELECT COUNT(*) tasks,COUNT(DISTINCT t.package_id) packages {join} WHERE {condition}"),&p)?;
        let pages = ((counts["packages"].as_i64().unwrap_or(0) + page_size - 1) / page_size).max(1);
        let page = page.min(pages);
        let mut pp = p.clone();
        pp.push(SqlValue::Integer(page_size));
        pp.push(SqlValue::Integer((page - 1) * page_size));
        let packs=rows(&c,&format!("SELECT p.id,MIN(p.ordinal) ord {join} WHERE {condition} GROUP BY p.id ORDER BY ord LIMIT ? OFFSET ?"),&pp)?;
        let mut result = Vec::new();
        for pack in packs {
            let id = pack["id"].as_str().ok_or("Fiche invalide.")?;
            let mut data =
                parse(&one(&c, "SELECT data FROM packages WHERE id=?", &[text(id)])?["data"])?;
            let mut tp = p.clone();
            tp.push(text(id));
            data["tasks"]=json!(rows(&c,&format!("SELECT t.id,t.title,t.kind,t.source_status,t.scope_required,g.name task_group,s.done,s.notes,s.revision,s.updated_at {join} JOIN task_groups g ON g.task_id=t.id WHERE {condition} AND t.package_id=? ORDER BY t.ordinal"),&tp)?);
            result.push(data);
        }
        Ok(
            json!({"packages":result,"matched_tasks":counts["tasks"],"matched_packages":counts["packages"],"page":page,"pages":pages,"page_size":page_size}),
        )
    }
    pub fn task(&self, id: &str) -> Result<Value> {
        let c = self.db()?;
        let mut t=one(&c,"SELECT t.*,s.done,s.notes,s.revision,s.updated_at FROM tasks t JOIN task_state s ON s.task_id=t.id WHERE t.id=? AND t.active=1",&[text(id)])?;
        t["data"] = parse(&t["data"])?;
        let mut deps = Vec::new();
        for d in t["data"]["depends_on"]
            .as_array()
            .ok_or("Dépendances invalides.")?
        {
            deps.push(one(&c,"SELECT t.id,t.title,s.done FROM tasks t JOIN task_state s ON s.task_id=t.id WHERE t.id=?",&[text(d.as_str().ok_or("Dépendance invalide.")?)])?);
        }
        t["dependencies"] = json!(deps);
        Ok(t)
    }
    pub fn change(&self, updates: &Value, archived: bool) -> Result<Value> {
        let updates = updates
            .as_array()
            .filter(|u| !u.is_empty() && u.len() <= 100000)
            .ok_or("Liste de modifications invalide.")?;
        let mut seen = HashSet::new();
        for u in updates {
            let id = u["id"].as_str().ok_or("Identifiant invalide.")?;
            if !seen.insert(id) {
                return Err("Identifiant dupliqué.".into());
            }
        }
        let mut c = self.db()?;
        let tx = c
            .transaction_with_behavior(rusqlite::TransactionBehavior::Immediate)
            .map_err(err)?;
        let (mut before, mut after) = (Vec::new(), Vec::new());
        let date = stamp();
        let ident = uuid::Uuid::new_v4().simple().to_string();
        for u in updates {
            let id = u["id"].as_str().unwrap();
            let r = one(
                &tx,
                &format!(
                    "SELECT s.* FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.id=?{}",
                    if archived { "" } else { " AND t.active=1" }
                ),
                &[text(id)],
            )?;
            let revision = r["revision"].as_i64().ok_or("Révision invalide.")?;
            if u["revision"].as_i64() != Some(revision) {
                return Err("La tâche a changé dans une autre fenêtre. Actualise le plan.".into());
            }
            let done = if u.get("done").is_some() {
                u["done"].as_bool().ok_or("Statut invalide.")?
            } else {
                r["done"] == 1
            };
            let notes = if u.get("notes").is_some() {
                u["notes"].as_str().ok_or("Notes invalides.")?
            } else {
                r["notes"].as_str().unwrap_or("")
            };
            if notes.chars().count() > 20000 {
                return Err("Notes trop longues.".into());
            }
            let n = json!({"task_id":id,"done":i64::from(done),"notes":notes,"revision":revision+1,"updated_at":date});
            tx.execute(
                "UPDATE task_state SET done=?,notes=?,revision=?,updated_at=? WHERE task_id=?",
                params![i64::from(done), notes, revision + 1, date, id],
            )
            .map_err(err)?;
            before.push(r);
            after.push(n);
        }
        tx.execute(
            "INSERT INTO changes VALUES(?,?,?,?,0)",
            params![
                ident,
                date,
                json!(before).to_string(),
                json!(after).to_string()
            ],
        )
        .map_err(err)?;
        tx.commit().map_err(err)?;
        Ok(json!({"change_id":ident,"updated":after,"saved_at":date}))
    }
    pub fn undo(&self, id: &str) -> Result<Value> {
        let mut c = self.db()?;
        let tx = c
            .transaction_with_behavior(rusqlite::TransactionBehavior::Immediate)
            .map_err(err)?;
        let r = one(
            &tx,
            "SELECT * FROM changes WHERE id=? AND undone=0",
            &[text(id)],
        )?;
        let before = parse(&r["before_json"])?;
        let after = parse(&r["after_json"])?;
        let before = before.as_array().ok_or("Historique invalide.")?;
        let after = after.as_array().ok_or("Historique invalide.")?;
        if before.len() != after.len() {
            return Err("Historique invalide.".into());
        }
        for a in after {
            let v = one(
                &tx,
                "SELECT revision FROM task_state WHERE task_id=?",
                &[text(a["task_id"].as_str().ok_or("Historique invalide.")?)],
            )?;
            if v["revision"] != a["revision"] {
                return Err("Une modification plus récente empêche cette annulation.".into());
            }
        }
        let date = stamp();
        let mut updated = Vec::new();
        for (b, a) in before.iter().zip(after) {
            let mut n = b.clone();
            n["revision"] = json!(a["revision"].as_i64().ok_or("Révision invalide.")? + 1);
            n["updated_at"] = json!(date);
            tx.execute(
                "UPDATE task_state SET done=?,notes=?,revision=?,updated_at=? WHERE task_id=?",
                params![
                    n["done"].as_i64(),
                    n["notes"].as_str(),
                    n["revision"].as_i64(),
                    date,
                    n["task_id"].as_str()
                ],
            )
            .map_err(err)?;
            updated.push(n);
        }
        tx.execute("UPDATE changes SET undone=1 WHERE id=?", [id])
            .map_err(err)?;
        tx.commit().map_err(err)?;
        Ok(json!({"updated":updated,"saved_at":date}))
    }
    pub fn export(&self) -> Result<Value> {
        let c = self.db()?;
        let tasks=rows(&c,"SELECT s.* FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.active=1 ORDER BY t.ordinal",&[])?;
        let archived=rows(&c,"SELECT s.* FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.active=0 ORDER BY t.id",&[])?;
        Ok(
            json!({"schema":"openleague_plan_progress/v1","exported_at":stamp(),"catalog_version":self.summary()?["catalog_version"],"tasks":tasks,"archived_tasks":archived}),
        )
    }
    pub fn import(&self, data: &Value) -> Result<Value> {
        if data["schema"] != "openleague_plan_progress/v1" {
            return Err("Format de sauvegarde invalide.".into());
        }
        let mut all = data["tasks"]
            .as_array()
            .ok_or("Sauvegarde invalide.")?
            .clone();
        if let Some(a) = data.get("archived_tasks") {
            all.extend(a.as_array().ok_or("Archives invalides.")?.iter().cloned());
        }
        if all.is_empty() || all.len() > 100000 {
            return Err("Nombre de tâches invalide.".into());
        }
        let c = self.db()?;
        let mut seen = HashSet::new();
        let mut updates = Vec::new();
        for row in all {
            let id = row["task_id"].as_str().ok_or("Identifiant invalide.")?;
            if !seen.insert(id.to_string()) {
                return Err("Identifiant dupliqué.".into());
            }
            let r=one(&c,"SELECT s.revision FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE s.task_id=?",&[text(id)])?;
            let done = match &row["done"] {
                Value::Bool(b) => *b,
                Value::Number(n) if n.as_i64() == Some(0) => false,
                Value::Number(n) if n.as_i64() == Some(1) => true,
                _ => return Err("Statut invalide.".into()),
            };
            let notes = row.get("notes").cloned().unwrap_or(json!(""));
            if notes.as_str().is_none_or(|n| n.chars().count() > 20000) {
                return Err("Notes invalides.".into());
            }
            updates.push(json!({"id":id,"revision":r["revision"],"done":done,"notes":notes}));
        }
        self.change(&json!(updates), true)
    }
    pub fn copy_text(&self, kind: &str, id: &str) -> Result<Value> {
        let c = self.db()?;
        match kind {
            "task" => {
                let t = self.task(id)?;
                let mut text = t["instructions"]
                    .as_str()
                    .ok_or("Consigne absente.")?
                    .to_string();
                if let Some(n) = t["notes"].as_str().filter(|n| !n.is_empty()) {
                    text.push_str(&format!("\nNOTES DE SUIVI AJOUTÉES LOCALEMENT\n{n}\n"));
                }
                Ok(json!({"title":t["title"],"text":text}))
            }
            "package" => {
                let p =
                    parse(&one(&c, "SELECT data FROM packages WHERE id=?", &[text(id)])?["data"])?;
                let mut text = format!(
                    "FICHE {id} — {}\nTraiter les tâches dans l’ordre de leurs dépendances.\n\n",
                    p["title"].as_str().unwrap_or("")
                );
                for tid in p["task_ids"].as_array().ok_or("Fiche invalide.")? {
                    text.push_str(
                        self.copy_text("task", tid.as_str().ok_or("Tâche invalide.")?)?["text"]
                            .as_str()
                            .unwrap_or(""),
                    );
                    text.push_str("\n\n");
                }
                Ok(json!({"title":p["title"],"text":text}))
            }
            "phase" => {
                let p =
                    parse(&one(&c, "SELECT data FROM phases WHERE id=?", &[text(id)])?["data"])?;
                let mut text=format!("PARTIE {id} — {}\nRéférence : LoL 4.20.\nOBJECTIF : {}\nCONDITION DE FIN : {}\nPRÉREQUIS : {}\nTraiter chaque tâche avec ses consignes complètes ; conserver les acquis et relier les preuves actuelles.\nTÂCHES :\n",p["title"].as_str().unwrap_or(""),p["deliverable"].as_str().unwrap_or(""),p["exit_criteria"].as_str().unwrap_or(""),p["all_dependency_phases"]);
                for t in rows(
                    &c,
                    "SELECT id,title FROM tasks WHERE phase=? AND active=1 ORDER BY ordinal",
                    &[SqlValue::Text(id.to_string())],
                )? {
                    text.push_str(&format!(
                        "- {} : {}\n",
                        t["id"].as_str().unwrap_or(""),
                        t["title"].as_str().unwrap_or("")
                    ));
                }
                Ok(json!({"title":p["title"],"text":text}))
            }
            _ => Err("Copie inconnue.".into()),
        }
    }
    pub fn backup(&self, path: &Path) -> Result<()> {
        let c = self.db()?;
        c.backup("main", path, None).map_err(err)
    }
    pub fn request(&self, path: &str, method: &str, body: Value) -> Result<Value> {
        if !path.starts_with("/api/") || path.len() > 2000 || path.starts_with("//") {
            return Err("Commande locale inconnue.".into());
        }
        let u = url::Url::parse(&format!("http://localhost{path}")).map_err(err)?;
        let q = u.query_pairs().collect::<std::collections::HashMap<_, _>>();
        let get = |k: &str| q.get(k).map(|x| x.as_ref()).unwrap_or("");
        match (method, u.path()) {
            ("GET", "/api/bootstrap") => self.summary(),
            ("GET", "/api/tasks") => self.list(
                get("phase"),
                get("q"),
                if get("status").is_empty() {
                    "all"
                } else {
                    get("status")
                },
                if get("page").is_empty() {
                    1
                } else {
                    get("page").parse().map_err(|_| "Page invalide.")?
                },
                16,
            ),
            ("GET", "/api/copy") => self.copy_text(get("kind"), get("id")),
            ("POST", "/api/status") => self.change(&body["updates"], false),
            ("POST", "/api/undo") => {
                self.undo(body["change_id"].as_str().ok_or("Modification invalide.")?)
            }
            ("POST", "/api/import") => self.import(&body),
            ("GET", p) if p.starts_with("/api/task/") => {
                let id = url::form_urlencoded::parse(format!("id={}", &p[10..]).as_bytes())
                    .next()
                    .ok_or("Identifiant invalide.")?
                    .1
                    .into_owned();
                self.task(&id)
            }
            _ => Err("Commande locale inconnue.".into()),
        }
    }
}
