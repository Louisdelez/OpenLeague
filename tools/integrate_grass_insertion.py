from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_insertion.rs';assert not p.exists()
p.write_text('''//! Original960000/9600F0 insertion and95EDA0 subdivision queue scheduling.
use crate::grass_parent::{Parent,Member};
#[derive(Clone,Copy)] pub enum Event {Insert(usize),Schedule(usize)}
pub fn insert(nodes:&mut[Parent],midpoints:&[[i32;2]],queued:&mut[bool],queue:&mut Vec<usize>,root:usize,id:u64,handle:u64,bounds:[i32;4],center_y:f32,local_y:[f32;2],slot:&mut Option<usize>,mut apply:impl FnMut(Event))->Result<usize,&'static str> {
    if nodes.len()!=midpoints.len()||nodes.len()!=queued.len()||root>=nodes.len(){return Err("invalid spatial insertion tables");}
    let lower=center_y+local_y[0];let upper=center_y+local_y[1];
    if [center_y,local_y[0],local_y[1],lower,upper].iter().any(|v|!v.is_finite()){return Err("unqualified spatial insertion arithmetic");}
    // ADD/SAR wrap in the original; widening or Rust checked addition would differ.
    let center=[bounds[2].wrapping_add(bounds[0])>>1,bounds[3].wrapping_add(bounds[1])>>1];
    let mut path=vec![root];let mut current=root;
    loop {
        if nodes[current].detached||nodes[current].vertical.iter().any(|v|!v.is_finite()){return Err("invalid spatial insertion node");}
        let quadrant=if center[0]>=midpoints[current][0] {usize::from(center[1]<midpoints[current][1])}else{2+usize::from(center[1]>=midpoints[current][1])};
        let Some(child)=nodes[current].children[quadrant] else{break;};
        if child>=nodes.len()||path.contains(&child){return Err("invalid spatial insertion child chain");}
        if !crate::grass_parent::contains(nodes[child].bounds,bounds){break;}
        path.push(child);current=child;
    }
    // Native list capacity guard, before callbacks/mutation in this supported port.
    if nodes[current].members.len()>=0x15555554{return Err("native spatial member capacity exceeded");}
    for &index in &path[..path.len()-1] {crate::grass_parent::extend(&mut nodes[index].vertical,lower,upper,false);}
    apply(Event::Insert(current));nodes[current].members.push(Member{id,handle});*slot=Some(current);
    crate::grass_parent::extend(&mut nodes[current].vertical,lower,upper,true);
    if nodes[current].members.len()>16 {
        apply(Event::Schedule(current));
        if !queued[current] {queued[current]=true;queue.push(current);}
    }
    Ok(current)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn actual_insertion_child_selection_links_and_subdivision_queue_match_original() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_insertion_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let count=c["initial_count"].as_u64().unwrap() as usize;let initially_queued=c["initial_queued"].as_bool().unwrap();
        let all_bounds=[[-10,-10,10,10],[0,0,10,10],[0,-10,10,0],[-10,-10,0,0],[-10,0,0,10],[5,5,10,10]];
        let mut nodes:Vec<Parent>=all_bounds.into_iter().map(|bounds|Parent{bounds,vertical:[-5.,5.,-4.,4.],parent:None,children:[None;4],members:(0..count).map(|j|Member{id:2,handle:j as u64}).collect(),detached:false}).collect();
        if c["topology"]!="none" {nodes[0].children=[Some(1),Some(2),Some(3),Some(4)];}if c["topology"]=="nested" {nodes[1].children[0]=Some(5);}
        let midpoints=[[0,0],[5,5],[0,0],[0,0],[0,0],[0,0]];let mut queued=vec![initially_queued;6];let mut queue=if initially_queued {(0..6).collect()}else{Vec::new()};let mut slot=None;let mut events=Vec::new();
        let bounds=std::array::from_fn(|i|c["integer_bounds"][i].as_i64().unwrap() as i32);
        let target=insert(&mut nodes,&midpoints,&mut queued,&mut queue,0,1,100,bounds,c["vertical"][0].as_f64().unwrap() as f32,[c["vertical"][1].as_f64().unwrap() as f32,c["vertical"][2].as_f64().unwrap() as f32],&mut slot,|e|events.push(match e {Event::Insert(node)=>serde_json::json!({"kind":"insert","node":node}),Event::Schedule(node)=>serde_json::json!({"kind":"schedule","node":node})})).unwrap();
        assert_eq!(target,c["target"].as_u64().unwrap() as usize,"native insertion case {case}");assert_eq!(slot,Some(target));assert_eq!(serde_json::json!(events),c["events"]);
        assert_eq!(serde_json::json!(nodes.iter().map(|n|n.vertical.map(f32::to_bits)).collect::<Vec<_>>()),c["vertical_bits"]);assert_eq!(serde_json::json!(nodes.iter().map(|n|n.members.len()).collect::<Vec<_>>()),c["counts"]);
        assert_eq!(serde_json::json!(queued),c["queued_flags"]);assert_eq!(serde_json::json!(nodes[target].members.iter().map(|m|m.id==1).collect::<Vec<_>>()),c["entries"]);assert_eq!(serde_json::json!(queue),c["queue"]);assert_eq!(queue.len(),c["queue_count"].as_u64().unwrap() as usize);
    }
 }
}
''',encoding='utf-8')
parent=r/'crates/client/src/grass_parent.rs';s=parent.read_text(encoding='utf-8').replace('fn contains(', 'pub(crate) fn contains(',1).replace('fn extend(', 'pub(crate) fn extend(',1);parent.write_text(s,encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');marker='mod grass_parent;';assert marker in s;s=s.replace(marker,marker+'\n#[allow(dead_code)]\nmod grass_insertion;',1);main.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_insertion.py','integrate_grass_insertion.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Insertion and subdivision scheduling installed')
