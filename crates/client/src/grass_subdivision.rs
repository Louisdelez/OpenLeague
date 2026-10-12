//! Native9605E0 zone calculation and9603C0 member subdivision.
use crate::{grass_parent::Parent,grass_insertion};
pub fn quarters(b:[i32;4])->[[i32;4];4] {
    let sx=b[2].wrapping_sub(b[0])/4;let sz=b[3].wrapping_sub(b[1])/4;
    let a=b[0].wrapping_add(sx);let z=b[1].wrapping_add(sz);let c=b[2].wrapping_sub(sx);let d=b[3].wrapping_sub(sz);
    let mx=a.wrapping_add(c)/2;let mz=z.wrapping_add(d)/2;let hx=mx.wrapping_sub(a)/2;let hz=mz.wrapping_sub(z)/2;
    [[mx.wrapping_sub(hx),mz.wrapping_sub(hz),c.wrapping_add(hx),d.wrapping_add(hz)],
     [mx.wrapping_sub(hx),z.wrapping_sub(hz),c.wrapping_add(hx),mz.wrapping_add(hz)],
     [a.wrapping_sub(hx),z.wrapping_sub(hz),mx.wrapping_add(hx),mz.wrapping_add(hz)],
     [a.wrapping_sub(hx),mz.wrapping_sub(hz),mx.wrapping_add(hx),d.wrapping_add(hz)]]
}
pub struct Actor {pub bounds:[i32;4],pub center_y:f32,pub local_y:[f32;2],pub parent:Option<usize>}
pub struct Tree {pub nodes:Vec<Parent>,pub midpoints:Vec<[i32;2]>,pub depths:Vec<u32>,pub queued:Vec<bool>,pub queue:Vec<usize>,pub max_depth:u32,pub pool:Vec<usize>,pub pool_capacity:usize}
#[derive(Clone,Copy)] pub enum Event {Create([i32;4]),Insert(u64)}
pub fn split(tree:&mut Tree,index:usize,actors:&mut[Actor],mut apply:impl FnMut(Event))->Result<(),&'static str> {
    if index>=tree.nodes.len()||tree.midpoints.len()!=tree.nodes.len()||tree.depths.len()!=tree.nodes.len()||tree.queued.len()!=tree.nodes.len(){return Err("invalid spatial subdivision tables");}
    tree.queued[index]=false;
    if tree.nodes[index].children.iter().all(Option::is_some)||tree.depths[index]>=tree.max_depth{return Ok(());}
    if tree.nodes[index].children.iter().flatten().any(|child|*child>=tree.nodes.len()){return Err("invalid spatial subdivision child");}
    let zones=quarters(tree.nodes[index].bounds);
    // Validate actor references and supported arithmetic before moving any members.
    for member in &tree.nodes[index].members {
        let actor=actors.get(member.id as usize).ok_or("invalid spatial subdivision actor")?;
        if [actor.center_y,actor.local_y[0],actor.local_y[1],actor.center_y+actor.local_y[0],actor.center_y+actor.local_y[1]].iter().any(|v|!v.is_finite()){return Err("unqualified spatial subdivision actor arithmetic");}
    }
    let members=std::mem::take(&mut tree.nodes[index].members);
    for member in members {
        let actor=&mut actors[member.id as usize];let b=actor.bounds;
        let center=[b[2].wrapping_add(b[0])>>1,b[3].wrapping_add(b[1])>>1];
        let quadrant=if center[0]>=tree.midpoints[index][0] {usize::from(center[1]<tree.midpoints[index][1])}else{2+usize::from(center[1]>=tree.midpoints[index][1])};
        if !crate::grass_parent::contains(zones[quadrant],b){tree.nodes[index].members.push(member);continue;}
        let child=if let Some(child)=tree.nodes[index].children[quadrant] {child}else{
            let bounds=zones[quadrant];apply(Event::Create(bounds));
            let child=crate::grass_pool::construct(tree,bounds,tree.depths[index].wrapping_add(1),|_|{})?;
            tree.nodes[child].parent=Some(index);tree.nodes[index].children[quadrant]=Some(child);child
        };
        let id=member.id;
        grass_insertion::append(&mut tree.nodes,&mut tree.queued,&mut tree.queue,child,member,actor.center_y,actor.local_y,&mut actor.parent,|event|{if matches!(event,grass_insertion::Event::Insert(_)){apply(Event::Insert(id));}})?;
    }
    Ok(())
}
/// Native95ED30 drains FIFO including new subdivisions queued by processing.
pub fn drain(tree:&mut Tree,actors:&mut[Actor],mut apply:impl FnMut(Event))->Result<(),&'static str> {
    while !tree.queue.is_empty() {
        let index=tree.queue[0];if index>=tree.nodes.len(){return Err("invalid queued spatial subdivision");}
        tree.queue.remove(0);split(tree,index,actors,&mut apply)?;
    }
    Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use crate::grass_parent::Member;
 #[test] fn native_queue_drain_processes_new_children_and_matches_entire_tree_and_actor_parents() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_subdivision_queue_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let mut actors:Vec<Actor>=c["member_bounds"].as_array().unwrap().iter().enumerate().map(|(i,b)|Actor{bounds:std::array::from_fn(|j|b[j].as_i64().unwrap() as i32),center_y:i as f32,local_y:[-2.,2.],parent:Some(0)}).collect();
        let node=Parent{bounds:[-100,-100,100,100],vertical:[-5.,5.,-5.,5.],parent:None,children:[None;4],members:(0..actors.len()).map(|i|Member{id:i as u64,handle:i as u64}).collect(),detached:false};
        let mut tree=Tree{nodes:vec![node],midpoints:vec![[0;2]],depths:vec![c["depth"].as_u64().unwrap() as u32],queued:vec![true],queue:vec![0],pool:Vec::new(),pool_capacity:0,max_depth:c["max_depth"].as_u64().unwrap() as u32};let mut events=Vec::new();
        drain(&mut tree,&mut actors,|event|events.push(match event{Event::Create(bounds)=>serde_json::json!({"kind":"create","bounds":bounds}),Event::Insert(member)=>serde_json::json!({"kind":"insert","member":member})})).unwrap();
        assert_eq!(serde_json::json!(events),c["events"],"native queue events {case}");assert!(tree.queue.is_empty());assert_eq!(c["queue_count"],0);
        let state:Vec<serde_json::Value>=tree.nodes.iter().enumerate().map(|(i,n)|serde_json::json!({"bounds":n.bounds,"midpoint":tree.midpoints[i],"depth":tree.depths[i],"vertical_bits":n.vertical.map(f32::to_bits),"members":n.members.iter().map(|m|m.id).collect::<Vec<_>>(),"queued":tree.queued[i],"parent":n.parent,"children":n.children})).collect();
        assert_eq!(serde_json::json!(state),c["tree"],"native full tree {case}");assert_eq!(serde_json::json!(actors.iter().map(|a|a.parent).collect::<Vec<_>>()),c["actor_parents"]);
    }
 }

 #[test] fn quadrant_zones_match_original_signed_wrap_and_truncation() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_subdivision_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for c in proof["quarter_cases"].as_array().unwrap(){let b=std::array::from_fn(|i|c["bounds"][i].as_i64().unwrap() as i32);assert_eq!(serde_json::json!(quarters(b)),c["quarters"]);}
 }
 #[test] fn subdivision_constructs_children_preserves_residual_order_and_schedules_native_threshold() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_subdivision_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let mut actors:Vec<Actor>=c["member_bounds"].as_array().unwrap().iter().enumerate().map(|(i,b)|Actor{bounds:std::array::from_fn(|j|b[j].as_i64().unwrap() as i32),center_y:i as f32,local_y:[-2.,2.],parent:Some(0)}).collect();
        let all_children=c["all_children"].as_bool().unwrap();
        let node=Parent{bounds:[-100,-100,100,100],vertical:[-5.,5.,-5.,5.],parent:None,children:if all_children {[Some(1),Some(2),Some(3),Some(4)]}else{[None;4]},members:(0..actors.len()).map(|i|Member{id:i as u64,handle:i as u64}).collect(),detached:false};
        let mut tree=Tree{nodes:vec![node],midpoints:vec![[0;2]],depths:vec![c["depth"].as_u64().unwrap() as u32],queued:vec![true],queue:Vec::new(),pool:Vec::new(),pool_capacity:0,max_depth:c["max_depth"].as_u64().unwrap() as u32};let mut events=Vec::new();
        split(&mut tree,0,&mut actors,|event|events.push(match event{Event::Create(bounds)=>serde_json::json!({"kind":"create","bounds":bounds}),Event::Insert(member)=>serde_json::json!({"kind":"insert","member":member})})).unwrap();
        assert_eq!(serde_json::json!(events),c["events"],"native subdivision {case}");assert_eq!(serde_json::json!(tree.nodes[0].members.iter().map(|m|m.id).collect::<Vec<_>>()),c["remaining"]);assert_eq!(tree.queued[0],c["flag"].as_bool().unwrap());assert_eq!(tree.queue.len(),c["queue_count"].as_u64().unwrap() as usize);
        if !all_children {
            let children:Vec<serde_json::Value>=tree.nodes[0].children.iter().map(|child|if let Some(i)=child {let n=&tree.nodes[*i];serde_json::json!({"bounds":n.bounds,"midpoint":tree.midpoints[*i],"depth":tree.depths[*i],"vertical_bits":n.vertical.map(f32::to_bits),"members":n.members.iter().map(|m|m.id).collect::<Vec<_>>(),"queued":tree.queued[*i]})}else{serde_json::Value::Null}).collect();assert_eq!(serde_json::json!(children),c["children"]);
        }
        let quadrants:Vec<Option<usize>>=actors.iter().map(|a|tree.nodes[0].children.iter().position(|child|child.is_some()&&*child==a.parent)).collect();assert_eq!(serde_json::json!(quadrants),c["member_parent_quadrants"]);
    }
 }
}
