from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/map_resource_provider.rs');s=p.read_text(encoding='utf-8')
insert='''
    /// Original905090 alias/priority rules. Input order is supplied by the caller;
    /// native archive/recursive iterator order remains a separate IO contract.
    pub fn from_native_files(files:impl IntoIterator<Item=(String,String,bool)>)->Result<Self,&'static str> {
        let mut table=Self::from_entries(Vec::new(),None)?;
        for (folder,name,directory) in files {
            if directory || name=="." || name==".." {continue;}
            if !folder.is_ascii() || !name.is_ascii() || name.contains(['/', '\\\\']) {return Err("native resource filename/locale unqualified");}
            let path=format!("{folder}/{name}");
            let key=name.to_ascii_lowercase();
            let (stem,extension)=name.rsplit_once('.').unwrap_or((&name,""));
            let extension=extension.to_ascii_lowercase();
            if extension.ends_with("bin") || extension.ends_with("obj") {
                let logical=&name[..name.len()-3];
                table.paths.insert(logical.to_ascii_lowercase(),format!("{folder}/{logical}"));
                table.paths.insert(key,path);
            } else {match extension.as_str() {
                "dds"=>{
                    table.paths.entry(format!("{stem}.tga").to_ascii_lowercase()).or_insert_with(||path.clone());
                    table.paths.entry(key).or_insert(path);
                }
                "tga"=>{
                    let replace=table.paths.get(&key).map_or(true,|prior|prior.rsplit_once('.').is_some_and(|(_,ext)|ext.eq_ignore_ascii_case("dds")));
                    if replace {table.paths.insert(key,path);}
                }
                "scb"|"gfx"=>{
                    let alias=if extension=="scb" {"sco"} else {"swf"};
                    table.paths.insert(format!("{stem}.{alias}").to_ascii_lowercase(),path.clone());
                    table.paths.insert(key,path);
                }
                "sco"|"swf"=>{table.paths.entry(key).or_insert(path);}
                _=>{table.paths.insert(key,path);}
            }}
        }
        Ok(table)
    }
'''
assert 'pub fn from_native_files' not in s;s=s.replace('    pub fn resolve(&self,key:',insert+'    pub fn resolve(&self,key:',1)
old='let locals=Provider::from_entries(row["entries"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_string())),None).expect("native ASCII Map10 table");'
new='let locals=Provider::from_native_files(row["input_filenames"].as_array().unwrap().iter().map(|name|("Levels/Map10".into(),name.as_str().unwrap().to_string(),false))).expect("native ASCII Map10 insertion");'
assert old in s;s=s.replace(old,new)
s+='''
#[cfg(test)] mod native_population_tests {
    use super::*;
    fn compare(files:Vec<(String,String,bool)>,expected:&serde_json::Value) {
        let table=Provider::from_native_files(files).unwrap();let expected=expected.as_object().unwrap();
        assert_eq!(table.paths.len(),expected.len());
        for (key,path) in expected {assert_eq!(table.resolve(key).unwrap(),path.as_str(),"{key}");}
    }
    #[test] fn map_root_and_format_aliases_match_original_file_insertion() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_resource_population_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        for row in proof["cases"].as_array().unwrap() {
            compare(row["input_filenames"].as_array().unwrap().iter().map(|name|("Levels/Map10".into(),name.as_str().unwrap().into(),false)).collect(),&row["entries"]);
        }
    }
    #[test] fn recursive_files_and_competing_format_precedence_match_original_collector() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/recursive_resource_files_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        for row in proof["cases"].as_array().unwrap() {
            compare(row["iterator_rows"].as_array().unwrap().iter().map(|file|(file["folder"].as_str().unwrap().into(),file["name"].as_str().unwrap().into(),file["directory"].as_bool().unwrap_or(false))).collect(),&row["entries"]);
        }
    }
}
'''
p.write_text(s,encoding='utf-8');print('Native population bound to Map10 startup and comparison tests installed')
