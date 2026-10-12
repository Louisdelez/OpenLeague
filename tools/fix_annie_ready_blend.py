from pathlib import Path
import urllib.request,hashlib,json,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
commit='66c9837f93ac359b13d5e915c9078310ed2d2c93'
folder=r/'tools/references/reyengine';folder.mkdir(parents=True,exist_ok=True)
paths=['LICENSE','docs/research/vfx-blend-modes.md','docs/research/troybin-rosetta.md','src/ReyEngine.Formats/Particles/TroyBinConverter.cs','src/ReyEngine.Formats/Vfx/VfxBlend.cs']
refs=[]
for p in paths:
 url=f'https://raw.githubusercontent.com/TheKillerey/ReyEngine/{commit}/{p}'
 b=urllib.request.urlopen(url,timeout=30).read();out=folder/Path(p).name;out.write_bytes(b)
 refs.append({'url':url,'path':str(out.relative_to(r)).replace('\\','/'),'sha256':hashlib.sha256(b).hexdigest()})
(folder/'manifest.json').write_text(json.dumps({'commit':commit,'files':refs,'scope':'Read-only community research, not original 4.20 runtime proof'},indent=2)+'\n',encoding='utf-8')
p=r/'crates/client/src/annie_ready.rs';s=p.read_text(encoding='utf-8')
s=s.replace('render::render_resource::AsBindGroup, shader::ShaderRef','mesh::MeshVertexBufferLayoutRef, pbr::{MaterialPipeline,MaterialPipelineKey}, render::render_resource::{AsBindGroup,RenderPipelineDescriptor,SpecializedMeshPipelineError,BlendState,BlendComponent,BlendFactor,BlendOperation}, shader::ShaderRef')
old=''' // Native rendermode4 was retained in the audit. Alpha blending is a reconstructed
 // binding, not a claim that its original D3D blend-state mapping was recovered.
 fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
'''
new=''' // Keep transparent queue/depth semantics, then bind explicit ALPHAADD factors.
 // Community Troy conversion preserves rendermode; mode4 maps SrcAlpha/One.
 // This cross-version evidence does not qualify original 4.20 runtime fidelity.
 fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
 fn specialize(_pipeline:&MaterialPipeline,descriptor:&mut RenderPipelineDescriptor,_layout:&MeshVertexBufferLayoutRef,_key:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError> {
  if let Some(fragment)=descriptor.fragment.as_mut() {
   for target in fragment.targets.iter_mut().flatten() {target.blend=Some(alpha_add());}
  }
  if let Some(depth)=descriptor.depth_stencil.as_mut() {depth.depth_write_enabled=false;}
  Ok(())
 }
'''
assert old in s;s=s.replace(old,new)
needle='#[derive(Clone,Debug)]\nstruct Sample'
s=s.replace(needle,'''// Alpha channel preserved with normal alpha compositing; original alpha factors unqualified.
fn alpha_add()->BlendState {BlendState {color:BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::One,operation:BlendOperation::Add},alpha:BlendComponent::OVER}}
'''+needle)
s=s.replace('"blend_state_original_qualified":false','"blend_state_original_qualified":false,"color_blend":"SrcAlpha/One/Add","blend_basis":"ReyEngine Troy identity mapping and VfxBlend mode4; cross-version community evidence"')
p.write_text(s,encoding='utf-8');shutil.copyfile(p,w/'annie_ready.rs')
shutil.copyfile(r/'assets/shaders/annie_ready.wgsl',w/'annie_ready.wgsl')
print('Bound mode4 color SrcAlpha/One; source evidence archived; native4.20 appearance still unqualified.')
