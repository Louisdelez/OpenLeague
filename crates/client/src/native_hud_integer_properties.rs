//! Qualified integer HUD property callbacks; native scanf decimal prefix semantics.
use crate::native_hud_element_storage::ElementStorage;
pub struct Applied {pub result:u32,pub warnings:usize}
pub(crate) fn decimal_prefix(value:&[u8])->Option<u32> {
    let value=&value[..value.iter().position(|c|*c==0).unwrap_or(value.len())];
    let mut i=0;while i<value.len() && (value[i]==32 || (9..=13).contains(&value[i])) {i+=1;}
    let negative=i<value.len() && value[i]==b'-';
    if i<value.len() && (value[i]==b'+' || value[i]==b'-') {i+=1;}
    let start=i;let mut number=0u32;
    while i<value.len() && value[i].is_ascii_digit() {number=number.wrapping_mul(10).wrapping_add((value[i]-b'0') as u32);i+=1;}
    if i==start {None} else {Some(if negative {number.wrapping_neg()} else {number})}
}
pub fn apply(element:&mut ElementStorage,property:&str,value:&[u8])->Result<Option<Applied>,&'static str> {
    let (bit,eligible,field,mask)=match property {
        "Enabled"=>(1,true,0x48,1),"AlwaysRespond"=>(4,true,0x48,1),"Draggable"=>(8,true,0x48,1),
        "KeepMaxScale"=>(0x80,true,0x48,1),"AutoRect"=>(0x200,true,0x48,1),"NoPixelSnappingX"=>(0x1000,true,0x48,1),
        "Alpha"=>(1,element.kind()==1,0x224,1),"DropShadow"=>(0x10,element.kind()==3,0x48,1),
        "FlipX"=>(0x400,matches!(element.kind(),1|2),0x48,1),"FlipY"=>(0x800,matches!(element.kind(),1|2),0x48,1),
        "Layer"=>(0,true,0x1a4,4),"Size"=>(0,element.kind()==3,0x204,0x1000),_=>return Ok(None),
    };
    if !value.is_ascii() || value.len()>1023 {return Err("unqualified native HUD integer text");}
    let Some(number)=decimal_prefix(value).filter(|_|eligible) else {return Ok(Some(Applied {result:0,warnings:1}))};
    if bit==0 {element.set_word(field,number);} else if number!=0 {element.set_word(field,element.word(field)|bit);}
    Ok(Some(Applied {result:mask,warnings:0}))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_integer_source_values_types_flags_and_edge_inputs_match_native_handlers() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_integer_properties_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1476);assert_eq!(p["property_count"],12);
        for c in p["cases"].as_array().unwrap() {
            let mut element=ElementStorage::new(c["kind"].as_u64().unwrap() as u32).unwrap();
            for (offset,value) in [(0x48,c["initial_flags"].as_u64().unwrap() as u32),(0x224,0x80),(0x1a4,0xa5a5a5a5),(0x204,0xa5a5a5a5)] {element.set_word(offset,value);}
            let mut expected=element.bytes().to_vec();
            let actual=apply(&mut element,c["property"].as_str().unwrap(),c["value"].as_str().unwrap().as_bytes()).unwrap().unwrap();
            assert_eq!(actual.result,c["result"].as_u64().unwrap() as u32);assert_eq!(actual.warnings,c["warnings"].as_u64().unwrap() as usize);
            for (field,offset) in [("output_flags",0x48),("output_icon_flags",0x224),("output_layer",0x1a4),("output_size",0x204)] {
                let value=c[field].as_u64().unwrap() as u32;expected[offset..offset+4].copy_from_slice(&value.to_le_bytes());
            }
            assert_eq!(element.bytes(),expected,"{}:{} kind{}",c["property"],c["value"],c["kind"]);
        }
    }
}
