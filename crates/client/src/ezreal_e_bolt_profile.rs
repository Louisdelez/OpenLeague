//! Checked inert inventory of the three base E missile groups. No particle
//! defaults, owner matrix, instance clock, native factory or renderer is invented.
use serde_json::{Value,json};
use std::collections::{BTreeMap,BTreeSet};
pub const SOURCE:&str=include_str!("../../../data/4.20/ezreal_e_current_bolt_inventory.json");
pub const ORIGINAL:&[u8]=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_arcaneshift_mis.troybin");
pub const POLICY:&str="e_bolt_three_base_groups_source_inventory_v1";
const SOURCE_SHA:&str="0977614e597816d5fb02493958fb86794b5af616ebd19665d7add13e185704c8";
#[derive(Clone,Debug)]
pub struct Group {pub slot:u8,pub name:&'static str,pub declared_type:Option<&'static str>,pub fields:BTreeMap<String,Value>}
#[derive(Clone,Debug)]
pub struct Profile {pub groups:[Group;3],pub unresolved_keys:Vec<u32>,pub resources:Vec<Value>}
/// Validate compiled-in DATA once; this does not create or authorize any draw.
pub fn inventory()->Result<&'static Profile,&'static str> {
    static INVENTORY:std::sync::OnceLock<Result<Profile,&'static str>>=std::sync::OnceLock::new();
    match INVENTORY.get_or_init(Profile::load){Ok(profile)=>Ok(profile),Err(error)=>Err(*error)}
}
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
/// Bounded v2 DATA decoding only. The complete 334-key table is checked, so
/// unknown fields remain preserved data rather than being silently dropped.
fn decode(raw:&[u8])->Result<BTreeMap<u32,Field>,&'static str> {
    if raw.len()!=2886||raw.first()!=Some(&2)||u16_at(raw,3)?!=8190{return Err("E original header changed");}
    let pool=raw.len().checked_sub(usize::from(u16_at(raw,1)?)).ok_or("E pool invalid")?;
    if pool!=2302{return Err("E original pool changed");}
    let sizes=[4,4,1,2,1,1,3,12,2,8,4,16,2];let mut at=5usize;let mut fields=BTreeMap::new();
    for kind in 0..13usize {
        if 8190u16&(1<<kind)==0{continue;}
        let count=usize::from(u16_at(raw,at)?);at+=2;
        if count>334||fields.len()+count>334{return Err("E field budget");}
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
    if at!=pool||fields.len()!=334{return Err("E full table incomplete");}Ok(fields)
}
impl Profile {
    pub fn load()->Result<Self,&'static str>{Self::parse(SOURCE,ORIGINAL)}
    fn parse(text:&str,raw:&[u8])->Result<Self,&'static str> {
        if text.len()>262_144{return Err("E profile size budget");}
        let doc:Value=serde_json::from_str(text).map_err(|_|"E profile JSON invalid")?;
        if doc["schema"]!="OpenLeague_E_current_bolt_resource_inventory/v1"||doc["policy"]!=POLICY
            ||doc["source"]["sha256"]!=SOURCE_SHA||doc["source"]["bytes"]!=2886
            ||doc["renderer_ready"]!=false||doc["version"]!=2||doc["flags"]!=8190||doc["pool_offset"]!=2302
            ||doc["excluded_variant"]!="CyberEzreal" {return Err("E inventory identity changed");}
        let table=decode(raw)?;let authored=doc["raw_fields"].as_array().ok_or("E raw fields absent")?;
        if authored.len()!=334{return Err("E preserved table incomplete");}
        let mut seen=BTreeSet::new();
        for f in authored {
            let key=f["key"].as_u64().and_then(|n|u32::try_from(n).ok()).ok_or("E key invalid")?;
            let field=table.get(&key).ok_or("E unknown table key")?;
            if !seen.insert(key)||f["type_bit"]!=field.kind||f["key_offset"]!=field.key_offset
                ||f["value_offset"]!=field.value_offset||f.get("bit_index").and_then(Value::as_u64)!=field.bit.map(u64::from)
                ||f["value"]!=field.value {return Err("E original field value changed");}
        }
        let definitions=doc["groups"].as_array().ok_or("E groups absent")?;
        if definitions.len()!=3{return Err("E group count changed");}
        let mut groups=Vec::new();
        for (index,(slot,name,class,kind)) in [(1,"missile1",None,0),(3,"magicdust",Some("Simple"),0),(4,"dust",Some("Simple"),1)].into_iter().enumerate() {
            let row=&definitions[index];let selection=class.unwrap_or("Complex");
            if row["slot"]!=slot||row["name"]!=name||row["selection"]!=selection
                ||row["declared_type"]!=class.map_or(Value::Null,|s|json!(s))||row["particle_type"]!=kind
                ||table.get(&hash(&format!("System*GroupPart{slot}"))).map(|f|&f.value)!=Some(&json!(name)) {
                return Err("E group identity changed");
            }
            let class_value=table.get(&hash(&format!("System*GroupPart{slot}Type"))).map(|f|f.value.as_str());
            if class_value!=class.map(Some){return Err("E class declaration changed");}
            let names=row["fields"].as_object().ok_or("E group fields absent")?;
            if names.len()!=[50,36,31][index]{return Err("E named field inventory incomplete");}
            let mut fields=BTreeMap::new();
            for (name_key,key) in names {
                let expected=hash(&format!("{name}*{name_key}"));
                if key.as_u64()!=Some(u64::from(expected)){return Err("E lexical hash changed");}
                fields.insert(name_key.clone(),table.get(&expected).ok_or("E named field not in original")?.value.clone());
            }
            if fields.get("KeywordsExcluded")!=Some(&json!("CyberEzreal")){return Err("E base selection changed");}
            groups.push(Group{slot:slot as u8,name,declared_type:class,fields});
        }
        let unresolved=doc["unresolved_keys"].as_array().ok_or("E unknown keys absent")?;
        let unresolved_keys=unresolved.iter().map(|v|v.as_u64().and_then(|n|u32::try_from(n).ok())).collect::<Option<Vec<_>>>().ok_or("E unknown key invalid")?;
        if unresolved_keys.len()!=62||unresolved_keys.iter().copied().collect::<BTreeSet<_>>().len()!=62
            ||unresolved_keys.iter().any(|k|!table.contains_key(k)){return Err("E unknown keys were dropped");}
        let resources=doc["resources"].as_array().ok_or("E resource inventory absent")?.clone();
        if resources.len()!=5{return Err("E resource inventory incomplete");}
        for (r,(group,field,name,digest,size)) in resources.iter().zip([
            ("missile1","p-texture","multilightning4.tga","0d34360ddfb7b160311d353e25e4910faa71d4a284155dc3bd5c58b92be84125",349680),
            ("magicdust","p-rgba","color-beacontrail.tga","d07652721520b47363a1766b7bb852d05b9c9362f367110d51383962c4571ad6",8320),
            ("dust","p-rgba","color-sorakabasicattack.tga","7dd0f9ea029ea2c6f7ac5695223ef84e59fc46727f85f0db7ac8c22e89cf6dea",5616),
            ("dust","p-texture","SorakaBasicAttack04.tga","6a601063035b495ef8068570e9fab8c51461f9c14f368a14c9debbf22efe71b8",131232),
            ("magicdust","p-texture","ball01.tga","9971cfd18a57f515b02f8425faf57d6ac052b30a40b676638a68408d556bd23f",22000),
        ]) {
            if r["group"]!=group||r["field"]!=field||r["source_name"]!=name||r["sha256"]!=digest||r["bytes"]!=size {
                return Err("E original resource binding changed");
            }
        }
        Ok(Self{groups:groups.try_into().map_err(|_|"E group count")?,unresolved_keys,resources})
    }
    pub fn renderer_ready(&self)->bool{false}
}

#[cfg(test)]
#[path="ezreal_e_bolt_profile_tests.rs"]
mod tests;
