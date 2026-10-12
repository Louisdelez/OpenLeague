from pathlib import Path
import json,struct,hashlib,sys
r=Path('E:/OpenLeague');version=sys.argv[1] if len(sys.argv)>1 else 'v70'
d=json.loads((r/f'logs/annie-pause-{version}-pixels.json').read_text());w=d['width_each'];h=d['height'];results=[]
for path,row in {x['cleanup_rgba']:x for x in d['rows'] if x.get('cleanup_rgba')}.items():
 p=Path(path);raw=p.read_bytes();assert len(raw)==w*2*(h+1)*4
 header=struct.unpack_from('<8I',raw,w*2*h*4)
 assert header[0]==0x4f4c5052 and header[2]==0 and header[7]==0
 assert header[1]==row['gpu_frame'] and header[6]==row['effect_time_bits']
 owner=int(p.name.split('.entity-')[1].split('-clean')[0])
 last=max(x['gpu_frame'] for x in d['rows'] if x['draws']>0 and x['entity']==owner)
 assert header[1]>last
 for y in range(h):
  a=raw[y*w*8:y*w*8+w*4];b=raw[y*w*8+w*4:(y+1)*w*8]
  assert all(a[i:i+3]==b[i:i+3] for i in range(0,len(a),4))
 results.append({'path':str(p),'gpu_frame':header[1],'sha256':hashlib.sha256(raw).hexdigest(),'same_frame_rgb_equal':True})
assert results,'no raw cleanup evidence'
(r/f'docs/annie_pause_{version}_raw_cleanup.json').write_text(json.dumps({'passed':True,'frames':results,'limits':['Only projection layer cleanup; not whole-game or original-frame equivalence.']},indent=2))
print('PASS raw GPU cleanup:',len(results))
