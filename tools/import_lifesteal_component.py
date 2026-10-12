"""Import native Vampiric Scepter numeric/text contract without passive-bearing items."""
import ast,struct,json,re,html,hashlib
from pathlib import Path
r=Path(__file__).resolve().parents[1];ns={'struct':struct};t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in t.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),ns)
rows=json.loads((r/'data/4.20/native_item_audit.json').read_text(encoding='utf-8'))
for row in rows:row['native_values']['PercentLifeStealMod']=ns['ini'](Path(row['source'])).get(ns['hashkey']('Data','PercentLifeStealMod'))
(r/'data/4.20/native_item_audit.json').write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
v=next(x for x in rows if x['id']==1053)['native_values'];shop=json.loads((r/'data/4.20/shop_foundation.json').read_text(encoding='utf-8'));loc=json.loads((r/'docs/item_localization_source.json').read_text(encoding='utf-8'))
translations=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',Path(loc['source']).read_text(encoding='utf-8'),re.M));name=translations['game_item_displayname_1053'];desc=translations['game_item_description_1053'];plain=html.unescape(re.sub('<[^>]+>','',desc.replace('<br>','\n')))
row={'id':1053,'price':800.,'recipe':[1036],'damage':float(v['FlatPhysicalDamageMod']),'life_steal':float(v['PercentLifeStealMod']),'name':name,'native_description':desc,'description':plain,'group':'','sell_multiplier':.7}
for field in ['armor','magic_resist','health','mana','health_regen_percent','mana_regen_percent','attack_speed','move_speed','critical_chance','critical_damage']:row[field]=0
shop['items']=[x for x in shop['items'] if x['id']!=1053]+[row];loc['items']=[x for x in loc['items'] if x['id']!=1053]+[{'id':1053,'name':name,'native_description':desc,'display_description':plain}]
(r/'data/4.20/shop_foundation.json').write_text(json.dumps(shop,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(r/'docs/item_localization_source.json').write_text(json.dumps(loc,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
source=Path('D:/LeagueOfLegendsV2/4.20/GameServer/GameServerLib/GameObjects/AttackableUnits/AttackableUnit.cs')
proof={'native_item':1053,'complete':False,'community_damage_source':str(source),'community_damage_source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'interpretation':'Attack-only life steal from post-mitigation damage before shield/health caps, as supplied community damage source; healing clamps to max health and never revives dead shooter.','limits':['Historical shield and overkill healing semantics, structure eligibility and champion/on-hit interactions require qualification.','Community source is not original Riot server code.','Garen empowered Q life steal remains incomplete; no blanket spell vamp or modern on-hit life steal.'],'later_patch_boundary_reference':'https://www.leagueoflegends.com/en-au/news/game-updates/patch-10-23-notes/','later_patch_boundary_note':'Official 2020 patch adds physical on-hit damage to life steal. This is a version boundary, not a full 4.20 runtime specification.'}
(r/'docs/lifesteal_progress.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'item':1053,'total':800,'life_steal':row['life_steal']}))
