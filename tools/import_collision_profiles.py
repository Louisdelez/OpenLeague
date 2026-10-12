"""Extract native collision values without inventing missing gameplay radii."""
from pathlib import Path
import ast,struct,json,hashlib,datetime
r=Path(__file__).resolve().parents[1];reference=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'))
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
fields={'pathfinding_radius':'PathfindingCollisionRadius','selection_radius':'SelectionRadius','gameplay_radius':'GameplayCollisionRadius'}
rows={};missing={key:[] for key in fields}
for name,contract in reference.items():
 source=Path(contract['character_source']);values=ns['ini'](source);row={'source':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest()}
 for key,field in fields.items():
  value=values.get(ns['hashkey']('Data',field));row[key]=float(value) if value is not None else None
  if value is None:missing[key].append(name)
  else:assert row[key]>0 and row[key]<10000,(name,field,value)
 rows[name]=row
assert len(rows)==122
out=r/'data/4.20/collision_profiles.json';out.write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
proof={'passed':True,'champions':len(rows),'native_numeric_fields':sum(row[key] is not None for row in rows.values() for key in fields),'missing':missing,'data_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'limits':['Native field extraction only; no full body-collision implementation or native runtime qualification.','Missing gameplay radius remains null; pathfinding radius and selection radius must not silently replace gameplay radius.']}
(r/'docs/collision_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'champions':122,'fields':proof['native_numeric_fields'],'missing':{k:len(v) for k,v in missing.items()},'garen':rows['garen']}))
