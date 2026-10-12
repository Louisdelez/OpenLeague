from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/map_resource_provider.rs');s=p.read_text(encoding='utf-8')
insert='''
    /// Original905A00 accepts directory rows and sends them to905090.
    pub fn from_native_directories(rows:impl IntoIterator<Item=(String,String,bool)>)->Result<Self,&'static str> {
        Self::from_native_files(rows.into_iter().filter(|(_,_,directory)|*directory).map(|(folder,name,_)|(folder,name,false)))
    }
'''
assert 'pub fn from_native_directories' not in s;s=s.replace('    pub fn resolve(&self,key:',insert+'    pub fn resolve(&self,key:',1)
s+='''
#[cfg(test)] mod shared_directory_tests {
    use super::*;
    fn rows(values:&serde_json::Value)->Vec<(String,String,bool)> {
        values.as_array().unwrap().iter().map(|row|(row["folder"].as_str().unwrap().to_string(),row["name"].as_str().unwrap().to_string(),row["directory"].as_bool().unwrap_or(false))).collect()
    }
    fn compare(table:Provider,expected:&serde_json::Value) {
        let expected=expected.as_object().unwrap();assert_eq!(table.paths.len(),expected.len());
        for (key,path) in expected {assert_eq!(table.resolve(key).unwrap(),path.as_str(),"{key}");}
    }
    #[test] fn all_extracted_shared_files_match_original_recursive_collector_table() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/shared_resource_catalog_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        assert_eq!(proof["iterator_rows"].as_array().unwrap().len(),1328);
        compare(Provider::from_native_files(rows(&proof["iterator_rows"])).unwrap(),&proof["entries"]);
    }
    #[test] fn levels_characters_and_file_filter_match_original_directory_collector() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/resource_directories_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        for case in proof["cases"].as_array().unwrap() {
            compare(Provider::from_native_directories(rows(&case["iterator_rows"])).unwrap(),&case["entries"]);
        }
    }
}
'''
p.write_text(s,encoding='utf-8');print('Shared and directory native table comparisons installed')
