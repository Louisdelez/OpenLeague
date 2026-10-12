@group(#{MATERIAL_BIND_GROUP}) @binding(123) var<uniform> high_fog0:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(124) var<uniform> high_fog1:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(125) var<uniform> cloud_phase:vec4<f32>;
// Bevy0.19 default mesh vertex path retained for skinning/morphs/normals/UVs/colors.
// Additional native height interpolant, shared by production terrain/environment consumers.
@group(#{MATERIAL_BIND_GROUP}) @binding(109) var<uniform> height_clear:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(113) var<uniform> height_below:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(100) var<uniform> terrain_coordinates:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(117) var<uniform> terrain_transform:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(120) var<uniform> fog_coordinates:vec4<f32>;
struct NativeFowVertexOutput {
    // This is `clip position` when the struct is used as a vertex stage output
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) world_normal: vec3<f32>,
#ifdef VERTEX_UVS_A
    @location(2) uv: vec2<f32>,
#endif
#ifdef VERTEX_UVS_B
    @location(3) uv_b: vec2<f32>,
#endif
#ifdef VERTEX_TANGENTS
    @location(4) world_tangent: vec4<f32>,
#endif
#ifdef VERTEX_COLORS
    @location(5) color: vec4<f32>,
#endif
#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    @location(6) @interpolate(flat) instance_index: u32,
#endif
#ifdef VISIBILITY_RANGE_DITHER
    @location(7) @interpolate(flat) visibility_range_dither: i32,
#endif
    @location(8) native_height_fades:vec2<f32>,
    @location(9) native_terrain_uv:vec2<f32>,
    @location(10) native_fog_lighting_uv:vec2<f32>,
    @location(11) native_high_fog:vec4<f32>,
}
#import bevy_pbr::{
    mesh_bindings::mesh,
    mesh_functions,
    skinning,
    morph::{morph_position, morph_normal, morph_tangent},
    forward_io::Vertex,
    view_transformations::position_world_to_clip,
}

#ifdef MORPH_TARGETS
// The instance_index parameter must match vertex_in.instance_index. This is a work around for a wgpu dx12 bug.
// See https://github.com/gfx-rs/naga/issues/2416
fn morph_vertex(vertex_in: Vertex, instance_index: u32) -> Vertex {
    var vertex = vertex_in;
    let first_vertex = mesh[instance_index].first_vertex_index;
    let vertex_index = vertex.index - first_vertex;

    let weight_count = bevy_pbr::morph::layer_count(instance_index);
    for (var i: u32 = 0u; i < weight_count; i ++) {
        let weight = bevy_pbr::morph::weight_at(i, instance_index);
        if weight == 0.0 {
            continue;
        }
        vertex.position += weight * morph_position(vertex_index, i, instance_index);
#ifdef VERTEX_NORMALS
        vertex.normal += weight * morph_normal(vertex_index, i, instance_index);
#endif
#ifdef VERTEX_TANGENTS
        vertex.tangent += vec4(weight * morph_tangent(vertex_index, i, instance_index), 0.0);
#endif
    }
    return vertex;
}
#endif

@vertex
fn vertex(vertex_no_morph: Vertex) -> NativeFowVertexOutput {
    var out: NativeFowVertexOutput;

#ifdef MORPH_TARGETS
    var vertex = morph_vertex(vertex_no_morph, vertex_no_morph.instance_index);
#else
    var vertex = vertex_no_morph;
#endif

    let mesh_world_from_local = mesh_functions::get_world_from_local(vertex_no_morph.instance_index);

#ifdef SKINNED
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416 .
    var world_from_local = skinning::skin_model(
        vertex.joint_indices,
        vertex.joint_weights,
        vertex_no_morph.instance_index
    );
#else
    var world_from_local = mesh_world_from_local;
#endif

#ifdef VERTEX_NORMALS
#ifdef SKINNED
    out.world_normal = skinning::skin_normals(world_from_local, vertex.normal);
#else
    out.world_normal = mesh_functions::mesh_normal_local_to_world(
        vertex.normal,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif
#endif

#ifdef VERTEX_POSITIONS
    out.world_position = mesh_functions::mesh_position_local_to_world(world_from_local, vec4<f32>(vertex.position, 1.0));
    out.position = position_world_to_clip(out.world_position.xyz);
#endif

#ifdef VERTEX_UVS_A
    out.uv = vertex.uv;
#endif
#ifdef VERTEX_UVS_B
    out.uv_b = vertex.uv_b;
#endif

#ifdef VERTEX_TANGENTS
    out.world_tangent = mesh_functions::mesh_tangent_local_to_world(
        world_from_local,
        vertex.tangent,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif

#ifdef VERTEX_COLORS
    out.color = vertex.color;
#endif

#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.instance_index = vertex_no_morph.instance_index;
#endif

#ifdef VISIBILITY_RANGE_DITHER
    out.visibility_range_dither = mesh_functions::get_visibility_range_dither_level(
        vertex_no_morph.instance_index, mesh_world_from_local[3]);
#endif

    out.native_height_fades=native_fow_vertex_height(out.world_position.y*20.0,height_clear,height_below);
    // Common direct world basis D. Native c230 still performs the texture-space Z flip.
    let native_xz=out.world_position.xz*terrain_coordinates.z;
    out.native_terrain_uv=native_map_uv(native_xz,terrain_transform);
    out.native_fog_lighting_uv=native_map_uv(native_xz,fog_coordinates);
    // Fog.hls: clamp radial/height at the vertex, preserve unclamped far layer.
    let screen=out.position.xy/out.position.w;
    let radial=clamp(1.0-dot(screen,screen),0.0,1.0)*high_fog0.z+high_fog0.w;
    let height=clamp(out.world_position.y*terrain_coordinates.z*high_fog0.x+high_fog0.y,0.0,1.0);
    let top=1.0-mix(high_fog1.x,1.0,max(height,radial));
    let far=out.world_position.y*terrain_coordinates.z*high_fog1.y+high_fog1.z;
    out.native_high_fog=vec4<f32>(top,far,native_xz*cloud_phase.xx+cloud_phase.yz);
    return out;
}


// Native FogOfWar_VS.hls: clamp in vertex stage BEFORE perspective interpolation.
fn native_fow_vertex_height(world_y:f32,clear:vec4<f32>,below:vec4<f32>)->vec2<f32> {
 return vec2<f32>(clamp(world_y*clear.x+clear.y,0.0,1.0),clamp(world_y*below.z+below.w,0.0,1.0));
}

// Native c230/c233 affine XZ mapping. Input recovered native world X/Z.
fn native_map_uv(world_xz:vec2<f32>,coordinates:vec4<f32>)->vec2<f32> {
 return world_xz*coordinates.xy+coordinates.zw;
}
