"""Recheck native Exhaust values/text and metadata without executing native scripts."""
import ast,datetime,hashlib,json,struct
from pathlib import Path
from native_lua import Chunk,initialization
r=Path(__file__).resolve().parents[1]
p=r/'docs/exhaust_source_validation.json';proof=json.loads(p.read_text(encoding='utf-8'));rules=json.loads((r/'data/4.20/exhaust_rules.json').read_text(encoding='utf-8'));bad=[]
ns={'struct':struct};tree=ast.parse(Path(r'E:\mapslol3v3\tools\import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns)
for key in ('native','menu','community'):
    if hashlib.sha256(Path(proof[key+'_source']).read_bytes()).hexdigest()!=proof[key+'_sha256']:bad.append(key+' changed')
native=ns['ini'](Path(proof['native_source']));fields={}
for key,value in {'CastRange':650,'Cooldown':210,'Cooldown1':210,'CanCastWhileDisabled':True}.items():
    fields[key]=native.get(ns['hashkey']('SpellData',key))
    if fields[key] is None or float(fields[key])!=value:bad.append(key)
if proof['native_description'] not in Path(proof['menu_source']).read_text(encoding='utf-8-sig'):bad.append('description')
community=Path(proof['community_source']).read_text(encoding='utf-8-sig')
for token in ('MoveSpeed.PercentBonus = -0.3f','AttackSpeed.PercentBonus = -0.3f','Armor.BaseBonus = -10','MagicResist.BaseBonus = -10','BuffAddType.REPLACE_EXISTING'):
    if token not in community:bad.append(token)
for key,value in {'cooldown_seconds':210,'duration_seconds':2.5,'range':650,'slow_fraction':.3,'attack_speed_bonus_penalty':.3,'defense_reduction':10,'damage_reduction_fraction':.4}.items():
    if rules[key]!=value:bad.append('rules '+key)
chunks=[]
for name in ('SummonerExhaust','SummonerExhaustDebuff','SummonerExhaustSlow'):
    source=Path(proof['native_source']).with_name(name+'.luaobj');chunk=Chunk(source.read_bytes()).function();init=initialization(chunk)
    chunks.append({'source':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'child_functions':len(chunk['functions']),'initialization':init})
    if chunk['functions'] or init['stopped'] is not None:bad.append(name+' metadata assumption changed')
proof.update(passed=not bad,native_fields=fields,native_lua=chunks,compiled_rule_checks=7,mismatches=bad,verified_at=datetime.datetime.now(datetime.timezone.utc).isoformat())
proof['native_server_body_recovered']=False
proof['native_effect_metadata']={'primary_effect':'Global_ss_exhaust.troy','attachment':'Buffbone_Glb_Ground_Loc','slow_effect':'GLOBAL_SLOW.TROY','DoesntBreakShields':True,'DoesntTriggerSpellCasts':True,'CastingBreaksStealth':True,'integration':'Native metadata audited; particle runtime/spell-shield/cast-trigger/stealth systems remain incomplete.'}
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':not bad,'native_numeric_fields':4,'rules':7,'native_lua_chunks':3,'mismatches':bad}));raise SystemExit(bool(bad))
