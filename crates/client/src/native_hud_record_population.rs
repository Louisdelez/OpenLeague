//! Qualified per-record population; outer file loop/owner and resource handles are separate.
use crate::{native_hud_named_element::{self,NamedElement},native_hud_property_driver::{self,Cursor},native_hud_property_apply,native_hud_record_header,native_hud_uv_flips};
pub struct PopulatedRecord {pub element:NamedElement,pub accepted:bool,pub consumed:usize,pub warnings:usize}
pub fn parse_record(data:&[u8],origin:[f32;2],aspect:f32)->Result<PopulatedRecord,&'static str> {
    let header=native_hud_record_header::read(data,0,[0xa5;32])?;
    if !header.accepted {return Err("invalid native HUD record header");}
    let name_end=header.name_storage.iter().position(|c|*c==0).unwrap_or(32);let mut element=native_hud_named_element::create(header.kind,&header.name_storage[..name_end])?;
    element.storage.set_word(0x1d8,aspect.to_bits());let mut cursor=Cursor {data,position:header.consumed};let mut failure=None;let mut warnings=0;
    let result=native_hud_property_driver::drive(&mut cursor,header.kind,|key,value,cursor| {
        let key=match std::str::from_utf8(key) {Ok(v)=>v,Err(_)=>{failure=Some("unqualified HUD key");return Some(0);}};
        match native_hud_property_apply::apply_with_cursor(&mut element.storage,key,value,origin,cursor) {
            Ok(Some(v))=>{warnings+=v.warnings;Some(v.result)},Ok(None)=>None,Err(e)=>{failure=Some(e);Some(0)}
        }
    })?;
    if let Some(e)=failure {return Err(e);}
    if result.accepted {native_hud_uv_flips::apply(&mut element.storage)?;}
    warnings+=result.diagnostics.len();Ok(PopulatedRecord {element,accepted:result.accepted,consumed:cursor.position,warnings})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_703_source_records_match_original_header_factory_callbacks_validation_and_flips() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_source_records_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],703);
        let decode=|s:&str|(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect::<Vec<_>>();
        let files=p["source_files"].as_array().unwrap().iter().map(|f|(f["path"].as_str().unwrap().to_owned(),decode(f["input_hex"].as_str().unwrap()))).collect::<std::collections::BTreeMap<_,_>>();
        for c in p["cases"].as_array().unwrap() {
            let path=c["path"].as_str().unwrap();let data=&files[path][c["offset"].as_u64().unwrap() as usize..];let origin=c["origin_bits"].as_array().unwrap();
            let actual=parse_record(data,[f32::from_bits(origin[0].as_u64().unwrap() as u32),f32::from_bits(origin[1].as_u64().unwrap() as u32)],f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32)).unwrap();
            assert_eq!(actual.accepted,c["accepted"].as_bool().unwrap(),"{path}@{}",c["offset"]);assert_eq!(actual.consumed,c["consumed"].as_u64().unwrap() as usize);assert_eq!(actual.warnings,c["warnings"].as_u64().unwrap() as usize,"{path}@{}",c["offset"]);assert_eq!(actual.element.storage.bytes(),decode(c["output_hex"].as_str().unwrap()),"{path}@{}",c["offset"]);
        }
    }
}
