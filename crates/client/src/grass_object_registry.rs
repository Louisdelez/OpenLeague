//! Native95EE90/95F230 registration and95F1D0 withdrawal in a supplied service.
use crate::{grass_spatial_dispatch::{IndexedNode,Node},grass_spatial_bounds::{self,IntegerProfile},grass_spatial_extents,grass_subdivision::Tree,grass_tree_service::Service,grass_insertion};
pub struct Object {pub indexed:IndexedNode,pub radius:f32,pub parent:Option<usize>,pub owner:u64}
pub struct Registry {pub objects:Vec<Object>,pub recycled:Vec<usize>,pub recycled_capacity:usize}
#[derive(Clone,Copy)] pub enum Event {Constructed,Bounds,Insert}
#[derive(Clone,Copy)] pub struct Snapshot {pub center:[f32;3],pub local:[f32;6],pub radius:f32,pub integer_bounds:[i32;4]}
fn snapshot(object:&Object)->Snapshot {Snapshot{center:object.indexed.node.center,local:object.indexed.local_bounds,radius:object.radius,integer_bounds:object.indexed.integer_bounds}}
pub fn register(registry:&mut Registry,tree:&mut Tree,service:&Service,owner:u64,center:[f32;3],local:[f32;6],profile:IntegerProfile,fresh_integer_storage:[i32;4],mut apply:impl FnMut(Event,Snapshot))->Result<usize,&'static str> {
    let index=if let Some(index)=registry.recycled.pop(){if index>=registry.objects.len(){return Err("invalid recycled spatial object");}index}else{
        let index=registry.objects.len();registry.objects.push(Object{indexed:IndexedNode{node:Node{center:[0.;3],parent_present:false},local_bounds:[f32::MAX,f32::MAX,f32::MAX,-f32::MAX,-f32::MAX,-f32::MAX],integer_bounds:fresh_integer_storage,profile},radius:0.,parent:None,owner});index
    };
    let object=&mut registry.objects[index];object.indexed.node.center=[0.;3];object.indexed.node.parent_present=false;object.indexed.profile=profile;object.radius=0.;object.parent=None;object.owner=owner;
    // Reused local/integer fields intentionally survive the native constructor.
    apply(Event::Constructed,snapshot(object));
    if center!=object.indexed.node.center {
        let bounds=grass_spatial_bounds::recalculate(center,object.indexed.local_bounds,profile)?;
        object.indexed.node.center=center;apply(Event::Bounds,snapshot(object));object.indexed.integer_bounds=bounds;
    }
    grass_spatial_extents::update(&mut object.indexed,&mut object.radius,local,|event,local,radius,integer_bounds|{
        if matches!(event,grass_spatial_extents::Event::Bounds){apply(Event::Bounds,Snapshot{center,local,radius,integer_bounds});}
    })?;
    if let Some(root)=service.root {
        let state=snapshot(object);
        grass_insertion::insert(&mut tree.nodes,&tree.midpoints,&mut tree.queued,&mut tree.queue,root,index as u64,index as u64,object.indexed.integer_bounds,center[1],[local[1],local[4]],&mut object.parent,|event|{if matches!(event,grass_insertion::Event::Insert(_)){apply(Event::Insert,state);}})?;
    }
    object.indexed.node.parent_present=object.parent.is_some();Ok(index)
}
pub fn unregister(registry:&mut Registry,tree:&mut Tree,index:usize)->Result<(),&'static str> {
    unregister_with_reservations(registry,tree,index,|_|{})
}
pub fn unregister_with_reservations(registry:&mut Registry,tree:&mut Tree,index:usize,mut reserve:impl FnMut(usize))->Result<(),&'static str> {
    let object=registry.objects.get_mut(index).ok_or("invalid spatial object")?;let parent=object.parent.ok_or("unregistered spatial object")?;
    let node=tree.nodes.get_mut(parent).ok_or("invalid spatial object parent")?;
    if let Some(position)=node.members.iter().position(|member|member.id==index as u64){node.members.remove(position);}
    object.parent=None;object.indexed.node.parent_present=false;
    let mut destroyed=Vec::new();crate::grass_parent::prune(&mut tree.nodes,parent,&mut |event|{if let crate::grass_parent::Event::Destroy(index)=event{destroyed.push(index);}});
    for index in destroyed {
        if tree.queued[index] {if let Some(position)=tree.queue.iter().position(|node|*node==index){tree.queue.remove(position);}}
        crate::grass_pool::push(&mut tree.pool,&mut tree.pool_capacity,index,|_|{})?;
    }
    crate::grass_pool::push(&mut registry.recycled,&mut registry.recycled_capacity,index,|event|{
        if let crate::grass_pool::Event::ReservePool(capacity)=event{reserve(capacity);}
    })?;Ok(())
}
#[derive(Clone,Copy)] pub enum UpdateEvent {Bounds,Parent,Extents,Insert,Schedule}
/// Executes each parent operation at its native position in the spatial chain.
pub fn update_aabb(registry:&mut Registry,tree:&mut Tree,service:&Service,index:usize,aabb:[f32;6],mut apply:impl FnMut(UpdateEvent,crate::grass_spatial_chain::Snapshot))->Result<(),&'static str> {
    let object=registry.objects.get_mut(index).ok_or("invalid spatial object update")?;
    if registry.recycled.contains(&index){return Err("recycled spatial object update");}
    if object.parent.is_some()&&service.root.is_none(){return Err("missing spatial tree service root");}
    let Object{indexed,radius,parent,..}=object;indexed.node.parent_present=parent.is_some();
    crate::grass_spatial_chain::propagate_try(aabb,Some(indexed),radius,|event,state|{
        apply(match event{crate::grass_spatial_chain::Event::Bounds=>UpdateEvent::Bounds,crate::grass_spatial_chain::Event::Parent=>UpdateEvent::Parent,crate::grass_spatial_chain::Event::Extents=>UpdateEvent::Extents},state);
        if matches!(event,crate::grass_spatial_chain::Event::Parent) {
            let current=parent.ok_or("missing spatial object parent")?;let root=service.root.ok_or("missing spatial tree service root")?;
            crate::grass_pool::reindex(tree,current,root,index as u64,index as u64,state.integer_bounds,state.center[1],[state.local[1],state.local[4]],parent,|_|{},|event|apply(match event{crate::grass_insertion::Event::Insert(_)=>UpdateEvent::Insert,crate::grass_insertion::Event::Schedule(_)=>UpdateEvent::Schedule},state))?;
        }
        Ok(())
    })?;
    indexed.node.parent_present=parent.is_some();Ok(())
}
/// Owned equivalent of successful native71A560 wrapper destruction.
pub struct Wrapper {pub object:Option<usize>,pub released:bool}
#[derive(Clone,Copy)] pub enum WrapperEvent {ReserveObjects(usize),Release}
pub fn dispose(wrapper:&mut Wrapper,registry:&mut Registry,tree:&mut Tree,mut apply:impl FnMut(WrapperEvent))->Result<(),&'static str> {
    if wrapper.released{return Err("spatial wrapper already released");}
    if let Some(index)=wrapper.object {
        unregister_with_reservations(registry,tree,index,|capacity|apply(WrapperEvent::ReserveObjects(capacity)))?;
        wrapper.object=None;
    }
    apply(WrapperEvent::Release);wrapper.released=true;Ok(())
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn registration_constructor_order_bounds_radius_insertion_and_recycled_repeat_match_native() {
    check(include_str!("../../../data/4.20/grass_object_registry_contract.json"),false,false);
 }
 #[test] fn object_pool_sequences_preserve_all_handles_after_growth_and_internal_sources() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_object_pool_sequences_contract.json")).unwrap();assert_eq!(proof["passed"],true);
    for c in proof["cases"].as_array().unwrap() {
        let mut pool:Vec<usize>=c["initial"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as usize).collect();let mut capacity=c["capacity"].as_u64().unwrap() as usize;
        for step in c["steps"].as_array().unwrap() {
            // Resolve an internal handle before reserve relocates the host vector.
            let value=if let Some(index)=step["source_index"].as_u64(){pool[index as usize]}else{step["value"].as_u64().unwrap() as usize};assert_eq!(value,step["value"].as_u64().unwrap() as usize);
            let mut reservations=Vec::new();crate::grass_pool::push(&mut pool,&mut capacity,value,|e|if let crate::grass_pool::Event::ReservePool(capacity)=e{reservations.push(capacity);}).unwrap();
            assert_eq!(serde_json::json!(pool),step["handles"]);assert_eq!(serde_json::json!(reservations),step["reservations"]);assert_eq!(capacity,step["capacity"].as_u64().unwrap() as usize);
        }
    }
 }
 #[test] fn object_pool_reservation_matches_native_growth_and_reuse() {
    check(include_str!("../../../data/4.20/grass_object_growth_contract.json"),true,false);
 }
 #[test] fn wrapper_destruction_clears_registration_and_releases_once() {
    check(include_str!("../../../data/4.20/grass_wrapper_contract.json"),true,true);
    let mut registry=Registry{objects:Vec::new(),recycled:Vec::new(),recycled_capacity:0};
    let mut tree=Tree{nodes:Vec::new(),midpoints:Vec::new(),depths:Vec::new(),queued:Vec::new(),queue:Vec::new(),pool:Vec::new(),pool_capacity:0,max_depth:0};
    let mut wrapper=Wrapper{object:None,released:false};let mut releases=0;
    dispose(&mut wrapper,&mut registry,&mut tree,|e|if matches!(e,WrapperEvent::Release){releases+=1;}).unwrap();
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_wrapper_contract.json")).unwrap();
    assert_eq!(wrapper.object.is_none(),proof["empty_wrapper"]["cleared"].as_bool().unwrap());assert_eq!(wrapper.released,proof["empty_wrapper"]["freed_once"].as_bool().unwrap());assert_eq!(releases,1);
    assert!(dispose(&mut wrapper,&mut registry,&mut tree,|_|panic!("double release")).is_err());
 }
 fn check(source:&str,growth:bool,use_wrapper:bool) {
    let proof:serde_json::Value=serde_json::from_str(source).unwrap();assert_eq!(proof["passed"],true);
    let encode=|kind:&str,s:Snapshot|serde_json::json!({"kind":kind,"center_bits":s.center.map(f32::to_bits),"radius_bits":s.radius.to_bits(),"local_bits":s.local.map(f32::to_bits),"integer_bounds":s.integer_bounds});
    for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let profile=if c["integer_sse"].as_bool().unwrap(){IntegerProfile::Sse}else{IntegerProfile::LegacyCrt};
        let mut registry=Registry{objects:vec![Object{indexed:IndexedNode{node:Node{center:[0.;3],parent_present:false},local_bounds:[2.,3.,4.,5.,6.,7.],integer_bounds:[101,202,303,404],profile},radius:0.,parent:None,owner:0}],recycled:if c["reuse"].as_bool().unwrap(){vec![0]}else{Vec::new()},recycled_capacity:if growth{usize::from(c["reuse"].as_bool().unwrap())}else{32}};
        let mut tree=Tree{nodes:Vec::new(),midpoints:Vec::new(),depths:Vec::new(),queued:Vec::new(),queue:Vec::new(),pool:Vec::new(),pool_capacity:32,max_depth:0};let service=crate::grass_tree_service::create(&mut tree).unwrap();let root=service.root.unwrap();
        let center=std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32);let local=std::array::from_fn(|i|c["local"][i].as_f64().unwrap() as f32);
        for expected in [c,&c["repeat"]] {
            let mut events=Vec::new();let index=register(&mut registry,&mut tree,&service,7,center,local,profile,[0;4],|e,s|events.push(encode(match e{Event::Constructed=>"constructed",Event::Bounds=>"bounds",Event::Insert=>"insert"},s))).unwrap();
            assert_eq!(serde_json::json!(events),expected["events"],"native registration {case}");assert_eq!(encode("final",snapshot(&registry.objects[index])),expected["final"]);assert_eq!(tree.nodes[root].members.len(),expected["root_members"].as_u64().unwrap() as usize);assert_eq!(registry.objects[index].parent==Some(root),expected["parent_is_root"].as_bool().unwrap());assert_eq!(registry.objects[index].owner==7,expected["owner_is_wrapper"].as_bool().unwrap());assert_eq!(registry.recycled.len(),expected["object_pool_size"].as_u64().unwrap() as usize);
            let mut reservations=Vec::new();
            if use_wrapper {
                let mut wrapper=Wrapper{object:Some(index),released:false};let mut releases=0;
                dispose(&mut wrapper,&mut registry,&mut tree,|e|match e{WrapperEvent::ReserveObjects(capacity)=>reservations.push(capacity),WrapperEvent::Release=>releases+=1}).unwrap();
                assert_eq!(wrapper.object.is_none(),expected["wrapper_cleared"].as_bool().unwrap());assert_eq!(wrapper.released&&releases==1,expected["wrapper_freed_once"].as_bool().unwrap());assert_eq!(expected["returned_wrapper"],true);
            }else{unregister_with_reservations(&mut registry,&mut tree,index,|capacity|reservations.push(capacity)).unwrap();}
            if growth{assert_eq!(serde_json::json!(reservations),expected["reservations"]);assert_eq!(registry.recycled_capacity,expected["pool_capacity"].as_u64().unwrap() as usize);}
            assert_eq!(registry.objects[index].parent.is_none(),expected["after_unregister"]["parent_null"].as_bool().unwrap());assert_eq!(tree.nodes[root].members.len(),expected["after_unregister"]["root_members"].as_u64().unwrap() as usize);assert_eq!(registry.recycled.len(),expected["after_unregister"]["object_pool_size"].as_u64().unwrap() as usize);assert_eq!(registry.recycled.last()==Some(&index),expected["after_unregister"]["pool_top_same"].as_bool().unwrap());
        }
    }
 }
}
