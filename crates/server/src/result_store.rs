use openleague_core::match_results::MatchResult;
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
  let mut result=MatchResult{session:7,ended_tick:123,winner:0,players:vec![],destroyed_nexus:None};let path=save(&directory,&result).unwrap();
  let restored:MatchResult=serde_json::from_slice(&fs::read(&path).unwrap()).unwrap();assert_eq!(restored.ended_tick,123);assert_eq!(restored.winner,0);assert_eq!(save(&directory,&result).unwrap(),path);
  result.winner=1;assert_eq!(save(&directory,&result).unwrap_err().kind(),io::ErrorKind::AlreadyExists);assert_eq!(fs::read_dir(&directory).unwrap().count(),1);fs::remove_file(path).unwrap();fs::remove_dir(directory).unwrap();
 }
}
