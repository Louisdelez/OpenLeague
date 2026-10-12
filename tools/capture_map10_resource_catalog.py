from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16008').replace('visibility-texture-133','map10-resource-136').replace('visibility-texture-server','map10-resource-server').replace('visibility-texture-client','map10-resource-client').replace("OPENLEAGUE_SCREENSHOT_DELAY='20'","OPENLEAGUE_SCREENSHOT_DELAY='25',OPENLEAGUE_MAP_RESOURCE_PROBE=str(r/'logs/map10-resource-catalog-136.json')").replace('visibility_texture_runtime_capture.json','map10_resource_runtime_capture.json')
exec(compile(s,str(p),'exec'))
