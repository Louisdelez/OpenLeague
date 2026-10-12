//! Native 9A5570 two-line HUD record header reader for qualified ASCII inputs.
//! Outer file loop, BaseOffset and property reading are separate.
#[derive(Debug)]
pub struct HeaderRead {pub accepted:bool,pub kind:u32,pub name_storage:[u8;32],pub consumed:usize}
fn line(data:&[u8],position:&mut usize)->Vec<u8> {
    let mut output=Vec::new();
    while *position<data.len() && output.len()<1023 {
        let c=data[*position];*position+=1;
        if c==b'\n' {break;}
        if c!=b'\r' {output.push(c);}
    }
    if let Some(nul)=output.iter().position(|v|*v==0) {output.truncate(nul);}
    output
}
fn whitespace(c:u8)->bool {c==b' ' || (9..=13).contains(&c)}
fn token<'a>(line:&'a [u8],prefix:&[u8])->Option<&'a [u8]> {
    let value=line.strip_prefix(prefix)?;let start=value.iter().position(|c|!whitespace(*c))?;
    let value=&value[start..];let end=value.iter().position(|c|whitespace(*c)).unwrap_or(value.len()).min(31);
    Some(&value[..end])
}
pub fn read(data:&[u8],initial_kind:u32,initial_name:[u8;32])->Result<HeaderRead,&'static str> {
    if !data.is_ascii() {return Err("unqualified non-ASCII native HUD header");}
    let mut out=HeaderRead {accepted:false,kind:initial_kind,name_storage:initial_name,consumed:0};
    let first=line(data,&mut out.consumed);
    let Some(value)=token(&first,b"Type:") else {return Ok(out)};
    out.kind=if value.eq_ignore_ascii_case(b"Icon") {1} else if value.eq_ignore_ascii_case(b"Effect") {2} else if value.eq_ignore_ascii_case(b"Text") {3} else {return Ok(out)};
    let second=line(data,&mut out.consumed);
    let Some(name)=token(&second,b"Name:") else {return Ok(out)};
    out.name_storage[..name.len()].copy_from_slice(name);out.name_storage[name.len()]=0;out.accepted=true;
    Ok(out)
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn all_original_source_headers_and_edges_match_native_reader() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_record_header_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["source_header_count"],703);assert_eq!(p["case_count"],722);
        for c in p["cases"].as_array().unwrap() {
            let data=decode(c["input_hex"].as_str().unwrap());let actual=read(&data,0xa5a5a5a5,[0xa5;32]).unwrap();
            assert_eq!(actual.accepted,c["accepted"].as_bool().unwrap());assert_eq!(actual.kind,c["kind"].as_u64().unwrap() as u32);
            assert_eq!(actual.name_storage.to_vec(),decode(c["name_storage_hex"].as_str().unwrap()));assert_eq!(actual.consumed,c["consumed"].as_u64().unwrap() as usize);assert_eq!(data.len()-actual.consumed,c["remaining"].as_u64().unwrap() as usize);
        }
        assert!(read(&[0xff],0,[0;32]).is_err());
    }
}
