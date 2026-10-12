//! Native95EE00 spatial-query starting node. Integer grid conversion is separate.
#[derive(Debug,Clone)]
pub struct Node {pub bounds:[i32;4],pub record_count:u32,pub children:[Option<usize>;4]}
/// Inclusive signed overlap, including point/edge contacts. Query bounds retain native order.
fn overlaps(a:[i32;4],b:[i32;4])->bool {a[0]<=b[2] && a[2]>=b[0] && a[1]<=b[3] && a[3]>=b[1]}
pub fn select(nodes:&[Node],root:Option<usize>,rectangle:[i32;4])->Result<Option<usize>,&'static str> {
 let Some(mut current)=root else {return Ok(None);};let mut visited=vec![false;nodes.len()];
 loop {
  let node=nodes.get(current).ok_or("spatial root index outside tree")?;
  if visited[current] {return Err("spatial root selection contains a cycle");}visited[current]=true;
  if node.record_count!=0 {return Ok(Some(current));}
  let mut selected=None;
  for child in node.children.into_iter().flatten() {
   let candidate=nodes.get(child).ok_or("spatial child index outside tree")?;
   if overlaps(candidate.bounds,rectangle) {
    if selected.is_some() {return Ok(Some(current));}
    selected=Some(child);
   }
  }
  match selected {Some(child)=>current=child,None=>return Ok(Some(current))}
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn selected_root_matches768_original_tree_queries() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/spatial_visibility_root_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),768);
  for c in cases {
   let nodes=c["nodes"].as_array().unwrap().iter().map(|n|Node{bounds:std::array::from_fn(|i|n["bounds"][i].as_i64().unwrap() as i32),record_count:n["record_count"].as_u64().unwrap() as u32,children:std::array::from_fn(|i|n["children"][i].as_u64().map(|x|x as usize))}).collect::<Vec<_>>();
   let rectangle=std::array::from_fn(|i|c["query"][i].as_i64().unwrap() as i32);let root=c["root"].as_u64().map(|x|x as usize);
   assert_eq!(select(&nodes,root,rectangle).unwrap(),c["selected"].as_u64().map(|x|x as usize),"{c}");
  }
 }
}
