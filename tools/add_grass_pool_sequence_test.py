from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_object_registry.rs';s=p.read_text(encoding='utf-8');assert 'fn object_pool_sequences' not in s
anchor=' #[test] fn object_pool_reservation_matches_native_growth_and_reuse() {'
test=''' #[test] fn object_pool_sequences_preserve_all_handles_after_growth_and_internal_sources() {
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
'''
s=s.replace(anchor,test+anchor);p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_wrapper.py','probe_native_grass_object_growth.py','probe_native_grass_object_pool_sequences.py','add_grass_pool_sequence_test.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
