from pathlib import Path
import urllib.request,json,hashlib,concurrent.futures
r=Path('E:/mapslol3v3');tree=json.loads((r/'community_endgame_tree.json').read_text());sha=tree['sha']
paths=[x['path'] for x in tree['tree'] if x['type']=='blob' and (x['path'] in ['GameServerLib/API/APIMapFunctionManager.cs','GameServerLib/API/ApiFunctionManager.cs','GameServerLib/Packets/PacketNotifier.cs','GameServerLib/GameObjects/AttackableUnits/Buildings/AnimatedBuildings/Nexus.cs','LICENSE'] or x['path'].endswith('/Game.cs') or x['path'].endswith('/GameMap.cs'))]
out=r/'community_endgame_sources';out.mkdir(exist_ok=True)
def fetch(path):
 url=f'https://raw.githubusercontent.com/LeagueSandbox/GameServer/{sha}/{path}';req=urllib.request.Request(url,headers={'User-Agent':'OpenLeague-source-audit'})
 with urllib.request.urlopen(req,timeout=35) as f:raw=f.read(2000000)
 assert len(raw)<2000000
 file=out/path;file.parent.mkdir(parents=True,exist_ok=True);file.write_bytes(raw)
 lines=raw.decode('utf-8-sig').splitlines();hits=[]
 for i,line in enumerate(lines):
  if any(token in line.lower() for token in ['fademinion','mainsfx','endgame','endofgame','norender','fadeout','stoprender']):hits.append({'line':i+1,'context':'\n'.join(lines[max(0,i-4):i+12])})
 return dict(path=path,url=url,sha256=hashlib.sha256(raw).hexdigest(),hits=hits)
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:rows=list(pool.map(fetch,paths))
d=dict(repository='LeagueSandbox/GameServer',commit=sha,rows=rows,complete=False,limits=['Community implementation is a reference, not proof of original native 4.20 behavior. No community code integrated.'])
(r/'community_endgame_source_audit.json').write_text(json.dumps(d,indent=2),encoding='utf-8');print(json.dumps(rows,indent=2))
