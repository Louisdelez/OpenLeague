//! Original90A480/90A4A0 local resource lookup and parent recursion.
//! Table population/archive enumeration remain separate native producers.
use std::collections::BTreeMap;
pub struct Provider {paths:BTreeMap<String,String>,parent:Option<Parent>} 
impl Provider {
    pub fn from_entries(entries:impl IntoIterator<Item=(String,String)>,parent:Option<Box<Provider>>)->Result<Self,&'static str> {
        let mut paths=BTreeMap::new();
        for (key,value) in entries {
            // Native CRT non-ASCII/locale behavior and duplicate insertion are unqualified.
            if !key.is_ascii() || !value.is_ascii() {return Err("non-ASCII native resource table unqualified");}
            if paths.insert(key.to_ascii_lowercase(),value).is_some() {return Err("duplicate native resource key insertion unqualified");}
        }
        Ok(Self {paths,parent:parent.map(Parent::Local)})
    }

    /// Original905090 alias/priority rules. Input order is supplied by the caller;
    /// native archive/recursive iterator order remains a separate IO contract.
    pub fn from_native_files(files:impl IntoIterator<Item=(String,String,bool)>)->Result<Self,&'static str> {
        let mut table=Self::from_entries(Vec::new(),None)?;
        for (folder,name,directory) in files {
            if directory || name=="." || name==".." {continue;}
            if !folder.is_ascii() || !name.is_ascii() || name.contains(['/', '\\']) {return Err("native resource filename/locale unqualified");}
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

    /// Original905A00 accepts directory rows and sends them to905090.
    pub fn from_native_directories(rows:impl IntoIterator<Item=(String,String,bool)>)->Result<Self,&'static str> {
        Self::from_native_files(rows.into_iter().filter(|(_,_,directory)|*directory).map(|(folder,name,_)|(folder,name,false)))
    }
    pub fn resolve(&self,key:&str)->Result<Option<&str>,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        if let Some(path)=self.paths.get(&key.to_ascii_lowercase()) {return Ok(Some(path));}
        self.parent.as_ref().map_or(Ok(None),|parent|parent.resolve(key))
    }
    pub fn contains(&self,key:&str)->Result<bool,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        if self.paths.contains_key(&key.to_ascii_lowercase()) {return Ok(true);}
        self.parent.as_ref().map_or(Ok(false),|parent|parent.contains(key))
    }
    /// Original virtual parent setter; requires a separately qualified search context producer.
    pub fn with_search_parent(mut self,parent:SearchProvider)->Self {
        self.parent=Some(Parent::Search(Box::new(parent)));self
    }
}

enum Parent {Local(Box<Provider>),Search(Box<SearchProvider>)}
impl Parent {
    fn resolve(&self,key:&str)->Result<Option<&str>,&'static str> {
        match self {Self::Local(p)=>p.resolve(key),Self::Search(p)=>p.resolve(key)}
    }
    fn contains(&self,key:&str)->Result<bool,&'static str> {
        match self {Self::Local(p)=>p.contains(key),Self::Search(p)=>p.contains(key)}
    }
}

/// Original904CD0/904EC0 search provider. Contexts must retain native order.
/// Cache/list construction and actual global contexts remain unqualified.
pub struct SearchProvider {contexts:Vec<Provider>,parent:Option<Box<Provider>>}
impl SearchProvider {
    pub fn from_contexts(contexts:Vec<Vec<(String,String)>>,parent:Option<Box<Provider>>)->Result<Self,&'static str> {
        let contexts=contexts.into_iter().map(|entries|Provider::from_entries(entries,None)).collect::<Result<Vec<_>,_>>()?;
        Ok(Self {contexts,parent})
    }
    pub fn resolve(&self,key:&str)->Result<Option<&str>,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        for context in &self.contexts {
            if let Some(path)=context.resolve(key)?.filter(|path|!path.is_empty()) {return Ok(Some(path));}
        }
        Ok(self.parent.as_ref().map_or(Ok(None),|parent|parent.resolve(key))?.filter(|path|!path.is_empty()))
    }
    pub fn contains(&self,key:&str)->Result<bool,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        // Native existence checks consult fallback inside each context iteration.
        // With no contexts the fallback is never queried, unlike resolve().
        for context in &self.contexts {
            if context.contains(key)? || self.parent.as_ref().map_or(Ok(false),|parent|parent.contains(key))? {return Ok(true);}
        }
        Ok(false)
    }
}

#[cfg(test)] mod search_tests {
    use super::*;
    #[test] fn ordered_contexts_empty_paths_and_map_delegation_match_original_search_provider() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/search_resource_provider_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),24);
        let entries=|v:&serde_json::Value|v.as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_string())).collect::<Vec<_>>();
        for c in proof["cases"].as_array().unwrap() {
            let parent=Provider::from_entries(entries(&c["parent"]),None).unwrap();
            let contexts=c["contexts"].as_array().unwrap().iter().map(entries).collect();
            let search=SearchProvider::from_contexts(contexts,Some(Box::new(parent))).unwrap();
            let key=c["key"].as_str().unwrap();let present=c["present"].as_bool().unwrap();let resolved=c["resolved"].as_str().unwrap();
            assert_eq!(search.contains(key).unwrap(),present,"{} {key}",c["name"]);
            assert_eq!(search.resolve(key).unwrap().unwrap_or(""),resolved,"{} {key}",c["name"]);
            assert_eq!(search.contains(&key.to_ascii_uppercase()).unwrap(),present);
            let map=Provider::from_entries(vec![("terrain.ini".into(),"Levels/Map10/terrain.ini".into())],None).unwrap().with_search_parent(search);
            assert_eq!(map.contains(key).unwrap(),present);assert_eq!(map.resolve(key).unwrap().unwrap_or(""),resolved);
            assert_eq!(map.resolve("terrain.ini").unwrap(),Some("Levels/Map10/terrain.ini"));
            assert!(map.contains("terrain.ini").unwrap());
        }
    }
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn lookup_case_parent_priority_and_empty_local_entry_match_original_methods() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_resource_lookup_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        let entries=|v:&serde_json::Value|v.as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_string())).collect::<Vec<_>>();
        for c in proof["cases"].as_array().unwrap() {
            let parent=Provider::from_entries(entries(&c["parent"]),None).unwrap();let provider=Provider::from_entries(entries(&c["local"]),Some(Box::new(parent))).unwrap();let key=c["key"].as_str().unwrap();
            assert_eq!(provider.contains(key).unwrap(),c["present"].as_bool().unwrap(),"{} {key}",c["name"]);
            assert_eq!(provider.resolve(key).unwrap().unwrap_or(""),c["resolved"].as_str().unwrap(),"{} {key}",c["name"]);
        }
    }
}


/// Recovered extracted snapshot in native default context `now`.
/// This supplies the current reconstruction; native IO/launch override fidelity
/// remains explicit in Map10Catalog::parent_qualified.
pub struct RecoveredGlobalCatalog {pub provider:SearchProvider,pub files:usize,pub entries:usize}
impl Default for RecoveredGlobalCatalog {
    fn default()->Self {
        let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/recovered_global_resource_manifest.json")).expect("native recovered global resource manifest");
        assert_eq!(manifest["context_name"],"now");
        let rows=manifest["files"].as_array().unwrap();
        let table=Provider::from_native_files(rows.iter().map(|row|(row[0].as_str().unwrap().into(),row[1].as_str().unwrap().into(),row[2].as_bool().unwrap()))).expect("native recovered global insertion");
        let entries=table.paths.len();assert_eq!(entries,manifest["native_entries"].as_u64().unwrap() as usize);
        Self {provider:SearchProvider {contexts:vec![table],parent:None},files:rows.len(),entries}
    }
}

/// Actual native table produced from extracted Map10 root files. This catalog has
/// a recovered default-context parent; full native IO and override qualification
/// remains open, so parent_qualified retains false.
#[derive(bevy::prelude::Resource)]
pub struct Map10Catalog {pub locals:Provider,pub terrain_path:String,pub parent_qualified:bool,pub global_files:usize,pub global_entries:usize,pub default_overlay_path:Option<String>}
impl Default for Map10Catalog {
    fn default()->Self {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_resource_population_contract.json")).expect("qualified native Map10 resource population");
        let row=proof["cases"].as_array().unwrap().iter().find(|c|c["name"]=="map10-original-files").expect("actual Map10 native table");
        let local_table=Provider::from_native_files(row["input_filenames"].as_array().unwrap().iter().map(|name|("Levels/Map10".into(),name.as_str().unwrap().to_string(),false))).expect("native ASCII Map10 insertion");
        let global=RecoveredGlobalCatalog::default();let global_files=global.files;let global_entries=global.entries;
        let locals=local_table.with_search_parent(global.provider);
        let default_overlay_path=locals.resolve("DefaultFogOfWarOverlay.dds").unwrap().map(str::to_string);
        let terrain_path=locals.resolve("terrain.ini").unwrap().expect("native Map10 terrain config alias").to_string();
        if let Ok(path)=std::env::var("OPENLEAGUE_MAP_RESOURCE_PROBE") {
            let report=serde_json::json!({"complete":false,"native_population_entries":row["entries"].as_object().unwrap().len(),"source_files":proof["sources"].as_array().unwrap().len(),"terrain_path":terrain_path,"local_overlay_present":locals.contains("FOWTexture").unwrap(),"parent_qualified":false,"global_profile":"recovered_extracted_default_context","global_files":global_files,"global_entries":global_entries,"default_overlay_path":default_overlay_path,"limits":["Recovered default-context parent is bound; original archive order, whole IO constructor and launch overrides remain open.","Available overlay path is a resource lookup, not proof of normal fog rendering or complete initialization."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
        }
        Self {locals,terrain_path,parent_qualified:false,global_files,global_entries,default_overlay_path}
    }
}
#[cfg(test)] mod catalog_tests {
    use super::*;
    #[test] fn actual_map10_native_catalog_retains_binary_config_and_texture_alias_paths() {
        let catalog=Map10Catalog::default();assert!(!catalog.parent_qualified);
        assert_eq!(catalog.terrain_path,"Levels/Map10/terrain.ini");
        assert_eq!(catalog.locals.resolve("TERRAIN.INIBIN").unwrap(),Some("Levels/Map10/terrain.inibin"));
        assert_eq!(catalog.locals.resolve("FogLightingMap.tga").unwrap(),Some("Levels/Map10/fogLightingMap.dds"));
        assert!(!catalog.locals.contains("FOWTexture").unwrap());
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_resource_population_contract.json")).unwrap();
        let expected=proof["cases"][0]["entries"].as_object().unwrap();assert_eq!(catalog.locals.paths.len(),expected.len());
        for (key,path) in expected {assert_eq!(catalog.locals.resolve(key).unwrap(),path.as_str());}
    }
}

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

#[cfg(test)] mod recovered_global_tests {
    use super::*;
    #[test] fn merged_recovered_profile_matches_every_native_entry_and_startup_fog_queries() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/global_resource_merge_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        let global=RecoveredGlobalCatalog::default();let expected=proof["entries"].as_object().unwrap();assert_eq!(global.entries,expected.len());assert_eq!(global.files,25198);
        for (key,path) in expected {assert_eq!(global.provider.resolve(key).unwrap(),path.as_str(),"{key}");}
        let map=Map10Catalog::default();assert!(!map.parent_qualified);assert_eq!(map.global_entries,46595);
        for row in proof["lookups"].as_array().unwrap() {
            let key=row["key"].as_str().unwrap();assert_eq!(map.locals.contains(key).unwrap(),row["present"].as_bool().unwrap());assert_eq!(map.locals.resolve(key).unwrap().unwrap_or(""),row["resolved"].as_str().unwrap());
        }
        assert_eq!(map.default_overlay_path.as_deref(),Some("DATA/Shaders/Texture/DefaultFogOfWarOverlay.dds"));
        assert_eq!(map.terrain_path,"Levels/Map10/terrain.ini");
    }
}
