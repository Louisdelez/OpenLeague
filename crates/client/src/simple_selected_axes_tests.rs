use super::*;
#[test] fn original_fixed_axes_and_pickup_selection_match_all_entries() {
 let fixed:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/fixed_axes_contract.json")).unwrap();
 let index:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/angle_index_contract.json")).unwrap();
 let source:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/integer_selection_contract.json")).unwrap();
 assert_eq!(fixed["passed"],true);assert_eq!(index["passed"],true);assert_eq!(source["passed"],true);
 for row in fixed["cases"].as_array().unwrap() {let orientation=row["orientation"].as_u64().unwrap() as u32;
  for (angle,words) in row["angle_words"].as_array().unwrap().iter().enumerate() {assert_eq!(selected_fixed(orientation,angle as f32).unwrap(),std::array::from_fn(|i|words[i].as_u64().unwrap() as u32));}
 }
 for row in index["cases"].as_array().unwrap(){assert_eq!(angle_index(f32::from_bits(row["angle_word"].as_u64().unwrap() as u32)),row["index"].as_u64().unwrap() as usize);}
 for row in source["cases"].as_array().unwrap().iter().filter(|r|r["field"]=="p-simpleorient") {
  let orientation=row["native_value"].as_u64().unwrap() as u32;
  if orientation==0 {assert!(selected_fixed(orientation,0.).is_err());} else {assert!(selected_fixed(orientation,-800.).is_ok());}
 }
 for invalid in [0,4,u32::MAX]{assert!(selected_fixed(invalid,0.).is_err());}
}

#[test] fn camera_orientation_requires_current_view_and_matches_native_tables(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_camera_axes_vectors.json")).unwrap();
 for c in proof["cases"].as_array().unwrap(){let view=std::array::from_fn(|i|f32::from_bits(c["view_bits"][i].as_u64().unwrap() as u32));
  for (angle,words) in c["all_angle_words"].as_array().unwrap().iter().enumerate(){assert_eq!(selected(0,angle as f32,Some(view)).unwrap(),std::array::from_fn(|i|words[i].as_u64().unwrap() as u32));}
 }
 assert!(selected(0,0.,None).is_err());assert!(selected(0,0.,Some([f32::NAN;16])).is_err());
 for orient in 1..4 {assert_eq!(selected(orient,-800.,None).unwrap(),selected_fixed(orient,-800.).unwrap());}
 assert!(selected(4,0.,Some([0.;16])).is_err());
}
