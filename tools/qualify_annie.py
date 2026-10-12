from pathlib import Path
import json,ast,struct,hashlib,datetime,urllib.request,re
r=Path('E:/OpenLeague');root=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[x for x in t.body if isinstance(x,ast.FunctionDef) and x.name in ['ini','hashkey']],type_ignores=[]),'p','exec'),ns)
url='https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/champion/Annie.json'
cache=r/'data/4.20/native_ddragon_annie_420.json'
if not cache.exists():cache.write_bytes(urllib.request.urlopen(url,timeout=30).read())
official=json.loads(cache.read_text(encoding='utf-8'))['data']['Annie'];rows=[]
keys=['CastRange','Coefficient','Cooldown','ManaCost','MissileSpeed','DelayCastOffsetPercent','DelayTotalTimePercent','CantCancelWhileWindingUp','CanCastWhileDisabled','Flags','TargettingType','MaxLevel']+[f'{s}{rank}' for s in ['Cooldown','ManaCost'] for rank in range(1,6)]+[f'Effect{k}Level{rank}Amount' for k in range(1,6) for rank in range(1,6)]
for spell in ['Disintegrate','Incinerate','MoltenShield','InfernalGuardian','Pyromania']:
 p=root/'DATA/Characters/Annie/Spells'/(spell+'.inibin');d=ns['ini'](p);values={k:d.get(ns['hashkey']('SpellData',k)) for k in keys};lua=p.with_suffix('.luaobj');b=lua.read_bytes();strings=[s.decode('ascii') for s in re.findall(rb'[\x20-\x7e]{6,}',b)]
 rows.append({'spell':spell,'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'values':values,'luaobj_bytes':len(b),'luaobj_sha256':hashlib.sha256(b).hexdigest(),'luaobj_strings':strings})
receipt={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_spells':rows,'official_url':url,'official_cache_sha256':hashlib.sha256(cache.read_bytes()).hexdigest(),'official_spells':official['spells'],'official_passive':official['passive'],'limits':['Native INIBIN values and version-specific Riot Data Dragon descriptions are sources, not gameplay acceptance. Lua object strings do not prove recovered server implementation. Cast/missile/passive sequencing, refund timing and NPC control require implementation and qualification.']}
(r/'docs/annie_native_sources.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'rows':[{k:v for k,v in x.items() if k not in ['source','sha256','luaobj_sha256','luaobj_strings']} for x in rows],'descriptions':[(s['id'],s['description'],s['cost'],s['effect']) for s in official['spells']],'passive':official['passive']},indent=2))
