from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16011').replace('visibility-texture-133','native-inibin-146').replace('visibility-texture-server','native-inibin-server').replace('visibility-texture-client','native-inibin-client').replace('visibility_texture_runtime_capture.json','native_inibin_runtime_capture.json')
s=s.replace("if d and d['uploads']>3", "if d and d['configuration_profile']=='native_map10_inibin_no_launch_override' and d['binary_configuration']=='Levels/Map10/terrain.inibin' and d['native_upscale'] is True and d['native_blur_sigma']==-1 and d['uploads']>3")
exec(compile(s,str(p),'exec'))
