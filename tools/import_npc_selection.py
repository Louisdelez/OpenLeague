"""Native NPC selection radii; absent fields remain explicit null."""
import ast,struct,json,hashlib,datetime
from pathlib import Path
r=Path(__file__).resolve().parents[1];contracts=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));base=Path(contracts['garen']['character_source']).parents[1]
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
world=json.loads((r/'data/4.20/map10_world.json').read_text(encoding='utf-8'));rows={};missing=[]
for name in world['definitions']:
 source=base/name/(name+'.inibin');raw=source.read_bytes();values=ns['ini'](source);value=values.get(ns['hashkey']('Data','SelectionRadius'));radius=float(value) if value is not None else None
 if radius is not None:assert 0<radius<10000
 else:missing.append(name)
 rows[name]={'selection_radius':radius,'source':str(source),'sha256':hashlib.sha256(raw).hexdigest()}
out=r/'data/4.20/npc_selection_profiles.json';out.write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
proof={'passed':True,'definitions':len(rows),'native_selection_fields':len(rows)-len(missing),'missing':missing,'data_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'limits':['Extraction validates original scalar fields; no observed original runtime picking equivalence.','Missing radii remain null; four structure types continue previous explicitly reconstructed client 160-unit selection fallback.']}
(r/'docs/npc_selection_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
