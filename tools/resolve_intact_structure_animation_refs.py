from pathlib import Path
import json,re,hashlib,datetime
r=Path('E:/OpenLeague');inventory=json.loads((r/'docs/intact_structure_animation_inventory.json').read_text(encoding='utf-8'));deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');missing=[]
for model in inventory['records']:
 refs=[]
 for f in model['files']:
  if f['kind']!='.blnd':continue
  b=Path(f['path']).read_bytes()
  for match in re.finditer(rb'(?i)characters/[^\x00]+\.(?:anm|skl)\x00',b):
   ref=match.group()[:-1].decode('ascii');path=deploy/'DATA'/ref
   if not path.is_file():missing.append(dict(alias=model['alias'],reference=ref))
   refs.append(dict(reference=ref,path=str(path),exists=path.is_file(),sha256=hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None,blend_offset=match.start()))
 model['authored_graph_references']=refs
 print(json.dumps(dict(alias=model['alias'],references=[x['reference'] for x in refs],missing=sum(not x['exists'] for x in refs))),flush=True)
inventory.update(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),missing_references=missing,complete=False)
(r/'docs/intact_structure_animation_inventory.json').write_text(json.dumps(inventory,indent=2)+'\n',encoding='utf-8')
