from pathlib import Path
import json,shutil,hashlib
from datetime import datetime,timezone
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));reader=load('data/4.20/map_particle_type_reader_contract.json');selector=load('data/4.20/map_particle_type_selection_contract.json');catalog=load('data/4.20/map10_particle_catalog.json');rows=[]
for definition in catalog['definitions']:
 for group in definition['groups']:
  source=next(c for c in reader['cases'] if c['authored']==group['declared_type']);selected=next(c for c in selector['cases'] if c['input']==source['output']);rows.append({'reference':definition['reference'],'slot':group['slot'],'name':group['name'],'authored_type':group['declared_type'],'reader_output':source['output'],'class':selected['selection'],'reader_entry':reader['entry'],'selector_entry':selector['entry']})
assert len(rows)==52
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'native_sha256':reader['native_sha256'],'groups':rows,'orphan_sections_enabled':False,'limits':['Only the 52 native declared groups are class-bound. Six undeclared sections are not enabled.','Reader composition uses supplied cache/raw lookup boundaries; emitter constructors, lifecycle, rendering and full native asset loading remain unqualified.']};(r/'data/4.20/map_particle_class_bindings.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(stage/'native_particle_class.rs',r/'crates/client/src/native_particle_class.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');needle='mod simple_projected_config;';assert s.count(needle)==1
if 'mod native_particle_class;' not in s:s=s.replace(needle,'mod native_particle_class;\n'+needle);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/simple_projected_config.rs';s=p.read_text(encoding='utf-8');old='if system[format!("GroupPart{slot}Type")].as_str()!=Some("Simple") {';new='if crate::native_particle_class::EmitterClass::from_system(system,slot)? != crate::native_particle_class::EmitterClass::Simple {'
if old in s:s=s.replace(old,new).replace('native group is not explicitly a Simple emitter','native group does not select a Simple emitter');p.write_text(s,encoding='utf-8')
else:assert new in s
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'native_bindings':52,'simple':sum(v['class']=='Simple' for v in rows),'complex':sum(v['class']=='Complex' for v in rows),'runtime_consumer':'SimpleProjectedConfig','full_renderer_complete':False}))
