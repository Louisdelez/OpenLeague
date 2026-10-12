//! Qualified native31byte string property callbacks.
use crate::native_hud_element_storage::ElementStorage;
use crate::native_hud_integer_properties::Applied;
fn space(c:u8)->bool {c==32 || (9..=13).contains(&c)}
pub fn apply(element:&mut ElementStorage,property:&str,value:&[u8])->Result<Option<Applied>,&'static str> {
    let (offset,eligible,mask,scanset)=match property {
        "Group"=>(0x20,true,2,false),
        "Texture"=>(if element.kind()==2 {0x21c}else {0x1e0},matches!(element.kind(),1|2),0x20,false),
        "Effect"=>(0x1e0,element.kind()==2,0x80,true),
        "Font"=>(0x1e0,element.kind()==3,0x800,true),
        "EffectTexture0"=>(0x23c,element.kind()==2,1,false),_=>return Ok(None),
    };
    if !value.is_ascii() || value.len()>1023 {return Err("unqualified native HUD string text");}
    let value=&value[..value.iter().position(|c|*c==0).unwrap_or(value.len())];
    let start=value.iter().position(|c|!space(*c)).unwrap_or(value.len());let value=&value[start..];
    let end=value.iter().position(|c|if scanset {*c==10}else {space(*c)}).unwrap_or(value.len()).min(31);
    if !eligible || end==0 {return Ok(Some(Applied {result:0,warnings:1}));}
    element.write_bytes(offset,&value[..end]);element.write_bytes(offset+end,&[0]);
    Ok(Some(Applied {result:mask,warnings:0}))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_source_string_values_and_field_boundaries_match_native_callbacks() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_string_properties_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1200);
        for c in p["cases"].as_array().unwrap() {
            let kind=c["kind"].as_u64().unwrap() as u32;let mut element=ElementStorage::new(kind).unwrap();let size=element.bytes().len();let prefill=c["prefill"].as_u64().unwrap() as u8;
            element.write_bytes(0,&vec![prefill;size]);element.set_word(0x40,kind);let mut expected=element.bytes().to_vec();
            let actual=apply(&mut element,c["property"].as_str().unwrap(),c["value"].as_str().unwrap().as_bytes()).unwrap().unwrap();
            assert_eq!(actual.result,c["result"].as_u64().unwrap() as u32);assert_eq!(actual.warnings,c["warnings"].as_u64().unwrap() as usize);
            if actual.result!=0 {
                let offset=c["field_offset"].as_u64().unwrap() as usize;let hex=c["field_storage_hex"].as_str().unwrap();let bytes=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();expected[offset..offset+32].copy_from_slice(&bytes);
            }
            assert_eq!(element.bytes(),expected);
        }
    }
}
