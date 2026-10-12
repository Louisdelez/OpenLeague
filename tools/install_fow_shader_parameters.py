from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/client/src/fow_settings.rs';s=p.read_text(encoding='utf-8');assert 'pub struct ShaderParameters' not in s
s=s.replace('impl Settings {','''#[derive(Clone,Copy)]
pub struct ShaderParameters {pub coordinates:[f32;4],pub height:[f32;4],pub edge:[f32;4]}
impl Settings {
    pub fn shader_parameters(&self,extent:f32)->Result<ShaderParameters,&'static str> {
        let coordinates=crate::native_fow::FogParams::from_native_extent(extent)?.params().to_array();
        // Preserve the native SSE ordering and singular edge result (infinity).
        let height_scale=1./(self.fade_finish-self.fade_start);
        let height_shift=-(height_scale*self.fade_start);
        let edge_scale=1./(1.-self.edge_enhancement);
        Ok(ShaderParameters {coordinates,height:[height_scale,height_shift,0.,0.],edge:[edge_scale,1.-edge_scale,self.one_over_tint_point,0.]})
    }
''')
s=s.replace('    #[test] fn upscale_layers', '''    #[test] fn all_shader_uniform_bits_match_original_initializer_stores() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_shader_parameters_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let mut s=Settings::native_initial();let field=|name:&str|c[name].as_f64().unwrap() as f32;
            s.fade_start=field("fade_start");s.fade_finish=field("fade_finish");s.edge_enhancement=field("edge_enhancement");s.one_over_tint_point=field("one_over_tint_point");
            let v=s.shader_parameters(field("extent")).unwrap();
            for (name,actual) in [("FOG_OF_WAR_PARAMS",v.coordinates),("FOW_HEIGHT_FADE",v.height),("FOW_EDGE_CONTROL",v.edge)] {
                let expected:Vec<u32>=c["result_bits"][name].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual.map(f32::to_bits).as_slice(),expected.as_slice(),"{} {name}",c["name"]);
            }
        }
    }
    #[test] fn upscale_layers''');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/terrain_material.rs';s=p.read_text(encoding='utf-8').replace('#[uniform(20)] pub visibility_diagnostic:u32,','#[uniform(20)] pub visibility_diagnostic:u32,\n    #[uniform(21)] pub visibility_height:Vec4,\n    #[uniform(22)] pub visibility_edge:Vec4,');s=s.replace('visibility_diagnostic:0,','visibility_diagnostic:0,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8').replace('#[uniform(108)] pub visibility_params:Vec4,','#[uniform(108)] pub visibility_params:Vec4,\n    #[uniform(109)] pub visibility_height:Vec4,\n    #[uniform(110)] pub visibility_edge:Vec4,').replace('visibility_map:Handle::default(),visibility_params:Vec4::ZERO,','visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,');s=s.replace('diagnostic_channel: if crate::fow_visibility_texture::diagnostic_enabled()', 'diagnostic_channel: if crate::fow_visibility_texture::parameter_diagnostic_enabled() {4} else if crate::fow_visibility_texture::diagnostic_enabled()');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_visibility_texture.rs';s=p.read_text(encoding='utf-8');s=s.replace('    let native=crate::native_fow::FogParams::from_native_extent(map.geometry.extent).expect("qualified Map10 extent").params();','    let uniforms=texture.settings.shader_parameters(map.geometry.extent).expect("qualified native Map10 FoW uniforms");\n    let native=Vec4::from_array(uniforms.coordinates);\n    let height=Vec4::from_array(uniforms.height);let edge=Vec4::from_array(uniforms.edge);')
s=s.replace('m.visibility_params!=params)', 'm.visibility_params!=params || m.visibility_height!=height || m.visibility_edge!=edge)')
s=s.replace('m.extension.visibility_params!=params)', 'm.extension.visibility_params!=params || m.extension.visibility_height!=height || m.extension.visibility_edge!=edge)')
s=s.replace('m.visibility_params=params;m.visibility_diagnostic=u32::from(diagnostic_enabled());', 'm.visibility_params=params;m.visibility_height=height;m.visibility_edge=edge;m.visibility_diagnostic=if parameter_diagnostic_enabled() {2} else {u32::from(diagnostic_enabled())};')
s=s.replace('m.extension.visibility_params=params;', 'm.extension.visibility_params=params;m.extension.visibility_height=height;m.extension.visibility_edge=edge;')
s+='''
pub fn parameter_diagnostic_enabled()->bool {std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var("OPENLEAGUE_FOW_PARAMETER_PROBE").as_deref()==Ok("1")}
'''
p.write_text(s,encoding='utf-8')
helper=Path('E:/mapslol3v3/fow_shader_functions.wgsl').read_text(encoding='utf-8');(r/'assets/shaders/fow_shader_functions.wgsl').write_text(helper,encoding='utf-8')
for file,binding,mode,output in [('terrain_height_blend.wgsl',21,'visibility_diagnostic==2u','return vec4<f32>(display_to_linear(vec3<f32>(native.z,visibility_edge.x*0.5,native.y)),1.0);'),('native_environment_fog.wgsl',109,'diagnostic_channel==4u','out.color=vec4<f32>(to_linear(vec3<f32>(native.z,visibility_edge.x*0.5,native.y)),1.0);return out;')]:
 p=r/'assets/shaders'/file;s=p.read_text(encoding='utf-8');target='@fragment fn fragment';start=s.index(target)
 s=s[:start]+f'@group(#{{MATERIAL_BIND_GROUP}}) @binding({binding}) var<uniform> visibility_height:vec4<f32>;\n@group(#{{MATERIAL_BIND_GROUP}}) @binding({binding+1}) var<uniform> visibility_edge:vec4<f32>;\n'+s[start:]
 target='    if visibility_diagnostic==1u {' if file.startswith('terrain') else '    if diagnostic_channel==3u {'
 # Native coordinate scale is already converted for Bevy units; height uses native units.
 s=s.replace(target,f'    if {mode} {{\n        let native=native_fow_coordinates(vec3<f32>(in.world_position.x,in.world_position.y*20.0,in.world_position.z),visibility_params,visibility_height);\n        {output}\n    }}\n'+target)
 p.write_text(s+'\n'+helper,encoding='utf-8')
shutil.copy2('E:/mapslol3v3/install_fow_shader_parameters.py',r/'tools/install_fow_shader_parameters.py')
print('Native height/edge uniforms bound to both material types; diagnostic consumer uses original coordinate arithmetic.')
