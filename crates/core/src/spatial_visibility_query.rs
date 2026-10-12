//! Recursive native9601C0 query. Tree construction and camera/root selection are separate.
use crate::native_troy_scratch::Scratch;
#[derive(Debug,Clone)]
pub struct Record {pub identity:u32,pub position:[f32;3],pub minimum:[f32;3],pub maximum:[f32;3]}
#[derive(Debug,Clone)]
pub struct Node {pub bounds:[f32;6],pub records:Vec<Record>,pub children:[Option<usize>;4]}
/// Preserve linked-list order followed by child slots0..3. Sorting belongs to the caller.
pub fn query(nodes:&[Node],root:usize,classification:i32,bypass:bool,volume:&Scratch)->Result<Vec<u32>,&'static str> {
 let mut result=Vec::new();let mut ancestors=vec![false;nodes.len()];
 fn walk(nodes:&[Node],index:usize,class:i32,bypass:bool,volume:&Scratch,ancestors:&mut [bool],result:&mut Vec<u32>)->Result<(),&'static str> {
  if class==-1 {return Ok(());}
  let node=nodes.get(index).ok_or("spatial child index outside tree")?;
  if ancestors[index] {return Err("spatial tree contains a cycle");}ancestors[index]=true;
  for record in &node.records {
   let accepted=if bypass || class!=0 {true} else {
    let bounds=std::array::from_fn(|i|{let axis=i%3;(record.position[axis]+if i<3 {record.minimum[axis]} else {record.maximum[axis]}).to_bits()});
    volume.contains_bounds(bounds)?
   };
   if accepted {result.push(record.identity);}
  }
  for child in node.children.into_iter().flatten() {
   // Native960310 deliberately classifies the CURRENT node before each child call.
   let child_class=if class==0 {volume.classify_bounds(node.bounds.map(f32::to_bits))?} else {class};
   walk(nodes,child,child_class,bypass,volume,ancestors,result)?;
  }
  ancestors[index]=false;Ok(())
 }
 walk(nodes,root,classification,bypass,volume,&mut ancestors,&mut result)?;Ok(result)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn recursive_query_and_real_plane_tests_match108_native_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/spatial_visibility_query_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),108);
  let mut volume=Scratch::default();volume.set_visibility_inputs(std::array::from_fn(|i|std::array::from_fn(|j|(proof["planes"][i][j].as_f64().unwrap() as f32).to_bits())),std::array::from_fn(|i|std::array::from_fn(|j|proof["selectors"][i][j].as_u64().unwrap() as u32)));
  for c in cases {
   let nodes=c["nodes"].as_array().unwrap().iter().map(|n|Node{bounds:std::array::from_fn(|i|n["bounds"][i].as_f64().unwrap() as f32),records:n["records"].as_array().unwrap().iter().map(|v|Record{identity:v["id"].as_u64().unwrap() as u32,position:std::array::from_fn(|i|v["position"][i].as_f64().unwrap() as f32),minimum:std::array::from_fn(|i|v["minimum"][i].as_f64().unwrap() as f32),maximum:std::array::from_fn(|i|v["maximum"][i].as_f64().unwrap() as f32)}).collect(),children:std::array::from_fn(|i|n["children"].get(i).map(|x|x.as_u64().unwrap() as usize))}).collect::<Vec<_>>();
   let actual=query(&nodes,0,c["initial"].as_i64().unwrap() as i32,c["bypass"].as_bool().unwrap(),&volume).unwrap();
   let expected=c["selected"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect::<Vec<_>>();assert_eq!(actual,expected,"{c}");
  }
 }
}
