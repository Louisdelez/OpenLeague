//! Main-world admission tests only. Reserved fog handles model external render
//! ownership with absent CPU storage; no replacement fog pixels or GPU claim.
use super::*;
use bevy::image::{CompressedImageFormats,ImageSamplerDescriptor};
use crate::{relic_image_reference_store::Store,relic_rune_image_bindings::{Bindings,Source}};

fn acquire(store:&mut Store,assets:&mut Assets<Image>)->Bindings {
    let source=|name:&'static [u8],bytes:&'static [u8]|Source::request(
        std::ffi::CStr::from_bytes_with_nul(name).unwrap(),std::ffi::CStr::from_bytes_with_nul(&[0]).unwrap(),
        bytes,ImageSampler::Descriptor(ImageSamplerDescriptor {lod_min_clamp:0.,lod_max_clamp:32.,..Default::default()}),false).unwrap();
    Bindings::acquire(store,assets,CompressedImageFormats::BC,
        source(b"Purify01.tga\0",include_bytes!("../../../assets/particles/relic_pickup/Purify01.DDS")),
        source(b"Wish_tar__starTrailSPI3__p-rgba.tga\0",include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__starTrailSPI3__p-rgba.DDS"))).unwrap()
}
fn input()->Inputs {Inputs {native_fog_extent:15398.671875,encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,
    render_mode:0,render_flags:0,shader_features:0}}

#[test]
fn external_render_fog_handles_admit_exact_dds_without_cpu_fog_or_gpu_claim() {
    let mut assets=Assets::<Image>::default();let mut store=Store::default();
    let bindings=acquire(&mut store,&mut assets);
    // Strong handles are reserved by the external owner; there are no CPU images.
    // The ordinary render host must reject them until actual GPU assets exist.
    let fog=[assets.reserve_handle(),assets.reserve_handle()];
    assert!(fog.iter().all(|h|h.is_strong() && assets.get(h).is_none()));
    assert!(GlowMaterial::new_owned(&bindings,&store,&assets,fog.clone(),input()).is_err());
    let material=GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,fog.clone(),input()).unwrap();
    assert!(!material.is_admitted());
    assert_eq!(material.visibility,fog[0]);assert_eq!(material.overlay,fog[1]);
    let handles=bindings.images_render_fog(&store,&assets,fog.clone()).unwrap();
    assert_eq!(material.image,handles[0]);assert_eq!(material.color,handles[1]);
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,[Handle::default(),fog[1].clone()],input()).is_err());
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&Store::default(),&assets,fog.clone(),input()).is_err());
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,fog.clone(),Inputs {shader_features:1,..input()}).is_err());
    drop(material);drop(handles);bindings.retire(&mut store,&mut assets).unwrap();assert_eq!(store.len(),0);
}

#[test]
fn external_fog_does_not_bypass_missing_retired_or_invalid_owned_dds() {
    let mut assets=Assets::<Image>::default();let mut store=Store::default();
    let bindings=acquire(&mut store,&mut assets);let fog=[assets.reserve_handle(),assets.reserve_handle()];
    let handles=bindings.images_render_fog(&store,&assets,fog.clone()).unwrap();
    let diffuse=assets.remove(handles[0].id()).unwrap();
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,fog.clone(),input()).is_err());
    assets.insert(handles[0].id(),diffuse).unwrap();
    {
        let mut image=assets.get_mut(&handles[0]).unwrap();
        image.sampler=ImageSampler::Default;
    }
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,fog.clone(),input()).is_err());
    {
        let mut image=assets.get_mut(&handles[0]).unwrap();
        image.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {lod_min_clamp:0.,lod_max_clamp:32.,..Default::default()});
    }
    bindings.register(&mut store,&assets).unwrap();
    store.cleanup_renderer(&mut assets).unwrap();
    assert!(GlowMaterial::new_owned_render_fog(&bindings,&store,&assets,fog,input()).is_err());
    assert_eq!(store.len(),0);
    // Leases invalidated by explicit renderer teardown remain rejected on release.
    assert!(bindings.retire(&mut store,&mut assets).is_err());
}
