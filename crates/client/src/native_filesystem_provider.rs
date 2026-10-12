//! Native simple provider8B6280/8B6360 and file8B5F90 read path.
//! Host Windows CRT implements the I/O boundary; archive provider is separate.
use std::{io,path::Path};
#[cfg(windows)] mod windows {
 use super::*;
 use std::ffi::{c_char,c_int,c_long,c_void,CString};
 unsafe extern "C" {
  fn _access(path:*const c_char,mode:c_int)->c_int;
  fn fopen_s(file:*mut *mut c_void,path:*const c_char,mode:*const c_char)->c_int;
  fn fclose(file:*mut c_void)->c_int;
  fn setvbuf(file:*mut c_void,buffer:*mut c_char,mode:c_int,size:usize)->c_int;
  fn ftell(file:*mut c_void)->c_long;
  fn fseek(file:*mut c_void,offset:c_long,origin:c_int)->c_int;
  fn fread(buffer:*mut c_void,size:usize,count:usize,file:*mut c_void)->usize;
 }
 struct Stream {file:*mut c_void,size:usize}
 impl Drop for Stream {fn drop(&mut self) {unsafe {fclose(self.file);}}}
 fn path_string(path:&Path)->io::Result<CString> {
  let path=path.to_str().ok_or_else(||io::Error::other("invalid historical file path"))?;
  if !path.is_ascii() {return Err(io::Error::new(io::ErrorKind::Unsupported,"historical non-ASCII file encoding is unqualified"));}
  CString::new(path).map_err(|_|io::Error::new(io::ErrorKind::InvalidInput,"embedded NUL in filesystem path"))
 }
 pub fn read(path:&Path)->io::Result<Option<Vec<u8>>> {
  let path=path_string(path)?;
  let selected=crate::native_config_resource_dispatch::open(1,path.as_bytes(),b"rb",|_,_,flags| {
   let value=unsafe {_access(path.as_ptr(),flags as c_int)};if value==0 {0}else{-1}
  },|_,_,_| {
   let mut file=std::ptr::null_mut();let code=unsafe {fopen_s(&mut file,path.as_ptr(),c"rb".as_ptr())};
   if code!=0 || file.is_null() {if !file.is_null() {unsafe {fclose(file);}}return None;}
   let mut stream=Stream {file,size:0};
   unsafe {setvbuf(file,std::ptr::null_mut(),0,64000);}
   let initial=unsafe {ftell(file)};unsafe {fseek(file,0,2);}
   let size=unsafe {ftell(file)};unsafe {fseek(file,initial,0);}
   // Native stores signed ftell into an unsigned field. Negative positions and
   // allocation-failure behavior remain unqualified; report them explicitly.
   if initial<0 || size<0 {return Some(Err(io::Error::new(io::ErrorKind::Unsupported,"native negative file position/size is unqualified")));}
   stream.size=size as usize;Some(Ok(stream))
  });
  let Some(stream)=selected.transpose()? else {return Ok(None)};
  let mut bytes=Vec::new();bytes.try_reserve_exact(stream.size).map_err(io::Error::other)?;bytes.resize(stream.size,0);
  unsafe {fseek(stream.file,0,0);fread(bytes.as_mut_ptr().cast(),bytes.len(),1,stream.file);}
  // Native reader ignores fread's item count; original zero-filled storage
  // remains available to the parser on a short read. Concurrent I/O is open.
  Ok(Some(bytes))
 }
}
#[cfg(windows)] pub fn read(path:&Path)->io::Result<Option<Vec<u8>>> {windows::read(path)}
#[cfg(not(windows))] pub fn read(_path:&Path)->io::Result<Option<Vec<u8>>> {Err(io::Error::new(io::ErrorKind::Unsupported,"native Windows CRT provider is unavailable"))}
#[cfg(all(test,windows))] mod tests {
 use super::*;
 #[test] fn real_files_through_crt_provider_match_native_full_text_pipeline() {
  let root=std::env::temp_dir().join(format!("openleague-native-filesystem-{}-{}",std::process::id(),std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos()));std::fs::create_dir(&root).unwrap();
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_filesystem_text_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
  let decode=|v:&serde_json::Value|v.as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
  let latin=|v:&serde_json::Value|v.as_str().unwrap().chars().map(|c|u8::try_from(c as u32).unwrap()).collect::<Vec<u8>>();
  for c in proof["cases"].as_array().unwrap() {
   let paths=[root.join("user.cfg"),root.join("defaults.cfg")];let inputs=[decode(&c["primary"]),decode(&c["baseline"])];
   for (path,bytes) in paths.iter().zip(&inputs) {match bytes {Some(bytes)=>std::fs::write(path,bytes).unwrap(),None=>{if path.exists() {std::fs::remove_file(path).unwrap();}}}}
   let primary=read(&paths[0]).unwrap();let baseline=read(&paths[1]).unwrap();assert_eq!([primary.clone(),baseline.clone()],inputs);
   let actual=crate::native_game_cfg_text::load_text_files(primary.as_deref(),baseline.as_deref());assert_eq!(actual.loaded,c["loaded"].as_bool().unwrap());assert_eq!(actual.parsed.warnings,c["result"]["warnings"].as_u64().unwrap() as usize);assert_eq!(actual.parsed.error,c["result"]["error"].as_str());
   let rows=c["result"]["entries"].as_array().unwrap();assert_eq!(actual.parsed.entries.len(),rows.len());
   for (entry,row) in actual.parsed.entries.iter().zip(rows) {assert_eq!(entry.hash,row["hash"].as_u64().unwrap() as u32);assert_eq!(entry.section,latin(&row["section"]));assert_eq!(entry.key,latin(&row["key"]));assert_eq!(entry.value,latin(&row["value"]));}
  }
  // A closed CRT stream must release its file for subsequent rename/removal.
  let source=root.join("user.cfg");std::fs::write(&source,b"owned").unwrap();assert_eq!(read(&source).unwrap(),Some(b"owned".to_vec()));std::fs::rename(&source,root.join("closed.cfg")).unwrap();
  let cleanup=root.canonicalize().unwrap();let parent=std::env::temp_dir().canonicalize().unwrap();assert_eq!(cleanup.parent(),Some(parent.as_path()));assert!(cleanup.file_name().unwrap().to_string_lossy().starts_with("openleague-native-filesystem-"));std::fs::remove_dir_all(cleanup).unwrap();
 }
}
