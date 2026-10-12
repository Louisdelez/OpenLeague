from pathlib import Path
import json
r=Path('E:/OpenLeague')
for name in ['native_shader_descriptor_catalog.json','environment_shader_macros_contract.json','environment_render_defaults.json']:
 d=json.loads((r/'data/4.20'/name).read_text(encoding='utf-8'))
 print(name,list(d.keys()))
 if name=='environment_render_defaults.json':print(json.dumps(d)[:2200])
 if name=='native_shader_descriptor_catalog.json':
  def walk(v):
   if isinstance(v,dict):
    if any(isinstance(x,str) and 'Environment_LIT_NO_EMISSIVE_DECAL_PS'==x for x in v.values()):print('DESCRIPTOR',json.dumps(v)[:3000])
    else:
     for x in v.values():walk(x)
   elif isinstance(v,list):
    for x in v:walk(x)
  walk(d)
 if name=='environment_shader_macros_contract.json':
  count=0
  for c in d['cases']:
   if c['quality']==3 and c['cloud_feature']==False and c['animate_feature']==False and not c['cache_hit']:
    print('CASE',json.dumps(c));count+=1
    if count==2:break
