from pathlib import Path
root=Path('E:/OpenLeague')
p=root/'crates/client/src/map_resource_provider.rs'
s=p.read_text(encoding='utf-8')
s=s.replace('parent:Option<Box<Provider>>}', 'parent:Option<Parent>} ',1)
s=s.replace('Ok(Self {paths,parent})','Ok(Self {paths,parent:parent.map(Parent::Local)})',1)
s=s.replace('pub fn contains(&self,key:&str)->Result<bool,&\'static str> {Ok(self.resolve(key)?.is_some())}', '''pub fn contains(&self,key:&str)->Result<bool,&'static str> {
        if !key.is_ascii() {return Err("non-ASCII native resource lookup unqualified");}
        if self.paths.contains_key(&key.to_ascii_lowercase()) {return Ok(true);}
        self.parent.as_ref().map_or(Ok(false),|parent|parent.contains(key))
    }
    /// Original virtual parent setter; requires a separately qualified search context producer.
    pub fn with_search_parent(mut self,parent:SearchProvider)->Self {
        self.parent=Some(Parent::Search(Box::new(parent)));self
    }''',1)
insert='''
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
'''
assert 'pub struct SearchProvider' not in s
s=s.replace('#[cfg(test)] mod tests {',insert+'\n#[cfg(test)] mod tests {',1)
p.write_text(s,encoding='utf-8')
print('Native search provider and original-observation comparison installed')
