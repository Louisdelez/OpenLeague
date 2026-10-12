from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16009').replace('visibility-texture-133','recovered-global-143').replace('visibility-texture-server','recovered-global-server').replace('visibility-texture-client','recovered-global-client').replace("OPENLEAGUE_SCREENSHOT_DELAY='20'","OPENLEAGUE_SCREENSHOT_DELAY='25',OPENLEAGUE_MAP_RESOURCE_PROBE=str(r/'logs/recovered-global-catalog-143.json')").replace('visibility_texture_runtime_capture.json','recovered_global_runtime_capture.json')
exec(compile(s,str(p),'exec'))
