from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague')
assert '#[uniform(129)]' not in (r/'crates/client/src/map_fog.rs').read_text(encoding='utf-8'), 'Profile binding already installed; restore archived inputs before replaying this one-time migration'
archive=r/'docs/plan_history'/('fog-profile-binding-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
archive.mkdir(parents=True)
def edit(name,fn):
 p=r/name;s=p.read_text(encoding='utf-8');t=fn(s);assert s!=t,name
 dest=archive/name;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
 p.write_text(t,encoding='utf-8')
for name,bind in [('map_fog.rs',129),('terrain_material.rs',36)]:
 def material(s,bind=bind):
  s=s.replace('pub fog_mod2x:u32,',f'pub fog_mod2x:u32,\n    #[uniform({bind})] pub fog_profile:UVec4,\n    #[uniform({bind+1})] pub fog_constant:Vec4,')
  s=s.replace('fog_mod2x:u32::from(native_settings.colormap),','fog_mod2x:u32::from(native_settings.colormap),\n        fog_profile:crate::native_high_fog::profile_uniform(3),\n        fog_constant:crate::native_high_fog::fog_constant(),')
  s=s.replace('fog_mod2x:0,','fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,')
  return s
 edit('crates/client/src/'+name,material)
for name,bind in [('native_environment_fog.wgsl',129),('terrain_height_blend.wgsl',36)]:
 def shader(s,name=name,bind=bind):
  prefix=f'@group(#{{MATERIAL_BIND_GROUP}}) @binding({bind}) var<uniform> fog_profile:vec4<u32>;\n@group(#{{MATERIAL_BIND_GROUP}}) @binding({bind+1}) var<uniform> fog_constant:vec4<f32>;\n'
  s=prefix+s
  s=s.replace('    top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;','    if fog_profile.y==1u {top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;}')
  start=s.index('    let fog=textureSample(fog_lighting')
  if name=='native_environment_fog.wgsl':
   end=s.index('    out.color=main_pass_post_lighting_processing',start)
   block=s[start:end]
   s=s[:start]+'''    if fog_profile.z==1u {
      if fog_profile.x==1u {
        let far=clamp(high_fog.y,0.0,1.0);
        out.color=vec4<f32>(to_linear(mix(to_display(out.color.rgb),fog_constant.rgb,far)),out.color.a);
      } else {
'''+block+'      }\n    }\n'+s[end:]
  else:
   s=s[:start]+'''    if fog_profile.z==0u {return vec4<f32>(display_to_linear(display),1.0);}
    if fog_profile.x==1u {
      let far=clamp(high_fog.y,0.0,1.0);
      return vec4<f32>(display_to_linear(mix(display,fog_constant.rgb,far)),1.0);
    }
'''+s[start:]
  return s
 edit('assets/shaders/'+name,shader)
def runtime(s):
 s=s.replace('//! Map10 native high-fog/cloud binding. Current profile uses PE initial fog quality2.','//! Map10 native fog/cloud binding from the qualified environment setting suffix.')
 pos=s.index('pub fn cloud_image')
 s=s[:pos]+'''pub fn profile_uniform(setting:i32)->UVec4 {
 let p=crate::native_fog_profile::Profile::from_setting(setting);
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 UVec4::new(p.fog,u32::from(p.clouds),u32::from(d["enabled"].as_bool().unwrap()),0)
}
pub fn fog_constant()->Vec4 {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 Vec4::new(d["native_fog_rgb"][0].as_u64().unwrap() as f32/255.,d["native_fog_rgb"][1].as_u64().unwrap() as f32/255.,d["native_fog_rgb"][2].as_u64().unwrap() as f32/255.,1.)
}
pub fn synchronize(profile:UVec4,constants:Vec4,fog:&mut Assets<crate::map_fog::FogMaterial>,terrain:&mut Assets<crate::terrain_material::TerrainMaterial>,catalog:&mut crate::map_fog::FogCatalog) {
 catalog.extension.cloud_phase=constants;catalog.extension.fog_profile=profile;
 for (_,mut m) in fog.iter_mut() {m.extension.cloud_phase=constants;m.extension.fog_profile=profile;}
 for (_,mut m) in terrain.iter_mut() {m.cloud_phase=constants;m.fog_profile=profile;}
}
'''+s[pos:]
 s=s.replace('pub fn advance(time:Res<Time>,','pub fn advance(quality:Res<crate::native_environment_draw::Quality>,time:Res<Time>,')
 start=s.index(' let constants=Vec4::from_array(state.phase.constants(2000.));catalog.extension.cloud_phase=constants;')
 s=s[:start]+''' let constants=Vec4::from_array(state.phase.constants(2000.));
 synchronize(profile_uniform(quality.value),constants,&mut fog,&mut terrain,&mut catalog);
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_environment_levels_update_existing_materials_and_future_catalog() {
  let mut catalog=crate::map_fog::FogCatalog::default();
  let mut fog=Assets::default();let mut terrain=Assets::default();
  let handle=fog.add(crate::map_fog::FogMaterial {base:StandardMaterial::default(),extension:catalog.extension.clone()});
  for level in [3,1,0,2,4,1,3] {
   let profile=profile_uniform(level);let constants=Vec4::new(0.0005,0.25,0.5,0.);
   synchronize(profile,constants,&mut fog,&mut terrain,&mut catalog);
   assert_eq!(catalog.extension.fog_profile,profile);
   assert_eq!(fog.get(&handle).unwrap().extension.fog_profile,profile);
   assert_eq!(fog.get(&handle).unwrap().extension.cloud_phase,constants);
   assert_eq!(profile.x,if level<=1 {1}else{2});assert_eq!(profile.y,u32::from(level>=2));assert_eq!(profile.z,1);
  }
  assert_eq!(fog_constant(),Vec4::new(34./255.,62./255.,84./255.,1.));
 }
}
'''
 return s
edit('crates/client/src/native_high_fog.rs',runtime)
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Updated native profile uniforms, low/high shader branches and material synchronization; archive:',archive)
