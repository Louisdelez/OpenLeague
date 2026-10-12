//! Original8C0BE0 glyph cell metadata and8BF600 simple UTF16 measurement.
//! Rich layout, draw placement, native allocation and atlas packing remain separate.
use crate::native_glyph::NativeMetrics;
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Node {pub character_utf16:u16,pub width:i32,pub height:i32,pub advance:i32}
pub fn node(character:u16,metrics:&NativeMetrics,extra:u32,flags:u32)->Node {
    let pad=extra.wrapping_mul(2) as i32;let shadow=if flags&4!=0 {16}else{0};let outline=if flags&2!=0 {2}else{0};
    Node {character_utf16:character,width:metrics.width.wrapping_add(1).wrapping_add(pad).wrapping_add(shadow).wrapping_add(outline),height:metrics.bottom.wrapping_add(pad).wrapping_add(shadow),advance:metrics.advance.wrapping_add(pad)}
}
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Measurement {pub success:bool,pub width:i32,pub height:i32}
pub fn measure(text:Option<&[u16]>,space_character:u16,space_advance:i32,line_height:i32,mut glyph:impl FnMut(u16)->Option<i32>)->Measurement {
    let empty=Measurement {success:true,width:0,height:0};let Some(text)=text else {return empty};
    if text.first().is_none_or(|c|*c==0) {return empty}
    let mut width=0i32;
    for &character in text.iter().take_while(|c|**c!=0) {
        let advance=if character==space_character {space_advance}else {
            let Some(value)=glyph(character) else {return Measurement {success:false,width:0,height:0}};value
        };
        width=width.wrapping_add(advance);
    }
    Measurement {success:true,width,height:line_height}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn node_metadata_matches384_original_constructors() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_glyph_node_metrics_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);
        for c in p["cases"].as_array().unwrap() {
            let metrics=NativeMetrics {advance:c["advance"].as_i64().unwrap() as i32,bearing_x:0,width:c["width"].as_i64().unwrap() as i32,bottom:c["bottom"].as_i64().unwrap() as i32};
            let flags=if c["shadow"].as_bool().unwrap(){4}else{0}|if c["outline"].as_bool().unwrap(){2}else{0};
            let actual=node(c["character_utf16"].as_u64().unwrap() as u16,&metrics,c["extra"].as_u64().unwrap() as u32,flags);
            assert_eq!((actual.width,actual.height,actual.advance),(c["node_width"].as_i64().unwrap() as i32,c["node_height"].as_i64().unwrap() as i32,c["node_advance"].as_i64().unwrap() as i32));
        }
    }
    #[test] fn measure_dimensions_calls_and_failures_match864_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_simple_text_measure_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],864);
        for c in p["cases"].as_array().unwrap() {
            let text=c["text_utf16"].as_array().map(|a|a.iter().map(|n|n.as_u64().unwrap() as u16).collect::<Vec<_>>());let mut calls=Vec::new();let fail=c["failed_character_utf16"].as_u64().map(|n|n as u16);
            let actual=measure(text.as_deref(),32,c["space_advance"].as_i64().unwrap() as i32,c["line_height"].as_i64().unwrap() as i32,|character|{calls.push(character);if fail==Some(character){None}else{Some(match c["metric_profile"].as_str().unwrap(){"normal"=>(character%13+1) as i32,"negative"=>-3,"overflow"=>i32::MAX,_=>panic!("unknown profile")})}});
            assert_eq!(actual,Measurement {success:c["success"].as_bool().unwrap(),width:c["width"].as_i64().unwrap() as i32,height:c["height"].as_i64().unwrap() as i32});
            assert_eq!(calls,c["calls"].as_array().unwrap().iter().map(|n|n["character_utf16"].as_u64().unwrap() as u16).collect::<Vec<_>>());
        }
    }
}
