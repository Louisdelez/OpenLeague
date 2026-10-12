from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_tree_service.rs';assert not p.exists()
p.write_text('''//! Verified95EA20 service defaults and95EAC0/95EB10 lifetime.
use crate::{grass_subdivision::Tree,grass_pool};
pub const ROOT_BOUNDS:[i32;4]=[-32768,-32768,32767,32767];
pub struct Service {pub root:Option<usize>}
pub fn create(tree:&mut Tree)->Result<Service,&'static str> {
    if !tree.queue.is_empty(){return Err("spatial service requires its own empty queue");}
    tree.max_depth=12;
    let root=grass_pool::construct(tree,ROOT_BOUNDS,1,|_|{})?;
    Ok(Service{root:Some(root)})
}
pub fn close(service:&mut Service,tree:&mut Tree)->Result<(),&'static str> {
    let Some(root)=service.root else{return Ok(());};
    grass_pool::destroy(tree,root,|_|{})?;service.root=None;
    // Native service teardown clears all residual queued links after root destruction.
    tree.queue.clear();Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use crate::grass_parent::Parent;
 #[test] fn service_original_defaults_and_root_lifecycle_match_native_fresh_and_recycled_cases() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_tree_service_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(serde_json::json!(ROOT_BOUNDS),proof["root_bounds"]);
    for c in proof["cases"].as_array().unwrap() {
        let nodes=(0..3).map(|_|Parent{bounds:[0;4],vertical:[42.,0.,0.,0.],parent:None,children:[None;4],members:Vec::new(),detached:false}).collect();
        let mut tree=Tree{nodes,midpoints:vec![[0;2];3],depths:vec![0;3],queued:vec![true;3],queue:Vec::new(),pool:c["initial_pool"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect(),pool_capacity:16,max_depth:0};
        let mut service=create(&mut tree).unwrap();let root=service.root.unwrap();let n=&tree.nodes[root];
        let state=serde_json::json!({"root":root,"max_depth":tree.max_depth,"queue_count":tree.queue.len(),"queue_empty":tree.queue.is_empty(),"bounds":n.bounds,"midpoint":tree.midpoints[root],"depth":tree.depths[root],"vertical_bits":n.vertical.map(f32::to_bits),"parent_null":n.parent.is_none(),"children_null":n.children.map(|p|p.is_none()),"queued":tree.queued[root],"members":n.members.len(),"pool":tree.pool});
        assert_eq!(state,c["constructor"]);close(&mut service,&mut tree).unwrap();assert_eq!(service.root.is_none(),c["wrapper_null"].as_bool().unwrap());assert_eq!(serde_json::json!(tree.pool),c["final_pool"]);assert!(tree.queue.is_empty());
    }
 }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');marker='mod grass_pool;';assert marker in s;s=s.replace(marker,marker+'\n#[allow(dead_code)]\nmod grass_tree_service;',1);main.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_tree_service.py','integrate_grass_tree_service.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native service defaults and lifetime integrated')
