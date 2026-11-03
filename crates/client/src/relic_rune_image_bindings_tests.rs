use super::*;
const COLOR:&[u8]=include_bytes!("../../../assets/particles/relic_runes/DefaultColorOverLifetime.dds");
const FALLOFF:&[u8]=include_bytes!("../../../assets/particles/relic_runes/DefaultFalloff.dds");
fn source(key:u32,bytes:&[u8])->Source<'_>{
 let name:&[u8]=match key{1=>b"DefaultColorOverLifetime.dds\0",2=>b"DefaultFalloff.dds\0",_=>unreachable!()};
 Source::request(std::ffi::CStr::from_bytes_with_nul(name).unwrap(),std::ffi::CStr::from_bytes_with_nul(&[0]).unwrap(),bytes,ImageSampler::Default,false).unwrap()
}
#[test]
fn failed_second_dds_returns_first_lease_without_hidden_resident_reference(){
 let mut store=Store::default();let mut assets=Assets::<Image>::default();
 let error=Bindings::acquire(&mut store,&mut assets,CompressedImageFormats::all(),source(1,COLOR),source(2,b"invalid DDS")).unwrap_err();
 assert_eq!(error.leases.len(),1);assert_eq!(assets.len(),1);assert_eq!(store.len(),1);
 for lease in error.leases {store.release(lease,&mut assets).unwrap();}
 assert_eq!(assets.len(),0);assert_eq!(store.len(),0);
}
#[test]
fn shared_material_images_survive_borrower_retirement_until_renderer_cleanup(){
 let mut store=Store::default();let mut assets=Assets::<Image>::default();let compression=CompressedImageFormats::all();
 let first=Bindings::acquire(&mut store,&mut assets,compression,source(1,COLOR),source(2,FALLOFF)).unwrap();
 first.register(&mut store,&assets).unwrap();
 let second=Bindings::acquire(&mut store,&mut assets,compression,source(1,b"cache hit"),source(2,b"cache hit")).unwrap();
 second.register(&mut store,&assets).unwrap();assert_eq!(assets.len(),2);
 // Fixture handles exercise CPU availability; they do not stand for native fog pixels.
 let ids=assets.iter().map(|(id,_)|id).collect::<Vec<_>>();let fog=ids.into_iter().map(|id|assets.get_strong_handle(id).unwrap()).collect::<Vec<_>>();
 assert_eq!(first.images(&store,&assets,[fog[0].clone(),fog[1].clone()]).unwrap(),second.images(&store,&assets,[fog[0].clone(),fog[1].clone()]).unwrap());
 assert!(first.images(&store,&assets,[Handle::default(),fog[0].clone()]).is_err());
 first.retire(&mut store,&mut assets).unwrap();assert_eq!(assets.len(),2);
 assert!(second.images(&store,&assets,[fog[0].clone(),fog[1].clone()]).is_ok());
 second.retire(&mut store,&mut assets).unwrap();assert_eq!(assets.len(),2);
 store.cleanup_renderer(&mut assets).unwrap();assert_eq!(assets.len(),0);
 // One source serving both material channels owns two loans and one resident pin.
 let same=Bindings::acquire(&mut store,&mut assets,compression,source(1,COLOR),source(1,COLOR)).unwrap();
 same.register(&mut store,&assets).unwrap();assert_eq!(assets.len(),1);
 same.retire(&mut store,&mut assets).unwrap();assert_eq!(assets.len(),1);
 store.cleanup_renderer(&mut assets).unwrap();assert_eq!(assets.len(),0);
}
#[test]
fn foreign_material_retirement_returns_both_leases_to_the_real_owner(){
 let mut store=Store::default();let mut assets=Assets::<Image>::default();let mut foreign=Store::default();
 let pair=Bindings::acquire(&mut store,&mut assets,CompressedImageFormats::all(),source(1,COLOR),source(2,FALLOFF)).unwrap();
 assert!(pair.register(&mut foreign,&assets).is_err());
 let error=pair.retire(&mut foreign,&mut assets).unwrap_err();assert_eq!(error.leases.len(),2);assert_eq!(assets.len(),2);
 for lease in error.leases {store.release(lease,&mut assets).unwrap();}assert_eq!(assets.len(),0);
}

#[test]
fn material_source_retains_requested_key_on_empty_canonical_and_rejects_absence(){
 let requested=std::ffi::CString::new("Env_TT_Heal_Proj.tga").unwrap();let canonical=std::ffi::CString::new("DATA/Particles/Env_TT_Heal_Proj.dds").unwrap();let empty=std::ffi::CStr::from_bytes_with_nul(&[0]).unwrap();
 let original=Source::request(&requested,empty,COLOR,ImageSampler::Default,false).unwrap();
 let selected=Source::request(&requested,&canonical,COLOR,ImageSampler::Default,false).unwrap();
 assert_eq!(original.key(),crate::relic_texture_name::hash(&requested));assert_eq!(selected.key(),crate::relic_texture_name::hash(&canonical));assert_ne!(original.key(),selected.key());
 assert!(Source::request(empty,&canonical,COLOR,ImageSampler::Default,false).is_err());
}
