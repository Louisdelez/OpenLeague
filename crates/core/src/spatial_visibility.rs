//! Native95EBA0 composition: grid conversion, starting node and recursive query.
use crate::{native_troy_scratch::Scratch, spatial_visibility_grid, spatial_visibility_root, spatial_visibility_query};
#[derive(Debug, Clone)]
pub struct Node {
    pub grid_bounds: [i32; 4],
    pub heights: [f32; 2],
    pub records: Vec<spatial_visibility_query::Record>,
    pub children: [Option<usize>; 4],
}
/// Returns traversal order; descriptor sorting belongs to the visibility manager.
pub fn select(nodes: &[Node], root: Option<usize>, bounds: [f32; 6], volume: &Scratch, bypass: bool) -> Result<Vec<u32>, &'static str> {
    let rectangle = spatial_visibility_grid::rectangle(bounds)?;
    let roots = nodes.iter().map(|n| Ok(spatial_visibility_root::Node {
        bounds: n.grid_bounds,
        record_count: u32::try_from(n.records.len()).map_err(|_| "spatial record count exceeds native range")?,
        children: n.children,
    })).collect::<Result<Vec<_>, &'static str>>()?;
    let Some(index) = spatial_visibility_root::select(&roots, root, rectangle)? else { return Ok(Vec::new()); };
    let query_nodes = nodes.iter().map(|n| spatial_visibility_query::Node {
        bounds: [n.grid_bounds[0] as f32, n.heights[0], n.grid_bounds[1] as f32, n.grid_bounds[2] as f32, n.heights[1], n.grid_bounds[3] as f32],
        records: n.records.clone(), children: n.children,
    }).collect::<Vec<_>>();
    let class = volume.classify_bounds(query_nodes[index].bounds.map(f32::to_bits))?;
    spatial_visibility_query::query(&query_nodes, index, class, bypass, volume)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn spatial_composition_matches120_full_native_queries() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/spatial_visibility_composition_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),120);
  for c in cases {
   let mut volume=Scratch::default();
   volume.set_visibility_inputs(std::array::from_fn(|i|std::array::from_fn(|j|(c["planes"][i][j].as_f64().unwrap() as f32).to_bits())),std::array::from_fn(|i|std::array::from_fn(|j|c["selectors"][i][j].as_u64().unwrap() as u32)));
   let nodes=c["nodes"].as_array().unwrap().iter().map(|n|Node {
    grid_bounds:std::array::from_fn(|i|n["grid_bounds"][i].as_i64().unwrap() as i32),
    heights:[n["bounds"][1].as_f64().unwrap() as f32,n["bounds"][4].as_f64().unwrap() as f32],
    records:n["records"].as_array().unwrap().iter().map(|v|spatial_visibility_query::Record{identity:v["id"].as_u64().unwrap() as u32,position:std::array::from_fn(|i|v["position"][i].as_f64().unwrap() as f32),minimum:std::array::from_fn(|i|v["minimum"][i].as_f64().unwrap() as f32),maximum:std::array::from_fn(|i|v["maximum"][i].as_f64().unwrap() as f32)}).collect(),
    children:std::array::from_fn(|i|n["children"].get(i).and_then(|v|v.as_u64()).map(|v|v as usize)),
   }).collect::<Vec<_>>();
   let actual=select(&nodes,c["root"].as_u64().map(|v|v as usize),std::array::from_fn(|i|c["volume_bounds"][i].as_f64().unwrap() as f32),&volume,c["bypass"].as_bool().unwrap()).unwrap();
   let expected=c["selected"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
   assert_eq!(actual,expected,"{c}");
  }
 }
}
