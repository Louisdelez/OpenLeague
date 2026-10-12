//! Native8B4EF0/8B4F60/8B5170 dispatch; provider implementations remain external.
fn cbytes(value:&[u8])->&[u8] {&value[..value.iter().position(|&b|b==0).unwrap_or(value.len())]}
pub fn mode_flags(mode:&[u8])->u32 {
 let mode=cbytes(mode);let first=mode.first().copied();
 (if first==Some(b'r') {4}else{0}) | (if matches!(first,Some(b'w'|b'a')) || mode.get(1)==Some(&b'+') {2}else{0})
}
pub fn open<T>(count:i32,path:&[u8],mode:&[u8],mut predicate:impl FnMut(usize,&[u8],u32)->i32,mut opener:impl FnMut(usize,&[u8],&[u8])->Option<T>)->Option<T> {
 let path=cbytes(path);let mode=cbytes(mode);let flags=mode_flags(mode);
 for index in 0..count.max(0) as usize {
  if predicate(index,path,flags)==0 {if let Some(file)=opener(index,path,mode) {return Some(file)}}
 }
 None
}
pub fn status(count:i32,path:&[u8],mut predicate:impl FnMut(usize,&[u8],u32)->i32)->i32 {
 let mut status=-1;let path=cbytes(path);
 for index in 0..count.max(0) as usize {status=predicate(index,path,0);if status==0 {break}}
 status
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn provider_order_modes_and_status_match_all_native_dispatch_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_resource_dispatch_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],7695);
  for c in proof["cases"].as_array().unwrap() {
   let calls=std::cell::RefCell::new(Vec::new());let count=c["provider_count"].as_i64().unwrap() as i32;
   let predicate=|index:usize,path:&[u8],flags:u32| {assert_eq!(path,b"Config/Game.cfg");let status=c["statuses"][index].as_i64().unwrap() as i32;calls.borrow_mut().push(serde_json::json!({"kind":"predicate","provider":index,"flags":flags,"status":status}));status};
   if c["kind"]=="open" {
    let actual=open(count,b"Config/Game.cfg",c["mode"].as_str().unwrap().as_bytes(),predicate,|index,path,mode| {assert_eq!(path,b"Config/Game.cfg");let returned=c["handles"][index].as_bool().unwrap();calls.borrow_mut().push(serde_json::json!({"kind":"open","provider":index,"mode":std::str::from_utf8(mode).unwrap(),"returned":returned}));returned.then_some(index)});
    assert_eq!(actual,c["winner"].as_u64().map(|i|i as usize));assert_eq!(mode_flags(c["mode"].as_str().unwrap().as_bytes()),c["flags"].as_u64().unwrap() as u32);
   } else {assert_eq!(status(count,b"Config/Game.cfg",predicate),c["status"].as_i64().unwrap() as i32)}
   assert_eq!(*calls.borrow(),*c["calls"].as_array().unwrap());
  }
 }
}
