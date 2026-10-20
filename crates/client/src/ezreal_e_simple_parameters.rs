//! Two authored E Simple groups. Missing descriptor values require an explicit
//! caller binding; none of these inputs reconstructs a native owner or clock.
use openleague_core::{native_scalar_parameter::ScalarParameter,
    native_vector_parameter::VectorParameter,native_simple_particle_update::Attribute};
use crate::ezreal_e_bolt_profile;
use serde_json::Value;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) enum Group { Magicdust, Dust, ReleaseFlash, ArrivalHead }
/// Deliberately has no Default. `provenance` names the caller's native evidence
/// or local binding. An absent value is an error, never a zero descriptor.
pub(crate) struct Missing {
    pub provenance:&'static str,
    pub quad_rotation:Option<ScalarParameter>,
    pub angular_velocity:Option<ScalarParameter>,
    pub size_over_life_base:f32,
    pub size_over_life:Option<ScalarParameter>,
    pub offset:Option<VectorParameter>,
    pub position_offset:VectorParameter,
}
#[derive(Clone)]
pub(crate) struct Parameters {
    pub group:Group,pub provenance:&'static str,
    pub rate:ScalarParameter,pub life:ScalarParameter,pub quad_rotation:ScalarParameter,
    pub scale:ScalarParameter,pub angular_velocity:ScalarParameter,pub xscale:ScalarParameter,
    pub offset:VectorParameter,pub velocity:VectorParameter,pub position_offset:VectorParameter,
    pub authored_emitter_life:f32,pub authored_emitter_linger:f32,pub authored_particle_linger:f32,
    pub emitter_local:bool,pub particle_type:u32,pub simple_orientation:Option<u32>,
    pub bind:[f32;2],pub attributes:[Attribute;2],
}
// Conversion of these finite typed numeric values is separate from CRT/cache
// parity. Booleans follow the archived native numeric getter's 0/1 branch.
fn numbers(v:&Value)->Option<Vec<f32>> {
    let out=if let Some(v)=v.as_bool(){vec![u8::from(v) as f32]}
    else if let Some(v)=v.as_f64(){vec![v as f32]}
    else if let Some(v)=v.as_str(){v.split_whitespace().map(str::parse::<f32>).collect::<Result<Vec<_>,_>>().ok()?}
    else {v.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>()?};
    (!out.is_empty()&&out.iter().all(|v|v.is_finite())).then_some(out)
}
impl Parameters {
    pub(crate) fn load(group:Group,missing:Missing)->Result<Self,&'static str> {
        if missing.provenance.trim().is_empty()||!missing.size_over_life_base.is_finite(){return Err("E Simple unresolved source binding");}
        let inventory=ezreal_e_bolt_profile::inventory()?;
        let row=&inventory.groups[match group{Group::Magicdust=>1,Group::Dust=>2,Group::ReleaseFlash|Group::ArrivalHead=>return Err("release group uses its own checked profile")}];
        let get=|key:&str|row.fields.get(key).and_then(numbers);
        let scalar=|key:&str,base:f32|ScalarParameter::read_numeric(key,base,get).map_err(|_|"E Simple scalar malformed");
        let vector=|key:&str|VectorParameter::read_nonrotation(key,[0.;3],256,get).map_err(|_|"E Simple vector malformed");
        let required=|key:&str|scalar(key,0.)?.ok_or("E Simple authored scalar missing");
        let one=|key:&str|{let values=get(key).ok_or("E Simple authored number missing")?;
            if values.len()!=1{return Err("E Simple authored scalar arity");}Ok(values[0])};
        let pair=|key:&str|get(key).ok_or("E Simple authored pair missing")?.try_into().map_err(|_|"E Simple pair arity");
        let modes:[f32;2]=pair("p-colortype")?;let color_scale:[f32;2]=pair("p-colorscale")?;let color_offset:[f32;2]=pair("p-coloroffset")?;
        if modes.iter().any(|v|!matches!(*v,0.|1.|2.|3.)){return Err("E Simple color mode unsupported");}
        let parameters=Self {group,provenance:missing.provenance,rate:required("e-rate")?,life:required("p-life")?,
            quad_rotation:scalar("p-quadrot",0.)?.or(missing.quad_rotation).ok_or("E Simple p-quadrot unresolved")?,
            scale:required("p-scale")?,angular_velocity:scalar("p-rotvel",0.)?.or(missing.angular_velocity).ok_or("E Simple p-rotvel unresolved")?,
            xscale:scalar("p-xscale",missing.size_over_life_base)?.or(missing.size_over_life).ok_or("E Simple p-xscale unresolved")?,
            offset:vector("p-offset")?.or(missing.offset).ok_or("E Simple p-offset unresolved")?,
            velocity:vector("p-vel")?.ok_or("E Simple p-vel missing")?,position_offset:missing.position_offset,
            authored_emitter_life:one("e-life")?,authored_emitter_linger:one("e-linger")?,authored_particle_linger:one("p-linger")?,
            emitter_local:row.fields.get("e-local-orient").and_then(Value::as_bool).ok_or("E Simple emitter-local missing")?,
            particle_type:match group{Group::Magicdust|Group::ReleaseFlash|Group::ArrivalHead=>0,Group::Dust=>1},
            simple_orientation:match group{Group::Magicdust|Group::ReleaseFlash|Group::ArrivalHead=>None,Group::Dust=>Some(one("p-simpleorient")? as u32)},
            bind:pair("p-bindtoemitter")?,attributes:std::array::from_fn(|i|Attribute {mode:modes[i] as u32,
                multiplier:color_scale[i].to_bits(),offset:color_offset[i].to_bits()})};
        parameters.validate()?;Ok(parameters)
    }
    pub(crate) fn validate(&self)->Result<(),&'static str> {
        if self.provenance.trim().is_empty()||self.attributes.iter().any(|a|a.mode>3
            ||!f32::from_bits(a.multiplier).is_finite()||!f32::from_bits(a.offset).is_finite()) {
            return Err("E Simple binding/color descriptor invalid");
        }
        for p in [&self.rate,&self.life,&self.quad_rotation,&self.scale,&self.angular_velocity,&self.xscale] {validate_scalar(p)?;}
        for p in [&self.offset,&self.velocity,&self.position_offset] {
            if p.table.is_empty()||p.table.len()>4096||p.table.iter().flatten().any(|v|!v.is_finite()){return Err("E Simple vector table invalid");}
            for probability in &p.probabilities{validate_probability(probability)?;}
        }
        if ![self.authored_emitter_life,self.authored_emitter_linger,self.authored_particle_linger].iter().chain(&self.bind).all(|v|v.is_finite())
            ||self.authored_emitter_life<=0. {return Err("E Simple authored duration invalid");}
        // The arrival head profile preserves its authored string-zero linger.
        // Only this typed adapter admits +0; it must supply an explicit live cap
        // in plan(). Existing groups retain the original positive-only contract.
        let valid_linger=match self.group {
            Group::ArrivalHead=>self.authored_particle_linger.to_bits()==0,
            _=>self.authored_particle_linger>0.,
        };
        if !valid_linger{return Err("E Simple authored particle linger invalid");}
        Ok(())
    }
}
pub(crate) fn validate_scalar(p:&ScalarParameter)->Result<(),&'static str>{
    if p.table.is_empty()||p.table.len()>4096||p.table.iter().any(|v|!v.is_finite())||!p.maximum.is_finite(){return Err("E Simple scalar table invalid");}
    validate_probability(&p.probability)
}
fn validate_probability(p:&openleague_core::native_probability_curve::ProbabilityCurve)->Result<(),&'static str>{
    if p.times.len()>4096||p.times.len()!=p.values.len()||!p.times.iter().chain(&p.values).all(|v|v.is_finite())
        ||![p.constant_value,p.begin,p.difference].iter().all(|v|v.is_finite())
        ||(!p.constant&&!p.fast&&p.times.is_empty()){return Err("E Simple probability invalid");}Ok(())
}
