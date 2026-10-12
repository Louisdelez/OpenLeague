"""Recover authored but undeclared spawn sections, without enabling them."""
from pathlib import Path
import json,sys,hashlib,importlib.util,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));from native_troy import decode,key_hash
folder=r/'tools/references/lolpytools'
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
reader=module('orphan_ini',folder/'lolpytools_inibin2.py');fixer=module('orphan_fix',folder/'lolpytools_troybin_fix.py')
sha=lambda b:hashlib.sha256(b).hexdigest();cp=r/'data/4.20/map10_particle_catalog.json';catalog=json.loads(cp.read_text(encoding='utf-8'));deploy=Path(catalog['particles_source']).parents[2]
names=('disc','fuzzydisc','crown');provenance={};keys=[key_hash('System',f'GroupPart{i}') for i in range(50)]
for path in sorted((deploy/'DATA/Particles').glob('*.troybin')):
 values=decode(path)
 for key in keys:
  v=values.get(key,{}).get('value')
  if isinstance(v,str) and v.lower() in names and v.lower() not in provenance:provenance[v.lower()]={'native_file':str(path),'source_sha256':sha(path.read_bytes()),'group_hash':key,'encoded_name':v,**values[key]}
 if len(provenance)==len(names):break
assert set(provenance)==set(names)
extended={h:(s,n) for s,n,h in fixer.a_ihash(names,fixer.group_names)};proofs=[]
for definition in catalog['definitions']:
 if Path(definition['native_file']).stem not in ('Chaos_Spawn','Order_Spawn'):continue
 path=Path(definition['native_file']);raw=decode(path);independent=reader.from_file(str(path));fixer.fix(independent);before=len(independent['UNKNOWN_HASHES']);fixer.fix(independent,extended)
 doc=json.loads((r/definition['asset']).read_text(encoding='utf-8'));doc['fields']=[];doc['sections']={};named=set();orphan=[]
 for section,fields in independent['Values'].items():
  doc['sections'][section]={}
  for name,value in fields.items():
   key=key_hash(section,name);assert key in raw and key not in named;named.add(key);native=raw[key];expected=reader.sanitize_str(native['value']) if isinstance(native['value'],str) else native['value'];normal=lambda v:list(v) if isinstance(v,tuple) else v
   assert normal(expected)==normal(value),(path,section,name)
   doc['sections'][section][name]=value;doc['fields'].append({'section':section,'name':name,'native_hash':key,**native})
 declared={v for k,v in doc['sections']['System'].items() if k.startswith('GroupPart') and k[9:].isdigit()}
 for section in names:
  assert section not in declared
  hashes=[f['native_hash'] for f in doc['fields'] if f['section']==section];assert len(hashes)>=10
  orphan.append({'section':section,'native_hashes':hashes,'declared_active':False,'runtime_activation_qualified':False,'name_provenance':provenance[section]})
 doc['unknown_hashes']={str(k):v for k,v in raw.items() if k not in named};assert len(named)+len(doc['unknown_hashes'])==len(raw)
 doc['orphan_sections']=orphan;doc['semantics_qualified']=False;doc['orphan_section_limits']=['Names supported by original corpus GroupPart strings and matching section-field hashes; original runtime reader execution not qualified.','No GroupPart entry names these sections in this definition. Their recovery does not enable them or count them among the 52 declared groups.']
 target=r/definition['asset'];target.write_text(json.dumps(doc,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');definition.update(asset_sha256=sha(target.read_bytes()),independent_named_fields_equal=len(named),unknown_field_count=len(doc['unknown_hashes']),orphan_sections=[v['section'] for v in orphan])
 proofs.append({'reference':definition['reference'],'native_sha256':sha(path.read_bytes()),'unknown_before':before,'unknown_after':len(doc['unknown_hashes']),'fields_recovered':before-len(doc['unknown_hashes']),'sections':orphan,'remaining_unknown':doc['unknown_hashes']})
catalog['unknown_fields']=[{'reference':d['reference'],'hashes':list(json.loads((r/d['asset']).read_text(encoding='utf-8'))['unknown_hashes'])} for d in catalog['definitions'] if d['unknown_field_count']]
catalog['updated_utc']=datetime.now(timezone.utc).isoformat();catalog['orphan_section_proof']='docs/map10_spawn_orphan_sections.json';cp.write_text(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof={'updated_utc':catalog['updated_utc'],'complete':False,'renderer_changed':False,'passed':True,'files':proofs,'fields_recovered':sum(p['fields_recovered'] for p in proofs),'unknown_remaining':sum(d['unknown_field_count'] for d in catalog['definitions']),'declared_group_count':sum(len(d['groups']) for d in catalog['definitions']),'limits':doc['orphan_section_limits']}
(r/'docs/map10_spawn_orphan_sections.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve() != (r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({k:v for k,v in proof.items() if k not in ('files','limits')}))
