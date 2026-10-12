from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/fow_terrain_ray.rs';s=p.read_text(encoding='utf-8')
old='''    let count=(i64::from(high_x)-i64::from(low_x)+1)*(i64::from(high_z)-i64::from(low_z)+1);
    if !(0..=1000).contains(&count) {return Err("native source flag scan exceeds budget");}
'''
assert old in s;s=s.replace(old,'    let mut budget=1000i32;\n')
s=s.replace('    for iz in low_z..=high_z {\n        let dz=sample_z-z;',"    'scan: for iz in low_z..=high_z {\n        if budget<0 {break;}\n        let dz=sample_z-z;",1)
s=s.replace('            for ix in low_x..=high_x {\n                let dx=sample_x-x;',"            for ix in low_x..=high_x {\n                if budget<0 {break 'scan;}\n                budget-=1;\n                let dx=sample_x-x;",1)
s=s.replace('''        }
        sample_z+=terrain.cell_size;
''','''        } else {budget-=1;}
        sample_z+=terrain.cell_size;
''',1)
marker='    #[test] fn terrain_traversal_matches_original_flag_column_masks() {'
assert marker in s
s=s.replace(marker,'''    #[test] fn source_query_matches_native_thresholds_and_exhausted_scan_budget() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_terrain_budget_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let flags:Vec<u16>=p["patterns"][c["pattern"].as_u64().unwrap() as usize].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect();
            let terrain=TerrainGrid{width:8,height:8,origin:[0.;3],cell_size:c["cell_size"].as_f64().unwrap() as f32,flags:&flags};
            let center=std::array::from_fn(|i|f32::from_bits(c["position_bits"][i].as_u64().unwrap() as u32));
            let radius=f32::from_bits(c["radius_bits"].as_u64().unwrap() as u32);
            assert_eq!(source_flag(center,radius,&terrain).unwrap(),c["result"].as_bool().unwrap(),"native query {c}");
        }
    }
    #[test] fn actor_cache_uses_original_map10_terrain_query_and_reuses_result() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_map10_contract.json")).unwrap();assert_eq!(p["passed"],true);
        let meta:serde_json::Value=serde_json::from_str(include_str!("../../../assets/maps/tt_navigation_grid.json")).unwrap();
        let flags:Vec<u16>=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin").chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid{width:meta["width"].as_u64().unwrap() as usize,height:meta["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|meta["min"][i].as_f64().unwrap() as f32),cell_size:meta["cellSize"].as_f64().unwrap() as f32,flags:&flags};
        for c in p["cases"].as_array().unwrap() {
            let mut cache=crate::grass_actor_cache::Cache{x:0.,z:0.,radius:0.,result:0};
            let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);
            let radius=c["radius"].as_f64().unwrap() as f32;
            for frame in c["frames"].as_array().unwrap() {
                let mut calls=Vec::new();let result=cache.update(position,0.,radius,|x,z,r|{calls.push([x.to_bits(),z.to_bits(),r.to_bits()]);u8::from(source_flag([x,z],r,&terrain).unwrap())});
                assert_eq!(result,frame["result"].as_u64().unwrap() as u8);
                let expected:Vec<[u32;3]>=frame["query_calls"].as_array().unwrap().iter().map(|row|std::array::from_fn(|i|row[i].as_u64().unwrap() as u32)).collect();assert_eq!(calls,expected);
                assert_eq!([cache.x.to_bits(),cache.z.to_bits(),cache.radius.to_bits()],std::array::from_fn(|i|frame["cache_bits"][i].as_u64().unwrap() as u32));
            }
        }
    }
'''+marker)
p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_terrain_budget.py','integrate_grass_terrain_budget.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native scan budget ported and native grid/cache comparisons installed.')
