//! Authored impact group2. Missing external flex/pose inputs use named local policy.
use openleague_core::{native_scalar_parameter::ScalarParameter,native_vector_parameter::VectorParameter};
pub const POLICY:&str="ezreal_r_magicdust_ground_local_v1";
pub const SOURCE:&str=include_str!("../../../data/4.20/particles/ezreal/r_magicdust_profile.json");
pub const IMAGE:&str="particles/ezreal/r_magicdust/ball01.dds";
pub const COLOR:&str="particles/ezreal/r_magicdust/color-beacontrail.dds";
#[derive(Clone,Debug)]
pub struct Profile {pub rate:ScalarParameter,pub life:ScalarParameter,pub scale:ScalarParameter,
    pub xscale:ScalarParameter,pub rotation:ScalarParameter,pub offset:VectorParameter,pub velocity:VectorParameter,
    pub emitter_life:f32,pub linger:f32,pub drag:f32,pub radius:f32,pub acceleration:[f32;3],
    pub color_scale:[f32;2],pub color_offset:[f32;2]}
fn numeric(v:&serde_json::Value)->Option<Vec<f32>> {v.as_array()?.iter().map(|v|{
    let n=v.as_f64()? as f32;n.is_finite().then_some(n)}).collect()}
impl Profile {
 pub fn load()->Result<Self,&'static str>{Self::parse(SOURCE)}
 fn parse(text:&str)->Result<Self,&'static str>{
    let doc:serde_json::Value=serde_json::from_str(text).map_err(|_|"Magicdust JSON invalid")?;
    let expected:serde_json::Value=serde_json::from_str(r#"{"p-coloroffset":[0.5,0.0],"p-lifeP1":[0.0,0.5],"p-lifeP2":[0.8999999761581421,2.0],"p-lifeP3":[1.0,4.0],"e-rotation1":[1.0],"p-colortype":[1.0,3.0],"p-offsetXP1":[0.0,-1.0],"p-offsetXP2":[1.0,1.0],"p-offsetYP1":[0.0,0.0],"p-offsetYP2":[1.0,100.0],"p-offsetZP1":[0.0,-1.0],"p-offsetZP2":[1.0,1.0],"p-xscale":[1.0],"single-particle":true,"p-scaleXP1":[0.0,0.5],"p-scaleXP2":[1.0,1.0],"p-scale":[3.0],"p-xscale1":[0.0,2.0],"p-xscale2":[0.20000000298023224,1.0],"p-xscale3":[0.800000011920929,1.0],"p-xscale4":[1.0,0.0],"p-life":[1.0],"e-life":[1.0],"p-rgba":"color-beacontrail.tga","p-flexoffset":[0.004999999888241291],"p-linger":[4.0],"e-rate":[50.0],"p-offset":[10.0,1.0,10.0],"e-rotation1P1":[0.0,0.0],"e-rotation1P2":[1.0,360.0],"e-rotation1-axis":[0.0,1.0,0.0],"p-texture":"ball01.dds","p-vel":[0.0,0.0,-3.0],"p-colorscale":[0.5,0.05000000074505806],"p-velZP1":[0.0,50.0],"p-velZP2":[1.0,200.0],"field-drag-1":"SparksDrag","field-accel-1":"Gravity"}"#).unwrap();
    let forces:serde_json::Value=serde_json::from_str(r#"{"SparksDrag*f-drag":[8.0],"SparksDrag*f-radius":[2000.0],"Gravity*f-accel":[0.0,-200.0,0.0]}"#).unwrap();
    if doc["schema"]!="OpenLeague_R_magicdust_authored/v1" || doc["troy_sha256"]!="0ae63338c76b869e906e05e129ff1eff86196d8dd81939a89b25ad4311a7a8cd"
        || doc["slot"]!=2 || doc["group"]!="magicdust" || doc["emitter_class"]!="Simple"
        || doc["fields"]!=expected || doc["forces"]!=forces {return Err("Magicdust authored identity/fields changed");}
    let get=|key:&str|doc["fields"].get(key).and_then(numeric);
    let scalar=|key:&str|ScalarParameter::read_numeric(key,0.,get).map_err(|_|"Magicdust scalar invalid")?.ok_or("Magicdust scalar absent");
    let vector=|key:&str|VectorParameter::read_nonrotation(key,[0.;3],256,get).map_err(|_|"Magicdust vector invalid")?.ok_or("Magicdust vector absent");
    Ok(Self {rate:scalar("e-rate")?,life:scalar("p-life")?,scale:scalar("p-scale")?,xscale:scalar("p-xscale")?,
        rotation:scalar("e-rotation1")?,offset:vector("p-offset")?,velocity:vector("p-vel")?,
        emitter_life:1.,linger:4.,drag:8.,radius:2000.,acceleration:[0.,-200.,0.],color_scale:[0.5,0.05],color_offset:[0.5,0.]})
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn every_authored_field_and_force_matches_original_troy_bytes(){
    let raw=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_TrueShot_tar.troybin");
    assert_eq!(raw.len(),1760);let doc:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
    let fields=doc["wire_fields"].as_array().unwrap();assert_eq!(fields.len(),38);
    let forces=doc["force_wire_fields"].as_array().unwrap();assert_eq!(forces.len(),3);
    for row in fields.iter().chain(forces) {
        let section=row["section"].as_str().unwrap();let name=row["name"].as_str().unwrap();
        let hash=format!("{section}*{name}").to_ascii_lowercase().bytes().fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)));
        let k=row["key_offset"].as_u64().unwrap() as usize;let v=row["value_offset"].as_u64().unwrap() as usize;
        assert_eq!(u32::from_le_bytes(raw[k..k+4].try_into().unwrap()),hash);
        let expected=if section=="magicdust"{&doc["fields"][name]}else{&doc["forces"][format!("{section}*{name}")]};
        let decoded=match row["type_bit"].as_u64().unwrap(){
            1=>vec![f32::from_le_bytes(raw[v..v+4].try_into().unwrap())],
            2=>vec![raw[v] as f32/10.],
            5=>{assert_eq!(expected.as_bool(),Some(((raw[v]>>row["boolean_bit"].as_u64().unwrap())&1)!=0));continue;},
            8=>vec![raw[v] as f32/10.,raw[v+1] as f32/10.],
            9=>(0..2).map(|i|f32::from_le_bytes(raw[v+i*4..v+i*4+4].try_into().unwrap())).collect(),
            12=>{let begin=800+u16::from_le_bytes(raw[v..v+2].try_into().unwrap()) as usize;
                let end=begin+raw[begin..].iter().position(|x|*x==0).unwrap();let text=std::str::from_utf8(&raw[begin..end]).unwrap();
                if let Some(value)=expected.as_str(){assert_eq!(text,value);continue;}
                text.split_whitespace().map(|n|n.parse::<f32>().unwrap()).collect()},
            _=>panic!("unsupported authored wire kind"),
        };assert_eq!(numeric(expected),Some(decoded),"{section}*{name}");
    }
 }
 #[test]
 fn scalar_xp_is_overwritten_by_absent_p_while_life_reaches_four_seconds(){
    let p=Profile::load().unwrap();assert_eq!(p.scale.table,vec![3.]);
    assert!(p.scale.probability.constant);assert_eq!(p.scale.probability.constant_value,1.);
    assert_eq!(p.life.probability.values,vec![0.5,2.,4.]);
    // Native maximum caches authored knots before probability multiplication.
    assert_eq!(p.life.maximum,1.);assert_eq!(p.life.maximum*4.,p.linger);
    assert_eq!(p.offset.table,vec![[10.,1.,10.]]);assert_eq!(p.velocity.table,vec![[0.,0.,-3.]]);
    assert_eq!(p.xscale.table[0],2.);assert!(p.xscale.table[255]<0.025);
 }
 #[test]
 fn missing_force_changed_palette_and_unknown_field_never_fall_back(){
    let original:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
    for n in 0..4 {let mut v=original.clone();match n {
        0=>{v["forces"].as_object_mut().unwrap().remove("Gravity*f-accel");},
        1=>v["fields"]["p-rgba"]=serde_json::json!("color-beacontrail32.tga"),
        2=>v["fields"]["p-quadrot"]=serde_json::json!([0.]),
        _=>v["fields"]["p-life"]=serde_json::json!([2.])};assert!(Profile::parse(&v.to_string()).is_err());}
 }
}
