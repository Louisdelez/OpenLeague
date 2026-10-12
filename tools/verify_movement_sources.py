"""Check community numeric provenance and native Garen Q coefficients separately."""
import ast,struct,json,hashlib,datetime
from pathlib import Path
r=Path(__file__).resolve().parents[1];rules=json.loads((r/'data/4.20/movement_rules.json').read_text(encoding='utf-8'));source=Path(rules['community_source']);text=source.read_text(encoding='utf-8');bad=[]
if hashlib.sha256(source.read_bytes()).hexdigest()!=rules['community_sha256']:bad.append('community hash')
checks={'low_threshold':'speed < 220.0f','middle_threshold':'speed >= 415.0f','high_threshold':'speed > 490.0f','low_ratio':'speed * 0.5f + 110.0f','middle_ratio':'speed * 0.8f + 83.0f','high_ratio':'speed * 0.5f + 230.0f'}
expected={'low_threshold':220.,'middle_threshold':415.,'high_threshold':490.,'low_ratio':.5,'middle_ratio':.8,'high_ratio':.5}
for key,token in checks.items():
 if token not in text or rules[key]!=expected[key]:bad.append(key)
base=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));deploy=Path(base['garen']['character_source']).parents[3];spells=json.loads((r/'data/4.20/native_spells_420.json').read_text(encoding='utf-8'));q=next(x for x in spells if x['champion'].lower()=='garen' and x['slot']==0);native=deploy/q['native_resource'];tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns);values=ns['ini'](native)
for rank in range(1,6):
 for field in [f'Effect2Level{rank}Amount',f'Effect5Level{rank}Amount']:
  if float(values[ns['hashkey']('SpellData',field)])!=float(q['values'][field]):bad.append(field)
proof={'passed':not bad,'community_threshold_ratio_checks':6,'native_q_speed_duration_fields':10,'mismatches':bad,'native_q_source':str(native),'native_q_sha256':hashlib.sha256(native.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'historical_soft_cap_qualification':False,'limits':['Community numeric provenance and native Q values checked; no original Riot runtime evidence for soft-cap ordering or stacking.']}
(r/'docs/movement_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));raise SystemExit(bool(bad))
