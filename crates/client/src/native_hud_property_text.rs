//! HUD float property scanf grammar, native4.20 C locale, bounded source inputs.
//! Structural file parsing, widget visibility and pixel layout are separate.
#[derive(Clone,Copy)] pub enum Property {Anchor,Rect,Uv}
pub struct Scanned {pub values:Vec<f32>,pub assignments:i32}
fn space(b:u8)->bool {b==b' ' || (b'\t'..=b'\r').contains(&b)}
fn skip(bytes:&[u8],position:&mut usize) {while bytes.get(*position).copied().is_some_and(space) {*position+=1;}}
fn number(bytes:&[u8],position:&mut usize)->Option<f32> {
    let start=*position;
    if matches!(bytes.get(*position),Some(b'+')|Some(b'-')) {*position+=1;}
    let mut digits=0;
    while bytes.get(*position).is_some_and(u8::is_ascii_digit) {*position+=1;digits+=1;}
    if bytes.get(*position)==Some(&b'.') {*position+=1;while bytes.get(*position).is_some_and(u8::is_ascii_digit) {*position+=1;digits+=1;}}
    if digits==0 {return None;}
    let mut numeric_end=*position;
    if matches!(bytes.get(*position),Some(b'e')|Some(b'E')) {
        *position+=1;
        if matches!(bytes.get(*position),Some(b'+')|Some(b'-')) {*position+=1;}
        let exponent_start=*position;
        while bytes.get(*position).is_some_and(u8::is_ascii_digit) {*position+=1;}
        if *position>exponent_start {numeric_end=*position;}
    }
    std::str::from_utf8(&bytes[start..numeric_end]).ok()?.parse::<f32>().ok()
}
pub fn scan_pattern(bytes:&[u8],prefix:&[u8],delimiters:&[u8])->Result<Scanned,&'static str> {
    let bytes=&bytes[..bytes.iter().position(|&b|b==0).unwrap_or(bytes.len())];
    if bytes.len()>1023 || !bytes.is_ascii() {return Err("unqualified HUD numeric input length or encoding");}
    if !bytes.starts_with(prefix) {return Ok(Scanned {values:Vec::new(),assignments:0});}
    let mut position=prefix.len();let mut values=Vec::new();
    for index in 0..=delimiters.len() {
        skip(bytes,&mut position);
        let Some(value)=number(bytes,&mut position) else {let assignments=if values.is_empty() && position==bytes.len() {-1}else{values.len() as i32};return Ok(Scanned {values,assignments});};
        values.push(value);
        if index==delimiters.len() {break;}
        skip(bytes,&mut position);
        if bytes.get(position)!=Some(&delimiters[index]) {break;}
        position+=1;
    }
    let assignments=values.len() as i32;Ok(Scanned {values,assignments})
}
pub fn scan(bytes:&[u8],property:Property)->Result<Scanned,&'static str> {let delimiters:&[u8]=match property {Property::Anchor=>b",",Property::Rect|Property::Uv=>b",-,/x"};scan_pattern(bytes,b"",delimiters)}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_source_values_and_listed_edges_match_original_scanner_and_handlers() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_property_text_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1147);
        for c in p["cases"].as_array().unwrap() {
            let bytes:Vec<u8>=c["text_bytes"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();
            let property=match c["property"].as_str().unwrap() {"Anchor"=>Property::Anchor,"Rect"=>Property::Rect,"UV"=>Property::Uv,_=>unreachable!()};
            let scanned=scan(&bytes,property).unwrap();assert_eq!(scanned.assignments,c["scanner_assignments"].as_i64().unwrap() as i32,"{} {:?}",c["property"],bytes);
            let floats=|key:&str|c[key].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect::<Vec<_>>();
            let initial=floats("initial_bits");let mut anchor=[initial[0],initial[1]];let mut cached=[initial[2],initial[3]];let mut rect=[initial[0],initial[1],initial[2],initial[3]];let mut uv1=[rect;2];let mut uv2=uv1;let origin=floats("origin_bits");
            let result=match property {Property::Anchor=>crate::native_hud_anchor::apply(&scanned.values,scanned.assignments,&mut anchor,&mut cached),Property::Rect=>crate::native_hud_rect::apply(&scanned.values,scanned.assignments,[origin[0],origin[1]],&mut rect),Property::Uv=>crate::native_hud_uv::apply(c["element_type"].as_u64().unwrap() as u32,&scanned.values,scanned.assignments,&mut uv1,&mut uv2)};
            assert_eq!(result,c["result"].as_u64().unwrap() as u32,"{} {:?}",c["property"],bytes);
            let anchor=[anchor[0],anchor[1],cached[0],cached[1]];
            for (out,key) in [(anchor.to_vec(),"anchor_bits"),(rect.to_vec(),"rect_bits"),(uv1.into_iter().flatten().collect(),"type1_uv_bits"),(uv2.into_iter().flatten().collect(),"type2_uv_bits")] {assert_eq!(out.into_iter().map(f32::to_bits).collect::<Vec<_>>(),c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>(),"{} {:?} {key}",c["property"],bytes);}
        }
    }
}
