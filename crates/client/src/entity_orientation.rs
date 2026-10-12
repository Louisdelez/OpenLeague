//! Native6AB380 yaw bridged to Bevy transforms; snapshot delta producer is reconstructed.
use bevy::prelude::*;
pub fn from_native_delta(direction:[f32;3])->Result<Option<Quat>,&'static str> {
 let mut frame=[0u32;19];for i in [0,5,10,15] {frame[i]=1_f32.to_bits();}
 if openleague_core::entity_yaw::update(&mut frame,direction)?.is_none() {return Ok(None);}
 Ok(Some(from_frame(&frame)))
}
pub fn from_facing(facing:openleague_core::entity_facing::Facing)->Result<Quat,&'static str> {
 let mut frame=[0u32;19];openleague_core::entity_yaw::apply_angle(&mut frame,facing.yaw_degrees())?;Ok(from_frame(&frame))
}
fn from_frame(frame:&[u32;19])->Quat {
 let row=|base:usize|Vec3::new(f32::from_bits(frame[base]),f32::from_bits(frame[base+1]),f32::from_bits(frame[base+2]));
 // Native row-vector basis becomes Bevy's column-vector basis. Quaternion normalizes
 // the tiny sine-table length error; raw matrix fidelity stays in the core contract.
 let matrix=Mat3::from_cols(row(0),row(4),row(8));
 Quat::from_mat3(&matrix).normalize()
}
pub fn apply(transform:&mut Transform,native_delta:[f32;3]) {
 match from_native_delta(native_delta) {Ok(Some(rotation))=>{transform.rotation=rotation;trace(native_delta,rotation);},Ok(None)=>{},Err(error)=>warn!("Native entity orientation: {error}")}
}
/// Heading is public source state; do not resolve a possibly private target here.
/// Legacy None retains displacement fallback. A reset from known to unknown, or
/// observed respawn, uses the existing identity spawn orientation (not native-qualified).
pub fn apply_snapshot(transform:&mut Transform, previous:Option<&openleague_core::Champion>, current:&openleague_core::Champion) {
 if let Some(facing)=current.facing {
  match from_facing(facing) {Ok(rotation)=>transform.rotation=rotation,Err(error)=>warn!("Authoritative entity orientation: {error}")}
 } else {
  let reset=previous.is_some_and(|old|old.facing.is_some() || (old.health<=0. && current.health>0.) || (old.respawn_at.is_some() && current.respawn_at.is_none()));
  if reset {transform.rotation=Quat::IDENTITY;}
  else if let Some(old)=previous {apply(transform,[current.position.x-old.position.x,0.,current.position.z-old.position.z]);}
 }
 // Preserve the existing explicit Annie W priority.
 if let Some(cast)=&current.effects.annie_w {apply(transform,[cast.direction.x,0.,cast.direction.z]);}
}
// Explicit screenshot diagnostic only; ordinary play allocates no trace rows.
fn trace(delta:[f32;3],rotation:Quat) {
 struct Trace {path:std::path::PathBuf,rows:Vec<serde_json::Value>,written:bool}
 static TRACE:std::sync::OnceLock<Option<std::sync::Mutex<Trace>>>=std::sync::OnceLock::new();
 let Some(trace)=TRACE.get_or_init(||std::env::var_os("OPENLEAGUE_ENTITY_YAW_TRACE").map(|path|{assert!(std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some(),"yaw trace requires screenshot mode");std::sync::Mutex::new(Trace{path:path.into(),rows:Vec::new(),written:false})})) else{return};
 let mut t=trace.lock().expect("yaw trace mutex");if t.written{return;}
 let mut frame=[0u32;19];openleague_core::entity_yaw::update(&mut frame,delta).expect("qualified finite yaw");
 t.rows.push(serde_json::json!({"direction_bits":delta.map(f32::to_bits),"matrix_bits":frame[..16],"render_quaternion":rotation.to_array()}));
 if t.rows.len()==128 {std::fs::write(&t.path,serde_json::to_vec_pretty(&serde_json::json!({"diagnostic":true,"frames":t.rows,"native_input_producer_complete":false})).expect("yaw trace JSON")).expect("yaw trace write");t.written=true;t.rows.clear();println!("Native entity yaw trace captured:128updates");}
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn render_forward_matches_108_native_nonzero_yaw_bases() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_yaw_contract.json")).unwrap();let mut count=0;
  for c in p["cases"].as_array().unwrap() {
   let delta=std::array::from_fn(|i|f32::from_bits(c["direction_bits"][i].as_u64().unwrap() as u32));let Some(rotation)=from_native_delta(delta).unwrap() else{continue};count+=1;
   let native=Vec3::new(f32::from_bits(c["output_frame_bits"][8].as_u64().unwrap() as u32),f32::from_bits(c["output_frame_bits"][9].as_u64().unwrap() as u32),f32::from_bits(c["output_frame_bits"][10].as_u64().unwrap() as u32)).normalize();
   assert!((rotation*Vec3::Z-native).length()<2e-6);assert!((rotation.length()-1.).abs()<1e-6);
  }
  assert_eq!(count,108);
 }
 #[test]
 fn stopped_snapshot_preserves_rotation_and_nonfinite_delta_is_explicitly_unsupported() {
  let mut transform=Transform::from_rotation(Quat::from_rotation_y(0.7));let old=transform.rotation;
  apply(&mut transform,[0.,10.,-0.]);assert_eq!(transform.rotation,old);assert!(from_native_delta([f32::NAN,0.,1.]).is_err());
 }
}

#[cfg(test)]
#[path = "entity_facing_tests.rs"]
mod facing_tests;
