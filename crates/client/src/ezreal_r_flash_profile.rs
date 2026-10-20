//! Seventeen exact original group3 fields; absent inputs are local policies.
use openleague_core::{native_scalar_parameter::ScalarParameter,native_random::Rng55,
    native_simple_birth_parameters as birth};
pub(crate) const POLICY:&str="ezreal_r_accepted_flash_ground_local_v1";
pub(crate) const SOURCE:&str=include_str!("../../../data/4.20/particles/ezreal/r_flash_profile.json");
pub(crate) const IMAGE:&str="particles/ezreal/r_flash/flare-sun.dds";
pub(crate) const COLOR:&str="particles/ezreal/r_flash/color-hit-physical.dds";
#[derive(Clone,Debug)]
pub(crate) struct Profile {life:ScalarParameter,scale:ScalarParameter,angle:ScalarParameter,xscale:ScalarParameter}
fn numeric(v:&serde_json::Value)->Option<Vec<f32>> {
    v.as_array()?.iter().map(|n|n.as_f64().map(|v|v as f32).filter(|v|v.is_finite())).collect()
}
impl Profile {
    pub(crate) fn load()->Result<Self,&'static str>{Self::parse(SOURCE)}
    fn parse(text:&str)->Result<Self,&'static str>{
        let doc:serde_json::Value=serde_json::from_str(text).map_err(|_|"flash profile JSON invalid")?;
        let fields=doc["fields"].as_object().ok_or("flash fields absent")?;
        if doc["schema"]!="OpenLeague_R_flash_authored/v1" || doc["slot"]!=3 || doc["group"]!="flash"
            || doc["class_name"]!="Simple" || doc["troy_sha256"]!="0ae63338c76b869e906e05e129ff1eff86196d8dd81939a89b25ad4311a7a8cd"
            || fields.len()!=17 {return Err("flash original identity changed");}
        let get=|key:&str|fields.get(key).and_then(numeric);
        for (key,values) in [("p-life",vec![0.3]),("e-life",vec![1.]),("e-rate",vec![1.]),
            ("p-scale",vec![150.]),("p-xscale",vec![1.]),("p-xscale1",vec![0.,1.]),("p-xscale2",vec![1.,0.]),
            ("p-quadrot",vec![1.]),("p-quadrotXP1",vec![0.,0.]),("p-quadrotXP2",vec![1.,360.]),
            ("p-flexscale",vec![0.005]),("p-flexoffset",vec![0.005]),("p-bindtoemitter",vec![1.,1.])] {
            if get(key)!=Some(values){return Err("flash numeric field changed");}
        }
        for key in ["flag-disable-z","single-particle"] {if fields.get(key).and_then(|v|v.as_bool())!=Some(true){return Err("flash boolean field changed");}}
        for (key,value) in [("p-texture","flare-sun.dds"),("p-rgba","color-hit-physical.tga")] {
            if fields.get(key).and_then(|v|v.as_str())!=Some(value){return Err("flash texture field changed");}
        }
        let parameter=|key|ScalarParameter::read_numeric(key,0.,get).map_err(|_|"flash scalar rejected")?.ok_or("flash scalar absent");
        let p=Self {life:parameter("p-life")?,scale:parameter("p-scale")?,angle:parameter("p-quadrot")?,xscale:parameter("p-xscale")?};
        for c in [&p.life,&p.scale,&p.angle,&p.xscale] {
            if !c.probability.constant || c.probability.constant_value!=1. {return Err("flash nonconstant probability outside audited scope");}
        } Ok(p)
    }
    pub(crate) fn birth(&self)->Result<(f32,f32,f32),&'static str> {
        // Local one-particle event phase0. XP is read then overwritten by absent P.
        // Constant probabilities consume no random draw; the seed is irrelevant.
        let values=birth::sample_base(&self.life.table,&self.angle.table,&self.scale.table,&[0.],0.)?;
        let mut rng=Rng55::seeded(0);
        let life=f32::from_bits(birth::probability(values.life,Some(&self.life.probability),&mut rng));
        let scale=f32::from_bits(birth::probability(values.factor,Some(&self.scale.probability),&mut rng));
        let angle=f32::from_bits(birth::probability(values.scalar,Some(&self.angle.probability),&mut rng));
        if (life,scale,angle)!=(0.3,150.,1.) {return Err("flash birth outside audited values");} Ok((life,scale,angle))
    }
    pub(crate) fn scale_at(&self,factor:f32,age:f32)->Result<f32,&'static str>{
        if !factor.is_finite() || !age.is_finite() || !(0.0..1.0).contains(&age){return Err("flash lifetime input invalid");}
        let value=self.xscale.sample_age(age,&mut Rng55::seeded(0)).map_err(|_|"flash xscale rejected")?*factor;
        if !value.is_finite() || value<0. {return Err("flash scale invalid");} Ok(value)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn all17_original_fields_are_read_from_their_actual_troy_bytes(){
        let raw=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_TrueShot_tar.troybin");assert_eq!(raw.len(),1760);
        let doc:serde_json::Value=serde_json::from_str(SOURCE).unwrap();let rows=doc["wire"].as_array().unwrap();assert_eq!(rows.len(),17);
        for r in rows {
            let name=r["name"].as_str().unwrap();let key=r["key_offset"].as_u64().unwrap() as usize;let v=r["value_offset"].as_u64().unwrap() as usize;
            let hash=format!("flash*{name}").to_ascii_lowercase().bytes().fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)));
            assert_eq!(u32::from_le_bytes(raw[key..key+4].try_into().unwrap()),hash);
            let values=match r["type_bit"].as_u64().unwrap(){
                1=>vec![f32::from_le_bytes(raw[v..v+4].try_into().unwrap())],2=>vec![raw[v] as f32/10.],
                8=>vec![raw[v] as f32/10.,raw[v+1] as f32/10.],
                5=>{assert_eq!(doc["fields"][name].as_bool(),Some(raw[v]&(1<<r["boolean_bit"].as_u64().unwrap())!=0));continue;},
                12=>{let start=800+u16::from_le_bytes(raw[v..v+2].try_into().unwrap()) as usize;let end=start+raw[start..].iter().position(|b|*b==0).unwrap();
                    let text=std::str::from_utf8(&raw[start..end]).unwrap();if let Some(expected)=doc["fields"][name].as_str(){assert_eq!(text,expected);continue;}
                    text.split_whitespace().map(|n|n.parse::<f32>().unwrap()).collect()},
                _=>panic!("unexpected field kind")};
            assert_eq!(numeric(&doc["fields"][name]),Some(values),"{name}");
        } Profile::load().unwrap();
    }
    #[test]
    fn xp_does_not_randomize_degree_and_scale150_is_applied_once(){
        let p=Profile::load().unwrap();assert_eq!(p.birth().unwrap(),(0.3,150.,1.));
        assert_eq!(p.scale_at(150.,0.).unwrap(),150.);assert_eq!(p.scale_at(150.,0.5).unwrap(),75.);
        let mut rng=Rng55::seeded(55);let before=rng.clone();assert_eq!(p.angle.sample_age(0.,&mut rng).unwrap(),1.);
        assert_eq!((rng.words,rng.first,rng.second),(before.words,before.first,before.second));
        assert_eq!(openleague_core::native_simple_type0_quad::angle_index(1.),1);
        for age in [f32::NAN,-1.,1.] {assert!(p.scale_at(150.,age).is_err());}
    }
    #[test]
    fn missing_unknown_or_corrupt_authored_input_fails_explicitly(){
        let original:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
        for case in 0..4 {let mut changed=original.clone();match case {
            0=>{changed["fields"].as_object_mut().unwrap().remove("p-flexscale");},
            1=>changed["fields"]["p-quadrotP1"]=serde_json::json!([0.,9.]),
            2=>changed["fields"]["flag-disable-z"]=serde_json::json!(false),
            _=>changed["fields"]["p-life"]=serde_json::json!([1.])};assert!(Profile::parse(&changed.to_string()).is_err());}
    }
}
