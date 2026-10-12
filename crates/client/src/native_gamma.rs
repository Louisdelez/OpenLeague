use bevy::{
    core_pipeline::fullscreen_material::FullscreenMaterial,
    prelude::*,
    render::{extract_component::ExtractComponent, render_resource::ShaderType},
    shader::ShaderRef,
};

/// Map10's native initial gamma option. User overrides and color fade are pending.
#[derive(Component, ExtractComponent, Clone, Copy, ShaderType, Default)]
pub struct Map10Gamma {
    pub state: Vec4,
}

impl Map10Gamma {
    pub fn native_map10() -> Self {
        let contract: serde_json::Value = serde_json::from_str(include_str!(
            "../../../data/4.20/native_gamma_sampler_contract.json"
        )).expect("qualified native gamma sampler");
        assert_eq!(contract["filter"], "point");
        assert_eq!(contract["address_u"], "clamp");
        Self { state: Vec4::new(if contract["default_gamma_enabled"].as_bool().unwrap() {1.} else {0.}, 0., 0., 0.) }
    }
}

impl FullscreenMaterial for Map10Gamma {
    fn fragment_shader() -> ShaderRef {
        "shaders/native_map10_gamma.wgsl".into()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn map10_gamma_shader_uses_native_uploaded_table_and_point_clamp() {
        let native: serde_json::Value = serde_json::from_str(include_str!(
            "../../../data/4.20/native_map10_gamma_contract.json"
        )).unwrap();
        let shader = include_str!("../../../assets/shaders/native_map10_gamma.wgsl");
        let table = shader.split("// BEGIN NATIVE TABLE").nth(1).unwrap()
            .split("// END NATIVE TABLE").next().unwrap();
        let values: Vec<u32> = table.split(',').filter_map(|s| s.trim().strip_suffix('u'))
            .map(|s| s.parse().unwrap()).collect();
        assert_eq!(values.len(), 256);
        for (i, value) in values.iter().enumerate() {
            assert_eq!(*value, native["lut_argb_u32"][i].as_u64().unwrap() as u32 & 255);
        }
        assert!(shader.contains("min(255u, u32(floor(clamp(channel, 0.0, 1.0) * 256.0)))"));
        assert!(shader.contains("vec4<f32>(to_linear(mapped), 1.0)"));
        assert_eq!(Map10Gamma::native_map10().state.x, 1.);
    }
}
