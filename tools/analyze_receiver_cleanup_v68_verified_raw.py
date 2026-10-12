from pathlib import Path
import json,struct,hashlib
r=Path('E:/OpenLeague');rows=[];versions={'dx12':'v68','vulkan':'v68'}
for b in ['dx12']:
 d=json.loads((r/f'logs/projected-core-cycle-{versions[b]}-receivers-{b}-pixels.json').read_text());w=d['width_each'];h=d['height']
 for path,row in {x['cleanup_rgba']:x for x in d['rows'] if x.get('cleanup_rgba')}.items():
  p=Path(path);raw=p.read_bytes();assert len(raw)==w*2*(h+1)*4
  header=struct.unpack_from('<6I',raw,w*2*h*4);assert header[0]==0x4f4c5052 and header[2]==0
  owner=int(p.name.split('.entity-')[1].split('-clean')[0]);last=max(x['gpu_frame'] for x in d['rows'] if x['draws']>0 and x['entity']==owner)
  assert header[1]>last and header[1]==row['gpu_frame']
  for y in range(h):
   a=raw[y*w*8:y*w*8+w*4];bb=raw[y*w*8+w*4:(y+1)*w*8]
   assert all(a[i:i+3]==bb[i:i+3] for i in range(0,len(a),4))
  rows.append(dict(backend=b,gpu_frame=header[1],journal_frame=row['gpu_frame'],journal_lag=header[1]-row['gpu_frame'],last_recorded_active_frame=last,sha256=hashlib.sha256(raw).hexdigest(),same_frame_rgb_equal=True))
assert len(rows)==2
(r/'docs/receiver_cleanup_v68_verified_raw.json').write_text(json.dumps(dict(passed=True,complete=False,frames=rows,limits=['Uses embedded GPU header as frame authority and compares both halves of that exact atlas.','Journal frame must equal the embedded GPU header; atomic publication was implemented before this verification.','No claim of original game framebuffer equivalence.']),indent=2)+'\n');print('PASS two complete raw GPU atlases; journal lag', [x['journal_lag'] for x in rows])
