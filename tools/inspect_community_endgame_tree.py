from pathlib import Path
import urllib.request,json
url='https://api.github.com/repos/LeagueSandbox/GameServer/git/trees/indev?recursive=1'
req=urllib.request.Request(url,headers={'User-Agent':'OpenLeague-source-audit','Accept':'application/vnd.github+json'})
with urllib.request.urlopen(req,timeout=35) as response:d=json.load(response)
assert not d.get('truncated')
Path('E:/mapslol3v3/community_endgame_tree.json').write_text(json.dumps(d,indent=2),encoding='utf-8')
selected=[x['path'] for x in d['tree'] if x['type']=='blob' and x['path'].endswith('.cs') and any(name in x['path'].lower() for name in ['endgame','nexus','packetnotifier','minion','maphandler','mapapi','api/','api.cs','gamemap'])]
print(json.dumps({'sha':d['sha'],'selected':selected},indent=2))
