//! Native8B7A10/8BA8C0 archive-name lookup, supplied valid index/C locale.
//! ZIP mounting, insertion/duplicate precedence and decompression are separate.
fn cbytes(bytes:&[u8])->&[u8] {&bytes[..bytes.iter().position(|&b|b==0).unwrap_or(bytes.len())]}
pub fn hash(bytes:&[u8])->u32 {
 cbytes(bytes).iter().fold(0u32,|h,&b|h.wrapping_mul(65599).wrapping_add((b.to_ascii_lowercase() as i8 as i32) as u32))
}
pub fn normalize(bytes:&[u8])->Vec<u8> {
 let bytes=cbytes(bytes);let mut out=Vec::new();let mut i=0;
 while i<bytes.len() {
  match bytes[i] {b'/'=>out.push(b'\\'),b'\\' if bytes.get(i+1)==Some(&b'\\')=>{out.push(b'\\');i+=1;},b=>out.push(b)}
  i+=1;
 }
 while out.last()==Some(&b' ') {out.pop();}
 out
}
fn compare(left:&[u8],right:&[u8])->std::cmp::Ordering {cbytes(left).iter().map(|b|b.to_ascii_lowercase()).cmp(cbytes(right).iter().map(|b|b.to_ascii_lowercase()))}
#[derive(Debug)] pub struct Entry {pub key:Vec<u8>,pub packed_id:u32}
pub struct Index {entries:Vec<Entry>,buckets:Vec<Vec<usize>>,mask:u32}
impl Index {
 pub fn from_rows(entries:Vec<Entry>,mask:u32,count:usize)->Result<Self,&'static str> {
  let capacity=mask.checked_add(1).ok_or("unqualified archive bucket mask")?;
  if !capacity.is_power_of_two() || count==0 || count>capacity as usize || count<(capacity/2).max(1) as usize {return Err("invalid native archive bucket layout");}
  let mut buckets=vec![Vec::new();count];
  for (i,entry) in entries.iter().enumerate() {
   let mut bucket=hash(&entry.key)&mask;if bucket>=count as u32 {bucket-= (mask>>1)+1;}
   if buckets[bucket as usize].iter().any(|&j: &usize|compare(&entries[j].key,&entry.key).is_eq()) {return Err("native duplicate archive-key insertion precedence unqualified");}
   buckets[bucket as usize].push(i);
  }
  for bucket in &mut buckets {bucket.sort_by(|&a,&b|compare(&entries[a].key,&entries[b].key));}
  Ok(Self {entries,buckets,mask})
 }
 fn find(&self,key:&[u8])->Option<u32> {
  let mut bucket=hash(key)&self.mask;if bucket>=self.buckets.len() as u32 {bucket-= (self.mask>>1)+1;}
  for &i in &self.buckets[bucket as usize] {
   let entry=&self.entries[i];match compare(&entry.key,key) {std::cmp::Ordering::Less=>continue,std::cmp::Ordering::Equal=>return Some(entry.packed_id),std::cmp::Ordering::Greater=>return None}
  }
  None
 }
 pub fn lookup(&self,requested:Option<&[u8]>,enabled:bool,mut query:impl FnMut(&[u8]))->Result<Option<u32>,&'static str> {
  let Some(requested)=requested.filter(|_|enabled) else {return Ok(None)};let requested=cbytes(requested);query(requested);
  if let Some(value)=self.find(requested) {return Ok(Some(value));}
  //8B7A10 has260 bytes between its temporary output and security cookie.
  // Larger misses require an unqualified native stack-buffer overwrite.
  if requested.len()>=260 {return Err("native archive fallback buffer length exceeded");}
  let normalized=normalize(requested);query(&normalized);Ok(self.find(&normalized))
 }
}
#[cfg(test)] mod tests {
 use super::*;
 fn bytes(v:&serde_json::Value)->Vec<u8> {v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect()}
 #[test] fn normalized_result_bytes_match_every_native_alias_and_boundary_fixture() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_archive_path_normalization_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],188);let mut underwrites=0;
  for c in proof["cases"].as_array().unwrap() {assert_eq!(normalize(&bytes(&c["input"])),bytes(&c["output"]));if !c["writes_before_output"].as_array().unwrap().is_empty() {underwrites+=1;}}
  // Only output bytes match these fixtures. Native underwrites have no safe
  // equivalent in owned Vec storage and are not a supported memory contract.
  assert_eq!(underwrites,4);
 }
 #[test] fn native_raw_normalized_hash_bucket_and_case_lookup_match_all_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_archive_index_lookup_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],720);
  for c in proof["cases"].as_array().unwrap() {
   let entries=c["entries"].as_array().unwrap().iter().map(|e|Entry {key:bytes(&e["key"]),packed_id:e["packed_id"].as_u64().unwrap() as u32}).collect();
   let index=Index::from_rows(entries,c["mask"].as_u64().unwrap() as u32,c["bucket_count"].as_u64().unwrap() as usize).unwrap();let requested=c["requested"].as_array().map(|_|bytes(&c["requested"]));let mut queries=Vec::new();
   let actual=index.lookup(requested.as_deref(),c["enabled"].as_bool().unwrap(),|key|queries.push(key.to_vec())).unwrap();assert_eq!(actual,c["result"].as_u64().map(|i|i as u32));assert_eq!(actual.is_some(),c["found"].as_bool().unwrap());
   let expected:Vec<Vec<u8>>=c["queries"].as_array().unwrap().iter().map(bytes).collect();assert_eq!(queries,expected);
  }
 }
}
