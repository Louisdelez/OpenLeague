//! The two declared arrival heads, with original bytes checked before sampling.
//! Instance attachment, start and visibility remain the named local release policy.
use openleague_core::{native_scalar_parameter::ScalarParameter,
    native_vector_parameter::VectorParameter,native_simple_particle_update::Attribute};
use serde_json::Value;
use crate::ezreal_e_simple_parameters::{Group,Parameters};

pub(crate) const POLICY:&str="map10_e_committed_arrival_heads_ground_local_v1";
const BINDING:[&str;2]=["map10_e_arrival_head1_ground_local_v1","map10_e_arrival_head2_ground_local_v1"];
pub(crate) const IMAGE:&str="particles/ezreal/e_release_flashes/flare-sun.dds";
pub(crate) const COLOR:&str="particles/ezreal/e_release_flashes/color-hold.dds";
pub(crate) const SOURCE:&str=include_str!("../../../data/4.20/ezreal_e_arrival_heads.json");
pub(crate) const RAW:&[u8]=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_arcaneshift_flash.troybin");
pub(crate) struct Profile {
    pub parameters:[Parameters;2],pub rotations:[ScalarParameter;2],
    pub axis:[u32;3],pub end:f64,
}
fn numbers(v:&Value)->Option<Vec<f32>> {
    let values=if let Some(v)=v.as_bool(){vec![u8::from(v) as f32]}
        else if let Some(v)=v.as_f64(){vec![v as f32]}
        else if let Some(v)=v.as_str(){v.split_whitespace().map(str::parse::<f32>).collect::<Result<Vec<_>,_>>().ok()?}
        else{v.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>()?};
    (!values.is_empty()&&values.iter().all(|v|v.is_finite())).then_some(values)
}
fn zero_vector()->VectorParameter {
    VectorParameter{table:vec![[0.;3]],probabilities:std::array::from_fn(|_|
        openleague_core::native_probability_curve::ProbabilityCurve::read_numeric("P",|_|None).expect("empty P descriptor"))}
}
impl Profile {
    pub(crate) fn load()->Result<Self,&'static str>{Self::parse(SOURCE,RAW)}
    fn parse(source:&str,raw:&[u8])->Result<Self,&'static str>{
        if source.len()>65536{return Err("E head profile budget");}
        let doc:Value=serde_json::from_str(source).map_err(|_|"E head profile JSON")?;
        if doc["schema"]!="OpenLeague_E_arrival_heads/v1"{return Err("E head profile schema");}
        let rows=doc["rows"].as_array().filter(|v|v.len()==2).ok_or("E head profile groups")?;
        let mut parameters=Vec::new();let mut rotations=Vec::new();let mut end=0f64;
        for (index,name) in ["head1","head2"].into_iter().enumerate(){
            if rows[index]["group"]!=name{return Err("E head authored group order");}
            let fields=crate::ezreal_e_release_profile::checked_arrival_head_fields(raw,name,
                rows[index]["fields"].as_array().ok_or("E head fields")?)?;
            let get=|key:&str|fields.get(key).and_then(numbers);
            let required=|key:&str,base:f32|ScalarParameter::read_numeric(key,base,get)
                .map_err(|_|"E head scalar malformed")?.ok_or("E head scalar absent");
            let vector=|key:&str|VectorParameter::read_nonrotation(key,[0.;3],256,get)
                .map_err(|_|"E head vector malformed")?.ok_or("E head vector absent");
            let one=|key:&str|{let v=get(key).ok_or("E head number absent")?;
                if v.len()!=1{return Err("E head number arity");}Ok(v[0])};
            let pair=|key:&str|get(key).ok_or("E head pair absent")?.try_into().map_err(|_|"E head pair arity");
            let modes:[f32;2]=pair("p-colortype")?;let scales:[f32;2]=pair("p-colorscale")?;
            let offsets:[f32;2]=pair("p-coloroffset")?;
            if modes!=[1.,3.]||fields["p-texture"]!="flare-sun.tga"||fields["p-rgba"]!="color-hold.tga"
                ||fields["p-type"]!="0"||fields["e-local-orient"]!=true||fields["p-linger"]!="0"
                ||pair("p-texdiv")?!=[1f32,1.] {return Err("E head renderer route changed");}
            // Preserve absence. The closed Simple reader supplies C4/108/A8 zero
            // and xscale base1. These are constructor resolutions, not new keys.
            for absent in ["p-quadrot","p-rotvel","p-postoffset","e-rotation1-axis","flag-disable-z","rendermode"] {
                if fields.contains_key(absent){return Err("E head absent input changed");}
            }
            let p=Parameters{group:Group::ArrivalHead,provenance:BINDING[index],
                rate:required("e-rate",0.)?,life:required("p-life",0.)?,scale:required("p-scale",1.)?,
                quad_rotation:crate::ezreal_e_bolt_local::scalar(0.),angular_velocity:crate::ezreal_e_bolt_local::scalar(0.),
                xscale:required("p-xscale",1.)?,offset:vector("p-offset")?,velocity:vector("p-vel")?,position_offset:zero_vector(),
                authored_emitter_life:one("e-life")?,authored_emitter_linger:one("e-linger")?,authored_particle_linger:one("p-linger")?,
                emitter_local:true,particle_type:0,simple_orientation:None,bind:pair("p-bindtoemitter")?,
                attributes:std::array::from_fn(|i|Attribute{mode:modes[i] as u32,multiplier:scales[i].to_bits(),offset:offsets[i].to_bits()})};
            p.validate()?;
            let rotation=required("e-rotation1",0.)?;
            // maximum caches knots BEFORE P. The observed positive probability
            // curve has a maximum4, so a late .2*4 particle can outlive1.7s.
            let probability=p.life.probability.values.iter().copied().fold(p.life.probability.constant_value,f32::max);
            let max_life=p.life.maximum*probability;
            if !max_life.is_finite()||max_life<=0.{return Err("E head lifetime bound");}
            end=end.max(f64::from(p.authored_emitter_life)+f64::from(max_life));
            parameters.push(p);rotations.push(rotation);
        }
        //91E99A/9A9/9B1 defaults the missing axis to unitY before8B22A0 and
        // normalization. This policy selects the archived resource, no overlay.
        Ok(Self{parameters:parameters.try_into().map_err(|_|"E head parameters")?,
            rotations:rotations.try_into().map_err(|_|"E head rotations")?,axis:[0f32,1.,0.].map(f32::to_bits),end})
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn head_pair_checks_original_fields_and_rejects_resource_or_metadata_tampering(){
        let p=Profile::load().unwrap();assert_eq!(p.parameters[0].authored_particle_linger.to_bits(),0);
        let mut raw=RAW.to_vec();raw[94]^=1;assert!(Profile::parse(SOURCE,&raw).is_err());
        let mut doc:Value=serde_json::from_str(SOURCE).unwrap();doc["rows"][0]["fields"][0]["value"]=serde_json::json!(9.);
        assert!(Profile::parse(&doc.to_string(),RAW).is_err());
        let mut doc:Value=serde_json::from_str(SOURCE).unwrap();doc["rows"][0]["group"]=serde_json::json!("flashes");
        assert!(Profile::parse(&doc.to_string(),RAW).is_err());
    }
    #[test]
    fn same_sense_authored_rotations_keep_half_turn_offset_and_probability_inclusive_bound(){
        let p=Profile::load().unwrap();assert_eq!(p.axis,[0f32,1.,0.].map(f32::to_bits));
        assert_eq!(p.rotations[0].table.len(),p.rotations[1].table.len());
        assert!(p.rotations[0].table.windows(2).all(|w|w[1]<w[0]));
        assert!(p.rotations[1].table.windows(2).all(|w|w[1]<w[0]));
        for (a,b) in p.rotations[0].table.iter().zip(&p.rotations[1].table){assert_eq!(*b-*a,180.);}
        assert_eq!(p.parameters[0].life.maximum,0.2);assert!(p.end>2.3&&p.end<2.300001);
        assert_eq!(p.parameters[0].life.probability.values,[1.,2.,4.]);
    }
}
