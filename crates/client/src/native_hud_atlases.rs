//! Original ShadowIsles HUD atlas payloads, preserved DDS storage/mipmaps.
//! HUD widgets, coordinates, interactions and original compositing remain separate.
use bevy::{prelude::*,asset::RenderAssetUsages,image::{CompressedImageFormats,ImageType,ImageSampler},render::{extract_resource::{ExtractResource,ExtractResourcePlugin},render_asset::RenderAssets,renderer::RenderDevice,texture::GpuImage,Render,RenderApp,RenderSystems}};
#[derive(Clone)] pub struct AtlasHandle {pub request:String,pub normalized:String,pub image:Handle<Image>,pub width:u32,pub height:u32,pub mips:u32,pub format:String}
#[derive(Resource,Default,Clone,ExtractResource)] pub struct Atlases {pub entries:Vec<AtlasHandle>}
#[derive(Resource,Default)] struct Reported(bool);
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Atlases>().add_plugins(ExtractResourcePlugin::<Atlases>::default()).add_systems(Startup,load);
        app.sub_app_mut(RenderApp).init_resource::<Reported>().add_systems(Render,report.in_set(RenderSystems::PrepareBindGroups));
    }
}
pub fn decode(bytes:&[u8],supported:CompressedImageFormats)->Result<Image,bevy::image::TextureError> {
    Image::from_buffer(bytes,ImageType::Extension("dds"),supported,true,ImageSampler::linear(),RenderAssetUsages::default())
}
fn load(mut commands:Commands,hud:Res<crate::native_zip_provider::StartupHud>,device:Res<RenderDevice>,mut images:ResMut<Assets<Image>>,mut atlases:ResMut<Atlases>) {
    for source in &hud.shadow_isles_atlases {
        let image=decode(&source.bytes,CompressedImageFormats::from_features(device.features())).expect("decode original HUD DDS for current GPU");
        assert_eq!(image.data.as_deref(),Some(&source.bytes[128..]),"native DDS payload changed");
        let descriptor=&image.texture_descriptor;
        let entry=AtlasHandle {request:source.request.clone(),normalized:source.normalized.clone(),image:Handle::default(),width:descriptor.size.width,height:descriptor.size.height,mips:descriptor.mip_level_count,format:format!("{:?}",descriptor.format)};
        let raw_readback=entry.normalized.ends_with("ShadowIslesHUDAtlas.dds");
        let image=images.add(image);let entry=AtlasHandle {image:image.clone(),..entry};
        eprintln!("Native HUD atlas request={} normalized={} width={} height={} mips={} format={} payload_equal=true",entry.request,entry.normalized,entry.width,entry.height,entry.mips,entry.format);
        if raw_readback {
            if let Ok(path)=std::env::var("OPENLEAGUE_HUD_SHADOW_ATLAS_READBACK") {
                let expected=source.bytes[128..].to_vec();
                commands.spawn(bevy::render::gpu_readback::Readback::texture(image)).observe(move |event:On<bevy::render::gpu_readback::ReadbackComplete>,mut commands:Commands| {
                    let report=serde_json::json!({"complete":false,"gpu_readback":true,"native_bytes_equal":event.data==expected,"bytes":event.data.len(),"expected_bytes":expected.len(),"scope":"ShadowIsles uncompressed BGRA atlas base mip storage only; no original HUD framebuffer equivalence."});
                    std::fs::write(&path,serde_json::to_vec_pretty(&report).unwrap()).expect("write native HUD atlas readback");commands.entity(event.entity).despawn();
                });
            }
        }
        atlases.entries.push(entry);
    }
}
fn report(atlases:Option<Res<Atlases>>,gpu:Res<RenderAssets<GpuImage>>,mut reported:ResMut<Reported>) {
    if reported.0 {return;}
    let Some(atlases)=atlases else{return;};if atlases.entries.len()!=5 {return;}
    let mut entries=Vec::new();
    for entry in &atlases.entries {
        let Some(image)=gpu.get(entry.image.id()) else{return;};let d=&image.texture_descriptor;
        assert!(image.had_data);assert_eq!((d.size.width,d.size.height,d.mip_level_count),(entry.width,entry.height,entry.mips));assert_eq!(format!("{:?}",d.format),entry.format);
        entries.push(serde_json::json!({"request":entry.request,"normalized":entry.normalized,"width":d.size.width,"height":d.size.height,"mips":d.mip_level_count,"format":entry.format,"gpu_prepared":true,"had_data":image.had_data}));
    }
    eprintln!("Native HUD GPU atlases_prepared={} DDS_payloads_preserved=true layout_applied=false",entries.len());
    if let Ok(path)=std::env::var("OPENLEAGUE_HUD_ATLAS_GPU_RECEIPT") {let report=serde_json::json!({"complete":false,"atlas_count":entries.len(),"entries":entries,"layout_applied":false,"limits":["Original atlas storage/mips loaded; native sampler/gamma/compositing, coordinate rules, widgets and interactions remain open.","Compressed atlases have GPU allocation/format/mip preparation proof; their GPU byte readback is not included."]});std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()).expect("write HUD GPU receipt");}
    reported.0=true;
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_hud_defaults_match_every_native_parser_field() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_defaults_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],4);
        for c in proof["cases"].as_array().unwrap() {
            let bytes:Vec<u8>=c["bytes"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();
            let parsed=crate::native_game_cfg_text::parse(&bytes,c["flag"].as_u64().unwrap() as u32);assert_eq!(parsed.error,c["result"]["error"].as_str());assert_eq!(parsed.warnings,c["result"]["warnings"].as_u64().unwrap() as usize);
            let expected=c["result"]["entries"].as_array().unwrap();assert_eq!(parsed.entries.len(),expected.len());
            let latin=|value:&serde_json::Value|value.as_str().unwrap().chars().map(|c|u8::try_from(c as u32).unwrap()).collect::<Vec<_>>();
            for (row,want) in parsed.entries.iter().zip(expected) {assert_eq!(row.hash,want["hash"].as_u64().unwrap() as u32);assert_eq!(row.section,latin(&want["section"]));assert_eq!(row.key,latin(&want["key"]));assert_eq!(row.value,latin(&want["value"]));}
        }
    }
    #[test] fn original_shadow_profile_atlases_preserve_dds_bytes_dimensions_and_mips() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.shadow_isles_atlases.len(),5);
        for source in hud.shadow_isles_atlases {
            let image=decode(&source.bytes,CompressedImageFormats::BC).unwrap();assert_eq!(image.data.unwrap(),source.bytes[128..]);
            let n=|p|u32::from_le_bytes(source.bytes[p..p+4].try_into().unwrap());
            assert_eq!((image.texture_descriptor.size.width,image.texture_descriptor.size.height,image.texture_descriptor.mip_level_count),(n(16),n(12),n(28).max(1)));
        }
    }
}
