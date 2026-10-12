from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16006').replace('visibility-texture-133','visibility-material-133').replace('visibility-texture-server','visibility-material-server').replace('visibility-texture-client','visibility-material-client').replace("OPENLEAGUE_SCREENSHOT_DELAY='20'","OPENLEAGUE_SCREENSHOT_DELAY='25',OPENLEAGUE_FOW_MASK_PROBE='1',OPENLEAGUE_RENDER_FOCUS='280,0,250',OPENLEAGUE_PROBE_ENV_ONLY='1',OPENLEAGUE_PROBE_NO_MSAA='1'").replace('visibility_texture_runtime_capture.json','visibility_material_runtime_capture.json')
exec(compile(s,str(p),'exec'))
