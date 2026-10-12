from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/map_fog.rs';s=p.read_text();s=s.replace('pub vertex_lighting_factor: f32,','pub vertex_lighting_factor: f32,\n    #[uniform(105)]\n    pub diagnostic_channel: u32,');s=s.replace('vertex_lighting_factor: 0.,','''vertex_lighting_factor: 0.,
        diagnostic_channel: if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() {
            std::env::var("OPENLEAGUE_PROBE_CHANNEL").ok().and_then(|s| s.parse::<u32>().ok()).filter(|v| *v <= 2).unwrap_or(0)
        } else { 0 },''');p.write_text(s)
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text();s=s.replace('@binding(104) var<uniform> vertex_lighting_factor: f32;', '@binding(104) var<uniform> vertex_lighting_factor: f32;\n@group(#{MATERIAL_BIND_GROUP}) @binding(105) var<uniform> diagnostic_channel: u32;');s=s.replace('    var out: FragmentOutput;','''    var out: FragmentOutput;
    if diagnostic_channel==1u {
        out.color=vec4<f32>(input.material.base_color.rgb,1.0);
        return out;
    }
#ifdef VERTEX_COLORS
    if diagnostic_channel==2u {
        out.color=vec4<f32>(to_linear(in.color.rgb),1.0);
        return out;
    }
#endif''');p.write_text(s)
