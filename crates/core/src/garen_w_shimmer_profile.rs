//! Original shimmer_base values, applied to an explicit local cast-age adapter.
//! This is not the six-effect native caller, scheduler, birth/update loop or Fade.
use std::sync::OnceLock;

#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Profile {
    pub particle_life:f32,
    pub emitter_life:f32,
    pub emission_rate:f32,
    pub scale:f32,
    pub slice_width:f32,
    pub color_modes:[u32;2],
    pub color_scale:[f32;2],
    pub color_offset:[f32;2],
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Sample {
    pub normalized_age:f32,
    pub scale:f32,
    pub lookup:[f32;2],
    pub slice_range:[f32;2],
}
fn parse()->Result<Profile,&'static str> {
    let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/garen_w_shimmer_profile.json"))
        .map_err(|_|"invalid Garen shimmer authored contract")?;
    let fields=&data["fields"];
    let value=|name:&str| &fields[name]["value"];
    let number=|name:&str| value(name).as_f64().map(|v|v as f32).ok_or("missing shimmer numeric field");
    let string=|name:&str| value(name).as_str().ok_or("missing shimmer string field");
    let scalar=|name:&str|->Result<f32,&'static str>{string(name)?.parse().map_err(|_|"invalid shimmer scalar string")};
    let pair=|name:&str|->Result<[f32;2],&'static str>{
        let a=value(name).as_array().ok_or("missing shimmer pair")?;
        if a.len()!=2{return Err("invalid shimmer pair length")}
        Ok([a[0].as_f64().ok_or("invalid shimmer pair value")? as f32,a[1].as_f64().ok_or("invalid shimmer pair value")? as f32])
    };
    if data["source"]["sha256"]!="a254f7ca5861db1a6c0936a1eae4b6755f468d37c81261eb6b2c51754ddaeabf"
        ||data["section"]!="shimmer_base"||number("p-type")?!=11.||number("rendermode")?!=4.
        ||number("p-simpleorient")?!=3.||number("p-local-orient")?!=1.
        ||string("single-particle")?!="0"||string("KeywordsRequired")?!="Garen"
        ||string("p-texture")?!="Garen_Base_W_Scroll.dds"||string("p-rgba")?!="alpha_20.tga" {
        return Err("unsupported Garen shimmer authored identity")
    }
    let scales=string("p-colorscale")?.split_whitespace().map(str::parse::<f32>).collect::<Result<Vec<_>,_>>()
        .map_err(|_|"invalid shimmer color scale string")?;
    let modes=pair("p-colortype")?;
    if scales.len()!=2||modes!=[1.,0.] {return Err("unsupported shimmer color policy")}
    let profile=Profile {particle_life:number("p-life")?,emitter_life:scalar("e-life")?,
        emission_rate:number("e-rate")?,scale:number("p-scale")?,slice_width:scalar("p-alphaslicerange")?,
        color_modes:[1,0],color_scale:[scales[0],scales[1]],color_offset:pair("p-coloroffset")?};
    // This narrow consumer must not silently accept another skin or a changed resource.
    if profile!= (Profile {particle_life:1.25,emitter_life:0.2,emission_rate:2.,scale:f32::from_bits(0x3f83d70a),
        slice_width:0.04,color_modes:[1,0],color_scale:[0.5,0.08],color_offset:[0.5,1.]}) {
        return Err("Garen shimmer authored values changed")
    }
    Ok(profile)
}
pub fn authored()->Result<&'static Profile,&'static str> {
    static PROFILE:OnceLock<Result<Profile,&'static str>>=OnceLock::new();
    PROFILE.get_or_init(parse).as_ref().map_err(|error|*error)
}
impl Profile {
    /// `age` is monotonic elapsed time since the existing committed W identity.
    /// The caller chooses this activation boundary explicitly. In particular, a
    /// delayed first sight resumes the aged pulse; it never creates a fresh birth.
    /// e-life closes emissions, not this already-born particle's p-life.
    pub fn at_cast_age(&self,age:f32)->Result<Option<Sample>,&'static str> {
        if !age.is_finite()||age<0. {return Err("invalid Garen shimmer cast age")}
        if age>=self.particle_life {return Ok(None)}
        let normalized_age=age/self.particle_life;
        let mut lookup=[0.;2];
        for (i,value) in lookup.iter_mut().enumerate() {
            let mut output=[0];
            crate::native_simple_attribute_policy::update(self.color_modes[i],self.color_scale[i].to_bits(),
                self.color_offset[i].to_bits(),&[normalized_age.to_bits()],&[],&[],&mut output)?;
            *value=f32::from_bits(output[0]);
        }
        Ok(Some(Sample {normalized_age,scale:self.scale,lookup,
            slice_range:[self.slice_width,1./(self.slice_width*self.slice_width)]}))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn authored_particle_lifetime_is_distinct_from_emitter_shutdown() {
        let p=authored().unwrap();
        assert_eq!(p.particle_life,1.25);assert_eq!(p.emitter_life,0.2);
        let middle=p.at_cast_age(0.625).unwrap().unwrap();
        assert_eq!(middle.lookup,[0.75,0.08]);assert_eq!(middle.normalized_age,0.5);
        assert!(p.at_cast_age(0.2).unwrap().is_some());
        assert!(p.at_cast_age(f32::from_bits(1.25f32.to_bits()-1)).unwrap().is_some());
        assert_eq!(p.at_cast_age(1.25).unwrap(),None);
        assert_eq!(p.at_cast_age(2.).unwrap(),None);
    }
    #[test]
    fn delayed_visibility_keeps_authored_age_and_constant_lookup_v() {
        let p=authored().unwrap();
        assert_eq!(p.at_cast_age(0.).unwrap().unwrap().lookup,[0.5,0.08]);
        let a=p.at_cast_age(1.).unwrap().unwrap();
        assert_eq!(a.lookup,[0.9,0.08]);
        assert_eq!(p.at_cast_age(1.).unwrap(),Some(a));
        assert_ne!(a.lookup[1],1.08); // mode zero ignores the authored offset.
        assert_eq!(a.slice_range[0].to_bits(),0.04f32.to_bits());
        assert!((a.slice_range[1]-625.).abs()<0.0001);
        for age in [-1.,f32::NAN,f32::INFINITY] {assert!(p.at_cast_age(age).is_err())}
    }
    #[test]
    fn native_emission_gate_permits_the_initial_birth_only_for_this_window() {
        use crate::native_simple_emission_count::{evaluate,Input};
        let p=authored().unwrap();
        let input=Input {time:0.,start:0.,previous:0.,life:p.emitter_life,delay:0.,
            period:f32::MAX,window:f32::MAX,rate:p.emission_rate,single:0,emitted:0};
        assert_eq!(evaluate(input).unwrap(),1);
        assert_eq!(evaluate(Input {time:0.1,previous:0.,emitted:1,..input}).unwrap(),0);
        assert_eq!(evaluate(Input {time:0.2,previous:0.1,emitted:1,..input}).unwrap(),0);
        // This does not assert a native actor caller or its emission cadence.
    }
}
