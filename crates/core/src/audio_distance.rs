//! Native closest scaled audio distance AF3700 and x87 Euclidean helper B05310.
#[derive(Clone,Copy,Debug,serde::Deserialize)]
pub struct Listener {pub position:[f32;3],pub distance_scale:f32}
#[derive(Clone,Copy,Debug)]
pub struct Sources<'a> {pub positions:&'a [[f32;3]],pub mode_raw:u8}
#[derive(Clone,Copy,Debug,PartialEq)]
pub enum Error {InvalidPosition,InvalidScale,TooManyPositions,Overflow}
/// Native finite starting minimum, also returned when listener mask is zero.
pub const DISTANCE_SENTINEL:f32=10000000000.;
/// Original fallback components at 121026C; descriptor coordinate mapping is
/// separate from the metric and must be qualified before live mixer integration.
pub const DEFAULT_POSITION:[f32;3]=[0.,0.,1.];
fn separation(a:[f32;3],b:[f32;3])->Result<f32,Error> {
 if a.iter().chain(b.iter()).any(|v|!v.is_finite()) {return Err(Error::InvalidPosition);}
 // x87 keeps differences/products extended until the caller stores distance as
 // f32. f64 preserves qualified input results; extreme coordinates unqualified.
 let x=a[0] as f64-b[0] as f64;let y=a[1] as f64-b[1] as f64;let z=a[2] as f64-b[2] as f64;
 let d=((x*x+y*y)+z*z).sqrt() as f32;
 if !d.is_finite() {return Err(Error::Overflow);}Ok(d)
}
/// Iterate only selected listener bits and native source count implied by mode.
/// Raw modes whose low three bits are zero use only the first source position.
/// Empty source storage selects the native fallback once for either mode path.
pub fn nearest(sources:Sources<'_>,listeners:&[Listener;8],listener_mask:u8)->Result<f32,Error> {
 if sources.positions.len()>u16::MAX as usize {return Err(Error::TooManyPositions);}
 let fallback=[DEFAULT_POSITION];
 let positions=if sources.positions.is_empty() {&fallback[..]} else if sources.mode_raw&7==0 {&sources.positions[..1]} else {sources.positions};
 let mut distance=DISTANCE_SENTINEL;
 for (i,listener) in listeners.iter().enumerate() {
  if listener_mask&(1<<i)==0 {continue;}
  if !listener.distance_scale.is_finite() || listener.distance_scale<=0. {return Err(Error::InvalidScale);}
  for &position in positions {
   let scaled=separation(listener.position,position)?/listener.distance_scale;
   if !scaled.is_finite() {return Err(Error::Overflow);}
   if scaled<=distance {distance=scaled;}
  }
 }
 Ok(distance)
}
#[cfg(test)]mod tests {
 use super::*;
 #[test]fn native_masks_modes_scaled_distances_and_fallback_match_exactly() {
  #[derive(serde::Deserialize)]struct Case {listener_mask:u8,mode_raw:u8,positions:Vec<[f32;3]>,listeners:[Listener;8],native_distance:f32}
  #[derive(serde::Deserialize)]struct Contract {cases:Vec<Case>}
  let c:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_distance_contract.json")).unwrap();assert_eq!(c.cases.len(),361);
  for (i,c) in c.cases.into_iter().enumerate() {
   let actual=nearest(Sources {positions:&c.positions,mode_raw:c.mode_raw},&c.listeners,c.listener_mask).unwrap();
   assert_eq!(actual.to_bits(),c.native_distance.to_bits(),"distance case{i} mask{} mode{}",c.listener_mask,c.mode_raw);
  }
 }
 #[test]fn selected_invalid_geometry_fails_and_unused_listeners_are_not_read() {
  let mut listeners=[Listener {position:[0.;3],distance_scale:1.};8];let positions=[[3.,4.,0.]];let sources=Sources {positions:&positions,mode_raw:1};
  listeners[7].position=[f32::NAN;3];listeners[7].distance_scale=0.;
  assert_eq!(nearest(sources,&listeners,0).unwrap(),DISTANCE_SENTINEL);assert_eq!(nearest(sources,&listeners,1).unwrap(),5.);
  assert_eq!(nearest(sources,&listeners,128),Err(Error::InvalidScale));listeners[7].distance_scale=1.;assert_eq!(nearest(sources,&listeners,128),Err(Error::InvalidPosition));
  listeners[0].distance_scale=f32::NAN;assert_eq!(nearest(sources,&listeners,1),Err(Error::InvalidScale));
 }
}
