use super::*;
use bevy::{image::{CompressedImageFormats,ImageSamplerDescriptor},asset::RenderAssetUsages,render::render_resource::Extent3d};
use crate::{relic_image_reference_store::Store,relic_rune_image_bindings::{Bindings,Source}};
#[test]fn native_pickup_image_leases_bind_existing_quad_material_and_retire_safely(){
 let diffuse=include_bytes!("../../../assets/particles/relic_pickup/Purify01.DDS");let color=include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__starTrailSPI3__p-rgba.DDS");
 let mut assets=Assets::<Image>::default();let mut store=Store::default();
 let source=|name:&'static [u8],bytes:&'static [u8]|Source::request(std::ffi::CStr::from_bytes_with_nul(name).unwrap(),std::ffi::CStr::from_bytes_with_nul(&[0]).unwrap(),bytes,ImageSampler::Descriptor(ImageSamplerDescriptor::default()),false).unwrap();
 let bindings=Bindings::acquire(&mut store,&mut assets,CompressedImageFormats::BC,source(b"Purify01.tga\0",diffuse),source(b"Wish_tar__starTrailSPI3__p-rgba.tga\0",color)).unwrap();
 // Explicit white fog fixtures test CPU handle ownership, not native FoW pixels.
 let fog=assets.add(Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default()));
 let input=Inputs{native_fog_extent:15398.671875,encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,render_mode:0,render_flags:0,shader_features:0};
 let material=GlowMaterial::new_owned(&bindings,&store,&assets,[fog.clone(),fog.clone()],input).unwrap();assert!(!material.is_admitted());
 let handles=bindings.images(&store,&assets,[fog.clone(),fog.clone()]).unwrap();assert_eq!(material.image,handles[0]);assert_eq!(material.color,handles[1]);assert_eq!(material.visibility,fog);
 assert!(GlowMaterial::new_owned(&bindings,&store,&assets,[Handle::default(),fog.clone()],input).is_err());
 assert!(GlowMaterial::new_owned(&bindings,&Store::default(),&assets,[fog.clone(),fog.clone()],input).is_err());
 assert!(GlowMaterial::new_owned(&bindings,&store,&assets,[fog.clone(),fog.clone()],Inputs{render_mode:1,..input}).is_err());
 {let mut image=assets.get_mut(&handles[0]).unwrap();let ImageSampler::Descriptor(sampler)=&mut image.sampler else{panic!()};sampler.lod_min_clamp=f32::NAN;}
 assert!(GlowMaterial::new_owned(&bindings,&store,&assets,[fog.clone(),fog.clone()],input).is_err());
 // Retire material users before image loans; this path never registers residency.
 drop(material);drop(handles);bindings.retire(&mut store,&mut assets).unwrap();assert_eq!(store.len(),0);assert_eq!(assets.len(),1);
}
