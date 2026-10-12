from pathlib import Path
r=Path('E:/OpenLeague')
for relative in ['crates/client/src/native_font_material.rs','crates/client/src/native_font_gpu.rs']:
 p=r/relative;s=p.read_text(encoding='utf-8').replace('pub struct Material {','pub struct FontMaterial {').replace('From<&Material>','From<&FontMaterial>').replace('material:&Material','material:&FontMaterial').replace('UiMaterial for Material','UiMaterial for FontMaterial').replace('Result<Material,String>','Result<FontMaterial,String>').replace('Ok(Material {','Ok(FontMaterial {').replace('UiMaterialPlugin::<Material>','UiMaterialPlugin::<FontMaterial>').replace('pub use crate::native_font_material::*;','pub use crate::native_font_material::{FontMaterial,Parameters,blend};')
 if relative.endswith('native_font_gpu.rs'):s=s.replace('AsBindGroup,ShaderType,RenderPipelineDescriptor,BlendState,BlendComponent,','').replace('shader::ShaderRef,','')
 p.write_text(s,encoding='utf-8')
print('font material name disambiguated')
