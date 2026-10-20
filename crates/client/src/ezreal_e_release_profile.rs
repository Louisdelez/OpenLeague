//! Two original named Simple flashes. Their other Troy groups remain outside this adapter.
use serde_json::{Value,json};
use std::collections::BTreeMap;
use openleague_core::{ezreal_e_accepted_releases::Phase,native_scalar_parameter::ScalarParameter,
    native_vector_parameter::VectorParameter,native_simple_particle_update::Attribute};
use crate::{ezreal_e_simple_parameters::{Group,Parameters},ezreal_e_bolt_local::scalar};
pub(crate) const POLICY:&str="map10_e_committed_phase_ground_flashes_local_v1";
pub(crate) const IMAGES:[&str;2]=["particles/ezreal/e_release_flashes/flare-sun_orange.dds","particles/ezreal/e_release_flashes/flare-sun.dds"];
pub(crate) const COLOR:&str="particles/ezreal/e_release_flashes/color-hold.dds";
pub(crate) const RAW:[&[u8];2]=[include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_arcaneshift_cas.troybin"),include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_arcaneshift_flash.troybin")];
pub(crate) const SOURCE:&str=include_str!("../../../data/4.20/ezreal_e_release_flashes.json");
pub(crate) fn phase_index(phase:Phase)->usize {match phase{Phase::Departure=>0,Phase::Arrival=>1}}
pub(crate) struct Profile {pub parameters:[Parameters;2],pub rotation:ScalarParameter,pub axis:[u32;3]}
#[derive(Clone,Debug,PartialEq)]
struct Field {kind:u8,key_offset:usize,value_offset:usize,bit:Option<u8>,value:Value}
fn hash(text:&str)->u32 {text.to_ascii_lowercase().bytes().fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)))}
fn bytes<const N:usize>(raw:&[u8],at:usize)->Result<[u8;N],&'static str> {
    raw.get(at..at.checked_add(N).ok_or("E field overflow")?).and_then(|s|s.try_into().ok()).ok_or("E field truncated")
}
fn u16_at(raw:&[u8],at:usize)->Result<u16,&'static str>{Ok(u16::from_le_bytes(bytes(raw,at)?))}
fn float_at(raw:&[u8],at:usize)->Result<f32,&'static str> {
    let v=f32::from_le_bytes(bytes(raw,at)?);if !v.is_finite(){return Err("E resource nonfinite");}Ok(v)
}
/// Bounded v2 DATA decoding only. The complete 262/363-key original table is decoded, so
/// unknown fields remain preserved data rather than being silently dropped.
fn decode(raw:&[u8],expected:usize,pool:usize)->Result<BTreeMap<u32,Field>,&'static str> {
    if raw.first()!=Some(&2)||u16_at(raw,3)?!=6134{return Err("E original header changed");}
    if raw.len().checked_sub(usize::from(u16_at(raw,1)?))!=Some(pool){return Err("E release pool changed");}
    let sizes=[4,4,1,2,1,1,3,12,2,8,4,16,2];let mut at=5usize;let mut fields=BTreeMap::new();
    for kind in 0..13usize {
        if 6134u16&(1<<kind)==0{continue;}
        let count=usize::from(u16_at(raw,at)?);at+=2;
        if count>expected||fields.len()+count>expected{return Err("E field budget");}
        let keys=at;at+=count*4;let values=at;
        let end=values+if kind==5{count.div_ceil(8)}else{count*sizes[kind]};
        if end>pool{return Err("E values escaped pool");}
        for i in 0..count {
            let key_offset=keys+4*i;let key=u32::from_le_bytes(bytes(raw,key_offset)?);
            let value_offset=values+if kind==5{i/8}else{i*sizes[kind]};
            let bit=(kind==5).then_some((i%8) as u8);
            let value=match kind {
                0=>json!(i32::from_le_bytes(bytes(raw,value_offset)?)),
                1=>json!(f64::from(float_at(raw,value_offset)?)),
                2=>json!(f64::from(raw[value_offset])/10.),
                3=>json!(i16::from_le_bytes(bytes(raw,value_offset)?)),
                4=>json!(raw[value_offset]),
                5=>json!((raw[value_offset]&(1<<(i%8)))!=0),
                6|8|10=>json!((0..sizes[kind]).map(|j|f64::from(raw[value_offset+j])/10.).collect::<Vec<_>>()),
                7|9|11=>json!((0..sizes[kind]/4).map(|j|float_at(raw,value_offset+4*j).map(f64::from)).collect::<Result<Vec<_>,_>>()?),
                12=>{let start=pool+usize::from(u16_at(raw,value_offset)?);
                    let tail=raw.get(start..).ok_or("E string outside pool")?;
                    let len=tail.iter().position(|b|*b==0).ok_or("E string unterminated")?;
                    if !tail[..len].is_ascii(){return Err("E source string not ASCII");}
                    json!(std::str::from_utf8(&tail[..len]).map_err(|_|"E source string invalid")?)},
                _=>return Err("E field type unsupported"),
            };
            if fields.insert(key,Field{kind:kind as u8,key_offset,value_offset,bit,value}).is_some(){return Err("E duplicate field key");}
        }
        at=end;
    }
    if at!=pool||fields.len()!=expected{return Err("E full table incomplete");}Ok(fields)
}

fn numbers(value:&Value)->Option<Vec<f32>> {
    let values=if let Some(v)=value.as_bool(){vec![u8::from(v) as f32]}
        else if let Some(v)=value.as_f64(){vec![v as f32]}
        else if let Some(v)=value.as_str(){v.split_whitespace().map(str::parse).collect::<Result<Vec<f32>,_>>().ok()?}
        else{value.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>()?};
    (!values.is_empty()&&values.iter().all(|v|v.is_finite())).then_some(values)
}
fn fields(text:&str,raw:[&[u8];2])->Result<[BTreeMap<String,Value>;2],&'static str> {
    if text.len()>65536{return Err("E release profile budget");}
    let doc:Value=serde_json::from_str(text).map_err(|_|"E release JSON invalid")?;
    if doc["schema"]!="OpenLeague_E_release_flashes/v1"||doc["rows"].as_array().is_none_or(|v|v.len()!=2){return Err("E release schema");}
    let mut output=Vec::new();
    for (i,(size,pool,count,name,image)) in [(1973,1794,262,"departure","flare-sun_orange.tga"),
        (2809,2478,363,"arrival","flare-sun.tga")].into_iter().enumerate(){
        let row=&doc["rows"][i];if raw[i].len()!=size||row["phase"]!=name||row["pool_offset"]!=pool||row["field_count"]!=count{return Err("E release source identity");}
        let table=decode(raw[i],count,pool)?;
        if table.get(&hash("System*GroupPart1")).map(|v|&v.value)!=Some(&json!("flashes"))
            ||table.get(&hash("System*GroupPart1Type")).map(|v|&v.value)!=Some(&json!("Simple")){return Err("E release class changed");}
        let rows=row["fields"].as_array().ok_or("E release field list")?;
        if rows.len()!=41{return Err("E release named field count");}let mut fields=BTreeMap::new();
        for f in rows{
            let name=f["name"].as_str().ok_or("E release field name")?;let key=hash(&format!("flashes*{name}"));
            let original=table.get(&key).ok_or("E release key absent")?;
            if f["key"]!=key||f["type_bit"]!=original.kind||f["key_offset"]!=original.key_offset
                ||f["value_offset"]!=original.value_offset||f.get("bit_index").and_then(Value::as_u64)!=original.bit.map(u64::from)
                ||f["value"]!=original.value||fields.insert(name.to_owned(),original.value.clone()).is_some(){return Err("E release field bytes mismatch");}
        }
        if fields.get("p-texture").and_then(Value::as_str).is_none_or(|s|!s.eq_ignore_ascii_case(image))
            ||fields.get("p-rgba")!=Some(&json!("color-hold.tga"))||fields.get("flag-disable-z")!=Some(&json!(true))
            ||fields.get("p-type")!=Some(&json!("0"))||fields.get("rendermode")!=Some(&json!("0"))
            ||fields.get("p-texdiv")!=Some(&json!([1.,1.]))||fields.get("p-numframes")!=Some(&json!(true))
            ||fields.get("p-startframe")!=Some(&json!(true))||fields.get("p-frameRate")!=Some(&json!("0"))
            ||fields.get("e-local-orient")!=Some(&json!("0")){return Err("E release renderer route changed");}
        output.push(fields);
    }
    Ok(output.try_into().map_err(|_|"E release phases")?)
}
impl Profile {
    pub(crate) fn load()->Result<Self,&'static str>{Self::parse(SOURCE,RAW)}
    fn parse(text:&str,raw:[&[u8];2])->Result<Self,&'static str>{
        let fields=fields(text,raw)?;
        let get=|key:&str|fields[0].get(key).and_then(numbers);
        let rotation=ScalarParameter::read_numeric("e-rotation1",0.,get).map_err(|_|"E release rotation")?.ok_or("E release rotation absent")?;
        let axis:[f32;3]=get("e-rotation1-axis").ok_or("E release axis absent")?.try_into().map_err(|_|"E release axis arity")?;
        let mut parameters=Vec::new();
        for row in &fields{
            let get=|key:&str|row.get(key).and_then(numbers);
            let s=|key:&str,base:f32|ScalarParameter::read_numeric(key,base,get).map_err(|_|"E release scalar")?.ok_or("E release scalar absent");
            let v=|key:&str|VectorParameter::read_nonrotation(key,[0.;3],256,get).map_err(|_|"E release vector")?.ok_or("E release vector absent");
            let one=|key:&str|{let values=get(key).ok_or("E release number absent")?;if values.len()!=1{return Err("E release number arity");}Ok(values[0])};
            let pair=|key:&str|get(key).ok_or("E release pair absent")?.try_into().map_err(|_|"E release pair arity");
            let modes:[f32;2]=pair("p-colortype")?;let colors:[f32;2]=pair("p-colorscale")?;
            if modes!=[1.,0.] {return Err("E release palette route changed");}
            let zero=VectorParameter::read_nonrotation("local",[0.;3],256,|k|(k=="local").then_some(vec![0.;3]))
                .map_err(|_|"E release local descriptor")?.ok_or("E release local descriptor absent")?;
            // Explicit local absent-input policy: velocity/angular speed/coloroffset0,
            // no particle stop-cap and no external attributes/forces/flex. These are
            // not resource values. Authored postoffset is bound separately below.
            let p=Parameters{group:Group::ReleaseFlash,provenance:POLICY,rate:s("e-rate",0.)?,life:s("p-life",0.)?,
                quad_rotation:s("p-quadrot",0.)?,scale:s("p-scale",0.)?,angular_velocity:scalar(0.),xscale:s("p-xscale",1.)?,
                offset:v("p-offset")?,velocity:zero,position_offset:v("p-postoffset")?,
                authored_emitter_life:one("e-life")?,authored_emitter_linger:one("e-linger")?,
                // Existing Parameters requires an explicit positive input even
                // when particle_cap is disabled; absent p-linger is not inferred.
                authored_particle_linger:f32::MAX,emitter_local:false,particle_type:0,simple_orientation:None,
                bind:pair("p-bindtoemitter")?,attributes:std::array::from_fn(|i|Attribute{mode:modes[i] as u32,
                    multiplier:colors[i].to_bits(),offset:0f32.to_bits()})};
            p.validate()?;parameters.push(p);
        }
        // Only the image differs between the authored groups. Rotation source is
        // shared, but each public phase owns a separate local random sequence.
        for (key,value) in &fields[0] {if key!="p-texture"&&fields[1].get(key)!=Some(value){return Err("E phase parameters diverged");}}
        Ok(Self{parameters:parameters.try_into().map_err(|_|"E release parameter phases")?,rotation,axis:axis.map(f32::to_bits)})
    }
    pub(crate) fn parameter(&self,phase:Phase)->&Parameters{&self.parameters[phase_index(phase)]}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn original_field_and_string_changes_are_rejected_before_birth(){
        let p=Profile::load().unwrap();assert_eq!(p.parameters[0].offset.table,p.parameters[1].offset.table);
        let mut raw=RAW[0].to_vec();raw[15]^=1;assert!(Profile::parse(SOURCE,[&raw,RAW[1]]).is_err());
        let mut j:Value=serde_json::from_str(SOURCE).unwrap();j["rows"][0]["fields"][0]["value"]=json!(2.);
        assert!(Profile::parse(&j.to_string(),RAW).is_err());
    }
    #[test]
    fn real_probability_and_lifetime_tables_are_used_instead_of_single_r_flash(){
        let p=Profile::load().unwrap();let a=p.parameter(Phase::Departure);
        assert!(a.offset.table.len()>1);assert_eq!(a.life.table,[0.5]);assert_eq!(a.rate.table,[200.]);
        let mut rng=openleague_core::native_random::Rng55::seeded(7);
        let angles=(0..10).map(|_|a.quad_rotation.sample_age(0.,&mut rng).unwrap()).collect::<Vec<_>>();
        assert!(angles.iter().all(|v|*v>=0.&&*v<=360.));assert!(angles.windows(2).any(|w|w[0]!=w[1]));
        assert_eq!(a.xscale.table[0],0.);assert!(*a.xscale.table.last().unwrap()>0.&&*a.xscale.table.last().unwrap()<0.01);
    }
}

/// Narrow reuse of the original arrival decoder for the two declared head groups.
/// No source-group activation or default values are inferred from arbitrary JSON.
pub(crate) fn checked_arrival_head_fields(raw:&[u8],section:&str,rows:&[Value])
    ->Result<BTreeMap<String,Value>,&'static str>{
    let slot=match section {"head1"=>2,"head2"=>4,_=>return Err("E arrival head section")};
    if raw.len()!=2809||rows.len()!=35{return Err("E arrival head source size/count");}
    let table=decode(raw,363,2478)?;
    if table.get(&hash(&format!("System*GroupPart{slot}"))).map(|f|&f.value)!=Some(&json!(section))
        ||table.get(&hash(&format!("System*GroupPart{slot}Type"))).map(|f|&f.value)!=Some(&json!("Simple")) {
        return Err("E arrival head declaration changed");
    }
    let mut fields=BTreeMap::new();
    for f in rows {
        let name=f["name"].as_str().ok_or("E arrival head field name")?;
        let key=hash(&format!("{section}*{name}"));let original=table.get(&key).ok_or("E arrival head field absent")?;
        if f["key"]!=key||f["type_bit"]!=original.kind||f["key_offset"]!=original.key_offset
            ||f["value_offset"]!=original.value_offset||f.get("bit_index").and_then(Value::as_u64)!=original.bit.map(u64::from)
            ||f["value"]!=original.value||fields.insert(name.to_owned(),original.value.clone()).is_some(){
            return Err("E arrival head field bytes mismatch");
        }
    }
    Ok(fields)
}
