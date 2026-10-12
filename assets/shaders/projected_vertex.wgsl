// Static restored receiver meshes; native projection and height evaluated per vertex.
#import bevy_pbr::{mesh_functions, forward_io::{Vertex, VertexOutput}, view_transformations::position_world_to_clip}
@group(#{MATERIAL_BIND_GROUP}) @binding(12) var<uniform> world_to_projection:mat4x4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(13) var<uniform> projection_height:vec4<f32>;
@vertex fn vertex(v:Vertex)->VertexOutput {
 var out:VertexOutput;
 let transform=mesh_functions::get_world_from_local(v.instance_index);
 out.world_position=mesh_functions::mesh_position_local_to_world(transform,vec4<f32>(v.position,1.0));
 out.position=position_world_to_clip(out.world_position.xyz);
 out.world_normal=mesh_functions::mesh_normal_local_to_world(v.normal,v.instance_index);
 out.uv=v.uv;
#ifdef VERTEX_COLORS
 out.color=v.color;
#endif
 if projection_height.w==1.0 {
  out.uv=(world_to_projection*vec4<f32>(out.world_position.xyz*20.0,1.0)).xz;
  let difference=abs(out.world_position.y*20.0-projection_height.x);
  var fade=1.0;
  if difference>projection_height.y {fade=1.0-(difference-projection_height.y)/projection_height.z;}
#ifdef VERTEX_COLORS
  out.color=vec4<f32>(1.0,1.0,1.0,fade);
#endif
 }
#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
 out.instance_index=v.instance_index;
#endif
 return out;
}
