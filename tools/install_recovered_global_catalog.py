from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
base=load('data/4.20/global_resource_catalog_contract.json');merge=load('data/4.20/global_resource_merge_contract.json');assert merge['passed'] and base['passed']
files=[list(path.rsplit('/',1))+[False] for path in base['input_files']]+[[row['folder'],row['name'],False] for row in merge['tail_rows']]
manifest={'complete':False,'context_name':'now','profile':'recovered_extracted_default_context','files':files,'native_entries':len(merge['entries']),'merge_contract_sha256':hashlib.sha256((r/'data/4.20/global_resource_merge_contract.json').read_bytes()).hexdigest(),'limits':['Sorted extracted filename order is explicit; original archive order/launch overrides remain unqualified.','Global cached profile reproduces original insertion/merge observations; whole native IO constructor and normal fog rendering remain incomplete.']}
(r/'data/4.20/recovered_global_resource_manifest.json').write_text(json.dumps(manifest,separators=(',',':'))+'\n',encoding='utf-8')
p=r/'crates/client/src/map_resource_provider.rs';s=p.read_text(encoding='utf-8');assert 'pub struct RecoveredGlobalCatalog' not in s
insert='''
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
'''
s=s.replace('/// Actual native table produced from extracted Map10 root files.',insert+'\n/// Actual native table produced from extracted Map10 root files.',1)
s=s.replace('pub struct Map10Catalog {pub locals:Provider,pub terrain_path:String,pub parent_qualified:bool}','pub struct Map10Catalog {pub locals:Provider,pub terrain_path:String,pub parent_qualified:bool,pub global_files:usize,pub global_entries:usize,pub default_overlay_path:Option<String>}')
line=next(line for line in s.splitlines() if 'let locals=Provider::from_native_files(row[' in line)
s=s.replace(line,line.replace('let locals=','let local_table=')+'''\n        let global=RecoveredGlobalCatalog::default();let global_files=global.files;let global_entries=global.entries;
        let locals=local_table.with_search_parent(global.provider);
        let default_overlay_path=locals.resolve("DefaultFogOfWarOverlay.dds").unwrap().map(str::to_string);''')
s=s.replace('"parent_qualified":false,"limits":["Native population executed with extracted directory filenames; archive enumeration and inherited table remain open.","Overlay fallback not inferred from local table absence."]','"parent_qualified":false,"global_profile":"recovered_extracted_default_context","global_files":global_files,"global_entries":global_entries,"default_overlay_path":default_overlay_path,"limits":["Recovered default-context parent is bound; original archive order, whole IO constructor and launch overrides remain open.","Available overlay path is a resource lookup, not proof of normal fog rendering or complete initialization."]')
s=s.replace('Self {locals,terrain_path,parent_qualified:false}','Self {locals,terrain_path,parent_qualified:false,global_files,global_entries,default_overlay_path}')
s=s.replace('/// no inferred parent: callers must qualify its contents before overlay fallback.','/// a recovered default-context parent; full native IO and override qualification\n/// remains open, so parent_qualified retains false.')
s+='''
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
'''
p.write_text(s,encoding='utf-8');print(json.dumps({'manifest_files':len(files),'native_entries':len(merge['entries']),'startup_parent_bound':True,'native_io_qualified':False}))
