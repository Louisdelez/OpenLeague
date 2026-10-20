use openleague_plan::store::Store;
use serde_json::json;
use std::{collections::HashSet, path::PathBuf};
fn main() -> Result<(), String> {
    let path = std::env::args().nth(1).ok_or("Chemin de base requis.")?;
    let s = Store::new(PathBuf::from(path))?;
    let summary = s.summary()?;
    let mut ids = HashSet::new();
    let mut package_ids = HashSet::new();
    let first = s.list("", "", "all", 1, 30)?;
    let pages = first["pages"].as_i64().ok_or("Pagination absente.")?;
    for p in 1..=pages {
        let list = s.list("", "", "all", p, 30)?;
        for package in list["packages"].as_array().ok_or("Fiches absentes.")? {
            if !package_ids.insert(package["id"].as_str().unwrap().to_string()) {
                return Err("Fiche dupliquée.".into());
            }
            for t in package["tasks"].as_array().unwrap() {
                if !ids.insert(t["id"].as_str().unwrap().to_string()) {
                    return Err("Tâche dupliquée.".into());
                }
            }
        }
    }
    if ids.len() as u64 != summary["total"].as_u64().unwrap()
        || package_ids.len() as u64 != summary["packages"].as_u64().unwrap()
    {
        return Err("Catalogue incomplet.".into());
    }
    let garen = s.list("D06", "Garen", "all", 1, 16)?;
    let q = s.copy_text("task", "CH-Garen-Q-SIMULATION")?;
    let g = s.copy_text("package", "D06-CH-Garen")?;
    let export = s.export()?;
    println!(
        "{}",
        json!({"summary":summary,"unique_tasks":ids.len(),"unique_packages":package_ids.len(),
      "garen_tasks":garen["matched_tasks"],"garen_q_instruction_characters":q["text"].as_str().unwrap().chars().count(),
      "garen_fiche_characters":g["text"].as_str().unwrap().chars().count(),
      "export_active":export["tasks"].as_array().unwrap().len(),"export_archived":export["archived_tasks"].as_array().unwrap().len()})
    );
    Ok(())
}
