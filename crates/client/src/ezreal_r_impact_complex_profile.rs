//! Exact authored Complex impact groups1/4. Factory and missing external inputs
//! are named local policy, distinct from recovered parameter defaults.
use openleague_core::{native_scalar_parameter::ScalarParameter,native_complex_vectors as vectors,
 native_complex_color as color,native_complex_timing::Timing,native_complex_linger::Linger,
 native_complex_uv_parameters::UvParameters};
use crate::relic_pickup_complex_profiles::{Profile as Parameters,Lookup};
pub const POLICY:&str="ezreal_r_impact_complex_ground_local_v1";
pub const SOURCE:&str=include_str!("../../../data/4.20/particles/ezreal/r_impact_complex_profile.json");
pub const IMAGE:&str="particles/ezreal/r_impact_complex/sliver.dds";
#[derive(Clone,Debug)]
pub struct Rotation {pub scalar:ScalarParameter,pub axis:[u32;3]}
#[derive(Clone,Debug)]
pub struct Profile {pub kind:u32,pub slot:u8,pub parameters:Parameters,pub rotations:Vec<Rotation>,
 pub single:u32,pub ttl:f32}
impl std::ops::Deref for Profile {type Target=Parameters;fn deref(&self)->&Parameters{&self.parameters}}
fn numeric(fields:&serde_json::Value,key:&str)->Option<Vec<f32>> {
 let v=fields.get(key)?;
 if let Some(n)=v.as_f64(){return (n as f32).is_finite().then_some(vec![n as f32]);}
 v.as_array()?.iter().map(|v|{let n=v.as_f64()? as f32;n.is_finite().then_some(n)}).collect()
}
impl Profile {
 pub fn load(index:usize)->Result<Self,&'static str>{Self::parse(index,SOURCE)}
 fn parse(index:usize,text:&str)->Result<Self,&'static str>{
  let expected:serde_json::Value=serde_json::from_str(r#"[{"p-xscale1":[0.0,10.0,1.0,1.0],"p-xscale2":[0.20000000298023224,1.0,0.800000011920929,1.0],"p-xscale3":[1.0,1.0,0.0,0.0],"p-offset":[0.0,0.0,20.0],"p-xrgba1":[0.0,1.0,1.0,1.0,0.0],"p-xrgba2":[0.30000001192092896,1.0,0.800000011920929,0.0,1.0],"p-xrgba3":[0.4000000059604645,1.0,0.20000000298023224,0.0,1.0],"p-xrgba4":[1.0,1.0,0.0,0.0,0.0],"p-flexoffset":[0.004999999888241291],"p-drag":[8.0,8.0,8.0],"e-rotation1P1":[0.0,0.0],"e-rotation1P2":[1.0,-50.0],"e-rotation2P1":[0.0,0.0],"e-rotation2P2":[1.0,360.0],"p-scale":[20.0,20.0,20.0],"p-texture":"sliver.dds","e-rotation1-axis":[1.0,0.0,0.0],"p-velYP1":[0.0,0.5],"p-velYP2":[1.0,1.0],"p-xrgba":[1.0,1.0,1.0,1.0],"e-local-orient":[0.0],"e-rotation2-axis":[0.0,1.0,0.0],"e-rotation1":[1.0],"e-rotation2":[1.0],"p-lifeP1":[0.0,0.20000000298023224],"p-lifeP2":[0.699999988079071,0.4000000059604645],"p-lifeP3":[1.0,1.0],"p-offsetYP1":[0.0,1.0],"p-offsetYP2":[1.0,50.0],"p-accel":[-1800.0,0.0,-4000.0],"p-xscale":[1.0,1.0,1.0],"p-vecalign":true,"p-life":[0.5],"e-life":[0.20000000298023224],"p-bindtoemitter":[1.0,0.0],"e-rate":[500.0],"p-vel":[0.0,0.0,1200.0]},{"p-type":[2.0],"single-particle":true,"p-scaleXP1":[0.0,1.0],"p-scaleXP2":[1.0,2.0],"p-scaleZP1":[0.0,0.0],"p-scaleZP2":[1.0,2.0],"p-linger":false,"p-xscale1":[0.0,2.0,20.0,0.0],"p-xscale2":[0.5,2.0,50.0,30.0],"p-xscale3":[1.0,1.0,20.0,60.0],"p-xrgba1":[0.0,1.0,1.0,1.0,1.0],"p-xrgba2":[0.5,1.0,0.5,0.0,1.0],"p-xrgba3":[1.0,1.0,0.20000000298023224,0.0,0.0],"p-scale":[30.0,1.0,1.0],"p-xrgba":[1.0,1.0,1.0,1.0],"p-life":[0.30000001192092896],"e-life":[1.0],"e-rate":[40.0],"p-quadrot":[0.0,1.0,0.0],"p-quadrotYP1":[0.0,0.0],"p-quadrotYP2":[1.0,360.0],"p-lifeP1":[0.0,0.5],"p-lifeP2":[1.0,1.5],"p-texture":"sliver.dds","p-xscale":[1.0,1.0,1.0]}]"#).unwrap();
  let d:serde_json::Value=serde_json::from_str(text).map_err(|_|"impact Complex document invalid")?;
  let groups=d["groups"].as_array().ok_or("impact Complex groups absent")?;
  if d["schema"]!="OpenLeague_R_impact_complex_authored/v1" || d["troy_sha256"]!="0ae63338c76b869e906e05e129ff1eff86196d8dd81939a89b25ad4311a7a8cd"
   || groups.len()!=2 || index>1 {return Err("impact Complex identity changed");}
  for (i,g) in groups.iter().enumerate(){
   if g["slot"]!=[1,4][i] || g["group"]!=["spinlines","Rays"][i] || g["emitter_class"]!="Complex" || g["fields"]!=expected[i] {
    return Err("impact Complex authored fields changed");}
  }
  let fields=groups[index]["fields"].clone();
  let scalar=|key:&str|ScalarParameter::read_numeric(key,0.,|k|numeric(&fields,k)).map_err(|_|"impact Complex scalar invalid")?.ok_or("impact Complex scalar absent");
  let life=scalar("p-life")?;
  let timing=Timing::from_scalars(None,Some(numeric(&fields,"e-life").ok_or("impact life absent")?[0]),None,None,None);
  //8AE180 bool conversion and913303 numeric getter proved statically: false→+0.
  let linger=Linger::from_scalars(life.maximum,timing.life,if index==1{Some(0.)}else{None},None);
  let mut rotations=Vec::new();
  if index==0 {for n in 1..=2 {
   let axis=numeric(&fields,&format!("e-rotation{n}-axis")).ok_or("impact rotation axis absent")?;
   let axis:[f32;3]=axis.try_into().map_err(|_|"impact axis width")?;
   rotations.push(Rotation {scalar:scalar(&format!("e-rotation{n}"))?,axis:axis.map(f32::to_bits)});
  }}
  // Unauthored atlas frame/rate, bind on Rays and primary lookup are explicit
  // local no-animation/zero-bind/no-color-map inputs, not unknown native defaults.
  let bind=if index==0{scalar("p-bindtoemitter")?}else{
   ScalarParameter::read_numeric("local-bind",0.,|k|(k=="local-bind").then_some(vec![0.])).map_err(|_|"local bind invalid")?.ok_or("local bind missing")?};
  let parameters=Parameters {index,group:["spinlines","Rays"][index],
   vectors:vectors::ComplexVectors::from_group(&fields).map_err(|_|"impact vectors invalid")?,
   birth_color:color::ComplexColor::from_group(&fields).map_err(|_|"impact birth color invalid")?,
   lifetime_color:color::ComplexColor::from_lifetime_group(&fields).map_err(|_|"impact lifetime color invalid")?,
   lifetime_scale:vectors::FieldConfig::from_lifetime_scale_group(&fields).map_err(|_|"impact lifetime scale invalid")?,
   uv:UvParameters::from_group(&fields).map_err(|_|"impact UV invalid")?,
   rate:scalar("e-rate")?,bind,life,timing,linger,start_frame:0,num_frames:1,frame_rate:0.,
   local_emitter_orientation:false,lookup:Lookup {modes:[0;2],scale:[0.;2],offset:[0.;2]},fields};
  Ok(Self {kind:if index==0{0}else{2},slot:[1,4][index],parameters,rotations,single:u32::from(index==1),ttl:if index==0{0.701}else{1.0}})
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test] fn authored_shapes_probabilities_and_bool_linger_are_distinct(){
  let spin=Profile::load(0).unwrap();let rays=Profile::load(1).unwrap();
  assert_eq!((spin.kind,spin.slot,spin.rotations.len(),spin.single),(0,1,2,0));
  assert_eq!((rays.kind,rays.slot,rays.rotations.len(),rays.single),(2,4,0,1));
  assert_eq!(rays.linger.particle.to_bits(),0);assert_eq!(rays.rate.table,vec![40.]);
  assert_eq!(spin.rate.table,vec![500.]);assert_eq!(spin.vectors.field(vectors::Field::Drag).table,vec![[8.;3]]);
  assert_eq!(spin.vectors.field(vectors::Field::Offset).table,vec![[0.,0.,20.]]);
  assert!(!rays.vectors.field(vectors::Field::Velocity).authored);
  assert_eq!(rays.vectors.field(vectors::Field::QuadRotation).table,vec![[0.,1.,0.]]);
 }
 #[test] fn missing_extra_or_mutated_fields_disable_profile(){
  let original:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
  for n in 0..4 {let mut d=original.clone();match n {
   0=>{d["groups"][0]["fields"].as_object_mut().unwrap().remove("p-vecalign");},
   1=>d["groups"][1]["fields"]["p-linger"]=serde_json::json!(0.),
   2=>d["groups"][0]["fields"]["p-type"]=serde_json::json!([1.]),
   _=>d["groups"][1]["fields"]["p-life"]=serde_json::json!([2.])}
   assert!(Profile::parse(0,&d.to_string()).is_err());assert!(Profile::parse(1,&d.to_string()).is_err());
  }
 }
 #[test] fn all_sixty_two_fields_match_original_troy_bytes(){
  let raw=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_TrueShot_tar.troybin");
  let d:serde_json::Value=serde_json::from_str(SOURCE).unwrap();let mut count=0;
  for g in d["groups"].as_array().unwrap(){for r in g["wire_fields"].as_array().unwrap(){
   let section=r["section"].as_str().unwrap();let name=r["name"].as_str().unwrap();
   let hash=format!("{section}*{name}").to_ascii_lowercase().bytes().fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)));
   let k=r["key_offset"].as_u64().unwrap() as usize;let v=r["value_offset"].as_u64().unwrap() as usize;
   assert_eq!(u32::from_le_bytes(raw[k..k+4].try_into().unwrap()),hash);let want=&g["fields"][name];count+=1;
   let got=match r["type_bit"].as_u64().unwrap(){
    1=>vec![f32::from_le_bytes(raw[v..v+4].try_into().unwrap())],2=>vec![raw[v] as f32/10.],4=>vec![raw[v] as f32],
    5=>{assert_eq!(want.as_bool(),Some(raw[v]>>r["boolean_bit"].as_u64().unwrap()&1!=0));continue;},
    n @ (6|8|10)=>{let width=match n{6=>3,8=>2,_=>4};raw[v..v+width].iter().map(|x|*x as f32/10.).collect()},
    9=>(0..2).map(|i|f32::from_le_bytes(raw[v+4*i..v+4*i+4].try_into().unwrap())).collect(),
    12=>{let begin=800+u16::from_le_bytes(raw[v..v+2].try_into().unwrap()) as usize;
     let end=begin+raw[begin..].iter().position(|b|*b==0).unwrap();let text=std::str::from_utf8(&raw[begin..end]).unwrap();
     if let Some(s)=want.as_str(){assert_eq!(s,text);continue;}
     text.split_whitespace().map(|v|v.parse::<f32>().unwrap()).collect()},_=>panic!("unexpected wire kind")};
   assert_eq!(numeric(&g["fields"],name),Some(got),"{section}*{name}");
  }}assert_eq!(count,62);
 }
}
