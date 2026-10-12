from pathlib import Path
r=Path(r'E:\OpenLeague')
p=r/'crates/client/src/match_results_ui.rs';s=p.read_text(encoding='utf-8');s=s.replace('let mut game=openleague_core::Simulation::new(&root).unwrap();','let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("../../assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();\n  let mut game=openleague_core::Simulation::new(navigation).unwrap();game.enable_map10().unwrap();');p.write_text(s,encoding='utf-8')
p=r/'crates/server/src/result_store.rs';assert not p.exists()
p.write_text('''use openleague_core::match_results::MatchResult;
use std::{fs,io::{self,Write},path::{Path,PathBuf}};
/// Write a complete synced document before publishing it. An existing result is immutable.
pub fn save(directory:&Path,result:&MatchResult)->io::Result<PathBuf>{
 fs::create_dir_all(directory)?;
 let path=directory.join(format!("{}.json",result.session));
 let bytes=serde_json::to_vec_pretty(result)?;
 if path.exists(){if fs::read(&path)?==bytes{return Ok(path);}return Err(io::Error::new(io::ErrorKind::AlreadyExists,"result session already contains different data"));}
 let temporary=directory.join(format!("{}.{}.pending",result.session,std::process::id()));
 let mut file=fs::OpenOptions::new().write(true).create_new(true).open(&temporary)?;
 let written=(||{file.write_all(&bytes)?;file.sync_all()})();drop(file);
 if let Err(error)=written {let _=fs::remove_file(&temporary);return Err(error);}
 // A hard link publishes atomically without replacing a different session document.
 let published=fs::hard_link(&temporary,&path);let _=fs::remove_file(&temporary);published?;Ok(path)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn stored_result_is_readable_idempotent_and_cannot_be_overwritten(){
  let directory=std::env::temp_dir().join(format!("openleague-result-test-{}-{}",std::process::id(),std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos()));
  let mut result=MatchResult{session:7,ended_tick:123,winner:0,players:vec![]};let path=save(&directory,&result).unwrap();
  let restored:MatchResult=serde_json::from_slice(&fs::read(&path).unwrap()).unwrap();assert_eq!(restored.ended_tick,123);assert_eq!(restored.winner,0);assert_eq!(save(&directory,&result).unwrap(),path);
  result.winner=1;assert_eq!(save(&directory,&result).unwrap_err().kind(),io::ErrorKind::AlreadyExists);assert_eq!(fs::read_dir(&directory).unwrap().count(),1);fs::remove_file(path).unwrap();fs::remove_dir(directory).unwrap();
 }
}
''',encoding='utf-8')
p=r/'crates/server/src/main.rs';s=p.read_text(encoding='utf-8');s='mod result_store;\n'+s;s=s.replace('    let mut next = Instant::now();','    let mut result_saved=false;\n    let mut next_result_attempt=Instant::now();\n    let mut next = Instant::now();',1)
needle='        if catchup > 0 && Instant::now() >= next_snapshot {';assert needle in s
s=s.replace(needle,'''        if !result_saved && Instant::now()>=next_result_attempt {
            if let Some(result)=game.final_results() {
                match result_store::save(&root.join("runtime/matches"),result) {
                    Ok(path)=>{result_saved=true;println!("Match result saved: {}",path.display());}
                    Err(error)=>{eprintln!("Match result save failed: {error}");next_result_attempt=Instant::now()+Duration::from_secs(5);}
                }
            }
        }
'''+needle,1);p.write_text(s,encoding='utf-8')
print('result persistence integrated; UI test fixture corrected')
