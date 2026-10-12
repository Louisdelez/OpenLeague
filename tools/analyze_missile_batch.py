from pathlib import Path
import json,sys,struct,hashlib
r=Path('E:/OpenLeague');v=sys.argv[1];assert v.isalnum()
receipt=json.loads((r/f'docs/projected_batch_{v}.json').read_text())
pixels=json.loads((r/f'logs/projected-core-cycle-{v}-receivers-dx12-pixels.json').read_text())
m=receipt['measurement'];rows=pixels['rows'];active=[x for x in rows if x['draws']>0]
assert m['created_effects']==1 and m['active_effects']==0 and m['active_draws']==0
traces=m['parent_traces'];assert len(traces)==1
for trace in traces:
 times=[x['time'] for x in trace['frames']];assert times==sorted(times),'time reversed'
assert active and any(x['changed_pixels']>0 for x in active),'no attributable visible pixels'
w=pixels['width_each'];h=pixels['height'];cleanup=[]
for path,row in {x['cleanup_rgba']:x for x in rows if x.get('cleanup_rgba')}.items():
 raw=Path(path).read_bytes();assert len(raw)==w*2*(h+1)*4
 header=struct.unpack_from('<6I',raw,w*2*h*4)
 assert header[0]==0x4f4c5052 and header[2]==0 and header[1]==row['gpu_frame']
 assert header[1]>max(x['gpu_frame'] for x in active)
 for y in range(h):
  a=raw[y*w*8:y*w*8+w*4];b=raw[y*w*8+w*4:(y+1)*w*8]
  assert all(a[i:i+3]==b[i:i+3] for i in range(0,len(a),4))
 cleanup.append({'path':path,'sha256':hashlib.sha256(raw).hexdigest(),'frame':header[1]})
assert len(cleanup)==1
out=dict(passed=True,complete=False,version=v,client_sha256=receipt['client_sha256'],monotonic_observed_effect_times=True,peak_changed_pixels=max(x['changed_pixels'] for x in active),cleanup=cleanup,limits=['Reconstructed effect versus its own suppressed draw, not original LoL equivalence.','Single delayed lifecycle; mixed owners and reconnect are separate scenarios.'])
(r/f'docs/missile_batch_{v}_gpu.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
