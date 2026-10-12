//! CPU-side binding observations only; no mutation, GPU-readiness or pixel claim.
use bevy::prelude::*;
use serde_json::{json,Value};

pub(super) const TARGETS:[usize;6]=[554,581,308,1417,555,322];
pub(super) fn target(name:&str)->Option<usize> {
    name.strip_prefix("MapGeo_Instance_")?.split('.').next()?.parse().ok()
        .filter(|id|TARGETS.contains(id))
}
pub(super) fn role(id:usize)->&'static str {
    match id {554|581=>"deep_cyan",308|1417=>"deep_background",555=>"shallow_ground_control",322=>"foreground_alpha",_=>"unknown"}
}
fn image_metadata(image:Option<&Image>)->Value {
    image.map(|i|json!({"format":format!("{:?}",i.texture_descriptor.format),
        "size":[i.texture_descriptor.size.width,i.texture_descriptor.size.height,i.texture_descriptor.size.depth_or_array_layers],
        "mip_count":i.texture_descriptor.mip_level_count,"sampler":format!("{:?}",i.sampler),
        "asset_usage":format!("{:?}",i.asset_usage),"cpu_data_bytes":i.data.as_ref().map(Vec::len)})).unwrap_or(Value::Null)
}
pub(super) fn image(handle:&Handle<Image>,assets:&AssetServer,images:&Assets<Image>)->Value {
    let asset=images.get(handle);
    json!({"handle":format!("{:?}",handle.id()),"path":assets.get_path(handle.id()).map(|p|p.to_string()),
        "cpu_asset_present":asset.is_some(),"cpu_metadata":image_metadata(asset),"gpu_readiness":null})
}
pub(super) fn binding<A:Asset>(handle:&Handle<A>,assets:&AssetServer,present:bool)->Value {
    json!({"handle":format!("{:?}",handle.id()),"path":assets.get_path(handle.id()).map(|p|p.to_string()),"cpu_asset_present":present})
}
pub(super) fn standard(m:&StandardMaterial,assets:&AssetServer,images:&Assets<Image>)->Value {
    let color=m.base_color.to_linear();
    json!({"base_color_linear":[color.red,color.green,color.blue,color.alpha],
        "base_color_texture":m.base_color_texture.as_ref().map(|h|image(h,assets,images)),
        "alpha_mode":format!("{:?}",m.alpha_mode),"double_sided":m.double_sided,
        "cull_mode":format!("{:?}",m.cull_mode),"unlit":m.unlit})
}
pub(super) fn fog(m:&crate::map_fog::FogMaterial,assets:&AssetServer,images:&Assets<Image>)->Value {
    let e=&m.extension;
    json!({"base":standard(&m.base,assets,images),"extension":{
        "high_fog0":e.high_fog0.to_array(),"high_fog1":e.high_fog1.to_array(),
        "fog_profile":e.fog_profile.to_array(),"opaque":e.opaque.to_array(),
        "fog_coordinates":e.fog_coordinates.to_array(),"diagnostic_channel":e.diagnostic_channel,
        "lighting":image(&e.lighting,assets,images),"native_draw_mode":e.native_draw_mode,
        "alpha_test_enabled":e.alpha_test_enabled,"alpha_reference":e.alpha_reference,
        "fog_mod2x":e.fog_mod2x,"fog_constant":e.fog_constant.to_array(),
        "cloud_phase":e.cloud_phase.to_array(),"cloud_opacity":image(&e.cloud_opacity,assets,images),
        "colormap":image(&e.colormap,assets,images),"terrain_transform":e.terrain_transform.to_array(),
        "spatial_denominator":e.spatial_denominator,"vertex_lighting_factor":e.vertex_lighting_factor,
        "colormap_lighting_factor":e.colormap_lighting_factor,"factor_mode":e.factor_mode,
        "visibility_map":image(&e.visibility_map,assets,images),"visibility_overlay":image(&e.visibility_overlay,assets,images),
        "visibility_params":e.visibility_params.to_array(),"visibility_height":e.visibility_height.to_array(),
        "visibility_edge":e.visibility_edge.to_array(),"visibility_below":e.visibility_below.to_array(),
        "visibility_ready_uniform":e.visibility_ready}})
}
pub(super) fn terrain(m:&crate::terrain_material::TerrainMaterial,assets:&AssetServer,images:&Assets<Image>)->Value {
    let private=m.fog_probe_inputs();
    json!({"high_fog0":m.high_fog0.to_array(),"high_fog1":m.high_fog1.to_array(),
        "fog_profile":m.fog_profile.to_array(),"fog_opaque":m.coordinate_uniform().to_array(),
        "fog_coordinates":private.coordinates.to_array(),"fog_lighting":image(private.lighting,assets,images),
        "alpha_reference":private.alpha_reference,"visibility_diagnostic":m.visibility_diagnostic,
        "fog_mod2x":m.fog_mod2x,"fog_constant":m.fog_constant.to_array(),
        "cloud_phase":m.cloud_phase.to_array(),"cloud_opacity":image(&m.cloud_opacity,assets,images),
        "colormap":image(private.colormap,assets,images),
        "visibility_map":image(&m.visibility_map,assets,images),"visibility_overlay":image(&m.visibility_overlay,assets,images),
        "visibility_params":m.visibility_params.to_array(),"visibility_height":m.visibility_height.to_array(),
        "visibility_edge":m.visibility_edge.to_array(),"visibility_below":m.visibility_below.to_array(),
        "visibility_ready_uniform":m.visibility_ready})
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn target_selection_is_bounded_to_six_native_mesh_ids() {
        for id in TARGETS {assert_eq!(target(&format!("MapGeo_Instance_{id}")),Some(id));assert_eq!(target(&format!("MapGeo_Instance_{id}.0")),Some(id));assert_ne!(role(id),"unknown");}
        for name in ["MapGeo_Instance_5540","MapGeo_Instance_53","554","Other_554","MapGeo_Instance_"] {assert!(target(name).is_none());}
    }
    #[test] fn cpu_image_descriptor_is_observed_without_requiring_or_claiming_pixels() {
        assert!(image_metadata(None).is_null());
        let mut image=Image::default();image.data=None;
        let got=image_metadata(Some(&image));
        assert!(got["cpu_data_bytes"].is_null());
        assert_eq!(got["size"][0],image.texture_descriptor.size.width);
        assert_eq!(got["format"],format!("{:?}",image.texture_descriptor.format));
        assert!(got.get("gpu_ready").is_none());
    }
}
