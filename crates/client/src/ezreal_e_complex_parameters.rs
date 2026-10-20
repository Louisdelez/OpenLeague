//! Exact E missile1 fields with explicit configuration for the missing emitter
//! lifetime. Generic native reader defaults are separate from runtime policy.
use openleague_core::{native_complex_vectors as vectors,native_complex_color as color,
    native_complex_timing::Timing,native_complex_linger::Linger,
    native_complex_uv_parameters::UvParameters,native_scalar_parameter::ScalarParameter,
    native_probability_curve::apply_probability,native_random::Rng55};
use crate::relic_pickup_complex_profiles as profiles;
use serde_json::Value;

#[derive(Clone,Debug)]
pub(crate) struct Rotation { pub scalar:ScalarParameter,pub axis:[u32;3] }
#[derive(Clone,Debug)]
pub(crate) struct Parameters {
    pub(crate) kind:u32,
    numeric:profiles::Profile,
    rotation:Rotation,
    provenance:&'static str,
    global_life:f32,
}
impl std::ops::Deref for Parameters {
    type Target=profiles::Profile;
    fn deref(&self)->&Self::Target{&self.numeric}
}
fn numbers(v:&Value)->Option<Vec<f32>> {
    let out=if let Some(v)=v.as_bool(){vec![u8::from(v) as f32]}
    else if let Some(v)=v.as_f64(){vec![v as f32]}
    else if let Some(v)=v.as_str(){v.split_whitespace().map(str::parse::<f32>).collect::<Result<Vec<_>,_>>().ok()?}
    else {v.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>()?};
    (!out.is_empty()&&out.iter().all(|v|v.is_finite())).then_some(out)
}
impl Parameters {
    /// No default global_life: an absent E e-life is not zero or a measured
    /// native lifetime. The caller names the configuration/local policy used.
    pub(crate) fn load(provenance:&'static str,global_life:f32)->Result<Self,&'static str>{
        if provenance.trim().is_empty()||!global_life.is_finite()||global_life<=0.{return Err("E Complex global life binding absent");}
        let inventory=crate::ezreal_e_bolt_profile::inventory()?;
        let row=&inventory.groups[0];
        if row.name!="missile1"||row.slot!=1||row.declared_type.is_some(){return Err("E Complex source group identity");}
        let mut map=serde_json::Map::new();
        for (key,value) in &row.fields {
            if let Some(v)=numbers(value){map.insert(key.clone(),if v.len()==1{serde_json::json!(v[0])}else{serde_json::json!(v)});}
            else if matches!(key.as_str(),"p-texture"|"KeywordsExcluded"){map.insert(key.clone(),value.clone());}
            else{return Err("E Complex nonnumeric field outside explicit resource strings");}
        }
        let fields=Value::Object(map);
        let get=|key:&str|profiles::numeric(&fields,key);
        let scalar=|key:&str|ScalarParameter::read_numeric(key,0.,get).map_err(|_|"E Complex scalar invalid")?.ok_or("E Complex authored scalar missing");
        let one=|key:&str|{let a=get(key).ok_or("E Complex required number missing")?;if a.len()!=1{return Err("E Complex scalar arity");}Ok(a[0])};
        if one("p-type")?!=0.||one("rendermode")?!=0.||one("p-vecalign")?!=1.||one("p-randomstartframe")?!=1.
            ||one("p-numframes")?!=9.||one("p-framerate")?!=9.||one("p-startframe")?!=0.
            ||one("e-local-orient")?!=1.||get("p-texdiv")!=Some(vec![3.,3.])
            ||get("e-rotation1-axis")!=Some(vec![0.,1.,0.])||fields.get("e-life").is_some(){return Err("E Complex selected source shape changed");}
        let life=scalar("p-life")?;
        let timing=Timing::from_group(&fields,Some(global_life)).map_err(|_|"E Complex timing invalid")?;
        let linger=Linger::from_group(&fields,&timing,life.maximum).map_err(|_|"E Complex linger invalid")?;
        let rotation=Rotation {scalar:scalar("e-rotation1")?,axis:[0,1f32.to_bits(),0]};
        let numeric=profiles::Profile {index:0,group:"missile1",
            vectors:vectors::ComplexVectors::from_group(&fields).map_err(|_|"E Complex vectors invalid")?,
            birth_color:color::ComplexColor::from_group(&fields).map_err(|_|"E Complex birth color invalid")?,
            lifetime_color:color::ComplexColor::from_lifetime_group(&fields).map_err(|_|"E Complex lifetime color invalid")?,
            lifetime_scale:vectors::FieldConfig::from_lifetime_scale_group(&fields).map_err(|_|"E Complex lifetime scale invalid")?,
            uv:UvParameters::from_group(&fields).map_err(|_|"E Complex UV invalid")?,
            rate:scalar("e-rate")?,bind:scalar("p-bindtoemitter")?,life,timing,linger,
            start_frame:0,num_frames:9,frame_rate:9.,local_emitter_orientation:true,
            // Native primary reader913219..913303, not a live owner fallback.
            lookup:profiles::Lookup {modes:[1,0],scale:[1.;2],offset:[0.;2]},fields};
        Ok(Self {kind:0,numeric,rotation,provenance,global_life})
    }
    pub(crate) fn binding(&self)->(&'static str,u32){(self.provenance,self.global_life.to_bits())}
    /// Native primary retention consumes one temporary angle at construction.
    /// A retained scalar is sampled again at each birth; it is never reseeded.
    pub(crate) fn retained(&self,rng:&Rng55)->Result<(Vec<Rotation>,Rng55),&'static str>{
        let mut random=rng.clone();let source=&self.rotation;
        let base=*source.scalar.table.first().ok_or("E Complex empty rotation")?;
        let temporary=apply_probability(Some(&source.scalar.probability),base,&mut random);
        if !temporary.is_finite(){return Err("E Complex rotation retention nonfinite");}
        let mut out=Vec::new();
        if temporary!=0.{
            // Same already qualified selected unit-Y RSQRT producer as Capture.
            let mut carrier=[0.;16];carrier[4]=f32::from_bits(source.axis[1]);
            let normal=openleague_core::native_actor_effect_owner::orientation(carrier)?;
            let axis=[normal[0],normal[4],normal[8]].map(f32::to_bits);
            if axis!=[0,0x3f800001,0]{return Err("E Complex selected axis producer differs");}
            out.push(Rotation {scalar:source.scalar.clone(),axis});
        }
        Ok((out,random))
    }
}
