from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_font_gpu.rs';s=p.read_text(encoding='utf-8')
start=s.index('#[derive(Clone,Copy,Debug,ShaderType)]');end=s.index('pub struct Plugin;',start);material=s[start:end]
material=material.replace(',pub mode:Vec4','').replace('for target in fragment.targets.iter_mut().flatten()', 'if key.bind_group_data.glow {fragment.shader_defs.push("NATIVE_FONT_GLOW".into());} for target in fragment.targets.iter_mut().flatten()')
header='use bevy::{prelude::*,render::render_resource::{AsBindGroup,ShaderType,RenderPipelineDescriptor,BlendState,BlendComponent,BlendFactor,BlendOperation},shader::ShaderRef,ui_render::ui_material::{UiMaterial,UiMaterialKey}};\n'
(r/'crates/client/src/native_font_material.rs').write_text(header+material,encoding='utf-8')
s=s[:start]+s[end:];s=s.replace('ui_render::{UiMaterial,UiMaterialKey,UiMaterialPlugin}','ui_render::UiMaterialPlugin').replace(',mode:Vec4::ZERO','');s=s.replace('#[derive(Resource,Default)]','pub use crate::native_font_material::*;\n#[derive(Resource,Default)]',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_font_material;' not in s;s='mod native_font_material;\n'+s;p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_font_ui.wgsl';s=p.read_text(encoding='utf-8').replace(',mode:vec4<f32>','');s=s.replace('    if parameters.mode.x!=0.0 {return native_font_glow(font_texel,parameters.color0);}','#ifdef NATIVE_FONT_GLOW\n    return native_font_glow(font_texel,parameters.color0);\n#else');s=s.replace('textureSample(fill,fill_sampler,fill_uv),parameters.color0,parameters.color1);','textureSample(fill,fill_sampler,fill_uv),parameters.color0,parameters.color1);\n#endif');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8');prefix,tail=s.split('#[cfg(test)] mod source_atlas_tests {',1)
tail=tail.replace('));app.insert_resource(sizes);', '));',1)
tail=tail.replace('let mut gpu=crate::native_font_gpu::Pages::default();let mut assets=Assets::<Image>::default();','')
tail=tail.replace('        for height in [800,1080,768] {','        let mut gpu=crate::native_font_gpu::Pages::default();let mut assets=Assets::<Image>::default();let mut previous=Vec::new();\n        for height in [800,1080,768] {',1)
anchor='faces.atlas_cell_for_text(&sizes,0,233).unwrap();assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),1);assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),0);'
assert anchor in tail;tail=tail.replace(anchor,anchor+'\n            let current=gpu.banks.iter().flatten().map(Handle::id).collect::<Vec<_>>();assert_eq!(current.len(),19);assert!(current.iter().all(|id|!previous.contains(id)));previous=current;drop(faces);app.insert_resource(sizes);')
p.write_text(prefix+'#[cfg(test)] mod source_atlas_tests {'+tail,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/fix_native_font_gpu.py'),r/'tools/fix_native_font_gpu.py');print('native material module and source test ownership corrected')
