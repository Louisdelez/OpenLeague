//! Native6C9490/71A5B0 owner bounds transfer. Tree mutation is exposed to the caller.
#[derive(Debug, Clone)]
pub struct Record { pub center: [f32;3], pub attached: bool }
#[derive(Debug, Clone)]
pub struct Transfer {
    pub center_changed: bool,
    pub update_node: bool,
    pub minimum: [f32;3],
    pub maximum: [f32;3],
}
pub fn update(owner_bounds: &mut [f32;6], provider: Option<[f32;6]>, record: Option<&mut Record>) -> Result<Option<Transfer>, &'static str> {
    let Some(bounds) = provider else { return Ok(None); };
    if bounds.iter().any(|v| !v.is_finite()) { return Err("nonfinite projectile bounds not qualified"); }
    *owner_bounds = bounds;
    let Some(record) = record else { return Ok(None); };
    let center = [(bounds[0]+bounds[3])*0.5,(bounds[4]+bounds[1])*0.5,(bounds[5]+bounds[2])*0.5];
    let changed = center.iter().zip(record.center).any(|(a,b)| *a != b);
    if changed { record.center = center; }
    let maximum = std::array::from_fn(|i| (bounds[i+3]-bounds[i])*0.5);
    let minimum = maximum.map(|v:f32| f32::from_bits(v.to_bits()^0x80000000));
    Ok(Some(Transfer{center_changed:changed,update_node:changed && record.attached,minimum,maximum}))
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn projectile_spatial_bounds_match144_native_transfers() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_spatial_bounds_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),144);
  for c in cases {
   let read=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
   let mut bounds=std::array::from_fn(|i|read("initial_bits",i));
   let mut record=Record{center:std::array::from_fn(|i|read("previous_bits",i)),attached:c["attached"].as_bool().unwrap()};
   let provider=c["live"].as_bool().unwrap().then(||std::array::from_fn(|i|read("bounds_bits",i)));
   let registered=c["registered"].as_bool().unwrap();
   let transfer=update(&mut bounds,provider,if registered {Some(&mut record)}else{None}).unwrap();
   assert_eq!(bounds.map(f32::to_bits),std::array::from_fn(|i|read("owner_bounds",i).to_bits()));
   assert_eq!(record.center.map(f32::to_bits),std::array::from_fn(|i|read("center",i).to_bits()));
   let mut events=Vec::new();
   if let Some(t)=transfer {
    if t.center_changed {events.push(serde_json::json!({"kind":"grid","center":record.center.map(f32::to_bits)}));}
    if t.update_node {events.push(serde_json::json!({"kind":"node-update"}));}
    events.push(serde_json::json!({"kind":"extents","minimum":t.minimum.map(f32::to_bits),"maximum":t.maximum.map(f32::to_bits)}));
   }
   assert_eq!(serde_json::json!(events),c["events"],"{c}");
  }
 }
}

/// Native921F60 producer followed by940DF4 bounds export and6C9490 transfer.
/// Caller supplies the current owner position and decoded System/group-vis.
pub fn update_from_position(owner_bounds: &mut [f32;6], position: Option<[f32;3]>, group_vis: f32, record: Option<&mut Record>) -> Result<Option<Transfer>, &'static str> {
    let provider = position.map(|position| {
        let bounds = crate::native_troy_position_bounds::apply(position.map(f32::to_bits), group_vis.to_bits());
        [bounds.minimum[0],bounds.minimum[1],bounds.minimum[2],bounds.maximum[0],bounds.maximum[1],bounds.maximum[2]].map(f32::from_bits)
    });
    update(owner_bounds, provider, record)
}
#[cfg(test)]
mod producer_tests {
 use super::*;
 #[test]
 fn projectile_spatial_producer_matches192_native_transfers() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_spatial_bounds_producer_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),192);
  for c in cases {
   let read=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
   let mut bounds=std::array::from_fn(|i|read("initial_bits",i));
   let mut record=Record{center:std::array::from_fn(|i|read("previous_bits",i)),attached:c["attached"].as_bool().unwrap()};
   let position=c["live"].as_bool().unwrap().then(||std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32));
   let registered=c["registered"].as_bool().unwrap();
   let transfer=update_from_position(&mut bounds,position,c["coefficient"].as_f64().unwrap() as f32,if registered {Some(&mut record)}else{None}).unwrap();
   assert_eq!(bounds.map(f32::to_bits),std::array::from_fn(|i|read("owner_bounds",i).to_bits()));
   assert_eq!(record.center.map(f32::to_bits),std::array::from_fn(|i|read("center",i).to_bits()));
   let mut events=Vec::new();
   if let Some(t)=transfer {
    if t.center_changed {events.push(serde_json::json!({"kind":"grid","center":record.center.map(f32::to_bits)}));}
    if t.update_node {events.push(serde_json::json!({"kind":"node-update"}));}
    events.push(serde_json::json!({"kind":"extents","minimum":t.minimum.map(f32::to_bits),"maximum":t.maximum.map(f32::to_bits)}));
   }
   assert_eq!(serde_json::json!(events),c["events"],"{c}");
  }
 }
}

