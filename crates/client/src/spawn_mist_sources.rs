//! Actual source configuration for the two Map10 spawn mist groups.
//! Reconstructed geometry/texture identities and full birth/frame host remain
//! separate. Every owner pose, frame packet and renderer context is supplied.
use openleague_core::{
    native_complex_vectors::{ComplexVectors,FieldConfig},
    native_complex_color::ComplexColor,
    native_complex_uv_parameters::UvParameters,
    native_complex_timing::Timing,native_complex_linger::Linger,
    native_scalar_parameter::ScalarParameter,
    native_probability_curve::ProbabilityCurve,
};
use serde_json::Value;
pub type Error=String;

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Effect {Order,Chaos}
impl Effect {
    pub fn name(self)->&'static str {match self {Self::Order=>"Order_Spawn",Self::Chaos=>"Chaos_Spawn"}}
}
#[derive(Debug,Clone,Copy)]
pub struct Lookup {pub modes:[u32;2],pub scale:[f32;2],pub offset:[f32;2]}
#[derive(Debug,Clone)]
pub struct Factory {
    pub provider_capability:bool,
    pub primary_position:[u32;3],pub primary_rotation_degrees:[u32;3],pub primary_scale:[u32;3],
    pub source_modulation:[f32;4],pub texdiv:[f32;2],pub uv_mode:u32,pub render_mode:u32,
    pub primary_render_flags:u32,pub nested_flags:[u8;3],
    /// Captured by offset; neither is mislabeled as an atlas clock producer.
    pub primary_parameter_f0:ScalarParameter,pub primary_parameter_22c:ScalarParameter,
    pub native_start_frame:i32,pub native_num_frames:i32,pub native_frame_rate:f32,pub emitter_shape_scale:f32,
    pub native_instance_c0:[u32;10],pub instance_life:f32,pub local_emitter:bool,
    pub mult_texture_pointer:u32,pub reflection_texture_pointer:u32,pub alpha_slice:f32,pub soft_enabled:bool,
}
#[derive(Debug,Clone)]
pub struct Profile {
    pub effect:Effect,pub fields:Value,pub factory:Factory,
    pub vectors:ComplexVectors,pub birth_color:ComplexColor,pub lifetime_color:ComplexColor,
    pub lifetime_scale:FieldConfig,pub uv:UvParameters,
    pub life:ScalarParameter,pub rate:ScalarParameter,pub bind:ScalarParameter,
    pub timing:Timing,pub linger:Linger,pub lookup:Lookup,
}
fn word(v:&Value)->Result<u32,Error> {v.as_u64().and_then(|v|u32::try_from(v).ok()).ok_or("invalid source word".into())}
fn words<const N:usize>(v:&Value)->Result<[u32;N],Error> {
    let values=v.as_array().ok_or("missing source vector")?;
    if values.len()!=N {return Err("source vector width".into());}
    values.iter().map(word).collect::<Result<Vec<_>,_>>()?.try_into().map_err(|_|"source vector width".into())
}
fn floats<const N:usize>(v:&Value)->Result<[f32;N],Error> {
    let values=words::<N>(v)?.map(f32::from_bits);
    if values.iter().any(|v|!v.is_finite()) {return Err("nonfinite source vector".into());}Ok(values)
}
pub fn numeric(fields:&Value,key:&str)->Option<Vec<f32>> {
    let value=fields.as_object()?.iter().find(|(k,_)|k.eq_ignore_ascii_case(key))?.1;
    if let Some(v)=value.as_f64(){return Some(vec![v as f32]);}
    value.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect()
}
fn authored_scalar(fields:&Value,key:&str,default:f32)->Result<ScalarParameter,Error> {
    ScalarParameter::read_numeric(key,default,|k|numeric(fields,k)).map_err(|e|format!("{key}: {e:?}"))?
        .ok_or_else(||format!("missing authored scalar {key}"))
}
fn probability(v:&Value)->Result<ProbabilityCurve,Error> {
    let values=|key:&str|->Result<Vec<f32>,Error>{v[key].as_array().ok_or("missing probability knots")?.iter()
        .map(|v|word(v).map(f32::from_bits)).collect()};
    let scalar=|key:&str|word(&v[key]).map(f32::from_bits);
    let p=ProbabilityCurve {present:true,constant:v["constant"].as_bool().ok_or("probability constant flag")?,
        constant_value:scalar("constant_word")?,fast:v["fast"].as_bool().ok_or("probability fast flag")?,
        begin:scalar("begin_word")?,difference:scalar("difference_word")?,
        times:values("times_words")?,values:values("values_words")?};
    if p.times.len()!=p.values.len() || p.times.iter().chain(&p.values)
        .chain([p.constant_value,p.begin,p.difference].iter()).any(|v|!v.is_finite()) {
        return Err("unsupported native probability".into());
    }Ok(p)
}
fn captured_scalar(row:&Value,offset:&str)->Result<ScalarParameter,Error> {
    let p=row["primary_parameters"].as_array().ok_or("missing actual primary parameters")?.iter()
        .find(|p|p["offset"]==offset).ok_or("missing actual stored parameter")?;
    if p["width"]!=1 {return Err("frame parameter width".into());}
    let table=p["table_words"].as_array().ok_or("frame table absent")?.iter().map(|v|word(v).map(f32::from_bits)).collect::<Result<Vec<_>,_>>()?;
    let curve=&p["probabilities"][0];
    // Frame configuration is an actual constructor output, not an expected
    // particle packet. A null curve is retained as the native default object.
    let probability=if curve.is_null(){ProbabilityCurve {present:false,constant:true,constant_value:1.,fast:false,begin:0.,difference:0.,times:vec![],values:vec![]}}
        else {probability(curve)?};
    let maximum=f32::from_bits(word(&p["maximum_word"])?);
    if table.iter().chain([maximum].iter()).any(|v|!v.is_finite()) {
        return Err(format!("unqualified or nonfinite native stored configuration {offset}"));
    }
    Ok(ScalarParameter {maximum,table,probability})
}
impl Profile {
    pub fn from_documents(effect:Effect,definition:&Value,factory_document:&Value,provider_capability:bool)->Result<Self,Error> {
        let fields=definition["sections"]["mist"].clone();
        if !fields.is_object() || factory_document["passed"]!=true
            || factory_document["source_profile_sha256"]!=definition["source_sha256"] {
            return Err("mist source/factory provenance mismatch".into());
        }
        let row=factory_document["cases"].as_array().ok_or("missing mist constructor cases")?.iter()
            .find(|row|row["effect"]==effect.name()&&row["group"]=="mist"&&row["provider_capability"]==provider_capability)
            .ok_or("actual source/capability case absent")?;
        let n=&row["nested_values"];let p=&row["primary_scalars"];
        if n["0x10"]!=3 || p["0x28"]!=4 || n["0x2b4"]!=2
            || fields["p-mesh"]!="fogcircle.sco" || fields["p-meshtex"]!="TT_Mist_circle.tga"
            || row["rotation_list"].as_array().is_none_or(|v|!v.is_empty()) {
            return Err("source outside selected native mist route".into());
        }
        let f=|key:&str|word(&p[key]).map(f32::from_bits);
        let div=floats::<4>(&row["texdiv_and_mult_words"])?;
        let soft= row["soft_parameter_native_bytes"].as_str().ok_or("actual soft fields absent")?;
        if soft.len()!=40 {return Err("actual soft fields width".into());}
        let factory=Factory {provider_capability,
            primary_position:words(&row["primary_fields"]["position"])?,
            primary_rotation_degrees:words(&row["primary_fields"]["rotation_degrees"])?,
            primary_scale:words(&row["primary_fields"]["scale"])?,
            source_modulation:floats(&row["source_modulation_rgba_a4"])?,texdiv:[div[0],div[1]],
            uv_mode:word(&n["0x2b4"])?,render_mode:word(&p["0x28"])?,primary_render_flags:word(&p["0x2c"])?,
            nested_flags:[word(&row["nested_flags_2ac"])? as u8,word(&row["nested_flags_2ad"])? as u8,word(&row["nested_flags_478"])? as u8],
            primary_parameter_f0:captured_scalar(row,"0xf0")?,primary_parameter_22c:captured_scalar(row,"0x22c")?,
            native_start_frame:word(&row["nested_raw_words"][1])? as i32,
            native_num_frames:word(&row["nested_raw_words"][2])? as i32,native_frame_rate:f32::from_bits(word(&row["nested_raw_words"][3])?),
            emitter_shape_scale:f32::from_bits(word(&n["0x474"])?),
            native_instance_c0:words(&row["native_instance_c0_table_source_words"])?,
            instance_life:f32::from_bits(word(&row["fresh"]["0x7c"])?),local_emitter:word(&p["0x2e8"])?&255!=0,
            mult_texture_pointer:word(&p["0x40"])?,reflection_texture_pointer:word(&p["0x50"])?,alpha_slice:f("0xf8")?,soft_enabled:&soft[..2]!="00"};
        let life=authored_scalar(&fields,"p-life",1.)?;
        let timing=Timing::from_group(&fields,None).map_err(|e|format!("{e:?}"))?;
        let linger=Linger::from_group(&fields,&timing,life.maximum).map_err(|e|format!("{e:?}"))?;
        let pair=|key:&str|->Result<[f32;2],Error>{numeric(&fields,key).ok_or_else(||format!("missing {key}"))?
            .try_into().map_err(|_|format!("invalid {key}"))};
        let modes=pair("p-colortype")?;
        if modes!=[1.,3.] || timing.life.to_bits()!=word(&p["0x2f0"])?
            || timing.life.to_bits()!=factory.instance_life.to_bits() {
            return Err("native mist timing/palette source mismatch".into());
        }
        Ok(Self {effect,
            vectors:ComplexVectors::from_group(&fields).map_err(|e|format!("{e:?}"))?,
            birth_color:ComplexColor::from_group(&fields).map_err(|e|format!("{e:?}"))?,
            lifetime_color:ComplexColor::from_lifetime_group(&fields).map_err(|e|format!("{e:?}"))?,
            lifetime_scale:FieldConfig::from_lifetime_scale_group(&fields).map_err(|e|format!("{e:?}"))?,
            uv:UvParameters::from_group(&fields).map_err(|e|format!("{e:?}"))?,
            rate:authored_scalar(&fields,"e-rate",0.)?,bind:authored_scalar(&fields,"p-bindtoemitter",0.)?,
            lookup:Lookup {modes:modes.map(|v|v as u32),scale:pair("p-colorscale")?,offset:pair("p-coloroffset")?},
            life,timing,linger,factory,fields})
    }
    /// Original93A07C mode1 and mode3 (record.field58 / birth packet108).
    /// The caller must supply the stored shared birth fraction; no RNG draw here.
    pub fn lookup_uv(&self,normalized_particle_age:f32,stored_shared_birth:f32)->Result<[f32;2],Error> {
        if !normalized_particle_age.is_finite() || !stored_shared_birth.is_finite(){return Err("nonfinite mist palette input".into());}
        let values=[self.lookup.scale[0]*normalized_particle_age+self.lookup.offset[0],
            self.lookup.scale[1]*stored_shared_birth+self.lookup.offset[1]];
        if values.iter().any(|v|!v.is_finite()){return Err("mist palette coordinate overflow".into());}Ok(values)
    }
    /// Original925F54 mode4 preserves alpha and multiplies each stored channel
    /// by actual primaryA4. Only modes0/2 take its RGB premultiplication branch.
    pub fn prepare_rgba(&self,stored:[f32;4])->Result<[f32;4],Error> {
        if stored.iter().any(|v|!v.is_finite()){return Err("nonfinite stored mist RGBA".into());}
        let result=std::array::from_fn(|i|stored[i]*self.factory.source_modulation[i]);
        if result.iter().any(|v|!v.is_finite()){return Err("mist RGBA overflow".into());}Ok(result)
    }
    /// Original9260A1..926229 type3/style2 c232 upload. CVTTSS2SI truncates
    /// the atlas frame; the stored UV scroll is added after native fmod layout.
    /// The actual packet/scroll producer is mandatory and is not sampled here.
    pub fn mesh_uv_transform(&self,atlas_frame:f32,stored_scroll:[f32;2])->Result<[f32;4],Error> {
        let [cols,rows]=self.factory.texdiv;
        if !atlas_frame.is_finite() || !(-2147483648.0..2147483648.0).contains(&atlas_frame)
            || stored_scroll.iter().any(|v|!v.is_finite()) || cols<=0. || rows<=0. {
            return Err("unsupported native mist UV input".into());
        }
        let frame=(atlas_frame as i32) as f32;
        let remainder=frame%cols;
        let inv_x=1./cols;let inv_y=1./rows;
        let x=remainder*inv_x;
        let y=((frame-remainder)*inv_x)*inv_y;
        let values=[inv_x,inv_y,stored_scroll[0]+x,stored_scroll[1]+y];
        if values.iter().any(|v|!v.is_finite()){return Err("native mist UV overflow".into());}Ok(values)
    }
    /// Exact existing native mesh-pose composition; radius/pivot and per-particle
    /// pose/scale/post-offset are supplied, never inferred from an asset name.
    pub fn mesh_world(&self,input:openleague_core::native_complex_mesh_pose::Inputs)->Result<[f32;16],Error> {
        openleague_core::native_complex_mesh_pose::compose(input).map_err(str::to_owned)
    }
}

#[cfg(test)]
#[path="spawn_mist_sources_tests.rs"]mod tests;
