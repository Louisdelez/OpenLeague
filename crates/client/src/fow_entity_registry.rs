//! Native62B380 -> payload+8 ->5BDD80 identity/handle lookup semantics.
//! Original hash container insertion/resize and registration lifetime remain open.
use std::collections::BTreeMap;
pub struct EntityRegistry<'a,T> {
    pub registrations:&'a BTreeMap<u32,u32>,
    pub actors:&'a BTreeMap<u32,T>,
}
impl<'a,T> EntityRegistry<'a,T> {
    pub fn handle(&self,identity:u32)->Option<u32> {self.registrations.get(&identity).copied()}
    pub fn resolve(&self,identity:u32)->Option<&'a T> {self.actors.get(&self.handle(identity)?)}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn two_stage_resolution_matches_original_collisions_unsigned_keys_and_missing_actor() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_entity_resolution_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),102);
        for c in proof["cases"].as_array().unwrap() {
            let keys:Vec<u32>=c["keys"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            let registrations:BTreeMap<u32,u32>=keys.iter().enumerate().map(|(i,key)|(*key,0x12340000+i as u32)).collect();
            let available=keys.len()-usize::from(c["omit_last"].as_bool().unwrap() && !keys.is_empty());
            let actors:BTreeMap<u32,usize>=(0..available).map(|i|(0x12340000+i as u32,i)).collect();
            let registry=EntityRegistry {registrations:&registrations,actors:&actors};let identity=c["query"].as_u64().unwrap() as u32;
            assert_eq!(registry.handle(identity),c["result_handle"].as_u64().map(|v|v as u32),"identity {c}");
            assert_eq!(registry.resolve(identity).copied(),c["result_actor_index"].as_u64().map(|v|v as usize),"actor {c}");
        }
    }
}
