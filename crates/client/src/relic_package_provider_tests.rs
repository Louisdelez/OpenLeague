use super::*;
use crate::relic_namespace::Namespace;

fn native() -> serde_json::Value {
    let doc: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/relic_runes/package_terminal_global_contract.json")).unwrap();
    assert_eq!(doc["passed"], true);
    assert_eq!(doc["cleanup_passed"], true);
    doc
}
fn cache(entries: &serde_json::Value) -> NamespaceCache {
    let values = entries.as_object().unwrap().iter().map(|(key, value)|
        (CString::new(key.as_str()).unwrap(), CString::new(value.as_str().unwrap()).unwrap())).collect();
    NamespaceCache::from_unique(vec![(CString::new("now").unwrap(), Namespace::new(values).unwrap())]).unwrap()
}
fn package(doc: &serde_json::Value, global: bool) -> PackageProvider {
    let terminal = global.then(|| Parent::TerminalGlobal(cache(&doc["terminal_global_provider"]["entries"])));
    let fallback = PackageProvider::prepared(NamespaceCache::empty(), cache(&doc["cases"][1]["entries"]), terminal);
    PackageProvider::prepared(NamespaceCache::empty(), cache(&doc["cases"][0]["entries"]), Some(Parent::Package(Box::new(fallback))))
}
#[test]
fn populated_package_terminal_global_and_scoped_queries_match_native_factory_tail() {
    let doc = native();
    assert_eq!(doc["factory_parent_branches"][0]["parent_is_embedded_global"], true);
    assert_eq!(doc["factory_parent_branches"][1]["parent_is_embedded_global"], false);
    let mut provider = package(&doc, true);
    for query in doc["package_queries"].as_array().unwrap() {
        let requested = CString::new(query["requested"].as_str().unwrap()).unwrap();
        let selected = provider.lookup(&[c"now"], &requested);
        assert_eq!(selected.value.to_bytes(), query["canonical"].as_str().unwrap().as_bytes());
    }
    for query in doc["scoped_queries"].as_array().unwrap() {
        let scope = CString::new(query["scope"].as_str().unwrap()).unwrap();
        let requested = CString::new(query["requested"].as_str().unwrap()).unwrap();
        assert_eq!(provider.scoped(&scope, &requested).value.to_bytes(), query["canonical"].as_str().unwrap().as_bytes());
    }
    for query in doc["empty_order_queries"].as_array().unwrap() {
        let requested = CString::new(query["requested"].as_str().unwrap()).unwrap();
        assert_eq!(provider.lookup(&[], &requested).value.to_bytes(), b"");
    }
    let selected = provider.lookup(&[c"now"], c"TT_Heal_Rune.troy");
    assert_eq!(selected.layer, Layer::TerminalGlobal);
    assert_eq!(selected.parent_hops, 2);
    assert_eq!(selected.order_index, Some(0));
    let selected = provider.lookup(&[c"now"], c"Cube.skn");
    assert_eq!(selected.layer, Layer::BaseDirectory);
    assert_eq!(selected.parent_hops, 1);
    assert!(package(&doc, false).lookup(&[c"now"], c"TT_Heal_Rune.troy").value.to_bytes().is_empty());
}
#[test]
fn recovered_dds_images_follow_terminal_global_package_paths_and_balance_leases() {
    use bevy::{prelude::*, image::{CompressedImageFormats, ImageSampler}};
    let doc = native();
    let mut provider = package(&doc, true);
    let catalog = crate::relic_recovered_catalog::Catalog::recovered_subset().unwrap();
    let aliases: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/relic_runes/recovered_dds_alias_catalog.json")).unwrap();
    let mut store = crate::relic_image_reference_store::Store::default();
    let mut images = Assets::<Image>::default();
    let mut leases = Vec::new();
    for entry in aliases["entries"].as_array().unwrap() {
        let requested = CString::new(entry[0].as_str().unwrap()).unwrap();
        let selected = provider.lookup(&[c"now"], &requested);
        assert_eq!(selected.layer, Layer::TerminalGlobal);
        assert_eq!(selected.parent_hops, 2);
        let source = catalog.source_from_package(&requested, &mut provider, &[c"now"], ImageSampler::Default, false).unwrap();
        assert_eq!(source.key(), crate::relic_texture_name::hash(&selected.value));
        let payload = source.bytes;
        let lease = store.acquire_dds(source.key(), payload, CompressedImageFormats::all(), source.is_srgb, source.sampler, &mut images).unwrap();
        let image = store.image(&lease, &images).unwrap();
        assert_eq!(images.get(&image).unwrap().data.as_deref(), Some(&payload[128..]));
        leases.push(lease);
    }
    assert_eq!(leases.len(), 18);
    assert_eq!(images.len(), 9);
    assert!(catalog.source_from_package(c"", &mut provider, &[c"now"], ImageSampler::Default, false).is_err());
    assert!(catalog.source_from_package(c"Cube.skn", &mut provider, &[c"now"], ImageSampler::Default, false).is_err());
    assert!(catalog.source_from_package(c"Env_Ice_Sheen.tga", &mut provider, &[], ImageSampler::Default, false).is_err());
    for lease in leases { store.release(lease, &mut images).unwrap(); }
    assert!(images.is_empty());
    assert_eq!(store.len(), 0);
}
