from pathlib import Path
import json,sys,struct,hashlib
r=Path('E:/OpenLeague');v=sys.argv[1];assert v.isalnum()
receipt=json.loads((r/f'docs/projected_batch_{v}.json').read_text());m=receipt['measurement']
audit=json.loads((r/f'docs/projected_startup_{v}_analysis.json').read_text())
assert len(audit['projectiles'])==2 and not audit['lifecycle_missing_context']
for projectile in audit['projectiles']:
 kinds=[x['kind'] for x in projectile['lifecycle']]
 assert kinds.count('Appeared')==1 and kinds.count('Disappeared')==1
assert m['created_effects']==2 and m['cleaned']==2 and m['active_effects']==m['active_draws']==0
assert len(m['parent_traces'])==2
for trace in m['parent_traces']:
 times=[f['time'] for f in trace['frames']];assert times==sorted(times),('reversed clock',trace['identity'])
 assert trace['frames'][-1]['active']==0
p=r/f'logs/projected-core-cycle-{v}-receivers-dx12-pixels.json';pixels=json.loads(p.read_text());rows=pixels['rows'];active=[x for x in rows if x['draws']>0]
assert active and any(x['changed_pixels']>0 for x in active)
cleanup=[];w=pixels['width_each'];h=pixels['height']
for path,row in {x['cleanup_rgba']:x for x in rows if x.get('cleanup_rgba')}.items():
 raw=Path(path).read_bytes();assert len(raw)==w*2*(h+1)*4
 header=struct.unpack_from('<6I',raw,w*2*h*4)
 assert header[0]==0x4f4c5052 and header[2]==0 and header[1]==row['gpu_frame']
 if header[1]<=max(x['gpu_frame'] for x in active):continue
 for y in range(h):
  a=raw[y*w*8:y*w*8+w*4];b=raw[y*w*8+w*4:(y+1)*w*8]
  assert all(a[i:i+3]==b[i:i+3] for i in range(0,len(a),4))
 cleanup.append({'path':path,'sha256':hashlib.sha256(raw).hexdigest(),'frame':header[1]})
assert cleanup,'no final global cleanup atlas'
out=dict(passed=True,complete=False,client_sha256=receipt['client_sha256'],lifecycle_identities=[x['identity'] for x in audit['projectiles']],monotonic_effect_clocks=True,final_global_gpu_cleanup=cleanup,limits=['Pixels attribute the combined projection layer, not each overlapping effect individually.','Per-effect retirement is CPU/native-port state evidence; final global zero-residue proof is GPU evidence.','Diagnostic seeded fixture, not ordinary gameplay or original LoL equivalence.'])
(r/f'docs/missile_mixed_{v}_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
