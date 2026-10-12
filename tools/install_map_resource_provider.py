from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='#[allow(dead_code)] // Native provider lookup qualified; filesystem/archive table population pending.\nmod map_resource_provider;\n'+s;p.write_text(s,encoding='utf-8')
source=r'''//! Original90A480/90A4A0 local resource lookup and parent recursion.
//! Table population/archive enumeration remain separate native producers.
use std::collections::BTreeMap;
pub struct Provider {paths:BTreeMap<String,String>,parent:Option<Box<Provider>>}
impl Provider {
    pub fn from_entries(entries:impl IntoIterator<Item=(String,String)>,parent:Option<Box<Provider>>)->Result<Self,&'static str> {
        let mut paths=BTreeMap::new();
        for (key,value) in entries {
            // Native CRT non-ASCII/locale behavior and duplicate insertion are unqualified.
            if !key.is_ascii() || !value.is_ascii() {return Err("non-ASCII native resource table unqualified");}
            if paths.insert(key.to_ascii_lowercase(),value).is_some() {return Err("duplicate native resource key insertion unqualified");}
        }
        Ok(Self {paths,parent})
    }
    pub fn resolve(&self,key:&str)->Result<Option<&str>,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        if let Some(path)=self.paths.get(&key.to_ascii_lowercase()) {return Ok(Some(path));}
        self.parent.as_ref().map_or(Ok(None),|parent|parent.resolve(key))
    }
    pub fn contains(&self,key:&str)->Result<bool,&'static str> {Ok(self.resolve(key)?.is_some())}
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
''';(r/'crates/client/src/map_resource_provider.rs').write_text(source,encoding='utf-8');print('Native case-insensitive provider lookup ported; production table enumeration not connected.')
