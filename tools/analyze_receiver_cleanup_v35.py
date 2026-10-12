from pathlib import Path
import json,struct,hashlib,sys,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');results=[]
for backend in ['dx12','vulkan']:
 path=r/f'logs/projected-core-cycle-v35-receivers-{backend}-pixels.json'
 d=json.loads(path.read_text());w=d['width_each'];h=d['height']
 rows=list({row['cleanup_rgba']:row for row in d['rows'] if row.get('cleanup_rgba')}.values())
 assert len(rows)==2
 for row in rows:
  p=Path(row['cleanup_rgba']);raw=p.read_bytes();assert len(raw)==w*2*(h+1)*4
  header=struct.unpack_from('<6I',raw,w*2*h*4)
  assert header[0]==0x4f4c5052 and header[1]==row['gpu_frame'] and header[2]==0
  assert row['changed_pixels']==0
  owner=int(p.name.split('.entity-')[1].split('-clean')[0]); assert row['gpu_frame']>max(x['gpu_frame'] for x in d['rows'] if x['draws']>0 and x['entity']==owner)
  atlas=Image.frombytes('RGBA',(w*2,h+1),raw);a=atlas.crop((0,0,w,h));b=atlas.crop((w,0,w*2,h))
  assert a.convert('RGB').tobytes()==b.convert('RGB').tobytes()
  out=p.with_suffix('.png');a.save(out)
  results.append(dict(backend=backend,gpu_frame=header[1],raw=str(p),raw_sha256=hashlib.sha256(raw).hexdigest(),image=str(out),same_frame_rgb_equal=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,passed=True,frames=results,limits=['Actual GPU atlas and embedded frame header verified; main-window screenshot timing is not inferred.','These scenes prove reconstructed projection removal, not original LoL visual equivalence or full kit acceptance.'])
(r/'docs/receiver_cleanup_v35.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(results))
