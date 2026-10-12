//! Native Text post-load request selection. Manager default is supplied explicitly.
//! Font allocation, GPU glyphs and removal lifecycle are separate.
use crate::native_hud_element_storage::ElementStorage;
#[derive(Debug,PartialEq)] pub struct Request {pub name:Vec<u8>,pub size:u32,pub shadow:bool}
pub enum Resolution<T> {Resolved(T),RemoveElement}
pub fn request(storage:&ElementStorage,manager_default:Option<&[u8]>)->Result<Request,&'static str> {
    if storage.kind()!=3 {return Err("font request requires native Text element");}
    let raw=&storage.bytes()[0x1e0..0x200];let name=manager_default.unwrap_or(&raw[..raw.iter().position(|v|*v==0).unwrap_or(raw.len())]);
    if name.contains(&0) {return Err("font request requires terminated-name contents");}
    Ok(Request {name:name.to_vec(),size:storage.word(0x204),shadow:storage.flags()&0x10!=0})
}
pub fn resolve<T>(request:&Request,supplier:impl FnOnce(&Request)->Option<T>)->Resolution<T> {
    match supplier(request) {Some(handle)=>Resolution::Resolved(handle),None=>Resolution::RemoveElement}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_924_native_text_font_requests_and_failure_routes_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_font_selection_contract.json")).unwrap();
        let files:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_file_loop_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],924);
        for c in proof["cases"].as_array().unwrap() {
            let f=files["cases"].as_array().unwrap().iter().filter(|f|f["path"]==c["path"]).max_by_key(|f|f["variant"]=="restored").unwrap();
            let r=f["accepted"].as_array().unwrap().iter().find(|r|r["name"]==c["name"]).unwrap();let hex=r["output_hex"].as_str().unwrap();
            let bytes=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();let mut storage=ElementStorage::new(3).unwrap();storage.write_bytes(0,&bytes);
            let default=match c["profile"].as_str().unwrap(){"inline"=>Some(b"FontA".as_slice()),"heap"=>Some(b"FontB".as_slice()),"heap_null"=>None,_=>panic!("unqualified font profile")};
            let req=request(&storage,default).unwrap();let expected=&c["request"];let name=expected["name_hex"].as_str().unwrap();let name=(0..name.len()).step_by(2).map(|i|u8::from_str_radix(&name[i..i+2],16).unwrap()).collect::<Vec<_>>();
            assert_eq!(req,Request {name,size:expected["size"].as_u64().unwrap() as u32,shadow:expected["shadow"]==1});
            let result=resolve(&req,|_|c["success"].as_bool().unwrap().then_some(1u32));
            assert_eq!(matches!(result,Resolution::RemoveElement),c["element_removed"].as_bool().unwrap());
        }
    }
}
