@group(#{MATERIAL_BIND_GROUP}) @binding(129) var<uniform> fog_profile:vec4<u32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(130) var<uniform> fog_constant:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(126) var cloud_opacity:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(127) var cloud_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(128) var<uniform> fog_mod2x:u32;
#import bevy_pbr::{forward_io::{VertexOutput,FragmentOutput},pbr_functions::{alpha_discard,apply_pbr_lighting,main_pass_post_lighting_processing},pbr_fragment::pbr_input_from_standard_material,pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT}
@group(#{MATERIAL_BIND_GROUP}) @binding(100) var<uniform> opaque: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(101) var<uniform> denominator: f32;
@group(#{MATERIAL_BIND_GROUP}) @binding(102) var fog_lighting: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(103) var fog_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(104) var<uniform> vertex_lighting_factor: f32;
@group(#{MATERIAL_BIND_GROUP}) @binding(105) var<uniform> diagnostic_channel: u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(106) var visibility_map: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(107) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(108) var<uniform> visibility_params: vec4<f32>;
fn to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
fn to_display(c: vec3<f32>) -> vec3<f32> {
    return select(1.055*pow(max(c,vec3<f32>(0.0)),vec3<f32>(1.0/2.4))-vec3<f32>(0.055),c*12.92,c<=vec3<f32>(0.0031308));
}
@group(#{MATERIAL_BIND_GROUP}) @binding(109) var<uniform> visibility_height:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(110) var<uniform> visibility_edge:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(111) var visibility_overlay:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(112) var overlay_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(113) var<uniform> visibility_below:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(114) var<uniform> visibility_ready:u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(115) var<uniform> factor_mode:u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(116) var<uniform> colormap_lighting_factor:f32;
@group(#{MATERIAL_BIND_GROUP}) @binding(118) var colormap:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(119) var colormap_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(121) var<uniform> native_alpha_enabled:u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(122) var<uniform> native_alpha_reference:f32;
@fragment fn fragment(in: VertexOutput,@builtin(front_facing) is_front: bool,@location(8) height_fades:vec2<f32>,@location(9) terrain_uv:vec2<f32>,@location(10) fog_uv:vec2<f32>,@location(11) high_fog:vec4<f32>) -> FragmentOutput {
    var base_in=in;
#ifdef VERTEX_COLORS
    // COLOR_0 contains native control data, not a glTF diffuse tint. Decode it
    // after texture sampling in native display-channel space.
    if vertex_lighting_factor>0.0 {base_in.color=vec4<f32>(1.0,1.0,1.0,in.color.a);}
#endif
#ifdef VERTEX_COLORS
    // Native DECAL shader reads texture alpha and colormap, not control vertex colors.
    if colormap_lighting_factor>0.0 {base_in.color=vec4<f32>(1.0);}
#endif
    var input=pbr_input_from_standard_material(base_in,is_front);
    if native_alpha_enabled==1u {
        if !native_alpha_accepts(input.material.base_color.a,native_alpha_reference) {discard;}
    } else {input.material.base_color=alpha_discard(input.material,input.material.base_color);}
    var out: FragmentOutput;
    if diagnostic_channel==4u {
        let native=native_fow_coordinates(vec3<f32>(in.world_position.x,in.world_position.y*20.0,in.world_position.z),visibility_params,visibility_height);
        out.color=vec4<f32>(to_linear(vec3<f32>(height_fades.x,visibility_edge.x*0.5,native.y)),1.0);return out;
    }
    if diagnostic_channel==3u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        out.color=vec4<f32>(to_linear(vec3<f32>(vis)),1.0);
        return out;
    }
    if diagnostic_channel==1u {
        out.color=vec4<f32>(input.material.base_color.rgb,1.0);
        return out;
    }
#ifdef VERTEX_COLORS
    if diagnostic_channel==2u {
        out.color=vec4<f32>(to_linear(in.color.rgb),1.0);
        return out;
    }
#endif
    if (input.material.flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT)==0u {
        out.color=apply_pbr_lighting(input);
    } else {out.color=input.material.base_color;}
#ifdef VERTEX_COLORS
    if vertex_lighting_factor>0.0 {
        let native_lighting=in.color.rgb*vertex_lighting_factor;
        let display=clamp(to_display(out.color.rgb)*native_lighting,vec3<f32>(0.0),vec3<f32>(1.0));
        out.color=vec4<f32>(to_linear(display),out.color.a);
    }
#endif

    if colormap_lighting_factor>0.0 {
        let light=textureSample(colormap,colormap_sampler,terrain_uv).rgb;
        let native=native_decal_lighting(vec4<f32>(to_display(input.material.base_color.rgb),input.material.base_color.a),light,colormap_lighting_factor);
        out.color=vec4<f32>(to_linear(native.rgb),native.a);
    }
    var fog_factors=vec4<f32>(0.0,0.0,0.0,1.0);
    if visibility_ready==1u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
        let factors=native_fow_factors(overlay,vis,height_fades.y,factor_mode,visibility_edge);
        fog_factors=factors;
        out.color=vec4<f32>(to_linear(mix(factors.rgb,to_display(out.color.rgb),factors.a)),out.color.a);
    }
    if fog_profile.z==1u {
      if fog_profile.x==1u {
        let far=clamp(high_fog.y,0.0,1.0);
        out.color=vec4<f32>(to_linear(mix(to_display(out.color.rgb),fog_constant.rgb,far)),out.color.a);
      } else {
    let fog=textureSample(fog_lighting,fog_sampler,fog_uv).rgb;
    var top=high_fog.x;
    if fog_mod2x==1u {top=clamp(top*textureSample(colormap,colormap_sampler,terrain_uv).a*2.0,0.0,1.0);}
    if fog_profile.y==1u {top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;}
    let far=clamp(high_fog.y,0.0,1.0);
    let top_color=mix(fog_factors.rgb,fog,fog_factors.a);
    let amount=mix(top,1.0,far);
    let fog_color=mix(top_color,fog,far);
    out.color=vec4<f32>(to_linear(mix(to_display(out.color.rgb),fog_color,amount)),out.color.a);
      }
    }
    out.color=main_pass_post_lighting_processing(input,out.color);
    return out;
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

// Native MOD2X_COLORMAP + DECAL + DISABLE_SHADOWS, no emissive handle.
fn native_decal_lighting(diffuse:vec4<f32>,light:vec3<f32>,factor:f32)->vec4<f32> {
 return vec4<f32>(clamp(diffuse.rgb*(light*factor),vec3<f32>(0.0),vec3<f32>(1.0)),diffuse.a);
}

// Native ordinary-world D3D GREATER predicate after reference-byte normalization.
fn native_alpha_accepts(alpha:f32,reference:f32)->bool {
 return alpha>reference;
}
