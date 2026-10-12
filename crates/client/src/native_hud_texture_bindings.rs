//! Owned texture-entry references for native Icon/Effect post-load assignment.
//! IDs replace original pointers; they identify pending entries, not GPU textures.
use crate::{native_hud_element_storage::ElementStorage,native_hud_textures::Registry};
#[derive(Default,Debug,PartialEq)] pub struct Bindings {pub icon:Option<u32>,pub primary:Option<u32>,pub extra:Option<u32>}
fn name(storage:&ElementStorage,offset:usize)->&[u8] {
    let raw=&storage.bytes()[offset..offset+32];&raw[..raw.iter().position(|v|*v==0).unwrap_or(32)]
}
pub fn bind(storage:&ElementStorage,textures:&mut Registry)->Result<Bindings,&'static str> {
    match storage.kind() {
        1=>Ok(Bindings {icon:Some(textures.request(name(storage,0x1e0))?),..Default::default()}),
        2=> {
            let primary=name(storage,0x21c);let extra=name(storage,0x23c);
            Ok(Bindings {icon:None,primary:if primary.is_empty(){None}else{Some(textures.request(primary)?)},extra:if extra.is_empty(){None}else{Some(textures.request(extra)?)}})
        }
        3=>Ok(Bindings::default()),
        _=>Err("unqualified HUD texture binding kind"),
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_549_native_source_texture_binding_branches_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_texture_bindings_contract.json")).unwrap();
        let files:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_file_loop_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],549);
        let mut registry=Registry::default();
        for c in proof["cases"].as_array().unwrap() {
            let file=files["cases"].as_array().unwrap().iter().filter(|f|f["path"]==c["path"]).max_by_key(|f|f["variant"]=="restored").unwrap();
            let record=file["accepted"].as_array().unwrap().iter().find(|r|r["name"]==c["name"]).unwrap();
            let hex=record["output_hex"].as_str().unwrap();let bytes=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
            let mut storage=ElementStorage::new(c["kind"].as_u64().unwrap() as u32).unwrap();storage.write_bytes(0,&bytes);
            let bound=bind(&storage,&mut registry).unwrap();
            for slot in c["bindings"].as_array().unwrap() {
                let actual=match slot["slot"].as_u64().unwrap() {0x200=>bound.icon,0x25c=>bound.primary,0x260=>bound.extra,_=>panic!("unexpected native slot")};
                let hex=slot["name_hex"].as_str().unwrap();let name=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
                assert_eq!(actual,slot["requested"].as_bool().unwrap().then(||crate::native_hud_named_element::hash(&name)));
            }
        }
        assert_eq!(registry.entries.len(),84);
    }
}
