"""Verify imported item numeric fields directly against original 4.20 inibins."""
import ast,struct,json,hashlib,re
from pathlib import Path
root=Path(__file__).resolve().parents[1]
parser=Path(r'E:\mapslol3v3\tools\import_all_champions.py');tree=ast.parse(parser.read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'native-parser','exec'),ns)
rows=json.loads((root/'data/4.20/native_item_audit.json').read_text(encoding='utf-8'));bad=[];by={x['id']:x for x in rows}
for row in rows:
 path=Path(row['source']);raw=ns['ini'](path)
 if hashlib.sha256(path.read_bytes()).hexdigest()!=row['sha256']:bad.append([row['id'],'source hash'])
 for field,value in row['native_values'].items():
  if raw.get(ns['hashkey']('Data',field))!=value:bad.append([row['id'],field])
config=json.loads((root/'data/4.20/shop_foundation.json').read_text(encoding='utf-8'))
official=json.loads((root/'data/4.20/native_ddragon_items_420.json').read_text(encoding='utf-8'))
def total(id):
 v=by[id]['native_values'];return float(v['Price'])+sum(total(int(v[f'RecipeItem{i}'])) for i in range(1,5) if float(v.get(f'RecipeItem{i}',0))>0)
for item in config['items']:
 v=by[item['id']]['native_values']
 for output,native in [('damage','FlatPhysicalDamageMod'),('ability_power','FlatMagicDamageMod'),('armor','FlatArmorMod'),('magic_resist','FlatSpellBlockMod'),('health','FlatHPPoolMod'),('mana','FlatMPPoolMod'),('health_regen_percent','PercentBaseHPRegenMod'),('mana_regen_percent','PercentBaseMPRegenMod'),('attack_speed','PercentAttackSpeedMod'),('move_speed','FlatMovementSpeedMod'),('critical_chance','FlatCritChanceMod'),('critical_damage','FlatCritDamageMod'),('life_steal','PercentLifeStealMod')]:
  if item.get(output,0)!=float(ns['ini'](Path(by[item['id']]['source'])).get(ns['hashkey']('Data',native),0) or 0):bad.append([item['id'],output])
 if item['price']!=total(item['id']):bad.append([item['id'],'recipe total'])
 if item.get('sell_price')!=official['data'][str(item['id'])]['gold']['sell']:bad.append([item['id'],'official sell value'])
 if float(v['InStore'])!=1:bad.append([item['id'],'not in native store'])
localization=json.loads((root/'docs/item_localization_source.json').read_text(encoding='utf-8'));source=Path(localization['source'])
if hashlib.sha256(source.read_bytes()).hexdigest()!=localization['sha256']:bad.append(['localization','source hash'])
translations=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',source.read_text(encoding='utf-8'),re.M))
for item in config['items']:
 if item['name']!=translations.get(f'game_item_displayname_{item["id"]}'):bad.append([item['id'],'native localized name'])
 if item['native_description']!=translations.get(f'game_item_description_{item["id"]}'):bad.append([item['id'],'native description'])
proof={'passed':not bad,'native_items_checked':len(rows),'active_components_checked':len(config['items']),'mismatches':bad,'limits':['Source hash and numeric agreement only; native catalog release availability, gameplay, UI and unknown reconstructed rules not qualified.']}
(root/'docs/native_item_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));raise SystemExit(bool(bad))
