from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16012').replace('visibility-texture-133','fow-uniform-147').replace('visibility-texture-server','fow-uniform-server').replace('visibility-texture-client','fow-uniform-client').replace('visibility_texture_runtime_capture.json','fow_uniform_runtime_capture.json')
s=s.replace("WGPU_BACKEND='vulkan',", "WGPU_BACKEND='vulkan',OPENLEAGUE_FOW_PARAMETER_PROBE='1',")
s=s.replace("if d and d['uploads']>3", "if d and d['native_upscale'] is True and d['uploads']>3")
exec(compile(s,str(p),'exec'))
