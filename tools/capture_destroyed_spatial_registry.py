from pathlib import Path
s=Path('E:/mapslol3v3/capture_altar_spatial_registry.py').read_text()
s=s.replace('16035','16039').replace('grass-altar-222','grass-destroyed-223').replace('grass_altar_registry_runtime','grass_destroyed_registry_runtime')
s=s.replace('30 world/intact-structure/altar model identities integrated; destroyed models, forms/skins and dynamic size producers remain open.','42 world/structure/altar model identities integrated; full destruction triggers/animation, forms/skins and dynamic size producers remain open.')
exec(compile(s,'capture-destroyed-spatial-registry','exec'))
