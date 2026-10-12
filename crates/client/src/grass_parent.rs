//! Native95FF10 parent control,9606D0 expansion,8A7C40 unlink,960350 pruning.
pub struct Member {pub id:u64,pub handle:u64}
pub struct Parent {pub bounds:[i32;4],pub vertical:[f32;4],pub parent:Option<usize>,pub children:[Option<usize>;4],pub members:Vec<Member>,pub detached:bool}
#[derive(Clone,Copy)] pub enum Event {Expand([f32;2]),Erase(u64),ReleaseLink(u64),Cleanup(usize),Destroy(usize),InsertRoot}
#[derive(Clone,Copy,Debug,PartialEq)] pub enum Outcome {Retained,NeedsInsertion}
pub(crate) fn contains(bounds:[i32;4],value:[i32;4])->bool {
    [0,2].into_iter().all(|i|value[i]>=bounds[0]&&value[i]<=bounds[2])&&[1,3].into_iter().all(|i|value[i]>=bounds[1]&&value[i]<=bounds[3])
}
pub(crate) fn extend(v:&mut[f32;4],lower:f32,upper:f32,local:bool) {
    if local {if v[2]>lower {v[2]=lower;}if upper>v[3] {v[3]=upper;}}
    if v[0]>lower {v[0]=lower;}if upper>v[1] {v[1]=upper;}
}
pub(crate) fn prune(nodes:&mut[Parent],index:usize,apply:&mut impl FnMut(Event)) {
    apply(Event::Cleanup(index));
    let Some(parent)=nodes[index].parent else{return;};
    if nodes[index].children.iter().any(Option::is_some)||!nodes[index].members.is_empty(){return;}
    let Some(slot)=nodes[parent].children.iter().position(|child|*child==Some(index)) else{return;};
    nodes[parent].children[slot]=None;prune(nodes,parent,apply);
    nodes[index].detached=true;apply(Event::Destroy(index));
}
/// Insertion remains a required explicit continuation; no fake parent assignment.
pub fn reindex(nodes:&mut[Parent],index:usize,id:u64,bounds:[i32;4],center_y:f32,local_y:[f32;2],slot:&mut Option<usize>,mut apply:impl FnMut(Event))->Result<Outcome,&'static str> {
    if index>=nodes.len(){return Err("invalid spatial parent");}
    let lower=center_y+local_y[0];let upper=center_y+local_y[1];
    let pad=(local_y[1]-local_y[0])*f32::from_bits(0x3e800000);let expanded=[lower-pad,upper+pad];
    if [center_y,local_y[0],local_y[1],lower,upper,pad,expanded[0],expanded[1]].iter().any(|v|!v.is_finite()){return Err("unqualified spatial parent arithmetic");}
    // Validate supplied ancestor topology before any mutation or callbacks.
    let mut chain=Vec::new();let mut cursor=Some(index);
    while let Some(i)=cursor {
        if i>=nodes.len()||chain.contains(&i){return Err("invalid spatial ancestor chain");}
        if nodes[i].vertical.iter().any(|v|!v.is_finite()){return Err("unqualified spatial parent vertical state");}
        chain.push(i);cursor=nodes[i].parent;
    }
    if contains(nodes[index].bounds,bounds) {
        if !(lower>=nodes[index].vertical[0]&&nodes[index].vertical[1]>=upper) {
            apply(Event::Expand(expanded));
            for (level,i) in chain.into_iter().enumerate(){extend(&mut nodes[i].vertical,expanded[0],expanded[1],level==0);}
        }
        return Ok(Outcome::Retained);
    }
    if let Some(member)=nodes[index].members.iter().position(|member|member.id==id) {
        let handle=nodes[index].members[member].handle;apply(Event::Erase(handle));
        nodes[index].members.remove(member);apply(Event::ReleaseLink(handle));
    }
    *slot=None;prune(nodes,index,&mut apply);apply(Event::InsertRoot);Ok(Outcome::NeedsInsertion)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn parent_control_expansion_unlink_and_recursive_pruning_match_original() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_parent_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["margin_bits"],0x3e800000u32);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let depth=c["depth"].as_u64().unwrap() as usize;
        let mut nodes:Vec<Parent>=(0..=depth).map(|i|Parent{bounds:[-10,-10,10,10],vertical:[-5.,5.,-4.,4.],parent:(i<depth).then_some(i+1),children:[if i>0 {Some(i-1)}else{None},None,None,None],members:Vec::new(),detached:false}).collect();
        nodes[0].members=c["members"].as_array().unwrap().iter().enumerate().map(|(i,target)|Member{id:if target.as_bool().unwrap(){1}else{2},handle:i as u64}).collect();
        let bounds=std::array::from_fn(|i|c["integer_bounds"][i].as_i64().unwrap() as i32);let mut slot=Some(0);let mut events=Vec::new();
        let result=reindex(&mut nodes,0,1,bounds,c["center_y"].as_f64().unwrap() as f32,[c["lower_y"].as_f64().unwrap() as f32,c["upper_y"].as_f64().unwrap() as f32],&mut slot,|event|events.push(match event {
            Event::Expand(v)=>serde_json::json!({"kind":"expand","argument_bits":v.map(f32::to_bits)}),
            Event::Erase(index)=>serde_json::json!({"kind":"erase","index":index}),Event::ReleaseLink(index)=>serde_json::json!({"kind":"free_link","index":index}),
            Event::Cleanup(level)=>serde_json::json!({"kind":"cleanup","level":level,"parent_cleared":true}),Event::Destroy(level)=>serde_json::json!({"kind":"destroy","level":level}),Event::InsertRoot=>serde_json::json!({"kind":"insert_root","parent_cleared":true})
        })).unwrap();
        assert_eq!(serde_json::json!(events),c["events"],"parent event order {case}");assert_eq!(serde_json::json!(nodes.iter().map(|n|n.vertical.map(f32::to_bits)).collect::<Vec<_>>()),c["vertical_bits"]);
        assert_eq!(serde_json::json!(nodes[0].members.iter().map(|m|m.handle).collect::<Vec<_>>()),c["remaining_member_indices"]);assert_eq!(nodes[0].members.len(),c["member_count"].as_u64().unwrap() as usize);
        assert_eq!(slot.is_none(),c["parent_cleared"].as_bool().unwrap());assert_eq!(result==Outcome::NeedsInsertion,slot.is_none());assert_eq!(serde_json::json!(nodes.iter().map(|n|n.children[0].is_some()).collect::<Vec<_>>()),c["child_present"]);
    }
 }
}
