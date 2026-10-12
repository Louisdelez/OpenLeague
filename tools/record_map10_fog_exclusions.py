from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
profiles=load('data/4.20/map10_shader_material_fields.json');catalog=load('data/4.20/native_shader_descriptor_catalog.json');lookup={d['name']:d for d in catalog['descriptors']}
assert profiles['passed'];rows=[]
for p in profiles['profiles']:
 for case in p['selector0']:
  selected=[s['name'] for s in case['selected'] if s['stage']=='pixel']
  if not selected:
   assert p['name']=='Wall_of_Grass'
   rows.append(dict(material=p['gltf_name'],flags=p['flags'],emissive_handle_present=case['emissive_handle_present'],shader=None,static_fog_excluded=None,scope='No pixel route selected in selector0; special pass requires separate qualification'))
   continue
  assert len(selected)==1
  d=lookup[selected[0]];assert d['exists'];source=(r/'data/4.20/shaders'/d['source']).read_text(encoding='utf-8')
  assert '#if defined(FOG_PIXELSHADER_BLEND) && !defined(FULLBRIGHT) && !defined(NOLIGHTING)' in source
  blocked=any(k in d['defines'].split() for k in ['FULLBRIGHT','NOLIGHTING']);assert not blocked
  rows.append(dict(material=p['gltf_name'],flags=p['flags'],emissive_handle_present=case['emissive_handle_present'],shader=d['name'],defines=d['defines'],static_fog_excluded=blocked))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,passed=True,material_count=len(profiles['profiles']),selected_pixel_routes=sum(row['shader'] is not None for row in rows),unselected_routes=sum(row['shader'] is None for row in rows),static_fog_exclusions=0,cases=rows,source_hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in ['data/4.20/map10_shader_material_fields.json','data/4.20/native_shader_descriptor_catalog.json','data/4.20/shaders/Environment/LIT_PS.ps_2_0']},limits=['Existing original selector0 contracts cover87 Map10 native materials and both emissive handle states;172 LIT pixel routes audited,2 Wall_of_Grass cases select no pixel route here and need their separate pass.','No global NOLIGHTING/debug option, other selectors, whole renderer/frame or live macro refresh qualification.','NOLIGHTING standalone shader differs from LIT with NOLIGHTING macro: do not impose a blanket exclusion based solely on shader name.'])
(r/'data/4.20/map10_static_fog_exclusions.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(materials=len(profiles['profiles']),static_routes=proof['selected_pixel_routes'],unselected_routes=proof['unselected_routes'],static_excluded=0,complete=False)))
