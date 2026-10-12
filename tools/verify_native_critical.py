"""Verify critical numeric profiles against both original source files."""
import ast,struct,json,hashlib,math,datetime
from pathlib import Path
r=Path(__file__).resolve().parents[1];tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
c=json.loads((r/'data/4.20/critical_contracts.json').read_text(encoding='utf-8'));base=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));bad=[]
def num(v,default):return float(v) if v is not None else default
for name,row in c.items():
 for role in ('character','spell'):
  p=Path(row[role+'_source']);raw=ns['ini'](p)
  if hashlib.sha256(p.read_bytes()).hexdigest()!=row[role+'_sha256']:bad.append([name,role,'hash'])
  for field,value in row['native_'+role+'_values'].items():
   if raw.get(ns['hashkey']('Data' if role=='character' else 'SpellData',field))!=value:bad.append([name,role,field])
 v=row['native_character_values'];s=row['native_spell_values'];period=num(v['CritAttack_AttackTotalTime'],1.6*(1+num(v['CritAttack_AttackDelayOffsetPercent'],0)))
 expected={'melee':base[name]['melee'],'chance':num(v['BaseCritChance'],0),'chance_growth':num(v['CritPerLevel'],0),'multiplier':num(v['CritDamageBonus'],2),'base_period_seconds':period,'base_windup_seconds':num(v['CritAttack_AttackCastTime'],period*(.3+num(v['CritAttack_AttackDelayCastOffsetPercent'],0))),'windup_speed_ratio':num(v['CritAttack_AttackDelayCastOffsetPercentAttackSpeedRatio'],1),'missile_speed':num(s['MissileSpeed'],base[name]['missile_speed']) if s['MissileSpeed'] is not None or base[name]['missile_speed'] is not None else None,'cant_cancel':str(s['CantCancelWhileWindingUp']).lower() in ('yes','true','1')}
 for field,value in expected.items():
  valid=math.isclose(row[field],value,abs_tol=1e-8,rel_tol=1e-8) if isinstance(value,float) else row[field]==value
  if not valid:bad.append([name,field,'derived mismatch'])
proof={'passed':not bad,'champions_checked':len(c),'files_checked':len(c)*2,'mismatches':bad,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Native numeric correspondence only. SplitMix64 sampling, cancelled-roll retention, structures exclusion and default timing interpretations remain reconstructed.','Garen empowered Q critical interactions and all other passive/ability-specific critical semantics remain incomplete.']}
(r/'docs/native_critical_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));raise SystemExit(bool(bad))
