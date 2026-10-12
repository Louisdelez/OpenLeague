//! Native 9A1A60 property driver control flow with supplied property callbacks.
//! Registry, callback semantics, post-validation UV flips and drawing are separate.
pub struct Cursor<'a> {pub data:&'a [u8],pub position:usize}
pub struct DriverResult {pub accepted:bool,pub accumulated:u32,pub diagnostics:Vec<Vec<u8>>}
pub fn read_line(cursor:&mut Cursor<'_>)->Result<Vec<u8>, &'static str> {
    if cursor.position>cursor.data.len() || !cursor.data.is_ascii() {return Err("unqualified HUD cursor");}
    let mut out=Vec::new();
    while cursor.position<cursor.data.len() && out.len()<1023 {
        let c=cursor.data[cursor.position];cursor.position+=1;
        if c==10 {break;}
        if c!=13 {out.push(c);}
    }
    if let Some(nul)=out.iter().position(|v|*v==0) {out.truncate(nul);}
    Ok(out)
}
pub fn drive<F>(cursor:&mut Cursor<'_>,kind:u32,mut callback:F)->Result<DriverResult,&'static str>
where F:FnMut(&[u8],&[u8],&mut Cursor<'_>)->Option<u32> {
    let required=match kind {1=>0x7e,2=>0x79e,3=>0x381e,_=>return Err("unsupported native HUD property kind")};
    if cursor.position>cursor.data.len() || !cursor.data.is_ascii() {return Err("unqualified native HUD input");}
    let mut accumulated=0;let mut last=0;let mut diagnostics=Vec::new();
    while cursor.position<cursor.data.len() {
        let start=cursor.position;let bytes=read_line(cursor)?;
        let first=bytes.iter().position(|c|*c!=b':').unwrap_or(bytes.len());
        let delimiter=bytes[first..].iter().position(|c|*c==b':').map(|i|i+first);
        let (key,value)=if let Some(n)=delimiter {(&bytes[..n],&bytes[n+1..])} else {(bytes.as_slice(),&[][..])};
        if let Some(result)=callback(key,value,cursor) {
            last=result;if result!=1 {accumulated|=result;}
            if cursor.position>cursor.data.len() {return Err("HUD callback moved beyond input");}
            if result!=0 {continue;}
        } else if bytes.starts_with(b"/") {
            if last!=0 {continue;}
        } else if key!=b"Type" {diagnostics.push(key.to_vec());}
        cursor.position=start;break;
    }
    Ok(DriverResult {accepted:accumulated&required==required,accumulated,diagnostics})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_property_order_masks_comments_and_rewind_match_native_driver() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_property_driver_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],216);
        for c in p["cases"].as_array().unwrap() {
            let hex=c["input_hex"].as_str().unwrap();let data=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
            let mut cursor=Cursor {data:&data,position:0};let mut events=Vec::new();
            let actual=drive(&mut cursor,c["kind"].as_u64().unwrap() as u32,|key,value,_| {
                let key=std::str::from_utf8(key).unwrap();let result=c["callback_results"][key].as_u64().map(|v|v as u32);
                let mut event=serde_json::json!({"key":key,"found":result.is_some()});
                if let Some(v)=result {event["value"]=std::str::from_utf8(value).unwrap().into();event["callback_result"]=v.into();}
                events.push(event);result
            }).unwrap();
            assert_eq!(actual.accepted,c["accepted"].as_bool().unwrap());assert_eq!(cursor.position,c["consumed"].as_u64().unwrap() as usize);assert_eq!(events,c["events"].as_array().unwrap().to_vec());assert_eq!(actual.diagnostics.len(),c["diagnostics"].as_u64().unwrap() as usize);
        }
    }
}
