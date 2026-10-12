//! Native95FDA0 destruction and95FC70/95FD10 reset/reuse in a supplied tree.
use crate::{grass_parent::Parent,grass_subdivision::Tree};
#[derive(Clone,Copy)] pub enum Event {Destroy(usize),RemoveQueue,AllocateNode(usize),ReservePool(usize)}
/// Native vector policy uses a 1.5 growth candidate, at least one extra slot.
pub fn next_capacity(len:usize,capacity:usize)->Result<usize,&'static str> {
    let limit=0x3fffffffusize;
    if len>capacity||capacity>limit||len>=limit{return Err("native spatial pool capacity exceeded");}
    if len<capacity{return Ok(capacity);}
    let grown=capacity.checked_add(capacity/2).filter(|v|*v<=limit).unwrap_or(0);
    Ok(grown.max(len+1))
}
pub(crate) fn push(pool:&mut Vec<usize>,capacity:&mut usize,index:usize,mut apply:impl FnMut(Event))->Result<(),&'static str> {
    let next=next_capacity(pool.len(),*capacity)?;
    if next!=*capacity {
        pool.try_reserve_exact(next.saturating_sub(pool.len())).map_err(|_|"spatial pool allocation failed")?;
        apply(Event::ReservePool(next));*capacity=next;
    }
    pool.push(index);Ok(())
}
pub fn destroy(tree:&mut Tree,index:usize,mut apply:impl FnMut(Event))->Result<(),&'static str> {
    fn validate(tree:&Tree,index:usize,visited:&mut Vec<usize>)->Result<(),&'static str> {
        if index>=tree.nodes.len()||visited.contains(&index)||tree.nodes[index].detached{return Err("invalid spatial destruction topology");}
        visited.push(index);for child in tree.nodes[index].children.into_iter().flatten(){validate(tree,child,visited)?;}Ok(())
    }
    if tree.queued.len()!=tree.nodes.len(){return Err("invalid spatial destruction flags");}
    validate(tree,index,&mut Vec::new())?;
    fn run(tree:&mut Tree,index:usize,apply:&mut impl FnMut(Event))->Result<(),&'static str> {
        apply(Event::Destroy(index));
        if tree.queued[index] {if let Some(position)=tree.queue.iter().position(|node|*node==index){apply(Event::RemoveQueue);tree.queue.remove(position);}}
        // Original destructor does not clear flag, child pointers or actor ownership.
        for child in tree.nodes[index].children.into_iter().flatten(){run(tree,child,apply)?;}
        tree.nodes[index].members.clear();tree.nodes[index].detached=true;push(&mut tree.pool,&mut tree.pool_capacity,index,apply)
    }
    run(tree,index,&mut apply)
}
pub fn construct(tree:&mut Tree,bounds:[i32;4],depth:u32,mut apply:impl FnMut(Event))->Result<usize,&'static str> {
    if tree.midpoints.len()!=tree.nodes.len()||tree.depths.len()!=tree.nodes.len()||tree.queued.len()!=tree.nodes.len(){return Err("invalid spatial construction tables");}
    if tree.pool.last().is_some_and(|i|*i>=tree.nodes.len()||!tree.nodes[*i].members.is_empty()){return Err("invalid reusable spatial node");}
    let index=if let Some(index)=tree.pool.pop(){index}else{
        let index=tree.nodes.len();apply(Event::AllocateNode(index));tree.nodes.push(Parent{bounds:[0;4],vertical:[0.;4],parent:None,children:[None;4],members:Vec::new(),detached:false});tree.midpoints.push([0;2]);tree.depths.push(0);tree.queued.push(false);index
    };
    let node=&mut tree.nodes[index];node.bounds=bounds;node.vertical=[f32::MAX,-f32::MAX,f32::MAX,-f32::MAX];node.parent=None;node.children=[None;4];node.members.clear();node.detached=false;
    tree.midpoints[index]=[bounds[2].wrapping_add(bounds[0])>>1,bounds[3].wrapping_add(bounds[1])>>1];tree.depths[index]=depth;tree.queued[index]=false;Ok(index)
}
/// Native parent pruning destroys only empty leaves; share their queue/pool lifecycle.
pub fn reindex(tree:&mut Tree,parent:usize,root:usize,id:u64,handle:u64,bounds:[i32;4],center_y:f32,local_y:[f32;2],slot:&mut Option<usize>,mut apply:impl FnMut(crate::grass_parent::Event),mut insertion:impl FnMut(crate::grass_insertion::Event))->Result<(),&'static str> {
    if tree.queued.len()!=tree.nodes.len()||tree.midpoints.len()!=tree.nodes.len()||root>=tree.nodes.len(){return Err("invalid pooled spatial reindex tables");}
    let queue=&mut tree.queue;let pool=&mut tree.pool;let queued=&tree.queued;let capacity=&mut tree.pool_capacity;let mut pool_error=None;
    let outcome=crate::grass_parent::reindex(&mut tree.nodes,parent,id,bounds,center_y,local_y,slot,|event|{
        if !matches!(event,crate::grass_parent::Event::InsertRoot){apply(event);}
        if let crate::grass_parent::Event::Destroy(index)=event {
            if queued[index] {if let Some(position)=queue.iter().position(|node|*node==index){queue.remove(position);}}
            if let Err(error)=push(pool,capacity,index,|_|{}) {pool_error=Some(error);}
        }
    })?;
    if let Some(error)=pool_error{return Err(error);}
    if outcome==crate::grass_parent::Outcome::NeedsInsertion {
        crate::grass_insertion::insert(&mut tree.nodes,&tree.midpoints,&mut tree.queued,&mut tree.queue,root,id,handle,bounds,center_y,local_y,slot,&mut insertion)?;
    }
    Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use crate::grass_parent::Member; #[test] fn parent_pruning_destruction_and_pool_are_connected_before_real_insertion() {
    use crate::grass_parent::Event as ParentEvent;
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_parent_pool_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let depth=c["depth"].as_u64().unwrap() as usize;let root=depth+1;
        let mut nodes:Vec<Parent>=(0..=depth).map(|i|Parent{bounds:[-10,-10,10,10],vertical:[-5.,5.,-4.,4.],parent:(i<depth).then_some(i+1),children:[if i>0 {Some(i-1)}else{None},None,None,None],members:Vec::new(),detached:false}).collect();
        nodes[0].members=c["members"].as_array().unwrap().iter().enumerate().map(|(i,target)|Member{id:if target.as_bool().unwrap(){1}else{2},handle:i as u64}).collect();
        nodes.push(Parent{bounds:[0;4],vertical:[0.;4],parent:None,children:[None;4],members:Vec::new(),detached:false});
        let queue=Vec::new();let queued=vec![false;nodes.len()];let midpoints=vec![[0;2];nodes.len()];let mut slot=Some(0);let events=std::cell::RefCell::new(Vec::new());
        let bounds=std::array::from_fn(|i|c["integer_bounds"][i].as_i64().unwrap() as i32);
        let mut tree=Tree{nodes,midpoints,depths:vec![0;root+1],queued,queue,pool:Vec::new(),pool_capacity:32,max_depth:0};
        reindex(&mut tree,0,root,1,100,bounds,c["center_y"].as_f64().unwrap() as f32,[c["lower_y"].as_f64().unwrap() as f32,c["upper_y"].as_f64().unwrap() as f32],&mut slot,|e|events.borrow_mut().push(match e {
            ParentEvent::Expand(v)=>serde_json::json!({"kind":"expand","argument_bits":v.map(f32::to_bits)}),ParentEvent::Erase(index)=>serde_json::json!({"kind":"erase","index":index}),ParentEvent::ReleaseLink(index)=>serde_json::json!({"kind":"free_link","index":index}),ParentEvent::Cleanup(level)=>serde_json::json!({"kind":"cleanup","level":level,"parent_cleared":true}),ParentEvent::Destroy(level)=>serde_json::json!({"kind":"destroy","level":level}),ParentEvent::InsertRoot=>unreachable!()
        }),|e|events.borrow_mut().push(match e {crate::grass_insertion::Event::Insert(target)=>{assert_eq!(target,root);serde_json::json!({"kind":"insert_root","parent_cleared":true})},crate::grass_insertion::Event::Schedule(_)=>panic!("unexpected root subdivision")})).unwrap();
        assert_eq!(serde_json::json!(tree.pool),c["pool_levels"]);let nodes=&tree.nodes;
        assert_eq!(serde_json::json!(events.into_inner()),c["events"],"compound parent case {case}");assert_eq!(slot==Some(root),c["inserted_root"].as_bool().unwrap());assert_eq!(slot.is_none(),c["parent_cleared"].as_bool().unwrap());
        assert_eq!(serde_json::json!(nodes[..root].iter().map(|n|n.vertical.map(f32::to_bits)).collect::<Vec<_>>()),c["vertical_bits"]);assert_eq!(serde_json::json!(nodes[root].vertical.map(f32::to_bits)),c["root_vertical_bits"]);assert_eq!(nodes[root].members.len(),c["root_member_count"].as_u64().unwrap() as usize);
        assert_eq!(serde_json::json!(nodes[0].members.iter().map(|m|m.handle).collect::<Vec<_>>()),c["remaining_member_indices"]);assert_eq!(nodes[0].members.len(),c["member_count"].as_u64().unwrap() as usize);assert_eq!(serde_json::json!(nodes[..root].iter().map(|n|n.children[0].is_some()).collect::<Vec<_>>()),c["child_present"]);
    }
 }

 #[test] fn queued_recursive_destruction_pool_order_and_constructor_reuse_match_original() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_pool_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let count=c["children"].as_array().unwrap().len();let members=c["member_count"].as_u64().unwrap() as usize;
        let mut nodes:Vec<Parent>=(0..7).map(|i|Parent{bounds:[0;4],vertical:[-1.,1.,-2.,2.],parent:None,children:if i<count {std::array::from_fn(|j|c["children"][i][j].as_u64().map(|v|v as usize))}else{[None;4]},members:(0..if i<count {members}else{0}).map(|j|Member{id:0,handle:j as u64}).collect(),detached:false}).collect();
        for i in 0..count {for child in nodes[i].children.into_iter().flatten(){nodes[child].parent=Some(i);}}
        let mut tree=Tree{nodes,midpoints:vec![[0;2];7],depths:vec![0;7],queued:(0..7).map(|i|i<count&&c["queue_profile"]!="none").collect(),queue:c["initial_queue"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool:c["initial_pool"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool_capacity:32,max_depth:0};
        let encode=|event|match event {Event::Destroy(node)=>serde_json::json!({"kind":"destroy","node":node}),Event::RemoveQueue=>serde_json::json!({"kind":"remove_queue"}),Event::AllocateNode(node)=>serde_json::json!({"kind":"allocate_node","node":node}),Event::ReservePool(capacity)=>serde_json::json!({"kind":"reserve_pool","capacity":capacity})};
        let mut events=Vec::new();destroy(&mut tree,0,|e|events.push(encode(e))).unwrap();assert_eq!(serde_json::json!(events),c["destroy_events"],"native destruction {case}");
        assert_eq!(serde_json::json!(tree.queue),c["after_destroy"]["queue"]);assert_eq!(tree.queue.len(),c["after_destroy"]["queue_count"].as_u64().unwrap() as usize);assert_eq!(serde_json::json!(tree.pool),c["after_destroy"]["pool"]);assert_eq!(serde_json::json!(tree.nodes[..count].iter().map(|n|n.members.len()).collect::<Vec<_>>()),c["after_destroy"]["member_counts"]);assert_eq!(serde_json::json!(tree.queued[..count]),c["after_destroy"]["queued_flags"]);
        events.clear();let mut reused=Vec::new();
        for (step,_) in c["reused"].as_array().unwrap().iter().enumerate() {
            let index=construct(&mut tree,[-11-step as i32,-13,17+step as i32,19],step as u32+2,|e|events.push(encode(e))).unwrap();let n=&tree.nodes[index];
            reused.push(serde_json::json!({"node":index,"bounds":n.bounds,"midpoint":tree.midpoints[index],"depth":tree.depths[index],"vertical_bits":n.vertical.map(f32::to_bits),"parent_null":n.parent.is_none(),"children_null":n.children.map(|p|p.is_none()),"queued":tree.queued[index],"member_count":n.members.len(),"sentinel_empty":n.members.is_empty()}));
        }
        assert_eq!(serde_json::json!(events),c["reuse_events"]);assert_eq!(serde_json::json!(reused),c["reused"],"native reset {case}");assert_eq!(tree.pool.len(),c["final_pool_size"].as_u64().unwrap() as usize);
    }
 } #[test] fn original_capacity_growth_copy_and_reuse_match_all_native_reservations() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_pool_growth_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let count=c["children"].as_array().unwrap().len();let members=c["member_count"].as_u64().unwrap() as usize;
        let mut nodes:Vec<Parent>=(0..7).map(|i|Parent{bounds:[0;4],vertical:[-1.,1.,-2.,2.],parent:None,children:if i<count {std::array::from_fn(|j|c["children"][i][j].as_u64().map(|v|v as usize))}else{[None;4]},members:(0..if i<count {members}else{0}).map(|j|Member{id:0,handle:j as u64}).collect(),detached:false}).collect();
        for i in 0..count {for child in nodes[i].children.into_iter().flatten(){nodes[child].parent=Some(i);}}
        let mut tree=Tree{nodes,midpoints:vec![[0;2];7],depths:vec![0;7],queued:(0..7).map(|i|i<count&&c["queue_profile"]!="none").collect(),queue:c["initial_queue"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool:c["initial_pool"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool_capacity:c["initial_pool_capacity"].as_u64().unwrap() as usize,max_depth:0};
        let encode=|event|match event {Event::Destroy(node)=>serde_json::json!({"kind":"destroy","node":node}),Event::RemoveQueue=>serde_json::json!({"kind":"remove_queue"}),Event::AllocateNode(node)=>serde_json::json!({"kind":"allocate_node","node":node}),Event::ReservePool(capacity)=>serde_json::json!({"kind":"reserve_pool","capacity":capacity})};
        let mut events=Vec::new();destroy(&mut tree,0,|e|events.push(encode(e))).unwrap();assert_eq!(serde_json::json!(events),c["destroy_events"],"native destruction {case}");
        assert_eq!(serde_json::json!(tree.queue),c["after_destroy"]["queue"]);assert_eq!(tree.queue.len(),c["after_destroy"]["queue_count"].as_u64().unwrap() as usize);assert_eq!(serde_json::json!(tree.pool),c["after_destroy"]["pool"]);assert_eq!(serde_json::json!(tree.nodes[..count].iter().map(|n|n.members.len()).collect::<Vec<_>>()),c["after_destroy"]["member_counts"]);assert_eq!(serde_json::json!(tree.queued[..count]),c["after_destroy"]["queued_flags"]);
        assert_eq!(tree.pool_capacity,c["after_destroy"]["pool_capacity"].as_u64().unwrap() as usize);
        events.clear();let mut reused=Vec::new();
        for (step,_) in c["reused"].as_array().unwrap().iter().enumerate() {
            let index=construct(&mut tree,[-11-step as i32,-13,17+step as i32,19],step as u32+2,|e|events.push(encode(e))).unwrap();let n=&tree.nodes[index];
            reused.push(serde_json::json!({"node":index,"bounds":n.bounds,"midpoint":tree.midpoints[index],"depth":tree.depths[index],"vertical_bits":n.vertical.map(f32::to_bits),"parent_null":n.parent.is_none(),"children_null":n.children.map(|p|p.is_none()),"queued":tree.queued[index],"member_count":n.members.len(),"sentinel_empty":n.members.is_empty()}));
        }
        assert_eq!(serde_json::json!(events),c["reuse_events"]);assert_eq!(serde_json::json!(reused),c["reused"],"native reset {case}");assert_eq!(tree.pool.len(),c["final_pool_size"].as_u64().unwrap() as usize);
    }
 }
}
