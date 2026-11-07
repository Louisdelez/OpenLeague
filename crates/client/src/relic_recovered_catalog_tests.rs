use super::*;
use bevy::{prelude::*,image::{CompressedImageFormats,ImageSampler}};
#[test] fn eighteen_recovered_aliases_share_nine_original_dds_images(){
 let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/recovered_dds_alias_catalog.json")).unwrap();let catalog=Catalog::recovered_subset().unwrap();
 let mut assets=Assets::<Image>::default();let mut store=crate::relic_image_reference_store::Store::default();let mut leases=Vec::new();
 for entry in doc["entries"].as_array().unwrap(){let key=CString::new(entry[0].as_str().unwrap()).unwrap();let source=catalog.source(&key,ImageSampler::Default,false).unwrap();let lease=store.acquire_dds(source.key(),source.bytes,CompressedImageFormats::all(),source.is_srgb,source.sampler,&mut assets).unwrap();let handle=store.image(&lease,&assets).unwrap();assert_eq!(assets.get(&handle).unwrap().data.as_deref(),Some(&source.bytes[128..]));store.pin_for_renderer(&lease).unwrap();leases.push(lease);}
 assert_eq!(leases.len(),18);assert_eq!(assets.len(),9);for pair in leases.chunks(2){assert_eq!(pair[0].id(),pair[1].id());}
 for lease in leases{store.release(lease,&mut assets).unwrap();}assert_eq!(assets.len(),9);store.cleanup_renderer(&mut assets).unwrap();assert_eq!(assets.len(),0);
 for missing in ["","Firefly_Spin.tga","path/color-hold.tga","unavailable.dds"]{assert!(catalog.source(&CString::new(missing).unwrap(),ImageSampler::Default,false).is_err());}assert_eq!(assets.len(),0);
}

#[test] fn recovered_images_follow_selected_map10_provider_canonical_paths(){
 let map=crate::map_resource_provider::Map10Catalog::default();assert!(!map.parent_qualified);
 let catalog=Catalog::recovered_subset().unwrap();
 let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/recovered_dds_alias_catalog.json")).unwrap();
 let mut assets=Assets::<Image>::default();let mut store=crate::relic_image_reference_store::Store::default();let mut leases=Vec::new();
 for entry in doc["entries"].as_array().unwrap(){
  let requested=CString::new(entry[0].as_str().unwrap()).unwrap();
  let selected=CString::new(map.locals.resolve(entry[0].as_str().unwrap()).unwrap().unwrap()).unwrap();
  let source=catalog.source_from_provider(&requested,&map.locals,ImageSampler::Default,false).unwrap();
  assert_eq!(source.key(),crate::relic_texture_name::hash(&selected));
  let lease=store.acquire_dds(source.key(),source.bytes,CompressedImageFormats::all(),source.is_srgb,source.sampler,&mut assets).unwrap();
  let handle=store.image(&lease,&assets).unwrap();assert_eq!(assets.get(&handle).unwrap().data.as_deref(),Some(&source.bytes[128..]));leases.push(lease);
 }
 assert_eq!(assets.len(),9);for pair in leases.chunks(2){assert_eq!(pair[0].id(),pair[1].id());}
 for lease in leases{store.release(lease,&mut assets).unwrap();}assert_eq!(assets.len(),0);
 let requested=CString::new("Env_Ice_Sheen.tga").unwrap();
 for canonical in ["","DATA/Other/Env_Ice_Sheen.dds"]{
  let provider=crate::map_resource_provider::Provider::from_entries(vec![("Env_Ice_Sheen.tga".into(),canonical.into())],None).unwrap();
  assert!(catalog.source_from_provider(&requested,&provider,ImageSampler::Default,false).is_err());
 }
 let provider=crate::map_resource_provider::Provider::from_entries(Vec::new(),None).unwrap();
 assert!(catalog.source_from_provider(&requested,&provider,ImageSampler::Default,false).is_err());
 assert!(catalog.source_from_provider(c"",&map.locals,ImageSampler::Default,false).is_err());
}
#[test] fn existing_search_provider_matches_original_684_warm_namespace_cases(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/provider_order_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),684);
 for row in proof["cases"].as_array().unwrap(){
  let values=row["namespace_values"].as_array().unwrap();
  let contexts=row["namespace_order"].as_array().unwrap().iter().map(|index|values[index.as_u64().unwrap() as usize].as_str().map(|value|vec![("Relic.tga".into(),value.into())]).unwrap_or_default()).collect();
  let requested=row["requested"].as_str().unwrap();
  let parent=row["parent"].as_str().map(|value|Box::new(crate::map_resource_provider::Provider::from_entries(vec![(requested.into(),value.into())],None).unwrap()));
  let provider=crate::map_resource_provider::SearchProvider::from_contexts(contexts,parent).unwrap();
  assert_eq!(provider.resolve(requested).unwrap().unwrap_or(""),row["value"].as_str().unwrap());
 }
}

#[test] fn pickup_aliases_preserve_original_payloads_extents_and_retire_images() {
 let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/pickup_dds_alias_catalog.json")).unwrap();
 let catalog=Catalog::recovered_with_pickup().unwrap();let mut assets=Assets::<Image>::default();let mut store=crate::relic_image_reference_store::Store::default();let mut leases=Vec::new();
 for row in doc["entries"].as_array().unwrap() {
  let requested=CString::new(row[0].as_str().unwrap()).unwrap();let source=catalog.source(&requested,ImageSampler::Default,false).unwrap();
  let native=doc["resources"].as_array().unwrap().iter().find(|r|r["canonical"]==row[1]).unwrap();
  let lease=store.acquire_dds(source.key(),source.bytes,CompressedImageFormats::all(),false,source.sampler,&mut assets).unwrap();let image=store.image(&lease,&assets).unwrap();let loaded=assets.get(&image).unwrap();
  assert_eq!(loaded.data.as_deref(),Some(&source.bytes[128..]));assert_eq!([loaded.width(),loaded.height()],[native["native_extent"][0].as_u64().unwrap() as u32,native["native_extent"][1].as_u64().unwrap() as u32]);store.pin_for_renderer(&lease).unwrap();leases.push(lease);
 }
 assert_eq!(leases.len(),16);assert_eq!(assets.len(),8);for pair in leases.chunks(2){assert_eq!(pair[0].id(),pair[1].id());}
 for lease in leases {store.release(lease,&mut assets).unwrap();}assert_eq!(assets.len(),8);store.cleanup_renderer(&mut assets).unwrap();assert_eq!(assets.len(),0);
 for absent in ["","Missing.tga","Other/Purify01.tga"]{assert!(catalog.source(&CString::new(absent).unwrap(),ImageSampler::Default,false).is_err());}
}
