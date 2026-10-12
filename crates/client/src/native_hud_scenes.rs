//! Native 9A9240 scene definition parser, with supplied initial name-storage bytes.
//! Pool/tree ownership, group caches/settings/layout, clock and drawing remain separate.
use crate::{native_hud_groups::{Registry,Group},native_hud_property_driver::{Cursor,read_line},native_hud_integer_properties::decimal_prefix,native_hud_named_element::hash};
pub struct Step {pub start:usize,pub consumed:usize,pub accepted:bool}
pub struct Scenes {pub registry:Registry,pub order:Vec<u32>,pub steps:Vec<Step>,pub consumed:usize}
fn name(line:&[u8])->Option<&[u8]> {
    let value=line.strip_prefix(b"Name:")?;let start=value.iter().position(|b|!(*b==32 || (9..=13).contains(b)))?;
    let value=&value[start..];let end=value.iter().position(|b|*b==32 || (9..=13).contains(b)).unwrap_or(value.len()).min(31);Some(&value[..end])
}
fn integer(line:&[u8],key:&[u8])->Option<u32> {decimal_prefix(line.strip_prefix(key)?)}
pub fn parse(data:&[u8],initial_name_storage:[u8;32])->Result<Scenes,&'static str> {
    if !data.is_ascii() {return Err("unqualified HUD scene encoding");}
    let mut cursor=Cursor {data,position:0};let mut result=Scenes {registry:Registry {groups:Default::default(),flags:0},order:Vec::new(),steps:Vec::new(),consumed:0};
    loop {
        let start=cursor.position;
        // The native parser always discards one line before attempting Name.
        while cursor.position<data.len() {let b=data[cursor.position];cursor.position+=1;if b==10 {break;}}
        let line=read_line(&mut cursor)?;
        let Some(name)=name(&line) else {result.steps.push(Step {start,consumed:cursor.position-start,accepted:false});break};
        let key=hash(name);
        if !result.registry.groups.contains_key(&key) {
            let mut name_storage=initial_name_storage;name_storage[..name.len()].copy_from_slice(name);name_storage[name.len()]=0;
            result.registry.groups.insert(key,Group {name_storage,enabled_marker:1,..Group::default()});result.order.push(key);result.registry.flags|=3;
        }
        let group=result.registry.groups.get_mut(&key).unwrap();let mut line=read_line(&mut cursor)?;
        for (key,bit,field) in [(&b"Enabled:"[..],1,0),(&b"Layer:"[..],0,1),(&b"Atlased:"[..],0x10,0),(&b"Dynamic:"[..],0x20,0),(&b"Alpha:"[..],1,2)] {
            if let Some(value)=integer(&line,key) {
                match field {1=>group.layer=value,2=>{if value!=0 {group.alpha_flags|=bit;}},_=>{if value!=0 {group.flags|=bit;}}}
                if field!=2 {line=read_line(&mut cursor)?;}
            }
        }
        result.steps.push(Step {start,consumed:cursor.position-start,accepted:true});
        if cursor.position<=start {return Err("native HUD scenes made no progress");}
    }
    result.consumed=cursor.position;Ok(result)
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn original_48_scenes_and_optional_order_flags_duplicate_updates_match_native() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_scenes_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],19);
        for case in p["cases"].as_array().unwrap() {
            let data=decode(case["input_hex"].as_str().unwrap());let actual=parse(&data,[0xa5;32]).unwrap();let label=case["label"].as_str().unwrap();
            assert_eq!(actual.consumed,case["consumed"].as_u64().unwrap() as usize,"{label}");assert_eq!(data.len()-actual.consumed,case["remaining"].as_u64().unwrap() as usize);
            assert_eq!(actual.registry.flags,case["manager_flags"].as_u64().unwrap() as u32);assert_eq!(actual.steps.len(),case["calls"].as_array().unwrap().len());
            for (step,expected) in actual.steps.iter().zip(case["calls"].as_array().unwrap()) {assert_eq!(serde_json::json!({"start":step.start,"consumed":step.consumed,"accepted":step.accepted}),*expected,"{label}");}
            assert_eq!(actual.order.len(),case["groups"].as_array().unwrap().len());
            for (id,expected) in actual.order.iter().zip(case["groups"].as_array().unwrap()) {
                let group=&actual.registry.groups[id];assert_eq!(*id,expected["hash"].as_u64().unwrap() as u32);assert_eq!(group.name_storage.to_vec(),decode(expected["name_storage_hex"].as_str().unwrap()),"{label}");
                assert_eq!(group.flags,expected["flags"].as_u64().unwrap() as u32);assert_eq!(group.layer,expected["layer"].as_u64().unwrap() as u32);assert_eq!(group.alpha_flags,expected["alpha_flags"].as_u64().unwrap() as u32);assert_eq!(vec![group.enabled_marker],decode(expected["enabled_marker"].as_str().unwrap()));assert!(!group.clock_enabled);assert_eq!(group.last_frame,0);
            }
        }
    }
}
