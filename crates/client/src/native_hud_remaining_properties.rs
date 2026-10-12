//! Eight original HUD callbacks, including callbacks consuming the following line.
use crate::{native_hud_element_storage::ElementStorage,native_hud_integer_properties::{Applied,decimal_prefix},native_hud_property_driver::{Cursor,read_line},native_hud_property_text::scan_pattern};
fn space(c:u8)->bool {c==32 || (9..=13).contains(&c)}
fn unsigned_quad(value:&[u8])->Vec<u32> {
    let value=&value[..value.iter().position(|c|*c==0).unwrap_or(value.len())];let mut pos=0;let mut out=Vec::new();
    for _ in 0..4 {
        while pos<value.len() && space(value[pos]) {pos+=1;}
        let Some(n)=decimal_prefix(&value[pos..]) else {break;};out.push(n);
        if pos<value.len() && matches!(value[pos],b'+'|b'-') {pos+=1;}
        while pos<value.len() && value[pos].is_ascii_digit() {pos+=1;}
        while pos<value.len() && space(value[pos]) {pos+=1;}
        if value.get(pos)!=Some(&b',') {break;}pos+=1;
    }
    out
}
fn write_floats(element:&mut ElementStorage,offset:usize,v:&[f32]) {for (i,x) in v.iter().enumerate() {element.set_word(offset+i*4,x.to_bits());}}
fn normalized(v:&[f32],count:i32)->[f32;4] {
    let mut quad=[v[0],v[1],v[2],v[3]];
    if count==6 {let x=1.0/v[4];let y=1.0/v[5];quad=[x*v[0],y*v[1],x*v[2],y*v[3]];}
    quad
}
pub fn apply(element:&mut ElementStorage,key:&str,value:&[u8],cursor:&mut Cursor<'_>)->Result<Option<Applied>,&'static str> {
    if !matches!(key,"LeftAnchor"|"Color"|"PerPixelUVsX"|"MinUV"|"EffectParams0"|"EffectColor0"|"EffectColor1"|"Align") {return Ok(None);}
    if !value.is_ascii() || value.len()>1023 {return Err("unqualified native HUD property text");}
    let eligible=match key {"PerPixelUVsX"|"MinUV"=>matches!(element.kind(),1|2),"EffectParams0"|"EffectColor0"|"EffectColor1"=>element.kind()==2,"Align"=>element.kind()==3,_=>true};
    if !eligible {return Ok(Some(Applied {result:0,warnings:1}));}
    let mut result=0;let mut warnings=0;
    match key {
        "Color"|"EffectColor0"|"EffectColor1"=>{
            let v=unsigned_quad(value);
            if v.len()==4 {
                let offset=match key {"Color"=>0x1dc,"EffectColor0"=>0x214,_=>0x218};element.write_bytes(offset,&[v[2] as u8,v[1] as u8,v[0] as u8,v[3] as u8]);
                result=match key {"Color"=>1,"EffectColor0"=>0x200,_=>0x400};
            } else {warnings=1;}
        },
        "PerPixelUVsX"=>{
            if let Some(n)=decimal_prefix(value) {if n!=0 {element.set_word(0x48,element.flags()|0x40);}result=1;} else {warnings=1;}
        },
        "EffectParams0"=>{
            let scan=scan_pattern(value,b"",b",,,")?;write_floats(element,0x204,&scan.values);
            if scan.assignments==4 {result=0x100;} else {warnings=1;}
        },
        "Align"=>{
            let v=&value[..value.iter().position(|c|*c==0).unwrap_or(value.len())];let start=v.iter().position(|c|!space(*c)).unwrap_or(v.len());let v=&v[start..];let end=v.iter().position(|c|space(*c)).unwrap_or(v.len()).min(6);let token=&v[..end];
            let index=if token.eq_ignore_ascii_case(b"Left") {Some(0)} else if token.eq_ignore_ascii_case(b"Center") {Some(1)} else if token.eq_ignore_ascii_case(b"Right") {Some(2)} else {None};
            if let Some(index)=index {element.set_word(0x208,index);result=0x2000;} else {warnings=1;}
        },
        "LeftAnchor"=>{
            let scan=scan_pattern(value,b"",b",")?;write_floats(element,0x1a8,&scan.values);
            if scan.assignments==2 {
                let following=read_line(cursor)?;let scan=scan_pattern(&following,b"RightAnchor:",b",")?;write_floats(element,0x1b0,&scan.values);
                if scan.assignments==2 {result=8;}
            } else {warnings=1;}
        },
        "MinUV"=>{
            let scan=scan_pattern(value,b"",b",-,/x")?;
            if matches!(scan.assignments,4|6) {
                let offset=if element.kind()==1 {0x204}else {0x264};write_floats(element,offset,&normalized(&scan.values,scan.assignments));
                let following=read_line(cursor)?;let scan=scan_pattern(&following,b"MaxUV:",b",-,/x")?;
                if scan.assignments>=4 {write_floats(element,offset+16,&normalized(&scan.values,scan.assignments));result=64;}
            } else {warnings=1;}
        },_=>unreachable!()
    }
    Ok(Some(Applied {result,warnings}))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn eight_remaining_callbacks_match_native_fields_partial_writes_and_stream_consumption() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_remaining_callbacks_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],450);
        for c in p["cases"].as_array().unwrap() {
            let kind=c["kind"].as_u64().unwrap() as u32;let mut element=ElementStorage::new(kind).unwrap();let size=element.bytes().len();element.write_bytes(0,&vec![0xa5;size]);element.set_word(0x40,kind);
            let data=c["following"].as_str().unwrap().as_bytes();let mut cursor=Cursor {data,position:0};
            let actual=apply(&mut element,c["property"].as_str().unwrap(),c["value"].as_str().unwrap().as_bytes(),&mut cursor).unwrap().unwrap();
            assert_eq!(actual.result,c["result"].as_u64().unwrap() as u32,"{}:{} kind{}",c["property"],c["value"],kind);assert_eq!(actual.warnings,c["warnings"].as_u64().unwrap() as usize);assert_eq!(cursor.position,c["consumed"].as_u64().unwrap() as usize);
            let hex=c["output_hex"].as_str().unwrap();let expected=(0..size*2).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();assert_eq!(element.bytes(),expected,"{}:{} kind{}",c["property"],c["value"],kind);
        }
    }
}
