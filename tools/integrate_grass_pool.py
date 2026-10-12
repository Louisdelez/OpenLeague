from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_pool.rs';assert not p.exists()
p.write_text('''//! Native95FDA0 destruction and95FC70/95FD10 reset/reuse in a supplied tree.
use crate::{grass_parent::Parent,grass_subdivision::Tree};
#[derive(Clone,Copy)] pub enum Event {Destroy(usize),RemoveQueue,AllocateNode(usize)}
pub fn destroy(tree:&mut Tree,index:usize,mut apply:impl FnMut(Event))->Result<(),&'static str> {
    fn validate(tree:&Tree,index:usize,visited:&mut Vec<usize>)->Result<(),&'static str> {
        if index>=tree.nodes.len()||visited.contains(&index)||tree.nodes[index].detached{return Err("invalid spatial destruction topology");}
        visited.push(index);for child in tree.nodes[index].children.into_iter().flatten(){validate(tree,child,visited)?;}Ok(())
    }
    if tree.queued.len()!=tree.nodes.len(){return Err("invalid spatial destruction flags");}
    validate(tree,index,&mut Vec::new())?;
    fn run(tree:&mut Tree,index:usize,apply:&mut impl FnMut(Event)) {
        apply(Event::Destroy(index));
        if tree.queued[index] {if let Some(position)=tree.queue.iter().position(|node|*node==index){apply(Event::RemoveQueue);tree.queue.remove(position);}}
        // Original destructor does not clear flag, child pointers or actor ownership.
        for child in tree.nodes[index].children.into_iter().flatten(){run(tree,child,apply);}
        tree.nodes[index].members.clear();tree.nodes[index].detached=true;tree.pool.push(index);
    }
    run(tree,index,&mut apply);Ok(())
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
#[cfg(test)] mod tests {
 use super::*;use crate::grass_parent::Member;
 #[test] fn queued_recursive_destruction_pool_order_and_constructor_reuse_match_original() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_pool_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let count=c["children"].as_array().unwrap().len();let members=c["member_count"].as_u64().unwrap() as usize;
        let mut nodes:Vec<Parent>=(0..7).map(|i|Parent{bounds:[0;4],vertical:[-1.,1.,-2.,2.],parent:None,children:if i<count {std::array::from_fn(|j|c["children"][i][j].as_u64().map(|v|v as usize))}else{[None;4]},members:(0..if i<count {members}else{0}).map(|j|Member{id:0,handle:j as u64}).collect(),detached:false}).collect();
        for i in 0..count {for child in nodes[i].children.into_iter().flatten(){nodes[child].parent=Some(i);}}
        let mut tree=Tree{nodes,midpoints:vec![[0;2];7],depths:vec![0;7],queued:(0..7).map(|i|i<count&&c["queue_profile"]!="none").collect(),queue:c["initial_queue"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool:c["initial_pool"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),max_depth:0};
        let encode=|event|match event {Event::Destroy(node)=>serde_json::json!({"kind":"destroy","node":node}),Event::RemoveQueue=>serde_json::json!({"kind":"remove_queue"}),Event::AllocateNode(node)=>serde_json::json!({"kind":"allocate_node","node":node})};
        let mut events=Vec::new();destroy(&mut tree,0,|e|events.push(encode(e))).unwrap();assert_eq!(serde_json::json!(events),c["destroy_events"],"native destruction {case}");
        assert_eq!(serde_json::json!(tree.queue),c["after_destroy"]["queue"]);assert_eq!(tree.queue.len(),c["after_destroy"]["queue_count"].as_u64().unwrap() as usize);assert_eq!(serde_json::json!(tree.pool),c["after_destroy"]["pool"]);assert_eq!(serde_json::json!(tree.nodes[..count].iter().map(|n|n.members.len()).collect::<Vec<_>>()),c["after_destroy"]["member_counts"]);assert_eq!(serde_json::json!(tree.queued[..count]),c["after_destroy"]["queued_flags"]);
        events.clear();let mut reused=Vec::new();
        for (step,_) in c["reused"].as_array().unwrap().iter().enumerate() {
            let index=construct(&mut tree,[-11-step as i32,-13,17+step as i32,19],step as u32+2,|e|events.push(encode(e))).unwrap();let n=&tree.nodes[index];
            reused.push(serde_json::json!({"node":index,"bounds":n.bounds,"midpoint":tree.midpoints[index],"depth":tree.depths[index],"vertical_bits":n.vertical.map(f32::to_bits),"parent_null":n.parent.is_none(),"children_null":n.children.map(|p|p.is_none()),"queued":tree.queued[index],"member_count":n.members.len(),"sentinel_empty":n.members.is_empty()}));
        }
        assert_eq!(serde_json::json!(events),c["reuse_events"]);assert_eq!(serde_json::json!(reused),c["reused"],"native reset {case}");assert_eq!(tree.pool.len(),c["final_pool_size"].as_u64().unwrap() as usize);
    }
 }
}
''',encoding='utf-8')
sub=r/'crates/client/src/grass_subdivision.rs';s=sub.read_text(encoding='utf-8');s=s.replace('pub max_depth:u32}', 'pub max_depth:u32,pub pool:Vec<usize>}',1)
a=s.index('            let bounds=zones[quadrant];apply(Event::Create(bounds));');b=s.index('\n        };',a)
s=s[:a]+'''            let bounds=zones[quadrant];apply(Event::Create(bounds));
            let child=crate::grass_pool::construct(tree,bounds,tree.depths[index].wrapping_add(1),|_|{})?;
            tree.nodes[child].parent=Some(index);tree.nodes[index].children[quadrant]=Some(child);child'''+s[b:]
s=s.replace('queue:vec![0],max_depth:', 'queue:vec![0],pool:Vec::new(),max_depth:').replace('queue:Vec::new(),max_depth:', 'queue:Vec::new(),pool:Vec::new(),max_depth:');sub.write_text(s,encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');marker='mod grass_subdivision;';assert marker in s;s=s.replace(marker,marker+'\n#[allow(dead_code)]\nmod grass_pool;',1);main.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_pool.py','integrate_grass_pool.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Destruction and pool recycling connected to child constructors')
