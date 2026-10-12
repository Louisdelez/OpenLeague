"""Verify native Q purge text and Garen W bonus defense/DR coefficients."""
import ast,struct,json,hashlib,re,datetime
from pathlib import Path
r=Path(__file__).resolve().parents[1];report=json.loads((r/'docs/slow_garen_progress.json').read_text(encoding='utf-8'));menu=Path(report['native_menu_source']);tr=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',menu.read_text(encoding='utf-8'),re.M));bad=[]
if hashlib.sha256(menu.read_bytes()).hexdigest()!=report['native_menu_sha256']:bad.append('native menu hash')
for key,value in report['native_text'].items():
 if tr.get(key)!=value:bad.append(key)
base=json.loads((r/'data/4.20/attack_contracts.json').read_text(encoding='utf-8'));deploy=Path(base['garen']['character_source']).parents[3];rows=json.loads((r/'data/4.20/native_spells_420.json').read_text(encoding='utf-8'));w=next(x for x in rows if x['champion'].lower()=='garen' and x['slot']==1);native=deploy/w['native_resource'];t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in t.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns);v=ns['ini'](native)
for rank in range(1,6):
 for effect in ['Effect1','Effect2','Effect4']:
  field=f'{effect}Level{rank}Amount'
  if float(v[ns['hashkey']('SpellData',field)])!=float(w['values'][field]):bad.append(field)
english=deploy/'DATA/Menu/fontconfig_en_US.txt';translations=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',english.read_text(encoding='utf-8'),re.M));text=translations['game_spell_tooltip_GarenW']
if '30% crowd control duration reduction' not in text:bad.append('native tenacity text')
proof={'passed':not bad,'native_menu_keys_checked':len(report['native_text']),'native_w_numeric_fields_checked':15,'mismatches':bad,'native_w_source':str(native),'native_w_sha256':hashlib.sha256(native.read_bytes()).hexdigest(),'native_english_source':str(english),'native_english_sha256':hashlib.sha256(english.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Native text and numeric correspondence only; generic slow ordering/stacking/refresh and full champion runtime fidelity unqualified.']}
(r/'docs/slow_garen_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));raise SystemExit(bool(bad))
