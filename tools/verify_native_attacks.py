"""Compare every imported basic-attack numeric contract to original 4.20 sources."""
import ast,struct,json,hashlib,math,datetime
from pathlib import Path
root=Path(__file__).resolve().parents[1]
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'native-parser','exec'),ns)
rows=json.loads((root/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));roster=json.loads((root/'data/4.20/champions.json').read_text(encoding='utf-8'));bad=[]
if set(rows)!=set(p['id'] for p in roster):bad.append(['roster','champion mismatch'])
def number(v,default):return default if v is None else float(v)
for champion,row in rows.items():
 for role in ('character','spell'):
  path=Path(row[role+'_source']);data=ns['ini'](path)
  if hashlib.sha256(path.read_bytes()).hexdigest()!=row[role+'_sha256']:bad.append([champion,role,'hash'])
  for field,value in row['native_'+role+'_values'].items():
   if data.get(ns['hashkey']('Data' if role=='character' else 'SpellData',field))!=value:bad.append([champion,role,field])
 c=row['native_character_values'];s=row['native_spell_values']
 period=number(c['AttackTotalTime'],1.6*(1+number(c['AttackDelayOffsetPercent'],0)))
 cast=number(c['AttackCastTime'],period*(.3+number(c['AttackDelayCastOffsetPercent'],0)))
 expected={'base_period_seconds':period,'base_windup_seconds':cast,'windup_speed_ratio':number(c['AttackDelayCastOffsetPercentAttackSpeedRatio'],1),'missile_speed':None if s['MissileSpeed'] is None else float(s['MissileSpeed']),'melee':str(c['IsMelee']).lower() in ('yes','true','1'),'cant_cancel':str(s['CantCancelWhileWindingUp']).lower() in ('yes','true','1')}
 for field,value in expected.items():
  if isinstance(value,float):valid=math.isclose(row[field],value,rel_tol=1e-8,abs_tol=1e-8)
  else:valid=row[field]==value
  if not valid:bad.append([champion,field,'derived mismatch'])
 if not row['melee'] and not (row['missile_speed'] and row['missile_speed']>0):bad.append([champion,'missing ranged speed'])
proof={'passed':not bad,'champions_checked':len(rows),'source_files_checked':2*len(rows),'mismatches':bad,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Native fields and source hashes verified; formula defaults and windup-speed interpolation still require historical runtime qualification.','Main attack profile only; special attacks, scripts, crit variants and per-champion semantics remain incomplete.']}
(root/'docs/native_attack_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));raise SystemExit(bool(bad))
