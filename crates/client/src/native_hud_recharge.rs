//! Original cooldown/ammo angle math and source HLSL. GPU draw/state bridge pending.
use bevy::prelude::*;
pub fn angle(remaining:f32,total:f32)->Result<Vec4,&'static str> {
 if !remaining.is_finite() || remaining<0.0 || !total.is_finite() || total<=0.0 {return Err("invalid authoritative recharge interval");}
 let value=(remaining/total)*f32::from_bits(0x40c90fdb);
 if !value.is_finite() {return Err("recharge angle overflow");}
 Ok(Vec4::new(value,0.,0.,0.))
}
/// Direct source Cooldown.ps_2_0 math, before framebuffer conversion/blending.
/// Native shader ignores COLOR0 and does not clamp its gradient output.
pub fn shade(uv:Vec2,params:Vec4,color0:Vec4,color1:Vec4)->Result<Vec4,&'static str> {
 if !uv.is_finite() || !params.is_finite() || !color0.is_finite() || !color1.is_finite() {return Err("nonfinite cooldown shader input");}
 let v=uv*2.-Vec2::ONE;if v==Vec2::ZERO {return Err("native normalize zero direction is not qualified");}
 let dir=v.normalize();let a=std::f32::consts::PI+dir.x.atan2(dir.y);
 Ok(if a<params.x {color1}else {Vec4::splat(0.5-(a-params.x))+color0})
}
pub fn player_params(p:&openleague_core::Champion,tick:u64)->Result<[Option<Vec4>;4],&'static str> {
 let mut result=[None;4];
 for slot in 0..4 {let remaining=p.cooldowns[slot].saturating_sub(tick);if remaining==0 {continue;}let total=p.cooldown_totals[slot].ok_or("authoritative total cooldown duration unknown")?;result[slot]=Some(angle(remaining as f32/openleague_core::TICK_RATE as f32,total as f32/openleague_core::TICK_RATE as f32)?);}
 Ok(result)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn server_cast_duration_drives_half_recharge_expiry_and_unknown_is_rejected() {
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=openleague_core::Simulation::new(nav).unwrap();let a=s.join("annie").unwrap();s.learn(a,2).unwrap();s.cast(a,2,None).unwrap();assert_eq!(player_params(&s.players[&a],0).unwrap()[2].unwrap().x,std::f32::consts::TAU);assert_eq!(player_params(&s.players[&a],150).unwrap()[2].unwrap().x,std::f32::consts::PI);assert_eq!(player_params(&s.players[&a],300).unwrap(),[None;4]);let mut p=s.players[&a].clone();p.cooldown_totals[2]=None;assert!(player_params(&p,1).is_err());p.cooldown_totals[2]=Some(0);assert!(player_params(&p,1).is_err());
 }
 #[test] fn all256_original_sse_parameter_updates_match_bit_for_bit() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_recharge_contract.json")).unwrap();assert_eq!(c["case_count"],256);assert_eq!(c["tau_bits"],0x40c90fdbu32);
  for a in c["cases"].as_array().unwrap() {let actual=angle(a["remaining"].as_f64().unwrap() as f32,a["total"].as_f64().unwrap() as f32).unwrap();let want:Vec<u32>=a["params"].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect();assert_eq!(actual.to_array().map(f32::to_bits).as_slice(),want.as_slice());}
  for (r,t) in [(f32::NAN,1.),(1.,0.),(-1.,1.),(1.,f32::INFINITY),(f32::MAX,f32::MIN_POSITIVE)] {assert!(angle(r,t).is_err());}
  assert!(angle(2.,1.).unwrap().x>std::f32::consts::TAU);
 }
 #[test] fn source_effect_parameters_and_colors_are_preserved() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_recharge_contract.json")).unwrap();let effects=c["source_effects"].as_array().unwrap();assert_eq!(effects.len(),4);
  for (slot,e) in effects.iter().enumerate() {assert_eq!(e["name"],format!("SpellCooldownFX{slot}"));let s=e["storage_hex"].as_str().unwrap();let bytes:Vec<u8>=(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect();let mut storage=crate::native_hud_element_storage::ElementStorage::new(2).unwrap();storage.write_bytes(0,&bytes);assert_eq!(storage.flags()&1,0);assert_eq!(storage.word(0x1a4),3);let u=crate::native_hud_effect_uniforms::from_storage(&storage).unwrap();assert_eq!(u.params_bits,[0;4]);assert_eq!(u.colors_rgba[0],[0.;4]);let factor=f32::from_bits(0x3b808081);assert_eq!(u.colors_rgba[1],[0.,0.,128.*factor,180.*factor]);}
 }
 #[test] fn original_hlsl_unclamped_gradient_and_pie_boundary_are_retained() {
  let c0=Vec4::ZERO;let c1=Vec4::new(0.,0.,128./255.,180./255.);let half=angle(5.,10.).unwrap();
  assert_eq!(shade(Vec2::new(0.,0.5),half,c0,c1).unwrap(),c1);
  let right=shade(Vec2::new(1.,0.5),half,c0,c1).unwrap();assert!((right.x-(0.5-std::f32::consts::FRAC_PI_2)).abs()<1e-6);assert!(right.w<0.);
  assert_eq!(shade(Vec2::new(0.5,1.),half,c0,c1).unwrap(),Vec4::splat(0.5));
  assert!(shade(Vec2::splat(0.5),half,c0,c1).is_err());
  let source=include_str!("../../../data/4.20/shaders/UI/Cooldown.ps_2_0");assert!(source.contains("atan2(dir.x, dir.y)"));assert!(source.contains("color = (gradAngle - (angle - params.x))+color0;"));
 }
}

// Constants read from the original 9A0800 pre-draw instructions.
const NATIVE_DIRECTION_CONSTANTS:[f32;8]=[f32::from_bits(0x40490fdb),f32::from_bits(0x40c90fdb),f32::from_bits(0x3fc90fdb),f32::from_bits(0x3f800000),f32::from_bits(0x3bf95d4f),f32::from_bits(0x3e2a0903),f32::from_bits(0x3d17c1be),f32::from_bits(0x3efe4f76)];
pub fn direction(angle:f32)->Result<(f32,Vec4),&'static str> {
 if !angle.is_finite() {return Err("invalid recharge direction angle");}
 let [pi,tau,half_pi,one,s_a,s_b,c_a,c_b]=NATIVE_DIRECTION_CONSTANTS;
 // Original x87 FPREM runs before the wrapped angle is rounded to f32.
 let x=(((angle as f64+pi as f64)%tau as f64)-pi as f64) as f32;
 let ax=x.abs();let y=pi-ax;
 let sin_arg=if ax<=half_pi {ax}else {y};let ss=sin_arg*sin_arg;
 let s=((ss*s_a-s_b)*ss+one)*sin_arg;let s=if x<0. {-s}else {s};
 let cos_arg=if ax<=half_pi {x}else {y};let cc=cos_arg*cos_arg;
 let c=(cc*c_a-c_b)*cc+one;let c=if ax<=half_pi {c}else {-c};
 let scale=one/s.abs().max(c.abs());let result=Vec4::new(-s,-c,scale,0.);
 if !result.is_finite() {return Err("invalid native recharge direction output");}Ok((x,result))
}
#[derive(Clone,Copy,Debug)] pub struct RechargeVertex {pub position:[f32;3],pub color:u32,pub uv:[f32;2]}
pub fn geometry(rect:[f32;4],dimensions:[u32;2],color:u32)->Result<[RechargeVertex;7],&'static str> {
 let [left,top,right,bottom]=rect;
 if dimensions.contains(&0) || rect.iter().any(|v|!v.is_finite()) || right<left || bottom<top {return Err("invalid native recharge geometry input");}
 let half_x=(0.5f64/dimensions[0] as f64) as f32;let half_y=(0.5f64/dimensions[1] as f64) as f32;
 let x=(right+left)*0.5+half_x;let y=(bottom+top)*0.5+half_y;
 let v=|x,y,u,v|RechargeVertex {position:[x,y,0.],color,uv:[u,v]};
 Ok([v(left,top,0.,0.),v(right,top,1.,0.),v(left,bottom,0.,1.),v(right,bottom,1.,1.),v(x,top+half_y,0.,0.),v(x,y,0.,0.),v(x,y,(right-left)*0.5,(bottom-top)*0.5)])
}
pub const RECHARGE_INDICES:[u16;9]=[0,2,1,1,2,3,4,5,6];
pub const RECHARGE_DESCRIPTORS:[[u32;5];2]=[[0,4,0,2,0],[4,3,6,2,3]];
#[cfg(test)] mod geometry_tests {
 use super::*;
 #[test] fn all69_native_direction_and_constant_upload_cases_match_exact_bits() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_recharge_direction_contract.json")).unwrap();assert_eq!(c["native_cases"],69);
  for a in c["cases"].as_array().unwrap() {let(wrapped,d)=direction(a["angle"].as_f64().unwrap() as f32).unwrap();assert_eq!(wrapped.to_bits(),(a["wrapped"].as_f64().unwrap() as f32).to_bits());let values:Vec<u32>=a["events"][0]["values"].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect();assert_eq!(d.to_array().map(f32::to_bits).as_slice(),values.as_slice(),"{}",a["angle"]);}
  assert!(direction(f32::NAN).is_err());
 }
 #[test] fn all36_native_quad_line_vertices_indices_and_descriptors_match_bytes() {
  let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_recharge_geometry_contract.json")).unwrap();assert_eq!(c["native_cases"],36);
  for a in c["cases"].as_array().unwrap() {let rect=std::array::from_fn(|i|a["rect"][i].as_f64().unwrap() as f32);let dimensions=std::array::from_fn(|i|a["dimensions"][i].as_u64().unwrap() as u32);let vertices=geometry(rect,dimensions,a["color"].as_u64().unwrap() as u32).unwrap();let mut bytes=Vec::new();for v in vertices {for f in v.position {bytes.extend(f.to_le_bytes());}bytes.extend(v.color.to_le_bytes());for f in v.uv {bytes.extend(f.to_le_bytes());}}
   let hex:String=bytes.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(hex,a["vertices_hex"].as_str().unwrap());assert_eq!(serde_json::json!(RECHARGE_INDICES),a["indices"]);assert_eq!(serde_json::json!(RECHARGE_DESCRIPTORS),a["descriptors"]);
  }
  assert!(geometry([0.,0.,1.,1.],[0,800],0).is_err());assert!(geometry([1.,0.,0.,1.],[1280,800],0).is_err());
 }
}
