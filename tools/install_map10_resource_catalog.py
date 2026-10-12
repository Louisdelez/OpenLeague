from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8').replace('        .init_resource::<Match>()','        .init_resource::<Match>()\n        .init_resource::<map_resource_provider::Map10Catalog>()');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_resource_provider.rs';s=p.read_text(encoding='utf-8');s+=r'''
/// Actual native table produced from extracted Map10 root files. This catalog has
/// no inferred parent: callers must qualify its contents before overlay fallback.
#[derive(bevy::prelude::Resource)]
pub struct Map10Catalog {pub locals:Provider,pub terrain_path:String,pub parent_qualified:bool}
impl Default for Map10Catalog {
    fn default()->Self {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_resource_population_contract.json")).expect("qualified native Map10 resource population");
        let row=proof["cases"].as_array().unwrap().iter().find(|c|c["name"]=="map10-original-files").expect("actual Map10 native table");
        let locals=Provider::from_entries(row["entries"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_string())),None).expect("native ASCII Map10 table");
        let terrain_path=locals.resolve("terrain.ini").unwrap().expect("native Map10 terrain config alias").to_string();
        if let Ok(path)=std::env::var("OPENLEAGUE_MAP_RESOURCE_PROBE") {
            let report=serde_json::json!({"complete":false,"native_population_entries":row["entries"].as_object().unwrap().len(),"source_files":proof["sources"].as_array().unwrap().len(),"terrain_path":terrain_path,"local_overlay_present":locals.contains("FOWTexture").unwrap(),"parent_qualified":false,"limits":["Native population executed with extracted directory filenames; archive enumeration and inherited table remain open.","Overlay fallback not inferred from local table absence."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
        }
        Self {locals,terrain_path,parent_qualified:false}
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
''';p.write_text(s,encoding='utf-8');print('Actual native Map10 root-resource catalog bound at client startup; inherited table unknown.')
