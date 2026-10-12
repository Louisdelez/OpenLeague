from pathlib import Path
s=Path('E:/mapslol3v3/capture_grass_live_registry.py').read_text(encoding='utf-8')
s=s.replace('16019','16035').replace('grass-live-215','grass-altar-222').replace('docs/grass_live_registry_runtime.json','docs/grass_altar_registry_runtime.json')
s=s.replace("m['root_members']==m['registered']", "m['queued_subdivisions']==0")
s=s.replace('  initial=m;actor=', "  initial=m;altars=[v for v in m['objects'] if v['model'] in ['altar_l','altar_r']];assert {v['model'] for v in altars}=={'altar_l','altar_r'},('normal loaded altars missing',m)\n  actor=")
s=s.replace('initial=initial,after_movement=m,','initial=initial,registered_altars=altars,after_movement=m,')
s=s.replace('forms/skins/NPC registry and dynamic size producers remain open.','30 world/intact-structure/altar model identities integrated; destroyed models, forms/skins and dynamic size producers remain open.')
s=s.replace("dict(registered=m['registered'],movement_verified=True,capture=str(capture))", "dict(registered=m['registered'],registered_altar_models=[v['model'] for v in altars],movement_verified=True,capture=str(capture))")
exec(compile(s,'capture-altar-spatial-registry','exec'))
