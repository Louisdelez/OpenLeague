//! Camera/spatial/transition composition for the native visibility manager.
use crate::{audio_emitter_camera_volume::Volume, camera_culling, camera_parameters::Parameters,
    entity_visibility_merge::{self, Object, Transition}, native_troy_scratch::Scratch, spatial_visibility::{self, Node}};
/// Query a qualified camera volume and retain duplicate descriptor handles.
pub fn visible_handles(nodes: &[Node], root: Option<usize>, volume: &Volume, bypass: bool) -> Result<Vec<u32>, &'static str> {
    let mut packet = Scratch::default();
    packet.set_visibility_inputs(
        std::array::from_fn(|i| volume.planes[i].coefficients.map(f32::to_bits)),
        std::array::from_fn(|i| volume.planes[i].indices.map(|v| v as u32)),
    );
    let mut current = spatial_visibility::select(nodes, root, volume.bounds, &packet, bypass)?;
    sort_handles(&mut current);
    Ok(current)
}
/// Native735920 compares unsigned descriptor addresses and preserves multiplicity.
pub fn sort_handles(handles: &mut [u32]) { handles.sort_unstable(); }
/// Previous handles must be the preceding successful frame's sorted output.
/// Errors leave caller-owned frame state untouched; lookup/callbacks retain merge order.
pub fn frame(previous: &[u32], nodes: &[Node], root: Option<usize>, camera: &Parameters,
    aspect: f32, inverse_fallback: &[f32;16], bypass: bool,
    lookup: impl FnMut(u32)->Option<Object>, notify: impl FnMut(Transition)) -> Result<Vec<u32>, &'static str> {
    let culling = camera_culling::from_parameters(camera, aspect, inverse_fallback)?;
    let current = visible_handles(nodes, root, &culling.volume, bypass)?;
    entity_visibility_merge::process(previous, &current, lookup, notify)?;
    Ok(current)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn visibility_sort_matches50_native_lists() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_visibility_sort_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),50);
  for c in cases {
   let read=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
   let mut actual=read("input");sort_handles(&mut actual);assert_eq!(actual,read("output"));
  }
 }
}

#[cfg(test)]
mod camera_tests {
 use super::*;
 #[test]
 fn visibility_camera_frame_matches576_native_volume_queries() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/spatial_visibility_camera_volume_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),576);
  for c in cases {
   let nodes=c["nodes"].as_array().unwrap().iter().map(|n|Node {
    grid_bounds:std::array::from_fn(|i|n["grid_bounds"][i].as_i64().unwrap() as i32),
    heights:[n["bounds"][1].as_f64().unwrap() as f32,n["bounds"][4].as_f64().unwrap() as f32],
    records:n["records"].as_array().unwrap().iter().map(|v|crate::spatial_visibility_query::Record{identity:v["id"].as_u64().unwrap() as u32,position:std::array::from_fn(|i|v["position"][i].as_f64().unwrap() as f32),minimum:std::array::from_fn(|i|v["minimum"][i].as_f64().unwrap() as f32),maximum:std::array::from_fn(|i|v["maximum"][i].as_f64().unwrap() as f32)}).collect(),
    children:std::array::from_fn(|i|n["children"].get(i).and_then(|v|v.as_u64()).map(|v|v as usize)),
   }).collect::<Vec<_>>();
   let cc=&c["camera_case"];
   let mut camera=Parameters::original_initial(std::array::from_fn(|i|cc["position"][i].as_f64().unwrap() as f32));
   camera.projection_raw=cc["mode"].as_u64().unwrap() as u32;
   camera.direction=std::array::from_fn(|i|cc["direction"][i].as_f64().unwrap() as f32);
   camera.up=std::array::from_fn(|i|cc["up"][i].as_f64().unwrap() as f32);
   let fallback=std::array::from_fn(|i|f32::from_bits(cc["fallback_bits"][i].as_u64().unwrap() as u32));
   let mut events=Vec::new();
   let actual=frame(&[],&nodes,c["root"].as_u64().map(|v|v as usize),&camera,f32::from_bits(cc["aspect_bits"].as_u64().unwrap() as u32),&fallback,c["bypass"].as_bool().unwrap(),|id|Some(Object{identity:id,active:1,type_flags:0x200}),|e|events.push(e)).unwrap();
   let mut expected=c["selected"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();expected.sort_unstable();
   assert_eq!(actual,expected,"{c}");
   assert_eq!(events,expected.iter().map(|id|Transition{identity:*id,active:true}).collect::<Vec<_>>());

  }
 }
}
