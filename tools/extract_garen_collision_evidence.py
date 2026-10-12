"""Decode native Garen metadata and verify compiled NPC contact radii without calls."""
import ast,struct,json,hashlib,datetime
from pathlib import Path
from native_lua import Chunk,initialization
r=Path(__file__).resolve().parents[1];contracts=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));character=Path(contracts['garen']['character_source']);directory=character.parent/'Spells';base=character.parents[1]
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
metadata={}
for name in ['GarenE','GarenECancel']:
 p=directory/(name+'.luaobj');raw=p.read_bytes();reader=Chunk(raw);proto=reader.function();assert reader.i==len(raw)
 data=initialization(proto);assert data['stopped'] is None
 metadata[name]={'source':str(p),'sha256':hashlib.sha256(raw).hexdigest(),'initialization':data,'child_functions':len(proto['functions'])}
cancel=directory/'GarenECancel.inibin';v=ns['ini'](cancel);metadata['GarenECancel_inibin']={'source':str(cancel),'sha256':hashlib.sha256(cancel.read_bytes()).hexdigest(),'fields':{key:v.get(ns['hashkey']('SpellData',key)) for key in ['CanCastWhileDisabled','Cooldown','CantCancelWhileWindingUp','CastFrame']}}
world=json.loads((r/'data/4.20/map10_world.json').read_text(encoding='utf-8'));rows={};bad=[]
for name,d in world['definitions'].items():
 if d['kind'] not in ['Melee','Caster','Siege','Super','Monster','Boss']:continue
 p=base/name/(name+'.inibin');values=ns['ini'](p);native=values.get(ns['hashkey']('Data','GameplayCollisionRadius'))
 row={'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'native_gameplay_radius':float(native) if native is not None else None,'compiled_radius':d['radius']}
 row['matching']=native is not None and abs(float(native)-d['radius'])<.0001
 if not row['matching']:bad.append(name)
 rows[name]=row
proof={'passed':not bad,'npc_radii_checked':len(rows),'mismatches':bad,'npc_radii':rows,'garen_metadata':metadata,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'limits':['Metadata initialization only; native E/ECancel chunks do not contain recovered combat implementation.','Matching NPC gameplay radii do not prove original Garen contact geometry, default champion gameplay radius or modifier order.','Critical damage formula and exact recast timing remain unqualified.']}
(r/'docs/garen_collision_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':proof['passed'],'npc_radii':len(rows),'mismatches':bad,'metadata':metadata}));raise SystemExit(bool(bad))
