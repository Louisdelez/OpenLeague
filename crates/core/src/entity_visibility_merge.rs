//! Native71A785 visibility-list merge; spatial query and frame scheduling are separate.
#[derive(Debug,Copy,Clone)]
pub struct Object {pub identity:u32,pub active:u8,pub type_flags:u32}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Transition {pub identity:u32,pub active:bool}
/// Input handles must retain native unsigned address order, including duplicates.
/// Lookup is performed for each unmatched occurrence, before its callback.
pub fn process(previous:&[u32],current:&[u32],mut lookup:impl FnMut(u32)->Option<Object>,mut notify:impl FnMut(Transition))->Result<(),&'static str> {
 if previous.windows(2).any(|p|p[0]>p[1]) || current.windows(2).any(|p|p[0]>p[1]) {return Err("visibility handles must be sorted");}
 let(mut old,mut new)=(0,0);
 while old<previous.len() || new<current.len() {
  let (handle,active)=if old==previous.len() {let h=current[new];new+=1;(h,true)}
   else if new==current.len() {let h=previous[old];old+=1;(h,false)}
   else if previous[old]==current[new] {old+=1;new+=1;continue;}
   else if previous[old]<current[new] {let h=previous[old];old+=1;(h,false)}
   else {let h=current[new];new+=1;(h,true)};
  if handle==0 {continue;}
  if let Some(object)=lookup(handle) {
   if object.active!=0 && object.type_flags&0x200!=0 {notify(Transition{identity:object.identity,active});}
  }
 }
 Ok(())
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn transitions_match576_native_merges() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_visibility_merge_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),576);
  for c in cases {
   let handles=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
   let previous=handles("previous");let current=handles("current");let mut actual=Vec::new();
   process(&previous,&current,|id|c["objects"].as_array().unwrap().iter().find(|o|o["id"].as_u64()==Some(id as u64)).map(|o|Object{identity:id,active:u8::from(o["active"].as_bool().unwrap()),type_flags:o["flags"].as_u64().unwrap() as u32}),|t|actual.push(t)).unwrap();
   let expected=c["events"].as_array().unwrap().iter().map(|e|Transition{identity:e["id"].as_u64().unwrap() as u32,active:e["active"].as_bool().unwrap()}).collect::<Vec<_>>();
   assert_eq!(actual,expected,"{c}");
  }
 }
}
