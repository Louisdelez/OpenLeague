from pathlib import Path
import urllib.request,json
sha='207baab80dc4cd203dd2d41ce9d98f1aae7a1544';url=f'https://api.github.com/repos/LeagueSandbox/LeaguePackets/git/trees/{sha}?recursive=1'
with urllib.request.urlopen(urllib.request.Request(url,headers={'User-Agent':'OpenLeague-source-audit'}),timeout=35) as f:d=json.load(f)
assert not d.get('truncated');Path('E:/mapslol3v3/community_endgame_packet_tree.json').write_text(json.dumps(d,indent=2),encoding='utf-8')
print(json.dumps([x['path'] for x in d['tree'] if x['type']=='blob' and any(n in x['path'].lower() for n in ['fade','render','sfx','endgame','opcode','command'])],indent=2))
