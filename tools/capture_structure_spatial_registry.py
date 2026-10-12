from pathlib import Path
s=Path('E:/mapslol3v3/capture_grass_live_registry.py').read_text(encoding='utf-8')
s=s.replace('16019','16031').replace('grass-live-215','grass-structure-220').replace('docs/grass_live_registry_runtime.json','docs/grass_structure_registry_runtime.json')
s=s.replace("m['root_members']==m['registered']", "m['queued_subdivisions']==0")
s=s.replace('  initial=m;actor=', "  initial=m;structure_names=set(json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text()));structures=[v for v in m['objects'] if v['model'].lower() in structure_names];assert len(structures)>=6,('normal structures missing',m)\n  actor=")
s=s.replace('initial=initial,after_movement=m,','initial=initial,registered_intact_structures=structures,after_movement=m,')
s=s.replace('forms/skins/NPC registry and dynamic size producers remain open.','28 world/intact-structure model identities integrated; destroyed models, altars, forms/skins and dynamic size producers remain open.')
s=s.replace("dict(registered=m['registered'],movement_verified=True,capture=str(capture))", "dict(registered=m['registered'],structures_registered=len(structures),movement_verified=True,capture=str(capture))")
exec(compile(s,'capture-structure-spatial-registry','exec'))
