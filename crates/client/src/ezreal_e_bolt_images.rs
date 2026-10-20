//! Five original DDS payloads plus a named local neutral lookup for missile1,
//! whose p-rgba is absent. No texture generation or native VFS claim.
use bevy::{asset::RenderAssetUsages,image::{ImageAddressMode,ImageFilterMode,ImageLoaderSettings,
    ImageSampler,ImageSamplerDescriptor},prelude::*,render::render_resource::{Extent3d,TextureDimension,TextureFormat}};
use crate::nexus_glow_material::Textures;
pub(crate) const NEUTRAL_LOOKUP_POLICY:&str="e_missile1_absent_rgba_neutral_white_v1";
struct Spec {path:&'static str,bytes:&'static [u8],width:u32,height:u32,mips:u32,format:TextureFormat}
const SPECS:[Spec;5]=[
    Spec{path:"particles/ezreal/e_missile/MultiLightning4.dds",bytes:include_bytes!("../../../assets/particles/ezreal/e_missile/MultiLightning4.dds"),width:512,height:512,mips:10,format:TextureFormat::Bc3RgbaUnorm},
    Spec{path:"particles/ezreal/e_missile/color-beacontrail.dds",bytes:include_bytes!("../../../assets/particles/ezreal/e_missile/color-beacontrail.dds"),width:128,height:128,mips:1,format:TextureFormat::Bc1RgbaUnorm},
    Spec{path:"particles/ezreal/e_missile/color-sorakabasicattack.dds",bytes:include_bytes!("../../../assets/particles/ezreal/e_missile/color-sorakabasicattack.dds"),width:64,height:64,mips:7,format:TextureFormat::Bc3RgbaUnorm},
    Spec{path:"particles/ezreal/e_missile/SorakaBasicAttack04.dds",bytes:include_bytes!("../../../assets/particles/ezreal/e_missile/SorakaBasicAttack04.dds"),width:256,height:384,mips:9,format:TextureFormat::Bc3RgbaUnorm},
    Spec{path:"particles/ezreal/e_missile/ball01.dds",bytes:include_bytes!("../../../assets/particles/ezreal/e_missile/ball01.dds"),width:128,height:128,mips:8,format:TextureFormat::Bc3RgbaUnorm},
];
pub(crate) fn sampler()->ImageSamplerDescriptor {
    // Named local linear/clamp sampling, not a recovered native sampler state.
    ImageSamplerDescriptor{address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,
        address_mode_w:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,
        mipmap_filter:ImageFilterMode::Linear,..default()}
}
pub(crate) struct Images {pub textures:[Textures;3],pub overlay:Handle<Image>,originals:[Handle<Image>;5],neutral:Handle<Image>}
impl Images {
    pub(crate) fn load(assets:&AssetServer,images:&mut Assets<Image>)->Self {
        let originals=std::array::from_fn(|i|assets.load_builder().with_settings(|settings:&mut ImageLoaderSettings|{
            settings.is_srgb=false;settings.sampler=ImageSampler::Descriptor(sampler());
        }).load(SPECS[i].path));
        let mut white=Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
            vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default());
        white.sampler=ImageSampler::Descriptor(sampler());let neutral=images.add(white);
        let textures=[Textures{image:originals[0].clone(),color:neutral.clone(),samplers:[sampler(),sampler()]},
            Textures{image:originals[4].clone(),color:originals[1].clone(),samplers:[sampler(),sampler()]},
            Textures{image:originals[3].clone(),color:originals[2].clone(),samplers:[sampler(),sampler()]}];
        Self{textures,originals,neutral,overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png")}
    }
    pub(crate) fn validate(&self,images:&Assets<Image>)->Result<(),&'static str>{
        for (handle,spec) in self.originals.iter().zip(&SPECS) {
            let image=images.get(handle).ok_or("E original DDS unavailable")?;let d=&image.texture_descriptor;
            if d.dimension!=TextureDimension::D2||d.size.width!=spec.width||d.size.height!=spec.height
                ||d.size.depth_or_array_layers!=1||d.mip_level_count!=spec.mips||d.format!=spec.format
                ||image.data.as_deref()!=Some(&spec.bytes[128..])
                ||!matches!(&image.sampler,ImageSampler::Descriptor(actual) if *actual==sampler()){
                return Err("E original DDS layout/payload/sampler changed");
            }
        }
        let neutral=images.get(&self.neutral).ok_or("E neutral lookup unavailable")?;let d=&neutral.texture_descriptor;
        if d.dimension!=TextureDimension::D2||d.size!=(Extent3d{width:1,height:1,depth_or_array_layers:1})
            ||d.mip_level_count!=1||d.format!=TextureFormat::Rgba8Unorm||neutral.data.as_deref()!=Some(&[255u8,255,255,255][..])
            ||!matches!(&neutral.sampler,ImageSampler::Descriptor(actual) if *actual==sampler()){
            return Err("E neutral lookup policy changed");
        }
        let pairs=[(self.originals[0].id(),self.neutral.id()),(self.originals[4].id(),self.originals[1].id()),
            (self.originals[3].id(),self.originals[2].id())];
        for (textures,(image,color)) in self.textures.iter().zip(pairs){
            if textures.image.id()!=image||textures.color.id()!=color||textures.samplers!=[sampler(),sampler()]{
                return Err("E original group texture binding changed");
            }
        }
        if !images.contains(self.overlay.id()){return Err("E FoW overlay unavailable");}Ok(())
    }
}
#[cfg(test)]
pub(crate) mod tests {
    use super::*;
    use bevy::image::{CompressedImageFormats,ImageType};
    pub(crate) fn fixture()->(Images,Assets<Image>){
        let mut images=Assets::<Image>::default();
        let originals=std::array::from_fn(|i|images.add(Image::from_buffer(SPECS[i].bytes,
            ImageType::Extension("dds"),CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler()),
            RenderAssetUsages::default()).unwrap()));
        let mut white=Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,
            vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default());white.sampler=ImageSampler::Descriptor(sampler());
        let neutral=images.add(white);let overlay=images.add(Image::default());
        let textures=[Textures{image:originals[0].clone(),color:neutral.clone(),samplers:[sampler(),sampler()]},
            Textures{image:originals[4].clone(),color:originals[1].clone(),samplers:[sampler(),sampler()]},
            Textures{image:originals[3].clone(),color:originals[2].clone(),samplers:[sampler(),sampler()]}];
        (Images{textures,originals,neutral,overlay},images)
    }
    #[test]
    fn every_original_mip_payload_and_the_neutral_lookup_are_checked(){
        let (profile,mut images)=fixture();profile.validate(&images).unwrap();
        for i in 0..5 {let saved=images.get(&profile.originals[i]).unwrap().clone();
            images.get_mut(&profile.originals[i]).unwrap().data.as_mut().unwrap()[0]^=1;
            assert!(profile.validate(&images).is_err());*images.get_mut(&profile.originals[i]).unwrap()=saved;}
        images.get_mut(&profile.neutral).unwrap().data.as_mut().unwrap()[0]=254;
        assert!(profile.validate(&images).is_err());
    }
    #[test]
    fn missing_resource_or_changed_sampler_or_group_alias_retires_draws(){
        let (mut profile,mut images)=fixture();let saved=images.get(&profile.originals[0]).unwrap().clone();
        images.remove(profile.originals[0].id());assert!(profile.validate(&images).is_err());
        images.insert(profile.originals[0].id(),saved).unwrap();
        images.get_mut(&profile.originals[0]).unwrap().sampler=ImageSampler::Default;
        assert!(profile.validate(&images).is_err());
        images.get_mut(&profile.originals[0]).unwrap().sampler=ImageSampler::Descriptor(sampler());
        profile.textures[0].color=profile.originals[1].clone();assert!(profile.validate(&images).is_err());
    }
}
