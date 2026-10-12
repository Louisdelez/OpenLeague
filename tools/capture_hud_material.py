from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16007').replace('visibility-texture-133','hud-material-133').replace('visibility-texture-server','hud-material-server').replace('visibility-texture-client','hud-material-client').replace("OPENLEAGUE_SCREENSHOT_DELAY='20'","OPENLEAGUE_SCREENSHOT_DELAY='25'").replace('visibility_texture_runtime_capture.json','hud_material_runtime_capture.json')
exec(compile(s,str(p),'exec'))
