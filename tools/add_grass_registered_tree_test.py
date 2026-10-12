from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_actor_aabb.rs';s=p.read_text(encoding='utf-8');assert 'fn full_owned_actor' not in s
anchor='    #[test] fn full_actor_refresh_with_registered_spatial_node_matches_original_method() {'
test='''    #[test] fn full_owned_actor_refresh_reindexes_real_tree_at_each_native_callback() {
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
'''
assert anchor in s;s=s.replace(anchor,test+anchor);p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/add_grass_registered_tree_test.py'),r/'tools/add_grass_registered_tree_test.py')
