"""Native 4.20 critical numeric profiles and two passive-free shop components."""
import ast,struct,json,hashlib,re,html
from pathlib import Path
root=Path(__file__).resolve().parents[1];tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
base=json.loads((root/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));out={};missing=[]
deploy=Path(next(iter(base.values()))['character_source']).parents[2]
index={}
for path in deploy.rglob('*.inibin'):index.setdefault(path.stem.lower(),[]).append(path)
fields=['BaseCritChance','CritPerLevel','CritDamageBonus','CritAttack','CritAttack_AttackCastTime','CritAttack_AttackTotalTime','CritAttack_AttackDelayCastOffsetPercent','CritAttack_AttackDelayCastOffsetPercentAttackSpeedRatio','CritAttack_AttackDelayOffsetPercent']
def num(v,default):return float(v) if v is not None else default
for name,row in base.items():
 char=Path(row['character_source']);data=ns['ini'](char);v={f:data.get(ns['hashkey']('Data',f)) for f in fields};key=str(v['CritAttack'] or name+'CritAttack').lower()
 candidates=index.get(key,[]);spell=next((p for p in candidates if char.parent in p.parents),candidates[0] if len(candidates)==1 else None)
 sv={} if spell is None else ns['ini'](spell)
 spell_values={f:sv.get(ns['hashkey']('SpellData',f)) for f in ['MissileSpeed','CantCancelWhileWindingUp','AnimationName']}
 period=num(v['CritAttack_AttackTotalTime'],1.6*(1+num(v['CritAttack_AttackDelayOffsetPercent'],0)))
 cast=num(v['CritAttack_AttackCastTime'],period*(.3+num(v['CritAttack_AttackDelayCastOffsetPercent'],0)))
 out[name]={'melee':row['melee'],'chance':num(v['BaseCritChance'],0),'chance_growth':num(v['CritPerLevel'],0),'multiplier':num(v['CritDamageBonus'],2),'base_period_seconds':period,'base_windup_seconds':cast,'windup_speed_ratio':num(v['CritAttack_AttackDelayCastOffsetPercentAttackSpeedRatio'],1),'missile_speed':num(spell_values['MissileSpeed'],row['missile_speed']) if spell_values['MissileSpeed'] is not None or row['missile_speed'] is not None else None,'cant_cancel':str(spell_values['CantCancelWhileWindingUp']).lower() in ('yes','true','1'),'native_character_values':v,'native_spell_values':spell_values,'character_source':str(char),'character_sha256':hashlib.sha256(char.read_bytes()).hexdigest(),'spell_source':str(spell) if spell else None,'spell_sha256':hashlib.sha256(spell.read_bytes()).hexdigest() if spell else None}
 if spell is None:missing.append(name)
(root/'data/4.20/critical_contracts.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
items=json.loads((root/'data/4.20/native_item_audit.json').read_text(encoding='utf-8'))
for row in items:
 raw=ns['ini'](Path(row['source']))
 for field in ['FlatCritChanceMod','FlatCritDamageMod']:row['native_values'][field]=raw.get(ns['hashkey']('Data',field))
(root/'data/4.20/native_item_audit.json').write_text(json.dumps(items,indent=2)+'\n',encoding='utf-8')
loc=json.loads((root/'docs/item_localization_source.json').read_text(encoding='utf-8'));translations=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',Path(loc['source']).read_text(encoding='utf-8'),re.M));shop=json.loads((root/'data/4.20/shop_foundation.json').read_text(encoding='utf-8'))
for id in [1051,1018]:
 v=next(x for x in items if x['id']==id)['native_values'];name=translations[f'game_item_displayname_{id}'];desc=translations[f'game_item_description_{id}'];plain=html.unescape(re.sub('<[^>]+>','',desc.replace('<br>','\n')))
 row={'id':id,'price':float(v['Price']),'recipe':[],'name':name,'native_description':desc,'description':plain,'sell_multiplier':.7,'group':'','critical_chance':float(v['FlatCritChanceMod']),'critical_damage':float(v['FlatCritDamageMod'] or 0)}
 for key in ['damage','armor','magic_resist','health','mana','health_regen_percent','mana_regen_percent','attack_speed','move_speed']:row[key]=0
 shop['items']=[i for i in shop['items'] if i['id']!=id]+[row]
 loc['items']=[i for i in loc['items'] if i['id']!=id]+[{'id':id,'name':name,'native_description':desc,'display_description':plain}]
(root/'data/4.20/shop_foundation.json').write_text(json.dumps(shop,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(root/'docs/item_localization_source.json').write_text(json.dumps(loc,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
report={'champions':len(out),'missing_critical_spell':missing,'complete':False,'limits':['Missing critical timing offsets 0, speed ratio 1 and chance growth 0 are reconstructed defaults.','Missing critical spell data inherits primary attack parameters; this fallback is not historical qualification.','Native crit numeric fields do not establish Riot pseudo-random streak correction or champion passive interactions.','Infinity Edge and other passive-bearing items remain unsupported; no fabricated passive effects.']}
(root/'docs/critical_progress.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8');print(json.dumps(report))
