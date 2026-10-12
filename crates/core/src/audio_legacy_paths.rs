//! Original7042C0 announcer path lookup; service event composition is explicit.
use std::collections::BTreeMap;
const MARKER:&str="/Dialogue/Announcer/";
fn validate(value:&str)->Result<(), &'static str> {
    if !value.is_ascii() || value.as_bytes().contains(&0) || value.len()>4096 {
        return Err("unsupported legacy audio string");
    }
    Ok(())
}
/// Original8E45D0 case-insensitive ASCII hash (distinct from event FNV).
pub fn path_hash(path:&str)->Result<u32,&'static str> {
    validate(path)?;
    let mut hash=0u32;
    for byte in path.bytes() {
        hash=hash.wrapping_shl(4).wrapping_add(byte.to_ascii_lowercase() as u32);
        let high=hash&0xf0000000;
        if high!=0 {hash^=(high>>24)^high;}
    }
    Ok(hash)
}
#[derive(Debug,PartialEq,Eq)]
pub struct ProviderRequest {
    pub namespace:String,
    pub filename:String,
    pub prefix:String,
}
/// Cache is keyed by native hash only. No cache insertion occurs in7042C0.
/// Provider models service virtual10 called by6F7360; its result is not guessed.
pub fn resolve(path:&str,cache:&BTreeMap<u32,String>,
    provider:impl FnMut(ProviderRequest)->Result<String,&'static str>)
    ->Result<String,&'static str> {
    resolve_with_namespace(path,cache,"",provider)
}
/// Namespace belongs to original global123DA8C, initialized from announcer voice configuration.
/// Pass the initialized value explicitly; an empty startup image is not the runtime default.
pub fn resolve_with_namespace(path:&str,cache:&BTreeMap<u32,String>,namespace:&str,
    mut provider:impl FnMut(ProviderRequest)->Result<String,&'static str>)
    ->Result<String,&'static str> {
    validate(namespace)?;
    let hash=path_hash(path)?;
    if let Some(cached)=cache.get(&hash) {validate(cached)?;return Ok(cached.clone());}
    let Some((_,remainder))=path.split_once(MARKER) else {return Ok(String::new());};
    let Some((prefix,_))=remainder.split_once('/') else {
        return Err("malformed legacy announcer path");
    };
    let filename=remainder.rsplit_once('/').unwrap().1.replace('.',"_");
    let result=provider(ProviderRequest {namespace:namespace.to_owned(),filename,prefix:prefix.to_owned()})?;
    validate(&result)?;
    Ok(result)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_original_128_path_and_131_hash_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_legacy_paths_contract.json")).unwrap();
        let hashes=proof["hash_cases"].as_array().unwrap();assert_eq!(hashes.len(),131);
        for case in hashes {assert_eq!(path_hash(case["input"].as_str().unwrap()).unwrap(),case["hash"].as_u64().unwrap() as u32);}
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),128);
        for case in cases {
            let cache=case["cache"].as_object().unwrap().iter().map(|(key,v)|(key.parse().unwrap(),v.as_str().unwrap().to_owned())).collect();
            let mut calls=Vec::new();
            let result=resolve(case["path"].as_str().unwrap(),&cache,|request| {
                calls.push(serde_json::json!({"namespace":request.namespace,"filename":request.filename,"prefix":request.prefix}));
                Ok(case["provider_result"].as_str().unwrap().to_owned())
            }).unwrap();
            assert_eq!(result,case["output"].as_str().unwrap());assert_eq!(calls,*case["provider_calls"].as_array().unwrap());
        }
    }
    #[test]
    fn cache_precedes_parsing_and_does_not_gain_invented_entries() {
        let path="/Dialogue/Announcer/NoSlash";let mut cache=BTreeMap::new();
        cache.insert(path_hash(path).unwrap(),"Actual_Cached_Event".to_owned());
        assert_eq!(resolve(path,&cache,|_|panic!("cache hit")).unwrap(),"Actual_Cached_Event");
        cache.clear();assert_eq!(resolve(path,&cache,|_|panic!("invalid path")),Err("malformed legacy announcer path"));
        let path="/Dialogue/Announcer/Classic/Welcome.mp3";
        let result=resolve(path,&cache,|_|Err("native provider unavailable"));assert_eq!(result,Err("native provider unavailable"));assert!(cache.is_empty());
        assert_eq!(resolve(path,&cache,|_|Ok(String::new())).unwrap(),"");assert!(cache.is_empty());
    }
    #[test]
    fn unsupported_strings_return_errors_before_provider_calls() {
        for path in ["é","a\0b",&"x".repeat(4097)] {
            assert!(resolve(path,&BTreeMap::new(),|_|panic!("unsupported input")).is_err());
        }
        assert!(resolve("/Dialogue/Announcer/A/a.mp3",&BTreeMap::new(),|_|Ok("é".to_owned())).is_err());
    }
}
