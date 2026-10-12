//! Native named element initialization from9A52A0, with separately owned registry/lists.
use crate::native_hud_element_storage::ElementStorage;
pub struct NamedElement {pub storage:ElementStorage,pub effect_list_member:bool}
pub(crate) fn hash(name:&[u8])->u32 {
    let mut value=0u32;
    for c in name {value=value.wrapping_shl(4).wrapping_add(c.to_ascii_lowercase() as u32);let high=value&0xf0000000;if high!=0 {value^=high^(high>>24);}}
    value
}
pub fn create(kind:u32,name:&[u8])->Result<NamedElement,&'static str> {
    if name.len()>31 || !name.is_ascii() || name.contains(&0) {return Err("unqualified native HUD element name");}
    let mut storage=ElementStorage::new(kind)?;storage.write_bytes(0,name);storage.write_bytes(name.len(),&[0]);storage.set_word(0x44,hash(name));
    if kind==2 {storage.set_word(0x48,storage.flags()|0x100);}
    Ok(NamedElement {storage,effect_list_member:kind==2})
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_source_named_elements_match_native_factory_hash_copy_and_list_classification() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_named_creation_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],721);assert_eq!(p["source_case_count"],703);
        let decode=|s:&str|(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect::<Vec<_>>();
        for c in p["cases"].as_array().unwrap() {
            let name=decode(c["name_hex"].as_str().unwrap());let actual=create(c["kind"].as_u64().unwrap() as u32,&name).unwrap();
            assert_eq!(actual.storage.bytes(),decode(c["output_hex"].as_str().unwrap()));assert_eq!(actual.storage.word(0x44),c["name_hash"].as_u64().unwrap() as u32);assert_eq!(actual.effect_list_member,c["effect_list_count"].as_u64().unwrap()==1);
        }
        for bad in [&[0xff][..],&[0][..],&[b'a';32][..]] {assert!(create(1,bad).is_err());}
    }
}
