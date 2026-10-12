from pathlib import Path
import json,collections
r=Path('E:/OpenLeague');profiles=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text(encoding='utf-8'))['profiles'];catalog=json.loads((r/'data/4.20/native_shader_descriptor_catalog.json').read_text(encoding='utf-8'))['descriptors'];lookup={d['name']:d for d in catalog}
counts=collections.Counter()
for p in profiles:
 for case in p['selector0']:
  names=[s['name'] for s in case['selected'] if s['stage']=='pixel']
  for name in names:
   counts[name]+=1
   descriptor=lookup[name]
   if 'NOLIGHTING' in name or 'FULLBRIGHT' in descriptor['defines']:print(json.dumps(dict(material=p['name'],flags=p['flags'],shader=name,defines=descriptor['defines'],source=descriptor['source'])))
print(json.dumps(dict(shader_routes=dict(counts))))
