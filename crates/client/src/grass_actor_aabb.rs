//! Native6151A0 AABB calculation prefix; model providers remain explicit.
pub fn calculate(position:[f32;3],model_scales:Option<[f32;2]>,mut bounds:impl FnMut()->[f32;6])->[f32;6] {
    let (width,height,min_y)=if let Some([model_scale,actor_scale])=model_scales {
        let first=bounds();let z_span=first[5]-first[2];
        let second=bounds();let x_span=second[3]-second[0];
        let mean=(x_span+z_span)*0.5;
        let third=bounds();let scale=model_scale*actor_scale;
        let height=(third[4]-third[1])*scale;let width=scale*mean;
        let fourth=bounds();(width,height,fourth[1])
    } else {(25.,85.,0.)};
    let min_x=position[0]-width*0.5;let min_y=position[1]+min_y;let min_z=position[2]-width*0.5;
    [min_x,min_y,min_z,min_x+width,min_y+height,min_z+width]
}
pub fn source(eligibility:crate::grass_sources::Eligibility,position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6])->crate::grass_sources::Actor {
    crate::grass_sources::Actor{eligibility,aabb:calculate(position,model_scales,bounds)}
}
/// Derived fields of complete6151A0; registered spatial propagation is separate.
pub struct State {pub aabb:[f32;6],pub height:f32,pub radius:f32,pub derived:[f32;6],pub sentinel:u32}
pub fn refresh(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32)->State {
    let aabb=calculate(position,model_scales,bounds);
    derive(aabb,raw_shape,raw_radius,initial_height,initial_radius)
}
/// Runs the registered spatial chain before committing native derived actor metrics.
pub fn refresh_registered(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32,node:Option<&mut crate::grass_spatial_dispatch::IndexedNode>,spatial_radius:&mut f32,apply:impl FnMut(crate::grass_spatial_chain::Event,crate::grass_spatial_chain::Snapshot))->Result<State,&'static str> {
    let aabb=calculate(position,model_scales,bounds);
    crate::grass_spatial_chain::propagate(aabb,node,spatial_radius,apply)?;
    Ok(derive(aabb,raw_shape,raw_radius,initial_height,initial_radius))
}
/// Refreshes actor metrics through its owned spatial registry and tree.
pub fn refresh_owned(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32,registry:&mut crate::grass_object_registry::Registry,tree:&mut crate::grass_subdivision::Tree,service:&crate::grass_tree_service::Service,object:Option<usize>,apply:impl FnMut(crate::grass_object_registry::UpdateEvent,crate::grass_spatial_chain::Snapshot))->Result<State,&'static str> {
    let aabb=calculate(position,model_scales,bounds);
    if let Some(index)=object{crate::grass_object_registry::update_aabb(registry,tree,service,index,aabb,apply)?;}
    Ok(derive(aabb,raw_shape,raw_radius,initial_height,initial_radius))
}
fn derive(aabb:[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32)->State {
    // Original COMISS zero,raw followed by JB skips replacement for positive or unordered.
    let height=if raw_shape>0. || raw_shape.is_nan(){initial_height}else{aabb[4]-aabb[1]};
    let radius=if raw_radius>0. || raw_radius.is_nan(){initial_radius}else{100.};
    let factor=f32::from_bits(0x3f051eb8);let first=radius*factor;let second=first*factor;
    State{aabb,height,radius,derived:[height,height,height,radius,first,second],sentinel:u32::MAX}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn full_owned_actor_refresh_reindexes_real_tree_at_each_native_callback() {
        use crate::{grass_object_registry::{Registry,UpdateEvent},grass_spatial_bounds::IntegerProfile,grass_subdivision::Tree};
        let inputs:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_registered_tree_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        let serialize=|kind:&str,state:crate::grass_spatial_chain::Snapshot|serde_json::json!({"kind":kind,"center_bits":state.center.map(f32::to_bits),"local_bits":state.local.map(f32::to_bits),"radius_bits":state.radius.to_bits(),"integer_bounds":state.integer_bounds});
        for (case,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let input=&inputs["cases"][c["input_index"].as_u64().unwrap() as usize];
            let position=std::array::from_fn(|i|input["position"][i].as_f64().unwrap() as f32);
            let scales=(input["profile"].as_u64().unwrap()!=0).then(||[input["model_scale"].as_f64().unwrap() as f32,input["actor_scale"].as_f64().unwrap() as f32]);
            let profile=if c["integer_sse"].as_bool().unwrap(){IntegerProfile::Sse}else{IntegerProfile::LegacyCrt};
            let mut registry=Registry{objects:Vec::new(),recycled:Vec::new(),recycled_capacity:32};
            let mut tree=Tree{nodes:Vec::new(),midpoints:Vec::new(),depths:Vec::new(),queued:Vec::new(),queue:Vec::new(),pool:Vec::new(),pool_capacity:32,max_depth:0};
            let service=crate::grass_tree_service::create(&mut tree).unwrap();let root=service.root.unwrap();
            if c["narrow"].as_bool().unwrap(){tree.nodes[root].bounds=[-10,-10,10,10];tree.midpoints[root]=[0;2];}
            let index=crate::grass_object_registry::register(&mut registry,&mut tree,&service,7,[0.;3],[-5.,-7.,-9.,5.,7.,9.],profile,[0;4],|_,_|{}).unwrap();
            assert_eq!(serde_json::json!(tree.nodes[root].vertical.map(f32::to_bits)),c["initial_vertical_bits"]);
            let mut height=71.;let mut actor_radius=19.;
            for expected in [c,&c["repeat"]] {
                let mut calls=Vec::new();let mut events=Vec::new();
                let state=refresh_owned(position,scales,||{let seq=input["bounds_calls"].as_array().unwrap();let value=std::array::from_fn(|i|seq[calls.len().min(seq.len()-1)][i].as_f64().unwrap() as f32);calls.push(value);value},c["raw_shape"].as_f64().unwrap() as f32,c["raw_radius"].as_f64().unwrap() as f32,height,actor_radius,&mut registry,&mut tree,&service,Some(index),|event,state|events.push(serialize(match event{UpdateEvent::Bounds=>"bounds",UpdateEvent::Parent=>"parent",UpdateEvent::Extents=>"extents",UpdateEvent::Insert=>"insert",UpdateEvent::Schedule=>"schedule"},state))).unwrap();
                let object=&registry.objects[index];let spatial=crate::grass_spatial_chain::Snapshot{center:object.indexed.node.center,local:object.indexed.local_bounds,radius:object.radius,integer_bounds:object.indexed.integer_bounds};
                assert_eq!(serde_json::json!(events),expected["events"],"owned actor events {case}");assert_eq!(serialize("final",spatial),expected["final"]);
                assert_eq!(serde_json::json!(tree.nodes[root].vertical.map(f32::to_bits)),expected["root_vertical_bits"],"owned root vertical {case}");assert_eq!(tree.nodes[root].members.len(),expected["root_members"].as_u64().unwrap() as usize);assert_eq!(object.parent==Some(root),expected["parent_is_root"].as_bool().unwrap());
                assert_eq!(serde_json::json!([state.height,state.radius,state.derived[0],state.derived[1],state.derived[2],state.derived[3],state.derived[4],state.derived[5]].map(f32::to_bits)),expected["state_bits"]);assert_eq!(state.sentinel,expected["sentinel"].as_u64().unwrap() as u32);
                assert_eq!(serde_json::json!(state.aabb.map(f32::to_bits)),input["aabb_bits"]);assert_eq!(serde_json::json!(calls),expected["bounds_calls"]);height=state.height;actor_radius=state.radius;
            }
        }
    }
    #[test] fn full_actor_refresh_with_registered_spatial_node_matches_original_method() {
        use crate::{grass_spatial_dispatch::{IndexedNode,Node},grass_spatial_bounds::IntegerProfile,grass_spatial_chain::{Event,Snapshot}};
        let inputs:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_registered_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        let serialize=|kind:&str,s:Snapshot|serde_json::json!({"kind":kind,"center_bits":s.center.map(f32::to_bits),"local_bits":s.local.map(f32::to_bits),"radius_bits":s.radius.to_bits(),"integer_bounds":s.integer_bounds});
        for (index,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let input=&inputs["cases"][c["input_index"].as_u64().unwrap() as usize];
            let position=std::array::from_fn(|i|input["position"][i].as_f64().unwrap() as f32);
            let scales=(input["profile"].as_u64().unwrap()!=0).then(||[input["model_scale"].as_f64().unwrap() as f32,input["actor_scale"].as_f64().unwrap() as f32]);
            let mut node=IndexedNode{node:Node{center:[0.;3],parent_present:c["parent_present"].as_bool().unwrap()},local_bounds:std::array::from_fn(|i|c["initial_local"][i].as_f64().unwrap() as f32),integer_bounds:[101,202,303,404],profile:if c["integer_sse"].as_bool().unwrap(){IntegerProfile::Sse}else{IntegerProfile::LegacyCrt}};
            let mut radius=99.;let mut height=71.;let mut actor_radius=19.;
            for expected in [c,&c["repeat"]] {
                let mut calls=Vec::new();let mut events=Vec::new();
                let state=refresh_registered(position,scales,||{let seq=input["bounds_calls"].as_array().unwrap();let value=std::array::from_fn(|i|seq[calls.len().min(seq.len()-1)][i].as_f64().unwrap() as f32);calls.push(value);value},c["raw_shape"].as_f64().unwrap() as f32,c["raw_radius"].as_f64().unwrap() as f32,height,actor_radius,c["node_present"].as_bool().unwrap().then_some(&mut node),&mut radius,|event,s|events.push(serialize(match event{Event::Bounds=>"bounds",Event::Parent=>"parent",Event::Extents=>"extents"},s))).unwrap();
                assert_eq!(serde_json::json!(events),expected["events"],"registered actor event order {index}");
                assert_eq!(serialize("final",Snapshot{center:node.node.center,local:node.local_bounds,radius,integer_bounds:node.integer_bounds}),expected["final"],"registered spatial state {index}");
                let actual=[state.height,state.radius,state.derived[0],state.derived[1],state.derived[2],state.derived[3],state.derived[4],state.derived[5]].map(f32::to_bits);
                assert_eq!(actual,std::array::from_fn(|i|expected["state_bits"][i].as_u64().unwrap() as u32));assert_eq!(state.sentinel,expected["sentinel"].as_u64().unwrap() as u32);
                assert_eq!(state.aabb.map(f32::to_bits),std::array::from_fn(|i|input["aabb_bits"][i].as_u64().unwrap() as u32));assert_eq!(serde_json::json!(calls),expected["bounds_calls"]);
                height=state.height;actor_radius=state.radius;
            }
        }
    }

    #[test] fn full_method_metrics_match_original_no_spatial_node_path() {
        let inputs:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_full_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let input=&inputs["cases"][c["input_index"].as_u64().unwrap() as usize];let profile=input["profile"].as_u64().unwrap() as usize;
            let position=std::array::from_fn(|i|input["position"][i].as_f64().unwrap() as f32);
            let scales=(profile!=0).then(||[input["model_scale"].as_f64().unwrap() as f32,input["actor_scale"].as_f64().unwrap() as f32]);
            let mut calls=0;let state=refresh(position,scales,||{let seq=input["bounds_calls"].as_array().unwrap();let v=std::array::from_fn(|i|seq[calls.min(seq.len()-1)][i].as_f64().unwrap() as f32);calls+=1;v},f32::from_bits(c["raw_shape_bits"].as_u64().unwrap() as u32),f32::from_bits(c["raw_radius_bits"].as_u64().unwrap() as u32),c["initial_height"].as_f64().unwrap() as f32,c["initial_radius"].as_f64().unwrap() as f32);
            assert_eq!(state.aabb.map(f32::to_bits),std::array::from_fn(|i|input["aabb_bits"][i].as_u64().unwrap() as u32));
            let actual=[state.height,state.radius,state.derived[0],state.derived[1],state.derived[2],state.derived[3],state.derived[4],state.derived[5]].map(f32::to_bits);
            assert_eq!(actual,std::array::from_fn(|i|c["state_bits"][i].as_u64().unwrap() as u32));assert_eq!(state.sentinel,c["sentinel"].as_u64().unwrap() as u32);assert_eq!(calls,input["bounds_calls"].as_array().unwrap().len());
        }
    }

    #[test] fn calculated_collector_source_matches_original_aabb_writes_and_getter_calls() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let profile=c["profile"].as_u64().unwrap() as usize;let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);
            let scales=(profile!=0).then(||[c["model_scale"].as_f64().unwrap() as f32,c["actor_scale"].as_f64().unwrap() as f32]);
            let mut calls=Vec::new();let actor=source(crate::grass_sources::Eligibility{enabled:1,flags_b0:0,flags_e0:0x40,virtual74:1,virtual1e0:true,virtual90:true},position,scales,||{let samples=p["profiles"][profile].as_array().expect("native model present");let value=std::array::from_fn(|i|samples[calls.len().min(samples.len()-1)][i].as_f64().unwrap() as f32);calls.push(value);value});
            assert_eq!(actor.aabb.map(f32::to_bits),std::array::from_fn(|i|c["aabb_bits"][i].as_u64().unwrap() as u32),"native AABB {c}");
            let expected:Vec<[f32;6]>=c["bounds_calls"].as_array().unwrap().iter().map(|row|std::array::from_fn(|i|row[i].as_f64().unwrap() as f32)).collect();assert_eq!(calls,expected);
        }
    }
}
