//! Native named texture cache and creation fields, independent from GPU loading.
use std::collections::BTreeMap;
pub struct Entry {pub storage:[u8;0x38],pub descriptor_name:[u8;32]}
impl Entry {
    pub fn create(name:&[u8],mut storage:[u8;0x38],mut descriptor_name:[u8;32])->Result<Self,&'static str> {
        if !name.is_ascii() || name.len()>31 || name.contains(&0) {return Err("unqualified HUD texture name");}
        storage[..name.len()].copy_from_slice(name);storage[name.len()]=0;
        descriptor_name[..name.len()].copy_from_slice(name);descriptor_name[name.len()]=0;
        storage[0x20..0x24].fill(0);
        storage[0x24..0x28].copy_from_slice(&crate::native_hud_named_element::hash(name).to_le_bytes());
        storage[0x34]=0;
        Ok(Self {storage,descriptor_name})
    }
}
#[derive(Default)] pub struct Registry {pub entries:BTreeMap<u32,Entry>}
impl Registry {
    pub fn request(&mut self,name:&[u8])->Result<u32,&'static str> {
        if !name.is_ascii() || name.len()>31 || name.contains(&0) {return Err("unqualified HUD texture name");}
        let id=crate::native_hud_named_element::hash(name);
        // Original hash-hit ignores name comparison result; entry remains unchanged.
        if let std::collections::btree_map::Entry::Vacant(slot)=self.entries.entry(id) {
            // OpenLeague supplies zeroed allocation storage; native pool lifecycle is separate.
            slot.insert(Entry::create(name,[0;0x38],[0;32])?);
        }
        Ok(id)
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_176_creation_and_172_cache_cases_match() {
        let creation:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_texture_creation_contract.json")).unwrap();
        assert_eq!(creation["passed"],true);assert_eq!(creation["case_count"],176);
        let decode=|s:&str|(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect::<Vec<_>>();
        for c in creation["cases"].as_array().unwrap() {
            let p=c["prefill"].as_u64().unwrap() as u8;
            let e=Entry::create(&decode(c["name_hex"].as_str().unwrap()),[p;0x38],[p;32]).unwrap();
            assert_eq!(e.storage.to_vec(),decode(c["texture_hex"].as_str().unwrap()));
            assert_eq!(e.descriptor_name.to_vec(),decode(c["descriptor_name_hex"].as_str().unwrap()));
        }
        let lookup:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_texture_cache_contract.json")).unwrap();
        assert_eq!(lookup["passed"],true);assert_eq!(lookup["case_count"],172);
        for c in lookup["cases"].as_array().unwrap() {
            let mut registry=Registry::default();
            for n in lookup["source_texture_names"].as_array().unwrap() {registry.request(n.as_str().unwrap().as_bytes()).unwrap();}
            registry.request(b"aq").unwrap();
            let query=decode(c["query_hex"].as_str().unwrap());let id=crate::native_hud_named_element::hash(&query);
            assert_eq!(registry.entries.contains_key(&id),!c["allocation_boundary_entered"].as_bool().unwrap());
            if let Some(name)=c["matched_name"].as_str() {
                let before=registry.entries[&id].storage;
                assert_eq!(registry.request(&query).unwrap(),id);assert_eq!(registry.entries[&id].storage,before);
                assert_eq!(&registry.entries[&id].storage[..name.len()],name.as_bytes());
            }
        }
    }
}
