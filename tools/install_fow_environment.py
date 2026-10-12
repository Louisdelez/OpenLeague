from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague');proof=json.loads((r/'data/4.20/fow_below_height_contract.json').read_text(encoding='utf-8'));assert proof['passed'] and proof['cases'][0]['uploads'][0]['bits']==[0,0xc47a0000,0x3c23d70a,0x41200000]
# Check the native-space position buffers of every recovered NVR material routed by the current scene.
raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();length=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+length]);blob=raw[28+length:]
settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'));allowed=set(settings['environment_materials']);rows=[]
for mesh in g['meshes']:
 for primitive in mesh['primitives']:
  name=g['materials'][primitive['material']].get('name','')
  if name not in allowed:continue
  accessor=g['accessors'][primitive['attributes']['POSITION']];assert accessor['componentType']==5126 and accessor['type']=='VEC3'
  view=g['bufferViews'][accessor['bufferView']];offset=view.get('byteOffset',0)+accessor.get('byteOffset',0);stride=view.get('byteStride',12)
  heights=[struct.unpack_from('<f',blob,offset+i*stride+4)[0] for i in range(accessor['count'])]
  rows.append({'mesh':mesh.get('name'),'material':name,'vertices':len(heights),'min_native_y':min(heights),'max_native_y':max(heights)})
assert rows
(r/'docs/fow_map10_height_inventory.json').write_text(json.dumps({'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'map_sha256':hashlib.sha256(raw).hexdigest(),'routed_primitives':rows,'below_fade_boundary_primitives':sum(x['min_native_y']<-900 for x in rows),'finding':'Some routed restored geometry extends below native Y=-900: c250 fade cannot be collapsed to constant1. Apply the full native LIT_PS toward-fogged height branch to the current LIT-derived terrain/environment pipeline.','limits':['Current renderer uses recovered LIT-derived lighting/material profiles; original high/low/baked variant routing and whole original scene transforms remain open.','No equivalence across all native branches or profiles claimed.']},indent=2)+'\n',encoding='utf-8')
p=r/'crates/client/src/native_fow.rs';s=p.read_text(encoding='utf-8-sig');s+='''
/// Literal native6B399F c250 upload, verified independently of configured c251.
pub fn always_below_params()->Vec4 {Vec4::new(0.,-1000.,f32::from_bits(0x3c23d70a),10.)}
pub fn fade_toward_fogged(native_y:f32)->f32 {let p=always_below_params();(native_y*p.z+p.w).clamp(0.,1.)}
#[cfg(test)] mod below_tests {
 use super::*;
 #[test] fn original_c250_uploads_and_height_boundaries_match() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_below_height_contract.json")).unwrap();assert_eq!(p["passed"],true);
  for c in p["cases"].as_array().unwrap() {assert_eq!(c["uploads"][0]["register"],250);for(i,x) in always_below_params().to_array().iter().enumerate() {assert_eq!(x.to_bits(),c["uploads"][0]["bits"][i].as_u64().unwrap() as u32);}}
  for(y,expected) in [(-1100.,0.),(-1000.,0.),(-950.,0.5),(-900.,1.),(-114.,1.),(179.,1.)] {assert!((fade_toward_fogged(y)-expected).abs()<0.000001);}
 }
}
''';p.write_text(s,encoding='utf-8')
for filename,field,last,fields in [
 ('terrain_material.rs','visibility_edge:Vec4',22,'    #[texture(23)] #[sampler(24)] pub visibility_overlay:Handle<Image>,\n    #[uniform(25)] pub visibility_below:Vec4,\n    #[uniform(26)] pub visibility_ready:u32,'),
 ('map_fog.rs','visibility_edge:Vec4',110,'    #[texture(111)] #[sampler(112)] pub visibility_overlay:Handle<Image>,\n    #[uniform(113)] pub visibility_below:Vec4,\n    #[uniform(114)] pub visibility_ready:u32,')]:
 p=r/'crates/client/src'/filename;s=p.read_text(encoding='utf-8');needle=f'    #[uniform({last})] pub {field},';assert needle in s;s=s.replace(needle,needle+'\n'+fields)
 s=s.replace('visibility_edge:Vec4::ZERO,','visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_visibility_texture.rs';s=p.read_text(encoding='utf-8');s=s.replace('let height=Vec4::from_array(uniforms.height);','let below=crate::native_fow::always_below_params();let height=Vec4::from_array(uniforms.height);')
s=s.replace('m.visibility_height!=height || m.visibility_edge!=edge)', 'm.visibility_height!=height || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_below!=below || m.visibility_ready!=1)')
s=s.replace('m.visibility_height=height;m.visibility_edge=edge;m.visibility_diagnostic=', 'm.visibility_height=height;m.visibility_edge=edge;m.visibility_overlay=overlay.clone();m.visibility_below=below;m.visibility_ready=1;m.visibility_diagnostic=')
s=s.replace('m.extension.visibility_height!=height || m.extension.visibility_edge!=edge)', 'm.extension.visibility_height!=height || m.extension.visibility_edge!=edge || m.extension.visibility_overlay!=overlay || m.extension.visibility_below!=below || m.extension.visibility_ready!=1)')
s=s.replace('m.extension.visibility_height=height;m.extension.visibility_edge=edge;', 'm.extension.visibility_height=height;m.extension.visibility_edge=edge;m.extension.visibility_overlay=overlay.clone();m.extension.visibility_below=below;m.extension.visibility_ready=1;')
p.write_text(s,encoding='utf-8')
helper=(r/'assets/shaders/fow_factor_functions.wgsl').read_text(encoding='utf-8')
for filename,first in [('terrain_height_blend.wgsl',23),('native_environment_fog.wgsl',111)]:
 p=r/'assets/shaders'/filename;s=p.read_text(encoding='utf-8');needle='@fragment fn fragment';assert needle in s
 uniforms=f'''@group(#{{MATERIAL_BIND_GROUP}}) @binding({first}) var visibility_overlay:texture_2d<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({first+1}) var overlay_sampler:sampler;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({first+2}) var<uniform> visibility_below:vec4<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({first+3}) var<uniform> visibility_ready:u32;
'''
 s=s.replace(needle,uniforms+needle);s=s.replace('// Direct arithmetic port of FogOfWar_VS.hls.',helper+'\n// Direct arithmetic port of FogOfWar_VS.hls.')
 if filename=='terrain_height_blend.wgsl':
  needle='    let display=clamp(detail*lighting,vec3<f32>(0.0),vec3<f32>(1.0));';assert needle in s
  s=s.replace(needle,needle.replace('let display','var display')+'''
    if visibility_ready==1u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
        let height=clamp(in.world_position.y*20.0*visibility_below.z+visibility_below.w,0.0,1.0);
        let factors=native_fow_factors(overlay,vis,height,1u,visibility_edge);
        // Native LIT_PS: saturate lighting, FoW blend, then volumetric height fog.
        display=mix(factors.rgb,display,factors.a);
    }
''')
 else:
  needle='    // Map10 native Fog.hls opaque layer and LIT_PS far-layer blend.';assert needle in s
  s=s.replace(needle,'''
    if visibility_ready==1u {
        let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
        let vis=textureSample(visibility_map,visibility_sampler,uv).r;
        let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
        let height=clamp(in.world_position.y*20.0*visibility_below.z+visibility_below.w,0.0,1.0);
        let factors=native_fow_factors(overlay,vis,height,1u,visibility_edge);
        out.color=vec4<f32>(to_linear(mix(factors.rgb,to_display(out.color.rgb),factors.a)),out.color.a);
    }
'''+needle)
 p.write_text(s,encoding='utf-8')
print(json.dumps({'native_c250_cases':3,'routed_geometry_primitives':len(rows),'min_native_y':min(x['min_native_y'] for x in rows),'environment_normal_fow_enabled':True,'actor_fow_enabled':False}))
