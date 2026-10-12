//! Connect qualified callbacks to native element field storage.
//! Remaining registered properties are explicit errors until qualified.
use crate::{native_hud_element_storage::ElementStorage,native_hud_integer_properties::Applied,native_hud_property_text::{self,Property}};
fn floats<const N:usize>(element:&ElementStorage,offset:usize)->[f32;N] {std::array::from_fn(|i|f32::from_bits(element.word(offset+i*4)))}
fn store(element:&mut ElementStorage,offset:usize,values:&[f32]) {for (i,v) in values.iter().enumerate() {element.set_word(offset+i*4,v.to_bits());}}
pub fn apply(element:&mut ElementStorage,key:&str,value:&[u8],origin:[f32;2])->Result<Option<Applied>,&'static str> {
    if let Some(out)=crate::native_hud_integer_properties::apply(element,key,value)? {return Ok(Some(out));}
    if let Some(out)=crate::native_hud_string_properties::apply(element,key,value)? {return Ok(Some(out));}
    let property=match key {
        "Anchor"=>Property::Anchor,"Rect"=>Property::Rect,"UV"=>Property::Uv,
        "LeftAnchor"|"MinUV"=>return Err("native HUD property requires following-line cursor"),
        "Color"|"PerPixelUVsX"|"EffectParams0"|"EffectColor0"|"EffectColor1"|"Align"=>{let mut cursor=crate::native_hud_property_driver::Cursor {data:&[],position:0};return crate::native_hud_remaining_properties::apply(element,key,value,&mut cursor);},
        _=>return Ok(None),
    };
    if matches!(property,Property::Uv) && !matches!(element.kind(),1|2) {return Ok(Some(Applied {result:0,warnings:1}));}
    let scan=native_hud_property_text::scan(value,property)?;
    let result=match property {
        Property::Anchor=>{
            let mut current=floats::<2>(element,0x1a8);let mut cached=floats::<2>(element,0x1b0);
            let r=crate::native_hud_anchor::apply(&scan.values,scan.assignments,&mut current,&mut cached);store(element,0x1a8,&current);store(element,0x1b0,&cached);r
        },
        Property::Rect=>{
            let mut rect=floats::<4>(element,0x1c0);let r=crate::native_hud_rect::apply(&scan.values,scan.assignments,origin,&mut rect);store(element,0x1c0,&rect);r
        },
        Property::Uv=>{
            let offset=if element.kind()==1 {0x204}else {0x264};let initial=[floats::<4>(element,offset),floats::<4>(element,offset+16)];let mut a=initial;let mut b=initial;
            let r=crate::native_hud_uv::apply(element.kind(),&scan.values,scan.assignments,&mut a,&mut b);let out=if element.kind()==1 {a}else {b};store(element,offset,&out[0]);store(element,offset+16,&out[1]);r
        }
    };
    Ok(Some(Applied {result,warnings:usize::from(result==0)}))
}
pub fn apply_with_cursor(element:&mut ElementStorage,key:&str,value:&[u8],origin:[f32;2],cursor:&mut crate::native_hud_property_driver::Cursor<'_>)->Result<Option<Applied>, &'static str> {if let Some(out)=crate::native_hud_remaining_properties::apply(element,key,value,cursor)? {return Ok(Some(out));}apply(element,key,value,origin)}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn numeric_scanners_and_field_application_match_all_native_callbacks() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_property_text_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1147);
        for c in p["cases"].as_array().unwrap() {
            let kind=c["element_type"].as_u64().unwrap() as u32;let mut element=ElementStorage::new(kind).unwrap();
            let initial=c["initial_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
            for offset in [0x1a8,0x1c0,if kind==1 {0x204}else {0x264},if kind==1 {0x214}else {0x274}] {for (i,v) in initial.iter().enumerate() {element.set_word(offset+i*4,*v);}}
            let bytes=c["text_bytes"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();let origin=c["origin_bits"].as_array().unwrap();
            let actual=apply(&mut element,c["property"].as_str().unwrap(),&bytes,[f32::from_bits(origin[0].as_u64().unwrap() as u32),f32::from_bits(origin[1].as_u64().unwrap() as u32)]).unwrap().unwrap();
            assert_eq!(actual.result,c["result"].as_u64().unwrap() as u32);assert_eq!(actual.warnings,c["warnings"].as_u64().unwrap() as usize);
            for (key,offset,count) in [("anchor_bits",0x1a8,4),("rect_bits",0x1c0,4),(if kind==1 {"type1_uv_bits"}else {"type2_uv_bits"},if kind==1 {0x204}else {0x264},8)] {
                let got=(0..count).map(|i|element.word(offset+i*4)).collect::<Vec<_>>();let expected=c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();assert_eq!(got,expected);
            }
        }
    }
}
