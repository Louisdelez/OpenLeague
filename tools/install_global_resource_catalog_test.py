from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/map_resource_provider.rs')
s=p.read_text(encoding='utf-8');assert 'actual_extracted_global_catalog_matches_original_fog_resource_queries' not in s
s+='''
#[cfg(test)] mod global_catalog_tests {
    use super::*;
    #[test] fn actual_extracted_global_catalog_matches_original_fog_resource_queries() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/global_resource_catalog_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);
        let inputs=proof["input_files"].as_array().unwrap().iter().map(|path| {
            let (folder,name)=path.as_str().unwrap().rsplit_once('/').unwrap();(folder.to_string(),name.to_string(),false)
        });
        let rebuilt=Provider::from_native_files(inputs).unwrap();
        assert_eq!(rebuilt.paths.len(),proof["entries"].as_object().unwrap().len());
        for (key,path) in proof["entries"].as_object().unwrap() {
            assert_eq!(rebuilt.resolve(key).unwrap(),path.as_str(),"{key}");
        }
        let entries=proof["entries"].as_object().unwrap().iter().map(|(key,value)|(key.clone(),value.as_str().unwrap().to_string())).collect::<Vec<_>>();
        let global=SearchProvider::from_contexts(vec![entries],None).unwrap();
        let map=Map10Catalog::default();assert!(!map.parent_qualified);
        let delegated=map.locals.with_search_parent(global);
        // This explicitly assembled partial parent remains a test fixture;
        // Shared/Levels/Characters traversal is required before production binding.
        for row in proof["lookups"].as_array().unwrap() {
            let key=row["key"].as_str().unwrap();
            assert_eq!(delegated.contains(key).unwrap(),row["present"].as_bool().unwrap(),"{key}");
            assert_eq!(delegated.resolve(key).unwrap().unwrap_or(""),row["resolved"].as_str().unwrap(),"{key}");
        }
        assert_eq!(delegated.resolve("terrain.ini").unwrap(),Some("Levels/Map10/terrain.ini"));
    }
}
'''
p.write_text(s,encoding='utf-8')
print('Actual native global catalog comparison test installed')
