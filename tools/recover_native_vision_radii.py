from pathlib import Path
import sys,json,hashlib,configparser,struct,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/references/lolpytools'))
import lolpytools_inibin2 as ini
native=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);deploy=native.parent;chars=deploy/'DATA/Characters';folders={p.name.lower():p for p in chars.iterdir() if p.is_dir()}
cfg=deploy/'DATA/cfg/defaults/GamePermanent.cfg';parser=configparser.ConfigParser();parser.read(cfg);default=float(parser['Vision']['PerceptionBubbleRadius']);assert default==1350.
champions=json.loads((r/'data/4.20/champions.json').read_text());world=json.loads((r/'data/4.20/map10_world.json').read_text());rows={}
for name in [c['id'] for c in champions]+list(world['definitions'])+['AnnieTibbers']:
 folder=folders[name.lower()];p=folder/(folder.name+'.inibin');raw=p.read_bytes();value=ini.from_file(p)['UNKNOWN_HASHES'].get(ini.ihash('Data','PerceptionBubbleRadius'))
 radius=float(value) if value is not None and float(value)>0 else default
 rows[name.lower()]=dict(resource=str(p),sha256=hashlib.sha256(raw).hexdigest(),explicit_radius=value,resolved_radius=radius,uses_global_default=value is None or float(value)<=0)
data=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,default_radius=default,default_source=str(cfg),default_sha256=hashlib.sha256(cfg.read_bytes()).hexdigest(),inibin_key=hex(ini.ihash('Data','PerceptionBubbleRadius')),profiles=rows,limits=['Actual source activation/team/lifecycle remain unqualified; resolving a resource radius does not prove that every object emits sight.','Native resource query fallback branch is traced at86A9B0; file/cache loader itself is not executed. Actor character-data override/cache population and native full source update remain open.'])
(r/'data/4.20/native_vision_radii.json').write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(profiles=len(rows),champions=len(champions),explicit=sum(not d['uses_global_default'] for d in rows.values()),default=default)))
