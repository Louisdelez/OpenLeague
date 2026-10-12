from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague');rows=[]
for backend in ['dx12','vulkan']:
 p=r/f'docs/projected_core_cycle_capture_v42_receivers_{backend}.json';d=json.loads(p.read_text());m=d['measurements'][-1]
 # Capture scripts store each measurement directly or under a shot envelope.
 if 'measurement' in m:m=m['measurement']
 hits=m['geometry_cache_hits'];rebuilds=m['geometry_rebuild_attempts'];reused=m['geometry_vertices_reused'];built=m['geometry_vertices_rebuilt']
 assert hits>=0 and rebuilds>0 and built>0
 assert hits+rebuilds>=m['visible_frames']
 rows.append(dict(backend=backend,hits=hits,rebuilds=rebuilds,reused_vertices=reused,rebuilt_vertices=built,reused_fraction=reused/(reused+built),source_sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
receipt=dict(complete=False,measured=True,rows=rows,limits=['Counts geometry construction work, not frame time or GPU triangle reduction.','Two short fixture casts per backend; not performance acceptance for six-client match.'])
(r/'docs/projected_cache_metrics_v42.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(rows))
