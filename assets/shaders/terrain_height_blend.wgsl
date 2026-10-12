@group(#{MATERIAL_BIND_GROUP}) @binding(36) var<uniform> fog_profile:vec4<u32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(37) var<uniform> fog_constant:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(33) var cloud_opacity:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(34) var cloud_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(35) var<uniform> fog_mod2x:u32;
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var<uniform> scales: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var<uniform> half_blend: f32;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var layer0: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var sampler0: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var layer1: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var sampler1: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var layer2: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var sampler2: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var layer3: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(9) var sampler3: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(10) var height_map: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(11) var height_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(12) var colormap: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(13) var color_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(14) var<uniform> fog_opaque: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(15) var fog_lighting: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(16) var fog_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(17) var visibility_map: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(18) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(19) var<uniform> visibility_params: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(20) var<uniform> visibility_diagnostic: u32;
fn display_to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@group(#{MATERIAL_BIND_GROUP}) @binding(21) var<uniform> visibility_height:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(22) var<uniform> visibility_edge:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(23) var visibility_overlay:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(24) var overlay_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(25) var<uniform> visibility_below:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(26) var<uniform> visibility_ready:u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(29) var<uniform> native_alpha_reference:f32;
@fragment fn fragment(in: VertexOutput,@location(8) height_fades:vec2<f32>,@location(9) terrain_uv:vec2<f32>,@location(10) fog_uv:vec2<f32>,@location(11) high_fog:vec4<f32>) -> @location(0) vec4<f32> {
    if visibility_diagnostic==2u {
        let native=native_fow_coordinates(vec3<f32>(in.world_position.x,in.world_position.y*20.0,in.world_position.z),visibility_params,visibility_height);
        return vec4<f32>(display_to_linear(vec3<f32>(height_fades.x,visibility_edge.x*0.5,native.y)),1.0);
    }
    if visibility_diagnostic==1u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        return vec4<f32>(display_to_linear(vec3<f32>(vis)),1.0);
    }
    // Native height-blend output alpha is1; world alpha test still applies.
    if !native_alpha_accepts(1.0,native_alpha_reference) {discard;}
    let c0 = textureSample(layer0,sampler0,in.uv);
    let c1 = textureSample(layer1,sampler1,in.uv);
    let c2 = textureSample(layer2,sampler2,in.uv);
    let c3 = textureSample(layer3,sampler3,in.uv);
    // Direct port of native HeightBlending.hls, including both saturate factors.
    let h = vec4<f32>(c0.a,c1.a,c2.a,c3.a)*textureSample(height_map,height_sampler,terrain_uv)*scales;
    let maximum = max(h.x,max(h.y,max(h.z,h.w)));
    let raw_weights = clamp(h-vec4<f32>(maximum)+vec4<f32>(half_blend),vec4<f32>(0.0),vec4<f32>(1.0))*clamp(h*32.0,vec4<f32>(0.0),vec4<f32>(1.0));
    let total = dot(raw_weights,vec4<f32>(1.0));
    // Explicit reconstructed handling for all-zero masks (native divides by zero).
    let weights = select(vec4<f32>(1.0,0.0,0.0,0.0),raw_weights/max(total,0.000001),total>0.000001);
    let detail = c0.rgb*weights.x+c1.rgb*weights.y+c2.rgb*weights.z+c3.rgb*weights.w;
    // Native LIT_PS MOD2X_COLORMAP branch, no shadow mask/cloud/fog yet.
    let lighting = textureSample(colormap,color_sampler,terrain_uv).rgb*4.0;
    var display=clamp(detail*lighting,vec3<f32>(0.0),vec3<f32>(1.0));
    var fog_factors=vec4<f32>(0.0,0.0,0.0,1.0);
    if visibility_ready==1u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
        let factors=native_fow_factors(overlay,vis,height_fades.y,1u,visibility_edge);
        fog_factors=factors;
        // Native LIT_PS: saturate lighting, FoW blend, then volumetric height fog.
        display=mix(factors.rgb,display,factors.a);
    }

    if fog_profile.z==0u {return vec4<f32>(display_to_linear(display),1.0);}
    if fog_profile.x==1u {
      let far=clamp(high_fog.y,0.0,1.0);
      return vec4<f32>(display_to_linear(mix(display,fog_constant.rgb,far)),1.0);
    }
    let fog=textureSample(fog_lighting,fog_sampler,fog_uv).rgb;
    var top=high_fog.x;
    if fog_mod2x==1u {top=clamp(top*textureSample(colormap,color_sampler,terrain_uv).a*2.0,0.0,1.0);}
    if fog_profile.y==1u {top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;}
    let far=clamp(high_fog.y,0.0,1.0);
    let top_color=mix(fog_factors.rgb,fog,fog_factors.a);
    return vec4<f32>(display_to_linear(mix(display,mix(top_color,fog,far),mix(top,1.0,far))),1.0);
}

// Literal port of FogOfWar_PS.hls, normal overlay UV and visibility branches.
// Edge sharpener is #if0 in the original; tint uses original visibility, not height-adjusted t.
fn native_fow_factors(overlay:vec4<f32>,vis:f32,height:f32,mode:u32,edge:vec4<f32>)->vec4<f32> {
 var t=vis;
 if mode==1u {t=vis*height;}
 if mode==2u {t=mix(vis,1.0,height);}
 let color=mix(overlay.rgb,vec3<f32>(0.2,0.07,0.06),clamp(vis*edge.z,0.0,1.0));
 return vec4<f32>(color,mix(overlay.a,1.0,t));
}

// Direct arithmetic port of FogOfWar_VS.hls. World positions use native units.
fn native_fow_coordinates(world:vec3<f32>,coordinates:vec4<f32>,height:vec4<f32>)->vec3<f32> {
    let uv=world.xz*coordinates.xy+coordinates.zw;
    let fade=clamp(world.y*height.x+height.y,0.0,1.0);
    return vec3<f32>(uv,fade);
}

// Native ordinary-world D3D GREATER predicate after reference-byte normalization.
fn native_alpha_accepts(alpha:f32,reference:f32)->bool {
 return alpha>reference;
}
