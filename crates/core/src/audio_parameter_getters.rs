//! Native AF1700/AF1660 getters, including static/RTPC prefix and range arithmetic.
//! The caller owns actual RTPC evaluation and the shared CRT random stream.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind {Property8,Property9}
/// Verified Sound FF1CD8 versus HIRC8 Bus FF1380 virtual getter behavior.
#[derive(Debug,Clone,Copy,PartialEq,Eq,Default)] pub enum Class {#[default] Sound,Bus}
impl Kind {pub fn parameter(self)->u32 {match self {Self::Property8=>29,Self::Property9=>30}}}
#[derive(Debug,Clone,Copy)]
pub struct Range {pub min:f32,pub max:f32}
#[derive(Debug,Clone,Copy,Default)]
pub struct Input {pub static_value:Option<f32>,pub rtpc_enabled:bool,pub range:Option<Range>}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidValue,InvalidDraw,Backend(&'static str),Overflow}
/// Native image default1210128 and property9 fallback are both zero.
/// RTPC8 replaces the static value; RTPC9 adds to it. Range width is f32,
/// CRT scaling is the original f64 constant, then rounds before f32 additions.
/// Equal endpoints retain min but consume no draw. No normalization/clamp guessed.
pub fn evaluate(kind:Kind,input:Input,rtpc:impl FnMut(u32)->Result<f32,Error>,draw:impl FnMut()->u16)->Result<f32,Error>{evaluate_for_class(kind,Class::Sound,input,rtpc,draw)}
/// Actual Bus virtual110/114 are base AFF150/AFF0C0, without the Sound wrapper
/// that reads ranges and draws random values. The ignored range is not read.
pub fn evaluate_for_class(kind:Kind,class:Class,mut input:Input,mut rtpc:impl FnMut(u32)->Result<f32,Error>,mut draw:impl FnMut()->u16)->Result<f32,Error> {
 if class==Class::Bus{input.range=None;}
 if input.static_value.into_iter().chain(input.range.into_iter().flat_map(|r|[r.min,r.max])).any(|v|!v.is_finite()){return Err(Error::InvalidValue);}
 let static_value=input.static_value.unwrap_or(0.);
 let mut base=static_value;
 if input.rtpc_enabled {
  let value=rtpc(kind.parameter())?;if !value.is_finite(){return Err(Error::InvalidValue);}
  base=match kind {Kind::Property8=>value,Kind::Property9=>static_value+value};
 }
 if !base.is_finite(){return Err(Error::Overflow);}
 if let Some(range)=input.range {
  let width=range.max-range.min;if !width.is_finite(){return Err(Error::Overflow);}
  let random=if width==0. {0.} else {
   let ticket=draw();if ticket>32767{return Err(Error::InvalidDraw);}
   ((f64::from(ticket)*f64::from_bits(0x3f00002000400080))*f64::from(width)) as f32
  };
  base=(range.min+random)+base;
 }
 if !base.is_finite(){return Err(Error::Overflow);}Ok(base)
}
pub fn evaluate_with_rng(kind:Kind,input:Input,rtpc:impl FnMut(u32)->Result<f32,Error>,rng:&mut crate::audio_random::NativeRandom)->Result<f32,Error> {
 evaluate(kind,input,rtpc,||rng.draw())
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn original_static_rtpc_range_and_call_order_match1440_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_parameter_getters_contract.json")).unwrap();assert_eq!(proof["default_property8"],0.);assert_eq!(proof["default_property9"],0.);
  let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),1440);
  for row in rows {
   let kind=if row["kind"]==8 {Kind::Property8}else{Kind::Property9};
   let input=Input {static_value:row["static"].as_f64().map(|v|v as f32),rtpc_enabled:row["rtpc_enabled"].as_bool().unwrap(),range:row["range"].as_array().map(|v|Range {min:v[0].as_f64().unwrap() as f32,max:v[1].as_f64().unwrap() as f32})};
   let calls=std::cell::RefCell::new(Vec::new());let value=evaluate(kind,input,|parameter|{calls.borrow_mut().push(serde_json::json!({"kind":"rtpc","parameter":parameter,"owner":123}));Ok(row["rtpc"].as_f64().unwrap() as f32)},||{let value=row["draw"].as_u64().unwrap() as u16;calls.borrow_mut().push(serde_json::json!({"kind":"rand","value":value}));value}).unwrap();
   assert_eq!(u64::from(value.to_bits()),row["result_bits"].as_u64().unwrap());assert_eq!(serde_json::json!(calls.into_inner()),row["calls"]);
  }
 }
 #[test] fn audio_original_bus_base_getters_ignore_ranges_in1440_native_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_parameter_getters_contract.json")).unwrap();assert_eq!(proof["default_property8"],0.);assert_eq!(proof["default_property9"],0.);
  let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),1440);
  for row in rows {
   let kind=if row["kind"]==8 {Kind::Property8}else{Kind::Property9};
   let input=Input {static_value:row["static"].as_f64().map(|v|v as f32),rtpc_enabled:row["rtpc_enabled"].as_bool().unwrap(),range:row["range"].as_array().map(|v|Range {min:v[0].as_f64().unwrap() as f32,max:v[1].as_f64().unwrap() as f32})};
   let calls=std::cell::RefCell::new(Vec::new());let value=evaluate_for_class(kind,Class::Bus,input,|parameter|{calls.borrow_mut().push(serde_json::json!({"kind":"rtpc","parameter":parameter,"owner":123}));Ok(row["rtpc"].as_f64().unwrap() as f32)},||{let value=row["draw"].as_u64().unwrap() as u16;calls.borrow_mut().push(serde_json::json!({"kind":"rand","value":value}));value}).unwrap();
   assert_eq!(u64::from(value.to_bits()),row["result_bits"].as_u64().unwrap());assert_eq!(serde_json::json!(calls.into_inner()),row["calls"]);
  }
 }
 #[test] fn equal_ranges_and_missing_rtpc_do_not_consume_unrelated_random_draws() {
  let mut rng=crate::audio_random::NativeRandom::seeded(17);let before=rng.state();
  assert_eq!(evaluate_with_rng(Kind::Property8,Input {range:Some(Range {min:3.,max:3.}),..Default::default()},|_|panic!("disabled RTPC"),&mut rng),Ok(3.));assert_eq!(rng.state(),before);
  assert_eq!(evaluate_with_rng(Kind::Property8,Input {rtpc_enabled:true,range:Some(Range {min:-8.,max:0.}),..Default::default()},|_|Err(Error::Backend("unresolved parameter")),&mut rng),Err(Error::Backend("unresolved parameter")));assert_eq!(rng.state(),before);
  assert_eq!(evaluate(Kind::Property9,Input {range:Some(Range {min:0.,max:1.}),..Default::default()},|_|panic!("disabled"),||65535),Err(Error::InvalidDraw));
 }
}
