//! Scratch source profile for the three native Complex heal groups.
//! This file reads authored numeric sources, never native expected tables.
use openleague_core::{native_complex_vectors as vectors,native_complex_color as color,
    native_complex_timing::Timing,native_complex_linger::Linger,
    native_complex_uv_parameters::UvParameters,native_scalar_parameter::ScalarParameter};
use serde_json::Value;
pub const GROUPS:[&str;3]=["bolts_1","bolts_2","littleray"];
pub const SOURCE_ORDER:[&str;7]=["starTrailspin","mesh","bolts_1","bolts_2","littleray","starswirl","shafts"];
#[derive(Debug,Clone,Copy)]
pub struct Lookup {pub modes:[u32;2],pub scale:[f32;2],pub offset:[f32;2]}
#[derive(Debug,Clone)]
pub struct Profile {
    pub index:usize,pub group:&'static str,pub fields:Value,pub vectors:vectors::ComplexVectors,
    pub birth_color:color::ComplexColor,pub lifetime_color:color::ComplexColor,
    pub lifetime_scale:vectors::FieldConfig,pub timing:Timing,pub linger:Linger,
    pub life:ScalarParameter,pub rate:ScalarParameter,pub bind:ScalarParameter,
    pub uv:UvParameters,pub start_frame:i32,pub num_frames:i32,pub frame_rate:f32,
    pub local_emitter_orientation:bool,
    pub lookup:Lookup,
}
pub fn numeric(fields:&Value,key:&str)->Option<Vec<f32>> {
    let value=fields.as_object()?.iter().find(|(k,_)|k.eq_ignore_ascii_case(key))?.1;
    if let Some(v)=value.as_f64(){return Some(vec![v as f32]);}
    value.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect()
}
fn scalar(fields:&Value,key:&str,default:f32)->Result<ScalarParameter,&'static str> {
    // All three selected profiles author these scalar fields. Missing is an error.
    ScalarParameter::read_numeric(key,default,|k|numeric(fields,k))
        .map_err(|_|"invalid selected Complex scalar")?.ok_or("missing selected Complex scalar")
}
impl Profile {
    pub fn load(index:usize)->Result<Self,&'static str> {
        Self::from_document(index,&serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/complex_source_parameters.json"))
            .map_err(|_|"invalid authored heal source")?)
    }
    pub fn from_document(index:usize,document:&Value)->Result<Self,&'static str> {
        let group=*GROUPS.get(index).ok_or("unsupported Complex group index")?;
        let fields=document["groups"].as_array().ok_or("missing source groups")?.iter()
            .find(|g|g["name"]==group).ok_or("missing Complex source group")?["fields"].clone();
        if numeric(&fields,"p-type")!=Some(vec![2.]) || numeric(&fields,"p-texdiv")!=Some(vec![2.,2.]) {
            return Err("unsupported native Complex draw profile");
        }
        let life=scalar(&fields,"p-life",1.)?;
        let timing=Timing::from_group(&fields,None).map_err(|_|"invalid Complex timing")?;
        let linger=Linger::from_group(&fields,&timing,life.maximum).map_err(|_|"invalid Complex linger")?;
        let frame_rate=numeric(&fields,"p-framerate").and_then(|v|v.first().copied()).ok_or("missing frame rate")?;
        if frame_rate!=0. {return Err("nonzero native atlas rate not admitted");}
        let div=numeric(&fields,"p-texdiv").ok_or("missing source atlas divisions")?;
        // Original914AD7..914B0B default: CVTTSS2SI(primary.texdivX*texdivY).
        // Whole nested914A40 captured4 from actual2x2 source. An authored
        // p-numframes overrides that default through original integer getter.
        let product=div[0]*div[1];
        if !product.is_finite() || product<1. || product>=2147483648. {return Err("unsupported atlas frame count domain");}
        let num_frames=numeric(&fields,"p-numframes").and_then(|v|v.first().copied()).unwrap_or(product).trunc() as i32;
        if num_frames<=0 {return Err("nonpositive native atlas frame count");}
        let pair=|key:&str,default:[f32;2]|->Result<[f32;2],&'static str>{match numeric(&fields,key){Some(v)=>v.try_into().map_err(|_|"invalid selected lookup pair"),None=>Ok(default)}};
        // Original913219..913303, validated against actual binary config.
        let modes=pair("p-colortype",[1.,0.])?;let lookup=Lookup {modes:modes.map(|v|v as u32),
            scale:pair("p-colorscale",[1.;2])?,offset:pair("p-coloroffset",[0.;2])?};
        Ok(Self {index,group,
            vectors:vectors::ComplexVectors::from_group(&fields).map_err(|_|"invalid Complex birth vectors")?,
            birth_color:color::ComplexColor::from_group(&fields).map_err(|_|"invalid emitter RGBA")?,
            lifetime_color:color::ComplexColor::from_lifetime_group(&fields).map_err(|_|"invalid lifetime RGBA")?,
            lifetime_scale:vectors::FieldConfig::from_lifetime_scale_group(&fields).map_err(|_|"invalid lifetime scale")?,
            rate:scalar(&fields,"e-rate",0.)?,bind:scalar(&fields,"p-bindtoemitter",0.)?,
            uv:UvParameters::from_group(&fields).map_err(|_|"invalid birth UV")?,
            start_frame:numeric(&fields,"p-startframe").and_then(|v|v.first().copied()).ok_or("missing atlas start")? as i32,
            num_frames,frame_rate,local_emitter_orientation:numeric(&fields,"e-local-orient").map(|v|v[0]!=0.).unwrap_or(true),
            life,timing,linger,lookup,fields})
    }
}
