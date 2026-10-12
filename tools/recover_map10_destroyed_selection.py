from pathlib import Path
import json,configparser,hashlib,datetime
r=Path('E:/OpenLeague');deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');config=deploy/'LEVELS/Map10/Scene/CFG/ObjectCFG.cfg';cfg=configparser.ConfigParser(strict=False,interpolation=None);cfg.read_string(config.read_text(encoding='utf-8-sig'));world=json.loads((r/'data/4.20/map10_world.json').read_text());rows=[];profiles={}
for structure in world['structures']:
 name=structure['name'];definition=structure['definition'];kind=world['definitions'][definition]['kind'];assert cfg.has_section(name),name
 if kind in ['Turret','Fountain']:selected=cfg.get(name,'DestroyedTowerSkin',fallback='DestroyedTower');skin=cfg.getint(name,'DestroyedTowerSkinID',fallback=0);key='DestroyedTowerSkin'
 else:assert kind in ['Nexus','Inhibitor'];selected=cfg.get(name,'SkinName2');skin=0;key='SkinName2'
 row=dict(section=name,definition=definition,kind=kind,model=selected,skin=skin,key=key);rows.append(row)
 if definition in profiles:assert profiles[definition]['model']==selected and profiles[definition]['skin']==skin
 else:profiles[definition]=row
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,resource=str(config),resource_sha256=hashlib.sha256(config.read_bytes()).hexdigest(),provider_contract='native_objectcfg_provider_contract.json',structures=rows,profiles=profiles,limits=['Original ObjectCFG configuration selection and native tower consumer keys; actual class descriptor construction and transition trigger remain unqualified.','SkinName2 is authored for nexus/inhibitors; native general multi-skin enumeration consumer has not yet been executed in this receipt.'])
(r/'docs/map10_destroyed_model_selection.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
# Re-execute the original tower consumer with real scene sections and CFG fields.
s=(r/'tools/probe_native_destroyed_selection.py').read_text();old="properties=parser['ini'](config)";new="properties={}\nfor section in "+repr([row['section'] for row in rows if row['kind'] in ['Turret','Fountain']])+":\n for key in ['DestroyedTowerSkin','DestroyedTowerSkinID']:\n  if cfg.has_option(section,key):properties[parser['hashkey'](section,key)]=cfg.get(section,key)"
assert old in s;s=s.replace(old,new).replace("config=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/LEVELS/Map10/Graphics.inibin')",'config=Path('+repr(str(config))+')')
s=s.replace("b'Levels/Map10/Graphics.ini\\0'","b'Levels/Map10/Scene/CFG/ObjectCFG.cfg\\0'")
s=s.replace("names=list(json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text()))",'names='+repr([row['section'] for row in rows if row['kind'] in ['Turret','Fountain']]))
s=s.replace('native_destroyed_selection_contract.json','native_map10_destroyed_selection_contract.json').replace('actual_map10_resource_binding_qualified=False','actual_map10_resource_binding_qualified=True')
s=s.replace("Supplied resource is original Map10 Graphics.inibin. Binding of native global+38 to that resource and actual descriptor section names remains unqualified; these fixtures do not prove final Map10 model selection.","Original ObjectCFG.cfg resource matched to native global+38 producer. Actual scene sections supplied from authored map structure records; full descriptor construction and destruction-triggered factory remain unqualified.")
exec(compile(s,'map10-native-destroyed-selection','exec'))
print(json.dumps(dict(scene_structures=len(rows),model_profiles=len(profiles),models=sorted({row['model'] for row in rows}))))
