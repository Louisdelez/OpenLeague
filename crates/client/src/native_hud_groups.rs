//! Native HUD group hash lookup and name comparison and membership transitions.
//! Group construction/settings, clock producer, bounds/layout and drawing are separate.
use std::collections::BTreeMap;
pub struct Group {
    pub name_storage:[u8;32],pub layer:u32,pub alpha_flags:u32,pub enabled_marker:u8,pub flags:u32,pub clock_enabled:bool,pub last_frame:u32,pub members:Vec<u32>,pub bounds:[u32;4],
}
impl Default for Group {
    fn default()->Self {Self {name_storage:[0;32],layer:0,alpha_flags:0,enabled_marker:0,flags:0,clock_enabled:false,last_frame:0,members:Vec::new(),bounds:crate::native_hud_group_bounds::EMPTY}}
}
pub struct Registry {pub groups:BTreeMap<u32,Group>,pub flags:u32}
pub struct Binding {pub group:Option<u32>,pub index:u32}
#[derive(Clone,Copy)] pub struct Clock {pub frame:u32,pub invalid:bool}
impl Clock {fn stamp(self)->u32 {if self.invalid {u32::MAX}else {self.frame}}}
impl Registry {
    pub fn refresh_bounds<'a,F>(&mut self,width:u32,height:u32,scalar:f32,resolve:F)->Result<usize,&'static str>
    where F:Fn(u32)->Option<&'a crate::native_hud_element_storage::ElementStorage> {
        let mut refreshed=0;
        for group in self.groups.values_mut() {
            let members=group.members.iter().map(|id|resolve(*id).ok_or("HUD bounds member missing"));
            if crate::native_hud_group_bounds::refresh(&mut group.bounds,&mut group.flags,width,height,scalar,members)? {refreshed+=1;}
        }
        Ok(refreshed)
    }
    pub fn lookup(&self,name:&[u8])->Result<Option<u32>,&'static str> {
        if !name.is_ascii() || name.len()>31 || name.contains(&0) {return Err("unqualified HUD group name");}
        let hash=crate::native_hud_named_element::hash(name);
        // The original calls a name comparison but ignores its return value.
        // Hash collision aliases resolve to the existing group without rewriting its name.
        Ok(self.groups.contains_key(&hash).then_some(hash))
    }
    pub fn rebind(&mut self,binding:&mut Binding,element:u32,name:&[u8],clock:Clock)->Result<(),&'static str> {
        let next=self.lookup(name)?;let previous=binding.group;
        if previous==next {return Ok(());}
        if let Some(id)=previous {
            let group=self.groups.get_mut(&id).ok_or("unqualified stale HUD group binding")?;
            binding.group=None;binding.index=u32::MAX;
            if let Some(index)=group.members.iter().position(|v|*v==element) {
                group.members.remove(index);group.flags|=2;
                if group.clock_enabled {group.last_frame=clock.stamp();}
                group.flags|=4;
            }
        }
        if let Some(id)=next {
            let group=self.groups.get_mut(&id).ok_or("HUD resolved group disappeared")?;
            binding.group=Some(id);group.members.push(element);group.flags|=2;
            if group.clock_enabled {group.last_frame=clock.stamp();}
            group.flags|=4;
        }
        if previous.is_some() || next.is_some() {self.flags|=1;}
        Ok(())
    }
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn fixture()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/native_hud_groups_contract.json")).unwrap()}
    #[test] fn source_group_lookup_case_aliases_hash_collision_and_name_storage_match_native() {
        let p=fixture();assert_eq!(p["passed"],true);assert_eq!(p["source_groups"],42);assert_eq!(p["lookup_case_count"],89);
        for case in p["lookup_cases"].as_array().unwrap() {
            let mut registry=Registry {groups:p["registry"].as_array().unwrap().iter().map(|r|(r["hash"].as_u64().unwrap() as u32,Group {name_storage:[0xa5;32],flags:0,clock_enabled:false,last_frame:0,members:Vec::new(),..Group::default()})).collect(),flags:0};
            let name=decode(case["query_hex"].as_str().unwrap());assert_eq!(crate::native_hud_named_element::hash(&name),case["hash"].as_u64().unwrap() as u32);
            let actual=registry.lookup(&name).unwrap();
            if case["matched_name"].is_null() {assert!(actual.is_none());}
            else {
                let matched=case["matched_name"].as_str().unwrap();assert_eq!(actual,Some(crate::native_hud_named_element::hash(matched.as_bytes())));
                assert_eq!(registry.groups[&actual.unwrap()].name_storage.to_vec(),decode(case["name_storage_hex"].as_str().unwrap()));
            }
        }
    }
    #[test] fn all_960_add_remove_move_noop_dirty_flags_and_clock_cases_match_native() {
        let p=fixture();assert_eq!(p["binding_case_count"],960);
        let old=crate::native_hud_named_element::hash(b"old");let new=crate::native_hud_named_element::hash(b"new");
        for case in p["binding_cases"].as_array().unwrap() {
            let previous=case["previous"].as_str().unwrap();
            let members=match previous {"none"|"absent"=>vec![101,102],"front"=>vec![0,101,102],"middle"=>vec![101,0,102],"last"=>vec![101,102,0],_=>unreachable!()};
            let initial=case["initial_flags"].as_u64().unwrap() as u32;
            let mut registry=Registry {groups:[(old,Group {name_storage:[0;32],flags:initial,clock_enabled:case["old_clock"].as_bool().unwrap(),last_frame:99,members,..Group::default()}),(new,Group {name_storage:[0;32],flags:initial,clock_enabled:case["new_clock"].as_bool().unwrap(),last_frame:99,members:vec![201,202],..Group::default()})].into(),flags:case["owner_flags"].as_u64().unwrap() as u32};
            let mut binding=Binding {group:if previous=="none" {None}else {Some(old)},index:123};
            registry.rebind(&mut binding,0,case["target"].as_str().unwrap().as_bytes(),Clock {frame:case["frame"].as_u64().unwrap() as u32,invalid:case["clock_invalid"].as_bool().unwrap()}).unwrap();
            let snapshot=|id:u32|{let group=&registry.groups[&id];serde_json::json!({"flags":group.flags,"last_frame":group.last_frame,"members":group.members})};
            let actual=serde_json::json!({"group":match binding.group {None=>"none",Some(id) if id==old=>"old",Some(id) if id==new=>"new",_=>unreachable!()},"index":binding.index,"owner_flags":registry.flags,"old":snapshot(old),"new":snapshot(new)});
            assert_eq!(actual,case["output"],"{previous}:{}",case["target"]);
        }
    }
}
