from pathlib import Path
import urllib.request,json,hashlib,concurrent.futures
r=Path('E:/mapslol3v3');tree=json.loads((r/'community_endgame_packet_tree.json').read_text());sha=tree['sha'];out=r/'community_endgame_packets';out.mkdir(exist_ok=True)
paths=[x['path'] for x in tree['tree'] if x['type']=='blob' and (x['path']=='LICENSE' or x['path'].endswith('.cs') and any(n in x['path'].lower() for n in ['fade','minion','endgame','visibility']))]
def fetch(path):
 url=f'https://raw.githubusercontent.com/LeagueSandbox/LeaguePackets/{sha}/{path}'
 with urllib.request.urlopen(urllib.request.Request(url,headers={'User-Agent':'OpenLeague-source-audit'}),timeout=35) as f:raw=f.read(500000)
 assert len(raw)<500000;file=out/path;file.parent.mkdir(parents=True,exist_ok=True);file.write_bytes(raw)
 return dict(path=path,url=url,sha256=hashlib.sha256(raw).hexdigest(),body=raw.decode('utf-8-sig') if 'Fade' in path or 'NoRender' in path else None)
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:rows=list(pool.map(fetch,paths))
(r/'community_endgame_packets_audit.json').write_text(json.dumps(dict(repository='LeagueSandbox/LeaguePackets',commit=sha,rows=rows,complete=False,limits=['Reference packet formats only; original client handlers not yet executed. No community code integrated.']),indent=2),encoding='utf-8')
print(json.dumps(rows,indent=2))
