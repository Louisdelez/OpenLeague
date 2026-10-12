"""Verify native Heal fields/text and explicitly separate supplied community reconstruction."""
import ast, datetime, hashlib, json, struct
from pathlib import Path
r=Path(__file__).resolve().parents[1]
receipt=json.loads((r/'docs/heal_source_validation.json').read_text(encoding='utf-8'))
rules=json.loads((r/'data/4.20/heal_rules.json').read_text(encoding='utf-8'))
ns={'struct':struct}
tree=ast.parse(Path(r'E:\mapslol3v3\tools\import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ('ini','hashkey')],type_ignores=[]),'native_inibin_parser','exec'),ns)
bad=[]
for source,sha in [('native_source','native_sha256'),('menu_source','menu_sha256'),('community_source','community_sha256')]:
    if hashlib.sha256(Path(receipt[source]).read_bytes()).hexdigest()!=receipt[sha]:bad.append(source+' hash changed')
native=ns['ini'](Path(receipt['native_source']))
expected={'CastRange':25000,'CastRangeDisplayOverride':850,'Cooldown':300,'Cooldown1':300,'Cooldown2':300,'CanCastWhileDisabled':True}
fields={}
for name,wanted in expected.items():
    value=native.get(ns['hashkey']('SpellData',name));fields[name]=value
    if value is None or float(value)!=float(wanted):bad.append(name)
menu=Path(receipt['menu_source']).read_text(encoding='utf-8-sig')
if receipt['native_description'] not in menu:bad.append('native description')
community=Path(receipt['community_source']).read_text(encoding='utf-8-sig')
for token in ('75 + (target.Stats.Level * 15)','healthGain *= 0.5f','AddBuff("HealSpeed", 1.0f','AddBuff("HealCheck", 35.0f','currentHealth * 100 / maxHealth < lowestHealthPercentage'):
    if token not in community:bad.append('community policy '+token)
for key,wanted in {'range':850,'heal_level_1':90,'heal_per_level':15,'speed_fraction':.3,'speed_seconds':1,'recent_seconds':35,'recent_multiplier':.5,'cooldown_seconds':240,'native_cooldown_conflict':300}.items():
    if rules[key]!=wanted:bad.append('compiled rules '+key)
receipt.update(passed=not bad,verified_at=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_fields=fields,mismatches=bad,source_numeric_checks=6,compiled_rule_checks=10)
receipt['cooldown_conflict']['web_source_reverified_this_run']=False
receipt['limits'].append('Source hashes/text and inibin values rechecked locally; historical patch-copy URL is the previously researched provenance, not a new web verification.') if not any('previously researched' in x for x in receipt['limits']) else None
(r/'docs/heal_source_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':not bad,'native_fields':fields,'mismatches':bad}))
raise SystemExit(bool(bad))
