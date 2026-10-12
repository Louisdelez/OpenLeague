from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16010').replace('visibility-texture-133','fow-upscale-config-144').replace('visibility-texture-server','fow-upscale-config-server').replace('visibility-texture-client','fow-upscale-config-client').replace('visibility_texture_runtime_capture.json','fow_upscale_config_runtime_capture.json')
s=s.replace("if d and d['uploads']>3", "if d and d['native_upscale'] is True and d['native_blur_sigma']==-1 and d['uploads']>3")
exec(compile(s,str(p),'exec'))
